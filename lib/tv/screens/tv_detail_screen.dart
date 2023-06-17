import 'dart:convert';
import 'dart:io';
import 'package:final_day/tv/screens/tv_cast_screen.dart';
import 'package:final_day/tv/screens/tv_detail_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../../custom_widget/custom_app_bar.dart';
import '../../movie/movie_model/backdrop_file_module.dart';
import '../../utils/apis.dart';
import 'package:http/http.dart';
import '../../utils/app_color.dart';
import '../bloc/tv_detail/tv_detail_bloc.dart';
import '../model/tv_module.dart';

class TvDetailScreen extends StatefulWidget {
  final TvShow tvShow;

  const TvDetailScreen({Key? key, required this.tvShow}) : super(key: key,);

  @override
  State<TvDetailScreen> createState() => _TvDetailScreenState();
}

class _TvDetailScreenState extends State<TvDetailScreen>
    with SingleTickerProviderStateMixin{
  List<Backdrops>filePathList=[];
  TabController ? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    BlocProvider.of<TvDetailBloc>(context).add(
        FetchTvDetailSEvent(id: widget.tvShow.id.toString()));
    fetchFilePath();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
    child: Scaffold(
      appBar: customAppBar(
        title: widget.tvShow.name,),
      body: BlocBuilder<TvDetailBloc, TvDetailStateImp>(
        builder: (context, state) {
          if (state.status == TvDetailStatus.success) {
            String genre = "";
            if (state.tvDetailModule.genres != null) {
              state.tvDetailModule.genres!.forEach((element) {
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
                else
                  Container(
                    alignment: Alignment.center,
                    height: 200,
                    child: CircularProgressIndicator(),
                  ),
                SizedBox(height: 3,),
                Padding(padding: EdgeInsets.all(4),
                  child: Container(
                    height: 150,
                    color: Colors.blue,
                    child: Column(
                    children :[
                      Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.network(
                          Apis.imgHeader +
                              state.tvDetailModule.posterPath.toString(),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.tvDetailModule.status.toString(),
                                      style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25),
                                    ),
                                    SizedBox(height: 10,),
                                    if (state.tvDetailModule.genres != null)
                                      Text(
                                        "Geners: $genre",
                                        style: TextStyle(
                                            color: AppColors.whiteColor),
                                      ),
                                    SizedBox(height: 10,),
                                    Text("Original Language: ${state.tvDetailModule
                                        .originalLanguage}",
                                      style: TextStyle(
                                          color: AppColors.whiteColor),
                                    ),
                                    SizedBox(height: 5,),
                                  ],
                                )
                            )
                        ),
                        ]
                      ),
                      TabBar(
                          controller: _tabController,
                          indicatorColor: AppColors.orangeColor,
                          labelColor: AppColors.orangeColor,
                          unselectedLabelColor: AppColors.whiteColor,
                          tabs: [
                        Tab(text: "Details",),
                        Tab(text: "Cast",),
                      ]),
                      ],
                    ),
                  ),
                ),
                Expanded(child: TabBarView(
                    controller: _tabController,
                    children: [
                 TvDetailTab(detailModule: state.tvDetailModule,),
                  TvCastScreen(tvShowId: widget.tvShow.id.toString(),),

                ]
                ))
              ],
            );
          } else if (state.status == TvDetailStatus.failure);
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
        },
      ),
    ),
    );
  }
  void fetchFilePath() async {
    try {
      var url = Apis.tv + widget.tvShow.id.toString() + Apis.imgLastUrl;
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