import 'package:flutter/material.dart';
import 'package:cinewave/models/movie_model.dart';
import 'package:cinewave/themes/app_themes.dart';

class MoviePosterCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onTap;
  final double width;

  const MoviePosterCard({
    super.key,
    required this.movie,
    this.onTap,
    this.width = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 14, bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppThemes.primary.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FadeInImage(
                        placeholder: const AssetImage('assets/jar-loading.gif'),
                        image: NetworkImage(movie.posterPath),
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppThemes.darkCard,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.movie_creation_outlined,
                              size: 40,
                              color: AppThemes.primary,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppThemes.primary.withValues(alpha: 0.6),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppThemes.primary,
                                size: 14,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: AppThemes.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.9),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Text(
                            '${movie.matchPercentage}% coincidencia',
                            style: const TextStyle(
                              color: AppThemes.systemMatch,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppThemes.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              movie.releaseDate,
              style: const TextStyle(
                fontSize: 11,
                color: AppThemes.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
