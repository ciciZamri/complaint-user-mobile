import 'package:complaint_user/models/Resolution.dart';
import 'package:complaint_user/models/progress.dart';
import 'package:complaint_user/utils/server.dart';

class Message {
  String? id;
  String? message;
  DateTime? createdAt;
  bool? isAuthor;
}

class Complaint {
  String? id;
  String? title;
  String? description;
  String? category;
  Map? location;
  DateTime? createdAt;
  DateTime? resolvedAt;
  List<String>? imageUrls;
  Resolution? resolution;
  List<Progress>? progresses;

  Complaint(this.title, this.description, this.location, this.category);

  Complaint.fromMap(Map data) {
    id = data['_id'];
    title = data['title'];
    description = data['description'];
    category = data['category'];
    location = data['location'];
    createdAt = DateTime.now();
    imageUrls = [];
    if (data['resolution'] != null) {
      resolution = Resolution.fromMap(data['resolution']);
      progresses = (data['progresses'] as List).map<Progress>((e) => Progress.fromMap(e)).toList();
    }
  }

  Future<String> create(String campusId) async {
    String errorMessage = 'Error to create complaint';
    Map body = {
      "title": title,
      "description": description,
      "location": location,
      "campusId": campusId,
      "category": category,
    };
    final result = await Server.httpPost(Server.baseUrl, '/complaint/create', body, errorMessage);
    if (result.code == 200) {
      return result.body['complaintId'];
    }
    throw Exception(errorMessage);
  }

  Future<bool> uploadImage() async {
    return true;
  }

  Future<List<Message>> fetchMessages() async {
    return [Message()];
  }

  Future<bool> sendMessage(Message message) async {
    return true;
  }

  static Future<Complaint> getDetails(String id) async {
    String errorMessage = 'Error to get complaint details';
    final result = await Server.httpGet(Server.baseUrl, '/complaint/get/$id', errorMessage);
    if (result.code == 200) {
      return Complaint.fromMap(result.body);
    }
    throw Exception(errorMessage);
  }
}
