Shader "ShaderStudy/Chapter11/Water"
{
    Properties
    {
        _BumpTex("Bump map", 2D) = "white"{}
        _Cube("Cube", Cube) = "" {}
        _RimMultiplier("Rim Multiplier", Range(1, 5)) = 3
        _EmissionScaler("Emission Scaler", Range(1, 5)) = 2
        _AlphaOffset("Alpha offset", Range(0, 1)) = 0.5

        _SpecularColor("Specular Color", Color) = (1, 1, 1, 1)
        _SpecularPower("Specular Power", Range(50, 300)) = 300
        _SpecularMultiply("Specular Multiply", Range(1, 10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf WaterSpecular alpha:fade

        sampler2D _BumpTex;
        samplerCUBE _Cube;
        float _RimMultiplier;
        float _EmissionScaler;
        float _AlphaOffset;

        float4 _SpecularColor;
        float _SpecularPower;
        float _SpecularMultiply;

        struct Input
        {
            float2 uv_BumpTex;
            float3 worldRefl;
            INTERNAL_DATA
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float3 normal1 = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex + _Time.x * 0.1));
            float3 normal2 = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex - _Time.x * 0.1));
            o.Normal = (normal1 + normal2) / 2;
            float3 refColor = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));

            float rim = saturate(dot(IN.viewDir, o.Normal));
            rim = pow(1 - rim, _RimMultiplier);
            // Reason why multiplied is to hide reflected part of transparent.
            o.Emission = refColor * rim * _EmissionScaler;

            o.Alpha = saturate(rim + _AlphaOffset);
        }

        float4 LightingWaterSpecular(SurfaceOutput s, float3 lightDir, float3 viewDir, float attenuation)
        {
            // Specular Term
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(H, s.Normal));
            spec = pow(spec, _SpecularPower);

            // final term
            float4 finalColor;
            finalColor.rgb = spec * _SpecularColor.rgb * _SpecularMultiply;
            finalColor.a = s.Alpha + spec;

            return finalColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
