# Version 1.8.1
**Mar 28, 2018**
* Fixed crash when clicking "Enter Activation Number" button with DevMateKit v1.8

# Version 1.8
**Mar 22, 2018**
* Updated Sparkle to the latest public release version 1.18.1 (updating functionality core)
* Fixed runtime warnings when working with your own copy of the Sparkle framework
* Fixed main controls layout in the automatic updates dialog
* Assigned 'Send and Relaunch' as the primary button within crash report dialogs
* Fixed runtime warnings when working with activation window controls in background threads
* Fixed typos in comments for the public API
* Removed gathering additional report info API (issues reporter)
* Updated copyright year in all public headers

# Version 1.7.1
**Mar 22, 2016**
* Fixed code signature for XPC service

# Version 1.7
**Mar 16, 2016**
* Introducing a better app activation experience (http://blog.devmate.com/a-simple-a-b-split-test-to-boost-your-app-revenue/)

# Version 1.6.2
**Mar 10, 2016**
* Fixed problem that  was blocking Issues dialog after application crash  in some cases.

# Version 1.6.1
**Mar 3, 2016**
* Corrected auto resizing masks in XIB files of Activation dialog to make it possible to resize window vertically
* Fixed crash while working with Feedback/Issues dialog if could not get current bundle info

# Version 1.6
**Feb 23, 2016**
* Added API for providing info about app installation if needed.
* Added API for easy changing of feedback type via source code for Feedback dialog
* Corrected adjusting UI for cases when developer customizes text of a message in Feedback and/or Issues dialogs
* Corrected Issues dialog work while another modal session is running
* Moved updater’s XPC serviсe inside DevMateKit framework. Another step less to integrate DevMateKit :)
* Fixed getting info about installation process by updater
> **Important!**
> If you used previous DevMateKit versions, you must remove `com.devmate.UpdateInstaller.xpc` component from your project because of moving it inside DevMateKit framework. You need to do it to avoid runtime error caused by duplicating mentioned XPC component inside the main app bundle.

# Version 1.5
**Feb 10, 2016**
* Updated PLCrashReporter (core for issue reporting) to version 1.3
* Updated Sparkle (core for updates delivery) to version 1.13.1
* Updated API to send issue reports silently (without showing reporter dialog to a user)
* Added API that provides developer more control over issue reports which are sent to the server
* Added API for getting value of trial left
* Improved integration with Kevlar lib
* Removed creating of unneeded folders for issue reporter
* Fixed some other small bugs

# Version 1.4
**Nov 3, 2015**
* Added API for faster and easier setup of additional log URLs.
* Updated FastSpring Embedded Store API to the latest public version.
* Added additional API for registering custom step controllers for activation/trial dialog.
* Fixed problem with high CPU load during modal activation/trial dialog run.
* Prevented possible exceptions/crashes during application update.
* Fixed problem with impossibility to update main app bundle via helper application.
* Fixed compilation warnings that appeared in new Xcode version.

# Version 1.3
**Sep 9, 2015**
* Implemented changes into framework to satisfy App Transport Security (ATS) requirements for OS X 10.11 El Capitan
* Updated Sparkle (updates core) to the latest version
* Added API for creating and running feedback dialog controller right from the XIB file
* Added restoring of user’s comments in feedback/issues dialog in case of sending failure
* Corrected trial behaviour in case of license deactivation (invalidation)
* Corrected app activation in case of running it on VM environment
* Fixed other minor bugs
> If you have `SUFeedURL` value in your *Info.plist* file or in user preferences or your `SUUpdater` delegate class implements `-feedURLStringForUpdater:` method, please check it to use URLs with https protocol only for correct work on OS X 10.11 El Capitan.

# Version 1.2
**Jun 17, 2015**
* Corrected constants declaration and added new APIs to use them in Swift projects
* Deprecated some APIs which cannot be used in Swift projects
* Fixed some minor bugs

# Version 1.1.1
**Apr 28, 2015**
* Fixed potential crash while using SUUpdaterQueue for updating
* Fixed vulnerability of dylib hijacking (https://www.virusbtn.com/pdf/magazine/2015/vb201503-dylib-hijacking.pdf)
* Fixed incorrect interpretation of “NotActivated” status to “LicenseExpired” for Kevlar v4.0.1
* Temporary disabled the feature of checking for updates after crash or exception
* Using PNG format (when possible) for image attachments pasted from clipboard into issue reports or feedback messages
* Other minor bugs fixed

# Version 1.1
**Mar 13, 2015**
* Added implementation of FastSpring embedded store
* Resolved conflicts of PLCrashReporter classes in case of using own copy of this framework
* Removed custom compile warning from inline functions

# Version 1.0
**Feb 24, 2015**

DevMateKit is the set of components necessary for collecting application usage data, tracking application health status and communication of end users with the developers.

Features:

 * Sending application launch tracks
 * Sending application activation/trial status
 * Enabling and handling application trial mode: time-limited, action-limited or combination of the two
 * Handling activation process (including FastSpring embedded store)
 * Handling application updates (based on Sparkle engine)
 * Catching application crashes and exceptions
 * Sending crashes and exceptions reports with ability to add user comments, screenshots and other attachments
 * Restarting application after crash
 * Sending user feedback messages with ability to add screenshots or other attachments.
 
