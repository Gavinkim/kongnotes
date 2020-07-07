import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kongnote/entities/entities.dart';

class Note extends Equatable {
  final String id;
  final String userId;
  final String content;
  final Color color;
  final DateTime timestamp;

  const Note({
    this.id,
    @required this.userId,
    @required this.content,
    @required this.color,
    @required this.timestamp,
  });

  @override
  List<Object> get props => [id, content, color, timestamp];

  @override
  String toString() {
    return 'Note{id: $id, userId: $userId, content: $content, color: $color, timestamp: $timestamp}';
  }

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      userId: userId,
      content: content,
      color: '#${color.value.toRadixString(16)}',
    );
  }

  factory Note.fromEntity(NoteEntity entity) {
    return Note(
        id: entity.id, userId: entity.content, color: HexColor(entity.color));
  }

  Note copy(
      {String id,
      String userId,
      String cotent,
      Color color,
      DateTime timestamp}) {
    return Note(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp);
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
