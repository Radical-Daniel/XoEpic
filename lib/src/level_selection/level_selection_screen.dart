// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:game_template/src/style/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';
import '../style/responsive_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Select Mode',
                  style:
                      TextStyle(fontFamily: 'Permanent Marker', fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      "2 Player",
                      style: OPTION_STYLE,
                    ),
                    onTap: () {
                      GoRouter.of(context).go('/play/two');
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Against Computer",
                      style: OPTION_STYLE,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Tutorial",
                      style: OPTION_STYLE,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        rectangularMenuArea: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(palette.backgroundMain)),
          onPressed: () {
            GoRouter.of(context).pop();
          },
          child: const Text('Back'),
        ),
      ),
    );
  }
}
