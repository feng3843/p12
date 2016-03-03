//
//  OrderCell.m
//  FlashTag
//
//  Created by MingleFu on 15/10/23.
//  Copyright © 2015年 Puyun. All rights reserved.
//

#import "OrderCell.h"
#import "UIView+AutoLayout.h"

@implementation OrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = PYColor(@"ffffff");
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = PYColor(@"cccccc").CGColor;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setFlowLayout:(OrderFlowLayout *)flowLayout
{
    _flowLayout = flowLayout;
    
    if (self.flowLayout.topType != OrderFlowLayoutTypeTopZero)
    {
        self.userHeadImageView.frame = CGRectMake(0, kCalculateV(15), kCalculateV(25), kCalculateV(25));
        self.userHeadImageView.center = CGPointMake(self.userHeadImageView.center.x, kCalculateV(44)*0.5);
        self.userHeadImageView.layer.masksToBounds = YES;
        self.userHeadImageView.layer.cornerRadius = kCalculateV(25)/2;
        
        self.userName.frame = CGRectMake(CGRectGetMaxX(self.userHeadImageView.frame) + kCalculateH(10), 0, kCalculateH(60), kCalculateV(44));
        self.userName.font = [UIFont systemFontOfSize:kCalculateH(12)];
        self.userName.textColor = PYColor(@"222222");
        [self.userName sizeToFit];
        self.userName.center = CGPointMake(self.userName.center.x, kCalculateV(44*0.5));
        
        if(self.arrowImageView)
        {
            self.arrowImageView.frame = CGRectMake(CGRectGetMaxX(self.userName.frame), CGRectGetMinY(self.userHeadImageView.frame), kCalculateH(26), kCalculateV(26));
            self.arrowImageView.image = [UIImage imageNamed:@"ic_search_tag"];
        }
        self.btnGotoUserCenter.frame = CGRectMake(kCalculateH(15), 0,CGRectGetMaxX(self.arrowImageView.frame), kCalculateV(44));
        
        if (self.flowLayout.topType == OrderFlowLayoutTypeTopOneRed) {
            if (self.stateLabel) {
                self.stateLabel.frame = CGRectMake(kCalculateH(CGRectGetMaxX(self.arrowImageView.frame))+kCalculateH(15), 0, fDeviceWidth - kCalculateH(CGRectGetMaxX(self.arrowImageView.frame))-kCalculateH(15)*2, kCalculateV(44));
                self.stateLabel.textColor = PYColor(@"f24949");
                self.stateLabel.font = [UIFont systemFontOfSize:12];
                self.stateLabel.textAlignment = NSTextAlignmentRight;
            }
        }
        
        if (self.divideUpView) {
            self.divideUpView.frame = CGRectMake(kCalculateH(15), kCalculateV(44), fDeviceWidth - 2*kCalculateH(15), kCalculateV(0.5));
            self.divideUpView.backgroundColor = PYColor(@"cccccc");
        }
    }
    
    if (self.flowLayout.middleType != OrderFlowLayoutTypeMiddleZero) {
        CGFloat postImageSize = kCalculateH(60);
        CGFloat detailLabelWidth = fDeviceWidth - kCalculateH(60) - 2*kCalculateH(15) - kCalculateH(10);
        self.postImageView.frame = CGRectMake(kCalculateH(15), CGRectGetMaxY(self.divideUpView.frame) + kCalculateV(16), postImageSize, postImageSize);
        
        self.postImageView.layer.masksToBounds = YES;
        self.postImageView.layer.cornerRadius = kCalculateH(4);
        
        if (self.flowLayout.middleType == OrderFlowLayoutTypeMiddleTwo)
        {
            self.detailLabel.numberOfLines = 1;
        }
        else
        {
            self.detailLabel.numberOfLines = 2;
        }
        
        self.detailLabel.frame = CGRectMake(CGRectGetMaxX(self.postImageView.frame) + kCalculateH(10), CGRectGetMinY(self.divideUpView.frame) + kCalculateV(20), detailLabelWidth, kCalculateV(self.detailLabel.numberOfLines*15));
        self.detailLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
        self.detailLabel.textColor = PYColor(@"515151");
        
        NSString* strKey;
        if (self.flowLayout.middleType == OrderFlowLayoutTypeMiddleOne||self.flowLayout.middleType == OrderFlowLayoutTypeMiddleOneRed) {
            strKey = @"订金: ";
        }
        else
        if (self.flowLayout.middleType == OrderFlowLayoutTypeMiddleTwo) {
            strKey = @"支付: ";
            //时间标签
            UILabel *timeLabel = self.timeLabel;
            timeLabel.frame = CGRectMake(CGRectGetMinX(self.detailLabel.frame), CGRectGetMaxY(self.divideUpView.frame) + kCalculateV(39), kCalculateH(30), kCalculateV(12));
            timeLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
            timeLabel.textColor = PYColor(@"999999");
            [self.timeLabel sizeToFit];
            //状态
            UILabel *stateLabel = self.stateLabel;
            stateLabel.frame = CGRectMake(kCalculateV(CGRectGetWidth(self.contentView.frame)-(30+15)), kCalculateV(CGRectGetMaxY(self.divideUpView.frame)), kCalculateH(30), kCalculateV(12));
            stateLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
            stateLabel.textColor = PYColor(@"f24949");
            [self.stateLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [self.stateLabel autoPinEdge:(ALEdgeRight) toEdge:ALEdgeRight ofView:stateLabel.superview withOffset:-15];
        }
        
        UILabel *pLabel = self.pLabel;
        pLabel.frame = CGRectMake(CGRectGetMinX(self.detailLabel.frame), CGRectGetMaxY(self.divideUpView.frame) + kCalculateV(57), kCalculateH(30), kCalculateV(12));
        pLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
        pLabel.textColor = PYColor(@"999999");
        pLabel.text = strKey;
        [self.pLabel sizeToFit];
        
        self.priceLabel.frame = CGRectMake(CGRectGetMaxX(pLabel.frame), CGRectGetMinY(pLabel.frame), 50, CGRectGetHeight(pLabel.frame));
        self.priceLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(12)];
        self.priceLabel.textColor = PYColor(@"222222");
        [self.priceLabel sizeToFit];
        
        if (self.flowLayout.middleType == OrderFlowLayoutTypeMiddleOneRed)
        {
            UILabel *rLabel = self.rLabel;
            rLabel.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame) + kCalculateH(10), CGRectGetMinY(self.priceLabel.frame), kCalculateH(30), kCalculateV(12));
            rLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
            rLabel.textColor = PYColor(@"999999");
            rLabel.text = @"退款: ";
            [self.rLabel sizeToFit];
            
            self.refundLabel.frame = CGRectMake(CGRectGetMaxX(rLabel.frame), CGRectGetMinY(rLabel.frame), 50, kCalculateV(12));
            _refundLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(12)];
            _refundLabel.textColor = PYColor(@"f24949");
            [self.refundLabel sizeToFit];
        }
    }
    
    if (self.flowLayout.bottomType != OrderFlowLayoutTypeBottomZero) {
        UIView *lastDivideLine = self.divideDownView;
        if (lastDivideLine)
        {
            lastDivideLine.frame = CGRectMake(kCalculateH(15), kCalculateV(CGRectGetMaxY(self.divideUpView.frame)+ 91), fDeviceWidth - 2*kCalculateH(15), kCalculateV(0.5));
            lastDivideLine.backgroundColor = PYColor(@"cccccc");
        }
        
        {
            self.leftButton.hidden = YES;
            
            self.rightButton.frame = CGRectMake(fDeviceWidth - kCalculateH(70+15), CGRectGetMaxY(lastDivideLine.frame) + kCalculateV((43 - 24)*0.5), kCalculateH(70), kCalculateV(24));
            self.rightButton.layer.borderWidth = 1;
            self.rightButton.layer.masksToBounds = YES;
            self.rightButton.layer.cornerRadius = kCalculateH(3);
            self.rightButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
            
            if (self.flowLayout.bottomType == OrderFlowLayoutTypeBottomOneRed||self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoGrayRed||self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoRedRed) {
                    self.rightButton.layer.borderColor = PYColor(@"f24949").CGColor;
                    [self.rightButton setTitleColor:PYColor(@"f24949") forState:UIControlStateNormal];
            }
            else if (self.flowLayout.bottomType == OrderFlowLayoutTypeBottomOneGray||self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoGrayGray||self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoRedGray) {
                self.rightButton.layer.borderColor = PYColor(@"999999").CGColor;
                [self.rightButton setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
            }
            
            if (self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoGrayGray||self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoGrayRed||self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoRedRed||self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoRedGray) {
                self.leftButton.hidden = NO;
                self.leftButton.frame = CGRectMake(kCalculateH(CGRectGetMinX(self.rightButton.frame)-8-70), CGRectGetMinY(self.rightButton.frame), kCalculateH(70), kCalculateV(24));
                self.leftButton.layer.borderWidth = 1;
                self.leftButton.layer.masksToBounds = YES;
                self.leftButton.layer.cornerRadius = kCalculateH(3);
                self.leftButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
                if (self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoRedRed||self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoRedGray) {
                    self.leftButton.layer.borderColor = PYColor(@"f24949").CGColor;
                    [self.leftButton setTitleColor:PYColor(@"f24949") forState:UIControlStateNormal];
                }
                else if (self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoGrayGray||self.flowLayout.bottomType == OrderFlowLayoutTypeBottomTwoGrayRed)
                {
                    self.leftButton.layer.borderColor = PYColor(@"999999").CGColor;
                    [self.leftButton setTitleColor:PYColor(@"666666") forState:UIControlStateNormal];
                }
            }
        }
    }
}


