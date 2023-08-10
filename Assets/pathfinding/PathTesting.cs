using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PathTesting : MonoBehaviour
{
    private MyPathFinding pathfinding;
    //private MyGrid grid;

    //private void Start()
    //{
    //    grid = new MyGrid(5, 2, 10f, new Vector3(10,0,0));
    //}


    //private void Update()
    //{
    //    if (Input.GetMouseButtonDown(0))
    //    {
    //        grid.SetValue(GetMousePosition(), 42);
    //    }
    //    if (Input.GetMouseButtonDown(1))
    //    {
    //        Debug.Log(grid.GetValue(GetMousePosition())); 
    //    }
    //}

    private void Start()
    {
        pathfinding = new MyPathFinding(10, 10);
    }

    private void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {

            Vector3 mouseWorldPosition = GetMousePosition();
            pathfinding.GetGrid().GetXY(mouseWorldPosition, out int x, out int y);
            List<MyPathNode> path = pathfinding.FindPath(0, 0, x, y);
            if(path != null)
            {
                //for(int i=0; i<path.Count; i++)
                //{
                //    Debug.Log(path[i].x + "," + path[i].y);
                //}
                for (int i = 0; i < path.Count - 1; i++)
                {
                    Debug.DrawLine(new Vector3(path[i].x, path[i].y) * 10f + Vector3.one * 5f, new Vector3(path[i + 1].x, path[i + 1].y) * 10f + Vector3.one * 5f, Color.green, 5f);
                }
            }
        }
        if (Input.GetMouseButtonDown(1))
        {
            Vector3 mouseWorldPosition = GetMousePosition();
            pathfinding.GetGrid().GetXY(mouseWorldPosition, out int x, out int y);
            pathfinding.GetNode(x, y).SetWalkable();

        }
    }

    //
    public Vector3 GetMousePosition()
    {
        Vector3 vec = Camera.main.ScreenToWorldPoint(Input.mousePosition);
        vec.z = 0;
        return vec;
    }
}
