//
//  NSFileHandle+RJScheme.m
//  Cicada
//
//  Created by Robert Jones on 1/15/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "NSFileHandle+RJScheme.h"

@implementation NSFileHandle (RJScheme)

- (NSString *)readline
{
    NSMutableString *readline = [NSMutableString string];
    NSData *readData;

    BOOL done = NO;
    while (!done) {
        readData = [self readDataOfLength:1];
        if ([readData length]) {
            NSString *character = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
            [readline appendString:character];
            if ([character isEqualToString:@"\n"]) {
                done = YES;
            }
        }
        else {
            done = YES;
        }
    }
    return readline;
}

@end
