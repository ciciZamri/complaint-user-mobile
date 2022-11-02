import 'dart:io';

import 'package:complaint_user/complaint_details_page.dart';
import 'package:complaint_user/models/complaint.dart';
import 'package:complaint_user/models/user.dart';
import 'package:complaint_user/utils/debugger.dart';
import 'package:complaint_user/utils/server.dart';
import 'package:complaint_user/widgets/dialog_menu_button.dart';
import 'package:complaint_user/widgets/extra_dialog.dart';
import 'package:complaint_user/widgets/location_selector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintForm extends StatefulWidget {
  const ComplaintForm({Key? key}) : super(key: key);

  @override
  State<ComplaintForm> createState() => _ComplaintFormState();
}

class _ComplaintFormState extends State<ComplaintForm> {
  final ImagePicker _picker = ImagePicker();
  late Future<List<String>> categoriesFuture;
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Map? location;
  String? category;
  List<XFile> images = [];

  String? titleError;
  String? descriptionError;

  @override
  void initState() {
    super.initState();
    categoriesFuture = fetchCategories();
    categoriesFuture.then((value) {
      setState(() {
        category = value.first;
      });
    });
  }

  Future<List<String>> fetchCategories() async {
    String errorMessage = 'Error to fetch categories';
    final result = await Server.httpGet(Server.baseUrl, '/category/all/${User.campusId}', errorMessage);
    if (result.code == 200) {
      return (result.body as List).map<String>((e) => e['name']).toList();
    }
    throw Exception(errorMessage);
  }

  bool validate() {
    titleError = descriptionError = null;
    if (titleController.text.isEmpty) titleError = 'required';
    if (descriptionController.text.isEmpty) descriptionError = 'required';
    setState(() {});
    return titleError == null && descriptionError == null;
  }

  void submit() {
    if (validate()) {
      setState(() => isLoading = true);
      Complaint complaint = Complaint(
        titleController.text,
        descriptionController.text,
        location,
        category,
      );
      complaint.create('campus-1').then((String complaintId) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ComplaintDetailsPage(complaintId)));
      }).catchError((err) {
        showSimpleDialog(context, 'Something went wrong. Please try again.');
      });
    }
  }

  Widget categorySelector() {
    return FutureBuilder(
      future: categoriesFuture,
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            return DialogMenuButton(
              label: 'Category',
              value: Text(category!),
              dialogTitle: 'Select category',
              dialogContent: [
                ...snapshot.data!
                    .map((e) => Column(
                          children: [
                            Divider(height: 1),
                            ListTile(
                              title: Text(e, textAlign: TextAlign.center),
                              onTap: () => Navigator.pop(context, e),
                            ),
                          ],
                        ))
                    .toList(),
                Divider(height: 1)
              ],
              onSubmitted: (val) {
                setState(() {
                  category = val;
                });
              },
            );
          } else {
            Debugger.log(snapshot.error);
            return Text('Error');
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit new complaint'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 96),
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title', errorText: titleError),
                controller: titleController,
              ),
              SizedBox(height: 8),
              categorySelector(),
              LocationSelector(
                onChanged: (val) {
                  setState(() {
                    location = val;
                  });
                  Debugger.log(val);
                },
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(labelText: 'Description', errorText: descriptionError),
                maxLines: 8,
                controller: descriptionController,
              ),
              SizedBox(height: 16),
              ...images
                  .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Stack(
                          children: [
                            Image.file(File(e.path)),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    images.remove(e);
                                  });
                                },
                                icon: Icon(Icons.cancel_rounded),
                              ),
                            ),
                          ],
                        ),
                  ))
                  .toList(),
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Please select'),
                        content: Column(
                          children: [
                            ListTile(
                              title: Text('Gallery'),
                              onTap: () => Navigator.pop(context, 'gallery'),
                            ),
                            ListTile(
                              title: Text('Camera'),
                              onTap: () => Navigator.pop(context, 'camera'),
                            ),
                          ],
                        ),
                      );
                    },
                  ).then((value) {
                    if (value != null) {
                      _picker.pickImage(source: value == 'camera' ? ImageSource.camera : ImageSource.gallery).then((value) {
                        if (value != null) {
                          setState(() {
                            images.add(value);
                          });
                        }
                      });
                    }
                  });
                },
                icon: Icon(Icons.add_photo_alternate_rounded),
                label: Text('Add photo'),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ElevatedButton(
                style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width - 24, 56))),
                onPressed: isLoading ? null : submit,
                child: Text(isLoading ? 'Loading...' : 'Submit'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
