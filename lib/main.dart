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
  Contact? currentContact;

  void createContact(String fn, String ln, String pNumber, {String? imgPath}) {
    setState(() {
      contacts.add(Contact(fn.trim(), ln.trim(), pNumber, imgPath: imgPath));
      swapScreens = !swapScreens;
    });
  }

  void editContact(String fn, String ln, String pNumber, {String? imgPath}) {
    setState(() {
      currentContact!.firstName = fn.trim();
      currentContact!.lastName = ln.trim();
      currentContact!.number = pNumber;
      currentContact!.imgPath = imgPath;
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
              if (swapScreens == false)
                const SizedBox(
                  width: 500,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                    ),
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
            ListView.separated(
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(contacts[index].fullname),
                  onTap: () => setState(() {
                    currentContact = contacts[index];
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
}
