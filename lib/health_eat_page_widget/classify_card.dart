import 'package:flutter/material.dart';

class ClassfiyCard extends StatelessWidget {
  final data;
  const ClassfiyCard({this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Stack(
        children: <Widget>[
          Image.network(data['img'], fit: BoxFit.fill),
          Positioned(
            left: 8.0,
            bottom: 10.0,
            child: Container(
              child: Column(
                children: data['class'].map<Widget>((it) {
                  return Chip(label: it);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
