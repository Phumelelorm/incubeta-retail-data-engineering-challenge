/*
===============================================================================
Gold Layer - Customer Segmentation Predictions

Source:
    retail_silver.cleaned_transactions

Model:
    retail_gold.customer_segmentation_model

Target:
    retail_gold.analytics_customer_segments

Purpose:
Apply the trained K-Means model to the cleaned transaction data and
store the predicted customer cluster alongside the original transaction
attributes.
===============================================================================
*/

CREATE OR REPLACE TABLE
`project-6e1f841e-b6bb-4d38-a14.retail_gold.analytics_customer_segments` AS

WITH predictions AS (

    SELECT
        transaction_id,
        CENTROID_ID AS customer_cluster

    FROM ML.PREDICT(

        MODEL `project-6e1f841e-b6bb-4d38-a14.retail_gold.customer_segmentation_model`,

        (
            SELECT

                transaction_id,
                amount,

                CASE WHEN item_category = 'APPAREL' THEN 1 ELSE 0 END AS apparel,
                CASE WHEN item_category = 'AUTOMOTIVE' THEN 1 ELSE 0 END AS automotive,
                CASE WHEN item_category = 'BEAUTY' THEN 1 ELSE 0 END AS beauty,
                CASE WHEN item_category = 'ELECTRONICS' THEN 1 ELSE 0 END AS electronics,
                CASE WHEN item_category = 'HOME' THEN 1 ELSE 0 END AS home,
                CASE WHEN item_category = 'SPORTS' THEN 1 ELSE 0 END AS sports

            FROM
            `project-6e1f841e-b6bb-4d38-a14.retail_silver.cleaned_transactions`

        )

    )

)

SELECT

    c.transaction_id,
    c.customer_id,
    c.signup_date,
    c.purchase_date,
    c.amount,
    c.item_category,
    c.is_returned,
    c.days_to_first_purchase,
    p.customer_cluster

FROM
`project-6e1f841e-b6bb-4d38-a14.retail_silver.cleaned_transactions` c

INNER JOIN predictions p
ON c.transaction_id = p.transaction_id;
