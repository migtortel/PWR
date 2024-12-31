class ExerciseList {
  List<List<double>> exerciseSet; // Cada sublista representará [peso, reps, rpe]

  // Constructor
  ExerciseList({required this.exerciseSet});

  // Método para añadir un nuevo set
  void addSet(double peso, double reps, double rpe) {
    exerciseSet.add([peso, reps, rpe]);
  }

  // Método para actualizar un set existente
  void updateSet(int index, double peso, double reps, double rpe) {
    if (index >= 0 && index < exerciseSet.length) {
      exerciseSet[index] = [peso, reps, rpe];
    } else {
      throw Exception("Índice fuera de rango");
    }
  }

  // Método para eliminar un set
  void removeSet(int index) {
    if (index >= 0 && index < exerciseSet.length) {
      exerciseSet.removeAt(index);
    } else {
      throw Exception("Índice fuera de rango");
    }
  }

  // Método para convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'sets': exerciseSet.map((set) => set).toList(),
    };
  }

  // Método para crear un objeto desde un Map recuperado de Firestore
  factory ExerciseList.fromMap(Map<String, dynamic> map) {
    return ExerciseList(
      exerciseSet: (map['sets'] as List<dynamic>)
          .map((set) => List<double>.from(set as List<dynamic>))
          .toList(),
    );
  }

  // Representación del objeto como texto
  @override
  String toString() {
    return 'ExerciseList(sets: $exerciseSet)';
  }
}

