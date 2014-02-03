//
//  RJEval.m
//  Lisp
//
//  Created by Robert Jones on 1/8/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJEval.h"
#import "RJEnv.h"
#import "RJSymbol.h"
#import "RJProcedure.h"
#import "RJInPort.h"
#import "RJSymbolTable.h"
#import "NSError+RJLisp.h"
#import "NSString+RJLisp.h"

@interface RJEval ()

@property (nonatomic, strong) RJEnv *globalEnvironment;
@property (nonatomic, strong) RJSymbolTable *globalSymbolTable;
@property (nonatomic, strong) NSMutableDictionary *macroTable;

@end

@implementation RJEval {
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
    RJSymbol *_cons;
    RJSymbol *_append;
    RJSymbol *_let;
    RJSymbol *_eof;

    NSDictionary *_quotes;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeGlobalSymbolTable];

        _globalEnvironment = [[RJEnv alloc] init];
        [_globalEnvironment initialize];

        _macroTable = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)replWithPrompt:(NSString *)prompt inPort:(RJInPort *)inPort output:(NSFileHandle *)output
{
    NSError *error;
    NSFileHandle *stderr = [NSFileHandle fileHandleWithStandardError];

    [stderr writeData:[@"RJLisp 2.0\n" dataUsingEncoding:NSUTF8StringEncoding]];
    while (YES) {
        if (prompt) {
            [stderr writeData:[[NSString stringWithFormat:@"%@", prompt] dataUsingEncoding:NSUTF8StringEncoding]];
        }

        error = nil;
        id sexp = [self parseFromInPort:inPort error:&error];
        if ([sexp isEqual:_eof]) {
            return;
        }

        id value = [self eval:sexp error:&error];
        if (!error) {
            if (value && value != [NSNull null]) {
                [output writeData:[[NSString stringWithFormat:@"%@\n", [self toString:value]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        else {
            [output writeData:[[NSString stringWithFormat:@"%@\n", [error rjlispErrorString]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
}

#pragma mark - Private

- (void)initializeGlobalSymbolTable
{
    _globalSymbolTable = [[RJSymbolTable alloc] init];

    _quote = self.globalSymbolTable[@"quote"];
    _if = self.globalSymbolTable[@"if"];
    _set = self.globalSymbolTable[@"set!"];
    _define = self.globalSymbolTable[@"define"];
    _lambda = self.globalSymbolTable[@"lambda"];
    _begin = self.globalSymbolTable[@"begin"];
    _defineMacro = self.globalSymbolTable[@"define-macro"];
    _quasiQuote = self.globalSymbolTable[@"quasiquote"];
    _unquote = self.globalSymbolTable[@"unquote"];
    _unquoteSplicing = self.globalSymbolTable[@"unquote-splicing"];
    _cons = self.globalSymbolTable[@"cons"];
    _append = self.globalSymbolTable[@"append"];
    _let = self.globalSymbolTable[@"let"];

    _quotes = @{@"'" : _quote, @"`" : _quasiQuote, @"," : _unquote, @",@" : _unquoteSplicing};

    _eof = [RJSymbol EOFSymbol];
}

- (NSString *)toString:(id)exp
{
    NSString *stringValue = nil;
    if ([exp isKindOfClass:[NSNumber class]]) {
        CFNumberRef number = (__bridge CFNumberRef)exp;
        if (number == (void *)kCFBooleanTrue) {
            stringValue = @"#t";
        }
        else if (number == (void *)kCFBooleanFalse) {
            stringValue = @"#f";
        }
        else {
            stringValue = [(NSNumber *)exp stringValue];
        }
    }
    else if ([exp isKindOfClass:[RJSymbol class]]) {
        stringValue = ((RJSymbol *)exp).name;
    }
    else if ([exp isKindOfClass:[NSString class]]) {
        stringValue = (NSString *)exp;
    }
    else if ([exp isKindOfClass:[NSArray class]]) {
        NSMutableString *string = [NSMutableString stringWithString:@""];
        for (id subExp in (NSArray *)exp) {
            [string appendFormat:@"%@ ", [self toString:subExp]];
        }
        if ([string length]) {
            [string deleteCharactersInRange:NSMakeRange([string length]-1, 1)];
        }
        stringValue = [NSString stringWithFormat:@"(%@)", string];
    }
    else {
        stringValue = [exp stringValue];
    }
    return stringValue;
}

- (id)eval:(id)sexp environment:(RJEnv *)environment error:(NSError **)error
{
    NSError *tmpError = nil;
    id value = nil;

    BOOL done = NO;
    while (!done) {
        if ([sexp isKindOfClass:[RJSymbol class]]) {
            value = [environment find:sexp][sexp];
            if (!value) {
                tmpError = [NSError rjlispUnboundSymbolError:sexp];
            }
            done = YES;
        }
        else if (![sexp isKindOfClass:[NSArray class]]) {
            value = sexp;
            done = YES;
        }
        else if (sexp[0] == _quote) {
            value = sexp[1];
            done = YES;
        }
        else if (sexp[0] == _if) {
            id test = sexp[1];
            id conseq = sexp[2];
            id alt = sexp[3];
            id val = [self eval:test environment:environment error:&tmpError];
            if ([val boolValue]) {
                value = [self eval:conseq environment:environment error:&tmpError];
            }
            else {
                value = [self eval:alt environment:environment error:&tmpError];
            }
            done = YES;
        }
        else if (sexp[0] == _set) {
            id var = sexp[1];
            id exp = sexp[2];
            id val = [self eval:exp environment:environment error:&tmpError];
            [environment find:var][var] = val;
            done = YES;
        }
        else if (sexp[0] == _define) {
            id var = sexp[1];
            id exp = sexp[2];
            id val = [self eval:exp environment:environment error:&tmpError];
            environment[var] = val;
            done = YES;
        }
        else if (sexp[0] == _lambda) {
            id vars = sexp[1];
            id exp = sexp[2];
            value = [[RJProcedure alloc] initWithParameters:vars expression:exp environment:environment repl:self];
            done = YES;
        }
        else if (sexp[0] == _begin) {
            for (NSInteger i = 1; i < [sexp count]-1; i++) {
                value = [self eval:sexp[i] environment:environment error:&tmpError];
            }
            sexp = sexp[[sexp count]-1];
        }
        else {
            NSMutableArray *exps = [NSMutableArray array];

            id val = nil;
            for (id exp in sexp) {
                val = [self eval:exp environment:environment error:&tmpError];
                if (!tmpError) {
                    [exps addObject:val];
                }
                else {
                    exps = nil;
                }
            }

            id proc = exps[0];
            [exps removeObjectAtIndex:0];
            if ([proc isKindOfClass:[RJProcedure class]]) {
                RJProcedure *tmpProc = (RJProcedure *)proc;
                sexp = tmpProc.expression;
                environment = [[RJEnv alloc] initWithParameters:tmpProc.parameters values:exps outerEnvironment:tmpProc.environment];
            }
            else if (proc) {
                value = ((lambda)proc)(exps, &tmpError);
                done = YES;
            }
            else {
                done = YES;
            }
        }
    }

    if (error && tmpError) {
        *error = tmpError;
    }

    return value;
}

- (id)eval:(id)sexp error:(NSError **)error
{
    return [self eval:sexp environment:self.globalEnvironment error:error];
}

- (id)atom:(id)token error:(NSError **)error
{
    id atom;

    if ([token isEqualToString:@"#t"]) {
        atom = @YES;
    }
    else if ([token isEqualToString:@"#f"]) {
        atom = @NO;
    }
    else if ([token hasPrefix:@"\""]) {
        atom = [[token substringWithRange:NSMakeRange(1, [token length]-2)] decodeBackslash];
    }
    else {
        float floatValue;

        NSScanner *scanner = [NSScanner scannerWithString:token];
        if ([scanner scanFloat:&floatValue]) {
            atom = @(floatValue);
        }
        else {
            atom = self.globalSymbolTable[token];
        }
    }
    return atom;
}

- (id)readAheadFromInPort:(RJInPort *)inPort token:(id)token error:(NSError **)error
{
    NSError *tmpError = nil;
    id value = nil;

    if ([token isEqualToString:@"("]) {
        BOOL done = NO;
        NSMutableArray *array = [NSMutableArray array];
        while (!done) {
            token = [inPort nextToken];
            if ([token isEqualToString:@")"]) {
                value = [NSArray arrayWithArray:array];
                done = YES;
            }
            else {
                token =[self readAheadFromInPort:inPort token:token error:&tmpError];
                if (token) {
                    [array addObject:token];
                }
                else {
                    value = nil;
                    done = YES;
                }
            }
        }
    }
    else if ([token isEqualToString:@")"]) {
        tmpError = [NSError rjlispParseErrorWithString:[NSString stringWithFormat:@"Unexpected symbol: %@", token]];
        value = nil;
    }
    else if ([[_quotes allKeys] indexOfObject:token] != NSNotFound) {
        id tmpToken = [self readFromInPort:inPort error:&tmpError];
        value = @[_quotes[token], tmpToken];
    }
    else if ([token isEqual:[RJSymbol EOFSymbol]]) {
        tmpError = [NSError rjlispParseErrorWithString:@"Unexpected EOF"];
        value = nil;
    }
    else {
        value = [self atom:token error:&tmpError];
    }

    if (error && tmpError) {
        *error = tmpError;
    }

    return value;
}

- (RJSymbol *)readFromInPort:(RJInPort *)inPort error:(NSError **)error
{
    id token = [inPort nextToken];
    if (token != [RJSymbol EOFSymbol]) {
        token = [self readAheadFromInPort:inPort token:token error:error];
    }
    return token;
}

- (id)expand:(id)exp topLevel:(BOOL)topLevel error:(NSError **)error
{
    NSError *tmpError;
    NSArray *sexp = (NSArray *)exp;
    id expandedExp = nil;

    if (![exp isKindOfClass:[NSArray class]]) {
        expandedExp = sexp;
    }
    else if (![sexp count]) {
        tmpError = [NSError rjlispParseErrorWithString:@"Invalid length"];
    }
    else if (sexp[0] == _quote) {
        if ([sexp count] != 2) {
            tmpError = [NSError rjlispParseErrorWithString:@"quote: Invalid length"];
        }
        else {
            expandedExp = sexp;
        }
    }
    else if (sexp[0] == _if) {
        if ([sexp count] == 3) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:sexp];
            [array addObject:[NSNull null]];
            sexp = [NSArray arrayWithArray:array];
        }
        if ([sexp count] != 4) {
            tmpError = [NSError rjlispParseErrorWithString:[NSString stringWithFormat:@"if: Invalid length '%@'", [self toString:exp]]];
        }
        else {
            // TODO: Map
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
            for (id exp in sexp) {
                id tmpExp = [self expand:exp topLevel:NO error:&tmpError];
                if (tmpError) {
                    array = nil;
                    break;
                }
                else {
                    [array addObject:tmpExp];
                }
            }
            if (array) {
                expandedExp = [NSArray arrayWithArray:array];
            }
        }
    }
   else if (sexp[0] == _set) {
        if ([sexp count] != 3) {
            tmpError = [NSError rjlispParseErrorWithString:@"Invalid length"];
        }
        else {
            RJSymbol *var = sexp[1];
            if (![var isKindOfClass:[RJSymbol class]]) {
                tmpError = [NSError rjlispParseErrorWithString:@"Can only set! a symbol"];
            }
            else {
                id tmpExp = [self expand:sexp[2] topLevel:NO error:&tmpError];
                if (tmpExp) {
                    expandedExp = @[_set, var, tmpExp];
                }
            }
        }
    }
    else if (sexp[0] == _define || sexp[0] == _defineMacro) {
        if ([sexp count] < 3) {
            tmpError = [NSError rjlispParseErrorWithString:@"Invalid length"];
        }
        else {
            id def = sexp[0];
            id v = sexp[1];
            id body = [sexp subarrayWithRange:NSMakeRange(2, [sexp count]-2)];
            if ([v isKindOfClass:[NSArray class]] && [((NSArray *)v) count]) {
                id f = v[0];
                id args = [v subarrayWithRange:NSMakeRange(1, [v count]-1)];
                NSMutableArray *tmpLambdaExp = [NSMutableArray arrayWithArray:@[_lambda, args]];
                [tmpLambdaExp addObjectsFromArray:body];
                NSArray *lambdaExp = [NSArray arrayWithArray:tmpLambdaExp];
                expandedExp = [self expand:@[def, f, lambdaExp] topLevel:NO error:&tmpError];
            }
            else {
                if ([sexp count] != 3) {
                    tmpError = [NSError rjlispParseErrorWithString:@"Invalid length"];
                }
                else if (![v isKindOfClass:[RJSymbol class]]) {
                    tmpError = [NSError rjlispParseErrorWithString:@"Can only define a symbol"];
                }
                else {
                    id exp = [self expand:sexp[2] topLevel:NO error:&tmpError];
                    if (def == _defineMacro) {
                        if (topLevel == NO) {
                            tmpError = [NSError rjlispParseErrorWithString:@"define-macro only allowed at top level"];
                        }
                        else {
                            RJProcedure *proc = [self eval:exp environment:self.globalEnvironment error:&tmpError];
                            if (![proc isKindOfClass:[RJProcedure class]]) {
                                tmpError = [NSError rjlispParseErrorWithString:@"macro must be a procedure"];
                            }
                            else {
                                self.macroTable[v] = proc;
                            }
                        }
                    }
                    else {
                        expandedExp = @[_define, v, exp];
                    }
                }
            }
        }
    }
    else if (sexp[0] == _begin) {
        if ([sexp count] > 1) {
            NSMutableArray *exps = [NSMutableArray arrayWithCapacity:[sexp count]];
            for (exp in sexp) {
                id tmpExp = [self expand:exp topLevel:topLevel error:&tmpError];
                if (tmpError) {
                    exps = nil;
                    break;
                }
                else {
                    [exps addObject:tmpExp];
                }
            }
            if (exps) {
                expandedExp = [NSArray arrayWithArray:exps];
            }
        }
    }
    else if (sexp[0] == _lambda) {
        if ([sexp count] < 3) {
            tmpError = [NSError rjlispParseErrorWithString:@"lambda missing parameter list or body"];
        }
        else {
            NSArray *vars = sexp[1];
            id body = [sexp subarrayWithRange:NSMakeRange(2, [sexp count]-2)];

            BOOL valid = YES;
            if ([vars isKindOfClass:[NSArray class]]) {
                for (RJSymbol *symbol in vars) {
                    if (![symbol isKindOfClass:[RJSymbol class]]) {
                        valid = NO;
                    }
                }
            }
            else {
                if (![vars isKindOfClass:[RJSymbol class]]) {
                    valid = NO;
                }
            }

            if (valid) {
                id exp = [body count] == 1 ? body[0] : @[_begin, body];
                id tmpExp = [self expand:exp topLevel:NO error:&tmpError];
                expandedExp = @[_lambda, vars, tmpExp];
            }
            else {
                tmpError = [NSError rjlispParseErrorWithString:@"illegal lambda argument list"];
            }
        }
    }
    else if (sexp[0] == _quasiQuote) {
        if ([sexp count] != 2) {
            tmpError = [NSError rjlispParseErrorWithString:@"Invalid length"];
        }
        else {
            expandedExp = [self expandQuasiQuote:sexp[1] error:&tmpError];
        }
    }
    else if ([sexp[0] isKindOfClass:[RJSymbol class]] && self.macroTable[sexp[0]]) {
        id tmpExp = nil;
        NSArray *args = [sexp subarrayWithRange:NSMakeRange(1, [sexp count]-1)];
        id callable = self.macroTable[sexp[0]];
        if ([callable isKindOfClass:[RJProcedure class]]) {
            tmpExp = [((RJProcedure *)callable) evalWithValues:args error:&tmpError];
        }
        else {
            tmpExp = ((lambda)callable)(args, &tmpError);
        }
        expandedExp = [self expand:tmpExp topLevel:topLevel error:error];
    }
    else {
        // TODO: Map
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[sexp count]];
        for (id exp in sexp) {
            id tmpExp = [self expand:exp topLevel:NO error:&tmpError];
            if (tmpExp) {
                [array addObject:tmpExp];
            }
            else {
                array = nil;
            }
        }
        if (array) {
            expandedExp = [NSArray arrayWithArray:array];
        }
    }

    if (error && tmpError) {
        *error = tmpError;
    }

    return expandedExp;
}

#define IsPair(x) ([(x) isKindOfClass:[NSArray class]] && [((NSArray *)(x)) count])

- (id)expandQuasiQuote:(id)exp error:(NSError **)error
{
    NSError *tmpError = nil;
    id expandedExp = nil;
    if (!IsPair(exp)) {
        expandedExp =  @[_quote, exp];
    }
    else {
        NSArray *sexp = (NSArray *)exp;
        if (sexp[0] == _unquoteSplicing) {
            tmpError = [NSError rjlispParseErrorWithString:@"can't splice here'"];
        }
        else {
            if (sexp[0] == _unquote) {
                if ([sexp count] == 2) {
                    expandedExp = sexp[1];
                }
                else {
                    tmpError = [NSError rjlispParseErrorWithString:@"Invalid length"];
                }
            }
            else if (IsPair(sexp[0]) && sexp[0][0] == _unquoteSplicing) {
                if ([sexp[0] count] == 2) {
                    id tmpQuasiQuote = [self expandQuasiQuote:[sexp subarrayWithRange:NSMakeRange(1, [sexp count]-1)] error:&tmpError];
                    expandedExp = @[_append, sexp[0][1], tmpQuasiQuote];
                }
                else {
                    tmpError = [NSError rjlispParseErrorWithString:@"Invalid length"];
                }
            }
            else {
                id tmpQuasiQuotePrefix = [self expandQuasiQuote:sexp[0] error:&tmpError];
                id tmpQuasiQuoteSuffix = [self expandQuasiQuote:[sexp subarrayWithRange:NSMakeRange(1, [sexp count]-1)] error:&tmpError];
                expandedExp = @[_cons, tmpQuasiQuotePrefix, tmpQuasiQuoteSuffix];
            }
        }
    }

    if (error && tmpError) {
        *error = tmpError;
    }

    return expandedExp;
}

- (id)parseFromInPort:(RJInPort *)inPort error:(NSError **)error
{
    NSError *tmpError = nil;

    id sexp = [self readFromInPort:inPort error:&tmpError];
    if (!*error) {
        sexp = [self expand:sexp topLevel:YES error:&tmpError];
    }

    if (error && tmpError) {
        *error = tmpError;
    }

    return sexp;
}

@end