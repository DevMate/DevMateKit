//
//  DMActivationsDelegate.m
//  Examples
//
//  Created by Dmytro Tretiakov on 11/13/14.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

#import "DMActivationsDelegate.h"
#import "DMKevlarApplication.h"
#import "DMKevlarErrors.h"
#import <DevMateKit/DevMateKit.h>

@interface DMActivationsDelegate () <DMActivationControllerDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSButton *activateButton;
@property (strong) id notificationObject;

- (IBAction)processActivation:(id)sender;

@end

@implementation DMActivationsDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DMKitDebugAddActivationMenu();

    self.notificationObject = [[NSNotificationCenter defaultCenter] addObserverForName:DMKApplicationActivationStatusDidChangeNotification
                                                                                object:nil
                                                                                 queue:[NSOperationQueue mainQueue]
                                                                            usingBlock:^(NSNotification *note) {
                                                                                [self updateUI];
                                                                            }];
    [self updateUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.notificationObject];
    self.notificationObject = nil;
}

- (void)updateUI
{
    NSString *title = DMKIsApplicationActivated(NULL) ? @"Invalidate License" : @"Activate Application";
    self.activateButton.title = title;
    [self.activateButton sizeToFit];
}

- (IBAction)processActivation:(id)sender
{
    if (!DMKIsApplicationActivated(NULL))
    {
        [DevMateKit runActivationDialog:self inMode:DMActivationModeSheet];
    }
    else
    {
        [NSApp invalidateLicense];
    }
}

#pragma mark - DMActivationControllerDelegate

- (NSWindow *)activationController:(DMActivationController *)controller parentWindowForActivationMode:(DMActivationMode)mode
{
    controller.animationAnchor = DMAnimationAnchorCenter;
    return self.window;
}

- (DMFsprgEmbeddedStoreType)fsprgEmbeddedStoreTypeForActivationController:(DMActivationController *)controller
{
    return DMFsprgEmbeddedStoreNative;
}

- (void)activationController:(DMActivationController *)controller willStartNativeFsprgEmbeddedStore:(id<DMFsprgStoreParameters>)storeParameters
{
    [storeParameters setOrderProcessTypeInt:DMFsprgOrderProcessDetail];
    [storeParameters setStoreId:@"devmatetesting" withProductId:@"devmateintegrationtest"];
    [storeParameters setModeInt:DMFsprgModeTest];
    
    [storeParameters setContactFname:@"John"];
    [storeParameters setContactLname:@"Apple"];
    [storeParameters setContactCompany:@"DevMate Inc."];
    [storeParameters setContactEmail:@"info@devmate.com"];
    [storeParameters setContactPhone:@"000-123-45-67-89"];
}

- (BOOL)activationController:(DMActivationController *)controller canResizeNativeFsprgEmbeddedStoreWindowWithInitialSize:(inout NSSize *)ioInitialSize
{
    return YES;
}

- (void)activationController:(DMActivationController *)controller didLoadNativeFsprgEmbeddedStorePage:(NSURL *)pageURL
{
    NSLog(@"Embedded store did load URL: %@", [pageURL absoluteString]);
}

@end
