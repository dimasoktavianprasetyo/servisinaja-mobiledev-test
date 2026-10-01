# ServisinAja Mobile Application
## Technical Architecture Specification & Software Requirements Document

---

### Document Information
- Project Name: ServisinAja Mobile App
- Version: 1.0.0+1
- Framework: Flutter 3.9.x (Dart 3.9.x)
- Document Classification: Engineering Specification & Software Requirements Document (SRD)
- Target Platforms: Android, iOS, Web, Desktop (macOS, Windows, Linux)
- Primary Language: English
- License: Proprietary / Internal Use Only

---

## Table of Contents
1. Executive Summary & Product Vision
2. Software Requirements Specification (SRS)
   - 2.1 Functional Requirements (FR)
   - 2.2 Non-Functional Requirements (NFR)
3. Architecture & Design Patterns
   - 3.1 Layered Architectural Model
   - 3.2 State Management Paradigm
   - 3.3 Design System & Dual-Theme Architecture
4. Comprehensive Project Directory Tree
5. Detailed Module & Screen Specifications
   - 5.1 Main Navigation Shell
   - 5.2 Dashboard (Beranda)
   - 5.3 Booking & Scheduling Engine
   - 5.4 Roadside Emergency Dispatch System (Layanan Darurat)
   - 5.5 Mechanic Communication Suite (VoIP & Live Chat)
   - 5.6 Real-Time Service Tracking (Status Servis)
   - 5.7 Multi-Vehicle Garage Management (Garasi Saya)
   - 5.8 Service History & Digital Logbook (Aktivitas & Buku Servis)
   - 5.9 Vouchers & Promotional Engine
   - 5.10 Notification Dispatch & Alert Center
   - 5.11 Profile, Address & Account Security Suite
6. Design System Tokens & Asset Catalog
   - 6.1 Color Matrix (Light & Dark Modes)
   - 6.2 Typography Hierarchy
   - 6.3 Static Assets & Resolution Variants
7. Technical Stack & Dependencies
8. Installation, Configuration & Build Guide
   - 8.1 System Prerequisites
   - 8.2 Local Development Setup
   - 8.3 Target Platform Execution
   - 8.4 Production Release Generation
9. Quality Assurance, Testing & Static Analysis
10. Requirements Traceability Matrix

---

## 1. Executive Summary & Product Vision

ServisinAja is a next-generation motorcycle maintenance and roadside assistance mobile platform. The application provides an integrated digital service ecosystem for two-wheeler owners, certified workshops (bengkel mitra), and mobile field technicians (montir darurat).

### Key Objectives:
- Eliminate traditional workshop waiting queues via scheduled booking and home service dispatch.
- Provide transparent cost estimation, authentic parts breakdown, and multi-vehicle garage management.
- Deliver a rapid emergency dispatch system featuring real-time radar scanning, road-aligned GPS live map tracking, and technician communication.
- Offer an immutable digital service logbook and warranty certification to maximize vehicle resale value and operational reliability.
- Provide a responsive user experience optimized across mobile touchscreens, desktop mouse pointers, and high-DPI displays with seamless Light and Dark mode transitions.

---

## 2. Software Requirements Specification (SRS)

### 2.1 Functional Requirements (FR)

