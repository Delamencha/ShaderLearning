Shader "Unlit/11ScrollingBackground"
{
    properties{
        _MainTex ("Base Layer (RGB)", 2D) = "white" {}
        _DetailTex ("2nd Layer (RGb)", 2D) = "white" {}
        _SCrollX ("Base Layer SCroll Speed", FLoat) = 1.0
        _SCroll2X ("2nd Layer SCroll Speed", FLoat) = 1.0
        _Multiplier ("Layer Multiplier", Float) = 1

    }

    SubShader{
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        
        Pass{
            Tags{"LightMode" = "ForwardBase"}

            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _DetailTex;
            float4 _DetailTex_ST;
            float _SCrollX;
            float _SCroll2X;
            float _Multiplier;

            struct a2v {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f{
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
            };

            v2f vert(a2v v){
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex) + frac(float2(_SCrollX, 0.0) * _Time.y);
                o.uv.zw = TRANSFORM_TEX(v.texcoord, _DetailTex) + frac(float2(_SCroll2X, 0.0) * _Time.y);
                return o;
            }   

            fixed4 frag(v2f i) : SV_Target{

                fixed4 firstLayer = tex2D(_MainTex, i.uv.xy);
                fixed4 secondLayer = tex2D(_DetailTex, i.uv.zw);

                fixed4 c = lerp(firstLayer, secondLayer, secondLayer.a);
                c.rgb *= _Multiplier;

                return c;
            } 
            ENDCG
            }
    }
    Fallback "VertexLit"
}
