import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yds_words/config/extensions/context_extension.dart';

import '../../../../config/items/colors/app_colors.dart';
import '../blocs/wordLearning/word_learning_bloc.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingVerticalLow,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: Padding(
          padding: context.paddingLow,
          child: BlocBuilder<WordLearningBloc, WordLearningState>(
            builder: (context, state) {
              if (state is WordLearningLoading ||
                  state is WordLearningInitial) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is WordLearningLoaded) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "İlerleyiş",
                        style: context.textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    //Buraya bir progress bar ekleyelim
                    Padding(
                      padding: context.paddingVerticalLow,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(8), // yuvarlak köşeler
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          value: 0.5, // %50 dolu
                          backgroundColor: AppColors.kInfoColor,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: context.paddingVerticalLow,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Öğrenilen Kelime",
                            style: context.textTheme.bodyMedium,
                          ),
                          Text(
                            "${state.learnedWords.length}",
                            style: context.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: context.paddingVerticalLow,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kalan Kelime",
                            style: context.textTheme.bodyMedium,
                          ),
                          Text(
                            "${state.words.length}",
                            style: context.textTheme.bodyMedium,
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
      ),
    );
  }
}
