# Cmpe451 2023 - Final Project Deliverables

### Video: [video link](https://drive.google.com/drive/folders/19cJjTXpYUrv4onLyVnvAxpwDbQdP1dSB?usp=drive_link)

### Executive summary

All types of users (guests, basic users, contributors, reviewers, admin) are implemented. A non-authorized user (guest) can search for theorems in our platform. In order to ask question, add annotation, and get notified via email, the guest must signup, login, and become a basic user. All these pages ready to use. We care our users' privacy and security. Therefore, a guest must have a strong password which meets our password criteria and accept our privacy policy to become a member of our platform. Otherwise, the guest cannot signup. 

Once the guest becomes a basic user, he/she can ask questions about theorems and get notified via email. A basic user can become a contributor by entering his/her ORCID ID. 

Once he/she becomes a contributor, the workspace page is open to him/her. In the workspace page, a contributor can create totally new workspaces and create a workspace on top of other theorems. He/she can can create entries, which are basically individual small bits of knowledge, and label them as theorem or proof. He/she can edit existing entries. Entries can be labeled as claim or proof. In addition, entries can be labeled as disproof if the workspace created from another node. A workspace can have exactly one claim (theorem) and multiple proofs. We have Katex renderer in our workspace page and a write-preview feature which similar to the one in the GitHub. 

A contributor can send collaboration requests to other contributors in order to work on the same project together. He/she also can refer to other theorems in his/her workspaces. Contributors can accept or reject collaboration requests. Before responding the request, contributors can see a read-only version of the workspace. Contributors are able to add semantic tags to their workspaces to categorize them.  

After everything is done, a contributor can finalize his/her workspace and send it to reviewers. Contributors can see the comments of the reviewers anonymously. 

Reviewers can see the list of workspaces that they already accepted to review and they have been requested to be review. Reviewer can see the workspaces they have been requested to be review before accepting the request. If a reviewer accept a review request, he/she can add their comment on the workspace and approve or reject the work. Reviewers can't see the contributors of the workspaces that they are assigned as reviewer. If randomly selected two reviewers approve the work, a node with the content of the workspace is created and published.

Another type of user is admin. An Admin can hide questions and theorems if he/she finds it inappropriate. The admin also can ban users. Finally, the reviewers are selected by admin. If the admin finds a reviewer inadequate, he/she can unrank a reviewer to contributor. 

### Final release notes

Web Link : http://13.51.205.39/
Back-End URL: http://13.51.55.11:8000/
Annotation Service URL: http://13.51.55.11:8001/

Almost all of the desired functionality is implemented as one can see in the software requirements status table. Some known errors/bugs:
- References/Citations are not updated upon creation of a node.
- There is a bug related to SSL that prevents the addition of semantic tags to workspaces in the deployed version of web application. Works fine in mobile and local web application
- There are some overflows in admin buttons.
- The profile settings page is unresponsive. It saves the information when the save button is pressed, but it does not give feedback. Please wait a bit after clicking and then close the pop-up.
- Semantic Search works but is a bit difficult to perform. We tried to make it better, but it is caused by the flutter widget.
- In the deployed version of the web application, refreshing the page causes the user to log out. This does not happen in the local web app. Please click some other page and go back if you need to refresh the page.  

### Management
### The changes we made and their Impacts

1. In the last milestone we couldn't present the workspace page because the task of connecting the frontend to backend was left to the last day. Unfortunately, the task couldn't be completed due of the lack of some features in the frontend, such as not providing ids of references in the add reference pop up, and many conflicts in the git. In this milestone, we cumulatively connected the frontend to backend instead of leaving it to the last day. 

2. The frontend and the backend team have usually worked separately up to the second milestone. In the last couple of weeks, This was not the case. We worked more interactively and solved the bugs and errors more quickly. As a result, our progress was much faster. 

3. In the weeks before the second milestone, The number of people that worked on the same files was usually more than one. AS a result, many conflicts had to be resolved to combine the work of different people. After the second milestone, We assigned tasks more individually. Each person was responsible of a part/file of the platform/repository. Hence, the number conflicts decreased.

### Final Demo Reflections

Our final demo was not as good as we expected. Some bugs that hadn't been handled caused problem during the demo. We couldn't show the full functionality of our platform in the given time. It would have been better to spend more time fixing the bugs before the demo. 

We also think that it was not a good idea to start explaining the platform starting from the admin features. Instead, we should have made a brief introduction to our platform. Our main product customer was familiar to our platform; therefore, we didn't think it was necessary to explain what a workspace, an entry is etc. However, there were some people in the audience who had no idea about our platform. As a result, they didn't understand some concepts and the purpose of our scientific collaboration platform in the beginning of the demo. 

### What could have done differently?

After each milestone, we gave a week break to the project. As a result we lost 2 weeks in total. We could have spend this time solving the bugs we encountered up to that time. In addition, weekly tasks were usually completed in a hurry on Sunday and Monday evenings, which resulted in poor works. The weekly tasks could have been completed in a much more controlled way. As discussed above, the task of connecting the front end to the back end could have been done cumulatively from the beginning of the project. 

In addition, we spent most of the lab sessions discussing the requirements and general features of the application. We believe those discussions were productive, but because of those long discussions we usually had little to no time to discuss API development between the front-end and back-end teams. This caused a lot of confusion and error during the development process.

### Software Requirements Status

