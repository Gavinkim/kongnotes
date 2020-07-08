import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kongnote/blocs/auth/auth_bloc.dart';
import 'package:kongnote/blocs/blocs.dart';
import 'package:kongnote/repositories/repositories.dart';
import 'package:kongnote/widgets/widgets.dart';

import 'note_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        //Fetch repositories.notes
        context.bloc<NotesBloc>().add(FetchNotes());
      },
      builder: (context, authState) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider<NoteDetailBloc>(
                      create: (_) => NoteDetailBloc(
                        authBloc: context.bloc<AuthBloc>(),
                        notesRepository: NotesRepository(),
                      ),
                      child: NoteDetailScreen(),
                    ))),
          ),
          body: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, notesState) {
              return _buildBody(context, authState, notesState);
            },
          ),
        );
      },
    );
  }

  Stack _buildBody(
      BuildContext context, AuthState authState, NotesState notesState) {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Your Notes'),
              ),
              leading: IconButton(
                icon: authState is Authenticated
                    ? Icon(Icons.exit_to_app)
                    : Icon(Icons.account_circle),
                iconSize: 28.0,
                onPressed: () => authState is Authenticated
                    ? context.bloc<AuthBloc>().add(Logout())
                    : print('Go to login'),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.brightness_4),
                  onPressed: () => print('Change theme'),
                ),
              ],
            ),
            notesState is NotesLoaded
                ? NotesGrid(
                    notes: notesState.notes,
                    onTap: (note) =>
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => BlocProvider<NoteDetailBloc>(
                                  create: (_) => NoteDetailBloc(
                                    authBloc: context.bloc<AuthBloc>(),
                                    notesRepository: NotesRepository(),
                                  )..add(NoteLoaded(note: note)),
                                  child: NoteDetailScreen(
                                    note: note,
                                  ),
                                ))),
                  )
                : const SliverPadding(padding: EdgeInsets.zero),
          ],
        ),
        notesState is NotesLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox.shrink(),
        notesState is NotesError
            ? Center(
                child: Text(
                  'Something went wrong!\n Please check your connection.',
                  textAlign: TextAlign.center,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
