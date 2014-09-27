//
//  GameScene.m
//  ShatterBlaster
//
//  Created by Jared Poetter on 9/25/14.
//  Copyright (c) 2014 JP. All rights reserved.
//

#import "GameScene.h"
#import "Block.h"
#import "Ball.h"
#import "Paddle.h"

//Names for the different objects
static NSString * ballName = @"BALL";
static NSString * bottomName = @"BOTTOM";
static NSString * blockName = @"BLOCK";
static NSString * paddleName = @"PADDLE";

//Physics Collision BitMasks
static const int ballCategory = 0x1 << 0;
static const int bottomCategory = 0x1 << 1;
static const int blockCategory = 0x1 << 2;
static const int paddleCategory = 0x1 << 3;

//Paddle information
static const float paddlePositionX = 122.0;
static const float paddlePositionY = 50.0;
static const float paddleSizeHeight = 40.0;
static const float paddleSizeWidth = 150.0;

//Ball information
static const float ballSize = 15.0;
static const float ballPositionX = 197.0;
static const float ballPositionY = 250.0;

//Block information


@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    
    
    
    //Border on the phone to prevent things from flying off the screen
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.friction = 0.0;
    
    //Ball
    Ball * ball = [Ball shapeNodeWithCircleOfRadius:ballSize];
    ball.name = ballName;
    ball.fillColor = [UIColor blueColor];
    ball.position = CGPointMake(250.0, 600.0);
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ballSize];
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.friction = 0.0;
    ball.physicsBody.restitution = 1.0;
    ball.physicsBody.linearDamping = 0.0;
    ball.physicsBody.allowsRotation = NO;
    [self addChild:ball];
    
    [ball.physicsBody applyImpulse:CGVectorMake(50.0f, -50.0f)];
    
    //Paddle
    Paddle * paddle = [Paddle shapeNodeWithRect:CGRectMake(0.0, 0.0, paddleSizeWidth, paddleSizeHeight)];
    paddle.name = paddleName;
    paddle.fillColor = [UIColor blackColor];
    paddle.position = CGPointMake(paddlePositionX, paddlePositionY);
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(paddleSizeWidth,
                                                                           paddleSizeHeight)
                                                         center:CGPointMake(paddleSizeWidth/2.0,
                                                                            paddleSizeHeight/2.0)];
    paddle.physicsBody.dynamic = NO;
    paddle.physicsBody.categoryBitMask = paddleCategory;
    paddle.physicsBody.restitution = 0.1;
    paddle.physicsBody.friction = 0.4;
    [self addChild:paddle];
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    /* Called when a touch begins */
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    NSLog(@"Touch Began: %@", touch);
    
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:touchLocation];
    if (body && [body.node isKindOfClass:[Paddle class]]) {
        NSLog(@"Began touch on paddle");
        self.isFingerOnPaddle = YES;
    }
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    //Checking to see if the touch is on the paddle
    if (self.isFingerOnPaddle) {
        //Getting the touch point
        UITouch* touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        CGPoint previousLocation = [touch previousLocationInNode:self];
        //Getting the node for the paddle
        Paddle * paddle = (Paddle *)[self childNodeWithName:paddleName];
        //Calculate new position along x for paddle
        int paddleX = paddle.position.x + (touchLocation.x - previousLocation.x);
        //Limit x so that the paddle will not leave the screen to left or right
        paddleX = MAX(paddleX, paddleSizeWidth/2);
        paddleX = MIN(paddleX, self.size.width - paddleSizeWidth/2);
        //Update position of paddle
        paddle.position = CGPointMake(paddleX, paddle.position.y);
    }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    self.isFingerOnPaddle = NO;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
