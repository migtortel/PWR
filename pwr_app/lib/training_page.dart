import 'package:flutter/material.dart';
import 'exercise_page.dart';


class TrainingDaysPage extends StatefulWidget {
  final String blockName;
  const TrainingDaysPage({
    super.key,
    required this.blockName,
  });

  @override
  State<TrainingDaysPage> createState() => TrainingDaysPageState();
}

class TrainingDaysPageState extends State<TrainingDaysPage> {
  final List<String> trainingDays = [];
  final List<String> selectedExercises = [];

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
      body: trainingDays.isEmpty? 
          const Center(
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
                    subtitle: Text('(Aqui se muestran el numero de) Ejercicios - Sin fecha'),
                    onTap: () => navigateToExercises(widget.blockName, trainingDays[index]),
                  ),
                );
              },
            ),
    );
  }

  void navigateToExercises(String blockName, String dayName) {
    // Navega a la página de ejercicios y espera los ejercicios seleccionados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExercisePage(blockName: blockName, dayName: dayName),
      ),
    );
  }
}