# Mobile App - Trainee

## **🧩 Background Story**

Trainees engage with LearnXpert primarily on-the-go through mobile devices. Currently, without a mobile-optimized dashboard, they must access courses through web browsers, leading to suboptimal experience on small screens. Trainees need a single entry point to see their assigned courses, progress metrics, and quick actions to resume learning without navigating through nested menus.

The Trainee Dashboard feature enables:

- Personalized home screen with key learning metrics at a glance
- Quick actions to navigate to courses, assessments, and schedule
- Resume functionality to jump back to the last ongoing course or journey
- Recent activity feed for motivation and progress visibility

This ensures a seamless, mobile-first learning experience that encourages daily engagement and completion of assigned programs.

## **🎯 Goals**

- Enable Trainees to quickly access and resume their learning journey from mobile in <2 seconds
- Provide at-a-glance visibility into learning progress and metrics
- Reduce friction for course/journey navigation via quick actions and search
- Increase daily active users (DAU) and session frequency among Trainees
- Support offline metrics display for users without immediate network connectivity

## **📌 Requirements**

### **👤 User Stories**

#### US-01: View Personalized Dashboard

As a Trainee,

I want to see my name, profile picture, and greeting message on the home screen,

So that I feel welcomed and have immediate confirmation of my identity.

#### US-02: View Learning Metrics

As a Trainee,

I want to see summary metrics (Courses Completed, Average Score, Learning Velocity),

So that I understand my learning progress at a glance.

---

#### US-03: Access Quick Actions

As a Trainee,

I want to see 4 quick action buttons (Browse Courses, Submit Work, My Schedule, Get Help),

So that I can quickly navigate to the features I need most frequently.

---

#### US-04: Resume Recent Learning

As a Trainee,

I want a prominent "Resume" button pointing to my most recent ongoing course or journey,

So that I can quickly return to where I left off without searching.

---

#### US-05: See Recent Activity

As a Trainee,

I want to see a feed of my 3-4 most recent learning activities (e.g., 'You completed Module X'),

So that I can track my recent progress and stay motivated.

---

#### US-06: Refresh Metrics in Real-Time

As a Trainee,

I want metrics on the dashboard to update immediately when I complete a course or submit an assessment,

So that I always see current progress information.

---

## **✅ Acceptance Criteria**

#### **AC-01: Mobile App Navbar**

**GIVEN**

Trainee opens the app and logs in successfully

**WHEN**

Dashboard screen loads 

**THEN**

- Page display dashboard
- Navigation bar shows 5 menu
    - Dashboard
    - My Course
    - My Journey
    - Assessment
    - Circle

---

#### AC-02: Dashboard Layout & Display

**GIVEN**

Trainee opens the app and logs in successfully

**WHEN**

Dashboard screen loads 

**THEN** Dashboard display

- profile name
- Latest ongoing learning (if trainee has any ongoing Course and/or Journey, otherwise hide this section)
- metric cards (Courses Completed, Average Score, Learning Velocity)
- NISA AI Insight
- Learning hours
- 4 quick action buttons available
    - Browse Courses → navigates to 'Upskill Hub'
    - Submit Work → navigates to 'Assessments' tab showing all pending quizzes and assignments
    - My Schedule → navigates to calendar view of upcoming training events
    - Get Help → opens support contact page or in-app help center
- Performance Trend

---

#### **AC-03: Resume/Continue Button Behavior**

**GIVEN**

Trainee has Ongoing Course displayed on dashboard

**WHEN**

Trainee click Continue/Resume button

**THEN**

- Navigate to course/journey detail, scrolled to the last viewed activity

---

#### **AC-04: Browse Courses**

**GIVEN**

Trainee tap Browse Courses from Dashboard’s Quick Action 

**WHEN**

Page Load 

**THEN**

- Trainee directed to Upskill Hub, page shows:
    - Search Bar (based on title)
    - Filter (based on Learning Type, Level, Source)
    - Recommended Courses
    - Self Learning Program

---

#### **AC-05: My Schedule**

**GIVEN**

Trainee tap My Schedule from Dashboard’s Quick Action 

**WHEN**

Page load 

**THEN**

- Trainee directed to Schedule
- Page shows:
    - Calendar view
    - Calendar defaults to Weekly view showing the current week
    - View switcher is visible at the top: Daily | Weekly | Monthly — switching views is immediate with no page reload
    - Navigation controls allow moving forward and backward by day, week, or month depending on active view
    - "Today" button jumps the calendar back to the current date in any view
    - Current date is visually highlighted in all views
    - Each event type uses a distinct color: Course start (green), Live session (blue), Quiz schedule (amber), Assignment deadline (red), Approval deadline (purple — Admin only)
    - Monthly view shows event chips per day; clicking a day with multiple events expands to show all
    - Weekly and Daily views show events as time-blocked entries with start time

---

#### **AC-06: Submit Work**

**GIVEN**

Trainee tap Submit Work from Dashboard’s Quick Action 

**WHEN**

Page load 

**THEN**

- Trainee directed to Assessment page
- All details follow **AC-09: Assessment layout & display**

---

