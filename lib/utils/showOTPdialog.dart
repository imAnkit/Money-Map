import 'package:flutter/material.dart';

void showOTPDialog(
    {required BuildContext context,
    required TextEditingController controller,
    required VoidCallback onTap}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Enter OTP"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: controller,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onTap,
          child: const Text("Done"),
        )
      ],
    ),
  );
}

void selectImageMethodDialog(
    {required BuildContext context,
    required VoidCallback onTap1,
    required VoidCallback onTap2}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              'Pick From :',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            backgroundColor: Colors.white,
            content: SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: onTap1,
                        icon: const Icon(
                          Icons.browse_gallery,
                          size: 50,
                        ),
                      ),
                      const Text(
                        'Gallery',
                        style: TextStyle(color: Colors.blue, fontSize: 24),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: onTap2,
                        icon: const Icon(
                          Icons.camera,
                          size: 50,
                        ),
                      ),
                      const Text(
                        'Camera',
                        style: TextStyle(color: Colors.orange, fontSize: 24),
                      )
                    ],
                  )
                ],
              ),
            ),
          ));
}
