import 'package:equatable/equatable.dart';
import 'package:fcl/applicaton_layer/core/constants/api_constants.dart';
import 'package:fcl/domain_layer/failures/failures.dart';
import 'package:fcl/domain_layer/usecases/advice_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advice_state.dart';

class AdviceCubit extends Cubit<AdviceCubitState> {
  final AdviceUseCases adviceUseCases;
  AdviceCubit({required this.adviceUseCases}) : super(const AdviceInitial());

  void adviceRequested() async {
    emit(const AdviceStateLoading());
    final failureOrAdvice = await adviceUseCases.getAdvice();

    failureOrAdvice.fold(
      (failure) =>
          emit(AdviceStateError(message: _mapFailureToMessage(failure))),
      (advice) => emit(AdviceStateLoaded(advice: advice.advice)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return ApiConstants.serverFailureMessage;
      case CacheFailure:
        return ApiConstants.cacheFailureMessage;
      default:
        return ApiConstants.generalFailureMessage;
    }
  }
}
