import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

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
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Scaffold(
                    body: Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: SizedBox(
                              child: Stack(children: [
                            Column(children: [
                              Hero(
                                tag:
                                    '${widget.filteredData[widget.index]['url']}',
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${widget.filteredData[widget.index]['imgSrc']}',
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                              ),
                              Text(
                                widget.filteredData[widget.index]
                                    ['description'],
                                style: const TextStyle(
                                    wordSpacing: 2,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              Link(
                                uri: Uri.parse(
                                    '${widget.filteredData[widget.index]['url']}'),
                                target: LinkTarget.blank,
                                builder:
                                    (BuildContext ctx, FollowLink? openLink) {
                                  return FilledButton(
                                    onPressed: openLink,
                                    child: const Text('Link documentation'),
                                  );
                                },
                              ),
                            ])
                          ])),
                        )),
                  )),
            ],
          )),
    );
  }
}
