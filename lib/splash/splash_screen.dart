import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_singer/quiz_repo.dart';
import 'package:guess_singer/splash/splash_cubit.dart';

import '../const.dart';


class SplashScreen extends StatelessWidget {
	SplashScreen({Key? key}): super(key: key);

	@override
  Widget build(BuildContext context) {
		return BlocProvider(
				create: (context) => SplashCubit(context.read<QuizRepo>()),
				child: SplashView()
		);
  }
}

class SplashView extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashState>(builder: (context, state) {
			return Scaffold(
				backgroundColor: const Color(0xffdcdcdc),
      body: Stack(
					alignment: Alignment.center,
					fit: StackFit.expand,
        children: [
					Column(
							mainAxisAlignment: MainAxisAlignment.center,
							children: <Widget>[
								Image(image: const AssetImage('assets/images/icon.png'), width: MediaQuery.of(context).size.width/1.5),
								const Text(
										Const.appName,
										style: TextStyle(
												color: Const.colorTextTitle,
												fontSize: 36,
												fontFamily: 'Nunito',
												fontWeight: FontWeight.normal,
										),
								),
							],
					),
						AnimatedPositioned(
								bottom: state.isLoading ? -64 : 64,
								duration: const Duration(milliseconds: 500),
								child: Ink(
										height: 64,
										width: 64,
										decoration: const ShapeDecoration(shape: CircleBorder(), color: Color(0xff1c56c0)),
										child: IconButton(icon: const Icon(Icons.play_arrow, size: 32), color: Colors.white, onPressed: () {
											Navigator.popAndPushNamed(context, '/main');
										},)
								),
						),
				]
      ),
    );
		});
	}
}
