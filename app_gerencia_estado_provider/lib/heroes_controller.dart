import 'package:flutter/foundation.dart';

import 'heroes_model.dart';

class HeroesController extends ChangeNotifier {
  List<HeroModel> heroes = [
    HeroModel(nome: "Thor"),
    HeroModel(nome: "Iron man"),
    HeroModel(nome: "Batman"),
    HeroModel(nome: "Captain America"),
    HeroModel(nome: "Super man"),
  ];

  bool config = false;

  checkFavorite(HeroModel model) {
    model.isFavorite = !model.isFavorite;
    notifyListeners();
  }
}