//延迟加载
-(UIImageView*)userHeadImageView
{
    if (!_userHeadImageView) {
        UIImageView* userHeadImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.userHeadImageView = userHeadImageView;
        if (self.btnGotoUserCenter) {
            [_btnGotoUserCenter addSubview:_userHeadImageView];
        }
//        [self.contentView addSubview:userHeadImageView];
    }
    return _userHeadImageView;
}
-(UILabel*)userName
{
    if (!_userName) {
        UILabel* userName = [[UILabel alloc] initWithFrame:CGRectZero];
        self.userName = userName;
        if (self.btnGotoUserCenter) {
            [_btnGotoUserCenter addSubview:_userName];
        }
//        [self.contentView addSubview:userName];
    }
    return _userName;
}
-(UIImageView*)arrowImageView
{
    if (!_arrowImageView) {
        UIImageView* arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.arrowImageView = arrowImageView;
        if (self.btnGotoUserCenter) {
            [_btnGotoUserCenter addSubview:self.arrowImageView];
        }
//        [self.contentView addSubview:arrowImageView];
    }
    return _arrowImageView;
}
-(UILabel*)stateLabel
{
    if (!_stateLabel) {
        UILabel* stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.stateLabel = stateLabel;
        [self.contentView addSubview:stateLabel];
    }
    return _stateLabel;
}
-(UIView*)divideUpView
{
    if (!_divideUpView) {
        UIView* divideUpView = [[UIView alloc] initWithFrame:CGRectZero];
        self.divideUpView = divideUpView;
        [self.contentView addSubview:divideUpView];
    }
    return _divideUpView;
}
-(UITapGestureRecognizer*)grGotoNoteDetail
{
    if (!_grGotoNoteDetail)
    {
        _grGotoNoteDetail=[[UITapGestureRecognizer alloc]init];
        [self.postImageView addGestureRecognizer:_grGotoNoteDetail];
    }
    return _grGotoNoteDetail;
}
-(UIImageView*)postImageView
{
    if (!_postImageView) {
        UIImageView* postImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        postImageView.userInteractionEnabled = YES;
        self.postImageView = postImageView;
        [self.contentView addSubview:postImageView];
    }
    return _postImageView;
}
-(UILabel*)detailLabel
{
    if (!_detailLabel) {
        UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.detailLabel = detailLabel;
        [self.contentView addSubview:detailLabel];
    }
    return _detailLabel;
}
-(UILabel*)timeLabel
{
    if (!_timeLabel) {
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
    }
    return _timeLabel;
}
-(UILabel*)pLabel
{
    if (!_pLabel) {
        UILabel* pLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.pLabel = pLabel;
        [self.contentView addSubview:pLabel];
    }
    return _pLabel;
}
-(UILabel*)priceLabel
{
    if (!_priceLabel) {
        UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.priceLabel = priceLabel;
        [self.contentView addSubview:priceLabel];
    }
    return _priceLabel;
}
-(UILabel*)rLabel
{
    if (!_rLabel) {
        UILabel* rLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.rLabel = rLabel;
        [self.contentView addSubview:rLabel];
    }
    return _rLabel;
}
-(UILabel*)refundLabel
{
    if (!_refundLabel) {
        UILabel* refundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.refundLabel = refundLabel;
        [self.contentView addSubview:refundLabel];
    }
    return _refundLabel;
}
-(UIView*)divideDownView
{
    if (!_divideDownView) {
        UIView* divideDownView = [[UIView alloc] initWithFrame:CGRectZero];
        self.divideDownView = divideDownView;
        [self.contentView addSubview:divideDownView];
    }
    return _divideDownView;
}
-(UIButton*)leftButton
{
    if (!_leftButton) {
        UIButton* leftButton = [[UIButton alloc] initWithFrame:CGRectZero];
        self.leftButton = leftButton;
        [self.contentView addSubview:leftButton];
    }
    return _leftButton;
}
-(UIButton*)rightButton
{
    if (!_rightButton) {
        UIButton* rightButton = [[UIButton alloc] initWithFrame:CGRectZero];
        self.rightButton = rightButton;
        [self.contentView addSubview:rightButton];
    }
    return _rightButton;
}

-(UIButton*)btnGotoUserCenter
{
    if (!_btnGotoUserCenter){
        _btnGotoUserCenter=[[UIButton alloc]initWithFrame:CGRectZero];
        _btnGotoUserCenter.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_btnGotoUserCenter];
    }
    return _btnGotoUserCenter;
}

@end
