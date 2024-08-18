import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abto_voip_sdk/sip_wrapper.dart';
import 'package:sip_app/videocall.dart';

class SipCallScreen extends StatefulWidget {
  const SipCallScreen({super.key});

  @override
  _SipCallScreenState createState() => _SipCallScreenState();
}

class _SipCallScreenState extends State<SipCallScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isRegistered = false;
  bool _isRegistering = true;
  bool _isCallActive = false;
  bool _isVideoCall = false;

  @override
  void initState() {
    super.initState();
    _initializeSipWrapper();
  }

  void _initializeSipWrapper() {
    // Initialize the SIP Wrapper
    SipWrapper.wrapper.init();

    // Set License
    if (Platform.isAndroid) {
      SipWrapper.wrapper.setLicense(
          '{Trial0e81_Android-D249-144A-ABEB5BD1-B97D-484B-BFEA-DA604244101E}',
          '{AufGKw0AgccH6hw/qP88p6K/O33xQGlwF3BCpGLzY6s9w2xzti0JHPOBe9saTPjoHPUnaRwHXO98OjA4bmx/Og==}'
      );
    } else if (Platform.isIOS) {
      SipWrapper.wrapper.setLicense(
          '{Trial0e81_iOS-D249-147A-BBEB5BD1-B97D-484B-BFEA-DA604244101E}',
          '{Ix6BNIR+1jeZRkZ17CQ6LsHEgu9l7+md9CjIM0N94cbErGCcDS01hcEvCdfw6W4p037IkZpEwoCBfzUaMfYmZg==}'
      );
    }

    // Register with SIP server
    String username = '905';
    String password = '1234';
    String domain = '192.168.100.19';

    SipWrapper.wrapper.register(
        domain, '', username, password, '', 'Flutter_APP', 3600
    );

    SipWrapper.wrapper.registerListener = RegisterListener(onRegistered: () {
      print('SIP Registered successfully');
      setState(() {
        _isRegistered = true;
        _isRegistering = false;
      });
    }, onRegistrationFailed: () {
      print('SIP Registration failed');
      setState(() {
        _isRegistering = false;
      });
    }, onUnregistered: () {
      print('SIP Unregistered');
      setState(() {
        _isRegistered = false;
        _isRegistering = false;
      });
    });

    SipWrapper.wrapper.callListener = CallListener(callConnected: (number) {
      print('Call connected with number: $number');
      setState(() {
        _isCallActive = true;
      });
    }, callDisconnected: () {
      print('Call disconnected');
      setState(() {
        _isCallActive = false;
        _isVideoCall = false;
      });
    });
  }

  void _startCall({bool isVideo = false}) {
    if (_isRegistered && !_isCallActive) {
      String extensionNumber = _phoneController.text;
      if (extensionNumber.isNotEmpty) {
        setState(() {
          _isVideoCall = isVideo;
        });
        SipWrapper.wrapper.startCall(extensionNumber, isVideo);

        if (isVideo) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoCallScreen(onEndCall: _endCall),
            ),
          );
        }
      }
    }
  }

  void _endCall() {
    if (_isCallActive) {
      SipWrapper.wrapper.endCall();
      setState(() {
        _isCallActive = false;
        _isVideoCall = false;
      });
      Navigator.pop(context); // Pop the video call screen
    }
  }

  Future<void> _saveExtensionNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('extension_number', number);
  }

  @override
  void dispose() {
    SipWrapper.wrapper.unregister();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIP Call'),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.lightBlue, width: 3),
                ),
                labelText: 'Extension Number',
                labelStyle: const TextStyle(color: Colors.lightBlue),
                prefixIcon: const Icon(Icons.phone, color: Colors.lightBlue),
                hintStyle: TextStyle(color: Colors.lightBlue.withOpacity(0.6)),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () async {
                String phoneNumber = _phoneController.text;
                if (phoneNumber.isNotEmpty) {
                  await _saveExtensionNumber(phoneNumber);
                  _startCall();
                }
              },
              icon: const Icon(Icons.phone, color: Colors.lightBlue),
              label: const Text(
                'Audio Call',
                style: TextStyle(
                  color: Colors.lightBlue, // Replace Colors.blue with your desired color
                ),
              ),

                style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.white, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                String phoneNumber = _phoneController.text;
                if (phoneNumber.isNotEmpty) {
                  await _saveExtensionNumber(phoneNumber);
                  _startCall(isVideo: true);
                }
              },
              icon: const Icon(Icons.videocam, color: Colors.lightBlue),
              label: const Text(
              'Video Call',
              style: TextStyle(
                color: Colors.lightBlue,
              ),
            ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (_isCallActive)
              ElevatedButton.icon(
                onPressed: _endCall,
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
            const SizedBox(height: 10),
            _isRegistering
                ? const CircularProgressIndicator()
                : _isRegistered
                ? const Icon(Icons.check_circle, color: Colors.green, size: 50.0)
                : const Icon(Icons.error, color: Colors.red, size: 50.0),
            const SizedBox(height: 10),
            Text(
              _isRegistering
                  ? 'SIP Registering...'
                  : _isRegistered
                  ? 'Registered'
                  : 'Registration Failed',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
