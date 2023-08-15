import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultTile extends ConsumerStatefulWidget {
  const SearchResultTile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchResultTileState();
}

class _SearchResultTileState extends ConsumerState<SearchResultTile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListTile(
        title: Text('data'),
      ),
    );
  }
}