| Requirement ID | Module | Description | Implementation Status |
|---|---|---|---|
| **FR-01** | Garage Management | Users can register, edit, view, and switch between multiple motorcycles (plate number, odometer, transmission, engine CC, chassis number). | Completed |
| **FR-02** | Service Catalog | Users can browse services categorized into Ringan (light), Rutin (routine), and Berat (heavy), with upfront pricing and scope. | Completed |
| **FR-03** | Workshop Booking | Users can select target authorized workshops (AHASS/Mitra), pick calendar dates, select dynamic time slots, and review cost breakdowns. | Completed |
| **FR-04** | Digital Boarding Ticket | Upon booking confirmation, the system generates a digital ticket containing a dynamic QR code, notch cutouts, workshop metadata, and celebration confetti. | Completed |
| **FR-05** | Roadside Emergency | Users can trigger emergency roadside assistance, select malfunction categories (flat tire, dead battery, engine failure), and view nearby technicians. | Completed |
| **FR-06** | Radar Search Animation | A high-precision 10-second radar sweep animation simulates live technician proximity detection with visual target lock-on. | Completed |
| **FR-07** | Live Map Tracking | An interactive custom canvas renders city street grids, waterways, bridges, breakdown hazard pins, technician markers, and road-aligned route trajectories. | Completed |
| **FR-08** | Docked Bottom Dispatch Card | The live map features a collapsible, gesture-aware bottom card displaying technician credentials, real-time ETA, and direct action triggers. | Completed |
| **FR-09** | VoIP Call Simulation | A dedicated calling interface provides real-time call duration counters, animated audio soundwaves, mute/speaker toggles, and dual contact routing (Technician / 24/7 Hotline). | Completed |
| **FR-10** | Live Chat System | An interactive chat room supports simulated technician responses, roadside photo inspection previews, and quick-reply action chips. | Completed |
| **FR-11** | Service Timeline | A 4-stage stepper timeline (Menunggu Montir, Menuju Lokasi, Sedang Dikerjakan, Selesai) with animated pull-to-refresh mechanics. | Completed |
| **FR-12** | Digital Service Book | Complete historical service log per registered vehicle with odometer tracking, service milestones, and workshop verification stamps. | Completed |
| **FR-13** | Promo Engine | Vouchers with percentage/flat discounts, voucher copying, promo banners carousel, and dynamic calculation in booking summaries. | Completed |
| **FR-14** | Notification Center | Real-time push alert simulation with categorized tabs (Semua, Servis, Promo, Info), unread count badges, and auto-dispatch triggers. | Completed |
| **FR-15** | Profile & Security | Account management including multi-address storage, 6-digit PIN modification, password updating with validation rules, and FAQ support accordion. | Completed |

### 2.2 Non-Functional Requirements (NFR)

#### NFR-01: Performance & Rendering Fidelity
- The user interface must maintain a consistent 60 frames per second (FPS) rendering speed, targeting 120 FPS on high-refresh-rate mobile displays.
- Custom canvas animations (radar sweep, soundwaves, confetti bursts, road-aligned map trajectories) must utilize hardware-accelerated painters without inducing garbage collection stutter.

#### NFR-02: Accessibility & Theme Compliance
- Color contrast across all typography, icons, and surface containers must comply with WCAG 2.1 Level AA standards.
- Every screen must support instant switching between Light Mode (`#FAF8F5` base background) and Dark Mode (`#0B1120` obsidian base background) without requiring an application restart.

#### NFR-03: Cross-Platform Input Compatibility
- Flutter `MaterialScrollBehavior` must be configured with `PointerDeviceKind.mouse`, `touch`, `stylus`, and `trackpad` to guarantee smooth dragging and scrolling across desktop browsers and mobile devices.

#### NFR-04: Robust Navigation & State Integrity
- All contextual flows (Emergency Dispatch, Booking Wizard, Profile Sub-screens) must maintain strict navigational stack integrity.
- Emergency cancellation and completion actions must cleanly pop routes until the root Beranda route is restored, resetting navigation tab states accurately.

#### NFR-05: Modularity & Code Maintainability
- Zero static analysis warnings (`dart analyze` score must remain 100% clean).
- Strict separation of concerns between Presentation layer widgets, Application Controllers, Data Models, and Core Design Tokens.

---

## 3. Architecture & Design Patterns

### 3.1 Layered Architectural Model

ServisinAja adopts an adapted Clean Architecture pattern tailored for Flutter applications:

```
+-------------------------------------------------------------+
|                     PRESENTATION LAYER                      |
|  Screens (UI Pages) | Widgets (Sub-components) | Painters    |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                     CONTROLLER LAYER                        |
|   AppController (ChangeNotifier / Single Source of Truth)   |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                      DOMAIN & DATA LAYER                    |
|   Models (Immutable Entities) | Mock Repositories / Sources |
+-------------------------------------------------------------+
                              |
                              v
+-------------------------------------------------------------+
|                         CORE LAYER                          |
|   Constants (AppColors) | Typography | Theme | Utilities    |
+-------------------------------------------------------------+
```

1. **Presentation Layer (`lib/presentation/`)**:
   - Contains all view components divided by feature domain (`home`, `booking`, `emergency`, `garasi`, `profile`, `status`, `aktivitas`, `promo`, `notification`, `call`, `chat`).
   - Pure UI logic delegates user intentions directly to the controller.

2. **Controller Layer (`lib/presentation/controllers/`)**:
   - `AppController` acts as the single source of truth managing reactive states via `ChangeNotifier`.
   - Listenable bindings (`ListenableBuilder`) trigger surgical sub-tree repaints without unnecessary widget rebuilds.

