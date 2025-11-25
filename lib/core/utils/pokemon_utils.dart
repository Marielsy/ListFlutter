class PokemonUtils {
  static String getImageUrl(String url) {
    final id = getIdFromUrl(url);
    if (id == null) return '';
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  static String? getIdFromUrl(String url) {
    // Example URL: https://pokeapi.co/api/v2/pokemon/1/
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return null;
    
    return segments.last;
  }
}
