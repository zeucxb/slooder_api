import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'controllers/heroes_controller.dart';

import 'heroes.dart';

class HeroesChannel extends ApplicationChannel {
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route('/heroes/[:id]').link(() => HeroesController());

    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    return router;
  }
}
