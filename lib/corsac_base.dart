library corsac_base;

import 'dart:async';
import 'dart:io';

import 'package:corsac_kernel/corsac_kernel.dart';
import 'package:corsac_stateless/corsac_stateless.dart';
import 'package:corsac_stateless/di.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

export 'package:corsac_kernel/corsac_kernel.dart' show Kernel, KernelModule;

part 'src/bootstrap.dart';
part 'src/modules.dart';
