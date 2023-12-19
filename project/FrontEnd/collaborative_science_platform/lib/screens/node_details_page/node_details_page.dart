import 'package:collaborative_science_platform/exceptions/node_details_exceptions.dart';
import 'package:collaborative_science_platform/models/basic_user.dart';
import 'package:collaborative_science_platform/models/node_details_page/node_detailed.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/providers/auth.dart';
import 'package:collaborative_science_platform/providers/node_provider.dart';
import 'package:collaborative_science_platform/providers/admin_provider.dart';
import 'package:collaborative_science_platform/screens/error_page/error_page.dart';
import 'package:collaborative_science_platform/screens/home_page/widgets/home_page_appbar.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/contributors_list_view.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/node_details.dart';
import 'package:collaborative_science_platform/screens/node_details_page/widgets/you_may_like.dart';
import 'package:collaborative_science_platform/screens/page_with_appbar/page_with_appbar.dart';
import 'package:collaborative_science_platform/utils/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NodeDetailsPage extends StatefulWidget {
  static const routeName = '/node';
  //final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
  final int nodeID;
  const NodeDetailsPage({super.key, required this.nodeID});

  @override
  State<NodeDetailsPage> createState() => _NodeDetailsPageState();
}

class _NodeDetailsPageState extends State<NodeDetailsPage> {
  ScrollController controller1 = ScrollController();
  ScrollController controller2 = ScrollController();
  bool _isFirstTime = true;
  NodeDetailed node = NodeDetailed();
  BasicUser basicUser = BasicUser();

  bool isAuthLoading = false;

  bool error = false;
  String errorMessage = "";
  String message = "";

  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getAuthUser();
      getNodeDetails();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void getNodeDetails() async {
    try {
      final nodeDetailsProvider = Provider.of<NodeProvider>(context);
      setState(() {
        error = false;
        isLoading = true;
      });
      await nodeDetailsProvider.getNode(widget.nodeID);

      setState(() {
        node = (nodeDetailsProvider.nodeDetailed ?? {} as NodeDetailed);
      });
    } on NodeDoesNotExist {
      setState(() {
        error = true;
        errorMessage = NodeDoesNotExist().message;
      });
    } catch (e) {
      setState(() {
        error = true;
        errorMessage = "Something went wrong!";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getAuthUser() async {
    final User? user = Provider.of<Auth>(context).user;
    if (user != null) {
      try {
        final auth = Provider.of<Auth>(context);
        basicUser = (auth.basicUser ?? {} as BasicUser);
        isAuthLoading = true;
        // user = (auth.user ?? {} as User);
      } catch (e) {
        setState(() {
          error = true;
          errorMessage = "Something went wrong!";
        });
        rethrow;
      } finally {
        setState(() {
          isAuthLoading = false;
        });
      }
    }
  }

  void changeNodeStatus() async {
    try {
      final User? admin = Provider.of<Auth>(context, listen: false).user;
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      await adminProvider.hideNode(admin, node, !node.isHidden);
      error = false;
      message = "Node status updated.";
      print(message);
    } catch (e) {
      setState(() {
        error = true;
        message = "Something went wrong!";
        print(message);
      });
    }
  }

  void handleButton() {
    setState(() {
      changeNodeStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return (!node.isHidden || basicUser.userType == "admin")
        ? PageWithAppBar(
            appBar: const HomePageAppBar(),
            pageColor: Colors.grey.shade200,
            child: isLoading
                ? Container(
                    padding: const EdgeInsets.only(top: 32),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : error
                    ? SelectableText(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      )
                    : Responsive.isDesktop(context)
                        ? WebNodeDetails(
                            node: node,
                            handleButton: handleButton,
                          )
                        : NodeDetails(
                            node: node,
                            controller: controller2,
                            userType: basicUser.userType,
                            onTap: handleButton,
                          ),
          )
        : const ErrorPage();
  }
}

class WebNodeDetails extends StatefulWidget {
  final NodeDetailed node;
  final Function() handleButton;

  const WebNodeDetails({super.key, required this.node, required this.handleButton});

  @override
  State<WebNodeDetails> createState() => _WebNodeDetailsState();
}

class _WebNodeDetailsState extends State<WebNodeDetails> {
  final ScrollController controller1 = ScrollController();
  final ScrollController controller2 = ScrollController();
  BasicUser basicUser = BasicUser();

  bool _isFirstTime = true;
  bool error = false;
  bool isLoading = false;
  bool isAuthLoading = false;

  String errorMessage = "";
  String message = "";

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      getAuthUser();
      getNodeSuggestions();
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void getNodeSuggestions() async {
    try {
      final nodeDetailsProvider = Provider.of<NodeProvider>(context);
      setState(() {
        error = false;
        isLoading = true;
      });
      await nodeDetailsProvider.getNodeSuggestions();
    } on NodeDoesNotExist {
      setState(() {
        error = true;
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getAuthUser() async {
    final User? user = Provider.of<Auth>(context).user;
    if (user != null) {
      try {
        final auth = Provider.of<Auth>(context);
        basicUser = (auth.basicUser ?? {} as BasicUser);
        isAuthLoading = true;
        // user = (auth.user ?? {} as User);
      } catch (e) {
        setState(() {
          error = true;
          errorMessage = "Something went wrong!";
        });
        rethrow;
      } finally {
        setState(() {
          isAuthLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    BrowserContextMenu.enableContextMenu();
    super.dispose();
  }

  @override
  void initState() {
    BrowserContextMenu.disableContextMenu();
    super.initState();
  }

  void changeNodeStatus() async {
    try {
      final User? user = Provider.of<Auth>(context, listen: false).user;
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      print(widget.node.isHidden.toString());
      await adminProvider.hideNode(user, widget.node, widget.node.isHidden);
      error = false;
      message = "Node status updated.";
      print(message);
    } catch (e) {
      setState(() {
        error = true;
        message = "Something went wrong!";
        print(message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (!widget.node.isHidden || basicUser.userType == "admin")
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Contributors(
                  contributors: widget.node.contributors, //widget.inputNode.contributors,
                  controller: controller1,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: NodeDetails(
                    node: widget.node,
                    controller: controller2,
                    userType: basicUser.userType,
                    onTap: widget.handleButton,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: YouMayLike(
                    isLoading: isLoading,
                    error: error,
                  ),
                ),
              ],
            ),
          )
        : const ErrorPage();
  }
}
