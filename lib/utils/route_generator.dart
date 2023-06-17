
import 'package:flutter/material.dart';
import '../movie/movie_model/movie_module.dart';
import '../movie/screens/movie_detail_screen.dart';
import '../pop_actor/screens/actor_detail_screen.dart';
import '../tv/model/tv_cast_model.dart';
import '../tv/model/tv_module.dart';
import '../tv/screens/tv_detail_screen.dart';
import './routes.dart';
class RouteGenerator{
  static  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Route<dynamic> onGenerator(RouteSettings setting){
    Object? arg= setting.arguments;
    switch(setting.name){
      case Routes.movieDetailScreen:
        return MaterialPageRoute(builder: (_)=> MovieDetailScreen(movieItem : arg as Results));
      case Routes.tvDetailScreen:
        return MaterialPageRoute(builder: (_)=> TvDetailScreen(tvShow : arg as TvShow));
      case Routes.actorDetailScreen:
        return MaterialPageRoute(builder: (_)=> ActorDetailScreen(cast : arg as Cast));

      default:
        return MaterialPageRoute(builder:(_)=>Scaffold());
    }
  }
}