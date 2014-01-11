//
//  main.m
//  Lisp
//
//  Created by Robert Jones on 1/8/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RJRepl.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        RJRepl *repl = [[RJRepl alloc] initWithPrompt:@"rjlisp> "];
        [repl run];
    }
    return 0;
}
