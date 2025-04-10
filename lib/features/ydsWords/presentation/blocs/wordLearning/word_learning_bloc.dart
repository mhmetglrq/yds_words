import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../config/constants/word_constants.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../domain/entities/word_entity.dart';
import '../../../domain/usecases/wordLearning/delete_all_learned_words_usecase.dart';
import '../../../domain/usecases/wordLearning/delete_learned_word_usecase.dart';
import '../../../domain/usecases/wordLearning/get_learned_words_usecase.dart';
import '../../../domain/usecases/wordLearning/get_words_usecase.dart';
import '../../../domain/usecases/wordLearning/learn_word_usecase.dart';
import '../../../domain/usecases/wordLearning/speak_word_usecase.dart';

part 'word_learning_event.dart';
part 'word_learning_state.dart';

class WordLearningBloc extends Bloc<WordLearningEvent, WordLearningState> {
  final DeleteAllLearnedWordsUsecase _deleteAllLearnedWordsUsecase;
  final DeleteLearnedWordUsecase _deleteLearnedWordUsecase;
  final GetLearnedWordsUsecase _getLearnedWordsUsecase;
  final GetWordsUseCase _getWordsUseCase;
  final LearnWordUsecase _learnWordUsecase;
  final SpeakWordUsecase _speakWordUsecase;

  WordLearningBloc({
    required DeleteAllLearnedWordsUsecase deleteAllLearnedWordsUsecase,
    required DeleteLearnedWordUsecase deleteLearnedWordUsecase,
    required GetLearnedWordsUsecase getLearnedWordsUsecase,
    required GetWordsUseCase getWordsUseCase,
    required LearnWordUsecase learnWordUsecase,
    required SpeakWordUsecase speakWordUsecase,
  })  : _deleteAllLearnedWordsUsecase = deleteAllLearnedWordsUsecase,
        _deleteLearnedWordUsecase = deleteLearnedWordUsecase,
        _getLearnedWordsUsecase = getLearnedWordsUsecase,
        _getWordsUseCase = getWordsUseCase,
        _learnWordUsecase = learnWordUsecase,
        _speakWordUsecase = speakWordUsecase,
        super(WordLearningInitial(
          selectedWordType: WordConstants.wordTypes.first,
        )) {
    on<LoadWords>(_onLoadWords);
    on<LoadLearnedWords>(_onLoadLearnedWords);
    on<LearnWord>(_onLearnWord);
    on<DeleteLearnedWord>(_onDeleteLearnedWord);
    on<DeleteAllLearnedWords>(_onDeleteAllLearnedWords);
    on<SpeakWord>(_onSpeakWord);
    on<NextWord>(_onNextWord); // Yeni olay
    on<PreviousWord>(_onPreviousWord); // Yeni olay
    on<FilterLearnedWords>(_filterLearnedWords);
    on<ResetLearning>(_resetLearning);
  }

  Future<void> _onLoadWords(
      LoadWords event, Emitter<WordLearningState> emit) async {
    final result = await _getWordsUseCase();
    emit(WordLearningLoading(
        selectedWordType: state.selectedWordType,
        currentWordIndex: state.currentWordIndex,
        words: state.words,
        learnedWords: state.learnedWords,
        filteredLearnedWords: state.filteredLearnedWords));
    if (result is DataSuccess) {
      emit(WordLearningLoaded(
        words: result.data!,
        currentWordIndex: 0,
        learnedWords: state.learnedWords,
        filteredLearnedWords: state.filteredLearnedWords,
        selectedWordType: state.selectedWordType,
      ));
    } else if (result is DataFailed) {
      emit(
        WordLearningError(
          result.message ?? "",
          selectedWordType: state.selectedWordType,
          currentWordIndex: state.currentWordIndex,
          filteredLearnedWords: state.filteredLearnedWords,
          learnedWords: state.learnedWords,
          words: state.words,
        ),
      );
    }
  }

