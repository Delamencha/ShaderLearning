Shader "Unlit/Shader1-3"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Pattern ("Pattern", 2D) = "white" {}
        _Rock("Rock", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"


            #define TAU 6.28318530718

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;

                float4 vertex : SV_POSITION;

                float3 worldPos : TEXCOORD1;

            };

            sampler2D _MainTex;
            sampler2D _Pattern;
            sampler2D _Rock;
            float4 _MainTex_ST;


            float GetWave(float coord)
            {
                float wave = cos((coord - _Time.y * 0.1) * 5 * TAU) * 0.5 + 0.5;
                wave *= 1 - coord;
                return wave;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.worldPos = mul(UNITY_MATRIX_M, v.vertex);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {

                float2 topDownProjection = i.worldPos.xz;
                float4 moss = tex2D(_MainTex, topDownProjection);
                float4 rock = tex2D(_Rock, topDownProjection);

                float pattern = tex2D(_Pattern, i.uv);

                float4 finalColor = lerp(rock, moss, pattern);

                return finalColor;
            }
            ENDCG
        }
    }
}