3. **Data Layer (`lib/data/`)**:
   - Data models (`VehicleModel`, `ServiceModel`, `BookingModel`, `ChatMessageModel`, `PromoVoucherModel`, `NotificationModel`) defined with immutable fields, JSON serialization helpers, and copy constructors (`copyWith`).
   - Mock data repository (`MockData`) provides pre-populated, production-realistic domain data.

4. **Core Layer (`lib/core/`)**:
   - Design tokens (`AppColors`), typography definitions (`AppTypography`), theme configurations (`AppTheme`), and formatting utilities (`Formatters`).

### 3.2 State Management Paradigm

The application utilizes Flutter's native `ChangeNotifier` combined with `ListenableBuilder`:
- **Predictable Data Flow**: Unidirectional data flow from `AppController` to UI screens.
- **Resource Optimization**: Avoids heavyweight third-party bloat while retaining fine-grained reactivity.
- **Persistent State Lifecycle**: Instantiated at the root widget (`ServisinAjaApp`) and propagated via constructor injection or scoped providers.

### 3.3 Design System & Dual-Theme Architecture

The application implements a centralized design token system:
- **Light Theme**: Warm luxury cream background (`#FAF8F5`), crisp white cards (`#FFFFFF`), slate text (`#0F172A`), and vibrant high-contrast orange primary (`#FF6B00`).
- **Dark Theme**: Deep obsidian background (`#0B1120`), slate surfaces (`#1E293B`), frosted borders (`#334155`), and luminous off-white text (`#F8FAFC`).
- **Semantic Accents**: Emergency Red (`#EF4444`), Success Emerald (`#10B981`), Warning Amber (`#F59E0B`), and Info Cyan (`#0EA5E9`).

---

## 4. Comprehensive Project Directory Tree

