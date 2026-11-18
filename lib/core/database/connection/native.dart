import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Opens an on-device persistent SQLite database using Drift and sqlite3.
LazyDatabase openConnection({String dbName = 'nyumbasmart_ledger.sqlite'}) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, dbName));
    return NativeDatabase.createInBackground(file);
  });
}

/// Creates an isolated in-memory database for automated testing.
DatabaseConnection openInMemoryConnection() {
  return DatabaseConnection(NativeDatabase.memory());
}

