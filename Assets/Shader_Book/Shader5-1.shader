// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'



Shader "Unlit/Shader5-1"
{
    Properties{
        _Color ("Color Tint", Color) = (1.0, 1.0,1.0,1.0)
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _Color;

            // struct a2v {
            //     float4 vertex : POSITION;
            //     float3 normal : NORMAl;
            //     float4 texcoord : TEXCOORD0;
            // };

            struct v2f{
                float4 pos : SV_POSITION;
                fixed4 color : COLOR0;
            };

            v2f vert(appdata_full v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                // //法线
                // o.color = fixed4(v.normal * 0.5 + fixed3(0.5, 0.5, 0.5) , 1.0);

                // //切线
                // o.color = fixed4(v.tangent.xyz * 0.5 + fixed3(0.5, 0.5, 0.5) , 1.0);

                // //副切线
                // fixed3 binormal = cross(v.normal, v.tangent.xyz) * v.tangent.w;
                // o.color = fixed4(binormal * 0.5 + fixed3(0.5, 0.5, 0.5) , 1.0);

                // //第一组纹理坐标
                // o.color = fixed4(v.texcoord.xy, 1.0, 1.0);

                // //第二组纹理坐标
                // o.color = fixed4(v.texcoord1.xy, 1.0, 1.0);

                // //第一组纹理坐标的小数部分
                 o.color = frac(v.texcoord);
                 if( any(saturate(v.texcoord) - v.texcoord)){
                     o.color.b = 0.5;
                 }
                o.color.a = 1.0;

                // //第二组纹理坐标的小数部分
                //  o.color = frac(v.texcoord1);
                //  if( any(saturate(v.texcoord1) - v.texcoord1)){
                //      o.color.b = 0.5;
                //  }
                //  o.color.a = 1.0;

                //顶点颜色
                //o.color = v.color;

                return o;
            }
                
            fixed4 frag(v2f i) : SV_Target {

                return i.color;
            }

            ENDCG
        }
    }
}
