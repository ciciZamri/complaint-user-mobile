import 'package:flutter/material.dart';

class ErrorItem extends StatelessWidget {
  final void Function() onRetry;
  const ErrorItem(this.onRetry, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Something went wrong'),
        OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}