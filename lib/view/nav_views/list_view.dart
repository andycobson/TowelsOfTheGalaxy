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
        String route = tiles[index].route;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
          child: SizedBox(
            height: 85,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(4, 6))
                  ]),
              child: Card(
                color: tile.color,
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () => widget.onPush?.call(route),
                  child: Center(
                    child: Text(
                      tile.title,
                      style: const TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
