import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'catalog.dart';

const lessonSamples = <String, List<String>>{
  'HTML': [
    'Introduction to HTML & Installing VS Code',
    'HTML Syntax & Structure',
    'Heading Tags, DOCTYPE & Comments',
    'Paragraph, Break, hr & Pre Tags',
    'Text Formatting Tags',
    'HTML Attributes',
    'Anchor Tags and Links',
    'Image Tags',
    'HTML Tables',
    'HTML Forms',
  ],
  'NextJS full course': [
    'What is NextJS',
    'Setting up NextJS Project',
    'Routing and Dynamic Routing',
    'Client Side Data Fetching',
    'Server Side Data Fetching',
    'Static Site Generation',
    'Authentication in NextJS',
    'Deploying NextJS Application',
  ],
  'Go programming Tutorial': [
    'Introduction to Go',
    'Types, Comments, Identifiers and Tokens',
    'Variables and Constants',
    'If, Else and Switch',
    'Loops',
    'Functions',
    'Arrays and Slices',
    'Maps',
  ],
};

class PracticeQuestion {
  const PracticeQuestion(this.prompt, this.options, this.answer, this.explanation);
  final String prompt;
  final List<String> options;
  final int answer;
  final String explanation;
}

const questionBank = <String, List<PracticeQuestion>>{
  'Web Development': [
    PracticeQuestion('Which HTML element creates a hyperlink?', ['<link>', '<a>', '<href>', '<url>'], 1, 'The anchor element, <a>, links to another location.'),
    PracticeQuestion('Which HTTP method typically retrieves a resource?', ['POST', 'DELETE', 'GET', 'PATCH'], 2, 'GET is used to request a resource.'),
    PracticeQuestion('What does CSS primarily control?', ['Database tables', 'Page styling', 'Server routing', 'User authentication'], 1, 'CSS controls layout and appearance.'),
    PracticeQuestion('What is a responsive layout designed to do?', ['Adapt to different screen sizes', 'Store user accounts', 'Compile JavaScript', 'Encrypt requests'], 0, 'Responsive layouts adapt to available screen space.'),
  ],
  'Programming': [
    PracticeQuestion('What does a function primarily help you do?', ['Repeat reusable logic', 'Install an OS', 'Increase screen brightness', 'Create a database automatically'], 0, 'Functions group reusable behavior.'),
    PracticeQuestion('Which structure usually stores a sequence of values?', ['Array or list', 'Comment', 'Boolean', 'Exception'], 0, 'Arrays and lists hold collections of values.'),
    PracticeQuestion('What does a conditional statement do?', ['Chooses a branch based on a condition', 'Always repeats forever', 'Downloads a package', 'Changes file encoding'], 0, 'A conditional chooses code to execute.'),
    PracticeQuestion('Why handle exceptions?', ['To respond to errors predictably', 'To remove all tests', 'To change syntax', 'To hide all warnings'], 0, 'Error handling makes failures manageable.'),
  ],
  'Mobile Development': [
    PracticeQuestion('Which language is primarily used by Flutter?', ['Dart', 'PHP', 'SQL', 'Swift only'], 0, 'Flutter apps are written in Dart.'),
    PracticeQuestion('In Flutter, what describes part of the interface?', ['Widget', 'Schema', 'Port', 'Commit'], 0, 'Flutter interfaces are built from widgets.'),
    PracticeQuestion('Why use responsive layouts in a mobile app?', ['To support varying screen sizes', 'To avoid authentication', 'To remove images', 'To replace tests'], 0, 'Devices vary in width and accessibility settings.'),
    PracticeQuestion('What should a loading state communicate?', ['Work is in progress', 'The task is complete', 'An error must have happened', 'The app is offline'], 0, 'A loading indicator communicates pending work.'),
  ],
  'AI & Data': [
    PracticeQuestion('What is training data used for?', ['Teaching a model patterns', 'Changing phone brightness', 'Hosting a website', 'Deleting predictions'], 0, 'A model learns from examples in training data.'),
    PracticeQuestion('What is an evaluation set for?', ['Estimating performance on unseen examples', 'Renaming the model', 'Adding UI colors', 'Compressing images'], 0, 'Evaluation uses data outside model training.'),
    PracticeQuestion('What does overfitting mean?', ['Good training fit but weak generalization', 'No training data', 'A faster network', 'A database error'], 0, 'An overfit model memorizes training details.'),
    PracticeQuestion('Why clean a dataset?', ['To improve quality and consistency', 'To make it secret', 'To remove every row', 'To increase file size'], 0, 'Cleaning addresses missing, duplicate or invalid values.'),
  ],
  'Design': [
    PracticeQuestion('What is visual hierarchy?', ['Guiding attention using size and contrast', 'A database relationship', 'An export format', 'A font license'], 0, 'Hierarchy helps users scan important content first.'),
    PracticeQuestion('Why should buttons have adequate contrast?', ['To improve readability', 'To reduce file size', 'To disable accessibility', 'To make networking faster'], 0, 'Adequate contrast makes controls easier to perceive.'),
    PracticeQuestion('What is a wireframe?', ['A basic layout sketch', 'An image compressor', 'A production server', 'A login method'], 0, 'Wireframes map layout and structure.'),
    PracticeQuestion('What does consistent spacing improve?', ['Clarity and rhythm', 'Battery voltage', 'Database speed', 'Password strength'], 0, 'Consistent spacing creates predictable structure.'),
  ],
  'Marketing': [
    PracticeQuestion('What is a call to action?', ['A prompt to take a next step', 'An ad billing method', 'A chart type', 'A login token'], 0, 'A CTA suggests a clear next action.'),
    PracticeQuestion('What is engagement rate used to describe?', ['Audience interactions relative to reach or followers', 'Device storage', 'Video resolution', 'Network latency'], 0, 'Engagement measures interaction with content.'),
    PracticeQuestion('Why define a target audience?', ['To tailor the message', 'To remove analytics', 'To block comments', 'To increase image size'], 0, 'Audience needs guide content choices.'),
    PracticeQuestion('What can A/B testing compare?', ['Two variants of a campaign', 'Two passwords', 'Two databases only', 'Two operating systems only'], 0, 'A/B tests compare variants against a goal.'),
  ],
  'Security': [
    PracticeQuestion('What does multi-factor authentication add?', ['Another verification factor', 'A larger screen', 'A new domain', 'A video codec'], 0, 'MFA requires an extra form of verification.'),
    PracticeQuestion('What is phishing?', ['A deceptive attempt to obtain information', 'A backup method', 'A secure protocol', 'A code formatter'], 0, 'Phishing uses deceptive messages or sites.'),
    PracticeQuestion('Why install security updates?', ['To address known vulnerabilities', 'To remove backups', 'To share credentials', 'To disable logs'], 0, 'Updates often fix security vulnerabilities.'),
    PracticeQuestion('What is least privilege?', ['Give only necessary permissions', 'Share one account', 'Disable all passwords', 'Grant everyone admin access'], 0, 'Least privilege limits access to what is needed.'),
  ],
  'Testing': [
    PracticeQuestion('What does a unit test check?', ['A small unit of behavior', 'The full production network', 'A logo license', 'A marketing campaign'], 0, 'Unit tests focus on small components.'),
    PracticeQuestion('What is regression testing?', ['Checking prior behavior after changes', 'Deleting old tests', 'Measuring screen brightness', 'Testing only new features'], 0, 'Regression tests detect broken existing behavior.'),
    PracticeQuestion('What should a bug report include?', ['Steps to reproduce and expected result', 'Only a screenshot', 'Only a title', 'A password'], 0, 'Reproduction steps make a defect actionable.'),
    PracticeQuestion('Why test edge cases?', ['To catch boundary behavior', 'To skip common paths', 'To avoid documentation', 'To hide failures'], 0, 'Boundary inputs often expose problems.'),
  ],
};

