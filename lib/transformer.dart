import 'package:barback/barback.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class DefinitionTransformer extends Transformer {

  String get allowedExtensions => ".json";

  final BarbackSettings _settings;
  DefinitionTransformer.asPlugin(this._settings);

  Future apply(Transform transform) async {

    String assetsPath = _settings.configuration['assets'];
    if (assetsPath == null)
      assetsPath = 'web/assets';


    if (transform.primaryInput.id.path.contains(assetsPath + '/definition.json')) {


      Map definitions = JSON.decode(await transform.primaryInput.readAsString());;


      Directory assetDir = new Directory(assetsPath);
      List assetDirectories =  assetDir.listSync()
      .where((e) => e is Directory)
      .where((e) => !e.path.contains('packages'));

      for (Directory dir in assetDirectories) {
        String directoryName = dir.path.split('/').last;

        List assetFiles =  dir.listSync()
        .where((entity) => entity is File);
        Map assetNames = {};

        for (FileSystemEntity fse in assetFiles) {
          if (fse.path.endsWith('.json'))
            assetNames[fse.path.split('/').last.split('.').first] = JSON.decode((fse as File).readAsStringSync());
        }

        if (assetNames.isNotEmpty)
          definitions[directoryName] = assetNames;
      }
      transform.logger.info(definitions.toString());

      transform.addOutput(new Asset.fromString(transform.primaryInput.id, JSON.encode(definitions)));
    }
  }
}