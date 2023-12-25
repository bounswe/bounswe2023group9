import 'package:collaborative_science_platform/models/workspaces_page/entry.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/widgets/app_bar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntryMenu extends StatelessWidget {
  final Function setProof;
  final Function setDisproof;
  final Function setTheorem;
  final Function removeDisproof;
  final Function removeTheorem;
  final Function removeProof;
  final Function deleteEntry;
  final Entry entry;
  final bool fromNode;
  const EntryMenu({
    super.key,
    required this.removeDisproof,
    required this.removeProof,
    required this.removeTheorem,
    required this.setDisproof,
    required this.setProof,
    required this.setTheorem,
    required this.entry,
    required this.deleteEntry,
    required this.fromNode,
  });

  @override
  Widget build(BuildContext context) {
    return (entry.isEditable && !entry.isFinalEntry)
        ? AuthenticatedEntryMenu(
            setProof: setProof,
            setDisproof: setDisproof,
            setTheorem: setTheorem,
            removeProof: removeProof,
            removeDisproof: removeDisproof,
            removeTheorem: removeTheorem,
            deleteEntry: deleteEntry,
            entry: entry,
            fromNode: fromNode,
          )
        : const SizedBox();
  }
}

class AuthenticatedEntryMenu extends StatelessWidget {
  final Function setProof;
  final Function setDisproof;
  final Function setTheorem;
  final Function removeDisproof;
  final Function removeTheorem;
  final Function removeProof;
  final Function deleteEntry;
  final bool fromNode;
  final Entry entry;
  final GlobalKey<PopupMenuButtonState<dynamic>> _popupNodeMenu = GlobalKey<PopupMenuButtonState>();
  AuthenticatedEntryMenu({
    super.key,
    required this.removeDisproof,
    required this.removeProof,
    required this.removeTheorem,
    required this.setDisproof,
    required this.setProof,
    required this.setTheorem,
    required this.entry,
    required this.deleteEntry,
    required this.fromNode,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      key: _popupNodeMenu,
      position: PopupMenuPosition.under,
      color: Colors.grey[200],
      onSelected: (String result) async {
        switch (result) {
          case 'setTheorem':
            await setTheorem(entry.entryId);
            break;
          case 'setProof':
            await setProof(entry.entryId);
            break;
          case 'setDisproof':
            await setDisproof(entry.entryId);
            break;
          case 'removeEntry':
            await deleteEntry(entry.entryId);
            break;
          case 'removeDisproof':
            await removeDisproof();
            break;
          case 'removeTheorem':
            await removeTheorem();
            break;
          case 'removeProof':
            await removeProof();
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
          value: 'removeEntry',
          child: Text("Remove Entry"),
        ),
        if (!entry.isFinalEntry &&
            !entry.isTheoremEntry &&
            !entry.isProofEntry &&
            !entry.isDisproofEntry)
          const PopupMenuItem<String>(
            value: 'setTheorem',
            child: Text("Set this entry as theorem"),
          ),
        if (!entry.isFinalEntry &&
            !entry.isTheoremEntry &&
            !entry.isProofEntry &&
            !entry.isDisproofEntry)
          const PopupMenuItem<String>(
            value: 'setProof',
            child: Text("Set this entry as proof"),
          ),
        if (!entry.isTheoremEntry && !entry.isProofEntry && !entry.isDisproofEntry && fromNode)
          const PopupMenuItem<String>(
            value: 'setDisproof',
            child: Text("Set this entry as disproof"),
          ),
        if (entry.isDisproofEntry)
          const PopupMenuItem<String>(
            value: 'removeDisproof',
            child: Text("Unset Disproof"),
          ),
        if (entry.isTheoremEntry)
          const PopupMenuItem<String>(
            value: 'removeTheorem',
            child: Text("Unset Theorem"),
          ),
        if (entry.isProofEntry)
          const PopupMenuItem<String>(
            value: 'removeProof',
            child: Text("Unset Proof"),
          ),
      ],
    );
  }
}
