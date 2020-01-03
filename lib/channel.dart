import 'package:aqueduct/managed_auth.dart';
import 'package:slooder/controllers/register_controller.dart';
import 'package:slooder/models/user_model.dart';

import 'controllers/hero_controller.dart';

import 'slooder.dart';

class SlooderChannel extends ApplicationChannel {
  ManagedContext context;

  AuthServer authServer;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = HeroConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName,
    );

    context = ManagedContext(dataModel, persistentStore);

    final authStorage = ManagedAuthDelegate<User>(context);

    authServer = AuthServer(authStorage);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route('/auth/token').link(() => AuthController(authServer));

    router
        .route('/heroes/[:id]')
        .link(() => Authorizer.bearer(authServer))
        .link(() => HeroController(context));

    router
        .route('/register')
        .link(() => RegisterController(context, authServer));

    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    return router;
  }
}

class HeroConfig extends Configuration {
  HeroConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
