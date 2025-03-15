import 'dart:developer';
import 'dart:typed_data'; // For AesCipher key
import 'package:hive_flutter/hive_flutter.dart';

/// A comprehensive and optimized Hive database service.
///
/// Enhanced Features:
/// - Optional encryption with AES cipher.
/// - Support for lazy and regular boxes with configurable caching.
/// - Batch operations (putAll/deleteAll) with transaction-like safety.
/// - Real-time change watching with flexible streams.
/// - Advanced error handling with custom callbacks.
/// - Backup/restore capabilities.
/// - Improved performance with optional preloading.
///
/// Usage example:
/// ```dart
/// await HiveDatabaseService.instance.init(encryptionKey: [1, 2, 3]);
/// await HiveDatabaseService.instance.putData('users', 'user1', User(name: 'Alice'));
/// ```
class HiveDatabaseService {
  // Singleton pattern
  HiveDatabaseService._privateConstructor();
  static final HiveDatabaseService instance =
      HiveDatabaseService._privateConstructor();

  // Optional configuration for advanced usage
  final Map<String, dynamic> _config = {
    'preloadOnOpen': false, // Whether to preload all data when opening a box
    'maxCacheSize': 100, // Max number of items to cache for lazy boxes
    'errorCallback': null, // Custom error handling callback
  };

  //////////////////////////////////////////////////////////////////////////////
  //                               INIT HIVE
  //////////////////////////////////////////////////////////////////////////////

  /// Initializes Hive with optional configurations.
  ///
  /// * [path]: Custom directory for Hive data (defaults to app directory).
  /// * [encryptionKey]: Optional AES encryption key (32 bytes recommended).
  /// * [useHiveFlutter]: Use Flutter-specific initialization (default: true).
  /// * [config]: Optional map to override default configurations.
  static Future<void> init({
    String? path,
    List<int>? encryptionKey,
    bool useHiveFlutter = true,
    Map<String, dynamic>? config,
  }) async {
    final service = HiveDatabaseService.instance;
    if (config != null) {
      service._config.addAll(config);
    }

    if (useHiveFlutter) {
      await Hive.initFlutter(path);
    } else {
      Hive.init(path ?? './hive_data');
    }

    // Validate encryption key length if provided
    if (encryptionKey != null && encryptionKey.length != 32) {
      service._logWarning(
        'Encryption key should be 32 bytes for AES. Provided: ${encryptionKey.length} bytes.',
      );
    }
  }

  /// Registers a custom adapter for type [T] if not already registered.
  static void registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //                           PRIVATE HELPERS
  //////////////////////////////////////////////////////////////////////////////

