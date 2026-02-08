# ClaudeAgentConfig

Configuration and skills for the Xcode 26 integrated Claude agent.

## Setup

The Xcode agent reads config from:

```
~/Library/Developer/Xcode/CodingAssistant/ClaudeAgentConfig/
```

This repo provides `CLAUDE.md` (agent instructions) and `skills/` (reference material) via symlinks:

```bash
ln -s ~/Repos/ClaudeAgentConfig/xcode-agent/CLAUDE.md \
      ~/Library/Developer/Xcode/CodingAssistant/ClaudeAgentConfig/CLAUDE.md

ln -s ~/Repos/ClaudeAgentConfig/xcode-agent/skills \
      ~/Library/Developer/Xcode/CodingAssistant/ClaudeAgentConfig/skills
```

Everything else in the Xcode path (`.claude.json`, `debug/`, session data) is Xcode-managed and stays out of version control.

## Installed Skills

| Skill | Source | Description |
|-------|--------|-------------|
| `swift-conventions` | Custom | Swift/SwiftUI/SwiftData standards + Foundation Models API |
| `swiftui-expert-skill` | [AvdLee/SwiftUI-Agent-Skill](https://github.com/AvdLee/SwiftUI-Agent-Skill) | State, animations, performance, layout, Liquid Glass |
| `swift-concurrency` | [AvdLee/Swift-Concurrency-Agent-Skill](https://github.com/AvdLee/Swift-Concurrency-Agent-Skill) | Async/await, actors, sendable, tasks, migration |
| `axiom-swiftui-debugging` | [CharlesWiltgen/Axiom](https://github.com/CharlesWiltgen/Axiom) | Decision trees for view updates, preview crashes, layout |
| `axiom-swiftui-26-ref` | CharlesWiltgen/Axiom | iOS 26 features: Liquid Glass, WebView, rich text, @Animatable |
| `axiom-swift-testing` | CharlesWiltgen/Axiom | Swift Testing: @Test/@Suite, #expect/#require, parameterized tests |
| `axiom-accessibility-diag` | CharlesWiltgen/Axiom | VoiceOver, Dynamic Type, contrast, touch targets, keyboard nav |
| `axiom-foundation-models-ref` | CharlesWiltgen/Axiom | LanguageModelSession, @Generable, @Guide, Tool protocol, streaming |
| `axiom-swiftdata` | CharlesWiltgen/Axiom | @Model, @Query, @Relationship, CloudKit, migration, performance |
