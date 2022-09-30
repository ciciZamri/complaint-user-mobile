import 'package:complaint_user/models/complaint.dart';
import 'package:complaint_user/widgets/error_item.dart';
import 'package:flutter/material.dart';

class ReplyPage extends StatefulWidget {
  final String? complaintId;
  const ReplyPage(this.complaintId, {Key? key}) : super(key: key);

  @override
  State<ReplyPage> createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  late Future<List<Message>> messagesFuture;

  @override
  void initState() {
    super.initState();
  }

  Future<List<Message>> fetchMessages() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      Message(),
      Message(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: messagesFuture,
      builder: (context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MessageItem(snapshot.data![index]);
              },
            );
          } else {
            return ErrorItem(() {});
          }
        }
      },
    );
  }
}

class MessageItem extends StatelessWidget {
  final Message message;

  const MessageItem(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 12.0;

    return Row(
      mainAxisAlignment: message.isAuthor! ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Card(
          color: message.isAuthor! ? Colors.blue[300] : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: message.isAuthor! ? Radius.circular(radius) : const Radius.circular(2.0),
              topRight: message.isAuthor! ? const Radius.circular(2.0) : Radius.circular(radius),
              bottomLeft: Radius.circular(radius),
              bottomRight: Radius.circular(radius),
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Container(
                      alignment: message.isAuthor! ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(message.message!),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    alignment: message.isAuthor! ? Alignment.centerLeft : Alignment.centerRight,
                    child: Text('23/09/22 10:46 AM', style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
