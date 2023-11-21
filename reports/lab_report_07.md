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

| Description                                                             | Issue                                                           | Assignee    | Due        | Estimated Duration | Actual Duration | PR                                                            |
| ----------------------------------------------------------------------- | --------------------------------------------------------------- | ----------- | ---------- | ------------------ | --------------- | ------------------------------------------------------------- |
| Implement Error Handler To Pages                                        | [#425](https://github.com/bounswe/bounswe2023group9/issues/425) | Leyla       | 21.11.2023 | 2hr                | 2hr             | [#466](https://github.com/bounswe/bounswe2023group9/pull/466) |
| Research Latex and MD renderer                                          | [#431](https://github.com/bounswe/bounswe2023group9/issues/431) | Leyla       | 21.11.2023 | 5hr                | 4hr             | NA                                                            |
| Make Texts Selectable Text and Intro to Annotation                      | [#432](https://github.com/bounswe/bounswe2023group9/issues/432) | Ömer Faruk  | 21.11.2023 | 8hr                | 8hr             | [458](https://github.com/bounswe/bounswe2023group9/pull/458)  |
| Enhance Graph Page                                                      | [#442](https://github.com/bounswe/bounswe2023group9/issues/442) | Bengisu     | 14.11.2023 | 2hr                | 2hr             |
| Web Workspace Page                                                      | [#439](https://github.com/bounswe/bounswe2023group9/issues/439) | Zülal       | 21.11.2023 | 6hr                | 6hr             | [471](https://github.com/bounswe/bounswe2023group9/pull/471)  |
| Mobile Workspace Page                                                   | [#440](https://github.com/bounswe/bounswe2023group9/issues/440) | Mehmet      | 21.11.2023 | 6hr                | 10hr            | [#463](https://github.com/bounswe/bounswe2023group9/pull/463) |
| Web Graph Preview Node                                                  | [#441](https://github.com/bounswe/bounswe2023group9/issues/441) | Abdullah    | 21.11.2023 | 4hr                | 3hr             | [#464](https://github.com/bounswe/bounswe2023group9/pull/464) |
| Role-Related Access Control                                             | [#444](https://github.com/bounswe/bounswe2023group9/issues/444) | Arda Arslan | 20.11.2023 | 10hr               | 4hr             | [#467](https://github.com/bounswe/bounswe2023group9/pull/467) |
| API Methods Implementation for Requests                                 | [#445](https://github.com/bounswe/bounswe2023group9/issues/445) | Ahmed Bera  | 18.11.2023 | 4hr                | 4hr             | [#460](https://github.com/bounswe/bounswe2023group9/pull/460) |
| GET API for Workspace Page                                              | [#450](https://github.com/bounswe/bounswe2023group9/issues/450) | Hakan       | 20.11.2023 | 4hr                | 4hr             | [#459](https://github.com/bounswe/bounswe2023group9/pull/459) |
| Semantic Tag Class/Model Implementation                                 | [#451](https://github.com/bounswe/bounswe2023group9/issues/451) | Ömer Şükrü  | 21.11.2023 | 5hr                | 6hr             | [#468](https://github.com/bounswe/bounswe2023group9/pull/468) |
| Third Party API Research and Utilization For Semantic Tag Functionality | [#453](https://github.com/bounswe/bounswe2023group9/issues/453) | Ömer Şükrü  | 21.11.2023 | 6hr                | 6hr             | [#468](https://github.com/bounswe/bounswe2023group9/pull/468) |

## Completed tasks that were not planned for the week

| Description                                | Issue                                                           | Assignee | PR                                                            |
| ------------------------------------------ | --------------------------------------------------------------- | -------- | ------------------------------------------------------------- |
| FE-Workspace Page Models for Frontend      | [#461](https://github.com/bounswe/bounswe2023group9/issues/461) | Zülal    | [#462](https://github.com/bounswe/bounswe2023group9/pull/462) |
| Enhancement for Profile Settings           | [#334](https://github.com/bounswe/bounswe2023group9/issues/334) | Bengisu  | [#482](https://github.com/bounswe/bounswe2023group9/pull/482) |
| BE - Implementation of various API methods | [#469](https://github.com/bounswe/bounswe2023group9/issues/469) | Ali Mert | [#470](https://github.com/bounswe/bounswe2023group9/pull/470) |

## Planned vs. Actual

- Advance Navigation Bar for Routing Options, issue [#422](https://github.com/bounswe/bounswe2023group9/issues/422), could not be completed. It didn't block anything and change any plans, it will be implemented next week.
- We decided to postpone the access related control for now. Thus, PR [#467](https://github.com/bounswe/bounswe2023group9/pull/467) is not merged or deleted.
- Implementation of Request API methods is merged after the planned date due to some improvement needs.
- Enhancing graph page design is postponed to next week. It's decided to give priority to connecting settings page to the backend instead (PR [#482](https://github.com/bounswe/bounswe2023group9/pull/482)) since it's a design task and it won't affect functional mechanism of the project.

## Your plans for the next week

| Description                                     | Issue                                                           | Assignee             | Due        | Estimated Duration |
| ----------------------------------------------- | --------------------------------------------------------------- | -------------------- | ---------- | ------------------ | --- |
| FE - Implement Latex                            | [#473](https://github.com/bounswe/bounswe2023group9/issues/473) | Leyla                | 27.11.2023 | 3hr                |
| FE - Configure Please Login Page                | [#474](https://github.com/bounswe/bounswe2023group9/issues/474) | Leyla                | 27.11.2023 | 2hr                |
| FE - Web Workspace Page Enhancement             | [#478](https://github.com/bounswe/bounswe2023group9/issues/478) | Zülal, Bengisu       | 27.11.2023 | 2hr                |
| FE - Mobile Workspace Page Enhancement          | [#476](https://github.com/bounswe/bounswe2023group9/issues/476) | Mehmet, Bengisu      | 27.11.2023 | 5hr                |
| FE - Create Workspace Provider                  | [#475](https://github.com/bounswe/bounswe2023group9/issues/475) | Zülal                | 27.11.2023 | 2hr                |
| FE - Connect Provider to Workspace Page         | [#477](https://github.com/bounswe/bounswe2023group9/issues/477) | Mehmet               | 27.11.2023 | 2hr                |
| FE - Semantic Tag Search                        | [#479](https://github.com/bounswe/bounswe2023group9/issues/479) | Abdullah, Ömer Faruk | 27.11.2023 | 5hr                |
| FE - User Get Token                             | [#480](https://github.com/bounswe/bounswe2023group9/issues/480) | Abdullah             | 27.11.2023 | 1hr                |
| FE - Advance Navigation Bar for Routing Options | [#422](https://github.com/bounswe/bounswe2023group9/issues/422) | Ömer Faruk           | 27.11.2023 | 3hr                |
| FE - Show Random Graph                          | [#443](https://github.com/bounswe/bounswe2023group9/issues/422) | Abdullah             | 27.11.2023 | 2hr                |
| Enhance Graph Page                              | [#442](https://github.com/bounswe/bounswe2023group9/issues/442) | Bengisu              | 21.11.2023 | 3.5hr              |     |
| Semantic Tag Search enhancement                 | [#344](https://github.com/bounswe/bounswe2023group9/issues/344) | Hakan                | 27.11.2023 | 5hr                |
| Workspace Get Update                            | [#484](https://github.com/bounswe/bounswe2023group9/issues/484) | Ali Mert             | 27.11.2023 | 3hr                |
| Node Model Update                               | [#485](https://github.com/bounswe/bounswe2023group9/issues/485) | Ahmed Bera           | 27.11.2023 | 1hr                |
| Node GET API Update                             | [#486](https://github.com/bounswe/bounswe2023group9/issues/486) | Ahmed Bera           | 27.11.2023 | 3hr                |
| Preparation of API Documentation                | [#488](https://github.com/bounswe/bounswe2023group9/issues/488) | Arda Arslan          | 27.11.2023 | 5hr                |
| Workspace POST API will be updated              | [#489](https://github.com/bounswe/bounswe2023group9/issues/489) | Ömer Şükrü           | 28.11.2023 | 3hr                |

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
