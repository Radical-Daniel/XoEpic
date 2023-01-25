import 'grid.dart';

class WinCalculator {
//   static bool player2Win(GridData gridData) {
//     for (var row in gridData.nodeData) {
//       // if (row.every((element) => element.checked && !element.isForPlayer1)) {
//         return true;
//       }
//     }
//     return false;
//   }
//
//   static bool player1Win(GridData gridData) {
//     return gridData.nodeData.first.any((element) {
//       return element.checked && checkBelow(gridData, element.uID);
//     });
//   }
// }

  bool checkBelow(GridData gridData, int uID) {
    int numOfRows = gridData.nodeData.length;
    int numOfX = ((numOfRows - 1) / 2 * (numOfRows - 1) / 2 + 1).toInt();
    int numOfO = ((numOfRows - 1) / 2 * (numOfRows - 1) / 2 + 1).toInt();
    if (uID >
        numOfO +
            numOfX -
            gridData.nodeData.where((element) => element.row == 0).length) {
      return true;
    } else {
      // List<Node> listOfNodes = [];
      // for (var element in gridData.nodeData) {
      //   listOfNodes.addAll(element);
      // }
      // return listOfNodes[(uID + (numOfRows / 2) + 1).toInt()].checked &&
      //     checkBelow(gridData, uID + numOfRows);
      return false;
    }
  }
}
