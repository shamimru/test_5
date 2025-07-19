import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usage_stats/usage_stats.dart';

class Appusagesdetails extends StatefulWidget {
  const Appusagesdetails({super.key, required this.app});

  final Application app;

  @override
  State<Appusagesdetails> createState() => _AppusagesdetailsState();
}

class _AppusagesdetailsState extends State<Appusagesdetails> {
  UsageInfo? appUsageInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUsage();
  }

  Future<void> getUsage() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day);

    try {
      List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startDate, endDate);

      for (var el in usageStats) {
        if (el.packageName == widget.app.packageName) {
          appUsageInfo = el;
          break;
        }
      }

      if (appUsageInfo != null) {
        debugPrint("Found usage for: ${appUsageInfo!.packageName}");
      } else {
        debugPrint("No usage data found for ${widget.app.packageName}");
      }
    } catch (e) {
      debugPrint("Error fetching usage stats: $e");
    }

    setState(() => isLoading = false);
  }

  String formatUsageTime(String? millis) {
    if (millis == null || millis.isEmpty) return "No usage data";
    double minutes = int.parse(millis) / 1000 / 60;
    return "${minutes.toStringAsFixed(2)} min";
  }

  String formatLastUsed(String? millis) {
    if (millis == null || millis.isEmpty) return "No last used data available";
    try {
      int timestamp = int.parse(millis);
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateFormat("dd-MM-yyyy HH:mm:ss").format(dateTime);
    } catch (e) {
      return "Invalid last used timestamp";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("${widget.app.appName} Usage Details"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            InfoCard(
              title: "Package",
              content: appUsageInfo?.packageName ?? "No package found",
            ),
            const SizedBox(height: 15),
            InfoCard(
              title: "Usage Time",
              content: formatUsageTime(appUsageInfo?.totalTimeInForeground),
            ),
            const SizedBox(height: 15),
            InfoCard(
              title: "Last Time Used",
              content: formatLastUsed(appUsageInfo?.lastTimeUsed),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "$title: $content",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