#### **AC-07: Course layout & display**

**GIVEN**

Trainee tap 'My Courses' navbar

**WHEN**

My Course page load

**THEN**

- Page display Assigned, Ongoing, Upcoming, & Completed Course
- Counter of number of courses displayed on each tab
- Course card shows:
    - Course name
    - Course level
    - Course duration
    - Course source (Internal LnD/O’reilly/Linkedin/etc.)
    - View Details button —> Navigate to course/journey detail

---

#### **AC-08: Journey layout & display**

**GIVEN**

Trainee tap 'Journeys' navbar

**WHEN**

Journey page load

**THEN**

- Page display Assigned, Ongoing, Upcoming, & Completed Journey
- Counter of number of journeys displayed on each tab
- Journey card shows:
    - Journey name
    - Number of courses
    - Journey duration
    - View Details button —> Navigate to course/journey detail

---

#### **AC-09: Assessment layout & display**

**GIVEN**

Trainee tap 'Assessment' navbar

**WHEN**

Assessment page load

**THEN** page display

- Metrics
    - Number of pending quizzes
    - Number of pending assignments
- Search Bar (based on Assessment or Course Name)
- Filter (based on Status, Assessment Type)
- Sort (by Deadline, Score)
- Assessment List card, shows:
    - Assessment Name
    - Course Name
    - Assessment Type (Quiz/Assignment)
    - Deadline
    - Status (Not Started / Late / Completed / Graded)
    - Score (show score if Grading completed by Trainer, otherwise empty)
    - View details

---

### **AC-10: Circle Page Display**

**GIVEN**

The trainee taps the **“Circle”** menu on the navigation bar

**WHEN**

The page is opened

**THEN** the system displays:

- A search bar to search by:
    - Account Name
    - Channel Name
- **Direct Messages**
    - List of users the trainee has previously interacted with through chat or calls
- **Channels**
    - List of channels the trainee has joined or created
- A **“+”** button to start a new conversation or create a channel
    - When clicked, the system displays:
        - List of users within the same organization
        - Checkbox selection beside each user name
        - “Start Conversation” button
    - If only one user is selected:
        - A Direct Message conversation is created automatically
    - If multiple users are selected:
        - A new channel is automatically created
        - Selected user names become the default channel name
- **Activity**
    - Redirects trainee to a page displaying conversation activities such as:
        - Mentions
        - Reactions
        - Thread activities
- **Pinned Messages**
    - Redirects trainee to a page displaying all pinned messages from:
        - Direct Messages
        - Channels
- **Call**
    - Redirects trainee to a page displaying:
        - Recent incoming and outgoing direct calls
        - Call date and duration
    - Includes a **“+ New Call”** button
        - When clicked, the system displays all users within the same organization
- **Conference Call**
    - Redirects trainee to a page displaying:
        - Upcoming conference calls linked to live session schedules (if available)
        - Empty state if no upcoming conference calls exist
        - Recent conference call history from:
            - Course/Journey live sessions
            - Channel conference calls
        - Including call date and duration

---

#### **AC-11: Course Detail display**

**GIVEN**

Trainee tap ‘View Detail’ on course

**WHEN**

Page load

**THEN** page display

- Course Basic Information
    - Course Name
    - Learning type (Self Learning / Blended Learning)
    - Course Level (Beginner / Intermediate / Advance / Expert)
    - Duration
    - Start Date & End Date
    - Description
    - Learning Objectives
    - Skill Covered
    - What You’ll Get
- Course Structure:
    - Topic
        - Topic Name
        - Topic Description
        - Number of modules
        - Duration
        - Start Date & End Date
            - Module
                - Module Name
                - Module Description
                - Duration
                    - Activity
                        - Activity Name
                        - Activity Type (Reading Material / Video / Slide / Quiz / Assignment / Live Session / In-Person Training)
                        - Duration
                        - Status
                            - Not Started (for All type)
                            - Completed (for All type)
                            - Late (for Assignment, Live Session, & In-Person Training)
                            - Graded (for Quiz & Assignment)
                            - Absent (for Live Session & In-Person Training)
- Analytic
    - 

---

#### **AC-12: Journey Detail display**

**GIVEN**

Trainee tap ‘View Detail’ on journey

**WHEN**

Page load

**THEN** page display

- Journey Basic Information
    - Journey Name
    - Learning type (Self Learning / Blended Learning)
    - Course Level (Beginner / Intermediate / Advance / Expert)
    - Duration
    - Start Date & End Date
    - Description
    - Learning Objectives
    - Skill Covered
    - What You’ll Get
- Journey Structure:
    - Course name
        - Number of activity
        - Duration
        - Start Date & End Date
        - Source (LnD/O’Reilly/Linkedin)
            - Activity
                - Activity Name
                - Activity Type (Reading Material / Video / Slide / Quiz / Assignment / Live Session / In-Person Training)
                - Duration
                - Status
                    - Not Started (for All type)
                    - Completed (for All type)
                    - Late (for Assignment, Live Session, & In-Person Training)
                    - Graded (for Quiz & Assignment)
                    - Absent (for Live Session & In-Person Training)
- Analytic
    -