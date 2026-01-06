import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {
  final String email;
  const LoadHistoryEvent(this.email);

  @override
  List<Object> get props => [email];
}

class DeleteHistoryEvent extends HistoryEvent {
  final int id;
  final String email;

  const DeleteHistoryEvent({required this.id, required this.email});

  @override
  List<Object> get props => [id, email];
}