| ID   | Name                                                                                                      | Status       | Notes                                                  |
| ---- | --------------------------------------------------------------------------------------------------------- | ------------ | ------------------------------------------------------ |
|1.1.1.1.1 | Guests shall be able to view the nodes and their references. | Completed | |
|1.1.1.1.2 | Guests shall be able to view the contributors and reviewers of the nodes. | 50% Completed | We decided not to display reviewers of the nodes publicly|
|1.1.1.1.3 | Guests shall be able to view the questions, answers, semantic tags, and public annotations of each node. | Completed | |
|1.1.1.1.4 | Guests shall be able to sign-up. | Completed | |
|1.1.1.2.1 | Basic users shall be able to ask questions about a node and have the option to choose whether their identity become public or anonymous when asking a question. | %80 Completed | The anonymity part is not fully functional. |
|1.1.1.2.2 | Basic users shall be able to create private annotations for a node. | Completed | |
|1.1.1.2.3 | Basic users shall be able to be notified via email when their questions are replied. | Completed | |
|1.1.1.2.4 | Basic users shall be able to perform the same actions as guests except sign-up. | Completed | |
|1.1.1.3.1 | Contributors shall be able to create workspaces. | Completed | |
|1.1.1.3.2 | Contributors shall be able to reference their workspaces from existing nodes. | Completed | |
|1.1.1.3.3 | Contributors shall be able to be notified via email . | Completed | |
|1.1.1.3.3.4 |Contributors shall be able to be notified via email when another contributor sends a collaboration request. | Completed | |
|1.1.1.3.3.5 |Contributors shall be able to be notified via email when a user asks a question about his/her node. | Completed | |
|1.1.1.3.4 |Contributors shall be able to add annotations that will be public after creating a node from the workspace to the workspaces they create before the reviewing process. | 80% Completed | Contributors cannot add annotations to workspaces |
|1.1.1.3.5 |Contributors shall be able to issue an objection against a node. | %50 Completed | There is a counter proof mechanism but it is not fully functional |
|1.1.1.3.6  | Contributors shall be able to link external scientific materials to support his/her claim/node. | Not Done | Contributors may add external links directly to the entries. |
|1.1.1.3.7  |Contributors shall be able to track the progress of their workspace and edit the entries. | Completed | |
|1.1.1.3.8  | Contributors shall be able to perform the same actions as basic users. | Completed | |
|1.1.1.3.9 | Contributors shall be able to send their workspaces to review which is further to be added to the graph as a node.| Completed | |
|1.1.1.3.10 |Contributors shall be able to add semantic tags to their workspaces. | Completed | |
|1.1.1.4.1 |Reviewers shall be able to accept or reject the workspaces which are submitted by contributors | Completed | |
|1.1.1.4.2 |Reviewers shall be able to accept or reject the objections issued by contributors. | Completed | |
|1.1.1.4.3 |  Reviewers shall be able to add comments to entries regarding to the review process.| Completed | |
|1.1.1.4.4  |Reviewers shall be able to perform the same actions as contributors. | Completed | |
|1.1.1.5.1 | Admins shall be able to remove (hide) nodes. | Completed | |
|1.1.1.5.2 | Admins shall be able to ban user accounts. | Completed | |
|1.1.1.5.3 |Admins shall be able to remove (hide) questions. | Completed | |
|1.1.1.5.4  |Admins shall be able to remove (hide) answers. | Completed | |
|1.1.1.5.5  | Admins shall be able to choose which contributors can be reviewers.| Completed | |
|1.1.1.5.6 |Admins shall be able to perform the same actions as basic users. | Completed | |
|1.1.2.1 |Contributors shall be able to send a collaboration request to another contributor. | Completed | |
|1.1.2.2 | Contributors shall be able to accept or reject a collaboration request.| Completed | |
|1.1.2.3 | Contributors shall be able to see and contribute to the workspaces they collaborate.| Completed | |
|1.1.2.4 |Contributors shall be able to reply asked questions about his/her nodes. | Completed | |
|1.1.3.1  |Users shall provide their real names, e-mail addresses, and passwords to sign up. | Completed | |
| 1.1.3.2|  E-mail addresses shall be unique.| Completed | |
|1.1.3.3 |User passwords shall meet safety criteria | Completed | |
|1.1.3.4 | E-mail addresses shall be confirmed. | Completed | |
| 1.1.3.5|Basic users shall provide and confirm their ORCID-ID in order to be a contributor. | Completed | |
|1.1.4.1 | Basic users shall be able to change their passwords. | Completed | |
| 1.1.4.2 |Basic users shall have profile pages. | Completed | |
|1.1.4.3 | Basic users shall be able to let their profile pages show their activity. | Completed | |
| 1.1.4.4 | Guests shall be able to view other users' profile pages. | Completed | |
| 1.1.4.5| Basic users shall be able to edit their own profile information.| Completed | |
| 1.1.4.6| Basic users shall be able to turn on or off the email notifications.| Completed | |
|1.2.1.1  |Nodes shall contain bits of knowledge that can represent a type of knowledge at any step in the scientific knowledge development process. | Completed | We decided not to include the development process to the nodes. |
|1.2.1.2  |Nodes shall be referenceable/linkable to other nodes. | Completed | |
| 1.2.1.3 | Nodes shall have semantic tags regarding to their subjects.| Completed | |
| 1.2.1.4 | Nodes shall have a questions/answers section.| Completed | |
| 1.2.1.5 | Nodes shall be objectable by contributors.| Completed | |
| 1.2.1.6 | Nodes shall have public annotations.| Completed | |
| 1.2.1.7 | Nodes shall be created and published upon approval of a workspace.| Completed | |
| 1.2.2.1 | The platform shall assign some number of randomly chosen related reviewers (according to semantic tags) for a node or objection. | Completed | |
| 1.2.2.2 |The platfrom shall not allow contributors and reviewers to see each others' identities when a node or an objection is being reviewed. | Dismissed | Contributor and Reviewer information during a review should be confidential. |
| 1.2.2.3 |The platform shall provide the contributors a report prepared by reviewers when a review process is rejected. | Completed | |
| 1.2.2.4 | A reviewer cannot be assigned as a reviewer for his/her own workspace. | Completed | |
| 1.2.2.5 |Workspaces' chosen first and final entries are sent to the reviewers to be reviewed. | Completed | The entries does not have to be the first and last. |
|1.2.3.1 |Questions shall be sorted either by date or by popularity. | Completed | |
|1.2.3.2 |Questions shall be repliable by the contributors of the node. | Completed | |
|1.2.4.1 |Public annotations should be visible to anyone. | Completed | |
|1.2.4.2 |  Private annotations should be visible only to their creator.| Completed | |
|1.2.5.1.1 | The platform shall allow users to search for users and nodes.| Completed | |
|1.2.5.2.1 |Nodes shall be filtered by their semantic tags. | Completed | |
|1.2.5.2.2 |Nodes shall be filtered by their contributors. | Completed | |
|1.2.5.2.3 |Nodes shall be filtered by their reviewers. | Completed | |
|1.2.5.3.1 | Nodes shall be sorted by their publish date.| Completed | |
|1.2.5.3.2 |Nodes shall be sorted by their popularity. | Completed | |
|1.2.5.3.2.1  |Nodes shall be sorted by their visits. | Completed | |
| 1.2.5.3.2.2 |Nodes shall be sorted by their number of references. | Not Completed |  |
|1.2.7.1 |The platform shall visualize the graph. | Completed | |
|1.2.8.1 |Email notifications shall include a message which contains information about the cause or reason behind it. | Completed | |
| 1.2.8.2|Email notifications shall only be delivered to users who are directly concerned. | Completed | |
| 1.2.8.3| Email notifications shall be sent immediately after the event that triggers them occurs.| Completed | |
| 1.2.8.4| Email notifications should be sent only once. | Completed | |
|1.2.9.1 |Workspaces shall let contributors add editable entries. | Completed | |
|1.2.9.2 | Workspaces shall be collaborative via sending request to desired contributors.| Completed | |
|1.2.9.3 |Workspaces shall have first and final entries chosen by the contributors before they are submitted for the review. | Completed | |
|1.2.9.4 | Workspaces shall let referenced nodes to be cited in the current work. | Completed | |
|1.2.9.5 |Workspaces shall be visible to only the contributors of the workspace. | Completed | |
|2.1.1 |The system shall be available in the English language. | Completed | |
|2.2.1 |Annotations shall be compliant with W3C annotation standards | Completed | |
|2.3.1 |The system shall comply with the rules defined by GDPR and KVKK. | Completed | |
|2.4.1 |User passwords shall be stored as hashed in the database. | Completed | |

## Progress Based on Teamwork

We first designed the login and signup pages and implemented the necessary API for them. Then, we started working on the general structure of the pages. After we selected a suitable design for it, we started implementing the home page. We added a search bar to search contributors and theorems, and we added a list view to list what was pulled from the database depending on the search filters. We also completed the general layout of the profile page. After the first milestone, We started working on the relations page, also known as 'graph' page. In this page, a user can see the references and citations of a theorem in a single page. After it was completed, the workspace page was our main concern. Since the most of the features related to our platform were about the workspace page, we spent several weeks working on the workspace page. some of the features are creating entries, rendering katex, sending collaboration request, referencing other theorems, sending to review, and accepting/rejecting review requests. In the last weeks before the final milestone, we added annotations and semantic tags. Finally, the platform was adjusted for the use cases of an admin.

