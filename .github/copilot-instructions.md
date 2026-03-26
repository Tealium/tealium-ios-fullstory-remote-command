# Tealium iOS Remote Command — Code Review Standards

## What Is a Remote Command

A Remote Command is a Tealium SDK feature that lets a single `track()` call trigger native vendor SDK code (Firebase, Braze, Adjust, FullStory, etc.) without hardcoding vendor logic in the tracking layer. The flow:

1. App sends a standard Tealium track with a Data Layer payload.
2. A JSON config or iQ Tag maps events/fields to vendor commands (e.g. `logevent`, `identify`).
3. The native Remote Command module receives the payload and calls vendor SDK methods.

## Architecture — Three Layers (+ optional vendor extensions)

Every iOS Remote Command repo follows this structure:

```
Sources/
  XxxConstants.swift        — command name strings, payload key strings, separator, version
  XxxInstance.swift         — protocol XxxCommand + class XxxInstance (thin vendor SDK wrapper)
  XxxRemoteCommand.swift    — RemoteCommand subclass, parses payload, calls XxxCommand methods
  VendorType+String.swift   — (optional) failable String initializer for vendor SDK enums
Tests/
  MockXxxInstance.swift     — XxxCommand mock with call counters
  XxxRemoteCommandTests.swift
```

The optional `VendorType+String.swift` file is needed when a vendor SDK enum must be constructed from a payload string (e.g. `FSEventLogLevel`). Place the failable `init?(_ string: String)` extension there — keep the mapping close to the vendor type, out of RemoteCommand or Instance.

**Constants** — single source of truth for all string literals. No raw strings anywhere else.

**Protocol + Instance split** — `XxxCommand` protocol allows injecting `MockXxxInstance` in tests without linking the real vendor SDK. `XxxInstance` is the only class that makes direct calls into the vendor SDK; other files may import the vendor framework only for type/enum declarations or string-to-enum mappings (e.g. `VendorType+String.swift`), and must not invoke vendor SDK methods.

**RemoteCommand subclass** — owns `weak var weakSelf` trick in `super.init` closure to avoid retain cycle. Splits `command_name` on `FullstoryConstants.separator` (comma), trims whitespace from each token, dispatches via `switch`.

## Command Dispatch

Use `enum Commands: String` + `compactMap` (the only pattern used in this repo):

```swift
enum Commands: String {
    case logEvent = "logevent"
}
// dispatch:
commands
    .compactMap { Commands(rawValue: $0.lowercased()) }
    .forEach { command in
        switch command { ... }   // exhaustive — compiler error on missing cases
    }
```

Unknown commands are dropped silently via `compactMap`. The exhaustive `switch` ensures every case is handled — no `default` needed.

## Known Footguns — Must Catch

**Multi-command payload** — `command_name` can be comma-separated (`"logevent,identify"`). Every implementation must split on the separator and iterate. A direct equality check on the raw string silently drops all but one command.

```swift
// Wrong — only handles single command
if payload["command_name"] as? String == "logevent" { ... }

// Correct
let commands = command.split(separator: Constants.separator)
    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
commands.forEach { switch $0 { ... } }
```

**Silent skip on missing required key** — when a required payload key is absent, skip this command silently. Never call the vendor SDK with a nil/default value as a substitute.

Inside the `forEach` closure, use `return` to exit the current iteration (not `break`):

```swift
// Wrong — calls vendor with empty string
let uid = payload["uid"] as? String ?? ""
instance.identify(uid)

// Correct — guard + return skips this command
case .identify:
    guard let uid = payload["uid"] as? String else { 
        return 
    }
    instance.identifyUser(id: uid)
```

**SPM vs CocoaPods import guard** — every file importing TealiumSwift must use the conditional:

```swift
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif
```

Missing this breaks one of the two distribution channels.

**Vendor SDK not wrapped by protocol** — vendor SDK calls must only appear inside `XxxInstance`, never directly in `XxxRemoteCommand`. This is what makes the protocol/instance split valuable: tests run without the vendor SDK linked.

The one permitted exception: type conversion using vendor SDK enum extensions (e.g. `FSEventLogLevel(level) != nil`). It is acceptable to validate a payload string against a vendor type in `XxxRemoteCommand` when the validation determines whether to call the instance at all — but the actual SDK call must still go through the instance.

## Testing Standards

Every command must have three test cases:

| Test | What it verifies |
|---|---|
| Happy path | Mock call counter == 1, correct arguments captured |
| Missing required key | Mock call counter == 0 (command silently skipped) |
| Multi-command payload | Both commands fire (`"cmd1,cmd2"` in `command_name`) |

The multi-command test is commonly missing — always verify it exists before marking a command complete:

```swift
func testMultiCommand() {
    let payload: [String: Any] = [
        "command_name": "identify,setuservariables",
        "uid": "abc",
        "user_variables": ["key": "val"]
    ]
    fullstoryCommand.processRemoteCommand(with: payload)
    XCTAssertEqual(1, fullstoryInstance.identifyUserCount)
    XCTAssertEqual(1, fullstoryInstance.setUserDataCount)
}
```

Mock pattern — counters + captured arguments:

```swift
class MockXxxInstance: XxxCommand {
    var logEventCount = 0
    var lastEventName: String?

    func logEvent(name: String) {
        logEventCount += 1
        lastEventName = name
    }
}
```

Never assert on vendor SDK state directly — always assert on mock counters/captured values.

## Distribution Checklist

This repo ships via three channels. All three must stay in sync on every release:

| Channel | File | What to update |
|---|---|---|
| CocoaPods | `XxxRemoteCommand.podspec` | `s.version`, `s.dependency 'VendorSDK', '~> X.Y'` |
| SPM | `Package.swift` | `.upToNextMajor(from: "X.Y.Z")` for vendor + tealium-swift |
| Carthage | `Xxx.json` + `Cartfile` | binary URL pointing to new release `.zip` |

The vendor SDK must be declared as a CocoaPods `dependency`, not a `vendored_frameworks`. Vendoring binaries in the repo bloats history and creates manual update toil.

## Payload Key Conventions

All payload keys are `snake_case` strings defined in `XxxConstants`. Standard keys shared across all remote commands:

| Key | Type | Purpose |
|---|---|---|
| `command_name` | `String` | Comma-separated list of commands to execute |

Vendor-specific keys must be namespaced to avoid collisions in multi-command payloads (e.g. `event_name`, `user_variables`, not just `name`).
