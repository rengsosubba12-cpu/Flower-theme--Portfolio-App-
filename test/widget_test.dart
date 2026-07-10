import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_portfolio/main.dart';

void main() {
  testWidgets('PersonalPortfolioApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const PersonalPortfolioApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
