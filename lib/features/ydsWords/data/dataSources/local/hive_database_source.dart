import 'dart:developer';
import 'dart:typed_data'; // For AesCipher key
import 'package:hive_flutter/hive_flutter.dart';

/// A comprehensive service class for managing Hive operations.
///
/// Features:
/// 1. **Optional encryption** using [encryptionKey].
/// 2. **Lazy box** support (load values on demand).
/// 3. **Register custom adapters** for storing objects.
/// 4. **Batch operations** for putAll/deleteAll.
/// 5. **Change watching** through [watchBox].
/// 6. **Error handling** with optional logging or custom exceptions.
class HiveDatabaseService {
  // Singleton pattern
  HiveDatabaseService._privateConstructor();
  static final HiveDatabaseService instance =
      HiveDatabaseService._privateConstructor();

  //////////////////////////////////////////////////////////////////////////////
  //                               INIT HIVE
  //////////////////////////////////////////////////////////////////////////////

  /// Initializes Hive.
  ///
  /// * [path]: Directory path to store Hive data.
  ///   If not provided, Hive will use the default application directory.
  /// * [encryptionKey]: Optional key for AesCipher-based encryption.
  /// * [useHiveFlutter]: Whether to use [Hive.initFlutter] (true) or [Hive.init] (false).
  static Future<void> init({
    String? path,
    List<int>? encryptionKey,
    bool useHiveFlutter = true,
  }) async {
    if (useHiveFlutter) {
      // If using hive_flutter
      await Hive.initFlutter(path);
    } else {
      // Standard Hive initialization
      Hive.init(path ?? './hive_data');
    }
  }

  /// Registers a custom [adapter] to store objects of type T in Hive.
  /// Checks whether the adapter is already registered before doing so.
  static void registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //                           PRIVATE HELPERS
  //////////////////////////////////////////////////////////////////////////////

