//
//  ResultView.m
//  FlashTag
//
//  Created by MyOS on 15/9/6.
//  Copyright (c) 2015年 Puyun. All rights reserved.
//  成果页面

#import "ResultView.h"

@implementation ResultView
//@synthesize scoreAddLabel;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    //底部用scrollView，防止一个屏幕显示不完信息
    self.rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, fDeviceWidth, kQPHeight - 64)];
    [self addSubview:self.rootScrollView];
    
    CGFloat imageSize = kCalculateH(80);
    self.userHradImageView = [[UIImageView alloc] initWithFrame:CGRectMake((fDeviceWidth - imageSize)/2, kCalculateV(20), imageSize, imageSize)];
    self.userHradImageView.layer.masksToBounds = YES;
    self.userHradImageView.layer.cornerRadius = imageSize/2;
    self.userHradImageView.layer.borderWidth = imageSize/100;
    self.userHradImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.userHradImageView.image = [UIImage imageNamed:@"test2.jpg"];
    [self.rootScrollView addSubview:self.userHradImageView];
    
    self.hotLabel = [[UILabel alloc] initWithFrame:CGRectMake((fDeviceWidth - kCalculateH(90))/2, CGRectGetMaxY(self.userHradImageView.frame) + kCalculateV(20), kCalculateH(70), kCalculateV(14))];
    self.hotLabel.text = @"我的热度";
    self.hotLabel.textColor = PYColor(@"222222");
    self.hotLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    [self.rootScrollView addSubview:self.hotLabel];
    
    self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hotLabel.frame), CGRectGetMinY(self.hotLabel.frame) - kCalculateV(3), kCalculateV(20), kCalculateV(20))];
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.cornerRadius = kCalculateV(10);
    self.tagLabel.backgroundColor = [UIColor redColor];
    self.tagLabel.textAlignment = NSTextAlignmentCenter;
    self.tagLabel.textColor = [UIColor whiteColor];
    self.tagLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(12)];
    [self.rootScrollView addSubview:self.tagLabel];
    
    self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake((fDeviceWidth - 250)/2, CGRectGetMaxY(self.hotLabel.frame) + kCalculateV(12), 250, kCalculateV(12))];
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    self.remindLabel.font = [UIFont systemFontOfSize:kCalculateH(11)];
    self.remindLabel.textColor = PYColor(@"999999");
    [self.rootScrollView addSubview:self.remindLabel];
    
    UIView *divideLine = [[UIView alloc] initWithFrame:CGRectMake(0, kCalculateV(179), fDeviceWidth, kCalculateV(0.5))];
    divideLine.backgroundColor = PYColor(@"cccccc");
    [self.rootScrollView addSubview:divideLine];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(divideLine.frame) + kCalculateV(15), kCalculateH(130), kCalculateV(14))];
    label.text = @"我的当前积分";
    label.font = [UIFont systemFontOfSize:kCalculateH(13)];
    label.textColor = PYColor(@"888888");
    [self.rootScrollView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(label.frame) + kCalculateV(8), kCalculateH(130), kCalculateV(14))];
    label1.text = @"我的历史总积分";
    label1.font = [UIFont systemFontOfSize:kCalculateH(13)];
    label1.textColor = PYColor(@"888888");
    [self.rootScrollView addSubview:label1];

    
    self.nowScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(130), CGRectGetMaxY(divideLine.frame) + kCalculateV(15), kCalculateH(100), kCalculateH(14))];
    self.nowScoreLabel.textColor = PYColor(@"222222");
    self.nowScoreLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    [self.rootScrollView addSubview:self.nowScoreLabel];
    
    self.historyScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(130), CGRectGetMaxY(label.frame) + kCalculateV(8), kCalculateH(100), kCalculateV(14))];
    self.historyScoreLabel.textColor = PYColor(@"222222");
    self.historyScoreLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    [self.rootScrollView addSubview:self.historyScoreLabel];
    
    
    if ([CMData getUserType] == 0) {
        
    }else{
    self.tradeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.tradeButton.frame = CGRectMake(fDeviceWidth - kCalculateH(86), CGRectGetMaxY(divideLine.frame) + kCalculateV(20.5), kCalculateH(71), kCalculateV(29));
    [self.tradeButton setTitle:@"兑换" forState:UIControlStateNormal];
    [self.tradeButton setTitleColor:PYColor(@"ffffff") forState:UIControlStateNormal];
    self.tradeButton.titleLabel.font = [UIFont systemFontOfSize:kCalculateH(14)];
    [self.tradeButton setBackgroundColor:PYColor(@"f24949")];
    self.tradeButton.layer.masksToBounds = YES;
    self.tradeButton.layer.cornerRadius = kCalculateH(8);
    [self.rootScrollView addSubview:self.tradeButton];
        
    }
    
    UIView *twoDivideLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(divideLine.frame) + kCalculateV(70), fDeviceWidth, kCalculateV(0.5))];
    twoDivideLine.backgroundColor = PYColor(@"cccccc");
    [self.rootScrollView addSubview:twoDivideLine];
    
    self.scoreRuleLabel = [[UILabel alloc] initWithFrame:CGRectMake((fDeviceWidth - 150)/2, CGRectGetMaxY(twoDivideLine.frame) + kCalculateV(20), 150, kCalculateV(16))];
    self.scoreRuleLabel.text = @"买咩积分规则";
    self.scoreUserLabel.font = [UIFont boldSystemFontOfSize:kCalculateH(15)];
    self.scoreRuleLabel.textColor = PYColor(@"222222");
    self.scoreRuleLabel.textAlignment = NSTextAlignmentCenter;
    [self.rootScrollView addSubview:self.scoreRuleLabel];
    
    
    UILabel *yongTuLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(twoDivideLine.frame) + kCalculateV(50), 200, kCalculateV(14))];
    yongTuLabel.textColor = PYColor(@"222222");
    yongTuLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    yongTuLabel.text = @"用途小贴士";
    [self.rootScrollView addSubview:yongTuLabel];
    
    self.scoreUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(yongTuLabel.frame), fDeviceWidth - kCalculateH(30), kCalculateV(121 - 64))];
    self.scoreUserLabel.text = @"积分可以用来抵现或兑换礼品，但如果小咩开通了代购身份，积分就只能用来兑换铺位。";
    self.scoreUserLabel.numberOfLines = 0;
    self.scoreUserLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.scoreUserLabel.textColor = PYColor(@"999999");
    [self.rootScrollView addSubview:self.scoreUserLabel];
    
    UIView *divideLLLL = [[UIView alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(twoDivideLine.frame) + kCalculateV(121), fDeviceWidth - kCalculateH(30), kCalculateV(0.5))];
    divideLLLL.backgroundColor = PYColor(@"cccccc");
    [self.rootScrollView addSubview:divideLLLL];
    
    UILabel *calculateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(divideLLLL.frame) + kCalculateV(15), kCalculateH(200), kCalculateV(14))];
    calculateLabel.text = @"计算小贴士";
    calculateLabel.font = [UIFont systemFontOfSize:kCalculateH(13)];
    calculateLabel.textColor = PYColor(@"222222");
    [self.rootScrollView addSubview:calculateLabel];
    
    self.scoreCalculateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCalculateH(15), CGRectGetMaxY(calculateLabel.frame), 200, kCalculateV(150))];
