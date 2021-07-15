Shader "ShaderStudy/Chapter10/CustomBlending"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff("Alpha Cut off", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        zwrite off

        // This is a blending option. There are a few of factors to apply.
        // One
        // Zero
        // SrcColor
        // SrcAlpha
        // DstColor
        // DstAlpha
        // OneMinus SrcColor
        // OneMinusSrcAlpha
        // OneMinusDstColor
        // OneMinusDstAlpha

        // Typically, there are five combinations.
        // 1. Blend SrcAlpha OneMinusSrcAlpha - Alpha blending                        // No brighter and no darker, just look they are added
        // 2. Blend SrcAlpha One - Additive                                                      // Become brighter. Usually used in explosions.
        // 3. Blend One One - Additive / No Alpha / Black is Transparent        // Retrench Alpha channel / Black becomes transparent / Cannot use Alpha blending
        // 4. Blend DstColor Zero - Multiplicative                                              // Usually used in effects / It shows destination when source image is white / Do not use Alpha channel
        // 5. Blend DstColor SrcColor - 2x Multiplicative                                   
        blend SrcAlpha OneMinusSrcAlpha

        // Relationship between blending and Z-buffer
            // Even though we give up z value issue, effects work because looks okay. (Actually, front and back sequences are different in every frame.)
            // However, when we deal with add effect and multiply effect together, problems occurred. Players can see the errors.
            // In this case, there are no solutions though, we need mitigations such as take care distance between pivot and camera.

        CGPROGRAM
        #pragma surface surf Lambert keepalpha       // keep alpha - After Unity 5.0, surface shader writes 1.0 to Alpha as default value for all opaque shader. This keyword prevents it from happening.

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
}
