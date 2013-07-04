//
//  Stop.h
//  TransitDataImport
//
//  Created by Chris Eidhof on 6/16/13.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stop : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
