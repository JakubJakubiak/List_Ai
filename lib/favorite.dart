import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './main.dart';

class Favorite extends StatefulWidget {
  final BuildContext context;
  final dynamic filteredData;
  final int index;

  Favorite(
    this.context,
    this.filteredData,
    this.index,
  ) : super(key: UniqueKey());

  @override
  createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<Favorite> {
  bool isInFavoritess = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Scaffold(
                  body: Container(
                      margin: const EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: SizedBox(
                            height: 100,
                            child: Stack(children: [
                              Column(
                                  verticalDirection: VerticalDirection.up,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(
                                        top: 50.0,
                                        left: 50.0,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.filteredData[widget.index]
                                              ['name'],
                                        ),
                                      ],
                                    ),
                                  ])
                            ])),
                      ))),
            ],
          )),
    );
  }
}
