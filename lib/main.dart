import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // For web: Remove the # from URLs for better PWA experience
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  
  runApp(const PeeMeterApp());
}

class PeeMeterApp extends StatelessWidget {
  const PeeMeterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pee Meter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        // Optimize for mobile web
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Better PWA support
      debugShowCheckedModeBanner: false,
      home: const PeeMeterHome(),
    );
  }
}

class PeeMeterHome extends StatefulWidget {
  const PeeMeterHome({super.key});

  @override
  State<PeeMeterHome> createState() => _PeeMeterHomeState();
}

class _PeeMeterHomeState extends State<PeeMeterHome> {
  int _todayCount = 0;
  List<String> _recentTimestamps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final savedDate = prefs.getString('last_date') ?? '';
    
    setState(() {
      if (savedDate == today) {
        _todayCount = prefs.getInt('today_count') ?? 0;
        _recentTimestamps = prefs.getStringList('timestamps') ?? [];
      } else {
        // New day, reset count but keep history
        _todayCount = 0;
        _recentTimestamps = [];
        prefs.setString('last_date', today);
        prefs.setInt('today_count', 0);
        prefs.setStringList('timestamps', []);
      }
      _isLoading = false;
    });
  }

  Future<void> _incrementCount() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final timestamp = DateFormat('HH:mm:ss').format(now);
    final today = DateFormat('yyyy-MM-dd').format(now);
    
    setState(() {
      _todayCount++;
      _recentTimestamps.insert(0, timestamp);
      if (_recentTimestamps.length > 10) {
        _recentTimestamps = _recentTimestamps.sublist(0, 10);
      }
    });
    
    await prefs.setInt('today_count', _todayCount);
    await prefs.setStringList('timestamps', _recentTimestamps);
    await prefs.setString('last_date', today);
    
    // Add to all-time history
    final allTimeCount = prefs.getInt('all_time_count') ?? 0;
    await prefs.setInt('all_time_count', allTimeCount + 1);
  }

  Future<void> _resetCount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Count?'),
        content: const Text('Are you sure you want to reset today\'s count?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _todayCount = 0;
        _recentTimestamps = [];
      });
      await prefs.setInt('today_count', 0);
      await prefs.setStringList('timestamps', []);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pee Meter 💧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCount,
            tooltip: 'Reset Count',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Today\'s Count',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 20),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade100,
                  border: Border.all(color: Colors.blue.shade400, width: 4),
                ),
                child: Center(
                  child: Text(
                    '$_todayCount',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _incrementCount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 24,
                  ),
                  textStyle: const TextStyle(fontSize: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('I Peed! 🚽'),
              ),
              const SizedBox(height: 40),
              if (_recentTimestamps.isNotEmpty) ...[
                const Text(
                  'Recent Times',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _recentTimestamps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${index + 1}. ${_recentTimestamps[index]}',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
