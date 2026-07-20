/*
===============================================================================
Gold Layer - Customer Segmentation Model

Source:
    retail_silver.cleaned_transactions

Model:
    retail_gold.customer_segmentation_model

Purpose:
Train a K-Means clustering model to segment customers based on
purchase amount and item category.
===============================================================================
*/

CREATE OR REPLACE MODEL
`project-6e1f841e-b6bb-4d38-a14.retail_gold.customer_segmentation_model`

OPTIONS (
    MODEL_TYPE = 'KMEANS',
    NUM_CLUSTERS = 4,
    STANDARDIZE_FEATURES = TRUE
)

AS

SELECT

    amount,

    CASE WHEN item_category = 'APPAREL' THEN 1 ELSE 0 END AS apparel,

    CASE WHEN item_category = 'AUTOMOTIVE' THEN 1 ELSE 0 END AS automotive,

    CASE WHEN item_category = 'BEAUTY' THEN 1 ELSE 0 END AS beauty,

    CASE WHEN item_category = 'ELECTRONICS' THEN 1 ELSE 0 END AS electronics,

    CASE WHEN item_category = 'HOME' THEN 1 ELSE 0 END AS home,

    CASE WHEN item_category = 'SPORTS' THEN 1 ELSE 0 END AS sports

FROM
`project-6e1f841e-b6bb-4d38-a14.retail_silver.cleaned_transactions`;
