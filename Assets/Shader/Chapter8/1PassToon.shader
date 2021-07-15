Shader "ShaderStudy/Chapter8/1PassToon"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Toon noambient

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal (tex2D(_BumpMap, IN.uv_BumpMap));
            o.Alpha = c.a;
        }

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float3 viewDir, float attenuation)
        {
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

            ndotl *= 3;
            ndotl = ceil(ndotl) / 3;

            // Fresnel calculation
            float rim = abs(dot(s.Normal, viewDir));
            if (rim >= 0.3)
            {
                rim = 1;
            }
            else
            {
                rim = 0;
            }

            float4 final;
            final.rgb = ndotl * s.Albedo * _LightColor0.rgb * attenuation * rim;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
