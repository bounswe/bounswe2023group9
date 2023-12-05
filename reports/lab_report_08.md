# Project Development Weekly Progress Report #8

**Team Name:** Collaborative Science Platform

**Date:** 05.12.2023

## Progress Summary

**This week**, we enhanced the user-friendliness of several pages and completed final preparations for our milestone. A LaTeX renderer for mathematical formulas was implemented, and we introduced semantic tagging and annotations features. The design and APIs for the workspace page are now set up, although they are not fully integrated yet. Thus, we have implemented all core functionalities of the app, making it ready for presentation and comprehensible to the customer.

**Subteams:**

- **Front-end Team**: Zülal, Bengisu, Abdullah, Mehmet, Ömer Faruk, Leyla
- **Back-end Team**: Ömer Şükrü, Ahmed Bera, Oğuz, Hakan, Arda, Ali Mert

**Our objective for the following week**, is to complete workspace page in the frontend with the functionalities that were not implemented yet in the last milestone. Also, we will implement Q&A functionality and proceed on the annotation functionality. In the backend, in addition to the Q&A, we are also going to implement API endpoints for admin functionalities and review functionality.

## What was planned for the week? How did it go?

| Description                                     | Issue                                                           | Assignee             | Due        | Estimated Duration | Actual Duration | PR                                                                                                                           |
| ----------------------------------------------- | --------------------------------------------------------------- | -------------------- | ---------- | ------------------ | --------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| FE - Implement Latex                            | [#473](https://github.com/bounswe/bounswe2023group9/issues/473) | Leyla                | 27.11.2023 | 3hr                | 5hr             | [#511](https://github.com/bounswe/bounswe2023group9/pull/511)                                                                |
| FE - Configure Please Login Page                | [#474](https://github.com/bounswe/bounswe2023group9/issues/474) | Leyla                | 27.11.2023 | 2hr                | 2hr             | [#496](https://github.com/bounswe/bounswe2023group9/pull/496)                                                                |
| FE - Web Workspace Page Enhancement             | [#478](https://github.com/bounswe/bounswe2023group9/issues/478) | Zülal                | 27.11.2023 | 2hr                | 3hr             | [#521](https://github.com/bounswe/bounswe2023group9/pull/494), [#506](https://github.com/bounswe/bounswe2023group9/pull/521) |
| FE - Mobile Workspace Page Enhancement          | [#476](https://github.com/bounswe/bounswe2023group9/issues/476) | Mehmet               | 27.11.2023 | 5hr                | 10hr            | [#494](https://github.com/bounswe/bounswe2023group9/pull/494), [#506](https://github.com/bounswe/bounswe2023group9/pull/506) |
| FE - Create Workspace Provider                  | [#475](https://github.com/bounswe/bounswe2023group9/issues/475) | Zülal                | 27.11.2023 | 2hr                | 2hr             | [#502](https://github.com/bounswe/bounswe2023group9/pull/502)                                                                |
| FE - Connect Provider to Workspace Page         | [#477](https://github.com/bounswe/bounswe2023group9/issues/477) | Mehmet               | 27.11.2023 | 2hr                | 6hr             | postponed                                                                                                                    |
| FE - Semantic Tag Search                        | [#479](https://github.com/bounswe/bounswe2023group9/issues/479) | Abdullah, Ömer Faruk | 27.11.2023 | 5hr                | 5hr             | [#509](https://github.com/bounswe/bounswe2023group9/pull/509)                                                                |
| FE - User Get Token                             | [#480](https://github.com/bounswe/bounswe2023group9/issues/480) | Abdullah             | 27.11.2023 | 1hr                | 1hr             | [#518](https://github.com/bounswe/bounswe2023group9/pull/518)                                                                |
| FE - Advance Navigation Bar for Routing Options | [#422](https://github.com/bounswe/bounswe2023group9/issues/422) | Ömer Faruk           | 27.11.2023 | 3hr                | 2hr             | [#520](https://github.com/bounswe/bounswe2023group9/pull/520)                                                                |
| FE - Show Random Graph                          | [#443](https://github.com/bounswe/bounswe2023group9/issues/422) | Abdullah             | 27.11.2023 | 2hr                | 1hr             | [#523](https://github.com/bounswe/bounswe2023group9/pull/523)                                                                |
| Enhance Mobile and Web Graph Page               | [#442](https://github.com/bounswe/bounswe2023group9/issues/442) | Bengisu              | 21.11.2023 | 3.5hr              | 3.5hr           | [#510](https://github.com/bounswe/bounswe2023group9/pull/510)                                                                |
| Semantic Tag Search enhancement                 | [#344](https://github.com/bounswe/bounswe2023group9/issues/344) | Hakan                | 27.11.2023 | 5hr                | 5hr             | [#487](https://github.com/bounswe/bounswe2023group9/pull/487)                                                                |
| Workspace Get Update                            | [#484](https://github.com/bounswe/bounswe2023group9/issues/484) | Ali Mert             | 27.11.2023 | 3hr                |                 | [#500](https://github.com/bounswe/bounswe2023group9/pull/500)                                                                |
| Node Model Update                               | [#485](https://github.com/bounswe/bounswe2023group9/issues/485) | Ahmed Bera           | 27.11.2023 | 1hr                | 30m             | cancelled                                                                                                                    |
| Node GET API Update                             | [#486](https://github.com/bounswe/bounswe2023group9/issues/486) | Ahmed Bera           | 27.11.2023 | 3hr                | 30m             | [#499](https://github.com/bounswe/bounswe2023group9/pull/499)                                                                |
| Preparation of API Documentation                | [#488](https://github.com/bounswe/bounswe2023group9/issues/488) | Arda Arslan          | 27.11.2023 | 5hr                | 5hr             | [wiki page](https://github.com/bounswe/bounswe2023group9/wiki/API-Documentation)                                             |
| Workspace POST API will be updated              | [#489](https://github.com/bounswe/bounswe2023group9/issues/489) | Ömer Şükrü           | 28.11.2023 | 3hr                | 4hr             | [#501](https://github.com/bounswe/bounswe2023group9/pull/501)                                                                |

## Completed tasks that were not planned for the week

| Description                                     | Issue                                                           | Assignee          | PR                                                            |
| ----------------------------------------------- | --------------------------------------------------------------- | ----------------- | ------------------------------------------------------------- |
| FE - You May Like                               | [#517](https://github.com/bounswe/bounswe2023group9/issues/517) | Leyla, Ömer Faruk | [#522](https://github.com/bounswe/bounswe2023group9/pull/522) |
| FE - UI Improvements                            | [#513](https://github.com/bounswe/bounswe2023group9/issues/513) | Ömer Faruk        | [#514](https://github.com/bounswe/bounswe2023group9/pull/514) |
| FE - Show Random Nodes in Home Page             | [#508](https://github.com/bounswe/bounswe2023group9/issues/508) | Ömer Faruk        | [#509](https://github.com/bounswe/bounswe2023group9/pull/509) |
| FE - Share Button                               | [#492](https://github.com/bounswe/bounswe2023group9/issues/492) | Ömer Faruk        | [#505](https://github.com/bounswe/bounswe2023group9/pull/505) |
| FE - Profile Page Enhancement                   | [#491](https://github.com/bounswe/bounswe2023group9/issues/481) | Bengisu           | [#527](https://github.com/bounswe/bounswe2023group9/pull/527) |
| Workspace Backend Bug Fix                       | [#497](https://github.com/bounswe/bounswe2023group9/issues/497) | Hakan             | [#498](https://github.com/bounswe/bounswe2023group9/pull/498) |
| swagger UI implementation for API documentation | [#578](https://github.com/bounswe/bounswe2023group9/issues/578) | Hakan             | [#579](https://github.com/bounswe/bounswe2023group9/pull/579) |

## Completed Tasks After Milestone 2

| Description                      | Issue                                                           | Assignee | PR                                                            |
| -------------------------------- | --------------------------------------------------------------- | -------- | ------------------------------------------------------------- |
| Milestone Report #2 was prepared | [#535](https://github.com/bounswe/bounswe2023group9/issues/535) | Team     | [#560](https://github.com/bounswe/bounswe2023group9/pull/560) |

## Planned vs. Actual

- Issue [#477](https://github.com/bounswe/bounswe2023group9/issues/477), We have planned to connect the workspace provider to the workspace page. We sent requests to GET API and processed their result to display on the workspaces page. But we had unexpected errors while dealing with the POST API's. We had to update our request sending mechanism. Since the issue is more complex than we expected, we couldn't complete it on time.
- Issue [#485](https://github.com/bounswe/bounswe2023group9/issues/485), The intention was to update the model to include and exclude some fields to correctly address the latest implementation of semantic tags. But later it turned out that it was already updated. So no implementation task is done.
- In issue [#497](https://github.com/bounswe/bounswe2023group9/issues/497), the intention was to edit the profile page design and make it seem nicer. However when the task is finished, PR merge is postponed since frontend branch was corrupted. We wanted to merge it to the new branch since its not a critical task.

## Your plans for the next week

| Description                                        | Issue                                                           | Assignee             | Due        | Estimated Duration |
| -------------------------------------------------- | --------------------------------------------------------------- | -------------------- | ---------- | ------------------ |
| FE - Connect Provider to Workspace Page            | [#477](https://github.com/bounswe/bounswe2023group9/issues/477) | Mehmet, Zülal        | 12.12.2023 | 6hr                |
| FE - Question/Answer Implementation                | [#567](https://github.com/bounswe/bounswe2023group9/issues/567) | Abdullah, Bengisu    | 12.12.2023 | 7hr                |
| FE - Workspace Add New Features                    | [#566](https://github.com/bounswe/bounswe2023group9/issues/566) | Mehmet, Leyla, Zülal | 12.12.2023 | 5hr                |
| FE - Start Annotation Implementation               | [#565](https://github.com/bounswe/bounswe2023group9/issues/565) | Leyla, Ömer Faruk    | 12.12.2023 | 8hr                |
| Research on authentication with ORCID              | [#568](https://github.com/bounswe/bounswe2023group9/issues/568) | Zülal                | 12.12.2023 | 1 hr               |
| Answer Question API Endpoint                       | [#570](https://github.com/bounswe/bounswe2023group9/issues/570) | Arda Arslan          | 12.12.2023 | 5hr                |
| Create Question API Endpoint                       | [#569](https://github.com/bounswe/bounswe2023group9/issues/569) | Arda Arslan          | 12.12.2023 | 5hr                |
| BE - Role Related Access Control                   | [#564](https://github.com/bounswe/bounswe2023group9/issues/564) | Arda Arslan          | 12.12.2023 | 10hr               |
| Semantic search bug fixes                          | [#573](https://github.com/bounswe/bounswe2023group9/issues/573) | Ömer Şükrü           | 12.12.2023 | 4hr                |
| BE - PUT API Method for Review Request Update      | [#571](https://github.com/bounswe/bounswe2023group9/issues/571) | Ahmed Bera           | 12.12.2023 | 1.5hr              |
| BE - Update the Update Request Method              | [#572](https://github.com/bounswe/bounswe2023group9/issues/572) | Ahmed Bera           | 12.12.2023 | 30m                |
| BE - Implement Admin Features                      | [#574](https://github.com/bounswe/bounswe2023group9/issues/574) | Ahmed Bera           | 12.12.2023 | 3hr                |
| BE - Fix Increment Number of Visits                | [#575](https://github.com/bounswe/bounswe2023group9/issues/575) | Ahmed Bera           | 12.12.2023 | 15m                |
| BE - API for Latest, Trending and For You sections | [#576](https://github.com/bounswe/bounswe2023group9/issues/576) | Hakan                | 12.12.2023 | 4hr                |
| Project plan will be updated                       | [#577](https://github.com/bounswe/bounswe2023group9/issues/577) | Team                 | 12.12.2023 | 2hr                |

## Remaining Features

| Rank | Feature                 | Reason                                                                                                                            |
| ---- | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| 10   | Workspace (cont.)       | It is related with and prerequisite for most of other features.                                                                   |
| 9    | Annotation              | The customer values a lot                                                                                                         |
| 8    | Review                  | One of the core features and without it the project is meaningless since the nodes are created after the review of the workspaces |
| 7    | ORCID                   | It provides reliability for the platform                                                                                          |
| 6    | Q&A                     | It is allows basic users to interact more with the application and supports knowledge sharing                                     |
| 5    | Email & Notification    | It allows users to be notified instantly and engage them more with the platform                                                   |
| 4    | Semantic Search (cont.) | It is implemented already. It is going to be improved and its bugs will be fixed                                                  |
| 3    | Admin Features          | It does not affect the main functionalities, only improves user experience and reliability                                        |
| 2    | Sorting                 | It does not affect the main functionalities, only improves user experience                                                        |
| 1    | Privacy Policy          | It does not affect the main functionalities or user experience                                                                    |

## Risks

- We might encounter challenges rendering LaTeX math formulas and implementing annotations to formulas. A potential workaround could involve separating explanations and formulas for clarity.

## Participants

- Ahmed Bera Pay
- Ahmet Abdullah Susuz
- Arda Arslan
- Bengisu Kübra Takkin
- Hakan Emre Aktaş
- Leyla Yayladere
- Mehmet Süzer
- Ömer Faruk Ünal
- Ömer Şükrü Uyduran
- Zülal Molla
