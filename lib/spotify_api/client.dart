import 'dart:convert';

import 'package:dio/dio.dart';

import 'models.dart';


class SpotifyApiClient {
	Dio dio = Dio();
	String? _token;

	static const prefix = 'https://api.spotify.com/v1';
	static const OAUTH_TOKEN_URL = 'https://accounts.spotify.com/api/token';

	static const CLIENT_ID = String.fromEnvironment("SPOTIFY_CLIENT_ID");
	static const CLIENT_SECRET = String.fromEnvironment("SPOTIFY_SECRET_ID");

	SpotifyApiClient();

	Future<bool> init() async {
		_token = await _getToken();

		if (_token == null) {
			return false;
		}

		dio.options.headers['Authorization'] = 'Bearer $_token';

		return true;
	}

	Future<String?> _getToken() async {
		String? token;

		try {
			var res = await dio.post(OAUTH_TOKEN_URL,
          data: {'grant_type': 'client_credentials'},
          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: makeAuthorizationHeaders()));
			token = res.data['access_token'];
		} on DioError catch (_) {
		}

		return token;
	}

	Map<String, String> makeAuthorizationHeaders() {
		const asciiCodec = AsciiCodec();
		var authHeader = base64Encode(asciiCodec.encode("$CLIENT_ID:$CLIENT_SECRET"));
		return {"Authorization": "Basic $authHeader"};
	}

	void search(String query) async {
		try {
			var res = await dio.get('$prefix/search', queryParameters: {'q': query, 'type': 'track'});
		} on DioError catch (err) {
			print(err.response?.data);
		}
	}

	Future<List<Playlist>> getFeaturedPlaylists() async {
		var res = await dio.get("$prefix/browse/featured-playlists", queryParameters: {'country': 'RU', 'locale': 'ru_RU'});

		return (res.data['playlists']['items'] as List<dynamic>).map((json) => Playlist.fromJson(json)).toList();
	}

	Future<List<Track>> getTracks(Playlist playlist) async {
		var res;
		try {
			res = await dio.get("$prefix/playlists/${playlist.id}/tracks");
		} on DioError catch (err) {
			print(err.response?.data);
		}

		return (res.data['items'] as List<dynamic>).map((json) => Track.fromJson(json['track'])).toList();
	}

	Future<List<Artist>> getArtists(List<String> ids) async {
		var res;
		try {
			res = await dio.get("$prefix/artists", queryParameters: {'ids': ids.join(',')});
		} on DioError catch (err) {
			print(err.response?.data);
		}

		return (res.data['artists'] as List<dynamic>).map((json) => Artist.fromJson(json)).toList();
	}

	Future<List<Category>> getCategories() async {
		var res;
		try {
			res = await dio.get("$prefix/browse/categories", queryParameters: {'locale': 'ru_RU', 'country': 'RU'});
		} on DioError catch (err) {
			print(err.response?.data);
		}

		return (res.data['categories']['items'] as List<dynamic>).map((json) => Category.fromJson(json)).toList();
	}

	Future<List<Playlist>> getCategoryPlaylists(Category category) async {
		var res;
		try {
			res = await dio.get("$prefix/browse/categories/${category.id}/playlists", queryParameters: {'locale': 'ru_RU', 'country': 'RU'});
		} on DioError catch (err) {
			print(err.response?.data);
		}

		return (res.data['playlists']['items'] as List<dynamic>).map((json) => Playlist.fromJson(json)).toList();
	}
}
