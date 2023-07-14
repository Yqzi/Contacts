import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  void openGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 238, 236, 236),
            height: MediaQuery.of(context).size.height / 3 - 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: null, child: Text('cancel')),
                    Text('New Contact'),
                    TextButton(onPressed: null, child: Text('done'))
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: IconButton(
                      onPressed: openGallery,
                      icon: const Icon(
                        Icons.account_circle,
                        size: 100,
                      )),
                ),
                TextButton(onPressed: openGallery, child: Text('Add Photo')),
              ],
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 238, 236, 236),
            height: MediaQuery.of(context).size.height * 2 / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  color: Colors.white,
                  child: const Column(
                    children: [
                      TextField(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            hintText: 'First Name',
                            contentPadding: EdgeInsets.all(15.0)),
                      ),
                      TextField(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                            hintText: 'Last Name',
                            contentPadding: EdgeInsets.all(15.0)),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const TextField(
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        hintText: 'add phone',
                        contentPadding: EdgeInsets.all(15.0)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
