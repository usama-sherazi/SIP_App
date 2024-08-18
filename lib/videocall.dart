import 'package:flutter/material.dart';
import 'package:abto_voip_sdk/abto_video_widget.dart';

class VideoCallScreen extends StatelessWidget {
  final VoidCallback onEndCall;

  const VideoCallScreen({Key? key, required this.onEndCall}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  'Outgoing Video',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: SizedBox(
                  width: double.infinity, // Expands to full width
                  child: VoipVideoWidget(true), // true - for outgoing video
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Incoming Video',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: SizedBox(
                  width: double.infinity, // Expands to full width
                  child: VoipVideoWidget(false), // false - for incoming video
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onEndCall,
              icon: const Icon(Icons.call_end),
              label: const Text('End Call'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
