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
          height: MediaQuery.of(context).size.height - 150,
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
                              const Padding(padding: EdgeInsets.all(40.0)),
                              Text(
                                widget.filteredData[widget.index]
                                    ['description'],
                                style: const TextStyle(
                                    wordSpacing: 2,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FilledButton(
                                    onPressed: () async {
                                      HapticFeedback.mediumImpact();
                                      _launchUrl();
                                    },
                                    child: null,
                                  )),
                              Link(
                                uri: Uri.parse(
                                    '${widget.filteredData[widget.index]['url']}'),
                                target: LinkTarget.blank,
                                builder:
                                    (BuildContext ctx, FollowLink? openLink) {
                                  return TextButton.icon(
                                    onPressed: openLink,
                                    label:
                                        const Text('Link Widget documentation'),
                                    icon: const Icon(Icons.read_more),
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

  Future<void> _launchUrl() async {
    Uri url = widget.filteredData[widget.index]['url'];
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception(
          'Could not launch ${widget.filteredData[widget.index]['url']}');
    }
  }
}
