// Turns a raw simulator recording of integration_test/store_video_test.dart
// into a store preview video:
//
//   dart run tool/store/compose_video.dart <iphone|ipad> <lang>
//
// Normally run by tool/store/video.sh. Reads build/store_video/raw/<device>/
// <lang>.{mp4,cues} and the captions from tool/store/video_captions_test.dart,
// and writes build/store_video/<device>/<lang>.mp4:
//
// - the footage, status bar cropped off, on the app's own navy background,
//   under a violet caption band whose captions fade in and out per scene;
// - a jump cut (cut_out → cut_in) with a short cross-fade;
// - the app's music and the sounds the app plays at each cue, at the app's
//   volumes, normalised to -16 LUFS;
// - App Store app preview spec: 15–30 s, 30 fps, H.264 High ≤ L4.0 at about
//   11 Mbps, stereo 256 kbps AAC at 48 kHz. Google Play takes the same file
//   via YouTube.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

/// Output canvas, caption band height (keep in sync with `_bands` in
/// tool/store/video_captions_test.dart) and how much of the recording to
/// crop off at the top (status bar) and bottom (home indicator), in
/// recording pixels.
const _devices = {
  'iphone': (width: 886, height: 1920, band: 290, cropTop: 170, cropBottom: 40),
  'ipad': (width: 1200, height: 1600, band: 210, cropTop: 80, cropBottom: 60),
};

const _navy = '0x0F172A';
const _crossFade = 0.4;
const _captionFade = 0.25;
const _musicVolume = 0.5;
const _targetLufs = -16.0;

