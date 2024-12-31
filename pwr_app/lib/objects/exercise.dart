import 'exercise_details.dart';

class Exercise {
  String name; // Nombre del ejercicio
  ExerciseList sets; // Conjunto de sets representado por ExerciseList

  // Constructor
  Exercise({
    required this.name,
    required this.sets,
  });

  // Método para agregar un nuevo set
  void addSet(double weight, double reps, double rpe) {
    sets.exerciseSet.add([weight, reps, rpe]);
  }

  // Método para eliminar un set por índice
  void removeSet(int index) {
    if (index >= 0 && index < sets.exerciseSet.length) {
      sets.exerciseSet.removeAt(index);
    } else {
      throw Exception("Índice fuera de rango");
    }
  }

  // Método para actualizar un set por índice
  void updateSet(int index, double weight, double reps, double rpe) {
    if (index >= 0 && index < sets.exerciseSet.length) {
      sets.exerciseSet[index] = [weight, reps, rpe];
    } else {
      throw Exception("Índice fuera de rango");
    }
  }

  // Método para convertir el ejercicio a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets.exerciseSet,
    };
  }

  // Método para crear un objeto desde un Map recuperado de Firestore
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      sets: ExerciseList(
        exerciseSet: (map['sets'] as List<dynamic>)
            .map((set) => List<double>.from(set as List<dynamic>))
            .toList(),
      ),
    );
  }

  // Representación en texto
  @override
  String toString() {
    return 'Ejercicio(name: $name, sets: ${sets.exerciseSet})';
  }
}
