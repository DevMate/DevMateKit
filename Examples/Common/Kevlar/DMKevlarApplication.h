//
//  DMKevlarApplication.h
//  Kevlar
//
//  Copyright (c) 2012-2015 DevMate Inc. All rights reserved.
//

#ifndef DMKevlarApplication_h
#define DMKevlarApplication_h

#import <Cocoa/Cocoa.h>
#include <AvailabilityMacros.h>
#include <sys/types.h>
#include <sys/ptrace.h>

#define KEVLAR_VERSION  @"4.0.1"

// -------------------------------------------------------------------------------------------------
// SOME ADDITIONAL INLINE FUNCTIONS

NS_INLINE void DMKStopDebug(void)
{
#ifndef DEBUG
    ptrace(PT_DENY_ATTACH, 0, 0, 0);
#endif
}

//! CodeSign validation function that will raise an excetions in case when signature is wrong
#define DMKCheckBundleSignatureWithURL YZCyind0BnczglK
FOUNDATION_EXTERN void DMKCheckBundleSignatureWithURL(CFURLRef bundleURL, SecCSFlags validationFlags);

NS_INLINE void DMKCheckMainBundleSignature(void)
{
    CFURLRef mainBundleURL = CFBundleCopyBundleURL(CFBundleGetMainBundle());
    @try
    {
        DMKCheckBundleSignatureWithURL(mainBundleURL, kSecCSDefaultFlags);
    }
    @finally
    {
        CFRelease(mainBundleURL);
    }
}

// -------------------------------------------------------------------------------------------------

typedef NS_OPTIONS(NSUInteger, DMKLicenseStorageLocation)
{
    DMKLicenseStorageUnknown                = 0,
    DMKLicenseStoragePreferencesMask		= 1 << 0,
    DMKLicenseStorageApplicationSupportMask = 1 << 1,
    DMKLicenseStorageSharedMask             = 1 << 2, // to support in sandboxed app, add com.apple.security.temporary-exception.files.absolute-path.read-write with "/Users/Shared/" to your entitlements file
    DMKLicenseStorageKeychainMask           = 1 << 3, // !!! not supported yet
    
    DMKLicenseStorageAllMask                = DMKLicenseStoragePreferencesMask | DMKLicenseStorageApplicationSupportMask | DMKLicenseStorageSharedMask | DMKLicenseStorageKeychainMask
};

//! Activation info keys for activating product
FOUNDATION_EXTERN NSString *const DMKevlarRequestFullName; // NSString
FOUNDATION_EXTERN NSString *const DMKevlarRequestUserEmail; // NSString
FOUNDATION_EXTERN NSString *const DMKevlarRequestActivationKey; // NSString
FOUNDATION_EXTERN NSString *const DMKevlarRequestReactivationBundle; // NSString
FOUNDATION_EXTERN NSString *const DMKevlarRequestReactivationIdentifier; // NSString
FOUNDATION_EXTERN NSString *const DMKevlarRequestAdditionalInfo; // NSDictionary

//! License info keys
FOUNDATION_EXTERN NSString *const DMKevlarLicenseActivationIdKey; // NSString
FOUNDATION_EXTERN NSString *const DMKevlarLicenseUserNameKey; // NSString
FOUNDATION_EXTERN NSString *const DMKevlarLicenseUserEmailKey; // NSString
FOUNDATION_EXTERN NSString *const DMKevlarLicenseOrderDateKey; // NSDate
FOUNDATION_EXTERN NSString *const DMKevlarLicenseActivationDateKey; // NSDate
FOUNDATION_EXTERN NSString *const DMKevlarLicenseExpirationDateKey; // NSDate, may be absent in case of lifetime
FOUNDATION_EXTERN NSString *const DMKevlarLicenseExpirationVersionKey; // NSString, may be absent in case of lifetime
FOUNDATION_EXTERN NSString *const DMKevlarLicenseActivationTagKey; // NSString, may be absent
FOUNDATION_EXTERN NSString *const DMKevlarLicenseBetaOnlyKey; // NSNumber with BOOL
FOUNDATION_EXTERN NSString *const DMKevlarLicenseIsSubscriptionKey; // NSNumber with BOOL, may be nil
FOUNDATION_EXTERN NSString *const DMKevlarLicenseSubscriptionUpdateDateKey; // NSDate, last subscription charging date, may be nil
FOUNDATION_EXTERN NSString *const DMKevlarLicenseSubscriptionExpirationDateKey; // NSDate, date that subscription was charged to, may be nil
FOUNDATION_EXTERN NSString *const DMKevlarLicenseLastServerConnectionDateKey; // NSDate, date of last successfull connection date

