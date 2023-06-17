import 'package:flutter/cupertino.dart';

import '../../utils/app_color.dart';
import '../model/tv_detail_model.dart';
class TvDetailTab extends StatefulWidget {
  final TvDetailModule detailModule;
  const TvDetailTab({Key? key, required this.detailModule}) : super(key: key);

  @override
  State<TvDetailTab> createState() => _TvDetailTabState();
}

class _TvDetailTabState extends State<TvDetailTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
          padding:  EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _customCardView(title: "Seasons",
                  value: widget.detailModule.numberOfSeasons.toString())),
              SizedBox(width: 5,),
              Expanded(child: _customCardView(title: "Episode",
                  value: widget.detailModule.numberOfEpisodes.toString())),
              SizedBox(width: 5,),
              Expanded(child: _customCardView(title: "Last Air Date",
                  value: widget.detailModule.lastAirDate.toString())),
            ],
          ),
        ),
        Padding(
          padding:  EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(child: _customCardView(title: "Type",
                  value: widget.detailModule.type.toString())),
              SizedBox(width: 6,),
              Expanded(child: _customCardView(title: "Status",
                  value: widget.detailModule.status))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _customCardView(title: "Overview",
              value: widget.detailModule.overview),
        ),
      ],
    )
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
}