  /// Opens a box if it is not already open. Returns the box instance (Box or LazyBox).
  ///
  /// * [boxName]: Unique name of the box.
  /// * [encryptionKey]: If provided, creates a [HiveAesCipher] for encryption.
  /// * [lazy]: If true, opens a lazy box ([Hive.openLazyBox]), otherwise a normal box ([Hive.openBox]).
  ///
  /// Throws [HiveError] if something fails during box opening.
  Future<BoxBase<T>> _openBoxIfNeeded<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    // If the box is already open, just return it
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }

    final cipher = (encryptionKey != null)
        ? HiveAesCipher(Uint8List.fromList(encryptionKey))
        : null;

    // Open either a lazy box or a normal box
    if (lazy) {
      await Hive.openLazyBox<T>(
        boxName,
        encryptionCipher: cipher,
      );
      return Hive.lazyBox<T>(boxName);
    } else {
      await Hive.openBox<T>(
        boxName,
        encryptionCipher: cipher,
      );
      return Hive.box<T>(boxName);
    }
  }

  /// Closes the box if it is currently open.
  Future<void> _closeBoxIfOpen(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //                           PUBLIC API METHODS
  //////////////////////////////////////////////////////////////////////////////

  /// Writes (or updates) a single [key-value] in the specified [boxName].
  ///
  /// * [encryptionKey]: Used for opening an encrypted box if provided.
  /// * [lazy]: If true, opens a lazy box.
  /// * [closeBoxAfterOperation]: Whether to close the box immediately after writing.
  Future<void> putData<T>(
    String boxName,
    String key,
    T value, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    final box = await _openBoxIfNeeded<T>(
      boxName,
      encryptionKey: encryptionKey,
      lazy: lazy,
    );
    await box.put(key, value);

    if (closeBoxAfterOperation) {
      await _closeBoxIfOpen(boxName);
    }
  }

  /// Writes multiple [key-value] pairs in one operation.
  ///
  /// * [dataMap]: A map of key-value entries to be stored.
  /// * [encryptionKey], [lazy], [closeBoxAfterOperation]: See [putData].
  Future<void> putAllData<T>(
    String boxName,
    Map<String, T> dataMap, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    final box = await _openBoxIfNeeded<T>(
      boxName,
      encryptionKey: encryptionKey,
      lazy: lazy,
    );
    await box.putAll(dataMap);

    if (closeBoxAfterOperation) {
      await _closeBoxIfOpen(boxName);
    }
  }

  /// Retrieves a single value by its [key].
  ///
  /// * Returns `null` if the key is not found.
  /// * [encryptionKey], [lazy], [closeBoxAfterOperation]: See [putData].
  Future<T?> getData<T>(
    String boxName,
    String key, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    final box = await _openBoxIfNeeded<T>(
      boxName,
      encryptionKey: encryptionKey,
      lazy: lazy,
    );

    T? value;
    if (box is LazyBox<T>) {
      // LazyBox.get() is async
      value = await box.get(key);
    } else if (box is Box<T>) {
      value = box.get(key);
    }

    if (closeBoxAfterOperation) {
      await _closeBoxIfOpen(boxName);
    }
    return value;
  }

  /// Retrieves all values from the specified [boxName].
  ///
  /// * If [lazy] is true and the box is a LazyBox, each value is loaded individually (await each get).
  /// * Returns a list of all values found in the box.
  Future<List<T>> getAllData<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    final boxBase = await _openBoxIfNeeded<T>(
      boxName,
      encryptionKey: encryptionKey,
      lazy: lazy,
    );

    final List<T> dataList = [];
    if (boxBase is LazyBox<T>) {
      // Retrieve values on demand, async
      for (final key in boxBase.keys) {
        final item = await boxBase.get(key);
        if (item != null) dataList.add(item);
      }
    } else if (boxBase is Box<T>) {
      // Normal box
      dataList.addAll(boxBase.values);
    }

    if (closeBoxAfterOperation) {
      await _closeBoxIfOpen(boxName);
    }
    return dataList;
  }

  /// Checks whether the [boxName] contains the given [key].
  ///
  /// * Returns `true` if the key exists.
  Future<bool> containsKey<T>(
    String boxName,
    String key, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    final box = await _openBoxIfNeeded<T>(
      boxName,
      encryptionKey: encryptionKey,
      lazy: lazy,
    );
    final bool hasKey = box.containsKey(key);

    if (closeBoxAfterOperation) {
      await _closeBoxIfOpen(boxName);
    }
    return hasKey;
  }

  /// Returns the number of records in the [boxName].
  Future<int> getBoxLength<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    final box = await _openBoxIfNeeded<T>(
      boxName,
      encryptionKey: encryptionKey,
      lazy: lazy,
    );
    final length = box.length;

    if (closeBoxAfterOperation) {
      await _closeBoxIfOpen(boxName);
    }
    return length;
  }

  /// Deletes the value by its [key] in the specified [boxName].
  Future<void> deleteData<T>(
    String boxName,
    String key, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    final box = await _openBoxIfNeeded<T>(
      boxName,
      encryptionKey: encryptionKey,
      lazy: lazy,
    );
    await box.delete(key);

    if (closeBoxAfterOperation) {
      await _closeBoxIfOpen(boxName);
    }
  }

  /// Deletes multiple values by their [keys] in one operation.
  Future<void> deleteAll<T>(
    String boxName,
    Iterable<dynamic> keys, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    final box = await _openBoxIfNeeded<T>(
      boxName,
      encryptionKey: encryptionKey,
      lazy: lazy,
    );
    await box.deleteAll(keys);

    if (closeBoxAfterOperation) {
      await _closeBoxIfOpen(boxName);
    }
  }

  /// Clears (removes) all entries from the specified [boxName].
  Future<void> clearBox<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    final box = await _openBoxIfNeeded<T>(
      boxName,
      encryptionKey: encryptionKey,
      lazy: lazy,
    );
    await box.clear();

    if (closeBoxAfterOperation) {
      await _closeBoxIfOpen(boxName);
    }
  }

  /// Closes a specific box if it is open.
  Future<void> closeBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box<T>(boxName);
      await box.close();
    }
  }

  /// Closes all open boxes (useful on logout or app exit).
  Future<void> closeAllBoxes() async {
    await Hive.close();
  }

  //////////////////////////////////////////////////////////////////////////////
  //                              WATCH CHANGES
  //////////////////////////////////////////////////////////////////////////////

  /// Watches for changes (inserts, updates, deletes) in the specified [boxName].
  ///
  /// * Returns a `Stream<BoxEvent>`.
  /// * Note: Do NOT close the box if you intend to keep listening for changes.
  ///
  /// Example usage:
  /// ```dart
  /// final stream = HiveDatabaseService.instance.watchBox<MyModel>('myBox');
  /// stream.listen((event) {
  ///   // handle changes
  /// });
  /// ```
  Stream<BoxEvent> watchBox<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async* {
    final box = await _openBoxIfNeeded<T>(
      boxName,
      encryptionKey: encryptionKey,
      lazy: lazy,
    );
    // Both Box<T> and LazyBox<T> extend BoxBase<T>, which has watch()
    yield* box.watch();
  }

  //////////////////////////////////////////////////////////////////////////////
  //                         ERROR HANDLING (OPTIONAL)
  //////////////////////////////////////////////////////////////////////////////

  /// Simple function to handle or log Hive errors, which you can
  /// integrate into your try-catch blocks if desired.
  ///
  /// Example usage in a try-catch:
  /// ```dart
  /// try {
  ///   // Some Hive operation
  /// } on HiveError catch (e) {
  ///   HiveDatabaseService.instance.handleHiveError(e);
  /// }
  /// ```
  void handleHiveError(HiveError e) {
    log(
      "Hive Error: ${e.message}",
      name: "HiveError",
      error: e,
      stackTrace: StackTrace.current,
    );
    // If you want to throw a custom exception:
    // throw HiveExceptionCustom(e.message);
  }
}
