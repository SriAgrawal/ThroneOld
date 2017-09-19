//
//  IndexPathButton.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "IndexPathButton.h"

@implementation IndexPathButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self defaultSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    if(self){
        
        [self defaultSetup];
        
    }
    return self;
}

#pragma mark - Private methods

- (void)defaultSetup {
    [self setExclusiveTouch:YES];
}


+(IndexPathButton*) underlinedButton {
    IndexPathButton* button = [[IndexPathButton alloc] init];
    return button;
}

- (void) drawRect:(CGRect)rect {
    
    CGRect textRect = self.titleLabel.frame;
    CGFloat padding = 0.0;
    if (self.currentTitle.length) {
        NSString * lastChe = [self.currentTitle substringFromIndex:self.currentTitle.length-2];
        if ([lastChe isEqualToString:@", "]) {
            textRect.size.width = textRect.size.width-4;
            padding = 2.0;
        }
    }

    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x+padding, textRect.origin.y + textRect.size.height + descender+2.4);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width-1, textRect.origin.y + textRect.size.height + descender+2.4);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}


@end
