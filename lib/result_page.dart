import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:schulte_table/banner_ad_manager.dart';

import 'main.dart';

class ResultPage extends StatefulWidget {
  final String bestTimeName, previousGameModeRoute, gameModeName;
  final List<int> list;
  final bool isReverse;

  const ResultPage(this.bestTimeName, this.gameModeName, this.list,
      this.previousGameModeRoute, this.isReverse,
      {super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final _adHelper = BannerAdHelper();
  int _bestTime = 0;
  List<Widget> _logWidgets = [];

  @override
  void initState() {
    super.initState();
    _adHelper.loadAd(onAdLoaded: () {
      if (mounted) setState(() {});
    });
    _computeResults();
  }

  @override
  void dispose() {
    _adHelper.dispose();
    super.dispose();
  }

  void _computeResults() {
    // Compute best time and save if needed
    int currentBest = _getBestTime(widget.bestTimeName);

    if (hasRoundFinished && (currentBest == 0 || globalTimer < currentBest)) {
      currentBest = globalTimer;
      _setBestTime(widget.bestTimeName, currentBest);
      _saveBestTime(widget.bestTimeName, currentBest);
    }
    _bestTime = currentBest;

    // Build log widgets once
    _logWidgets = List.generate(maxElementNumber, (i) {
      final label = widget.isReverse ? '${maxElementNumber - i}' : '${i + 1}';
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurpleAccent,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          'Time taken: ${widget.list[i] / 1000}s',
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.timer, color: Colors.grey),
      );
    });
  }

  int _getBestTime(String key) {
    switch (key) {
      case "bestTimeClassicOriginal":
        return bestTimeClassicOriginal;
      case "bestTimeClassicOriginalReverse":
        return bestTimeClassicOriginalReverse;
      case "bestTimeClassicLight":
        return bestTimeClassicLight;
      case "bestTimeClassicLightReverse":
        return bestTimeClassicLightReverse;
      case "bestTimeMemory":
        return bestTimeMemory;
      case "bestTimeReaction":
        return bestTimeReaction;
      default:
        return 0;
    }
  }

  void _setBestTime(String key, int value) {
    switch (key) {
      case "bestTimeClassicOriginal":
        bestTimeClassicOriginal = value;
        break;
      case "bestTimeClassicOriginalReverse":
        bestTimeClassicOriginalReverse = value;
        break;
      case "bestTimeClassicLight":
        bestTimeClassicLight = value;
        break;
      case "bestTimeClassicLightReverse":
        bestTimeClassicLightReverse = value;
        break;
      case "bestTimeMemory":
        bestTimeMemory = value;
        break;
      case "bestTimeReaction":
        bestTimeReaction = value;
        break;
    }
  }

  Future<void> _saveBestTime(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName("/"))),
        title: Text("${widget.gameModeName} Results",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Icon(Icons.emoji_events, color: Colors.orange, size: 40),
                            const SizedBox(height: 10),
                            const Text("Best Time", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("${_bestTime / 1000}s", style: const TextStyle(color: Colors.deepPurple, fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Icon(Icons.timer, color: Colors.blueAccent, size: 40),
                            const SizedBox(height: 10),
                            const Text("Total Time", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("${globalTimer / 1000}s", style: const TextStyle(color: Colors.deepPurple, fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Detailed Timings", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
            ),
            Expanded(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: ListView.separated(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _logWidgets.length,
                  itemBuilder: (context, index) => _logWidgets[index],
                  separatorBuilder: (context, index) => const Divider(indent: 20, endIndent: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                  label: const Text(
                    "PLAY AGAIN!",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  onPressed: () => Navigator.pushNamed(context, widget.previousGameModeRoute),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _adHelper.buildBannerWidget(),
    );
  }
}
