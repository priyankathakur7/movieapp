part of 'movie_detail_bloc.dart';
enum MovieDetailStatus{
  initial,
  loading,
  failure,
  success,
}
@immutable
abstract class MovieDetailState extends Equatable{
  final MovieDetailStatus status;
  final MovieDetailModule module;
  MovieDetailState({
    required this.status,
    required this.module,
  });
  @override
  List<Object?> get props => [
    status,
    module,
  ];
}
class MovieDetailStateImp extends MovieDetailState{
  MovieDetailStateImp({
    required super.status,
    required super.module,
    });
  MovieDetailStateImp copyWith({
    MovieDetailStatus ? status,
    MovieDetailModule ? module,
  })  {
    return MovieDetailStateImp(
      status: status ?? this.status,
      module: module ?? this.module,
    );
  }
}
class MovieDetailInitial extends MovieDetailStateImp{
  MovieDetailInitial():super(
    status: MovieDetailStatus.initial,
    module: MovieDetailModule(),
  );
}

