part of 'question_bloc.dart';

sealed class QuestionEvent extends Equatable {
  const QuestionEvent();

  @override
  List<Object> get props => [];
}

class QuestionStarted extends QuestionEvent {
  final TestQuestionType questionType;

  const QuestionStarted(this.questionType);

  @override
  List<Object> get props => [questionType];
}

class QuestionAnswered extends QuestionEvent {
  final int selectedIndex;

  const QuestionAnswered(this.selectedIndex);

  @override
  List<Object> get props => [selectedIndex];
}

class QuestionNext extends QuestionEvent {
  const QuestionNext();
}
