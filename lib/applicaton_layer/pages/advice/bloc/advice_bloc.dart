import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'advice_event.dart';
part 'advice_state.dart';

class AdviceBloc extends Bloc<AdviceEvent, AdviceState> {
  AdviceBloc() : super(AdviceInitial()) {
    on<AdviceRequestedEvent>((event, emit) async {
      emit(AdviceStateLoading());

      debugPrint("fake get advice triggred");
      await Future.delayed(const Duration(seconds: 3), () {});
      debugPrint("fake got advice");

      // emit(AdviceStateLoaded(advice: "fake advice to test bloc"));
      emit(AdviceStateError(message: "error message"));
    });
  }
}
