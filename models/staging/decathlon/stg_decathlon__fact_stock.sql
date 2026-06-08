with source as (
    select * from {{ source('decathlon_raw', 'fact_stock') }}
),

renamed as (
    select
        cast(stock_date as date) as stock_date,
        cast(store_code as string) as store_code,
        cast(item_code as string) as item_code,
        cast(top_suivi as boolean) as is_tracked,
        cast(top_available_stock as boolean) as is_available_in_stock
    from source
)

select * from renamed