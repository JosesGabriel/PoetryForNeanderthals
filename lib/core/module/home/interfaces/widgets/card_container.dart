import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({required this.color, required this.title, super.key});
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card.filled(
        color: color,
        margin: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
