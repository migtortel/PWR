import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pwr_app/detail_exercise_page.dart';

class ExercisePage extends StatefulWidget {
  final String blockName;
  final String dayName;
  final String userId;

  const ExercisePage({
    super.key,
    required this.dayName,
    required this.blockName,
    required this.userId,
  });

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  late final CollectionReference exercisesCollection;

  @override
  void initState() {
    super.initState();
    // Referencia a la subcolección exercises dentro del entrenamiento
    exercisesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('blocks')
        .doc(widget.blockName)
        .collection('trainings')
        .doc(widget.dayName)
        .collection('exercises');
  }

  // Método para navegar a la página de selección de ejercicios
  void navigateToAddExercises(BuildContext context) async {
    final result = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectExercisePage(
          dayName: widget.dayName,
          exercisesCollection: exercisesCollection,
        ),
      ),
    );

    // Sincronizar con Firestore si se seleccionaron ejercicios
    if (result != null && result.isNotEmpty) {
      for (final exercise in result) {
        await exercisesCollection.doc(exercise).set({
          'name': exercise,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => navigateToAddExercises(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: exercisesCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Presiona + para crear ejercicios',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final exercises = snapshot.data!.docs;

          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(exercise['name']),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetailsPage(
                        exerciseName: exercise['name'],
                        dayName: widget.dayName,
                        blockName: widget.blockName,
                        userId: widget.userId,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SelectExercisePage extends StatefulWidget {
  final String dayName;
  final CollectionReference exercisesCollection;

  const SelectExercisePage({
    super.key,
    required this.dayName,
    required this.exercisesCollection,
  });

  @override
  State<SelectExercisePage> createState() => SelectExercisePageState();
}

class SelectExercisePageState extends State<SelectExercisePage> {
  List<String> selectedExercises = [];

  final List<String> categories = [
    'Dominante de Rodilla',
    'Dominante de Cadera',
    'Empuje',
    'Tirón',
    'Core',
  ];

  List<String> exercises = [
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
        title: Text(widget.dayName),
        actions: [
          TextButton(
            onPressed: saveExercises,
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: addExerciseToList,
            child: const Text(
              'Añadir ejercicio a la lista',
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
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Chip(
                    label: Text(categories[index]),
                    backgroundColor: Colors.teal.withValues(),
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
                return Card(
                  margin: const EdgeInsets.all(1),
                  child: ListTile(
                    title: Text(exercise),
                    onTap: () => addExercise(exercise),
                  ),
                );
              },
            ),
          ),// Mostrar ejercicios seleccionados temporalmente
          if (selectedExercises.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: selectedExercises.length,
                itemBuilder: (context, index) {
                  final exercise = selectedExercises[index];
                  return Card(
                      margin: const EdgeInsets.all(1),
                      color: const Color.fromARGB(255, 57, 30, 119),
                      child: ListTile(
                        title: Text(selectedExercises[index]),
                        onTap: () => removeExercise(exercise),
                      ));
                },
              ),
            )
        ],
      ),
    );
  }

  void addExercise(String exercise) {
    setState(() {
      if (!selectedExercises.contains(exercise)) {
        selectedExercises.add(exercise);
      }
    });
  }
  
  void removeExercise(String exercise) {
    setState(() {
      selectedExercises.remove(exercise);
    });
  }

  void saveExercises() {
    Navigator.pop(context, selectedExercises);
  }

  void addExerciseToList() {
    String exerciseName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Añadir ejercicio'),
          content: TextField(
            onChanged: (value) => exerciseName = value,
            decoration: const InputDecoration(hintText: 'Nombre del ejercicio'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!exercises.contains(exerciseName)) {
                  setState(() => exercises.add(exerciseName));
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
}
