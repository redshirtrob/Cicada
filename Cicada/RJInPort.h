//
//  RJInPort.h
//  Cicada
//
//  Created by Robert Jones on 1/15/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJInPort : NSObject

+ (instancetype)inPortWithStandardInput;

- (instancetype)initWithFileHandle:(NSFileHandle *)fileHandle;
- (instancetype)initWithInputString:(NSString *)inputString;

- (id)nextToken;

@end
