class Resolution {
  String? id;
  String? title;
  String? description;
  String? priority;
  String? action;
  DateTime? dueDate;
  DateTime? createdAt;
  DateTime? arrivedAt;
  DateTime? arrivalVerifiedAt;
  DateTime? resolvedAt;

  Resolution.fromMap(Map data) {
    id = data['_id'];
    title = data['title'];
    description = data['description'];
    priority = data['priority'];
    action = data['action'];
    if (data['createdAt'] != null) createdAt = DateTime.tryParse(data['createdAt']);
    if (data['arrivedAt'] != null) arrivedAt = DateTime.tryParse(data['arrivedAt']);
    if (data['arrivalVerifiedAt'] != null) arrivalVerifiedAt = DateTime.tryParse(data['arrivalVerifiedAt']);
    if (data['resolvedAt'] != null) resolvedAt = DateTime.tryParse(data['resolvedAt']);
  }
}
