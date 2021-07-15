Shader "ShaderStudy/Chapter7/Blinn-Phong"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}
        _SpecCol("Specular Color", Color) = (1, 1, 1, 1)
        _SpecPow("Specular Power", Range(10, 200)) = 100
        _RimCol("Rim Color", Color) = (0.5, 0.5, 0.5, 0.5)
        _RimPow("Rim Power", Range(1, 25)) = 6
        _FakeSpecCol("Fake Specular Color", Color) = (0.2, 0.2, 0.2, 0.2)
        _FakeSpecPow("Fake Specular Power", Range(1, 200)) = 50
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Test noambient

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _SpecCol;
        float _SpecPow;
        float4 _RimCol;
        float _RimPow;
        float4 _FakeSpecCol;
        float _FakeSpecPow;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float3 viewDir, float attenuation)
        {
            // Lambert calculation
            float ndotl = saturate(dot(s.Normal, lightDir));
            float3 diffColor = ndotl * s.Albedo * _LightColor0.rgb * attenuation;

            // Spec calculation
            float3 H = normalize(lightDir + viewDir);
            float specColor = saturate(dot(H, s.Normal));
            // specular is too wide to apply. -> add pow calculation to adjust accordingly
            float3 mySpecularColor = pow(specColor, _SpecPow) * _SpecCol.rgb;

            // Rim calculation
            float3 rimColor;
            float rim = abs(dot(viewDir, s.Normal));
            float invrim = 1 - rim;
            rimColor = pow(invrim, _RimPow) * _RimCol.rgb;

            // Fake Spec with Rim
            float3 fakeSpecColor;
            fakeSpecColor = pow(rim, _FakeSpecPow) * _FakeSpecCol.rgb/* * s.Gloss .. when gloss map is activated */;

            // final calculation
            float4 final;
            final.rgb = diffColor + mySpecularColor + rimColor + fakeSpecColor;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
