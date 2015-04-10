![](https://github.com/DevMate/DevMateKit/blob/master/DevMate-logo.png)

##What is DevMate

[DevMate](devmate.com) is development and distribution platform for Mac OS X developers.

DevMate Dashboard provides a full control over your application and customers, displays app usage statistics, crash reports and user feedback in real time - all from a single, elegant place.

 * **Distribute your app**. Upload and host application binaries on DevMate to make the app available for downloading. DevMate uses Amazon CDN to deliver installation files, which guarantees 99.9% uptime.

 * **Analyze sales and app usage.** Get detailed sales and downloads reports, conversions ratios and campaign reports. Analyze customers behaviour and application usage.

 * **Monitor crash reports.** Issue and exception reports are collected in real time and grouped by similarity in DevMate DashBoard. Each issue group shows the impact on your app users.

 * **Manage customers.** A simple CRM crafted specially for the developers and support guys. It collects and stores all essential info about customer and initiated purchases: order number, activation keys, and more.

 * **Users’ feedback.** Collect and reply users’ feedback, discuss them with your team, and assign statuses to ensure that no message is left without a reply.

In order to connect your application to DevMate you are to integrate DevMateKit which provides you a set of ready-to-use tools that allows you to prepare your application for distribution:

* **Activations** to protect and license your application. Create time and/or feature limited trial versions.

* **Updates based on Sparkle framework.** Automatically deliver app updates right to the customer.

* **Crash reporting in real time.** DevMate collects and symbolicates issue reports.

* **Feedback.** Your customers can send feedback right from the app.

##Get Started

* Download DevMateKit
* Follow the instructions from [wiki](https://github.com/DevMate/DevMateKit/wiki/Integrating-DevMateKit)

or, alternatively, integrate it to your project using [CocoaPods](cocoapods.org). Here is the podfile:

````ruby
platform :osx, '10.7'
pod 'DevMateKit'
````

##Activations and Trial

To manage activations and trial you need to have Kevlar library installed which is generated uniquely for each application. You can read more on it [here](http://docs.devmate.com/v1.0/docs/activations-and-trial).

##Issue Reporter Setup

DevMateKit allows sending crashes and exception reports that can be viewed later in [Issues Management](http://docs.devmate.com/v1.0/docs/issues-management) section of DevMate Dashboard. Moreover, you will be able to view how issues of your app are distributed by various parameters in [Issues Statistics](http://docs.devmate.com/v1.0/docs/issues-statistics) section, which will help you to detrmine the weaker places of the app.

Enabling issue reporter is that easy as just adding to the `-applicationDidFinishLaunching:` method of your application delegate class the following string:

````objective-c
[DevMateKit setupIssuesController:nil reportingUnhandledIssues:YES];
````

More info of issue reporter usage you can find in the [wiki article](https://github.com/DevMate/DevMateKit/wiki/Issue-Reporter).

## Feedback Setup

To allow your users sending feedback messages you need to do the following:

1. Add the following method to your application delegate class implementation:

````objective-c
- (IBAction)showFeedbackDialog:(id)sender {
    [DevMateKit showFeedbackDialog:nil inMode:DMFeedbackDefaultMode];
}
````

2.  Connect action method you just added with corresponding menu item or button inside your XIB files.

3. Build and run your application. Send a feedback message as you defined in previous step. If everything was done correctly, your message will be displayed in [Feedback Management](http://docs.devmate.com/v1.0/docs/feedback-management) DevMate section.

##Updates Setup

To keep user of your app updated, do the following.

1. Add **com.devmate.UpdateInstaller.xpc** component to your project. Read more [here](http://docs.devmate.com/v1.0/docs/updates#install-necessary-xpc-components) if you need help.

2. Add new Object component from _'Object library'_ to your main XIB file and change its class name to `SUUpdater`.

3. Build and run your application and try to update.