import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'catalog.dart';
import 'learning.dart';
import 'portal.dart';

const green = Color(0xFF19A875);
const dark = Color(0xFF092C24);
const bg = Color(0xFFF5F8F5);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(const InterneeApp());
  } catch (error) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_outlined,
                      size: 56, color: Color(0xFF19A875)),
                  const SizedBox(height: 16),
                  const Text('Firebase setup is needed',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text(
                    'Configure Firebase for this Android application, then restart the app. See README.md for the setup steps.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  SelectableText(error.toString(), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class InterneeApp extends StatelessWidget {
  const InterneeApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Internee Portal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: bg,
          colorScheme: ColorScheme.fromSeed(
              seedColor: green, primary: green, surface: Colors.white),
          appBarTheme: const AppBarTheme(
              backgroundColor: bg, foregroundColor: dark, elevation: 0),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          ),
        ),
        home: const AuthGate(),
      );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          return snapshot.data == null ? const AuthScreen() : const HomeShell();
        },
      );
}

class Brand extends StatelessWidget {
  const Brand({super.key, this.light = false});
  final bool light;
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: light ? Colors.white : green,
                borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.school_rounded,
                size: 22, color: light ? green : Colors.white)),
        const SizedBox(width: 9),
        Text('internee',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
                color: light ? Colors.white : dark)),
        Text('.pk',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
                color: light ? const Color(0xFF8EEDC8) : green)),
      ]);
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  bool register = false;
  bool busy = false;
  bool obscure = true;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      if (register) {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: password.text);
        await credential.user!.updateDisplayName(name.text.trim());
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'createdAt': FieldValue.serverTimestamp()
        });
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) showMessage(context, authError(e));
    } catch (_) {
      if (mounted)
        showMessage(
            context, 'Could not complete the request. Please try again.');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> reset() async {
    if (email.text.trim().isEmpty) {
      showMessage(context, 'Enter your email first.');
      return;
    }
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim());
      if (mounted) showMessage(context, 'Password reset email sent.');
    } on FirebaseAuthException catch (e) {
      if (mounted) showMessage(context, authError(e));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Form(
                          key: form,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Brand(),
                                const SizedBox(height: 42),
                                Text(
                                    register
                                        ? 'Start your journey.'
                                        : 'Welcome back.',
                                    style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        color: dark,
                                        letterSpacing: -1.6)),
                                const SizedBox(height: 10),
                                Text(
                                    register
                                        ? 'Create your account to discover and save courses.'
                                        : 'Pick up where your learning journey left off.',
                                    style: const TextStyle(
                                        color: Color(0xFF6D8179),
                                        fontSize: 15)),
                                const SizedBox(height: 34),
                                if (register) ...[
                                  TextFormField(
                                      controller: name,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: const InputDecoration(
                                          labelText: 'Full name',
                                          prefixIcon:
                                              Icon(Icons.person_outline)),
                                      validator: (v) =>
                                          (v == null || v.trim().length < 2)
                                              ? 'Enter your name'
                                              : null),
                                  const SizedBox(height: 14)
                                ],
                                TextFormField(
                                    controller: email,
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.email],
                                    decoration: const InputDecoration(
                                        labelText: 'Email address',
                                        prefixIcon: Icon(Icons.mail_outline)),
                                    validator: (v) => v == null ||
                                            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                                .hasMatch(v.trim())
                                        ? 'Enter a valid email'
                                        : null),
                                const SizedBox(height: 14),
                                TextFormField(
                                    controller: password,
                                    obscureText: obscure,
                                    autofillHints: [
                                      register
                                          ? AutofillHints.newPassword
                                          : AutofillHints.password
                                    ],
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon:
                                            const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                            onPressed: () => setState(
                                                () => obscure = !obscure),
                                            icon: Icon(obscure
                                                ? Icons.visibility_outlined
                                                : Icons
                                                    .visibility_off_outlined))),
                                    validator: (v) => v == null || v.length < 6
                                        ? 'Use at least 6 characters'
                                        : null),
                                if (!register)
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                          onPressed: reset,
                                          child:
                                              const Text('Forgot password?'))),
                                const SizedBox(height: 22),
                                SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: FilledButton(
                                        onPressed: busy ? null : submit,
                                        child: busy
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white))
                                            : Text(
                                                register
                                                    ? 'Create account'
                                                    : 'Sign in',
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)))),
                                const SizedBox(height: 20),
                                Center(
                                    child: TextButton(
                                        onPressed: () => setState(
                                            () => register = !register),
                                        child: Text(register
                                            ? 'Already have an account? Sign in'
                                            : 'New here? Create an account'))),
                                const SizedBox(height: 30),
                                const Center(
                                    child: Text(
                                        'Discover courses. Build skills. Grow your future.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF82948D),
                                            fontSize: 12))),
                              ])))))));
}

