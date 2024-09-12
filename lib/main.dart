import 'package:core/core.dart';
import 'package:core/presentation/pages/about_page.dart';
import 'package:core/presentation/pages/home_page.dart';
import 'package:core/presentation/pages/splash_page.dart';
import 'package:core/utils/http_ssl_pinning.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation/bloc/detail/detail_movies_bloc.dart';
import 'package:movies/presentation/bloc/now_playing/now_playing_movies_bloc.dart';
import 'package:movies/presentation/bloc/popular/popular_movies_bloc.dart';
import 'package:movies/presentation/bloc/search/search_movies_bloc.dart';
import 'package:movies/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:movies/presentation/bloc/up_coming/up_coming_movies_bloc.dart';
import 'package:movies/presentation/bloc/watchlist/watchlist_movies_bloc.dart';
import 'package:movies/presentation/pages/movie_detail_page.dart';
import 'package:movies/presentation/pages/now_playing_movies_page.dart';
import 'package:movies/presentation/pages/popular_movies_page.dart';
import 'package:movies/presentation/pages/search_movies_page.dart';
import 'package:movies/presentation/pages/top_rated_movies_page.dart';
import 'package:movies/presentation/pages/watchlist_movies_page.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:tv_series/presentation/bloc/airing_today/airing_today_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/detail/detail_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/now_playing/now_playing_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/popular/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/search/search_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/season/detail_season_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated/top_rated_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist/watchlist_tv_series_bloc.dart';
import 'package:tv_series/presentation/pages/detail_season_page.dart';
import 'package:tv_series/presentation/pages/now_playing_tv_series_page.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/presentation/pages/search_tv_series_page.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:tv_series/presentation/pages/tv_series_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HttpSSLPinning.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<SearchMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<UpComingMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<AiringTodayTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailSeasonBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: const SplashPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case "/splash":
              return MaterialPageRoute(
                builder: (_) => const SplashPage(),
              );
            case HomePage.routeName:
              return MaterialPageRoute(
                builder: (_) => const HomePage(),
              );
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularMoviesPage(),
              );
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedMoviesPage(),
              );
            case NowPlayingMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const NowPlayingMoviesPage(),
              );
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const SearchMoviesPage(),
              );
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const WatchlistMoviesPage(),
              );
            case TvSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case SearchTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const SearchTvSeriesPage(),
              );
            case NowPlayingTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const NowPlayingTvSeriesPage(),
              );
            case PopularTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const PopularTvSeriesPage(),
              );
            case TopRatedTvSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const TopRatedTvSeriesPage(),
              );
            case AboutPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const AboutPage(),
              );
            case DetailSeasonPage.routeName:
              final arguments = settings.arguments as Map<String, dynamic>;
              final id = arguments['id'] as int;
              final seasonNumber = arguments['seasonNumber'] as int;
              return MaterialPageRoute(
                builder: (_) => DetailSeasonPage(
                  id: id,
                  seasonNumber: seasonNumber,
                ),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
