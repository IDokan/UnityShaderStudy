// In order to avoid drawing complex models that are transparent and wierd, use 2pass drawing.
// At the first pass, write z values on z-buffer but draw nothing.
// second pass, based on z values, draw transparent model successfully.

Shader "ShaderStudy/Chapter11/AlphaBlendingWith2Pass"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Scaler ("Transparent Scale", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }

        // 1st pass, zwrite on, rendering off
        zwrite on
        ColorMask 0
        CGPROGRAM
        #pragma surface surf nolight noambient noforwardadd nolightmap novertexlights noshadow

        sampler2D _MainTex;

        struct Input
        {
            float4 color:COLOR;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float attenuation)
        {
            return float4(0, 0, 0, 0);
        }
        ENDCG

        // 2nd pass, zwrite off, rendering on
        zwrite off
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        float _Scaler;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = _Scaler;
        }
        ENDCG

    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
