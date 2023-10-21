import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:duckdb_dart/duckdb_dart.dart' as ddb;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

const _libName = 'duckdb';
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

class _MyAppState extends State<MyApp> {
  late int sumResult;
  late Future<int> sumAsyncResult;

  /// The dynamic library in which the symbols for [DuckDbDartBindings] can be found.

  /// The bindings to the native functions in [_dylib].
  final ddb.DuckDbDartBindings _bindings = ddb.DuckDbDartBindings(_dylib);

  @override
  void initState() {
    super.initState();
    // Pointer<Pointer<NativeType>> _ptrToPtr = allocate();
// (Pointer<_duckdb_database> database; Pointer<Pointer<_duckdb_connection>> out_connection
// final db=ddb.duckdb_database.fromAddress(0);

// final dbPath=using((Arena arena) {
//   final p = arena<Char>();

// return 'eng'.toNativeUtf8().cast<Char>();
// });
    // final openDb = using((Arena arena) {
    //   final p = arena<Uint32>();
    //   return 'test'.toNativeUtf8().cast<Char>();
    // });

    Pointer<ddb.duckdb_database>.fromAddress(0);
    final Pointer<ddb.duckdb_database> outDbPtr = malloc<ddb.duckdb_database>();

// final Pointer<ddb.duckdb_database> outDbPtr = malloc<ddb.duckdb_database>()
//   ..ref = createStructFn();

    final db = 'test'.toNativeUtf8().cast<Char>();
    final openedDb = _bindings.duckdb_open(db, outDbPtr);
    // final connection = _bindings.duckdb_connect(db, Pointer);
    // sumResult = _bindings.duckdb_open(Pointer<Char>(), Pointer);
    // sumAsyncResult = duckdb_dart.sumAsync(3, 4);
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'sum(1, 2) = $sumResult',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                FutureBuilder<int>(
                  future: sumAsyncResult,
                  builder: (BuildContext context, AsyncSnapshot<int> value) {
                    final displayValue =
                        (value.hasData) ? value.data : 'loading';
                    return Text(
                      'await sumAsync(3, 4) = $displayValue',
                      style: textStyle,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
