import 'package:flutter/material.dart';
import '../../data/models/career_milestone.dart';
import '../../data/models/project_model.dart';
import '../../data/models/social_link.dart';
// ignore_for_file: prefer_const_constructors

class AppContent {
  // Personal
  static const String name = 'Satya Prakash';
  static const String email = 'satyaprakash6945@gmail.com';
  static const String githubUrl = 'https://github.com/saty-a';
  static const String linkedInUrl = 'https://linkedin.com/in/saty/';

  // Hero section
  static const String heroGreeting = "I build Flutter apps that ship.";

  static const String heroBio =
      'Flutter Developer with 2+ years building cross-platform apps for Android & iOS. '
      'I work across the full mobile stack — clean architecture, Firebase, native integrations, '
      'and payment gateways — and use AI tooling to ship faster without cutting corners.';

  static const List<MapEntry<String, String>> heroDetails = [
    MapEntry('ROLE', 'Flutter Developer'),
    MapEntry('FOCUS', 'Flutter · Dart · Clean Architecture'),
    MapEntry('LOCATION', 'New Delhi, India'),
    MapEntry('STATUS', 'Open to opportunities'),
  ];

  // Stats row in hero
  static const List<MapEntry<String, String>> heroStats = [
    MapEntry('2+', 'years experience'),
    MapEntry('10K+', 'app downloads'),
    MapEntry('5', 'shipped apps'),
    MapEntry('2', 'open source contribs'),
  ];

  // About column
  static const String aboutIntro =
      'Flutter Developer based in New Delhi. I design and build '
      'cross-platform apps that reach real users — from KYC onboarding flows '
      'to health-tracking platforms and open-source tooling.';

  static const String aboutBio =
      'B.Tech CSE, Roorkee Institute of Technology (UTU), GPA 8.0. '
      'I value clean architecture, measurable impact, and shipping on time.';

  // Role details
  static const List<MapEntry<String, String>> roleDetails = [
    MapEntry('ROLE', 'Flutter Developer: Full mobile layer — UI, state, native integrations, release pipelines.'),
    MapEntry('FOCUS', 'Cross-platform: One codebase, two stores. Flutter with BLoC, Riverpod, or GetX.'),
    MapEntry('STACK', 'Flutter, Dart, Firebase, Razorpay, Cashfree, ZegoCloud, Google Fit, HealthKit, Method Channel.'),
    MapEntry('AI TOOLS', 'Claude Code, GitHub Copilot — used in production. Shipped 2 features 30% faster.'),
  ];

  // Skills by category — consumed by SkillsSection widget
  static const Map<String, List<String>> skillCategories = {
    'Mobile': ['Flutter', 'Dart', 'Android', 'iOS', 'Kotlin', 'Java', 'Swift'],
    'Architecture': ['Clean Architecture', 'BLoC', 'Riverpod', 'GetX', 'MVVM', 'DI'],
    'Backend & APIs': ['Firebase', 'REST APIs', 'Razorpay', 'Cashfree', 'FCM', 'WebRTC'],
    'Native Bridge': ['Method Channel', 'Google Fit', 'HealthKit', 'Google Maps', 'Deep Linking'],
    'Testing & DevOps': ['flutter_test', 'Mockito', 'GitHub Actions', 'Fastlane', 'TestFlight'],
    'AI Tools': ['Claude Code', 'GitHub Copilot', 'Prompt Engineering'],
  };

  // Legacy flat skills list
  static const List<String> skills = [
    'Flutter', 'Dart', 'Android', 'Kotlin', 'Java',
    'Firebase', 'BLoC', 'GetX', 'HealthKit', 'Google Fit',
    'Razorpay', 'Cashfree', 'Method Channel',
  ];

  // Social links (icons hardcoded inline in about_column.dart)
  static const List<SocialLink> socialLinks = [
    SocialLink(platform: 'GitHub', url: githubUrl, icon: Icons.code),
  ];

