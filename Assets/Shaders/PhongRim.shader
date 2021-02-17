Shader "Custom/PhongRim"
{
    Properties
    {
        _Albedo("Albedo", Color) = (1,1, 1, 1)
        _MainTex("Main Texture", 2D) = "white"{}
        [HDR] _EmissionColor("Emission Color", Color) = (1, 1, 1, 1)
        _RimPower("Rim Power", Range(0.0, 8.0)) = 1.0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        half4 _Albedo;
        float4 _EmissionColor;
        half _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 texColor = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = _Albedo * texColor;
            float3 viewDirNormalized = normalize(IN.viewDir);
            float3 VdotN = dot(viewDirNormalized, o.Normal); 
            fixed rim = 1 - saturate(VdotN);
            o.Emission = _EmissionColor * pow(rim, _RimPower);
        }

        ENDCG
    
    }
}