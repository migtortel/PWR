import 'trainings.dart';

class Block {
  Map<String, List<Trainings>> blocks; // Mapa de bloques con lista de entrenamientos

  // Constructor para inicializar el mapa de bloques
  Block({required String name, required List<Trainings> training})
      : blocks = {name: training};

  // Método para agregar un bloque nuevo
  void addBlock(String blockName) {
    if (!blocks.containsKey(blockName)) {
      blocks[blockName] = [];
    } else {
      throw Exception("El bloque '$blockName' ya existe.");
    }
  }

  // Método para agregar un entrenamiento a un bloque
  void addTraining(String blockName, Trainings training) {
    if (blocks.containsKey(blockName)) {
      blocks[blockName]?.add(training);
    } else {
      throw Exception("El bloque '$blockName' no existe.");
    }
  }

  // Método para eliminar un bloque completo
  void removeBlock(String blockName) {
    if (blocks.containsKey(blockName)) {
      blocks.remove(blockName);
    } else {
      throw Exception("El bloque '$blockName' no existe.");
    }
  }

  // Método para eliminar un entrenamiento de un bloque
  void removeTraining(String blockName, Trainings training) {
    if (blocks.containsKey(blockName)) {
      blocks[blockName]?.remove(training);
    } else {
      throw Exception("El bloque '$blockName' no existe.");
    }
  }

  // Obtener una lista de entrenamientos en un bloque
  List<Trainings>? getTrainings(String blockName) {
    return blocks[blockName];
  }

  // Representación en texto
  @override
  String toString() {
    return 'Blocks: ${blocks.keys.toList()}';
  }
}
