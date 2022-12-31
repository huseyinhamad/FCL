import 'package:equatable/equatable.dart';
import 'package:fcl/domain_layer/failures/failures.dart';
import 'package:fcl/domain_layer/usecases/advice_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advice_state.dart';

const generalFailureMessage = "Ups, something went wrong, please try again";
const serverFailureMessage = "Ups, API Error, please try again";
const cacheFailureMessage = "Ups, cache failed, please try again";

class AdviceCubit extends Cubit<AdviceCubitState> {
  final AdviceUseCases adviceUseCases;
  AdviceCubit({required this.adviceUseCases}) : super(AdviceInitial());

  void adviceRequested() async {
    emit(AdviceStateLoading());
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
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return generalFailureMessage;
    }
  }
}
