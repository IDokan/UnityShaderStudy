Shader "ShaderStudy/Chapter10/SimpleEmededParticleShader"
{
    Properties
    {
        // Default color is grey, which is able to make image brighter when _TintColor is white nad darker when _TintColor is black.
        _TintColor ("Tint Color", Color) = (0.5, 0.5, 0.5, 0.5)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // IgnoreProjector -> it is a setting which make it not react. Not only need to be here because a lot of ways to enable this setting.
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True" }
        zwrite off
        blend SrcAlpha One
        cull off

        CGPROGRAM
                                                                        // these options minimize variants (variants is additional shaders to do extra calculations)
        #pragma surface surf nolight keepalpha noforwardadd nolightmap noambient novertexlights noshadow

        sampler2D _MainTex;
        float4 _TintColor;

        struct Input
        {
            float2 uv_MainTex;
            // enable particle color option
            float4 color:COLOR;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            c = c * 2 * _TintColor * IN.color;
            o.Emission = c.rgb;
            o.Alpha = c.a;
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float attenuation)
        {
            return float4(0, 0, 0, s.Alpha);
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
