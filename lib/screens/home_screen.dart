import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:cinewave/models/movie_model.dart';
import 'package:cinewave/routes/app_routes.dart';
import 'package:cinewave/themes/app_themes.dart';
import 'package:cinewave/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<MovieModel> _movies = [
    MovieModel(
      id: 1,
      title: 'Dune: Part Two',
      overview: 'Paul Atreides se une a Chani y a los Fremen mientras busca venganza contra los conspiradores que destruyeron a su familia.',
      posterPath: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500&auto=format&fit=crop&q=80',
      backdropPath: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&auto=format&fit=crop&q=80',
      voteAverage: 8.8,
      releaseDate: '2024',
      genre: 'Ciencia Ficción • Aventura',
      matchPercentage: 98,
    ),
    MovieModel(
      id: 2,
      title: 'Interstellar',
      overview: 'Un equipo de exploradores viaja a través de un agujero de gusano en el espacio en un intento por garantizar la supervivencia de la humanidad.',
      posterPath: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=500&auto=format&fit=crop&q=80',
      backdropPath: 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=800&auto=format&fit=crop&q=80',
      voteAverage: 8.7,
      releaseDate: '2014',
      genre: 'Ciencia Ficción • Drama',
      matchPercentage: 96,
    ),
    MovieModel(
      id: 3,
      title: 'Oppenheimer',
      overview: 'La historia del científico estadounidense J. Robert Oppenheimer y su papel en el desarrollo de la bomba atómica.',
      posterPath: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=500&auto=format&fit=crop&q=80',
      backdropPath: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=800&auto=format&fit=crop&q=80',
      voteAverage: 8.6,
      releaseDate: '2023',
      genre: 'Biografía • Historia',
      matchPercentage: 94,
    ),
    MovieModel(
      id: 4,
      title: 'Gladiator II',
      overview: 'Años después de presenciar la muerte del venerado héroe Máximo a manos de su tío, Lucio debe ingresar al Coliseo.',
      posterPath: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500&auto=format&fit=crop&q=80',
      backdropPath: 'https://images.unsplash.com/photo-1460881680858-30d870d7bffe?w=800&auto=format&fit=crop&q=80',
      voteAverage: 8.3,
      releaseDate: '2024',
      genre: 'Acción • Aventura',
      matchPercentage: 92,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.movie_filter_rounded, color: AppThemes.primary, size: 24),
            const SizedBox(width: 8),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
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
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeFeedView(movies: _movies),
          const _ExploreView(),
          const _FavoritesView(),
          const _ProfileView(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppThemes.darkCard,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withValues(alpha: 0.2),
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
              tabBackgroundColor: AppThemes.primary.withValues(alpha: 0.12),
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
  final List<MovieModel> movies;

  const _HomeFeedView({required this.movies});

  @override
  Widget build(BuildContext context) {
    final heroMovie = movies.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                FadeInImage(
                  placeholder: const AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(heroMovie.backdropPath),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(height: 220, color: AppThemes.darkCard);
                  },
                ),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppThemes.darkCard.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppThemes.systemMatch.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppThemes.systemMatch),
                        ),
                        child: Text(
                          '${heroMovie.matchPercentage}% de coincidencia',
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
                          fontWeight: FontWeight.bold,
                          color: AppThemes.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppThemes.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.detailsRoute, arguments: heroMovie);
                            },
                            icon: const Icon(Icons.play_arrow_rounded, size: 18),
                            label: const Text('Ver Tráiler'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppThemes.translucentButton,
                              foregroundColor: AppThemes.textPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.detailsRoute, arguments: heroMovie);
                            },
                            icon: const Icon(Icons.info_outline_rounded, size: 18),
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
          const SizedBox(height: 20),
          const Text(
            'Tendencias de la Semana (TMDB)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppThemes.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...movies.map(
            (m) => MovieCardWidget(
              movie: m,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.detailsRoute, arguments: m);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreView extends StatelessWidget {
  const _ExploreView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Explorador de Categorías TMDB', style: TextStyle(color: AppThemes.textSecondary)),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  const _FavoritesView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Películas Guardadas en Mi Lista', style: TextStyle(color: AppThemes.textSecondary)),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Perfil de Usuario', style: TextStyle(color: AppThemes.textSecondary)),
    );
  }
}
