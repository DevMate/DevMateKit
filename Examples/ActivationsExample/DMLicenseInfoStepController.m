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

@property (weak) IBOutlet NSTextField *userName;
@property (weak) IBOutlet NSTextField *userEmail;
@property (weak) IBOutlet NSTextField *licenseId;

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
