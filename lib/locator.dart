import 'package:clean_architecture_sample/locator.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final locator = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Initialize SQL Database
  final database = await openDatabase(
    join(await getDatabasesPath(), 'posts_database.db'),
    onCreate: (db, version) {
      return db.execute("CREATE TABLE posts(id INTEGER PRIMARY KEY, title TEXT, body TEXT)");
    },
    version: 1,
  );

  locator.registerSingleton<Database>(database);
  locator.init(); // This calls the generated code
}