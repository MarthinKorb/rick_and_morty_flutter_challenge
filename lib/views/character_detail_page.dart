import 'package:flutter/material.dart';

import '../models/character.dart';

class CharacterDetailPage extends StatelessWidget {
  final Character character;

  const CharacterDetailPage({super.key, required this.character});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'character_${character.id}',
              child: Image.network(
                character.image,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              character.name,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: _statusColor(character.status),
                ),
                const SizedBox(width: 6),
                Text(
                  character.status,
                  style: TextStyle(
                    fontSize: 16,
                    color: _statusColor(character.status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_outline),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Name: ${character.name}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.category),
                        const SizedBox(width: 8),
                        Text(
                          "Espécie: ${character.species}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (character.type.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.type_specimen),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Type: ${character.type}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        const Icon(Icons.transgender),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Gender: ${character.gender}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
