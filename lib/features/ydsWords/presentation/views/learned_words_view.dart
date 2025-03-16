import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yds_words/config/constants/word_constants.dart';
import 'package:yds_words/config/extensions/context_extension.dart';
import 'package:yds_words/features/ydsWords/presentation/blocs/wordLearning/word_learning_bloc.dart';

class LearnedWordsView extends StatelessWidget {
  const LearnedWordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Öğrendiğim Kelimeler"),
      ),
      body: SafeArea(
        child: Padding(
          padding: context.paddingDefault,
          child: Column(
            children: [
              Padding(
                padding: context.paddingVerticalLow,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: double.infinity,
                    maxHeight: context.heightPercentage(0.075),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: WordConstants.wordTypes.length,
                    itemBuilder: (BuildContext context, int index) {
                      final wordType = WordConstants.wordTypes[index];
                      return InkWell(
                        onTap: () => context
                            .read<WordLearningBloc>()
                            .add(FilterLearnedWords(wordType)),
                        borderRadius: BorderRadius.circular(10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: context.paddingDefault,
                            child: Center(
                              child: Text(wordType,
                                  style: context.textTheme.titleSmall),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              BlocBuilder<WordLearningBloc, WordLearningState>(
                builder: (context, state) {
                  if (state is WordLearningInitial ||
                      state is WordLearningLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is WordLearningLoaded) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.filteredLearnedWords.length,
                        itemBuilder: (BuildContext context, int index) {
                          final word = state.filteredLearnedWords[index];
                          return Padding(
                            padding: context.paddingbottomLow,
                            child: Card(
                              child: ListTile(
                                title: Text(word.word,
                                    style: context.textTheme.titleMedium),
                                subtitle: Text(word.translation,
                                    style: context.textTheme.titleSmall),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.volume_up,
                                  ),
                                  onPressed: () => context
                                      .read<WordLearningBloc>()
                                      .add(SpeakWord(word)),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("Error"),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
