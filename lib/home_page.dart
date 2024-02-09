// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:creator_folders/custum_butom.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FolderList {
  String folderName;

  FolderList({required this.folderName});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _folderCount = TextEditingController();
  List<FolderList> folderList = [];

  Future<String?> _getDestinationDirectory() async {
    final result = await FilePicker.platform.getDirectoryPath();
    return result;
  }

  Future<void> _createFolders(String? destinationDirectory) async {
    if (destinationDirectory != null) {
      for (var folder in folderList) {
        String folderName = folder.folderName;
        if (folderName.isNotEmpty) {
          Directory newDirectory =
              Directory('$destinationDirectory/$folderName');
          newDirectory.createSync(recursive: true);
          log('Folder created at: ${newDirectory.path}');
        }
      }
    } else {
      log('Destination directory is null');
    }
  }

  void _openMenu() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('How Many Folders'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _folderCount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Folder Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              CustomButtom(
                title: 'Create Folders',
                onPressed: () async {
                  if (_folderCount.text.isNotEmpty) {
                    try {
                      int count = int.parse(_folderCount.text);
                      List<FolderList> tempFolderList = [];
                      for (var i = 0; i < count; i++) {
                        tempFolderList.add(FolderList(folderName: ''));
                      }
                      setState(() {
                        folderList = tempFolderList;
                      });
                      _folderCount.clear();
                      Navigator.pop(context);
                    } catch (e) {
                      _folderCount.clear();
                      ScaffoldMessenger.of(context).showMaterialBanner(
                        MaterialBanner(
                          content: const Text('Error'),
                          actions: [
                            Builder(builder: (context) {
                              return IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentMaterialBanner();
                                },
                                icon: const Icon(Icons.close),
                              );
                            }),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Folder Creator',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Are you sure?'),
                        content:
                            const Text('Do you want to delete all folders?'),
                        actions: [
                          CustomButtom(
                            title: 'Yes',
                            onPressed: () {
                              setState(() {
                                folderList.clear();
                              });
                              Navigator.pop(context);
                            },
                          ),
                          CustomButtom(
                            title: 'No',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(25),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: folderList.length,
              itemBuilder: (BuildContext context, int index) {
                final TextEditingController folderNameController =
                    TextEditingController(text: folderList[index].folderName);
                return Column(
                  children: [
                    TextField(
                      controller: folderNameController,
                      onChanged: (value) {
                        folderList[index].folderName = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Folder ${index + 1}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.green.withOpacity(0.5),
                            child: Text('${index + 1}'),
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.folder,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
          CustomButtom(
            title: 'Create',
            onPressed: () async {
              if (folderList.isNotEmpty) {
                String? destinationDirectory = await _getDestinationDirectory();
                _createFolders(destinationDirectory);
              }
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _openMenu,
        child: const Icon(Icons.add),
      ),
    );
  }
}

TextStyle textStyle = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 25,
);
