import 'package:baby_tracks/model/card_item.dart';
import 'package:flutter/material.dart';

class AppListViewPage extends StatefulWidget {
  const AppListViewPage({super.key, this.onPush});

  final ValueChanged<String>? onPush;

  @override
  State<AppListViewPage> createState() => _AppListViewPageState();
}

class _AppListViewPageState extends State<AppListViewPage> {
  List<CardItem> tiles = CardItem.builder();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        final tile = tiles[index];
        String keyTitle = tiles[index].title;

        return Card(
          child: InkWell(
            splashColor: tile.color,
            onTap: () => widget.onPush?.call(keyTitle),
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(22.0),
                child: Row(
                  children: <Widget>[
                    Text(tile.title),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
