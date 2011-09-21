//
//  CustomTableFlushViewCell.m
//  Sample
//
//  Created by Arthur Evstifeev on 25.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTableFlushViewCell.h"

@implementation CustomTableFlushViewCell

+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    //return 300.0;
    return ((UIView *)object).frame.size.height;
}

@end
