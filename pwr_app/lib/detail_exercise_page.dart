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
  State<ExerciseDetailsPage> createState() => ExerciseDetailsPageState();
}

class ExerciseDetailsPageState extends State<ExerciseDetailsPage> {
  int selectedTabIndex = 0;
  late final DocumentReference exerciseDoc;
  ExerciseList objetivoData = ExerciseList(exerciseSet: []);
  ExerciseList realData = ExerciseList(exerciseSet: []);

  @override
  void initState() {
    super.initState();
    // Referencia al documento del ejercicio en Firestore
    exerciseDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('blocks')
        .doc(widget.blockName)
        .collection('trainings')
        .doc(widget.dayName)
        .collection('exercises')
        .doc(widget.exerciseName);

    // Cargar los datos iniciales desde Firestore
    loadExerciseData();
  }

  Future<void> loadExerciseData() async {
    final snapshot = await exerciseDoc.get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        objetivoData = ExerciseList(
          exerciseSet: List<List<double>>.from(data['objetivo']?.map((e) => List<double>.from(e)) ?? []),
        );
        realData = ExerciseList(
          exerciseSet: List<List<double>>.from(data['real']?.map((e) => List<double>.from(e)) ?? []),
        );
      });
    }
  }

  Future<void> saveExerciseData() async {
    await exerciseDoc.set({
      'objetivo': objetivoData.exerciseSet.map((e) => e.toList()).toList(),
      'real': realData.exerciseSet.map((e) => e.toList()).toList(),
    }, SetOptions(merge: true));
  }

  String formattedNumber(double number) {
    return number % 1 == 0 ? number.toInt().toString() : number.toString();
  }

  void addRow() {
    setState(() {
      if (selectedTabIndex == 0) {
        objetivoData.addSet(0, 0, 0);
      } else {
        realData.addSet(0, 0, 0);
      }
    });
    saveExerciseData(); // Guardar cambios en Firestore
  }

  Widget buildTable(ExerciseList data) {
    return ListView.builder(
      itemCount: data.exerciseSet.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildEditableCell(data, index, 0, 'kg'),
            buildEditableCell(data, index, 1, ''),
            buildEditableCell(data, index, 2, ''),
          ],
        );
      },
    );
  }

  Widget buildEditableCell(
      ExerciseList data, int rowIndex, int colIndex, String unit) {
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
            saveExerciseData(); // Guardar cambios en Firestore
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
                  buildTable(objetivoData),
                  buildTable(realData),
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
            const Divider(height: 2),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estadísticas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
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
            const Divider(height: 2),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                maxLines: 3,
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
