import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts/button.dart';

class NextScreen extends StatefulWidget {
  const NextScreen({super.key});

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  // void openGallery() async {
  ImagePicker picker = ImagePicker();
  Uint8List? imageBytes;

  TextEditingController controller = TextEditingController();

  void imagePicker() async {
    XFile? _image = await picker.pickImage(source: ImageSource.gallery);
    imageBytes = await _image?.readAsBytes();
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () {}, child: const Text('done')),
                  const Text('New Contact'),
                  const TextButton(onPressed: null, child: Text('cancel'))
                ],
              ),
              ProfileImage(pick: imagePicker, bytes: imageBytes),
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
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: controller,
                  onSubmitted: (num) {
                    num = num.substring(0, 3) +
                        '-' +
                        num.substring(3, 6) +
                        '-' +
                        num.substring(6, 10);
                    controller.text = num;
                  },
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                      labelText: 'Phone #',
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
