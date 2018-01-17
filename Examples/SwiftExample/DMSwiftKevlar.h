//
//  DMSwiftKevlar.h
//  Examples
//
//  Created by Dmytro Tretiakov on 6/15/15.
//  Copyright © 2015 DevMate Inc. All rights reserved.
//

#import "DMKevlarApplication.h"

typedef BOOL (*DMKIsApplicationActivatedFunc)(DMKevlarError *);
static DMKIsApplicationActivatedFunc _my_secret_activation_check = &DMKIsApplicationActivated;

typedef CFDictionaryRef (*DMKCopyLicenseUserInfoFunc)(void);
static DMKCopyLicenseUserInfoFunc _my_secret_license_info_getter = &DMKCopyLicenseUserInfo;

void InvalidateAppLicense(void);
void ValidateAppLicense(void (^callback)(NSError *errorOrNil));