String authError(FirebaseAuthException e) => switch (e.code) {
      'email-already-in-use' => 'This email already has an account.',
      'invalid-email' => 'Please check your email address.',
      'weak-password' => 'Please choose a stronger password.',
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' =>
        'Email or password is incorrect.',
      'network-request-failed' =>
        'Check your internet connection and try again.',
      _ => e.message ?? 'Authentication failed. Please try again.',
    };

void showMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int tab = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: IndexedStack(index: tab, children: const [
          DiscoverPage(),
          SavedPage(),
          LearningPage(),
          ProfilePage()
        ])),
        bottomNavigationBar: NavigationBar(
            selectedIndex: tab,
            onDestinationSelected: (v) => setState(() => tab = v),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: 'Discover'),
              NavigationDestination(
                  icon: Icon(Icons.bookmark_border),
                  selectedIcon: Icon(Icons.bookmark),
                  label: 'Saved'),
              NavigationDestination(
                  icon: Icon(Icons.insights_outlined),
                  selectedIcon: Icon(Icons.insights),
                  label: 'Learning'),
              NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile'),
            ]),
      );
}

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  String query = '';
  String category = 'All';
  @override
  Widget build(BuildContext context) {
    final visible = courses
        .where((c) =>
            (category == 'All' || category == c.category) &&
            ('${c.title} ${c.category}'
                .toLowerCase()
                .contains(query.toLowerCase())))
        .toList();
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Brand(),
                    const SizedBox(height: 30),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                            color: dark,
                            borderRadius: BorderRadius.circular(26)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('YOUR NEXT CHAPTER STARTS HERE',
                                  style: TextStyle(
                                      color: Color(0xFF95E9C9),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.4)),
                              const SizedBox(height: 12),
                              const Text(
                                  'Build skills.\nGet experience.\nLand your job.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 31,
                                      fontWeight: FontWeight.w900,
                                      height: 1.15,
                                      letterSpacing: -0.7)),
                              const SizedBox(height: 14),
                              const Text(
                                  'Explore learning opportunities from Internee.pk.',
                                  style: TextStyle(color: Color(0xFFBDCEC7))),
                              const SizedBox(height: 20),
                              const Wrap(spacing: 9, runSpacing: 9, children: [
                                HeroTag(
                                    icon: Icons.menu_book_outlined,
                                    label: '29 courses'),
                                HeroTag(
                                    icon: Icons.bolt_outlined,
                                    label: 'Learn at your pace')
                              ]),
                            ])),
                    const SizedBox(height: 28),
                    const Text('Explore courses',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: dark)),
                    const SizedBox(height: 14),
                    TextField(
                        onChanged: (v) => setState(() => query = v),
                        decoration: const InputDecoration(
                            hintText: 'Search courses or topics',
                            prefixIcon: Icon(Icons.search))),
                    const SizedBox(height: 16),
                    SizedBox(
                        height: 43,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, i) {
                              final value = categories[i];
                              return ChoiceChip(
                                  label: Text(value),
                                  selected: category == value,
                                  onSelected: (_) =>
                                      setState(() => category = value));
                            })),
                    const SizedBox(height: 18),
                    Text(
                        '${visible.length} ${visible.length == 1 ? 'course' : 'courses'}',
                        style: const TextStyle(
                            color: Color(0xFF70827A),
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                  ]))),
      if (visible.isEmpty)
        const SliverFillRemaining(
            child: Center(child: Text('No courses match your search.')))
      else
        SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.builder(
                itemCount: visible.length,
                itemBuilder: (context, i) => CourseTile(course: visible[i]))),
    ]);
  }
}

class HeroTag extends StatelessWidget {
  const HeroTag({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xFF1D4B3D),
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 15, color: const Color(0xFF9AE7C5)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white))
      ]));
}

