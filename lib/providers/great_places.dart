import 'package:flutter/foundation.dart';
import 'dart:io';

import '../models/place.dart';

import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: null,
      image: image,
    );

    _items.add(newPlace);

    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    // transform returned query data into maps thens to list
    _items = dataList
        .map(
          (item) => Place(
                id: item['id'],
                title: item['title'],
                image: File(item['image']),
                location: null,
              ),
        )
        .toList();
    notifyListeners();
  }
}
