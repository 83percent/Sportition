import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sportition_center/models/exercise/exercise_model.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class ExerciseListWidget extends StatefulWidget {
  final Function(Exercise) onExerciseSelected;

  const ExerciseListWidget({Key? key, required this.onExerciseSelected})
      : super(key: key);

  @override
  _ExerciseListWidgetState createState() => _ExerciseListWidgetState();
}

class _ExerciseListWidgetState extends State<ExerciseListWidget> {
  Future<List<Exercise>> _loadExercises() async {
    final String response =
        await rootBundle.loadString('lib/data/exercises.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Exercise.fromJson(json)).toList();
  }

  List<Exercise> _allExercises = [];
  List<Exercise> _filteredExercises = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadExercises().then((exercises) {
      setState(() {
        _allExercises = exercises;
        _filteredExercises = exercises;
        _sortExercises();
      });
    });
  }

  void _filterExercises(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredExercises = _allExercises;
      } else {
        _filteredExercises = _allExercises.where((exercise) {
          return exercise.name.contains(query);
        }).toList();
      }
      _sortExercises();
    });
  }

  void _sortExercises() {
    _filteredExercises.sort((a, b) {
      final regex = RegExp(r'^[ㄱ-ㅎ가-힣]');
      final isAKorean = regex.hasMatch(a.name);
      final isBKorean = regex.hasMatch(b.name);

      if (isAKorean && !isBKorean) {
        return -1;
      } else if (!isAKorean && isBKorean) {
        return 1;
      } else {
        return a.name.compareTo(b.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterExercises,
              decoration: const InputDecoration(
                labelText: '운동명을 입력해주세요...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: FutureBuilder<List<Exercise>>(
            future: _loadExercises(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('운동 목록이 없습니다.'));
              } else {
                final exercises = _filteredExercises;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          exercise.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          exercise.category,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          widget.onExerciseSelected(exercise);
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
