Shader "ShaderStudy/Chapter10/EnhancedFireShader"
{
    Properties
    {
        _TintColor("Tint Color", Color) = (0.5, 0.5, 0.5, 0.5)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SecondaryTex("Secondary Texture", 2D) = "white"{}

        _Scaler("Fire velocity offset", Range(0, 5)) = 1

        [Enum(UnityEngine.Rendering.BlendMode)]_SrcBlend("SrcBlend Mode", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]_DstBlend("DstBlend Mode", Float) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True"}
        zwrite off
        cull off
        Blend [_SrcBlend] [_DstBlend]

        CGPROGRAM
        #pragma surface surf nolight keepalpha noforwardadd nolightmap noambient novertexlights noshadow

        sampler2D _MainTex;
        sampler2D _SecondaryTex;
        float4 _TintColor;
        float _Scaler;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SecondaryTex;
            float4 color:COLOR;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_SecondaryTex, fixed2(IN.uv_SecondaryTex.x, IN.uv_SecondaryTex.y - (_Time.y * _Scaler)));
            c = c * d * 2 * _TintColor * IN.color;
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
