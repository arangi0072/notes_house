class notes {
  String id;
  String title;
  String content;

  notes({required this.id, required this.title, required this.content});

  // factory notes.fromDocument(DocumentSnapshot doc) {
  //   return notes(
  //     id: doc.id,
  //     title: doc['title'],
  //     content: doc['content'],
  //   );
  // }
}