//! Notifications
FOUNDATION_EXTERN NSString *const DMKBundleIntegrityDidChangeNotification;
FOUNDATION_EXTERN NSString *const DMKApplicationActivationStatusDidChangeNotification;


//! Function help with running timer for advanced check
#define DMKRunNewIntegrityCheckTimer QKXSP3p4bMy1gaB7V
FOUNDATION_EXTERN void DMKRunNewIntegrityCheckTimer(NSUInteger num, NSTimeInterval checkFrequency);

//! Checks if applicaion activated. Look for kevlar errors in \p DMKevlarErrors.h file
#define DMKIsApplicationActivated kNWqdwWHLzNhuRno1F
FOUNDATION_EXTERN BOOL DMKIsApplicationActivated(NSInteger *outKevlarError);

//! Returns user license info
#define DMKCopyLicenseUserInfo uLKp5Fep6U4dYMOIB0U
FOUNDATION_EXTERN CFDictionaryRef DMKCopyLicenseUserInfo(void) CF_RETURNS_RETAINED;

/**
 This catogory will extend functionality of NSApplication to be complies with Kevlar concept of protection. Rigth now, some helper inteface have been declare there, because it is kind of complicated to load category.
 */
#define com_devmate_Kevlar TNFeNKpWUX
@interface NSApplication (com_devmate_Kevlar)

/**
 Format of file, which have been used for store license information. Default is \p kCFPropertyListXMLFormat_v1_0.
 */
#define licenseStorageFormat NBAzLOWlL1Z
@property (nonatomic) NSPropertyListFormat licenseStorageFormat DEPRECATED_MSG_ATTRIBUTE("Property is not used for storing license info anymore.");

/**
 License could be store in different location, this option provied information to application, where to find and where to store license. Property is bitwise mask that used default `NSSearchPathDirectory` options by the next scheme:
 
 - `NSApplicationSupportDirectory` - ~/[USER]/Application Support/[APPNAME]/.license
 - `NSUserDirectory` - /Users/Shared/[APPNAME]/.license
 - `NSPreferencePanesDirectory` - use UserDefaults instead of file
 
 Default: `NSApplicationSupportDirectory | NSUserDirectory | NSPreferencePanesDirectory`
 */
#define licenseStoragePath tFYQCNPtBANX
@property (nonatomic) NSSearchPathDirectory licenseStoragePath DEPRECATED_MSG_ATTRIBUTE("Use licenseStorageLocation property instead.");

/**
 License could be store in different location, this option provied information to application, where to find and where to store license. Property is bitwise mask.
 Default is DMKLicenseStorageAllMask
 */
#define licenseStorageLocation qWHz9UXpT5tlxJ2aX
@property (nonatomic) DMKLicenseStorageLocation licenseStorageLocation;

/** 
 Indicate application activation status. This option is usefull for bindings. For more security use DMKIsApplicationActivated function.
 */
#define isActivated EFVu5S7DwBX1Bvx
@property (nonatomic, readonly) BOOL isActivated;

/**
 Return user-friendly information about license, with out any system information. For more security use DMKCopyLicenseUserInfo function.
 */
#define licenseUserInfo L9i87mCAjz11NU
@property (nonatomic, readonly) NSDictionary *licenseUserInfo;

/**
 Removes all license info on local storages and sends server request to deactivate it.
 In case, if license was invalidated, this method removes all license information
 */
#define invalidateLicense q9PJleYl0ZJ0H
- (void)invalidateLicense;

/** 
 Activate process 
 @param activationInfo data that will be used for action
 @param handler block will invoke to handle actiontion proccess
 */
- (void)activateWithInfo:(NSDictionary *)activationInfo completionHandler:(void (^)(BOOL success, NSError *error))handler;

/** 
 Setup public key
 @param publicKey String with public key
 */
#define setPublicKeyWithString Y5DinGDUuNDyGLjx
+ (void)setPublicKeyWithString:(NSString *)keyString;

@end

#endif // DMKevlarApplication_h
