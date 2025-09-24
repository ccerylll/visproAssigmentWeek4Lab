// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Local counter increments and decrements test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyAdvancedCounterApp());

    // Verify that our local counter starts at 0.
    expect(find.text('Local Counter: 0'), findsOneWidget);

    // Test increment
    await tester.tap(find.text('Increment'));
    await tester.pump();
    expect(find.text('Local Counter: 1'), findsOneWidget);

    // Test decrement
    await tester.tap(find.text('Decrement'));
    await tester.pump();
    expect(find.text('Local Counter: 0'), findsOneWidget);
  });

  testWidgets('Global state - Add counter test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyAdvancedCounterApp());

    // Initially no counters
    expect(find.text('No counters yet'), findsOneWidget);
    expect(find.text('Total: 0'), findsOneWidget);

    // Add a counter
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify counter was added
    expect(find.text('Total: 1'), findsOneWidget);
    expect(find.text('Counter 1'), findsOneWidget);
  });

  testWidgets('Global state - Counter increment and decrement', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyAdvancedCounterApp());

    // Add a counter first
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Find increment button and tap it
    final incrementButton = find.byTooltip('Increment');
    await tester.tap(incrementButton);
    await tester.pump();

    // Verify counter incremented
    expect(find.text('Value: 1'), findsOneWidget);

    // Find decrement button and tap it
    final decrementButton = find.byTooltip('Decrement');
    await tester.tap(decrementButton);
    await tester.pump();

    // Verify counter decremented
    expect(find.text('Value: 0'), findsOneWidget);
  });
}
