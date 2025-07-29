import 'package:flirt/core/domain/models/api_error_response.dart';
import 'package:flirt/internal/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  Future<void> fetchQuote() async {
    try {
      emit(FetchQuoteLoading());

      emit(FetchQuoteSuccess(''));
    } on APIErrorResponse catch (error) {
      emit(
        FetchQuoteFailed(
          errorCode: error.errorCode!,
          message: error.message,
        ),
      );
    } catch (e, stackTrace) {
      logError(e, stackTrace);

      emit(
        FetchQuoteFailed(
          errorCode: '$e',
          message: 'Something went wrong.',
        ),
      );
    }
  }
}