  // Career milestones — real data from resume
  static const List<CareerMilestone> careerMilestones = [
    CareerMilestone(
      year: '2025',
      title: 'Flutter Developer',
      organization: 'TechShy Private Limited · New Delhi',
      description: 'KYC onboarding (drop-off 38%→18%), real-time chat + FCM reminders, Razorpay/Cashfree payments. Shipped 2 features 30% faster with Claude Code.',
      type: MilestoneType.work,
      employmentType: 'Full-time',
      dateRange: '2025 – Present',
      sortOrder: 0,
    ),
    CareerMilestone(
      year: '2023',
      title: 'Flutter Developer',
      organization: 'Shine Web Solutions · Noida',
      description: 'Android & iOS apps. Method Channel for Google Fit + HealthKit on Pawpular. 25% faster startup, 75% test coverage.',
      type: MilestoneType.work,
      employmentType: 'Full-time',
      dateRange: '2023 – 2025',
      sortOrder: 1,
    ),
    CareerMilestone(
      year: '2022',
      title: 'Mobile Engineer Intern',
      organization: 'Squareboat · Gurugram',
      description: 'Mobile engineering internship building production Flutter apps at Squareboat.',
      type: MilestoneType.work,
      employmentType: 'Internship',
      dateRange: 'Dec 2022 – Jun 2023 ',
      sortOrder: 2,
    ),
    CareerMilestone(
      year: '2023',
      title: 'B.Tech — Computer Science & Engineering',
      organization: 'Roorkee Institute of Technology (UTU)',
      description: 'GPA 8.0/10.0 · Data Structures, Software Engineering, DBMS.',
      type: MilestoneType.education,
      employmentType: 'B.Tech',
      dateRange: '2019 – 2023',
      sortOrder: 4,
    ),
  ];

