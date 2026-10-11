import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LearningPortalPage extends StatefulWidget {
  const LearningPortalPage({super.key, required this.title});
  final String title;
  @override
  State<LearningPortalPage> createState() => _LearningPortalPageState();
}

class _LearningPortalPageState extends State<LearningPortalPage> {
  late final WebViewController controller;
  int loading = 0;
  bool failed = false;
  static final home = Uri.parse('https://learn.internee.pk/home/courses');

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (value) { if (mounted) setState(() => loading = value); },
        onWebResourceError: (error) {
          if (error.isForMainFrame == true && mounted) setState(() => failed = true);
        },
        onNavigationRequest: (request) {
          final uri = Uri.tryParse(request.url);
          if (uri == null) return NavigationDecision.prevent;
          if (uri.scheme == 'https' && (uri.host == 'internee.pk' || uri.host.endsWith('.internee.pk'))) return NavigationDecision.navigate;
          if (uri.scheme == 'https') launchUrl(uri, mode: LaunchMode.externalApplication);
          return NavigationDecision.prevent;
        },
      ))
      ..loadRequest(home);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title, overflow: TextOverflow.ellipsis), actions: [
      IconButton(tooltip: 'Reload', onPressed: () { setState(() => failed = false); controller.reload(); }, icon: const Icon(Icons.refresh)),
      IconButton(tooltip: 'Open in browser', onPressed: () => launchUrl(home, mode: LaunchMode.externalApplication), icon: const Icon(Icons.open_in_browser)),
    ]),
    body: Column(children: [
      if (loading < 100) LinearProgressIndicator(value: loading / 100),
      Container(width: double.infinity, color: const Color(0xFFE7F5EC), padding: const EdgeInsets.all(10), child: const Text('Official Internee.pk LMS • Sign in there separately for lessons and enrollment.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12))),
      Expanded(child: failed ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.wifi_off, size: 50), const SizedBox(height: 12),
        const Text('Could not load the learning portal.'), const SizedBox(height: 10),
        FilledButton(onPressed: () { setState(() => failed = false); controller.loadRequest(home); }, child: const Text('Try again')),
      ])) : WebViewWidget(controller: controller)),
    ]),
  );
}
