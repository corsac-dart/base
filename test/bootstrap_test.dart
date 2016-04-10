library corsac_bootstrap.tests.functions;

import 'dart:mirrors';

import 'package:corsac_bootstrap/corsac_bootstrap.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:test/test.dart';

void main() {
  var bootstrap = new Bootstrap();
  var libPath = currentMirrorSystem()
      .findLibrary(#corsac_bootstrap.tests.functions)
      .uri
      .path;
  var defaultScriptPath =
      libPath.replaceFirst('bootstrap_test.dart', 'fixtures/in_root/run.dart');
  var badScriptPath =
      libPath.replaceFirst('bootstrap_test.dart', 'fixtures/in_sub/run.dart');

  group('Bootstrap.findProjectRoot:', () {
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

  group('Bootstrap.buildKernel:', () {
    tearDown(() {
      dotenv.clean();
    });

    test('it builds kernel', () async {
      var root = bootstrap.findProjectRoot(defaultScriptPath);
      var kernel = await bootstrap.buildKernel(projectRoot: root);
      expect(kernel, new isInstanceOf<Kernel>());
      expect(kernel.environment, 'local');
    });

    test('it requires environment be not empty', () {
      var root = bootstrap.findProjectRoot(badScriptPath);
      expect(() {
        return bootstrap.buildKernel(projectRoot: root);
      }, throwsStateError);
    });

    test('it sets environment and project root entries in container', () async {
      var root = bootstrap.findProjectRoot(defaultScriptPath);
      var kernel = await bootstrap.buildKernel(projectRoot: root);
      expect(kernel.get('project.root'), root);
      expect(kernel.get('project.environment'), 'local');
    });
  });
}
