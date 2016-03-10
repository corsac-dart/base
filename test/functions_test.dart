library corsac_base.tests.functions;

import 'dart:mirrors';

import 'package:corsac_base/corsac_base.dart';
import 'package:test/test.dart';

void main() {
  group('findProjectRoot:', () {
    var libPath = currentMirrorSystem()
        .findLibrary(#corsac_base.tests.functions)
        .uri
        .path;

    test('it finds project root with config in the same folder', () {
      var path = libPath.replaceFirst(
          'functions_test.dart', 'fixtures/in_root/run.dart');
      var resultPath = findProjectRoot(path, 'params.yaml');
      expect(resultPath, endsWith('test/fixtures/in_root/'));
    });

    test('it finds project root with config in the `config` subfolder', () {
      var path = libPath.replaceFirst(
          'functions_test.dart', 'fixtures/in_sub/run.dart');
      var resultPath = findProjectRoot(path, 'params.yaml');
      expect(resultPath, endsWith('test/fixtures/in_sub/'));
    });

    test('it throws StateError if config file not found.', () {
      var path = libPath;
      expect(() {
        findProjectRoot(path, 'params.yaml');
      }, throwsStateError);
    });
  });
}
