//
//  main.m
//  MainUpdaterExample
//
//  Created by Dmytro Tretiakov on 10/27/15.
//  Copyright © 2015 Dmytro Tretiakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DMHelperAppDelegate.h"

int main(int argc, const char * argv[]) {
    NSApplication *app = [NSApplication sharedApplication];
    DMHelperAppDelegate *appDelegate = [[DMHelperAppDelegate alloc] init];
    app.delegate = appDelegate;
    [app run];
    appDelegate = nil;
    return 0;
}
