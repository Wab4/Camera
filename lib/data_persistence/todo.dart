class Todo {
  final int? id;
  final String title;

  Todo({this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}