//    self.scoreCalculateLabel.text = @"发布帖子\r分享帖子\r点赞\r评论帖子\r被点赞\r被评论\r被关注\r成功邀请一位好友";
    self.scoreCalculateLabel.numberOfLines = 0;
    self.scoreCalculateLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.scoreCalculateLabel.textColor = PYColor(@"999999");
    [self.rootScrollView addSubview:self.scoreCalculateLabel];
    
    self.scoreAddLabel = [[UILabel alloc] initWithFrame:CGRectMake(fDeviceWidth - kCalculateH(95), CGRectGetMaxY(calculateLabel.frame), kCalculateH(80), CGRectGetHeight(self.scoreCalculateLabel.frame))];
//    scoreAddLabel = [[UILabel alloc] initWithFrame:CGRectMake(fDeviceWidth - kCalculateH(95), CGRectGetMaxY(calculateLabel.frame), kCalculateH(80), CGRectGetHeight(self.scoreCalculateLabel.frame))];
//    scoreAddLabel.text = @"+10分\r＋5分\r＋1分\r＋2分\r＋1分\r＋2分\r＋5分\r＋10分";
    self.scoreAddLabel.numberOfLines = 0;
    self.scoreAddLabel.font = [UIFont systemFontOfSize:kCalculateH(12)];
    self.scoreAddLabel.textColor = PYColor(@"999999");
    self.scoreAddLabel.textAlignment = NSTextAlignmentRight;
    [self.rootScrollView addSubview:self.scoreAddLabel];
    
    self.rootScrollView.contentSize = CGSizeMake(fDeviceWidth, self.scoreCalculateLabel.frame.origin.y + self.scoreCalculateLabel.frame.size.height);
}

