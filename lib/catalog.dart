import 'package:flutter/material.dart';

class Course {
  const Course(this.title, this.category, this.description, this.icon);
  final String title;
  final String category;
  final String description;
  final IconData icon;
  String get id => title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
}

const courses = <Course>[
  Course('Chatbot development in dialogflow', 'AI & Data', 'Build conversational experiences with Dialogflow.', Icons.smart_toy_outlined),
  Course('Graphic designing using adobe illustrator', 'Design', 'Learn visual design and Illustrator fundamentals.', Icons.palette_outlined),
  Course('react Development', 'Web Development', 'Build interactive interfaces with React.', Icons.code_rounded),
  Course('Flutter Complete course', 'Mobile Development', 'Create cross-platform applications with Flutter and Dart.', Icons.phone_android_rounded),
  Course('OpenAI and Django Step by Step Guide', 'AI & Data', 'Connect AI workflows with Django projects.', Icons.auto_awesome_outlined),
  Course('NextJS full course', 'Web Development', 'Create modern web applications with Next.js.', Icons.web_outlined),
  Course('Social Media Marketing Full Course', 'Marketing', 'Explore social media promotion and strategy.', Icons.campaign_outlined),
  Course('python full course', 'Programming', 'Study practical Python programming foundations.', Icons.terminal_rounded),
  Course('Django Project course', 'Web Development', 'Build a web project using Django.', Icons.layers_outlined),
  Course('Node js full course', 'Web Development', 'Explore server-side JavaScript with Node.js.', Icons.dns_outlined),
  Course('Next.js Tutorial', 'Web Development', 'Learn the Next.js framework step by step.', Icons.web_asset_outlined),
  Course('Typescript Tutorial', 'Programming', 'Learn typed JavaScript with TypeScript.', Icons.data_object_rounded),
  Course('UIUX Figma Complete Course', 'Design', 'Design user interfaces and experiences with Figma.', Icons.design_services_outlined),
  Course('PHP Programing', 'Web Development', 'Explore server-side programming with PHP.', Icons.php_rounded),
  Course('Go programming Tutorial', 'Programming', 'Discover Go syntax and programming concepts.', Icons.terminal_rounded),
  Course('REST API with Node, Express, Mongo & Mongoose', 'Web Development', 'Learn to build an API with Node and MongoDB.', Icons.hub_outlined),
  Course('Cyber Security', 'Security', 'Explore cybersecurity foundations.', Icons.security_rounded),
  Course('How To Become A Social Media Marketer', 'Marketing', 'Explore a path into social media marketing.', Icons.trending_up_rounded),
  Course('Html & CSS tutorial', 'Web Development', 'Build and style pages with HTML and CSS.', Icons.html_rounded),
  Course('learn python', 'Programming', 'Learn the fundamentals of Python.', Icons.terminal_rounded),
  Course('Learn SQA', 'Testing', 'Explore software quality assurance.', Icons.fact_check_outlined),
  Course('Wordpress', 'Web Development', 'Learn to build a website with WordPress.', Icons.language_rounded),
  Course('HTML', 'Web Development', 'Learn HTML structure, tags and forms.', Icons.html_rounded),
  Course('Machine Learning', 'AI & Data', 'Explore machine learning concepts.', Icons.psychology_outlined),
  Course('Data Structure & Algorithm', 'Programming', 'Build foundations in data structures and algorithms.', Icons.account_tree_outlined),
  Course('Advance Typescript', 'Programming', 'Explore additional TypeScript concepts.', Icons.data_object_rounded),
  Course('Three JS Tutorial', 'Web Development', 'Create interactive 3D experiences with Three.js.', Icons.view_in_ar_outlined),
  Course('Masterclass Flutter 2025', 'Mobile Development', 'Build practical mobile apps with Flutter.', Icons.phone_android_rounded),
  Course('SOC Analyst Course', 'Security', 'Explore security operations center workflows.', Icons.shield_outlined),
];

const categories = <String>['All', 'Web Development', 'Programming', 'Mobile Development', 'AI & Data', 'Design', 'Marketing', 'Security', 'Testing'];
