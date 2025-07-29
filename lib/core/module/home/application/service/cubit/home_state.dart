part of 'home_cubit.dart';

class HomeState {
  HomeState();
}

class UpdatePointsLoading extends HomeState {}

class UpdatePointsSuccess extends HomeState {
  UpdatePointsSuccess(this.points);

  final String points;
}

class UpdatePointsFailed extends HomeState {
  UpdatePointsFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class FetchPromptLoading extends HomeState {}

class FetchPromptSuccess extends HomeState {
  FetchPromptSuccess(this.data);

  final Prompt data;
}

class FetchPromptFailed extends HomeState {
  FetchPromptFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class FetchScoredWordsSuccess extends HomeState {
  FetchScoredWordsSuccess({
    required this.three,
    required this.one,
    required this.minusOne,
  });

  final List<Prompt> three;
  final List<Prompt> one;
  final List<Prompt> minusOne;
}
