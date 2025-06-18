## Introudction

Lorene's workspace, iOS

Features

- Allowance
- Charts
- About em

## Issue

1. **Sheet Parameter Binding Issue**: When opening education edit sheet for the first time, `editingEntry` parameter receives `nil` instead of the selected education item, causing empty form. Works correctly on subsequent attempts.

2. **SwipeActions in List within ScrollView**: Initial implementation had gesture conflicts between ScrollView scrolling and List swipe actions. Resolved by using proper List configuration with `.listStyle(.plain)` and `.scrollDisabled(true)`.

3. **Layout Alignment**: Education history items had inconsistent left margin compared to Basic Information section due to List's default `listRowInsets`. Fixed with `.listRowInsets(EdgeInsets())`.

## Appendix

Ignore the entire xcodeproj/ directory in git, as it exposes usernames and developer team IDs.
