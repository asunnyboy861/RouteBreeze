# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- "地图" / "map" / "定位" / "location" → Location Services required for map display and geocoding
- "导航" / "navigation" → Deep links to Apple Maps/Google Maps/Waze (no special capability needed)
- "离线" / "offline" → Local-only storage, no iCloud needed
- "订阅" / "会员" / "premium" / "Pro" → In-App Purchase required
- No camera, health, push notifications, or other special capabilities detected

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| In-App Purchase | ✅ Configured | Xcode UI (StoreKit 2) |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| Location Services (When In Use) | ⏳ Pending | 1. Open Xcode → RouteBreeze target → Signing & Capabilities → + Capability → Location When In Use 2. Add NSLocationWhenInUseUsageDescription to Info.plist: "RouteBreeze uses your location to set as route start point and show your position on the map." 3. No entitlements file change needed for When In Use |

## No Configuration Needed
- iCloud / CloudKit: All data stored locally with SwiftData
- Push Notifications: Not required for route optimization
- HealthKit: Not applicable
- Camera / Photo Library: Not required
- Apple Watch: Not in scope
- Siri: Not in scope
- Background Modes: Not required
- Sign in with Apple: Not required

## Verification
- Build succeeded after configuration: ⏳ Pending (will verify after code generation)
- All entitlements correct: ⏳ Pending
