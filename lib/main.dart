import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injections/app_injection.dart';
import 'features/ydsWords/data/dataSources/local/widget_updater.dart';
import 'features/ydsWords/presentation/blocs/question/question_bloc.dart';
import 'features/ydsWords/presentation/blocs/wordLearning/word_learning_bloc.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjection.init();

  const channel = MethodChannel('app.channel');
  channel.setMethodCallHandler((call) async {
    if (call.method == 'updateWidget') {
      final widgetUpdater = sl<WidgetUpdater>();
      await widgetUpdater.updateWidget();
    }
  });

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<WordLearningBloc>(
        create: (context) => sl<WordLearningBloc>()
          ..add(LoadWords())
          ..add(LoadLearnedWords()),
      ),
      BlocProvider<QuestionBloc>(
        create: (context) => sl<QuestionBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}
