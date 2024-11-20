import 'package:flutter/material.dart';
import 'data/jokes.dart';

Color appColor = Colors.green[300] as Color;

void main() => runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appColor,
          title: const Text("Favorite Jokes"),
        ),
        body: JokesList(),
      ),
    ));

class FavoriteCard extends StatefulWidget {
  final Joke joke;
  final Function(Joke) onFavoriteToggle;

  const FavoriteCard({
    super.key,
    required this.joke,
    required this.onFavoriteToggle,
  });

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  void onFavoriteClick() {
    widget.onFavoriteToggle(widget.joke);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: .5, color: Colors.grey),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.joke.title,
                  style:
                      TextStyle(color: appColor, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10.0),
                Text(widget.joke.description)
              ],
            ),
          ),
          IconButton(
              onPressed: onFavoriteClick,
              icon: Icon(
                widget.joke.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.joke.isFavorite ? Colors.red : Colors.grey,
              ))
        ],
      ),
    );
  }
}

class JokesList extends StatefulWidget {
  @override
  State<JokesList> createState() => _JokesListState();
}

class _JokesListState extends State<JokesList> {
  void toggleFavorite(Joke joke) {
    setState(() {
      // If another joke is favorite, unfavorite it
      if (joke.isFavorite == false) {
        for (var j in jokes) {
          if (j.isFavorite) {
            j.isFavorite = false;
          }
        }
      }
      joke.isFavorite = !joke.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jokes.length,
      itemBuilder: (context, index) {
        return FavoriteCard(
          joke: jokes[index],
          onFavoriteToggle: toggleFavorite,
        );
      },
    );
  }
}