| Name | Work |
| --------| ------------ | 
| [Hakan Emre Aktas](https://github.com/bounswe/bounswe2023group9/wiki/Hakan-Emre-Aktas) | As a member of the backend team, I have implemented several API endpoints with their tests and documentation. I tried to be as active as possible in the discussions we had during the weekly meetings on implementation, requirements, and design. I also maintained the database and made sure all the changes made in the implementation were reflected in the database. Furthermore, I was responsible for the DevOps of both the front-end and the back-end of the application. | 
| [Ahmed Bera Pay](https://github.com/bounswe/bounswe2023group9/wiki/Ahmed-Bera-Pay) | As a member of the backend team, I have worked on implementing various API methods and their tests as well as documenting them in Postman after our regular meetings each week. I attended the discussions about design and implementation choices and expressed my ideas to contribute in them. I also contributed to the research and the implementation of annotations aligning with W3C standards. Also, as much as I could, I responded and fixed the bugs encountered on frontend as quickly as possible.
| [Ömer Şükrü Uyduran](https://github.com/bounswe/bounswe2023group9/wiki/%C3%96mer-%C5%9E%C3%BCkr%C3%BC-Uyduran) | As a member of backend team; I implemented ORM models, API endpoints, and their unit tests in general. I documented my API endpoints in our Postman workspace, and created examples for them. I designed the structural outline of the backend project and initiated it. I attended our weekly lab meetings, discussed design and management topics with my teammates, and contributed to the decision making about our tech selections and project plan. I also discussed the specifications of some complex features (like semantic tagging, semantic search, and annotation functionality) with product owners and explained them to my teammates. I also took place in the research and implementation of semantic tagging, semantic search, and annotation service in the backend side. Furthermore; I fixed some of the bugs, gave my backend teammates detailed pull request reviews. I checked and ensured everyone is on the same page about requirements as much as I can. I contributed to the preparation of some of the meeting reports and uploaded them, I contributed to the preparation of the scenario and mock data of our final demo. | 
| [Mehmet Süzer](https://github.com/bounswe/bounswe2023group9/wiki/Mehmet-S%C3%BCzer) | As a member of the frontend team, I mainly focused on designing pages, creating reusable widgets, and fixing render bugs. I also reported some of the problems that I encountered in the last weeks to the backend team . I spend a great deal of time making web and mobile design similar. I wrote providers for user and workspace semantic tags. | 
| [Ahmet Abdullah Susuz](https://github.com/bounswe/bounswe2023group9/wiki/Ahmet-Abdullah-Susuz)                 | I am member of the frontend team. My main responsibilities were designing and creating user interfaces also connecting backend with providers. I was mostly involved in the logic the admin features and question/answer page. Also, I was responsible for writing privacy policy.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| [Ali Mert Geben](https://github.com/bounswe/bounswe2023group9/wiki/Ali-Mert-Geben) | I was a member of the backend team for all semester. My main tasks were implementing API functions with unit test and documenting them on the Postman, implementing database models for various classes according to class diagram and the creation of e-mail notification system. I also joined my teammates in the regular weekly meetings as well as finding and fixing bugs that may have occured previously.| 
| [Arda Arslan](https://github.com/bounswe/bounswe2023group9/wiki/Arda-Arslan) | | 
| [Zülal Molla](https://github.com/bounswe/bounswe2023group9/wiki/Z%C3%BClal-Molla)| I am a member of the frontend team. I mostly worked on the design and the implementation of the user interfaces for both mobile and web. I wrote several providers to make user interfaces functional. Screens that I had a significant contribution to are node details page and workspaces page. I also wrote some widgets to be used in other pages. I made research on ORCID authentication process. | 
| [Leyla Yayladere](https://github.com/bounswe/bounswe2023group9/wiki/Leyla-Yayladere) | As a member of the frontend team, my primary focus was on developing the logic and implementing various user interface features for both mobile and web platforms. Notably, I contributed to the routing mechanism, latex rendering engine, and annotation mechanism. My significant contributions include the development of the node details and profile pages. Furthermore, I authored explanatory pages aimed at informing users of different levels (guests, basic users, etc.) about the functionalities available to them and the benefits of signing in or becoming a contributor. Throughout the project, I focused on learning from my peers in code reviews, understanding the existing code and adding to it in a clear and structured way.|  
| [Omer Faruk Unal](https://github.com/bounswe/bounswe2023group9/wiki/%C3%96mer-Faruk-%C3%9Cnal) |In the project, I focused on using my frontend development experience to contribute to planning, structuring, and maintenance. I played a role in shaping all screens, whether as a contributor or reviewer. I spent time checking pull requests, resolving conflicts, and providing feedback to improve the codebase. My goal was to ensure a smooth and cohesive user experience. Overall, I aimed to bring practical expertise to the project, contributing to its success through a combination of development and quality assurance efforts. I implemented generic pages, routing mechanism, annotation, many providers and authentication mechanisms.| 
| [Bengisu Kübra Takkin](https://github.com/bounswe/bounswe2022group3/wiki/Bengisu-Takkin) | I am a member of the frontend team. I mostly worked on the design and the implementation of the user interfaces for both mobile and web. Screens that I had significant contribution were profile page, settings page, admin features and relations page. I wrote the providers for them too. During this semester my aim was to be a good teammate, participate and contribute as much as possible and learn as much as i can. I put a great effort to read others code and learn from them. | 


### API Endpoints

[API Documentation](http://13.51.55.11:8000/api/docs/)

We prepared an API documentation using Swagger/OpenAPI. You can find it [here](http://13.51.55.11:8000/api/docs/)
You can also find several examples in the documentation. Most of the functions have at least one example in them (not all, unfortunately). We added several examples to some of the most crucial API calls like get_node and search. All of the required parameters should be included in the documentation as well. PLEASE don't forget to add the Authorization token if you wish to use the API functions that require authentication (All POST/PUT/DELETE functions and some of the GET functions).

### User Interface / User Experience
**Source Code**
* [Home Page](https://github.com/bounswe/bounswe2023group9/tree/main/project/FrontEnd/collaborative_science_platform/lib/screens/home_page)
* [Workspaces Page](https://github.com/bounswe/bounswe2023group9/tree/main/project/FrontEnd/collaborative_science_platform/lib/screens/workspace_page)
* [Node Details Page](https://github.com/bounswe/bounswe2023group9/tree/main/project/FrontEnd/collaborative_science_platform/lib/screens/node_details_page)
* [Relations Page](https://github.com/bounswe/bounswe2023group9/tree/main/project/FrontEnd/collaborative_science_platform/lib/screens/graph_page)
* [Sign-In, Sign-up Screens](https://github.com/bounswe/bounswe2023group9/tree/main/project/FrontEnd/collaborative_science_platform/lib/screens/auth_screens)
* [Profile Page
](https://github.com/bounswe/bounswe2023group9/tree/main/project/FrontEnd/collaborative_science_platform/lib/screens/profile_page)

**Screenshots** 

Home page and relations page are same for all user types.

### Mobile
**Home Screen**

<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/54028102-43be-4c95-b91f-35a621ce0c8a" width="300">

**Relations Screen**

<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/6732715a-e44b-4889-aa18-ca4449663980" width="300">
<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/37b6cdbe-5fa5-4e65-89ce-109aeea526b3" width="300">
<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/be022b34-0481-439a-b40a-473202321659" width="300">

### Web
**Home Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/7ea2b91f-4951-4cbe-a8be-0c0869a388f0)
**Relations Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/b07bf178-0861-4e14-9042-8d175552ccb7)
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/6c3cfd53-ecd9-4acd-b7c7-691eb91f2afb)


## Guest User
### Mobile
|Workspaces Screen | Node Details|Profile Screen|
|---|---|---|
|<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/ae74d069-1641-48dd-85b3-825a45757f3c" width="300"> | <img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/93609dfd-cd0c-4d1a-a70c-3eb507bfc79e" width="300">|<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/4a97f6de-9a2d-4564-a019-bf0029dfd582" width="300">|

| Sign In Screen |Sign Up Screen|
|---|---|
|<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/2e65848a-7ade-4b53-8bf4-8db3d13c50bd" width="300">| <img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/0964f9a0-4d49-4a7b-9737-bc389e362dd2" width="300">| 

### Web

**Workspaces Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/65d90924-6c9a-4378-be3d-aa20ff84c196)
**Node Details**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/0f16067d-2157-4199-9474-624f8909f3c8)
**Sign In Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/2cff10d9-d916-40a7-8931-4b2042514670)
**Sign Up Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/2f28a221-d2c7-4c59-9392-4505bcb0cd68)

***

## Basic User
### Mobile
|Workspaces Screen | Node Details |Profile Screen|
|---|---|---|
|<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/4798d52e-8626-415e-a1f9-65f006a475b2" width="300"> | <img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/93609dfd-cd0c-4d1a-a70c-3eb507bfc79e" width="300">|<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/5781053b-fe82-4547-947b-f70c7ef135f8" width="300">|

### Web
**Workspaces Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/2fc53308-05a1-41cf-9b65-0df82c36276a)
**Node Details**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/0f16067d-2157-4199-9474-624f8909f3c8)
**Profile Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/151a0679-b1cc-4bc2-a2c4-04ec718845dc)
***

## Contributor
### Mobile

**Workspaces Screen**

<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/72391eec-0192-4194-a9c0-e0b79155f66d" width="300">
<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/fb019c31-1487-4ac3-9be9-2e68d13685a7" width="300">
<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/d688889c-a0a0-47d0-8349-f1e1478658e2" width="300">
<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/e9f9678c-1c86-48af-b24c-028f9f4a9467" width="300">
<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/a49e37f3-7d0d-467a-96a4-902b2ee31be9" width="300">

**Node Details**

<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/a7725644-3456-46a5-974a-5254905db0ac" width="300">

**Profile Screen**

<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/0accf956-2035-4e72-b2ea-f8e1e76c1d01" width="300">
<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/84565e94-4d52-4078-8aa3-b96e52abf306" width="300">

### Web
**Workspaces Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/557c5f9a-a26a-4b4c-a038-5a6f8376cc69)
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/d8baf25c-2885-4fee-81c3-926f7c79bad0)
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/3b2faf1a-5488-4031-8631-7f553bc96dc8)

**Node Details**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/1655a497-7c9a-4fbb-aff1-7103bb965e04)

**Profile Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/7528c9da-7b7a-4ded-ba99-7de7dfd02964)

***

## Reviewer
Reviewers see the same screens with contributors except the workspaces page.
### Mobile

<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/f3923646-0338-43da-9ef8-cf67c5120c66" width="300">
<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/27c2754c-3375-43d6-ad8b-d825a95e7252" width="300">
<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/66e43492-0d7a-4620-aed3-76020e06d0dd" width="300">
<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/5d0da824-da18-466d-b16b-769fa58b84d7" width="300">

### Web
**Workspaces Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/95f0f472-b7ed-4c82-a587-e8069224dd8b)
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/ef0e29e6-56e7-479d-bb00-65d10dbe9b95)
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/1b877190-1a08-4f65-82d3-4f0e13fbb8dc)

***
## Admin
### Mobile
**Workspaces Screen**

<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/27af590c-93c6-4981-a0cd-c044643053b5" width="300">

**Node Details Screen**

<img src="https://github.com/bounswe/bounswe2023group9/assets/111250696/ea467386-bed3-4083-804f-382ede724dd2" width="300">

### Web
**Workspaces Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/113efc73-eea1-4d5c-a890-727347ba3d84)

**Node Details Screen**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/c53e86eb-12a3-460e-b2de-d840fc4fed87)
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/f852dee4-a548-4971-967a-6222a8a1fb54)

