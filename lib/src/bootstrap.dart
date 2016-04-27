part of corsac_bootstrap;

/// Default name of system variable which defines project environment.
const _ENV = 'CORSAC_ENV';

/// Bootstraps the project.
///
/// This is the main entry point which should be used in executable scripts to
/// initialize and run project's applications if needed.
class Bootstrap {
  /// The name of project.
  String projectName = 'project_name';

  /// Global logging level for project.
  Level logLevel = Level.INFO;

  /// List of kernel modules for infrastructure layer.
  final List<KernelModule> modules = [new RepositoryKernelModule()];

  /// Builds this project's Kernel.
  Future<Kernel> buildKernel(
      {List<KernelModule> applicationModules: const [], String projectRoot}) {
    setupLoggers();

    var dotenvFilename = '${projectRoot}.env';
    if (!dotenv.env.containsKey(_ENV) &&
        new File(dotenvFilename).existsSync()) {
      // Only load dotenv if project environment is not yet defined in the
      // system environment variables.
      Logger.root.info('dotenv file found, loading environment.');
      dotenv.load(dotenvFilename);
    }

    String environment = dotenv.env[_ENV];
    if (environment == null || environment.isEmpty) {
      throw new StateError('Environment for project is not set.');
    }

    List<KernelModule> actualModules = [];
    actualModules.addAll(modules);
    actualModules.addAll(applicationModules);

    Logger.root.info('Initializing project with `${environment}` environment.');
    Logger.root.info('Using ${projectRoot} as project root.');

    var parameters = _loadParameters(projectRoot, 'parameters.yaml');
    parameters['project.root'] = projectRoot;
    parameters['project.environment'] = environment;

    return Kernel.build(environment, parameters, actualModules);
  }

  /// Creates project's console app.
  Future<Console> createConsole({String projectRoot}) async {
    var kernel =
        await buildKernel(applicationModules: [], projectRoot: projectRoot);
    return new Console(kernel, 'console', 'CLI console for $projectName.');
  }

  /// Sets up loggers.
  ///
  /// By default will output all logs to stdout.
  void setupLoggers() {
    Logger.root.level = logLevel;
    Logger.root.onRecord.listen((LogRecord record) {
      var d = record.time.toUtc().toIso8601String();
      print('[${d}] ${record}');
      if (record.error != null) print(record.error);
      if (record.stackTrace != null) print(record.stackTrace);
    });
  }

  /// Loads parameters file.
  ///
  /// Only `yaml` format supported.
  Map _loadParameters(String projectRoot, String filename) {
    File confFile = new File('${projectRoot}${filename}');

    if (!confFile.existsSync()) {
      confFile = new File('${projectRoot}config/${filename}');
      if (!confFile.existsSync()) {
        Logger.root.info('Parameters file not found for project. Skipping.');
        return {};
      }
    }

    YamlMap yamlParameters =
        loadYaml(confFile.readAsStringSync()) ?? new YamlMap.wrap({});
    Map parameters = new Map.from(yamlParameters.value);

    return parameters;
  }
}
