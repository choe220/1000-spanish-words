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
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(
        widget.user.speechSensitivity[0].toDouble(),
        widget.user.speechSensitivity[1].toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
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
                        .where((word) => word.flagged != null && word.flagged!)
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
                  values: _currentRangeValues,
                  max: 100,
                  divisions: 50,
                  labels: RangeLabels(
                    '${_currentRangeValues.start.round()} %',
                    '${_currentRangeValues.end.round()} %',
                  ),
                  onChanged: (values) =>
                      setState(() => _currentRangeValues = values),
                  onChangeEnd: (value) async => {
                    widget.user.speechSensitivity = [
                      _currentRangeValues.start,
                      _currentRangeValues.end
                    ],
                    await widget.user.saveToFirebase(),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
