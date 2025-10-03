part of '../../package_rename_plus.dart';

void _setLinuxConfigurations(dynamic linuxConfig) {
  try {
    if (linuxConfig == null) return;
    if (linuxConfig is! Map) throw _PackageRenameErrors.invalidLinuxConfig;

    final linuxConfigMap = Map<String, dynamic>.from(linuxConfig);

    _setLinuxAppName(linuxConfigMap[_appNameKey]);
    _setLinuxPackageName(linuxConfigMap[_packageNameKey]);
    _setLinuxExecutableName(linuxConfigMap[_executableKey]);
  } on _PackageRenameException catch (e) {
    PackageRenamePlusLogger.error('${e.message}ERR Code: ${e.code}');
    PackageRenamePlusLogger.error('Skipping Linux configuration!!!');
  } catch (e) {
    PackageRenamePlusLogger.warning(e.toString());
    PackageRenamePlusLogger.error('ERR Code: 255');
    PackageRenamePlusLogger.error('Skipping Linux configuration!!!');
  } finally {
    if (linuxConfig != null) {
      PackageRenamePlusLogger.warning(_majorTaskDoneLine);
    }
  }
}

void _setLinuxAppName(dynamic appName) {
  try {
    if (appName == null) return;
    if (appName is! String) throw _PackageRenameErrors.invalidAppName;

    final myAppFile = File(_linuxMyApplicationFilePath);
    final runnerMyAppFile = File(_linuxRunnerMyApplicationFilePath);

    final doesMyAppFileExist = myAppFile.existsSync();
    final doesRunnerMyAppFileExist = runnerMyAppFile.existsSync();

    if (!doesMyAppFileExist && !doesRunnerMyAppFileExist) {
      throw _PackageRenameErrors.linuxMyApplicationNotFound;
    }

    if (doesMyAppFileExist) {
      final myAppString = myAppFile.readAsStringSync();
      final newTitleMyAppString = myAppString
          .replaceAll(
            RegExp(r'gtk_header_bar_set_title\(header_bar, "(.*)"\);'),
            'gtk_header_bar_set_title(header_bar, "$appName");',
          )
          .replaceAll(
            RegExp(r'gtk_window_set_title\(window, "(.*)"\);'),
            'gtk_window_set_title(window, "$appName");',
          );

      myAppFile.writeAsStringSync(newTitleMyAppString);
    }
    if (doesRunnerMyAppFileExist) {
      final runnerMyAppString = runnerMyAppFile.readAsStringSync();
      final newTitleRunnerMyAppString = runnerMyAppString
          .replaceAll(
            RegExp(r'gtk_header_bar_set_title\(header_bar, "(.*)"\);'),
            'gtk_header_bar_set_title(header_bar, "$appName");',
          )
          .replaceAll(
            RegExp(r'gtk_window_set_title\(window, "(.*)"\);'),
            'gtk_window_set_title(window, "$appName");',
          );

      runnerMyAppFile.writeAsStringSync(newTitleRunnerMyAppString);
    }

    PackageRenamePlusLogger.info(
        'Linux app title set to: `$appName` (my_application.cc)');
  } on _PackageRenameException catch (e) {
    PackageRenamePlusLogger.error('${e.message}ERR Code: ${e.code}');
    PackageRenamePlusLogger.error('Linux App Name change failed!!!');
  } catch (e) {
    PackageRenamePlusLogger.warning(e.toString());
    PackageRenamePlusLogger.error('ERR Code: 255');
    PackageRenamePlusLogger.error('Linux App Name change failed!!!');
  } finally {
    if (appName != null) PackageRenamePlusLogger.warning(_minorTaskDoneLine);
  }
}

void _setLinuxPackageName(dynamic packageName) {
  try {
    if (packageName == null) return;
    if (packageName is! String) throw _PackageRenameErrors.invalidPackageName;

    final cmakeListsFile = File(_linuxCMakeListsFilePath);
    if (!cmakeListsFile.existsSync()) {
      throw _PackageRenameErrors.linuxCMakeListsNotFound;
    }

    final cmakeListsString = cmakeListsFile.readAsStringSync();
    final newAppIDCmakeListsString = cmakeListsString.replaceAll(
      RegExp(r'set\(APPLICATION_ID "(.*?)"\)'),
      'set(APPLICATION_ID "$packageName")',
    );

    cmakeListsFile.writeAsStringSync(newAppIDCmakeListsString);

    PackageRenamePlusLogger.info(
        'Linux application id set to: `$packageName` (CMakeLists.txt)');
  } on _PackageRenameException catch (e) {
    PackageRenamePlusLogger.error('${e.message}ERR Code: ${e.code}');
    PackageRenamePlusLogger.error('Linux Application ID change failed!!!');
  } catch (e) {
    PackageRenamePlusLogger.warning(e.toString());
    PackageRenamePlusLogger.error('ERR Code: 255');
    PackageRenamePlusLogger.error('Linux Application ID change failed!!!');
  } finally {
    if (packageName != null) {
      PackageRenamePlusLogger.warning(_minorTaskDoneLine);
    }
  }
}

void _setLinuxExecutableName(dynamic exeName) {
  try {
    if (exeName == null) return;
    if (exeName is! String) throw _PackageRenameErrors.invalidExecutableName;

    final validExeNameRegExp = RegExp(_desktopBinaryNameTemplate);
    if (!validExeNameRegExp.hasMatch(exeName)) {
      throw _PackageRenameErrors.invalidExecutableNameValue;
    }

    final cmakeListsFile = File(_linuxCMakeListsFilePath);
    if (!cmakeListsFile.existsSync()) {
      throw _PackageRenameErrors.linuxCMakeListsNotFound;
    }

    final cmakeListsString = cmakeListsFile.readAsStringSync();
    final newBinaryNameCmakeListsString = cmakeListsString.replaceAll(
      RegExp(r'set\(BINARY_NAME "(.*?)"\)'),
      'set(BINARY_NAME "$exeName")',
    );

    cmakeListsFile.writeAsStringSync(newBinaryNameCmakeListsString);

    PackageRenamePlusLogger.info(
        'Linux binary name set to: `$exeName` (CMakeLists.txt)');
  } on _PackageRenameException catch (e) {
    PackageRenamePlusLogger.error('${e.message}ERR Code: ${e.code}');
    PackageRenamePlusLogger.error('Linux Executable Name change failed!!!');
  } catch (e) {
    PackageRenamePlusLogger.warning(e.toString());
    PackageRenamePlusLogger.error('ERR Code: 255');
    PackageRenamePlusLogger.error('Linux Executable Name change failed!!!');
  } finally {
    if (exeName != null) PackageRenamePlusLogger.warning(_minorTaskDoneLine);
  }
}
