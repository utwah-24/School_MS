# School Management System

A comprehensive school management system built with Flutter and Supabase, designed to handle various aspects of school administration including student management, teacher management, and academic tracking.

## Features

- Role-based access control (Admin, School Owner, Teacher, Student)
- Student management and enrollment
- Teacher management and assignment
- Academic performance tracking
- Homework assignment and submission
- Results management and reporting
- School statistics and analytics

## Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Supabase account and project

## Setup

1. Clone the repository:

```bash
git clone https://github.com/yourusername/school-management-system.git
cd school-management-system
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure environment variables:

   - Copy `.env.example` to `.env`
   - Update the Supabase URL and anon key with your project credentials

4. Run the application:

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart              # Application entry point
├── pages/                 # Screen pages
│   ├── admin/            # Admin-specific pages
│   ├── owner/            # School owner pages
│   ├── teacher/          # Teacher pages
│   └── student/          # Student pages
├── utils/                # Utility classes and constants
└── widgets/              # Reusable widgets
```

## Security

- Environment variables are used to store sensitive configuration
- Role-based access control implemented
- Secure authentication with Supabase
- Input validation and sanitization

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
