Shader "Unlit/Shader1-2"
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
        _WaveAmp("Wave Amplitude", Range(0, 0.2)) = 0.1
    }
        SubShader
    {
        Tags { 
            "RenderType" = "Opaque" 
            }


        Pass
        {



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
            float _WaveAmp;

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

            float GetWave(float2 uv)
            {
                float2 uvCentered = uv * 2 - 1;
                float radialDistance = length(uvCentered);
                float wave = cos((radialDistance - _Time.y * 0.1) * 4 * TAU) * 0.5 + 0.5;
                wave *= 1 - radialDistance;
                return wave;
            }

            Interpolators vert (appdata v)
            {
                Interpolators o;

                float wave = cos((v.uv0.y - _Time.y * 0.1) * 5 * TAU) ;
                //v.vertex.y = wave * _WaveAmp;
                v.vertex.y = GetWave(v.uv0) * _WaveAmp;

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




            //float xOffset = cos(i.uv.x * TAU * 6) * 0.01 ;

                return GetWave(i.uv);




            }
            ENDCG
        }
    }
}
