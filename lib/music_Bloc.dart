// ignore_for_file: constant_identifier_names
// @dart = 2.9

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart ' as http;
import 'package:musiclyric/model/music.dart';
import 'package:musiclyric/music_Bloc.dart';

import 'music_Bloc.dart';

enum MusicAction { Fetch, Delete }

class MusicBloc {
  final _stateStreamController = StreamController<List<TrackList>>();

  StreamSink<List<TrackList>> get _musicSink => _stateStreamController.sink;
  Stream<List<TrackList>> get musicStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<MusicAction>();

  StreamSink<MusicAction> get eventSink => _eventStreamController.sink;
  Stream<MusicAction> get eventSteam => _eventStreamController.stream;

  MusicBloc() {
    eventSteam.listen((event) async {
      if (event == MusicAction.Fetch) {
        try {
          var music = await getNames();
          if(music!=null) {
            _musicSink.add(music.trackList);
          } else {
            _musicSink.addError("Something went wrong");
          }
        } on Exception catch (e) {
          _musicSink.addError("Something went wrong");
        }
      }
    });
  }
  Future<Body> getNames() async {
    var musicModel;

    try {
      var response = await http.get(Uri.parse('https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7'));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        musicModel = Body.fromJson(jsonMap);
      }
    } catch (Exception) {
      print("exception caught");
    }
    return musicModel;
  }
}
