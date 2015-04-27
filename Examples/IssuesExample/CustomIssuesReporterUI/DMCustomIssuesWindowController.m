//
//  DMCustomIssuesWindowController.m
//  Examples
//
//  Created by Dmytro Tretiakov on 11/13/14.
//  Copyright (c) 2015 DevMate Inc. All rights reserved.
//

#import "DMCustomIssuesWindowController.h"

@implementation DMCustomIssuesWindowController

+ (instancetype)defaultController
{
    NSBundle *bundle = [NSBundle bundleForClass:[DMCustomIssuesWindowController class]];
    NSString *windowNibPath = [bundle pathForResource:@"DMCustomIssuesWindow" ofType:@"nib"];
    DMCustomIssuesWindowController *controller = nil;
    if (nil != windowNibPath)
    {
        controller = [self alloc];
        controller = [controller initWithWindowNibPath:windowNibPath owner:controller];
    }
    else
    {
        controller = [super defaultController];
    }
    return controller;
}

@end
