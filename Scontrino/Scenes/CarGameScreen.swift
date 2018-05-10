//
//  CarGameScreen.swift
//  Scontrino
//
//  Created by Eduardo Yutaka Nakanishi on 26/04/2018.
//  Copyright © 2018 Eduardo Yutaka Nakanishi. All rights reserved.
//
//MARK: add end game, add score

import SpriteKit

class CarGameScreen: GameScene, SKPhysicsContactDelegate {
    
    let squareNode = MovingNode(imageNamed: "red square")
    
//    var holePosition: CGPoint!
    
    var holeNode = GameDataSource.shared.nextStaticNode()
    
    //shape arrays
    var coloredShapesNodes: [MovingNode] = []
    var coloredShapesPositions: [String: CGPoint] = [:]
    var coloredShapesInitialPositions: [String: CGPoint] = [:] //using a different type
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    override public func sceneDidLoad() {
//        debugPrint("line 33")
//        self.physicsWorld.contactDelegate = self
//    }
//
//    override public func didMove(to view: SKView) {
//        self.physicsWorld.contactDelegate = self
//        debugPrint("line 39")
//    }
    
    func setDifficulty() -> Int {
        let difficulty = 1 //example for difficulty
        var numberOfShapes: Int
        switch difficulty {
        case 1:
            numberOfShapes = 3
        case 2:
            numberOfShapes = 4
        case 3:
            numberOfShapes = 5
        case 4:
            numberOfShapes = 6
        default:
            numberOfShapes = 3
        }
        return numberOfShapes
    }
    
    func createShapes() {
        let numberOfShapes = setDifficulty()
        for index in  0..<numberOfShapes{
            coloredShapesNodes.append(GameDataSource.shared.nextMovingNode())
            createOneShape(index: index, numberOfShapes: numberOfShapes)
        }
    }
    func createOneShape(index: Int, numberOfShapes: Int){
        let spacing: CGFloat = 10
        coloredShapesNodes[index].name = Consts.Id.CarGameScreen.coloredShapeNode + "\(index)"
        coloredShapesInitialPositions[coloredShapesNodes[index].name!] = (CGPoint(x: CGFloat(UIScreen.main.bounds.width / CGFloat(numberOfShapes) + spacing + (CGFloat(index) * coloredShapesNodes[index].size.width ) ), y: UIScreen.main.bounds.height / 2))
        coloredShapesPositions[coloredShapesNodes[index].name!] = coloredShapesInitialPositions[coloredShapesNodes[index].name!]
        coloredShapesNodes[index].position = coloredShapesPositions[coloredShapesNodes[index].name!]!
        self.addChild(coloredShapesNodes[index])
        
    }
    
    override func createSceneContents() {
        super.createSceneContents()
        self.physicsWorld.contactDelegate = self
        debugPrint(self.scene?.view)
        createShapes()
//        mainView.showsPhysics = true
//        mainView.ignoresSiblingOrder = true
        
        createHole()
        
        
    }
    
    func createHole(){
        holeNode.position = CGPoint(x: CGFloat(UIScreen.main.bounds.width / 2), y: UIScreen.main.bounds.height / 3)
        holeNode.zPosition = -1
        if let texture = holeNode.texture {
            var texSize = texture.size()
            debugPrint("texsize wid: \(texSize.width)")
            texSize.width = (texSize.width) * 0.55
            debugPrint("texsize wid: \(texSize.width)")
            texSize.height = (texSize.height) * 0.55
            holeNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "red square"), size: texSize)
            holeNode.physicsBody?.isDynamic = false
            holeNode.physicsBody?.affectedByGravity = false
            holeNode.physicsBody?.categoryBitMask = Consts.PhysicsMask.holeNode
            holeNode.physicsBody?.contactTestBitMask = Consts.PhysicsMask.shapeNodes
            debugPrint("line 96")
        }
        self.addChild(holeNode)
    }
    
    func controlIfRightShapeInHole(nodeName: String) {
        var i = 0
        while i < coloredShapesNodes.count {
            if coloredShapesNodes[i].name == nodeName {
                coloredShapesNodes[i].removeFromParent()
                coloredShapesNodes[i] = GameDataSource.shared.nextMovingNode()
                createOneShape(index: i, numberOfShapes: setDifficulty())
//                coloredShapesNodes[i].name = Consts.Id.CarGameScreen.coloredShapeNode + "\(i)"
//                coloredShapesNodes[i].position = coloredShapesInitialPositions[coloredShapesNodes[i].name!]!
//                coloredShapesPositions[coloredShapesNodes[i].name!] = coloredShapesInitialPositions[coloredShapesNodes[i].name!]
//                self.addChild(coloredShapesNodes[i])
            }
            i += 1
        }
        
    }
    
    public func didBegin(_ contact: SKPhysicsContact) {
//        contact.contactPoint
        if contact.bodyA.categoryBitMask == Consts.PhysicsMask.shapeNodes{
            if contact.bodyB.categoryBitMask == Consts.PhysicsMask.holeNode{
                debugPrint("scontro punot:\(contact.contactPoint)")
                let contactNode = contact.bodyA.node as! MovingNode
                contactNode.isInTheRightHole = true
            }
        }
    }
    
    public func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == Consts.PhysicsMask.shapeNodes{
            if contact.bodyB.categoryBitMask == Consts.PhysicsMask.holeNode{
                debugPrint("end scontro")
                let contactNode = contact.bodyA.node as! MovingNode
                contactNode.isInTheRightHole = false
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
//        squareNode.position = squarePosition
//        coloredShapesNodes[0].position = squarePosition
        for index in  0..<coloredShapesNodes.count {
            coloredShapesNodes[index].position = coloredShapesPositions[coloredShapesNodes[index].name!]!
        }
    }
}
