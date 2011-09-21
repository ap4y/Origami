//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "StyleSheet.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StyleSheet


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)font {
    return [UIFont fontWithName:@"Segoe UI" size:11];
}

-(UIColor *)backgroundColor {
    return RGB(230, 230, 230);
}

-(UIColor *)tablePlainBackgroundColor {
    return RGB(230, 230, 230);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableFont {    
    return [UIFont fontWithName:@"Segoe UI" size:11];
}

-(UITableViewCellSelectionStyle)tableSelectionStyle {
    return UITableViewCellSelectionStyleBlue;
}

-(UITableViewCellSeparatorStyle)tablePlainCellSeparatorStyle {
    return UITableViewCellSeparatorStyleNone;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (UIFont*)tableHeaderPlainFont {
//  return [UIFont fontWithName:@"Georgia" size:13];
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//-(UIFont*)titleFont {
//  return [UIFont fontWithName:@"Georgia-Bold" size:14];
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (UIColor*)tableGroupedBackgroundColor {
//  return RGBCOLOR(224, 221, 203);
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (UIColor*)tableHeaderTextColor {
//  return [UIColor brownColor];
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (UIColor*)tableHeaderTintColor {
//  return RGBCOLOR(224, 221, 203);
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)navigationBarTintColor {
  return [UIColor blackColor];
}


@end
