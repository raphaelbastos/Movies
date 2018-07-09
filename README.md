# Movies

Project that pulls content from The Movie Database and shows the user in a friendly manner, following iOS 11's visual paradigms, upcoming movies. The user can also search by title or tap on a poster to see movie details.

The feed will automatically paginate once the user scrolls down.

## Code Architecture

The project was developed following clean architecture principles with four key principles in mind: stability, maintainabiliy, readability and modularity. This results in a safe, readable code that will easily scale if new features are added or if there are changes to be made on the existing ones.

## Running

The project should be ready to run after cloning. Since it uses Cocoapods as its dependency manager, the project must be open through the .xcworkspace file.

If the dependencies change, you will need to run 'pod install' or even to update already existing libs if necessary.

## Pods Used
All pods used have specific versions on the Podfile to avoid compatibility problems on future versions. If desired, each one has to be manually updated.

1. ** Reusable **

Allows type-safety when dealing with interface files or registering nibs or when reusing cells in UICollectionViews or UITableViews.

2. ** RxSwift, RxAlamofire, RxCocoa **

Allows the usage of Rx paradigms on the project, leading to all intrinsic benefits from such programming paradigm. RxCocoa brings lots of important functionalities when dealing with interface elements, such as the ability to debounce changes in a searchBar and send the updated text for an API request, for example.

3. ** ObjectMapper **

Brings more safety and practicality when dealing with REST APIs or any JSON files that needs to be converted to objects or vice versa.

4. ** SwiftLint **

Incredibly important for big projects or when working on teams, linting should always be done to deliver readable, organized and safe projects.
