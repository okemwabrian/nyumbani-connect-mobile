# 🚀 Nyumbani Connect - The "Super App" for Household Care

Nyumbani Connect is a premium, high-end job-matching ecosystem designed specifically for the Kenyan market. It bridges the gap between **Professional Household Managers (Workers)**, **Bureaus (Agents)**, and **Employers (Clients)** through an HCI-driven automated platform.

## 🌟 Key Features (Phase 6 & 7 Upgrade)
*   **🎭 Multi-Role Ecosystem:** Tailored dashboards for Workers, Employers, Bureaus, and Admins.
*   **🌍 Full Localization:** Real-time English & Kiswahili toggle with automatic UI translation.
*   **🛡️ Automated KYC:** Compulsory National ID upload and automated verification simulation.
*   **🎬 Premium UX:** Looping video backgrounds on auth screens and elastic Lottie animations.
*   **💬 Real-Time Communication:** Direct in-app chat and integrated one-tap calling functionality.
*   **📅 Professional Tools:** Integrated `table_calendar` for interview scheduling and portfolio galleries for workers.
*   **📍 County-Based Logic:** Intelligent job matching and discovery filtering across Kenya's 47 counties.

## 🎨 Visual Identity
The app utilizes a nature-inspired palette to establish trust and reduce eye strain:
-   **Deep Teal (#327A7D):** Represents authority, professionalism, and primary actions.
-   **Sage Green (#80A486):** Used for navigation and secondary interactive states.
-   **Tertiary Olive (#C2D19D):** Highlights, status indicators, and empty states.
-   **Surface Pale (#E7EFD0):** Background scaffold to ensure clarity and low cognitive load.

## 🤖 Smart Automations
-   **Smart Skill Picker:** Auto-populates expertise based on job clusters.
-   **ID Parser:** Extracts age and DOB from ID documents to ensure 18+ compliance.
-   **Hiring Panel:** A professional recruitment workflow with Approve/Reject/Call capabilities.

## 🏗️ Architecture
-   **Frontend:** Flutter (Material 3) with dynamic Dark/Light mode support.
-   **State Management:** `Provider` for auth, theme, and localization.
-   **Navigation:** Professional `Navigator` flow with persistent App Drawer.
-   **Backend (In Progress):** Django REST Framework.

## 🚀 Installation & Build
1.  **Dependencies:** Ensure you have the Flutter SDK (Stable) installed.
2.  **Clean Cache:** If you encounter `Invalid depfile`, run:
    ```bash
    flutter clean
    flutter pub get
    ```
3.  **Run:** Use `flutter run` on an Android/iOS device or emulator.

---
*Developed with focus on Human-Computer Interaction (HCI) and Kenyan labor market efficiency.*
