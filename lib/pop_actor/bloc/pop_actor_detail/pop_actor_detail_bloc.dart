import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../../utils/apis.dart';
import '../../../utils/route_generator.dart';
part 'pop_actor_detail_event.dart';
part 'pop_actor_detail_state.dart';
class PopActorDetailBloc extends Bloc<PopActorDetailEvent, PopActorDetailStateImp> {
  PopActorDetailBloc() : super(PopActorDetailInitial()) {
    on<PopActorDetailEvent>((event, emit) {
    });
    on<FetchPopActorDetailEvent>(_onPopActorDetailFetch);
  }
  void _onPopActorDetailFetch(FetchPopActorDetailEvent event,emit)async{
    try{
      var url = Apis.celebs +event.actorId + Apis.getCelebs;
      Response response = await http.get(Uri.parse(url));
      if(response.statusCode ==200){
        var jsonBody =jsonDecode(response.body);
        emit(state.copyWith(status: PopActorDetailStatus.success,));
      }else{
        emit(state.copyWith(status: PopActorDetailStatus.failure));
      }
    }on SocketException catch(error){
      ScaffoldMessenger.of(RouteGenerator.navigatorKey.currentContext!)
          .showSnackBar(SnackBar(content: Text("no internet")));
    }
  }
}

