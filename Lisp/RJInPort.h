//
//  RJInPort.h
//  Lisp
//
//  Created by Robert Jones on 1/15/14.
//  Copyright (c) 2014 Robert Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RJSymbol.h"

@interface RJInPort : NSObject

+ (instancetype)inPortWithStandardInput;

- (instancetype)initWithFileHandle:(NSFileHandle *)fileHandle;

- (RJSymbol *)nextToken;

@end
