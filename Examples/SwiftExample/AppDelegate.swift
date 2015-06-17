//
//  AppDelegate.swift
//  SwiftExample
//
//  Created by Dmytro Tretiakov on 6/10/15.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, DevMateKitDelegate
{

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        // Send launch report
        DevMateKit.sendTrackingReport(nil, delegate: self)
        
        // Setup crash/exception reporter
        DevMateKit.setupIssuesController(self, reportingUnhandledIssues: true)
        
        // Setup trial
        var error: Int = DMKevlarError.TestError.rawValue
        if !_my_secret_activation_check(&error) || DMKevlarError.NoError != DMKevlarError(rawValue: error)
        {
            DevMateKit.setupTimeTrial(self, withTimeInterval: kDMTrialWeek)
        }
    }

    @IBAction func openFeedbackWindow(sender: AnyObject?)
    {
        DevMateKit.showFeedbackDialog(self, inMode: DMFeedbackMode.SheetMode)
    }
    
    @IBAction func tryException(sender: AnyObject?)
    {
        print("Will throw exception now...")
        print("\(NSArray().objectAtIndex(23))")
    }
    
    @IBAction func checkForUpdates(sender: AnyObject?)
    {
        DM_SUUpdater.sharedUpdater().checkForUpdates(sender)
    }
    
    @IBAction func activateApp(sender: AnyObject?)
    {
        // Use next keys to activate current app:
        // id670018815249odr
        // id700081094354odr
        // id755295510217odr
        // id507989082392odr
        // id249966537626odr
        // id525124839460odr
        var error: Int = DMKevlarError.TestError.rawValue
        if !_my_secret_activation_check(&error) || DMKevlarError.NoError != DMKevlarError(rawValue: error)
        {
            DevMateKit.runActivationDialog(self, inMode: DMActivationMode.Sheet)
        }
        else
        {
            let license = _my_secret_license_info_getter().takeUnretainedValue() as NSDictionary
            let licenseSheet = NSAlert()
            licenseSheet.messageText = "Your application is already activated."
            licenseSheet.informativeText = "\(license.description)"
            licenseSheet.addButtonWithTitle("OK")
            licenseSheet.addButtonWithTitle("Invalidate License")
            licenseSheet.beginSheetModalForWindow(self.window, completionHandler: { (response) -> Void in
                if response == NSAlertSecondButtonReturn
                {
                    InvalidateAppLicense()
                }
            })
        }
    }
    
    // --------------------------------------------------------------------------------------------
    // DevMateKitDelegate implementation
    @objc func trackingReporter(reporter: DMTrackingReporter!, didFinishSendingReportWithSuccess success: Bool) {
        let resultStr = success ? "was successfully sent" : "was failled"
        print("Tracking report \(resultStr).")
    }
    
    @objc func feedbackController(controller: DMFeedbackController!, parentWindowForFeedbackMode mode: DMFeedbackMode) -> NSWindow?
    {
        return self.window
    }

    @objc func activationController(controller: DMActivationController!, parentWindowForActivationMode mode: DMActivationMode) -> NSWindow?
    {
        return self.window
    }

    @objc func activationController(controller: DMActivationController!, shouldShowDialogForReason reason: DMShowDialogReason, withAdditionalInfo additionalInfo: [NSObject : AnyObject]!, proposedActivationMode ioProposedMode: UnsafeMutablePointer<DMActivationMode>, completionHandlerSetter handlerSetter: ((DMCompletionHandler!) -> Void)!) -> Bool {
        ioProposedMode.memory = DMActivationMode.Sheet
        handlerSetter({ result in
            print("Controller end result: \(result.description)")
        })
        return true
    }
    
}

