import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  final FlutterTts flutterTts = FlutterTts();
  bool switchValue = false;
  final SpeechToText speechToText = SpeechToText();
  String _textResult = '';
  bool _isListening = false;

  void checkMicrophoneAvailability() async {
    bool available = await speechToText.initialize();
    if (available) {
      setState(() {
        if (kDebugMode) {}
      });
    } else {
      if (kDebugMode) {
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
    }
  }

  Future<void> _setLanguage() async {
    await flutterTts.setLanguage("vi-VN");
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
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

    try {
      final result = await DeviceService.textHandler(_textResult);
      Fluttertoast.showToast(
        msg: result,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      _speak(result);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Có lỗi xảy ra khi xử lý văn bản ${e.toString()}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkMicrophoneAvailability();
    _setLanguage();
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
          CircleAvatar(
            radius: 35, // The radius of the circle
            backgroundColor: Colors.blueAccent,
            child: IconButton(
              onPressed: _isListening ? _stopListening : _listening,
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 30,
                color: _isListening ? Colors.red : Colors.white,
              ),
            ),
          ),
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
