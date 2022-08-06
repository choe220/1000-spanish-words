import 'package:flutter/material.dart';
import 'package:spanish_words/models/user.dart';
import 'package:spanish_words/models/words.dart';
import 'package:spanish_words/widgets/flashcard.dart';
import 'package:spanish_words/widgets/white_text.dart';

class FlashcardsView extends StatefulWidget {
  final User user;

  const FlashcardsView({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<FlashcardsView> createState() => _FlashcardsViewState();
}

class _FlashcardsViewState extends State<FlashcardsView>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  List<bool> isSelected = [true, false];
  late List<FlashCard> _flashCards;
  PageController _flashCardPageController =
      PageController(viewportFraction: 0.8);

  List<FlashCard> getFlashcards() {
    return List<FlashCard>.from(
      widget.user.currentSet!.map((e) => FlashCard(
            key: ValueKey<Word>(e),
            word: e,
            showAnswer: !isSelected[0],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    _flashCards = getFlashcards();
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: ToggleButtons(
                onPressed: (index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                isSelected: isSelected,
                fillColor: const Color(0xFF006874),
                borderRadius: BorderRadius.circular(8.0),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: WhiteText(
                      'English',
                      fontSize: 32,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: WhiteText(
                      'Spanish',
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WhiteText(
                          '${_index % _flashCards.length + 1} / 10',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 200.0,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.8),
                        // itemCount: _flashCards.length,
                        onPageChanged: (int index) =>
                            setState(() => _index = index),
                        itemBuilder: (context, index) {
                          return Transform.scale(
                            scale: index == _index ? 1 : 0.9,
                            child: _flashCards[index % _flashCards.length],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       decoration: BoxDecoration(
                //         color: const Color(0xFF006874),
                //         borderRadius: BorderRadius.circular(
                //           20,
                //         ),
                //       ),
                //       child: IconButton(
                //         onPressed: () {
                //           if (_index == 0) {
                //             setState(() => _index = 9);
                //           } else {
                //             setState(() => _index -= 1);
                //           }
                //         },
                //         icon: const Icon(
                //           Icons.arrow_back,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 55,
                //     ),
                //     Container(
                //       decoration: BoxDecoration(
                //         color: const Color(0xFF006874),
                //         borderRadius: BorderRadius.circular(
                //           20,
                //         ),
                //       ),
                //       child: IconButton(
                //         onPressed: () {
                //           if (_index == 9) {
                //             setState(() => _index = 0);
                //           } else {
                //             setState(() => _index += 1);
                //           }
                //         },
                //         icon: const Icon(
                //           Icons.arrow_forward,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
