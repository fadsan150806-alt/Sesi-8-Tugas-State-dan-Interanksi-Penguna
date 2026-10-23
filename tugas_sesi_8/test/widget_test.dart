
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_sesi_8/main.dart';

void main() {
  testWidgets('CampusConnect tampil dan navigasi berfungsi',
      (WidgetTester tester) async {
    await tester.pumpWidget(const CampusConnectApp());

    expect(find.text('CampusConnect'), findsOneWidget);
    expect(find.text('Ringkasan Aktivitas'), findsOneWidget);

    await tester.tap(find.text('Jadwal').last);
    await tester.pumpAndSettle();

    expect(find.text('Pilih Hari Perkuliahan'), findsOneWidget);
  });
}
