part of 'tv_detail_bloc.dart';

@immutable
abstract class TvDetailEvent {}
class FetchTvDetailSEvent extends TvDetailEvent{
  final String id;
  FetchTvDetailSEvent({required this.id});
}
