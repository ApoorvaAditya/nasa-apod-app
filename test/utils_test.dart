import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_apod_app/utils.dart';

void main() {
  group('RemoveNewLinesAndSpaces Function', () {
    test('New line should be replaced by space', () {
      const String tString = '1\n1';
      expect(Utils.removeNewLinesAndExtraSpace(tString), '1 1');
    });
    test('Extra spaces should be removed', () {
      const String tString = '2   2';
      expect(Utils.removeNewLinesAndExtraSpace(tString), '2 2');
    });
  });
}
