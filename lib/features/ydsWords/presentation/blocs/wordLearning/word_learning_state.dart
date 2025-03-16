part of 'word_learning_bloc.dart';

sealed class WordLearningState extends Equatable {
  final int currentWordIndex; // Artık sabit değil, alt sınıflarda ayarlanacak
  final List<WordEntity> words;
  final List<WordEntity> learnedWords;

  const WordLearningState(
      {this.currentWordIndex = 0,
      this.words = const [],
      this.learnedWords = const []});

  @override
  List<Object> get props => [currentWordIndex, words, learnedWords];
}

final class WordLearningInitial extends WordLearningState {
  WordLearningInitial()
      : super(currentWordIndex: 0, words: [], learnedWords: []);
}

final class WordLearningLoading extends WordLearningState {
  const WordLearningLoading(
      {super.currentWordIndex, super.words, super.learnedWords});
}

final class WordLearningLoaded extends WordLearningState {
  const WordLearningLoaded(
      {super.currentWordIndex, super.words, super.learnedWords});

  @override
  List<Object> get props => [words, currentWordIndex, learnedWords];
}

final class WordLearningError extends WordLearningState {
  final String message;

  const WordLearningError(this.message, {super.currentWordIndex});

  @override
  List<Object> get props => [message, currentWordIndex];
}

final class WordLearningLearned extends WordLearningLoaded {
  const WordLearningLearned(
      {super.currentWordIndex, super.words, super.learnedWords});
}

final class WordLearningDeleted extends WordLearningState {
  const WordLearningDeleted({super.currentWordIndex});
}

final class WordLearningDeletedAll extends WordLearningState {
  const WordLearningDeletedAll({super.currentWordIndex});
}

final class WordLearningSpeaking extends WordLearningLoaded {
  final WordEntity spokenWord;

  const WordLearningSpeaking(this.spokenWord,
      {super.currentWordIndex, super.words, super.learnedWords});

  @override
  List<Object> get props => [spokenWord, currentWordIndex];
}
