import 'exercise.dart';

class Trainings {
  Map<String, Exercise> trainings; // Mapa de ejercicios con nombre como clave

  // Constructor
  Trainings({required this.trainings});

  // Método para agregar un entrenamiento
  void addTraining(String name, Exercise exercise) {
    trainings.addAll({name: exercise});
  }

  // Método para eliminar un entrenamiento
  void removeTraining(String name) {
    if (trainings.containsKey(name)) {
      trainings.remove(name);
    } else {
      throw Exception("No se encontró un entrenamiento con nombre '$name'.");
    }
  }

  // Obtener un entrenamiento por nombre
  Exercise? getTraining(String name) {
    return trainings[name];
  }

  // Representación en texto
  @override
  String toString() {
    return 'Trainings: ${trainings.keys.toList()}';
  }
}
