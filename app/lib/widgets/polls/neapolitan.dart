import 'package:flutter/material.dart';

class Neapolitan extends StatelessWidget {
  final List<int> pieces;
  final List<Color> colors;

  const Neapolitan({required this.pieces, required this.colors})
      : assert(pieces.length == colors.length);

  int get total => pieces.reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) => Container(
        width: 100,
        height: 25,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (total > 0)
              for (var i = 0; i < pieces.length; i++)
                Flexible(
                  flex: pieces[i],
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(color: colors[i]),
                      Text(
                        '${pieces[i]}',
                        style: TextStyle(
                            color: colors[i] == Colors.white
                                ? Colors.black
                                : Colors.white),
                      ),
                    ],
                  ),
                )
            else const Text('No votes.'),
          ],
        ),
      );
}
