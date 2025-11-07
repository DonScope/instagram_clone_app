# instagram_clone_app

A fully functional Instagram clone built with Flutter, Firebase, and Supabase.  
This project replicates core Instagram features with modern architecture and a responsive UI.

## Features

- Firebase Authentication (sign up, log in, log out)
- Create, edit, and delete posts with captions and images  
- Like, comment, and save posts  
- Follow and unfollow users  
- Upload and view stories (auto-expire after 24 hours)  
- Real-time feed updates using Cloud Firestore  
- Store and fetch images, profile pictures, and videos using Supabase Storage  
- User profiles with followers and following lists  
- Responsive UI using ScreenUtil  
- State management with Cubit  
- API handling with Dio  

## Getting Started

This project is a complete Flutter application connected to Firebase and Supabase.

To run it locally:

1. Clone the repository  
   ```bash
   git clone https://github.com/DonScope/instagram_clone_app.git
   ```
2. Install dependencies  
   ```bash
   flutter pub get
   ```
3. Set up Firebase:
   - Add your `google-services.json` (Android)
   - Add your `GoogleService-Info.plist` (iOS)
4. Configure Supabase:
   - Add your Supabase URL and anon key in `.env` or constants file
5. Run the app  
   ```bash
   flutter run
   ```

## Tech Stack

- Flutter (Dart)  
- Firebase (Auth, Firestore)  
- Supabase Storage  
- Cubit (Bloc)  
- Dio  
- ScreenUtil  

## About

This project was created as a learning and development resource for Flutter developers who want to explore real-world app architecture using Firebase, Supabase, and clean state management.  
It can also serve as a base for social media or community-style applications.
