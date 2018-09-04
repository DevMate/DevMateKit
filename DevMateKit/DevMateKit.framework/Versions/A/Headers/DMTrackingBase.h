//
//  DMTrackingBase.h
//  DevMateTracking
//
//  Copyright (c) 2013-2018 DevMate Inc. All rights reserved.
//

#if __has_feature(modules)
@import Foundation;
#else
#import <Foundation/Foundation.h>
#endif

#import "DMDefines.h"

//! Application activation status
typedef NS_ENUM(NSUInteger, DMAppActivationStatus)
{
    DMAppStatusUndefined            = 0,
    DMAppStatusTrialValid           = 1,    // app in trial mode
    DMAppStatusTrialInvalid         = 2,    // trial mode ended but app is not activated yet
    DMAppStatusNotActivated         = 3,    // app has no trial mode at all
    DMAppStatusActivated            = 4,    // app is activated
    DMAppStatusActivationExpired    = 5,    // app was activated but license is expired
    DMAppStatusFreeSoftware         = 6     // app is a free software
};

//! Application trial value structure
typedef struct _DMAppTrialValue
{
    NSInteger trialStart;
    NSInteger trialEnd;
    NSInteger trialCurrent;
} DMAppTrialValue;

NS_INLINE DMAppTrialValue DMAppTrialValueMake(NSInteger start, NSInteger end, NSInteger current)
{
    DMAppTrialValue trialValue;
    trialValue.trialStart = start;
    trialValue.trialEnd = end;
    trialValue.trialCurrent = current;
    return trialValue;
}

#define DMAppTrialValueMakeSimple(_end_, _current_) DMAppTrialValueMake(0, (_end_), (_current_))
