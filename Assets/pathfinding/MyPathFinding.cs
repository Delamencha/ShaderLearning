using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MyPathFinding
{
    private const int MOVE_STRAIGHT_COST = 10;
    private const int MOVE_DIAGONAL_COST = 14;

    private Grid<MyPathNode> grid;
    private List<MyPathNode> openList;
    private List<MyPathNode> closedList;

    public MyPathFinding(int width, int height)
    {
        grid = new Grid<MyPathNode>(width, height, 10f, Vector3.zero, (Grid<MyPathNode> g, int x, int y) => new MyPathNode(g, x, y));
    }

    public Grid<MyPathNode> GetGrid()
    {
        return grid;
    }

    public List<MyPathNode> FindPath(int startX, int startY, int endX, int endY)
    {
        MyPathNode startNode = grid.GetGridObject(startX, startY);
        MyPathNode endNode = grid.GetGridObject(endX, endY);

        openList = new List<MyPathNode> { startNode};
        closedList = new List<MyPathNode>();

        for (int x =0; x < grid.GetWidth(); x++)
        {
            for(int y = 0; y<grid.GetHeight(); y++)
            {
                MyPathNode pathNode = grid.GetGridObject(x, y);
                pathNode.gCost = int.MaxValue;
                pathNode.CalculateFCost();
                pathNode.cameFromNode = null;
            }
        }

        startNode.gCost = 0;
        startNode.hCost = CalculateDistanceCost(startNode, endNode);
        startNode.CalculateFCost();

        while(openList.Count > 0)
        {
            MyPathNode currentNode = GetLowestFCostNode(openList);
            if(currentNode == endNode)
            {
                //reached the final node
                return CalculatePath(endNode);

            }

            openList.Remove(currentNode);
            closedList.Add(currentNode);

            foreach (MyPathNode neighbourNode in GetNeighbourList(currentNode))
            {
                if (closedList.Contains(neighbourNode)) continue;
                if(!neighbourNode.isWalkable)
                {
                    closedList.Add(neighbourNode);
                    continue;
                }

                int tentativeGCost = currentNode.gCost + CalculateDistanceCost(currentNode, neighbourNode);
                if(tentativeGCost < neighbourNode.gCost)
                {
                    neighbourNode.cameFromNode = currentNode;
                    neighbourNode.gCost = tentativeGCost;
                    neighbourNode.hCost = CalculateDistanceCost(neighbourNode, endNode);
                    neighbourNode.CalculateFCost();

                    if (!openList.Contains(neighbourNode))
                    {
                        openList.Add(neighbourNode);
                    }
                }
            }

        }

        return null;
    }

    private List<MyPathNode> GetNeighbourList(MyPathNode currentNode)
    {

        List<MyPathNode> neighbourList = new List<MyPathNode>();
        if(currentNode.x - 1 >= 0)
        {
            neighbourList.Add(GetNode(currentNode.x - 1, currentNode.y));
            if (currentNode.y - 1 >= 0) neighbourList.Add(GetNode(currentNode.x - 1, currentNode.y-1));
            if(currentNode.y + 1 < grid.GetHeight()) neighbourList.Add(GetNode(currentNode.x - 1, currentNode.y + 1));

        }
        if(currentNode.x + 1 < grid.GetWidth())
        {
            neighbourList.Add(GetNode(currentNode.x + 1, currentNode.y));
            if (currentNode.y - 1 >= 0) neighbourList.Add(GetNode(currentNode.x + 1, currentNode.y - 1));
            if (currentNode.y + 1 < grid.GetHeight()) neighbourList.Add(GetNode(currentNode.x + 1, currentNode.y + 1));
        }
        if(currentNode.y - 1 >= 0)
        {
            neighbourList.Add(GetNode(currentNode.x , currentNode.y -1 ));
        }
        if(currentNode.y +1 < grid.GetHeight()){
            neighbourList.Add(GetNode(currentNode.x , currentNode.y + 1 ));
        }


        return neighbourList;
    }

    public MyPathNode GetNode(int x, int y)
    {
        return grid.GetGridObject(x, y);
    }

    private List<MyPathNode> CalculatePath(MyPathNode endNode)
    {
        List<MyPathNode> path = new List<MyPathNode>();
        path.Add(endNode);
        MyPathNode currentNode = endNode;
        while(currentNode.cameFromNode != null)
        {
            path.Add(currentNode.cameFromNode);
            currentNode = currentNode.cameFromNode;
        }
        path.Reverse();
        return path;
    }

    private int CalculateDistanceCost(MyPathNode a,MyPathNode b)
    {
        int xDistance = Mathf.Abs(a.x - b.x);
        int yDistance = Mathf.Abs(a.y - b.y);
        int remaining = Mathf.Abs(xDistance - yDistance);

        return MOVE_DIAGONAL_COST * Mathf.Min(xDistance, yDistance) + MOVE_STRAIGHT_COST * remaining;
    }

    private MyPathNode GetLowestFCostNode(List<MyPathNode> pathNodeList)
    {

        MyPathNode lowestFCostNode = pathNodeList[0];
        for(int i=0; i < pathNodeList.Count; i++)
        {
            if(pathNodeList[i].fCost < lowestFCostNode.fCost)
            {
                lowestFCostNode = pathNodeList[i];
            }
        }

        return lowestFCostNode;
    }

}
