# neom_onboarding
neom_onboarding is a critical module within the Open Neom ecosystem, dedicated to guiding new users
through their initial setup and personalization journey. It encompasses all the necessary screens
and logic for onboarding processes, from requesting essential permissions and selecting preferences
(like language and profile type) to gathering initial user information and setting up their first profile.

This module is designed to provide a smooth, intuitive, and engaging first-time user experience,
crucial for user retention and for correctly configuring the application to individual needs.
It adheres strictly to Open Neom's Clean Architecture principles, ensuring a clear separation of concerns,
high testability, and seamless integration with neom_core for core services and neom_commons for shared UI components.
It plays a vital role in aligning new users with the fsm philosophy by enabling conscious choices from the outset.

🌟 Features & Responsibilities
neom_onboarding is responsible for a series of sequential steps that onboard a user:
•	Required Permissions Handling: Guides users through granting necessary permissions (e.g., location)
    for the app's core functionalities.
•	Locale Selection: Allows users to choose their preferred language, ensuring a localized experience from the start.
•	Profile Type Selection: Enables users to define their primary profile type (e.g., appArtist, facilitator,
    host, researcher, general), tailoring their subsequent experience.
•	Facility/Place Type Selection: For specific profile types (e.g., facilitator, host),
    it guides the selection of related types (e.g., recordStudio, bar).
•	User Information Collection: Facilitates the input of essential user details, including username,
    "about me" description, date of birth, and optional phone number verification.
•	Profile Image Upload: Manages the process of adding a profile image, leveraging neom_media_upload for file handling.
•	Coupon Code Application: Allows new users to apply coupon codes for special benefits during the onboarding process.
•	Terms and Conditions Agreement: Ensures users acknowledge and agree to the platform's terms of service.
•	New Account/Profile Creation: Orchestrates the final steps of creating a new user account
    or an additional profile, persisting data via neom_core services.
•	Welcome Experience: Provides a welcoming screen upon successful completion of the onboarding process.

🛠 Technical Highlights / Why it Matters (for developers)
For developers, neom_onboarding serves as an excellent case study for:
•	Multi-Step Form/Flow Management: Demonstrates how to design and implement a sequential onboarding
    flow with multiple pages and interdependent data collection.
•	GetX for Complex State: Shows advanced GetX usage for managing state across multiple screens
    in a flow, handling user input, and orchestrating asynchronous operations (e.g., API calls, file uploads).
•	Permission Handling: Provides practical examples of requesting and verifying device
    permissions (e.g., Geolocator) and adapting UI based on permission status.
•	User Input Validation: Implements robust input validation for various fields
    (e.g., username, phone number, date of birth, coupon codes).
•	Integration with Core Services: Illustrates seamless interaction with LoginService, UserService,
    MediaUploadService, and ProfileService from neom_core for data persistence and business logic.
•	Dynamic UI based on App Flavor: Shows how the UI and flow adapt based on the AppInUse configuration
•	Image Upload Integration: Demonstrates how to integrate with a separate media upload module
    (neom_media_upload) for handling image selection and upload.

How it Supports the Open Neom Initiative
neom_onboarding is fundamental to the success and growth of the Open Neom ecosystem and the Tecnozenism vision by:
•	Ensuring User Engagement: A well-designed onboarding process is crucial for user retention,
    making the initial interaction with Open Neom positive and clear.
•	Personalizing the Experience: By allowing users to define their profile type and preferences from the start,
    it enables a tailored experience that aligns with individual needs and purposes.
•	Facilitating Data Collection for Research: It provides structured mechanisms for collecting essential user
    and preference data, which can be vital for research purposes within the Open Neom framework (with user consent).
•	Reinforcing Tecnozenism Principles: By guiding users through conscious choices (e.g., locale, profile type, permissions),
    it subtly introduces the idea of intentional interaction with technology.
•	Showcasing Modularity: As a self-contained module, it exemplifies Open Neom's "Plug-and-Play" architecture,
    demonstrating how complex user flows can be built from independent, reusable components.

🚀 Usage
This module provides the necessary routes and UI components for the application's onboarding flow.
It is typically invoked immediately after user authentication (e.g., from neom_auth)
for new users or for creating additional profiles.

📦 Dependencies
neom_onboarding relies on neom_core for core services, models, and routing constants,
and on neom_commons for reusable UI components, themes, and utility functions.

🤝 Contributing
We welcome contributions to the neom_onboarding module! If you're passionate about user experience,
user journey design, or improving initial setup flows, your contributions can significantly
impact how new users engage with Open Neom.

To understand the broader architectural context of Open Neom and how neom_onboarding fits
into the overall vision of Tecnozenism, please refer to the main project's MANIFEST.md.

For guidance on how to contribute to Open Neom and to understand the various levels of learning
and engagement possible within the project, consult our comprehensive guide:
Learning Flutter Through Open Neom: A Comprehensive Path.

📄 License
This project is licensed under the Apache License, Version 2.0, January 2004. See the LICENSE file for details.
