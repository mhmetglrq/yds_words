import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yds_words/config/extensions/context_extension.dart';
import '../../../../config/items/colors/app_colors.dart';
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
            if (state is WordLearningLoading || state is WordLearningInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WordLearningLoaded) {
              final currentWord = state.words[state.currentWordIndex];
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${currentWord.word} - ",
                                      style:
                                          context.textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      currentWord.type,
                                      style: context.textTheme.bodyLarge
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              fontStyle: FontStyle.italic),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                                Text(
                                  currentWord.translation,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: context.paddingVerticalDefault,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (state.currentWordIndex > 0)
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<WordLearningBloc>()
                                  .add(PreviousWord());
                            },
                            child: const Text("Önceki Kelime"),
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
                          child: const Text("Sonraki Kelime"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                  child:
                      Text("Error: ${(state as WordLearningError).message}"));
            }
          },
        ),
      ),
    );
  }
}
