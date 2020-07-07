import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kongnote/config/paths.dart';
import 'package:kongnote/entities/entities.dart';
import 'package:kongnote/notes/base_notes_repository.dart';
import 'package:kongnote/model/models.dart';

class NotesRepository extends BaseNotesRepository {
  final Firestore _firestore;
  final Duration _timeoutDuration = Duration(seconds: 10);

  NotesRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  @override
  Future<Note> addNote({@required Note note}) async {
    await _firestore
        .collection(Paths.notes)
        .add(note.toEntity().toDocument())
        .timeout(_timeoutDuration);
    return note;
  }

  @override
  Future<Note> updateNote({@required Note note}) async {
    await _firestore
        .collection(Paths.notes)
        .document(note.id)
        .updateData(note.toEntity().toDocument())
        .timeout(_timeoutDuration);
    return note;
  }

  @override
  Future<Note> deleteNote({@required Note note}) async {
    await _firestore
        .collection(Paths.notes)
        .document(note.id)
        .delete()
        .timeout(_timeoutDuration);
    return note;
  }

  @override
  Stream<List<Note>> streamNotes({@required String userId}) {
    return _firestore
        .collection(Paths.notes)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => Note.fromEntity(NoteEntity.fromSnapshot(doc)))
            .toList()
              ..sort((a, b) => b.timestamp.compareTo(a.timestamp)))
        .timeout(_timeoutDuration);
  }

  @override
  void dispose() {}
}
