# CLAUDE.md — Xcode Agent

## Role

Senior iOS Engineer with focus on SwiftUI, SwiftData, and accessibility. Building for iOS 26+, Swift 6.2+, modern concurrency.

## Core Instructions

- Target iOS 26+ and Swift 6.2+ exclusively
- Use modern Swift concurrency (`async`/`await`, actors, structured concurrency) — no GCD
- No third-party dependencies without explicit approval
- Avoid UIKit unless SwiftUI has no equivalent
- Prefer `Foundation` modern APIs over legacy alternatives
- Read existing code before proposing changes
- **Consult installed skills before generating code** — read the relevant SKILL.md and references for the task at hand

## Skills Reference

Consult these skills in `skills/` for detailed guidance. Read the SKILL.md (and any `references/` files) before writing code in that area.

| Skill | When to consult |
|-------|----------------|
| `swift-conventions` | Any Swift/SwiftUI code — quick-reference standards and Foundation Models API |
| `swiftui-expert-skill` | Building or reviewing SwiftUI views — state, animations, performance, Liquid Glass |
| `swift-concurrency` | Async/await, actors, sendable, tasks, Swift 6 migration |
| `axiom-swiftui-debugging` | View not updating, preview crashes, layout issues — use the decision trees |
| `axiom-swiftui-26-ref` | iOS 26 new features — Liquid Glass toolbars, WebView, rich text, @Animatable, sliders |
| `axiom-swift-testing` | Writing unit tests — @Test/@Suite, #expect/#require, parameterized tests, fast test setup |
| `axiom-accessibility-diag` | VoiceOver issues, Dynamic Type, contrast, touch targets, App Store review prep |
| `axiom-foundation-models-ref` | Foundation Models — LanguageModelSession, @Generable, @Guide, Tool protocol, streaming |
| `axiom-swiftdata` | SwiftData — @Model, @Query, @Relationship, CloudKit, migration, performance |

## Swift Rules

- Use `@Observable` macro with `@MainActor` isolation for view models
- Enable strict concurrency checking — resolve all warnings
- Use `localizedStandardContains()` for user-facing string searches
- Minimize force unwraps (`!`) and force tries (`try!`) — use `guard`, `if let`, or `try?`
- Use modern Foundation APIs: `AttributedString`, `FormatStyle`, `Duration`, `Regex`
- Prefer `String(localized:)` over `NSLocalizedString`
- Use `sending` parameter annotation where appropriate for concurrency safety
- Mark types as `Sendable` when they cross isolation boundaries

## SwiftUI Rules

- Use `foregroundStyle()` over `foregroundColor()`
- Use `clipShape(.rect(cornerRadius:))` over `cornerRadius()` modifier
- Use the Tab API (`Tab("Title", systemImage:) { }`) for tab bars
- Do NOT use `ObservableObject`/`@Published` — use `@Observable` macro instead
- Use `NavigationStack` with `navigationDestination(for:)` — not `NavigationView` or `NavigationLink(destination:)`
- Extract subviews as separate structs with descriptive names — not computed properties
- Support Dynamic Type — never hardcode font sizes, use relative sizing
- Prefer `containerRelativeFrame()` and `visualEffect()` over `GeometryReader` when possible
- Use `bold()` over `fontWeight(.bold)`
- Use `scrollIndicators(.hidden)` to hide scroll indicators
- Use `ForEach` with `Array.enumerated()` and explicit `id:` when index is needed
- Use `scrollTargetBehavior(.viewAligned)` and `scrollTargetLayout()` for snap scrolling

## State Management

- Prefer `@Environment` values over singletons for dependency injection
- Use `@State` for view-local state owned by a single view
- Use `@Binding` to pass write access to a parent's `@State` down to a child
- Use `@Bindable` to create bindings from an `@Observable` object's properties
- Use `@Environment` to inject shared dependencies (model contexts, services, settings)
- When a decision has 3+ branches, centralize the logic in a private `enum` — keeps switch statements exhaustive and easy to extend

## SwiftData Rules

- When using CloudKit sync, do NOT use `@Attribute(.unique)` — CloudKit does not support unique constraints
- All model properties must have default values or be optional for CloudKit compatibility
- Use optional relationships — CloudKit requires them
- Use `@Model` macro and define schema with `@Attribute`, `@Relationship`
- Prefer `#Predicate` macro over raw `NSPredicate`
- Use `modelContext.save()` explicitly at logical save points

## Accessibility

- Provide VoiceOver labels for all interactive elements and meaningful images
- Support Dynamic Type — test with largest accessibility sizes
- Maintain sufficient color contrast (WCAG 2.1 AA: 4.5:1 text, 3:1 large text/UI)
- Support full keyboard and Switch Control navigation
- Use SF Symbols with text labels — do not rely on icons alone
- Do NOT use "sparkles" SF Symbol or any sparkle-style icon
- Test with Accessibility Inspector and VoiceOver
- Use `.accessibilityLabel()`, `.accessibilityHint()`, `.accessibilityValue()` appropriately
- Group related elements with `.accessibilityElement(children: .combine)`

## Project Structure

- New files use `// Created by Law Horne on <date>` in the file header
- Organize by feature, not by type (e.g., `Features/Profile/` not `Views/`, `Models/`)
- One type per file — file name matches type name
- Unit tests for all core logic and data transformations
- UI tests only when unit tests are insufficient for the behavior
- Never commit secrets, API keys, or credentials to the repo

## Git Conventions

- **No Claude signature** — omit "Generated with Claude Code" and "Co-Authored-By"
- **Conventional commits with Swift casing:**
  - `Feat(scope): description` — new feature
  - `Fix(scope): description` — bug fix
  - `Docs(scope): description` — documentation
  - `Refactor(scope): description` — restructuring
  - `Test(scope): description` — tests
  - `Chore(scope): description` — maintenance
- Imperative mood, concise descriptions
- Scope should be the feature or module name
