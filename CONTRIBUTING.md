# Contributing

## Import Order

Keep imports grouped and ordered as follows:

1. System frameworks (e.g., `Foundation`, `SwiftUI`, `UIKit`, `SwiftData`)
2. Third-party frameworks (SPM/CocoaPods/Carthage)
3. Resource frameworks (e.g., `RswiftResources`)
4. `@testable` imports

Rules:
- Separate groups with a single blank line.
- Sort imports alphabetically within each group.

Example:

```swift
import Foundation
import SwiftUI

import Alamofire

import RswiftResources

@testable import Mingdalart
```
