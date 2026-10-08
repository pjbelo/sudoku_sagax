import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'settings_service.dart';

/// Centralised audio: one looping background-music player and one
/// low-latency sound-effect player, shared by every screen.
///
/// Playback is gated on the Sound option and on the device's silent mode.
/// iOS:   AVAudioSessionCategory.ambient automatically silences audio when
///        the ringer/mute switch is flipped — no extra detection needed.
/// Android: ringer mode is polled via a MethodChannel; [isSilent] is true
///          only when the device is in full-silent mode (not just vibrate).
class AudioService with WidgetsBindingObserver {
  AudioService._();
  static final instance = AudioService._();

  static const _channel = MethodChannel('com.tekinsight.sudokusagax/ringer');

  static const buttonSfx = 'sounds/click_button.mp3';
  static const digitSfx = 'sounds/click_tile.mp3';
  static const levelSelectSfx = 'sounds/phaserUp5.mp3';
  static const hintSfx = 'sounds/phaserUp7.mp3';
  static const wrongSfx = 'sounds/lost_life.mp3';
  static const levelUpSfx = 'sounds/new_level.mp3';
  static const winSfx = 'sounds/win_play.mp3';
  static const _musicAsset = 'musics/solar_sail.mp3';

  // Shared AudioContext for every player in the app.
  // iOS ambient category mixes with other apps and respects the mute switch.
  // (`mixWithOthers` is implicit for `ambient` and must NOT be set explicitly —
  // audioplayers only allows that option for playback/playAndRecord/multiRoute.)
  // Android uses standard media focus without interrupting other audio.
  static AudioContext get audioContext => AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.ambient,
      options: const {},
    ),
    android: AudioContextAndroid(
      isSpeakerphoneOn: false,
      stayAwake: false,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
      audioFocus: AndroidAudioFocus.gain,
    ),
  );

  // Created in [init]; while null (e.g. in tests) every call is a no-op.
  AudioPlayer? _musicPlayer;
  AudioPlayer? _sfxPlayer;

  bool _isSilent = false;
  bool get isSilent => _isSilent;

  /// Whether some screen asked for background music.
  bool _musicWanted = false;
  bool _musicPlaying = false;

  bool get _canPlay => SettingsService.instance.sound && !_isSilent;

  /// Call once in `main()` before `runApp`.
  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    await AudioPlayer.global.setAudioContext(audioContext);
    final music = AudioPlayer();
    final sfx = AudioPlayer();
    await music.setAudioContext(audioContext);
    await sfx.setAudioContext(audioContext);
    await music.setReleaseMode(ReleaseMode.loop);
    await sfx.setReleaseMode(ReleaseMode.stop);
    await music.setPlayerMode(PlayerMode.mediaPlayer);
    await sfx.setPlayerMode(PlayerMode.lowLatency);
    _musicPlayer = music;
    _sfxPlayer = sfx;
    await updateSilentMode();
    SettingsService.instance.addListener(_onSettingsChanged);
  }

  /// Refreshes [isSilent] from the platform.
  Future<void> updateSilentMode() async {
    try {
      // Android: 0 = RINGER_MODE_SILENT, 1 = VIBRATE, 2 = NORMAL
      final mode = await _channel.invokeMethod<int>('getRingerMode');
      _isSilent = mode == 0;
    } on MissingPluginException {
      // iOS does not implement this channel — ambient category handles it.
      _isSilent = false;
    } catch (_) {
      _isSilent = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        if (_musicPlaying) unawaited(_musicPlayer?.pause());
      case AppLifecycleState.resumed:
        unawaited(_onAppResumed());
      default:
        break;
    }
  }

  Future<void> _onAppResumed() async {
    await updateSilentMode();
    await _syncMusic();
  }

  void _onSettingsChanged() => unawaited(_syncMusic());

  Future<void> playSfx(String asset, {double volume = 0.9}) async {
    final player = _sfxPlayer;
    if (player == null || !_canPlay) return;
    try {
      await player.stop();
      await player.play(AssetSource(asset), volume: volume);
    } catch (e) {
      log('Error playing $asset: $e');
    }
  }

  /// Starts the looping menu music (if sound is allowed).
  Future<void> startMusic() async {
    _musicWanted = true;
    await _syncMusic();
  }

  /// Plays or stops the music to match [_musicWanted] and [_canPlay].
  Future<void> _syncMusic() async {
    final player = _musicPlayer;
    if (player == null) return;
    try {
      if (_musicWanted && _canPlay) {
        if (_musicPlaying) {
          await player.resume();
        } else {
          await player.play(AssetSource(_musicAsset), volume: 0.28);
          _musicPlaying = true;
        }
      } else if (_musicPlaying) {
        await player.stop();
        _musicPlaying = false;
      }
    } catch (e) {
      log('Error playing background music: $e');
    }
  }
}
