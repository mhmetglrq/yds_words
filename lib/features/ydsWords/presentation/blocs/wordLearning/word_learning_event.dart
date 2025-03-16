part of 'word_learning_bloc.dart';

sealed class WordLearningEvent extends Equatable {
  const WordLearningEvent();

  @override
  List<Object> get props => [];
}

class LoadWords extends WordLearningEvent {}

class LoadLearnedWords extends WordLearningEvent {}

class LearnWord extends WordLearningEvent {
  final WordEntity word;
  const LearnWord(this.word);
  @override
  List<Object> get props => [word];
}

class DeleteLearnedWord extends WordLearningEvent {
  final WordEntity word;
  const DeleteLearnedWord(this.word);
  @override
  List<Object> get props => [word];
}

class DeleteAllLearnedWords extends WordLearningEvent {}

class SpeakWord extends WordLearningEvent {
  final WordEntity word;
  const SpeakWord(this.word);
  @override
  List<Object> get props => [word];
}

class NextWord extends WordLearningEvent {} // Yeni olay

class PreviousWord extends WordLearningEvent {} // Yeni olay

class FilterLearnedWords extends WordLearningEvent {
  final String wordType;
  const FilterLearnedWords(this.wordType);
  @override
  List<Object> get props => [wordType];
}
