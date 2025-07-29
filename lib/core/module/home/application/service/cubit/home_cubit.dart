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

      final Prompt data = promptList.firstWhere(
        (Prompt prompt) =>
            !plusThrees.contains(prompt) &&
            !plusOnes.contains(prompt) &&
            !minusOnes.contains(prompt),
        orElse: () => throw Exception('No available prompts left'),
      );

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
