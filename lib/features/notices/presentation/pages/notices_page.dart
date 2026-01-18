import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notice.dart';
import '../bloc/notice_bloc.dart';
import '../bloc/notice_event.dart';
import '../bloc/notice_state.dart';
import '../widgets/notice_card.dart';
import '../widgets/empty_notices_widget.dart';

/// Página principal para mostrar los avisos del usuario
class NoticesPage extends StatefulWidget {
  const NoticesPage({super.key});

  @override
  State<NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  List<Notice> _notices = [];
  String _filter = 'todos'; // todos, leidos, no_leidos

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  void _loadNotices() {
    context.read<NoticeBloc>().add(const GetMyNoticesEvent());
  }

  List<Notice> get _filteredNotices {
    switch (_filter) {
      case 'leidos':
        return _notices.where((n) => n.leido).toList();
      case 'no_leidos':
        return _notices.where((n) => !n.leido).toList();
      default:
        return _notices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos'),
        actions: [
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
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotices,
            tooltip: 'Actualizar',
          ),
        ],
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
          } else if (state is NoticeMarkedAsRead) {
            _loadNotices(); // Recargar lista
          } else if (state is NoticeDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Aviso eliminado'),
                backgroundColor: Colors.green,
              ),
            );
            _loadNotices(); // Recargar lista
          }
        },
        builder: (context, state) {
          if (state is NoticeLoading && _notices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NoticesLoaded) {
            _notices = state.notices;
          }

          if (_filteredNotices.isEmpty) {
            return const EmptyNoticesWidget();
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadNotices();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredNotices.length,
              itemBuilder: (context, index) {
                final notice = _filteredNotices[index];
                return NoticeCard(
                  notice: notice,
                  onTap: () => _onNoticeTap(notice),
                  onDelete: () => _onNoticeDelete(notice),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _onNoticeTap(Notice notice) {
    if (!notice.leido) {
      context.read<NoticeBloc>().add(MarkNoticeAsReadEvent(notice.id));
    }
    
    _showNoticeDetail(notice);
  }

  void _onNoticeDelete(Notice notice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar aviso'),
        content: const Text('¿Estás seguro de eliminar este aviso?'),
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
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showNoticeDetail(Notice notice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            _buildTypeIcon(notice.tipo),
            const SizedBox(width: 12),
            Expanded(
              child: Text(notice.titulo),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(notice.mensaje),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeIcon(NoticeType tipo) {
    IconData iconData;
    Color color;

    switch (tipo) {
      case NoticeType.success:
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case NoticeType.warning:
        iconData = Icons.warning;
        color = Colors.orange;
        break;
      case NoticeType.error:
        iconData = Icons.error;
        color = Colors.red;
        break;
      case NoticeType.announcement:
        iconData = Icons.campaign;
        color = Colors.purple;
        break;
      default:
        iconData = Icons.info;
        color = Colors.blue;
    }

    return Icon(iconData, color: color);
  }
}
