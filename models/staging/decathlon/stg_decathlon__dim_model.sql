with source as (
    select * from {{ source('decathlon_raw' , 'dim_model') }}
),

renamed as (
    select
        cast(item_code as string) as item_code,
        cast(model_code as string) as model_code,
        cast(model_name as string) as model_name,
        cast(product_weight as float64) as product_weight,
        cast(product_nature as string) as product_nature,
        cast(range_item as float64) as item_range, -- Float car il y a des valeurs manquantes dans Pandas
        cast(picture_url as string) as picture_url
    from source
)

select * from renamed