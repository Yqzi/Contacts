import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts/button.dart';

class NextScreen extends StatefulWidget {
  final void Function(String, String) onSubmitted;
  const NextScreen({super.key, required this.onSubmitted});

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  ImagePicker picker = ImagePicker();
  Uint8List? imageBytes;

  TextEditingController controller = TextEditingController();
  TextEditingController fnc = TextEditingController();
  TextEditingController lnc = TextEditingController();

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
                  TextButton(
                      onPressed: () {
                        widget.onSubmitted(
                          fnc.text,
                          lnc.text,
                        );
                      },
                      child: const Text('done')),
                  Text('New Contact'),
                  TextButton(onPressed: null, child: Text('cancel'))
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
                child: Column(
                  children: [
                    TextField(
                      controller: fnc,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
                          hintText: 'First Name',
                          contentPadding: EdgeInsets.all(15.0)),
                    ),
                    TextField(
                      controller: lnc,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(
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
