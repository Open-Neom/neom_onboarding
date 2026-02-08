### 2.0.0 - Error Handling & Stability Improvements

This release focuses on robust error handling during account creation to prevent users from getting stuck on loading screens.

**Bug Fixes:**

* **Account Creation Error Handling:**
    * Fixed critical issue where users could get stuck on "Welcome" loading screen if account creation failed.
    * Added proper error handling in `finishAccount()` that navigates users back to login on critical errors.
    * Users now see clear error messages when account creation fails.

* **Code Organization:**
    * Reorganized SMS verification controller variables to the top of the class for better code structure.
    * Removed deprecated code comments.

**Improvements:**

* **Better Error Messages:**
    * Error messages now display the actual error to help diagnose issues.
    * Snackbar notifications inform users of what went wrong.

* **Graceful Failure Recovery:**
    * When account creation fails, users are redirected to login page instead of being stuck.
    * Loading state is properly reset after errors.

---

### 1.4.0 - Architectural Enhancements & Feature Refinements

This release for `neom_onboarding` includes significant architectural improvements, primarily focusing on decoupling its core logic and enhancing maintainability, alongside general refinements aligned with the broader Open Neom refactoring efforts.

**Key Architectural & Feature Improvements:**

* **Controller Decoupling for Interface-Based Services:**
    * The `OnBoardingController` now interacts with core functionalities (like user management, media uploads, and profile services) through their respective **service interfaces (use_cases)** defined in `neom_core` (e.g., `UserService`, `MediaUploadService`, `ProfileService`).
    * This change significantly reduces direct coupling to concrete controller implementations, enhancing testability and flexibility, consistent with the Dependency Inversion Principle (DIP) across Open Neom.

* **Module-Specific Translations:**
    * Introduced `OnBoardingTranslationConstants` to centralize and manage all module-specific translation keys. This ensures that `neom_onboarding`'s UI text is easily localizable and maintainable, aligning with Open Neom's internationalization strategy.
    * Examples of new translation keys include: `addLastProfileInfoMsg`, `addNewProfileInfoMsg`, `addProfileImg`, `addProfileImgMsg`, `changeThisSettingLater`, `enterDOB`, `finishAccount`, `finishProfile`, `introEventPlannerType`, `introFacilitatorType`, `introGenres`, `introInstruments`, `introLocale`, `introProfileType`, `introReason`, `phoneVerificationFailed`, `phoneVerified`, `sendCodeAgain`, `tellAboutYou`, `verifyPhone`.

* **Refined Onboarding Flow & User Experience:**
    * Improved the flow for **phone number verification**, including options to resend SMS codes and clear validation states.
    * Enhanced the **profile image addition** process, with clearer messaging for new users and additional profiles.
    * Refined **date of birth validation** logic to ensure valid age input.
    * Streamlined the **coupon code application** process, including validation and handling of different coupon types (`oneMonthFree`, `coinAddition`).
    * Improved **terms and conditions agreement** flow, ensuring user consent before account finalization.

* **Integration with Global Architectural Changes:**
    * Adopts the updated service injection patterns established in `neom_core`'s recent refactor.
    * Benefits from the consolidated `CoreConstants` and `MediaUploadDestination` enum for clearer file handling logic.

* **Performance & Maintainability:**
    * The decoupling of logic contributes to a lighter, more focused module, improving compilation speed and overall application performance.
    * Clearer separation of concerns makes the module easier to understand, debug, and extend for future features.ental services and data models, and `neom_commons` for shared UI components, ensuring consistency and efficiency across the platform.