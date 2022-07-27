import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/services/database_class.dart';

import '../../widgets/task_builder.dart';
import 'entries_bloc.dart';
import 'entries_list_tile.dart';

class EntryDetPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<DatabaseClass>(
      context,
      listen: false,
    );
    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(
        database: database,
      ),
      child: EntryDetPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(
      context,
      listen: false,
    );
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return ListTaskBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          taskBuilder: (context, model) => EntriesListTile(
            model: model,
          ),
        );
      },
    );
  }
}
