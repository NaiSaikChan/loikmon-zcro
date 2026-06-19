import 'package:flutter/material.dart';

class EmptyListScreen extends StatelessWidget {
  final String message;

  const EmptyListScreen({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                //fontFamily: 'style1',
              ),
            )),
      ),
    );
  }
}
