import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notice.dart';
import '../bloc/notice_bloc.dart';
import '../bloc/notice_event.dart';
import '../bloc/notice_state.dart';
import '../widgets/notice_card.dart';
import '../widgets/notice_stat_card.dart';
import '../widgets/empty_notices_widget.dart';
import 'admin_notice_create_page.dart';
import 'admin_notice_edit_page.dart';

/// Página de gestión de avisos para administradores
class AdminNoticesManagementPage extends StatefulWidget {
  const AdminNoticesManagementPage({super.key});

  @override
  State<AdminNoticesManagementPage> createState() => _AdminNoticesManagementPageState();
}

class _AdminNoticesManagementPageState extends State<AdminNoticesManagementPage> {
  List<Notice> _notices = [];
  String _filter = 'todos';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  void _loadNotices() {
    context.read<NoticeBloc>().add(const GetAllNoticesEvent());
  }

  List<Notice> get _filteredNotices {
    var filtered = _notices;

    // Filtrar por estado
    switch (_filter) {
      case 'leidos':
        filtered = filtered.where((n) => n.leido).toList();
        break;
      case 'no_leidos':
        filtered = filtered.where((n) => !n.leido).toList();
        break;
      case 'importantes':
        filtered = filtered.where((n) => n.importante).toList();
        break;
    }

    // Filtrar por búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((n) =>
        n.titulo.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        n.mensaje.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Avisos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            onPressed: _createBroadcastNotice,
            tooltip: 'Crear aviso broadcast',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar',
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'todos',
                child: Text('Todos'),
              ),
              const PopupMenuItem(
                value: 'no_leidos',
                child: Text('No leídos'),
              ),
              const PopupMenuItem(
                value: 'leidos',
                child: Text('Leídos'),
              ),
              const PopupMenuItem(
                value: 'importantes',
                child: Text('Importantes'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotices,
            tooltip: 'Actualizar',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Buscar avisos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: BlocConsumer<NoticeBloc, NoticeState>(
        listener: (context, state) {
          if (state is NoticeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is NoticeDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Aviso eliminado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            _loadNotices();
          } else if (state is NoticeUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Aviso actualizado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            _loadNotices();
          } else if (state is BroadcastNoticesCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Avisos broadcast creados: ${state.notices.length}'),
                backgroundColor: Colors.green,
              ),
            );
            _loadNotices();
          } else if (state is NoticeCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Aviso creado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            _loadNotices();
          }
        },
        builder: (context, state) {
          if (state is NoticeLoading && _notices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AllNoticesLoaded) {
            _notices = state.notices;
          }

          if (_filteredNotices.isEmpty) {
            return _searchQuery.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron resultados para "$_searchQuery"',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : const EmptyNoticesWidget();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: NoticeStatCard(
                        title: 'Total',
                        value: _notices.length.toString(),
                        icon: Icons.notifications,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NoticeStatCard(
                        title: 'No Leídos',
                        value: _notices.where((n) => !n.leido).length.toString(),
                        icon: Icons.circle_notifications,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NoticeStatCard(
                        title: 'Importantes',
                        value: _notices.where((n) => n.importante).length.toString(),
                        icon: Icons.priority_high,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _loadNotices();
                    await Future.delayed(const Duration(seconds: 1));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredNotices.length,
                    itemBuilder: (context, index) {
                      final notice = _filteredNotices[index];
                      return NoticeCard(
                        notice: notice,
                        onTap: () => _editNotice(notice),
                        onDelete: () => _confirmDelete(notice),
                        showAdminActions: true,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNotice,
        icon: const Icon(Icons.add),
        label: const Text('Crear Aviso'),
      ),
    );
  }

  void _createNotice() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminNoticeCreatePage(),
      ),
    );

    if (result == true) {
      _loadNotices();
    }
  }

  void _createBroadcastNotice() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminNoticeCreatePage(isBroadcast: true),
      ),
    );

    if (result == true) {
      _loadNotices();
    }
  }

  void _editNotice(Notice notice) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminNoticeEditPage(notice: notice),
      ),
    );

    if (result == true) {
      _loadNotices();
    }
  }

  void _confirmDelete(Notice notice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Aviso'),
        content: const Text('¿Estás seguro de que deseas eliminar este aviso?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<NoticeBloc>().add(DeleteNoticeEvent(notice.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
