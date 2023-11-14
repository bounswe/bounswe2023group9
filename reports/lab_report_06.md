# Project Development Weekly Progress Report #6

**Team Name:** Collaborative Science Platform

**Date:** 14.11.2023

## Progress Summary
**This week**, on backend, we implemented class logics related to workspace requirements of the project. Addressing performance concerns, we optimized uploading of node view page by refining data retrieval logic. On frontend, advanced routing now ensures that each node, graph, and profile view has a unique URL, enhancing overall navigation. Graph page is complete, with plans for further enhancements in the coming weeks.

**Subteams:**
- **Front-end Team**: Zülal, Bengisu, Abdullah, Mehmet, Ömer Faruk, Leyla
- **Back-end Team**: Ömer Şükrü, Ahmed Bera, Oğuz, Hakan, Arda, Ali Mert

**Our objective for the following week** is to create a collaborative workspace page and enhance existing graph page. We'll also explore a LaTeX renderer, intro to annotation implementation and make our app more resistant to errors. Backend team will be implementing all API functions needed for the Workspace page.

## What was planned for the week? How did it go?
| Description | Issue | Assignee | Due | Estimated Duration | Actual Duration | PR |
| --- | --- | --- | --- | --- | --- | --- |
| GoRouter Implementation | [#308](https://github.com/bounswe/bounswe2023group9/issues/308) | Leyla, Ömer Faruk | 14.11.2023 | 10hr | 8hr | [#421](https://github.com/bounswe/bounswe2023group9/pull/421), [#434](https://github.com/bounswe/bounswe2023group9/pull/434)|
| Mobile Graph Page | [#402](https://github.com/bounswe/bounswe2023group9/issues/402) | Mehmet | 14.11.2023 | 6hr | 6hr | [#414](https://github.com/bounswe/bounswe2023group9/pull/414)|
| Web Graph Page | [#404](https://github.com/bounswe/bounswe2023group9/issues/404) | Abdullah, Bengisu | 14.11.2023 | 6hr | 6hr | [#433](https://github.com/bounswe/bounswe2023group9/pull/433) |
| Enhance Node View Page | [#406](https://github.com/bounswe/bounswe2023group9/issues/406) | Zülal | 14.11.2023 | 6hr | 3hr | [#419](https://github.com/bounswe/bounswe2023group9/pull/419), [#437](https://github.com/bounswe/bounswe2023group9/pull/437) |
| Organize Frontend File Structure | [#405](https://github.com/bounswe/bounswe2023group9/issues/405)  | Zülal | 14.11.2023 | 1hr | 1hr | [#415](https://github.com/bounswe/bounswe2023group9/pull/415), [#418](https://github.com/bounswe/bounswe2023group9/pull/418) |
| Node View Page API Enhancement | [#407](https://github.com/bounswe/bounswe2023group9/issues/407) | Ahmed Bera | 12.11.2023 | 2.5hr | 3hr | [#410](https://github.com/bounswe/bounswe2023group9/pull/418) |
| Search Update | [#344](https://github.com/bounswe/bounswe2023group9/issues/344) | Hakan | 13.11.2023 | 2h |
| Request Class Implementation | [#399](https://github.com/bounswe/bounswe2023group9/issues/399) | Ömer Şükrü | 13.11.2023 | 3hr | 3hr | [#426](https://github.com/bounswe/bounswe2023group9/pull/426) |
| ReviewRequest Class Implementation | [#400](https://github.com/bounswe/bounswe2023group9/issues/400) | Ahmed Bera, Arda | 13.11.2023 | 3hr | 3hr | [#427](https://github.com/bounswe/bounswe2023group9/pull/427) |
| CollaborationRequest Class Implementation | [#305](https://github.com/bounswe/bounswe2023group9/issues/305) | Ahmed Bera, Arda | 13.11.2023 |3hr | 3hr | [#427](https://github.com/bounswe/bounswe2023group9/pull/427)|
| Entry Class Implementation | [#401](https://github.com/bounswe/bounswe2023group9/issues/401) | Ali Mert | 13.11.2023 | 4hr | | |


## Completed tasks that were not planned for the week
| Description  | Issue | Assignee | PR |
| -------- | ----- | -------- | --- |
| Node Provider Connection | [#423](https://github.com/bounswe/bounswe2023group9/issues/423) | Ömer Faruk | [#430](https://github.com/bounswe/bounswe2023group9/pull/430) |

## Planned vs. Actual
None

## Your plans for the next week
| Description | Issue | Assignee | Due | Estimated Duration |
| --- | --- | --- | --- | --- |
| Implement Error Handler To Pages | [#425](https://github.com/bounswe/bounswe2023group9/issues/425) | Leyla | 21.11.2023 | 2hr |
| Research Latex and MD renderer | [#431](https://github.com/bounswe/bounswe2023group9/issues/431) | Leyla | 21.11.2023 | 5hr |
| Make Texts Selectable Text and Intro to Annotation | [#432](https://github.com/bounswe/bounswe2023group9/issues/432) | Ömer Faruk | 21.11.2023 | 4hr |
| Enhance Graph Page | [#442](https://github.com/bounswe/bounswe2023group9/issues/442) | Bengisu | 14.11.2023 | 2hr | |
| Advance Navigation Bar for Routing Options  | [#422](https://github.com/bounswe/bounswe2023group9/issues/422) | Ömer Faruk | 21.11.2023 | 3hr |
| Web Workspace Page | [#439](https://github.com/bounswe/bounswe2023group9/issues/439) | Zülal | 21.11.2023 | 6hr |
| Mobile Workspace Page | [#440](https://github.com/bounswe/bounswe2023group9/issues/440) | Mehmet | 21.11.2023 | 6hr |
| Web Graph Preview Node | [#441](https://github.com/bounswe/bounswe2023group9/issues/441) | Abdullah | 21.11.2023 | 4hr |
| Enhance Graph Page | [#442](https://github.com/bounswe/bounswe2023group9/issues/442) | Bengisu | 21.11.2023 | 4hr |
|Role-Related Access Control|[#444](https://github.com/bounswe/bounswe2023group9/issues/444)| Arda Arslan| 20.11.2023| 10hr |
|API Methods Implementation for Requests|[#445](https://github.com/bounswe/bounswe2023group9/issues/445)| Ahmed Bera | 18.11.2023| 4hr |
|GET API for Workspace Page|[#450](https://github.com/bounswe/bounswe2023group9/issues/450)| Hakan | 20.11.2023| 4hr |
| Semantic Tag Class/Model Implementation | [#451](https://github.com/bounswe/bounswe2023group9/issues/451) | Ömer Şükrü | 21.11.2023 | 5hr|
| Third Party API Research and Utilization For Semantic Tag Functionality | [#452](https://github.com/bounswe/bounswe2023group9/issues/452) | Ömer Şükrü | 21.11.2023 | 6hr |

## Risks
None

## Nice UX

**already implemented or will be implemented:**

- Diverse designs created for web and mobile ensure optimal user experience. For instance, we adjust text size and page details on the web to display comprehensive information, while on mobile, we separate elements to enhance readability. Despite these differences, we maintain consistency with colors, shapes, and functionality. This ensures a seamless transition between web and mobile versions, so people using one won't face significant challenges when moving to the other.
- The collaborative workspace puts all essential tools into one accessible hub. Users can easily search for other researchers, request collaboration, and explore nodes, making it effortless to add references. This streamlined approach fosters efficient collaboration within the platform.
- 

**would be implemented with limitless resources like time and money:**

- advanced AI-powered search/recommendations based on user preferences and past interactions within platform
- real-time collaboration features, allowing multiple contributors to edit and contribute to same workspace simultaneously

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
