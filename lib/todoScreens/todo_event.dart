class TodoModel {
  final String id;
  final String title;
  final bool done;

  TodoModel({this.id, this.title, this.done});

  factory TodoModel.fromMap(Map data) {
    return TodoModel(
      title: data['todoTitle'],
      done: data['done'],
    );
  }

  factory TodoModel.fromDS(String id, Map<String, dynamic> data) {
    return TodoModel(
      id: id,
      title: data['todoTitle'],
      done: data['done'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "todoTitle": title,
      "done": done,
    };
  }
}
