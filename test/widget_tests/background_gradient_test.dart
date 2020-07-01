import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod_app/widgets/background_gradient.dart';
import 'package:flutter/material.dart';

void main() {
  final Widget child = Container();
  final BackgroundGradient bgg = BackgroundGradient(child: child);
  testWidgets('BackgroundGradient has Linear Gradient',
      (WidgetTester tester) async {
    await tester.pumpWidget(bgg);

    final linearGradientFinder = find.byType(BoxDecoration);

    expect(linearGradientFinder, findsOneWidget);
  });
  testWidgets('BackgroundGround has child', (WidgetTester tester) async {
    await tester.pumpWidget(bgg);
    expect(find.byWidget(child), findsOneWidget);
  });
}
