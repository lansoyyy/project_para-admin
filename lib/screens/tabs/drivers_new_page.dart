import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_para_admin/widgets/text_widget.dart';
import 'package:project_para_admin/widgets/toast_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import '../../utils/colors.dart';

class DeliveryNewPage extends StatefulWidget {
  const DeliveryNewPage({super.key});

  @override
  State<DeliveryNewPage> createState() => _DeliveryNewPageState();
}

class _DeliveryNewPageState extends State<DeliveryNewPage> {
  String filter = '';
  final messageController = TextEditingController();

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
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextBold(text: 'Drivers', fontSize: 14, color: Colors.black),
          const SizedBox(
            height: 5,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Drivers')
                  .where('isVerified', isEqualTo: false)
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
                                ],
                              ),
                              trailing: SizedBox(
                                width: 60,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('Drivers')
                                            .doc(data.docs[index].id)
                                            .update({
                                          'isVerified': true,
                                        });
                                        showToast('Driver verified');
                                      },
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.grey,
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
