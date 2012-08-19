//
//  ORGMMenuDataSource.m
//  Origami
//
//  Created by ap4y on 8/18/12.
//
//

#import "ORGMMenuDataSource.h"

@interface ORGMMenuDataSource ()

@end

@implementation ORGMMenuDataSource

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    UIView *backView = [[UIView alloc] initWithFrame:cell.bounds];
    [backView setBackgroundColor:RGB(238, 238, 238)];
    [cell setBackgroundView:backView];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UIView *stripeView = [cell viewWithTag:2];
    UIButton *tapButton = (UIButton *)[cell viewWithTag:3];
    
    UIImage *backImage =
        [[UIImage imageNamed:@"nav_back"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:backImage]];

    
    switch (section) {
        case 0: {
            titleLabel.text = NSLocalizedString(@"Tracks", nil);
            stripeView.backgroundColor = RGB(0, 204, 238);
            tapButton.titleLabel.tag = 0;
            break;
        }
        case 1: {
            titleLabel.text = NSLocalizedString(@"Artists", nil);
            stripeView.backgroundColor = RGB(204, 0, 238);
            tapButton.titleLabel.tag = 1;
            break;
        }
        case 2: {
            titleLabel.text = NSLocalizedString(@"Albums", nil);
            stripeView.backgroundColor = RGB(238, 0, 204);
            tapButton.titleLabel.tag = 2;
            break;
        }
        case 3: {
            titleLabel.text = NSLocalizedString(@"Genres", nil);
            stripeView.backgroundColor = RGB(238, 204, 0);
            tapButton.titleLabel.tag = 3;
            break;
        }
        case 4: {
            titleLabel.text = NSLocalizedString(@"Sources", nil);
            stripeView.backgroundColor = RGB(204, 238, 0);
            tapButton.titleLabel.tag = 4;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

@end
