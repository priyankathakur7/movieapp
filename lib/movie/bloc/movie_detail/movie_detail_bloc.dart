import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../../utils/apis.dart';
import '../../../utils/route_generator.dart';
import '../../movie_model/movie_detail_module.dart';
part 'movie_detail_event.dart';
part 'movie_detail_state.dart';
class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailStateImp> {
  MovieDetailBloc() : super(MovieDetailInitial()) {
    on<MovieDetailEvent>((event, emit) {
    });
    on<FetchMovieDetailEvent>(_onMovieDetailFetch);
  }
  void _onMovieDetailFetch(FetchMovieDetailEvent event,emit)async{
    try{
      var url = Apis.movie +event.movieId + Apis.urlLastPart;
      Response response = await http.get(Uri.parse(url));
      if(response.statusCode ==200){
        var jsonBody =jsonDecode(response.body);
        MovieDetailModule movieDetailModule = MovieDetailModule.fromJson(jsonBody);
        emit(state.copyWith(status: MovieDetailStatus.success,  module: movieDetailModule));
      }else{
        emit(state.copyWith(status: MovieDetailStatus.failure));
      }
    }on SocketException catch(error){
      ScaffoldMessenger.of(RouteGenerator.navigatorKey.currentContext!)
          .showSnackBar(SnackBar(content: Text("no internet")));
    }
  }
}
