library corsac_bootstrap.tests.testing;

import 'package:corsac_bootstrap/testing.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

void main() {
  group('test wrapper:', () {
    var bootstrap = new Bootstrap();
    bootstrap.logLevel = Level.OFF;

    setUp(() {
      dotenv.env['CORSAC_ENV'] = 'test';
    });

    tearDown(() {
      dotenv.clean();
    });

    test('we can resolve dependencies in test functions',
        (SimpleService service) {
      expect(service, new isInstanceOf<SimpleService>());
    }, bootstrap: bootstrap);
  });
}

class SimpleService {}
