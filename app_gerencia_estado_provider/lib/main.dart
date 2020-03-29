import 'package:app_gerencia_estado_provider/heroes_controller.dart';
import 'package:app_gerencia_estado_provider/heroes_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HeroesController>.value(
            value: HeroesController()),
      ],
      child: Consumer<HeroesController>(
        builder: (context, heroesController, widget) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MyApp(),
            theme: !heroesController.config ? ThemeData() : ThemeData.dark(),
          );
        },
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _buildItems(HeroModel model) {
    var heroesController = Provider.of<HeroesController>(context);
    return ListTile(
      onTap: () {
        heroesController.checkFavorite(model);
      },
      title: Text(model.nome),
      trailing: model.isFavorite ? Icon(Icons.star) : Icon(Icons.star_border),
    );
  }

  _buildList(HeroesController heroesController) {
    return ListView.builder(
      itemCount: heroesController.heroes.length,
      itemBuilder: (context, index) {
        return _buildItems(heroesController.heroes[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var heroesController = Provider.of<HeroesController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Provider"),
        actions: <Widget>[
          Switch(
              value: heroesController.config,
              onChanged: (value) {
                heroesController.config = !heroesController.config;
                heroesController.notifyListeners();
              }),
        ],
      ),
      body: Consumer<HeroesController>(
        builder: (context, heroesController, widget) {
          return _buildList(heroesController);
        },
      ),
    );
  }
}
