import 'package:flutter/material.dart';
import 'package:projeto_teste/models/task.dart';
import 'package:projeto_teste/screens/add_task_screen.dart';
import 'package:projeto_teste/widgets/task_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadSampleTasks();
  }

  void _loadSampleTasks() {
    tasks = [
      Task(
        id: '1',
        title: 'Estudar Flutter',
        description: 'Estudar os conceitos básicos de Flutter',
        dueDate: DateTime.now().add(Duration(days: 1)),
        isCompleted: true,
      ),
      Task(
        id: '2',
        title: 'Fazer projetos',
        description: 'Desenvolver aplicativos Flutter',
        dueDate: DateTime.now().add(Duration(days: 2)),
      ),
      Task(
        id: '3',
        title: 'Tarefa Atrasada',
        description: 'Esta tarefa está atrasada',
        dueDate: DateTime.now().subtract(Duration(days: 2)),
      ),
      Task(
        id: '4',
        title: 'Tarefa para Hoje',
        description: 'Esta tarefa vence hoje',
        dueDate: DateTime.now(),
      ),
      Task(
        id: '5',
        title: 'Tarefa para Amanhã',
        description: 'Esta tarefa vence amanhã',
        dueDate: DateTime.now().add(Duration(days: 1)),
      ),
      Task(
        id: '6',
        title: 'Tarefa da Próxima Semana',
        description: 'Esta tarefa vence na próxima semana',
        dueDate: DateTime.now().add(Duration(days: 10)),
      ),
    ];
  }

  void _toggleTaskCompletion(String taskId) {
    setState(() {
      int index = tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        tasks[index] = tasks[index].copyWith(
          isCompleted: !tasks[index].isCompleted,
        );
      }
    });
  }

  void _deleteTask(String taskId) {
    setState(() {
      tasks.removeWhere((task) => task.id == taskId);
    });
  }

  void _navigateToAddTask() async {
    final Task? newTask = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => AddTaskScreen()));

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final totalTasks = tasks.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Minhas Tarefas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header com estatísticas
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6366F1).withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', totalTasks.toString(), Icons.list),
                Container(width: 1, height: 40, color: Colors.white24),
                _buildStatCard(
                  'Concluídas',
                  completedTasks.toString(),
                  Icons.check_circle,
                ),
                Container(width: 1, height: 40, color: Colors.white24),
                _buildStatCard(
                  'Pendentes',
                  (totalTasks - completedTasks).toString(),
                  Icons.access_time,
                ),
              ],
            ),
          ),

          // Lista de tarefas
          Expanded(
            child: tasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: TaskItem(
                          task: task,
                          onToggleComplete: () =>
                              _toggleTaskCompletion(task.id),
                          onDelete: () => _deleteTask(task.id),
                          onEdit: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Edição em desenvolvimento'),
                                backgroundColor: Color(0xFF6366F1),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddTask,
        icon: Icon(Icons.add),
        label: Text('Nova Tarefa'),
        elevation: 8,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.list, size: 64, color: Colors.grey[400]),
          ),
          SizedBox(height: 24),
          Text(
            'Nenhuma tarefa ainda!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Adicione sua primeira tarefa\ntocando no botão abaixo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
