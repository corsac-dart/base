part of corsac_base;

/// Base (default) implementation of kernel module responsible for configuring
/// Domain layer of the project.
///
/// This module does a couple things:
/// * registers IdentityMap with project's kernel. It uses `ZoneLocalIdentityMap`.
/// * registers container middleware which decorates all repositories with
///   `IdentityMapRepositoryDecorator` which implements IdentityMap caching.
class DomainKernelModule extends KernelModule {
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
}