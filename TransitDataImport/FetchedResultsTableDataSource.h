//
// Created by chris on 6/16/13.
//

#import <Foundation/Foundation.h>

typedef void (^ConfigureBlock)(id cell, id item);

@interface FetchedResultsTableDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, copy) ConfigureBlock configureCellBlock;

- (id)initWithTableView:(UITableView*)aTableView fetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController;
- (void)changePredicate:(NSPredicate*)predicate;
- (id)selectedItem;

@end