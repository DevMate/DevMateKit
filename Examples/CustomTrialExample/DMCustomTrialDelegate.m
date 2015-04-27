//
//  DMCustomTrialDelegate.m
//  Examples
//
//  Created by Dmytro Tretiakov on 11/13/14.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

#import "DMCustomTrialDelegate.h"
#import "DMKevlarApplication.h"
#import "DMKevlarErrors.h"
#import <DevMateKit/DevMateKit.h>

#define DM_CUSTOM_TRIAL_INTEGRATION 0
#define DM_TRIAL_CLICK_COUNT 1

@interface DMCustomTrialDelegate () <DMActivationControllerDelegate>
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSButton *actionButton;
- (IBAction)doSomeAction:(id)sender;

@property (strong) id notificationObject;

@end

@implementation DMCustomTrialDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.notificationObject = [[NSNotificationCenter defaultCenter] addObserverForName:DMKApplicationActivationStatusDidChangeNotification
                                                                                object:nil
                                                                                 queue:[NSOperationQueue mainQueue]
                                                                            usingBlock:^(NSNotification *note) {
                                                                                [self updateUI];
                                                                            }];
    
    DMKitDebugAddTrialMenu();
    DMKitDebugAddActivationMenu();
    
    // No need to start trial if our app is already activated.
    if (!DMKIsApplicationActivated(NULL))
    {
        DMTrialCallbacks callbacks = {0};
        callbacks.getEndValue = ^(void *context) {
            return (CFIndex)DM_TRIAL_CLICK_COUNT;
        };
        callbacks.changeValue = ^(CFIndex currentTrialValue, CFIndex changeValue, void *context) {
            CFIndex updatedValue = currentTrialValue + changeValue;
            return updatedValue;
        };
        
#if !DM_CUSTOM_TRIAL_INTEGRATION
        [DevMateKit setupManualTrial:self withTrialCallbacks:callbacks];
#else
        // We have window with custom background for trial dialog.
        DMActivationController *trialController = [DMActivationController manualTrialControllerForArea:kDMTrialAreaForAllUsers
                                                                                             callbacks:callbacks
                                                                                       customWindowNib:@"DMCustomActivationWindow"];
        trialController.delegate = self;
        [trialController startTrial];
#endif
    }
    
    [self updateUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.notificationObject];
    self.notificationObject = nil;
}

- (IBAction)doSomeAction:(id)sender
{
    DMTrialRef trial = [DMActivationController currentTrialController].trialObject;
    DMTrialChangeTrialValue(trial, 1);
    [self updateUI];
}

- (void)updateUI
{
    NSString *updatedText = nil;
    BOOL canAct = YES;
    
    BOOL isActivated = DMKIsApplicationActivated(NULL);
    DMTrialRef trial = [DMActivationController currentTrialController].trialObject;
    if (isActivated)
    {
        updatedText = @"Application is already activated. Now you have unlimited actions.";
        canAct = YES;
    }
    else if (kDMTrialStateValid == DMTrialGetTrialState(trial))
    {
        CFIndex leftCount = DM_TRIAL_CLICK_COUNT - DMTrialGetTrialCurrentValue(trial);
        updatedText = [NSString stringWithFormat:@"You have %ld trial actions.", leftCount];
        canAct = YES;
    }
    else
    {
        updatedText = @"You should activate application to continue work.";
        canAct = NO;
    }
    
    self.textField.stringValue = updatedText ? : @"";
    [self.textField sizeToFit];
    self.actionButton.enabled = canAct;
}

#pragma mark - DMActivationControllerDelegate

- (NSWindow *)activationController:(DMActivationController *)controller parentWindowForActivationMode:(DMActivationMode)mode
{
    return self.window;
}

- (BOOL)activationController:(DMActivationController *)controller shouldShowDialogForReason:(DMShowDialogReason)reason
          withAdditionalInfo:(NSDictionary *)additionalInfo proposedActivationMode:(inout DMActivationMode *)ioProposedMode
           completionHandler:(out DMCompletionHandler *)pHandlerCopy
{
    NSString *reasonStr = nil;
    switch (reason)
    {
        case DMShowReasonTrialInitialize:
            reasonStr = @"DMShowReasonTrialInitialize";
            break;
            
        case DMShowReasonTrialContinue:
            reasonStr = @"DMShowReasonTrialContinue";
            break;
            
        case DMShowReasonTrialExpired:
            reasonStr = @"DMShowReasonTrialExpired";
            break;

        default:
            reasonStr = @"Other reasons";
            break;
    };
    NSLog(@"Will show activation dialog for reason: %@", reasonStr);
    
    *ioProposedMode = DMActivationModeSheet;
    
    DMCompletionHandler handler = ^(DMActivationProcessResult result) {
        [self updateUI];
    };
    *pHandlerCopy = (__bridge DMCompletionHandler)Block_copy((__bridge void *)handler);
    
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

- (BOOL)trialControllerShouldContinueLastSavedTrial:(DMActivationController *)controller
{
    // In case when max trial clicks is less than 2 give user an ability to start new trial counter at every launch.
    if (DM_TRIAL_CLICK_COUNT < 2)
        return NO;
    return YES;
}

@end
