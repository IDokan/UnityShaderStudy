Shader "ShaderStudy/Chapter11/refraction"
{
    Properties
    {
        _MainTex("Albedo RGB", 2D) = "white"{}
        _RefStrength("Refraction Strength", Range(0, 0.1)) = 0.05
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
        
        // It is a kind of capture of screen. We are going to use sampler2D _GrabTexture to get the capture of the screen.
        GrabPass{}

        zwrite off

        CGPROGRAM
        #pragma surface surf nolight noambient alpha:fade

        sampler2D _GrabTexture;
        sampler2D _MainTex;
        float _RefStrength;

        struct Input
        {
            float4 color : COLOR;
            // It's for UV coordinate for current screen.
            float4 screenPos;
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            float4 ref = tex2D(_MainTex, float2(IN.uv_MainTex.x + _Time.y, IN.uv_MainTex.y));
            float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
            o.Emission = tex2D(_GrabTexture, float2((screenUV.x + (ref.x) * _RefStrength), screenUV.y));
        }

        float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float attenuation)
        {
            return float4(0, 0, 0, 1);
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
