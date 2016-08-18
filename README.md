# PredicateEditor

PredicateEditor is a visual editor for creating and using NSPredicates for querying data in your app.

![Screenshot](http://i.imgur.com/m7PUa3el.png)

PredicateEditor was inspired by the implementation in [Workflow](http://workflow.is)

## Features
- Create filters for the following property types: `String`s, `NSDate`s, `NSNumber`s, `Int`s, `Float`s, and `Bool`s.
- Easily define the properties & keyPaths you'd like to be able to filter on.
- Filters can be added & deleted at will in the UI - The user can define as many filters as required.
- Input types are automatically updated to reflect the property type - Strings, Dates, Numbers etc
- Supports multiple sections of filters, each with its own compound predicate - AND or OR. Sections can again be clubbed together with other compound predicates.

## Installation

PredicateEditor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PredicateEditor"
```

## Requirements
- Requires Xcode 7.3 with Swift 2.2
- Deployment target of iOS 9+ (due to liberal use of UIStackViews)

**Please note that it's not possible to use this library in Obj-C code yet**

## Usage

#### Creating the editor
The first step in using the PredicateEditor is to create sections with the keyPaths you'd like to be made available for filtering.

Sections are created using one or more `KeyPathDescriptor`s. Each of these describe the property that is to be filtered on, and the keyPath to use while filtering.

In most cases, each section would correspond to a particular model in your app.

```swift
var keyPaths: [KeyPathDescriptor] = []

//Assuming you have a Person model with properties `name`, `age`, `dateOfBirth` & a Bool `isDeveloper`, create a descriptor for each of them.
let kp1 = KeyPathDescriptor(keyPath:"name", title: "Name", propertyType: .String)
let kp2 = KeyPathDescriptor(keyPath:"dateOfBirth", title: "Date Of Birth", propertyType: .Date)
let kp3 = KeyPathDescriptor(keyPath:"age", title: "Age", propertyType: .Int)
let kp4 = KeyPathDescriptor(keyPath:"isDeveloper", title: "Is a Developer", propertyType: .Boolean)
keyPaths = [kp1, kp2, kp3, kp4]

let section = Section(title: "Filter People", keyPaths: keyPaths)
```

Now you can create a PredicateEditor View Controller instance, and present it:

```swift
let predicateEditorVC = PredicateEditorViewController(sections: [section])
predicateEditorVC.delegate = self // Conform to PredicateEditorDelegate to receive callbacks.

// Wrap the editor in a nav controller in order to be able to dismiss it.
let nc = UINavigationController(rootViewController: predicateEditorVC)
nc.modalTransitionStyle = .CoverVertical
presentViewController(nc, animated: true, completion: nil)
```

#### Enumeration Options
Suppose the values of a particular property can be listed as an enumeration, and you'd like the user to be able to specify a value only from any of those options, you can additionally configure the descriptor:

```swift
let kp = KeyPathDescriptor(keyPath:"gender", title: "Gender", propertyType: .String)
kp.enumerationOptions = ["Male", "Female"]
```

#### Editor Configuration
Additionally create and pass a `PredicatedEditorConfig` object to the predicate editor during init.

```swift
var config = PredicatorEditorConfig()
config.backgroundColor = UIColor(white: 0.9, alpha: 1)
config.sectionBackgroundColor = UIColor(white: 0.95, alpha: 1)
...

let predicateEditor = PredicateEditorViewController(sections: [section], config: config)
```

#### Pre-defined Sections
By default, sections start out empty, and the user has to manually create new filters. However, if you'd like to present a pre-defined set of filters to the user, you can do so by creating and adding `Row`s to the section.

```swift
// For each filter you'd like to pre-define, create a Row with the descriptor, comparisonType and value.

let descriptor = KeyPathDescriptor(keyPath: "name", title: "Name", propertyType: KeyPathPropertyType.String)
let comparisonType: KeyPathComparisonType = .Contains
let value = "John"
if let row = Row(descriptor: descriptor, comparisonType: comparisonType, value: value){
  section.append(row)
}

let descriptor2 = KeyPathDescriptor(keyPath: "dob", title: "Date of Birth", propertyType: KeyPathPropertyType.Date)
let comparisonType2: KeyPathComparisonType = .IsAfter
let value2 = NSDate(timeIntervalSince1970: 321312311)
if let row2 = Row(descriptor: descriptor2, comparisonType: comparisonType2, value: value2){
  section.append(row2)
}
```

Note that the comparisonType & value have to be compatible with the descriptor's property type. For example, you should not create a filter with `IsGreaterThan` comparison, on a `String` property type. Doing so will lead to an  exception being thrown when creating the predicate.

#### Obtaining Predicates
Once the user finishes work in the predicate editor, and taps the done button, `predicateEditorDidFinishWithPredicates:` is called on the delegate object, along with an array of `NSPredicate`s - one for each section.

It's up to you to use these predicates any way you want - for instance, you can combine all of them into one compound predicate and filter a single model, or use each predicate on a separate model. In the example above, the resulting predicate would be used on the `Person` model.

```swift
let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
let filteredPeople = (people as NSArray).filteredArrayUsingPredicate(compoundPredicate) as! [Person]
```

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Todo:
- Add an In-Between comparison type.
- Add more configuration options.
- Add support for filtering array property types.

## Author

Arvindh Sukumar ([Github](https://www.github.com/arvindhsukumar))

## License

PredicateEditor is available under the MIT license. See the LICENSE file for more info.
