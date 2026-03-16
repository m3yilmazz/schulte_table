import 'package:flutter/material.dart';
import 'package:schulte_table/banner_ad_manager.dart';
import 'main.dart';

class PlayButton extends StatefulWidget {
  final String gameModeName, routeName, description;
  final int bestTime;

  const PlayButton(this.gameModeName, this.routeName, this.bestTime, this.description, {super.key});

  @override
  State<StatefulWidget> createState() => PlayButtonState();
}

class PlayButtonState extends State<PlayButton> {
  final _adHelper = BannerAdHelper();

  @override
  void initState() {
    super.initState();
    _adHelper.loadAd(onAdLoaded: () {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _adHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName("/"))),
        title: Text("Play ${widget.gameModeName}",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.info_outline,
                                  color: Colors.deepPurpleAccent, size: 28),
                              const SizedBox(width: 10),
                              Text(
                                "How to Play",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple.shade800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.description,
                            style: const TextStyle(
                                fontSize: 16, height: 1.5, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.deepPurple.shade50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.emoji_events,
                              color: Colors.orange, size: 30),
                          const SizedBox(width: 12),
                          Text(
                            "Best Time: ${widget.bestTime ~/ 1000}s",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        iconColor: Colors.white,
                        elevation: 8,
                        shadowColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow, size: 30),
                      label: const Text(
                        "PLAY",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5),
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, widget.routeName),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _adHelper.buildBannerWidget(),
    );
  }
}
