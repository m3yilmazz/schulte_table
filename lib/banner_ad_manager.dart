import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:schulte_table/ad_helper.dart';

/// Helper to create and manage a BannerAd per screen.
/// Each screen gets its own ad instance to avoid the
/// "AdWidget is already in the Widget tree" error.
class BannerAdHelper {
  BannerAd? bannerAd;
  bool isAdLoaded = false;

  void loadAd({VoidCallback? onAdLoaded}) {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isAdLoaded = true;
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          bannerAd = null;
          isAdLoaded = false;
        },
      ),
    )..load();
  }

  void dispose() {
    bannerAd?.dispose();
    bannerAd = null;
    isAdLoaded = false;
  }

  /// Convenience widget builder for the bottom nav bar.
  /// Always reserves the banner height to prevent layout shifts.
  Widget buildBannerWidget() {
    return SafeArea(
      child: SizedBox(
        height: AdSize.banner.height.toDouble(),
        child: isAdLoaded && bannerAd != null
            ? AdWidget(ad: bannerAd!)
            : const SizedBox.shrink(),
      ),
    );
  }
}
