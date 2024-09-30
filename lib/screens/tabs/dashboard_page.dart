import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart' as pie;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../widgets/text_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    getTotalFare();
    getBookings();
    super.initState();
  }

  List fares = [];

  bool hasLoaded = false;

  double total = 0;
  double today = 0;
  double average = 0;

  double monday = 0;
  double tuesday = 0;
  double wednesday = 0;
  double thursday = 0;
  double friday = 0;
  double saturday = 0;
  double sunday = 0;

  double rides = 0;
  double cancelled = 0;
  double pendings = 0;

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Mon', monday),
      ChartData('Tue', tuesday),
      ChartData('Wed', wednesday),
      ChartData('Thu', thursday),
      ChartData('Fri', friday),
      ChartData('Sat', saturday),
      ChartData('Sun', sunday),
    ];
    return Scaffold(
      body: hasLoaded
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                      child: Column(
                        children: [
                          TextRegular(
                              text: 'Number of bookings per week',
                              fontSize: 18,
                              color: Colors.black),
                          const SizedBox(
                            height: 10,
                          ),
                          // SfCartesianChart(
                          //     primaryXAxis: CategoryAxis(),
                          //     series: <ChartSeries<ChartData, String>>[
                          //       // Renders column chart
                          //       ColumnSeries<ChartData, String>(
                          //           dataSource: chartData,
                          //           xValueMapper: (ChartData data, _) => data.x,
                          //           yValueMapper: (ChartData data, _) => data.y)
                          //     ]),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextRegular(
                              text: 'Bookings Analytics',
                              fontSize: 18,
                              color: Colors.black),
                          SizedBox(
                            height: 300,
                            width: 1000,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: pie.PieChart(
                                legendOptions: const pie.LegendOptions(
                                    legendPosition: pie.LegendPosition.left),
                                dataMap: {
                                  'Accepted': rides,
                                  'Cancelled': cancelled,
                                  'Pending': pendings,
                                },
                                chartType: pie.ChartType.disc,
                                colorList: const [
                                  Colors.blue,
                                  Colors.red,
                                  Colors.green,
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  getTotalFare() async {
    await FirebaseFirestore.instance
        .collection('Bookings')
        .where('status', isEqualTo: 'Accepted')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        DateTime dateTime = doc['dateTime'].toDate();

        setState(() {
          if (dateTime.year == DateTime.now().year &&
              dateTime.month == DateTime.now().month &&
              dateTime.day == DateTime.now().day) {
            today += double.parse(doc['fare']);
          }

          if (dateTime.weekday == DateTime.monday) {
            monday += 1;
          } else if (dateTime.weekday == DateTime.tuesday) {
            tuesday += 1;
          } else if (dateTime.weekday == DateTime.wednesday) {
            wednesday += 1;
          } else if (dateTime.weekday == DateTime.thursday) {
            thursday += 1;
          } else if (dateTime.weekday == DateTime.friday) {
            friday += 1;
          } else if (dateTime.weekday == DateTime.saturday) {
            saturday += 1;
          } else if (dateTime.weekday == DateTime.sunday) {
            sunday += 1;
          }
          total += double.parse(doc['fare']);
        });
      }
    });
  }

  getBookings() async {
    await FirebaseFirestore.instance
        .collection('Bookings')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print(doc['status']);
        if (doc['status'] == 'Accepted') {
          setState(() {
            rides += 1;
          });
        } else if (doc['status'] == 'Rejected') {
          setState(() {
            cancelled += 1;
          });
        } else {
          setState(() {
            pendings += 1;
          });
        }
      }
    });

    setState(() {
      hasLoaded = true;
    });
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
