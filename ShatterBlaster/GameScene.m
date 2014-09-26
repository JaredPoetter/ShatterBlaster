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

#define PADDLE_HEIGHT 50.0
#define PADDLE_SIZE_HEIGHT 40.0
#define PADDLE_SIZE_WIDTH 400.0

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    //Border on the phone to prevent things from flying off the screen
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    //Ball
    float ballSize = 25.0;
    Ball * ball = [Ball shapeNodeWithCircleOfRadius:ballSize];
    ball.fillColor = [UIColor blueColor];
    ball.position = CGPointMake(250.0, 600.0);
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ballSize];
    [self addChild:ball];
    
    //Paddle
    Paddle * paddle = [Paddle shapeNodeWithRect:CGRectMake(0.0, 0.0,
                                                           PADDLE_SIZE_WIDTH, PADDLE_SIZE_HEIGHT)];
    paddle.fillColor = [UIColor blackColor];
    paddle.position = CGPointMake(250.0, PADDLE_HEIGHT);
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(PADDLE_SIZE_WIDTH,
                                                                           PADDLE_SIZE_HEIGHT)
                                                         center:CGPointMake(PADDLE_SIZE_WIDTH/2.0,
                                                                            PADDLE_SIZE_HEIGHT/2.0)];
    paddle.physicsBody.dynamic = NO;
//    paddle.physicsBody.collisionBitMask = 0;
    [self addChild:paddle];
}

-(void)setDraggedNode:(SKNode*) draggedNode {
    // Previous.
    _draggedNode.physicsBody.affectedByGravity = YES;
    
    _draggedNode = draggedNode; // Set
    
    // New.
    draggedNode.physicsBody.affectedByGravity = NO;
}

-(void)touchesBegan:(NSSet*) touches withEvent:(UIEvent*) event
{
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    Paddle * touchedNode = (Paddle *) [self nodeAtPoint:touchLocation];
    if ([touchedNode isKindOfClass:[Paddle class]] == NO) return; // Checks
    
    // Track and save offset (with the new SKNode feature).
    self.draggedNode = touchedNode;
    touchedNode.touchOffset = CGPointMake(touchLocation.x - self.draggedNode.position.x, PADDLE_HEIGHT);
}

-(void)touchesMoved:(NSSet*) touches withEvent:(UIEvent*) event {
    // Align with offset (if any)
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    Paddle * paddle = (Paddle *) self.draggedNode;
    self.draggedNode.position = CGPointMake(touchLocation.x - paddle.touchOffset.x, PADDLE_HEIGHT);
}

-(void)touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
    self.draggedNode = nil;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    /* Called when a touch begins */
//    UITouch *touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInNode:self];
//    SKNode *touchedNode = [self nodeAtPoint:touchLocation];
//    
//    if (touchedNode != self) {
//        touchedNode.physicsBody.affectedByGravity = NO;
//        touchedNode.position = [touch locationInNode:self];
//        touchedNode.physicsBody.affectedByGravity = YES;
//    }
//}

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    /* Called when a touch moves */
//    UITouch *touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInNode:self];
//    SKNode *touchedNode = [self nodeAtPoint:touchLocation];
//    
//    if (touchedNode != self) {
//        touchedNode.position = [touch locationInNode:self];
//    }
//}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
