import 'package:final_day/pop_actor/screens/pop_actor_screen.dart';
import 'package:final_day/tv/screens/tv_screen.dart';
import 'package:final_day/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'custom_widget/custom_app_bar.dart';
import 'movie/screens/movie_screen.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  List<String> _tabs = ["Movie","Tv", "Popular Actor"];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: customAppBar(title: 'Movie App', bottomWidget:
        TabBar(
            unselectedLabelColor: AppColors.whiteColor,
            labelColor: AppColors.orangeColor,
            indicatorColor: AppColors.orangeColor,
            tabs: _tabs.map((e) {
              return Tab(text: e,);
            }).toList()
        ),
        ),
        body: TabBarView(children: [
          MovieScreen(),
          TvScreen(),
          PopActorScreen(),
        ]),
      ),
    );
  }
}
