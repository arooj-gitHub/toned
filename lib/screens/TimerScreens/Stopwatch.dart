/* import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:tonedaustralia/style/colors.dart';

class StopWatchUI extends StatefulWidget {
  const StopWatchUI({super.key});

  @override
  State<StopWatchUI> createState() => _StopwatchState();
}

class _StopwatchState extends State<StopWatchUI> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.

  @override
  void initState() {
    super.initState();
  }

  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(1), // millisecond => minute.
  );

  final stopWatchTimerdown = StopWatchTimer(mode: StopWatchMode.countUp);

  /// Get millisecond from hour
  final value = StopWatchTimer.getMilliSecFromHour(1);

  /// Get millisecond from minute
  final value2 = StopWatchTimer.getMilliSecFromMinute(60);

  /// Get millisecond from second
  final value3 = StopWatchTimer.getMilliSecFromSecond(60 * 60);

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  bool isRun = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 50, right: 50),
            child: Column(
              children: [
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: 0,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime = StopWatchTimer.getDisplayTime(value!);
                    return Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Text(
                              displayTime,
                              style: const TextStyle(fontSize: 40, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          height: 500,
                          margin: const EdgeInsets.only(top: 150),
                          child: StreamBuilder<List<StopWatchRecord>>(
                            stream: _stopWatchTimer.records,
                            initialData: const [],
                            builder: (context, snap) {
                              final value = snap.data;
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final data = value[index];
                                  return Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          '${index + 1} ${data.displayTime}',
                                          style: const TextStyle(fontSize: 17, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      )
                                    ],
                                  );
                                },
                                itemCount: value!.length,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                        child: GestureDetector(
                          onTap: () {
                            _stopWatchTimer.onResetTimer();
                          },
                          child: const Center(
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isRun = _stopWatchTimer.isRunning;
                            });

                            if (isRun) {
                              _stopWatchTimer.onStopTimer();
                            } else {
                              _stopWatchTimer.onStartTimer();
                            }
                          },
                          child: Center(
                            child: Icon(
                              !isRun ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                        child: GestureDetector(
                          onTap: () {
                            _stopWatchTimer.onAddLap();
                          },
                          child: const Center(
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
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
    );
  }
}
 */