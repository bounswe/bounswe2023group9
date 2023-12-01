# The Summary of the Project Status and Our Future Plans

Login and sign up pages are available. Anyone who want to use our platform can create an account. In the signup page, there is strong password checker which prevents users from selecting weak passwords. Pages which are not available without authorization have nice and informative messages for user. These pages direct unauthorized users to our login and signup pages. Our home page has a functioning search bar where users can search for theorems and contributors. Furthermore, the semantic search has been implemented. In our home page, some theorems are listed when you first direct to the page. It was empty before. A user can view the profile page of another user by clicking on the card of a user. Also, every theorem has its own page where theorem related stuff such as proofs, references, citations, and questions can be viewed. Those who want to see the references and referents with together the theorem can check our graph page. On can navigate between pages of different theorems easily. We have a well-designed workspace where users can work on their theorems. The UI of the workspace and almost all the functionality needed from the workspace page are ready, but they haven't been merged yet. In the previous milestone, we realized that our system responds slowly. It is more responsive now after some optimizations.

In the future, we plan to complete the implementation of the workspace. The notification page is a necessity for users to be aware of any changes which are related to them. Collaboration requests, Review results, questions, and so on will be reported to the related users via notifications. In order to provide these, we will add a functioning notification page. The process of reviewing has not been implemented yet. Those who complete their work on their theorems and proofs will be able to send workspaces to the reviewers. Reviewer will give be able to give approval or rejection. In addition, an admin panel is needed for our platform to be user-friendly. Any problem noticed by a user will be reported to admin so that necessary actions can be taken. Finally, Q&A sections will be functioning soon.

# The Summary of the Customer Feedback and Reflections

The proofs related with a theorem can be written by several contributors. Even though the platform is keeps track of the list of contributors that have made contributions to theorem and proofs, it is missed to capture the actual contributor of a single entry (proof or theorem). In the previous customer presentation, the customer feedback revealed that there was a need to improve the tracking system for individual contributions to the theorems and proofs.

The feedback and reflections from the customer pointed out that the graph concept used in the project is irrelevant with a structure of a real graph. Therefore, the graph section leads a misconception and the "graph" term should be revised to align with the current implementation.

In addition, there are some ambiguities with the tags used to categorize nodes and authors. It is not obvious that in which aspects these tags are related with the nodes and authors .Since we have not implemented a tagging system to add new tags, the customer couldn't see the relation clearly.
Furthermore, the purpose and the usage of the annotations are not clear for the customer up to now. Therefore, we should consider to work on a more understandable user experience for annotations.

Latex support is also expected in the workspace by the customer. We will implement it later, since the platform have Latex reader in the node view page.

In the pre-release day, there were some last minute changes and merges; and we had difficulties on resolving the conflicts when mergeing some front-end branches. This even caused some of the additional features we have implemented not to be included in the pre-release. We should make more rebase with the origin parent branches during implementations and communicate with the team members that are working on the same pieces of the project more frequently to avoid this. Also, we should leave a gap before pre-releases for such cases while planning the weeks. Moreover, maybe preparing some plan B for risky situations may help us in the future.

# Changes Since Milestone 1 and Our Future Plans

First, we have implemented the graph page which is fully functioning since the delivery of the milestone 1. Those who want to see the list of references and referents of a theorem can navigate to our graph page from the view page of the theorem. In addition, semantic search has been implemented. Also, the texts in our platforms can, now, be selectable. Pages which cannot be accessed without authorization welcome un-authorized users with informative messages about the platform. We have designed the UI of the workspace and the necessary functionalities related to it are implemented. However, they have not been merged yet. We have improved the responsiveness of our platform.

We plan to add a panel for admin(s) so that the platform does not diverge from its original purpose. Necessary actions will be taken for those who act offensively in our platform by admin(s). Q&A sections will be functioning for those who want to learn more about the theorems and proofs in which they are interested. We will complete the implementation of the workspace. We have always aimed for a user-friendly and responsive platform; therefore, we will work on improving the already-implemented pages as well. Finally, notifications will be implemented so that users can be aware of the changes and actions in our platform.

We have a lot of thing to do until this platform is fully functioning, and we have limited amount of time for that. Since we have spent most our time dealing with small details, we are a little bit off from the plan that we made in the early weeks of the semester. However, we believe that the project will be mostly complete in the final milestone.

# Progress According to the Requirements

We have covered the requirements about annotations only in the front-end in the way that contributors are able to add public annotations to their nodes in the node view page. Since backend and frontend is not connected through annotation APIs, they are not exactly functional. Also, contributors can see the workspaces they are collaborating however they cannot contribute (add entries) at the moment. All other mentioned requirements below are covered in this milestone. They are fullfilled in the graph page, node view page, search page, login / signup pages, settings page, profile page. Also, documentation of the related APIs can be found in the API documentation part.

### Covered Requirements in Customer Milestone 2

### 1. Functional Requirements

### 1.1 User Requirements

- 1.1.1 User Types
  - 1.1.1.1 Guests
    - 1.1.1.1.1 Guests shall be able to view the nodes and their references.
    - 1.1.1.1.2 Guests shall be able to view the contributors and reviewers of the nodes.
    - 1.1.1.1.4 Guests shall be able to sign-up.
  - 1.1.1.2 Basic users
    - 1.1.1.2.4 Basic users shall be able to perform the same actions as guests except sign-up.
  - 1.1.1.3 Contributors
    - 1.1.1.3.8 Contributors shall be able to perform the same actions as basic users.
- 1.1.2 User Interactions
  - 1.1.2.3 Contributors shall be able to see and contribute to the workspaces they collaborate.
- 1.1.3 Sign up & Login
  - 1.1.3.1 Users shall provide their real names, e-mail addresses, and passwords to sign up.
  - 1.1.3.2 E-mail addresses shall be unique.
  - 1.1.3.3 User passwords shall meet safety criteria
