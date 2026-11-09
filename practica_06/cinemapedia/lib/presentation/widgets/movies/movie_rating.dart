import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';

class MovieRating extends StatelessWidget {
  const MovieRating({super.key, required this.voteAverage});

  final double voteAverage;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_half_outlined, color: Colors.yellow.shade800),
        const SizedBox(width: 3),
        Text(
          HumanFormats.number(voteAverage, 1),
          style: style?.copyWith(color: Colors.yellow.shade800),
        ),
      ],
    );
  }
}
