import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioService extends ChangeNotifier {
  FlutterSoundPlayer? _player;
  FlutterSoundRecorder? _recorder;
  bool isRecording = false;

  AudioService() {
    _player = FlutterSoundPlayer();
    _recorder = FlutterSoundRecorder();
  }

  Future<void> startRecording() async {
    await _recorder?.startRecorder(toFile: 'temp_audio.aac');
    isRecording = true;
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await _recorder?.stopRecorder();
    isRecording = false;
    notifyListeners();
  }

  Future<void> playAudio(String audioPath) async {
    await _player?.startPlayer(fromURI: audioPath);
  }

  @override
  void dispose() {
    _player?.closePlayer();
    _recorder?.closeRecorder();
    super.dispose();
  }

  void setQuality(String newValue) {}

  void setVolume(double value) {}
}