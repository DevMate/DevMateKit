//
//  DMActivationsDelegate.m
//  Examples
//
//  Created by Dmytro Tretiakov on 11/13/14.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

#import "DMActivationsDelegate.h"
#import "DMKevlarApplication.h"
#import <DevMateKit/DevMateKit.h>

#define DM_USE_TRIAL 1

static NSString *const DMURLSchemeName = @"bathyscaphe";

/*
 See Info.plist for all URL schemes supporteb by this app.
 For testing just type link in browser:
    bathyscaphe://activate?key=id661692763632odr
*/

@interface DMActivationsDelegate () <DevMateKitDelegate>

@property (unsafe_unretained) IBOutlet NSWindow *window;

@end

@implementation DMActivationsDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
#if DM_USE_TRIAL
    DMKitDebugAddTrialMenu();
#endif
    DMKitDebugAddActivationMenu();
    
    if (DM_USE_TRIAL)
    {
        DMActivationController *controller = [DMActivationController timeTrialControllerForArea:kDMTrialAreaDefault
                                                                                   timeInterval:kDMTrialWeek
                                                                                customWindowNib:nil];
        controller.delegate = self;
        
        // Need to register URL scheme for this controller, because default one will respond for URL scheme request
        [controller registerForScheme:DMURLSchemeName];
        
        if (!DMKIsApplicationActivated(NULL))
        {
            [controller startTrial];
        }
    }
}

#pragma mark - DMActivationControllerDelegate

- (NSWindow *)activationController:(DMActivationController *)controller parentWindowForActivationMode:(DMActivationMode)mode
{
    return self.window;
}

- (BOOL)activationController:(DMActivationController *)controller shouldShowDialogForReason:(DMShowDialogReason)reason
          withAdditionalInfo:(NSDictionary *)additionalInfo proposedActivationMode:(inout DMActivationMode *)ioProposedMode
     completionHandlerSetter:(void (^)(DMCompletionHandler))handlerSetter
{
    if (reason == DMShowReasonActivateViaURLScheme)
    {
        *ioProposedMode = DMActivationModeSheet;
        NSLog(@"Will activate via URL scheme: %@", [additionalInfo objectForKey:DMAdditionalInfoURLSchemeNameKey] ? : @"Unknown");
    }

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
