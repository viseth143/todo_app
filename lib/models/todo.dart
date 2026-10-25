import 'package:equatable/equatable.dart';

// Equatable helps BLoC avoid emitting the same state to the UI again.

class Todo extends Equatable {
  final int id;
  final String title;
  final bool done;

  Todo({
    required this.id, 
    required this.title, 
    required this.done});
  // we use todocopy becuz todo is the final field we can't change it so if we wanna change some info we must need todocopy
  Todo copyWith({String? title, bool? done}) {
    return Todo(
      id: id, 
      title: title ?? this.title, 
      done: done ?? this.done);
  }

  // convert obj into json
  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title,
    'done' : done
  };

  // convert data from json into obj
  // we can also use it without factory
  factory Todo.fromJson(Map<String, dynamic> json){
    return Todo(
      id: json['id'], 
      title: json['title'], 
      done: json['done']
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, done];



}
