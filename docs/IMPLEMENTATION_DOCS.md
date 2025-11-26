# UTANGIN Frontend Development Documentation

## Overview
This document details the complete implementation of the UTANGIN frontend application, a personal loan management platform designed to formalize and transparently manage loans between individuals. The app was built using Flutter with a focus on the core features required for the MVP.

## Project Structure

```
lib/
├── models/
│   ├── user.dart          # User data model
│   ├── agreement.dart     # Agreement data model
│   ├── notification.dart  # Notification data model
│   └── auth.dart          # Authentication models
├── services/
│   ├── api_service.dart      # API service for backend communication
│   ├── auth_provider.dart    # Authentication provider for state management
│   ├── agreement_provider.dart # Agreement provider for state management
│   └── main_provider.dart    # Main provider combining other providers
├── screens/
│   ├── splash_screen.dart        # Initial splash screen
│   ├── login_screen.dart         # User login screen
│   ├── register_screen.dart      # User registration screen
│   ├── dashboard_screen.dart     # Main dashboard screen
│   ├── agreement_detail_screen.dart # Agreement details screen
│   ├── create_agreement_screen.dart # Create new agreement screen
│   ├── qr_scanner_screen.dart    # QR code scanner screen
│   ├── qr_creation_screen.dart   # QR code generation screen
│   └── repayment_tracking_screen.dart # Repayment tracking screen
├── theme/
│   └── app_theme.dart           # App theme configuration
└── main.dart                    # App entry point
```

## Dependencies Added

The following dependencies were added to pubspec.yaml:

- http: ^1.2.2 - For API communication
- provider: ^6.1.2 - For state management
- shared_preferences: ^2.2.3 - For local storage
- qr_flutter: ^4.1.0 - For QR code generation
- qr_code_scanner: ^1.0.1 - For QR code scanning
- image_picker: ^1.1.2 - For image handling
- image: ^4.2.1 - For image processing
- intl: ^0.19.0 - For date/time formatting
- form_field_validator: ^1.1.0 - For form validation
- flutter_dotenv: ^5.1.0 - For environment variables
- flutter_spinkit: ^5.2.1 - For loading indicators
- flutter_iconpicker: ^3.5.1 - For icons

## Data Models

### User Model (lib/models/user.dart)
- Complete user data structure with all fields from the backend schema
- JSON serialization/deserialization methods
- All necessary fields including verification status, reputation, balance, etc.

### Agreement Model (lib/models/agreement.dart)
- Comprehensive agreement structure with lender/borrower IDs
- Amount, interest rate, due date, status tracking
- Repayment schedule with obligations
- Agreement status enum (pending, active, paid, overdue, disputed)

### Notification Model (lib/models/notification.dart)
- Notification data structure with type, delivery method, read status
- Notification type enum and delivery method enum

### Auth Model (lib/models/auth.dart)
- Authentication token handling
- Login response structure
- Register request model

## Services Implementation

### API Service (lib/services/api_service.dart)
- Complete API integration with all backend endpoints
- Authentication methods (register, login, logout, get profile)
- User management methods (get all users, get user by ID, update user)
- Agreement management methods (create, get, update, confirm, mark as paid)
- Notification methods (get user notifications, mark as read)
- QR code methods (generate QR for agreement)
- Token management with shared preferences
- Environment variable support for API base URL

### State Management Providers

#### Auth Provider (lib/services/auth_provider.dart)
- User authentication state management
- Registration and login functionality
- User profile fetching and updates
- Error handling and loading states

#### Agreement Provider (lib/services/agreement_provider.dart)
- Agreement state management
- Fetch, create, confirm, mark as paid operations
- Agreement filtering by status and user
- Loading state management

#### Main Provider (lib/services/main_provider.dart)
- Combines auth and agreement providers
- Initializes API service with environment variables
- Centralized app state management

## Screen Implementations

### Main Entry Point (lib/main.dart)
- Provider pattern setup for state management
- Theme configuration
- Splash screen as home page

