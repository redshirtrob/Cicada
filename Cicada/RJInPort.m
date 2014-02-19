//
//  RJInPort.m
//  Cicada
//
//  Created by Robert Jones on 1/15/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import "RJInPort.h"
#import "RJSymbol.h"
#import "NSFileHandle+RJScheme.h"
#import "NSMutableString+RJScheme.h"

/*
 * Peter Norvig's Lisp Regex
 *
 *                    1            3              3                    1
 * tokenizer = r'''\s*(,@|[('`,)]|"(?:[\\].|[^\\"])*"|;.*|[^\s('"`,;)]*)(.*)'''
 *                        2     2     4  4  5    5        6          6  7  7
 *
 * Briefly this means match:
 *  - Any number of whitespace characters, followed by
 *  - One of (Capturing):
 *    - ',@' (Lisp ,@exp form)
 *    - Either a left parenthesis ((), single quote ('), backtick (`), comma (,) or right parenthesis ()) character
 *    - A double quote (") followed by zero or more of the following and closed with another double quote ("):
 *      - A backslash (\) followed by a single character, or
 *      - A non backslash character
 *    - A semicolon (;) followed by zero or more characters
 *    - Zero or more characters that are not one of the followinjg:
 *      - Whitespace
 *      - Left parenthesis (()
 *      - Single quote (')
 *      - Double quote (")
 *      - Backtick (`)
 *      - Comma (,)
 *      - Semicolon (;)
 *      - Right parenthesis ())
 *  - Zero or more characters (Capturing)
 */

static NSString *const PNTokenizerRegEx = @"\\s*(,@|[('`,)]|\"(?:[\\\\].|[^\\\\\"])*\"|;.*|[^\\s('\"`,;)]*)(.*)";

typedef NS_ENUM(NSInteger, RJInPortType) {
    RJInPortFileType,
    RJInPortStringType,
};

@interface RJInPort ()

@property (nonatomic) RJInPortType type;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, strong) NSMutableString *inputString;
@property (nonatomic, strong) NSString *line;
@property (nonatomic, strong) NSRegularExpression *regex;

@end

@implementation RJInPort

+ (instancetype)inPortWithStandardInput
{
    return [[RJInPort alloc] initWithFileHandle:[NSFileHandle fileHandleWithStandardInput]];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _line = @"";
        NSError *error;
        _regex = [NSRegularExpression regularExpressionWithPattern:PNTokenizerRegEx options:0 error:&error];
        if (error) {
            NSLog(@"%@", error);
            self = nil;
        }
    }
    return self;
}

- (instancetype)initWithFileHandle:(NSFileHandle *)fileHandle
{
    self = [self init];
    if (self) {
        _fileHandle = fileHandle;
        _type = RJInPortFileType;

    }
    return self;
}

- (instancetype)initWithInputString:(NSString *)inputString
{
    self = [self init];
    if (self) {
        _inputString = [NSMutableString stringWithString:inputString];
        _type = RJInPortStringType;
    }
    return self;
}

- (NSString *)readline
{
    NSString *line = nil;
    switch (self.type) {
    case RJInPortFileType:
        line = [self.fileHandle readline];
        break;
    case RJInPortStringType:
        line = [self.inputString readline];
        break;
    }
    return line;
}

- (id)nextToken
{
    while (YES) {
        if (![self.line length]) {
            self.line = [self readline];
        }
        if (![self.line length]) {
            return [RJSymbol EOFSymbol];
        }

        NSTextCheckingResult *match = [self.regex firstMatchInString:self.line options:0 range:NSMakeRange(0, [self.line length])];
        if (match) {
            NSRange range = [match rangeAtIndex:1];
            NSString *token = [self.line substringWithRange:range];

            range = [match rangeAtIndex:2];
            self.line = [self.line substringWithRange:range];

            if ([token length] && ![token hasPrefix:@";"]) {
                return token;
            }
        }
    }
    return nil;
}

@end
