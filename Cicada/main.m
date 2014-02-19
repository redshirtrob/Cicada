//
//  main.m
//  Cicada
//
//  Created by Robert Jones on 1/8/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RJScheme.h"
#import "RJInPort.h"

int main(int argc, const char *argv[])
{
    @autoreleasepool {
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        NSArray *arguments = [processInfo arguments];

        RJScheme *lisp = [[RJScheme alloc] init];

        if ([arguments count] == 1) {
            [lisp replWithPrompt:@"> " inPort:[RJInPort inPortWithStandardInput] output:[NSFileHandle fileHandleWithStandardOutput]];
        }
        else {
            [lisp loadFile:arguments[1]];
        }
    }
    return 0;
}