```
servisin_aja/
|-- android/                         # Android platform native configuration & gradle
|-- ios/                             # iOS platform native workspace & CocoaPods configuration
|-- web/                             # Web hosting index, manifest & service worker
|-- windows/                         # Windows desktop runner configuration
|-- macos/                           # macOS desktop runner configuration
|-- linux/                           # Linux desktop runner configuration
|-- assets/                          # Static assets and resolution variants
|   `-- images/                      # Vector illustrations, photos, avatars & branding
|       |-- ticket/                  # Ticket boarding pass assets (Light Mode)
|       |   |-- bengkel_mitra.png
|       |   |-- btn_close.png
|       |   |-- btn_share.png
|       |   |-- dashed_notches.png
|       |   |-- dots.png
|       |   |-- motor_icon.png
|       |   |-- multi_motor_badge.png
|       |   |-- notches.png
|       |   |-- qr_code.png
|       |   |-- qr_code_box.png
|       |   |-- schedule_jadwal.png
|       |   |-- success_badge.png
|       |   `-- warning_box.png
|       |-- ticket/dark/             # Ticket boarding pass assets (Dark Mode)
|       |   |-- bengkel_mitra.png
|       |   |-- btn_close.png
|       |   |-- btn_share.png
|       |   |-- motor_icon.png
|       |   |-- schedule_jadwal.png
|       |   `-- warning_box.png
|       |-- cvt_roller_inspection.png
|       |-- feature_booking.png
|       |-- feature_emergency.png
|       |-- feature_homeservice.png
|       |-- Ilustrasi-ganti-oli.webp
|       |-- kampas_rem_inspection.jpg
|       |-- kang_agus.png
|       |-- kang_asep.png
|       |-- logo.webp
|       |-- mechanic_avatar.png
|       |-- motor_beat.png
|       |-- motor_vario.png
|       |-- ongoing_service_illustration.jpg
|       |-- promo_banner.png
|       |-- tania_avatar.png
|       `-- tips_oil.png
|-- lib/                             # Application source code
|   |-- main.dart                    # Application entry point, DevicePreview setup & root builder
|   |-- core/                        # Core system tokens, constants & utilities
|   |   |-- constants/
|   |   |   |-- app_colors.dart      # Semantic color palette for Light and Dark themes
|   |   |   `-- app_typography.dart  # Google Fonts typography tokens & heading definitions
|   |   |-- theme/
|   |   |   `-- app_theme.dart       # ThemeData configurations for Light and Dark modes
|   |   `-- utils/
|   |       `-- formatters.dart      # Currency (IDR), date & odometer formatting helpers
|   |-- data/                        # Data entities, models & mock repositories
|   |   |-- mock/
|   |   |   `-- mock_data.dart       # Static catalog data, vehicles, services & vouchers
|   |   `-- models/
|   |       |-- booking_model.dart        # Booking entity & BookingStatus enumeration
|   |       |-- chat_message_model.dart   # Interactive chat message representation
|   |       |-- notification_model.dart   # Push notification data entity
|   |       |-- promo_voucher_model.dart  # Discount voucher & promotional terms
|   |       |-- service_model.dart        # Workshop service specifications & pricing
|   |       `-- vehicle_model.dart        # Motorcycle entity with technical specifications
|   `-- presentation/                # UI Presentation layer
|       |-- controllers/
|       |   `-- app_controller.dart  # Global state manager, dispatchers & business logic
|       |-- screens/
|       |   |-- main_navigation_screen.dart # Root navigation shell & persistent bottom bar
|       |   |-- aktivitas/           # Service activity and history module
|       |   |   |-- aktivitas_servis_screen.dart
|       |   |   `-- widgets/
|       |   |       |-- aktivitas_filter_bar.dart
|       |   |       |-- aktivitas_guarantee_banner.dart
|       |   |       |-- aktivitas_history_card.dart
|       |   |       `-- aktivitas_ongoing_card.dart
|       |   |-- booking/             # Workshop booking wizard module
|       |   |   |-- booking_step1_screen.dart
|       |   |   |-- schedule_picker_screen.dart
|       |   |   |-- booking_confirm_screen.dart
|       |   |   `-- booking_success_ticket_screen.dart
|       |   |-- buku_servis/         # Digital service logbook module
|       |   |   `-- buku_servis_screen.dart
|       |   |-- call/                # VoIP call interface module
|       |   |   `-- call_montir_screen.dart
|       |   |-- chat/                # Live mechanic messaging module
|       |   |   `-- chat_montir_screen.dart
|       |   |-- emergency/           # Roadside emergency dispatch module
|       |   |   |-- emergency_request_screen.dart
|       |   |   |-- emergency_searching_screen.dart
|       |   |   `-- emergency_tracking_screen.dart
|       |   |-- garasi/              # Vehicle garage management module
|       |   |   |-- garasi_screen.dart
|       |   |   `-- widgets/
|       |   |       `-- tambah_motor_sheet.dart
|       |   |-- home/                # Main dashboard module
|       |   |   |-- home_screen.dart
|       |   |   `-- widgets/
|       |   |       |-- features_grid.dart
|       |   |       |-- garasi_preview_list.dart
|       |   |       |-- home_header.dart
|       |   |       |-- promo_banner_carousel.dart
|       |   |       |-- tips_card.dart
|       |   |       `-- tips_detail_modal.dart
|       |   |-- notification/        # Notification center module
|       |   |   `-- notification_screen.dart
|       |   |-- profile/             # User profile, security & support module
|       |   |   |-- profile_screen.dart
|       |   |   |-- alamat_tersimpan_screen.dart
|       |   |   |-- keamanan_akun_screen.dart
|       |   |   |-- ubah_kata_sandi_screen.dart
|       |   |   |-- ganti_pin_screen.dart
|       |   |   `-- pusat_bantuan_screen.dart
|       |   |-- promo/               # Promotions and discount vouchers module
|       |   |   `-- promo_screen.dart
|       |   `-- status/              # Live workshop service status module
|       |       |-- status_servis_screen.dart
|       |       `-- widgets/
|       |           |-- animated_refresh_button.dart
|       |           |-- mechanic_finding_card.dart
|       |           |-- service_stepper_timeline.dart
|       |           `-- status_mechanic_card.dart
|       `-- widgets/                 # Reusable cross-module UI components
|           |-- animated_soundwave.dart
|           |-- app_button.dart
|           |-- badge_percent_icon.dart
|           |-- servisin_app_bar.dart
|           `-- status_badge.dart
|-- test/                            # Automated widget & unit tests
|   `-- widget_test.dart             # Smoke & widget mounting test suite
|-- pubspec.yaml                     # Dependencies, assets & environment metadata
|-- analysis_options.yaml            # Linter rules & code standards
`-- README.md                        # Technical documentation & requirements specification
```

---

## 5. Detailed Module & Screen Specifications

### 5.1 Main Navigation Shell (`main_navigation_screen.dart`)
- **Navigation Engine**: Utilizes an `IndexedStack` to preserve scrolling positions and input states across 5 primary tabs:
  1. Index 0: Beranda (Home Dashboard)
  2. Index 1: Booking (Booking Wizard)
  3. Index 2: Promo (Promotional Vouchers)
  4. Index 3: Garasi (Motorcycle Garage)
  5. Index 4: Akun (User Profile & Account)
