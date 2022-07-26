// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:intl/intl.dart';
import 'package:matcher/matcher.dart';
import 'package:musiclyric/model/music.dart';
import 'package:musiclyric/music_Bloc.dart';
class MusicPage extends StatefulWidget {
  const MusicPage({Key key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
   final musicBloc = MusicBloc();

  @override
  void initState() {
    musicBloc.eventSink.add(MusicAction.Fetch);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('music App'),
      ),
      body: Container(
        child: StreamBuilder<List<TrackList>>(
          stream: musicBloc.musicStream,
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Center(child: Text(snapshot.error ?? 'Error'),);
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var article = snapshot.data;
                    return Container(
                      height: 100,
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  article.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  article.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}