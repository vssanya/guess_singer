import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guess_singer/playlists/playlists_cubit.dart';

import '../quiz_repo.dart';
import 'playlist_widget.dart';


class PlaylistsScreen extends StatelessWidget {
	@override
  Widget build(BuildContext context) {
		return BlocProvider(
				create: (context) => PlaylistsCubit(context.read<QuizRepo>()),
				child: PlaylistsView()
		);
  }
}

class PlaylistsView extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return BlocBuilder<PlaylistsCubit, PlaylistsState>(builder: (context, state) {
			var width = MediaQuery.of(context).size.width;
			return Scaffold(
					body: SafeArea(child: 
							Stack(
									alignment: Alignment.center,
									children: [
										const Positioned(
												child: Text("Выберите категорию",
														textAlign: TextAlign.center,
														style: TextStyle(fontSize: 68, color: Color(0xff69a9da)))
										),
										Image.asset(
														'assets/images/background_playlists_center.png',
														width: width),
										buildListPlaylist(width, state),
										Positioned(
												top: 0.0,
												child: Image.asset(
														'assets/images/background_playlists_up.png',
														width: width)),
										Positioned(
												bottom: 0.0,
												child: Image.asset(
														'assets/images/background_playlists_bottom.png',
														width: width)),
									])
					)
			);
		});
	}

	Widget buildListPlaylist(double width, PlaylistsState state) {
		if (state.isLoading) {
			return const Center(child: CircularProgressIndicator());
		}

		return ListView.builder(
				padding: EdgeInsets.symmetric(vertical: width*180.0/756.0),
				itemBuilder: (context, index) {
			return PlaylistWidget(playlist: state.playlists![index]);
		}, itemCount: state.playlists!.length);
	}
}
