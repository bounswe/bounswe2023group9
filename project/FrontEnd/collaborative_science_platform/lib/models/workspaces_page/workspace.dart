import 'package:collaborative_science_platform/models/node.dart';
import 'package:collaborative_science_platform/models/user.dart';
import 'package:collaborative_science_platform/models/workspace_semantic_tag.dart';
import 'package:collaborative_science_platform/models/workspaces_page/comment.dart';
import 'package:collaborative_science_platform/models/workspaces_page/entry.dart';

enum WorkspaceStatus { finalized, workable, inReview, published, rejected }

enum RequestStatus { approved, rejected, pending }

class Workspace {
  int workspaceId;
  String workspaceTitle;
  List<Entry> entries;
  WorkspaceStatus status;
  int numApprovals;
  List<WorkspaceSemanticTag> tags;
  List<User> contributors;
  List<User> pendingContributors;
  List<Node> references;
  int fromNodeId;
  int requestId;
  bool pending;
  bool pendingReviewer;
  bool pendingContributor;

  List<Comment> comments;

  Workspace({
    required this.workspaceId,
    required this.workspaceTitle,
    required this.entries,
    required this.status,
    required this.numApprovals,
    required this.tags,
    required this.contributors,
    required this.pendingContributors,
    required this.references,
    required this.fromNodeId,
    required this.requestId,
    required this.pending,
    required this.pendingContributor,
    required this.pendingReviewer,
    required this.comments,

  });

  factory Workspace.fromJson(Map<String, dynamic> jsonString) {
    var entryList = jsonString['workspace_entries'] as List;
    var tagList = jsonString['semantic_tags'] as List;
    var contributorsList = jsonString['contributors'] as List;
    var pendingContributorsList = jsonString['pending_contributors'] as List;
    var referencesList = jsonString['references'] as List;
    var commentsList = jsonString['comments'] as List;

    List<Entry> entries = entryList.map((e) => Entry.fromJson(e)).toList();
    List<WorkspaceSemanticTag> tags = tagList.map((e) => WorkspaceSemanticTag.fromJson(e)).toList();
    List<User> contributors =
        contributorsList.map((e) => User.fromJsonforNodeDetailPage(e)).toList();
    List<User> pendingContributors = pendingContributorsList
        .map((e) => User.fromJsonforNodeDetailPagePendingContributors(e))
        .toList();
    List<Node> references = referencesList.map((e) => Node.fromJsonforNodeDetailPage(e)).toList();
List<Comment> comments = commentsList.map((e) => Comment.fromJson(e)).toList();
    String statusString = jsonString['status'];
    WorkspaceStatus status = (statusString == "finalized")
        ? WorkspaceStatus.finalized
        : (statusString == "workable")
            ? WorkspaceStatus.workable
            : (statusString == "in_review")
                ? WorkspaceStatus.inReview
                : (statusString == "published")
                    ? WorkspaceStatus.published
                    : WorkspaceStatus.rejected;
    return Workspace(
      workspaceId: jsonString['workspace_id'],
      workspaceTitle: jsonString['workspace_title'],
      entries: entries,
      status: status,
      tags: tags,
      numApprovals: jsonString['num_approvals'],
      contributors: contributors,
      pendingContributors: pendingContributors,
      references: references,
      requestId: jsonString["request_id"] == "" ? -1 : jsonString["request_id"],
      fromNodeId: jsonString["from_node_id"] == "" ? -1 : jsonString["from_node_id"],

      pending: jsonString["pending_reviewer"] || jsonString["pending_collab"],
      pendingReviewer: jsonString["pending_reviewer"],
      pendingContributor: jsonString["pending_collab"],

      comments: comments,

    );
  }
}
