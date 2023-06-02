import 'package:flutter/material.dart';
import 'package:game_template/src/style/constants.dart';
import 'package:provider/provider.dart';

class Grid extends StatefulWidget {
  final GridData gridData;
  final int rows;
  const Grid({
    super.key,
    required this.gridData,
    required this.rows,
  });

  static GridData nodeMapConstructor(int minColNum) {
    int numOfRows = minColNum + minColNum + 1;
    List<Node> createdList = [];
    int uID = 0;
    int rowCount = 0;
    for (int i = 0; i < numOfRows; i++) {
      bool isForPlayer1 = i.isEven;
      if (isForPlayer1) {
        for (int c = 0; c < minColNum; c++) {
          createdList.add(Node(
              uID: uID,
              row: rowCount,
              column: c,
              isHighlighted: false,
              isForPlayer1: isForPlayer1,
              connectedTo: [],
              checked: false));
          uID++;
        }
        rowCount++;
      } else {
        for (int c = 0; c < minColNum + 1; c++) {
          createdList.add(Node(
              row: rowCount,
              column: c,
              isHighlighted: false,
              uID: uID,
              isForPlayer1: isForPlayer1,
              connectedTo: [],
              checked: false));
          uID++;
        }
        rowCount++;
      }
      print(createdList.map((e) => e.row));
    }
    return GridData(
      isStartingPointSelection: true,
      nodeData: createdList,
      isPlayer1Turn: true,
      player1Win: false,
      player2Win: false,
      player1Path: [],
      player1NodePath: [],
      player2Path: [],
      player2NodePath: [],
      player1Lines: [],
      player2Lines: [],
    );
  }

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  final List<GlobalKey> _keys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  Offset? _getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset? position = box?.localToGlobal(Offset.zero);
    if (position == null) {
      return null;
    }
    return Offset(position.dx, position.dy);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.rows,
        itemBuilder: (context, count) {
          List<Widget> nodes = [];
          for (Node element in widget.gridData.nodeData
              .where((element) => element.row == count)) {
            nodes.add(IconButton(
                key: _keys[element.uID],
                onPressed: () {
                  List<int> allowedMoves(int uID) {
                    int player1RowLength() {
                      List<Node> list = [];
                      for (Node node in widget.gridData.nodeData) {
                        if (node.isForPlayer1) {
                          list.add(node);
                        } else {
                          return list.length;
                        }
                      }
                      return list.length;
                    }

                    bool elementOnLeft() {
                      if (uID == 0) {
                        return true;
                      }
                      if (widget.gridData.nodeData[uID - 1].isForPlayer1 !=
                          element.isForPlayer1) {
                        return true;
                      }
                      return false;
                    }

                    bool elementOnRight() {
                      if (uID == 0) {
                        return false;
                      }
                      if (uID == widget.gridData.nodeData.last.uID) {
                        return true;
                      }
                      if (widget.gridData.nodeData[uID + 1].isForPlayer1 !=
                          element.isForPlayer1) {
                        return true;
                      }
                      return false;
                    }

                    bool elementOnTopRow() {
                      if (uID <= (player1RowLength() * 2)) {
                        return true;
                      }
                      return false;
                    }

                    bool elementOnBottomRow() {
                      if (uID >=
                          widget.gridData.nodeData.last.uID -
                              (player1RowLength() * 2)) {
                        return true;
                      }
                      return false;
                    }

                    bool isBlockedRight() {
                      if (uID < player1RowLength()) {
                        return false;
                      }
                      if (!element.isForPlayer1 && elementOnRight()) {
                        return false;
                      }
                      if (widget.gridData.nodeData[uID - player1RowLength()]
                          .connectedTo
                          .contains((uID + player1RowLength()) + 1)) {
                        return true;
                      }
                      return false;
                    }

                    bool isBlockedLeft() {
                      if (uID < player1RowLength()) {
                        return false;
                      }
                      if (!element.isForPlayer1 && elementOnLeft()) {
                        return false;
                      }
                      if (widget.gridData.nodeData[uID - player1RowLength() - 1]
                          .connectedTo
                          .contains((uID + player1RowLength()))) {
                        return true;
                      }

                      return false;
                    }

                    bool isBlockedBelow() {
                      if (element.isForPlayer1 && elementOnBottomRow()) {
                        return false;
                      }
                      if (!element.isForPlayer1 && elementOnLeft()) {
                        return false;
                      }
                      if (widget.gridData.nodeData[uID + player1RowLength()]
                          .connectedTo
                          .contains((uID + player1RowLength() + 1))) {
                        return true;
                      }

                      return false;
                    }

                    bool isBlockedAbove() {
                      if (elementOnTopRow()) {
                        return false;
                      }
                      if (!element.isForPlayer1 && elementOnLeft()) {
                        return false;
                      }
                      if (!element.isForPlayer1 && elementOnRight()) {
                        return false;
                      }

                      if (widget.gridData.nodeData[uID - player1RowLength()]
                          .connectedTo
                          .contains((uID - player1RowLength() - 1))) {
                        return true;
                      }
                      return false;
                    }

                    List<int> moves = [];
                    if (elementOnLeft()) {
                      moves.add(uID + 1);
                    }
                    if (elementOnRight()) {
                      moves.add(uID - 1);
                    }
                    if (elementOnTopRow()) {
                      moves.add(uID + (player1RowLength() * 2 + 1));
                    }
                    if (elementOnBottomRow()) {
                      moves.add(uID - (player1RowLength() * 2 + 1));
                    }
                    if (!elementOnBottomRow() &&
                        !elementOnTopRow() &&
                        !elementOnRight() &&
                        !elementOnLeft()) {
                      moves.add(uID + 1);
                      moves.add(uID - 1);
                      moves.add(uID + (player1RowLength() * 2 + 1));
                      moves.add(uID - (player1RowLength() * 2 + 1));
                    }
                    if (!elementOnBottomRow() && !elementOnTopRow()) {
                      moves.add(uID + (player1RowLength() * 2 + 1));
                      moves.add(uID - (player1RowLength() * 2 + 1));
                    }
                    if (!elementOnLeft() && !elementOnRight()) {
                      moves.add(uID - 1);
                      moves.add(uID + 1);
                    }
                    if (isBlockedRight()) {
                      moves.removeWhere((element) => element == uID + 1);
                    }
                    if (isBlockedLeft()) {
                      moves.removeWhere((element) => element == uID - 1);
                    }
                    if (isBlockedBelow()) {
                      moves.removeWhere((element) =>
                          element == uID + (player1RowLength() * 2 + 1));
                    }
                    if (isBlockedAbove()) {
                      moves.removeWhere((element) =>
                          element == uID - (player1RowLength() * 2 + 1));
                    }
                    moves = moves.toSet().toList();
                    return moves;
                  }

                  if (widget.gridData.isPlayer1Turn == element.isForPlayer1) {
                    if (widget.gridData.isStartingPointSelection) {
                      element.isHighlighted = true;
                      widget.gridData.isStartingPointSelection = false;
                      context.read<GridData>().updateNodeData(widget.gridData);
                      return;
                    }
                    if (element.isHighlighted) {
                      element.isHighlighted = false;
                      widget.gridData.isStartingPointSelection = true;
                      context.read<GridData>().updateNodeData(widget.gridData);
                      return;
                    }
                    int startingPointID = widget.gridData.nodeData
                        .firstWhere((element) => element.isHighlighted)
                        .uID;
                    if (element.connectedTo
                        .any((element) => element == startingPointID)) {
                      return;
                    }
                    if (!allowedMoves(startingPointID).contains(element.uID)) {
                      return;
                    }

                    if (widget.gridData.isPlayer1Turn) {
                      widget.gridData.player1Path
                          .add(_getOffset(_keys[startingPointID])!);
                      widget.gridData.player1Path
                          .add(_getOffset(_keys[element.uID])!);
                      widget.gridData.player1NodePath
                          .add([startingPointID, element.uID]);
                    } else {
                      widget.gridData.player2Path
                          .add(_getOffset(_keys[startingPointID])!);
                      widget.gridData.player2Path
                          .add(_getOffset(_keys[element.uID])!);
                      widget.gridData.player2NodePath
                          .add([startingPointID, element.uID]);
                    }

                    element.connectedTo.add(startingPointID);
                    element.checked = true;
                    widget.gridData.nodeData[startingPointID].connectedTo
                        .add(element.uID);
                    widget.gridData.nodeData[startingPointID].isHighlighted =
                        false;
                    widget.gridData.nodeData[startingPointID].checked = true;
                    widget.gridData.isStartingPointSelection = true;
                    widget.gridData.isPlayer1Turn =
                        !widget.gridData.isPlayer1Turn;

                    context.read<GridData>().updateNodeData(widget.gridData);
                  }
                },
                icon: Icon(
                  element.isForPlayer1 ? Icons.close : Icons.circle_outlined,
                  color: ICON_COLORS(element),
                  size: 22,
                )));
          }
          return ListTile(
            title: Row(
              mainAxisAlignment: count.isOdd
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceEvenly,
              children: nodes,
            ),
          );
        });
  }
}