- 1.1.4 Profile Preferences
  - 1.1.4.1 Basic users shall be able to change their passwords.
  - 1.1.4.2 Basic users shall have profile pages.
  - 1.1.4.3 Basic users shall be able to let their profile pages show their activity.
  - 1.1.4.4 Guests shall be able to view other users' profile pages.
  - 1.1.4.5 Basic users shall be able to edit their own profile information.
  - 1.1.4.6 Basic users shall be able to turn on or off the email notifications.

### 1.2 System Requirements

- 1.2.1 Nodes
  - 1.2.1.2 Nodes shall be referenceable/linkable to other nodes.
  - 1.2.1.3 Nodes shall have semantic tags regarding to their subjects.
  - 1.2.1.4 Nodes shall have a questions/answers section.
  - 1.2.1.6 Nodes shall have public annotations.
- 1.2.5 Search
  - 1.2.5.1 Searching
    - 1.2.5.1.1 The platform shall allow users to search for users and nodes.
  - 1.2.5.2 Filtering
    - 1.2.5.2.1 Nodes shall be filtered by their semantic tags.
    - 1.2.5.2.2 Nodes shall be filtered by their contributors.
- 1.2.7 Graph Visualization
  - 1.2.7.1 The platform shall visualize the graph.

### 2. Non-functional Requirements

- 2.1 Availability
  - 2.1.1 The system shall be available in the English language.
- 2.2 Standards
  - 2.2.1 Annotations shall be compliant with W3C annotation standards
- 2.4 Security
  - 2.4.1 User passwords shall be stored as hashed in the database.

# API Endpoints

