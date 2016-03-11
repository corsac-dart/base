part of corsac_base;

class Bootstrap {
  /// Name of environment variable defining project environment.
  final String projectEnvVarname = 'PROJECT_ENV';

  final String projectConfigFilename = 'parameters.yaml';

  final KernelModule domainModule = new DomainKernelModule();

  final List<KernelModule> infrastructureModules = [];

  Future<Kernel> buildKernel(String projectRoot,
      {List<KernelModule> applicationModules: const []}) {
    if (!dotenv.env.containsKey(projectEnvVarname) &&
        new File('${projectRoot}/.env').existsSync()) {
      // Only load dotenv if project environment is not yet defined in the
      // system environment variables.
      dotenv.load('${projectRoot}/.env');
    }
    String environment = dotenv.env[projectEnvVarname];

    // var infrastructure = new TwitterExtensionInfrastructureModule();
    List<KernelModule> modules = [domainModule];
    modules.addAll(infrastructureModules);
    modules.addAll(applicationModules);

    // _logger.info('Initializing project with `${environment}` environment.');
    // _logger.info('Using ${projectRoot} as project root.');

    var parameters = loadParameters(projectRoot, projectConfigFilename);
    parameters['project_root'] = projectRoot;
    parameters['environment'] = environment;
    //
    // String levelName = parameters['logging.level'];
    // Logger.root.level =
    //     Level.LEVELS.firstWhere((_) => _.name == levelName.toUpperCase());
    return Kernel.build(environment, parameters, modules);
  }

  Map loadParameters(String projectRoot, String filename) {
    return {}; // TODO: actually load parameters
  }
}
