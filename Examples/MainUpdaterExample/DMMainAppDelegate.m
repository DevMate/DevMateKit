//
//  DMMainAppDelegate.m
//  MainUpdaterExample
//
//  Created by Dmytro Tretiakov on 10/27/15.
//  Copyright © 2015 DevMate Inc. All rights reserved.
//

#import "DMMainAppDelegate.h"
#import <DevMateKit/DevMateKit.h>

@interface DMMainAppDelegate ()

@property (unsafe_unretained) IBOutlet NSWindow *window;
@end

@implementation DMMainAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    static NSString *const kHelperApp = @"HelperExample.app";
    
    NSString *helperBundlePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:kHelperApp];
    if (nil != helperBundlePath)
    {
        NSBundle *helperBundle = [NSBundle bundleWithPath:helperBundlePath];
        for (NSRunningApplication *app in [NSRunningApplication runningApplicationsWithBundleIdentifier:helperBundle.bundleIdentifier])
        {
            [app terminate];
        }
        
        [[NSWorkspace sharedWorkspace] launchApplicationAtURL:[NSURL fileURLWithPath:helperBundlePath]
                                                      options:NSWorkspaceLaunchWithoutActivation | NSWorkspaceLaunchAsync
                                                configuration:@{}
                                                        error:nil];
    }
    
    [[SUUpdater sharedUpdater] checkForUpdatesInBackground];
}

@end
