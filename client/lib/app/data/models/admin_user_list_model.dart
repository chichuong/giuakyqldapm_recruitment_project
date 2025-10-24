class PaginatedAdminUsers {
  final List<AdminUserListItem> users;
  final int totalPages;
  PaginatedAdminUsers({required this.users, required this.totalPages});
}

class AdminUserListItem {
  final int id;
  final String email;
  final String fullName;
  final String role;
  final DateTime createdAt;

  AdminUserListItem({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.createdAt,
  });

  factory AdminUserListItem.fromJson(Map<String, dynamic> json) =>
      AdminUserListItem(
        id: json["id"],
        email: json["email"],
        fullName: json["full_name"],
        role: json["role"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}