- **Top Bar Dynamic Tinting**: Background container uses a vertical gradient (subtle amber/orange drift in Light mode; rich obsidian dark gradient in Dark mode).
- **Persistent Bottom Bar**: Custom height of 60px with elevated border lines, responsive ink ripples, and custom vector icons.

### 5.2 Dashboard Module (`home/`)
- **`HomeHeader`**: Displays user greeting, location selector, theme toggle switch, and notification bell with live unread badge counter.
- **`GarasiPreviewList`**: Horizontal vehicle selector displaying currently active motorcycle, plate number, odometer reading, and quick-switch capabilities.
- **`FeaturesGrid`**: Quick-action launchers for:
  - Booking Servis (opens booking flow)
  - Home Service (on-demand mechanic visit)
  - Layanan Darurat (triggers emergency dispatch workflow)
  - Buku Servis Digital (opens service logbook)
- **`PromoBannerCarousel`**: Interactive horizontal carousel featuring ongoing seasonal discounts and partner workshop promotions.
- **`TipsCard` & `TipsDetailModal`**: Curated vehicle maintenance insights (e.g., oil viscosity guidelines, CVT belt wear signs) with full-screen detailed reading modals.

### 5.3 Booking & Scheduling Engine (`booking/`)
- **`BookingStep1Screen`**:
  - Vehicle selection card with live motor specifications.
  - Multi-tiered service catalog (Servis Ringan, Servis Rutin, Servis Lengkap/Besar) with transparent pricing and checklist of inclusions.
- **`SchedulePickerScreen`**:
  - Interactive calendar date picker.
  - Workshop selector (AHASS Mitra) with distance calculations.
  - Matrix time slot selector (Morning, Afternoon, Evening availability).
- **`BookingConfirmScreen`**:
  - Itemized cost breakdown (service fee, parts, administration).
  - Promo code input with instant validation and discount deduction.
  - Payment method selector (Cash on Service, QRIS, Bank Transfer, E-Wallet).
- **`BookingSuccessTicketScreen`**:
  - Digital boarding-pass style ticket rendered with authentic upper and lower circular notch cutouts.
  - Scannable dynamic QR code for workshop check-in verification.
  - Integrated celebration confetti explosion animation with particle dispersion.
  - Action buttons to share ticket receipt or view live service status.

### 5.4 Roadside Emergency Dispatch System (`emergency/`)
- **`EmergencyRequestScreen`**:
  - Full-screen custom canvas displaying nearby standby technicians.
  - Emergency malfunction selector pills:
    - Mesin Mogok / Mati Total
    - Ban Bocor / Kurang Angin
    - Rem Blong / Bermasalah
    - Aki Soak / Kelistrikan
    - Rantai Putus / CVT Rusak
    - Mesin Overheat
  - Location verification with GPS coordinates and manual landmark notes input.
- **`EmergencySearchingScreen`**:
  - 10-second countdown radar animation.
  - Concentric sonar pulse waves expanding outward with rotational radar beam sweep.
  - Simulated technician lock-on sequence with smooth status stage transitions.
  - Automatic dispatch notification generator upon technician match.
- **`EmergencyTrackingScreen`**:
  - Multi-avenue city grid canvas (West Avenue, East Avenue, cross streets, river waterway, and bridges).
  - High-precision road-aligned trajectory route (orange dashed line adhering strictly to center-street coordinates).
  - Moving technician vehicle marker and pulsating breakdown hazard pin.
  - **Docked Bottom Dispatch Card**:
    - Permanently docked card that never scrolls out or disappears.
    - Gesture-enabled: swipe up to expand full technician details; swipe down to collapse to compact view.
    - Compact view shows ETA (`~12 Menit`), distance (`1.8 km`), and rotating toggle chevron.
    - Expanded view shows technician credentials (Kang Asep Supriyadi, 4.9 rating, 1,200+ jobs), breakdown details, and action shortcuts.
    - Back navigation protection: back button, system gesture, and cancellation dialog ("Ya, Batalkan") cleanly route back to the Beranda tab.

### 5.5 Mechanic Communication Suite (`call/` & `chat/`)
- **`CallMontirScreen`**:
  - Supports dual contact routing:
    - Field Technician: Kang Asep Supriyadi (Honda Genuine Service)
    - 24/7 Emergency Call Center: 1500-988
  - Active call timer, microphone mute toggle, speakerphone selector, and numeric keypad overlay.
  - Animated multi-bar audio soundwave responding during active calls.
