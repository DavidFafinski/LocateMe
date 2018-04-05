# LocateMe
LocateMe is a light application for iOS devices witch helps you find an address by its location on a map.

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/a14ed11ec5ec43e697858847174f9c44)](https://www.codacy.com/app/DavidFafinski/LocateMe?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=DavidFafinski/LocateMe&amp;utm_campaign=Badge_Grade)

![Logo LocateMe](https://image.noelshack.com/fichiers/2018/14/3/1522858369-icon-60-3x.png)

TL;DR : Click on this link from your iDevice to download and install the app : https://i.diawi.com/au2NqP

***To install this app, you must first authorise the installation of foreigns application. Go to your Settings -> General -> Profils and click on trust INEAT Conseil Distribution -> Allow installation.***

# What's LocateMe?!

For iPhones, from iOS 9.0, LocateMe is as simple as that, it locates you. Thanks to **MapBox** Framework, you can easily geolocate yourself and geocode your position, simply drag and pinch the map to the desired location to get its address. 

# Technically

LocateMe is using the MVC pattern, each Controller has its View, designed in a storyboard, and using auto layout constraints. The DataManager is responsible for holding all the managers of this app and initialize them with their respective SAL and DAL classes.

> **SAL** : Service Access Layer 
> **DAL** : Data Access Layer

Each manager class define its own protocol for the SAL and DAL, so you can implement your own Storage or your own Service. As long as you follow the protocol implementation, the Controllers classes won't be damaged :)

## The storage

LocateMe uses a simple and famous storage : the User Defaults. Because it just need to save the last two previous places, you want a storage fast and easy to use. The places are converted to Data thanks to a NSKeyedArchiver so it can save a whole array. 

## The tests

This project has a scheme dedicated for tests where you can launch a quick test and verify that your code is running well. I have choose to use Slather to have a great look on my tests, it works with the data generated by xCode, and it can convert gcc coverage data to many others formats.

Here is a quick view of my result 

![enter image description here](https://image.noelshack.com/fichiers/2018/14/3/1522874348-capture-d-ecran-2018-04-04-a-17-48-26.png)

## Where to go from here ?

Yes, LocateMe is a simple application, but it can implements more and more features.  This is a quick list of evolutions I have think about.

- **RXSwift** : I have a develop a little magic trick to handle the throttle of the searchBar and handle its autocompletion. But of course, RX is very famous for being a master of the "transient state". Just for this case, I have preferred my implementation to handle this case, but if I were to deal with a much bigger app, I would recommend its implementation, it's the best and easy way to handle retries, failing APIs, anti-spamming system, etc.
https://github.com/ReactiveX/RxSwift

- **CoreData or Realm** : For this application, we just need to save 2 places, witch is not a quite big deal, but if I were to handle more data and more complex objects, I would recommend to think about a local storage more powerful. With these mobile databases, you would be able to develop a much more powerful data storage. 
https://github.com/realm/realm-cocoa 

- **Jenkins + Fastlane + Slather + ...** : In order to master your code you must follow this state of life during its development phases. You will want to do follow the tests that fails and want to keep track of it. You may want to get your Continuous Integration straight thanks to a job Jenkins that handles the build. With Fastlane you can improve your deployment from building the app locally to sending it to the AppStore.  It also has great tools to take automatic screenshots of your apps and handling the code signing. Long story short : Jenkins + Fastlane = 🚀 
https://fastlane.tools
https://jenkins.io

- **Tests** : The tests need to be develop with the new features. Sure you can add some UI Tests and Unit tests, but be sure to keep track of them and their consistencies. In this project, only few methods are tested but you will want to fully secure your most important manager classes. 
 
## Contributors

David Fafinski : Developer
david.fafinski@ineat-conseil.fr