  Future<void> _onLoadLearnedWords(
      LoadLearnedWords event, Emitter<WordLearningState> emit) async {
    emit(WordLearningLoading(
      currentWordIndex: state.currentWordIndex,
      words: state.words,
      learnedWords: state.learnedWords,
      filteredLearnedWords: state.filteredLearnedWords,
      selectedWordType: state.selectedWordType,
    ));
    final result = await _getLearnedWordsUsecase();
    if (result is DataSuccess) {
      emit(WordLearningLoaded(
        words: state.words,
        currentWordIndex: state.currentWordIndex,
        learnedWords: result.data!,
        filteredLearnedWords: state.filteredLearnedWords,
        selectedWordType: state.selectedWordType,
      ));
    } else if (result is DataFailed) {
      emit(WordLearningError(result.message ?? "",
          currentWordIndex: state.currentWordIndex,
          words: state.words,
          learnedWords: state.learnedWords,
          filteredLearnedWords: state.filteredLearnedWords,
          selectedWordType: state.selectedWordType));
    }
  }

  Future<void> _onLearnWord(
      LearnWord event, Emitter<WordLearningState> emit) async {
    emit(WordLearningLoading(
        currentWordIndex: state.currentWordIndex,
        words: state.words,
        learnedWords: state.learnedWords,
        filteredLearnedWords: state.filteredLearnedWords,
        selectedWordType: state.selectedWordType));
    final result = await _learnWordUsecase.call(params: event.word);
    if (result is DataSuccess) {
      emit(WordLearningLearned(
          currentWordIndex: state.currentWordIndex,
          words: state.words,
          learnedWords: state.learnedWords,
          filteredLearnedWords: state.filteredLearnedWords,
          selectedWordType: state.selectedWordType));
      add(LoadLearnedWords());
    } else if (result is DataFailed) {
      emit(WordLearningError(
        result.message ?? "",
        currentWordIndex: state.currentWordIndex,
        words: state.words,
        learnedWords: state.learnedWords,
        filteredLearnedWords: state.filteredLearnedWords,
        selectedWordType: state.selectedWordType,
      ));
    }
  }

  Future<void> _onDeleteLearnedWord(
      DeleteLearnedWord event, Emitter<WordLearningState> emit) async {
    emit(WordLearningLoading(
        currentWordIndex: state.currentWordIndex,
        learnedWords: state.learnedWords,
        words: state.words,
        filteredLearnedWords: state.filteredLearnedWords,
        selectedWordType: state.selectedWordType));
    final result = await _deleteLearnedWordUsecase.call(params: event.word);
    if (result is DataSuccess) {
      emit(WordLearningDeleted(
          currentWordIndex: state.currentWordIndex,
          learnedWords: state.learnedWords,
          words: state.words,
          filteredLearnedWords: state.filteredLearnedWords,
          selectedWordType: state.selectedWordType));
      add(LoadLearnedWords());
    } else if (result is DataFailed) {
      emit(WordLearningError(result.message ?? "",
          currentWordIndex: state.currentWordIndex,
          words: state.words,
          learnedWords: state.learnedWords,
          filteredLearnedWords: state.filteredLearnedWords,
          selectedWordType: state.selectedWordType));
    }
  }

  Future<void> _onDeleteAllLearnedWords(
      DeleteAllLearnedWords event, Emitter<WordLearningState> emit) async {
    emit(WordLearningLoading(
        currentWordIndex: state.currentWordIndex,
        words: state.words,
        learnedWords: state.learnedWords,
        filteredLearnedWords: state.filteredLearnedWords,
        selectedWordType: state.selectedWordType));
    final result = await _deleteAllLearnedWordsUsecase();
    if (result is DataSuccess) {
      emit(WordLearningDeletedAll(currentWordIndex: 0));
      add(LoadLearnedWords());
    } else if (result is DataFailed) {
      emit(WordLearningError(result.message ?? "",
          currentWordIndex: state.currentWordIndex,
          words: state.words,
          learnedWords: state.learnedWords,
          filteredLearnedWords: state.filteredLearnedWords,
          selectedWordType: state.selectedWordType));
    }
  }

