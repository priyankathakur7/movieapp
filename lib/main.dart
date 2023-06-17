
import 'package:final_day/pop_actor/bloc/actor_bloc.dart';
import 'package:final_day/pop_actor/bloc/actor_detail/actor_detail_bloc.dart';
import 'package:final_day/pop_actor/bloc/pop_actor_detail/pop_actor_detail_bloc.dart';
import 'package:final_day/tv/bloc/tv_bloc.dart';
import 'package:final_day/tv/bloc/tv_cast/tv_cast_bloc.dart';
import 'package:final_day/tv/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:final_day/utils/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_screen.dart';
import 'movie/bloc/movie_bloc.dart';
import 'movie/bloc/movie_detail/movie_detail_bloc.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovieBloc(),
        ),
        BlocProvider(
          create: (context) => TvBloc(),
        ),
        BlocProvider(
          create: (context) => ActorBloc(),
        ),
        BlocProvider(create: (_)=>MovieDetailBloc()),
        BlocProvider(create: (_)=>TvDetailBloc()),
        BlocProvider(create: (_)=>PopActorDetailBloc()),
        BlocProvider(create: (_)=>TvCastBloc()),
        BlocProvider(create: (_)=>ActorDetailBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.onGenerator,
        navigatorKey: RouteGenerator.navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
      ),
    );
  }
}
