import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../services/device_service.dart';

class ModalSpeechToText extends StatefulWidget {
  const ModalSpeechToText({super.key});
  @override
  State<ModalSpeechToText> createState() => _ModalSpeechToTextState();
}

class _ModalSpeechToTextState extends State<ModalSpeechToText> {
  bool switchValue = false;
  final SpeechToText speechToText = SpeechToText();
  String _textResult = '';
  bool _isListening = false;

  void checkMicrophoneAvailability() async {
    bool available = await speechToText.initialize();
    if (available) {
      setState(() {
        if (kDebugMode) {
          print('Microphone available: $available');
        }
      });
    } else {
      if (kDebugMode) {
        print("The user has denied the use of speech recognition.");
      }
    }
  }

  void _onResult(SpeechRecognitionResult result) {
    setState(() {
      _textResult = result.recognizedWords;
    });
  }

  void _listening() async {
    if (!_isListening) {
      bool available = await speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
        });
        speechToText.listen(
          onResult: _onResult,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Microphone is not available',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      setState(() {
        _isListening = false;
        speechToText.stop();
      });
    }
  }

  void _stopListening() async {
    setState(() {
      _isListening = false;
      speechToText.stop();
    });

    String result = await DeviceService.textHandler(_textResult);
    Fluttertoast.showToast(
      msg: result,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    super.initState();
    checkMicrophoneAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Speech to text',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _textResult,
                style: const TextStyle(fontSize: 20, color: Colors.black54),
              ),
            ),
          ),
          GestureDetector(
              onTapDown: (_) => _listening(),
              onTapUp: (_) => _stopListening(),
              onTapCancel: () => setState(() => _isListening = false),
              child: CircleAvatar(
                radius: 35, // The radius of the circle
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  size: 30,
                  color: _isListening ? Colors.red : Colors.white,
                ),
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
