library corsac_bootstrap.tests.functions;

import 'dart:mirrors';

import 'package:corsac_bootstrap/corsac_bootstrap.dart';
import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:test/test.dart';
import 'package:logging/logging.dart';

void main() {
  var bootstrap = new Bootstrap();
  bootstrap.logLevel = Level.OFF;
  var libPath = currentMirrorSystem()
      .findLibrary(#corsac_bootstrap.tests.functions)
      .uri
      .path;
  var projectRoot =
      libPath.replaceFirst('bootstrap_test.dart', 'fixtures/in_root/');
  var badProjectRoot =
      libPath.replaceFirst('bootstrap_test.dart', 'fixtures/in_sub/');

  group('Bootstrap.buildKernel:', () {
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
  });
}
