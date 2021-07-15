Shader "ShaderStudy/Chapter2/CoolFire"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SecondTex("Secondary Texture", 2D) = "black" {}

        _Scaler("Scaler", Range(0, 5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf Standard alpha:fade

        sampler2D _MainTex;
        sampler2D _SecondTex;
        float _Scaler;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SecondTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 d = tex2D(_SecondTex, IN.uv_SecondTex - _Time.y);
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex - (d.r * _Scaler));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
