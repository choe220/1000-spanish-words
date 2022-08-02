import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spanish_words/models/user.dart';
import 'package:spanish_words/models/words.dart';
import 'package:spanish_words/widgets/white_text.dart';

class WordsList extends StatefulWidget {
  const WordsList({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  List<Word> _foundWords = [];
  bool _filters = false;
  RangeValues _currentRangeValues = const RangeValues(0, 100);
  bool _onlyFlagged = false;
  bool _currentSet = false;

  @override
  void initState() {
    super.initState();
    _foundWords = (widget.user.words + widget.user.currentSet!);
  }

  void _filter(String? enteredKeyword) {
    List<Word> results = [];
    List<Word> wordPool = _onlyFlagged
        ? (widget.user.words + widget.user.currentSet!)
            .where((word) => word.flagged != null && word.flagged!)
            .toList()
        : _currentSet
            ? widget.user.currentSet!
            : (widget.user.words + widget.user.currentSet!);
    if (enteredKeyword != null && enteredKeyword.isNotEmpty) {
      results = wordPool
          .where((word) =>
              word.english.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    } else {
      results = wordPool;
    }
    results = results
        .where((word) =>
            (word.mastery ?? 0) >= _currentRangeValues.start / 100 &&
            (word.mastery ?? 0) <= _currentRangeValues.end)
        .toList();
    setState(() => _foundWords = results);
  }

  FlutterTts flutterTts = FlutterTts();

  Future _speak(String string) async {
    await flutterTts.setLanguage("es-MX");
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(string);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      onChanged: (value) => _filter(value),
                      onSubmitted: (value) => _filter(value),
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        labelStyle: TextStyle(color: Colors.white),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                        iconColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => setState(() => _filters = !_filters),
                )
              ],
            ),
            if (_filters)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WhiteText(
                    'Mastery Amount',
                  ),
                  RangeSlider(
                    values: _currentRangeValues,
                    max: 100,
                    divisions: 50,
                    labels: RangeLabels(
                      '${_currentRangeValues.start.round()} %',
                      '${_currentRangeValues.end.round()} %',
                    ),
                    onChanged: (values) => setState(() {
                      _currentRangeValues = values;
                      _filter(null);
                    }),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        fillColor: MaterialStateProperty.all(Colors.white),
                        checkColor: Colors.black,
                        value: _onlyFlagged,
                        onChanged: (value) => {
                          setState(() => _onlyFlagged = value!),
                          _filter(null),
                        },
                      ),
                      InkWell(
                        onTap: () => {
                          setState(() => _onlyFlagged = !_onlyFlagged),
                          _filter(null),
                        },
                        child: const WhiteText('Show Only Flagged Words'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        fillColor: MaterialStateProperty.all(Colors.white),
                        checkColor: Colors.black,
                        value: _currentSet,
                        onChanged: (value) => {
                          setState(() => _currentSet = value!),
                          _filter(null),
                        },
                      ),
                      InkWell(
                        onTap: () => {
                          setState(() => _currentSet = !_currentSet),
                          _filter(null),
                        },
                        child: const WhiteText('Show Current Set'),
                      ),
                    ],
                  ),
                ],
              ),
            Expanded(
              child: _foundWords.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundWords.length,
                      itemBuilder: (context, index) => Card(
                        key: ValueKey(_foundWords[index].english),
                        color: Colors.white,
                        elevation: 4,
                        child: ListTile(
                          title: Text(_foundWords[index].english),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_foundWords[index].spanish),
                              Text(
                                  '${(_foundWords[index].mastery ?? 0) * 100} % mastery'),
                              LinearProgressIndicator(
                                value: _foundWords[index].mastery,
                                semanticsLabel: 'Linear progress indicator',
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const Text('Flagged'),
                                  Checkbox(
                                    value: _foundWords[index].flagged ?? false,
                                    onChanged: (value) async => {
                                      _foundWords[index].flagged = value,
                                      setState(() {}),
                                      await widget.user.saveToFirebase(),
                                    },
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.volume_up),
                                onPressed: () async =>
                                    await _speak(_foundWords[index].spanish),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const WhiteText(
                      'No Results Found',
                      fontSize: 24,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
