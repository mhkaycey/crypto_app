import 'package:crypto_app/src/core/services/shared_preference_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences not initialized'),
);

final sharedPreferenceServiceProvider = Provider<SharedPreferenceService>((
  ref,
) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return SharedPreferenceService(sharedPreferences);
});