Future<void> main(List<String> args) async {
  if (args.length != 2 || !_devices.containsKey(args[0])) {
    stderr.writeln('usage: compose_video.dart <iphone|ipad> <lang>');
    exit(64);
  }
  final device = args[0];
  final lang = args[1];
  final spec = _devices[device]!;
  final raw = 'build/store_video/raw/$device/$lang.mp4';
  final captions = 'build/store_video/captions/$device/$lang';
  final out = 'build/store_video/$device/$lang.mp4';
  Directory('build/store_video/$device').createSync(recursive: true);

  // Cues, in ms from the test's clock.
  final cues = <(int, String)>[
    for (final line in File(
      'build/store_video/raw/$device/$lang.cues',
    ).readAsLinesSync())
      if (RegExp(r'CUE:(\d+):(.+)$').firstMatch(line) case final m?)
        (int.parse(m[1]!), m[2]!.trim()),
  ];
  int at(String event) => cues.firstWhere((c) => c.$2 == event).$1;

  // The simulator only writes a frame when the screen changes, and the test
  // keeps it still until `sync`. The sync tap starts an animation, so it is
  // the first frame of a burst (the recorder can write a lone stray frame).
  final frames = LineSplitter.split(
    await _run('ffprobe', [
      '-v', 'error', '-select_streams', 'v', //
      '-show_entries', 'frame=pts_time', '-of', 'csv=p=0', raw,
    ]),
  ).map((l) => double.parse(l.replaceAll(',', ''))).toList();
  final dims = (await _run('ffprobe', [
    '-v', 'error', '-select_streams', 'v', //
    '-show_entries', 'stream=width,height', '-of', 'csv=p=0', raw,
  ])).trim().split(',').map(int.parse).toList();
  final burst = [
    for (int i = 1; i + 1 < frames.length; i++)
      if (frames[i + 1] - frames[i] < 0.1) i,
  ];
  final syncPts = frames[burst.first];
  final preRoll = (at('sync') - at('ready')) / 1000;
  if (syncPts < 1 || syncPts > preRoll + 0.5) {
    throw StateError(
      'sync frame at ${syncPts}s, expected within ${preRoll}s of the start: '
      'did something change on screen during the pre-roll?',
    );
  }
  double t(int ms) => syncPts + (ms - at('sync')) / 1000;

  final a0 = t(at('start')), a1 = t(at('cut_out'));
  final b0 = t(at('cut_in'));
  var b1 = t(at('end'));
  var duration = (a1 - a0) + (b1 - b0) - _crossFade;
  if (duration > 29.9) {
    stdout.writeln(
      'Trimming ${(duration - 29.9).toStringAsFixed(2)}s off '
      'the end to fit the 30 s App Store limit.',
    );
    b1 -= duration - 29.9;
    duration = 29.9;
  }
  if (duration < 15) throw StateError('video is only ${duration}s (min 15)');
  final bOffset = (a1 - a0) - _crossFade;

  /// Maps a cue to output time, or null if it falls in the cut.
  double? outTime(int ms) {
    final x = t(ms);
    if (x >= a0 && x <= a1) return x - a0;
    if (x >= b0 && x <= b1) return bOffset + (x - b0);
    return null;
  }

  // Footage: crop, scale to fit under the band, centre on navy.
  final srcW = dims[0], srcH = dims[1] - spec.cropTop - spec.cropBottom;
  final fitH = spec.height - spec.band;
  final scale = min(spec.width / srcW, fitH / srcH);
  final fw = (srcW * scale / 2).round() * 2,
      fh = (srcH * scale / 2).round() * 2;
  final inputs = <String>['-i', raw, '-i', 'assets/musics/solar_sail.mp3'];
  var inputCount = 2;
  final f = <String>[
    '[0:v]tpad=stop_mode=clone:stop_duration=5,fps=30,'
        'crop=$srcW:$srcH:0:${spec.cropTop},'
        'scale=$fw:$fh:flags=lanczos,'
        'pad=${spec.width}:${spec.height}:${(spec.width - fw) ~/ 2}:'
        '${spec.band + (fitH - fh) ~/ 2}:color=$_navy,setsar=1,split[va][vb]',
    '[va]trim=start=${_s(a0)}:end=${_s(a1)},setpts=PTS-STARTPTS[A]',
    '[vb]trim=start=${_s(b0)}:end=${_s(b1)},setpts=PTS-STARTPTS[B]',
    '[A][B]xfade=transition=fade:duration=$_crossFade:offset=${_s(bOffset)}'
        '[v0]',
  ];

  // Caption band over the top of the footage for the whole video.
  final bandInput = inputCount++;
  inputs.addAll([
    '-loop', '1', '-framerate', '30', '-t', _s(duration), //
    '-i', '$captions/../band.png',
  ]);
  f.add('[v0][$bandInput:v]overlay=0:0:eof_action=pass[vband]');

  // Captions: each scene's caption from its cue to the next scene (or end).
  final scenes = [
    for (final c in cues)
      if (c.$2.startsWith('scene:')) (c.$1, int.parse(c.$2.substring(6))),
  ];
  var v = 'vband';
  for (int k = 0; k < scenes.length; k++) {
    final start = outTime(scenes[k].$1)!;
    final end = k + 1 < scenes.length ? outTime(scenes[k + 1].$1)! : duration;
    final input = inputCount++;
    final len = end - start;
    inputs.addAll([
      '-loop', '1', '-framerate', '30', '-t', _s(len), //
      '-i', '$captions/${scenes[k].$2}.png',
    ]);
    f.add(
      '[$input:v]format=rgba,'
      'fade=t=in:st=0:d=$_captionFade:alpha=1,'
      'fade=t=out:st=${_s(len - _captionFade)}:d=$_captionFade:alpha=1,'
      'setpts=PTS-STARTPTS+${_s(start)}/TB[c$k]',
    );
    f.add('[$v][c$k]overlay=0:0:eof_action=pass[v${k + 1}]');
    v = 'v${k + 1}';
  }
  f.add(
    '[$v]fade=t=in:st=0:d=0.35:color=$_navy,'
    'fade=t=out:st=${_s(duration - 0.6)}:d=0.6:color=$_navy,'
    'format=yuv420p[vout]',
  );

  // Audio: music bed plus the app's sounds at the cue times.
  final sfx = <(double, String, double)>[
    for (final c in cues)
      if (c.$2.startsWith('sfx:'))
        if (outTime(c.$1) case final x?)
          (x, c.$2.split(':')[1], double.parse(c.$2.split(':')[2])),
  ];
  final assets = {for (final s in sfx) s.$2};
  final mix = <String>[];
  f.add(
    '[1:a]atrim=0:${_s(duration)},volume=$_musicVolume,'
    'afade=t=in:st=0:d=0.5,afade=t=out:st=${_s(duration - 1.2)}:d=1.2[music]',
  );
  mix.add('[music]');
  for (final asset in assets) {
    final input = inputCount++;
    inputs.addAll(['-i', 'assets/$asset']);
    final uses = sfx.where((s) => s.$2 == asset).toList();
    final name = asset.split('/').last.split('.').first;
    f.add(
      '[$input:a]asplit=${uses.length}'
      '${[for (int i = 0; i < uses.length; i++) '[${name}_$i]'].join()}',
    );
    for (int i = 0; i < uses.length; i++) {
      final ms = (uses[i].$1 * 1000).round();
      f.add('[${name}_$i]adelay=$ms|$ms,volume=${uses[i].$3}[${name}_d$i]');
      mix.add('[${name}_d$i]');
    }
  }
  f.add(
    '${mix.join()}amix=inputs=${mix.length}:normalize=0:duration=first,'
    'aformat=sample_rates=48000:channel_layouts=stereo,'
    'alimiter=limit=0.9[aout]',
  );

  final tmp =
      '${Directory.systemTemp.path}/sudoku-sagax-video-$device-$lang.mp4';
  stdout.writeln('Composing $out (${duration.toStringAsFixed(1)} s)');
  await _run('ffmpeg', [
    '-v', 'error', '-y', ...inputs, //
    '-filter_complex', f.join(';'),
    '-map', '[vout]', '-map', '[aout]',
    '-t', _s(duration),
    '-c:v', 'libx264', '-preset', 'slow', '-profile:v', 'high',
    '-level:v', '4.0', '-pix_fmt', 'yuv420p', '-r', '30',
    '-b:v', '11M', '-maxrate', '12M', '-bufsize', '24M',
    '-c:a', 'aac', '-b:a', '256k', '-ar', '48000', '-ac', '2',
    '-movflags', '+faststart', tmp,
  ]);

  // Normalise loudness: measure, then apply one fixed gain to the audio.
  final measured = await _run('ffmpeg', [
    '-hide_banner', '-nostats', '-i', tmp, //
    '-af', 'ebur128', '-f', 'null', '-',
  ], stderrToo: true);
  final lufs = double.parse(
    RegExp(r'Integrated loudness:\s+I:\s+(-?[\d.]+) LUFS')
        .allMatches(measured)
        .last[1]!,
  );
  final gain = _targetLufs - lufs;
  await _run('ffmpeg', [
    '-v', 'error', '-y', '-i', tmp, //
    '-map', '0', '-c:v', 'copy',
    '-af', 'volume=${gain.toStringAsFixed(2)}dB,alimiter=limit=0.89',
    '-c:a', 'aac', '-b:a', '256k', '-ar', '48000', '-ac', '2',
    '-movflags', '+faststart', out,
  ]);
  File(tmp).deleteSync();
  stdout.writeln(
    '  -> $out (${spec.width}×${spec.height}, '
    '${duration.toStringAsFixed(1)} s, audio ${lufs.toStringAsFixed(1)} → '
    '$_targetLufs LUFS)',
  );
}

String _s(double seconds) => seconds.toStringAsFixed(3);

Future<String> _run(
  String cmd,
  List<String> args, {
  bool stderrToo = false,
}) async {
  final r = await Process.run(cmd, args);
  if (r.exitCode != 0) {
    throw ProcessException(cmd, args, '${r.stderr}', r.exitCode);
  }
  return stderrToo ? '${r.stdout}${r.stderr}' : '${r.stdout}';
}
