import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yds_words/config/extensions/context_extension.dart';
import '../blocs/wordLearning/word_learning_bloc.dart';

class WordLearningView extends StatelessWidget {
  const WordLearningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Learning"),
      ),
      body: Padding(
        padding: context.paddingDefault,
        child: BlocBuilder<WordLearningBloc, WordLearningState>(
          builder: (context, state) {
            if (state is WordLearningLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WordLearningLoaded) {
              final currentWord = state.words[state.currentWordIndex];
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: context.paddingLow,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.white),
                                  ),
                                  padding: context.paddingLow,
                                  child: const Icon(
                                    Icons.volume_up,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  context
                                      .read<WordLearningBloc>()
                                      .add(SpeakWord(currentWord));
                                },
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentWord.word,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                                Text(
                                  currentWord.translation,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (state.currentWordIndex > 0)
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<WordLearningBloc>()
                                .add(PreviousWord());
                          },
                          child: const Text("Previous Word"),
                        )
                      else
                        const SizedBox(),
                      ElevatedButton(
                        onPressed:
                            state.currentWordIndex < state.words.length - 1
                                ? () {
                                    context
                                        .read<WordLearningBloc>()
                                        .add(NextWord());
                                  }
                                : null, // Son kelimedeyse devre dışı bırak
                        child: const Text("Next Word"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<WordLearningBloc>()
                          .add(LearnWord(currentWord));
                    },
                    child: const Text("Learn This Word"),
                  ),
                ],
              );
            } else if (state is WordLearningSpeaking) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "Speaking: ${state.spokenWord.word}",
                          style: context.textTheme.bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              );
            } else if (state is WordLearningError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const Center(child: Text("No words loaded yet"));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<WordLearningBloc>().add(LoadWords());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