CollectionReference<Map<String, dynamic>> practiceCollection() =>
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('practice');

class PracticePage extends StatefulWidget {
  const PracticePage({super.key, required this.course});
  final Course course;
  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  int index = 0;
  final Map<int, int> choices = {};
  bool submitted = false;
  bool saving = false;
  bool saved = false;
  late final List<PracticeQuestion> questions = questionBank[widget.course.category] ?? questionBank['Programming']!;
  int get score => List.generate(questions.length, (i) => choices[i] == questions[i].answer ? 1 : 0).fold(0, (a, b) => a + b);

  Future<void> finish() async {
    if (choices.length != questions.length) return;
    setState(() { submitted = true; saving = true; });
    try {
      final reference = practiceCollection().doc(widget.course.id);
      final previous = await reference.get();
      final best = previous.data()?['bestScore'];
      await reference.set({
        'title': widget.course.title,
        'category': widget.course.category,
        'bestScore': best is int && best > score ? best : score,
        'latestScore': score,
        'total': questions.length,
        'attempts': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) setState(() => saved = true);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Score could not sync. Check your connection and try again.')));
    } finally { if (mounted) setState(() => saving = false); }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[index];
    return Scaffold(
      appBar: AppBar(title: const Text('Practice quiz')),
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(22), children: [
        Text(widget.course.title, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
        const SizedBox(height: 5), const Text('Independent practice • Not an official LMS quiz', style: TextStyle(color: Color(0xFF637E70))),
        const SizedBox(height: 22),
        LinearProgressIndicator(value: submitted ? 1 : (index + 1) / questions.length, minHeight: 7, borderRadius: BorderRadius.circular(12)),
        const SizedBox(height: 26),
        if (submitted) ...[
          Icon(score >= 3 ? Icons.emoji_events_outlined : Icons.refresh, size: 60, color: const Color(0xFF19A875)),
          const SizedBox(height: 14),
          Center(child: Text('$score / ${questions.length} correct', style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w900))),
          const SizedBox(height: 10),
          Center(child: Text(saved ? 'Score saved to your learning space' : saving ? 'Saving your score…' : 'Score not synced yet', textAlign: TextAlign.center)),
          const SizedBox(height: 18),
          for (var i = 0; i < questions.length; i++) Card(child: Padding(padding: const EdgeInsets.all(15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${i + 1}. ${questions[i].prompt}', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 7), Text(choices[i] == questions[i].answer ? 'Correct' : 'Answer: ${questions[i].options[questions[i].answer]}', style: TextStyle(color: choices[i] == questions[i].answer ? Colors.green : Colors.deepOrange)), Text(questions[i].explanation)]))),
          const SizedBox(height: 12), if (!saved && !saving) OutlinedButton(onPressed: finish, child: const Text('Retry saving score')),
          FilledButton(onPressed: () => setState(() { index = 0; choices.clear(); submitted = false; saved = false; }), child: const Text('Try again')),
        ] else ...[
          Text('QUESTION ${index + 1} OF ${questions.length}', style: const TextStyle(color: Color(0xFF19A875), fontWeight: FontWeight.w800, letterSpacing: 1)),
          const SizedBox(height: 12), Text(question.prompt, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),
          for (var i = 0; i < question.options.length; i++) Padding(padding: const EdgeInsets.only(bottom: 9), child: Card(color: choices[index] == i ? const Color(0xFFDDF4E8) : Colors.white, child: ListTile(onTap: () => setState(() => choices[index] = i), leading: Icon(choices[index] == i ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: const Color(0xFF19A875)), title: Text(question.options[i])))),
          const SizedBox(height: 18), Row(children: [
            if (index > 0) OutlinedButton(onPressed: () => setState(() => index--), child: const Text('Back')),
            const Spacer(), FilledButton(onPressed: choices[index] == null ? null : index == questions.length - 1 ? finish : () => setState(() => index++), child: Text(index == questions.length - 1 ? 'See results' : 'Next')),
          ]),
        ],
      ])),
    );
  }
}
