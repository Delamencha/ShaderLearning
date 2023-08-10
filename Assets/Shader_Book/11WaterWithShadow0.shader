Shader "Unlit/11WaterWithShadow0"
{
    properties{
        _MainTex ("Base Layer (RGB)", 2D) = "white" {}
        _Color ("Color Tint", Color) = (1,1,1,1)
        _Magnitude ("Distortion Magnitude", Float ) = 1
        _Frequencey ("Disortion Frequency", Float) = 1
        _InvWaveLength ("Disortion Inverse Wave Length", Float) = 10
        _Speed ("Speed", Float) = 0.5

    }

    SubShader{
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector" = "True" "DisableBatching" = "true"}
        
        Pass{
            Tags{"LightMode" = "ForwardBase"}

            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            Cull off
        
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _Magnitude;
            float _Frequencey;
            float _InvWaveLength;
            float _Speed;

            struct a2v {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f{
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(a2v v){
                v2f o;

                float4 offset;
                offset.yzw = float3(0.0, 0.0, 0.0);
                offset.x = sin(_Frequencey * _Time.y + v.vertex.x * _InvWaveLength + v.vertex.y * _InvWaveLength + v.vertex.z * _InvWaveLength) * _Magnitude;
                
                o.pos = UnityObjectToClipPos(v.vertex + offset);

                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv += float2(0.0, _Time.y * _Speed);
                //o.uv += float2( _Time.y * _Speed ,0.0);

                return o;
            }   

            fixed4 frag(v2f i) : SV_Target{

                fixed4 c = tex2D(_MainTex, i.uv);

                c.rgb *= _Color;

                return c;

            } 
            ENDCG
            }
    }
    Fallback "VertexLit"
}
