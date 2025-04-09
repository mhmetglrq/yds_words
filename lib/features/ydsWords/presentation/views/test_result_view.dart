import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      const Text("your Score",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      const SizedBox(height: 8),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Text(
                          "$score pt",
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _statRow("100%", "Completion", color: Colors.purple),
                        const SizedBox(height: 8),
                        _statRow("$total", "Total Question"),
                        const SizedBox(height: 8),
                        _statRow("$correct", "Correct", color: Colors.green),
                        const SizedBox(height: 8),
                        _statRow("$wrong", "Wrong", color: Colors.red),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _actionButton(Icons.refresh, "Play Again", () {
                        context
                            .read<QuestionBloc>()
                            .add(QuestionStarted(TestQuestionType.meaning));
                        Navigator.pop(context);
                      }),
                      _actionButton(Icons.visibility, "Review Answer", () {}),
                      _actionButton(Icons.share, "Share Score", () {}),
                      _actionButton(
                          Icons.picture_as_pdf, "Generate PDF", () {}),
                      _actionButton(
                          Icons.home, "Home", () => Navigator.pop(context)),
                      _actionButton(Icons.leaderboard, "Leaderboard", () {}),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statRow(String value, String label, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
