Shader "ShaderStudy/Chapter5/CustomLambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("NormalMap", 2D) = "normal"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        // PBR ->               Standard
        // Blinn-Phong ->   BlinnPhong
        // Lambert ->          Lambert
        // Custom ->           Whatever
        // In this line, I named custom lighting as Test to test something.
        #pragma surface surf Test 
        //                                  ㄴ> Light naming

        sampler2D _MainTex;
        sampler2D _NormalMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
        };

        // ★First
        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Alpha = c.a;
        }

        // ★Second
        // In order to refered as light function, We have to follow the naming convention
        // naming convention : Lighting + (Light name)
        float4 LightingTest(SurfaceOutput s, float3 lightDir, float atten)
            //                                                                                      ㄴ> abbreviation for attenuation, use this when I remove receiving light.
        {
            // saturate == clamping
            float ndotl = (dot(s.Normal, lightDir)) * 0.5 + 0.5;
            float4 final;
            final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;
            final.a = s.Alpha;

            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
