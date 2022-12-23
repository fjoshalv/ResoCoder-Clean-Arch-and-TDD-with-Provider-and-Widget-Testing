# ResoCoder's TDD Clean Architecture project (using Change Notifier, Dio and widget testing)

## Description
This is the number trivia app which is done in [ResoCoder's "Flutter TDD Clean Architecture" course](https://www.youtube.com/watch?v=KjE2IDphA_U&list=PLB6lc7nQ1n4iYGE_khpXRdJkJEp9WOech), but using Change Notifier as the state management solution, dio as the http manager and adding widget testing. 

### What does the app does?
The app is made to let the user enter a number to get a trivia from said number (or get randomly), which is gotten from [Numbers API](http://numbersapi.com/). If something goes wrong (like having no internet connection), the last trivia gotten is going to be shown.
### Why was the app built with the mentioned approached?
* [Provider](https://pub.dev/packages/provider)'s ChangeNotifier is an state management approach preferred by many because of its simplicity. In addition, it's usually used in a complete different way than bloc (which is the solution used originally), so it was thought that this could be a great substitute in the project.

* [Dio](https://pub.dev/packages/dio) was used because it is a very popular HTTP client package. What's more, finding information about how can we test it is difficult, so it was thought that using it could be a good way of setting at least some notion of how to test its functionality.

* Widget tests was added because its a feature that gets along with the intention of the course, which is to teach how to test your applications. Furthermore, it is considered that testing that consumer widget is rebuilding the UI is a great complement to the course.

---

### Challenges and further features
As a beginner on testing Flutter code, there were plenty of things that took time to implement as well to understand completely. Nonetheless, there were some challenges that took hours to figure out:
* Challenges
    * How to check that dio was really sending the specified headers. 
    * How to trigger consumer widget to rebuild the UI based on the state variables in the test
    * How to verify that notifyListeners method was called the correct number of times

Now, in the near future it is planned to add the following features:
* Integration Testing
* Better approach with Dio
* Add dates trivia

---

## Installation
1. After cloning the repository run
```zsh
flutter pub get
```
2. Run build runner to generate mock files (needed for the tests)
```zsh
flutter pub run build_runner run --delete-conflicting-outputs
```
3. Run the app using your code editor or by running:
 ```zsh
flutter run --debug
```
4. To run the tests, use
 ```zsh
flutter test
```
Built using Flutter 3.3.3

---

## Contribution
There are some things that does not convince 100% yet, so if you would like to add something extra to the project or fix something, you are more than welcome! Send a PR and I will merge it:)

---

## Credits and references
[What is faking vs. mocking vs. stubbing?](https://www.educative.io/answers/what-is-faking-vs-mocking-vs-stubbing)

[Testing widget which are using provider](https://github.com/rrousselGit/provider/issues/182)

[Andrea Bizotto](https://codewithandrea.com/) (Helped me checking Dio's test)

## License
[GPL](https://choosealicense.com/licenses/gpl-3.0/)