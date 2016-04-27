/// Testing utilities for Corsac projects.
library corsac_bootstrap.testing;

import 'dart:mirrors';

import 'package:corsac_bootstrap/corsac_bootstrap.dart';
import 'package:test/test.dart' as t;

export 'package:test/test.dart' hide test;

/// Creates a new test case with given description (converted to a string) and
/// body.
///
/// This function wraps original `test` function from the `test` package and
/// allows [body] with positional parameters which can refer to kernel
/// services. This enables basic dependency injection in tests:
///
///     test('repository can store entities', (Repository<User> userRepository) {
///       var user = new User(123, 'Burt Macklin');
///       expect(userRepository.put(user), completes);
///     }, bootstrap: new MyBootstrap());
///
/// In order for DI to work it is required to pass named parameter `bootstrap`
/// with instance of your project's Bootstrap class configured for tests.
///
/// If body has no parameters then behavior of this function is the same as the
/// original one so it will act as a proxy.
test(description, Function body,
    {Bootstrap bootstrap,
    String testOn,
    t.Timeout timeout,
    skip,
    tags,
    Map<String, dynamic> onPlatform}) {
  FunctionTypeMirror m = reflect(body).type;
  if (m.parameters.isEmpty) {
    t.test(description, body);
  } else {
    t.test(description, () async {
      var kernel = await bootstrap.buildKernel();
      var f = kernel.execute(body);
      t.expect(f, t.completes);
    },
        testOn: testOn,
        timeout: timeout,
        skip: skip,
        tags: tags,
        onPlatform: onPlatform);
  }
}
