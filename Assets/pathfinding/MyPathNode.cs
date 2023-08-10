using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using CodeMonkey.Utils;

public class MyPathNode 
{
    private TextMesh blockedInfo;
    private Grid<MyPathNode> grid;
    public int x;
    public int y;

    public int gCost;
    public int hCost;
    public int fCost;

    public bool isWalkable;
    public MyPathNode cameFromNode;

    public MyPathNode(Grid<MyPathNode> grid, int x, int y)
    {
        this.grid = grid;
        this.x = x;
        this.y = y;

        isWalkable = true;

        blockedInfo = UtilsClass.CreateWorldText("Block", null, grid.GetWorldPosition(x, y) + new Vector3(10f, 10f) * .5f, 30, Color.red, TextAnchor.MiddleCenter);
        blockedInfo.gameObject.SetActive(false);
    }
    public void CalculateFCost()
    {
        fCost = gCost + hCost;
    }

    public override string ToString()
    {
        return x + "," + y;
    }

    public void SetWalkable()
    {
        isWalkable = !isWalkable;
        if (!isWalkable)
        {
            blockedInfo.gameObject.SetActive(true);
        }
        else
        {
            blockedInfo.gameObject.SetActive(false);
        }
        
    }

}
