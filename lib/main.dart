import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'screen.dart';

void main() {
  runApp(const Contacts());
}

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  bool swapScreens = false;

  List<Contact> contacts = [];

  void changeS(String fn, String ln, String pNumber, {String? imgPath}) {
    setState(() {
      contacts.add(Contact(fn, ln, pNumber, imgPath: imgPath));
      swapScreens = !swapScreens;
    });
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
              TextButton(
                onPressed: () {
                  setState(() {
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
            ListView.separated(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(contacts[index].fullname),
                  onTap: () => print(contacts[index].number),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
            if (swapScreens) NextScreen(onSubmitted: changeS),
          ],
        ),
      ),
    );
  }
}

class Contact {
  final String? imgPath;
  final String firstName;
  final String lastName;
  final String number;

  Contact(this.firstName, this.lastName, this.number, {this.imgPath});

  String get fullname => "$firstName $lastName";
}
