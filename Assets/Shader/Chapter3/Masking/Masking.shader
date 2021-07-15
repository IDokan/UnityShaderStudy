Shader "ShaderStudy/Chapter3/Masking"
{
    Properties
    {
        _MainTex1("Texture", 2D) = "white" {}
        _MainTex2("Texture", 2D) = "white" {}
        _MainTex3("Texture", 2D) = "white" {}
        _MainTex4("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard 

        sampler2D _MainTex1;
        sampler2D _MainTex2;
        sampler2D _MainTex3;
        sampler2D _MainTex4;

        struct Input
        {
            float2 uv_MainTex1;
            float2 uv_MainTex2;
            float2 uv_MainTex3;
            float2 uv_MainTex4;
            fixed4 color : COLOR;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex1, IN.uv_MainTex1);
            fixed4 d = tex2D(_MainTex2, IN.uv_MainTex2);
            fixed4 e = tex2D(_MainTex3, IN.uv_MainTex3);
            fixed4 f = tex2D(_MainTex4, IN.uv_MainTex4);

            o.Albedo = d * IN.color.r + d * IN.color.g + f * IN.color.b + c * (1 - IN.color.r + IN.color.g + IN.color.b);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
