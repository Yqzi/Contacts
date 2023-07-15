import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  // void openGallery() async {
  ImagePicker picker = ImagePicker();
  Uint8List? imageBytes;

  void imagePicker() async {
    XFile? _image = await picker.pickImage(source: ImageSource.gallery);
    imageBytes = await _image?.readAsBytes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: MaterialButton(
                  onPressed: imagePicker,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: imageBytes == null
                        ? const Icon(
                            Icons.account_circle,
                            size: 100,
                          )
                        : Image.memory(
                            imageBytes!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              TextButton(onPressed: imagePicker, child: Text('Add Photo')),
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
    );
  }
}
