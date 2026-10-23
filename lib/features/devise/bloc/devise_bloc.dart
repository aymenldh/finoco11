import 'package:finoco/core/models/devise.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'devise_event.dart';
import 'devise_state.dart';

class DeviseBloc extends Bloc<DeviseEvent, DeviseState> {
  List<Devise> _devises = [];

  DeviseBloc() : super(DevisesLoading()) {
    on<LoadDevises>((event, emit) async {
      emit(DevisesLoading());
      final result = await DatabaseHelper.instance.getAllDevises();
      _devises = result.map((e) => Devise.fromJson(e)).toList();
      emit(DevisesLoaded(List.from(_devises)));
    });

    on<AddDevise>((event, emit) async {
      emit(DevisesLoading());
      await DatabaseHelper.instance.insertDevise(event.devise.toJson());
      final result = await DatabaseHelper.instance.getAllDevises();
      _devises = result.map((e) => Devise.fromJson(e)).toList();
      emit(DevisesLoaded(List.from(_devises)));
    });

    on<DeleteDevise>((event, emit) async {
      emit(DevisesLoading());
      await DatabaseHelper.instance.deleteDevise(event.devise);
      final result = await DatabaseHelper.instance.getAllDevises();
      _devises = result.map((e) => Devise.fromJson(e)).toList();
      emit(DevisesLoaded(List.from(_devises)));
    });
  }
}
