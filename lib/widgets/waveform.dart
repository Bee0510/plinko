import 'package:flutter/material.dart';

class WaveformBar extends StatelessWidget {
  final double amplitude;
  final int numBlocks;
  final List<Color> gradientColors = [
    const Color.fromARGB(255, 255, 17, 0),
    Color.fromARGB(255, 255, 230, 0),
    const Color.fromARGB(255, 0, 255, 8),
  ];
  WaveformBar({
    Key? key,
    required this.amplitude,
    this.numBlocks = 100,
  }) : super(key: key);

  Color _getBlockColor(int blockIndex) {
    double blockRatio = blockIndex / numBlocks;

    int firstColorIndex = (blockRatio * (gradientColors.length - 1)).floor();
    int secondColorIndex = (blockRatio * (gradientColors.length - 1)).ceil();
    double lerpFactor = (blockRatio * (gradientColors.length - 1)) % 1;

    Color color = Color.lerp(gradientColors[firstColorIndex],
        gradientColors[secondColorIndex], lerpFactor)!;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(numBlocks, (index) {
        return Flexible(
          child: Container(
            margin: const EdgeInsets.all(1.0),
            color: index > (amplitude * numBlocks).toInt()
                ? _getBlockColor(index)
                : Colors.transparent,
          ),
        );
      }),
    );
  }
}
