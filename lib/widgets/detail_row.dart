import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  const DetailRow({
    Key? key,
    required this.displayicon,
    required this.labeltext,
    required this.contenttext,
  }) : super(key: key);

  final Icon displayicon;
  final String labeltext;
  final String contenttext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  labeltext,
                  style: const TextStyle(fontSize: 16.0),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      contenttext,
                      maxLines: 25,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DetailRowForIcon extends StatelessWidget {
  const DetailRowForIcon({
    Key? key,
    required this.displayicon,
    required this.labeltext,
    required this.contenticon,
  }) : super(key: key);

  final Icon displayicon;
  final String labeltext;
  final Icon contenticon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                displayicon,
                Text(
                  labeltext,
                  style: const TextStyle(fontSize: 16.0),
                ),
                contenticon,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
