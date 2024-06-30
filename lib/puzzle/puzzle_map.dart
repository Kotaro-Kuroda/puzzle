import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle/puzzle/puzzle_block.dart';

class PuzzleMap extends ConsumerStatefulWidget {
  final int numRows;
  final int numCols;
  final List<dynamic> labels;
  final double blockWidth;
  final double blockHeight;
  const PuzzleMap(this.numRows, this.numCols, this.labels, this.blockWidth,
      this.blockHeight,
      {super.key});

  @override
  ConsumerState<PuzzleMap> createState() => _PuzzleMapState();
}

class _PuzzleMapState extends ConsumerState<PuzzleMap> {
  final List<int> _indices = [for (int i = 0; i < 16; i++) i];
  bool _isCompleted() {
    for (int i = 0; i < _indices.length; i++) {
      if (_indices[i] != i) {
        return false;
      }
    }
    return true;
  }

  bool _isFeasible() {
    int vacantIndex = _indices.indexOf(15);
    int distance = (15 - vacantIndex) % 2;
    int numMove = 0;
    List<int> indicesCloned = [..._indices];
    for (int i = 0; i < indicesCloned.length - 1; i++) {
      for (int j = i + 1; j < indicesCloned.length; j++) {
        if (indicesCloned[i] > indicesCloned[j]) {
          numMove += 1;
          int tmp = indicesCloned[i];
          indicesCloned[i] = indicesCloned[j];
          indicesCloned[j] = tmp;
        }
      }
    }
    return numMove % 2 == distance;
  }

  @override
  void initState() {
    super.initState();
    _indices.shuffle(Random());
    while (!_isFeasible()) {
      _indices.shuffle(Random());
    }
  }

  void _swap(int index1, int index2) {
    setState(() {
      final int tmp = _indices[index1];
      _indices[index1] = _indices[index2];
      _indices[index2] = tmp;
    });
  }

  Widget createMap() {
    List<Widget> column = [];
    for (int i = 0; i < widget.numCols; i++) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < widget.numRows; j++) {
        final int index = _indices[i * widget.numCols + j];
        final String label = widget.labels[index].toString();
        final PuzzleBlock puzzleBlock =
            PuzzleBlock(widget.blockWidth, widget.blockHeight, index, label);
        final GestureDetector block = GestureDetector(
            onTap: () {
              int left = i * widget.numCols + j - 1;
              int right = i * widget.numCols + j + 1;
              int above = (i - 1) * widget.numCols + j;
              int under = (i + 1) * widget.numCols + j;
              if (j >= 1) {
                String leftLabel = (widget.labels[_indices[left]]);
                if (leftLabel.isEmpty) {
                  _swap(i * widget.numCols + j, left);
                }
              }
              if (j < widget.numCols - 1) {
                String rightLabel = (widget.labels[_indices[right]]);
                if (rightLabel.isEmpty) {
                  _swap(i * widget.numCols + j, right);
                }
              }
              if (i >= 1) {
                String aboveLabel = (widget.labels[_indices[above]]);
                if (aboveLabel.isEmpty) {
                  _swap(i * widget.numCols + j, above);
                }
              }
              if (i < widget.numRows - 1) {
                String underLabel = (widget.labels[_indices[under]]);
                if (underLabel.isEmpty) {
                  _swap(i * widget.numCols + j, under);
                }
              }
              if (_isCompleted()) {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("This is the title"),
                        content: const Text("This is the content"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              _indices.shuffle(Random());
                              while (!_isFeasible()) {
                                _indices.shuffle(Random());
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              }
            },
            child: puzzleBlock);
        rowChildren.add(block);
      }
      Row row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowChildren,
      );
      column.add(row);
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: column);
  }

  @override
  Widget build(BuildContext context) {
    return createMap();
  }
}
