/*
===============================================================================
Silver Layer - Data Cleansing & Transformation

Source:
    retail_bronze.raw_transactions

Target:
    retail_silver.cleaned_transactions

Transformations:
1. Converts signup_date to DATE.
2. Replaces missing signup_date with purchase_date.
3. Converts is_returned to BOOLEAN.
4. Replaces missing is_returned values with FALSE.
5. Removes invalid transactions (amount <= 0).
6. Trims whitespace from string columns.
7. Standardises item_category values to uppercase.
8. Removes duplicate transaction IDs.
9. Handles invalid signup dates occurring after purchase dates.
10. Creates days_to_first_purchase.
===============================================================================
*/

CREATE OR REPLACE TABLE
`project-6e1f841e-b6bb-4d38-a14.retail_silver.cleaned_transactions` AS

WITH cleaned_data AS (

    SELECT

        TRIM(transaction_id) AS transaction_id,

        TRIM(customer_id) AS customer_id,

        CASE
            WHEN SAFE_CAST(TRIM(signup_date) AS DATE) > purchase_date
                THEN purchase_date
            ELSE COALESCE(
                    SAFE_CAST(TRIM(signup_date) AS DATE),
                    purchase_date
                 )
        END AS signup_date,

        purchase_date,

        amount,

        UPPER(TRIM(item_category)) AS item_category,

        COALESCE(
            SAFE_CAST(TRIM(is_returned) AS BOOL),
            FALSE
        ) AS is_returned

    FROM
        `project-6e1f841e-b6bb-4d38-a14.retail_bronze.raw_transactions`

    WHERE amount > 0

    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY transaction_id
        ORDER BY purchase_date DESC
    ) = 1

)

SELECT

    transaction_id,
    customer_id,
    signup_date,
    purchase_date,
    amount,
    item_category,
    is_returned,

    DATE_DIFF(
        purchase_date,
        signup_date,
        DAY
    ) AS days_to_first_purchase

FROM cleaned_data;