#pragma mark-

//-(void)setMyResultModel:(MyResultModel *)myResultModel{
//    _myResultModel=myResultModel;
//    
//    self.tagLabel.text = [NSString stringWithFormat:@"V%@" , _myResultModel.level];
//    self.remindLabel.text = [NSString stringWithFormat:@"(您还差%@点热度就升级啦)" , _myResultModel.count];
//    self.nowScoreLabel.text = [NSString stringWithFormat:@"%@" , _myResultModel.score];
//    self.historyScoreLabel.text = [NSString stringWithFormat:@"%@" , _myResultModel.scoreTotal];
//}

//-(void)setScoreRuleModelArr:(NSArray *)scoreRuleModelArr{
//    _scoreRuleModelArr=scoreRuleModelArr;
//    
//    //重新设置高度
//    CGRect scoreCalculateLabelFrame=self.scoreCalculateLabel.frame;
//    CGRect scoreAddLabelFrame=self.scoreAddLabel.frame;
//    CGSize rootScrollViewSize=self.rootScrollView.frame.size;
//    
//    float singleHeight=scoreCalculateLabelFrame.size.height/8;
//    float addHeight=singleHeight*_scoreRuleModelArr.count-scoreCalculateLabelFrame.size.height;
//    
//    scoreCalculateLabelFrame.size.height+=addHeight;
//    scoreAddLabelFrame.size.height+=addHeight;
//    rootScrollViewSize.height+=addHeight;
//    self.scoreCalculateLabel.frame=scoreCalculateLabelFrame;
//    self.scoreAddLabel.frame=scoreAddLabelFrame;
//    
//    self.rootScrollView.contentSize=rootScrollViewSize;
//    
//    //setValue
//    NSMutableString *scoreCalculateLabelText=[[NSMutableString alloc] init];
//    NSMutableString *scoreAddLabelText=[[NSMutableString alloc] init];
//    for (int i=0; i<_scoreRuleModelArr.count; i++) {
//        ScoreRuleModel *scoreRuleModel=_scoreRuleModelArr[i];
//        
//        [scoreCalculateLabelText appendString:scoreRuleModel.scoreRuleName];
//        [scoreAddLabelText appendFormat:@"+%@分",scoreRuleModel.score];
//        
//        if (i < _scoreRuleModelArr.count-1) {
//            [scoreCalculateLabelText appendString:@"\r"];
//            [scoreAddLabelText appendString:@"\r"];
//        }
//    }
//    self.scoreCalculateLabel.text=scoreCalculateLabelText;
//    self.scoreAddLabel.text=scoreAddLabelText;
//    
//}

#pragma mark-


@end
