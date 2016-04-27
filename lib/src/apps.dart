part of corsac_bootstrap;

typedef Future startApp();

class AppSupervisor {
  final apps;

  Map<String, Set<Future<Isolate>>> isolates;

  AppSupervisor(this.apps);

  /// Starts application(s).
  ///
  /// By default will start all applications according to their configuration.
  /// If [appName] is set then only that application will be started.
  void start({String appName}) {
    var rPort = new ReceivePort();
    Isolate.spawn((_) {
      // do start
    }, rPort.sendPort);
  }

  /// Stops application(s).
  Future stop({String appName}) {
    return null;
  }
}

class AppConfig {
  final int instances;

  AppConfig(this.instances);
}

typedef Future RunApp(int instanceId, AppConfig config);
