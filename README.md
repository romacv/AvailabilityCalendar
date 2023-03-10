# AvailabilityCalendar

  AvailabilityCalendar - wonderful, lightweight and highly customizable calendar solution with the ability to specify availability/unavailability of dates. The component is written in SwiftUI, but you can easily represent it in UIKit as well.

<img src="/demo.jpg" width="320" />

### Cocoapods
AvailabilityCalendar is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AvailabilityCalendar'
```

### Swift Package Manager

1. File > Swift Packages > Add Package Dependency
2. Add `https://github.com/romacv/AvailabilityCalendar.git`

_OR_

Update `dependencies` in `Package.swift`
```swift
dependencies: [
    .package(url: "https://github.com/romacv/AvailabilityCalendar.git", .upToNextMajor(from: "1.0.0"))
]
```
## Usage
Import the module
```swift
import AvailabilityCalendar
```
Declare properties for manager
```swift
let disabledDates = [Date().addingTimeInterval(86400 * 3),
                     Date().addingTimeInterval(86400 * 5),
                     Date().addingTimeInterval(86400 * 10)] // Not available dates - for example 3, 5, 10 days ahead
let minimumDate = Date() // Minimum today
let maximumDate = Date().addingTimeInterval(86400 * 365) // Year ahead
let selectedDate = Date() // Optional, can be nil
let uiColorSheme = AppStyle.shared.color // App color
```
Create manager instance

```swift
let manager = CalendarManager(minimumDate: minimumDate,
                              maximumDate: maximumDate,
                              disabledDates: disabledDates,
                              selectedDate: selectedDate,
                              uiColorSheme: uiColorSheme)
// Properties for View
let titleText = "Calendar"
let rightButtonText = "Deselect all"
let doneButtonText = "Done"
```

### SwiftUI integraion example
```swift
struct ContentView: View {
    var body: some View {
        return CalendarView(titleText: titleText,
                            rightButtonText: rightButtonText,
                            doneButtonText: doneButtonText,
                            manager: manager,
                            dateSelected: { dateSelected in
                if let dateSelected = dateSelected {
                    print(dateSelected)
                }
                else {
                    print("No selected date")
                }
            })
    }
}
```

### UIKit integration example
Import SwiftUI for using UIHostingController
```swift
import SwiftUI
```
Create SwiftUI View
```swift
let swiftUIView = CalendarView(titleText: titleText,
                               rightButtonText: rightButtonText,
                               doneButtonText: doneButtonText,
                               manager: manager,
                               dateSelected: { dateSelected in
        self.dismiss(animated: true)
        if let dateSelected = dateSelected {
           print(dateSelected)
        }
        else {
           print("No selected date")
        }
})
// Create UIViewController
let calendarViewController = UIHostingController(rootView: swiftUIView)
self.present(calendarViewController, animated: true)
```

Enjoy!
