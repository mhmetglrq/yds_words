import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yds_words/config/extensions/context_extension.dart';

import '../../../../config/items/colors/app_colors.dart';
import '../../../../config/router/route_names.dart';
import '../../domain/entities/test_question_entity.dart';
import '../blocs/question/question_bloc.dart';

class TestResultView extends StatelessWidget {
  const TestResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Sonucu")),
      body: BlocBuilder<QuestionBloc, QuestionState>(
        builder: (context, state) {
          if (state is! QuestionLoaded) {
            return const Center(child: Text("Sonuç verisi bulunamadı."));
          }

          final correct = state.correctAnswerCount;
          final total = state.questions.length;
          final wrong = total - correct;
          final score = ((correct / total) * 100).toInt();

          return Padding(
            padding: context.paddingDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Text(
                    "$score\nPuan",
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: context.paddingVerticalHigh,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _statRow("$total", "Toplam Soru Sayısı", context),
                          _statRow("$correct", "Doğru Sayısı", context,
                              color: Colors.green),
                          _statRow("$wrong", "Yanlış Sayısı", context,
                              color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _actionButton(
                        context,
                        Icons.refresh,
                        "Tekrar Çöz",
                        () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _actionButton(
                        context,
                        Icons.home,
                        "Ana Sayfa",
                        () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteNames.home,
                          (_) => false,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statRow(String value, String label, BuildContext context,
      {Color? color}) {
    return Padding(
      padding: context.paddingbottomLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.textTheme.bodyLarge),
          Text(
            value,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return AspectRatio(
      aspectRatio: 1,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kSecondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: context.paddingbottomLow,
              child: Icon(icon, color: Colors.white),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
