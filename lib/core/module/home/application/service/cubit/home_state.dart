part of 'home_cubit.dart';

class HomeState {
  HomeState();
}

class FetchQuoteLoading extends HomeState {}

class FetchQuoteSuccess extends HomeState {
  FetchQuoteSuccess(this.color);

  final String color;
}

class FetchQuoteFailed extends HomeState {
  FetchQuoteFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
