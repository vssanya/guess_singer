import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:guess_singer/spotify_api/models.dart';

class PlaylistWidget extends StatelessWidget {
	final Playlist playlist;

	PlaylistWidget({Key? key, required this.playlist}): super(key: key);

	@override
	Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/main/quiz', arguments: playlist);
      },
      child: Container(
          width: 220,
          height: 220,
          child: CachedNetworkImage(imageUrl: playlist.imageUrl)),
    );
  }
}
