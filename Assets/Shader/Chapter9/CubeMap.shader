Shader "ShaderStudy/Chapter9/CubeMap"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Normal("Normal Map", 2D) = "white" {}
        _Cube("Cubemap", Cube) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert noambient

        sampler2D _MainTex;
        sampler2D _Normal;
        samplerCUBE _Cube;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Normal;
            // float3 worldRefl - contains world reflection vector if surface shader does not write to o.Normal. See Reflect-Diffuse shader for example.
            // float3 worldRefl; INTERNAL_DATA - contains world reflection vector if surface shader writes to o.Normal.To get the reflection vector based on per - pixel normal map, use WorldReflectionVector(IN, o.Normal).
            float3 worldRefl;
            INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {

            //// When do this, we get an error because...
            //o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));        // In this function, we are using normal data which is derived by UnpackNormal function that is 'tangent normal' in fact 
            //float4 re = texCUBE(_Cube, IN.worldRefl);                                    // while we are using data about 'vertex world normal' such as float3 worldRefl, or float3 worldNormal in Input.

            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            float4 re = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
            o.Albedo = c.rgb * 0.75;
            o.Emission = re.rgb * 0.25;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
