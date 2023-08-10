Shader "Unlit/Shader1-1"
{
    Properties
    {
        //input data
         _ColorA("Color A", Color) = (1, 1, 1, 1)
         _ColorB("Color B", Color) = (1, 1, 1, 1)
         _ColorStart("Color Start", Range(0, 1) ) = 0
        _ColorEnd("Color End", Range(0, 1)) = 1
         _Scale("UV Scale", Float) = 1
         _Offset ("UV Offset", Float) = 0  
    }
        SubShader
    {
        Tags { 
            "RenderType" = "Transparent" 
            "Queue" = "Transparent"
            }


        Pass
        {
            Cull Off
            ZWrite Off
            Blend One One //additive
            //Blend DstColor Zero //multiply
            
            ZTest LEqual


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

#define TAU 6.28318530718

            float4 _ColorA;
            float4 _ColorB;
            float _Scale;
            float _Offset;
            float _ColorStart;
            float _ColorEnd;

            // MeshData unity 自动完成
            struct appdata //per-vertex mesh data
            {
                float4 vertex : POSITION; //vertex position 将position数据传入变量vertex（可命名）中
                float3 normals : NORMAL;
                float4 tangent : TANGENT;
                float4 color : COLOR;
                float4 uv0 : TEXCOORD0; //uv coordinates

                //仅需vertex 和 uv 来贴上texture
            };

            struct Interpolators
            {
                //float2 uv : TEXCOORD0; //可以不用是uv
                float4 vertex : SV_POSITION; //clip space position
                float3 normal: TEXCOORD0;
                float2 uv : TEXCOORD1;
            };



            Interpolators vert (appdata v)
            {
                Interpolators o;
                o.vertex =  UnityObjectToClipPos(v.vertex); // converts local space to clip space 
                o.normal = /*mul((float3x3)unity_ObjectToWorld, v.normals);*/UnityObjectToWorldNormal(v.normals) ;
                o.uv = v.uv0;//(v.uv0 + _Offset ) * _Scale ;
                return o;
            }


            float InverseLerp(float a, float b, float v) 
            {
                return (v - a) / (b-a);
            }

            //bool 0 1
            //int 
            //float4 = vector4            float (32 bit float )
            //half (16 bit float)
            //fixed(lower percision) -1 to 1
            // flaot4 -> half4 -> fixed4
            // float4x4 -> half4x4 (c# Matrix4x4)

            //SV_Target 作为输出目标
            float4 frag(Interpolators i) : SV_Target
            {
                //float4 myValue;
                //float2 otherValue = myValue.rg; // swizzling

                //float t = InverseLerp(_ColorStart, _ColorEnd, i.uv.x);  //t 可能在(-1, 1 )之外，在只有t时无法发现，在t做两个颜色的lerp时会改变效果
                // frac = v - floor(v) 循环
                //t = frac(t);

                //clamp
                //t = saturate(t);


            

            float xOffset = cos(i.uv.x * TAU * 6) * 0.01 ;

            float t = cos((i.uv.y + xOffset - _Time.y * 0.1) * 4 *  TAU) * 0.5 + 0.5 ;
            t *= 1 - i.uv.y; 

            float topBottomRemover = (abs(i.normal.y) < 0.99);
            float waves = t * topBottomRemover;

            float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);
            return gradient * waves ;
             

                //lerp  : belnd betwenn two colors
                //float4 outColor = lerp(_ColorA, _ColorB, t);  

                //return outColor; //float4(i.uv, 0 , 1); //red


            }
            ENDCG
        }
    }
}
