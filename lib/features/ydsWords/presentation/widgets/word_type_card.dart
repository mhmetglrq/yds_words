import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yds_words/config/extensions/context_extension.dart';

import '../../../../config/items/colors/app_colors.dart';
import '../blocs/wordLearning/word_learning_bloc.dart';

class WordTypeCard extends StatelessWidget {
  const WordTypeCard({
    super.key,
    required this.wordType,
  });

  final String wordType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordLearningBloc, WordLearningState>(
      builder: (context, state) {
        return Padding(
          padding: context.paddingHorizontalLow,
          child: InkWell(
            onTap: () => context
                .read<WordLearningBloc>()
                .add(FilterLearnedWords(wordType: wordType)),
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: state.selectedWordType == wordType
                    ? AppColors.kPrimaryColor
                    : AppColors.kScaffoldColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: context.paddingDefault,
                child: Center(
                  child: Text(
                    wordType,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: state.selectedWordType == wordType
                          ? AppColors.kWhiteColor
                          : AppColors.kTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
