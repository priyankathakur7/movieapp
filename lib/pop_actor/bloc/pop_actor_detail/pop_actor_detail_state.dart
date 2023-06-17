part of 'pop_actor_detail_bloc.dart';
enum PopActorDetailStatus {
  initial,
  loading,
  failure,
  success,
}
@immutable
abstract class PopActorDetailState {
  final PopActorDetailStatus status;
  PopActorDetailState({
  required this.status,
  });
  @override
  List<Object?> get props => [status,];
}
class PopActorDetailStateImp extends PopActorDetailState {
  PopActorDetailStateImp({
    required PopActorDetailStatus status,
  }) : super(status: status,);

  PopActorDetailStateImp copyWith({
    PopActorDetailStatus? status,

  }) {
    return PopActorDetailStateImp(
      status: status ?? this.status,
    );
  }
}
class PopActorDetailInitial extends PopActorDetailStateImp {
  PopActorDetailInitial()
      : super(
    status: PopActorDetailStatus.initial,
  );
}
