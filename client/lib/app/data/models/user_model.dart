// lib/app/data/models/user_model.dart

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

class User {
  final int id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String role;
  final String? avatarUrl;
  final String? headline;
  final String? bio;
  final String? linkedinUrl;
  final String? githubUrl;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    this.avatarUrl,
    this.headline,
    this.bio,
    this.linkedinUrl,
    this.githubUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    role: json["role"],
    avatarUrl: json["avatar_url"],
    headline: json["headline"],
    bio: json["bio"],
    linkedinUrl: json["linkedin_url"],
    githubUrl: json["github_url"],
  );
}
