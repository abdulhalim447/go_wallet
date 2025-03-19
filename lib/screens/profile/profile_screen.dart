import 'package:flutter/material.dart';
import 'package:go_wallet/screens/profile/profile_editScreen.dart';
import 'package:go_wallet/models/user_session.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Map<String, String?>> _loadUserData() async {
    return {
      'name': await UserSession.getName(),
      'email': await UserSession.getEmail(),
      'phone': await UserSession.getPhone(),
      'profileImage': await UserSession.getProfileImage(),
      'reffer': await UserSession.getReffer(),
    };
  }

  Future<void> _handleChangePIN(BuildContext context) async {
    final TextEditingController currentPinController = TextEditingController();
    final TextEditingController newPinController = TextEditingController();
    final TextEditingController confirmPinController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPinController,
              decoration: InputDecoration(
                labelText: 'Current PIN',
                hintText: 'Enter current PIN',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
            ),
            SizedBox(height: 8),
            TextField(
              controller: newPinController,
              decoration: InputDecoration(
                labelText: 'New PIN',
                hintText: 'Enter new PIN',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
            ),
            SizedBox(height: 8),
            TextField(
              controller: confirmPinController,
              decoration: InputDecoration(
                labelText: 'Confirm PIN',
                hintText: 'Confirm new PIN',
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (newPinController.text != confirmPinController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('New PINs do not match')),
                );
                return;
              }
              // Here you would typically verify the current PIN and update with new PIN
              // await UserSession.updatePIN(currentPinController.text, newPinController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('PIN updated successfully')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleChangePassword(BuildContext context) async {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: InputDecoration(
                labelText: 'Current Password',
                hintText: 'Enter current password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 8),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter new password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 8),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm new password',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('New passwords do not match')),
                );
                return;
              }
              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Password must be at least 6 characters')),
                );
                return;
              }
              // Here you would typically verify the current password and update with new password
              // await UserSession.updatePassword(currentPasswordController.text, newPasswordController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password updated successfully')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Logout'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );

        await UserSession.clearSession();

        // Remove loading indicator
        Navigator.pop(context);

        // Navigate to login screen and clear all routes
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out. Please try again.')),
      );
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _primaryBlue = const Color(0xFF2196F3);
    final _lightBlue = const Color(0xFFE3F2FD);
    final _darkBlue = const Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: _lightBlue,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryBlue,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileEditScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading profile data'));
          }

          final userData = snapshot.data ?? {};
          final name = userData['name'] ?? 'N/A';
          final email = userData['email'] ?? 'N/A';
          final phone = userData['phone'] ?? 'N/A';
          final profileImage = userData['profileImage'];
          final reffer = userData['reffer'] ?? 'N/A';

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: _primaryBlue,
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 56,
                            backgroundImage: NetworkImage(
                              profileImage ?? 'https://via.placeholder.com/150',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Referral Code: $reffer',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _darkBlue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoItem(Icons.email, 'Email', email),
                          _buildInfoItem(Icons.phone, 'Phone', phone),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  icon: Icons.lock,
                  label: 'Change PIN',
                  onTap: () => _handleChangePIN(context),
                  color: _darkBlue,
                ),
                _buildActionButton(
                  icon: Icons.password,
                  label: 'Change Password',
                  onTap: () => _handleChangePassword(context),
                  color: _darkBlue,
                ),
                _buildActionButton(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () => _handleLogout(context),
                  color: Colors.red,
                ),
                const SizedBox(height: 150),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
