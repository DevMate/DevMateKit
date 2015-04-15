//
//  DMFeedbackDelegate.m
//  Examples
//
//  Created by Dmytro Tretiakov on 11/13/14.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

#import "DMFeedbackDelegate.h"
#import <DevMateKit/DevMateKit.h>

#define DM_CUSTOM_FEEDBACK_INTEGRATION 0

@interface DMFeedbackDelegate () <DMFeedbackControllerDelegate>

@property (weak) IBOutlet NSWindow *window;
@end

@implementation DMFeedbackDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // As my app is sandboxed, let's setup own log system
    DMKitSetupSandboxLogSystem();
}

#pragma mark - IBActions

- (IBAction)provideFeedback:(id)sender
{
#if !DM_CUSTOM_FEEDBACK_INTEGRATION
    [DevMateKit showFeedbackDialog:nil inMode:DMFeedbackDefaultMode];
#else
    DMFeedbackController *feedback = [[DMFeedbackController alloc] initWithWindowNibName:@"DMCustomFeedbackWindow"];
    feedback.delegate = self;
    [feedback showFeedbackWindowInMode:DMFeedbackSheetMode completionHandler:^(BOOL success) {
        NSLog(@"User feedback %@ sent", success ? @"WAS" : @"WAS NOT");
    }];
#endif
}

#pragma mark - DMFeedbackControllerDelegate

- (NSWindow *)feedbackController:(DMFeedbackController *)controller parentWindowForFeedbackMode:(DMFeedbackMode)mode
{
    return self.window;
}

@end
