//
//  DMSwiftKevlar.h
//  Examples
//
//  Created by Dmytro Tretiakov on 6/15/15.
//  Copyright © 2015 DevMate Inc. All rights reserved.
//

#import "DMKevlarApplication.h"

typedef BOOL (*DMKIsApplicationActivatedFunc)(NSInteger *);
DMKIsApplicationActivatedFunc _my_secret_activation_check;

typedef CFDictionaryRef (*DMKCopyLicenseUserInfoFunc)(void);
DMKCopyLicenseUserInfoFunc _my_secret_license_info_getter;

void InvalidateAppLicense(void);