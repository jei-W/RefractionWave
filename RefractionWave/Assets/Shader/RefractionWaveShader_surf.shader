Shader "Custom/SurfaceShader/RefractionWaveShader_surf"
{
    Properties
    {
		_MainTex ("Refraction Texture", 2D) = "black" {}
		_RefStrength ("Refraction Strength", Range(0, 0.1)) = 0.05
    }
    SubShader
    {
		//다른 오브젝트들 보다 나중에 드로우 하여, 다른 오브젝트가 그려진 후 GrabPass가 실행되도록 한다
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" } 
		zwrite off

		GrabPass {}

        CGPROGRAM
        #pragma surface surf noLight noambient

		sampler2D _GrabTexture;
		sampler2D _MainTex;
		half _RefStrength;

        struct Input
        {
            fixed4 color : COLOR;
			float4 screenPos;
			float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;  //카메라 거리에따른 영향을 받지 않게한다
			fixed4 ref = tex2D(_MainTex, IN.uv_MainTex);

			o.Emission = tex2D(_GrabTexture, screenUV + ref.xy * _RefStrength);
        }

		fixed4 LightingnoLight (SurfaceOutput s, float3 lightDir, float atten)
		{
			return fixed4 (0,0,0,1);
		}

        ENDCG
    }

	// surface shader에서 fallback은 그림자패스와 연관이 있는 것 같다
	// fallback을 Transparent 계열을 씀으로써 그림자가 생기지 않도록 한다
    FallBack "Regacy Shaders/Transparent/Vertexlit"
}
