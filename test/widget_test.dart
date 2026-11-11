import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab05_xylophone/main.dart';

void main() {
  testWidgets('Bảy phím gọi đúng nốt và WAV thực sự có dữ liệu', (
    tester,
  ) async {
    final played = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        home: XylophonePage(
          onPlay: (n) async {
            played.add(n);
          },
        ),
      ),
    );
    for (var n = 1; n <= 7; n++) {
      final data = await rootBundle.load('assets/audio/note$n.wav');
      expect(data.lengthInBytes, greaterThan(44100));
      expect(String.fromCharCodes(data.buffer.asUint8List(0, 4)), 'RIFF');
      await tester.tap(find.byKey(ValueKey('note-$n')));
      await tester.pump();
    }
    expect(played, [1, 2, 3, 4, 5, 6, 7]);
    expect(find.text('Đang ngân: Si'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Lỗi phát âm thanh được báo trên giao diện', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: XylophonePage(
          onPlay: (_) async {
            throw StateError('audio');
          },
        ),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('note-1')));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
