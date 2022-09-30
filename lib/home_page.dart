import 'dart:math';
import 'package:complaint_user/complaint_form.dart';
import 'package:complaint_user/resolved_card.dart';
import 'package:flutter/material.dart';
import 'package:complaint_user/home_page_header.dart';
import 'package:complaint_user/ongoing_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  ValueNotifier<double> opacity = ValueNotifier(1.0);

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      opacity.value = max(1 - controller.offset / 100, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade50,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ComplaintForm())),
            label: Text('Submit complaint'),
            icon: Icon(Icons.add_rounded),
          ),
          body: Stack(
            children: [
              ValueListenableBuilder(
                valueListenable: opacity,
                builder: (context, double val, _) {
                  return CustomPaint(
                    painter: Background(val, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                  );
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      children: [
                        Card(
                          color: Colors.green.shade50,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          //margin: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12, bottom: 0),
                          child: InkWell(
                            onTap: () {}, // () => Navigator.push(context, MaterialPageRoute(builder: (_) => SelectCampusPage(() {}))),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_city_rounded),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('IIUM, Gombak', maxLines: 1)),
                                  //const Icon(Icons.chevron_right_rounded),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const HomePageHeader(),
                        SizedBox(height: 8),
                        const OngoingCard(),
                        SizedBox(height: 6),
                        const ResolvedCard(),
                        SizedBox(height: 96),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Background extends CustomPainter {
  final double width;
  final double height;
  final double opacity;
  Background(this.opacity, this.width, this.height);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.green.withOpacity(opacity);
    paint.style = PaintingStyle.fill;
    canvas.drawOval(Rect.fromCenter(center: Offset(width / 2, 0), width: width * 1.9, height: height / 1.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
