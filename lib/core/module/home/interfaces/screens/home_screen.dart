import 'package:flirt/core/module/home/application/service/cubit/home_cubit.dart';
import 'package:flirt/core/module/home/application/service/cubit/home_dto.dart';
import 'package:flirt/core/module/home/interfaces/widgets/card_container.dart';
import 'package:flirt/core/module/home/interfaces/widgets/prompt_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Prompt currentPrompt;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchPrompt();
  }

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
                children: <Widget>[
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (HomeState previous, HomeState current) =>
                        current is UpdatePointsSuccess,
                    builder: (BuildContext context, HomeState state) {
                      if (state is UpdatePointsSuccess) {
                        return Text(
                          'Score: ${state.points}',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return const Text(
                        'Score: 0',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (HomeState previous, HomeState current) =>
                        current is FetchPromptSuccess,
                    builder: (BuildContext context, HomeState state) {
                      if (state is FetchPromptSuccess) {
                        currentPrompt = state.data;
                        return PromptCard(data: state.data);
                      }
                      return PromptCard(
                        data: Prompt(one: '', three: ''),
                      );
                    },
                  ),
                  TextButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.teal),
                    ),
                    label: const Text(
                      'New Game',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CardContainer(
                    onTap: () {
                      context.read<HomeCubit>().updatePoints(
                            currentPrompt: currentPrompt,
                            score: 3,
                          );
                    },
                    color: const Color(0xFF95E1D3),
                    title: '+3',
                  ),
                  CardContainer(
                    onTap: () {
                      context.read<HomeCubit>().updatePoints(
                            currentPrompt: currentPrompt,
                            score: 1,
                          );
                    },
                    color: const Color(0xFFFCE38A),
                    title: '+1',
                  ),
                  CardContainer(
                    onTap: () {
                      context.read<HomeCubit>().updatePoints(
                            currentPrompt: currentPrompt,
                            score: -1,
                          );
                    },
                    color: const Color(0xFFF38181),
                    title: '-1',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
