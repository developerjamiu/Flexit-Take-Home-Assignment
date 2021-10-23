# Flexit

Flexit Flutter Take Home Project

## Introduction

This project is the implementation of the Flexit Flutter Take Home Project.

### Requirements

- Create an **Mobile App(iOS/Android) displaying a list items and their detail** when clicking on it
- Data needs to come from an API, you can use https://dummyapi.io/ (or choose one of your choice)
- Display list of users (https://dummyapi.io/data/api/user?limit=100)
- Display details of user when clicking on a user (https://dummyapi.io/data/api/user/{userId})
- Add cache or offline mode.
- Share with us the github project 
- You can use any dependency as long as you can justify them.

### Implementation

The project was implemented with a custom architecture similar to MVVM where
- ViewModels are known as notifiers
- State Management been used is Riverpod (provider's older brother :))
- Class Dependencies are managed using the Riverpod Providers
- There are no usage of special providers such as StreamProvider, StateProviders, ChangeNotifiers are used for simplicity
- It uses the classic repository approach
- Features are grouped in the features folder i.e. this app has only on folder
- Most dependencies are abstracted as services
- Contextless navigation and snackbar display are used
- Only services are tested

### Things to improve on

- The API call depends on an app-id (for calling the dummy api) which should be gitignored It is present in lib/src/services/base/api_credentials.dart 
- Use the CachedNetworkImage package/utility to cache network images

## Build
- App build can be found in the github release tab