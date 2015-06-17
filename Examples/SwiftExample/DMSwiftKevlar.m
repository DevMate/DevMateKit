//
//  DMSwiftKevlar.m
//  Examples
//
//  Created by Dmytro Tretiakov on 6/15/15.
//  Copyright © 2015 DevMate Inc. All rights reserved.
//

#import "DMSwiftKevlar.h"

static __attribute__((constructor)) void _GlobalVarsInitializer(void)
{
    _my_secret_activation_check = &DMKIsApplicationActivated;
    _my_secret_license_info_getter = &DMKCopyLicenseUserInfo;
}

void InvalidateAppLicense(void)
{
    @autoreleasepool
    {
        [NSApp invalidateLicense];
    }
}