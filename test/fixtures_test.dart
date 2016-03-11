library corsac_base.tests.fixtures;

import 'dart:io';
import 'dart:mirrors';

import 'package:corsac_base/test.dart';
import 'package:test/test.dart';

void main() {
  group('FixturesBuildCommand:', () {
    var lib = currentMirrorSystem().findLibrary(#corsac_base.tests.fixtures);
    var seg = lib.uri.pathSegments.toList();
    seg.removeLast();
    seg.addAll(['resources', 'fixtures']);
    var fixturesRoot =
        lib.uri.replace(pathSegments: seg).path + Platform.pathSeparator;
    new Directory(fixturesRoot).createSync(recursive: true);

    setUp(() {
      for (var f in new Directory(fixturesRoot).listSync()) {
        f.deleteSync();
      }
    });

    tearDown(() {
      for (var f in new Directory(fixturesRoot).listSync()) {
        f.deleteSync();
      }
    });

    test('it builds fixtures', () async {
      var command = new FixturesBuildCommand(
          'corsac_base.tests.fixtures', [new Post(1, 'Test')]);
      command.run();
      expect(new File(fixturesRoot + 'Post-1.json').existsSync(), isTrue);
    });
  });
}

class Post {
  final int id;
  String name;

  Post(this.id, this.name);
}
