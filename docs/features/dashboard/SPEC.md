# Feature: Dashboard
**Status:** in-progress

## Entity
No dedicated entity — static UI with mock data for MVP. Data will eventually aggregate
from user-profile, course-progress, and analytics APIs.

## API
None for current MVP iteration (all values are mocked in the page).

Future endpoints (TBD):
| Method | Endpoint | Params | Response |
|--------|----------|--------|----------|
| GET | /me | — | UserProfileResponse |
| GET | /dashboard/summary | — | DashboardSummaryResponse |
| GET | /dashboard/learning-hours | — | LearningHoursResponse |
| GET | /dashboard/performance-trend | — | PerformanceTrendResponse |

## UI States

### DashboardPage (static)
- **Loading:** n/a for MVP (static mock data)
- **Data:**
  - Header: avatar initials (gradient), user name, role/department, notification bell with red dot
  - Continue Learning card: course thumbnail, title, progress %, module info, progress bar, "Continue →" button, "View all →" link
  - Stats row (3 tiles): Courses completed (9/12), Avg quiz score (82%), Velocity (Normal)
  - Achievements hero (NISA AI Insight): gradient blue card, decorative bubbles, 3 achievement items (7-Day Streak 🔥, Great Progress ⭐, High Achiever 🏆)
  - Learning hours card: clock icon, delta "+3 vs last week", stats (This Week / This Month / Total)
  - Quick Actions 2×2 grid: Browse Courses (purple), My Schedule (blue), Submit Work (green), Get Help (orange)
  - Performance Trend card: line chart (last 6 months), "+15 pts" pill
  - Floating bottom tab bar: Dashboard (active), My Course, Circle, Journey, Assessment

## Navigation
- **Entry:** `/dashboard` — navigated to after successful login
- **Quick Actions:** placeholder (other features not yet implemented)
- **Bottom tab bar:** Dashboard active; other tabs are visual stubs

## Acceptance Criteria
- [ ] Header renders with gradient avatar initials, name, and role
- [ ] Notification bell has red dot indicator
- [ ] Continue Learning card shows progress bar at 45%
- [ ] Stats row shows 3 tiles with correct values (9/12, 82%, Normal)
- [ ] Achievements hero renders with gradient background and 3 items
- [ ] Learning hours section shows This Week / This Month / Total
- [ ] Quick Actions 2×2 grid renders with correct accent colours
- [ ] Performance Trend shows line chart with 6 month labels and "+15 pts" pill
- [ ] Floating bottom tab bar renders with Dashboard active and blur backdrop
- [ ] Content scrolls behind the floating tab bar without being obscured

## Open Questions
- [ ] Real API for user profile data — backend TBD
- [ ] Real API for ongoing courses and progress — backend TBD
- [ ] NISA AI Insight integration — product TBD
- [ ] Bottom tab navigation with StatefulShellRoute — implement when other features land
