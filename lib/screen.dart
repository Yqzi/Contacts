import 'dart:io';
import 'package:contacts/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NextScreen extends StatefulWidget {
  final void Function(String, String, String, {String? imgPath}) onSubmitted;
  final Contact? contact;
  const NextScreen({super.key, required this.onSubmitted, this.contact});

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  ImagePicker picker = ImagePicker();
  Future<Uint8List>? imageBytes;
  String? imagePath;

  TextEditingController numC = TextEditingController();
  TextEditingController fnc = TextEditingController();
  TextEditingController lnc = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    numC.text = widget.contact?.number ?? "";
    fnc.text = widget.contact?.firstName ?? "";
    lnc.text = widget.contact?.lastName ?? "";
    imagePath = widget.contact?.imgPath;
    if (imagePath != null) imageBytes = XFile(imagePath!).readAsBytes();
    super.initState();
  }

  void imagePicker() async {
    XFile? _image = await picker.pickImage(source: ImageSource.gallery);
    imageBytes = _image?.readAsBytes();
    imagePath = _image?.path;
    setState(() {});
  }

  @override
  void dispose() {
    numC.dispose();
    fnc.dispose();
    lnc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
                          if (_formKey.currentState!.validate()) {
                            widget.onSubmitted(
                              fnc.text,
                              lnc.text,
                              numC.text,
                              imgPath: imagePath,
                            );
                          }
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
                      TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.toString().trim().isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
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
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    controller: numC,
                    onFieldSubmitted: (num) {
                      num =
                          '${num.substring(0, 3)}-${num.substring(3, 6)}-${num.substring(6, 10)}';
                      numC.text = num;
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
      ),
    );
  }
}
