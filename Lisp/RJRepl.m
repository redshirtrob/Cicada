//
//  RJRepl.m
//  Lisp
//
//  Created by Robert Jones on 1/8/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJRepl.h"
#import "RJEnv.h"
#import "RJSymbol.h"
#import "RJSymbolTable.h"
#import "NSError+RJLisp.h"

#define DefineSymbol(s, v)                      \
    do {                                        \
        v = _globalSymbolTable[s];              \
    } while (0)

@interface RJRepl ()

@property (nonatomic, strong) RJEnv *globalEnvironment;
@property (nonatomic, strong) RJSymbolTable *globalSymbolTable;

@end

@implementation RJRepl {
    RJSymbol *_quote;
    RJSymbol *_if;
    RJSymbol *_set;
    RJSymbol *_define;
    RJSymbol *_lambda;
    RJSymbol *_begin;
    RJSymbol *_defineMacro;
    RJSymbol *_quasiQuote;
    RJSymbol *_unquote;
    RJSymbol *_unquoteSplicing;
}

- (id)initWithPrompt:(NSString *)prompt
{
    self = [super init];
    if (self) {
        _prompt = prompt;

        [self initializeGlobalSymbolTable];

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
                    NSError *error = nil;
                    NSString *cleanedInput = [input stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    NSArray *sexp = [self parse:cleanedInput error:&error];

                    if (!sexp) {
                        [stdout writeData:[[NSString stringWithFormat:@"%@\n", error] dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                    else {
                        id value = [self eval:sexp error:&error];

                        if (!error) {
                            if (value) {
                                [stdout writeData:[[NSString stringWithFormat:@"%@\n", value] dataUsingEncoding:NSUTF8StringEncoding]];
                            }
                        }
                        else {
                            [stdout writeData:[[NSString stringWithFormat:@"%@\n", [error rjlispErrorString]] dataUsingEncoding:NSUTF8StringEncoding]];
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

- (void)initializeGlobalSymbolTable
{
    _globalSymbolTable = [[RJSymbolTable alloc] init];

    DefineSymbol(@"quote", _quote);
    DefineSymbol(@"if", _if);
    DefineSymbol(@"set!", _set);
    DefineSymbol(@"define", _define);
    DefineSymbol(@"lambda", _lambda);
    DefineSymbol(@"begin", _begin);
    DefineSymbol(@"define-macro", _defineMacro);
    DefineSymbol(@"quasiquote", _quasiQuote);
    DefineSymbol(@"unquote", _unquote);
    DefineSymbol(@"unquote-splicing", _unquoteSplicing);
}

- (id)eval:(id)sexp environment:(RJEnv *)environment error:(NSError **)error
{
    id value = nil;
    if ([sexp isKindOfClass:[NSString class]]) {
        value = [environment find:sexp][sexp];
        if (!value) {
            *error = [NSError rjlispUnboundSymbolError:sexp];
        }
    }
    else if (![sexp isKindOfClass:[NSArray class]]) {
        value = sexp;
    }
    else if (![sexp count]) {
        value = [NSNull null];
    }
    else if (![sexp[0] isKindOfClass:[NSString class]]) {
        *error = [NSError rjlispUnboundSymbolError:sexp[0]];
    }
    else if ([sexp[0] isEqualToString:@"quote"]) {
        if ([sexp count] == 2) {
            value = sexp[1];
        }
        else {
        }
    }
    else if ([sexp[0] isEqualToString:@"if"]) {
        id test = sexp[1];
        id conseq = sexp[2];
        id alt = sexp[3];
        id val = [self eval:test environment:environment error:error];
        if (!*error) {
            if (val != [NSNull null] && [val boolValue]) {
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
            *error = [NSError rjlispParseErrorWithString:@"Unexpected EOF"];
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
            *error = [NSError rjlispParseErrorWithString:[NSString stringWithFormat:@"Unexpected symbol: %@", token]];
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
