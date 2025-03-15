import 'package:flutter/material.dart';
import 'package:yds_words/config/extensions/context_extension.dart';

import '../../../../config/items/colors/app_colors.dart';

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
          child: Column(
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
                  borderRadius: BorderRadius.circular(8), // yuvarlak köşeler
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
                      "50",
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
                      "Toplam Kelime",
                      style: context.textTheme.bodyMedium,
                    ),
                    Text(
                      "100",
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
