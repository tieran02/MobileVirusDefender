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
    let position : CGVector
    var parent : Node?
    
    var G : Float //G cost is the distance between the current node and start
    var H : Float //H is tge heuristic - estimated distance from current node to the end node
    
    var F : Float {get{return G + H}}
    
    var walkable : Bool
    
    init(x: Int, y: Int)
    {
        position = CGVector(dx: x, dy: y)
        
        G = 0
        H = 0
        walkable = true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(position.dx)
        hasher.combine(position.dy)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.position == rhs.position
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
    
    func FindPath(start : Node, end: Node) -> [Node]
    {
        var openSet : Set<Node> = []
        var closedSet : Set<Node> = []
        
        let startNode = Node(x:Int(start.position.dx), y: Int(start.position.dy));
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
                    path.append(current!)
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
                child.G = Distance(start: currentNode, end: child)
                child.H = Distance(start: currentNode, end: end)
                
                if(openSet.contains(child))
                {
                    if(child.G > openSet.first(where: {$0.position == child.position})!.G)
                    {
                        continue
                    }
                    
                }
                
                openSet.insert(child)
            }
        }
        return []
    }
    
    func GetNode(position : CGPoint) -> Node?
    {
        let x : Int = Int(floor(position.x / CGFloat(TileMapSettings.TileSize)))
        let y : Int = Int(floor(position.y / CGFloat(TileMapSettings.TileSize)))
        
        if(x >= 0 && x < TileMap.numberOfColumns-1 && y >= 0 && y < TileMap.numberOfRows-1){
            return nodes[x][y]
        }
        return nil
    }
    
    private func getAdjacentNodes(node : Node) -> Set<Node>
    {
        let minX : Int = max(Int(node.position.dx) - 1, 0)
        let maxX : Int = min(Int(node.position.dx) + 1, TileMap.numberOfColumns-1)
        let minY : Int = max(Int(node.position.dy) - 1, 0)
        let maxY : Int = min(Int(node.position.dy) + 1, TileMap.numberOfRows-1)
        
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
    
    private func Distance(start : Node, end:Node) -> Float
    {
        return Float(start.position.distanceTo(end.position))
    }
    
}
