//
//  GameScene.h
//  ShatterBlaster
//

//  Copyright (c) 2014 JP. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Ball.h"
#import "Paddle.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>

//@property (nonatomic, strong) SKNode * draggedNode;
@property (nonatomic) BOOL isFingerOnPaddle;
@property (nonatomic) BOOL gameStarted;
@property (nonatomic, strong) Ball * ball;
@property (nonatomic, strong) Paddle * paddle;
@property (nonatomic, strong) SKLabelNode * startLabel;
@property (nonatomic, strong) SKLabelNode * scoreLabel;
@property (nonatomic) int score;

@end
