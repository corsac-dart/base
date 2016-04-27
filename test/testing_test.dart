library corsac_bootstrap.tests.testing;

import 'package:corsac_bootstrap/testing.dart';

void main() {
  group('test wrapper:', () {
    var bootstrap = new CorsacBootstrap();
    bootstrap.logLevel = Level.OFF;

    test('we can resolve dependencies in test functions',
        (SimpleService service) {
      expect(service, new isInstanceOf<SimpleService>());
    }, bootstrap: bootstrap);
  });
}

class SimpleService {}
