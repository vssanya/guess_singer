import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_singer/quiz/quiz_cubit.dart';
import 'package:guess_singer/quiz/widgets/artist_answer_widget.dart';
import 'package:guess_singer/quiz/widgets/progress_player_widget.dart';
import 'package:guess_singer/spotify_api/models.dart';

import '../const.dart';
import '../quiz_repo.dart';


class QuizScreen extends StatelessWidget {
  final Playlist playlist;

  QuizScreen({Key? key, required this.playlist}) : super(key: key);

	@override
  Widget build(BuildContext context) {
		return BlocProvider(
				create: (context) => QuizCubit(context.read<QuizRepo>(), playlist),
				child: QuizView()
		);
  }
}

class QuizView extends StatelessWidget {
	@override
  Widget build(BuildContext context) {
		return BlocBuilder<QuizCubit, QuizState>(builder: (context, state) {
			var cubit = context.read<QuizCubit>();

			onTapArtist(Artist artist) {
				cubit.setAnswer(artist);
			}

			var question = state.question;
			var answer = state.answer;

			if (question == null) {
				return const Center(child: CircularProgressIndicator());
			}

			var size = MediaQuery.of(context).size;
			var shift = size.height - 1.85*size.width - 110;
			if (shift > 0) {
				shift = 0;
			}

			final width = size.width;

			return Scaffold(
					backgroundColor: const Color(0xff4c4c4d),
					body: SafeArea(
							child: Stack(
									fit: StackFit.expand,
									alignment: AlignmentDirectional.center,
									children: [
										Positioned(
												top: 0,
												width: width,
												height: width,
												child: Stack(
														alignment: AlignmentDirectional.center,
														children: [
															CachedNetworkImage(
																	imageUrl: question.track.imageUrl!,
																	placeholder: (context, url) => const SizedBox(),
																	errorWidget: (context, url, error) => const SizedBox(),
																	color: const Color(0xff4c4c4d).withOpacity(0.6),
																	colorBlendMode: BlendMode.multiply,
																	fit: BoxFit.fitWidth,
															),
															Container(
																	child: BackdropFilter(
																			filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
																			child: Container(color: Colors.black.withOpacity(0.0)))),
															if (answer == null)
															Container(
																	width: 0.5 * width,
																	height: 0.5 * width,
																	decoration:
																	const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
																	child: const Center(child: Text("?", style: TextStyle(fontSize: 128, color: Color(0xff4c4c4d))))
															),
																if (answer != null)
																	ClipOval(
																			child: CachedNetworkImage(
																					imageUrl: question.artist.imageUrl!,
																					width: 0.5*width,
																					height: 0.5*width,
																					fit: BoxFit.cover
																			),
																	),
																		SizedBox(
																				width: 0.5*width,
																				height: 0.5*width,
																				child: ProgressPlayerWidget(
																						streamPosition: cubit.player.positionStream,
																						streamDuration: cubit.player.durationStream, onFinish: () {
																							cubit.setNullAnswer();
																				}),
																		),
																		SizedBox(
																				width: width,
																				height: width,
																				child: Column(children: [
																					Padding(
																							padding: const EdgeInsets.all(8),
																							child: Text(state.playlist.name, textAlign: TextAlign.center,
																									style: const TextStyle(fontSize: 38, color: Color(0xff69a9da)), maxLines: 2),
																					)
																				])),
																		if (answer != null)
																			Positioned(bottom: 16, child: Column(children: [
																				Text(question.artist.name, style: const TextStyle(fontSize: 32, color: Colors.white), maxLines: 1),
																				Text(question.track.name, style: const TextStyle(fontSize: 24, color: Colors.grey), maxLines: 1)
																			]))
																					]),
																					),
																					if (answer != null && !state.isLastQuestion)
																						Positioned(
																								top: width + 32,
																								child: TextButton(
																										onPressed: () {
																											cubit.next();
																										},
																										child: const Text("Next", style: Const.btnTextStyle)),
																						),
																							if (answer != null && state.isLastQuestion)
																								Positioned(
																										top: width + 32,
																										child: TextButton(
																												onPressed: () {
																													Navigator.pushReplacementNamed(context, '/stat', arguments: cubit.answerStat);
																												},
																												child: const Text("Finish", style: Const.btnTextStyle)),
																								),
																									AnimatedPositioned(
																											bottom: answer == null ? 0 : shift,
																											width: 0.94*width,
																											duration: const Duration(seconds: 1),
																											child: Container(
																													decoration: const BoxDecoration(
																															color: Color(0xffdcdcdc),
																															borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
																													),
																													child: Column(
																															children: [
																																const SizedBox(height: 8),
																																ArtistAnswerWidget(artist: question.artists[0], answer: answer, onTap: onTapArtist),
																																ArtistAnswerWidget(artist: question.artists[1], answer: answer, onTap: onTapArtist),
																																ArtistAnswerWidget(artist: question.artists[2], answer: answer, onTap: onTapArtist),
																																ArtistAnswerWidget(artist: question.artists[3], answer: answer, onTap: onTapArtist),
																																Padding(
																																		padding: const EdgeInsets.only(bottom: 10.0),
																																		child: Text('${state.step + 1} / ${state.countQuestions}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Color(0xff69a9da))),
																																),
																															],
																													),
																											),
																											),
																											])));
		});
  }
}
