//
//  DMIssuesDelegate.m
//  Examples
//
//  Created by Dmytro Tretiakov on 11/13/14.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

#import "DMIssuesDelegate.h"
#import <DevMateKit/DevMateKit.h>
#import <CustomIssuesReporterUI/DMCustomIssuesWindowController.h>

#define DM_CUSTOM_ISSUES_INTEGRATION 0

@interface DMIssuesDelegate () <DMIssuesControllerDelegate>

@property (unsafe_unretained) IBOutlet NSWindow *window;
@end

@implementation DMIssuesDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // As my app is sandboxed, let's setup own log system
    DMKitSetupSandboxLogSystem();
    
    // Add DevMate Debug menu for testing issues reporter
    DMKitDebugAddIssuesMenu();
    
#if !DM_CUSTOM_ISSUES_INTEGRATION
    [DevMateKit setupIssuesController:nil reportingUnhandledIssues:YES];
#else
    DMIssuesController *issuesController = [DMIssuesController sharedController];
    issuesController.delegate = self;
    [issuesController setIssuesWindowControllerClass:[DMCustomIssuesWindowController class]];
    [issuesController reportUnhandledIssuesIfExists:YES];
#endif
}

#pragma mark - DMIssuesControllerDelegate

- (void)reporterWillRestartApplication:(DMIssuesController *)controller
{
    NSLog(@"Application will be restarted now. Try to finish all actions to save user data if needs.");
}

- (BOOL)controller:(DMIssuesController *)controller shouldReportIssue:(id<DMIssue>)issue
{
    BOOL shouldShowIssueReporterDialogRightNow = YES;
    if (issue.type == DMIssueTypeException)
    {
        shouldShowIssueReporterDialogRightNow = NO;
        
        // do some work before showing issues reporter here
        // ...
        // than try to report unhadled exception
        dispatch_async(dispatch_get_main_queue(), ^{
            [[DMIssuesController sharedController] reportUnhandledIssuesIfExists:YES];
        });
    }
    else
    {
        // In case of crash we can just forbid to show issue reporter dialog
        // but application will be terminated anyway
    }
    
    return shouldShowIssueReporterDialogRightNow;
}

- (NSString *)additionalIssueInfoForController:(DMIssuesController *)controller
{
    return @"Some additional info";
}

@end