  Future<void> _onSpeakWord(
      SpeakWord event, Emitter<WordLearningState> emit) async {
    emit(WordLearningSpeaking(event.word,
        currentWordIndex: state.currentWordIndex,
        words: state.words,
        learnedWords: state.learnedWords,
        filteredLearnedWords: state.filteredLearnedWords,
        selectedWordType: state.selectedWordType));
    String? params = event.word.word;
    if (event.isExample) {
      params = event.word.exampleSentence;
    }
    final result = await _speakWordUsecase.call(params: params);
    if (result is DataSuccess) {
      if (state is WordLearningLoaded) {
        emit(WordLearningLoaded(
            words: (state as WordLearningLoaded).words,
            currentWordIndex: state.currentWordIndex,
            learnedWords: state.learnedWords,
            filteredLearnedWords: state.filteredLearnedWords,
            selectedWordType: state.selectedWordType));
      } else {
        emit(WordLearningInitial());
      }
    } else if (result is DataFailed) {
      emit(WordLearningError(result.message ?? "",
          currentWordIndex: state.currentWordIndex,
          words: state.words,
          learnedWords: state.learnedWords,
          filteredLearnedWords: state.filteredLearnedWords,
          selectedWordType: state.selectedWordType));
    }
  }

  Future<void> _onNextWord(
      NextWord event, Emitter<WordLearningState> emit) async {
    if (state is WordLearningLoaded) {
      final loadedState = state as WordLearningLoaded;
      final nextIndex = loadedState.currentWordIndex + 1;
      if (nextIndex < loadedState.words.length) {
        add(LearnWord(loadedState.words[state.currentWordIndex]));
        emit(WordLearningLoaded(
            words: loadedState.words,
            currentWordIndex: nextIndex,
            learnedWords: loadedState.learnedWords,
            filteredLearnedWords: loadedState.filteredLearnedWords,
            selectedWordType: loadedState.selectedWordType));
      }
    }
  }

  Future<void> _onPreviousWord(
      PreviousWord event, Emitter<WordLearningState> emit) async {
    if (state is WordLearningLoaded) {
      final loadedState = state as WordLearningLoaded;
      final prevIndex = loadedState.currentWordIndex - 1;
      if (prevIndex >= 0) {
        emit(WordLearningLoaded(
          words: loadedState.words,
          currentWordIndex: prevIndex,
          learnedWords: loadedState.learnedWords,
          filteredLearnedWords: loadedState.filteredLearnedWords,
          selectedWordType: loadedState.selectedWordType,
        ));
      }
    }
  }

  Future<void> _filterLearnedWords(
      FilterLearnedWords event, Emitter<WordLearningState> emit) async {
    List<WordEntity> filteredWords = [];
    if (event.wordType != null) {
      if (event.wordType == WordConstants.wordTypes.first) {
        filteredWords = state.learnedWords;
      } else {
        filteredWords = state.learnedWords
            .where((element) => event.wordType!
                .toLowerCase()
                .contains(element.type.toLowerCase()))
            .toList();
      }
    } else if (event.wordType == null) {
      filteredWords = state.learnedWords;
    }
    emit(WordLearningLoaded(
      words: state.words,
      currentWordIndex: state.currentWordIndex,
      learnedWords: state.learnedWords,
      filteredLearnedWords: filteredWords,
      selectedWordType: event.wordType ?? WordConstants.wordTypes.first,
    ));
  }

  Future<void> _resetLearning(
      ResetLearning event, Emitter<WordLearningState> emit) async {
    emit(WordLearningLoaded(
      words: state.words,
      currentWordIndex: 0,
      learnedWords: state.learnedWords,
      filteredLearnedWords: state.filteredLearnedWords,
      selectedWordType: state.selectedWordType,
    ));
    add(LoadWords());
  }
}
