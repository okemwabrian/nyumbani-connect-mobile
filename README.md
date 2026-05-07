# Nyumbani Connect - HCI & Automation Ecosystem

Nyumbani Connect is a high-end, fully automated employment ecosystem for Kenya, connecting verified **House Managers (Workers)** with **Employers** via intermediary **Bureaus (Agents)**. 

The project follows a strict **HCI-driven (Human-Computer Interaction)** design philosophy, focusing on trust, security, and extreme automation to reduce manual data entry.

## 🎨 Visual Identity
The app utilizes an earthy-professional 4-color palette designed to reduce cognitive load:
- **Primary Teal (#327A7D):** Authority and action.
- **Sage Green (#80A486):** Navigation and secondary states.
- **Tertiary Olive (#C2D19D):** Highlights and status indicators.
- **Surface Pale (#E7EFD0):** Scaffold background for reduced eye strain.

## 🤖 Smart Automations
- **Smart Skill Picker:** Workers select a job category, and the app automatically pre-highlights associated skills.
- **ID/Age Verification:** Automated parsing of National ID photos to extract DOB and verify 18+ legal compliance.
- **Regional Job Alerts:** Real-time push notifications sent to workers in specific counties (1 of 47) when a relevant job is posted.
- **Smart Matching:** Bureau agents receive "Best Match" suggestions (percentage-based) for job allocations.

## 🏗️ Three-Dashboard Architecture
Based on the authenticated role, users are routed to a custom experience:
1. **Worker Dashboard:** Focus on earnings, regional job feeds, and "Quick Apply" functionality.
2. **Employer Dashboard:** Tools for automated job posting and a hiring panel to track applicants.
3. **Bureau Dashboard:** A verification queue for ID/Skills review and a smart job-allocation center.

## 🛠️ Tech Stack
- **Framework:** Flutter (Material 3)
- **State Management:** Provider
- **Animations:** Lottie
- **Fonts:** Google Fonts (Outfit)
- **Data Persistence:** SharedPreferences

## 🚀 Getting Started
1. Ensure Flutter SDK is installed.
2. Clone the repository.
3. Run `flutter pub get` to fetch dependencies.
4. Run `flutter run` on your preferred device.

**Note:** For development testing, you can use any phone number to login. Prefixes `1` (Worker) and `2` (Agent) determine the initial role simulation.
