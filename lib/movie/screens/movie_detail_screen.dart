import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../custom_widget/custom_app_bar.dart';
import '../../utils/apis.dart';
import '../../utils/app_color.dart';
import '../bloc/movie_detail/movie_detail_bloc.dart';
import '../movie_model/backdrop_file_module.dart';
import '../movie_model/movie_module.dart';
class MovieDetailScreen extends StatefulWidget {
  final Results movieItem;

  const MovieDetailScreen({Key? key, required this.movieItem})
      : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  List<Backdrops> filePathList = [];

  @override
  void initState() {
    BlocProvider.of<MovieDetailBloc>(context)
        .add(FetchMovieDetailEvent(movieId: widget.movieItem.id.toString()));
    fetchFilePath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: widget.movieItem.title),
      body: BlocBuilder<MovieDetailBloc, MovieDetailStateImp>(
        builder: (context, state) {
          if (state.status == MovieDetailStatus.success) {
            String genre = "";
            if (state.module.genres != null) {
              state.module.genres!.forEach((element) {
                genre = genre +
                    (genre.isNotEmpty ? " ," : "") +
                    element.name.toString();
              });
            }
            return Column(
              children: [
                if (filePathList.length > 0)
                  CarouselSlider(
                    options: CarouselOptions(
                        height: 150,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.1),
                    items: filePathList.map((e) {
                      return Image.network(
                        Apis.imgHeader + e.filePath.toString(),
                        fit: BoxFit.cover,
                      );
                    }).toList(),
                  )
                else Container(
                alignment: Alignment.center,
                height: 200,
                child: CircularProgressIndicator(),
                ),
                SizedBox(height: 3,),
                Padding(padding: EdgeInsets.all(4),
                child: Container(
                  height: 90,
                  color: Colors.blue,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        Apis.imgHeader +
                            state.module.posterPath.toString(),
                        width: 90,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                       Expanded(
                         child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.module.title.toString(),
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25),
                              ),
                              SizedBox(height: 10,),
                              if (state.module.genres != null)
                                Text(
                                  "Geners: $genre",
                                  style: TextStyle(color: AppColors.whiteColor),
                                ),
                              SizedBox(height: 10,),
                              Text("Original Language: ${state.module.originalLanguage}",
                                style: TextStyle(color: AppColors.whiteColor),
                              ),
                              SizedBox(height: 5,),
                              // Text("Release Date: ${state.module.releaseDate}",
                              // style: TextStyle(color: AppColors.whiteColor),
                              // ),
                              // SizedBox(height: 10,),
                              // Text("OverView: ${state.module.overview}",
                              //   style: TextStyle(color: AppColors.whiteColor),
                              // ),
                              // SizedBox(height: 10,),
                              // Text("Run-Time: ${state.module.runtime} Minutes",
                              //   style: TextStyle(color: AppColors.whiteColor),
                              // ),
                              // SizedBox(height: 10,),
                              // Text("Budget: ${state.module.budget}",
                              //   style: TextStyle(color: AppColors.whiteColor),
                              // ),
                              // SizedBox(height: 10,),
                              // Text("Revenue: ${state.module.revenue}",
                              //   style: TextStyle(color: AppColors.whiteColor),
                              // ),
                            ],
                          )
                      )
                       ),
                    ],
                  ),
                ),
              ),
                SizedBox(height: 2,),
                Padding(padding: EdgeInsets.all(8),
                  child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child:
                    Padding(padding: EdgeInsets.all(5),
                    child:_customCardView(
                        title: "Budget", value: state.module.budget.toString()))),
                    SizedBox(width: 4,),
                  Padding(padding: EdgeInsets.all(5),child:Expanded(
                      child: _customCardView(title: "Revenue", value: state.module.revenue.toString()))),
                    SizedBox(width: 4,),
                  Padding(padding: EdgeInsets.all(5),child: Expanded(
                      child:_customCardView(title: "Release Date", value: state.module.releaseDate.toString()))),
                    SizedBox(width: 4,),
                  ],
                )
                  ),
                SizedBox(height: 5,),
              Padding(padding: EdgeInsets.all(8),
              child:Row(
                  children: [
                    Expanded(child:
                    _customCardView(title: "Runtime", value: state.module.runtime.toString())),
                    SizedBox(width: 5,),
                    Expanded(child:
                    _customCardView(title: "Status", value: state.module.status.toString())),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(5),
                child:Expanded(child:
                _customCardView(title: "OverView", value: state.module.overview.toString())),
              ),
              ],
            );
          } else if (state.status == MovieDetailStatus.failure)
            return Container(
              alignment: Alignment.center,
              child: Text("Something went wrong!"),
            );
          else
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }
  Widget _customCardView({required String title, String? value}){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color:AppColors.whiteColor,
        boxShadow: [BoxShadow(spreadRadius: 0.2)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,),
          SizedBox(height: 5,),
          Text(value??"-"),
        ],
      ),
    );
  }

  void fetchFilePath() async {
    try {
      var url = Apis.movie + widget.movieItem.id.toString() + Apis.imgLastUrl;
      Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body);
        BackDropModule imageModel = BackDropModule.fromJson(jsonBody);
        if (imageModel.backdrops != null) {
          filePathList = imageModel.backdrops!;
          setState(() {});
        }
      } else {}
    } on SocketException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No internet")));
    } on Error catch (e) {
      print(e);
    }
  }
}






// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import '../../custom_widget/custom_app_bar.dart';
// import '../../utils/apis.dart';
// import '../../utils/app_color.dart';
// import '../bloc/movie_detail/movie_detail_bloc.dart';
// import '../movie_model/backdrop_file_module.dart';
// import '../movie_model/movie_module.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// class MovieDetailsScreen extends StatefulWidget {
//   final Results movieItem;
//   const MovieDetailsScreen({Key? key,required this.movieItem}) : super(key: key);
//
//   @override
//   State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
// }
// class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
//
//   List<BackDrops> filePathList = [];
//
//
//   @override
//   void initState() {
//     BlocProvider.of<MovieDetailBloc>(context).add(
//         FetchMovieDetailEvent(movieId: widget.movieItem.id.toString()));
//     super.initState();
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: customAppBar(
//             title: widget.movieItem.title),
//         body: BlocBuilder<MovieDetailBloc, MovieDetailStateImp>(
//             builder: (context, state) {
//               if (state.status == MovieDetailStatus.success){
//                 String gener ="";
//                 if(state.module.genres!=null){
//                   state.module.genres.forEach((element) {
//                     gener = gener +  (gener.isNotEmpty ?? "" :"" +element.
//                   })
//                 }
//               }
//                 return Column(
//                   children: [
//                     if(filePathList.length>0)
//                       CarouselSlider(
//                         options: CarouselOption(
//                         height: 200,
//                         autoPlay: true,
//                           enlargerCenterPage:true,
//                         enlargeFactor :0.1;
//                       ),
//                     item: filePathList.map((e){
//               return Image.network(Apis.img.Header +e.filePath.toString, fit: BoxFit.cover,);
//               }).toList(),
//                       ),
//                     SizedBox(height: 10,),
//                     Container(
//                       height: 100,
//                       color: Colors.blue,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Image.network(Apis.imgHeader +state.module.posterPath.toString(),
//                             width: 100,
//                           fit: BoxFit.cover,),
//                           SizedBox(width: 10,),
//                           Expanded(child: Column(
//                             children: [
//                               Text(state.module.title.toString(),style: TextStyle(
//                                 color: AppColors.whiteColor,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 17,
//                               ),),
//                               if(state.module.genres!= null)
//                                 Text("geners: $genre",
//                                 style: TextStyle(
//                                   color: AppColors.whiteColor,
//                                 ),)
//                               SizedBox(height: 10,),
//                               Text("Original")
//
//                             ],
//                           ))
//                         ],
//                       ),
//                     )
//                   ],
//                 );
//                 return Container(
//                   alignment: Alignment.center,
//                   child: Text("Something Wrong!"),
//                 );
//               else
//                 return Container(
//                   alignment: Alignment.center,
//                   child: CircularProgressIndicator(),
//                 );
//             }
//         )
//     );
//   }
//
//
//   void fetchFilePath() async {
//     try {
//       var url = Apis.movie + widget.movieItem.id.toString() + Apis.imgLastUrl;
//       Response response = await http.get(Uri.parse(Apis.getMovie));
//       if (response.statusCode == 200) {
//         var jsonBody = jsonDecode(response.body);
//         BackDropModule imageModel = BackDropModule.fromJson(jsonBody);
//         if (imageModel.backdrops != null) {
//           filePathList = imageModel.backdrops!;
//           setState(() {});
//         }
//
//       }
//     }
//   }
// }
