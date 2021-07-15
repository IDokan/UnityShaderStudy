Shader "ShaderStudy/Chapter8/2PassOutline"
{
    // 2Pass indicates we are going to draw same object twice. (once itself, once to draw outline which means heavy)
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _OutlineThickness ("Thickness of outline", Range(0, 100)) = 10
        _OutlineColor("Color of Outline", Color) = (0, 0, 0, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        cull front

        // 1st Pass
        CGPROGRAM
        #pragma surface surf Nolight noshadow noambient vertex:vert // let processor know name of my vertex shader

        sampler2D _MainTex;
        float _OutlineThickness;
        float4 _OutlineColor;

        // appdata_full is in UnityCG.cginc
            // about appdate struct
            // appdata_base : position, normal and one texture coordinate.
            // appdata_tan : position, tangent, normal and one texture coordinate.
            // appdata_full : position, tangent, normal and four texture coordinate and color.

                // struct appdata_full {
                // float4 vertex : POSITION;            represents position of vertex
                // float4 tangent : TANGENT;           represents tangent direction
                // float3 normal : NORMAL;              represents normal of vertex
                // float4 texcoord : TEXCOORD0;     represents first UV coordinate (do not worry about data type of this variable, usually use only float2)
                // float4 texcoord1 : TEXCOORD1;    represents second UV coordinate ; usually be used when use custom UV data for light map
                // float4 texcoord2 : TEXCOORD2;    represents third UV coordinate for special usage
                // float4 texcoord3 : TEXCOORD3;    represents fourth UV coordinate for special usage
                // fixed4 color : COLOR;                    represents vertex color
                // UNIRT_VERTEX_INPUT_INSTANCE_ID
                // };
        void vert(inout appdata_full v)
        {
            v.vertex.xyz = v.vertex.xyz + v.normal.xyz * 0.001 * _OutlineThickness;
        }

        struct Input
        {
            float color : COLOR;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {

        }

        float4 LightingNolight(SurfaceOutput s, float3 lightDir, float attenuation)
        {
            return _OutlineColor;
        }

        ENDCG


            cull back
       // 2st Pass
       CGPROGRAM
        #pragma surface surf Toon noambient

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten)
        {
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

            // method 1; using if statement. (However, book does not recommend if statements because it takes a huge works in mobile.
            if (ndotl > 0.5)
            {
                ndotl = 0.8;
            }
            else
            {
                ndotl = 0.3;
            }

            //// method 2; using ceil function.
            //int howManyTones = 2;
            //ndotl *= howManyTones;
            //ndotl = (ceil(ndotl) / howManyTones);
            //ndotl += (1 / (2 * howManyTones));

            float4 final;
            final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;
            final.a = s.Alpha;

            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
