import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'objects/exercise_details.dart';

class ExerciseDetailsPage extends StatefulWidget {
  final String exerciseName;
  final String dayName;
  final String blockName;
  final String userId;

  const ExerciseDetailsPage({
    super.key,
    required this.exerciseName,
    required this.dayName,
    required this.blockName,
    required this.userId,
  });

  @override
  State<ExerciseDetailsPage> createState() => _ExerciseDetailsPageState();
}

class _ExerciseDetailsPageState extends State<ExerciseDetailsPage> {
  int selectedTabIndex = 0;
  late final CollectionReference exerciseDetailsCollection;

  ExerciseList objetivoData = ExerciseList(exerciseSet: []);
  ExerciseList realData = ExerciseList(exerciseSet: []);

  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    exerciseDetailsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('blocks')
        .doc(widget.blockName)
        .collection('trainings')
        .doc(widget.dayName)
        .collection('exercises')
        .doc(widget.exerciseName)
        .collection('details');

    loadExerciseDetails();
    loadNotes();
  }

  Future<void> loadExerciseDetails() async {
    final snapshot = await exerciseDetailsCollection.get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        objetivoData = ExerciseList(
          exerciseSet: snapshot.docs
              .where((doc) => doc['type'] == 'objetivo')
              .map((doc) => List<double>.from(doc['set']))
              .toList(),
        );
        realData = ExerciseList(
          exerciseSet: snapshot.docs
              .where((doc) => doc['type'] == 'real')
              .map((doc) => List<double>.from(doc['set']))
              .toList(),
        );
      });
    }
  }

  Future<void> loadNotes() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('blocks')
        .doc(widget.blockName)
        .collection('trainings')
        .doc(widget.dayName)
        .collection('exercises')
        .doc(widget.exerciseName)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      if (data.containsKey('notes')) {
        notesController.text = data['notes'];
      }
    }
  }

  Future<void> saveNotes(String notes) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('blocks')
        .doc(widget.blockName)
        .collection('trainings')
        .doc(widget.dayName)
        .collection('exercises')
        .doc(widget.exerciseName)
        .set({'notes': notes}, SetOptions(merge: true));
  }

  Future<void> saveExerciseDetail(String type, List<double> set) async {
    await exerciseDetailsCollection.add({
      'type': type,
      'set': set,
    });
  }

  Future<void> saveAllDetails() async {
    await exerciseDetailsCollection.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });

    for (var set in objetivoData.exerciseSet) {
      await saveExerciseDetail('objetivo', set);
    }

    for (var set in realData.exerciseSet) {
      await saveExerciseDetail('real', set);
    }
  }

  void addRow() {
    setState(() {
      if (selectedTabIndex == 0) {
        objetivoData.addSet(0, 0, 0);
      } else {
        realData.addSet(0, 0, 0);
      }
    });
    saveAllDetails();
  }

  Widget buildTable(ExerciseList data, String type) {
    return ListView.builder(
      itemCount: data.exerciseSet.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildEditableCell(data, index, 0, 'kg', type),
            buildEditableCell(data, index, 1, '', type),
            buildEditableCell(data, index, 2, '', type),
          ],
        );
      },
    );
  }

  Widget buildEditableCell(
      ExerciseList data, int rowIndex, int colIndex, String unit, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: SizedBox(
        width: 150,
        child: TextField(
          onChanged: (value) {
            setState(() {
              data.exerciseSet[rowIndex][colIndex] =
                  double.tryParse(value) ?? 0;
            });
            saveAllDetails();
          },
          decoration: InputDecoration(
            hintText:
                '${formattedNumber(data.exerciseSet[rowIndex][colIndex])} $unit',
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  String formattedNumber(double number) {
    return number % 1 == 0 ? number.toInt().toString() : number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exerciseName),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
            tabs: const [
              Tab(text: 'OBJETIVO'),
              Tab(text: 'REAL'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  buildTable(objetivoData, 'objetivo'),
                  buildTable(realData, 'real'),
                ],
              ),
            ),
            GestureDetector(
              onTap: addRow,
              child: Container(
                width: 500,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.add, color: Colors.black),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estadísticas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('E1RM: 0 kg', style: TextStyle(color: Colors.white)),
                      Text('Tonelaje: 0 kg',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller:
                    notesController, // Controlador para manejar el texto
                maxLines: 3,
                onChanged: (value) => saveNotes(
                    value), // Guardar las notas en Firestore al cambiar
                decoration: InputDecoration(
                  hintText: 'Notas del ejercicio',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
