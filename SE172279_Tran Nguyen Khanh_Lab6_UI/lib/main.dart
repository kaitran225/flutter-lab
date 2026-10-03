import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

final List<Movie> allMovies = [
  Movie(
    title: "Harry Potter and the Philosopher's Stone",
    year: 2001,
    genres: ['Fantasy', 'Adventure', 'Family'],
    posterUrl: 'assets/images/hp1_philosophers_stone.png',
    rating: 7.6,
  ),
  Movie(
    title: 'Harry Potter and the Chamber of Secrets',
    year: 2002,
    genres: ['Fantasy', 'Adventure'],
    posterUrl: 'assets/images/hp2_chamber_of_secrets.png',
    rating: 7.4,
  ),
  Movie(
    title: 'Harry Potter and the Prisoner of Azkaban',
    year: 2004,
    genres: ['Fantasy', 'Adventure', 'Mystery'],
    posterUrl: 'assets/images/hp3_prisoner_of_azkaban.png',
    rating: 7.9,
  ),
  Movie(
    title: 'Harry Potter and the Goblet of Fire',
    year: 2005,
    genres: ['Fantasy', 'Adventure', 'Action'],
    posterUrl: 'assets/images/hp4_goblet_of_fire.png',
    rating: 7.7,
  ),
  Movie(
    title: 'Harry Potter and the Order of the Phoenix',
    year: 2007,
    genres: ['Fantasy', 'Adventure', 'Family'],
    posterUrl: 'assets/images/hp5_order_of_the_phoenix.png',
    rating: 7.5,
  ),
  Movie(
    title: 'Harry Potter and the Half-Blood Prince',
    year: 2009,
    genres: ['Fantasy', 'Adventure', 'Mystery'],
    posterUrl: 'assets/images/hp6_half_blood_prince.png',
    rating: 7.6,
  ),
  Movie(
    title: 'Harry Potter and the Deathly Hallows – Part 1',
    year: 2010,
    genres: ['Fantasy', 'Adventure', 'Mystery'],
    posterUrl: 'assets/images/hp7_deathly_hallows_part1.png',
    rating: 7.7,
  ),
  Movie(
    title: 'Harry Potter and the Deathly Hallows – Part 2',
    year: 2011,
    genres: ['Fantasy', 'Adventure', 'Action'],
    posterUrl: 'assets/images/hp8_deathly_hallows_part2.png',
    rating: 8.1,
  ),
];

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Movie App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';
  Set<String> selectedGenres = {};
  String selectedSort = 'A-Z';

  final List<String> allGenres = [
    'Action',
    'Adventure',
    'Family',
    'Fantasy',
    'Mystery',
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Filtering
    List<Movie> filteredMovies = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any((g) => selectedGenres.contains(g));
      return matchesSearch && matchesGenre;
    }).toList();

    // 2. Sorting
    filteredMovies.sort((a, b) {
      switch (selectedSort) {
        case 'A-Z':
          return a.title.compareTo(b.title);
        case 'Z-A':
          return b.title.compareTo(a.title);
        case 'Year':
          return b.year.compareTo(a.year); // Newest first
        case 'Rating':
          return b.rating.compareTo(a.rating); // Highest first
        default:
          return 0;
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find a Movie',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Genre Chips
              Row(
                children: [
                  const Text('Genres:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  if (selectedGenres.isNotEmpty)
                    Badge(
                      label: Text('${selectedGenres.length}'),
                      child: const Icon(Icons.filter_list),
                    ),
                  const Spacer(),
                  if (selectedGenres.isNotEmpty)
                    TextButton(
                      onPressed: () => setState(() => selectedGenres.clear()),
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: allGenres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedGenres.add(genre);
                        } else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Sort Bar
              Row(
                children: [
                  const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: selectedSort,
                    items: ['A-Z', 'Z-A', 'Year', 'Rating'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedSort = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Responsive Movie List
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 800) {
                      // Small screens: Single column ListView
                      return ListView.builder(
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          return MovieCard(movie: filteredMovies[index]);
                        },
                      );
                    } else {
                      // Large screens: Two column GridView
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredMovies.length,
                        itemBuilder: (context, index) {
                          return MovieCard(movie: filteredMovies[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                movie.posterUrl,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 150,
                    color: Colors.grey,
                    child: const Icon(Icons.movie, size: 50),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text('Year: ${movie.year}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: movie.genres
                        .map((g) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                g,
                                style: const TextStyle(fontSize: 10, color: Colors.deepPurple),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
