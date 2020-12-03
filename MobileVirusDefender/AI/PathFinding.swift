//
//  AStar.swift
//  MobileVirusDefender
//
//  Created by Tieran on 15/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class Node : Hashable
{
    let X : Int
    let Y : Int
    var parent : Node?
    
    var G : Int //G cost is the distance between the current node and start
    var H : Int //H is tge heuristic - estimated distance from current node to the end node
    
    var F : Int {get{return G + H}}
    
    var walkable : Bool
    
    init(x: Int, y: Int)
    {
        X = x
        Y = y
        
        G = 0
        H = 0
        walkable = true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(X)
        hasher.combine(Y)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.X == rhs.X && lhs.Y == rhs.Y
    }
}

class PathFinding
{
    let scene : GameScene
    var nodes : [[Node?]]
    
    let nodesPerUnit : Int
    let unitSize : Int
    let unitColumns : Int
    let unitRows : Int
    
    init(scene : GameScene, nodesPerUnit : Int, unitSize : Int, unitColumns : Int, unitRows : Int)
    {
        self.scene = scene
        self.nodesPerUnit = nodesPerUnit
        self.unitSize = unitSize
        self.unitColumns = unitColumns
        self.unitRows = unitRows
        
        nodes = [[Node?]]( repeating: [Node?](repeating: nil, count: unitColumns * nodesPerUnit), count: unitRows * nodesPerUnit)
        setupNodes()
    }
    
    private func setupNodes()
    {
        let nodeColumns = unitColumns * nodesPerUnit
        let nodeRows = unitRows * nodesPerUnit
        
        for column in 0...nodeColumns-1
        {
            for row in 0...nodeRows-1
            {
                nodes[column][row] = Node(x:column,y:row)
                rayCastFromPoint(x: column, y: row)
                /*let tileDefinition = TileMap.tileDefinition(atColumn: column, row: row)
                if(tileDefinition != nil)
                {
                    nodes[column][row]!.walkable = false
                }*/
            }
        }
    }

    func rayCastFromPoint(x: Int, y:Int)
    {
        let worldPoint = ToWorldPosition(x: x, y: y)

        //let size = CGFloat(unitSize / nodesPerUnit)
        //let rect = CGRect(x: worldPoint.x - (size*0.5), y: worldPoint.y - (size*0.5) , width: size, height: size)
        
        self.scene.physicsWorld.enumerateBodies(at: worldPoint)
        {body,_ in
            if body.categoryBitMask > 0 && PhysicsMask.NonWalkable.contains(PhysicsMask.init(rawValue: body.categoryBitMask))
            {
                self.nodes[x][y]?.walkable = false
            }
        }

    }
    
    func ToWorldPosition(node : Node) -> CGPoint
    {
        return ToWorldPosition(x: node.X, y: node.Y)
    }
    
    func ToWorldPosition(x : Int, y:Int) -> CGPoint
    {
        let mapWidth2 = CGFloat(unitColumns * unitSize)  * 0.5
        let mapHeight2 = CGFloat(unitRows * unitSize) * 0.5
        let unit2 = (CGFloat(unitSize) / CGFloat(nodesPerUnit)) * 0.5
        
        let worldPoint = CGPoint(x: CGFloat((x * unitSize) / nodesPerUnit) - mapWidth2 + unit2, y: CGFloat((y * unitSize) / nodesPerUnit) - mapHeight2 + unit2)
    
        return worldPoint
    }
    
    func FindPath(startPosition : CGPoint, endPosition : CGPoint) -> [Node]
    {
        let startNode = GetNode(worldPosition: startPosition)
        let endNode = GetNode(worldPosition: endPosition)
        
        if(startNode != nil && endNode != nil)
        {
            return FindPath(start: startNode!, end: endNode!)
        }
        return []
    }
    
