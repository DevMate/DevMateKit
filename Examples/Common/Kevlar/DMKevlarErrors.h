//
//  DMKevlarErrors.h
//  kevlar
//
//  Copyright (c) 2012-2015 DevMate Inc. All rights reserved.
//

#ifndef DMKevlarErrors_h
#define DMKevlarErrors_h

FOUNDATION_EXTERN NSString *const DMKevlarErrorDomain;

typedef NS_ENUM (NSInteger, DMKevlarError)
{
    DMKevlarTestError                       = NSIntegerMax, // proposed to init your var with this test code. After validation it should be changed to one of the other codes below.

    DMKevlarNoError                         = 0,

    DMKevlarGeneralError                    = -100,
    DMKevlarActivationInProcess             = -101,

    DMKevlarEmptyProduct                    = 1,
    DMKevlarNoSuchProduct                   = 2,
    DMKevlarAbsentUsername                  = 3,
    DMKevlarAbsentActivationCode            = 4,
    DMKevlarNeedProductUpgrade              = 5,
    DMKevlarOldKeyUsed                      = 6,
    DMKevlarWrongActivationNumber           = 7,
    DMKevlarKeyAlreadyActivated             = 8,
    DMKevlarFailedToReactivate              = 9,
    DMKevlarKeyExpired                      = 10,
    DMKevlarInternalServerError             = 11,
    DMKevlarKeyForOtherProduct              = 12,
    DMKevlarReactivationKeyNotFound         = 14,
    DMKevlarBetaOnlyKeyError                = 15,
    DMKevlarProductVersionExpired           = 16,
    DMKevlarServerValidationError           = 17,
    DMKevlarProductDeactivated              = 18,
    DMKevlarOrderWasRefunded                = 19,
    DMKevlarSubscriptionWasCanceled         = 20,
    DMKevlarSubscriptionChargeFailed        = 21,
    
    DMKevlarLicenseAbsentError              = 100,
    DMKevlarLicenseSignatureError           = 101,
    DMKevlarLicenseValidationError          = 102,
};

#endif // DMKevlarErrors_h
