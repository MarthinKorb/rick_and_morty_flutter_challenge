import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_flutter_challenge/views/character_detail_page.dart';

import '../viewmodels/character_list_viewmodel.dart';
import '../widgets/character_card.dart';

class CharactersListPage extends ConsumerStatefulWidget {
  const CharactersListPage({super.key});

  @override
  ConsumerState<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends ConsumerState<CharactersListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(characterListProvider.notifier).loadFirstPage(),
    );

    // Paginação ao chegar perto do final
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 300) {
        ref.read(characterListProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(characterListProvider);

    final crossAxis = MediaQuery.of(context).size.width ~/ 180;
    final crossAxisCount = crossAxis.clamp(2, 6);

    return Scaffold(
      appBar: AppBar(title: const Text('Rick and Morty')),
      body: Column(
        children: [
          if (state.error != null)
            MaterialBanner(
              content: Text(state.error!),
              actions: [
                TextButton(
                  onPressed: () =>
                      ref.read(characterListProvider.notifier).loadFirstPage(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          Expanded(
            child: state.isLoading && state.items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(characterListProvider.notifier)
                          .loadFirstPage();
                    },
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: state.items.length + (state.isLoading ? 1 : 0),
                      itemBuilder: (_, index) {
                        if (index < state.items.length) {
                          final char = state.items[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CharacterDetailPage(character: char),
                                ),
                              );
                            },
                            child: CharacterCard(character: char),
                          );
                        } else {
                          // indicador de carregamento no final (pagina extra)
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
