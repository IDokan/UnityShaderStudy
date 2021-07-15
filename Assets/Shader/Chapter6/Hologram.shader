Shader "ShaderStudy/Chapter6/Hologram"
{
    Properties
    {
        _BumpMap ("NormalMap", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (1, 1, 1, 1)
        _RimPower("Rim Power", Range(1, 10)) = 3
        _LinePower("Line Power", Range(5, 50)) = 30
        _BlinkSpeed("Blink Speed", Range(1, 10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf nolight noambient alpha:fade

        sampler2D _BumpMap;
        float3 _RimColor;
        float _RimPower;
        float _LinePower;
        float _BlinkSpeed;

        struct Input
        {
            float2 uv_BumpMap;
            float3 viewDir;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));
            o.Emission = _RimColor;

            float rim = saturate(dot(o.Normal, IN.viewDir));
            // Original
            // o.Alpha = pow(1 - rim, _RimPower);
            // Blink Hologram
            // o.Alpha = pow(1 - rim, _RimPower) * abs(sin(_Time.y * _BlinkSpeed));
            // LineMoving
             o.Alpha = saturate(pow(1 - rim, _RimPower) + abs(sin(_Time.y * _BlinkSpeed * 0.25)) * pow(frac(IN.worldPos.g * 3 - _Time.y), _LinePower));
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, s.Alpha);
        }

        ENDCG
    }
    FallBack "Diffuse"
}
