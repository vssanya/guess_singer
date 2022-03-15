import 'package:guess_singer/spotify_api/models.dart';


class Question {
	final Track track;
	final List<Artist> artists;
	final Artist artist;

	Question(this.track, this.artists, this.artist);
}

class Quiz {
	final Playlist playlist;
	final List<Question> questions;
	final Map<String, Artist> artists;

	Quiz(this.playlist, this.questions, this.artists);
}

class Answer {
	final Artist? artist;
	final bool isCorrect;

	Answer(this.artist, this.isCorrect);
	Answer.empty():
			artist = null,
			isCorrect = false;

	get isNotEmpty => artist != null;
}

class AnswerStat {
	final Quiz quiz;
	final int countQuestions;
	int countCorrectAnswer;

	AnswerStat(this.quiz): countQuestions = quiz.questions.length, countCorrectAnswer = 0;

	addAnswer(Answer answer) {
		if (answer.isCorrect) {
			countCorrectAnswer = countCorrectAnswer + 1;
		}
	}

	bool get isGood {
		return countCorrectAnswer > 2.0/3.0*countQuestions;
	}
}
