import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'training_page.dart';

class TrainingBlocksPage extends StatefulWidget {
  final String userId; // ID del usuario autenticado
  const TrainingBlocksPage({super.key, required this.userId});

  @override
  State<TrainingBlocksPage> createState() => TrainingBlocksPageState();
}

class TrainingBlocksPageState extends State<TrainingBlocksPage> {
  late final CollectionReference blocksCollection;

  @override
  void initState() {
    super.initState();
    // Referencia a la colección de bloques para el usuario autenticado
    blocksCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('blocks');
  }

  // Método para crear un nuevo bloque
  void createBlock() {
    String blockName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Bloque'),
          content: TextField(
            onChanged: (value) => blockName = value,
            decoration: const InputDecoration(hintText: 'Nombre del Bloque'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (blockName.isNotEmpty) {
                  // Guardar el bloque en Firestore
                  await blocksCollection.doc(blockName).set({
                    'name': blockName,
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
        title: const Text('Bloques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: createBlock,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: blocksCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Presiona + para crear un bloque',
                  style: TextStyle(color: Colors.grey)),
            );
          }

          final blocks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: blocks.length,
            itemBuilder: (context, index) {
              final block = blocks[index];
              return Card(
                child: ListTile(
                  title: Text(block['name']),
                  subtitle: const Text('0 Entrenamientos'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainingDaysPage(blockName: block['name'], userId: widget.userId),
                      ),
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
}
