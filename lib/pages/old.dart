
  // // Future play(OffsetsAndHeuristicValue bestFit) async {
  // //   Offset tileToMoveOffset = initialOffsets[bestFit.indexMoved];
  // //   previousMoveIndex = bestFit.indexMoved;

  // //   setState(() {
  // //     Offset tempEmptySlotOffset = initialOffsets.last;
  // //     initialOffsets.last = tileToMoveOffset;
  // //     initialOffsets.removeAt(bestFit.indexMoved);
  // //     initialOffsets.insert(bestFit.indexMoved, tempEmptySlotOffset);
  // //   });

  // //   await Future.delayed(Duration(milliseconds: 200));

  // //   // print(bestFit.heuristicValue);
  // //   // print(solvedStateOffsets);

  // //   if (bestFit.heuristicValue != 0) {
  // //     play(getBestFit(mainOffsets: bestFit.offset));
  // //   } else {
  // //     previousMoveIndex = null;
  // //   }
  // // }

  // //  List<Offset> getConnectedTilesOffsets() {
  // //   Offset tile1 =
  // //       Offset(initialOffsets.last.dx - 217.0, initialOffsets.last.dy);
  // //   Offset tile2 =
  // //       Offset(initialOffsets.last.dx + 217.0, initialOffsets.last.dy);
  // //   Offset tile3 =
  // //       Offset(initialOffsets.last.dx, initialOffsets.last.dy - 217.0);
  // //   Offset tile4 =
  // //       Offset(initialOffsets.last.dx, initialOffsets.last.dy + 217.0);
  // //   List<Offset> connectedTilesOffsets = [];
  // //   void addIfExists(Offset tile) {
  // //     if (initialOffsets.contains(tile)) {
  // //       connectedTilesOffsets.add(tile);
  // //     }
  // //   }

  // //   addIfExists(tile1);
  // //   addIfExists(tile2);
  // //   addIfExists(tile3);
  // //   addIfExists(tile4);
  // //   return connectedTilesOffsets;
  // // }

  //   void solve() async {
  //   List<Offset> connectedTiles = getConnectedTilesOffsets();
  //   List<Offset> clonedOffsets =
  //       List.generate(initialOffsets.length, (index) => initialOffsets[index]);
  //   Offset clonedEmptySlotOffset = initialOffsets.last;

  //   List<OffsetsAndHeuristicValue> o = [];

  //   connectedTiles.forEach((connectedTileOffset) {
  //     //Swap.
  //     Offset tempEmptySlotOffset = clonedEmptySlotOffset;
  //     clonedOffsets.last = connectedTileOffset;
  //     int index = clonedOffsets.indexOf(connectedTileOffset);
  //     clonedOffsets.removeAt(index);
  //     clonedOffsets.insert(index, tempEmptySlotOffset);

  //     //Calculate Heursitic Value.
  //     if (previousMoveIndex != null) {
  //       if (index != previousMoveIndex) {
  //         o.add(heuristicFunction(clonedOffsets: clonedOffsets)
  //           ..indexMoved = index);
  //       }
  //     } else {
  //       o.add(heuristicFunction(clonedOffsets: clonedOffsets)
  //         ..indexMoved = index);
  //     }

  //     //Set back.
  //     clonedOffsets = List.generate(
  //         initialOffsets.length, (index) => initialOffsets[index]);
  //     clonedOffsets.last = initialOffsets.last;
  //   });

  //   o.sort((a, b) {
  //     return a.heuristicValue.compareTo(b.heuristicValue);
  //   });

  //   OffsetsAndHeuristicValue bestFit = o.first;
  //   int lengthOfBest = o
  //       .where((element) => element.heuristicValue == bestFit.heuristicValue)
  //       .length;
  //   if (lengthOfBest > 1) {
  //     //Get Heuristic Value for each case
  //     //The question is however, how are You sure that those ones won't have the same issue.
  //     //So basically You have to keep going down for each until the value is 0.
  //     //Then You use that to determine the one to take until You get to the topper top.
  //     //I don't know what the shit I'm writing here. It feels like it'll take a lot f
  //   }

  //   // await play(bestFit);
  // }