class Node {
  bool isForPlayer1;
  int row;
  int column;
  bool checked;
  bool isHighlighted;
  List<int> connectedTo = [];
  int uID;

  Node(
      {required this.checked,
      required this.row,
      required this.isForPlayer1,
      required this.connectedTo,
      required this.isHighlighted,
      required this.uID,
      required this.column});
}

class GridData with ChangeNotifier {
  List<Node> nodeData;
  List<Offset> player1Path;
  List<List<int>> player1NodePath;
  List<Offset> player2Path;
  List<List<int>> player2NodePath;
  List<List<int>> player1Lines;
  List<List<int>> player2Lines;
  bool isPlayer1Turn;
  bool isStartingPointSelection;
  bool player1Win;
  bool player2Win;
  GridData({
    required this.nodeData,
    required this.isPlayer1Turn,
    required this.isStartingPointSelection,
    required this.player1Path,
    required this.player1NodePath,
    required this.player2Path,
    required this.player2NodePath,
    required this.player1Win,
    required this.player2Win,
    required this.player1Lines,
    required this.player2Lines,
  });
  void updateNodeData(GridData gridData) {
    player1Win = gridData.player1Win;
    player2Win = gridData.player2Win;
    isStartingPointSelection = gridData.isStartingPointSelection;
    player1Path = gridData.player1Path;
    player1NodePath = gridData.player1NodePath;
    player2Path = gridData.player2Path;
    player2NodePath = gridData.player2NodePath;
    nodeData = gridData.nodeData;
    isPlayer1Turn = gridData.isPlayer1Turn;
    player1Lines = gridData.player1Lines;
    player2Lines = gridData.player2Lines;
    notifyListeners();
  }
}
