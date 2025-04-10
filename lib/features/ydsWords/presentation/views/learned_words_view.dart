import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yds_words/config/constants/word_constants.dart';
import 'package:yds_words/config/extensions/context_extension.dart';
import 'package:yds_words/features/ydsWords/presentation/blocs/wordLearning/word_learning_bloc.dart';

import '../../../../config/items/colors/app_colors.dart';
import '../../../../config/router/route_names.dart';
import '../../domain/entities/test_question_entity.dart';
import '../blocs/question/question_bloc.dart';
import '../widgets/word_type_card.dart';

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
                padding: context.paddingbottomLow,
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: MaterialButton(
                          onPressed: () {
                            context
                                .read<QuestionBloc>()
                                .add(QuestionStarted(TestQuestionType.meaning));
                            Navigator.pushNamed(
                                context, RouteNames.questionView);
                          },
                          color: AppColors.kSecondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: context.paddingDefault,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "🔁",
                                  style:
                                      context.textTheme.headlineLarge?.copyWith(
                                    color: AppColors.kWhiteColor,
                                  ),
                                ),
                                Text(
                                  "Kelimeleri Tekrar Gözden Geçir",
                                  style: context.textTheme.titleSmall?.copyWith(
                                    color: AppColors.kWhiteColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 9,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: MaterialButton(
                          onPressed: () {
                            context.read<QuestionBloc>().add(QuestionStarted(
                                TestQuestionType.sentenceTranslation));
                            Navigator.pushNamed(
                                context, RouteNames.questionView);
                          },
                          color: AppColors.kSecondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: context.paddingDefault,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "✍️",
                                  style:
                                      context.textTheme.headlineLarge?.copyWith(
                                    color: AppColors.kWhiteColor,
                                  ),
                                ),
                                Text(
                                  "Kelimeleri Cümle İçinde Gör",
                                  style: context.textTheme.titleSmall?.copyWith(
                                    color: AppColors.kWhiteColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                      return WordTypeCard(wordType: wordType);
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
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.kScaffoldColor,
                              ),
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
                    return Center(
                      child: Text((state as WordLearningError).message),
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
