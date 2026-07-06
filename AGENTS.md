# Tripmate
Mobile-first trip-planning app for backpackers (Flutter). Currently a mock-data UI prototype — no backend or state-management lib yet.

## Setup & commands
```bash
flutter pub get
flutter run
flutter build apk     # Android release
flutter build ios     # iOS release
flutter analyze
```
No codegen (build_runner). No tests yet.

## Stack
- **Dart SDK:** ^3.10.8, **Flutter:** Material 3 (`useMaterial3: true`)
- **Packages:** google_fonts (Inter + JetBrains Mono), cupertino_icons
- **Routing:** manual enum-based in `AppShell` (no go_router / Navigator 2.0)
- **State:** `StatefulWidget` + `setState` only (no Provider/Riverpod/BLoC)

## Conventions
- Layer-first structure: `lib/screens`, `lib/widgets`, `lib/theme`, `lib/data`
- Design tokens centralized in `lib/theme/tokens.dart` (`TmColors`, `TmPalette`, `TmType`, `TmRadius`, `TmDur`)
- Light/dark via `TmPalette.of(context)`; `ColorScheme.fromSeed(violet500)`
- Screens are isolated `StatefulWidget`s that receive callbacks (`onOpen`, `onBack`, `onSwitchTab`) — no InheritedWidget
- Category enum `TmCategory` (stay/eat/doActivity/go/see) with icons in the `tmCategories` map
- Mock data in `lib/data/mock.dart`

## Gotchas / do-not-touch
- All navigation is an enum-switch in `AppShell._renderRoute()` — adding a screen means editing there **and** the `_Route` enum.
- Theme toggle lives in top-level `_TripmateAppState` via setState; not persisted yet.
- If you add freezed/json_serializable, you must add build_runner codegen to `pubspec.yaml` first.
- Material 3 only, no M2 fallback; `splashFactory: InkSparkle`.
- `android/`, `ios/` are standard config with no custom native code.

## Rules (team defaults, adjust as needed)
- Branch off `main`; don't push directly to `main` for non-trivial changes.
- Run `flutter analyze` before committing — keep it clean (zero warnings).
- Still a prototype: no tests required yet. When real logic (not just UI) lands, add widget/unit tests for it.
- Never commit secrets or generated build output (`build/`, `.dart_tool/`).
