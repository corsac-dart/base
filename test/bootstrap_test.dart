library corsac_base.tests.functions;

import 'dart:mirrors';

import 'package:corsac_base/corsac_base.dart';
import 'package:test/test.dart';

void main() {
  group('Bootstrap.findProjectRoot:', () {
    var bootstrap = new Bootstrap();
    var libPath = currentMirrorSystem()
        .findLibrary(#corsac_base.tests.functions)
        .uri
        .path;

    test('it finds project root with config in the same folder', () {
      var path = libPath.replaceFirst(
          'bootstrap_test.dart', 'fixtures/in_root/run.dart');
      var resultPath = bootstrap.findProjectRoot(path);
      expect(resultPath, endsWith('test/fixtures/in_root/'));
    });

    test('it finds project root with config in the `config` subfolder', () {
      var path = libPath.replaceFirst(
          'bootstrap_test.dart', 'fixtures/in_sub/run.dart');
      var resultPath = bootstrap.findProjectRoot(path);
      expect(resultPath, endsWith('test/fixtures/in_sub/'));
    });

    test('it throws StateError if config file not found.', () {
      var path = libPath;
      expect(() {
        bootstrap.findProjectRoot(path);
      }, throwsStateError);
    });
  });
}
