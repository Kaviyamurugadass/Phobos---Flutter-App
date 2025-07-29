# App Colors - Centralized Color Palette

This directory contains the centralized color palette for the Phobos Flutter app.

## Usage

### Import the colors
```dart
import '../constants/app_colors.dart';
```

### Available Colors

#### Primary Colors
- `AppColors.primary` - Main brand color (dark blue)
- `AppColors.gold` - Accent color (gold)

#### Secondary Colors
- `AppColors.secondary` - Secondary brand color
- `AppColors.accent` - Accent color

#### Status Colors
- `AppColors.active` - Green for active status
- `AppColors.away` - Yellow for away status
- `AppColors.offline` - Red for offline status

#### Background Colors
- `AppColors.background` - Main background color
- `AppColors.surface` - Surface color
- `AppColors.cardBackground` - Card background color

#### Text Colors
- `AppColors.textPrimary` - Primary text color
- `AppColors.textSecondary` - Secondary text color
- `AppColors.textLight` - Light text color

#### Border Colors
- `AppColors.border` - Border color
- `AppColors.borderLight` - Light border color

#### Error and Success Colors
- `AppColors.error` - Error color
- `AppColors.success` - Success color
- `AppColors.warning` - Warning color
- `AppColors.info` - Info color

### Helper Methods

#### Status Colors
```dart
// Get status color based on user status
Color statusColor = AppColors.getStatusColor(userStatus);

// Get status text based on user status
String statusText = AppColors.getStatusText(userStatus);
```

#### Gradients
```dart
// Primary gradient
Container(
  decoration: BoxDecoration(gradient: AppColors.primaryGradient),
)

// Gold gradient
Container(
  decoration: BoxDecoration(gradient: AppColors.goldGradient),
)
```

### Example Usage

```dart
import '../constants/app_colors.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Text(
        'Hello World',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
      ),
    );
  }
}
```

## Benefits

1. **Consistency**: All colors are defined in one place
2. **Maintainability**: Easy to update colors across the entire app
3. **Theme Support**: Colors can be easily adapted for dark/light themes
4. **Type Safety**: Compile-time checking for color usage
5. **Documentation**: Clear naming and organization of colors 