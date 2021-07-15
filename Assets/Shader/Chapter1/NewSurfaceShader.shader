// The right below code is a setting of current shader.
Shader "ShaderStudy/Chapter1/TestShader"
{
    // This is a part to customize interface.
    Properties
    {
        // My custom Properties
        _MyCustomProperty1 ("My custom property 1", Range(0, 1)) = 0.1
        _MyCustomProperty2 ("My custom property 2", Vector) = (0, 0, 0, 0)
        _MyCustomProperty3 ("My custom property 3", 3D) = "custom" {}
        _Brightness ("change Brightness!!", Range(0, 1)) = 0.5
        _Offset ("Offset for unknown", float) = 0
        _SecondaryColor ("2nd Color", Color) = (0, 0, 0, 0)
        _Texture2D("Texture 2D", 2D) = "unspecified" {}

        // Test properties
        //_TestColor("testColor", Color) = (1, 1, 1, 1)
        _Red("Red", Range(0, 1)) = 1
        _Green("Green", Range(0, 1)) = 1
        _Blue("Blue", Range(0, 1)) = 1
        _BrightDark ("Brightness $ Darkness", Range(-1, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
/*
Default Setting part. It can be reffered as Preprocessor or called "snippet". Details will be discussed later
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
*/

#pragma surface surf Standard fullforwardshadows

        struct Input
        {
            float4 color : COLOR;
        };

        fixed4 _TestColor;

        half _Red;
        half _Green;
        half _Blue;
        half _BrightDark;

/*
    definition of SurfaceOutputStandard

    struct SurfaceOutputStandard
    {
        fixed3 Albedo;
        fixed3 Normal;
        fixed3 Emission;
        half Metallic;
        half Smoothness;
        half Occlusion;
        half Alpha;
    };
*/
/*
    What is float / half / fixed?
    half is a half size version of float.
    fixed is even smaller version of half

    fixed is enough to store Color or Length of vector values.
    half is good to use if you deal with values which needed precision .
*/
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            /*
                o.Albedo values get lighting calculation eventually.
                Meanwhile, o.Emission does not.
                Therefore, o.Emission is prefered when we want to see a pure result.

                    o.Albedo and o.Emission are added at the end.
                    In other words, result color become brighter inevitably when we use both of them (o.Albedo & o.Emission)


            o.Emission = fixed3(1, 0, 0) + fixed3(0, 1, 0);

            */

            /*
            When your final result is over than 1. In the variable, it contains bigger pure value eventually. In other words, they do not climp the values
            o.Emission = fixed3(1, 0, 0) + fixed3(1, 0, 0) - fixed3(0.2, 0, 0); -> fixed(1.8, 0, 0)
            o.Emission = fixed3(1, 0, 0) + fixed3(1, 0, 0) - fixed3(0.8, 0, 0); -> fixed(1.2, 0, 0)
            o.Emission = fixed3(1, 0, 0) + fixed3(1, 0, 0) - fixed3(1.8, 0, 0); -> fixed(0.2, 0, 0)
            */

            /*
            float4 test = float4(1, 0, 0, 1);

            Unity accept all of below cases.
            o.Albedo = test.rgb;
            o.Albedo = test.rrr;
            o.Albedo = test.gbr;
            o.Albedo = test.bgr;
            */
            /*
            Advanced use of variables in Unity

            float r = 1;
            float2 gg = float2(0.5, 0);
            float3 bbb = float3(1, 0, 1);

            o.Albedo = float3(bbb.b, gg.r, r.r);
            */
            o.Albedo = float3(_Red, _Green, _Blue) + _BrightDark;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
