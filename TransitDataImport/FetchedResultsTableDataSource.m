//
// Created by chris on 6/16/13.
//

#import "FetchedResultsTableDataSource.h"


@interface FetchedResultsTableDataSource () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation FetchedResultsTableDataSource
{

}

- (id)initWithTableView:(UITableView*)aTableView fetchedResultsController:(NSFetchedResultsController*)aFetchedResultsController
{
    self = [super init];
    if(self) {
        self.tableView = aTableView;
        self.fetchedResultsController = aFetchedResultsController;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.tableView.dataSource = self;
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:NULL];
}

- (void)changePredicate:(NSPredicate*)predicate {
    NSAssert(self.fetchedResultsController.cacheName == NULL, @"Can't change predicate when you have a caching fetched results controller");
    NSFetchRequest* fetchRequest = self.fetchedResultsController.fetchRequest;
    fetchRequest.predicate = predicate;
    NSInteger numberOfSections = self.tableView.numberOfSections;
    [self.fetchedResultsController performFetch:NULL];
    NSInteger newNumberOfSections = self.fetchedResultsController.sections.count;
    [self.tableView reloadData];
}

- (id)itemAtIndexPath:(NSIndexPath*)path {
    return [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:path.row inSection:path.section]];
}

- (id)selectedItem {
    return [self itemAtIndexPath:[self.tableView indexPathForSelectedRow]];
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)path {
    id item = [self itemAtIndexPath:path];
    if(self.configureCellBlock) {
        self.configureCellBlock(cell, item);
    }
}

#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView*)aTableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView*)aTableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger i = [self.fetchedResultsController.sections[(NSUInteger) section] numberOfObjects];
    return i;
}

- (NSString*)tableView:(UITableView*)aTableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> info = [self.fetchedResultsController sections][(NSUInteger) section];
    return info.name;
}

- (UITableViewCell*)tableView:(UITableView*)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            if([self.tableView.indexPathsForVisibleRows indexOfObject:indexPath] != NSNotFound) {
                [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            }
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

@end