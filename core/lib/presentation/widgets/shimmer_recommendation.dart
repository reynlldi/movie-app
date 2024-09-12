import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerRecommendations extends StatelessWidget {
  const ShimmerRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.3),
            highlightColor: Colors.grey.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
