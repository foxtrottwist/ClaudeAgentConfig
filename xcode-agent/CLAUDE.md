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
- Use typed throws (`async throws(MyError)`) for functions with predictable failure modes — avoid `Result` types with async/await
- Use modern Foundation APIs: `AttributedString`, `FormatStyle`, `Duration`, `Regex`
- Prefer `String(localized:)` over `NSLocalizedString`
- Use `sending` parameter annotation where appropriate for concurrency safety
- Mark types as `Sendable` when they cross isolation boundaries
- `os.Logger` string interpolation — see Logging section for details

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
- Use `ForEach(items.enumerated(), id: \.element.id)` when index is needed — do not wrap in `Array()`
- Use `scrollTargetBehavior(.viewAligned)` and `scrollTargetLayout()` for snap scrolling
- `Section("Title") { } footer: { }` doesn't compile — use `Section { } header: { Text("Title") } footer: { }` when both header and footer are needed

## State Management

- Prefer `@Environment` values over singletons for dependency injection
- Use `@State` for view-local state owned by a single view
- Use `@Binding` to pass write access to a parent's `@State` down to a child
- Use `@Bindable` to create bindings from an `@Observable` object's properties
- Use `@Environment` to inject shared dependencies (model contexts, services, settings)
- When a decision has 3+ branches, centralize the logic in a private `enum` — keeps switch statements exhaustive and easy to extend

## Logging

Use `os.Logger` exclusively — no `print()` or `NSLog()`. Centralize categories in a `Logger` extension file with `static nonisolated let` properties.

- **Setup:** Each file declares `private nonisolated let log = Logger.<category>` at file scope
- **Categories:** One per service/feature area — add new ones to the centralized Logger extension

**Log levels:**
- `debug` — verbose events useful only when investigating (button taps, view show/hide)
- `info` — operational milestones and timing (service started, operation completed)
- `warning` — recoverable issues or fallbacks taken (unsupported config, retry needed)
- `error` — failures that stop an operation (permission denied, resource unavailable)
- `fault` — system-level corruption only

**When to log:**
- Service entry/exit points and state transitions
- Timing-sensitive paths — include elapsed ms where performance matters
- Error/failure branches — always log before throwing or returning early
- Hardware/device changes and retry attempts

**Gotchas:**
- `os.Logger` interpolation evaluates in a closure context — `@Observable` properties need explicit `self.` (e.g., `log.info("value: \(self.someProperty)")`)
- File-scope `private let log = Logger(...)` inherits MainActor isolation when `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` — use `private nonisolated let` to opt out

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

## Build & Test

Xcode MCP server is connected. Prefer MCP tools over CLI commands.

- **Build:** `BuildProject` via Xcode MCP (fallback: `xcodebuild -scheme <Scheme> -destination 'platform=macOS'`)
- **Run all tests:** `RunAllTests` via Xcode MCP
- **Run specific tests:** `RunSomeTests` via Xcode MCP with test identifiers (e.g., `<TestTarget>/<Suite>/<testName>`)
- **Get build errors:** `GetBuildLog` with severity filter after a failed build
- **List test targets:** `GetTestList` via Xcode MCP

## Project Structure

- New files use the full Xcode file header template:
  ```swift
  //
  //  FileName.swift
  //  ProjectName
  //
  //  Created by Law Horne on M/d/yy.
  //
  ```
- Organize by feature, not by type (e.g., `Features/Profile/` not `Views/`, `Models/`)
- One type per file — file name matches type name
- Unit tests for all core logic and data transformations
- UI tests only when unit tests are insufficient for the behavior
- Test files: `FooTests.swift` for `Foo.swift`, use `@Suite struct` and `@Test func` (no `test` prefix)
- Use `#Preview { }` macro for all previews — provide dependencies via `.environment()` or `.modelContainer()`
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
