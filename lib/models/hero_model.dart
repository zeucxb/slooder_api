import 'package:slooder/slooder.dart';

class Hero extends ManagedObject<_Hero> implements _Hero {}

class _Hero {
  @primaryKey
  int id;

  @Column(unique: true)
  String name;
}
