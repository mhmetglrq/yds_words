part of 'word_learning_bloc.dart';

sealed class WordLearningState extends Equatable {
  final int currentWordIndex; // Artık sabit değil, alt sınıflarda ayarlanacak
  final List<WordEntity> words;
  final List<WordEntity> learnedWords;
  final List<WordEntity> filteredLearnedWords;
  final String selectedWordType;

  const WordLearningState(
      {this.currentWordIndex = 0,
      this.words = const [],
      this.learnedWords = const [],
      this.filteredLearnedWords = const [],
      this.selectedWordType = "All (Hepsi)"});

  @override
  List<Object> get props => [
        currentWordIndex,
        words,
        learnedWords,
        filteredLearnedWords,
        selectedWordType
      ];
}

final class WordLearningInitial extends WordLearningState {
  const WordLearningInitial({
    super.selectedWordType,
    super.learnedWords,
    super.filteredLearnedWords,
    super.words,
    super.currentWordIndex,
  });
}

final class WordLearningLoading extends WordLearningState {
  const WordLearningLoading({
    super.currentWordIndex,
    super.words,
    super.learnedWords,
    super.filteredLearnedWords,
    super.selectedWordType,
  });
}

final class WordLearningLoaded extends WordLearningState {
  const WordLearningLoaded({
    super.currentWordIndex,
    super.words,
    super.learnedWords,
    super.filteredLearnedWords,
    super.selectedWordType,
  });
}

final class WordLearningError extends WordLearningState {
  final String message;

  const WordLearningError(
    this.message, {
    super.currentWordIndex,
    super.words,
    super.learnedWords,
    super.filteredLearnedWords,
    super.selectedWordType,
  });

  @override
  List<Object> get props => [
        message,
        currentWordIndex,
        words,
        learnedWords,
        filteredLearnedWords,
        selectedWordType
      ];
}

final class WordLearningLearned extends WordLearningLoaded {
  const WordLearningLearned({
    super.currentWordIndex,
    super.words,
    super.learnedWords,
    super.filteredLearnedWords,
    super.selectedWordType,
  });
}

final class WordLearningDeleted extends WordLearningState {
  const WordLearningDeleted({
    super.currentWordIndex,
    super.learnedWords,
    super.words,
    super.filteredLearnedWords,
    super.selectedWordType,
  });
}

final class WordLearningDeletedAll extends WordLearningState {
  const WordLearningDeletedAll({
    super.currentWordIndex,
    super.words,
    super.learnedWords,
    super.filteredLearnedWords,
    super.selectedWordType,
  });
}

final class WordLearningSpeaking extends WordLearningLoaded {
  final WordEntity spokenWord;

  const WordLearningSpeaking(
    this.spokenWord, {
    super.currentWordIndex,
    super.words,
    super.learnedWords,
    super.filteredLearnedWords,
    super.selectedWordType,
  });

  @override
  List<Object> get props => [
        spokenWord,
        currentWordIndex,
        words,
        learnedWords,
        filteredLearnedWords,
        selectedWordType
      ];
}
