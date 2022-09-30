import 'package:complaint_user/widgets/images_carousel.dart';
import 'package:flutter/material.dart';

class ComplaintDetailsPage extends StatefulWidget {
  final String id;
  const ComplaintDetailsPage(this.id, {Key? key}) : super(key: key);

  @override
  State<ComplaintDetailsPage> createState() => _ComplaintDetailsPageState();
}

class _ComplaintDetailsPageState extends State<ComplaintDetailsPage> {
  Widget _item(String label, String child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(child),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text('THLK-55673'),
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey.shade600,
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Reply'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Stack(
              children: [
                ListView(
                  children: [
                    ImagesCarousel(
                      height: 300,
                      images: [
                        'https://storage.googleapis.com/sandbox99images/image_1.jpeg',
                        'https://storage.googleapis.com/sandbox99images/image_2.jpeg',
                        'https://storage.googleapis.com/sandbox99images/image_3.jpeg'
                      ],
                    ),
                    _item('Title', 'Broken door'),
                    _item('Description', 'dscedk icwdjsficdws widfjicwd cwid'),
                    _item('Category', 'Broken asset'),
                    _item('Location', 'IAT, Level 2, Block C, KICT'),
                    _item('Status', 'pending'),
                    _item('Submitted at', '24 Sep 2022, 5:30 PM'),
                    Divider(),
                    _item('Supervisor', 'Ahmad Umar bin Rahim'),
                    _item('Action', 'Repair door'),
                    _item('Due date', '30 Sep 2022'),
                    SizedBox(height: 96),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ElevatedButton(
                      style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width - 24, 56))),
                      onPressed: () {},
                      child: Text('Supervisor has arrived'),
                    ),
                  ),
                )
              ],
            ),
            Text('Reply')
          ],
        ),
      ),
    );
  }
}
