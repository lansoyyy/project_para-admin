import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_para_admin/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import '../../utils/colors.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  String filter = '';
  final messageController = TextEditingController();

  int day = DateTime.now().day;
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  DateTime startDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50,
                width: 275,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: TextFormField(
                  controller: messageController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: grey,
                    ),
                    suffixIcon: filter != ''
                        ? IconButton(
                            onPressed: (() {
                              setState(() {
                                filter = '';
                                messageController.clear();
                              });
                            }),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: grey,
                            ),
                          )
                        : const Icon(
                            Icons.account_circle_outlined,
                            color: grey,
                          ),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1, color: grey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    hintText: 'Search Driver',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      filter = value;
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () async {
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      // day = selectedDate.day;
                      // month = selectedDate.month;
                      // year = selectedDate.year;
                      startDate = selectedDate;
                    });
                  }
                },
                icon: const Icon(
                  Icons.calendar_month,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextBold(
              text: 'Deliveries for: ${DateFormat.yMMMMd().format(startDate)}',
              fontSize: 14,
              color: Colors.black),
          const SizedBox(
            height: 5,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Drivers')
                  .where('name',
                      isGreaterThanOrEqualTo: toBeginningOfSentenceCase(filter))
                  .where('name',
                      isLessThan: '${toBeginningOfSentenceCase(filter)}z')
                  // .where('dateTime', isLessThan: date)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    )),
                  );
                }

                final data = snapshot.requireData;

                return Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: data.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              leading: CircleAvatar(
                                minRadius: 20,
                                maxRadius: 20,
                                backgroundImage: NetworkImage(
                                    data.docs[index]['profilePicture']),
                              ),
                              title: TextBold(
                                  text: data.docs[index]['name'],
                                  fontSize: 15,
                                  color: Colors.black),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextRegular(
                                      text:
                                          '${data.docs[index]['vehicle'] ?? ''}'
                                                  ' - ' +
                                              data.docs[index]['plateNumber'],
                                      fontSize: 11,
                                      color: Colors.grey),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Delivery')
                                          .where('driverId',
                                              isEqualTo: data.docs[index].id)
                                          .where('dateTime',
                                              isGreaterThanOrEqualTo: startDate)
                                          .where('dateTime',
                                              isLessThan: startDate
                                                  .add(const Duration(days: 1)))
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          print(snapshot.error);
                                          return const Center(
                                              child: Text('Error'));
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Padding(
                                            padding: EdgeInsets.only(top: 50),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.black,
                                            )),
                                          );
                                        }

                                        final data12 = snapshot.requireData;

                                        return TextBold(
                                            text:
                                                '${data12.docs.length} Deliveries',
                                            fontSize: 12,
                                            color: Colors.green);
                                      }),
                                ],
                              ),
                              trailing: SizedBox(
                                width: 60,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 12,
                                      color: data.docs[index]['isActive']
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        var text =
                                            'tel:${data.docs[index]['number']}';
                                        if (await canLaunch(text)) {
                                          await launch(text);
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.phone,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
