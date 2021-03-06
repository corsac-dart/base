part of corsac_bootstrap;

/// Base (default) implementation of kernel module responsible for configuring
/// Repository layer of the project.
///
/// This module does a couple things:
/// * registers IdentityMap with project's kernel. It uses `ZoneLocalIdentityMap`.
/// * registers container middleware which decorates all repositories with
///   `IdentityMapRepositoryDecorator` which implements IdentityMap caching on top
///   of entity repositories.
class RepositoryKernelModule extends KernelModule {
  @override
  Map getServiceConfiguration(String environment) {
    return {
      IdentityMap: DI.get(ZoneLocalIdentityMap),
      ZoneLocalIdentityMap: DI.object()
        ..bindParameter('key', const Symbol('zoneLocalIdentityMapCache'))
    };
  }

  @override
  Future initialize(Kernel kernel) {
    kernel.container.addMiddleware(kernel.get(IdentityMapDIMiddleware));
    return new Future.value();
  }

  @override
  Map initializeTask(Kernel kernel) {
    ZoneLocalIdentityMap identityMap = kernel.get(IdentityMap);
    return identityMap.zoneValues;
  }
}
