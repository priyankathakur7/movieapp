
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../movie/movie_model/movie_module.dart';
import '../../tv/bloc/tv_cast/tv_cast_bloc.dart';
import '../../tv/model/tv_cast_model.dart';
import '../../tv/model/tv_module.dart';
import '../../utils/apis.dart';
import '../../utils/app_color.dart';
import '../../utils/routes.dart';
import '../actor_model/shows_model.dart';
class TvMoviesShowTab extends StatefulWidget {
  final String actorId;
  const TvMoviesShowTab({Key? key, required this.actorId}) : super(key: key);
  @override
  State<TvMoviesShowTab> createState() => _TvMoviesShowTabState();
}
class _TvMoviesShowTabState extends State<TvMoviesShowTab> {
@override
  void initState() {
    BlocProvider.of<TvCastBloc>(context).add(FetchActorShowsEvent(id: widget.actorId));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvCastBloc, TvCastStateImp>(
  builder: (context, state) {
    if(state.status==TvCastStatus.showFetchSuccess)
    return GridView.builder(
      itemCount: state.combinedCreditList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemBuilder: (context,index){
        return _showsView(state.combinedCreditList[index]);
      }
    );
    else if(state.status==TvCastStatus.showFetchFailure)
      return Container(
        alignment: Alignment.center,
        child: Text("Something Went Wrong"),
      );
    else
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
  },
);
  }
Widget _showsView(ShowsCast cast) {
  return Padding(padding: EdgeInsets.all(5),
    child: InkWell(
      onTap: () {
        if (cast.mediaType == "tv") {
          Navigator.pushNamed(context, Routes.tvDetailScreen,
              arguments: TvShow(id: cast.id, name: cast.name)
          );
        } else if (cast.mediaType == "tv") {
          Navigator.pushNamed(context, Routes.movieDetailScreen,
              arguments: Results(id: cast.id,title: cast.title));
        }
      },
    child: Container(
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [BoxShadow(spreadRadius: 0.1)]
      ),
      child: Column(
        children: [
          // if(cast.profilePath!=null)
          Image.network(Apis.imgHeader + (cast.mediaType =="movie"? cast.posterPath.toString():
              cast.backdropPath.toString()),
            height: 45,fit:BoxFit.fitWidth,
            width: double.infinity,
            errorBuilder: (context,_,trace){
              return Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text("No image!"));
            },
          ),
          SizedBox(height: 2,),
          Center(child: Padding(padding: EdgeInsets.all(5),
            child: Text(cast.mediaType =="movie"? cast.title.toString()
            :cast.name.toString(),
              maxLines: 2, textAlign:TextAlign.center,),
          )
          ),
        ],
      ),
    ),
    )
  );
}
}
