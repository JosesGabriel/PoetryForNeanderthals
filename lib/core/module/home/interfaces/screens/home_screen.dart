import 'package:flirt/core/module/home/interfaces/widgets/card_container.dart';
import 'package:flirt/core/module/home/interfaces/widgets/prompt_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5EC),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PromptCard(),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Icons.undo_rounded),
                  )
                ],
              ),
            ),
            const Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CardContainer(color: Color(0xFF95E1D3), title: '+3'),
                  CardContainer(color: Color(0xFFFCE38A), title: '+1'),
                  CardContainer(color: Color(0xFFF38181), title: '-1'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
