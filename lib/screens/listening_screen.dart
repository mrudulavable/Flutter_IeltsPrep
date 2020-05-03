import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

import 'package:ielts/models/listening.dart';
import 'package:ielts/screens/listening_detail_screen.dart';
import 'package:ielts/viewModels/listeningCrudModel.dart';
import 'package:ielts/widgets/lessonCard.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Color backgroundColor = Color(0xFF21BFBD);

class ListeningScreen extends StatefulWidget {
  ListeningScreen({Key key}) : super(key: key);

  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen>
    with SingleTickerProviderStateMixin {
  List listening;

  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);

  List<String> checkedListeningItems = [];

  void _getcheckedListeningItems() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('checkedListeningItems')) {
      checkedListeningItems = prefs.getStringList('checkedListeningItems');
    } else {
      prefs.setStringList('checkedListeningItems', checkedListeningItems);
    }
  }

  @override
  void initState() {
    _getcheckedListeningItems();
    super.initState();

    // listening = getListeningData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

//If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)
    ScreenUtil.init(context, width: 414, height: 896);

//If you want to set the font size is scaled according to the system's "font size" assist option
    ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        bottomOpacity: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          // MenuPage(),
          dashboard(context),
        ],
      ),
    );
  }

  Widget dashboard(context) {
    final productProvider = Provider.of<ListeningCrudModel>(context);
    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),
      elevation: 8,
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 18.0),
              //       child: InkWell(
              //         child: Icon(Icons.arrow_back, color: Colors.white),
              //         onTap: () {
              //           Navigator.pop(context);
              //         },
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(right: 18.0),
              //       child: Icon(Icons.settings, color: Colors.white),
              //     ),
              //   ],
              // ),

              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                child: Row(
                  children: <Widget>[
                    Text('Listening Exercises',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(25),
                        )),
                    SizedBox(width: ScreenUtil().setWidth(10)),
                    // Text('Prep',
                    //     style: TextStyle(
                    //         fontFamily: 'Montserrat',
                    //         color: Colors.white,
                    //         fontSize: 25.0))
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(40)),
              Container(
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).secondaryHeaderColor,
                        blurRadius: 10)
                  ],
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil().setWidth(75))),
                ),
                child: Container(
                  // height: screenHeight,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: productProvider.fetchListeningAsStream(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          listening = snapshot.data.documents
                              .map((doc) =>
                                  Listening.fromMap(doc.data, doc.documentID))
                              .toList();

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(70),
                                bottom: ScreenUtil().setHeight(50)),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: listening.length,
                            itemBuilder: (BuildContext context, int index) {
                              _getcheckedListeningItems();
                              return makeCard(listening[index]);
                            },
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeCard(Listening listening) => LessonCard(
        title: listening.title,
        indicatorValue: listening.indicatorValue,
        level: listening.level,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ListeningDetailScreen(listening: listening)));
        },
        trailing: FittedBox(
          child: CheckboxGroup(
              checked: checkedListeningItems,
              labels: [listening.id],
              checkColor: Colors.black,
              activeColor: Theme.of(context).secondaryHeaderColor,
              labelStyle: TextStyle(fontSize: 0),
              onSelected: (List<String> checked) {
                print("${checked.toString()}");
              },
              onChange: (bool isChecked, String label, int index) async {
                print(label);
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool(label, isChecked);
                print(prefs.getBool(label) ?? 0);

                setState(() {
                  isChecked = prefs.getBool(label);

                  if (checkedListeningItems.contains(label)) {
                    checkedListeningItems.remove(label);
                  } else {
                    checkedListeningItems.add(label);
                  }
                  prefs.setStringList(
                      'checkedListeningItems', checkedListeningItems);
                  print(checkedListeningItems);
                });
              }),
        ),
      );
}
