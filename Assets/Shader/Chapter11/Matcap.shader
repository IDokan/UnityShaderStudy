// 1. Matcap is a kind of IBL(Image Based Lighting)

Shader "ShaderStudy/Chapter11/Matcap"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}
        _MatcapTex("Material Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf nolight noambient

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _MatcapTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_MatcapTex;
            float3 worldNormal;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            float3 worldNormal = WorldNormalVector(IN, o.Normal);
            // UNITY_MATRIX_V is a 'view coordinate' matrix in Unity. mul function is for multiplication between matrix and vector
            float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, worldNormal);

            float2 MatcapUV = viewNormal.xy * 0.5 + 0.5;
            o.Emission = c * tex2D(_MatcapTex, MatcapUV);
            o.Alpha = c.a;
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float attenuation)
        {
            return float4(0, 0, 0, s.Alpha);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
