/// Testing features for Corsac projects.
library corsac_base.test;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:corsac_console/corsac_console.dart';
import 'package:corsac_dto/corsac_dto.dart';
import 'package:corsac_kernel/corsac_kernel.dart';
import 'package:corsac_stateless/corsac_stateless.dart';
import 'package:corsac_stateless/di.dart';

part 'src/test/fixtures.dart';
part 'src/test/test_tools.dart';

class TestKernelModule extends KernelModule {
  @override
  Map getServiceConfiguration(String environment) {
    return {
      'test_tools.commands': DI.add([DI.get(FixturesCommand)]),
    };
  }

  @override
  Future initialize(Kernel kernel) {
    if (kernel.environment == 'test') {
      // Register in-memory implementations for repository layer.
      kernel.container.addMiddleware(new InMemoryRepositoryDIMiddleware());
    }

    // TODO: Load fixtures

    return new Future.value();
  }
}
