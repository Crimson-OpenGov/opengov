import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Neapolitan extends StatelessWidget {
  static final _numberFormat = NumberFormat();

  final List<int> pieces;
  final List<Color> colors;

  const Neapolitan({required this.pieces, required this.colors})
      : assert(pieces.length == colors.length);

  int get total => pieces.reduce((a, b) => a + b);

  List<int> get percentages =>
      pieces.map((e) => (e / total * 100).round()).toList(growable: false);

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 25,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (total > 0)
                    for (var i = 0; i < pieces.length; i++)
                      Flexible(
                        flex: pieces[i],
                        child: Container(
                          color: colors[i],
                          // height: 25,
                        ),
                      )
                  else
                    const Text('No votes.'),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (total > 0)
                  for (var i = 0; i < pieces.length; i++)
                    Text(
                      '${percentages[i]}%',
                      style: TextStyle(
                          color: colors[i] == Colors.white
                              ? Colors.black
                              : colors[i]),
                    ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${_numberFormat.format(total)} vote${total == 1 ? '' : 's'}'),
          ],
        ),
      );
}
