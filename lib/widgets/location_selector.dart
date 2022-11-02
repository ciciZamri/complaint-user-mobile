import 'package:complaint_user/models/user.dart';
import 'package:complaint_user/utils/debugger.dart';
import 'package:complaint_user/utils/server.dart';
import 'package:complaint_user/widgets/dialog_menu_button.dart';
import 'package:flutter/material.dart';

class LocationSelector extends StatefulWidget {
  final Function(Map) onChanged;
  const LocationSelector({required this.onChanged, Key? key}) : super(key: key);

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  List<String> keys = ['Building'];
  List<List<Map>?> options = [null];
  Map<String, String> locations = {};
  late String parentId;

  Future<List<Map>> fetch() async {
    String errorMessage = 'Error to fetch locations';
    final result = await Server.httpGet(Server.baseUrl, '/location/get/$parentId', errorMessage);
    if (result.code == 200) {
      return (result.body as List).map<Map>((e) => e as Map).toList();
    }
    throw Exception(errorMessage);
  }

  void fetchLocations(int index) {
    Debugger.log('fetch...... $index');
    fetch().then((value) {
      setState(() {
        options[index] = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    parentId = 'campus-1';
    fetch().then((value) {
      setState(() {
        options[0] = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: keys
          .map((e) => options[keys.indexOf(e)] == null
              ? Text('Loading...')
              : DialogMenuButton(
                  value: locations[e] == null ? Text('Please select') : Text(locations[e]!),
                  label: e,
                  dialogTitle: e,
                  dialogContent: options[keys.indexOf(e)]!
                      .map((f) => ListTile(
                            title: Text(f['name']),
                            onTap: () => Navigator.pop(context, f),
                          ))
                      .toList(),
                  onSubmitted: (val) {
                    if (val != null) {
                      setState(() {
                        keys = keys.sublist(0, keys.indexOf(e) + 1);
                        locations.removeWhere((key, value) => !(keys.contains(key)));
                        locations[e] = val['name'];
                        if (val['childLabel'] != null) {
                          parentId = val['_id'];
                          if (!keys.contains(val['childLabel'])) {
                            keys.add(val['childLabel']);
                            options.add(null);
                          } else {
                            options = options.sublist(0, keys.indexOf(e));
                          }
                          fetchLocations(val['level'] + 1);
                        }
                        widget.onChanged(locations);
                      });
                    }
                  },
                ))
          .toList(),
    );
  }
}
