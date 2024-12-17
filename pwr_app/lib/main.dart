import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';


void main() => runApp(const PersonalTrainingApp());

class PersonalTrainingApp extends StatelessWidget {
  const PersonalTrainingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PWR Training',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFEFF4F5),
        primarySwatch: Colors.teal,
      ),
      home: LoginPage(),
    );
  }
}

// Página de Login
class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboard con navegación
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StatisticsPage(),
    const TrainingBlocksPage(),
    const CalendarPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PWR Training'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Estadísticas'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Entrenamientos'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendario'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Página de Estadísticas
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: const FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 2, reservedSize: 40),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 3),
                  FlSpot(1, 4),
                  FlSpot(2, 6),
                  FlSpot(3, 8),
                  FlSpot(4, 5),
                  FlSpot(5, 7),
                  FlSpot(6, 9),
                ],
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                isStrokeCapRound: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página del Calendario
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(color: Colors.teal.withValues(), shape: BoxShape.circle),
            selectedDecoration: const BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
          ),
          headerStyle: const HeaderStyle(titleCentered: true, formatButtonVisible: false),
        ),
      ),
    );
  }
}

// Página de Bloques
class TrainingBlocksPage extends StatefulWidget {
  const TrainingBlocksPage({Key? key}) : super(key: key);

  @override
  State<TrainingBlocksPage> createState() => _TrainingBlocksPageState();
}

class _TrainingBlocksPageState extends State<TrainingBlocksPage> {
  final List<String> trainingBlocks = [];

  void _createBlock() {
    String blockName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Bloque'),
          content: TextField(
            onChanged: (value) => blockName = value,
            decoration: const InputDecoration(hintText: 'Nombre del Bloque'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (blockName.isNotEmpty) {
                  setState(() => trainingBlocks.add(blockName));
                }
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createBlock,
          ),
        ],
      ),
      body: trainingBlocks.isEmpty
          ? const Center(child: Text('Presiona + para crear un bloque', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: trainingBlocks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(trainingBlocks[index]),
                    subtitle: const Text('0 Entrenamientos'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainingDaysPage(blockName: trainingBlocks[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

// Página de Entrenamientos
class TrainingDaysPage extends StatefulWidget {
  final String blockName;

  const TrainingDaysPage({Key? key, required this.blockName}) : super(key: key);

  @override
  State<TrainingDaysPage> createState() => _TrainingDaysPageState();
}

class _TrainingDaysPageState extends State<TrainingDaysPage> {
  final List<String> trainingDays = [];

  void _createTrainingDay() {
    String dayName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Entrenamiento'),
          content: TextField(
            onChanged: (value) => dayName = value,
            decoration: const InputDecoration(hintText: 'Nombre del entrenamiento'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (dayName.isNotEmpty) {
                  setState(() => trainingDays.add(dayName));
                }
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToExercises(String dayName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisePage(dayName: dayName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blockName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createTrainingDay,
          ),
        ],
      ),
      body: trainingDays.isEmpty
          ? const Center(
              child: Text(
                'Presiona + para crear un entrenamiento',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: trainingDays.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(trainingDays[index]),
                    subtitle: const Text('0 Ejercicios · Sin fecha'),
                    onTap: () => _navigateToExercises(trainingDays[index]),
                  ),
                );
              },
            ),
    );
  }
}

class ExercisePage extends StatelessWidget {
  final String dayName;

  const ExercisePage({Key? key, required this.dayName}) : super(key: key);

  void _navigateToAddExercises(BuildContext context, String dayName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectExercisePage(dayName: '')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddExercises(context, dayName)
            )
        ],
      ),
      body: const Center(
        child: Text(
          'Presiona + para crear ejercicios',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

class SelectExercisePage extends StatelessWidget {
  final String dayName;
  SelectExercisePage({Key? key, required this.dayName});

  final List<String> categories = [
    'Dominante de Rodilla',
    'Dominante de Cadera',
    'Empuje',
    'Tirón',
    'Core',
  ];

  final List<String> exercises = [
    'Remo en máquina',
    'Hyperextensiones',
    'Prensa de piernas Platz',
    'Sentadilla',
    'Sentadilla Hack',
    'Sentadilla Búlgara',
    'Sentadilla Frontal',
    'Sentadilla Zercher',
    'Curl de Piernas',
    'Extensión de Piernas',
    'Prensa de Piernas',
    'Zancadas',
    'Peso Muerto Convencional',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dayName),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Añadir',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Chip(
                    label: Text(categories[index]),
                    backgroundColor: Colors.teal.withValues(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(exercises[index]),
                  leading: const Icon(Icons.info_outline),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
