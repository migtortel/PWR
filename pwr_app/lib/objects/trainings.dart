import 'exercise.dart';
import 'exercise_details.dart';

class Trainings {
  final String name; // Nombre del entrenamiento
  final List<Exercise> exercises; // Lista de ejercicios en el entrenamiento

  // Constructor
  Trainings({required this.name, required this.exercises});

  // Método para agregar un ejercicio al entrenamiento
  void addExercise(Exercise exercise) {
    exercises.add(exercise);
  }

  // Método para eliminar un ejercicio por nombre
  void removeExercise(String exerciseName) {
    exercises.removeWhere((exercise) => exercise.name == exerciseName);
  }

  // Obtener un ejercicio por nombre
  Exercise? getExercise(String exerciseName) {
    return exercises.firstWhere(
      (exercise) => exercise.name == exerciseName,
      orElse: () => Exercise(name: '', sets: ExerciseList(exerciseSet: [])),
    );
  }

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }

  // Crear un objeto desde un Map recuperado de Firestore
  factory Trainings.fromMap(Map<String, dynamic> map) {
    return Trainings(
      name: map['name'],
      exercises: (map['exercises'] as List<dynamic>)
          .map((exercise) => Exercise.fromMap(exercise as Map<String, dynamic>))
          .toList(),
    );
  }

  // Representación en texto
  @override
  String toString() {
    return 'Training(name: $name, exercises: ${exercises.map((e) => e.name).toList()})';
  }
}
