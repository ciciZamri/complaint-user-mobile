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
  late Future<List<Map>> future;
  late String parentId;
  List<String> childLabel = ['Building'];
  Map location = {};
  List<Widget> selectors = [];

  Future<List<Map>> fetch() async {
    String errorMessage = 'Error to fetch locations';
    final result = await Server.httpGet(Server.baseUrl, '/location/get/$parentId', errorMessage);
    if (result.code == 200) {
      return (result.body as List).map<Map>((e) => e as Map).toList();
    }
    throw Exception(errorMessage);
  }

  void addSelector(int index) {
    selectors.add(FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot<List<Map>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            String key = childLabel[selectors.length - 1];
            Debugger.log(key);
            Debugger.log(location[key]);
            return DialogMenuButton(
              value: Text(location[childLabel[index]] ?? 'Select ${childLabel[index]}'),
              label: childLabel[index],
              dialogTitle: 'Select ${childLabel[index]}',
              dialogContent: snapshot.data!
                  .map((e) => Column(
                        children: [
                          Divider(height: 1),
                          ListTile(
                            title: Text(e['name'], textAlign: TextAlign.center),
                            onTap: () => Navigator.pop(context, e),
                          ),
                        ],
                      ))
                  .toList(),
              onSubmitted: (val) {
                if (val != null) {
                  onSelected(val);
                }
              },
            );
          } else {
            Debugger.log(snapshot.error);
            return Text('Error');
          }
        }
      },
    ));
  }

  void onSelected(Map loc) {
    location[childLabel.last] = loc['name'];
    if (loc['childLabel'] != null) {
      childLabel.add(loc['childLabel']);
      parentId = loc['_id'];
      future = fetch();
      location[loc['childLabel']] = null;
      addSelector(selectors.length);
    }
    Debugger.log(location);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    parentId = User.campusId;
    future = fetch();
    location[childLabel.last] = null;
    addSelector(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [...selectors],
    );
  }
}
