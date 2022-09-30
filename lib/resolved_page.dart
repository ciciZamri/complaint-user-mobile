import 'package:complaint_user/complaint_details_page.dart';
import 'package:flutter/material.dart';

class ResolvedComplaintPage extends StatelessWidget {
  const ResolvedComplaintPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resolved'), elevation: 0),
      body: ListView.builder(
        itemCount: 18,
        itemBuilder: (context, index) {
          if (index % 2 == 0) {
            return Divider(height: 1);
          }
          return ListTile(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ComplaintDetailsPage('1'))),
            title: Text('Complaint ${index + 1}'),
            subtitle: Text('26 Sep 2022, 4:22 PM'),
            trailing: Icon(Icons.arrow_forward_rounded),
          );
        },
      ),
    );
  }
}
