import 'package:equatable/equatable.dart';

abstract class StatsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadStats extends StatsEvent {}
