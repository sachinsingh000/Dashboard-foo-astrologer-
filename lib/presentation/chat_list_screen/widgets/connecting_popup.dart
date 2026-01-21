import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ConnectingPopup extends StatelessWidget {
  final String clientName;
  final String clientAvatar;
  final bool isCall;

  const ConnectingPopup({
    Key? key,
    required this.clientName,
    required this.clientAvatar,
    this.isCall = false,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40.sp,
              backgroundImage: clientAvatar.isNotEmpty
                  ? NetworkImage(clientAvatar)
                  : null,
              child: clientAvatar.isEmpty
                  ? const Icon(Icons.person, size: 60, color: Colors.white)
                  : null,
            ),
            SizedBox(height: 3.h),
            Text(
              "Connecting to $clientName...",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 4.h),
            const CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 6.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.redAccent, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
