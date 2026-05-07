# RouteBreeze - iOS Development Guide

## Executive Summary

**RouteBreeze** is a smart route planning and optimization app built for solo operators and small teams in service-based businesses — lawn care, cleaning, delivery, repair, and real estate. Unlike enterprise-grade competitors that cost $10–$349/month and require training, RouteBreeze delivers the simplest route optimization experience: enter addresses, tap optimize, navigate. Built natively with SwiftUI and MapKit, it runs entirely offline with no third-party dependencies, ensuring privacy and reliability.

**Target Audience**: 12.5M+ independent service providers in the US who visit 5–50 locations daily and waste 1–2 hours manually planning routes.

**Key Differentiators**:
- Simplest UX: 30-second first route optimization, zero learning curve
- Lowest price: Free tier with 15 stops + Pro at $4.99/month
- Offline-first: Local TSP + 2-opt algorithm works without internet
- One-tap navigation: Jump directly to Apple Maps, Google Maps, or Waze
- Route reuse: Save, duplicate, and adjust historical routes

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Route4Me | Established brand, 40K+ users, voice navigation, barcode scanning | Expensive ($9.99–$349/mo), 10-stop free limit, 7-day route expiry, ads, cluttered UI | 15-stop free limit, no expiry, $4.99/mo Pro, clean simple UI |
| Circuit | Easy-to-use, proof-of-delivery, 500 stops | 5-stop free limit, $20/mo paid, limited features on free | 15-stop free, full optimization on free tier, 3x cheaper Pro |
| RoadWarrior | 500+ stops, real-time traffic, FedEx integration | Frequent crashes, address errors, poor customer support, 8-stop free limit | Stable native app, accurate geocoding, 15-stop free, responsive design |
| Droppath | Up to 500 stops, barcode scan, CSV import, no account required | No team features, limited on free (25 stops), no service duration | Service duration per stop, route templates, simpler UX |
| PlaceMaker | 500 stops, 4.8 rating, text/barcode scanning | $4.99–$14.99/mo, complex UI, no HIG compliance | HIG-compliant design, service duration, priority stops, route templates |

## Apple Design Guidelines Compliance

- **Maps**: Use MapKit with standard emphasis style; interactive zoom/pan/rotate; numbered annotations for stops; blue polyline for route path; clustering for overlapping stops
- **Navigation**: Tab-based navigation with 4 tabs (Routes, Map, Add Stop, Settings); large title navigation bars; hierarchical push navigation for detail views
- **Touch Targets**: All interactive elements minimum 44x44pt; prominent Optimize button; swipe actions for stop management
- **Typography**: SF Pro system font; 17pt body text; 34pt large titles; Dynamic Type support
- **Color**: System blue for primary actions; system green for completed stops; system red for high priority; semantic colors for dark mode support
- **Feedback**: Haptic feedback on optimization complete; progress indicators during geocoding; success/error alerts
- **Accessibility**: VoiceOver labels on all map annotations; Dynamic Type throughout; high contrast support; reduce motion option
- **Sheets**: Add stop and edit stop use half-height sheets; settings uses full-height sheet on iPhone
- **iPad**: Side-by-side layout with route list and map; max content width 720pt in scroll views

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), MapKit, CoreLocation
- **Data**: SwiftData with @Model classes (Stop, Route)
- **Algorithms**: Nearest Neighbor + 2-opt local search (offline, no server)
- **Geocoding**: CLGeocoder (Apple native, no API key needed)
- **Navigation**: MKMapItem deep links to Apple Maps; URL schemes for Google Maps and Waze
- **IAP**: StoreKit 2 for subscription management
- **Minimum Deployment**: iOS 17.0
- **Third-party Dependencies**: None

## Module Structure

```
RouteBreeze/
├── RouteBreezeApp.swift
├── Models/
│   ├── Stop.swift
│   └── Route.swift
├── Services/
│   ├── RouteOptimizer.swift
│   ├── GeocodingService.swift
│   ├── NavigationService.swift
│   └── PurchaseManager.swift
├── Views/
│   ├── RouteListView.swift
│   ├── RouteMapView.swift
│   ├── AddStopView.swift
│   ├── EditStopView.swift
│   ├── SettingsView.swift
│   ├── ContactSupportView.swift
│   └── PaywallView.swift
├── Algorithms/
│   ├── NearestNeighbor.swift
│   └── TwoOptOptimizer.swift
└── Resources/
    └── Assets.xcassets
```

## Implementation Flow

1. Create SwiftData models (Stop, Route) with all attributes and relationships
2. Implement RouteOptimizer with Nearest Neighbor + 2-opt algorithm
3. Implement GeocodingService using CLGeocoder
4. Implement NavigationService with deep links to Apple/Google/Waze
5. Build RouteListView with CRUD operations and swipe actions
6. Build RouteMapView with MapKit annotations and polyline
7. Build AddStopView with address search and geocoding
8. Build EditStopView for stop details, priority, duration
9. Build SettingsView with policy links and preferences
10. Implement PurchaseManager with StoreKit 2
11. Build PaywallView for subscription upgrade
12. Build ContactSupportView with feedback backend
13. Integrate all views in RouteBreezeApp with TabView
14. Test on iPhone XS Max and iPad Pro 13-inch simulators
15. Push to GitHub and deploy policy pages

## UI/UX Design Specifications

- **Color Scheme**: Primary blue (#007AFF), secondary green (#34C759), accent orange (#FF9500), background system grouped
- **Typography**: SF Pro, large titles 34pt bold, headings 22pt semibold, body 17pt regular, captions 12pt
- **Layout**: 4-tab interface (Routes, Map, Add, Settings); card-based route list; full-screen map; modal sheets for add/edit
- **Animations**: Smooth route optimization animation; stop completion checkmark; map camera transition on stop selection
- **Dark Mode**: Full support using semantic system colors
- **iPad**: Split view with route list sidebar + map detail; popover for add stop on iPad

## Code Generation Rules

- Architecture: MVVM + SwiftData; Views only handle UI; Services handle business logic
- Concurrency: async/await + Actor; GeocodingService uses Actor isolation
- Error Handling: Swift Error enums; no force unwraps; no try!
- Naming: American English; PascalCase for types; camelCase for methods/properties
- Minimum Deployment: iOS 17.0; use SwiftData and new MapKit API
- No Third-Party Dependencies: Core functionality uses only Apple native frameworks
- Privacy First: All data stored locally; no user location history collected
- Accessibility: All UI elements support VoiceOver and Dynamic Type
- No comments in code unless explicitly requested

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.RouteBreeze
2. Verify Deployment Target: iOS 17.0
3. Verify App Icon in Asset Catalog
4. Build on iPhone simulator — must succeed
5. Build on iPad simulator — must succeed
6. Run on iPhone XS Max simulator — verify all features
7. Run on iPad Pro 13-inch simulator — verify layout
8. Push to GitHub repository RouteBreeze
9. Deploy policy pages to GitHub Pages
10. Create App Store Connect metadata (keytext.md)
