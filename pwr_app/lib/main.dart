import 'package:flutter/material.dart';

import 'login_page.dart';


void main() => runApp(const PersonalTrainingApp());

class PersonalTrainingApp extends StatelessWidget {
  const PersonalTrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PWR Training',
      theme: ThemeData.dark(),
      home: LoginPage(),
    );
  }
}

// Página de Login

// Dashboard con navegación

// Página de Estadísticas

// Página del Calendario

// Página de Bloques

// Página de Entrenamientos
class TrainingDaysPage extends StatefulWidget {
  final String blockName;

  const TrainingDaysPage({super.key, required this.blockName});

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

  const ExercisePage({super.key, required this.dayName});

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

class SelectExercisePage extends StatefulWidget {
  final String dayName; // Nombre del entrenamiento
  const SelectExercisePage({super.key, required this.dayName});

  @override
  State<SelectExercisePage> createState() => _SelectExercisePageState();
}

class _SelectExercisePageState extends State<SelectExercisePage> {
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

  // Mapa para guardar los ejercicios seleccionados en cada entrenamiento
  Map<String, List<String>> trainingExercises = {};

  List<String> selectedExercises = [];

  void _addExercise(String exercise) {
    setState(() {
      if (!selectedExercises.contains(exercise)) {
        selectedExercises.add(exercise);
      }
    });
  }

  void _removeExercise(String exercise) {
    setState(() {
      selectedExercises.remove(exercise);
    });
  }

  void _saveExercises() {
    // Guardar ejercicios en el mapa asociado al entrenamiento
    trainingExercises[widget.dayName] = List.from(selectedExercises);

    // Retornar a la página anterior con los datos seleccionados
    Navigator.pop(context, trainingExercises);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dayName), // Muestra el nombre del entrenamiento
        actions: [
          TextButton(
            onPressed: _saveExercises, // Guardar los ejercicios seleccionados
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Cuadro de búsqueda
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
          // Categorías como Lazy Row
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
                    backgroundColor: Colors.teal.withOpacity(0.2),
                  ),
                );
              },
            ),
          ),
          // Lista de ejercicios
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final isSelected = selectedExercises.contains(exercise);

                return ListTile(
                  title: Text(exercise),
                  leading: const Icon(Icons.info_outline),
                  trailing: isSelected
                      ? IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeExercise(exercise),
                        )
                      : IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => _addExercise(exercise),
                        ),
                );
              },
            ),
          ),
          // Mostrar ejercicios seleccionados temporalmente
          if (selectedExercises.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ejercicios Seleccionados:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...selectedExercises.map((e) => Text('- $e')),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

