import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
    this.onEdit,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Color _getCardColor() {
    if (task.isCompleted) return Color(0xFFF0FDF4);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
    );
    final daysUntilDue = dueDate.difference(today).inDays;

    if (daysUntilDue < 0) return Color(0xFFFEF2F2);
    if (daysUntilDue == 0) return Color(0xFFFEF2F2);
    if (daysUntilDue == 1) return Color(0xFFFFF7ED);
    if (daysUntilDue <= 3) return Color(0xFFFEFBEA);
    if (daysUntilDue <= 7) return Color(0xFFEFF6FF);
    return Colors.white;
  }

  Color _getBorderColor() {
    if (task.isCompleted) return Color(0xFF22C55E);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
    );
    final daysUntilDue = dueDate.difference(today).inDays;

    if (daysUntilDue < 0) return Color(0xFFEF4444);
    if (daysUntilDue == 0) return Color(0xFFEF4444);
    if (daysUntilDue == 1) return Color(0xFFF97316);
    if (daysUntilDue <= 3) return Color(0xFFF59E0B);
    if (daysUntilDue <= 7) return Color(0xFF3B82F6);
    return Color(0xFF10B981);
  }

  Color _getIconColor() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
    );
    final daysUntilDue = dueDate.difference(today).inDays;

    if (task.isCompleted) return Color(0xFF22C55E);
    if (daysUntilDue < 0) return Color(0xFFEF4444);
    if (daysUntilDue == 0) return Color(0xFFEF4444);
    if (daysUntilDue == 1) return Color(0xFFF97316);
    if (daysUntilDue <= 3) return Color(0xFFF59E0B);
    if (daysUntilDue <= 7) return Color(0xFF3B82F6);
    return Color(0xFF10B981);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    final checkboxSize = isTablet ? 28.0 : 24.0;
    final titleFontSize = isTablet ? 18.0 : 16.0;
    final descriptionFontSize = isTablet ? 16.0 : 14.0;
    final dateFontSize = isTablet ? 14.0 : 12.0;
    final priorityFontSize = isTablet ? 14.0 : 12.0;
    final iconSize = isTablet ? 20.0 : 18.0;
    final padding = isTablet ? 20.0 : 16.0;

    return Container(
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getBorderColor().withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop)
              Row(
                children: [
                  GestureDetector(
                    onTap: onToggleComplete,
                    child: Container(
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? _getIconColor()
                            : Colors.transparent,
                        border: Border.all(color: _getIconColor(), width: 2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      width: checkboxSize,
                      height: checkboxSize,
                      child: task.isCompleted
                          ? Icon(
                              Icons.check,
                              size: checkboxSize * 0.6,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontWeight: FontWeight.w700,
                            fontSize: titleFontSize,
                            color: task.isCompleted
                                ? Colors.grey[600]
                                : Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          task.description,
                          style: TextStyle(
                            color: task.isCompleted
                                ? Colors.grey[500]
                                : Colors.grey[600],
                            fontSize: descriptionFontSize,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getIconColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('📅', style: TextStyle(fontSize: dateFontSize)),
                        SizedBox(width: 6),
                        Text(
                          _formatDate(task.dueDate),
                          style: TextStyle(
                            fontSize: dateFontSize,
                            color: _getIconColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!task.isCompleted) ...[
                    SizedBox(width: 12),
                    _buildPriorityChip(
                      isDesktop: true,
                      fontSize: priorityFontSize,
                    ),
                  ],
                  SizedBox(width: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Color(0xFF6366F1),
                              size: iconSize,
                            ),
                            onPressed: onEdit,
                            tooltip: 'Editar',
                            padding: EdgeInsets.all(8),
                            constraints: BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                          ),
                        ),
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Color(0xFFEF4444),
                            size: iconSize,
                          ),
                          onPressed: () =>
                              _showDeleteConfirmation(context, isTablet),
                          tooltip: 'Excluir',
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onToggleComplete,
                        child: Container(
                          decoration: BoxDecoration(
                            color: task.isCompleted
                                ? _getIconColor()
                                : Colors.transparent,
                            border: Border.all(
                              color: _getIconColor(),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          width: checkboxSize,
                          height: checkboxSize,
                          child: task.isCompleted
                              ? Icon(
                                  Icons.check,
                                  size: checkboxSize * 0.6,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontWeight: FontWeight.w700,
                            fontSize: titleFontSize,
                            color: task.isCompleted
                                ? Colors.grey[600]
                                : Colors.grey[800],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (onEdit != null)
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF6366F1).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Color(0xFF6366F1),
                                  size: iconSize,
                                ),
                                onPressed: onEdit,
                                tooltip: 'Editar',
                                padding: EdgeInsets.all(8),
                                constraints: BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                              ),
                            ),
                          SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFEF4444).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Color(0xFFEF4444),
                                size: iconSize,
                              ),
                              onPressed: () =>
                                  _showDeleteConfirmation(context, isTablet),
                              tooltip: 'Excluir',
                              padding: EdgeInsets.all(8),
                              constraints: BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 12),
                  Text(
                    task.description,
                    style: TextStyle(
                      color: task.isCompleted
                          ? Colors.grey[500]
                          : Colors.grey[600],
                      fontSize: descriptionFontSize,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getIconColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '📅',
                              style: TextStyle(fontSize: dateFontSize),
                            ),
                            SizedBox(width: 4),
                            Text(
                              _formatDate(task.dueDate),
                              style: TextStyle(
                                fontSize: dateFontSize,
                                color: _getIconColor(),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!task.isCompleted)
                        _buildPriorityChip(
                          isDesktop: false,
                          fontSize: priorityFontSize,
                        ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip({
    required bool isDesktop,
    required double fontSize,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.dueDate.year,
      task.dueDate.month,
      task.dueDate.day,
    );
    final daysUntilDue = dueDate.difference(today).inDays;

    String label;
    String symbol;
    Color color;

    if (daysUntilDue < 0) {
      label = 'Atrasada';
      symbol = '⚠️';
      color = Color(0xFFEF4444);
    } else if (daysUntilDue == 0) {
      label = 'Hoje';
      symbol = '🔥';
      color = Color(0xFFEF4444);
    } else if (daysUntilDue == 1) {
      label = 'Amanhã';
      symbol = '⏰';
      color = Color(0xFFF97316);
    } else if (daysUntilDue <= 3) {
      label = 'Próxima';
      symbol = '📅';
      color = Color(0xFFF59E0B);
    } else if (daysUntilDue <= 7) {
      label = 'Esta semana';
      symbol = '📆';
      color = Color(0xFF3B82F6);
    } else {
      label = 'Futuro';
      symbol = '✅';
      color = Color(0xFF10B981);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 12 : 10,
        vertical: isDesktop ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(symbol, style: TextStyle(fontSize: fontSize)),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, bool isTablet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmar Exclusão',
            style: TextStyle(fontSize: isTablet ? 20 : 18),
          ),
          content: Text(
            'Tem certeza que deseja excluir a tarefa "${task.title}"?',
            style: TextStyle(fontSize: isTablet ? 16 : 14),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancelar',
                style: TextStyle(fontSize: isTablet ? 16 : 14),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Excluir',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: isTablet ? 16 : 14,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
          ],
        );
      },
    );
  }
}
