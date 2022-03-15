import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../quiz_repo.dart';

enum SplashStatus { initial, loading, success, failure }

class SplashState extends Equatable {
	final SplashStatus status;

	SplashState({this.status = SplashStatus.initial});

	@override
  List<Object?> get props => [status,];

	bool get isLoading => status == SplashStatus.initial || status == SplashStatus.loading;
}

class SplashCubit extends Cubit<SplashState> {
	final QuizRepo _quizRepo;

	SplashCubit(this._quizRepo): super(SplashState()) {
		init();
	}

	Future<void> init() async {
		emit(SplashState(status: SplashStatus.loading));

		var isAuth = await _quizRepo.init();
		if (isAuth) {
			emit(SplashState(status: SplashStatus.success));
		} else {
			emit(SplashState(status: SplashStatus.failure));
		}
	}
}
