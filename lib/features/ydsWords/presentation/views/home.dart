import 'package:flutter/material.dart';
import 'package:yds_words/config/extensions/context_extension.dart';
import 'package:yds_words/config/items/colors/app_colors.dart';

import '../../../../config/router/route_names.dart';
import '../widgets/progress_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: context.paddingDefault,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "İyi Akşamlar",
                style: context.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: context.paddingVerticalLow,
                child: Text(
                  "Eğitimine kaldığımız\nyerden devam edelim",
                  style: context.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              ProgressCard(),
              Padding(
                padding: context.paddingVerticalLow,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.wordLearningView);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text("Yeni Kelimeler Öğren",
                      style: context.textTheme.labelLarge),
                ),
              ),
              Padding(
                padding: context.paddingVerticalLow,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.learnedWords),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text("Öğrendiğim Kelimeler",
                      style: context.textTheme.labelLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