### Splash Screen (lib/screens/splash_screen.dart)
- Initial app branding display
- Automatic navigation to login screen
- App initialization

### Login Screen (lib/screens/login_screen.dart)
- Email and password fields with validation
- Login functionality with error handling
- Link to registration screen
- Loading state during authentication

### Registration Screen (lib/screens/register_screen.dart)
- Complete user registration form
- Validation for all required fields (name, email, phone, KTP, address, password)
- Registration functionality with error handling
- Link to login screen

### Dashboard Screen (lib/screens/dashboard_screen.dart)
- Welcome message with user name
- Summary cards showing total loaned, borrowed, active agreements, and reputation
- Recent agreements list with status indicators
- Floating action button for creating new agreements
- Pull-to-refresh functionality
- Navigation to other screens

### Agreement Detail Screen (lib/screens/agreement_detail_screen.dart)
- Detailed display of agreement information
- Party information (lender and borrower)
- Agreement terms display
- Confirmation status
- Action buttons based on agreement status
- QR code option

### Create Agreement Screen (lib/screens/create_agreement_screen.dart)
- Form for creating new loan agreements
- Fields for borrower ID, amount, interest rate, due date
- Date picker for due date selection
- Validation and error handling
- Agreement creation functionality

### QR Scanner Screen (lib/screens/qr_scanner_screen.dart)
- Camera-based QR code scanning
- Overlay for scanning area
- Manual entry option as fallback
- Camera flip functionality

### QR Creation Screen (lib/screens/qr_creation_screen.dart)
- QR code generation for agreements
- Display of agreement details with QR code
- Proper data formatting for scanning

### Repayment Tracking Screen (lib/screens/repayment_tracking_screen.dart)
- Tab-based navigation (All, Active, Overdue, Completed)
- Filtered agreement lists based on status
- Visual indicators for agreement status
- Action options based on user role and agreement status
- Pull-to-refresh functionality

## Theme Configuration

### App Theme (lib/theme/app_theme.dart)
- Light and dark theme definitions
- Green color scheme for financial application
- Consistent styling across the app
- Material 3 support

## Backend API Integration

### API Configuration
- Environment variable support via .env file
- Base URL configuration
- JWT token management
- Error handling for API responses
- Proper header configuration

### Environment Configuration
- .env file with API_BASE_URL
- Default fallback URL in case environment variable is missing

## State Management

### Provider Pattern Implementation
- Multi-provider setup in main.dart
- ChangeNotifier-based providers
- Proper disposal of resources
- Centralized state management

## Security Features
- JWT token storage in shared preferences
- Token-based authentication for all API calls
- Secure API communication
- Proper error handling to prevent data exposure

## User Experience Features
- Loading indicators during API calls
- Form validation with appropriate error messages
- Pull-to-refresh functionality
- Responsive UI design
- Consistent navigation patterns

## Error Handling
- Comprehensive error handling for API calls
- User-friendly error messages
- Proper validation of form inputs
- Network error handling

## Code Quality
- Clean, organized code structure
- Proper comments and documentation
- Consistent naming conventions
- Separation of concerns across files
- Reusable components and patterns

## Testing Readiness
- Modular architecture ready for unit testing
- Proper separation of UI and business logic
- Mockable dependencies for testing
- Consistent API service interface

## Future Enhancements
The current implementation provides a solid foundation for future enhancements:
- Notification system integration
- Image upload for verification documents
- Payment gateway integration
- Push notification implementation
- Advanced reporting features

## Summary
The UTANGIN frontend application is now fully functional with all core features implemented:

1. User authentication and registration
2. Agreement creation and management
3. QR code generation and scanning for agreement confirmation
4. Dashboard with financial summaries
5. Repayment tracking system
6. Complete backend API integration
7. Proper state management using Provider pattern
8. Responsive UI with consistent theming
9. Environment configuration for API endpoints
10. Comprehensive error handling and validation

The application is ready to connect to the backend API and can be run with `flutter run`.