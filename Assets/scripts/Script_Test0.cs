using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Script_Test0 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

        var coroutine = CountCoroutine(8) ;
        StartCoroutine(coroutine);

        //while (coroutine.MoveNext())
        //{
        //    var value = coroutine.Current;

        //    Debug.Log("Current: " + value);
        //}


    }

    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator CountCoroutine(int n)
    {

        for(int i=0; i < n; i++)
        {
            Debug.Log("Count: " + i);
            yield return new WaitForSeconds(1);
        }

    }

    IEnumerator TestCoro()
    {
        int n = 0;
        
        while(n < 10)
        {
            yield return new WaitForSeconds(1f);

            Debug.Log("value: " + (n++));
        }


    }


}