CollectionReference<Map<String, dynamic>> savedCollection() =>
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('saved');

class CourseTile extends StatelessWidget {
  const CourseTile({super.key, required this.course});
  final Course course;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => CourseDetail(course: course))),
              child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Row(children: [
                    Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                            color: const Color(0xFFE6F5EE),
                            borderRadius: BorderRadius.circular(16)),
                        child: Icon(course.icon, color: green, size: 30)),
                    const SizedBox(width: 15),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(course.category.toUpperCase(),
                              style: const TextStyle(
                                  color: green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.7)),
                          const SizedBox(height: 5),
                          Text(course.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: dark)),
                          const SizedBox(height: 5),
                          const Text('Internee.pk learning catalog',
                              style: TextStyle(
                                  color: Color(0xFF81928A), fontSize: 11))
                        ])),
                    const Icon(Icons.chevron_right, color: Color(0xFF9EADA6)),
                  ])))));
}

class CourseDetail extends StatelessWidget {
  const CourseDetail({super.key, required this.course});
  final Course course;
  void openOfficial(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LearningPortalPage(title: course.title)));
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Brand()),
      body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(22), children: [
        Container(
            height: 170,
            decoration: BoxDecoration(
                color: dark, borderRadius: BorderRadius.circular(26)),
            child: Center(
                child: Icon(course.icon,
                    color: const Color(0xFF9AE7C5), size: 82))),
        const SizedBox(height: 25),
        Text(course.category.toUpperCase(),
            style: const TextStyle(
                color: green,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1)),
        const SizedBox(height: 9),
        Text(course.title,
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: dark,
                height: 1.16)),
        const SizedBox(height: 12),
        const Text('Listed on Internee.pk learning portal',
            style: TextStyle(color: Color(0xFF778B80))),
        const SizedBox(height: 28),
        const Text('About this course',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, color: dark)),
        const SizedBox(height: 9),
        Text(course.description,
            style: const TextStyle(
                color: Color(0xFF60786B), height: 1.5, fontSize: 16)),
        if (lessonSamples.containsKey(course.title)) ...[
          const SizedBox(height: 26),
          const Text('Curriculum preview',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: dark)),
          const SizedBox(height: 5),
          const Text('Selected lesson titles from the public LMS page',
              style: TextStyle(color: Color(0xFF70827A))),
          const SizedBox(height: 12),
          for (var i = 0; i < lessonSamples[course.title]!.length; i++)
            Card(
                child: ListTile(
                    leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0xFFE6F5EE),
                        child: Text('${i + 1}',
                            style:
                                const TextStyle(color: green, fontSize: 12))),
                    title: Text(lessonSamples[course.title]![i],
                        style: const TextStyle(fontSize: 13)),
                    trailing: const Icon(Icons.open_in_new, size: 16),
                    onTap: () => openOfficial(context))),
        ],
        const SizedBox(height: 25),
        Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
                color: const Color(0xFFE8F5EE),
                borderRadius: BorderRadius.circular(16)),
            child: const Text(
                'Course enrollment and lessons are available on the official Internee.pk website. Your account in this app is separate.',
                style: TextStyle(color: dark, height: 1.4))),
        const SizedBox(height: 25),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: savedCollection().doc(course.id).snapshots(),
            builder: (context, snapshot) {
              final saved = snapshot.data?.exists ?? false;
              return OutlinedButton.icon(
                  onPressed: () async {
                    try {
                      if (saved) {
                        await savedCollection().doc(course.id).delete();
                      } else {
                        await savedCollection().doc(course.id).set({
                          'title': course.title,
                          'savedAt': FieldValue.serverTimestamp()
                        });
                      }
                    } catch (_) {
                      if (context.mounted)
                        showMessage(context,
                            'Could not update saved courses. Check your connection.');
                    }
                  },
                  icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                  label: Text(saved ? 'Remove from saved' : 'Save course'));
            }),
        const SizedBox(height: 10),
        OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PracticePage(course: course))),
            icon: const Icon(Icons.quiz_outlined),
            label: const Text('Take a practice quiz')),
        const SizedBox(height: 10),
        FilledButton.icon(
            onPressed: () => openOfficial(context),
            icon: const Icon(Icons.play_circle_outline),
            label: const Text('Open official learning portal')),
      ])));
}

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) =>
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: practiceCollection().snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Could not load practice progress. Check Firestore rules.',
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final records = snapshot.data!.docs;

          final attempts = records.fold<int>(
            0,
            (total, doc) =>
                total + ((doc.data()['attempts'] as num?)?.toInt() ?? 0),
          );

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 12),
              const Text(
                'My learning',
                style: TextStyle(
                  color: dark,
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Your independent practice activity',
                style: TextStyle(
                  color: Color(0xFF70827A),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: dark,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${records.length}',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            'Topics practiced',
                            style: TextStyle(
                              color: Color(0xFFC4E7D7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$attempts',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            'Quiz attempts',
                            style: TextStyle(
                              color: Color(0xFFC4E7D7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (records.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 55),
                  child: Column(
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 58,
                        color: green,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Your practice starts here',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Open a course and take its practice quiz.',
                      ),
                    ],
                  ),
                )
              else
                ...records.map((record) {
                  final data = record.data();

                  Course? course;

                  for (final candidate in courses) {
                    if (candidate.id == record.id) {
                      course = candidate;
                      break;
                    }
                  }

                  final latest = (data['latestScore'] as num?)?.toInt() ?? 0;

                  final total = (data['total'] as num?)?.toInt() ?? 4;

                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: const Icon(
                        Icons.auto_graph,
                        color: green,
                      ),
                      title: Text(
                        data['title'] as String? ?? record.id,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Latest practice: $latest/$total • '
                        'Best: ${data['bestScore'] ?? 0}/$total',
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: course == null
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CourseDetail(
                                    course: course!,
                                  ),
                                ),
                              );
                            },
                    ),
                  );
                }),
              const SizedBox(height: 20),
              const Text(
                'Practice scores are stored in your account. '
                'Official LMS enrollment, videos, quizzes and certificates '
                'are managed on Internee.pk.',
                style: TextStyle(
                  color: Color(0xFF70827A),
                  height: 1.5,
                ),
              ),
            ],
          );
        },
      );
}

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});
  @override
  Widget build(BuildContext context) =>
      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: savedCollection().snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return const Center(
                  child: Text(
                      'Could not load saved courses. Check Firestore rules.'));
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());
            final ids = snapshot.data!.docs.map((d) => d.id).toSet();
            final items = courses.where((c) => ids.contains(c.id)).toList();
            return ListView(padding: const EdgeInsets.all(20), children: [
              const SizedBox(height: 10),
              const Text('Saved courses',
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w900, color: dark)),
              const SizedBox(height: 5),
              const Text('Keep interesting courses close.',
                  style: TextStyle(color: Color(0xFF70827A))),
              const SizedBox(height: 25),
              if (items.isEmpty)
                const Padding(
                    padding: EdgeInsets.only(top: 95),
                    child: Column(children: [
                      Icon(Icons.bookmark_border, size: 58, color: green),
                      SizedBox(height: 15),
                      Text('Nothing saved yet',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text('Discover courses and bookmark your favorites.')
                    ]))
              else
                ...items.map((c) => CourseTile(course: c))
            ]);
          });
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return ListView(padding: const EdgeInsets.all(22), children: [
      const SizedBox(height: 12),
      const Brand(),
      const SizedBox(height: 45),
      CircleAvatar(
          radius: 37,
          backgroundColor: const Color(0xFFE0F4E9),
          child: Text(
              (user.displayName?.isNotEmpty == true
                      ? user.displayName!
                      : user.email ?? 'U')
                  .substring(0, 1)
                  .toUpperCase(),
              style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold, color: green))),
      const SizedBox(height: 15),
      Center(
          child: Text(
              user.displayName?.isNotEmpty == true
                  ? user.displayName!
                  : 'Learner',
              style: const TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w900, color: dark))),
      const SizedBox(height: 4),
      Center(
          child: Text(user.email ?? '',
              style: const TextStyle(color: Color(0xFF71867B)))),
      const SizedBox(height: 38),
      Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your learning space',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: dark)),
                SizedBox(height: 8),
                Text(
                    'Find a path that fits your goals. Save courses here, and continue on the official Internee.pk learning portal.',
                    style: TextStyle(color: Color(0xFF70827A), height: 1.5))
              ])),
      const SizedBox(height: 23),
      OutlinedButton.icon(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sign out')),
    ]);
  }
}
