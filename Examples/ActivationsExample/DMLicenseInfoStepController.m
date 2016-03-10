//
//  DMLicenseInfoStepController.m
//  Examples
//
//  Created by Dmytro Tretiakov on 11/14/14.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

#import "DMLicenseInfoStepController.h"
#import "DMKevlarApplication.h"

@interface DMLicenseInfoStepController ()

@property (unsafe_unretained) IBOutlet NSTextField *userName;
@property (unsafe_unretained) IBOutlet NSTextField *userEmail;
@property (unsafe_unretained) IBOutlet NSTextField *licenseId;

@end

@implementation DMLicenseInfoStepController

- (void)restoreState:(NSDictionary *)saveContainer
{
    if ([NSApp isActivated])
    {
        NSDictionary *userLicense = [NSApp licenseUserInfo];
        self.userName.stringValue = [[userLicense objectForKey:DMKevlarLicenseUserNameKey] length] ? [userLicense objectForKey:DMKevlarLicenseUserNameKey] : @"Unknown";
        self.userEmail.stringValue = [[userLicense objectForKey:DMKevlarLicenseUserEmailKey] length] ? [userLicense objectForKey:DMKevlarLicenseUserEmailKey] : @"Unknown";
        self.licenseId.stringValue = [userLicense objectForKey:DMKevlarLicenseActivationIdKey] ? : @"Unknown";
    }
}


@end
