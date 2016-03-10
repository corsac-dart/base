part of corsac_base;

String findProjectRoot(String scriptPath, String configFilename) {
  var uri = new Uri.file(scriptPath, windows: Platform.isWindows);
  var segments = uri.pathSegments.toList();
  while (segments.isNotEmpty) {
    segments.removeLast();

    var candidate = new List.from(segments);
    candidate.addAll([configFilename]);
    var candidateUri = uri.replace(pathSegments: candidate);
    if (new File.fromUri(candidateUri).existsSync()) {
      return uri
              .replace(pathSegments: segments)
              .toFilePath(windows: Platform.isWindows) +
          Platform.pathSeparator;
    }
    candidate = new List.from(segments);
    candidate.addAll(['config', configFilename]);
    candidateUri = uri.replace(pathSegments: candidate);
    if (new File.fromUri(candidateUri).existsSync()) {
      return uri
              .replace(pathSegments: segments)
              .toFilePath(windows: Platform.isWindows) +
          Platform.pathSeparator;
    }
  }
  throw new StateError(
      'Could not locate project root from path ${scriptPath}. ${configFilename} does not exist.');
}
