import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fasting_event.dart';
part 'fasting_state.dart';

class FastingBloc extends Bloc<FastingEvent, FastingState> {
  FastingBloc() : super(FastingInitial()) {
    on<FastStarted>(_onFastStarted);
    on<FastEnded>(_onFastEnded);
  }

  void _onFastStarted(FastStarted event, Emitter<FastingState> emit) {
    emit(FastingInProgress());
  }

  void _onFastEnded(FastEnded event, Emitter<FastingState> emit) {
    emit(FastingInitial());
  }
}
