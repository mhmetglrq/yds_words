import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/test_question_entity.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../domain/usecases/question/generate_test_questions_usecase.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final GenerateTestQuestionsUsecase _generateQuestionsUseCase;
  final List<TestQuestionEntity> _questions = [];
  int _correctAnswerCount = 0;

  QuestionBloc(this._generateQuestionsUseCase)
      : super(const QuestionInitial()) {
    on<QuestionStarted>(_onQuestionStarted);
    on<QuestionAnswered>(_onQuestionAnswered);
    on<QuestionNext>(_onQuestionNext);
  }

  Future<void> _onQuestionStarted(
      QuestionStarted event, Emitter<QuestionState> emit) async {
    emit(const QuestionLoading());

    final result = await _generateQuestionsUseCase(params: event.questionType);

    if (result is DataSuccess<List<TestQuestionEntity>>) {
      _questions
        ..clear()
        ..addAll(result.data ?? []);
      _correctAnswerCount = 0;

      emit(QuestionAnswering(
        questions: _questions,
        currentIndex: 0,
        correctAnswerCount: _correctAnswerCount,
      ));
    } else {
      emit(QuestionError(result.message ?? "Bilinmeyen bir hata oluştu"));
    }
  }

  void _onQuestionAnswered(
      QuestionAnswered event, Emitter<QuestionState> emit) {
    final currentState = state;
    if (currentState is QuestionAnswering) {
      final currentQuestion = currentState.questions[currentState.currentIndex];
      final isCorrect = currentQuestion.correctIndex == event.selectedIndex;

      if (isCorrect) _correctAnswerCount += 1;

      emit(QuestionAnswering(
        questions: currentState.questions,
        currentIndex: currentState.currentIndex,
        selectedOptionIndex: event.selectedIndex,
        isAnswered: true,
        correctAnswerCount: _correctAnswerCount,
      ));

      Future.delayed(const Duration(milliseconds: 700), () {
        add(const QuestionNext());
      });
    }
  }

  void _onQuestionNext(QuestionNext event, Emitter<QuestionState> emit) {
    final currentState = state;
    if (currentState is QuestionAnswering) {
      final nextIndex = currentState.currentIndex + 1;

      if (nextIndex < currentState.questions.length) {
        emit(QuestionAnswering(
          questions: currentState.questions,
          currentIndex: nextIndex,
          correctAnswerCount: _correctAnswerCount,
        ));
      } else {
        emit(QuestionLoaded(
          currentState.questions,
          correctAnswerCount: _correctAnswerCount,
        ));
      }
    }
  }
}
