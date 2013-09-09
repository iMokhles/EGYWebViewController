EGYWebViewController
====================

In-App Browser for iOS Apps Support UIActivity ;)

__*Important note if your project doesn't use ARC*__: you must add the **-fobjc-arc** compiler flag to **EGYWebViewController.m** and **EGYModalWebViewController.m** in Target Settings > Build Phases > Compile Sources.

**EGYWebViewController features:**

* iPhone and iPad distinct UIs
* full landscape orientation support
* back, forward, stop/refresh and action buttons 
* Actions ( Share Link to [ Facebook, Twitter ] Send Link to [ Mail, CopyToPasteboard] Open Link in [ Safari, Chrome & Crux ] )
* NavigationBar title set to the currently visible web page

1

![ScreenShot](https://raw.github.com/iMokhles/EGYWebViewController/master/IMG_0133.PNG)  

2

![ScreenShot](https://raw.github.com/iMokhles/EGYWebViewController/master/IMG_0134.PNG)

**Installation**

* Drag the **EGYWebViewController** / **EGYWebViewController** folder into your project. 
* Drag the [ **ARChromeActivity** , **MLCruxActivity** & **TUSafariActivity**] Folders into your project.

**Usage**

(see sample Xcode project in **Demo**)

Just like any UIViewController, **EGYWebViewController** can be pushed into a UINavigationController stack:

<pre>
EGYWebViewController *webViewController = [[EGYWebViewController alloc] initWithAddress:@"http://yahoo.com"];
[self.navigationController pushViewController:webViewController animated:YES];
</pre>

It can also be presented modally using **EGYModalWebViewController**:

<pre>
EGYModalWebViewController *webViewController = [[EGYModalWebViewController alloc] initWithAddress:@"http://yahoo.com"];
[self presentViewController:webViewController animated:YES completion:NULL];
</pre>

**Changing the bars tint color**

Only **EGYModalWebViewController** supports custom tint colors using the **barsTintColor** property.

**Credits**

EGYWebViewController is brought to you by **Mokhles Hussien** "(iMokhles)":http://iMokhles.com
