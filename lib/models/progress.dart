class Progress {
  String? description;
  DateTime? createdAt;

  Progress.fromMap(Map data) {
    description = data['description'];
    if (data['createdAt'] != null) createdAt = DateTime.tryParse(data['createdAt']);
  }
}