  /// Opens a box if not already open, with caching and preload options.
  Future<BoxBase<T>> _openBoxIfNeeded<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool preload = false,
  }) async {
    if (Hive.isBoxOpen(boxName)) {
      return lazy ? Hive.lazyBox<T>(boxName) : Hive.box<T>(boxName);
    }

    final cipher = encryptionKey != null
        ? HiveAesCipher(Uint8List.fromList(encryptionKey))
        : null;

    if (lazy) {
      final lazyBox = await Hive.openLazyBox<T>(
        boxName,
        encryptionCipher: cipher,
      );
      if (preload && _config['preloadOnOpen']) {
        await _preloadLazyBox(lazyBox);
      }
      return lazyBox;
    } else {
      final box = await Hive.openBox<T>(
        boxName,
        encryptionCipher: cipher,
      );
      if (preload && _config['preloadOnOpen']) {
        box.values; // Trigger preload
      }
      return box;
    }
  }

  /// Preloads a lazy box up to [maxCacheSize] items for better performance.
  Future<void> _preloadLazyBox<T>(LazyBox<T> box) async {
    final keys = box.keys.take(_config['maxCacheSize'] as int);
    for (final key in keys) {
      await box.get(key); // Load into memory
    }
  }

  /// Closes a box if open.
  Future<void> _closeBoxIfOpen(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// Logs warnings or errors with an optional custom callback.
  void _logWarning(String message, {Object? error}) {
    log(
      message,
      name: 'HiveDatabaseService',
      error: error,
      stackTrace: StackTrace.current,
    );
    final callback = _config['errorCallback'] as Function(String, Object?)?;
    callback?.call(message, error);
  }

  //////////////////////////////////////////////////////////////////////////////
  //                           PUBLIC API METHODS
  //////////////////////////////////////////////////////////////////////////////

  /// Stores a single key-value pair.
  Future<void> putData<T>(
    String boxName,
    String key,
    T value, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      await box.put(key, value);
      if (closeBoxAfterOperation) await _closeBoxIfOpen(boxName);
    } catch (e) {
      _handleError('Failed to put data', e);
      rethrow;
    }
  }

  /// Stores multiple key-value pairs in a batch.
  Future<void> putAllData<T>(
    String boxName,
    Map<String, T> dataMap, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      await box.putAll(dataMap);
      if (closeBoxAfterOperation) await _closeBoxIfOpen(boxName);
    } catch (e) {
      _handleError('Failed to put all data', e);
      rethrow;
    }
  }

  /// Retrieves a value by key.
  Future<T?> getData<T>(
    String boxName,
    String key, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      T? value;
      if (box is LazyBox<T>) {
        value = await (box).get(key); // LazyBox için await ile get
      } else if (box is Box<T>) {
        value = (box).get(key); // Normal Box için direkt get
      }
      if (closeBoxAfterOperation) await _closeBoxIfOpen(boxName);
      return value;
    } catch (e) {
      _handleError('Failed to get data', e);
      return null;
    }
  }

  /// Retrieves all values from a box.
  Future<List<T>> getAllData<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      final List<T> dataList = [];
      if (box is LazyBox<T>) {
        for (final key in box.keys) {
          final item = await box.get(key);
          if (item != null) dataList.add(item);
        }
      } else {
        dataList.addAll((box as Box<T>).values);
      }
      if (closeBoxAfterOperation) await _closeBoxIfOpen(boxName);
      return dataList;
    } catch (e) {
      _handleError('Failed to get all data', e);
      return [];
    }
  }

  /// Checks if a key exists in the box.
  Future<bool> containsKey<T>(
    String boxName,
    String key, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      final result = box.containsKey(key);
      if (closeBoxAfterOperation) await _closeBoxIfOpen(boxName);
      return result;
    } catch (e) {
      _handleError('Failed to check key', e);
      return false;
    }
  }

  /// Returns the number of items in the box.
  Future<int> getBoxLength<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      final length = box.length;
      if (closeBoxAfterOperation) await _closeBoxIfOpen(boxName);
      return length;
    } catch (e) {
      _handleError('Failed to get box length', e);
      return 0;
    }
  }

  /// Deletes a single key-value pair.
  Future<void> deleteData<T>(
    String boxName,
    String key, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      await box.delete(key);
      if (closeBoxAfterOperation) await _closeBoxIfOpen(boxName);
    } catch (e) {
      _handleError('Failed to delete data', e);
      rethrow;
    }
  }

  /// Deletes multiple keys in a batch.
  Future<void> deleteAll<T>(
    String boxName,
    Iterable<dynamic> keys, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      await box.deleteAll(keys);
      if (closeBoxAfterOperation) await _closeBoxIfOpen(boxName);
    } catch (e) {
      _handleError('Failed to delete all data', e);
      rethrow;
    }
  }

  /// Clears all data in the box.
  Future<void> clearBox<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool closeBoxAfterOperation = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      await box.clear();
      if (closeBoxAfterOperation) await _closeBoxIfOpen(boxName);
    } catch (e) {
      _handleError('Failed to clear box', e);
      rethrow;
    }
  }

  /// Closes a specific box.
  Future<void> closeBox<T>(String boxName) async {
    await _closeBoxIfOpen(boxName);
  }

  /// Closes all open boxes.
  Future<void> closeAllBoxes() async {
    await Hive.close();
  }

  //////////////////////////////////////////////////////////////////////////////
  //                              WATCH CHANGES
  //////////////////////////////////////////////////////////////////////////////

  /// Watches for changes in the box and streams [BoxEvent]s.
  Stream<BoxEvent> watchBox<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async* {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      yield* box.watch();
    } catch (e) {
      _handleError('Failed to watch box', e);
      rethrow;
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //                           BACKUP & RESTORE
  //////////////////////////////////////////////////////////////////////////////

  /// Exports the box data to a Map for backup purposes.
  Future<Map<String, T>> exportBox<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      final Map<String, T> backup = {};
      if (box is LazyBox<T>) {
        for (final key in box.keys) {
          final value = await box.get(key);
          if (value != null) backup[key] = value;
        }
      } else {
        backup.addAll((box as Box<T>).toMap().cast<String, T>());
      }
      return backup;
    } catch (e) {
      _handleError('Failed to export box', e);
      return {};
    }
  }

  /// Restores box data from a Map.
  Future<void> restoreBox<T>(
    String boxName,
    Map<String, T> data, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool clearBeforeRestore = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      if (clearBeforeRestore) await box.clear();
      await box.putAll(data);
    } catch (e) {
      _handleError('Failed to restore box', e);
      rethrow;
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  //                         ERROR HANDLING
  //////////////////////////////////////////////////////////////////////////////

  /// Centralized error handling with custom callback support.
  void _handleError(String message, Object error) {
    _logWarning('Hive Error: $message', error: error);
    if (error is HiveError) {
      // Optionally rethrow or handle specific Hive errors
    }
  }
}
