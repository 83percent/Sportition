import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sportition_center/models/exercise/exercise_dto.dart';
import 'package:sportition_center/models/exercise/exercise_model.dart';
import 'package:sportition_center/services/exercise/exercise_service.dart';
import 'package:sportition_center/shared/styles/app_colors.dart';

class ExerciseListWidget extends StatefulWidget {
  Function(Exercise)? onExerciseSelected;

  ExerciseListWidget({super.key, this.onExerciseSelected});

  @override
  _ExerciseListWidgetState createState() => _ExerciseListWidgetState();
}

class _ExerciseListWidgetState extends State<ExerciseListWidget> {
  List<ExerciseDTO> _allExercises = [];
  List<ExerciseDTO> _filteredExercises = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _getExerciseListLoad().then((exercises) {
      setState(() {
        _allExercises = exercises;
        _filteredExercises = exercises;
        _sortExercises();
      });
    });
  }

  Future<List<ExerciseDTO>> _getExerciseListLoad() async {
    return await ExerciseService().getExerciseList();
  }

  Future<List<Exercise>> _loadExercises() async {
    final String response =
        await rootBundle.loadString('lib/data/exercises.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Exercise.fromJson(json)).toList();
  }

  void _filterExercises(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredExercises = _allExercises;
      } else {
        _filteredExercises = _allExercises.where((exercise) {
          return exercise.exerciseName.contains(query);
        }).toList();
      }
      _sortExercises();
    });
  }

  void _sortExercises() {
    _filteredExercises.sort((a, b) {
      final regex = RegExp(r'^[ㄱ-ㅎ가-힣]');
      final isAKorean = regex.hasMatch(a.exerciseName);
      final isBKorean = regex.hasMatch(b.exerciseName);

      if (isAKorean && !isBKorean) {
        return -1;
      } else if (!isAKorean && isBKorean) {
        return 1;
      } else {
        return a.exerciseName.compareTo(b.exerciseName);
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
          child: FutureBuilder<List<ExerciseDTO>>(
            future: _getExerciseListLoad(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('운동 목록이 없습니다.'));
              } else {
                final exercises = _filteredExercises;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                                exercise.exerciseName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                exercise.type,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                if (widget.onExerciseSelected != null) {
                                  widget.onExerciseSelected!(
                                    Exercise(
                                      name: exercise.exerciseName,
                                      value: exercise.exerciseUID!,
                                      category: exercise.type,
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
