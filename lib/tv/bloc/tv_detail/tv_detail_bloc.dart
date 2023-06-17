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
import '../../model/tv_detail_model.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailStateImp> {
  TvDetailBloc() : super(TvDetailInitial()) {
    on<TvDetailEvent>((event, emit) {
    });
    on<FetchTvDetailSEvent>(_onTvDetailsFetch);
  }
  void _onTvDetailsFetch(FetchTvDetailSEvent event,emit)async{
  try{
  var url = Apis.tv +event.id + Apis.urlLastPart;
  Response response = await http.get(Uri.parse(url));
  if(response.statusCode ==200){
  var jsonBody =jsonDecode(response.body);
  TvDetailModule tvDetailModule = TvDetailModule.fromJson(jsonBody);
  emit(state.copyWith(status: TvDetailStatus.success,tvDetailModule: tvDetailModule));
  }else{
  emit(state.copyWith(status: TvDetailStatus.failure));
  }
  }on SocketException catch(error){
  ScaffoldMessenger.of(RouteGenerator.navigatorKey.currentContext!)
      .showSnackBar(SnackBar(content: Text("no internet")));
  }
  }
  }
