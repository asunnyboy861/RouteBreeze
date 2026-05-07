# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: RouteBreeze Premium
- **Group ID**: 21594947

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: Monthly Premium
- **Product ID**: `com.zzoutuo.RouteBreeze.monthly`
- **Price**: $4.99 per month
- **Display Name**: RouteBreeze Pro Monthly
- **Description**: Unlimited stops, route templates, priority
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: Yearly Premium
- **Product ID**: `com.zzoutuo.RouteBreeze.yearly`
- **Price**: $29.99 per year (50% savings vs monthly)
- **Display Name**: RouteBreeze Pro Yearly
- **Description**: Unlimited stops, route templates, priority
- **Localization**: English (US)

### 3. Lifetime Purchase
- **Reference Name**: Lifetime Access
- **Product ID**: `com.zzoutuo.RouteBreeze.lifetime`
- **Price**: $59.99 one-time
- **Display Name**: RouteBreeze Lifetime
- **Description**: Pay once, use forever. All Pro features
- **Note**: No ongoing server costs — local algorithm only

## Free Tier vs Pro Tier

| Feature | Free | Pro |
|---------|------|-----|
| Stops per route | 15 | Unlimited |
| Route optimization | ✅ | ✅ |
| Save routes | 3 routes | Unlimited |
| Route templates | ❌ | ✅ |
| Service duration per stop | ❌ | ✅ |
| Priority stops | ❌ | ✅ |
| One-tap navigation | ✅ | ✅ |
| Offline optimization | ✅ | ✅ |
| Apple/Google/Waze nav | ✅ | ✅ |

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial (auto-converts to monthly)

## Policy Pages Required
- Support Page: ✅ (Must include subscription management info)
- Privacy Policy: ✅
- Terms of Use: ✅ (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included (if applicable)
- [ ] Restore purchases functionality implemented