  // Featured projects
  static const List<Project> featuredProjects = [
    Project(
      title: 'flutter_app_size_reducer',
      shortDescription: 'pub.dev CLI package — only tool of its kind for Flutter app size reduction.',
      longDescription:
          'CLI package that scans Flutter projects for unused assets and removes them automatically. '
          'Achieves 15–30% app size reduction. First and only pub.dev package of its kind.',
      imageUrls: [],
      liveUrl: 'https://pub.dev/packages/flutter_app_size_reducer',
      technologies: ['Dart', 'CLI', 'pub.dev', 'Open Source'],
      category: ProjectCategory.openSource,
      role: 'Author',
      sortOrder: 0,
    ),
    Project(
      title: 'PAWPULAR — Walk to Earn',
      shortDescription: 'Pet health tracking app · 10K+ downloads on Android & iOS.',
      tagline: 'Walk your dog. Earn rewards. Track health.',
      longDescription:
          'Native step tracking via Method Channel (Google Fit on Android, HealthKit on iOS), '
          'geolocation-based pet tracking, and gamified rewards system. '
          '25% app startup improvement via lazy loading + memory profiling. 75% test coverage.',
      imageUrls: [
        'https://play-lh.googleusercontent.com/VoajiqefzfF-C-ElZXmxcqcuOHL1FCqUicYkWjXJrBMHQZKQEXuewuaaGaChL4ceNsM=w480-h960-rw',
      ],
      screenshotUrls: [
        'https://play-lh.googleusercontent.com/VoajiqefzfF-C-ElZXmxcqcuOHL1FCqUicYkWjXJrBMHQZKQEXuewuaaGaChL4ceNsM=w480-h960-rw',
      ],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.pawpular.pawpular',
      appStoreUrl: 'https://apps.apple.com/in/app/pawpular-walk-to-earn-rewards/id6447305426',
      technologies: ['Flutter', 'Dart', 'Firebase', 'Method Channel', 'Google Fit', 'HealthKit', 'GetX'],
      category: ProjectCategory.featured,
      role: 'Flutter Developer',
      sortOrder: 1,
      problem:
          'Pet owners had no unified way to track their dog\'s daily activity alongside earning '
          'tangible rewards. Existing health apps ignored pets entirely. The core technical '
          'challenge: Flutter had no native bridge to Google Fit (Android) and HealthKit (iOS) '
          'simultaneously — every existing package covered only one platform.',
      solution:
          'Built a custom dual-platform Method Channel bridge in Kotlin (Google Fit) and Swift '
          '(HealthKit) — the only Flutter app to do both natively. Added a gamified walk-to-earn '
          'rewards engine, geolocation tracking, and a real-time health dashboard. Optimised '
          'startup via lazy loading and memory profiling — 25% faster cold boot.',
      metrics: [
        CaseStudyMetric(value: '10K+', label: 'Downloads', icon: Icons.download_rounded),
        CaseStudyMetric(value: '25%', label: 'Faster Startup', icon: Icons.speed_rounded),
        CaseStudyMetric(value: '75%', label: 'Test Coverage', icon: Icons.verified_rounded),
        CaseStudyMetric(value: '2', label: 'Platforms', icon: Icons.devices_rounded),
      ],
      features: [
        CaseStudyFeature(
          name: 'Dual Health Bridge',
          description: 'Custom Method Channel connects Google Fit on Android and HealthKit on iOS — one codebase, two native SDKs.',
          icon: Icons.favorite_rounded,
        ),
        CaseStudyFeature(
          name: 'Walk-to-Earn Rewards',
          description: 'Gamified step-counting engine tracks daily walks and converts activity into redeemable rewards.',
          icon: Icons.emoji_events_rounded,
        ),
        CaseStudyFeature(
          name: 'Geolocation Tracking',
          description: 'Real-time GPS route mapping for every walk with distance, duration, and pace metrics.',
          icon: Icons.location_on_rounded,
        ),
        CaseStudyFeature(
          name: 'Health Dashboard',
          description: 'Visual charts and weekly trends for steps, calories, and activity streaks — all synced natively.',
          icon: Icons.bar_chart_rounded,
        ),
        CaseStudyFeature(
          name: 'Performance Optimised',
          description: '25% cold-start improvement via lazy loading, image caching, and memory profiling sprints.',
          icon: Icons.speed_rounded,
        ),
        CaseStudyFeature(
          name: 'Cross-Platform CI',
          description: 'Automated testing pipeline with 75% coverage. GitHub Actions builds for both Play Store and App Store.',
          icon: Icons.shield_rounded,
        ),
      ],
    ),
    Project(
      title: 'Laathi — Healthcare & Safety',
      shortDescription: 'Healthcare platform with KYC, real-time chat, medication reminders.',
      tagline: 'Accessible healthcare and safety for every Indian.',
      longDescription:
          'Multi-tier KYC via Cashfree API (95% Aadhaar success rate). '
          'Real-time chat + file sharing (Firebase Firestore). '
          'FCM medication reminders (85% notification engagement). '
          'Razorpay/Cashfree payments. Onboarding drop-off reduced from 38% to 18%.',
      imageUrls: [
        'https://play-lh.googleusercontent.com/gRtr338QpO0H2m7j7IGhvK-5tAqjnnOp1TgDYlO_zeNFFQ1S0rs6LRZj06rzgP-8cQo=w480-h960-rw',
      ],
      screenshotUrls: [
        'https://play-lh.googleusercontent.com/gRtr338QpO0H2m7j7IGhvK-5tAqjnnOp1TgDYlO_zeNFFQ1S0rs6LRZj06rzgP-8cQo=w480-h960-rw',
      ],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=org.techshy.laathi',
      appStoreUrl: 'https://apps.apple.com/in/app/laathi/id6742400530',
      technologies: ['Flutter', 'Dart', 'Firebase', 'Cashfree', 'Razorpay', 'FCM', 'ZegoCloud', 'Clean Architecture'],
      category: ProjectCategory.featured,
      role: 'Flutter Developer',
      sortOrder: 2,
      problem:
          'Healthcare onboarding in India is riddled with friction: 38% of users abandoned '
          'Laathi\'s signup before completing KYC. Medication reminders were unreliable, '
          'in-app support was non-existent, and payments were split across incompatible '
          'gateways — causing transaction failures and user trust issues.',
      solution:
          'Rebuilt onboarding with multi-tier Aadhaar KYC (Cashfree API) achieving 95% '
          'success — drop-off fell from 38% to 18%. Integrated Firebase Firestore for '
          'real-time chat and file sharing. FCM-powered medication reminders hit 85% '
          'engagement. Unified Razorpay and Cashfree under a single payment abstraction '
          'layer. ZegoCloud added live video consultations.',
      metrics: [
        CaseStudyMetric(value: '38%→18%', label: 'Drop-off Reduced', icon: Icons.trending_down_rounded),
        CaseStudyMetric(value: '95%', label: 'KYC Success Rate', icon: Icons.verified_user_rounded),
        CaseStudyMetric(value: '85%', label: 'Notification Engagement', icon: Icons.notifications_active_rounded),
        CaseStudyMetric(value: '2', label: 'Payment Gateways', icon: Icons.payment_rounded),
      ],
      features: [
        CaseStudyFeature(
          name: 'Aadhaar KYC',
          description: 'Multi-tier identity verification via Cashfree API. 95% success rate, onboarding drop-off cut from 38% to 18%.',
          icon: Icons.fingerprint_rounded,
        ),
        CaseStudyFeature(
          name: 'Real-time Chat',
          description: 'Firebase Firestore powered messaging with file sharing, read receipts, and end-to-end encryption.',
          icon: Icons.chat_rounded,
        ),
        CaseStudyFeature(
          name: 'FCM Reminders',
          description: 'Smart medication reminder system using Firebase Cloud Messaging — 85% notification engagement rate.',
          icon: Icons.notifications_active_rounded,
        ),
        CaseStudyFeature(
          name: 'Payment Gateway',
          description: 'Unified Razorpay + Cashfree abstraction handles subscriptions, consultations, and pharmacy orders.',
          icon: Icons.payment_rounded,
        ),
        CaseStudyFeature(
          name: 'Video Consultation',
          description: 'Live doctor-patient video calls via ZegoCloud SDK with waiting room, recording consent, and chat fallback.',
          icon: Icons.videocam_rounded,
        ),
        CaseStudyFeature(
          name: 'Clean Architecture',
          description: 'Domain-driven design with BLoC state management, dependency injection, and 80%+ test coverage.',
          icon: Icons.architecture_rounded,
        ),
      ],
    ),
    Project(
      title: 'Today in History — OZI',
      shortDescription: 'AI-powered history app · 51 countries · daily quizzes, battles & XP rewards.',
      tagline: '50+ countries. AI companion. History battles. Every single day.',
      longDescription:
          'Wikipedia-powered daily history events across 51 countries, with OZI — a Firebase Gemini '
          'AI companion that explains why events mattered. Features real-time multiplayer quiz battles '
          'via Firestore, a complex XP/streak/badge gamification engine, offline-first Hive caching, '
          'IAP subscriptions (monthly/yearly/lifetime), and AdMob monetization. '
          'Clean Architecture · BLoC · 99 Dart files.',
      logoUrl: 'assets/images/ozi/todayinhistory.webp',
      imageUrls: [
        'assets/images/ozi/today-in-history-iphone-01-hero.png',
      ],
      screenshotUrls: [
        'assets/images/ozi/today-in-history-iphone-01-hero.png',
        'assets/images/ozi/today-in-history-iphone-02-anyday.png',
        'assets/images/ozi/today-in-history-iphone-03-scroll.png',
        'assets/images/ozi/today-in-history-iphone-04-ozi.png',
        'assets/images/ozi/today-in-history-iphone-05-trivia.png',
        'assets/images/ozi/today-in-history-iphone-06-battle.png',
        'assets/images/ozi/today-in-history-iphone-07-streak.png',
        'assets/images/ozi/today-in-history-iphone-08-ranks.png',
        'assets/images/ozi/today-in-history-iphone-09-region.png',
        'assets/images/ozi/today-in-history-iphone-10-hall.png',
      ],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.esp.todayinhistory',
      technologies: [
        'Flutter', 'Dart', 'Firebase AI (Gemini)', 'Firestore', 'BLoC',
        'Hive', 'In-App Purchase', 'AdMob', 'Clean Architecture', 'Dio', 'GetIt',
      ],
      category: ProjectCategory.featured,
      role: 'Flutter Developer',
      sortOrder: 3,
      problem:
          'History education apps are static, shallow, and boring — plain Wikipedia lists with '
          'no AI context, no gamification, and no daily engagement loop. Existing trivia apps '
          'ignore historical depth. The core technical challenge: build a full-stack education '
          'product solo — AI companion with cost-effective caching, real-time multiplayer '
          'without a game server, complex XP/badge state across devices, and a freemium '
          'monetization layer — all in Flutter, shipped to production.',
      solution:
          'Architected a 99-file Clean Architecture Flutter app from scratch. '
          'Wikipedia\'s Wikimedia REST API feeds 51 countries daily. OZI (Firebase Gemini AI) '
          'explains events with dual-tier caching (Hive device + Firestore global) — '
          'targeting >95% cache hit rate to minimize API cost. Real-time quiz battles use '
          'Firestore matchmaking with an OZI Bot fallback (70% accuracy, human-like think '
          'times). ProfileBloc orchestrates XP, streaks, 22 badges, and artifact collection '
          'with dynamic game rules fetched from Firestore. IAP (monthly/yearly/lifetime) '
          'and AdMob complete the freemium monetisation stack.',
      metrics: [
        CaseStudyMetric(value: '51', label: 'Countries Covered', icon: Icons.public_rounded),
        CaseStudyMetric(value: '5.0★', label: 'Play Store Rating', icon: Icons.star_rounded),
        CaseStudyMetric(value: '99', label: 'Dart Files', icon: Icons.code_rounded),
        CaseStudyMetric(value: '95%+', label: 'AI Cache Hit Rate', icon: Icons.bolt_rounded),
      ],
      features: [
        CaseStudyFeature(
          name: 'OZI — AI Companion',
          description:
              'Firebase Gemini explains why every event mattered — with Wikipedia references. '
              'Dual-tier cache (Hive + Firestore global) cuts API cost; >95% of popular events '
              'served from cache after first request.',
          icon: Icons.psychology_rounded,
        ),
        CaseStudyFeature(
          name: 'History Battles',
          description:
              'Real-time 1v1 quiz duels via Firestore matchmaking (5-room pool). '
              'OZI Bot fallback with 70% accuracy and human-like 3.5–8.5s think times '
              'ensures no wait, ever.',
          icon: Icons.sports_esports_rounded,
        ),
        CaseStudyFeature(
          name: '51-Country Daily Feed',
          description:
              'Wikimedia REST API feeds fresh historical events every day across 51 countries '
              'and 6 categories. Offline-first: Hive cache returns instantly; API syncs in background.',
          icon: Icons.public_rounded,
        ),
        CaseStudyFeature(
          name: 'XP & Gamification Engine',
          description:
              'Era-based XP rewards (500 XP for ancient events → 200 for modern). '
              'Dynamic game rules from Firestore: 5 rank tiers, 22 achievement badges, '
              'artifact sets, streak shields, and daily login bonuses.',
          icon: Icons.emoji_events_rounded,
        ),
        CaseStudyFeature(
          name: 'Daily Quiz & Challenges',
          description:
              'Seeded deterministic quiz — same 5 questions for all users on a given day. '
              'Daily challenges (century, category, count goals) with bonus XP. '
              'Monthly leaderboard reset keeps competition fresh.',
          icon: Icons.quiz_rounded,
        ),
        CaseStudyFeature(
          name: 'Freemium Monetization',
          description:
              'IAP subscriptions (monthly \$1.99 / yearly \$9.99 / lifetime \$24.99) '
              'unlock all 51 countries, unlimited OZI AI, and ad-free experience. '
              'AdMob (banner + interstitial + app-open) for free tier. Cloud sync restores premium on reinstall.',
          icon: Icons.workspace_premium_rounded,
        ),
      ],
    ),
    Project(
      title: 'ImageKit SDK + Flutter OTP TextField',
      shortDescription: 'Open-source contributions — builder pattern SDK and merged PRs.',
      longDescription:
          'Builder-pattern URL constructors + JaCoCo test suite for ImageKit Android SDK. '
          'Multiple PRs merged into Flutter OTP TextField package improving developer UX.',
      imageUrls: [],
      githubUrl: 'https://github.com/imagekit-developer/imagekit-android',
      technologies: ['Kotlin', 'Android', 'JaCoCo', 'Flutter', 'Open Source'],
      category: ProjectCategory.openSource,
      role: 'Contributor',
      sortOrder: 4,
    ),
    Project(
      title: 'Keydock — Password Manager',
      shortDescription: 'Offline password vault · Android + Windows · AES-256 encrypted.',
      tagline: 'Your passwords. Your device. No cloud.',
      longDescription:
          'Fully offline, AES-256 encrypted password vault built with Flutter. '
          'Single codebase ships to Android (Play Store) and Windows (Microsoft Store) — '
          'same UI, same vault format, no account required. All data stays on device.',
      imageUrls: [],
      screenshotUrls: [],
      githubUrl: 'https://github.com/saty-a/Keydock-Password-Manager',
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.sun2.keydock',
      windowsStoreUrl: 'https://apps.microsoft.com/detail/9n10405jxw22',
      technologies: ['Flutter', 'Dart', 'SQLite', 'AES Encryption', 'Windows', 'Android', 'GetX'],
      category: ProjectCategory.featured,
      role: 'Author',
      sortOrder: 5,
      problem:
          'Most password managers require cloud accounts, subscriptions, and trust in a '
          'third-party server. Users who want full control over their credentials have no '
          'lightweight, cross-platform offline option that works seamlessly on both Android '
          'and Windows without forcing an account or syncing anything to the cloud.',
      solution:
          'Built an offline-first, AES-256 encrypted password vault using Flutter. '
          'Zero network calls — all data is stored locally with no account, no sync, no server. '
          'A single Flutter codebase targets both Android and Windows, '
          'delivering an identical secure vault experience on mobile and desktop. '
          'Published to both Google Play Store and Microsoft Store.',
      metrics: [
        CaseStudyMetric(value: '2', label: 'Store Platforms', icon: Icons.devices_rounded),
        CaseStudyMetric(value: 'AES-256', label: 'Encryption', icon: Icons.lock_rounded),
        CaseStudyMetric(value: '0', label: 'Cloud Dependencies', icon: Icons.cloud_off_rounded),
        CaseStudyMetric(value: '100%', label: 'Offline', icon: Icons.offline_bolt_rounded),
      ],
      features: [
        CaseStudyFeature(
          name: 'AES-256 Encrypted Vault',
          description:
              'Every credential is encrypted at rest with AES-256. '
              'Keys never leave the device — no cloud backup, no exposure surface.',
          icon: Icons.lock_rounded,
        ),
        CaseStudyFeature(
          name: 'Android + Windows',
          description:
              'Single Flutter codebase compiled and published to both Google Play Store '
              'and Microsoft Store — same secure vault on mobile and desktop.',
          icon: Icons.devices_rounded,
        ),
        CaseStudyFeature(
          name: 'Offline-First',
          description:
              'No account required. No internet needed. All data persists in a local '
              'encrypted SQLite database — works completely without connectivity.',
          icon: Icons.offline_bolt_rounded,
        ),
        CaseStudyFeature(
          name: 'Password Generator',
          description:
              'Built-in strong password generator with configurable length and character '
              'sets — uppercase, lowercase, digits, and symbols.',
          icon: Icons.vpn_key_rounded,
        ),
        CaseStudyFeature(
          name: 'Secure Clipboard',
          description:
              'One-tap copy with automatic clipboard clear after 30 seconds — '
              'credentials never linger in the system clipboard.',
          icon: Icons.content_copy_rounded,
        ),
        CaseStudyFeature(
          name: 'Multi-Store Publish',
          description:
              'Navigated both Google Play and Microsoft Store submission processes — '
              'separate signing, manifest requirements, and review policies for each platform.',
          icon: Icons.store_rounded,
        ),
      ],
    ),
    Project(
      title: 'DeadlineFlow',
      shortDescription: 'Deadline tracker · 6 platforms · No slack. Just track.',
      tagline: 'No slack. Just track.',
      longDescription:
          'Focused, offline-first deadline tracker built with Flutter. '
          'No team chat, no integrations, no bloat — just track what\'s due and when. '
          'Single codebase ships to Android, iOS, Web, Windows, macOS, and Linux.',
      imageUrls: [],
      screenshotUrls: [],
      githubUrl: 'https://github.com/saty-a/DeadlineFlow',
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.sun2.chessclock',
      technologies: ['Flutter', 'Dart', 'Hive', 'Local Notifications', 'Multi-Platform'],
      category: ProjectCategory.featured,
      role: 'Author',
      sortOrder: 6,
      problem:
          'Deadline management apps are built for teams — they add chat, integrations, '
          'boards, and collaboration features that overwhelm solo users. The result is '
          'cognitive overhead for a simple problem: knowing what\'s due and when. '
          'Most tools require accounts, sync, and onboarding before you can add a single task.',
      solution:
          'Built a single-purpose Flutter app with one goal: show deadlines clearly. '
          'Offline-first with Hive local storage and local push notifications — '
          'no account, no server, no noise. The same clean experience cross-compiled '
          'to 6 platforms (Android, iOS, Web, Windows, macOS, Linux) from one codebase.',
      metrics: [
        CaseStudyMetric(value: '6', label: 'Platforms', icon: Icons.devices_rounded),
        CaseStudyMetric(value: '0', label: 'Cloud Dependencies', icon: Icons.cloud_off_rounded),
        CaseStudyMetric(value: '100%', label: 'Offline', icon: Icons.offline_bolt_rounded),
        CaseStudyMetric(value: '1', label: 'Goal: Track Deadlines', icon: Icons.track_changes_rounded),
      ],
      features: [
        CaseStudyFeature(
          name: 'Deadline Tracking',
          description:
              'Add deadlines with title, date, and priority. '
              'Visual countdown shows urgency at a glance — no noise, just the facts.',
          icon: Icons.timer_rounded,
        ),
        CaseStudyFeature(
          name: 'Local Notifications',
          description:
              'Reminders fire locally — no server, no account. '
              'Notifications are scheduled on-device and work fully offline.',
          icon: Icons.notifications_active_rounded,
        ),
        CaseStudyFeature(
          name: '6-Platform Deploy',
          description:
              'Single Flutter codebase compiles to Android, iOS, Web, '
              'Windows, macOS, and Linux — one build pipeline, six targets.',
          icon: Icons.devices_rounded,
        ),
        CaseStudyFeature(
          name: 'Offline-First',
          description:
              'Hive local database persists all deadlines on device. '
              'Fully functional without any internet connection.',
          icon: Icons.offline_bolt_rounded,
        ),
        CaseStudyFeature(
          name: 'Minimal UI',
          description:
              'No tabs, no onboarding, no accounts. '
              'Open the app and see your deadlines — zero friction from launch.',
          icon: Icons.view_list_rounded,
        ),
        CaseStudyFeature(
          name: 'Priority System',
          description:
              'Color-coded urgency levels sort deadlines by proximity and importance automatically — '
              'overdue tasks surface immediately.',
          icon: Icons.priority_high_rounded,
        ),
      ],
    ),
  ];

  static const List<Project> sideProjects = [];
}
