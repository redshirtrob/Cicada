//
//  main.m
//  Lisp
//
//  Created by Robert Jones on 1/8/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RJEval.h"
#import "RJInPort.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        RJEval *repl = [[RJEval alloc] init];
        [repl replWithPrompt:@"> " inPort:[RJInPort inPortWithStandardInput] output:[NSFileHandle fileHandleWithStandardOutput]];
    }
    return 0;
}
