// ignore_for_file: avoid_print

part of '../../package_rename_plus.dart';

void _setIOSConfigurations(dynamic iosConfig) {
  try {
    if (iosConfig == null) return;
    if (iosConfig is! Map) throw _PackageRenameErrors.invalidIOSConfig;

    final iosConfigMap = Map<String, dynamic>.from(iosConfig);

    _setIOSDisplayName(iosConfigMap[_appNameKey]);
    _setIOSBundleName(iosConfigMap[_bundleNameKey]);
    _setIOSPackageName(
      oldPackageName: iosConfigMap[_overrideOldPackageKey],
      packageName: iosConfigMap[_packageNameKey],
    );
  } on _PackageRenameException catch (e) {
    print('${e.message}ERR Code: ${e.code}');
    print('Skipping iOS configuration!!!');
  } catch (e) {
    print(e);
    print('ERR Code: 255');
    print('Skipping iOS configuration!!!');
  } finally {
    if (iosConfig != null) print(_majorTaskDoneLine);
  }
}

void _setIOSDisplayName(dynamic appName) {
  try {
    if (appName == null) return;
    if (appName is! String) throw _PackageRenameErrors.invalidAppName;

    final iosInfoPlistFile = File(_iosInfoPlistFilePath);
    if (!iosInfoPlistFile.existsSync()) {
      throw _PackageRenameErrors.iosInfoPlistNotFound;
    }

    final iosInfoPlistString = iosInfoPlistFile.readAsStringSync();
    final newDisplayNameIOSInfoPlistString = iosInfoPlistString.replaceAll(
      RegExp(r'<key>CFBundleDisplayName</key>\s*<string>(.*?)</string>'),
      '<key>CFBundleDisplayName</key>\n\t<string>$appName</string>',
    );

    iosInfoPlistFile.writeAsStringSync(newDisplayNameIOSInfoPlistString);

    print('iOS display name set to: `$appName` (Info.plist)');
  } on _PackageRenameException catch (e) {
    print('${e.message}ERR Code: ${e.code}');
    print('iOS Display Name change failed!!!');
  } catch (e) {
    print(e);
    print('ERR Code: 255');
    print('iOS Display Name change failed!!!');
  } finally {
    if (appName != null) print(_minorTaskDoneLine);
  }
}

void _setIOSBundleName(dynamic bundleName) {
  try {
    if (bundleName == null) return;
    if (bundleName is! String) throw _PackageRenameErrors.invalidBundleName;

    if (bundleName.length > 15) {
      print(
        'Bundle name is too long. Maximum length should be 15'
        ' characters.',
      );
    }

    final iosInfoPlistFile = File(_iosInfoPlistFilePath);
    if (!iosInfoPlistFile.existsSync()) {
      throw _PackageRenameErrors.iosInfoPlistNotFound;
    }

    final iosInfoPlistString = iosInfoPlistFile.readAsStringSync();
    final newBundleNameIOSInfoPlistString = iosInfoPlistString.replaceAll(
      RegExp(r'<key>CFBundleName</key>\s*<string>(.*?)</string>'),
      '<key>CFBundleName</key>\n\t<string>$bundleName</string>',
    );

    iosInfoPlistFile.writeAsStringSync(newBundleNameIOSInfoPlistString);

    print('iOS bundle name set to: `$bundleName` (Info.plist)');
  } on _PackageRenameException catch (e) {
    print('${e.message}ERR Code: ${e.code}');
    print('iOS Bundle Name change failed!!!');
  } catch (e) {
    print(e);
    print('ERR Code: 255');
    print('iOS Bundle Name change failed!!!');
  } finally {
    if (bundleName != null) print(_minorTaskDoneLine);
  }
}

void _setIOSPackageName({dynamic oldPackageName, dynamic packageName}) {
  try {
    if (packageName == null) return;
    if (packageName is! String) throw _PackageRenameErrors.invalidPackageName;

    final iosProjectFile = File(_iosProjectFilePath);
    if (!iosProjectFile.existsSync()) {
      throw _PackageRenameErrors.iosProjectFileNotFound;
    }

    final iosProjectString = iosProjectFile.readAsStringSync();
    final newBundleIDIOSProjectString = iosProjectString
        // Replaces old bundle id from
        // `PRODUCT_BUNDLE_IDENTIFIER = {{BUNDLE_ID}};`
        .replaceAll(
      RegExp(
        'PRODUCT_BUNDLE_IDENTIFIER = $oldPackageName(?<!\\.RunnerTests);',
      ),
      'PRODUCT_BUNDLE_IDENTIFIER = $packageName;',
    )
        // Removes old bundle id from
        // `PRODUCT_BUNDLE_IDENTIFIER = "{{BUNDLE_ID}}.{{EXTENSION_NAME}}";`
        .replaceAllMapped(
      RegExp(
        'PRODUCT_BUNDLE_IDENTIFIER = $oldPackageName\\.([A-Za-z0-9.-_]+);',
      ),
      (match) {
        final extensionName = match.group(1);
        final isContains = packageName.contains(extensionName.toString());
        if (isContains) {
          return 'PRODUCT_BUNDLE_IDENTIFIER = $packageName;';
        } else {
          return 'PRODUCT_BUNDLE_IDENTIFIER = $packageName.$extensionName;';
        }
      },
    );

    iosProjectFile.writeAsStringSync(newBundleIDIOSProjectString);

    print('iOS bundle identifier set to: `$packageName` (project.pbxproj)');
  } on _PackageRenameException catch (e) {
    print('${e.message}ERR Code: ${e.code}');
    print('iOS Bundle Identifier change failed!!!');
  } catch (e) {
    print(e);
    print('ERR Code: 255');
    print('iOS Bundle Identifier change failed!!!');
  } finally {
    if (packageName != null) print(_minorTaskDoneLine);
  }
}
