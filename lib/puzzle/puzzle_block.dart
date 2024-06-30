import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PuzzleBlock extends ConsumerStatefulWidget {
  final double blockWidth;
  final double blockHeight;
  final int index;
  final String label;
  const PuzzleBlock(this.blockWidth, this.blockHeight, this.index, this.label,
      {super.key});

  @override
  ConsumerState<PuzzleBlock> createState() => _PuzzleBlockState();
}

class _PuzzleBlockState extends ConsumerState<PuzzleBlock> {
  @override
  Widget build(BuildContext context) {
    final Color color;
    final Border? border;
    if (widget.index == 15) {
      color = Colors.transparent;
      border = null;
    } else {
      color = Colors.blue;
      border = Border.all();
    }

    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: color,
        border: border,
        borderRadius: BorderRadius.circular(10),
      ),
      width: widget.blockWidth,
      height: widget.blockHeight,
      alignment: Alignment.center,
      child: Text(widget.label),
    );
  }
}
