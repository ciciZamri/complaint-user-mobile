import 'package:flutter/material.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({Key? key}) : super(key: key);
  
  Widget get fullStar => Icon(Icons.star_rate_rounded, color: Colors.yellow.shade700);
  Widget get halfStar => Icon(Icons.star_half_rounded, color: Colors.yellow.shade700);
  Widget get emptyStar => Icon(Icons.star_outline_rounded, color: Colors.yellow.shade700);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(radius: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Muhammad Arif bin Karim', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Text('Lecturer'),
                  ],
                )
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Pending'),
                      SizedBox(height: 8),
                      Text('1', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(height: 64, width: 2, color: Colors.grey.shade300),
                Expanded(
                  child: Column(
                    children: [
                      Text('Completed'),
                      SizedBox(height: 8),
                      Text('5', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}