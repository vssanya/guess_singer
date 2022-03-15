import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:appmetrica_sdk/appmetrica_sdk.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_singer/quiz_models.dart';
import 'package:guess_singer/spotify_api/models.dart';
import 'package:just_audio/just_audio.dart';

import '../quiz_repo.dart';


enum QuizStatus { initial, loading, success, failure }

class QuizState extends Equatable {
	final Playlist playlist;

	final Quiz? quiz;
	final Question? question;
	final Answer? answer;
	final int step;

	final QuizStatus status;

	QuizState({required this.playlist, this.quiz, this.question, this.answer, this.step = -1, this.status = QuizStatus.initial});

	QuizState copyWith({
		Playlist? playlist,
		Quiz? quiz,
		Question? question,
		Answer? answer,
		int? step,
		QuizStatus? status
	}) {
		return QuizState(
				playlist: playlist ?? this.playlist,
				quiz: quiz ?? this.quiz,
				question: question ?? this.question,
				answer: answer ?? this.answer,
				step: step ?? this.step,
				status: status ?? this.status
		);
	}

	QuizState next() {
		if (quiz == null) {
			return this;
		}

		var step = this.step + 1;

		return QuizState(
				playlist: playlist,
				quiz: quiz,
				question: quiz!.questions[step],
				answer: null,
				step: step,
				status: status
		);
	}

	bool get isLastQuestion => step + 1 == quiz?.questions.length;
	int get countQuestions => quiz?.questions.length ?? 0;

	@override
  List<Object?> get props => [playlist, quiz, question, answer, step, status];
}

const admobAdUnitId = String.fromEnvironment("ADMOB_AD_ID", defaultValue: "ca-app-pub-3940256099942544/1033173712");

class QuizCubit extends Cubit<QuizState> {
	final QuizRepo _quizRepo;

	var player = AudioPlayer();
	var ad = AdmobInterstitial(adUnitId: admobAdUnitId);
	AnswerStat? answerStat;

	QuizCubit(this._quizRepo, Playlist playlist): super(QuizState(playlist: playlist)) {
		ad.load();
		loadQuiz();
	}

	Future<void> loadQuiz() async {
		AppmetricaSdk().reportEvent(name: "loadQuiz", attributes: {"playlist": state.playlist.id});

		var quiz = await _quizRepo.loadQuiz(state.playlist);
		var question = quiz.questions[0];
		answerStat = AnswerStat(quiz);

		emit(state.copyWith(quiz: quiz, question: question, step: 0));
		_playTrack();
	}

	void setNullAnswer() {
		if (state.answer != null) {
			return;
		}

		var answer = Answer.empty();
		answerStat!.addAnswer(answer);

		AppmetricaSdk().reportEvent(name: "setNullAnswer", attributes: {"track": state.question?.track.id});

		emit(state.copyWith(answer: answer));
	}

	void setAnswer(Artist artist) {
		if (state.answer != null) {
			return;
		}

		var answer = Answer(artist, state.question!.track.artists[0].id == artist.id);
		answerStat!.addAnswer(answer);

		AppmetricaSdk().reportEvent(name: "setAnswer", attributes: {
			"track": state.question?.track.id,
			"selectArtist": artist.id,
			"correct": answer.isCorrect});

		emit(state.copyWith(answer: answer));
	}

	void next() {
		if (state.step == 10) {
			ad.isLoaded.then((status) {
				if (status ?? false) {
					ad.show();
				}
			});
		}

		emit(state.next());
		_playTrack();
	}

  Future _playTrack() async {
		if (state.question != null) {
			var track = state.question!.track;
			await player.setUrl(track.previewUrl!);
			player.play();
		}
  }

	@override
  Future<void> close() {
		player.dispose();
		ad.dispose();

    return super.close();
  }
}
