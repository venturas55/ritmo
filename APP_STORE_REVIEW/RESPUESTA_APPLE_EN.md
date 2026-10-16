# Guideline 2.1 — Information Needed

Owner preparation: replace every bracketed field, confirm the submitted build matches these source findings, and complete the physical-device recording before sending. The exact Apple message was not supplied; compare this response against every question in Resolution Center.

Dear App Review Team,

Thank you for requesting additional information about Ritmo.

Ritmo is a personal habit tracker for people who want to build consistent daily or weekly routines. Users create their own habits, choose scheduled weekdays, mark completion, review a calendar, and view recent progress and current streaks. Optional local reminders help users remember their routines. The interface is in Spanish.

The application works with a local SQLite database. It does not require registration, sign-in, passwords, an invitation, or a demo account. Reviewers can access all implemented features immediately after launch. There is no account backend or account-deletion flow. Users can delete a habit and its history, or erase local habits, history and settings through Ajustes > Eliminar todos mis datos. Previously shared exports must be deleted separately at their destination.

Users enter private habit names; the app has no public feed, user profiles, messaging, or content exchange between users. There is no public user-generated content service. The reviewed source has no in-app purchases, subscriptions, paid feature unlocks, or advertising. There is no purchase or subscription restoration flow. Download price: [CONFIRM APP STORE CONNECT PRICE].

Main review steps:
1. Open Ritmo and select Añadir nuevo hábito or the + button in Hoy.
2. Enter a habit name, choose weekdays, and tap Crear hábito.
3. Tap the habit in Hoy to toggle completion. Tap its arrow to edit it.
4. Open Calendario to inspect scheduled dates and adjust a past completion where a habit existed. Future completions are disabled.
5. Open Progreso to inspect the last seven days and streaks.
6. Edit a habit, enable Recordatorio, enter a valid time, and save. Notification permission is optional. Denial does not prevent habit tracking.
7. Open Ajustes to export JSON using the native share sheet, open the privacy policy, or contact support.
8. Delete a habit from its editor or use Ajustes > Eliminar todos mis datos and confirm to erase local data.

Physical iPhone demonstration: [ACCESSIBLE VIDEO URL]. Device: [MODEL]. iOS: [VERSION]. App version/build shown: [VERSION / BUILD]. The video starts by opening the installed app and demonstrates the actual flows above. Registration, login, account deletion, public-content moderation and purchase flows are absent because those features do not exist.

Technology: React Native, React and Expo; Expo Router/React Navigation; expo-sqlite; expo-notifications for local scheduling; expo-file-system and expo-sharing for user-requested JSON export; expo-haptics; expo-status-bar, splash/system UI, safe-area/screens and SVG/Lucide presentation components. AsyncStorage, expo-constants, expo-linking, Zustand and Zod are declared dependencies without direct imports in the reviewed app/src source. No remote data backend, advertising provider, payment provider, or analytics integration was found in that source. The privacy/support website uses Google Fonts; browsing it can contact Google and the website hosting provider. Hosting provider and release SDK behavior: [OWNER CONFIRMATION].

No country-based feature branches were found in the reviewed source. Storefront availability, pricing and any release-specific regional behavior: [CONFIRM IN APP STORE CONNECT AND SUBMITTED BUILD].

The reviewed app provides general productivity tools, not regulated financial, gambling, medical or similar services. No third-party content catalog was found. Ownership or licenses for branding, images and bundled libraries must be confirmed by us: [CONFIRM RIGHTS AND ATTACH AUTHORIZATION IF REQUIRED]. Intended distribution: [CONFIRM PUBLIC APP STORE FOR GENERAL USERS, NOT ORGANIZATION-RESTRICTED DISTRIBUTION].

Privacy policy: https://guardiandelfaro.es/proyectos/ritmo/privacidad.html
Support: https://guardiandelfaro.es/proyectos/ritmo/soporte.html
Contact: dev@guardiandelfaro.es [CONFIRM MONITORED MAILBOX].

Kind regards,
[DEVELOPER LEGAL NAME]