**Profile Screen of Other Users**
![image](https://github.com/bounswe/bounswe2023group9/assets/111250696/6b579493-9a48-4e94-9dce-215c7e7f119c)


### Annotations
On the backend, we have implemented annotations based on W3C standards. These standards have the following conformance keywords: "may," "must," "must not," "not recommended," "recommended," "should," and "should not". Our implementation aligns with the "must" and "must not" standards, but the "should" and "recommended" standards are partially implemented. For instance, we have implemented the annotation delete feature, but the edit functionality is not available. Our annotation data models, request and response bodies constructed according to W3C standards.

On the frontend, we've established an intuitive annotation system for theorems and proofs of nodes. Users can select text, which is then highlighted in green, and right-click to access the "Add Annotation" option. This action triggers a pop-up for entering the annotation text, along with a KaTeX rendered version of the selected text, a feature designed to address challenges in annotating KaTeX content. For existing annotations, right-clicking offers two options: "Show Annotation," which displays both the annotation body and the KaTeX rendered text, and "Update Annotation," allowing users to edit and replace an existing annotation at the same location with new content, operates through a combination of DELETE and POST API calls. Our platform supports two types of annotations: _Public Annotations_, marked in pink, which can be added by node contributors and are visible to all visitors of that node page, and _Individual Annotations_, highlighted in purple, for personal notes by logged-in users and can be added by non-contributors of that node, visible only to their creator. These annotations are stored in the same manner on the annotation server. Individual annotations are showed to only their creator through page rendering and API calls using unique user parameters.

We were notified about image annotations in the last week before the final milestone, and as a result, we are still working on implementing image annotations in the week following the milestone. Ultimately, our platform will support two types of annotations: one for textual annotations related to theorems, claims, and proofs, one for selections on images associated with questions asked for a theorem or claim.

### Scenarios
Scenario - 1:
A student called Bengisu works on a new approach on Bubble Sort with her friend Leyla. They decided to use the collaborative science platform. Leyla already a contributor in the platform.
- Bengisu sign-ups to platform 
- She first explores the home page as a newcomer. 
- Then she searchs the bubble sort in the search bar and finds node, views node details.
- She checks nodes related to bubble sort.
- She decides to add their work to bubble sort node so she enters her ORCID to become a contributor in the platform.
- She creates a new workspace from bubble sort and add their new claim and proof to this workspace. 
- After adding their work, she sends a collabration request to Leyla and then sends the workspace to review. 
- The workspace is reviewed and accepted by the reviewers in the platform (which are Alper and Tunga).

Scenario - 2:
Cem Say, a contributor in the platform realizes that he is being imitated by someone else in the platform and reports this user to platform admin.
- Admin examines the situation and decides that the report is valid. Then admin bans this user.

Scenario - 3:
Two Cem Say's students enter to the platform in both mobile and web to view their teachers work. 
- After they search and find the nodes writed by their teacher, they make use of relations part in the website to see citations and references of their teacher's nodes. 

# Project Artifacts
     
 ## Manuals

### Run Back End 
o build a docker image, 
 - `docker build --tag <your-tag> .`

Please be sure your database server is running before run the container. You can check below for database setup.

To run the container,
 - `docker run -p 8000:8000 <your-tag>`

The first port number (8000) is the port number of your machine your service runs. Please be sure that the specified port is available. The second one is your container's port number and should be same as the one exported in the Dockerfile. (8000 for this project.)

Dont forget to set the following environment variables,
- DJANGO_SECRET_KEY: You can generate one by running `python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'`. Note that, this key should be kept hidden from public and you cannot change it later since all of the hashes are generated from this key.
- DATABASE_NAME: should be the name of the PostgreSQL database
- DATABASE_USER: should be the username of the owner of the created database, for root user: postgres
- DATABASE_PASSWORD: should be the password of the owner of the created database, for root user: postgres
- DATABASE_HOST: should be the address of your database server, in local: 127.0.0.1
- DATABASE_PORT: should be the port number of your database server, default: 5432
- EMAIL_HOST_USER: should be a real gmail email address, this is for sending user's email notifications
- EMAIL_HOST_PASSWORD: should be the password of the gmail email address used as EMAIL_HOST_USER
- ADMIN_EMAIL: should be the same as EMAIL_HOST_USER

You can set them while running the container like the following
- `docker run -p 8000:8000 -e DJANGO_SECRET_KEY=<your-secret-key> <your-tag>`

### Run Web Application
#### Running the Flutter App locally
follow these steps:

1. Make sure you have Flutter installed. If not, you can install it by following the official Flutter installation guide: [Flutter Installation](https://flutter.dev/docs/get-started/install).

2. Navigate to your project directory:

`cd your-path-to-project/collaborative_science_platform`

3.  Ensure you have the latest dependencies by running:

`flutter pub get`

4. Build and run the web version of your app with the following command:

`flutter build web --release`

`flutter run -d web`

#### Releasing an Android App

1. Navigate to your project directory:

`cd your-path-to-project/collaborative_science_platform`

2. Build the release APK for Android using the following command:

`flutter build apk --split-per-abi`

This will generate the APK files in the `build/app/outputs/flutter-apk` directory.

 **Using Docker**

To create a docker image, run:



`docker build -t <tag-name> .`



To create a container from that image:


`docker run -p 80:80 <tag-name>`


After starting the container you can access the website at `http://localhost`

### Software Requirements Specification (SRS)  
Requirements Specification can be found [here](https://github.com/bounswe/bounswe2023group9/wiki/Requirements).

### Software design documents (using UML)
 Diagrams can be found in the following links:
- [Use Case Diagram](https://github.com/bounswe/bounswe2023group9/wiki/Class-Diagram)
- [Class Diagram](https://github.com/bounswe/bounswe2023group9/wiki/Use-Case-Diagram)
- [Sequence Diagrams](https://github.com/bounswe/bounswe2023group9/wiki/Sequence-Diagrams)

### User scenarios and mockups

Mock-ups can be found in the following links:
-    [Contributor]( https://github.com/bounswe/bounswe2023group9/wiki/Scientist-Contributor)
-    [Reviewer]( https://github.com/bounswe/bounswe2023group9/wiki/Reviewer)
-    [Guest User]( https://github.com/bounswe/bounswe2023group9/wiki/Guest-to-Normal-User)
-    [Collaborator]( https://github.com/bounswe/bounswe2023group9/wiki/Collaborator)

### Research
We did a comprehensive research on annotations, beginning with an exploration of the concept itself and then delving into the W3C standards. We carefully examined the general standard guidelines for annotations and researched the “vocabulary” concept. Additionally, we spent some time to better understand the structure upon which the standards are built. 
Believing gained a good understanding of the fundamentals of annotations and their standards, including the protocols for retrieval and creation, we proceeded to the implementation.
### Project plan

Project plan can be found [here](https://github.com/bounswe/bounswe2023group9/wiki/Project-Plan).

### Unit tests reports
* #### Unit tests for the main backend application
```
python manage.py test --verbosity=2
Found 69 test(s).
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
test_add_user_semantic_tag (api.tests.AddUserSemanticTagTestCase.test_add_user_semantic_tag) ... ok
test_no_context_given (api.tests.AdminFeatureAPITest.test_no_context_given) ... All tests for the Admin Features API are completed!
ok
test_update_node_status (api.tests.AdminFeatureAPITest.test_update_node_status) ... All tests for the Admin Features API are completed!
ok
test_update_question_status (api.tests.AdminFeatureAPITest.test_update_question_status) ... All tests for the Admin Features API are completed!
ok
test_update_user_status (api.tests.AdminFeatureAPITest.test_update_user_status) ... All tests for the Admin Features API are completed!
ok
test_user_conversion (api.tests.AdminFeatureAPITest.test_user_conversion) ... All tests for the Admin Features API are completed!
ok
test_answer_question_success (api.tests.AnswerQuestionAPITest.test_answer_question_success) ... first if
second if
/Users/abera/anaconda3/envs/djangoenv/lib/python3.12/site-packages/django/db/models/fields/__init__.py:1595: RuntimeWarning: DateTimeField Question.answered_at received a naive datetime (2023-12-28 10:34:37.933972) while time zone support is active.
  warnings.warn(
All tests for the Answer Question API are completed!
ok
test_answer_strangernode_question (api.tests.AnswerQuestionAPITest.test_answer_strangernode_question) ... first if
All tests for the Answer Question API are completed!
ok
test_ask_question_success (api.tests.AskQuestionAPITest.test_ask_question_success) ... All tests for the Ask Question API are completed!
ok
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
test_get_contributor_from_id (api.tests.ContributorGETAPITestCase.test_get_contributor_from_id) ... All tests for the Contributor GET API are completed!
ok
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
test_search (api.tests.SearchAPITestCase.test_search) ... ok
test_add_semantic_tag (api.tests.SemanticTagAPITestCase.test_add_semantic_tag) ... All tests for the Semantic Tag API are completed!
ok
test_remove_workspace_tag (api.tests.SemanticTagAPITestCase.test_remove_workspace_tag) ... All tests for the Semantic Tag API are completed!
ok
test_user_signup (api.tests.SignUpAPIViewTestCase.test_user_signup) ... All tests for the Sign Up API are completed!
ok
test_get_theorem_from_id_not_found (api.tests.TheoremGETAPITestCase.test_get_theorem_from_id_not_found) ... All tests for the Theorem GET API are completed!
ok
test_get_theorem_from_id_valid (api.tests.TheoremGETAPITestCase.test_get_theorem_from_id_valid) ... All tests for the Theorem GET API are completed!
ok
test_get_user_detail_authenticated (api.tests.UserDetailAPITestCase.test_get_user_detail_authenticated) ... All tests for the User Detail API are completed!
ok
test_get_user_detail_not_authenticated (api.tests.UserDetailAPITestCase.test_get_user_detail_not_authenticated) ... All tests for the User Detail API are completed!
ok
test_create_workspace (api.tests.WorkspacePOSTAPITestCase.test_create_workspace) ... All tests for the Workspace POST API are completed!
ok
test_remove_workspace_proof (api.tests.WorkspaceProofTestCase.test_remove_workspace_proof) ... All tests for setting/removing workspace proof are completed!
ok
test_set_workspace_proof (api.tests.WorkspaceProofTestCase.test_set_workspace_proof) ... All tests for setting/removing workspace proof are completed!
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
Ran 69 tests in 341.458s

OK
Destroying test database for alias 'default' ('test_postgres')...
```
* #### Unit tests for the annotations application
```
python manage.py test --verbosity=2
Found 5 test(s).
Creating test database for alias 'default' ('test_postgres')...
Operations to perform:
  Synchronize unmigrated apps: corsheaders, messages, staticfiles
  Apply all migrations: admin, annotations, auth, contenttypes, sessions
Synchronizing apps without migrations:
  Creating tables...
    Running deferred SQL...
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying annotations.0001_initial... OK
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
  Applying sessions.0001_initial... OK
System check identified no issues (0 silenced).
test_delete_annotation (annotations.tests.AnnotationGetTest.test_delete_annotation) ... DELETE
All Annotation Get API Tests Completed
ok
test_get_annotation_by_id (annotations.tests.AnnotationGetTest.test_get_annotation_by_id) ... GET
All Annotation Get API Tests Completed
ok
test_get_matched_annotations (annotations.tests.AnnotationGetTest.test_get_matched_annotations) ... All Annotation Get API Tests Completed
ok
test_image_annotation (annotations.tests.AnnotationGetTest.test_image_annotation) ... GET
All Annotation Get API Tests Completed
ok
test_create_annotation (annotations.tests.AnnotationPostTest.test_create_annotation) ... All Annotation Post API Tests Completed
ok

----------------------------------------------------------------------
Ran 5 tests in 20.276s

OK
Destroying test database for alias 'default' ('test_postgres')...
```

## Software

You can find the django database dump [here](https://github.com/bounswe/bounswe2023group9/files/13796102/data_dump.json).

To load it run `python manage.py loaddata data_dump.json`

Please do not run this when you are connected to the remote database.




# Individual Contribution Reports

## Member: Ahmed Bera Pay

**Responsibilities:** I was responsible on the implementation of various functionalities and mechanisms discussed in our regular meetings. As most of the data models were already implemented before the second milestone, my responsibilities included the addition of new features and providing them as APIs and addressing bugs, particularly related with my implementations.


**Main contributions:** I mainly contributed to the implementation of diverse functionalities such as request mechanisms in the platform and admin features. One of my significant contributions was the research and implementation related to annotations aligning with W3C standards. I also helped bug fixing in the last week to the milestone.

**Code-related significant issues:**
* [BE - PUT API Method for Review Request Update](https://github.com/bounswe/bounswe2023group9/issues/571)
* [BE - Update the Update Request Method](https://github.com/bounswe/bounswe2023group9/issues/572)
* [BE - Implement Admin Features](https://github.com/bounswe/bounswe2023group9/issues/574)
* [BE - Fix Increment Number of Visits](https://github.com/bounswe/bounswe2023group9/issues/575)
* [BE - Project plan will be updated](https://github.com/bounswe/bounswe2023group9/issues/577)
* [BE - Reviewer Randomizer and Assigner](https://github.com/bounswe/bounswe2023group9/issues/581)
* [BE - Annotations Implementation](https://github.com/bounswe/bounswe2023group9/issues/603)
* [BE - API to change user roles](https://github.com/bounswe/bounswe2023group9/issues/624)
* [Bug - Issue with review randomizer](https://github.com/bounswe/bounswe2023group9/issues/628)
* [BE Bug- Node, Question and User do not return removal/ban state](https://github.com/bounswe/bounswe2023group9/issues/637)
* [BE - Annotation GET API Enhancement](https://github.com/bounswe/bounswe2023group9/issues/660)
* [Backend Implementation Update for Image Annotations](https://github.com/bounswe/bounswe2023group9/issues/731)

**Management-related significant issues:**
* [BE - ORCID Integration](https://github.com/bounswe/bounswe2023group9/issues/607)
* [BE - API Update for Filtering](https://github.com/bounswe/bounswe2023group9/issues/608)
* [BE - ORCID Check and Basic User Promotion](https://github.com/bounswe/bounswe2023group9/issues/662)
* [Writing Privacy Policy](https://github.com/bounswe/bounswe2023group9/issues/663)

**Pull requests:**


**Created:**
* [Enhance requests](https://github.com/bounswe/bounswe2023group9/pull/586)
* [Implement Admin API](https://github.com/bounswe/bounswe2023group9/pull/589)
* [Implement GET API](https://github.com/bounswe/bounswe2023group9/pull/616)
* [Implement user conversion](https://github.com/bounswe/bounswe2023group9/pull/625)
* [Backend bugfix](https://github.com/bounswe/bounswe2023group9/pull/640)
* [Update update_content_status](https://github.com/bounswe/bounswe2023group9/pull/668)
* [Get annotation update](https://github.com/bounswe/bounswe2023group9/pull/669)
* [Implement delete](https://github.com/bounswe/bounswe2023group9/pull/691)
* [Fix user ban](https://github.com/bounswe/bounswe2023group9/pull/700)
* [Update hide check](https://github.com/bounswe/bounswe2023group9/pull/706)
* [BE - Image annotation](https://github.com/bounswe/bounswe2023group9/pull/732)


**Reviewed:** 
* [Profile GET API bug fix](https://github.com/bounswe/bounswe2023group9/pull/519)
* [Profile GET API Semantic Tag Update](https://github.com/bounswe/bounswe2023group9/pull/704)
* [Reset Workspace State API](https://github.com/bounswe/bounswe2023group9/pull/701)
* [Workspace Bug Fix #697](https://github.com/bounswe/bounswe2023group9/pull/697)
* [Semantic tag post api and remove workspace tag put api](https://github.com/bounswe/bounswe2023group9/pull/673)
* [Workspace Bug Fix #657](https://github.com/bounswe/bounswe2023group9/pull/657)
* [Annotations post api](https://github.com/bounswe/bounswe2023group9/pull/636)
* [Workspace API Enhancement](https://github.com/bounswe/bounswe2023group9/pull/621)
* [fix semantic tag bugs](https://github.com/bounswe/bounswe2023group9/pull/592)


**Unit Tests**
I have written the relevant unit tests when I have implemented the functionality. Therefore the unit tests written by me are included in my pull requests. There are not separate pull requests for unit tests.

**Additional information:** 
I collaborated with Ömer Şükrü on the reorganization of the project plan.

## Member: Ali Mert Geben

**Responsibilities:** I was a part of the backend subgroup. My main responsibilities revolved around implementing new functions according to our discussions in the group meetings. Since most of the models and API functions were implemented before this milestone, my main responsibilities were addressing bugs and implementing new functionalities to the application.

**Main contributions:** My primary responsibility involved the successful implementation of an email notification system in order to meet our specific requirements. To achieve this, I researched integrating SMTP functionality using Django. Additionally, I created an email address, "collabscienceplatform@gmail.com," to send dispatch of emails to users. I used app password to maintain security.

**Code-related significant issues:**
* [BE - Review Request Notification Update](https://github.com/bounswe/bounswe2023group9/issues/702)
* [BE - E-Mail Notification Triggers](https://github.com/bounswe/bounswe2023group9/issues/654)
* [BE - E-Mail Notification Implementation](https://github.com/bounswe/bounswe2023group9/issues/605)

**Pull requests:**

**Created:**
* [Review Request Notification Update](https://github.com/bounswe/bounswe2023group9/pull/703)
* [Implementation of E-Mail Notification Triggers](https://github.com/bounswe/bounswe2023group9/pull/692)
* [E-Mail Notification Implementation](https://github.com/bounswe/bounswe2023group9/pull/623)

**Reviewed:** 
* [Profile GET API Semantic Tag Update](https://github.com/bounswe/bounswe2023group9/pull/704)
* [Workspace Bug Fix](https://github.com/bounswe/bounswe2023group9/pull/699)
* [Related Nodes API implemented.](https://github.com/bounswe/bounswe2023group9/pull/687)
* [orcid introduced.](https://github.com/bounswe/bounswe2023group9/pull/626)
* [Created QuestionID is returned after creation.](https://github.com/bounswe/bounswe2023group9/pull/594)

**Unit Tests**
I created the necessary unit tests while implementing the functionality, so the pull requests I submit include the tests.

**Additional information:**
None

## Member: Mehmet Süzer

**Responsibilities:** I was a member of the frontend team. My main responsibilities were designing pages and connecting the frontend to the backend by writing providers. I created some custom widgets such as the app button so that all pages of the platform looks similar. I was also responsible for fixing bugs related to render overflow. 

**Main contributions:** Since we used Flutter for both web and mobile, I contributed to both web and mobile designs. I mainly worked on the designs of the login, signup, home, relations, and workspace pages. I also implemented some custom widget which are usable in different parts of the platform. I solved many render overflow bugs. I also wrote some providers to connect the frontend to the backend. I worked a lot to make both mobile and web design to be similar.

**Code-related significant issues:**
* [Add Semantic Tags](https://github.com/bounswe/bounswe2023group9/issues/648)
* [Review Feature of Workspaces](https://github.com/bounswe/bounswe2023group9/issues/596)
* [New Features in Workspace](https://github.com/bounswe/bounswe2023group9/issues/566)

**Management-related significant issues:**
* [Executive Summary](https://github.com/bounswe/bounswe2023group9/issues/733)
* [Management](https://github.com/bounswe/bounswe2023group9/issues/734)

**Pull requests:**

**Created:**
* [New Features in Workspace](https://github.com/bounswe/bounswe2023group9/pull/588)
* [Bug Fix, Latex for Entries, Message in Collaboration Request, and So on](https://github.com/bounswe/bounswe2023group9/pull/610)
* [Semantic Tags in workspace](https://github.com/bounswe/bounswe2023group9/pull/698)
* [Semantic Tags in Profile](https://github.com/bounswe/bounswe2023group9/pull/723)

**Reviewed:** 
* [Update Collaboration Request](https://github.com/bounswe/bounswe2023group9/pull/696)
* [Update in Workspace Provider](https://github.com/bounswe/bounswe2023group9/pull/584)

**Additional information:**
I reported some of the bugs related to backend to Hakan Aktaş. After they are fixed, I updated the relevant parts in the frontend.

## Member: Ömer Faruk Ünal

**Responsibilities:** As a member of the frontend team, my role involves creating and maintaining the frontend of our application. In this milestone, my main focus was tackling challenging aspects. I also took up the responsibility of reviewing and fixing multiple pages that my teammates had designed. And since this is final milestone, I tested everything did many fixes and last minute additions.

**Main contributions:** Due to my experience with our tech tools, I've been reviewing everyone's code and handling team conflicts. I played a big role in building important parts of our project, like the router, annotation system, and search bar, which are used on all our pages.
I also added new features to my teammates' screens and fixed lots of bugs. In the first two weeks of a recent project phase, I faced a tough challenge: implementing LaTeX in annotations. Even though it might seem like I only finished one issue in those two weeks, it was more complicated than it seems. I had to find a workaround after trying different methods that didn't work.

**Code-related significant issues:**
- Annotation Implementation [#565](https://github.com/bounswe/bounswe2023group9/issues/565)
- Fix Selectable-Clickable Problems [#622](https://github.com/bounswe/bounswe2023group9/issues/622)
- Multiple Latex Proofs, shown as blank [#635](https://github.com/bounswe/bounswe2023group9/issues/635)
- Home Page Advanced Nodes [#646](https://github.com/bounswe/bounswe2023group9/issues/646)
- You May Like Return Related Nodes [#647](https://github.com/bounswe/bounswe2023group9/issues/647)
- Annotation Provider [#649](https://github.com/bounswe/bounswe2023group9/issues/649)
- Change name "Graph" to something else [#674](https://github.com/bounswe/bounswe2023group9/issues/674)
- Share Button change app url [#675](https://github.com/bounswe/bounswe2023group9/issues/675)
- Disable Notification [#679](https://github.com/bounswe/bounswe2023group9/issues/679)
- Home Page Node Options Bug [#682](https://github.com/bounswe/bounswe2023group9/issues/682)
- If User is Already Logged In [#684](https://github.com/bounswe/bounswe2023group9/issues/684)
- Node View Semantic Tags [#721](https://github.com/bounswe/bounswe2023group9/issues/721)
- Login With Shared Preferences Raises an Error [#729](https://github.com/bounswe/bounswe2023group9/issues/729)
- Image Annotation [#730](https://github.com/bounswe/bounswe2023group9/issues/730)

**Management-related significant issues:**
- Every week, through discussions with my teammates, I allocated work equitably by considering their availability and capabilities. Additionally, I communicated with the Backend team, providing instructions on the results of endpoints to be returned and establishing deadlines to ensure we had enough time for frontend implementation.

**Pull requests:**
- Make texts unselectable [#633](https://github.com/bounswe/bounswe2023group9/pull/633)
- Annotation Implementation [#634](https://github.com/bounswe/bounswe2023group9/pull/634)
- home page advanced nodes [#677](https://github.com/bounswe/bounswe2023group9/pull/677)
- share button change app url [#678](https://github.com/bounswe/bounswe2023group9/pull/678)
- Change name graph to relation [#680](https://github.com/bounswe/bounswe2023group9/pull/680)
- Remove notification page [#681](https://github.com/bounswe/bounswe2023group9/pull/681)
- home page node options bug [#683](https://github.com/bounswe/bounswe2023group9/pull/683)
- Fix auth token disappears error [#685](https://github.com/bounswe/bounswe2023group9/pull/685)
- bug fix for showing multiple proofs [#686](https://github.com/bounswe/bounswe2023group9/pull/686)
- Provider for GET and POST annotations [#688](https://github.com/bounswe/bounswe2023group9/pull/688)
- you may like return related nodes [#693](https://github.com/bounswe/bounswe2023group9/pull/693)
- Node view semantic tags [#713](https://github.com/bounswe/bounswe2023group9/pull/713)
- Final Milestone Frontend [#715](https://github.com/bounswe/bounswe2023group9/pull/715)
- Solved flutter's bug on web release with some library [#728](https://github.com/bounswe/bounswe2023group9/pull/728)
- Reviews:
    - Connect provider to workspace page2 [#591](https://github.com/bounswe/bounswe2023group9/pull/591)
    - Connect provider to workspace page2 [#601](https://github.com/bounswe/bounswe2023group9/pull/601)
    - Admin features frontend [#629](https://github.com/bounswe/bounswe2023group9/pull/629)
    - Create workspace from a node [#642](https://github.com/bounswe/bounswe2023group9/pull/642)
    - fixed editentry provider, resized some widgets [#643](https://github.com/bounswe/bounswe2023group9/pull/643)
    - add review feature to workspace page [#644](https://github.com/bounswe/bounswe2023group9/pull/644)
    - user permissions for review process [#676](https://github.com/bounswe/bounswe2023group9/pull/676)
    - bug fix for showing multiple proofs [#686](https://github.com/bounswe/bounswe2023group9/pull/686)
    - Provider for GET and POST annotations [#688](https://github.com/bounswe/bounswe2023group9/pull/688)
    - bug fix [#694](https://github.com/bounswe/bounswe2023group9/pull/694)
    - user type update [#695](https://github.com/bounswe/bounswe2023group9/pull/695)
    - Display review comments [#707](https://github.com/bounswe/bounswe2023group9/pull/707)
    - update contributors section's visibility [#708](https://github.com/bounswe/bounswe2023group9/pull/708)
    - entry types [#712](https://github.com/bounswe/bounswe2023group9/pull/712)
    - Admin features frontend [#716](https://github.com/bounswe/bounswe2023group9/pull/716)
    - reset workspace button [#717](https://github.com/bounswe/bounswe2023group9/pull/717)
    - Privacy policy text [#718](https://github.com/bounswe/bounswe2023group9/pull/718)
    - Orcid [#722](https://github.com/bounswe/bounswe2023group9/pull/722)
    - user tags are completed [#723](https://github.com/bounswe/bounswe2023group9/pull/723)
    - Get hidden node bug [#724](https://github.com/bounswe/bounswe2023group9/pull/724)
    - Backend Main Merge [#726](https://github.com/bounswe/bounswe2023group9/pull/726)

**Additional information:** xx


## Member: Zülal Molla

**Responsibilities:** I am member of the frontend team. My main responsibility is designing and creating user interfaces. I was in charge of designing and implementing the node details page and workspaces page. Also, I was responsible for writing providers and models to connect these pages to the backend.

**Main contributions:** I designed and implemented workspaces page for web. I connected the frontend of the both web and mobile workspaces page. I edited the workspaces page to implement reviewer features. I implemented the objection process for the published nodes.  

**Code-related significant issues:**
* [Review Feature of Workspaces](https://github.com/bounswe/bounswe2023group9/issues/596)
* [Reviewers should not see the contributors of a Review Request](https://github.com/bounswe/bounswe2023group9/issues/705)
* [FE - Create Workspace from a Node](https://github.com/bounswe/bounswe2023group9/issues/611)
* [FE - Enhancements for Workspace Page](https://github.com/bounswe/bounswe2023group9/issues/602)
* [FE - Fix Workspace Provider](https://github.com/bounswe/bounswe2023group9/issues/583)

**Pull requests:**

**Created:**
* [Fe reset workspace button](https://github.com/bounswe/bounswe2023group9/pull/717)
* [Fe entry types](https://github.com/bounswe/bounswe2023group9/pull/712)
* [update contributors section's visibility](https://github.com/bounswe/bounswe2023group9/pull/708)
* [Display review comments ](https://github.com/bounswe/bounswe2023group9/pull/707)
* [update collaboration request ](https://github.com/bounswe/bounswe2023group9/pull/696)
* [user type update](https://github.com/bounswe/bounswe2023group9/pull/695)
* [Fe user permissions for review process](https://github.com/bounswe/bounswe2023group9/pull/676)
* [596 fe add review feature to workspace page](https://github.com/bounswe/bounswe2023group9/pull/644)
* [Create workspace from a node](https://github.com/bounswe/bounswe2023group9/pull/642)
* [Connect provider to workspace page2](https://github.com/bounswe/bounswe2023group9/pull/601)

**Reviewed:** 
* [647 fe you may like return related nodes](https://github.com/bounswe/bounswe2023group9/pull/693)
* [Fix auth token disappears error](https://github.com/bounswe/bounswe2023group9/pull/685)
* [Workspace](https://github.com/bounswe/bounswe2023group9/pull/610)

**Additional information:**
 I made research on ORCID authentication.[FE - Research on authentication with ORCID](https://github.com/bounswe/bounswe2023group9/issues/568)


## Member: Arda Arslan

**Responsibilities:** In the final episode of our project development, my main responsibility was to implement some of the missing functionalities in the back-end program,in order to fulfill requirements of the project.

**Main contributions:** I've introduced necessary urls to enlarge our api and provided views to propagate necessary actions query to the endpoint necessitates. Communication with front-end team was important to establish desired communication between front and back-end programs which in turn made us create adjustment issues to fine tune the responses the way front-end team wants.

**Code-related significant issues:**
- Create Question API Endpoint [#569](https://github.com/bounswe/bounswe2023group9/issues/569)
- Answer Question API Endpoint [#570](https://github.com/bounswe/bounswe2023group9/issues/570)
- Create Question API - Modification [#593](https://github.com/bounswe/bounswe2023group9/issues/593)
- Node GET API Update [#599](https://github.com/bounswe/bounswe2023group9/issues/599)
- ORCID Integration [#607](https://github.com/bounswe/bounswe2023group9/issues/607)
- API Update for Filtering [#608](https://github.com/bounswe/bounswe2023group9/issues/608)

**Management-related significant issues:**
I have participated to weekly meetings, participated to discussions and workload distribution.

**Pull requests:**
- Creating and Answering Question API Implementation [#582](https://github.com/bounswe/bounswe2023group9/pull/582)
- Created QuestionID is returned after creation. [#594](https://github.com/bounswe/bounswe2023group9/pull/594)
- 'id' added to NodeViewQuestionSerializer [#617](https://github.com/bounswe/bounswe2023group9/pull/617)
- orcid introduced. [#626](https://github.com/bounswe/bounswe2023group9/pull/626)
- User can add SM Tag [#627](https://github.com/bounswe/bounswe2023group9/pull/627)


## Member: Bengisu Kübra Takkin

**Responsibilities:** I am member of the frontend team. My main responsibility is designing and creating user interfaces. I was in charge of designing and implementing the admin features and question/answer features. Also, I was responsible for writing privacy policy. 

**Main contributions:** I designed and implemented admin features (These features are banning users, giving user reviewer status, hiding question/answers and hiding nodes) for both web and mobile. I wrote providers and connected them to backend. I contributed to implementation of question/answer features and writing of the privacy policy. I added required features for ORCID and privacy policy to the frontend and connected them to backend.

**Code-related significant issues:**
* [FE - Question/Answer Implementation](https://github.com/bounswe/bounswe2023group9/issues/595)
* [FE - Admin Features](https://github.com/bounswe/bounswe2023group9/issues/597)
* [FE - Privacy Policy to Login Page](https://github.com/bounswe/bounswe2023group9/issues/598)
* [FE - Real Privacy Text](https://github.com/bounswe/bounswe2023group9/issues/650)
* [FE - ORCID Frontend](https://github.com/bounswe/bounswe2023group9/issues/651)
* [FE - Settings Bug Fix](https://github.com/bounswe/bounswe2023group9/issues/656)

**Management related significant issues:**
* [FE - Writing Privacy Policy](https://github.com/bounswe/bounswe2023group9/issues/663)

**Pull requests:**
* [Privacy policy](https://github.com/bounswe/bounswe2023group9/pull/618)
* [bug fixed in settings](https://github.com/bounswe/bounswe2023group9/pull/710)
* [Admin features frontend](https://github.com/bounswe/bounswe2023group9/pull/716)
* [Privacy policy text](https://github.com/bounswe/bounswe2023group9/pull/718)
* [Orcid](https://github.com/bounswe/bounswe2023group9/pull/722)

**Reviewed:** 
* [Question answer pages](https://github.com/bounswe/bounswe2023group9/pull/632)


## Member: Leyla Yayladere

**Responsibilities:** I am part of the front-end team, tasked with designing and implementing responsive, reliable, and user-friendly interfaces. My responsibilities also include reviewing team members' work, actively engage in project meetings, and contribute to project discussions and progress documentation.

**Main contributions:** I contributed to annotation implementation which was problematic with LaTeX rendering. I connected the frontend of annotation mechanism logic to backend for POST, GET, and DELETE APIs. Additionally, I always commented or reviewed PR requests that involved changes to the code I was familiar with.

**Code-related significant issues:**
- FE - Annotation Implementation [#565](https://github.com/bounswe/bounswe2023group9/issues/565)
- FE - Annotation Provider [#649](https://github.com/bounswe/bounswe2023group9/issues/649)
- Bug - Multiple Latex Proofs, shown as blank [#635](https://github.com/bounswe/bounswe2023group9/issues/635)

**Management-related significant issues:**
- Milestone Scenario [#653](https://github.com/bounswe/bounswe2023group9/issues/653)
- FE - Test of Everything [#652](https://github.com/bounswe/bounswe2023group9/issues/652)

**Pull requests:**
- Provider for GET, POST, and DELETE annotations, integrity with frontend's annotation mechanism [#688](https://github.com/bounswe/bounswe2023group9/pull/688)
- bug fix for showing multiple proofs [#686](https://github.com/bounswe/bounswe2023group9/pull/686)
- Reviews:
  - Node view semantic tags [#713](https://github.com/bounswe/bounswe2023group9/pull/713)
  - 596 fe add review feature to workspace page [#644](https://github.com/bounswe/bounswe2023group9/pull/644)
  - Create workspace from a node [#642](https://github.com/bounswe/bounswe2023group9/pull/642)
  - FE Annotation Implementation [#634](https://github.com/bounswe/bounswe2023group9/pull/634)
  - Admin features frontend [#629](https://github.com/bounswe/bounswe2023group9/pull/629)

**Additional information:**
I helped cleaning the database by removing dummy/test data and creating various meaningful data for users, theorems & proofs, semantic tags, and annotations to show our platform to customer more efficiently before preparing scenario and presentation. 


## Member: Hakan Emre Aktas

**Responsibilities:** I am a member of the backend team. My responsibilities include API endpoint design, implementation, testing, and documentation. I was also responsible for management-related tasks such as preparing the project plan and RAM. I was also tasked with the DevOps of the front end and the back-end of the application. 

**Main contributions:** I implemented many API endpoints such as search, profile GET and most of the APIs related to the workspace page. I also deployed and maintained the back end and the front end of the application. I also solved many issues related to the database.

**Code-related significant issues:**
- Profile Page GET API [#285](https://github.com/bounswe/bounswe2023group9/issues/285)
- Home Page GET API [#286](https://github.com/bounswe/bounswe2023group9/issues/286)
- Dockerfile should be created [#339](https://github.com/bounswe/bounswe2023group9/issues/339)
- BE - Implementation of GET APIs for Workspace page [#450](https://github.com/bounswe/bounswe2023group9/issues/450)
- Workspace APIs bug fix [#497](https://github.com/bounswe/bounswe2023group9/issues/497)
- BE - Latest, Trending and For You additions for search [#576](https://github.com/bounswe/bounswe2023group9/issues/576)
- BE - Implementation of Swagger UI for API documentation [#578](https://github.com/bounswe/bounswe2023group9/issues/578)


**Management-related significant issues:**
- Review of the RAM table [#262](https://github.com/bounswe/bounswe2023group9/issues/262)
- Review of the Project Plan [#252](https://github.com/bounswe/bounswe2023group9/issues/252)
- A Responsibility Assignment Matrix (RAM) will be prepared [#246](https://github.com/bounswe/bounswe2023group9/issues/246)
- A project plan wiki page will be published [#244](https://github.com/bounswe/bounswe2023group9/issues/244)

**Pull requests:**
- Workspace backend bug fix [#498](https://github.com/bounswe/bounswe2023group9/pull/498)
- Profile Page GET API [#312](https://github.com/bounswe/bounswe2023group9/pull/312)
- Backend Home Page GET API implementation [#316](https://github.com/bounswe/bounswe2023group9/pull/316)
- Security Update [#587](https://github.com/bounswe/bounswe2023group9/pull/587)
- Workspace GET APIs [#459](https://github.com/bounswe/bounswe2023group9/pull/459)
- Workspace API Enhancement [#621](https://github.com/bounswe/bounswe2023group9/pull/621)
- Workspace Bug Fix [#657](https://github.com/bounswe/bounswe2023group9/pull/657)
- Related Nodes API implemented [#687](https://github.com/bounswe/bounswe2023group9/pull/687)
- Workspace Bug Fix [#697](https://github.com/bounswe/bounswe2023group9/pull/697)
- Reset Workspace State API [#701](https://github.com/bounswe/bounswe2023group9/pull/701)
- Fix of Several Bugs [#709](https://github.com/bounswe/bounswe2023group9/pull/709)
- user semantic tag add/remove implemented [#711](https://github.com/bounswe/bounswe2023group9/pull/711)
- Reviews:
  - fix annotation target selector start error [#725](https://github.com/bounswe/bounswe2023group9/pull/725)
  - Setup instructions [#719](https://github.com/bounswe/bounswe2023group9/pull/719)
  - Update hide check[#706](https://github.com/bounswe/bounswe2023group9/pull/706)
  - Review Request Notification Update [#703](https://github.com/bounswe/bounswe2023group9/pull/703)
  - Implementation of E-Mail Notification Triggers [#692](https://github.com/bounswe/bounswe2023group9/pull/692)
  - Implement delete [#691](https://github.com/bounswe/bounswe2023group9/pull/691)
  - Semantic tag post api and remove workspace tag put api [#673](https://github.com/bounswe/bounswe2023group9/pull/673)
  - Implement disproof functionality[#670](https://github.com/bounswe/bounswe2023group9/pull/670)
  - Get annotation update [#669](https://github.com/bounswe/bounswe2023group9/pull/669)
  - Update update_content_status [#668](https://github.com/bounswe/bounswe2023group9/pull/668)
  - Backend bugfix[#640](https://github.com/bounswe/bounswe2023group9/pull/640)
  - Implement user conversion [#625](https://github.com/bounswe/bounswe2023group9/pull/625)
  - E-Mail Notification Implementation[#623](https://github.com/bounswe/bounswe2023group9/pull/623)
  - Implement Admin API [#589](https://github.com/bounswe/bounswe2023group9/pull/589)
  - Enhance requests[#586](https://github.com/bounswe/bounswe2023group9/pull/586)

**Unit Tests:**
- Workspace GET APIs [#459](https://github.com/bounswe/bounswe2023group9/pull/459)
- Search and Profile GET API Update [#417](https://github.com/bounswe/bounswe2023group9/pull/417)
- Contributor GET API implementation [#362](https://github.com/bounswe/bounswe2023group9/pull/362)
- Profile Page GET API Update[#336](https://github.com/bounswe/bounswe2023group9/pull/336)
- Backend Home Page GET API implementation [#316](https://github.com/bounswe/bounswe2023group9/pull/316)
- Profile Page GET API [#312](https://github.com/bounswe/bounswe2023group9/pull/312)


**Additional information:**
Self-Reflection: I should have written more tests. I stopped writing them entirely at some point. I thought they were not significant since I was already checking everything using Postman before each commit. I realized later that they are very important to make sure that everything functions correctly in the long run. This did not create a big problem overall, but there were several bugs that could have been prevented if I wrote the tests for them.

## Member: Ömer Şükrü Uyduran - Collaborative Science Platform / Backend


**Responsibilities:**
I was assigned to implementation of the annotation service mainly. I also impelmented APIs for creating semantic tags initially attached to workspaces and also for removing them from workspaces since these needs arised. I also fixed some bugs we encountered. I also took place in the preparation o the milestone scenario and project plan update. I wrote the setup instructions for the annotation service and updated the backend service setup instructions for database setup.

**Main contributions:**
I attended to all of the laboratories and meetings. I made contributions while we, as a team or backend sub-team, were making decisions about significant issues. I have fulfilled all tasks that have been assigned to me. I also documented the APIs that are implemented by me in the postman workspace of the team.

**Code-related significant issues:**

- Semantic search bug fixes - [#573](https://github.com/bounswe/bounswe2023group9/issues/573)
- BE - Annotations Implementation - [#603](https://github.com/bounswe/bounswe2023group9/issues/603)
- Annotations POST API implementation - [#613](https://github.com/bounswe/bounswe2023group9/issues/613)
- Semantic Tag POST API will be implemented - [#665](https://github.com/bounswe/bounswe2023group9/issues/665)
- Remove Workspace Tag PUT API will be implemented - [#666](https://github.com/bounswe/bounswe2023group9/issues/666)

**Management-related significant issues:**

- Project plan will be updated - [#577](https://github.com/bounswe/bounswe2023group9/issues/577)
- Setup instructions for annotation and database service - [#714](https://github.com/bounswe/bounswe2023group9/issues/714)
- Milestone Scenario - [#653](https://github.com/bounswe/bounswe2023group9/issues/653)

**Pull requests:**

Created:

- fix semantic tag bugs - [#592](https://github.com/bounswe/bounswe2023group9/pull/592)
- Annotations - [#639](https://github.com/bounswe/bounswe2023group9/pull/639)
- Semantic tag post api and remove workspace tag put api - [#673](https://github.com/bounswe/bounswe2023group9/pull/673)
- Setup instructions - [#719](https://github.com/bounswe/bounswe2023group9/pull/719)

Reviewed:

- Implement GET API - [#616](https://github.com/bounswe/bounswe2023group9/pull/616)
- disproof API implemented - [#672](https://github.com/bounswe/bounswe2023group9/pull/672)
- BE - Image annotation - [#732](https://github.com/bounswe/bounswe2023group9/pull/732)

Unit tests:
- [ChangePasswordAPITestCase - (#345)](https://github.com/bounswe/bounswe2023group9/pull/345/files#diff-c341d6ef36d5d22a5cd01a1dd4676030062c9aadc198e63a31986ebf2c4e2454)
- [ChangeProfileSettingsAPITestCase - (#350)](https://github.com/bounswe/bounswe2023group9/pull/350/files#diff-c341d6ef36d5d22a5cd01a1dd4676030062c9aadc198e63a31986ebf2c4e2454)
- [RequestModelTestCase - (#426)](https://github.com/bounswe/bounswe2023group9/pull/426/files#diff-c651e6f1e2bc8af0fac0d17a881e5854afc6280be3f591360daa41b802823ad4)
- [SemanticTagModelTestCase - (#468)](https://github.com/bounswe/bounswe2023group9/pull/468/files#diff-c651e6f1e2bc8af0fac0d17a881e5854afc6280be3f591360daa41b802823ad4)
- [WorkspacePOSTAPITestCase - (#501)](https://github.com/bounswe/bounswe2023group9/pull/501/files#diff-c341d6ef36d5d22a5cd01a1dd4676030062c9aadc198e63a31986ebf2c4e2454)
- [AnnotationPostTest - (#636)](https://github.com/bounswe/bounswe2023group9/pull/636/files#diff-fa6b6dcac8ac9ec78591ecfcd7f6e4acb94c1cdf8eff2af0eb6827f7ae6668ad)
- [SemanticTagAPITestCase - (#673)](https://github.com/bounswe/bounswe2023group9/pull/673/files#diff-c341d6ef36d5d22a5cd01a1dd4676030062c9aadc198e63a31986ebf2c4e2454)


## Member: Ahmet Abdullah Susuz

**Responsibilities:** I am member of the frontend team. My main responsibilities were designing and creating user interfaces also connecting backend with providers. I was mostly involved in the logic the admin features and question/answer page. Also, I was responsible for writing privacy policy. 

**Main contributions:** I designed and implemented q/a page design, providers and state management bugs. Also implement logic for display buttons for user based. In the last week fixed all its state and design bugs. I also wrote privacy policy for the application. 

**Code-related significant issues:**
* [FE - Question/Answer Implementation](https://github.com/bounswe/bounswe2023group9/issues/567)
* [FE - Admin Features](https://github.com/bounswe/bounswe2023group9/issues/597)
* [FE - Privacy Policy to Login Page](https://github.com/bounswe/bounswe2023group9/issues/598)
* [FE - Tidy Up Q&A and Admin Features](https://github.com/bounswe/bounswe2023group9/issues/655)
* [FE - Settings Bug Fix](https://github.com/bounswe/bounswe2023group9/issues/656)
* [FE - Get hidden nodes bug](https://github.com/bounswe/bounswe2023group9/issues/727)

**Management related significant issues:**
* [FE - Writing Privacy Policy](https://github.com/bounswe/bounswe2023group9/issues/663)

**Pull requests:**
* [Privacy policy](https://github.com/bounswe/bounswe2023group9/pull/618)
* [Question answer pages](https://github.com/bounswe/bounswe2023group9/pull/632)
* [bug fixed in settings](https://github.com/bounswe/bounswe2023group9/pull/710)
* [Admin features frontend](https://github.com/bounswe/bounswe2023group9/pull/716)
* [Get hidden node bug](https://github.com/bounswe/bounswe2023group9/pull/724)

**Reviewed:** 
* [Privacy policy text](https://github.com/bounswe/bounswe2023group9/pull/718)
