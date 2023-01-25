// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../games_services/grid.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../style/confetti.dart';
import '../style/palette.dart';

class TwoPlayerSessionScreen extends StatefulWidget {
  const TwoPlayerSessionScreen({super.key});

  @override
  State<TwoPlayerSessionScreen> createState() => _TwoPlayerSessionScreenState();
}

class _TwoPlayerSessionScreenState extends State<TwoPlayerSessionScreen> {
  static final _log = Logger('PlaySessionScreen');
  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;
  bool isActivated = false;
  bool isActivated1 = false;
  late DateTime _startOfPlay;
  bool isPlayer1Turn = true;

  @override
  Widget build(BuildContext context) {
    _duringCelebration = context.watch<GridData>().player2Win ||
        context.watch<GridData>().player1Win;
    final palette = context.watch<Palette>();
    MediaQueryData media = MediaQuery.of(context);
    // return MultiProvider(
    //   providers: [
    // ChangeNotifierProvider(
    //   create: (context) => LevelState(
    //     goal: widget.level.difficulty,
    //     onWin: _playerWon,
    //   ),
    // ),
    // ]
    // ),

    return IgnorePointer(
      ignoring: _duringCelebration,
      child: Scaffold(
        backgroundColor: palette.backgroundPlaySession,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: media.size.width * .7,
                height: media.size.height * .55,
                child: context.watch<GridData>().player1Win ||
                        context.watch<GridData>().player2Win
                    ? Center(
                        child: Text(
                            "Player ${context.watch<GridData>().player1Win ? 1 : 2} has won the game!!"),
                      )
                    : Stack(
                        children: [
                          CustomPaint(
                            painter: GridPainter(
                                context: context,
                                isPlayer1Turn: true,
                                path: context.read<GridData>().player1Path),
                          ),
                          CustomPaint(
                            painter: GridPainter(
                                isPlayer1Turn: false,
                                context: context,
                                path: context.read<GridData>().player2Path),
                          ),
                        ],
                      ),
              ),
            ),
            Center(
              // This is the entirety of the "game".
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkResponse(
                      onTap: () => GoRouter.of(context).push('/settings'),
                      child: Image.asset(
                        'assets/images/settings.png',
                        semanticLabel: 'Settings',
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      context.watch<GridData>().isPlayer1Turn
                          ? 'Player 1'
                          : 'Player 2',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Text(
                    'Reach the ${context.watch<GridData>().isPlayer1Turn ? 'bottom' : 'right'} side of the grid',
                  ),
                  SizedBox(
                    width: media.size.width * .7,
                    height: media.size.height * .55,
                    child: context.watch<GridData>().player1Win ||
                            context.watch<GridData>().player2Win
                        ? Center(
                            child: Text(
                                "Player ${context.watch<GridData>().player1Win ? 1 : 2} has won the game!!"),
                          )
                        : Grid(
                            rows:
                                context.watch<GridData>().nodeData.last.row + 1,
                            gridData: GridData(
                                isStartingPointSelection: context
                                    .watch<GridData>()
                                    .isStartingPointSelection,
                                nodeData: context.watch<GridData>().nodeData,
                                isPlayer1Turn:
                                    context.watch<GridData>().isPlayer1Turn,
                                player1Win:
                                    context.watch<GridData>().player1Win,
                                player2Win:
                                    context.watch<GridData>().player2Win,
                                player1Path:
                                    context.watch<GridData>().player1Path,
                                player2Path:
                                    context.watch<GridData>().player2Path),
                          ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => GoRouter.of(context).pop(),
                        child: const Text('Back'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox.expand(
              child: Visibility(
                visible: _duringCelebration,
                child: IgnorePointer(
                  child: Confetti(
                    isStopped: !_duringCelebration,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _startOfPlay = DateTime.now();

    // Preload ad for the win screen.
    final adsRemoved =
        context.read<InAppPurchaseController?>()?.adRemoval.active ?? false;
    if (!adsRemoved) {
      final adsController = context.read<AdsController?>();
      adsController?.preloadAd();
    }
  }

  // Future<void> _playerWon() async {
  //   _log.info('Level ${widget.level.number} won');
  //
  //   final score = Score(
  //     widget.level.number,
  //     widget.level.difficulty,
  //     DateTime.now().difference(_startOfPlay),
  //   );
  //
  //   final playerProgress = context.read<PlayerProgress>();
  //   playerProgress.setLevelReached(widget.level.number);
  //
  //   // Let the player see the game just after winning for a bit.
  //   await Future<void>.delayed(_preCelebrationDuration);
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _duringCelebration = true;
  //   });
  //
  //   final audioController = context.read<AudioController>();
  //   audioController.playSfx(SfxType.congrats);
  //
  //   final gamesServicesController = context.read<GamesServicesController?>();
  //   if (gamesServicesController != null) {
  //     // Award achievement.
  //     if (widget.level.awardsAchievement) {
  //       await gamesServicesController.awardAchievement(
  //         android: widget.level.achievementIdAndroid!,
  //         iOS: widget.level.achievementIdIOS!,
  //       );
  //     }
  //
  //     // Send score to leaderboard.
  //     await gamesServicesController.submitLeaderboardScore(score);
  //   }
  //
  //   /// Give the player some time to see the celebration animation.
  //   await Future<void>.delayed(_celebrationDuration);
  //   if (!mounted) return;
  //
  //   GoRouter.of(context).go('/play/won', extra: {'score': score});
  // }
}

class GridPainter extends CustomPainter {
  Palette _palette = Palette();

  BuildContext context;
  final List<Offset> path;
  final bool isPlayer1Turn;
  GridPainter(
      {required this.context, required this.path, required this.isPlayer1Turn});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = isPlayer1Turn ? _palette.darkPen : _palette.redPen;

    canvas.drawPoints(PointMode.lines, path, paint);
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return context.read<GridData>().isPlayer1Turn
        ? context.watch<GridData>().player1Path.length > oldDelegate.path.length
        : context.watch<GridData>().player2Path.length >
            oldDelegate.path.length;
  }
}
