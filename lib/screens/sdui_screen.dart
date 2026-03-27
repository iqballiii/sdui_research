import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:sdui_research/json_service.dart';
import 'package:stac/stac.dart';

class SduiScreen extends StatefulWidget {
  const SduiScreen({super.key, required this.binId});
  final String binId;
  @override
  State<SduiScreen> createState() => _SduiScreenState();
}

class _SduiScreenState extends State<SduiScreen> {
  Map<String, dynamic>? _uiJson;
  bool _loading = true;
  String? _error;

  int _fetchMs = 0;
  int _renderMs = 0;
  final _fetchStopwatch = Stopwatch();
  final _renderStopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  Future<void> _loadScreen() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await JsonBinService.fetchScreen(widget.binId);

      setState(() {
        _uiJson = result.json;
        _fetchMs = result.fetchMs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Logger().i(
      'Building SduiScreen with state: loading=$_loading, error=$_error, fetchMs=$_fetchMs',
    );
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadScreen,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ Measure render time around the build call
    _renderStopwatch.reset();
    _renderStopwatch.start();

    // ✅ Correct API: Stac.fromJson(jsonString, context) → returns Widget
    // final jsonString = jsonEncode(_uiJson);
    final sduiWidget = Stac.fromJson(_uiJson, context);

    _renderStopwatch.stop();
    _renderMs = _renderStopwatch.elapsedMilliseconds;
    log(
      '🌐 Fetch: ${_fetchMs}ms | 📐 Parse+Render: ${_renderMs}ms | ⚡ Total: ${_fetchMs + _renderMs}ms',
    );

    return Stack(
      children: [
        ?sduiWidget, // ✅ This is already a Flutter Widget — no type mismatch
        Positioned(
          bottom: 16,
          right: 16,
          child: _MetricsBadge(fetchMs: _fetchMs, renderMs: _renderMs),
        ),
      ],
    );
  }
}

class _MetricsBadge extends StatefulWidget {
  final int fetchMs;
  final int renderMs;
  const _MetricsBadge({required this.fetchMs, required this.renderMs});

  @override
  State<_MetricsBadge> createState() => _MetricsBadgeState();
}

class _MetricsBadgeState extends State<_MetricsBadge> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: _expanded
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SDUI Metrics',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '🌐 Fetch: ${widget.fetchMs}ms',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '📐 Render: ${widget.renderMs}ms',
                    style: const TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '⚡ Total: ${widget.fetchMs + widget.renderMs}ms',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              )
            : const Text('📊', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
