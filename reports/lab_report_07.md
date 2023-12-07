# Project Development Weekly Progress Report #7

**Team Name:** Collaborative Science Platform

**Date:** 21.11.2023

## Progress Summary
**This week**, on backend, all API functions needed for the workspace page are implemented and merged. Moreover, wikidata api has been utilized and connected to the semantic tag class. On frontend, graph page is enhanced with navigation between nodes on the graph. Workspace page is designed and implemented without functionality for mobile and web. Solutions for rendering math formulas have been researched. Annotation implementation has begun.

**Subteams:**
- **Front-end Team**: Zülal, Bengisu, Abdullah, Mehmet, Ömer Faruk, Leyla
- **Back-end Team**: Ömer Şükrü, Ahmed Bera, Oğuz, Hakan, Arda, Ali Mert

**Our objective for the following week**, enhancements for improved user-friendliness on various pages and final touches for the milestone. We plan to implement a LaTeX renderer for math formulas and add semantic tag functionality. Additionally, workspace will be functioning according to backend, bringing all core functionalities of the app ready for presentation to the customer.

## What was planned for the week? How did it go?
| Description | Issue | Assignee | Due | Estimated Duration | Actual Duration | PR |
| --- | --- | --- | --- | --- | --- | --- |
| Implement Error Handler To Pages | [#425](https://github.com/bounswe/bounswe2023group9/issues/425) | Leyla | 21.11.2023 | 2hr | 2hr | [#466](https://github.com/bounswe/bounswe2023group9/pull/466) |
| Research Latex and MD renderer | [#431](https://github.com/bounswe/bounswe2023group9/issues/431) | Leyla | 21.11.2023 | 5hr | 4hr | NA |
| Make Texts Selectable Text and Intro to Annotation | [#432](https://github.com/bounswe/bounswe2023group9/issues/432) | Ömer Faruk | 21.11.2023 | 8hr | 8hr | [458](https://github.com/bounswe/bounswe2023group9/pull/458) |
| Enhance Graph Page | [#442](https://github.com/bounswe/bounswe2023group9/issues/442) | Bengisu | 14.11.2023 | 2hr | 2hr |
| Web Workspace Page | [#439](https://github.com/bounswe/bounswe2023group9/issues/439) | Zülal | 21.11.2023 | 6hr | 6hr | [471](https://github.com/bounswe/bounswe2023group9/pull/471) |
| Mobile Workspace Page | [#440](https://github.com/bounswe/bounswe2023group9/issues/440) | Mehmet | 21.11.2023 | 6hr | 10hr | [#463](https://github.com/bounswe/bounswe2023group9/pull/463) |
| Web Graph Preview Node | [#441](https://github.com/bounswe/bounswe2023group9/issues/441) | Abdullah | 21.11.2023 | 4hr | 3hr| [#464](https://github.com/bounswe/bounswe2023group9/pull/464)|
|Role-Related Access Control|[#444](https://github.com/bounswe/bounswe2023group9/issues/444)| Arda Arslan| 20.11.2023| 10hr | 4hr| [#467](https://github.com/bounswe/bounswe2023group9/pull/467)|
|API Methods Implementation for Requests|[#445](https://github.com/bounswe/bounswe2023group9/issues/445)| Ahmed Bera | 18.11.2023| 4hr | 4hr | [#460](https://github.com/bounswe/bounswe2023group9/pull/460)
|GET API for Workspace Page|[#450](https://github.com/bounswe/bounswe2023group9/issues/450)| Hakan | 20.11.2023| 4hr | 4hr | [#459](https://github.com/bounswe/bounswe2023group9/pull/459)
| Semantic Tag Class/Model Implementation | [#451](https://github.com/bounswe/bounswe2023group9/issues/451) | Ömer Şükrü | 21.11.2023 | 5hr| 6hr | [#468](https://github.com/bounswe/bounswe2023group9/pull/468) |
| Third Party API Research and Utilization For Semantic Tag Functionality | [#453](https://github.com/bounswe/bounswe2023group9/issues/453) | Ömer Şükrü | 21.11.2023 | 6hr | 6hr | [#468](https://github.com/bounswe/bounswe2023group9/pull/468) |



## Completed tasks that were not planned for the week
| Description  | Issue | Assignee | PR |
| -------- | ----- | -------- | --- |
| FE-Workspace Page Models for Frontend | [#461](https://github.com/bounswe/bounswe2023group9/issues/461) | Zülal | [#462](https://github.com/bounswe/bounswe2023group9/pull/462) |
| Enhancement for Profile Settings | [#334](https://github.com/bounswe/bounswe2023group9/issues/334) | Bengisu | [#482](https://github.com/bounswe/bounswe2023group9/pull/482) |
| BE - Implementation of various API methods | [#469](https://github.com/bounswe/bounswe2023group9/issues/469) | Ali Mert | [#470](https://github.com/bounswe/bounswe2023group9/pull/470) |

## Planned vs. Actual
- Advance Navigation Bar for Routing Options, issue [#422](https://github.com/bounswe/bounswe2023group9/issues/422), could not be completed. It didn't block anything and change any plans, it will be implemented next week.
- We decided to postpone the access related control for now. Thus, PR [#467](https://github.com/bounswe/bounswe2023group9/pull/467) is not merged or deleted.
- Implementation of Request API methods is merged after the planned date due to some improvement needs.
- Enhancing graph page design is postponed to next week. It's decided to give priority to connecting settings page to the backend instead (PR [#482](https://github.com/bounswe/bounswe2023group9/pull/482)) since it's a design task and it won't affect functional mechanism of the project.

## Your plans for the next week
| Description | Issue | Assignee | Due | Estimated Duration |
| --- | --- | --- | --- | --- |
| FE - Implement Latex | [#473](https://github.com/bounswe/bounswe2023group9/issues/473) | Leyla | 27.11.2023 | 3hr |
| FE - Configure Please Login Page | [#474](https://github.com/bounswe/bounswe2023group9/issues/474) | Leyla | 27.11.2023 | 2hr |
| FE - Web Workspace Page Enhancement | [#478](https://github.com/bounswe/bounswe2023group9/issues/478) | Zülal, Bengisu | 27.11.2023 | 2hr |
| FE - Mobile Workspace Page Enhancement | [#476](https://github.com/bounswe/bounswe2023group9/issues/476) | Mehmet, Bengisu | 27.11.2023 | 5hr |
| FE - Create Workspace Provider | [#475](https://github.com/bounswe/bounswe2023group9/issues/475) | Zülal | 27.11.2023 | 2hr |
| FE - Connect Provider to Workspace Page | [#477](https://github.com/bounswe/bounswe2023group9/issues/477) | Mehmet | 27.11.2023 | 2hr |
| FE - Semantic Tag Search | [#479](https://github.com/bounswe/bounswe2023group9/issues/479) | Abdullah, Ömer Faruk | 27.11.2023 | 5hr |
| FE - User Get Token | [#480](https://github.com/bounswe/bounswe2023group9/issues/480) | Abdullah | 27.11.2023 | 1hr |
| FE - Advance Navigation Bar for Routing Options  | [#422](https://github.com/bounswe/bounswe2023group9/issues/422) | Ömer Faruk | 27.11.2023 | 3hr |
| FE - Show Random Graph  | [#443](https://github.com/bounswe/bounswe2023group9/issues/422) | Abdullah | 27.11.2023 | 2hr |
| Enhance Graph Page | [#442](https://github.com/bounswe/bounswe2023group9/issues/442) | Bengisu | 21.11.2023 | 3.5hr | |
| Semantic Tag Search enhancement | [#344](https://github.com/bounswe/bounswe2023group9/issues/344) | Hakan | 27.11.2023 | 5hr |
| Workspace Get Update | [#484](https://github.com/bounswe/bounswe2023group9/issues/484) | Ali Mert | 27.11.2023 | 3hr |
| Node Model Update | [#485](https://github.com/bounswe/bounswe2023group9/issues/485) | Ahmed Bera | 27.11.2023 | 1hr |
| Node GET API Update | [#486](https://github.com/bounswe/bounswe2023group9/issues/486) | Ahmed Bera | 27.11.2023 | 3hr |
| Preparation of API Documentation| [#488](https://github.com/bounswe/bounswe2023group9/issues/488) | Arda Arslan | 27.11.2023 | 5hr |
| Workspace POST API will be updated | [#489](https://github.com/bounswe/bounswe2023group9/issues/489) | Ömer Şükrü | 28.11.2023 | 3hr |


## Scenarios

### Milestone Scenario

-------- WEB ---------
- Contributor(Mehmet Suzer) logins using login page. 
- After logging in, he sees the search bar. There are random nodes in the home page. 
 - Scrolls down to see homepage is infinitely scrollable. 
 - He writes a keyword in the search bar and searches for it. Sees the semantic search functionality at the bottom. 
 - He clicks one of them and makes a semantic search, search results are related to the keyword via parent-child relations of the semantic tags.
- He received instructions beforehand about creating a workspace, adding "Cem Say" and "Utkan Gezer" as contributors as well as adding a couple theorems as references. He only remembers one of them.
 - He creates the workspace by providing a workspace name and adds "Cem Say" and "Utkan Gezer" as contributors. He adds the theorem he remembers as a reference. In order to find the reference he doesn't remember, he clicks the node he added as a reference.
 - The page of that theorem opens up and he sees public annotations on this page. He clicks to the button "see the graph" and the graph page opens up. He finds the node that he wants to add in this page.
 - He goes back to the workspace and adds the other node as a reference.
 - He adds an entry to the workspace and edits it.

------- MOBILE --------
 - Another contributor (Cem Say) logins using login page of the mobile application.
 - He steps into the workspace page.
 - He accepts the collaboration request from Mehmet.
 - He looks around to see some features of the mobile app that are previously shown on the website.

### Possibly Covered Requirements in Customer Milestone 2

### 1. Functional Requirements

### 1.1 User Requirements
- 1.1.1 User Types
    - 1.1.1.1 Guests
        - 1.1.1.1.1 Guests shall be able to view the nodes and their references.
        - 1.1.1.1.2 Guests shall be able to view the contributors and reviewers of the nodes.
        - 1.1.1.1.4 Guests shall be able to sign-up.
    - 1.1.1.2 Basic users
        - 1.1.1.2.2 Basic users shall be able to create private annotations for a node.
        - 1.1.1.2.4 Basic users shall be able to perform the same actions as guests except sign-up.
    - 1.1.1.3 Contributors
        - 1.1.1.3.1 Contributors shall be able to create workspaces.
        - 1.1.1.3.2 Contributors shall be able to reference their workspaces from existing nodes.
        - 1.1.1.3.4 Contributors shall be able to add annotations that will be public after creating a node from the workspace to the workspaces they create before the reviewing process.
        - 1.1.1.3.7 Contributors shall be able to track the progress of their workspace and edit the entries.
        - 1.1.1.3.8 Contributors shall be able to perform the same actions as basic users.
        - 1.1.1.3.10 Contributors shall be able to add semantic tags to their workspaces.
- 1.1.2 User Interactions
    - 1.1.2.1 Contributors shall be able to send a collaboration request to another contributor.
    - 1.1.2.2 Contributors shall be able to accept or reject a collaboration request.
    - 1.1.2.3 Contributors shall be able to see and contribute to the workspaces they collaborate.
- 1.1.3 Sign up & Login
    - 1.1.3.1 Users shall provide their real names, e-mail addresses, and passwords to sign up.
    - 1.1.3.2 E-mail addresses shall be unique.
    - 1.1.3.3 User passwords shall meet safety criteria
- 1.1.4 Profile Preferences
    - 1.1.4.1 Basic users shall be able to change their passwords.
    - 1.1.4.2 Basic users shall have profile pages.
    - 1.1.4.3 Basic users shall be able to let their profile pages show their activity.
    - 1.1.4.4 Guests shall be able to view other users' profile pages. ?????? (bu var çünkü author aradıktan sonra profil görünüyor)
    - 1.1.4.5 Basic users shall be able to edit their own profile information.
    - 1.1.4.6 Basic users shall be able to turn on or off the email notifications.

### 1.2 System Requirements

- 1.2.1 Nodes
    - 1.2.1.2 Nodes shall be referenceable/linkable to other nodes.
    - 1.2.1.3 Nodes shall have semantic tags regarding to their subjects.
    - 1.2.1.4 Nodes shall have a questions/answers section.
    - 1.2.1.6 Nodes shall have public annotations.
- 1.2.2 Reviews
    - 1.2.2.5 Workspaces' chosen first and final entries are sent to the reviewers to be reviewed.
- 1.2.4 Annotations
    - 1.2.4.1 Public annotations should be visible to anyone.
    - 1.2.4.2 Private annotations should be visible only to their creator.
- 1.2.5 Search
    - 1.2.5.1 Searching
        - 1.2.5.1.1 The platform shall allow users to search for users and nodes.
    - 1.2.5.2 Filtering
        - 1.2.5.2.1 Nodes shall be filtered by their semantic tags.
        - 1.2.5.2.2 Nodes shall be filtered by their contributors.
- 1.2.7 Graph Visualization
    - 1.2.7.1 The platform shall visualize the graph.
- 1.2.9 Workspaces
    - 1.2.9.1 Workspaces shall let contributors add editable entries.
    - 1.2.9.2 Workspaces shall be collaborative via sending request to desired contributors.
    - 1.2.9.3 Workspaces shall have first and final entries chosen by the contributors before they are submitted for the review.
    - 1.2.9.4 Workspaces shall let referenced nodes to be cited in the current work.
    - 1.2.9.5 Workspaces shall be visible to only the contributors of the workspace.

### 2. Non-functional Requirements

- 2.1 Availability
    - 2.1.1 The system shall be available in the English language.
- 2.2 Standards
    - 2.2.1 Annotations shall be compliant with W3C annotation standards
- 2.4 Security
    - 2.4.1 User passwords shall be stored as hashed in the database.



### Test Scenario
| Step | Action | Expected Outcome |
| --- | --- | --- |
| 1. | Open up the website | Observe random nodes on the homepage with a search bar at the top of the page |
| 2. | Search for **theorem**s using keyword: _finite state machine_ | View related nodes |
| 3. | Search for **author**s using their name or mail: _Utkan Gezer_ | View _Utkan Gezer_ profile |
| 4. | Search for content written **by** an author using their name or email: _Utkan Gezer_ | View nodes written by _Utkan Gezer_ |
| 5. | Search for **both** using keyword  | View profiles, nodes, or a mix of both in the results related to keyword |
| 6. | Click any of the results | Either profile page for that user or node view page of that node opens up |
| 7. | Click to sign in | Login page opens up |
| 8. | Login with given credentials; _email: john.doe@email.com , password: Pass123!_ | Become an authenticated user |
| 9. | Click to profile | Own profile page opens up |
| 10. | Click to one of the nodes in the profile | Node view page opens up for that node |
| 11. | Click to proofs tab in node view | See proofs of that node |
| 12. | Click to reference tab in node view | See reference of that node |
| 13. | Click to citations tab in node view | See citations of that node |
| 14. | Click to see graph button | Graph page of that node opens |
| 15. | Click to reference in graph | See preview of reference |
| 16. | Click to go that reference in graph | Graph page of that reference node opens up |
| 17. | Click to logout button | User logs out, reverting to a guest status |

## Risks
- We might encounter challenges rendering LaTeX math formulas and implementing annotations to formulas. A potential workaround could involve separating explanations and formulas for clarity.

## Participants
- Ahmed Bera Pay
- Ahmet Abdullah Susuz
- Ali Mert Geben
- Arda Arslan
- Bengisu Kübra Takkin
- Hakan Emre Aktaş
- Leyla Yayladere
- Mehmet Süzer
- Ömer Faruk Ünal
- Ömer Şükrü Uyduran
- Zülal Molla
