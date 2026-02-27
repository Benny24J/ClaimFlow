class UserProfile {
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String organization;
  final String location;
  final String? avatarUrl;

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.organization,
    required this.location,
    this.avatarUrl,
  });

  /// TODO: Replace with real API response parsing
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      organization: json['organization'] as String,
      location: json['location'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  
  factory UserProfile.placeholder() {
    return const UserProfile(
      fullName: 'Dr. Sarah Okonkwo',
      email: 'sarah.okonkwo@healthclinic.ng',
      phone: '+234 803 456 7890',
      role: 'Claims Manager',
      organization: 'Harmony Health Clinic',
      location: 'Lagos, Nigeria',
    );
  }
}