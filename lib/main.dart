import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import './state_management.dart';
import 'favorite.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stateManager = HomePageManager();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: MyHomePage(stateManager: stateManager),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HomePageManager stateManager;
  const MyHomePage({Key? key, required this.stateManager}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    widget.stateManager.makeGetRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: Wrap(
          spacing: 50,
          alignment: WrapAlignment.center,
        ),
      ),
      ValueListenableBuilder<RequestState>(
          valueListenable: widget.stateManager.resultNotifier,
          builder: (context, requestState, child) {
            if (requestState is RequestLoadInProgress) {
              return const Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Center(child: CircularProgressIndicator()));
            } else if (requestState is RequestLoadSuccess) {
              List<dynamic> jsonData = jsonDecode(requestState.body);
              List<Map<String, dynamic>> _allResults = jsonData.map((item) {
                return {
                  "imgSrc": item['imgSrc'],
                  "text": item['text'],
                  "description": item["description"],
                  "dolar": item["dolar"],
                  "isFree": item["isFree"],
                  "tag": item["tag"],
                  "url": item["url"],
                };
              }).toList();

              if (_searchResults.isEmpty &&
                  searchController.selection.baseOffset == -1)
                _searchResults = _allResults;

              void _performSearch(searchText) {
                _searchResults = _allResults
                    .where((element) => element['text']
                        .toLowerCase()
                        .contains(searchText.toLowerCase()))
                    .toList();
                print(_searchResults.length);
                setState(() {
                  _searchResults = _searchResults;
                });
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: TextFormField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  fillColor: Colors.grey,
                                  focusColor: Colors.grey,
                                  border: InputBorder.none,
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  )),
                              onChanged: (value) async => {
                                    _performSearch(value),
                                  }))),
                  Expanded(
                      child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () => {
                                      HapticFeedback.mediumImpact(),
                                      Navigator.push(
                                          context,
                                          CupertinoDialogRoute(
                                              builder: (context) => Favorite(
                                                    context,
                                                    _searchResults,
                                                    index,
                                                  ),
                                              context: context)),
                                    },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Card(
                                      child: Column(children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.all(40.0),
                                        child: SizedBox(
                                          child: Stack(children: <Widget>[
                                            Container(
                                              height: 200,
                                            ),
                                            Column(
                                              children: [
                                                Hero(
                                                  tag:
                                                      '${_searchResults[index]['url']}',
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            '${_searchResults[index]['imgSrc']}',
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 200,
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      )),
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10)),
                                                Text(
                                                  _searchResults[index]['text'],
                                                  style: const TextStyle(
                                                      wordSpacing: 2,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                _searchResults[index]
                                                            ['dolar'] ==
                                                        ''
                                                    ? const Text('')
                                                    : FilledButton(
                                                        onPressed: null,
                                                        child: Text(
                                                          _searchResults[index]
                                                              ['dolar'],
                                                          style: const TextStyle(
                                                              wordSpacing: 2,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                FilledButton(
                                                    onPressed: null,
                                                    child: Text(
                                                      _searchResults[index]
                                                          ['isFree'],
                                                      style: const TextStyle(
                                                          wordSpacing: 2,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Text(
                                                  _searchResults[index]
                                                      ['description'],
                                                  maxLines: 4,
                                                  style: const TextStyle(
                                                      wordSpacing: 2,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          ]),
                                        ))
                                  ])),
                                ));
                          })),
                ]),
              );
            } else {
              return Container();
            }
          })
    ]);
  }
}
