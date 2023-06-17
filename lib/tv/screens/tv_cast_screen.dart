
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/apis.dart';
import '../../utils/app_color.dart';
import '../../utils/routes.dart';
import '../bloc/tv_cast/tv_cast_bloc.dart';
import '../model/tv_cast_model.dart';

class TvCastScreen extends StatefulWidget {
  final String tvShowId;
  const TvCastScreen({Key? key, required this.tvShowId}) : super(key: key);

  @override
  State<TvCastScreen> createState() => _TvCastScreenState();
}
class _TvCastScreenState extends State<TvCastScreen> {
  @override
  void initState() {
BlocProvider.of<TvCastBloc>(context).add(FetchCastEvent(id: widget.tvShowId));
super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvCastBloc, TvCastStateImp>(
        builder: (context, state){
        if (state.status == TvCastStatus.success) {
          if(state.tvCastList.length>0)
          return GridView.builder(
              itemCount: state.tvCastList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
              itemBuilder: (context, index) {
                return _actorView(state.tvCastList[index]);
              });
          else return Container(
            alignment: Alignment.center,
            child: Text("No Cast Found")
          );
        }
        else if (state.status == TvCastStatus.failure)
          return Container(
            alignment: Alignment.center,
            child: Text("Something Went Wrong"),
          );
        else
          return Container(
            alignment: Alignment.center,
            child:
            CircularProgressIndicator
              (),
          );
      });
  }
  Widget _actorView(Cast cast) {
    return Padding(padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, Routes.actorDetailScreen,
          arguments: Cast(id: cast.id, name: cast.name));
        },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [BoxShadow(spreadRadius: 0.1)]
        ),
        child: Column(
          children: [
            // if(cast.profilePath!=null)
            Image.network(Apis.imgHeader + cast.profilePath.toString(),
              height: 55,fit:BoxFit.fitWidth,
            width: double.infinity,
            errorBuilder: (context,_,trace){
              return Container(
                height: 80,
                alignment: Alignment.center,
                child: Text("No image!"));
            },
         ),
            // SizedBox(height: 2,),
            // Center(child: Padding(padding: EdgeInsets.all(5),
            //   child: Text(cast.name.toString(), maxLines: 2,textAlign:TextAlign.center,),
            // )
            // ),
          ],
        ),
      ),
      )
    );
  }
}

