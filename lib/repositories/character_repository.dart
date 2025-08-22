import '../models/character.dart';
import '../services/api_service.dart';

class CharacterRepository {
  final ApiService _apiService;
  const CharacterRepository(this._apiService);

  Future<(List<Character> items, int? nextPage)> fetchCharacters({
    int page = 1,
  }) async {
    final json = await _apiService.get('/character', query: {'page': '$page'});
    final results = (json['results'] as List).cast<Map<String, dynamic>>();
    final items = results.map(Character.fromMap).toList();

    // A API traz info.next com URL da próxima página
    final info = json['info'] as Map<String, dynamic>;
    final nextUrl = info['next'] as String?; // pode ser null
    int? nextPage;
    if (nextUrl != null) {
      final uri = Uri.parse(nextUrl);
      final pageStr = uri.queryParameters['page'];
      nextPage = pageStr != null ? int.tryParse(pageStr) : null;
    }
    return (items, nextPage);
  }

  Future<Character> fetchCharacterById(int id) async {
    final resp = await _apiService.get('/character/$id');
    return Character.fromMap(resp);
  }
}
