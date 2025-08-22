import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback? onTap;
  const CharacterCard({super.key, required this.character, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Hero(
        tag: 'character_${character.id}',
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: character.status.toLowerCase() == 'alive'
              ? Colors.green.shade100
              : character.status.toLowerCase() == 'dead'
              ? Colors.red.shade100
              : Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: character.image,
                    fit: BoxFit.cover,
                    placeholder: (c, _) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (c, _, __) => const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    character.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: character.status.toLowerCase() == 'alive'
                          ? Colors.green
                          : character.status.toLowerCase() == 'dead'
                          ? Colors.red
                          : Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        character.status,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
