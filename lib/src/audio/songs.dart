// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

const Set<Song> songs = {
  // Filenames with whitespace break package:audioplayers on iOS
  // (as of February 2022), so we use no whitespace.
  Song('ctw.mp3', 'Hazel', artist: 'Plush Animals'),
  Song('an2rd.mp3', 'Teal', artist: 'Plush Animals'),
  Song('idele.mp3', 'Bright', artist: 'Plush Animals'),
  Song('fall_out.mp3', 'Fall Out', artist: 'Plush Animals'),
};

class Song {
  final String filename;

  final String name;

  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() => 'Song<$filename>';
}
