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

  void changeS() {
    setState(() {
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
                onPressed: changeS,
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
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
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
