with sales as (
    select * from {{ ref('stg_decathlon__fact_sales') }}
),

stores as (
    select * from {{ ref('stg_decathlon__dim_store') }}
),

models as (
    select * from {{ ref('stg_decathlon__dim_model') }}
),

stock as (
    select * from {{ ref('stg_decathlon__fact_stock') }}
),

-- 1. Filtrage rigoureux des magasins (uniquement ceux avec le Kit 10kg dispo en période pré-test)
eligible_stores as (
    select distinct stk.store_code
    from stock stk
    inner join models m on stk.item_code = m.item_code
    where lower(m.model_name) = 'kit 10kg' 
      and extract(week from stk.stock_date) between 28 and 34
      and stk.is_available_in_stock = true
),

-- 2. Alignement des ventes sur les deux périodes uniquement
enriched_sales as (
    select
        s.transaction_id,
        s.store_code,
        s.item_code,       -- Gardé pour descendre au niveau article en BI
        s.quantity,
        s.gmv_turnover,
        st.is_tested_region,
        m.model_name,      -- Gardé pour l'affichage principal
        m.picture_url,        -- Ajout de l'URL de l'image pour la dataviz 
        m.product_nature,  
        
        -- Classification binaire des périodes
        case 
            when extract(week from s.transaction_date) between 35 and 41 then '2. Période Test'
            when extract(week from s.transaction_date) between 28 and 34 then '1. Période Pré Test'
        end as test_period,

        -- Indicateur simple pour isoler la cible
        case 
            when lower(m.model_name) = 'kit 10kg' then 'Target'
            else 'Alternative'
        end as product_type

    from sales s
    inner join stores st on s.store_code = st.store_code
    inner join models m on s.item_code = m.item_code
    inner join eligible_stores es on s.store_code = es.store_code
    where extract(week from s.transaction_date) between 28 and 41 
)

-- 3. Agrégation finale directe par Période / Modèle / Article / Image
select
    store_code,
    is_tested_region,
    test_period,
    product_type,
    product_nature,
    model_name,
    item_code, --  Ajouté ici pour le groupement
    picture_url, 
    sum(quantity) as total_quantity_sold,
    sum(gmv_turnover) as total_revenue_gmv,
    count(distinct transaction_id) as total_transactions
from enriched_sales
group by 1, 2, 3, 4, 5, 6, 7,8