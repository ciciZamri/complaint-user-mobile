import 'package:flutter/material.dart';

class ImagesCarousel extends StatefulWidget {
  final double height;
  final List<String> images;
  ImagesCarousel({required this.height, required this.images});
  @override
  _ImagesCarouselState createState() => _ImagesCarouselState();
}

class _ImagesCarouselState extends State<ImagesCarousel> {
  late PageController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: index, keepPage: false, viewportFraction: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.grey[100],
          // padding: EdgeInsets.only(top: 52.0, bottom: 24.0),
          height: widget.height,
          child: PageView.builder(
            itemCount: widget.images.length,
            itemBuilder: (context, i) {
              return Image.network(widget.images[i], fit: BoxFit.contain);
            },
            controller: controller,
            onPageChanged: (val) {
              setState(() {
                index = val;
              });
            },
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Text('${index+1}/${widget.images.length}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}