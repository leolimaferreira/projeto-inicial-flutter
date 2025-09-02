import 'package:flutter/material.dart';
import 'package:projeto_teste/models/task.dart';

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

    if (daysUntilDue < 0) return Color(0xFFFEF2F2); // Atrasada - vermelho
    if (daysUntilDue == 0) return Color(0xFFFEF2F2); // Hoje - vermelho
    if (daysUntilDue == 1) return Color(0xFFFFF7ED); // Amanhã - laranja
    if (daysUntilDue <= 3) return Color(0xFFFEFBEA); // Próxima - amarelo
    if (daysUntilDue <= 7) return Color(0xFFEFF6FF); // Esta semana - azul
    return Colors.white; // Futuro - branco
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
    if (daysUntilDue < 0) return Color(0xFFEF4444); // Atrasada
    if (daysUntilDue == 0) return Color(0xFFEF4444); // Hoje
    if (daysUntilDue == 1) return Color(0xFFF97316); // Amanhã
    if (daysUntilDue <= 3) return Color(0xFFF59E0B); // Próxima
    if (daysUntilDue <= 7) return Color(0xFF3B82F6); // Esta semana
    return Color(0xFF10B981); // Futuro
  }

  @override
  Widget build(BuildContext context) {
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header da tarefa
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
                    width: 24,
                    height: 24,
                    child: task.isCompleted
                        ? Icon(Icons.check, size: 16, color: Colors.white)
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
                      fontSize: 16,
                      color: task.isCompleted
                          ? Colors.grey[600]
                          : Colors.grey[800],
                    ),
                  ),
                ),
                // Ações
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
                            size: 18,
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
                          size: 18,
                        ),
                        onPressed: () => _showDeleteConfirmation(context),
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

            // Descrição
            Text(
              task.description,
              style: TextStyle(
                color: task.isCompleted ? Colors.grey[500] : Colors.grey[600],
                fontSize: 14,
                height: 1.4,
              ),
            ),

            SizedBox(height: 12),

            // Data e status
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getIconColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('📅', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 4),
                      Text(
                        _formatDate(task.dueDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getIconColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                if (!task.isCompleted) _buildPriorityChip(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip() {
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(symbol, style: TextStyle(fontSize: 14)),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text(
            'Tem certeza que deseja excluir a tarefa "${task.title}"?',
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Excluir', style: TextStyle(color: Colors.red)),
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
