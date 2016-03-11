/// Testing features for Corsac projects.
library corsac_base.test;

import 'dart:async';

import 'package:corsac_console/corsac_console.dart';
import 'package:corsac_kernel/corsac_kernel.dart';
import 'package:corsac_stateless/di.dart';

part 'src/test/test_tools.dart';

class TestKernelModule extends KernelModule {
  @override
  Future initialize(Kernel kernel) {
    if (kernel.environment == 'test') {
      // Register in-memory implementations for repository layer.
      kernel.container.addMiddleware(new InMemoryRepositoryDIMiddleware());
    }
    return new Future.value();
  }
}
