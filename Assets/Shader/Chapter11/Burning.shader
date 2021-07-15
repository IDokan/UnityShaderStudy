Shader "ShaderStudy/Chapter11/Burning"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _Cut("Alpha Cut", Range(0, 1)) = 0
        _OutlineScaler("Alpha Outline Scaler", Range(1, 2)) = 1.15
        [HDR]_OutColor("OutColor", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        COLORMASK 0
        CGPROGRAM
        #pragma surface surf nolight noambient noforwardadd noshadow novertexlights nolightmap

        struct Input
        {
        float4 color : COLOR;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {

        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float attenuation)
        {
            return (0, 0, 0, 0);
        }
        ENDCG

            zwrite off
            blend SrcAlpha One
            CGPROGRAM
            #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float _Cut;
        float _OutlineScaler;
        float4 _OutColor;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            float4 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);
            o.Albedo = c.rgb;

            float alpha;
            if (noise.r >= _Cut)
            {
                alpha = 1;
            }
            else
            {
                alpha = 0;
            }

            if (noise.r < _Cut * _OutlineScaler)
            {
                o.Emission = _OutColor;
            }
            o.Alpha = c.a * alpha;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
