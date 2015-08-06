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

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(com_mycompany_controlTextDidChange:)
                                                 name:NSControlTextDidChangeNotification
                                               object:self.userEmailField];
}


- (BOOL)hasUserEmail
{
    NSString *potentialEmail = self.userEmailField.stringValue;
    return DMIsEmailValid(&potentialEmail);
}

- (IBAction)sendReport:(id)sender
{
    if ([self hasUserEmail])
    {
        [super sendReport:sender];
    }
}

- (IBAction)sendAndRelaunch:(id)sender
{
    if ([self hasUserEmail])
    {
        [super sendAndRelaunch:sender];
    }
}

- (void)com_mycompany_controlTextDidChange:(NSNotification *)notification
{
    BOOL hasEmail = [self hasUserEmail];
    self.sendButton.enabled = hasEmail;
    self.sendRestartButton.enabled = hasEmail;
}

@end
