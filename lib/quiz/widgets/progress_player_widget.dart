import 'dart:async';
import 'package:flutter/material.dart';

class ProgressPlayerWidget extends StatefulWidget {
	final Stream<Duration?> streamDuration;
	final Stream<Duration?> streamPosition;

	final VoidCallback? onFinish;

	ProgressPlayerWidget({Key? key, required this.streamDuration, required this.streamPosition, this.onFinish}) : super(key: key);

	@override
	State<StatefulWidget> createState() {
		return _ProgressPlayerState();
	}
}

class _ProgressPlayerState extends State<ProgressPlayerWidget> {
	var value = 0.0;
	late StreamSubscription<Duration?> streamPosSubsc;
	late StreamSubscription<Duration?> streamDurSubsc;
	Duration? duration;

	@override
	void initState() {
		super.initState();
		streamPosSubsc = widget.streamPosition.listen((cur) {
			setState(() {
				if (duration != null && cur != null) {
					value = cur.inMilliseconds / duration!.inMilliseconds;
				} else {
					value = 0.0;
				}
			});

			if (value >= 1.0) {
				widget.onFinish?.call();
			}
		});

		streamDurSubsc = widget.streamDuration.listen((duration) {
			this.duration = duration;
		});
	}

	@override
	void dispose() {
		streamPosSubsc.cancel();
		streamDurSubsc.cancel();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return CircularProgressIndicator(value: value, backgroundColor: const Color(0xffdcdcdc),
				valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff1c56c0)),
				strokeWidth: 6.0);
	}
}
