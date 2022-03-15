import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_singer/spotify_api/models.dart';

import '../quiz_repo.dart';


enum PlaylistsStatus { initial, loading, success, failure }

class PlaylistsState extends Equatable {
	final List<Playlist>? playlists;
	final PlaylistsStatus status;

	PlaylistsState({this.playlists, this.status = PlaylistsStatus.initial});

	PlaylistsState copyWith({
		List<Playlist>? playlists,
		PlaylistsStatus? status
	}) {
		return PlaylistsState(
				playlists: playlists ?? this.playlists,
				status: status ?? this.status
		);
	}

	bool get isLoading => status == PlaylistsStatus.initial || status == PlaylistsStatus.loading;

	@override
  List<Object?> get props => [playlists, status];
}

class PlaylistsCubit extends Cubit<PlaylistsState> {
	final QuizRepo _quizRepo;

	PlaylistsCubit(this._quizRepo): super(PlaylistsState()) {
		loadPlaylists();
	}

	Future<void> loadPlaylists() async {
		emit(state.copyWith(status: PlaylistsStatus.loading));

		var playlists = await _quizRepo.loadPlaylists();

		emit(state.copyWith(playlists: playlists, status: PlaylistsStatus.success));
	}
}
