import 'exercise_details.dart';

class Exercise {
  String nombre; // Nombre del ejercicio
  ExerciseList sets; // Conjunto de sets representado por ExerciseList

  // Constructor
  Exercise({
    required this.nombre,
    required this.sets,
  });

  // Método para agregar un nuevo set
  void addSet(double peso, double reps, double rpe) {
    sets.exerciseSet.add([peso, reps, rpe]);
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
  void updateSet(int index, double peso, double reps, double rpe) {
    if (index >= 0 && index < sets.exerciseSet.length) {
      sets.exerciseSet[index] = [peso, reps, rpe];
    } else {
      throw Exception("Índice fuera de rango");
    }
  }

  // Representación en texto
  @override
  String toString() {
    return 'Ejercicio(nombre: $nombre, sets: ${sets.exerciseSet})';
  }
}
