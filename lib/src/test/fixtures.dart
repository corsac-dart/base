part of corsac_base.test;

class FixturesCommand extends Command {
  @override
  String get description => 'Manage testing fixtures';

  @override
  String get name => 'fixtures';

  FixturesCommand(FixturesBuildCommand buildCommand) {
    addSubcommand(buildCommand);
  }
}

class FixturesBuildCommand extends Command {
  final String projectName;
  final Iterable<Object> fixtures;
  @override
  String get description => 'Builds fixtures';

  @override
  String get name => 'build';

  FixturesBuildCommand(this.projectName, this.fixtures);

  @override
  run() {
    var lib = currentMirrorSystem().findLibrary(new Symbol(projectName));
    var seg = lib.uri.pathSegments.toList();
    seg.removeLast();
    seg.addAll(['resources', 'fixtures']);
    var fixturesRoot =
        lib.uri.replace(pathSegments: seg).path + Platform.pathSeparator;

    new Directory(fixturesRoot).createSync(recursive: true);

    for (var obj in fixtures) {
      var mirror = reflect(obj);
      var name = MirrorSystem.getName(mirror.type.simpleName);
      var stateObject = DTO.extract(obj);
      var id = entityId(obj);
      var data = {
        'library': MirrorSystem.getName(mirror.type.owner.simpleName),
        'name': name,
        'data': stateObject
      };
      var codec = new JsonEncoder.withIndent(' ' * 2);
      var json = codec.convert(data);

      var filename = fixturesRoot + '${name}-${id}.json';
      var file = new File(filename);
      file.writeAsStringSync(json, flush: true);
    }
  }
}
