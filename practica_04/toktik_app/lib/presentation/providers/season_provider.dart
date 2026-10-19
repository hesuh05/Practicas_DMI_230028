import 'package:flutter/foundation.dart';
import 'package:toktik/config/theme/app_theme.dart';
import 'package:toktik/domain/datasources/video_post_local_store.dart';

class SeasonProvider extends ChangeNotifier {
  SeasonProvider({required this.localStore});

  final VideoPostLocalStore localStore;
  AppSeason? _seasonOverride;
  DateTime? _forcedDate;
  HalloweenSongChoice _halloweenSongChoice = HalloweenSongChoice.original;

  AppSeason get season =>
      _seasonOverride ?? AppTheme.seasonForDate(_forcedDate ?? DateTime.now());
  AppSeason? get seasonOverride => _seasonOverride;
  DateTime? get forcedDate => _forcedDate;
  HalloweenSongChoice get halloweenSongChoice => _halloweenSongChoice;

  Future<void> load() async {
    final preferences = await localStore.getSeasonPreferences();
    final seasonOverride = _seasonFromName(preferences.seasonOverride);
    if (preferences.seasonOverride != null && seasonOverride == null) {
      throw FormatException(
        'Stored season override is invalid: ${preferences.seasonOverride}',
      );
    }
    _seasonOverride = seasonOverride;
    _forcedDate = preferences.forcedDate;
    _halloweenSongChoice = preferences.halloweenSongChoice;
    notifyListeners();
  }

  Future<void> selectSeason(AppSeason? season) async {
    final updated = SeasonPreferences(
      seasonOverride: season?.name,
      forcedDate: _forcedDate,
      halloweenSongChoice: _halloweenSongChoice,
    );
    await localStore.saveSeasonPreferences(updated);
    _seasonOverride = season;
    notifyListeners();
  }

  Future<void> selectDate(DateTime? date) async {
    final updated = SeasonPreferences(
      seasonOverride: _seasonOverride?.name,
      forcedDate: date == null
          ? null
          : DateTime(date.year, date.month, date.day),
      halloweenSongChoice: _halloweenSongChoice,
    );
    await localStore.saveSeasonPreferences(updated);
    _forcedDate = updated.forcedDate;
    notifyListeners();
  }

  Future<void> selectHalloweenSong(HalloweenSongChoice choice) async {
    final updated = SeasonPreferences(
      seasonOverride: _seasonOverride?.name,
      forcedDate: _forcedDate,
      halloweenSongChoice: choice,
    );
    await localStore.saveSeasonPreferences(updated);
    _halloweenSongChoice = choice;
    notifyListeners();
  }

  Future<void> reset() async {
    await localStore.saveSeasonPreferences(const SeasonPreferences());
    _seasonOverride = null;
    _forcedDate = null;
    _halloweenSongChoice = HalloweenSongChoice.original;
    notifyListeners();
  }

  AppSeason? _seasonFromName(String? name) {
    if (name == null) return null;
    for (final season in AppSeason.values) {
      if (season.name == name) return season;
    }
    return null;
  }
}
