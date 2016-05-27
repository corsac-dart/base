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

  group('test project root:', () {
    test('it can handle whitespaces in project root path', () {
      const path =
          'application/dart;charset=utf-8,%20%20%20%20%20%20%20%20import%20%22dart:isolate%22;%0A%0A%20%20%20%20%20%20%20%20import%20%22package:stream_channel/stream_channel.dart%22;%0A%0A%20%20%20%20%20%20%20%20import%20%22package:test/src/runner/plugin/remote_platform_helpers.dart%22;%0A%20%20%20%20%20%20%20%20import%20%22package:test/src/runner/vm/catch_isolate_errors.dart%22;%0A%0A%20%20%20%20%20%20%20%20import%20%22file:///Users/anatoly/Personal/Unit%2520tests%2520for%2520Tests/test/example_test.dart%22%20as%20test;%0A%0A%20%20%20%20%20%20%20%20void%20main(_,%20SendPort%20message)%20%7B%0A%20%20%20%20%20%20%20%20%20%20var%20channel%20=%20serializeSuite(()%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20catchIsolateErrors();%0A%20%20%20%20%20%20%20%20%20%20%20%20return%20test.main;%0A%20%20%20%20%20%20%20%20%20%20%7D);%0A%20%20%20%20%20%20%20%20%20%20new%20IsolateChannel.connectSend(message).pipe(channel);%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20';
      var result = findTestProjectRoot(scriptPath: path);
      expect(result, '/Users/anatoly/Personal/Unit tests for Tests/');
    });

    test('it supports test executed directly via vm', () {
      const path = '/home/user/project/test/my_test.dart';
      var result = findTestProjectRoot(scriptPath: path);
      expect(result, '/home/user/project/');
    });
  });
}

class SimpleService {}
