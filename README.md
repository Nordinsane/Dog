# goDog
goDog is an iOS application developed in xCode using Swift. The app allow users to assign dogs to an account where each dog has their own timer which saves them as "Walks" in a Firestore Database. goDog was my contribution to the final thesis of our one-month iOS Database exercise.

![goDog1](Screenshots/goDog-MoshIphoneX.png)
![goDog2](Screenshots/goDog-MoshIphoneX3.png)

## Getting Started
You will need a mac running the latest xCode before pulling the project.  
goDog is compatible with the latest version of iOS 12 and can be run on any iPhone or iPad device running atleast iOS 9.

### Installing
Pull the latest goDog version from github:
```
$ cd your-directory
$ git pull ssh-link
```

### Requirements
The App relies on Firebase to handle users.  
Install the framworks with the following command:
```
$ cd your-directory
$ pod install
```

#### Error!
If you don't have a podfile open Terminal and run:
```
$ pod init
```
A Podfile will appear in your directory, open it.  
Specify the pods you want to install:
```
pod 'Firebase/Core'
```
Return to [Requirements](#Requirements)
