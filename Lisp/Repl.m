//
//  Repl.m
//  Lisp
//
//  Created by Robert Jones on 1/8/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "Repl.h"

@implementation Repl

- (id)initWithPrompt:(NSString *)prompt
{
    self = [super init];
    if (self) {
        _prompt = prompt;
    }
    return self;
}

- (void)run
{
    BOOL done = NO;

    NSFileHandle *stdin = [NSFileHandle fileHandleWithStandardInput];
    NSFileHandle *stdout = [NSFileHandle fileHandleWithStandardOutput];
    while (!done) {
        [stdout writeData:[self.prompt dataUsingEncoding:NSUTF8StringEncoding]];

        NSMutableString *input = [NSMutableString string];
        BOOL readDone = NO;
        while (!readDone) {
            NSData *inputData = [stdin readDataOfLength:1];
            if ([inputData length]) {
                NSString *tmpString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
                [input appendString:tmpString];

                NSRange range = [input rangeOfString:@"\n"];
                if (range.location != NSNotFound) {
                    [stdout writeData:[input dataUsingEncoding:NSUTF8StringEncoding]];
                    readDone = YES;
                }
            }
            else {
                done = readDone = YES;
            }
        }
    }
}

@end
