part of corsac_bootstrap;

/// Bootstraps the project.
///
/// This is main entry point which should be used in executable scripts to
/// initialize and run project's applications.
class Bootstrap {
  /// Name of environment variable defining project environment.
  final String environmentVarname = 'PROJECT_ENV';

  /// Name of configuration file.
  final String parametersFilename = 'parameters.yaml';

  /// List of kernel modules for domain layer.
  final List<KernelModule> domainModules = [];

  /// List of kernel modules for infrastructure layer.
  final List<KernelModule> infrastructureModules = [
    new RepositoryKernelModule()
  ];

  /// Builds this project's Kernel.
  Future<Kernel> buildKernel(
      {List<KernelModule> applicationModules: const [], String projectRoot}) {
    projectRoot ??= findProjectRoot(Platform.script.path);

    var dotenvFilename = '${projectRoot}.env';
    if (!dotenv.env.containsKey(environmentVarname) &&
        new File(dotenvFilename).existsSync()) {
      // Only load dotenv if project environment is not yet defined in the
      // system environment variables.
      Logger.root.info('dotenv file found, loading environment.');
      dotenv.load(dotenvFilename);
    }

    String environment = dotenv.env[environmentVarname];
    if (environment == null || environment.isEmpty) {
      throw new StateError('Environment for project is not set.');
    }

    List<KernelModule> modules = [];
    modules.addAll(domainModules);
    modules.addAll(infrastructureModules);
    modules.addAll(applicationModules);

    Logger.root.info('Initializing project with `${environment}` environment.');
    Logger.root.info('Using ${projectRoot} as project root.');

    var parameters = loadParameters(projectRoot, parametersFilename);
    parameters['project.root'] = projectRoot;
    parameters['project.environment'] = environment;

    return Kernel.build(environment, parameters, modules);
  }

  /// Loads parameters file.
  ///
  /// Only `yaml` format supported.
  Map loadParameters(String projectRoot, String filename) {
    File confFile = new File('${projectRoot}${filename}');

    if (!confFile.existsSync()) {
      confFile = new File('${projectRoot}config/${filename}');
      if (!confFile.existsSync())
        throw new StateError('Parameters file ${confFile} does not exist.');
    }

    YamlMap yamlParameters =
        loadYaml(confFile.readAsStringSync()) ?? new YamlMap.wrap({});
    Map parameters = new Map.from(yamlParameters.value);

    return parameters;
  }

  /// Finds project root folder.
  ///
  /// Project root folder serves as a single point of reference to any resources
  /// or assets you wish to store, access and/or distribute with your project.
  ///
  /// The only required asset by default is a parameters file.
  ///
  /// Detection of project root is based on location of parameters file.
  /// If `{root}` is a root folder of this project then configuration file may be
  /// located in following destinations (in order of priority):
  ///
  /// * `{root}/parameters.yaml` (in the root folder itself, recommended).
  /// * `{root}/config/parameters.yaml` (in a `config` subfolder).
  ///
  /// This function will try to locate project root based on the path of
  /// the script being executed. The algorithm is as follows:
  ///
  /// 1. Start from the folder where executable is located and assign it to `{root}`.
  /// 2. Check `{root}/parameters.yaml` and `{root}/config/parameters.yaml`.
  /// 3. If configuration file is found return current value of `{root}`.
  /// 4. If configuration is not found, go up one level and assign new value to `{root}`.
  /// 5. Repeat steps 2-4 until root folder is found or we reached the root of file
  ///   system. In later case `StateError` will be thrown.
  String findProjectRoot(String scriptPath) {
    var uri = new Uri.file(scriptPath, windows: Platform.isWindows);
    var segments = uri.pathSegments.toList();
    while (segments.isNotEmpty) {
      segments.removeLast();

      var candidate = new List.from(segments);
      candidate.addAll([parametersFilename]);
      var candidateUri = uri.replace(pathSegments: candidate);
      if (new File.fromUri(candidateUri).existsSync()) {
        return uri
                .replace(pathSegments: segments)
                .toFilePath(windows: Platform.isWindows) +
            Platform.pathSeparator;
      }
      candidate = new List.from(segments);
      candidate.addAll(['config', parametersFilename]);
      candidateUri = uri.replace(pathSegments: candidate);
      if (new File.fromUri(candidateUri).existsSync()) {
        return uri
                .replace(pathSegments: segments)
                .toFilePath(windows: Platform.isWindows) +
            Platform.pathSeparator;
      }
    }
    throw new StateError(
        'Could not locate project root from path ${scriptPath}. ${parametersFilename} does not exist.');
  }
}
