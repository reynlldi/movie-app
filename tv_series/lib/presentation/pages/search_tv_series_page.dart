import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/search/search_tv_series_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_series_card_list.dart';

class SearchTvSeriesPage extends StatefulWidget {
  static const routeName = "/search-tv-series";

  const SearchTvSeriesPage({super.key});

  @override
  State<SearchTvSeriesPage> createState() => _SearchTvSeriesPageState();
}

class _SearchTvSeriesPageState extends State<SearchTvSeriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchTvSeriesBloc>().add(OnQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchTvSeriesBloc, SearchTvSeriesState>(
              builder: (context, state) {
                if (state is SearchTvSeriesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchTvSeriesHasData) {
                  final result = state.result;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = result[index];
                        return TvSeriesCard(movie);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchTvSeriesEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text("Search Not Found"),
                    ),
                  );
                } else if (state is SearchTvSeriesError) {
                  return Expanded(
                    key: const Key('error_message'),
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Container(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
