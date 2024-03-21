import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:equatable/equatable.dart';


class UnOpenedDBException implements Exception { }

class LocalHighScoreDatabase {

  static const String dbName = "localnews";
  static const String _leaders = "leaders";


  //the hive box
  late final Box box;

  ///constructor ensures box is open
  LocalHighScoreDatabase({box} ) : this.box=box??Hive.box<HighScoreRecord>(dbName){
    if (!this.box.isOpen) {
      throw UnOpenedDBException();
    }
  }

  void put(List<HighScoreRecord> leaders) {
    for(var i = 0; i < leaders.length; i++) {
      box.put(i, leaders[i]);
    }
  }

  List<HighScoreRecord> getLeaders() {
    List<HighScoreRecord> hsr =<HighScoreRecord> [];
    for (var i = 0; i < box.length; i++) {
      hsr.add(box.get(i));
    }
    return hsr;
  }

  static Future<void> init() async{
    //hive documentation states to register the type adapter first
    Hive.registerAdapter(HighScoreRecordAdapter());

    await Hive.initFlutter();
    await Hive.openBox<HighScoreRecord>(dbName);
  }

  static Future<void> close() async {
    await Hive.close();
  }
}

@HiveType(typeId: 0)
class HighScoreRecord extends Equatable {
  final String? title;
  final String img;
  final String author;
  final String date;
  final String paper;

  const HighScoreRecord(this.title, this.img,this.author, this.date, this.paper);



  @override
  List<Object?> get props => [title, img,author, date, paper];
}

class HighScoreRecordAdapter extends TypeAdapter<HighScoreRecord> {

  @override
  HighScoreRecord read (BinaryReader reader) {

    var numOfFields = reader.readByte();

    //build the map of fieldNumber: field
    //e.g. 0 : name
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };

    return HighScoreRecord(
        fields[0] as String,
        fields[1] as String,
        fields[2] as String,
        fields[3] as String,
        fields[4] as String,
    );
  }

  @override
  //unique number between 0 and 233
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, HighScoreRecord obj) {
    //high score record has:
    // field 0: String name,
    // field 1: int streakLength and
    // field 2: DateTime date

    writer
      ..writeByte(5) //5 fields
      ..writeByte(0) //next is field 0
      ..write(obj.title) //write the person's initials
      ..writeByte(1) //next is field 1
      ..write(obj.img)
      ..writeByte(2) //next field is 2
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.paper);
  }
}