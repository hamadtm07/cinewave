import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cinewave/models/movie_model.dart';
import 'package:cinewave/routes/app_routes.dart';
import 'package:cinewave/services/tmdb_service.dart';
import 'package:cinewave/themes/app_themes.dart';
import 'package:cinewave/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;
  List<MovieModel> _nowPlaying = [];
  List<MovieModel> _popular = [];
  List<MovieModel> _topRated = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() async {
    final nowPlayingFuture = TmdbService.getNowPlaying();
    final popularFuture = TmdbService.getPopular();
    final topRatedFuture = TmdbService.getTopRated();

    final results = await Future.wait([nowPlayingFuture, popularFuture, topRatedFuture]);

    if (mounted) {
      setState(() {
        _nowPlaying = results[0];
        _popular = results[1];
        _topRated = results[2];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppThemes.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppThemes.primary.withValues(alpha: 0.4)),
              ),
              child: const Icon(Icons.movie_filter_rounded, color: AppThemes.primary, size: 20),
            ),
            const SizedBox(width: 10),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                children: [
                  TextSpan(text: 'Cine', style: TextStyle(color: AppThemes.textPrimary)),
                  TextSpan(text: 'Wave', style: TextStyle(color: AppThemes.primary)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Buscar en TMDB',
            icon: const Icon(Icons.search_rounded, color: AppThemes.primary, size: 24),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.searchRoute);
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppThemes.primary,
              ),
            )
          : IndexedStack(
              index: _currentIndex,
              children: [
                _HomeFeedView(
                  nowPlaying: _nowPlaying,
                  popular: _popular,
                  topRated: _topRated,
                ),
                _ExploreView(movies: _popular),
                _FavoritesView(movies: _topRated.take(4).toList()),
                const _ProfileView(),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppThemes.darkCard,
          border: Border(
            top: BorderSide(
              color: AppThemes.primary.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
            child: GNav(
              rippleColor: AppThemes.primary.withValues(alpha: 0.2),
              hoverColor: AppThemes.primary.withValues(alpha: 0.1),
              gap: 6,
              activeColor: AppThemes.primary,
              iconSize: 22,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              tabBackgroundColor: AppThemes.primary.withValues(alpha: 0.15),
              color: AppThemes.textSecondary,
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: const [
                GButton(icon: Icons.home_rounded, text: 'Inicio'),
                GButton(icon: Icons.explore_rounded, text: 'Explorar'),
                GButton(icon: Icons.bookmark_rounded, text: 'Mi Lista'),
                GButton(icon: Icons.person_rounded, text: 'Perfil'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeFeedView extends StatelessWidget {
  final List<MovieModel> nowPlaying;
  final List<MovieModel> popular;
  final List<MovieModel> topRated;

  const _HomeFeedView({
    required this.nowPlaying,
    required this.popular,
    required this.topRated,
  });

  @override
  Widget build(BuildContext context) {
    final heroMovie = nowPlaying.isNotEmpty ? nowPlaying.first : popular.first;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppThemes.primary.withValues(alpha: 0.4), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppThemes.primary.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  FadeInImage(
                    placeholder: const AssetImage('assets/jar-loading.gif'),
                    image: NetworkImage(heroMovie.backdropPath),
                    height: 230,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(height: 230, color: AppThemes.darkCard);
                    },
                  ),
                  Container(
                    height: 230,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppThemes.darkBackground.withValues(alpha: 0.7),
                          AppThemes.darkBackground,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppThemes.systemMatch.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppThemes.systemMatch),
                          ),
                          child: Text(
                            '${heroMovie.matchPercentage}% de coincidencia • Estreno',
                            style: const TextStyle(
                              color: AppThemes.systemMatch,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          heroMovie.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppThemes.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppThemes.primary,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.detailsRoute, arguments: heroMovie);
                              },
                              icon: const Icon(Icons.play_arrow_rounded, size: 20),
                              label: const Text('Ver Tráiler', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 10),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppThemes.translucentButton,
                                foregroundColor: AppThemes.textPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                side: BorderSide(color: AppThemes.primary.withValues(alpha: 0.3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.detailsRoute, arguments: heroMovie);
                              },
                              icon: const Icon(Icons.info_outline_rounded, size: 18, color: AppThemes.primary),
                              label: const Text('Detalles'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildSectionHeader('En Cartelera', 'TMDB Live', () {}),
          SizedBox(
            height: 235,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: nowPlaying.length,
              itemBuilder: (context, index) {
                final movie = nowPlaying[index];
                return MoviePosterCard(
                  movie: movie,
                  width: 135,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.detailsRoute, arguments: movie);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Más Populares', 'Ver más', () {}),
          SizedBox(
            height: 235,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: popular.length,
              itemBuilder: (context, index) {
                final movie = popular[index];
                return MoviePosterCard(
                  movie: movie,
                  width: 135,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.detailsRoute, arguments: movie);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Aclamadas por la Crítica', 'Top Ranking', () {}),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: topRated.length > 6 ? 6 : topRated.length,
              itemBuilder: (context, index) {
                final movie = topRated[index];
                return MoviePosterCard(
                  movie: movie,
                  width: double.infinity,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.detailsRoute, arguments: movie);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String tag, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppThemes.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.textPrimary,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppThemes.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppThemes.primary.withValues(alpha: 0.3)),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: AppThemes.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreView extends StatelessWidget {
  final List<MovieModel> movies;

  const _ExploreView({required this.movies});

  @override
  Widget build(BuildContext context) {
    final categories = ['Ciencia Ficción', 'Acción', 'Drama', 'Aventura', 'Animación', 'Suspenso'];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explorar Géneros',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppThemes.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == 0;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppThemes.primary : AppThemes.darkCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? AppThemes.primary : AppThemes.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.black : AppThemes.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Catálogo Destacado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppThemes.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MoviePosterCard(
                movie: movie,
                width: double.infinity,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.detailsRoute, arguments: movie);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  final List<MovieModel> movies;

  const _FavoritesView({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppThemes.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Mi Lista de Favoritos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MoviePosterCard(
                movie: movie,
                width: double.infinity,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.detailsRoute, arguments: movie);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppThemes.primary, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppThemes.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 46,
                    backgroundColor: AppThemes.darkCard,
                    child: Text(
                      'HT',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.primary,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppThemes.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Hamad El Troudi',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppThemes.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Estudiante de Ingeniería de Sistemas',
            style: TextStyle(
              fontSize: 13,
              color: AppThemes.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Universidad de Margarita (UNIMAR)',
            style: TextStyle(
              fontSize: 12,
              color: AppThemes.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard('Películas', '42', Icons.local_movies_outlined),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard('Mi Lista', '18', Icons.bookmark_border_rounded),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard('Favorito', 'Sci-Fi', Icons.auto_awesome_outlined),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppThemes.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppThemes.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.badge_outlined, color: AppThemes.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Información de la Cuenta',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 22, color: Color(0x1AD4AF37)),
                _buildInfoRow('Correo Académico', 'hel_troudi.9491@unimar.edu.ve'),
                const SizedBox(height: 10),
                _buildInfoRow('Telegram', '@hamadelt'),
                const SizedBox(height: 10),
                _buildInfoRow('GitHub', 'github.com/hamadtm07'),
                const SizedBox(height: 10),
                _buildInfoRow('Materia', 'Programación III'),
                const SizedBox(height: 10),
                _buildInfoRow('Profesor', 'Prof. Héctor'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppThemes.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppThemes.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                _buildOptionTile(Icons.hd_outlined, 'Calidad de Streaming', 'Ultra HD 4K'),
                const Divider(height: 16, color: Color(0x1AD4AF37)),
                _buildOptionTile(Icons.language_outlined, 'Idioma de la API', 'Español (es-ES)'),
                const Divider(height: 16, color: Color(0x1AD4AF37)),
                _buildOptionTile(Icons.info_outline_rounded, 'Versión de la App', 'CineWave v1.0.0'),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppThemes.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppThemes.primary.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppThemes.primary, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppThemes.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppThemes.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppThemes.textSecondary, fontSize: 13)),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: AppThemes.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: AppThemes.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: AppThemes.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: AppThemes.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}
