Shader "ShaderStudy/Chapter11/Leaves"
{
    Properties
    {
        // Shadow does not work when _Color parameter is missed
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Cutoff("Cutoff", float) = 0.5
        _Move("Move", Range(0, 0.5)) = 0.1
        _Timeing("Timeing", Range(0, 5)) = 1
    }
    SubShader
    {
        // RenderType : Transparent - most semitransparent shaders
        // RenderType : TransparentCutout - masked transparency shaders
        // Queue : AlphaTest - alpha tested geometry uses this queue. It's a separate queue from 'Geometry' one (which is default queue) since it's more efficient to render alpha-tested objects after all solid ones are drawn.
        // Queue : Transparent - this render queue is renderd after 'Geometry' and 'AlphaTest', in back-to-front order. Anything alpha-blended (i.e. shaders that don't write to depth buffer) should go here (glass, particle effects)
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }

        cull off
        CGPROGRAM
        // Reminder!! :: this line is called 'snippet'
        // alpha:fade - Enable traditional fade-transparency.
        // alphatst:VariableName - Enable alpha cutout transparency. Cutoff value is in a float variable with VariableName. You'll likely also want to use 'addshadow' directive to generate proper shadow caster pass.
        #pragma surface surf Lambert alphatest:_Cutoff vertex:vert addshadow

        sampler2D _MainTex;
        float _Move;
        float _Timeing;

        struct Input
        {
            float2 uv_MainTex;
        };

        void vert(inout appdata_full v)
        {
            v.vertex.y += sin(_Time.y * _Timeing) * _Move * v.color.r;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
}
