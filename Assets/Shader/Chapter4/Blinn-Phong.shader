Shader "ShaderStudy/Chapter4/Blinn-Phong"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

        // _SpecColor is only defined in here.
        _SpecColor("Specular Color", color) = (1, 1, 1, 1)

        _SpecularInput("Specular Input", Range(0, 1)) = 0.5
        _GlossInput("Gloss Input", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf BlinnPhong

        sampler2D _MainTex;
        half _SpecularInput;
        fixed _GlossInput;

        // It would cause redifinition error
        // float4 _SpecColor;
        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Specular = _SpecularInput;
            o.Gloss = _GlossInput;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
