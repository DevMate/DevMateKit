//
//  DMTimeTrialDelegate.m
//  Examples
//
//  Created by Dmytro Tretiakov on 11/13/14.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

#import "DMTimeTrialDelegate.h"
#import "DMKevlarApplication.h"
#import "DMKevlarErrors.h"
#import <DevMateKit/DevMateKit.h>

#define DM_CUSTOM_TRIAL_INTEGRATION 0
#define DM_TIME_TRIAL_INTERVAL kDMTrialWeek

@interface DMTimeTrialDelegate () <DMActivationControllerDelegate>
@property (weak) IBOutlet NSWindow *window;
@end

@implementation DMTimeTrialDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    DMKitDebugAddTrialMenu();
    DMKitDebugAddActivationMenu();
    
    // No need to start trial if our app is already activated.
    if (!DMKIsApplicationActivated(NULL))
    {
#if !DM_CUSTOM_TRIAL_INTEGRATION
        [DevMateKit setupTimeTrial:self withTimeInterval:DM_TIME_TRIAL_INTERVAL];
#else
        // We have window with custom background for trial dialog.
        DMActivationController *trialController = [DMActivationController timeTrialControllerForArea:kDMTrialAreaForAllUsers
                                                                                        timeInterval:DM_TIME_TRIAL_INTERVAL
                                                                                     customWindowNib:@"DMCustomActivationWindow"];
        trialController.delegate = self;
        [trialController startTrial];
#endif
    }
    else
    {
        NSRunInformationalAlertPanel(@"Application is activated", @"", nil, nil, nil);
    }
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
    // In case when trial time is less than 5 minutes give user an ability to start new trial counter at every launch.
    if (DM_TIME_TRIAL_INTERVAL < kDMTrialMinute * 5)
        return NO;
    return YES;
}

@end
