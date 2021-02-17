Shader "Custom/NormalStrenght"
{
    Properties 
    {
        _Albedo("Albedo color", Color) = (1, 1, 1, 1)
        _MainTex("Main Texture", 2D) = "white" {}
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
            #pragma surface surf Lambert

            float4 _Albedo;
            sampler2D _MainTex;
            sampler2D _NormalTex;
            float _NormalStreght;

            struct Input
            {
                float2 uv_MainTex;
                float2 uv_NormalTex;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                half4 texColor = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = _Albedo * texColor;

                half4 normalMapColor = tex2D(_NormalTex, IN.uv_NormalTex);
                half3 normal = UnpackNormal(normalMapColor);
                normal.z = normal.z / _NormalStreght;
                o.Normal = normal;
            }
        ENDCG
    }
}
