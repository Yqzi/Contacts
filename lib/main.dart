import 'dart:convert';

import 'package:flutter/material.dart';
import 'screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void saveAsJson(contact) {
    Map<String, Object?> convertedData = {};

    convertedData['firstName'] = firstName;
    convertedData['lastname'] = lastName;
    convertedData['number'] = number;
    convertedData['imagePath'] = imgPath;

    String formattedData = json.encode(convertedData);

    StoreData.instance.saveString(fullname, formattedData);
  }
}

class StoreData {
  StoreData._privateConstructer();

  static final StoreData instance = StoreData._privateConstructer();

  Future<void> saveString(String key, String value) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final encodedValue = base64.encode(utf8.encode(value));

      pref.setString(key, encodedValue);
    } catch (e) {
      print("saveString ${e.toString()}");
    }
  }

  Future<String> getString(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final value = pref.getString(key) ?? '';

    if (value!.isNotEmpty) {
      final decodedValue = utf8.decode(base64.decode(value));
      return decodedValue.toString();
    }
    return '';
  }

  Future<bool> remove(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove(key);
  }
}
