import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final wordPair = WordPair.random();

    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(
        primaryColor: Colors.blue,
      ), //程序主题
      home: new Scaffold(
        // appBar: new AppBar(
        //   title: new Text('Welcome to Flutter'),
        // ),
        body: new Center(
          child: new RandomWords(),
        ),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  @override
  final _sugg = <WordPair>[]; //列表

  final _saved = new Set<WordPair>(); //添加用户喜欢列表

  final _biggerFont = const TextStyle(fontSize: 18.0); //控制字体大小
  Widget _build() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;

        if (index >= _sugg.length) {
          _sugg.addAll(generateWordPairs().take(10)); //生成十个单词
        }
        return _buildRow(_sugg[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ), //添加图标
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // leading: BackButton(),
        title: new Text('Startup Name Generator'),
        // bottom: TabBar(
        //   isScrollable: true,
        //   tabs: <Widget>[
        //     Text('列表'),
        //     Text('列表'),
        //     Text('列表'),
        //     Text('列表'),
        //     Text('列表')
        //   ],
        //   controller: TabController(length: 5, vsync: this),
        // ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                final tiles = _saved.map((pair) {
                  return new ListTile(
                    title: new Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                });
                final divided = ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList();
                return new Scaffold(
                  appBar: new AppBar(
                    title: new Text('Saved Suggestions'),
                  ),
                  body: new ListView(children: divided),
                );
              }));
            },
          ), //列表项
          IconButton(icon: Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: _build(),
    );
  }
}
