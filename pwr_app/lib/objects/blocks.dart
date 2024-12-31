import 'package:cloud_firestore/cloud_firestore.dart';
import 'trainings.dart';

class Block {
  final String userId; // UID del usuario autenticado

  Block({required this.userId});

  // Método para agregar un bloque
  Future<void> addBlock(String blockName) async {
    final blockRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('blocks')
        .doc(blockName);

    await blockRef.set({
      'name': blockName,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Método para eliminar un bloque
  Future<void> removeBlock(String blockName) async {
    final blockRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('blocks')
        .doc(blockName);

    await blockRef.delete();
  }

  // Método para agregar un entrenamiento a un bloque
  Future<void> addTraining(String blockName, Trainings training) async {
    final trainingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('blocks')
        .doc(blockName)
        .collection('trainings')
        .doc(training.name);

    await trainingRef.set(training.toMap());
  }

  // Método para obtener entrenamientos de un bloque
  Future<List<Trainings>> getTrainings(String blockName) async {
    final trainingsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('blocks')
        .doc(blockName)
        .collection('trainings')
        .get();

    return trainingsSnapshot.docs
        .map((doc) => Trainings.fromMap(doc.data()))
        .toList();
  }
}

