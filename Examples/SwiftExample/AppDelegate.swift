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


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Setup trial
        var error = DMKevlarError.testError
        if !_my_secret_activation_check!(&error).boolValue || DMKevlarError.noError != error {
            DevMateKit.setupTimeTrial(self, withTimeInterval: kDMTrialWeek)
        }
        
        // Setup activation delegate for all activation controllers
        DMActivationController.setDelegate(self)
    }

    @IBAction func checkForUpdates(_ sender: AnyObject?) {
        DM_SUUpdater.shared().automaticallyDownloadsUpdates = false
        DM_SUUpdater.shared().checkForUpdates(self)
    }
    
    @IBAction func activateApp(_ sender: AnyObject?) {
        // Use next keys to activate current app:
        // id661692763632odr
        // id875021488172odr
        // id912199957389odr
        // id447048439877odr
        // id878451030189odr
        // id401703394809odr
        var error = DMKevlarError.testError
        if !_my_secret_activation_check!(&error).boolValue || DMKevlarError.noError != error {
            DevMateKit.runActivationDialog(self, in: DMActivationMode.sheet)
        }
        else {
            ValidateAppLicense({ error in
                if let error = error {
                    print("Failed license validation with error: \(error)")
                }
                else {
                    print("License did validate successfully")
                }
            })
            let license: NSDictionary? = _my_secret_license_info_getter()?.takeUnretainedValue()
            let licenseSheet = NSAlert()
            licenseSheet.messageText = "Your application is already activated."
            licenseSheet.informativeText = "\(license?.description ?? "(null)")"
            licenseSheet.addButton(withTitle: "OK")
            licenseSheet.addButton(withTitle: "Invalidate License")
            licenseSheet.beginSheetModal(for: self.window, completionHandler: { response in
                if response == .alertSecondButtonReturn {
                    InvalidateAppLicense()
                }
            })
        }
    }
    
    // --------------------------------------------------------------------------------------------
    // DevMateKitDelegate implementation
    @objc func activationController(_ controller: DMActivationController,
                                    parentWindowFor mode: DMActivationMode) -> NSWindow? {
        return window
    }

    @objc func activationController(_ controller: DMActivationController,
                                    shouldShowDialogForReason reason: DMShowDialogReason,
                                    withAdditionalInfo additionalInfo: [AnyHashable : Any],
                                    proposedActivationMode ioProposedMode: UnsafeMutablePointer<DMActivationMode>,
                                    completionHandlerSetter handlerSetter: @escaping (DMCompletionHandler) -> Void) -> Bool {
        ioProposedMode.pointee = DMActivationMode.sheet
        handlerSetter() {
            print("Controller end result: \($0.description)")
        }
        return true
    }
    
}

