//
// ASJTag.m
//
// Copyright (c) 2016 Sudeep Jaiswal
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ASJTag.h"

@interface ASJTag ()

@property (weak, nonatomic) IBOutlet UIButton *tagButton;

- (IBAction)tagTapped:(UIButton *)sender;

@end

@implementation ASJTag

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (NSBundle *)tagsBundle
{
  return [NSBundle bundleForClass:[self class]];
}

#pragma mark - IBActions

- (IBAction)tagTapped:(UIButton *)sender
{
  if (_tapBlock) {
    _tapBlock(sender.titleLabel.text, self.tag);
  }
}

#pragma mark - Property setters

- (void)setTagText:(NSString *)tagText
{
  if (!tagText) {
    return;
  }
  _tagText = tagText;
  
  [UIView performWithoutAnimation:^{
    [_tagButton setTitle:tagText forState:UIControlStateNormal];
    [_tagButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_tagButton layoutIfNeeded];
  }];
}

- (void)setTagTextColor:(UIColor *)tagTextColor
{
  if (!tagTextColor) {
    return;
  }
  _tagTextColor = tagTextColor;
  [_tagButton setTitleColor:tagTextColor forState:UIControlStateNormal];
}

- (void)setTagFont:(UIFont *)tagFont
{
  if (!tagFont) {
    return;
  }
  _tagFont = tagFont;
  _tagButton.titleLabel.font = tagFont;
}

@end
