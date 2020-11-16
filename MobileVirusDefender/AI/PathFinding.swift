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
    let TileMap : SKTileMapNode
    var nodes : [[Node?]]
    
    
    init(tilemap : SKTileMapNode)
    {
        self.TileMap = tilemap
        
        nodes = [[Node?]]( repeating: [Node?](repeating: nil, count: TileMap.numberOfColumns), count: TileMap.numberOfRows)
        setupNodes()
    }
    
    private func setupNodes()
    {
        for column in 0...TileMap.numberOfColumns-1
        {
            for row in 0...TileMap.numberOfRows-1
            {
                nodes[column][row] = Node(x:column,y:row)
                let tileDefinition = TileMap.tileDefinition(atColumn: column, row: row)
                if(tileDefinition != nil)
                {
                    nodes[column][row]!.walkable = false
                }
            }
        }
    }
    
    func ToWorldPosition(node : Node) -> CGPoint
    {
        return ToWorldPosition(x: node.X, y: node.Y)
    }
    
    func ToWorldPosition(x : Int, y:Int) -> CGPoint
    {
        let TileSize = CGFloat(TileMapSettings.TileSize)
        let nodeXOffset = CGFloat(x) + 0.5
        let nodeYOffset = CGFloat(y) + 0.5
        
        let nodeWorldPoint = CGPoint(x: (nodeXOffset * TileSize) - TileMap.mapSize.width/2,
                                     y: (nodeYOffset * TileSize) - TileMap.mapSize.width/2)
        
        return nodeWorldPoint
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
        let mapWidth2 = (TileMap.mapSize.width) * 0.5
        let mapHeight2 = (TileMap.mapSize.height) * 0.5
        
        let percentX : CGFloat = (worldPosition.x + mapWidth2) / CGFloat(TileMap.mapSize.width)
        let percentY : CGFloat = (worldPosition.y + mapHeight2) / CGFloat(TileMap.mapSize.height)
        
        let x = Int(round((CGFloat(TileMap.numberOfColumns) - 1.0) * percentX))
        let y = Int(round((CGFloat(TileMap.numberOfRows) - 1.0) * percentY))
        
        if(x >= 0 && x < TileMap.numberOfColumns-1 && y >= 0 && y < TileMap.numberOfRows-1){
            return nodes[x][y]
        }
        return nil
    }
    
    private func getAdjacentNodes(node : Node) -> Set<Node>
    {
        let minX : Int = max(Int(node.X) - 1, 0)
        let maxX : Int = min(Int(node.X) + 1, TileMap.numberOfColumns-1)
        let minY : Int = max(Int(node.Y) - 1, 0)
        let maxY : Int = min(Int(node.Y) + 1, TileMap.numberOfRows-1)
        
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
    }
    
    func DrawNodes(scene : SKScene)
    {
        for column in 0...TileMap.numberOfColumns-1
        {
            for row in 0...TileMap.numberOfRows-1
            {
                let tileNode = nodes[column][row]!
                let shape = SKShapeNode.init(circleOfRadius: 128)
                shape.position = ToWorldPosition(node: tileNode)
                scene.addChild(shape)
            }
        }
    }
}
