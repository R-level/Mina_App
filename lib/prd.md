# **Project Requirements Document: Mina Menstrual Tracking App**

The following table outlines the detailed functional requirements of the Mina Menstrual Tracking App.

| Requirement ID | Description                               | User Story                                                                                       | Expected Behavior/Outcome                                                                                                     |
|----------------|-------------------------------------------|--------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| FR001          | Track Menstrual Cycles                    | As a user, I want to log the start and end dates of my period so I can monitor my cycle.         | The app should provide an interface for users to input and save period dates, which are then displayed on a calendar.        |
| FR002          | Predict Future Cycles                     | As a user, I want the app to predict my next period based on past data so I can plan ahead.      | The app should analyze historical cycle data and display predicted start and end dates for future periods.                  |
| FR003          | Log Symptoms and Moods                    | As a user, I want to record daily symptoms and moods to track patterns over time.                | The app should allow users to input and save symptoms and moods, linking them to specific dates in their cycle.             |
| FR004          | Calendar Integration                      | As a user, I want to view my cycle data on a calendar for easy reference.                       | The app should display period dates, predicted dates, and logged symptoms/moods on an interactive calendar.                  |
| FR005          | Add Custom Notes                          | As a user, I want to add notes to specific dates to record additional observations.              | The app should provide a notepad feature where users can input, edit, and delete notes linked to dates.                     |
| FR006          | Set Reminders                             | As a user, I want to set reminders for medication or appointments related to my cycle.           | The app should allow users to create and manage custom reminders with notifications.                                         |
| FR007          | View Statistics and Trends                | As a user, I want to see charts or graphs of my cycle trends, symptoms, and moods.              | The app should generate visualizations (e.g., charts) based on logged data to help users identify patterns.                 |
| FR008          | Export Data                               | As a user, I want to export my cycle data to share with my healthcare provider.                 | The app should provide options to export data in a readable format (e.g., PDF or CSV).                                       |
| FR009          | Backup and Restore Data                   | As a user, I want to back up my data and restore it if needed.                                  | The app should allow users to create backups of their data and restore it from a backup file.                                |
| FR010          | User Authentication                       | As a user, I want to secure my data with login credentials.                                     | The app should support user authentication to protect personal data.                                                        |
| FR011          | Cloud Sync                                | As a user, I want my data to sync across devices via the cloud.                                 | The app should sync data to a cloud service, ensuring it is accessible on multiple devices.                                  |
| FR012          | Notifications                             | As a user, I want to receive reminders for upcoming periods or logged events.                   | The app should send push notifications for period predictions, reminders, and other logged events.                           |
| FR013          | Dashboard Overview                        | As a user, I want a dashboard that summarizes my current cycle status and recent activity.       | The app should display a dashboard with key metrics (e.g., cycle length, symptoms) and recent notes or logs.                 |
| FR014          | Data Validation                           | As a user, I want the app to validate my inputs to ensure accurate tracking.                    | The app should check for logical inconsistencies (e.g., end date before start date) and prompt the user to correct them.     |
| FR015          | Cycle Analysis                            | As a user, I want insights into my cycle patterns and health trends.                            | The app should provide analysis features (e.g., average cycle length, symptom frequency) to help users understand their data. |

## Non-Functional Requirements

| Requirement ID | Description                               | Criteria                                                                                        |
|----------------|-------------------------------------------|------------------------------------------------------------------------------------------------|
| NFR001         | Performance                               | The app should load calendar views and statistics within 2 seconds on mid-range devices.        |
| NFR002         | Security                                  | All user data should be encrypted both in transit and at rest.                                 |
| NFR003         | Accessibility                             | The app should meet WCAG 2.1 AA standards for accessibility.                                   |
| NFR004         | Cross-Platform Support                   | The app should maintain consistent functionality across iOS and Android platforms.             |
| NFR005         | Offline Functionality                     | Core tracking features should remain available without an internet connection.                   |
| NFR006         | Data Privacy                              | The app should comply with GDPR and other relevant data protection regulations.                 |

## Technical Notes

1. **Data Layer**:
   - SQLite database for local storage
   - Cloud Firestore for cloud sync functionality
   - JSON format for data exports

2. **Architecture**:
   - BLoC pattern for state management
   - Repository pattern for data access
   - MVVM architecture for UI components

3. **Dependencies**:
   - Flutter SDK for cross-platform development
   - Firebase for authentication and cloud services
   - Syncfusion Flutter Charts for data visualization