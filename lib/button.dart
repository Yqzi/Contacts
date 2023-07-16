import 'dart:typed_data';

import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final void Function() pick;
  final Uint8List? bytes;

  const ProfileImage({super.key, required this.pick, this.bytes});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: pick,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          width: 100,
          height: 100,
          child: bytes == null
              ? const Icon(
                  Icons.account_circle,
                  size: 100,
                )
              : Image.memory(
                  bytes!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
