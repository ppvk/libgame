import 'package:barback/barback.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class DefinitionTransformer extends Transformer {

  String get allowedExtensions => ".json";
  DefinitionTransformer.asPlugin();

  Future apply(Transform transform) async {
    if (transform.primaryInput.id.path.contains('assets/definition.json')) {


      Map definitions = JSON.decode(await transform.primaryInput.readAsString());;


      Directory assetDir = new Directory('web/assets');
      List assetDirectories =  assetDir.listSync()
      .where((e) => e is Directory)
      .where((e) => !e.path.contains('packages'));

      for (Directory dir in assetDirectories) {
        String directoryName = dir.path.split('/').last;

        List assetFiles =  dir.listSync()
        .where((entity) => entity is File);
        List <String> assetNames = [];

        for (FileSystemEntity fse in assetFiles) {
          assetNames.add(fse.path.split('/').last);
        }

        definitions[directoryName] = assetNames;
      }
      transform.logger.info(definitions.toString());

      transform.addOutput(new Asset.fromString(transform.primaryInput.id, JSON.encode(definitions)));
    }
  }
}