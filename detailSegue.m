//
//  detailSegue.m
//  FinalSketch
//
//  Created by XiaoYifan on 2/28/15.
//  Copyright (c) 2015 xiaoyifan. All rights reserved.
//

#import "detailSegue.h"

@implementation detailSegue
- (void)perform{
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    
    [srcViewController presentViewController:destViewController animated:NO completion:nil];
}

//- (void)perform {
//    UIViewController *sourceViewController = self.sourceViewController;
//    UIViewController *destinationViewController = self.destinationViewController;
//    
//    // Add the destination view as a subview, temporarily
//    [sourceViewController.view addSubview:destinationViewController.view];
//    
//    // Transformation start scale
//    destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    
//    // Store original centre point of the destination view
//    CGPoint originalCenter = destinationViewController.view.center;
//    // Set center to start point of the button
//    destinationViewController.view.center = self.originatingPoint;
//    
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options:UIViewAnimationOptionTransitionFlipFromRight
//                     animations:^{
//                         // Grow!
//                         destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                         destinationViewController.view.center = originalCenter;
//                     }
//                     completion:^(BOOL finished){
//                         [destinationViewController.view removeFromSuperview]; // remove from temp super view
//                         [sourceViewController presentViewController:destinationViewController animated:NO completion:NULL]; // present VC
//                     }];
//}

@end
