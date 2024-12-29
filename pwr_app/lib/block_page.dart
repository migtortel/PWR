import 'package:flutter/material.dart';
import 'package:pwr_app/objects/blocks.dart';
import 'package:pwr_app/objects/trainings.dart';
import 'training_page.dart';
class TrainingBlocksPage extends StatefulWidget {
  const TrainingBlocksPage({super.key});

  @override
  State<TrainingBlocksPage> createState() => TrainingBlocksPageState();
}

class TrainingBlocksPageState extends State<TrainingBlocksPage> {
  final List<String> trainingBlocks = [];
  late List<Trainings> trainingsList = [];
  late Block block = Block(name: '', training: trainingsList);

  
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
              onPressed: () {
                if (blockName.isNotEmpty) {
                  setState(() => trainingBlocks.add(blockName));
                  Block block = Block(name: blockName, training: trainingsList);  //Se añade a la BBDD
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
            onPressed: createBlock,
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