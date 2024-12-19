import 'package:flutter/material.dart';
import 'main.dart';

class TrainingDaysPage extends StatefulWidget {
  final String blockName;
  const TrainingDaysPage({super.key, required this.blockName});

  @override
  State<TrainingDaysPage> createState() => TrainingDaysPageState();
}

class TrainingDaysPageState extends State<TrainingDaysPage> {
  final List<String> trainingDays = [];

  void createTrainingDay() {
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
                    onTap: () => navigateToExercises(trainingDays[index]),
                  ),
                );
              },
            ),
    );
  }

  void navigateToExercises(String dayName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisePage(dayName: dayName),
      ),
    );
  }
}