import 'package:complaint_user/models/user.dart';
import 'package:complaint_user/utils/debugger.dart';
import 'package:complaint_user/utils/server.dart';
import 'package:complaint_user/widgets/dialog_menu_button.dart';
import 'package:flutter/material.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector({Key? key}) : super(key: key);

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  List<Map> locations = [
    {
      'options': ['Building 1', 'Building 2', 'Building 3'],
      'key': 'Building',
      'index': 0,
      'selectedIndex': 1
    },
    {
      'options': ['Block A', 'Block B', 'Block C'],
      'key': 'Block',
      'index': 1,
      'selectedIndex': 0
    },
    {
      'options': ['Level 1', 'Level 2', 'Level 3'],
      'key': 'Level',
      'index': 0,
      'selectedIndex': 1
    }
  ];

  // Future<List<Map>> fetch() async {
  //   String errorMessage = 'Error to fetch locations';
  //   final result = await Server.httpGet(Server.baseUrl, '/location/get/$parentId', errorMessage);
  //   if (result.code == 200) {
  //     return (result.body as List).map<Map>((e) => e as Map).toList();
  //   }
  //   throw Exception(errorMessage);
  // }

  // void addSelector(int index) {
  //   selectors.add(FutureBuilder(
  //     future: future,
  //     builder: (context, AsyncSnapshot<List<Map>> snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator();
  //       } else {
  //         if (snapshot.hasData) {
  //           String key = childLabel[selectors.length - 1];
  //           Debugger.log(key);
  //           Debugger.log(location[key]);
  //           return DialogMenuButton(
  //             value: Text(location[childLabel[index]] ?? 'Select ${childLabel[index]}'),
  //             label: childLabel[index],
  //             dialogTitle: 'Select ${childLabel[index]}',
  //             dialogContent: snapshot.data!
  //                 .map((e) => Column(
  //                       children: [
  //                         Divider(height: 1),
  //                         ListTile(
  //                           title: Text(e['name'], textAlign: TextAlign.center),
  //                           onTap: () => Navigator.pop(context, e),
  //                         ),
  //                       ],
  //                     ))
  //                 .toList(),
  //             onSubmitted: (val) {
  //               if (val != null) {
  //                 onSelected(val);
  //               }
  //             },
  //           );
  //         } else {
  //           Debugger.log(snapshot.error);
  //           return Text('Error');
  //         }
  //       }
  //     },
  //   ));
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: locations
          .map<Widget>(
            (e) => DialogMenuButton(
              value: Text(e['options'][e['selectedIndex']]),
              label: e['key'],
              dialogTitle: 'Select ${e["key"]}',
              dialogContent: e['options']
                  .map<Widget>((f) => Column(
                        children: [
                          Divider(height: 1),
                          ListTile(
                            title: Text(f, textAlign: TextAlign.center),
                            onTap: () => Navigator.pop(context, f),
                          ),
                        ],
                      ))
                  .toList(),
              onSubmitted: (val) {
                if (val != null) {
                  int i = (e['options'] as List).indexOf(val);
                  setState(() {
                    e['selectedIndex'] = i;
                  });
                }
              },
            ),
          )
          .toList(),
    );
  }
}
