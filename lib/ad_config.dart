import 'package:flutter/foundation.dart';

/// Set this to false to disable all ads globally while in debug mode (e.g., for taking app store screenshots).
/// Note: Ads will ALWAYS be enabled in release/published builds to prevent accidental revenue loss.
const bool _enableAdsInDebug = true;

/// Returns true if ads should be enabled. Always true in release mode.
bool get enableAdsGlobally => kReleaseMode || _enableAdsInDebug;
