//
//  DMCustomTimeTrialDelegate.m
//  CustomTimeTrialExample
//
//  Created by Dmytro Tretiakov on 8/31/15.
//  Copyright (c) 2015 Dmytro Tretiakov. All rights reserved.
//

#import "DMCustomTimeTrialDelegate.h"
#import "DMKevlarApplication.h"
#import <DevMateKit/DevMateKit.h>

@interface DMCustomTimeTrialDelegate () <DMActivationControllerDelegate>

@property (strong) NSMutableArray *observers;
@property (readonly) NSString *activeTimeLeftStr;

@property (weak) IBOutlet NSWindow *window;
@end

@implementation DMCustomTimeTrialDelegate

- (void)dealloc
{
    for (id observer in self.observers)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}

#define MAX_ACTIVE_TRIAL_TIME (15 * kDMTrialMinute)
#define UPDATE_EVERY_SECONDS_TIME 1

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DMKitDebugAddTrialMenu();
    DMKitDebugAddActivationMenu();
    
    // To activate application you can use one of the next keys:
    // id661692763632odr
    // id875021488172odr
    // id912199957389odr
    // id447048439877odr
    // id878451030189odr
    // id401703394809odr
    if (DMKIsApplicationActivated(NULL) == YES)
        return;

    // Current example shows an example of one more using of manual trial.
    // Here we start manual time trial that counts only active time (application is in a foreground).
    // Every UPDATE_EVERY_SECONDS_TIME seconds time that left will be updated.
    static CFAbsoluteTime sLastUpdateTime = 0;
    void (^updateTrialInfo)(DMTrialRef, CFIndex) = ^(DMTrialRef trial, CFIndex minChangedTime) {
        CFAbsoluteTime prevUpdateTime = sLastUpdateTime;
        CFAbsoluteTime currentUpdateTime = CFAbsoluteTimeGetCurrent();
        CFIndex changedTime = (CFIndex)fabs(currentUpdateTime - prevUpdateTime);
        if (changedTime < minChangedTime)
            changedTime = minChangedTime;
        DMTrialChangeTrialValue(trial, changedTime);

        sLastUpdateTime = currentUpdateTime;
        
        [self willChangeValueForKey:@"activeTimeLeftStr"];
        [self didChangeValueForKey:@"activeTimeLeftStr"];
    };

    static dispatch_source_t updateTimer = NULL;
    void (^startTrialTimer)(void) = ^{
        if (NULL != updateTimer)
            return;

        DMTrialRef trial = [DMActivationController currentTrialController].trialObject;
        if (!DMTrialIsTrialInitialized(trial))
            return;

        sLastUpdateTime = CFAbsoluteTimeGetCurrent();
        DMTrialChangeTrialValue(trial, 0.0);

        CFIndex repeatTime = UPDATE_EVERY_SECONDS_TIME;
        uint64_t repeatInterval = repeatTime * NSEC_PER_SEC;
        uint64_t repeatLeeway = repeatInterval / 10;
        updateTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(updateTimer, dispatch_walltime(NULL, repeatInterval), repeatInterval, repeatLeeway);
        dispatch_source_set_event_handler(updateTimer, ^{
            updateTrialInfo(trial, repeatTime);
        });
        dispatch_resume(updateTimer);
    };
    void (^stopTrialTimer)(void) = ^{
        if (NULL == updateTimer)
            return;

        dispatch_source_cancel(updateTimer);
        updateTimer = NULL;

        DMTrialRef trial = [DMActivationController currentTrialController].trialObject;
        updateTrialInfo(trial, 0); // to save last active trial time
    };

    if (nil == self.observers)
        self.observers = [NSMutableArray array];
    id observer = nil;

    observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillBecomeActiveNotification object:NSApp queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        startTrialTimer();
    }];
    [self.observers addObject:observer];

    observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillResignActiveNotification object:NSApp queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        stopTrialTimer();
    }];
    [self.observers addObject:observer];

    observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillTerminateNotification object:NSApp queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        stopTrialTimer();
    }];
    [self.observers addObject:observer];


    DMTrialCallbacks callbacks = {0};
    callbacks.getEndValue = ^(void *context) {
        return (CFIndex)MAX_ACTIVE_TRIAL_TIME;
    };
    callbacks.changeValue = ^(CFIndex currentTrialValue, CFIndex changeValue, void *context) {
        CFTimeInterval resultValue = (CFTimeInterval)currentTrialValue + (CFTimeInterval)changeValue;
        if (resultValue > (CFTimeInterval)LONG_MAX)
            resultValue = (CFTimeInterval)LONG_MAX;
        return (CFIndex)resultValue;
    };
    callbacks.initialize = ^(void *context) {
        startTrialTimer();
    };
    callbacks.didEndTrial = ^(void *context) {
        stopTrialTimer();
    };
    callbacks.finalize = ^(void *context) {
        stopTrialTimer();
    };

    DMActivationController *controller = [DMActivationController manualTrialControllerForArea:kDMTrialAreaDefault
                                                                                    callbacks:callbacks
                                                                              customWindowNib:nil];
    controller.delegate = self;
    [controller startTrial];
}

- (NSString *)activeTimeLeftStr
{
    NSString *result = @"undefined";
    if (DMKIsApplicationActivated(NULL))
    {
        result = @"application is activated";
    }
    else if (kDMTrialStateValid == DMTrialGetTrialState([DMActivationController currentTrialController].trialObject))
    {
        DMTrialRef trial = [DMActivationController currentTrialController].trialObject;
        double timeLeft = (double)(MAX_ACTIVE_TRIAL_TIME - DMTrialGetTrialCurrentValue(trial));
        double daysLeft = floor(timeLeft / kDMTrialDay);
        double hoursLeft = floor((timeLeft - daysLeft * kDMTrialDay) / kDMTrialHour);
        double minutesLeft = floor((timeLeft - daysLeft * kDMTrialDay - hoursLeft * kDMTrialHour) / kDMTrialMinute);
        double secondsLeft = timeLeft - daysLeft * kDMTrialDay - hoursLeft * kDMTrialHour - minutesLeft * kDMTrialMinute;
        
        result = [NSString stringWithFormat:@"%.0fd %02.0f:%02.0f:%02.0f", daysLeft, hoursLeft, minutesLeft, secondsLeft];
    }
    else if (kDMTrialStateInvalid == DMTrialGetTrialState([DMActivationController currentTrialController].trialObject))
    {
        result = @"trial expired";
    }
    
    return result;
}

@end
