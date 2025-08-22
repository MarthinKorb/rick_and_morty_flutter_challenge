import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character.dart';
import '../repositories/character_repository.dart';
import 'character_list_viewmodel.dart';

class CharacterDetailState {
  final Character? character;
  final bool isLoading;
  final String? error;

  const CharacterDetailState({
    this.character,
    this.isLoading = false,
    this.error,
  });

  CharacterDetailState copyWith({
    Character? character,
    bool? isLoading,
    String? error,
  }) {
    return CharacterDetailState(
      character: character ?? this.character,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CharacterDetailViewModel extends StateNotifier<CharacterDetailState> {
  final CharacterRepository _characterRepository;
  CharacterDetailViewModel(this._characterRepository)
    : super(const CharacterDetailState());

  Future<void> loadById(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final character = await _characterRepository.fetchCharacterById(id);
      state = state.copyWith(character: character, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final characterDetailProvider =
    StateNotifierProvider.autoDispose<
      CharacterDetailViewModel,
      CharacterDetailState
    >((ref) {
      return CharacterDetailViewModel(ref.read(characterRepositoryProvider));
    });
