//
//  RJRepl.m
//  Lisp
//
//  Created by Robert Jones on 1/8/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJRepl.h"
#import "RJEnv.h"

@interface RJRepl ()

@property (nonatomic, strong) RJEnv *globalEnvironment;

@end

@implementation RJRepl

- (id)initWithPrompt:(NSString *)prompt
{
    self = [super init];
    if (self) {
        _prompt = prompt;
        _globalEnvironment = [[RJEnv alloc] init];
        [_globalEnvironment initialize];
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
                        NSError *error = nil;
                        id value = [self eval:sexp error:&error];

                        if (!error) {
                            [stdout writeData:[[NSString stringWithFormat:@"%@\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
                        }
                        else {
                            NSLog(@"%@", error);
                        }
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

- (id)eval:(id)sexp environment:(RJEnv *)environment error:(NSError **)error
{
    id value = nil;
    if ([sexp isKindOfClass:[NSString class]]) {
        value = [environment find:sexp][sexp];
    }
    else if (![sexp isKindOfClass:[NSArray class]]) {
        value = sexp;
    }
    else if ([sexp[0] isEqualToString:@"quote"]) {
        value = sexp[1];
    }
    else if ([sexp[0] isEqualToString:@"if"]) {
        id test = sexp[1];
        id conseq = sexp[2];
        id alt = sexp[3];
        id val = [self eval:test environment:environment error:error];
        if (!*error) {
            if (val) {
                value = [self eval:conseq environment:environment error:error];
            }
            else {
                value = [self eval:alt environment:environment error:error];
            }
        }
    }
    else if ([sexp[0] isEqualToString:@"set!"]) {
        id var = sexp[1];
        id exp = sexp[2];
        id val = [self eval:exp environment:environment error:error];
        if (!*error) {
            [environment find:var][var] = val;
        }
    }
    else if ([sexp[0] isEqualToString:@"define"]) {
        id var = sexp[1];
        id exp = sexp[2];
        id val = [self eval:exp environment:environment error:error];
        if (!*error) {
            environment[var] = val;
        }
    }
    else if ([sexp[0] isEqualToString:@"lambda"]) {
        id var = sexp[1];
        id exp = sexp[2];

        id __weak weakSelf = self;
        value = ^(NSArray *args, NSError **error) {
            RJEnv *lambdaEnv = [[RJEnv alloc] initWithParameters:var values:args outerEnvironment:environment];
            return [weakSelf eval:exp environment:lambdaEnv error:error];
        };
    }
    else if ([sexp[0] isEqualToString:@"begin"]) {
        for (NSInteger i = 1; i < [sexp count]; i++) {
            value = [self eval:sexp[i] environment:environment error:error];
            if (error) {
                break;
            }
        }
    }
    else {
        NSMutableArray *exps = [NSMutableArray array];

        id val = nil;
        for (id exp in sexp) {
            val = [self eval:exp environment:environment error:error];
            if (!*error) {
                [exps addObject:val];
            }
            else {
                break;
            }
        }

        if (!*error) {
            lambda proc = (lambda)exps[0];
            [exps removeObjectAtIndex:0];
            value = proc(exps, error);
        }
    }

    return value;
}

- (id)eval:(id)sexp error:(NSError **)error
{
    return [self eval:sexp environment:self.globalEnvironment error:error];
}

- (id)atom:(NSString *)token error:(NSError **)error
{
    id atom;
    float floatValue;

    NSScanner *scanner = [NSScanner scannerWithString:token];
    if ([scanner scanFloat:&floatValue]) {
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