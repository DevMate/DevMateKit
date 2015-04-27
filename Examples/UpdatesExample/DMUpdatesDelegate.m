//
//  DMUpdatesDelegate.m
//  Examples
//
//  Created by Dmytro Tretiakov on 11/13/14.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

#import "DMUpdatesDelegate.h"
#import <DevMateKit/DevMateKit.h>

@interface DMUpdatesDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet SUUpdater *updater;

@end

#define DM_CUSTOM_UPDATES_INTEGRATION 1

@implementation DMUpdatesDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // As my app is sandboxed, let's setup own log system
    DMKitSetupSandboxLogSystem();

#if DM_CUSTOM_UPDATES_INTEGRATION
    self.updater.delegate = self;
#endif
}

#pragma mark - SUUpdaterDelegateInformalProtocol

/* No need to explain here all the delegate methods for SUUpdater object.
    You can easily download source code of it from GitHub to find everything you want to know.
 
    NOTE!!! Use only MacPaw fork of Sparkle project <https://github.com/DevMate/Sparkle> to have
    possibility to update you application via DevMate.
*/

@end
