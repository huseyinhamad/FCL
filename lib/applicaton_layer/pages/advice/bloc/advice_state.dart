part of 'advice_bloc.dart';

@immutable
abstract class AdviceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdviceInitial extends AdviceState {}

class AdviceStateLoading extends AdviceState {}

class AdviceStateLoaded extends AdviceState {
  final String advice;

  @override
  List<Object?> get props => [advice];

  AdviceStateLoaded({required this.advice});
}

class AdviceStateError extends AdviceState {
  final String message;

  @override
  List<Object?> get props => [message];

  AdviceStateError({required this.message});
}
