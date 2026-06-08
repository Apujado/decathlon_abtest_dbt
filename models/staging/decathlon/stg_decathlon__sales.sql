with source as (
    select * from {{ source('decathlon_raw', 'fact_sales') }}
),

renamed as (
    select
        cast(transaction_id as string) as transaction_id,
        cast(transaction_date as date) as transaction_date,
        cast(store_code as string) as store_code,
        cast(transaction_channel_type as string) as transaction_channel_type,
        cast(item_code as string) as item_code,
        cast(item_operation_type as string) as item_operation_type,
        cast(quantity as int64) as quantity,
        cast(gmv as float64) as gmv_turnover
    from source
)

select * from renamed