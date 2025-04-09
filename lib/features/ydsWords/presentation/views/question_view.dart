import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/router/route_names.dart';
import '../blocs/question/question_bloc.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelime Testi")),
      body: BlocBuilder<QuestionBloc, QuestionState>(
        builder: (context, state) {
          if (state is QuestionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QuestionAnswering) {
            final question = state.questions[state.currentIndex];
            final total = state.questions.length;
            final correct = state.correctAnswerCount;
            final wrong = state.currentIndex - correct;

            // Navigate to result page when last question answered
            if (state.isAnswered && state.currentIndex + 1 == total) {
              Future.microtask(() {
                Navigator.of(context)
                    .pushReplacementNamed(RouteNames.testResultView);
              });
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Üst sayaç kutusu
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(correct.toString(),
                                style: const TextStyle(color: Colors.green)),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text((state.currentIndex + 1).toString()),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.close, color: Colors.red),
                            const SizedBox(width: 4),
                            Text(wrong.toString(),
                                style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Soru metni
                  Text(
                    question.questionText,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

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
                      borderColor = Colors.purple;
                    }

                    return GestureDetector(
                      onTap: state.isAnswered
                          ? null
                          : () => context
                              .read<QuestionBloc>()
                              .add(QuestionAnswered(index)),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                option,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            if (icon != null) Icon(icon, color: borderColor),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }

          return const Center(child: Text("Test başlatılmadı."));
        },
      ),
    );
  }
}
