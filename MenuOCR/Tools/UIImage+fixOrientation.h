//
//  UIImage+fixOrientation.h
//  RoadTrip
//
//  Created by Yi Qin on 5/29/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>

// http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
@interface UIImage (FixOrientation)

- (UIImage *)fixOrientation;

@end
