Shader "ShaderStudy/Chapter11/Practices/Hologram Kyle"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Scaler("Scaler", Range(0.1, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        zwrite on
        COLORMASK 0
        CGPROGRAM
        // These are keyword to do nothing (optimization)
        // nolight - my lighting which just return (0, 0, 0, 0)
        // noambient - Disables ambient lighting and spherical harmonics lights on a shader.
        // noforwardadd - Disables forward rendering additive pass. This makes the shader support only one important directional light. Other less important lights computed per-vertex/SH. Makes shaders smaller
        // nolightmap - Disables all lightmapping support in this shader.
        // novertexlights - Do not apply any light probes or per-vertex lights in Forward rendering
                // light probes - Similar to lightmaps, light probes store "baked" information about lighting in your scene. the Different is light probes store information about light passing through empty space in your scene.
        // noshadow - disables all shadow receiving support in this shader
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
            return (0, 0, 0, 0);
        }
        ENDCG

        zwrite off
        CGPROGRAM
        // alpha:fade - enable traditional fade-transparency.
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        float _Scaler;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;

            float rim = (saturate(1 - dot(o.Normal, IN.viewDir)));

            o.Alpha = rim;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
