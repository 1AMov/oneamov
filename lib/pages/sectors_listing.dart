import 'package:flutter/material.dart';
import 'package:oneamov/models/project_sector.dart';

class SectorsListing extends StatelessWidget {
  const SectorsListing({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        const Text(
          "Sector Activity",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),
        ),
        const SizedBox(height: 10.0),
        ...List.generate(projectSectors.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${(index + 1).toString().padLeft(2, "0")}."),
                const SizedBox(width: 10.0),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        projectSectors[index].imageUrl,
                        height: 100.0,
                        width: size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      projectSectors[index].title,
                      style: TextStyle(fontWeight: FontWeight.w800),
                    )
                  ],
                ))
              ],
            ),
          );
        })
      ],
    );
  }
}
