//
//  DZAIOTableElement.m
//  Pods
//
//  Created by stonedong on 16/5/4.
//
//

#import "DZAIOTableElement.h"

@implementation DZAIOTableElement

- (void) scrollToEnd
{
    if (self.tableView) {
      NSInteger section = [self.tableView.dataSource numberOfSectionsInTableView:self.tableView];
        if (section == 0) {
            return;
        }
        NSInteger row = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:section -1];

        if (row == 0) {
            return;
        }
        NSIndexPath* indexpath = [NSIndexPath indexPathForRow:row-1 inSection:section-1];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
@end
