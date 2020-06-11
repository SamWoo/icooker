import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class AdBanner extends StatelessWidget {
  final _data;
  const AdBanner(this._data);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = ScreenUtil().setHeight(480);

    return Container(
      width: width,
      height: height,
      color: Colors.transparent,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(_data[index]['img'],
                  width: width, height: height, fit: BoxFit.fill),
            ),
          );
        },
        itemCount: _data.length,
        scrollDirection: Axis.horizontal,
        autoplay: true,
        pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
