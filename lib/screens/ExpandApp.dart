import 'package:flutter/material.dart';

class TileApp1 extends StatefulWidget {
  @override
  _TileApp1State createState() => _TileApp1State();
}

class _TileApp1State extends State<TileApp1> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: AppBar(
              title: Text('ExpansionTile App'),
            ),
            body: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return new StuffInTiles(listofTiles[index]);
              },
              itemCount: listofTiles.length,
            )));
  }
}

class TileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: AppBar(
              title: Text('ExpansionTile App'),
            ),
            body: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return new StuffInTiles(listofTiles[index]);
              },
              itemCount: listofTiles.length,
            )));
  }
}

class MyTile {
  String title;
  List<MyTile> children;
  MyTile(this.title, [this.children = const <MyTile>[]]);
}

List<MyTile> listofTiles = <MyTile>[
  new MyTile(
    'Due: 2021-03-24',
    <MyTile>[
      new MyTile(
        '3-4pm',
        <MyTile>[
          new MyTile('T1'),
          new MyTile('T2'),
          new MyTile('T3'),
        ],
      ),
      new MyTile(
        '4-5pm',
        <MyTile>[
          new MyTile('T4'),
          new MyTile('T5'),
          new MyTile('T6'),
        ],
      ),
      new MyTile(
        '5-6pm',
        <MyTile>[
          new MyTile('T7'),
          new MyTile('T8'),
          new MyTile('T9'),
        ],
      ),
    ],
  ),
  new MyTile(
    'Due: 2021-03-25',
    <MyTile>[
      new MyTile(
        '13-14',
        <MyTile>[
          new MyTile('T4'),
          new MyTile('T5'),
          new MyTile('T6'),
        ],
      ),
      new MyTile('14-15'),
      new MyTile('15-16'),
    ],
  ),
  new MyTile(
    'Due: 2021-03-26',
    <MyTile>[
      new MyTile(
        '20-21',
        <MyTile>[
          new MyTile('T7'),
          new MyTile('T8'),
          new MyTile('T9'),
        ],
      ),
      new MyTile('21-22'),
      new MyTile('22-23'),
    ],
  ),
];

class StuffInTiles extends StatelessWidget {
  final MyTile myTile;
  StuffInTiles(this.myTile);

  @override
  Widget build(BuildContext context) {
    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty) {
      return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Title'),
                  Text('Context'),
                  Text('Due Date'),
                ],
              ),
              isThreeLine: false,
              dense: true,
              value: false,
              onChanged: (value) {
              },
              activeColor: Colors.brown[900],
              checkColor: Colors.white,
              autofocus: true,
            );
    }
    return new ExpansionTile(
      key: new PageStorageKey<MyTile>(t),
      title: new Text(t.title),
      children: t.children.map(_buildTiles).toList(),
    );
  }
}
