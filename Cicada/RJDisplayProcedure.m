//
//  RJDisplayProcedure.m
//  Cicada
//
//  Created by Robert Jones on 2/26/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJScheme.h"
#import "RJDisplayProcedure.h"
#import "NSError+RJScheme.h"

@implementation RJDisplayProcedure

- (id)evalWithValues:(NSArray *)values error:(NSError **)error
{
    NSError *tmpError = nil;

    if ([values count]) {
        id displayValue = values[0];

        NSFileHandle *outputFileHandle;
        if ([values count] == 2) {
            outputFileHandle = values[1];
        }
        else {
            outputFileHandle = [NSFileHandle fileHandleWithStandardOutput];
        }

        if ([outputFileHandle isKindOfClass:[NSFileHandle class]]) {
            NSString *stringValue = [displayValue isKindOfClass:[NSString class]] ? displayValue : [RJScheme toString:displayValue];
            [outputFileHandle writeData:[[NSString stringWithFormat:@"%@", stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else {
            tmpError = [NSError rjschemeEvalErrorWithString:@"Display requires an instance of NSFileHandle for output."];
        }
    }
    else {
        tmpError = [NSError rjschemeTooFewArgumentsErrorForSymbol:@"display" atLeast:1 got:[values count]];
    }

    COPY_ERROR(error, tmpError);
    return nil;
}

@end
