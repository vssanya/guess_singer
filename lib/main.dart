import 'package:admob_flutter/admob_flutter.dart';
import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_singer/playlists/playlists_screen.dart';
import 'package:guess_singer/quiz/quiz_screen.dart';
import 'package:guess_singer/quiz_models.dart';
import 'package:guess_singer/quiz_repo.dart';
import 'package:guess_singer/splash/splash_screen.dart';
import 'package:guess_singer/spotify_api/models.dart';
import 'package:guess_singer/stat_screen.dart';

import 'package:page_transition/page_transition.dart';


const appmetricaApiKey = String.fromEnvironment("APPMETRICA_API_KEY", defaultValue: "");

void main() async {
	WidgetsFlutterBinding.ensureInitialized();

	if (appmetricaApiKey.isNotEmpty) {
		await AppmetricaSdk().activate(apiKey: appmetricaApiKey);
	}

	Admob.initialize();

  runApp(App(quizRepo: QuizRepo()));
}

class App extends StatelessWidget {
	const App({Key? key, required QuizRepo quizRepo})
			: _quizRepo = quizRepo, super(key: key);

	final QuizRepo _quizRepo;

	@override
  Widget build(BuildContext context) {
		return RepositoryProvider.value(
				value: _quizRepo,
				child: AppView()
		);
  }
}

class AppView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess Singer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
				scaffoldBackgroundColor: const Color(0xff4c4c4d),
      ),
			initialRoute: '/splash',
			onGenerateRoute: (settings) {
				switch (settings.name) {
					case '/splash':
						return PageTransition(
								child: SplashScreen(),
								type: PageTransitionType.bottomToTop);
					case '/main':
						return PageTransition(
								child: PlaylistsScreen(),
								type: PageTransitionType.bottomToTop);
					case '/main/quiz':
						return PageTransition(
								child: QuizScreen(playlist: settings.arguments as Playlist),
								type: PageTransitionType.bottomToTop);
					case '/stat':
						return PageTransition(
								child: StatScreen(stat: settings.arguments as AnswerStat),
								type: PageTransitionType.bottomToTop);
					default:
						return null;
				}
			},
    );
  }
}
