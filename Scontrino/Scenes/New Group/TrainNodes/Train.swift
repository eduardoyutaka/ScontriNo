//
//  Train.swift
//  Scontrino
//
//  Created by Alessio Perrotti on 24/05/2018.
//  Copyright © 2018 Eduardo Yutaka Nakanishi. All rights reserved.
//

import SpriteKit

struct Train {
    var headVagon: HeadVagonNode
    var centralVagons: [CentralVagonNode] = []
    var tailVagon: TailVagonNode
    var trainSpeed: CGFloat = 600
    
    init() {
        headVagon = HeadVagonNode(imageNamed: "frontal")
        tailVagon = TailVagonNode(imageNamed: "back")
//        instanziateCentralVagons(numberOfShapes: numberOfShapes)
    }
    
    mutating func setupTrain(numberOfShapes: Int) {
        headVagon.setup()
        var vagonXPosition = headVagon.position.x - (headVagon.size.width / 2) + (headVagon.size.width / 100 * 5)
        debugPrint(numberOfShapes)
        for index in 0...numberOfShapes - 1 {
            centralVagons.append(CentralVagonNode(imageNamed: "central"))
            centralVagons[index].setup(posX: vagonXPosition)
            vagonXPosition -= centralVagons[index].size.width + (centralVagons[index].size.width / 100 * 5)
        }
        tailVagon.setup(posX: vagonXPosition)
    }
    
    mutating func instanziateCentralVagons(numberOfShapes: Int) {
        for index in 0...Consts.shapes.count - 1 {
            
        }
    }
    
    func moveTrain(pos: CGFloat, onComplete: @escaping (Bool) -> Void) -> TimeInterval {
        var position = pos - (centralVagons[0].size.width * CGFloat(centralVagons.count + 1))
        let duration = moveVagon(vagon: headVagon, pos: pos) { (value) in
            if(value) {
                position -= self.headVagon.size.width
            }
        }
        
        
        for index in 0...centralVagons.count - 1 {
//            pos -= centralVagons[index].size.width
            moveVagon(vagon: centralVagons[index], pos: pos - (centralVagons[index].size.width * CGFloat(index + 1)) + (headVagon.size.width / 100 * 5)) { (value) in
//            moveVagon(vagon: centralVagons[index], pos: position) { (value) in
                if(value) {
                    position = pos - (self.centralVagons[index].size.width * CGFloat(index + 1))
//                    count += 1
//                    if count == self.centralVagons.count {
//                        onComplete(true)
//                    }
                }
            }
        }
        moveVagon(vagon: tailVagon, pos: position) { (value) in
            if(value) {
                onComplete(true)
            }
        }
        return duration
    }
    
    func moveVagon(vagon: SKSpriteNode, pos: CGFloat, onComplete: @escaping (Bool) -> Void) -> TimeInterval{
        let path = UIBezierPath()
        path.move(to: vagon.position)
        path.addLine(to: CGPoint(x: pos, y: vagon.position.y))
        
        let anim = SKAction.run {
            onComplete(true)
        }
        
        let fillInHoleAnimation = SKAction.sequence([
//            SKAction.follow(<#T##path: CGPath##CGPath#>, duration: <#T##TimeInterval#>)
            SKAction.follow(path.cgPath, asOffset: false, orientToPath: false, speed: trainSpeed),
            anim
            ])
//        debugPrint("fill in Hole anim: \(fillInHoleAnimation.duration)")
        vagon.run(fillInHoleAnimation)
        return fillInHoleAnimation.duration
    }
    
    
}