- **`ChatMontirScreen`**:
  - Real-time conversation thread with timestamped message bubbles.
  - Mechanic online presence indicator.
  - Technician image attachment preview showcasing live roadside inspection (worn brake pad / CVT inspection).
  - Quick-prompt action chips ("Posisi saya di depan ruko", "Apakah bawa ban dalam cadangan?").
  - Simulated automated technician reply engine with realistic 2-second typing delay.

### 5.6 Real-Time Service Tracking (`status/`)
- **`StatusServisScreen`**:
  - 4-stage vertical stepper timeline illustrating real-time job progression.
  - Live technician information card with plate number, assigned service pit, and contact buttons.
  - `AnimatedRefreshButton`: interactive spinning sync action that simulates live telemetry updates.
  - Detailed task progress checklist (e.g., Oil Drained, Spark Plug Cleaned, Filter Replaced).

### 5.7 Multi-Vehicle Garage Management (`garasi/`)
- **`GarasiScreen`**:
  - Multi-card motorcycle carousel with odometer meters, condition badges, and last service logs.
  - Active motorcycle toggle for all subsequent booking operations.
  - Technical vehicle specification table (Year, Engine CC, Transmission, Chassis Number, Engine Number).
- **`TambahMotorSheet`**:
  - Bottom modal sheet form for registering additional motorcycles.
  - Input validation for brand, model, plate number, manufacturing year, and transmission type.

### 5.8 Service History & Digital Logbook (`aktivitas/` & `buku_servis/`)
- **`AktivitasServisScreen`**:
  - Tab-based filter bar: Semua, Berlangsung, Selesai, Dibatalkan.
  - Ongoing service card with live progress indicator.
  - Historical service cards with itemized invoices and workshop stamps.
  - Official warranty guarantee banner (Garansi Servis 7 Hari / 500 KM).
- **`BukuServisScreen`**:
  - Immutable digital logbook per motorcycle.
  - Maintenance schedule recommendations based on cumulative odometer mileage.
  - Regular oil change interval countdown.

### 5.9 Vouchers & Promotional Engine (`promo/`)
- **`PromoScreen`**:
  - Discount voucher card listings with percentage tags, expiry dates, and minimum spend terms.
  - One-tap voucher code copying to clipboard with confirmation toast.
  - Filter categories: Servis Rutin, Oli & Sparepart, Diskon Darurat.

### 5.10 Notification Center (`notification/`)
- **`NotificationScreen`**:
  - Real-time notification listing segmented into date sections (HARI INI, KEMARIN).
  - Category filters: Semua, Servis, Promo, Info.
  - Status highlight badges (e.g., "Pit 01 & 02", "Dikonfirmasi").
  - Mark-all-as-read functionality with dynamic counter updates in the header.

### 5.11 Profile, Address & Account Security Suite (`profile/`)
- **`ProfileScreen`**:
  - Verified user profile header (Tania Regina, Verified Member).
  - Quick-access menus for Saved Addresses, Account Security, Help Center, and Terms of Service.
- **`AlamatTersimpanScreen`**:
  - Saved addresses manager (Home, Office, Primary Tagging) with full street, district, and notes metadata.
- **`KeamananAkunScreen`**:
  - Security overview: Biometric Login status, 2-Factor Authentication, Password, and Security PIN.
- **`UbahKataSandiScreen`**:
  - Password change form with current password validation, new password strength meter, and show/hide password toggles.
- **`GantiPinScreen`**:
  - 6-digit transaction PIN change interface with numeric keypad and masking circles.
- **`PusatBantuanScreen`**:
  - Expandable FAQ accordion covering booking cancellation, emergency response radius, and payment policies.
  - Direct customer support hotline and WhatsApp integration links.

---

## 6. Design System Tokens & Asset Catalog

### 6.1 Color Matrix (Light & Dark Modes)

