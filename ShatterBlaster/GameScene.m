//
//  GameScene.m
//  ShatterBlaster
//
//  Created by Jared Poetter on 9/25/14.
//  Copyright (c) 2014 JP. All rights reserved.
//

#import "GameScene.h"
#import "Block.h"

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
static const float blockSizeHeight = 20.0;
static const float blockSizeWidth = 30.0;

//Level information
static const int numberOfBlocksVert = 15;
static const int numberOfBlocksHori = 10;

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    //Game has not started
    self.gameStarted = NO;
    
    //Label to let the user know to tap to start
    self.startLabel = [SKLabelNode labelNodeWithText:@"Double Tap to Start"];
    self.startLabel.fontColor = [UIColor blackColor];
    self.startLabel.fontSize = 50.0;
    self.startLabel.position = CGPointMake(197.0, 600.0);
    [self addChild:self.startLabel];
    
    //Setting up double tap to start the game
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);

    self.physicsWorld.contactDelegate = self;
    
    //Blocks
    short int level[numberOfBlocksVert][numberOfBlocksHori] = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    };
    Block * block;
    for (int x = 0; x < numberOfBlocksHori; x++) {
        for (int y = 0; y < numberOfBlocksVert; y++) {
            switch (level[x][y]) {
                case 0:
                    block = [Block shapeNodeWithRect:CGRectMake(0.0, 0.0, blockSizeWidth, blockSizeHeight)];
                    block.name = blockName;
                    block.fillColor = [UIColor purpleColor];
                    block.position = CGPointMake(x * (blockSizeWidth + 4.0) + 22.0, (y * (blockSizeHeight + 10.0)) + 275.0);
                    block.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(blockSizeWidth, blockSizeHeight)
                                                                        center:CGPointMake(blockSizeWidth/2.0, blockSizeHeight/2.0)];
                    block.physicsBody.dynamic = NO;
                    block.physicsBody.categoryBitMask = blockCategory;
                    block.physicsBody.friction = 0.0;
                    [self addChild:block];
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    //Border on the phone to prevent things from flying off the screen
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.friction = 0.0;
    
    //Ball
    self.ball = [Ball shapeNodeWithCircleOfRadius:ballSize];
    self.ball.name = ballName;
    self.ball.fillColor = [UIColor blueColor];
    self.ball.position = CGPointMake(197.0, 200.0);
    self.ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ballSize];
    self.ball.physicsBody.categoryBitMask = ballCategory;
    self.ball.physicsBody.contactTestBitMask = blockCategory | bottomCategory;
    self.ball.physicsBody.friction = 0.0;
    self.ball.physicsBody.restitution = 1.0;
    self.ball.physicsBody.linearDamping = 0.0;
    self.ball.physicsBody.allowsRotation = NO;
    [self addChild:self.ball];
    
    //Paddle
    self.paddle = [Paddle shapeNodeWithRect:CGRectMake(0.0, 0.0, paddleSizeWidth, paddleSizeHeight)];
    self.paddle.name = paddleName;
    self.paddle.fillColor = [UIColor blackColor];
    self.paddle.position = CGPointMake(paddlePositionX, paddlePositionY);
//    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
    self.paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(paddleSizeWidth,
                                                                           paddleSizeHeight)
                                                         center:CGPointMake(paddleSizeWidth/2.0,
                                                                            paddleSizeHeight/2.0)];
    self.paddle.physicsBody.dynamic = NO;
    self.paddle.physicsBody.categoryBitMask = paddleCategory;
    self.paddle.physicsBody.restitution = 0.1;
    self.paddle.physicsBody.friction = 0.4;
    [self addChild:self.paddle];
}

//Touch Events

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    /* Called when a touch begins */
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
//    NSLog(@"Touch Began: %@", touch);
    
    SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:touchLocation];
    if (body && [body.node isKindOfClass:[Paddle class]]) {
//        NSLog(@"Began touch on paddle");
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
//        Paddle * paddle = (Paddle *)[self childNodeWithName:paddleName];
        //Calculate new position along x for paddle
        int paddleX = self.paddle.position.x + (touchLocation.x - previousLocation.x);
        //Limit x so that the paddle will not leave the screen to left or right
        paddleX = MAX(paddleX, paddleSizeWidth/2);
        paddleX = MIN(paddleX, self.size.width - paddleSizeWidth/2);
        //Update position of paddle
        self.paddle.position = CGPointMake(paddleX, self.paddle.position.y);
    }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    self.isFingerOnPaddle = NO;
}

//Contact Events
- (void)didBeginContact:(SKPhysicsContact *)contact {
//        NSLog(@"collision");
    if (contact.bodyA.categoryBitMask == ballCategory && contact.bodyB.categoryBitMask == blockCategory) {
//         NSLog(@"collision");
        [contact.bodyB.node removeFromParent];
    }
    else if (contact.bodyB.categoryBitMask == ballCategory && contact.bodyA.categoryBitMask == blockCategory) {
//         NSLog(@"collision");
        [contact.bodyA.node removeFromParent];
    }
}

//Double Tap Event
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        if (!self.gameStarted) {
            //The initial impluse to start the ball moving
            [self.ball.physicsBody applyImpulse:CGVectorMake(0.0, -20.0)];
            
            //Removing the start label
            [self.startLabel removeFromParent];
            
            //Set that the game has started
            self.gameStarted = YES;
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
