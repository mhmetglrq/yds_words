import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injections/app_injection.dart';
import 'features/ydsWords/presentation/blocs/wordLearning/word_learning_bloc.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInjection.init();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<WordLearningBloc>(
        create: (context) => sl<WordLearningBloc>()
          ..add(LoadWords())
          ..add(LoadLearnedWords()),
      ),
    ],
    child: const MyApp(),
  ));
}
