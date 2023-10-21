import 'dart:ffi';

// import 'package:duckdb_dart/duckdb_dart.dart';
import 'package:ffi/ffi.dart';
import 'package:spec/spec.dart';
import 'package:duckdb_dart/duckdb_dart.dart' as ddb;

typedef DuckDBCnnection = void Function();

void main() {
  late final ddb.DuckDbDartBindings bindings;
  setUpAll(() {
    bindings = ddb.DuckDbDartBindings(
        DynamicLibrary.open('./assets/osx/libduckdb.dylib'));
    // bindings = ddb.DuckDbDartBindings(ddb.openLibrary());
  });

  test('opening from dynamic library', () {
    final Pointer<ddb.duckdb_database> outDbPtr = malloc<ddb.duckdb_database>();

    final db = 'test'.toNativeUtf8().cast<Char>();
    final dbPtr = malloc<ddb.duckdb_database>();
    final conn = malloc<ddb.duckdb_connection>();
    final res1 = malloc<ddb.duckdb_result>();
    try {
      final openedDb = bindings.duckdb_open(db, outDbPtr);
      expect(openedDb).toBe(1);

      bindings.duckdb_connect(dbPtr.value, conn);

      bindings.duckdb_query(
          conn.value,
          "CREATE TABLE integers(i INTEGER, j INTEGER);"
              .toNativeUtf8()
              .cast<Char>(),
          res1);
      print(res1.ref);
    } catch (e) {
      print(e);
    } finally {
      bindings.duckdb_disconnect(conn);
      bindings.duckdb_close(outDbPtr);
    }
  });

  /* test('query from arrow', () {
    final Pointer<ddb.duckdb_database> dbPtr = malloc<ddb.duckdb_database>();
    Pointer<ddb.duckdb_connection> conn = malloc<ddb.duckdb_connection>();
    try {
      // final connection = using<ddb.duckdb_connection>((Arena arena) {
      //   final p = arena<Uint32>();
      //   // return ();
      // });
      // Void Function();
      Pointer<ddb.duckdb_arrow> result = malloc<ddb.duckdb_arrow>();

      // final db = 'test'.toNativeUtf8().cast<Char>();

      final db = 'test'.toNativeUtf8().cast<Char>();

      final openedDb = bindings.duckdb_open(db, dbPtr);
      bindings.duckdb_connect(dbPtr.value, conn);
      expect(openedDb).toBe(1);

      final query = """
CREATE TABLE recipes AS SELECT * 
FROM './fixtures/export.parquet';
""";

      final state = bindings.duckdb_query(
          conn.value,
          "CREATE TABLE integers(i INTEGER, j INTEGER);"
              .toNativeUtf8()
              .cast<Char>(),
          nullptr);
      final state1 = bindings.duckdb_query(
          conn.value,
          "INSERT INTO integers VALUES (3, 4), (5, 6), (7, NULL);"
              .toNativeUtf8()
              .cast<Char>(),
          nullptr);

      Pointer<ddb.duckdb_result> res = malloc<ddb.duckdb_result>();

      final state2 = bindings.duckdb_query(conn.value,
          "SELECT * FROM integers".toNativeUtf8().cast<Char>(), res);
      // final openedDb = bindings.duckdb_query_arrow(
      //     nullptr, query.toNativeUtf8().cast(), result);
      // final openedDb = bindings.duckdb_arrow_scan(db, outDbPtr);
      // final openedDb = bindings.duckdb_arrow_row_count(db, outDbPtr);
      print(result.value.toString());
      // expect(openedDb).toBe(1);

      // expect(result).toBe(1);
    } catch (e) {
      print(e);
    } finally {
      bindings.duckdb_disconnect(conn);
      bindings.duckdb_close(dbPtr);
    }
  });
 */
  tearDownAll(() {});
}
