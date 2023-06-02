import 'package:game_template/src/games_services/grid.dart';

class WinCon {
  final GridData gridData;
  WinCon({required this.gridData});

  static List<List<int>> createPlayerLines(GridData data, bool isForPlayer1) {
    List<List<int>> lines = [];
    for (int node in data.nodeData
        .where((element) =>
            isForPlayer1 ? element.isForPlayer1 : !element.isForPlayer1)
        .map((e) => e.uID)) {
      Node testedNode = data.nodeData[node];
      if (testedNode.checked) {
        // &&
        //   (!lines
        //           .map((e) => e.map((f) => f.uID))
        //           .any((element) => element.contains(node.uID)) &&
        //       !lines.any((element) => node.connectedTo
        //           .any((e) => element.map((e) => e.uID).contains(e))))) {
        List<int> line = [];
        line.add(node);
        if (testedNode.connectedTo.isNotEmpty) {
          line.addAll(testedNode.connectedTo);
        }
        List<int> additionalConnections = [];
        for (int related in line) {
          Node relatedNode = data.nodeData[related];
          for (int conNode in relatedNode.connectedTo) {
            additionalConnections.add(conNode);
          }
        }
        line.addAll(additionalConnections);

        line = line.toSet().toList();
        lines.add(line);
      }
    }
    return lines;
  }

  static List<List<int>> cleanLines(List<List<int>> linez) {
    List<List<int>> cleaned = linez;
    for (int i = 0; i < linez.length; i++) {
      List<List<int>> testedLines;
      if (i == 0) {
        testedLines = linez.sublist(i + 1);
      } else {
        testedLines = linez.sublist(0, i);
        testedLines.addAll(linez.sublist(i + 1).toList());
      }

      for (List<int> oline in testedLines) {
        if (oline.any((element) => linez[i].contains(element))) {
          cleaned[i].addAll(oline);
          cleaned[i].toSet().toList();
          cleaned.remove(oline);
        }
      }
    }
    cleaned = cleaned.map((e) => e.toSet().toList()).toList();
    return cleaned;
  }

  static List<bool> createChecksList(bool isPlayer1, GridData data) {
    List<bool> checks = [];
    if (isPlayer1) {
      int numOfRow = data.nodeData.last.row + 1;
      for (int i = 0; i < numOfRow; i++) {
        // set player 1 rows checks false
        if (i % 2 == 0) {
          checks.add(false);
        }
        // set player 2 rows checks to be true
        else {
          checks.add(true);
        }
      }
    } else {
      int numOfColumn = data.nodeData.last.column + 2;

      // adding false checks for each column
      for (int i = 0; i < numOfColumn; i++) {
        checks.add(false);
      }
    }

    return checks;
  }

  static bool player1Win(GridData data) {
    List<List<int>> lines = [];
    // creates lines
    if (data.nodeData.every((element) => !element.checked)) {
      return false;
    }

    lines = createPlayerLines(data, true);

    // joins new lines to old ones
    lines = cleanLines(lines);

    for (var line in lines) {
      List<bool> checkList = createChecksList(true, data);
      for (int uID in line) {
        Node node = data.nodeData[uID];
        checkList[node.row] = true;
      }
      if (checkList.every((element) => element == true)) {
        return true;
      }
    }

    return false;
  }

  static bool player2Win(GridData data) {
    List<List<int>> lines = [];

    if (data.nodeData.every((element) => !element.checked)) {
      return false;
    }

    lines = createPlayerLines(data, false);
    lines = cleanLines(lines);

    for (var line in lines) {
      List<bool> checkList = createChecksList(false, data);
      for (int uID in line) {
        Node node = data.nodeData[uID];
        checkList[node.column] = true;
      }
      print(checkList);
      if (checkList.every((element) => element == true)) {
        return true;
      }
    }

    return false;
  }
}
