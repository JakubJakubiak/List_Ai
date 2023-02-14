import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './state_management.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final stateManager = HomePageManager();

  @override
  Widget build(BuildContext context) {
    _makeGetRequest();
    return Column(children: [
      const SizedBox(height: 50),
      Center(
        child: Wrap(
          spacing: 50,
          alignment: WrapAlignment.center,
        ),
      ),
      const SizedBox(height: 20),
      ValueListenableBuilder<RequestState>(
          valueListenable: stateManager.resultNotifier,
          builder: (context, requestState, child) {
            if (requestState is RequestLoadInProgress) {
              return const CircularProgressIndicator();
            } else if (requestState is RequestLoadSuccess) {
              List<dynamic> jsonData = jsonDecode(requestState.body);
              List<Map<String, dynamic>> filteredData = jsonData.map((item) {
                return {
                  "id": item['id'],
                  "name": item['title'],
                };
              }).toList();
              return SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Text(filteredData[index]['name']),
                          ],
                        );
                      }));
            } else {
              return Container();
            }
          })
    ]);
  }

  Future<void> _makeGetRequest() async {
    await stateManager.makeGetRequest();
  }
}
