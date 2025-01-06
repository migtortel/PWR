import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'exercise_page.dart';

class TrainingDaysPage extends StatefulWidget {
  final String blockName;
  final String userId; // ID del usuario autenticado

  const TrainingDaysPage({
    super.key,
    required this.blockName,
    required this.userId,
  });

  @override
  State<TrainingDaysPage> createState() => TrainingDaysPageState();
}

class TrainingDaysPageState extends State<TrainingDaysPage> {
  late final CollectionReference trainingsCollection;

  @override
  void initState() {
    super.initState();
    // Referencia a la subcolección trainings dentro del bloque
    trainingsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('blocks')
        .doc(widget.blockName)
        .collection('trainings');
  }

  // Método para crear un nuevo entrenamiento
  void createTrainingDay() {
    String dayName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Entrenamiento'),
          content: TextField(
            onChanged: (value) => dayName = value,
            decoration:
                const InputDecoration(hintText: 'Nombre del entrenamiento'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (dayName.isNotEmpty) {
                  // Guardar el entrenamiento en Firestore
                  await trainingsCollection.doc(dayName).set({
                    'name': dayName,
                    'created_at': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context);
                }
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
        title: Text(widget.blockName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: createTrainingDay,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: trainingsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Presiona + para crear un entrenamiento',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final trainings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: trainings.length,
            itemBuilder: (context, index) {
              final training = trainings[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: FutureBuilder<int>(
                  future: _getExerciseCount(training.id),
                  builder: (context, exerciseCountSnapshot) {
                    final exerciseCount = exerciseCountSnapshot.data ?? 0;
                    return ListTile(
                      title: Text(training['name']),
                      subtitle: Text('$exerciseCount Ejercicios - Sin fecha'),
                      onTap: () => navigateToExercises(
                          widget.blockName, training['name'], widget.userId),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  Future<int> _getExerciseCount(String trainingId) async {
    final exercisesCollection = trainingsCollection.doc(trainingId).collection('exercises');
    final snapshot = await exercisesCollection.get();
    return snapshot.size;
  }

  void navigateToExercises(String blockName, String dayName, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ExercisePage(blockName: blockName, dayName: dayName, userId: userId),
      ),
    );
  }
}
