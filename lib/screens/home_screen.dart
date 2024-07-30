// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';

import '../widgets/waveform.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  List<double> _waveformData = [];

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    await _audioPlayer.setAsset('assets/audio/music.mp3');
    _audioPlayer.setLoopMode(LoopMode.all);
    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration ?? Duration.zero;
      });
    });
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _position = position;
        _updateWaveform();
      });
    });
  }

  void _updateWaveform() {
    List<double> amplitudeData = _getAmplitudeData();

    setState(() {
      _waveformData = amplitudeData;
    });
  }

  List<double> _getAmplitudeData() {
    List<double> amplitudeData =
        List.generate(60, (index) => Random().nextDouble());
    return amplitudeData;
  }

  void _playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _stop() {
    _audioPlayer.stop();
    setState(() {
      isPlaying = false;
      _position = const Duration();
    });
  }

  void _seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }

  double _volume = 0.5;

  void _increaseVolume() {
    setState(() {
      _volume = (_volume + 0.1).clamp(0.0, 1.0);
      _audioPlayer.setVolume(_volume);
    });
  }

  void _decreaseVolume() {
    setState(() {
      _volume = (_volume - 0.1).clamp(0.0, 1.0);
      _audioPlayer.setVolume(_volume);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.music_note),
        title: Text('Audio Visualizer', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text('237', style: TextStyle(color: Colors.white)),
                SizedBox(width: 8.0),
                Text(
                  'Online',
                  style: TextStyle(color: Colors.white70),
                )
              ],
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.black,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text(
                                'Back to Plinko',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Tru Tones – Dancing (feat. Roger)',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              'Seth Pantalony',
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: _waveformData.map((amplitude) {
                                  return Flexible(
                                    child: WaveformBar(
                                      amplitude: amplitude,
                                      numBlocks: 100,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        bottomLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      icon: const Icon(Icons.skip_previous,
                                          color: Colors.white),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: _playPause,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    decoration: BoxDecoration(
                                      color: Colors.pink,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      icon: const Icon(Icons.skip_next,
                                          color: Colors.white),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Slider(
                              value: _position.inMilliseconds.toDouble().clamp(
                                  0.0, _duration.inMilliseconds.toDouble()),
                              min: 0.0,
                              max: _duration.inMilliseconds.toDouble(),
                              onChanged: (double value) {
                                setState(() {
                                  print('Slider Value: $value');
                                  _seekToSecond((value ~/ 1000).toInt());
                                });
                              },
                              activeColor: Colors.pink,
                              inactiveColor: Colors.white30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(_position),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    _formatDuration(_duration),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.volume_down,
                                        color: Colors.white),
                                    onPressed: _decreaseVolume,
                                  ),
                                  Expanded(
                                    child: Slider(
                                      value: _volume,
                                      min: 0.0,
                                      max: 1.0,
                                      onChanged: (double value) {
                                        setState(() {
                                          _volume = value;
                                          _audioPlayer.setVolume(_volume);
                                        });
                                      },
                                      activeColor: Colors.purple,
                                      inactiveColor: Colors.white30,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.volume_up,
                                        color: Colors.white),
                                    onPressed: _increaseVolume,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
