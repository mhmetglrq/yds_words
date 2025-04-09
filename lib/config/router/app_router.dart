import 'package:flutter/material.dart';
import 'package:yds_words/features/ydsWords/presentation/views/question_view.dart';
import 'package:yds_words/features/ydsWords/presentation/views/test_result_view.dart';
import '../../features/ydsWords/presentation/views/home.dart';
import '../../features/ydsWords/presentation/views/learned_words_view.dart';
import '../../features/ydsWords/presentation/views/word_learning_view.dart';
import 'route_names.dart';

/// A convenient router class to handle named routes with various custom animations.
///
/// You can easily add new routes in [generateRoute] using the transition methods
/// such as [fadeRoute], [slideRoute], [scaleRoute], [rotateRoute], [sizeRoute], etc.
class AppRouter {
  /// Generates the appropriate [Route] based on the given [RouteSettings].
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Example usage:
      case RouteNames.home:
        return fadeRoute(
          settings: settings,
          view: Home(),
        );

      case RouteNames.wordLearningView:
        return slideRoute(
          settings: settings,
          view: WordLearningView(),
        );

      case RouteNames.learnedWords:
        return slideRoute(
          settings: settings,
          view: LearnedWordsView(),
        );
      case RouteNames.questionView:
        return slideRoute(
          settings: settings,
          view: QuestionView(),
        );
      case RouteNames.testResultView:
        return fadeRoute(settings: settings, view: TestResultView());

      // If no matching route is found, return an error page.
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('No route defined for \${settings.name}'),
            ),
          ),
        );
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  // MaterialPageRoute
  ////////////////////////////////////////////////////////////////////////////

  /// Creates a standard [MaterialPageRoute].
  static Route<dynamic> materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }

  ////////////////////////////////////////////////////////////////////////////
  // Slide Transition
  ////////////////////////////////////////////////////////////////////////////

  /// Creates a slide transition route from [begin] to [end] positions.
  ///
  /// [begin] is the starting offset of the page (default is bottom: Offset(0, 1)).
  /// [end] is the ending offset of the page (default is Offset.zero).
  /// [duration] controls how long the transition takes.
  /// [curve] controls the transition's timing function.
  static Route<dynamic> slideRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 500),
    Offset begin = const Offset(0, 1),
    Offset end = Offset.zero,
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => view,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);
        return SlideTransition(
          position:
              Tween<Offset>(begin: begin, end: end).animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////////
  // Fade Transition
  ////////////////////////////////////////////////////////////////////////////

  /// Creates a fade transition route.
  ///
  /// [duration] controls how long the transition takes.
  /// [curve] controls the transition's timing function.
  static Route<dynamic> fadeRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => view,
      transitionDuration: duration,
      transitionsBuilder: (_, animation, __, child) {
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////////
  // Scale Transition
  ////////////////////////////////////////////////////////////////////////////

  /// Creates a scale transition route.
  ///
  /// [duration] controls how long the transition takes.
  /// [curve] controls the transition's timing function.
  static Route<dynamic> scaleRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => view,
      transitionDuration: duration,
      transitionsBuilder: (_, animation, __, child) {
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);
        return ScaleTransition(
          scale: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////////
  // Rotation Transition
  ////////////////////////////////////////////////////////////////////////////

  /// Creates a rotation transition route.
  ///
  /// [duration] controls how long the transition takes.
  /// [curve] controls the transition's timing function.
  static Route<dynamic> rotateRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => view,
      transitionDuration: duration,
      transitionsBuilder: (_, animation, __, child) {
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);
        return RotationTransition(
          turns: curvedAnimation,
          child: child,
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////////
  // Size Transition
  ////////////////////////////////////////////////////////////////////////////

  /// Creates a size transition route, growing from 0 to 1.
  ///
  /// [duration] controls how long the transition takes.
  /// [curve] controls the transition's timing function.
  static Route<dynamic> sizeRoute({
    required RouteSettings settings,
    required Widget view,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => view,
      transitionDuration: duration,
      transitionsBuilder: (_, animation, __, child) {
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);
        return Align(
          alignment: Alignment.center,
          child: SizeTransition(
            sizeFactor:
                Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
