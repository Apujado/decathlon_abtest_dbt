with source as (
    select * from {{ source('decathlon_raw', 'dim_store') }}
),

renamed as (
    select
        cast(store_code as string) as store_code,
        cast(sales_area as float64) as sales_area,
        cast(location as string) as location,
        cast(is_tested_region as boolean) as is_tested_region, -- Notre colonne magique pour l'A/B test !
        cast(family_range as int64) as family_range
    from source
)

select * from renamed