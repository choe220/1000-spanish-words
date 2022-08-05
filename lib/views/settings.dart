import 'package:flutter/material.dart';
import 'package:spanish_words/models/user.dart';
import 'package:spanish_words/models/words.dart';
import 'package:spanish_words/widgets/white_text.dart';

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late RangeValues _currentSpeechSensitivityValues;
  late double _currentNumMatchCards = 5;
  Map<String, bool> partsOfSpeech = {
    'Pronoun': true,
    'Noun': true,
    'Adjective': true,
    'Verb': true,
    'Adverb': true,
    'Preposition': true,
    'Conjunction': true,
    'Interjection': true,
  };

  @override
  void initState() {
    super.initState();
    _currentSpeechSensitivityValues = RangeValues(
        widget.user.speechSensitivity[0].toDouble(),
        widget.user.speechSensitivity[1].toDouble());
    _currentNumMatchCards = widget.user.numMatchCards;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      widget.user.generateSet(null).then((_) => widget.user
                          .saveToFirebase()
                          .then((_) => setState(() {})));
                    },
                    child: const Text('Generate New Set'),
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // ElevatedButton(
                  //   onPressed: () async => {
                  //     widget.user.words += widget.user.currentSet!,
                  //     widget.user.currentSet = [],
                  //     await widget.user.saveToFirebase(),
                  //   },
                  //   child: const Text('Clear Current Set'),
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      List<Word> flagged = (widget.user.words +
                              widget.user.currentSet!)
                          .where(
                              (word) => word.flagged != null && word.flagged!)
                          .toList();
                      await widget.user.generateSet(flagged).then(
                          (value) async => await widget.user.saveToFirebase());
                    },
                    child: const Text('Create Set From Flagged'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const WhiteText(
                    'Increase Speech Attempts',
                    fontSize: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF006874),
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            if (widget.user.attempts > 1) {
                              widget.user.attempts -= 1;
                              await widget.user.saveToFirebase();
                              setState(() {});
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      WhiteText(
                        widget.user.attempts.toString(),
                        fontSize: 24,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF006874),
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            widget.user.attempts += 1;
                            await widget.user.saveToFirebase();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const WhiteText(
                    'Speech Sensitivity',
                  ),
                  RangeSlider(
                    values: _currentSpeechSensitivityValues,
                    max: 100,
                    divisions: 50,
                    labels: RangeLabels(
                      '${_currentSpeechSensitivityValues.start.round()} %',
                      '${_currentSpeechSensitivityValues.end.round()} %',
                    ),
                    onChanged: (values) => setState(
                        () => _currentSpeechSensitivityValues = values),
                    onChangeEnd: (value) async => {
                      widget.user.speechSensitivity = [
                        _currentSpeechSensitivityValues.start,
                        _currentSpeechSensitivityValues.end
                      ],
                      await widget.user.saveToFirebase(),
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const WhiteText(
                    'Change Number of Match Cards',
                    fontSize: 24,
                  ),
                  Slider(
                    value: _currentNumMatchCards,
                    min: 5,
                    max: 10,
                    divisions: 5,
                    label: _currentNumMatchCards.round().toString(),
                    onChangeEnd: (value) async => {
                      widget.user.numMatchCards = value,
                      await widget.user.saveToFirebase(),
                    },
                    onChanged: (value) =>
                        setState(() => _currentNumMatchCards = value),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const WhiteText(
                    'Parts of Speech to Practice',
                    fontSize: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Column(
                      children: [
                        ...widget.user.partsOfSpeech.keys.map(
                          (e) => Row(
                            children: [
                              Checkbox(
                                value: widget.user.partsOfSpeech[e],
                                fillColor:
                                    MaterialStateProperty.all(Colors.white),
                                checkColor: Colors.black,
                                onChanged: (value) async {
                                  setState(() {
                                    widget.user.partsOfSpeech[e] = value!;
                                  });
                                  await widget.user.saveToFirebase();
                                },
                              ),
                              WhiteText(e),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
