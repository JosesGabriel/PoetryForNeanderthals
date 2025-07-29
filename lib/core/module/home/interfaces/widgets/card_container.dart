import 'package:flirt/core/module/home/application/service/cubit/home_cubit.dart';
import 'package:flirt/core/module/home/application/service/cubit/home_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    required this.color,
    required this.title,
    required this.onTap,
    super.key,
  });
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card.filled(
        color: color,
        margin: const EdgeInsets.all(20),
        child: InkWell(
          onTap: onTap,
          splashColor: const Color(0xFF00809D),
          borderRadius: BorderRadius.circular(12),
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
              BlocBuilder<HomeCubit, HomeState>(
                buildWhen: (HomeState previous, HomeState current) =>
                    current is FetchScoredWordsSuccess,
                builder: (BuildContext context, HomeState state) {
                  if (state is FetchScoredWordsSuccess) {
                    final List<Prompt> data = <Prompt>[];
                    switch (title) {
                      case '+3':
                        data.addAll(state.three);
                      case '+1':
                        data.addAll(state.one);
                      case '-1':
                        data.addAll(state.minusOne);
                      default:
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 4,
                        children: <Widget>[
                          for (final Prompt item in data)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.3),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(15),
                              margin:
                                  const EdgeInsets.only(bottom: 5, right: 8),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    item.one,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 70,
                                    child: Divider(
                                      color: Colors.grey.withAlpha(50),
                                    ),
                                  ),
                                  Text(
                                    item.three,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