| Token Name | Light Mode Hex | Dark Mode Hex | Semantic Role |
|---|---|---|---|
| `primary` | `#FF6B00` | `#FF6B00` | Main brand accent, primary CTA buttons |
| `primaryDark` | `#E05300` | `#E05300` | Pressed state, gradient terminal |
| `primaryLight` | `#FF8533` | `#FF8533` | Highlights, hover overlays |
| `primaryContainer` | `#FFF0E6` | `#3A1800` | Pill container, active tab background |
| `emergency` | `#EF4444` | `#EF4444` | Roadside alerts, cancel buttons, error tags |
| `emergencyDark` | `#DC2626` | `#DC2626` | Severe hazard highlights |
| `emergencyContainer`| `#FEE2E2` | `#450A0A` | Emergency chip container |
| `success` | `#10B981` | `#10B981` | Completed tasks, verified badges |
| `warning` | `#F59E0B` | `#F59E0B` | In-progress statuses, pending reviews |
| `info` | `#0EA5E9` | `#0EA5E9` | Information notices, GPS routes |
| `bg` | `#F8FAFC` | `#0B1120` | Base canvas background |
| `surface` | `#FFFFFF` | `#1E293B` | Card surfaces, modal sheets |
| `border` | `#E2E8F0` | `#334155` | Structural dividers, outline strokes |
| `textPrimary` | `#0F172A` | `#F8FAFC` | High-emphasis headers, titles |
| `textSecondary` | `#475569` | `#94A3B8` | Body copy, subtitles |
| `textMuted` | `#94A3B8` | `#64748B` | Captions, inactive tab labels |

### 6.2 Typography Hierarchy

Implemented via `GoogleFonts.plusJakartaSans`:
- **Display Heading**: 24pt / SemiBold (w700), Line Height: 1.2
- **Screen Title**: 20pt / Bold (w700), Line Height: 1.25
- **Section Heading**: 16pt / SemiBold (w600), Line Height: 1.3
- **Card Title**: 14pt / SemiBold (w600), Line Height: 1.35
- **Body Regular**: 14pt / Regular (w400), Line Height: 1.5
- **Body Medium**: 13pt / Medium (w500), Line Height: 1.45
- **Caption / Label**: 12pt / SemiBold (w600), Line Height: 1.2
- **Micro Badge**: 10pt / Bold (w700), Line Height: 1.1

### 6.3 Static Assets Catalog
- **Brand Identity**: `logo.webp`
- **Features Icons**: `feature_booking.png`, `feature_emergency.png`, `feature_homeservice.png`
- **Vehicle Models**: `motor_vario.png`, `motor_beat.png`
- **Technicians**: `kang_asep.png`, `kang_agus.png`, `mechanic_avatar.png`, `tania_avatar.png`
- **Roadside Inspection Photos**: `kampas_rem_inspection.jpg`, `cvt_roller_inspection.png`
- **Boarding Pass Ticket Assets**: `ticket/` and `ticket/dark/` (notches, QR boxes, warning boxes, dashed lines)

---

## 7. Technical Stack & Dependencies

### Core Framework
- **Flutter SDK**: `>=3.9.2`
- **Dart SDK**: `^3.9.2`
- **Material Design**: Version 3 (`uses-material-design: true`)

### Production Dependencies (`pubspec.yaml`)
- `cupertino_icons: ^1.0.8`: iOS style symbol pack.
- `google_fonts: ^8.1.0`: Dynamic typography loading for Plus Jakarta Sans.
- `intl: 0.20.2`: Currency formatting (Indonesian Rupiah `IDR`), date parsing, and localized representations.
- `device_preview: ^1.3.1`: Multi-device responsive screen simulator for debugging and presentation.

### Dev Dependencies
- `flutter_test`: Native testing framework for unit and widget verification.
- `flutter_lints: ^5.0.0`: Strict static analysis and code standard rules.

---

## 8. Installation, Configuration & Build Guide

### 8.1 System Prerequisites
Before running or building the project, ensure your workstation has the following installed:
1. Git CLI (`git --version` >= 2.30)
2. Flutter SDK (`flutter --version` >= 3.9.0)
3. Dart SDK (`dart --version` >= 3.9.0)
4. Target Platform Dependencies:
   - For Android: Android Studio, Android SDK Build Tools (API 34/35), Android Emulator.
   - For iOS: macOS with Xcode 15+, CocoaPods.
   - For Web: Google Chrome or Microsoft Edge.
   - For Desktop: Visual Studio C++ toolchain (Windows) or Clang/CMake (Linux/macOS).

