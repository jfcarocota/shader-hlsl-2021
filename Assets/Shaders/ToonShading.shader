Shader "Custom/ToonShading"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _Albedo("Albedo Color", Color) = (1, 1, 1, 1)
        _RampTex("Ramp Texture", 2D) = "white" {}
        _FallOff("FallOff", Range(0.1, 0.5)) = 0.1
        [HDR] _EmissionColor("Emission Color", Color) = (1, 1, 1, 1)
        _RimPower("Rim Power", Range(0.0, 8.0)) = 1.0
        _NormalTex("Bump Map", 2D) = "bump"{}
        _NormalStreght("Normal Strenght", Range(-2.0, 2.0)) = 1.0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
        
        #pragma surface surf Toon

        sampler2D _MainTex;
        sampler2D _RampTex;
        half4 _Albedo;
        half _FallOff;
        float4 _EmissionColor;
        half _RimPower;
        sampler2D _NormalTex;
        float _NormalStreght;

        half4 LightingToon(SurfaceOutput s, half3 lightDir, half atten)
        {
            half NdotL = dot(s.Normal, lightDir);
            half diff = NdotL * _FallOff + _FallOff;
            float x = NdotL * 0.5 + 0.5;
            float2 uv_RampTex = float2(x, 0);
            half4 rampColor = tex2D(_RampTex, uv_RampTex);
            half4 c;
            c.rgb = s.Albedo * NdotL * _LightColor0.rgb * rampColor * atten * diff;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float2 uv_NormalTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            //Diffuse
            half4 mainTexColor = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = mainTexColor * _Albedo;

            //Bump Map
            half4 normalMapColor = tex2D(_NormalTex, IN.uv_NormalTex);
            half3 normal = UnpackNormal(normalMapColor);
            normal.z = normal.z / _NormalStreght;
            o.Normal = normal;

            //Rim light
            float3 viewDirNormalized = normalize(IN.viewDir);
            float3 VdotN = dot(viewDirNormalized, o.Normal); 
            fixed rim = 1 - saturate(VdotN);
            o.Emission = _EmissionColor * pow(rim, _RimPower);
        }

        ENDCG
    }
}