import 'package:flutter/material.dart';

import 'main.dart';

class TrainingBlocksPage extends StatefulWidget {
  const TrainingBlocksPage({Key? key}) : super(key: key);

  @override
  State<TrainingBlocksPage> createState() => _TrainingBlocksPageState();
}

class _TrainingBlocksPageState extends State<TrainingBlocksPage> {
  final List<String> trainingBlocks = [];

  void _createBlock() {
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
              onPressed: () {
                if (blockName.isNotEmpty) {
                  setState(() => trainingBlocks.add(blockName));
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
        title: const Text('Bloques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createBlock,
          ),
        ],
      ),
      body: trainingBlocks.isEmpty
          ? const Center(child: Text('Presiona + para crear un bloque', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: trainingBlocks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(trainingBlocks[index]),
                    subtitle: const Text('0 Entrenamientos'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainingDaysPage(blockName: trainingBlocks[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}