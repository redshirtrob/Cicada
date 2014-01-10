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
                    NSError *error;
                    NSString *cleanedInput = [input stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    NSArray *sexp = [self parse:cleanedInput error:&error];

                    if (!sexp) {
                        [stdout writeData:[[NSString stringWithFormat:@"Error: %@\n", error] dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                    else {
                        [stdout writeData:[[NSString stringWithFormat:@"%@\n", sexp] dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                    readDone = YES;
                }
            }
            else {
                done = readDone = YES;
            }
        }
    }
}

#pragma mark - Private

- (id)atom:(NSString *)token error:(NSError **)error
{
    id atom;
    int intValue;
    float floatValue;

    NSScanner *scanner = [NSScanner scannerWithString:token];
    if ([scanner scanInt:&intValue]) {
        atom = @(intValue);
    }
    else if ([scanner scanFloat:&floatValue]) {
        atom = @(floatValue);
    }
    else {
        atom = token;
    }

    return atom;
}

- (id)readFrom:(NSMutableArray *)tokens error:(NSError **)error
{
    if (![tokens count]) {
        if (error) {
            *error = [NSError errorWithDomain:@"Unexpected EOF" code:-1 userInfo:nil];
        }
        return nil;
    }

    NSString *token = [tokens objectAtIndex:0];
    [tokens removeObjectAtIndex:0];
    if ([token isEqualToString:@"("]) {
        NSMutableArray *array = [NSMutableArray array];

        while (![tokens[0] isEqualToString:@")"]) {
            id sexp = [self readFrom:tokens error:error];
            if (!sexp) {
                return nil;
            }
            [array addObject:sexp];
        }
        [tokens removeObjectAtIndex:0];

        return array;
    }
    else if ([token isEqualToString:@")"]) {
        if (error) {
            *error = [NSError errorWithDomain:[NSString stringWithFormat:@"Unexpected symbol: %@", token] code:-1 userInfo:nil];
        }
        return nil;
    }
    else {
        return [self atom:token error:error];
    }
}

- (NSArray *)parse:(NSString *)input error:(NSError **)error
{
    NSError *tmpError;
    NSArray *sexp = nil;

    NSArray *tokens = [self tokenize:input error:&tmpError];
    if (tokens) {
        sexp = [self readFrom:[NSMutableArray arrayWithArray:tokens] error:&tmpError];
        if (!sexp) {
            if (error) {
                *error = tmpError;
            }
        }
    }
    else {
        if (error) {
            *error = tmpError;
        }
    }

    return sexp;
}

- (NSArray *)tokenize:(NSString *)string error:(NSError **)error
{
    NSString *tmpString = [[string stringByReplacingOccurrencesOfString:@"(" withString:@" ( "]
                              stringByReplacingOccurrencesOfString:@")" withString:@" ) "];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.length > 0"];
    return [[tmpString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                filteredArrayUsingPredicate:predicate];
}

@end
