part of 'word_learning_bloc.dart';

sealed class WordLearningState extends Equatable {
  final int currentWordIndex; // Artık sabit değil, alt sınıflarda ayarlanacak

  const WordLearningState({this.currentWordIndex = 0});

  @override
  List<Object> get props => [currentWordIndex];
}

final class WordLearningInitial extends WordLearningState {
  const WordLearningInitial() : super(currentWordIndex: 0);
}

final class WordLearningLoading extends WordLearningState {
  const WordLearningLoading({super.currentWordIndex});
}

final class WordLearningLoaded extends WordLearningState {
  final List<WordEntity> words;

  const WordLearningLoaded(this.words, {super.currentWordIndex});

  @override
  List<Object> get props => [words, currentWordIndex];
}

final class WordLearningError extends WordLearningState {
  final String message;

  const WordLearningError(this.message, {super.currentWordIndex});

  @override
  List<Object> get props => [message, currentWordIndex];
}

final class WordLearningLearned extends WordLearningState {
  const WordLearningLearned({super.currentWordIndex});
}

final class WordLearningDeleted extends WordLearningState {
  const WordLearningDeleted({super.currentWordIndex});
}

final class WordLearningDeletedAll extends WordLearningState {
  const WordLearningDeletedAll({super.currentWordIndex});
}

final class WordLearningSpeaking extends WordLearningState {
  final WordEntity spokenWord;

  const WordLearningSpeaking(this.spokenWord, {super.currentWordIndex});

  @override
  List<Object> get props => [spokenWord, currentWordIndex];
}
