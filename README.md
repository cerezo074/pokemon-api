# iOS Pokedex: A Handheld Electronic Encyclopedia about Pokémon

## What is this?

This is a small project made for iOS that aims to consume the well-known [PokeAPI](https://pokeapi.co), an HTTP Rest API for consulting Pokémon data. The purpose of this app is to demonstrate iOS skills. This app is still ongoing, so there are many things to implement. That's why you will see empty screens for some modules.

## What features can this app bring to you?

### 1. Home Module

This module shows all the available Pokémon in a two-column grid.

- We use pagination instead of fetching all the Pokémon at once.
- Search Pokémon by name.
- Saves the downloaded Pokémon in your device in case you don't have an internet connection; you're still able to use them.
- In case the app fails to retrieve the Pokémon, you can interact with a Retry button and initialize the download again.
- Shows a detail screen for a Pokémon when the user taps on a Pokémon from the list.

## Technical Aspects

### Data

Pokémon data was retrieved using the library made by [Kinkofer](https://github.com/kinkofer/PokemonAPI). However, because I wanted to show Pokémon thumbnail images in the list, I needed to call 2 endpoints, not only one. The first one is the list endpoint, which only gives you names and Pokémon URLs. For each list item returned, I called the Pokémon info endpoint, which returns all details about a Pokémon. But that wasn't enough. I've [forked](a5bd7587c29aa371382277e24737d162ae6a84f0) the library and enhanced it by exposing the large Pokémon image (there were only small images) and also opened the pagination model to make it easy to be recreated (I persist this item too, and I want to use Core Data or a query mechanism to improve filter performance).

Data is being saved locally in the documents folder. For now, the implementation is pretty straightforward and doesn't block the main thread.

### Architecture

I picked MVVM. Why? It's simple to implement and to scale up. This time, I tried to make it simple to wire up the navigation component. The idea is to use a stateless/cheap/hierarchical navigation. At the top, the app provides a navigation component (which makes the navigation UI component), and for each module, we have its own navigation component. Keep in mind that all of them are open to communicate, but the app navigation is the bridge when each one is going to be instantiated (and for future modules as well). When you configure them using the Main Navigation, set some delegates, publishers, subjects, or whatever mechanism you prefer to notify/propagate modules events.

Why Main/App Navigation for now is a class and conforms to ObservableObject? In case an app needs to show an authentication module, here is where you can change its state and force SwiftUI to re-update the UI based on that change. You can do something like this:

```swift
@ViewBuilder makeRootScreen() -> some View {
    if (!authModule.isSessionValid) {
        authNavigation.start() -> takes user to login
    } else {
        homeNavigation.start() -> takes user to your home module.
    }
}
```

The app navigation is attached to this event authModule.isSessionValid, and when it changes, your app does as well. Also, another important aspect is to support iOS 15 versions. I could use Navigation Stack with its Path property to simplify the implementation, but this will limit the support, and keep in mind that many apps can't afford to move forward quickly.

## Future Things

### Test

Increase the code coverage. For now, the Remote Data Repository is the only class covered 100% (Using URLProtocol). This is the most critical part because it relies on direct integration with the API (Library wrapper). Other components like ViewModels are easy to test because they rely on contracts (protocols or interfaces), and these contracts can be injected to mock the behavior of the ViewModels.

### Query Mechanism

Data requires to be filtered with different criteria. So, in order to make the app scalable, using a query library can be more flexible in case new criteria would arise in the future. I added a Core Data template, but this is open to using other libraries.

### New Modules

App modules are still under development, so in the future, I expect to implement them.
```
