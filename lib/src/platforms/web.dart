part of '../../package_rename_plus.dart';

void _setWebConfigurations(dynamic webConfig) {
  try {
    if (webConfig == null) return;
    if (webConfig is! Map) throw _PackageRenameErrors.invalidWebConfig;

    final webConfigMap = Map<String, dynamic>.from(webConfig);

    _setWebTitle(webConfigMap[_appNameKey]);
    _setPWAAppName(
      webConfigMap[_appNameKey],
      webConfigMap[_shortAppNameKey],
    );
    _setWebDescription(webConfigMap[_descriptionKey]);
    _setPWADescription(webConfigMap[_descriptionKey]);
  } on _PackageRenameException catch (e) {
    PackageRenamePlusLogger.error('${e.message}ERR Code: ${e.code}');
    PackageRenamePlusLogger.error('Skipping Web configuration!!!');
  } catch (e) {
    PackageRenamePlusLogger.warning(e.toString());
    PackageRenamePlusLogger.error('ERR Code: 255');
    PackageRenamePlusLogger.error('Skipping Web configuration!!!');
  } finally {
    if (webConfig != null) PackageRenamePlusLogger.warning(_majorTaskDoneLine);
  }
}

void _setWebTitle(dynamic appName) {
  try {
    if (appName == null) return;
    if (appName is! String) throw _PackageRenameErrors.invalidAppName;

    final webIndexFile = File(_webIndexFilePath);
    if (!webIndexFile.existsSync()) {
      throw _PackageRenameErrors.webIndexNotFound;
    }

    final webIndexString = webIndexFile.readAsStringSync();
    final webIndexDocument = html.parse(webIndexString);
    webIndexDocument.querySelector('title')?.text = appName;
    webIndexDocument
        .querySelector('meta[name="apple-mobile-web-app-title"]')
        ?.attributes['content'] = appName;

    webIndexFile.writeAsStringSync('${webIndexDocument.outerHtml}\n');

    PackageRenamePlusLogger.info('Web title set to: `$appName` (index.html)');
  } on _PackageRenameException catch (e) {
    PackageRenamePlusLogger.error('${e.message}ERR Code: ${e.code}');
    PackageRenamePlusLogger.error('Web Title change failed!!!');
  } catch (e) {
    PackageRenamePlusLogger.warning(e.toString());
    PackageRenamePlusLogger.error('ERR Code: 255');
    PackageRenamePlusLogger.error('Web Title change failed!!!');
  } finally {
    if (appName != null) PackageRenamePlusLogger.warning(_minorTaskDoneLine);
  }
}

void _setPWAAppName(dynamic appName, dynamic shortAppName) {
  try {
    if (appName == null) return;
    if (appName is! String) throw _PackageRenameErrors.invalidAppName;

    if (shortAppName != null && shortAppName is! String) {
      throw _PackageRenameErrors.invalidShortAppName;
    }
    final actualShortAppName = shortAppName is String ? shortAppName : appName;

    final webManifestFile = File(_webManifestFilePath);
    if (!webManifestFile.existsSync()) {
      PackageRenamePlusLogger.warning('Web manifest.json not found!!!');
      return;
    }

    final webManifestString = webManifestFile.readAsStringSync();
    final webManifestJson = json.decode(
      webManifestString,
    ) as Map<String, dynamic>;

    webManifestJson['name'] = appName;
    webManifestJson['short_name'] = actualShortAppName;

    const encoder = JsonEncoder.withIndent('    ');
    webManifestFile.writeAsStringSync('${encoder.convert(webManifestJson)}\n');

    PackageRenamePlusLogger.info('PWA name set to: `$appName` (manifest.json)');
    PackageRenamePlusLogger.info(
        'PWA short name set to: `$actualShortAppName` (manifest.json)');
  } on _PackageRenameException catch (e) {
    PackageRenamePlusLogger.error('${e.message}ERR Code: ${e.code}');
    PackageRenamePlusLogger.error('PWA Name/Short Name change failed!!!');
  } catch (e) {
    PackageRenamePlusLogger.warning(e.toString());
    PackageRenamePlusLogger.error('ERR Code: 255');
    PackageRenamePlusLogger.error('PWA Name/Short Name change failed!!!');
  } finally {
    if (appName != null) PackageRenamePlusLogger.warning(_minorTaskDoneLine);
  }
}

void _setWebDescription(dynamic description) {
  try {
    if (description == null) return;
    if (description is! String) throw _PackageRenameErrors.invalidDescription;

    final webIndexFile = File(_webIndexFilePath);
    if (!webIndexFile.existsSync()) {
      throw _PackageRenameErrors.webIndexNotFound;
    }

    final webIndexString = webIndexFile.readAsStringSync();
    final webIndexDocument = html.parse(webIndexString);
    webIndexDocument
        .querySelector('meta[name="description"]')
        ?.attributes['content'] = description;

    webIndexFile.writeAsStringSync('${webIndexDocument.outerHtml}\n');

    PackageRenamePlusLogger.info(
        'Web description set to: `$description` (index.html)');
  } on _PackageRenameException catch (e) {
    PackageRenamePlusLogger.error('${e.message}ERR Code: ${e.code}');
    PackageRenamePlusLogger.error('Web Description change failed!!!');
  } catch (e) {
    PackageRenamePlusLogger.warning(e.toString());
    PackageRenamePlusLogger.error('ERR Code: 255');
    PackageRenamePlusLogger.error('Web Description change failed!!!');
  } finally {
    if (description != null) {
      PackageRenamePlusLogger.warning(_minorTaskDoneLine);
    }
  }
}

void _setPWADescription(dynamic description) {
  try {
    if (description == null) return;
    if (description is! String) throw _PackageRenameErrors.invalidDescription;

    final webManifestFile = File(_webManifestFilePath);
    if (!webManifestFile.existsSync()) {
      PackageRenamePlusLogger.warning('Web manifest.json not found!!!');
      return;
    }

    final webManifestString = webManifestFile.readAsStringSync();
    final webManifestJson = json.decode(
      webManifestString,
    ) as Map<String, dynamic>;

    webManifestJson['description'] = description;

    const encoder = JsonEncoder.withIndent('    ');
    webManifestFile.writeAsStringSync('${encoder.convert(webManifestJson)}\n');

    PackageRenamePlusLogger.info(
        'PWA description set to: `$description` (manifest.json)');
  } on _PackageRenameException catch (e) {
    PackageRenamePlusLogger.error('${e.message}ERR Code: ${e.code}');
    PackageRenamePlusLogger.error('PWA Description change failed!!!');
  } catch (e) {
    PackageRenamePlusLogger.warning(e.toString());
    PackageRenamePlusLogger.error('ERR Code: 255');
    PackageRenamePlusLogger.error('PWA Description change failed!!!');
  } finally {
    if (description != null) {
      PackageRenamePlusLogger.warning(_minorTaskDoneLine);
    }
  }
}
