import 'package:slooder/slooder.dart';
import 'package:slooder/models/hero_model.dart';

class HeroController extends ResourceController {
  HeroController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllHeroes({@Bind.query('name') String name}) async {
    final heroQuery = Query<Hero>(context);

    if (name != null) {
      heroQuery.where((hero) => hero.name).contains(name, caseSensitive: false);
    }

    final heroes = await heroQuery.fetch();

    return Response.ok(heroes);
  }

  @Operation.get('id')
  Future<Response> getHeroByID(@Bind.path('id') int id) async {
    final heroQuery = Query<Hero>(context)
      ..where((hero) => hero.id).equalTo(id);
    final hero = await heroQuery.fetchOne();

    if (hero == null) {
      return Response.notFound(body: {});
    }

    return Response.ok(hero);
  }

  @Operation.post()
  Future<Response> createHero(@Bind.body(ignore: ['id']) Hero inputHero) async {
    final query = Query<Hero>(context)..values = inputHero;

    final insertedHero = await query.insert();

    return Response.ok(insertedHero);
  }
}
