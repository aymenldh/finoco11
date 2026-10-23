import 'package:finoco/core/repository/dbhelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc() : super(StatsInitial());

  @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is LoadStats) {
      yield* loadStats();
    }
  }

  // Upload current database to Firebase Storage
  Stream<StatsState> loadStats() async* {
    yield StatsInProgress();
    try {
      final stats = await DatabaseHelper.instance.getStats();
      yield StatsSuccess(stats);
    } catch (e) {
      yield StatsFailure("Error uploading database: $e");
    }
  }
}
