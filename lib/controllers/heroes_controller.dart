import 'package:get_it/get_it.dart';
import 'package:heroes/heroes.dart';
import 'package:mongo_dart/mongo_dart.dart';

class HeroesController extends ResourceController {
  HeroesController() {
    heroesCol = GetIt.I<Db>().collection("cities");
  }
  DbCollection heroesCol;

  @Operation.get()
  Future<Response> getAllHeroes() async {
    final heroes = await heroesCol.find().toList();
    return Response.ok(heroes);
  }

  @Operation.get('id')
  Future<Response> getHeroByID(@Bind.path('id') int id) async {
    final hero = heroesCol.findOne(where.eq("id", id));

    if (hero == null) {
      return Response.notFound();
    }

    return Response.ok(hero);
  }
}
