import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guess_singer/quiz_models.dart';

import '../../spotify_api/models.dart';


typedef void ArtistCallback(Artist artist);

class ArtistAnswerWidget extends StatelessWidget {
	final Artist artist;
	final ArtistCallback? onTap;
	final Answer? answer;

	ArtistAnswerWidget({Key? key, required this.artist, this.answer, this.onTap}): super(key: key);

	@override
	Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { onTap?.call(artist); },
			child: Padding(
								 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
			  child: Opacity(
						opacity: getOpacity(),
						child: Stack(
						  children: [
								Container(
										margin: const EdgeInsets.only(top: 8, bottom: 8),
										height: 48,
						  		child: Row(children: [
						  			const SizedBox(width: 4.0 + 64 + 8),
						  			Text(artist.name, style: const TextStyle(fontSize: 24, color: Color(0xff25282b)), maxLines: 1, overflow: TextOverflow.clip)
						  		]),
						  		decoration: BoxDecoration(
						  				shape: BoxShape.rectangle,
						  				color: getColor(),
											borderRadius: const BorderRadius.all(Radius.circular(8)),
						  				boxShadow: const [BoxShadow()]
						  		),
								),
								Positioned(
										left: 4,
										child: ClipOval(
												child: CachedNetworkImage(
														imageUrl: artist.imageUrl!,
														width: 64,
														height: 64,
														fit: BoxFit.cover
												),
										),
								),
							]
						),
			  ),
			)
    );
  }

	double getOpacity() {
		if (answer != null) {
			if (answer!.artist == null || answer!.artist!.id != artist.id) {
				return 0.3;
			}
		}

		return 1.0;
	}

	Color getColor() {
		if (answer?.isNotEmpty ?? false) {
			if (answer!.artist!.id == artist.id) {
				return answer!.isCorrect ? Colors.lightGreen : Colors.redAccent;
			}
		}

		return Colors.white;
	}
}
