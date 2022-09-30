import 'package:flutter/material.dart';

class DialogMenuButton extends StatelessWidget {
  final String label;
  final Widget value;
  final String dialogTitle;
  final List<Widget> dialogContent;
  final Function(dynamic) onSubmitted;
  final Widget? trailIcon;
  final bool scrollable;
  final bool centerTitle;
  const DialogMenuButton({
    Key? key,
    required this.value,
    required this.label,
    required this.dialogTitle,
    required this.dialogContent,
    required this.onSubmitted,
    this.trailIcon,
    this.scrollable = false,
    this.centerTitle = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(dialogTitle, textAlign: centerTitle ? TextAlign.center : TextAlign.start),
                content: scrollable
                    ? SizedBox(
                        height: double.maxFinite,
                        width: MediaQuery.of(context).size.height - 200,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return dialogContent[index];
                          },
                          itemCount: dialogContent.length,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: dialogContent,
                      ),
              );
            },
          ).then((value) {
            if (value != null) {
              onSubmitted(value);
            }
          });
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [value, trailIcon ?? Icon(Icons.keyboard_arrow_down_rounded)],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Container(
                  color: Colors.grey.shade50,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
