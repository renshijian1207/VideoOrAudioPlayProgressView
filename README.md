# VideoOrAudioPlayProgressView
1.需求概述
根据产品需求需要做进度条上播放时间替换UISlider滑块，因为项目给的工期很短，很多代码能省就省但百度谷歌未果之后决定自己写。完成了如下需求：

2.基本实现思路：
已知：总播放时间totalT，当前播放时间t

视图总宽度totalW

播放显示时长视图宽度timeW

可计算出 ：

播放时间视图移动总距离：totalW - timeW

每个时间单位移动的距离：(totalW - timeW)/totalT  moveW



正常播放时：

传入当前播放时间及总时间：t/60 + t%60 totalT/60 + totalT%60 直接显示即可

时间视图位置x值改变：t*moveW

播放结束判断为: t = totalT



移动滑块（显示时间视图）：doMoveAction:

获取移动距离 ： moveW = newCenter.x - recognizer.view.frame.size.width/2;

获取移动多少时间：

假设：移动距离为10 ，总距离为100，

移动距离占总距离为0.1

总时间为300秒

得出移动后的时间：0.1*300 = 30秒

传入播放器即可

3.主要功能代码
```

// Figure out where the user is trying to drag the view.



CGPointtranslation = [recognizertranslationInView:self];

CGPointnewCenter =CGPointMake(recognizer.view.center.x+ translation.x,

recognizer.view.center.y+ translation.y);

//    限制屏幕范围：

newCenter.y=MAX(recognizer.view.frame.size.height/2, recognizer.view.frame.size.width/2);

newCenter.y=MIN(self.frame.size.height - recognizer.view.frame.size.height/2, recognizer.view.frame.size.width/2);

newCenter.x=MAX(recognizer.view.frame.size.width/2, newCenter.x);

newCenter.x=MIN(self.frame.size.width - recognizer.view.frame.size.width/2,newCenter.x);

recognizer.view.center= newCenter;

[recognizersetTranslation:CGPointZeroinView:self];



CGRectgreenRect =self.backGreenView.frame;

greenRect.size.width= newCenter.x;

self.backGreenView.frame= greenRect;



CGFloattotalW =self.tempFrame.size.width-self.playTimeW;

CGFloatmoveW = newCenter.x- recognizer.view.frame.size.width/2;

intmoveX = moveW/totalW*self.totalLength;



if([self.delegaterespondsToSelector:@selector(changePlayTimeByPublicAudioPlayProgressView:)]) {

[self.delegate changePlayTimeByPublicAudioPlayProgressView:moveX];

}

```

PS:历时四个小时完成这个功能。时间比较仓促，希望大神们多多提提意见。写的不好的地方大神们多担待多指教。
