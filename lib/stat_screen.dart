import 'package:flutter/material.dart';
import 'package:guess_singer/const.dart';
import 'package:guess_singer/quiz_models.dart';


class StatScreen extends StatelessWidget {
  final AnswerStat stat;

  StatScreen({Key? key, required this.stat}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		var width = MediaQuery.of(context).size.width;
		var height = MediaQuery.of(context).size.height;

    return Scaffold(
				backgroundColor: const Color(0xff4c4c4d),
        body: SafeArea(
            child: Stack(
								alignment: Alignment.center,
								children: [
							SizedBox(width: width, height: height),
						  Image.asset(stat.isGood ? 'assets/images/result_screen_good.png' : 'assets/images/result_screen_bad.png', width: 0.7*width),
							Positioned(top: 16, width: width,child: Text(stat.quiz.playlist.name, textAlign: TextAlign.center,
							  					style: const TextStyle(fontSize: 48, color: Color(0xff69a9da)), maxLines: 2)),
							Positioned(bottom: 16, child: TextButton(
							  			onPressed: () {
							  				Navigator.pushReplacementNamed(context, '/main');
							  			},
							  			child: const Text("Next", style: Const.btnTextStyle))),
							Positioned(top: height/2 + (0.7*width)/2, child:
							  	Text("${stat.countCorrectAnswer}/${stat.countQuestions}", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300, color: Color(0xff69a9da))),
							),
						])));
	}
}
