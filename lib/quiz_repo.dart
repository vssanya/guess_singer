import 'dart:math';

import 'package:guess_singer/quiz_models.dart';
import 'package:guess_singer/spotify_api/client.dart';
import 'package:guess_singer/spotify_api/models.dart';

class QuizRepo {
	QuizRepo({SpotifyApiClient? apiClient})
			: _apiClient = apiClient ?? SpotifyApiClient();

	final SpotifyApiClient _apiClient;

	Future<bool> init() async {
		var isAuth = await _apiClient.init();
		return isAuth;
	}

	Future<Quiz> loadQuiz(Playlist playlist) async {
		var tracks = await _apiClient.getTracks(playlist);
		tracks.shuffle();
		tracks = tracks.sublist(0, 20);

		Map<String, Artist> artists = {
			for (var it in await _apiClient.getArtists(tracks.map((it) => it.artists[0].id).toList()))
				it.id: it
		};

		var questions = tracks.where((item) {
			return item.previewUrl != null;
		}).map((track) {
			var artist = artists[track.artists[0].id];
			return Question(track,
          _getArtistsQuestion(4, artist!, artists.values.toList()),
					artist);
		}).toList();

		return Quiz(playlist, questions, artists);
	}

	List<Artist> _getArtistsQuestion(int count, Artist answer, List<Artist> artists) {
		final random = Random();
		List<Artist> res = [answer,];

		while (count-1 > 0) {
			Artist artist;

			do {
				artist = artists[random.nextInt(artists.length)];
			} while (res.firstWhere((it) => it.id == artist.id, orElse: () => Artist.empty()).id.isNotEmpty);

			count = count - 1;
			res.add(artist);
		}

		return res..shuffle(random);
	}


	Future<List<Playlist>> loadPlaylists() async {
		List<Playlist> playlists = [];
		playlists
				..addAll(await _apiClient.getFeaturedPlaylists())
				..addAll(await _apiClient.getCategoryPlaylists(Category('pop')))
				..addAll(await _apiClient.getCategoryPlaylists(Category('rock')));

		return playlists;
	}
}
