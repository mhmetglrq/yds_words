import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yds_words/config/extensions/context_extension.dart';
import '../../../../config/items/colors/app_colors.dart';
import '../../../../config/router/route_names.dart';
import '../blocs/question/question_bloc.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelime Testi")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: context.paddingDefault,
            child: BlocConsumer<QuestionBloc, QuestionState>(
              listener: (context, state) {
                // Navigate to result page when last question answered
                final currentState = state as QuestionAnswering;
                final total = state.questions.length;
                if (currentState.isAnswered &&
                    currentState.currentIndex + 1 == total) {
                  Navigator.pushReplacementNamed(
                      context, RouteNames.testResultView);
                }
              },
              builder: (context, state) {
                if (state is QuestionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is QuestionAnswering) {
                  final question = state.questions[state.currentIndex];

                  final correct = state.correctAnswerCount;
                  final wrong = state.currentIndex - correct;

                  return Column(
                    children: [
                      // Üst sayaç kutusu
                      Container(
                        padding: context.paddingLow,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.kPrimaryColor,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: context.paddingVerticalHigh,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.check, color: Colors.green),
                                  Padding(
                                    padding: context.paddingleftLow,
                                    child: Text(
                                      correct.toString(),
                                      style: context.textTheme.labelMedium
                                          ?.copyWith(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: (state.currentIndex + 1) / 10,
                                    strokeWidth: 4,
                                    backgroundColor: AppColors.kStrokeColor,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                  Text(
                                    (state.currentIndex + 1).toString(),
                                    style: context.textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: context.paddingrightLow,
                                    child: const Icon(Icons.close,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    wrong.toString(),
                                    style:
                                        context.textTheme.labelMedium?.copyWith(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Soru metni
                      Padding(
                        padding: context.paddingVerticalDefault,
                        child: Text(
                          question.questionText,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Şıklar
                      ...List.generate(question.options.length, (index) {
                        final option = question.options[index];
                        final isCorrect = index == question.correctIndex;
                        final isSelected = index == state.selectedOptionIndex;

                        Color borderColor = Colors.grey.shade300;
                        IconData? icon;

                        if (state.isAnswered) {
                          if (isCorrect) {
                            borderColor = Colors.green;
                            icon = Icons.check_circle;
                          } else if (isSelected) {
                            borderColor = Colors.red;
                            icon = Icons.cancel;
                          }
                        } else {
                          borderColor = AppColors.kSecondaryColor;
                        }

                        return Padding(
                          padding: context.paddingVerticalLow,
                          child: GestureDetector(
                            onTap: state.isAnswered
                                ? null
                                : () => context
                                    .read<QuestionBloc>()
                                    .add(QuestionAnswered(index)),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              padding: context.paddingDefault,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: borderColor, width: 2),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(),
                                    ),
                                  ),
                                  if (icon != null)
                                    Icon(icon, color: borderColor),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }

                return const Center(child: Text("Test başlatılmadı."));
              },
            ),
          ),
        ),
      ),
    );
  }
}
