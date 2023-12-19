# Project Development Weekly Progress Report #10

**Team Name:** Collaborative Science Platform

**Date:** 19.12.2023

## Progress Summary

**This week**,
On the backend, we implemented the annotations following the W3C standards. We have written GET and POST API for them. Also we have implemented the mail notification system. Additionally, missing workspace and admin features implemented. On the frontend, we continued to work on annotations. We created user interface for review process. In addition, we implemented admin features for frontend.

**Subteams:**

- **Front-end Team**: Zülal, Bengisu, Abdullah, Mehmet, Ömer Faruk, Leyla
- **Back-end Team**: Ömer Şükrü, Ahmed Bera, Oğuz, Hakan, Arda, Ali Mert

**Our objective for the following week**,
On the backend, we will mostly fix the bugs and implement final missing functionalities. Also a privacy policy will be written.
On the frontend, we aim to implement review process completely. We will provide adding semantic tag feature to workspace. Users will be able to add ORCID ID's to their profiles. Also, we will test the platform comprehensively and fix the bugs.

## What was planned for the week? How did it go?

| Description                               | Issue                                                           | Assignee               | Due        | Estimated Duration | Actual Duration | PR                                                                                                                                                                                          |
| ----------------------------------------- | --------------------------------------------------------------- | ---------------------- | ---------- | ------------------ | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| FE - Add Review Feature to Workspace Page | [#596](https://github.com/bounswe/bounswe2023group9/issues/596) | Mehmet, Zülal          | 26.12.2023 | 8hr                | 5hr             | [#644](https://github.com/bounswe/bounswe2023group9/issues/644)                                                                                                                             |
| FE - Privacy Policy to Login Page         | [#598](https://github.com/bounswe/bounswe2023group9/issues/598) | Abdullah, Bengisu      | 19.12.2023 | 1hr                | 1hr             | [#618](https://github.com/bounswe/bounswe2023group9/pull/618)                                                                                                                               |
| FE - Admin Features                       | [#565](https://github.com/bounswe/bounswe2023group9/issues/565) | Abdullah, Bengisu      | 19.12.2023 | 8hr                | 10hr            | [#629](https://github.com/bounswe/bounswe2023group9/pull/629)                                                                                                                               |
| FE - Annotation Implementation            | [#565](https://github.com/bounswe/bounswe2023group9/issues/565) | Leyla, Ömer Faruk      | 19.12.2023 | 10hr               | 8hr             | [#634](https://github.com/bounswe/bounswe2023group9/pull/634)                                                                                                                               |
| BE - Workspace API Update                 | [#600](https://github.com/bounswe/bounswe2023group9/issues/600) | Hakan                  | 19.12.2023 | 8hr                | 9hr             | [#621](https://github.com/bounswe/bounswe2023group9/pull/621), [#631](https://github.com/bounswe/bounswe2023group9/pull/631), [#657](https://github.com/bounswe/bounswe2023group9/pull/657) |
| FE - Enhancements for Workspace Page      | [#602](https://github.com/bounswe/bounswe2023group9/issues/602) | Zülal                  | 19.12.2023 | 2hr                | 2hr             | [#643](https://github.com/bounswe/bounswe2023group9/issues/643)                                                                                                                             |
| BE - Annotations Implementation           | [#603](https://github.com/bounswe/bounswe2023group9/issues/603) | Ömer Şükrü, Ahmed Bera | 19.12.2023 | 5hr                | 6hr             | [#639](https://github.com/bounswe/bounswe2023group9/pull/639), [#636](https://github.com/bounswe/bounswe2023group9/pull/636), [#616](https://github.com/bounswe/bounswe2023group9/pull/616) |
| BE - E-Mail Notification Implementation   | [#605](https://github.com/bounswe/bounswe2023group9/issues/605) | Ali Mert               | 19.12.2023 | 4hr                | 5hr             | [#623](https://github.com/bounswe/bounswe2023group9/pull/623)                                                                                                                               |
| BE - API Update for Filtering             | [#608](https://github.com/bounswe/bounswe2023group9/issues/608) | Arda                   | 19.12.2023 | 2hr                | 2hr             | [#627](https://github.com/bounswe/bounswe2023group9/pull/627)                                                                                                                               |
| BE - ORCID Integration                    | [#607](https://github.com/bounswe/bounswe2023group9/issues/607) | Arda                   | 19.12.2023 | 2hr                | 2hr             | [#626](https://github.com/bounswe/bounswe2023group9/pull/626)                                                                                                                               |
| Node GET API Update                       | [#599](https://github.com/bounswe/bounswe2023group9/issues/599) | Arda                   | 19.12.2023 | 2hr                | 1hr             | [#617](https://github.com/bounswe/bounswe2023group9/pull/617)                                                                                                                               |

## Completed tasks that were not planned for the week

| Description                                                     | Issue                                                           | Assignee   | PR                                                            |
| --------------------------------------------------------------- | --------------------------------------------------------------- | ---------- | ------------------------------------------------------------- |
| BE - Create Question API - Modification                         | [#593](https://github.com/bounswe/bounswe2023group9/issues/593) | Arda       | [#594](https://github.com/bounswe/bounswe2023group9/pull/594) |
| FE - Create Workspace from a Node                               | [#611](https://github.com/bounswe/bounswe2023group9/issues/611) | Zülal      | [#642](https://github.com/bounswe/bounswe2023group9/pull/642) |
| BE - API to change user roles                                   | [#624](https://github.com/bounswe/bounswe2023group9/issues/624) | Ahmed Bera | [#625](https://github.com/bounswe/bounswe2023group9/pull/625) |
| Bug - Issue with review randomizer                              | [#628](https://github.com/bounswe/bounswe2023group9/issues/628) | Ahmed Bera | [#640](https://github.com/bounswe/bounswe2023group9/pull/640) |
| BE Bug- Node, Question and User do not return removal/ban state | [#637](https://github.com/bounswe/bounswe2023group9/issues/637) | Ahmed Bera | [#640](https://github.com/bounswe/bounswe2023group9/pull/640) |

## Planned vs. Actual

We encounter some problem in [#588](https://github.com/bounswe/bounswe2023group9/pull/588). This PR was closed and the work was carried to another PR, [#610](https://github.com/bounswe/bounswe2023group9/pull/610), with some additional tasks. Semantic tags couldnt be added to workspaces since some additional APIs were needed.

Admin features connection to backend is delayed due to some updates on related APIs. After it is deployed we will connect admin features to backend. Also hide/show question/answer part is not implemented since question answer features is just merged to the frontend branch. We will complete the task soon since everything needed is ready now.

It turned out that some admin features on the backend were missing. So we implemented those features in addition.

## Your plans for the next week

| Description                                         | Issue                                                           | Assignee          | Due        | Estimated Duration |
| --------------------------------------------------- | --------------------------------------------------------------- | ----------------- | ---------- | ------------------ |
| FE - Add Review Feature to Workspace Page           | [#596](https://github.com/bounswe/bounswe2023group9/issues/596) | Mehmet, Zülal     | 25.12.2023 | 6hr                |
| FE - Add semantic tags (Workspace and User Profile) | [#648](https://github.com/bounswe/bounswe2023group9/issues/648) | Mehmet            | 25.12.2023 | 5hr                |
| FE - Annotation Provider                            | [#649](https://github.com/bounswe/bounswe2023group9/issues/649) | Leyla             | 24.12.2023 | 6hr                |
| FE - Test of Everything                             | [#652](https://github.com/bounswe/bounswe2023group9/issues/652) | Leyla             | 24.12.2023 | 2hr                |
| Milestone Scenario                                  | [#653](https://github.com/bounswe/bounswe2023group9/issues/653) | Leyla, Ömer Şükrü | 25.12.2023 | 2hr                |
| FE - Tidy Up Q&A and Admin Features                 | [#655](https://github.com/bounswe/bounswe2023group9/issues/655) | Abdullah, Bengisu | 25.12.2023 | 5hr                |
| FE - ORCID Frontend                                 | [#651](https://github.com/bounswe/bounswe2023group9/issues/651) | Bengisu           | 25.12.2023 | 1.5hr              |
| FE - Settings Bug Fix                               | [#656](https://github.com/bounswe/bounswe2023group9/issues/656) | Abdullah, Bengisu | 25.12.2023 | 3hr                |
| FE - Real Privacy Text                              | [#650](https://github.com/bounswe/bounswe2023group9/issues/650) | Bengisu           | 25.12.2023 | 15dk               |
| FE - You May Like Return Related Nodes              | [#647](https://github.com/bounswe/bounswe2023group9/issues/647) | Ömer Faruk        | 25.12.2023 | 3hr                |
| FE - Home Page Advanced Nodes                       | [#646](https://github.com/bounswe/bounswe2023group9/issues/646) | Ömer Faruk        | 25.12.2023 | 4hr                |
| BE - E-Mail Notification Triggers                   | [#654](https://github.com/bounswe/bounswe2023group9/issues/654) | Ali Mert          | 25.12.2023 | 2hr                |
| BE - Admin remove check for APIs                    | [#658](https://github.com/bounswe/bounswe2023group9/issues/658) | Hakan             | 25.12.2023 | 2hr                |
| BE - Annotation GET API Enhancement                 | [#660](https://github.com/bounswe/bounswe2023group9/issues/660) | Ahmed Bera        | 24.12.2023 | 2hr                |
| BE - Workspace API Enhancement                      | [#661](https://github.com/bounswe/bounswe2023group9/issues/661) | Ahmed Bera        | 24.12.2023 | 3hr                |
| BE - ORCID Check and Basic User Promotion           | [#662](https://github.com/bounswe/bounswe2023group9/issues/662) | Arda              | 24.12.2023 | 3hr                |
| Writing Privacy Policy                              | [#663](https://github.com/bounswe/bounswe2023group9/issues/663) | Abdullah, Bengisu | 24.12.2023 | 4hr                |
| Semantic Tag POST API will be implemented           | [#665](https://github.com/bounswe/bounswe2023group9/issues/665) | Ömer Şükrü        | 26.12.2023 | 3hr                |
| Semantic Tag DELETE API will be implemented         | [#666](https://github.com/bounswe/bounswe2023group9/issues/666) | Ömer Şükrü        | 26.12.2023 | 3hr                |

## Risks

We became aware of the requirement for image annotations through a conversation with Suzan Hoca. As our project does not currently involve images, this requirement is not just about annotation for us but also about implementing a feature for uploading images, etc. Since we haven't received any feedback on this, we have additional one week after final milestone deadline to address this requirement if we decide to implement it. Therefore, a decision can be made after the final milestone presentation.

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
