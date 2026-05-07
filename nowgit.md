# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | RouteBreeze |
| **Git URL** | git@github.com:asunnyboy861/RouteBreeze.git |
| **Repo URL** | https://github.com/asunnyboy861/RouteBreeze |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | Enabled (from /docs folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/RouteBreeze/ | Active |
| Support | https://asunnyboy861.github.io/RouteBreeze/support.html | Active |
| Privacy Policy | https://asunnyboy861.github.io/RouteBreeze/privacy.html | Active |
| Terms of Use | https://asunnyboy861.github.io/RouteBreeze/terms.html | Active |

Note: Terms of Use required for IAP subscription apps.

## Repository Structure

```
RouteBreeze/
├── RouteBreeze/                       # iOS App Source Code
│   ├── RouteBreeze.xcodeproj/         # Xcode Project
│   └── RouteBreeze/                   # Swift Source Files
│       ├── Views/
│       │   ├── RouteListView.swift
│       │   ├── RouteMapView.swift
│       │   ├── AddStopView.swift
│       │   ├── EditStopView.swift
│       │   ├── SettingsView.swift
│       │   ├── PaywallView.swift
│       │   └── ContactSupportView.swift
│       ├── Models/
│       │   ├── Stop.swift
│       │   └── Route.swift
│       ├── Services/
│       │   ├── RouteOptimizer.swift
│       │   ├── GeocodingService.swift
│       │   ├── NavigationService.swift
│       │   └── PurchaseManager.swift
│       ├── Assets.xcassets/
│       ├── RouteBreezeApp.swift
│       └── ContentView.swift
├── docs/                              # Policy Pages (GitHub Pages source)
│   ├── landing.html                   # Landing Page
│   ├── support.html                   # Support Page
│   ├── privacy.html                   # Privacy Policy
│   └── terms.html                     # Terms of Use
├── .github/workflows/
│   └── deploy.yml                     # GitHub Pages deployment
├── us.md                              # English Development Guide
├── keytext.md                         # App Store Metadata
├── capabilities.md                    # Capabilities Configuration
├── icon.md                            # App Icon Details
├── price.md                           # Pricing Configuration
└── nowgit.md                          # This File
```
