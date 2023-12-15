import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NodeDetailsMenu extends StatelessWidget {
  const NodeDetailsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return auth.isSignedIn ? AuthenticatedNodeDetailsMenu() : const SizedBox();
  }
}

class AuthenticatedNodeDetailsMenu extends StatelessWidget {
  final GlobalKey<PopupMenuButtonState<dynamic>> _popupNodeMenu = GlobalKey<PopupMenuButtonState>();
  AuthenticatedNodeDetailsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      key: _popupNodeMenu,
      position: PopupMenuPosition.under,
      color: Colors.grey[200],
      onSelected: (String result) async {
        switch (result) {
          case 'create':
            // Create new node TODO

            break;
          default:
        }
      },
      child: AppBarButton(
        icon: Icons.more_horiz,
        text: Provider.of<Auth>(context).user!.firstName,
        onPressed: () => _popupNodeMenu.currentState!.showButtonMenu(),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'create',
          child: Text("Create new workspace with this theorem."),
        ),
      ],
    );
  }
}