### 8.2 Local Development Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/dimasoktavianprasetyo/servisinaja-mobiledev-test.git
   cd servisinaja-mobiledev-test
   ```

2. **Verify Flutter Environment**:
   ```bash
   flutter doctor -v
   ```

3. **Install Package Dependencies**:
   ```bash
   flutter pub get
   ```

4. **Verify Static Code Analysis**:
   ```bash
   flutter analyze
   ```

### 8.3 Target Platform Execution

- **Run on Web (Chrome / Edge with DevicePreview)**:
  ```bash
  flutter run -d chrome
  # or
  flutter run -d edge
  ```

- **Run on Connected Android Device or Emulator**:
  ```bash
  flutter run -d android
  ```

- **Run on iOS Simulator (macOS only)**:
  ```bash
  flutter run -d ios
  ```

- **Run on Desktop (Windows)**:
  ```bash
  flutter run -d windows
  ```

### 8.4 Production Release Generation

- **Android APK (Release)**:
  ```bash
  flutter build apk --release --split-per-abi
  ```
  Output path: `build/app/outputs/flutter-apk/app-release.apk`

- **Android App Bundle (Google Play Store)**:
  ```bash
  flutter build appbundle --release
  ```
  Output path: `build/app/outputs/bundle/release/app-release.aab`

- **Web Production Bundle**:
  ```bash
  flutter build web --release --pwa-strategy=offline-first
  ```
  Output path: `build/web/`

- **Windows Desktop Executable**:
  ```bash
  flutter build windows --release
  ```
  Output path: `build/windows/runner/Release/`

---

## 9. Quality Assurance, Testing & Static Analysis

### 9.1 Static Code Analysis
The codebase is governed by `analysis_options.yaml` enforcing Flutter Lints rules:
```bash
flutter analyze
```
*Current Status: 0 errors, 0 warnings, 0 info lints.*

### 9.2 Automated Unit & Widget Tests
The test suite validates application mounting, navigation transitions, and controller state changes:
```bash
flutter test
```

### 9.3 Code Formatting Standards
To ensure consistent syntax across all contributions:
```bash
dart format --line-length 100 lib/ test/
```

---

## 10. Requirements Traceability Matrix

| Requirement | Implementation File | Verification Method |
|---|---|---|
| FR-01: Garage Management | `lib/presentation/screens/garasi/garasi_screen.dart` | Manual UI Test & Controller Unit Test |
| FR-02: Service Catalog | `lib/data/mock/mock_data.dart`, `booking_step1_screen.dart` | Widget Inspection |
| FR-03: Workshop Booking | `lib/presentation/screens/booking/schedule_picker_screen.dart` | Navigation Flow Test |
| FR-04: Digital Ticket | `lib/presentation/screens/booking/booking_success_ticket_screen.dart` | Pixel & Rendering Inspection |
| FR-05: Emergency Request | `lib/presentation/screens/emergency/emergency_request_screen.dart` | Tap Interaction & State Validation |
| FR-06: Radar Animation | `lib/presentation/screens/emergency/emergency_searching_screen.dart` | CustomPainter Frame Rate Test |
| FR-07: GPS Live Map | `lib/presentation/screens/emergency/emergency_tracking_screen.dart` | Trajectory Coordinate Alignment Test |
| FR-08: Docked Bottom Sheet | `lib/presentation/screens/emergency/emergency_tracking_screen.dart` | Vertical Gesture Drag Validation |
| FR-09: VoIP Call Screen | `lib/presentation/screens/call/call_montir_screen.dart` | Audio Timer & Mute State Test |
| FR-10: Live Chat Screen | `lib/presentation/screens/chat/chat_montir_screen.dart` | Message Thread & Auto-Reply Test |
| FR-11: Service Status Stepper | `lib/presentation/screens/status/status_servis_screen.dart` | Step Progression Verification |
| FR-12: Digital Service Book | `lib/presentation/screens/buku_servis/buku_servis_screen.dart` | Historical Log Verification |
| FR-13: Promo Vouchers | `lib/presentation/screens/promo/promo_screen.dart` | Clipboard Copy & Discount Math Test |
| FR-14: Notification Center | `lib/presentation/screens/notification/notification_screen.dart` | Realtime Alert Injection Test |
| FR-15: Profile & Security | `lib/presentation/screens/profile/` (all sub-screens) | Form Input & PIN Verification |

---

## 11. Maintenance, Contributions & Licensing

### Branching Strategy
- `main`: Production release branch. Only tagged releases are merged here.
- `dev`: Active integration branch. All feature branches must branch off and merge into `dev`.
- `feature/*`: Specific feature branches for new screens or services.

### Commit Standards
All commits must follow Conventional Commits standard:
- `feat(scope): description`
- `fix(scope): description`
- `docs(scope): description`
- `refactor(scope): description`
- `test(scope): description`

### Copyright & Ownership
Copyright 2026 Dimas Oktavian Prasetyo / ServisinAja Team. All rights reserved.
Unauthorized copying, modification, or distribution of this software is strictly prohibited.
