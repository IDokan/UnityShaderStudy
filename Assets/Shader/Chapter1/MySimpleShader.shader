Shader "ShaderStudy/Chapter1/MySimpleShader"
{
    Properties
    {
        _Red("Red", Range(0, 1)) = 1
        _Green("Green", Range(0, 1)) = 1
        _Blue("Blue", Range(0, 1)) = 1
        _BrightDark("Brightness & Darkness", Range(-1, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        struct Input
        {
            float4 color : COLOR;
        };

    half _Red;
    half _Green;
    half _Blue;
    half _BrightDark;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = float3(_Red, _Green, _Blue) + _BrightDark;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
