import 'dart:math';

import 'package:flirt/core/domain/models/api_error_response.dart';
import 'package:flirt/core/module/home/application/service/cubit/home_dto.dart';
import 'package:flirt/internal/prompts.dart';
import 'package:flirt/internal/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  int roundPoints = 0;

  List<Prompt> plusThrees = <Prompt>[];
  List<Prompt> plusOnes = <Prompt>[];
  List<Prompt> minusOnes = <Prompt>[];

  Future<void> newGame() async {
    try {
      emit(NewGameLoading());

      roundPoints = 0;

      plusOnes.clear();
      plusThrees.clear();
      minusOnes.clear();

      fetchPrompt();
      fetchScoredWords();

      emit(NewGameSuccess());
    } on APIErrorResponse catch (error) {
      emit(
        NewGameFailed(
          errorCode: error.errorCode!,
          message: error.message,
        ),
      );
    } catch (e, stackTrace) {
      logError(e, stackTrace);

      emit(
        NewGameFailed(
          errorCode: '$e',
          message: 'Something went wrong.',
        ),
      );
    }
  }

  Future<void> updatePoints({
    required int score,
    required Prompt currentPrompt,
  }) async {
    try {
      emit(UpdatePointsLoading());

      roundPoints += score;

      switch (score) {
        case 3:
          plusThrees.add(currentPrompt);
        case 1:
          plusOnes.add(currentPrompt);
        case -1:
          minusOnes.add(currentPrompt);
      }

      fetchPrompt();
      fetchScoredWords();

      emit(UpdatePointsSuccess(roundPoints.toString()));
    } on APIErrorResponse catch (error) {
      emit(
        UpdatePointsFailed(
          errorCode: error.errorCode!,
          message: error.message,
        ),
      );
    } catch (e, stackTrace) {
      logError(e, stackTrace);

      emit(
        UpdatePointsFailed(
          errorCode: '$e',
          message: 'Something went wrong.',
        ),
      );
    }
  }

  Future<void> fetchPrompt() async {
    try {
      emit(FetchPromptLoading());

      // Filter prompts based on your conditions
      final List<Prompt> availablePrompts = promptList
          .where(
            (Prompt prompt) =>
                !plusThrees.contains(prompt) &&
                !plusOnes.contains(prompt) &&
                !minusOnes.contains(prompt),
          )
          .toList();

      if (availablePrompts.isEmpty) {
        throw Exception('No available prompts left');
      }

      // Pick a random prompt from the filtered list
      final Random random = Random();
      final Prompt data =
          availablePrompts[random.nextInt(availablePrompts.length)];

      emit(FetchPromptSuccess(data));
    } on APIErrorResponse catch (error) {
      emit(
        FetchPromptFailed(
          errorCode: error.errorCode!,
          message: error.message,
        ),
      );
    } catch (e, stackTrace) {
      logError(e, stackTrace);

      emit(
        FetchPromptFailed(
          errorCode: '$e',
          message: 'Something went wrong.',
        ),
      );
    }
  }

  Future<void> fetchScoredWords() async {
    emit(
      FetchScoredWordsSuccess(
        three: plusThrees,
        one: plusOnes,
        minusOne: minusOnes,
      ),
    );
  }
}
