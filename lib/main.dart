import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constance.dart';

void main() {
  runApp(const Contacts());
}

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final TextEditingController _searchController = TextEditingController();
  bool swapScreens = false;

  List<Contact> contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = false;
  Contact? currentContact;

  @override
  void initState() {
    super.initState();
    _filteredContacts = contacts;
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  void saveCotacts() async {
    Lmso formedData = [];
    Map<String, Lmso> formattedData = {};
    for (Contact contact in contacts) {
      formedData.add(contact.convertToJson());
    }
    formattedData[listName] = formedData;
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    print('$path/$fileName');
    await File('$path/$fileName').writeAsString(json.encode(formattedData));
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _filteredContacts = contacts
          .where((element) => element.fullname
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      _isLoading = false;
    });
  }

  void createContact(String fn, String ln, String pNumber, {String? imgPath}) {
    setState(() {
      _filteredContacts = contacts;
      _searchController.text = '';
      contacts.add(Contact(fn.trim(), ln.trim(), pNumber, imgPath: imgPath));
      contacts.sort((c1, c2) => c1.fullname.compareTo(c2.fullname));
      swapScreens = !swapScreens;
    });

    _performSearch();

    saveCotacts();
  }

  void editContact(String fn, String ln, String pNumber, {String? imgPath}) {
    setState(() {
      _filteredContacts = contacts;
      _searchController.text = '';
      currentContact!.firstName = fn.trim();
      currentContact!.lastName = ln.trim();
      currentContact!.number = pNumber;
      currentContact!.imgPath = imgPath;
      swapScreens = !swapScreens;
    });

    _performSearch();

    saveCotacts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const TextButton(
                onPressed: null,
                child: Text(
                  '< List',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              if (swapScreens == false)
                SizedBox(
                  width: 500,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none),
                  ),
                ),
              TextButton(
                onPressed: () {
                  setState(() {
                    currentContact = null;
                    swapScreens = !swapScreens;
                  });
                },
                child: Text(
                  (swapScreens) ? "x" : '+',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(_filteredContacts[index].fullname),
                        onTap: () => setState(() {
                          currentContact = _filteredContacts[index];
                          swapScreens = !swapScreens;
                        }),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
            if (swapScreens)
              NextScreen(
                onSubmitted:
                    currentContact == null ? createContact : editContact,
                contact: currentContact,
              )
          ],
        ),
      ),
    );
  }
}

class Contact {
  String? imgPath;
  String firstName;
  String lastName;
  String number;

  Contact(this.firstName, this.lastName, this.number, {this.imgPath});

  String get fullname => "$firstName $lastName";

  Map<String, Object?> convertToJson() {
    Map<String, Object?> convertedData = {};

    convertedData['firstName'] = firstName;
    convertedData['lastname'] = lastName;
    convertedData['number'] = number;
    convertedData['imagePath'] = imgPath;

    return convertedData;
  }
}

typedef Lmso = List<Map<String, Object?>>;
