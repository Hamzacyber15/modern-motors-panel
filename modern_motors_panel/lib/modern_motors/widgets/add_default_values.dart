import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modern_motors_panel/provider/modern_motors/mm_resource_provider.dart';
import 'package:provider/provider.dart';

class AddDefaultValuesWidget extends StatefulWidget {
  final String title;
  final String? permissionAccess;
  final VoidCallback onPress;
  const AddDefaultValuesWidget({
    super.key,
    required this.title,
    required this.onPress,
    this.permissionAccess,
  });

  @override
  State<AddDefaultValuesWidget> createState() => _AddDefaultValuesWidgetState();
}

class _AddDefaultValuesWidgetState extends State<AddDefaultValuesWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MmResourceProvider>(context, listen: false);
    provider.listenToEmployee(user!.uid);
    // provider.listenToEmployee("O4cq5T5khYsyePxfA9Bd");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MmResourceProvider>(
      builder: (context, value, child) {
        final hasPermission =
            widget.permissionAccess == null ||
            (value.employeeModel?.profileAccessKey?.contains(
                  widget.permissionAccess,
                ) ??
                false) ||
            user!.uid == "dVaqI5nCKQZnlqhiqNQyXAERJbG3";
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (hasPermission)
              IconButton(
                onPressed: widget.onPress,
                icon: const Icon(Icons.add),
              ),
          ],
        );
      },
    );
  }
}
