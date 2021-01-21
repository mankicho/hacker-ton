import 'dart:async';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hackerton/FocusTime/focus_time.dart';
import 'package:hackerton/Time/stopwatch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with WidgetsBindingObserver {
  int _currentSec;
  var bottomSheetController;

  @override
  Widget build(BuildContext context) {
    AboutTime timer = Provider.of<AboutTime>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding:
          EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0, bottom: 20.0),
      decoration: BoxDecoration(color: Colors.black),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset("assets/png/timer_logo.png", height: 50),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 5.2,
                  height: 30,
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: Color(0xFFB69FF7),
                      child: Text(
                        "집중 모드",
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        setState(() {
                          count ++;
                        });
                        List<dynamic> result;
                        Future<List<dynamic>> future1 = _getPastTime();
                        await future1.then((value) => result = value,
                            onError: (e) => print(e));
                        for (int i = 0; i < result.length; i++) {
                          print(result[i]["focusTime"]);
                          times.add(result[i]["focusTime"]);
                        }
                        setState(() {
                          _bottomSheetOpened = true;
                        });
                        Future<int> future = _getCurTime();
                        await future.then((value) => _currentSec = value,
                            onError: (e) => print(e));
                        bottomSheetController = showModalBottomSheet(
                            context: context,
                            builder: _buildTimer,
                            backgroundColor: Colors.transparent)
                          ..whenComplete(() {
                            timer.pauseTimer();
                            setState(() {
                              _bottomSheetOpened = false;
                              count--;
                            });
                          });
                        if (!timer.isRunning) {
                          timer.startTimer();
                        }
                      }))
            ]),
        SizedBox(
          height: 20.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: Text(
                  "지금 $count명이",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.center,
                child: Text(
                  "초집중하고 있어요",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 20.0),
            Image.asset("assets/png/cat.png", height: 190),
          ],
        ),
        Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text("집중스터디 신청하기",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0))),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2.4,
                      height: MediaQuery.of(context).size.height / 3.3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: InkWell(
                          onTap: null,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("생성",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0))),
                                Image.asset("assets/png/cat2.png", height: 70,),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("나에게 맞는",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0)),
                                      SizedBox(height: 8.0),
                                      Text("집중스터디 만들기",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        color: Color(0xFF4A4B5B),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.4,
                      height: MediaQuery.of(context).size.height / 3.3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("참여",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0))),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset("assets/png/cat2.png", height: 50,),
                                      Image.asset("assets/png/cat2.png", height: 50,),
                                    ]
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset("assets/png/cat2.png", height: 50,),
                                      Image.asset("assets/png/cat2.png", height: 50,),
                                      Image.asset("assets/png/cat2.png", height: 50,),
                                    ]
                                  )
                                ]
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("나에게 맞는",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0)),
                                    SizedBox(height: 8.0),
                                    Text("집중스터디 찾아보기",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        color: Color(0xFFA8A344),
                      ),
                    )
                  ],
                )
              ],
            ))
      ]),
    );
  }

  bool _bottomSheetOpened;
  List<int> times;
  int count;
  @override
  void initState() {
    super.initState();
    _bottomSheetOpened = false;
    WidgetsBinding.instance.addObserver(this);
    times = [];
    count = 0;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_bottomSheetOpened) {
      if (state == AppLifecycleState.inactive) {
        Navigator.pop(context);
      }
    }
  }

  void _removeTime() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var time = DateTime.now();
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (time.hour == 21) {
        sp.remove("seconds");
      }
    });
  }

  Future<int> _getCurTime() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.getInt("seconds") == null) {
      sp.setInt("seconds", 0);
    }
    int currentSec = sp.getInt("seconds");
    return Future<int>(() {
      return currentSec;
    });
  }

  List<FocusTimeData> data;

  List<charts.Series<FocusTimeData, String>> _getSeriesData() {
    List<charts.Series<FocusTimeData, String>> series = [
      charts.Series(
        id: "FocusTime1",
        data: data,
        domainFn: (FocusTimeData data, _) => data.date.toString(),
        measureFn: (FocusTimeData data, _) => (data.time / 3600),
        colorFn: (FocusTimeData data, _) => data.barColor,
        fillColorFn: (FocusTimeData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.transparent),
      ),
      charts.Series(
        id: "FocusTime",
        data: data,
        domainFn: (FocusTimeData data, _) => data.date.toString(),
        measureFn: (FocusTimeData data, _) => (data.time / 3600),
        colorFn: (FocusTimeData data, _) => data.barColor,
      ),
      charts.Series(
        id: "FocusTime2",
        data: data,
        domainFn: (FocusTimeData data, _) => data.date.toString(),
        measureFn: (FocusTimeData data, _) => (data.time / 3600),
        colorFn: (FocusTimeData data, _) => data.barColor,
        fillColorFn: (FocusTimeData data, _) =>
            charts.ColorUtil.fromDartColor(Colors.transparent),
      )
    ];
    return series;
  }

  Future<List<dynamic>> _getPastTime() async {
    String url = "http://studyplanet.kr/member/timer/get.do";
    String body =
        "token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ6a3NwZmZoQG5hdmVyLmNvbSIsImV4cCI6MTYxMTY2MzE5NX0.AoohMYtBIGjLAGjDNC_GDEIVEMGUYdTfjBB0wGc4xqQ";
    Map<String, String> header = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    var response = await http.post(url, headers: header, body: body);
    List<dynamic> myResult = jsonDecode(response.body);

    return Future(() {
      return myResult;
    });
  }

  Widget _buildTimer(BuildContext context) {
    AboutTime timer = Provider.of<AboutTime>(context, listen: true);
    int totalTime = _currentSec + timer.seconds;
    int hour = (totalTime) ~/ (60 * 60);
    int min = (totalTime - (hour * 60 * 60)) ~/ 60;
    int sec = (totalTime) - (hour * 60 * 60) - (min * 60);
    int sum = 0;
    for (int i = 0; i < times.length; i++) {
      sum += times[i];
    }
    double mean = sum / 7;
    int mHour = mean ~/ (60 * 60);
    int mMinute = (mean - (hour * 60 * 60)) ~/ 60;
    data = [
      FocusTimeData(
          date: DateTime.now().day - 6,
          time: times[1],
          barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      FocusTimeData(
          date: DateTime.now().day - 5,
          time: times[2],
          barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      FocusTimeData(
          date: DateTime.now().day - 4,
          time: times[3],
          barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      FocusTimeData(
          date: DateTime.now().day - 3,
          time: times[4],
          barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      FocusTimeData(
          date: DateTime.now().day - 2,
          time: times[5],
          barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      FocusTimeData(
          date: DateTime.now().day - 1,
          time: times[6],
          barColor: charts.ColorUtil.fromDartColor(Colors.white)),
      FocusTimeData(
        date: DateTime.now().day,
        time: totalTime,
        barColor: charts.ColorUtil.fromDartColor(Colors.white),
      ),
    ];
    return Container(
      height: MediaQuery.of(context).size.height / 2.04,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0)),
          gradient: LinearGradient(
              begin: const Alignment(0.7, -0.5),
              end: const Alignment(0.6, 0.5),
              colors: [Color(0xFF4370C7), Color(0xFFB69FF7)])),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "집중시간",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text("다른 곳을 터치하면 시간이 정지합니다",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "${hour.toString().padLeft(2, "0")} : ${min.toString().padLeft(2, "0")} : ${sec.toString().padLeft(2, "0")}",
            style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "이번주 일일 평균 $mHour시간 $mMinute분",
            style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 160,
            child: charts.BarChart(
              _getSeriesData(),
              animate: true,
              barGroupingType: charts.BarGroupingType.grouped,
              domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                    tickLengthPx: 0,
                    labelRotation: 0,
                    labelStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white,
                    ),
                    lineStyle: charts.LineStyleSpec(
                      thickness: 0,
                      color: charts.MaterialPalette.white,
                    )),
              ),
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.white)),
              ),
            ),
          )
        ],
      ), //
    );
  }
}
