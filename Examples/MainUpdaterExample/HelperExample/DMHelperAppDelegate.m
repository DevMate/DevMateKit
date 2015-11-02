//
//  DMHelperAppDelegate.m
//  HelperExample
//
//  Created by Dmytro Tretiakov on 10/27/15.
//  Copyright © 2015 DevMate Inc. All rights reserved.
//

#import "DMHelperAppDelegate.h"
#import <DevMateKit/DevMateKit.h>

@interface DMHelperAppDelegate () <SUUpdaterDelegate>

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSString *mainAppBundlePath;
@property (nonatomic, strong) SUUpdater *mainAppUpdater;

@end

@implementation DMHelperAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"AppIcon"];
    
    NSMenu *menu = [[NSMenu alloc] init];
    NSMenuItem *item = [menu addItemWithTitle:@"Update in background" action:@selector(updateMainApp:) keyEquivalent:@""];
    item.target = self;
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    
    self.statusItem.menu = menu;
    self.mainAppBundlePath = [NSBundle mainBundle].bundlePath.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent.stringByDeletingLastPathComponent;
    self.mainAppUpdater = nil;
}

- (IBAction)updateMainApp:(id)sender
{
    NSError *error = nil;
    do
    {
        if (nil != self.mainAppUpdater)
        {
            error = [NSError errorWithDomain:NSCocoaErrorDomain
                                        code:1
                                    userInfo:@{NSLocalizedDescriptionKey : @"Updating process is in progress."}];
            break;
        }
        
        NSBundle *mainAppBundle = [NSBundle bundleWithPath:self.mainAppBundlePath];
        if (nil == mainAppBundle)
        {
            error = [NSError errorWithDomain:NSCocoaErrorDomain
                                        code:2
                                    userInfo:@{NSLocalizedDescriptionKey : @"Main application bundle could not be located"}];
            break;
        }
        
        if ([self isMainAppRunning])
        {
            error = [NSError errorWithDomain:NSCocoaErrorDomain
                                        code:1
                                    userInfo:@{NSLocalizedDescriptionKey : @"Main application is running. It should update itself."}];
            break;
        }
        
        self.mainAppUpdater = [SUUpdater updaterForBundle:mainAppBundle];
        self.mainAppUpdater.delegate = self;
        [self.mainAppUpdater checkForUpdatesInBackground];
    }
    while (NO);
    
    if (error)
    {
        [self updater:nil didAbortWithError:error];
    }
}

- (BOOL)isMainAppRunning
{
    BOOL isMainAppRunning = NO;
    
    NSBundle *mainAppBundle = [NSBundle bundleWithPath:self.mainAppBundlePath];
    NSArray *runningApplications = mainAppBundle ? [NSRunningApplication runningApplicationsWithBundleIdentifier:mainAppBundle.bundleIdentifier] : nil;
    for (NSRunningApplication *runningApp in runningApplications)
    {
        if ([runningApp.bundleURL.path isEqualToString:mainAppBundle.bundlePath])
        {
            isMainAppRunning = YES;
            break;
        }
    }
    
    return isMainAppRunning;
}

- (BOOL)updaterShouldRelaunchApplication:(SUUpdater *)updater
{
    return ![self isMainAppRunning];
}

- (void)updater:(SUUpdater *)updater willInstallUpdateOnQuit:(SUAppcastItem *)item immediateInstallationInvocation:(NSInvocation *)invocation
{
    [invocation invoke];
}

- (NSString *)pathToRelaunchForUpdater:(SUUpdater *)updater
{
    return [NSBundle mainBundle].bundlePath;
}

- (void)updater:(SUUpdater *)updater didAbortWithError:(NSError *)error
{
    if (nil != error)
    {
        NSLog(@"ERROR: %ld - %@", error.code, error.localizedDescription);
        [[NSAlert alertWithError:error] runModal];
    }
    self.mainAppUpdater = nil;
}

- (BOOL)updater:(SUUpdater *)updater mayShowModalAlert:(NSAlert *)alert
{
    return NO;
}

@end

