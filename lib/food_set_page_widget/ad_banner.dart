import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class AdBanner extends StatelessWidget {
  final data;
  const AdBanner({this.data});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = ScreenUtil().setHeight(480);

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(vertical:8.0,horizontal:8.0),
      color: Colors.transparent,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(data[index]['img'],
                  width: width, height: height, fit: BoxFit.fill),
            ),
          );
        },
        itemCount: data.length,
        scrollDirection: Axis.horizontal,
        autoplay: true,
        pagination: SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