    func FindPath(start : Node, end: Node) -> [Node]
    {
        var openSet : Set<Node> = []
        var closedSet : Set<Node> = []
        
        let startNode = Node(x:Int(start.X), y: Int(start.Y));
        openSet.insert(startNode)
        
        while !openSet.isEmpty
        {
            //get lowest F cost in openSet
            let currentNode = openSet.min{$0.F < $1.F}!
            //remove the current node from the openSet and add to closed
            openSet.remove(currentNode)
            closedSet.insert(currentNode)
            
            //check if current node is the end
            if(currentNode == end)
            {
                //back track to get path
                var path : [Node] = []
                var current : Node? = currentNode
                while current != nil
                {
                    if(current != start){
                        path.append(current!)
                    }
                    current = current!.parent
                }
                return path.reversed()
            }
            
            //get all adjacent tiles
            let children = getAdjacentNodes(node: currentNode)
            for child in children
            {
                if(closedSet.contains(child))
                {
                    continue
                }
                
                //create F, G and H values
                child.G = currentNode.G + Distance(start: currentNode, end: child)
                child.H = Distance(start: currentNode, end: end)
                
                if(openSet.contains(child))
                {
                    if(child.G > openSet.first(where: {$0.X == child.X && $0.Y == child.Y})!.G)
                    {
                        continue
                    }
                    openSet.remove(child)
                }
                
                openSet.insert(child)
            }
        }
        return []
    }
    
    func GetNode(worldPosition : CGPoint) -> Node?
    {
        let tileSize = CGFloat(TileMapSettings.TileSize)
        let mapWidth2 = CGFloat(unitColumns * unitSize)  * 0.5
        let mapHeight2 = CGFloat(unitRows * unitSize) * 0.5
        
        let percentX : CGFloat = (worldPosition.x + mapWidth2) / CGFloat(unitColumns * unitSize)
        let percentY : CGFloat = (worldPosition.y + mapHeight2) / CGFloat(unitRows * unitSize)
        
        let x = Int(round((CGFloat(unitColumns * nodesPerUnit) - 1.0) * percentX))
        let y = Int(round((CGFloat(unitRows * nodesPerUnit) - 1.0) * percentY))
        
        if(x >= 0 && x < (unitColumns * unitSize)-1 && y >= 0 && y < (unitRows * unitSize)-1){
            return nodes[x][y]
        }
        return nil
    }
    
    private func getAdjacentNodes(node : Node) -> Set<Node>
    {
        let minX : Int = max(Int(node.X) - 1, 0)
        let maxX : Int = min(Int(node.X) + 1, (unitColumns * unitSize)-1)
        let minY : Int = max(Int(node.Y) - 1, 0)
        let maxY : Int = min(Int(node.Y) + 1, (unitRows * unitSize)-1)
        
        var adjacentNodes : Set<Node> = []
        
        for column in minX...maxX
        {
            for row in minY...maxY
            {
                let tileNode = nodes[column][row]
                if(tileNode!.walkable && tileNode != node)
                {
                    let newNode = Node(x:column,y:row)
                    newNode.parent = node
                    adjacentNodes.insert(newNode)
                }
            }
        }
        return adjacentNodes
    }
    
    private func Distance(start : Node, end:Node) -> Int
    {
        let dstX : Int = Int(abs(start.X - end.X))
        let dstY : Int = Int(abs(start.Y - end.Y))
        
        if (dstX > dstY)
        {
            return 14*dstY + 10 * (dstX-dstY);
        }
        return 14*dstX + 10 * (dstY-dstX);
    }
    
    func DrawPath(path : [Node], scene : SKScene)
    {
        let spritePath = CGMutablePath()
        let points = path.map{ToWorldPosition(x: $0.X, y: $00.Y)}
        spritePath.addLines(between: points)
        let pathNode = SKShapeNode.init(path: spritePath)
        pathNode.fillColor = .clear
        pathNode.strokeColor = .blue
        pathNode.lineWidth = 30
        scene.addChild(pathNode)
        
        pathNode.run(SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.removeFromParent()]))
        
    }
    
    func DrawNodes(scene : SKScene)
    {
        for column in 0...(unitColumns * nodesPerUnit)-1
        {
            for row in 0...(unitRows * nodesPerUnit)-1
            {
                let tileNode = nodes[column][row]!
                
                let worldPosition = ToWorldPosition(node: tileNode)
                
                let size = CGFloat(unitSize / nodesPerUnit)
                let rect = CGRect(x: worldPosition.x - (size*0.5), y: worldPosition.y - (size*0.5) , width: size, height: size)
                
                let shape = SKShapeNode.init(circleOfRadius: size*0.5)
                let nodeX = worldPosition.x - CGFloat(column*nodesPerUnit)
                let nodeY = worldPosition.y - CGFloat(row*nodesPerUnit)
                let nodePos = CGPoint(x: nodeX, y: nodeY)
                shape.position = nodePos
                if(!tileNode.walkable){
                    shape.fillColor = UIColor.red
                }
                else{
                    shape.fillColor = UIColor.white
                }
                scene.addChild(shape)
            }
        }
    }
}
