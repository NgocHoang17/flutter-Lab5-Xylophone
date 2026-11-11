import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() => runApp(const XylophoneApp());

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Xylophone',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121C28),
    ),
    home: const XylophonePage(),
  );
}

class XylophonePage extends StatefulWidget {
  const XylophonePage({super.key, this.onPlay});
  final Future<void> Function(int)? onPlay;
  @override
  State<XylophonePage> createState() => _XylophonePageState();
}

class _XylophonePageState extends State<XylophonePage> {
  static const _names = ['Đô', 'Rê', 'Mi', 'Fa', 'Sol', 'La', 'Si'];
  static const _colors = [
    Color(0xFFEF5350),
    Color(0xFFFFA13A),
    Color(0xFFFFD65C),
    Color(0xFF70C79A),
    Color(0xFF48C4C1),
    Color(0xFF6EA7EF),
    Color(0xFFC295E8),
  ];
  // Mỗi nốt có player riêng để những nốt khác nhau có thể ngân đồng thời.
  final Map<int, AudioPlayer> _players = {};
  int? _lastNote;

  Future<void> playSound(int noteNumber) async {
    assert(noteNumber >= 1 && noteNumber <= 7);
    setState(() => _lastNote = noteNumber);
    try {
      if (widget.onPlay != null) {
        await widget.onPlay!(noteNumber);
      } else {
        final player = _players.putIfAbsent(noteNumber, AudioPlayer.new);
        await player.stop();
        await player.play(AssetSource('audio/note$noteNumber.wav'));
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Không phát được âm thanh. Hãy kiểm tra thiết bị âm thanh rồi thử lại.',
            ),
          ),
        );
    }
  }

  @override
  void dispose() {
    for (final player in _players.values) {
      unawaited(player.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('XYLOPHONE / 05')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              children: [
                Text(
                  'Chạm vào giai điệu',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _lastNote == null
                      ? 'Bảy sắc màu, bảy nốt nhạc.'
                      : 'Đang ngân: ${_names[_lastNote! - 1]}',
                  key: const Key('now-playing'),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, box) => SingleChildScrollView(
                      child: SizedBox(
                        height: box.maxHeight < 360 ? 360 : box.maxHeight,
                        child: Column(
                          children: List.generate(
                            7,
                            (index) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: index * 5.0,
                                ),
                                child: TextButton(
                                  key: ValueKey('note-${index + 1}'),
                                  onPressed: () => playSound(index + 1),
                                  style: TextButton.styleFrom(
                                    backgroundColor: _colors[index],
                                    foregroundColor: const Color(0xFF17212A),
                                    minimumSize: const Size(
                                      double.infinity,
                                      48,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${index + 1}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        _names[index],
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.music_note_rounded,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
