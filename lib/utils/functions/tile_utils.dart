import 'dart:math';
import 'package:eight_puzzle/utils/widgets/n_puzzle/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

class TileUtils {
  static Map<String, List<Image>> _cache = {};

  static Future<List<TileImage>> getTileImages({
    String imagePath,
    int dimensions,
    List<int> state,
  }) async {
    List<Image> snap = await _snap(dimensions, imagePath);
    return List.generate(
      dimensions * dimensions,
      (index) => TileImage(snap[index], state[index]),
    );
  }

  static Future<List<Image>> _snap(int dimensions, String imagePath) async {
    String key = "$imagePath#$dimensions";
    if (_cache.containsKey(key)) {
      return _cache[key];
    } else {
      var data = await rootBundle.load('assets/$imagePath.jpg');
      var pngBytes = data.buffer.asUint8List();
      List<Image> images = _splitImage(pngBytes, dimensions);
      _cache.putIfAbsent(key, () => images);
      return images;
    }
  }

  static List<Image> _splitImage(List<int> input, int dimensions) {
    // convert image to image from image package
    image.Image img = image.decodeImage(input);
    img = image.copyResizeCropSquare(
      img,
      217 * (pow(dimensions, 2) ~/ dimensions),
    );

    int x = 0, y = 0;
    int width = (img.width / dimensions).round();
    int height = (img.height / dimensions).round();

    // split image to parts
    List<image.Image> parts = [];
    for (int i = 0; i < dimensions; i++) {
      for (int j = 0; j < dimensions; j++) {
        parts.add(image.copyCrop(img, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    // convert image from image package to Image Widget to display
    List<Image> output = [];
    for (var img in parts) {
      output.add(Image.memory(image.encodeJpg(img)));
    }

    return output;
  }
}
