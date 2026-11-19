import 'package:flutter/material.dart';
import 'package:cinewave/models/movie_model.dart';
import 'package:cinewave/services/tmdb_service.dart';
import 'package:cinewave/themes/app_themes.dart';

class DetailsScreen extends StatelessWidget {
  final MovieModel? movie;

  const DetailsScreen({super.key, this.movie});

  @override
  Widget build(BuildContext context) {
    final MovieModel currentMovie = movie ??
        (ModalRoute.of(context)?.settings.arguments as MovieModel?) ??
        TmdbService.fallbackMovies.first;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            shape: BoxShape.circle,
            border: Border.all(color: AppThemes.primary.withValues(alpha: 0.5), width: 1),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppThemes.primary, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                FadeInImage(
                  placeholder: const AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(currentMovie.backdropPath),
                  height: 330,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 330,
                      color: AppThemes.darkCard,
                      alignment: Alignment.center,
                      child: const Icon(Icons.movie, size: 60, color: AppThemes.primary),
                    );
                  },
                ),
                Container(
                  height: 330,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppThemes.darkBackground.withValues(alpha: 0.8),
                        AppThemes.darkBackground,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 95,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppThemes.primary, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppThemes.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage(
                            placeholder: const AssetImage('assets/jar-loading.gif'),
                            image: NetworkImage(currentMovie.posterPath),
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppThemes.darkCard,
                                alignment: Alignment.center,
                                child: const Icon(Icons.movie, color: AppThemes.primary),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppThemes.systemMatch.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppThemes.systemMatch),
                              ),
                              child: Text(
                                '${currentMovie.matchPercentage}% de coincidencia',
                                style: const TextStyle(
                                  color: AppThemes.systemMatch,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentMovie.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppThemes.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  currentMovie.releaseDate,
                                  style: const TextStyle(
                                    color: AppThemes.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '•',
                                  style: TextStyle(color: AppThemes.primary),
                                ),
                                const SizedBox(width: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: AppThemes.primary, size: 16),
                                    const SizedBox(width: 3),
                                    Text(
                                      currentMovie.voteAverage.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: AppThemes.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reproduciendo en CineWave Player...'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 22),
                          label: const Text('Reproducir', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppThemes.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Película añadida a Mi Lista'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.bookmark_add_outlined, color: AppThemes.primary, size: 20),
                          label: const Text('Mi Lista', style: TextStyle(color: AppThemes.textPrimary)),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppThemes.translucentButton,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: AppThemes.primary.withValues(alpha: 0.4), width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                        'Sinopsis Oficial',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppThemes.darkCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppThemes.primary.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      currentMovie.overview,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppThemes.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        'Datos de TMDB',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppThemes.darkCard,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Identificador TMDB', style: TextStyle(color: AppThemes.textSecondary, fontSize: 13)),
                            Text('#${currentMovie.id}', style: const TextStyle(color: AppThemes.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        const Divider(height: 20, color: Color(0x1AD4AF37)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Calificación General', style: TextStyle(color: AppThemes.textSecondary, fontSize: 13)),
                            Text('${currentMovie.voteAverage} / 10', style: const TextStyle(color: AppThemes.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        const Divider(height: 20, color: Color(0x1AD4AF37)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Año de Estreno', style: TextStyle(color: AppThemes.textSecondary, fontSize: 13)),
                            Text(currentMovie.releaseDate, style: const TextStyle(color: AppThemes.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
