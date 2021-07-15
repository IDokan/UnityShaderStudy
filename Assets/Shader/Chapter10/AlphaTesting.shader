Shader "ShaderStudy/Chapter10/AlphaTesting"
{
    Properties
    {
        // We do not use color in my shader, but have to create outline because it is used by another pass we cannot see now probably for color of shader but no changes occuerred when changed color.
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        // How tough to cut pixels..... I think I need much details though
        _Cutoff("Alpha cutoff", Range(0, 1)) = 0.5
    }
    SubShader
    {
                                                                            // Queue sequence) Opaque -> Alpha testing -> Alpha blending
        Tags { "RenderType"="TransparentCutout" "Queue" = "AlphaTest" }
        // Alpha testing is much fater than alpha blending in PC
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert alphatest:_Cutoff

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
}
