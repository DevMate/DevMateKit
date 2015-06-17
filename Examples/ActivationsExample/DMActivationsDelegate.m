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

#define DM_CUSTOM_ACTIVATION_INTEGRATION 0
#define DM_USE_TRIAL DM_CUSTOM_ACTIVATION_INTEGRATION && 1

@interface DMActivationsDelegate () <DMActivationControllerDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSButton *activateButton;
@property (strong) DMActivationController *customController;
@property (strong) id notificationObject;

- (IBAction)processActivation:(id)sender;

@end

@implementation DMActivationsDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
#if DM_USE_TRIAL
    DMKitDebugAddTrialMenu();
#endif
    DMKitDebugAddActivationMenu();

#if !DM_CUSTOM_ACTIVATION_INTEGRATION
    // No need to run activation dialog if application is already activated
    if (!DMKIsApplicationActivated(NULL))
    {
        [DevMateKit runActivationDialog:nil inMode:DMActivationModeModal];
        if (!DMKIsApplicationActivated(NULL))
        {
            [NSApp terminate:nil];
        }
    }
#else
    BOOL useTrialController = DM_USE_TRIAL && !DMKIsApplicationActivated(NULL);
    if (useTrialController)
    {
        self.customController = [DMActivationController timeTrialControllerForArea:kDMTrialAreaForAllUsers
                                                           timeInterval:kDMTrialWeek
                                                        customWindowNib:@"DMCustomActivationWindow"];
    }
    else
    {
        self.customController = [[DMActivationController alloc] initWithWindowNibName:@"DMCustomActivationWindow"];
    }
    
    self.customController.delegate = self;
    
    // lets show instead of 'Thank you' window 'License info' window
    [self.customController registerStepController:@"DMLicenseInfoStepController"
                                      withNibName:@"DMLicenseInfoStepView"
                                forActivationStep:DMActivationStepSuccess];
    if (useTrialController)
    {
        [self.customController startTrial];
    }
#endif
    
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
    NSString *title = DMKIsApplicationActivated(NULL) ? @"Show License Info" : @"Activate Application";
    self.activateButton.title = title;
    [self.activateButton sizeToFit];
}

- (IBAction)processActivation:(id)sender
{
#if !DM_CUSTOM_ACTIVATION_INTEGRATION
    [DevMateKit runActivationDialog:self inMode:DMActivationModeModal];
#else
    [self.customController runActivationWindowInMode:DMActivationModeSheet
                               initialActivationInfo:nil
                               withCompletionHandler:^(DMActivationProcessResult result) {
                                   [self updateUI];
                               }];
#endif
}

#pragma mark - DMActivationControllerDelegate

- (NSWindow *)activationController:(DMActivationController *)controller parentWindowForActivationMode:(DMActivationMode)mode
{
    return self.window;
}

- (DMActivationStep)activationController:(DMActivationController *)controller activationStepForProposedStep:(DMActivationStep)proposedStep
{
    if (proposedStep == DMActivationStepWelcome && DMKIsApplicationActivated(NULL))
    {
        proposedStep = DMActivationStepSuccess;
    }
    return proposedStep;
}

- (BOOL)activationController:(DMActivationController *)controller shouldShowDialogForReason:(DMShowDialogReason)reason
          withAdditionalInfo:(NSDictionary *)additionalInfo proposedActivationMode:(inout DMActivationMode *)ioProposedMode
     completionHandlerSetter:(void (^)(DMCompletionHandler))handlerSetter
{
    *ioProposedMode = DMActivationModeSheet;

    handlerSetter(^(DMActivationProcessResult result) {
        [self updateUI];
    });

    return YES;
}

- (BOOL)activationController:(DMActivationController *)controller shouldTerminateAppWithReason:(DMTerminationReason)reason
{
    BOOL result = YES;
    if (reason == DMTerminationReasonTrialExpired)
    {
        NSRunAlertPanel(@"Trial Did End.",
                        @"We won't quit app here. To reset trial use 'DevMate Debug' menu.",
                        nil,
                        nil,
                        @"", nil);
        result = NO;
    }
    
    return result;
}

@end
