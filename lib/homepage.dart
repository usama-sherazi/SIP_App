import 'package:flutter/material.dart';
import 'package:sip_app/sipcall.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sip dialer'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        centerTitle: true, // Optional: to center the title
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0), // Padding around the container
          decoration: BoxDecoration(
            color: Colors.lightBlue, // Background color of the container
            borderRadius: BorderRadius.circular(10.0), // Rounded corners

          ),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to the SIP Call screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SipCallScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              backgroundColor: Colors.white, // Background color of the button
            ),
            child: const Icon(
              Icons.phone,
              size: 60,
              color: Colors.lightBlue, // Color of the icon
            ),
          ),
        ),
      ),
    );
  }
}
