import 'package:complaint_user/complaint_details_page.dart';
import 'package:complaint_user/models/complaint.dart';
import 'package:flutter/material.dart';

class ResolvedCard extends StatefulWidget {
  const ResolvedCard({Key? key}) : super(key: key);

  @override
  State<ResolvedCard> createState() => _ResolvedCardState();
}

class _ResolvedCardState extends State<ResolvedCard> {
  List<Complaint> complaints = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    // String errorMessage = 'Error to fetch ongoing buy deliver orders';
    // final result = await Server.httpGet(Server.baseUrl, '/order/ongoing', errorMessage);
    // if (result.code == 200) {
    setState(() {
      complaints = [
        Complaint.fromMap({'_id': 'dc', 'title': 'Repair door', 'priority': 'low'}),
        Complaint.fromMap({'_id': 'dc', 'title': 'Clogged drain', 'priority': 'moderate'}),
        Complaint.fromMap({'_id': 'dc', 'title': 'Repair lamp', 'priority': 'high'})
      ];
      //tasks.addAll((result.body as List).map((e) => BuyDeliverOrder.fromMap(e)));
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (complaints.isEmpty) {
      return const SizedBox();
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            color: Colors.green,
            child: Text('Resolved', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
          ...complaints
              .map(
                (e) => Column(
                  children: [
                    Divider(height: 1),
                    ListTile(
                      leading: Text('24 \nSep', textAlign: TextAlign.center),
                      title: Text(e.title!),
                      subtitle: Row(
                        children: [
                          Text('Due in 3 days'),
                          SizedBox(width: 8),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ComplaintDetailsPage(e.id!))),
                    ),
                  ],
                ),
              )
              .toList(),
          Divider(height: 1),
          Align(
            alignment: Alignment.center,
            child: TextButton(onPressed: () {}, child: Text('View more')),
          ),
        ],
      ),
    );
  }
}
