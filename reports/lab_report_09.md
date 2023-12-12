# Project Development Weekly Progress Report #9

**Team Name:** Collaborative Science Platform

**Date:** 12.12.2023

## Progress Summary
**This week**, we worked adding functionalities to workspace page that were not implemented yet in the last milestone. Also, we started to implement Q&A functionality and continued to find a win-win solution with product owner on frontend for annotation functionality with LaTeX. In the backend, in addition to the Q&A, we implemented API endpoints for admin functionalities and review functionality. Token Authentication is added to almost all APIs that require authentication. API functions for Admins are added.

**Subteams:**
- **Front-end Team**: Zülal, Bengisu, Abdullah, Mehmet, Ömer Faruk, Leyla
- **Back-end Team**: Ömer Şükrü, Ahmed Bera, Oğuz, Hakan, Arda, Ali Mert

**Our objective for the following week**,
In the backend, we will implement the annotations service and the email notifications. Also we will add the ORCID integration and update some API methods for workspaces.

## What was planned for the week? How did it go?
| Description | Issue | Assignee | Due | Estimated Duration | Actual Duration | PR |
| --- | --- | --- | --- | --- | --- | --- |
| FE - Connect Provider to Workspace Page | [#477](https://github.com/bounswe/bounswe2023group9/issues/477) | Mehmet, Zülal | 12.12.2023 | 6hr | 6hr |[#601](https://github.com/bounswe/bounswe2023group9/pull/601), [#591](https://github.com/bounswe/bounswe2023group9/pull/591)|
| FE - Question/Answer Implementation | [#567](https://github.com/bounswe/bounswe2023group9/issues/567) | Abdullah, Bengisu | 12.12.2023 | 7hr | 6hr |
| FE - Workspace Add New Features  | [#566](https://github.com/bounswe/bounswe2023group9/issues/566) | Mehmet, Leyla, Zülal | 12.12.2023 | 5hr | 6hr |[#588](https://github.com/bounswe/bounswe2023group9/pull/588) |
| FE - Annotation Implementation | [#565](https://github.com/bounswe/bounswe2023group9/issues/565) | Leyla, Ömer Faruk | 12.12.2023 | 8hr | 10hr | NA |
| Research on authentication with ORCID | [#568](https://github.com/bounswe/bounswe2023group9/issues/568) | Zülal | 12.12.2023 | 1 hr | 1hr | NA |
| Answer Question API Endpoint | [#570](https://github.com/bounswe/bounswe2023group9/issues/570) | Arda Arslan | 12.12.2023 | 5hr | 5hr | [#582](https://github.com/bounswe/bounswe2023group9/pull/582)
| Create Question API Endpoint | [#569](https://github.com/bounswe/bounswe2023group9/issues/569) | Arda Arslan | 12.12.2023 | 5hr | 5hr | [#582](https://github.com/bounswe/bounswe2023group9/pull/582)
| BE - Role Related Access Control | [#564](https://github.com/bounswe/bounswe2023group9/issues/564) | Arda Arslan | 12.12.2023 | 10hr | 10hr | [#467](https://github.com/bounswe/bounswe2023group9/pull/467)
| Semantic search bug fixes | [#573](https://github.com/bounswe/bounswe2023group9/issues/573) | Ömer Şükrü | 12.12.2023 | 4hr | 4hr | [#592](https://github.com/bounswe/bounswe2023group9/pull/592)
| BE - PUT API Method for Review Request Update | [#571](https://github.com/bounswe/bounswe2023group9/issues/571) | Ahmed Bera | 12.12.2023 | 1.5hr | 3hr | [#586](https://github.com/bounswe/bounswe2023group9/pull/586)
| BE - Update the Update Request Method | [#572](https://github.com/bounswe/bounswe2023group9/issues/572) | Ahmed Bera | 12.12.2023 | 30m | 30m | [#586](https://github.com/bounswe/bounswe2023group9/pull/586)
| BE - Implement Admin Features | [#574](https://github.com/bounswe/bounswe2023group9/issues/574) | Ahmed Bera | 12.12.2023 | 3hr | 2.5hr | [#589](https://github.com/bounswe/bounswe2023group9/pull/589)
| BE - Fix Increment Number of Visits | [#575](https://github.com/bounswe/bounswe2023group9/issues/575) | Ahmed Bera | 12.12.2023 | 15m | 15m | [#586](https://github.com/bounswe/bounswe2023group9/pull/586)
| BE - API for Latest, Trending and For You sections | [#576](https://github.com/bounswe/bounswe2023group9/issues/576) | Hakan | 12.12.2023 | 4hr | 4hr | [#585](https://github.com/bounswe/bounswe2023group9/pull/585)|
| Project plan will be updated | [#577](https://github.com/bounswe/bounswe2023group9/issues/577) | Team | 12.12.2023 | 2hr | 2hr | [Link](https://github.com/orgs/bounswe/projects/25/views/7)


## Completed tasks that were not planned for the week
| Description  | Issue | Assignee | PR |
| -------- | ----- | -------- | --- |
|Swagger UI Implementation| [#578](https://github.com/bounswe/bounswe2023group9/issues/578)| Hakan | [#579](https://github.com/bounswe/bounswe2023group9/pull/579)|
|Security Update For the APIs| - |Hakan | [#587](https://github.com/bounswe/bounswe2023group9/pull/587)|
| BE - Reviewer Randomizer and Assigner | [#581](https://github.com/bounswe/bounswe2023group9/issues/581) | Ahmed Bera | [#586](https://github.com/bounswe/bounswe2023group9/pull/586) |


## Planned vs. Actual
- Issue [#581](https://github.com/bounswe/bounswe2023group9/issues/581) - Sending a review request requires the assignment of reviewers randomly. We did not talk about it explicitly and planned for this week. But since it is a part of the method, we implemented it.
## Your plans for the next week
| Description | Issue | Assignee | Due | Estimated Duration |
| --- | --- | --- | --- | --- |
| FE - Add Review Feature to Workspace Page | [#596](https://github.com/bounswe/bounswe2023group9/issues/596) | Mehmet, Zülal | 26.12.2023 | 8hr |
| FE - Privacy Policy to Login Page | [#598](https://github.com/bounswe/bounswe2023group9/issues/598) | Abdullah, Bengisu | 19.12.2023 | 1hr |
| FE - Admin Features  | [#565](https://github.com/bounswe/bounswe2023group9/issues/565) | Abdullah, Bengisu | 19.12.2023 | 8hr |
| FE - Annotation Implementation | [#565](https://github.com/bounswe/bounswe2023group9/issues/565) | Leyla, Ömer Faruk | 19.12.2023 | 10hr |
| BE - Workspace API Update | [#600](https://github.com/bounswe/bounswe2023group9/issues/600)  | Hakan  | 19.12.2023 | 8hr |
| FE - Enhancements for Workspace Page | [#602](https://github.com/bounswe/bounswe2023group9/issues/602)  | Zülal | 19.12.2023 | 2hr |
| BE - Annotations Implementation | [#603](https://github.com/bounswe/bounswe2023group9/issues/603)  | Ömer Şükrü, Ahmed Bera | 19.12.2023 | 5hr |
| BE - E-Mail Notification Implementation | [#605](https://github.com/bounswe/bounswe2023group9/issues/605)  | Ali Mert | 19.12.2023 | 4hr |
| BE - API Update for Filtering | [#608](https://github.com/bounswe/bounswe2023group9/issues/608)  | Arda | 19.12.2023 | 2hr |
| BE - ORCID Integration | [#607](https://github.com/bounswe/bounswe2023group9/issues/607)  | Arda | 19.12.2023 | 2hr |
| Node GET API Update | [#599](https://github.com/bounswe/bounswe2023group9/issues/605)  | Arda | 19.12.2023 | 2hr |

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
