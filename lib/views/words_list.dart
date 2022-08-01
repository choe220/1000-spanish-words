import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:spanish_words/models/words.dart';

class WordsList extends StatefulWidget {
  const WordsList({Key? key, required this.words}) : super(key: key);

  final List<Word> words;

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  List<Word> _foundWords = [];
  bool _filters = false;
  RangeValues _currentRangeValues = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();
    _foundWords = widget.words;
  }

  void _filter(String? enteredKeyword) {
    List<Word> results = [];
    if (enteredKeyword != null && enteredKeyword.isNotEmpty) {
      results = widget.words
          .where((word) =>
              word.english.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    } else {
      results = widget.words;
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
                  const Text(
                    'Mastery Amount',
                    style: TextStyle(color: Colors.white),
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
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () async =>
                                await _speak(_foundWords[index].spanish),
                          ),
                        ),
                      ),
                    )
                  : const Text(
                      'No Results Found',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
