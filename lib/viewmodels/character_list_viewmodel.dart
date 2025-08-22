import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character.dart';
import '../repositories/character_repository.dart';
import '../services/api_service.dart';

// Providers básicos
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => CharacterRepository(ref.read(apiServiceProvider)),
);

// Estado da lista
class CharacterListState {
  final List<Character> items;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int? nextPage;

  const CharacterListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.nextPage = 2,
  });

  CharacterListState copyWith({
    List<Character>? items,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? nextPage,
  }) {
    return CharacterListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class CharacterListViewModel extends StateNotifier<CharacterListState> {
  final CharacterRepository _repo;
  CharacterListViewModel(this._repo) : super(const CharacterListState());

  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, error: null, currentPage: 1);
    try {
      final (items, nextPage) = await _repo.fetchCharacters(page: 1);
      state = state.copyWith(
        items: items,
        isLoading: false,
        nextPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.nextPage == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final next = state.nextPage ?? 1;
      final (items, nextPage) = await _repo.fetchCharacters(page: next);
      state = state.copyWith(
        items: [...state.items, ...items],
        isLoading: false,
        currentPage: next,
        nextPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final characterListProvider =
    StateNotifierProvider<CharacterListViewModel, CharacterListState>((ref) {
      return CharacterListViewModel(ref.read(characterRepositoryProvider));
    });
