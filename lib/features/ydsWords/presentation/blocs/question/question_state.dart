part of 'question_bloc.dart';

abstract class QuestionState extends Equatable {
  const QuestionState({this.correctAnswerCount = 0});
  final int correctAnswerCount;

  @override
  List<Object?> get props => [correctAnswerCount];
}

class QuestionInitial extends QuestionState {
  const QuestionInitial({super.correctAnswerCount});
}

class QuestionLoading extends QuestionState {
  const QuestionLoading({super.correctAnswerCount});
}

class QuestionLoaded extends QuestionState {
  final List<TestQuestionEntity> questions;

  const QuestionLoaded(this.questions, {super.correctAnswerCount});

  @override
  List<Object?> get props => [questions, correctAnswerCount];
}

class QuestionError extends QuestionState {
  final String message;

  const QuestionError(this.message, {super.correctAnswerCount});

  @override
  List<Object?> get props => [message, correctAnswerCount];
}

class QuestionAnswering extends QuestionState {
  final List<TestQuestionEntity> questions;
  final int currentIndex;
  final int? selectedOptionIndex;
  final bool isAnswered;

  const QuestionAnswering({
    required this.questions,
    this.currentIndex = 0,
    this.selectedOptionIndex,
    this.isAnswered = false,
    super.correctAnswerCount,
  });

  @override
  List<Object?> get props =>
      [questions, currentIndex, selectedOptionIndex, isAnswered, correctAnswerCount];
}
