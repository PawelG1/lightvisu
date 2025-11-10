import 'package:flutter_bloc/flutter_bloc.dart';

class SliderCubit extends Cubit<double>{
  SliderCubit(double initialState) : super(initialState);

  void change(double newValue) => emit(newValue);
}