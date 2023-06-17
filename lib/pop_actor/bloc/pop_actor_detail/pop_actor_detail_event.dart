part of 'pop_actor_detail_bloc.dart';

@immutable
abstract class PopActorDetailEvent {}
class FetchPopActorDetailEvent extends PopActorDetailEvent{
  final String actorId;
  FetchPopActorDetailEvent({required this.actorId});
}
