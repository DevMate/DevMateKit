//
//  DMTrackingDelegate.m
//  Examples
//
//  Created by Dmytro Tretiakov on 11/13/14.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

#import "DMTrackingDelegate.h"
#import <DevMateKit/DevMateKit.h>

#define DM_CUSTOM_TRACKING_INTEGRATION 0

@interface DMTrackingDelegate () <DMTrackingReporterDelegate, DMTrackingReporterInfoProvider>

@property (unsafe_unretained) IBOutlet NSWindow *window;
@end

@implementation DMTrackingDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Try to send tracking report at application start
#if !DM_CUSTOM_TRACKING_INTEGRATION
    [DevMateKit sendTrackingReport:nil delegate:nil];
#else
    [self sendTrackingReport];
#endif
}

- (void)sendTrackingReport
{
    DMTrackingReporter *reporter = [DMTrackingReporter reporterWithInfoProvider:self];
    reporter.delegate = self;
    [reporter sendReport:YES];
}

#pragma mark - DMTrackingReporterInfoProvider

// Let tracking reporter to do it for me
//- (NSUInteger)applicationLaunchCount:(DMTrackingReporter *)reporter;

- (DMAppActivationStatus)applicationActivationStatus:(DMTrackingReporter *)reporter
{
    // My application is free
    return DMAppStatusFreeSoftware;
}

- (DMAppTrialValue)applicationTrialValue:(DMTrackingReporter *)reporter
{
    // As my app is free and have no any trial
    return DMAppTrialValueMakeSimple(0, 0);
}

#pragma mark - DMTrackingReporterDelegate

- (void)trackingReporter:(DMTrackingReporter *)reporter didFinishSendingReportWithSuccess:(BOOL)success
{
    if (success)
    {
        NSLog(@"Tracking report was sent successfully");
    }
    else
    {
        NSTimeInterval delayTime = 10.0f;
        NSLog(@"Tracking report failed. Will be sent again in a %.0f seconds", delayTime);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self sendTrackingReport];
        });
    }
}

@end
