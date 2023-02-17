import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        appBar: AppBar(),
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
      const SizedBox(height: 50),
      Center(
        child: Wrap(
          spacing: 50,
          alignment: WrapAlignment.center,
        ),
      ),
      const SizedBox(height: 0),
      ValueListenableBuilder<RequestState>(
          valueListenable: widget.stateManager.resultNotifier,
          builder: (context, requestState, child) {
            if (requestState is RequestLoadInProgress) {
              return const CircularProgressIndicator();
            } else if (requestState is RequestLoadSuccess) {
              List<dynamic> jsonData = jsonDecode(requestState.body);
              List<Map<String, dynamic>> _allResults = jsonData.map((item) {
                return {
                  "id": item['id'],
                  "name": item['title'],
                };
              }).toList();

              if (_searchResults.isEmpty &&
                  searchController.selection.baseOffset == -1)
                _searchResults = _allResults;

              void _performSearch(searchText) {
                _searchResults = _allResults
                    .where((element) => element['name']
                        .toLowerCase()
                        .contains(searchText.toLowerCase()))
                    .toList();
                print(_searchResults.length);
                setState(() {
                  _searchResults = _searchResults;
                });
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                child:

                    // _searchResults.isNotEmpty
                    //     ?
                    Column(children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                    ),
                    onChanged: (value) async => _performSearch(value),
                  ),

                  Expanded(
                      child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: FilledButton(
                                      onPressed: () async {
                                        HapticFeedback.mediumImpact();
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) => Favorite(
                                                      context,
                                                      _searchResults,
                                                      index,
                                                    )));
                                      },
                                      child: Column(children: [
                                        SizedBox(
                                            height: 100,
                                            width: 300,
                                            child: Text(
                                              _searchResults[index]['name'],
                                              style: const TextStyle(
                                                  wordSpacing: 2,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ]),
                                    )),
                              ],
                            );
                          })),
                  // : const Text('No search results'),
                ]),
              );
            } else {
              return Container();
            }
          })
    ]);
  }
}
