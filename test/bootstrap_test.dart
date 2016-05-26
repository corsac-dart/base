library corsac_bootstrap.tests.functions;

import 'dart:mirrors';

import 'package:corsac_bootstrap/corsac_bootstrap.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:test/test.dart';
import 'package:logging/logging.dart';

void main() {
  var bootstrap = new CorsacBootstrap();
  bootstrap.logLevel = Level.OFF;
  var libPath = currentMirrorSystem()
      .findLibrary(#corsac_bootstrap.tests.functions)
      .uri
      .path;
  var projectRoot =
      libPath.replaceFirst('bootstrap_test.dart', 'fixtures/in_root/');
  var badProjectRoot =
      libPath.replaceFirst('bootstrap_test.dart', 'fixtures/in_sub/');
  var envCheckRoot =
      libPath.replaceFirst('bootstrap_test.dart', 'fixtures/env_check/');

  group('CorsacBootstrap:', () {
    tearDown(() {
      dotenv.clean();
    });

    test('it builds kernel', () async {
      var kernel = await bootstrap.buildKernel(projectRoot: projectRoot);
      expect(kernel, new isInstanceOf<Kernel>());
      expect(kernel.environment, 'local');
    });

    test('it requires environment be not empty', () {
      expect(() {
        return bootstrap.buildKernel(projectRoot: badProjectRoot);
      }, throwsStateError);
    });

    test('it sets environment and project root entries in container', () async {
      var kernel = await bootstrap.buildKernel(projectRoot: projectRoot);
      expect(kernel.get('project.root'), projectRoot);
      expect(kernel.get('project.environment'), 'local');
    });

    test('it validates environment if .envcheck is present', () {
      var error;
      try {
        bootstrap.buildKernel(projectRoot: envCheckRoot);
      } on StateError catch (e) {
        error = e;
      }

      expect(error, new isInstanceOf<StateError>());
      expect(error.message,
          'Environment variables are not set: MUST_BE_PRESENT, THIS_ONE_TOO');
    });
  });
}
