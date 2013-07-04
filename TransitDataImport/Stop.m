//
//  Stop.m
//  TransitDataImport
//
//  Created by Chris Eidhof on 6/16/13.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import "Stop.h"


@implementation Stop

@dynamic identifier;
@dynamic name;
@dynamic latitude;
@dynamic longitude;

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@ - %@ (%f, %f)>", [self class], self, self.identifier, self.name, self.latitude.doubleValue, self.longitude.doubleValue];
}

@end
