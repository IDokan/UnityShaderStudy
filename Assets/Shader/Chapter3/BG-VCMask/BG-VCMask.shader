Shader "ShaderStudy/Chapter3/BG-VCMask"
{
    Properties
    {
        _MainTex1("Texture", 2D) = "white" {}
        _MainTex2("Texture", 2D) = "white" {}
        _MainTex3("Texture", 2D) = "white" {}
        _MainTex4("Texture", 2D) = "white" {}

        _BumpMap("Normal Map", 2D) = "bump" {}

        _Metallic("Metallic", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Standard 

        #pragma target 3.0

        sampler2D _MainTex1;
        sampler2D _MainTex2;
        sampler2D _MainTex3;
        sampler2D _MainTex4;
        sampler2D _BumpMap;

        float _Metallic;
        float _Smoothness;

        struct Input
        {
            float2 uv_MainTex1;
            float2 uv_MainTex2;
            float2 uv_MainTex3;
            float2 uv_MainTex4;
            float2 uv_BumpMap;
            fixed4 color : COLOR;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex1, IN.uv_MainTex1);
            fixed4 d = tex2D(_MainTex2, IN.uv_MainTex2);
            fixed4 e = tex2D(_MainTex3, IN.uv_MainTex3);
            fixed4 f = tex2D(_MainTex4, IN.uv_MainTex4);

            fixed4 n = tex2D(_BumpMap, IN.uv_BumpMap);
            o.Normal = UnpackNormal(n);

            o.Albedo = d * IN.color.r + e * IN.color.g + f * IN.color.b + c * (1 - (IN.color.r + IN.color.g + IN.color.b));
            o.Metallic = _Metallic;
            o.Smoothness = (_Smoothness * (1 - (IN.color.r + IN.color.g + IN.color.b))) * 0.5 + 0.3;
            o.Alpha = c.a;
        }
        ENDCG
    }
        FallBack "Diffuse"
}