You may access pdf file of our projects API Documentation from this [wiki page](https://github.com/bounswe/bounswe2023group9/wiki/API-Documentation) and also you can find the interactive swagger documentation in our [related page of live backend](http://13.51.55.11:8000/api/docs/).

# Generated Unit Test Reports

## Backend

```
python manage.py test --verbosity=2
Found 59 test(s).
Creating test database for alias 'default' ('test_postgres')...
Operations to perform:
  Synchronize unmigrated apps: corsheaders, messages, rest_framework, staticfiles
  Apply all migrations: admin, auth, authtoken, contenttypes, database, sessions
Synchronizing apps without migrations:
  Creating tables...
    Running deferred SQL...
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying auth.0012_alter_user_first_name_max_length... OK
  Applying authtoken.0001_initial... OK
  Applying authtoken.0002_auto_20160226_1747... OK
  Applying authtoken.0003_tokenproxy... OK
  Applying database.0001_initial... OK
  Applying sessions.0001_initial... OK
System check identified no issues (0 silenced).
test_success (api.tests.ChangePasswordAPITestCase.test_success) ... All tests for the Change Password API are completed!
ok
test_wrong_old_password (api.tests.ChangePasswordAPITestCase.test_wrong_old_password) ... All tests for the Change Password API are completed!
ok
test_success (api.tests.ChangeProfileSettingsAPITestCase.test_success) ... All tests for the Change Profile Settings API are completed!
ok
test_send_collab_request (api.tests.CollaborationRequestAPITestCase.test_send_collab_request) ... Test for the CollaborationRequest API is completed!
ok
test_update_collab_request (api.tests.CollaborationRequestAPITestCase.test_update_collab_request) ... Test for the CollaborationRequest API is completed!
ok
test_get_contributor_from_id (api.tests.ContributorGETAPITestCase.test_get_contributor_from_id) ... ok
test_get_invalid (api.tests.NodeAPITestCase.test_get_invalid) ... All tests for the Node API are completed!
ok
test_get_random_node (api.tests.NodeAPITestCase.test_get_random_node) ... All tests for the Node API are completed!
ok
test_get_random_node_id (api.tests.NodeAPITestCase.test_get_random_node_id) ... All tests for the Node API are completed!
ok
test_get_removed_node (api.tests.NodeAPITestCase.test_get_removed_node) ... All tests for the Node API are completed!
ok
test_get_valid (api.tests.NodeAPITestCase.test_get_valid) ... All tests for the Node API are completed!
ok
test_get_user_profile (api.tests.ProfileGETAPITestCase.test_get_user_profile) ... ok
test_get_proof_from_id_not_found (api.tests.ProofGETAPITestCase.test_get_proof_from_id_not_found) ... All tests for the Proof GET API are completed!
ok
test_get_proof_from_id_valid (api.tests.ProofGETAPITestCase.test_get_proof_from_id_valid) ... All tests for the Proof GET API are completed!
ok
test_send_review_request (api.tests.ReviewRequestAPITestCase.test_send_review_request) ... Test for the ReviewRequest API is completed!
ok
test_update_review_request (api.tests.ReviewRequestAPITestCase.test_update_review_request) ... Test for the ReviewRequest API is completed!
ok
test_search (api.tests.SearchAPITestCase.test_search) ... ok
test_user_signup (api.tests.SignUpAPIViewTestCase.test_user_signup) ... All tests for the Sign Up API are completed!
ok
test_get_theorem_from_id_not_found (api.tests.TheoremGETAPITestCase.test_get_theorem_from_id_not_found) ... ok
test_get_theorem_from_id_valid (api.tests.TheoremGETAPITestCase.test_get_theorem_from_id_valid) ... ok
test_get_user_detail_authenticated (api.tests.UserDetailAPITestCase.test_get_user_detail_authenticated) ... All tests for the User Detail API are completed!
ok
test_get_user_detail_not_authenticated (api.tests.UserDetailAPITestCase.test_get_user_detail_not_authenticated) ... All tests for the User Detail API are completed!
ok
test_get_workspaces_of_user (api.tests.UserWorkspacesGETAPITestCase.test_get_workspaces_of_user) ... ok
test_get_workspace_from_id (api.tests.WorkspaceGETAPITestCase.test_get_workspace_from_id) ... ok
test_create_workspace (api.tests.WorkspacePOSTAPITestCase.test_create_workspace) ... All tests for the Workspace POST API are completed!
ok
test_admin_create (database.tests.AdminModelTestCase.test_admin_create) ... Test for the Admin Model is completed!
ok
test_basic_user_create (database.tests.BasicUserModelTestCase.test_basic_user_create) ... All tests for the Basic User Model are completed!
ok
test_basic_user_str (database.tests.BasicUserModelTestCase.test_basic_user_str) ... All tests for the Basic User Model are completed!
ok
test_basic_user_serializer_fields (database.tests.BasicUserSerializerTestCase.test_basic_user_serializer_fields) ... All tests for the BasicUserSerializer are completed!
ok
test_accept (database.tests.CollaborationRequestTestCase.test_accept) ... Test for the CollaborationRequest Model is completed!
ok
test_reject (database.tests.CollaborationRequestTestCase.test_reject) ... Test for the CollaborationRequest Model is completed!
ok
test_contributor_create (database.tests.ContributorModelTestCase.test_contributor_create) ... All tests for the Contributor Model are completed!
ok
test_create_workspace (database.tests.ContributorModelTestCase.test_create_workspace) ... All tests for the Contributor Model are completed!
ok
test_delete_nonexistent_workspace (database.tests.ContributorModelTestCase.test_delete_nonexistent_workspace) ... All tests for the Contributor Model are completed!
ok
test_delete_workspace (database.tests.ContributorModelTestCase.test_delete_workspace) ... All tests for the Contributor Model are completed!
ok
test_contributor_serializer_fields (database.tests.ContributorSerializerTestCase.test_contributor_serializer_fields) ... All tests for the ContributorSerializer are completed!
ok
test_entry_model (database.tests.EntryModelTestCase.test_entry_model) ... All tests for the Entry Model are completed!
ok
test_increment_num_visits (database.tests.NodeModelTestCase.test_increment_num_visits) ... All tests for the Node Model are completed!
ok
test_node_model (database.tests.NodeModelTestCase.test_node_model) ... All tests for the Node Model are completed!
ok
test_reference_symmetry (database.tests.NodeReferenceTestCase.test_reference_symmetry) ... All tests for the Node Reference Model are completed!
ok
test_references (database.tests.NodeReferenceTestCase.test_references) ... All tests for the Node Reference Model are completed!
ok
test_proof_model (database.tests.ProofModelTestCase.test_proof_model) ... All tests for the Proof Model are completed!
ok
test_create (database.tests.RegisterSerializerTestCase.test_create) ... All tests for the RegisterSerializer are completed!
ok
test_validate_true (database.tests.RegisterSerializerTestCase.test_validate_true) ... All tests for the RegisterSerializer are completed!
ok
test_accept (database.tests.RequestModelTestCase.test_accept) ... ok
test_db (database.tests.RequestModelTestCase.test_db) ... ok
test_reject (database.tests.RequestModelTestCase.test_reject) ... ok
test_accept (database.tests.ReviewRequestTestCase.test_accept) ... Test for the ReviewRequest Model is completed!
ok
test_reject (database.tests.ReviewRequestTestCase.test_reject) ... Test for the ReviewRequest Model is completed!
ok
test_get_review_requests (database.tests.ReviewerModelTestCase.test_get_review_requests) ... All tests for the Reviewer Model are completed!
ok
test_inheritance (database.tests.ReviewerModelTestCase.test_inheritance) ... All tests for the Reviewer Model are completed!
ok
test_reviewer_create (database.tests.ReviewerModelTestCase.test_reviewer_create) ... All tests for the Reviewer Model are completed!
ok
test_reviewer_serializer_fields (database.tests.ReviewerSerializerTestCase.test_reviewer_serializer_fields) ... All tests for the ReviewerSerializer are completed!
ok
test_nodes (database.tests.SemanticTagModelTestCase.test_nodes) ... All tests for the Semantic Tag Model are completed!
ok
test_search (database.tests.SemanticTagModelTestCase.test_search) ... All tests for the Semantic Tag Model are completed!
ok
test_theorem_model (database.tests.TheoremModelTestCase.test_theorem_model) ... All tests for the Theorem Model are completed!
ok
test_user_serializer_fields (database.tests.UserSerializerTestCase.test_user_serializer_fields) ... All tests for the UserSerializer are completed!
ok
test_finalize_workspace (database.tests.WorkspaceModelTestCase.test_finalize_workspace) ... All tests for the Workspace Model are completed!
ok
test_workspace_model (database.tests.WorkspaceModelTestCase.test_workspace_model) ... All tests for the Workspace Model are completed!
ok

----------------------------------------------------------------------
Ran 59 tests in 214.981s

OK
Destroying test database for alias 'default' ('test_postgres')...
```

## Frontend and Mobile

# General Test Plan

We implement unit tests for every model and API call method we develop. Each team member assigned to implement a specific project feature is also expected to create unit tests for that particular feature. Using mock data, we test the functionality of the implemented features and then open a pull request. Our merge strategy enforces the successful completion of all unit tests; hence, if some tests fail, the pull request cannot merged. For automated unit testing, we utilize Django's standard test framework. This framework creates a new test database for this purpose, populating the tables with mock data provided by us. The test database is destroyed once the tests are completed.

For the client application, we conducted manual screen tests to ensure that all functionality is working as excepted. We run the tests for various user scenerios , including login/logout, navigation between pages, submitting forms, and viewing and interacting with content. In addition, we tested each others work to detect possible errors and bugs.

# Annotations

## Status

We have carefully considered the implementation of annotations in our project, addressing aspects such as eligibility to add annotations, visibility of annotations, and their specific locations.

In the frontend, we devised a design on paper to illustrate how annotations should be presented to users and how users can add new annotations. The decision was made to integrate annotations into the Node View Page, which serves as a detailed page for nodes. This is crucial as certain texts may require additional clarification.

Currently, we have implemented a preliminary structure for annotations in the frontend. At this stage, "anyone" can add and view annotations; however, this functionality is not yet connected to the backend, and all annotations in the projects are currently placeholders.

Additionally, we encountered challenges with our Latex Renderer engine in conjunction with annotations. The integration of these two components may be excessively complex, that we may need alternative solutions to facilitate for addition of annotations.

## Plans

Our upcoming plans involve organizing a meeting between the Backend and Frontend teams to collaboratively explore ways to establish communication between the backend and frontend for annotation display. Subsequently, we aim to implement an authorization mechanism to restrict annotation addition to only node contributors. Finally, we will establish a link between the frontend and backend to facilitate the addition and display of annotations in the appropriate locations.

Apart from them as a Frontend team we will discuss how we can create a conjunction between annotation and latex renderer.

# List and Status of Deliverables

| Name                                                   | Status    |
| ------------------------------------------------------ | --------- |
| The Summary of the Project Status and Our Future Plans | Delivered |
| The Summary of the Customer Feedback and Reflections   | Delivered |
| Changes Since Milestone 1 and Our Future Plans         | Delivered |
| Progress According to Requirements                     | Delivered |
| API Endpoints                                          | Delivered |
| Generated Unit Test Reports                            | Delivered |
| General Test Plan                                      | Delivered |
| Annotation Technology and Future Plans                 | Delivered |
| Individual Contributions                               | Delivered |

# Individual Contribution Reports

## Member: Ahmed Bera Pay

**Responsibilities:** I am at the back-end development. I have implemented a few models and some API methods rather. I also reviewed my teammates' works related to backend. Additionally I attended meetings regularly and contributed to discussions about implementation and design choices.

**Main contributions:** I have implemented POST/PUT methods to create and update status of collaboration or review requests. Corresponding tests for these have been developed as well. In order to enhance the GET method for Node responses, I have introduced new Serializer classes to include all fields from models related with Node. Additionally, I reviewed backend-related pull requests of my teammates.

**Code-related significant issues:**

- [Node GET API Enhancement](https://github.com/bounswe/bounswe2023group9/issues/407)
- [BE - API Methods Implementation for Requests](https://github.com/bounswe/bounswe2023group9/issues/445)
- [BE - POST API Method for Sending Collaboration Request](https://github.com/bounswe/bounswe2023group9/issues/446)
- [BE - Implementation of Approve for Collaboration Request](https://github.com/bounswe/bounswe2023group9/issues/447)
- [BE - Implementation of POST Method for Review Request](https://github.com/bounswe/bounswe2023group9/issues/449)
- [BE - Node GET API Update](https://github.com/bounswe/bounswe2023group9/issues/486)

**Management-related significant issues:**

- [Node GET API Enhancement](https://github.com/bounswe/bounswe2023group9/issues/407)
- [BE - API Methods Implementation for Requests](https://github.com/bounswe/bounswe2023group9/issues/445)
- [BE - Node GET API Update](https://github.com/bounswe/bounswe2023group9/issues/486)
- [Milestone Report #2 should be prepared](https://github.com/bounswe/bounswe2023group9/issues/535)

**Pull requests:**
**Created:**

- [Implement return of random node](https://github.com/bounswe/bounswe2023group9/pull/499)
- [Implement Request POST Methods](https://github.com/bounswe/bounswe2023group9/pull/460)
- [Update serializers.py](https://github.com/bounswe/bounswe2023group9/pull/410)

**Reviewed:**

- [Profile GET API bug fix](https://github.com/bounswe/bounswe2023group9/pull/519)
- [Milestone Scenarios Added to the Lab Report 7](https://github.com/bounswe/bounswe2023group9/pull/495)
- [Request parent model implementation](https://github.com/bounswe/bounswe2023group9/pull/426)
- [Search and Profile GET API Update](https://github.com/bounswe/bounswe2023group9/pull/417)

**Additional information:**

## Member: Ahmet Abdullah Susuz

**Responsibilities:** I was a part of the frontend team, actively contributing to the development and enhancement of various features. I worked on graph page design, structure and enhancement.

**Main contributions:** I am mostly involved in graph pages. I contributed and developed its design and its logic. I helped with its provider structure and also decided some design choices. I implemented token logic. I inserted token logic to user model and change authorization methods according to it.

**Code-related significant issues:**

- Implementation of token for authorization [#480](https://github.com/bounswe/bounswe2023group9/issues/480)
- Show random node in graph page [#443](https://github.com/bounswe/bounswe2023group9/issues/443)
- Web Graph Preview Node [#441](https://github.com/bounswe/bounswe2023group9/issues/441)
- Implementation of the graph page for web [#404](https://github.com/bounswe/bounswe2023group9/issues/404)

**Management-related significant issues:**

- Individual Contribution Report [#554](https://github.com/bounswe/bounswe2023group9/issues/554)

**Pull requests:**

- Add token implementation for authorization [#518](https://github.com/bounswe/bounswe2023group9/pull/518)
- Graph page, node preview popup [#464](https://github.com/bounswe/bounswe2023group9/pull/464)
- Graph Web Page [#433](https://github.com/bounswe/bounswe2023group9/pull/433)
- Implement random graph page in opening [#523](https://github.com/bounswe/bounswe2023group9/pull/523)

## Member: Ali Mert Geben

**Responsibilities:** I was a part of the back-end team, so my responsibilities mainly
revolved around back-end tasks like the first milestone. My overall responsibilities were
creation or enhancement of database models and their test cases as well as implementation of API methods to be used in the front-end and documenting them inside Postman.

**Main contributions:** I have implemented the Workspace and Entry models into the database with regards to the class diagram that was drawn before. I have also updated the Workspace GET API and implemented various small API methods. Furthermore, I wrote the
test cases for these methods and models.

**Code-related significant issues:**

- Entry Class Implementation [#401](https://github.com/bounswe/bounswe2023group9/issues/401)

- Implementation of various API methods. [#469](https://github.com/bounswe/bounswe2023group9/issues/469)

- Workspace Model/Class Implementation. [#356](https://github.com/bounswe/bounswe2023group9/issues/356)

- Workspace GET API Update. [#456](https://github.com/bounswe/bounswe2023group9/issues/356)

**Management-related significant issues:**

- Individual Contribution Report [#537](https://github.com/bounswe/bounswe2023group9/issues/537)

**Pull requests:**
Created:

- Workspace GET API Update [#500](https://github.com/bounswe/bounswe2023group9/pull/500)

- Implementation of various API methods [#470](https://github.com/bounswe/bounswe2023group9/pull/470)

- Entry Class Implementation [#429](https://github.com/bounswe/bounswe2023group9/pull/429)

- Workspace Model/Class Implementation [#413](https://github.com/bounswe/bounswe2023group9/pull/413)

There were only minor conflicts in these PRs caused by the placement of
code blocks. I merely just changed the classes’ place in the code.

Reviewed:

- Workspace backend bug fix [#498](https://github.com/bounswe/bounswe2023group9/pull/498)
- Workspace GET APIs [#459](https://github.com/bounswe/bounswe2023group9/pull/459)
  I have reviewed the code and tested the functionality in both of these PRs in my local workspace and both of them passed the tests and there were no
  conflicts.

**Additional information:** Workspace model implementation was started before this milestone but wasn’t finished. I also worked with my teammates to design a test scenario in order to be used in the demo.

## Member: Arda Arslan

**Responsibilities:** Being a member of back-end team requires understanding of updates from other team members to the database models and representative classes. Also communication with front-end team is very important when writing API endpoints, back-end application must serve the information in the most appropriate way the front-end program requires.

**Main contributions:** My main contribution was to write remaining classses and to reflect them on database. I also did prepare the API documentation, wrote the description and example use cases for the ones missing. I checked some methods of implementing access control to our system but this further was postponed upon team decision, prioritization of necessities is considered wisely within team.

**Code-related significant issues:**

- ReviewRequest Class Implementation [#400](https://github.com/bounswe/bounswe2023group9/issues/400)
- CollaborationRequest Class Implementation [#305](https://github.com/bounswe/bounswe2023group9/issues/305)
- Role Related Access Control [#400](https://github.com/bounswe/bounswe2023group9/issues/400)
- Preparation of API Documentation [#488](https://github.com/bounswe/bounswe2023group9/issues/488)

**Pull requests:**

- CollaborationRequest and ReviewRequest class implementation [#427](https://github.com/bounswe/bounswe2023group9/pull/427)
- (Reviewed) Entry Class Implementation [#429](https://github.com/bounswe/bounswe2023group9/pull/429)
- (Reviewed) Workspace Model Implementation [#413](https://github.com/bounswe/bounswe2023group9/pull/413)

**Additional information:** API documentation is not deployed on our servers yet. So we are providing the pdf file of the documentation.

## Member: Bengisu Kübra Takkin

## Responsibilities

I am a part of the frontend team. I am working on both web and mobile page implementation and design. My overall responsibilities were creation or enhancement of frontend pages and writing providers for them. My responsibilities include staying informed about messages and project updates, as well as actively participating in weekly meetings.

## Main Contributions

- Profile Page Enhancement [#481](https://github.com/bounswe/bounswe2023group9/issues/481)
- Web Workspace Page Enhancement [#478](https://github.com/bounswe/bounswe2023group9/issues/478)
- Enhance Graph Page [#442](https://github.com/bounswe/bounswe2023group9/issues/442)
- Web Graph Page [#433](https://github.com/bounswe/bounswe2023group9/pull/433)
- Enhancement for Profile Settings [#334](https://github.com/bounswe/bounswe2023group9/issues/334)

## Pull Requests

- Profile Page Design [#527](https://github.com/bounswe/bounswe2023group9/pull/527)
- Graph Web and Mobile Enhancement[ #510](https://github.com/bounswe/bounswe2023group9/pull/510)
- Settings Provider [#482](https://github.com/bounswe/bounswe2023group9/pull/482)
- Web Graph Page [#433](https://github.com/bounswe/bounswe2023group9/pull/433)

## Additional Information

Enhancement for Profile Settings task was intended to be completed just before the first milestone. Page design was completed however it wasn’t connected to the backend. In the second milestone, I wrote the provider for the page and connected to the backend. Also profile page design is a completed pull request but not merged to the main branch yet.

## Member: Leyla Yayladere

**Responsibilities:** I am part of the front-end team, tasked with designing and implementing responsive, reliable, and user-friendly interfaces. My responsibilities also include reviewing team members' work, actively engage in project meetings, and contribute to project discussions and progress documentation.

**Main contributions:** I contributed to the initial implementation and later bug fixes in our routing logic with GoRouter. I created distinct 'please login' pages for workspace, notification, and profile, ensuring proper redirection with GoRouter. I researched and implemented a Latex renderer for the theorems and proofs of nodes. I cleaned the database by removing dummy data and added fundamental theorems in language theory, complexity theory, calculus, and arithmetic in proper format for our Latex renderer called Katex. I also implemented error handling on pages with the same logic, addressing missing error handling or improving messages. Additionally, I always commented or reviewed PR requests that involved changes to the code I was familiar with.

**Code-related significant issues:**

- GoRouter Implementation [#308](https://github.com/bounswe/bounswe2023group9/issues/308)
- Latex and MD Renderer Research [#431](https://github.com/bounswe/bounswe2023group9/issues/431)
- Latex Implementation and DB adjustment [#473](https://github.com/bounswe/bounswe2023group9/issues/473)
- Error Handling on Pages [#425](https://github.com/bounswe/bounswe2023group9/issues/425)
- Configuration of Specific Please Login Pages [#474](https://github.com/bounswe/bounswe2023group9/issues/474)
- You May Like Feature on Node Page [#517](https://github.com/bounswe/bounswe2023group9/issues/517)

**Management-related significant issues:**

- Milestone Report 2 [#535](https://github.com/bounswe/bounswe2023group9/issues/535)
- I helped preparation of draft of all weekly progress reports, particularly wrote parts related to general team work.Additionally, I reminded my teammates to complete their respective parts.

**Pull requests:**

- Advanced Routing Implementation [#421](https://github.com/bounswe/bounswe2023group9/pull/421)
- Latex Implementation [#511](https://github.com/bounswe/bounswe2023group9/pull/511)
- Error Handling [#466](https://github.com/bounswe/bounswe2023group9/pull/466)
- Specific Please Login Pages [#496](https://github.com/bounswe/bounswe2023group9/pull/496)
- You May Like Feature [#522](https://github.com/bounswe/bounswe2023group9/pull/522)
- Bug Fix [#434](https://github.com/bounswe/bounswe2023group9/pull/434), [#465](https://github.com/bounswe/bounswe2023group9/pull/465)
- Reviews:
  - Mobil Workspace Page [#506](https://github.com/bounswe/bounswe2023group9/pull/506)
  - Generic UI Enhancement [#514](https://github.com/bounswe/bounswe2023group9/pull/514)
  - App Bar Bug Fix and Search Bar Enhancement [#520](https://github.com/bounswe/bounswe2023group9/pull/520)
  - Node View Page [#437](https://github.com/bounswe/bounswe2023group9/pull/437)
  - Frontend File Organization [#415](https://github.com/bounswe/bounswe2023group9/pull/415)

## Member: Mehmet Süzer

**Responsibilities:** I am a member of the frontend team which is responsible for designing responsive and user-friendly UI. I mainly worked on the design part of the project.

**Main contributions:** I designed the mobile pages of graphs and workspaces. In addition, I solved some overflow and alignment problems in both web and mobile. I made significant changes for the mobile app design to be compatible with the web design.

**Code-related significant issues:**

- Design of the Mobile Graph Page [#402](https://github.com/bounswe/bounswe2023group9/issues/402)
- Design of the Mobile Workspace Page [#440](https://github.com/bounswe/bounswe2023group9/issues/440)
- Enhancement of the Mobile Workspace Page [#476](https://github.com/bounswe/bounswe2023group9/issues/476)

**Management-related significant issues:**

- Individual Contribution Report [#539](https://github.com/bounswe/bounswe2023group9/issues/539)
- Description of any Changes Since Milestone 1 or Plans for the Future [#541](https://github.com/bounswe/bounswe2023group9/issues/541)
- List and Status of Deliverables [#547](https://github.com/bounswe/bounswe2023group9/issues/547)
- The Summary of the Project Status and Our Future Plans [#540](https://github.com/bounswe/bounswe2023group9/issues/540)

**Pull requests (Created):**

- Mobile Graph Page [#414](https://github.com/bounswe/bounswe2023group9/pull/414)
- Mobile Workspace Design [#463](https://github.com/bounswe/bounswe2023group9/pull/463)
- Enhance Workspace [#494](https://github.com/bounswe/bounswe2023group9/pull/494)
- Further Enhancement for Workspace [#506](https://github.com/bounswe/bounswe2023group9/pull/506)

**Pull requests (Reviewed):**

- Provider Implementation for Workspace [#502](https://github.com/bounswe/bounswe2023group9/pull/502)
- List View Fix [#507](https://github.com/bounswe/bounswe2023group9/pull/507)

**Additional information:** I also worked on connecting provider to the workspace page, but the task couldn't be completed until the deployment deadline. Significant refinements on the implementation of the workspace pages were needed to be able to add the providers to these pages. I also helped one of my teammate solving a problem about the router [#471](https://github.com/bounswe/bounswe2023group9/pull/471).

## Member: Ömer Faruk Ünal

**Responsibilities:** As a member of the frontend team, I have been tasked with both creating and maintaining the frontend of our application. For this milestone, I focused on addressing challenging aspects. Additionally, I took on the responsibility of reviewing and fixing numerous pages designed by my teammates.

**Main contributions:** Because of my experience and familiarity with the technology stack, I conducted code reviews for almost everyone on the team and managed conflicts. I provided assistance to my colleagues in resolving challenging and significant conflicts. I implemented intricate components that have a widespread impact on all the pages we have developed so far, such as the router, annotation system, and search bar. Furthermore, I introduced new features to the screens designed by my teammates and fixed many of the bugs.

**Code-related significant issues:**

- GoRouter Implementation [#308](https://github.com/bounswe/bounswe2023group9/issues/308)
- Advance Navigating Bar Router [#422](https://github.com/bounswe/bounswe2023group9/issues/422)
- Connect Provider to Graph Page [#423](https://github.com/bounswe/bounswe2023group9/issues/423)
- Make Texts Selectable Text and Intro to Annotation [#432](https://github.com/bounswe/bounswe2023group9/issues/432)
- Enhance Graph Page [#442](https://github.com/bounswe/bounswe2023group9/issues/442)
- Semantic Tag Search [#479](https://github.com/bounswe/bounswe2023group9/issues/479)
- Share Button [#492](https://github.com/bounswe/bounswe2023group9/issues/492)
- Fix ListViewBuilder [#493](https://github.com/bounswe/bounswe2023group9/issues/493)
- Show Random Nodes in Home Page [#508](https://github.com/bounswe/bounswe2023group9/issues/508)
- UI Improvements [#513](https://github.com/bounswe/bounswe2023group9/issues/513)
- You May Like [#517](https://github.com/bounswe/bounswe2023group9/issues/517)

**Management-related significant issues:**

- Every week, through discussions with my teammates, I allocated work equitably by considering their availability and capabilities. Additionally, I communicated with the Backend team, providing instructions on the results of endpoints to be returned and establishing deadlines to ensure we had enough time for frontend implementation.

**Pull requests:**

- Advanced Routing Implementation [#421](https://github.com/bounswe/bounswe2023group9/pull/421)
- Web Graph Page [#433](https://github.com/bounswe/bounswe2023group9/pull/433)
- Annotation design [#458](https://github.com/bounswe/bounswe2023group9/pull/458)
- Graph node preview [#464](https://github.com/bounswe/bounswe2023group9/pull/464)
- Share item implementation [#505](https://github.com/bounswe/bounswe2023group9/pull/505)
- List view UI fix [#507](https://github.com/bounswe/bounswe2023group9/pull/507)
- Search semantic UI [#509](https://github.com/bounswe/bounswe2023group9/pull/509)
- Generic UI enhancement [#514](https://github.com/bounswe/bounswe2023group9/pull/514)
- App bar bug fix - Search bar enhancement [#520](https://github.com/bounswe/bounswe2023group9/pull/520)
- Add suggestions to node view page [#522](https://github.com/bounswe/bounswe2023group9/pull/522)
- Reviews:
  - Random Graph Page [#523](https://github.com/bounswe/bounswe2023group9/pull/523)
  - Web workspace page enhancements [#521](https://github.com/bounswe/bounswe2023group9/pull/521)
  - User token added [#518](https://github.com/bounswe/bounswe2023group9/pull/518)
  - Basic user model created [#516](https://github.com/bounswe/bounswe2023group9/pull/516)
  - Implement Latex Renderer [#511](https://github.com/bounswe/bounswe2023group9/pull/511)
  - Graph web and mobile enhancement [#510](https://github.com/bounswe/bounswe2023group9/pull/510)
  - Provider is implemented for workspace [#502](https://github.com/bounswe/bounswe2023group9/pull/502)
  - Configuration of different please login pages and their routing [#496](https://github.com/bounswe/bounswe2023group9/pull/496)
  - Settings provider [#482](https://github.com/bounswe/bounswe2023group9/pull/482)
  - Web workspace page [#471](https://github.com/bounswe/bounswe2023group9/pull/471)
  - Error handling in pages [#466](https://github.com/bounswe/bounswe2023group9/pull/466)
  - AnnotationText Path Fix [#465](https://github.com/bounswe/bounswe2023group9/pull/465)
  - Mobile workspace [#463](https://github.com/bounswe/bounswe2023group9/pull/463)
  - Node to graph navigate [#456](https://github.com/bounswe/bounswe2023group9/pull/456)
  - App bar routing fix [#434](https://github.com/bounswe/bounswe2023group9/pull/434)
  - Improved node details provider [#419](https://github.com/bounswe/bounswe2023group9/pull/419)
  - Fixed issues related with the new file structure [#418](https://github.com/bounswe/bounswe2023group9/pull/418)

**Additional information:** xx

## Member: Ömer Şükrü Uyduran

**Responsibilities:**
I was a member of the backend sub-team and assigned for implementation of Request Class/Model and update of Semantic Tag Class/Model. I was also assigned to make a research for WikiData API and its utilization. Also, I was assigned to update the Workspace POST API considering the updates in the Semantic Tag, authorization checks, and newly utilized Wikidata API.

**Main contributions:**
I attended to all of the laboratories and meetings. I made contributions while we, as a team or backend sub-team, were making decisions about significant issues. I have communicated with the product owners and discussed the necessary functionalities with them on behalf of the team. I reviewed my teammates' code related contributions, gave feedback to them, and helped them if they needed. Lastly, I have fulfilled all tasks that have been assigned to me. I also documented the APIs that are implemented by me in the postman workspace of the team.

**Code-related significant issues:**

- Request Class/Model - [#399](https://github.com/bounswe/bounswe2023group9/issues/399)
- Semantic Tag Class/Model Update - [#451](https://github.com/bounswe/bounswe2023group9/issues/451)
- WikiData API Research and Utilization - [#453](https://github.com/bounswe/bounswe2023group9/issues/453)
- Workspace POST API Update - [#489](https://github.com/bounswe/bounswe2023group9/issues/489)

**Management-related significant issues:**

- Individual Contibution Report - [#544](https://github.com/bounswe/bounswe2023group9/issues/544)
- A summary of the customer feedback and reflections - [#542](https://github.com/bounswe/bounswe2023group9/issues/542)
- Progress according to the requirements - [#559](https://github.com/bounswe/bounswe2023group9/issues/559)

**Pull requests:**

Created:

- Request parent model implementation - [#426](https://github.com/bounswe/bounswe2023group9/pull/426)
- Semantic tag with wikidata api - [#468](https://github.com/bounswe/bounswe2023group9/pull/468)
- Workspace post api update - [#501](https://github.com/bounswe/bounswe2023group9/pull/501)
- add weekly report 7 - [#490](https://github.com/bounswe/bounswe2023group9/pull/490)
- Backend cumulative pr to main - [#524](https://github.com/bounswe/bounswe2023group9/pull/524)

Reviewed:

- CollaborationRequest and ReviewRequest class - [#427](https://github.com/bounswe/bounswe2023group9/pull/427)
- Role Related Access Control - [#467](https://github.com/bounswe/bounswe2023group9/pull/467)
- Implement return of random node - [#499](https://github.com/bounswe/bounswe2023group9/pull/499)
- Basic user getter implementation - [#504](https://github.com/bounswe/bounswe2023group9/pull/504)
- Semantic and Random search implementation - [#487](https://github.com/bounswe/bounswe2023group9/pull/487)

**Additional information:**
I gave detailed feedbacks to my teammates in my reviews and also in personal. I resolved some conflicts before merges. I back my teammates up when they needed help with technical and non-technical issues.

## Member: Zülal Molla

**Responsibilities:** I am a member of the front-end team. I am responsible for implementing a reliable and user friendly interface. Other than reviewing other members' work, I was mainly in charge of improving node details page and creating the web workspaces page.
**Main contributions:** I enhanced UI&UX of the node details page for both mobile and web. I implemented the workspaces page for web application after I created the necessary models. I also created a provider to get data used in the workspaces page.

**Code-related significant issues:**

- Web Workspace Page Enhancement [#478](https://github.com/bounswe/bounswe2023group9/issues/478)
- Create Workspace Provider [#475](https://github.com/bounswe/bounswe2023group9/issues/475)
- Workspace Page Models for Frontend [#461](https://github.com/bounswe/bounswe2023group9/issues/461)
- Web Workspace Page [#439](https://github.com/bounswe/bounswe2023group9/issues/439)
- Node View Details Page UI Bug [#420](https://github.com/bounswe/bounswe2023group9/issues/420)
- Enhance Node View Page [#406](https://github.com/bounswe/bounswe2023group9/issues/406)
- Organize Frontend File Structure [#405](https://github.com/bounswe/bounswe2023group9/issues/405)

**Pull requests:**

- **Created:**

  - frontend files are organized [#415](https://github.com/bounswe/bounswe2023group9/pull/415)
  - Enhance node view page [#437](https://github.com/bounswe/bounswe2023group9/pull/437)
  - Improved node details provider [#419](https://github.com/bounswe/bounswe2023group9/pull/419)
  - workspace models are created [#462](https://github.com/bounswe/bounswe2023group9/pull/462)
  - Web workspace page [#471](https://github.com/bounswe/bounswe2023group9/pull/471)
  - provider is implemented for workspace [#502](https://github.com/bounswe/bounswe2023group9/pull/502)

- **Reviewed:**
  - Design of the Graph Page for Mobile [#414](https://github.com/bounswe/bounswe2023group9/pull/414)
  - Mobile workspace [#463](https://github.com/bounswe/bounswe2023group9/pull/463)
  - Graph node preview [#464](https://github.com/bounswe/bounswe2023group9/pull/464)
  - Enhance workspace [#494](https://github.com/bounswe/bounswe2023group9/pull/494)

**Additional information:**



## Member: Hakan Emre Aktas	
**Responsibilities:** 


As part of the backend team, I have completed several tasks related to implementation of new features. I also solved several bugs. Aside from implementation, I actively participated in the meetings and contributed to the discussions related to the implementation of the whole project. Furthermore, as the team communicator, I ensured that the wishes of the Customers are well received.

**Main contributions:**

Deployment, Implementation, Dockerization, Database maintanence.

**Code-related significant issues:**


Fixed a bug that affects profile page api [#515](https://github.com/bounswe/bounswe2023group9/issues/515)
Implemented a API function to get basic user information from the session token [#503](https://github.com/bounswe/bounswe2023group9/issues/503)
GET API implementation for Workspace Page [#450](https://github.com/bounswe/bounswe2023group9/issues/450)
Added question fields to the GET api of Profile page [#416](https://github.com/bounswe/bounswe2023group9/issues/416)
Fixed several bugs that affect the POST apis of the Workspace page [#497](https://github.com/bounswe/bounswe2023group9/issues/497)



**Management-related significant issues:**


Contributed to the creation of Milestone scenario and test scenario

**Pull requests:**


**Created:**


 - Workspace backend bug fix [#498](https://github.com/bounswe/bounswe2023group9/pull/498)
 - Addition of milestone scenarios [#495](https://github.com/bounswe/bounswe2023group9/pull/495)
 - Semantic and Random search implementation [#487](https://github.com/bounswe/bounswe2023group9/pull/487)
 - Workspace GET API [#459](https://github.com/bounswe/bounswe2023group9/pull/459)
 - Search and profile page API update [#417](https://github.com/bounswe/bounswe2023group9/pull/417)
 - Profile page API bug fix [#519](https://github.com/bounswe/bounswe2023group9/pull/519)
 - Basic User GET API [#504](https://github.com/bounswe/bounswe2023group9/pull/504)

**Reviewed:**

 - Workspace post api update (with token authentication) [#501](https://github.com/bounswe/bounswe2023group9/pull/501)
 - Workspace GET api update [#500](https://github.com/bounswe/bounswe2023group9/pull/500)
 - Implementation of various api methods [#470](https://github.com/bounswe/bounswe2023group9/pull/470)
 - Semantic tag and wikidata implementation [#468](https://github.com/bounswe/bounswe2023group9/pull/468)
 - Implementation of POST request methods [#460](https://github.com/bounswe/bounswe2023group9/pull/460)
 - Update Node model serializers [#410](https://github.com/bounswe/bounswe2023group9/pull/410)
 - Change backend url  [#483](https://github.com/bounswe/bounswe2023group9/pull/483)


**Additional information:**
	Over the course of the last month, I have fixed issues related to the database and ensured that it is up and running at all times. This included cleaning unwanted migrations and applying unapplied ones. I also deployed the updated version of the backend of our application after almost every PR merge to ease the process of front end development. Aside from that, I also implemented the renderer to render the API documentation of the backend. I am also responsible for deploying the front end.de 



