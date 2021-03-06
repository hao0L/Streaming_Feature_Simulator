----- Extract all checkpoint calls during simulation period
DROP TABLE IF EXISTS sandbox_analytics_us.tmp_feature_audit_feature_value_payment_ach;
CREATE TABLE sandbox_analytics_us.tmp_feature_audit_feature_value_payment_ach DISTKEY(entity_id) AS (
WITH tmp_source AS (
    SELECT par_region
         , par_process_date
         , key_created_at::BIGINT AS checkpoint_time
         , key_consumer_id
         , key_order_token
         , key_merchant_id_main
         , key_device_fingerprint_hash
         , consumer_email
         , request
         , (CASE
                    WHEN NOT is_valid_json(rules_variables)
                        THEN rtrim(regexp_substr(rules_variables, '^.*[,]'),',') || '}'
                    ELSE rules_variables END) AS feature_map
    FROM red.raw_c_e_fc_decision_record
    WHERE par_region = 'US'
      AND par_process_date BETWEEN '2022-05-20' AND '2022-05-22'
      AND key_checkpoint = 'CHECKOUT_CONFIRM'
)
    SELECT
            par_region
           , par_process_date
           , checkpoint_time
           , key_consumer_id AS consumer_uuid
           , key_consumer_id AS entity_id
----- adding feature extractions for feature audit use case ----
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_cnt_incl_ach_h1_0', TRUE) AS sp_c_pymt_attmpt_cnt_incl_ach_h1_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_cnt_incl_ach_h6_0', TRUE) AS sp_c_pymt_attmpt_cnt_incl_ach_h6_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_cnt_incl_ach_h12_0', TRUE) AS sp_c_pymt_attmpt_cnt_incl_ach_h12_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_cnt_incl_ach_h24_0', TRUE) AS sp_c_pymt_attmpt_cnt_incl_ach_h24_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_cnt_incl_ach_h48_0', TRUE) AS sp_c_pymt_attmpt_cnt_incl_ach_h48_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_cnt_incl_ach_h72_0', TRUE) AS sp_c_pymt_attmpt_cnt_incl_ach_h72_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_cnt_incl_ach_h168_0', TRUE) AS sp_c_pymt_attmpt_cnt_incl_ach_h168_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_amt_incl_ach_h1_0', TRUE) AS sp_c_pymt_attmpt_amt_incl_ach_h1_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_amt_incl_ach_h6_0', TRUE) AS sp_c_pymt_attmpt_amt_incl_ach_h6_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_amt_incl_ach_h12_0', TRUE) AS sp_c_pymt_attmpt_amt_incl_ach_h12_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_amt_incl_ach_h24_0', TRUE) AS sp_c_pymt_attmpt_amt_incl_ach_h24_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_amt_incl_ach_h48_0', TRUE) AS sp_c_pymt_attmpt_amt_incl_ach_h48_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_amt_incl_ach_h72_0', TRUE) AS sp_c_pymt_attmpt_amt_incl_ach_h72_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_pymt_attmpt_amt_incl_ach_h168_0', TRUE) AS sp_c_pymt_attmpt_amt_incl_ach_h168_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0', TRUE) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0', TRUE) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0', TRUE) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0', TRUE) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0', TRUE) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0', TRUE) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0', TRUE) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0', TRUE) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0', TRUE) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0', TRUE) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0', TRUE) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0', TRUE) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0', TRUE) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0', TRUE) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0', TRUE) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0', TRUE) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0', TRUE) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0', TRUE) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0', TRUE) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0', TRUE) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0', TRUE) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0', TRUE) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0', TRUE) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0', TRUE) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0', TRUE) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0', TRUE) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0', TRUE) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0
           , JSON_EXTRACT_PATH_TEXT(feature_map, 'sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0', TRUE) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0
           FROM tmp_source
    WHERE IS_VALID_JSON(feature_map)
    ORDER BY entity_id
    )
;

----- Extract all raw events during simulation period
DROP TABLE IF EXISTS sandbox_analytics_us.tmp_feature_audit_feature_event_payment_ach;
CREATE TABLE sandbox_analytics_us.tmp_feature_audit_feature_event_payment_ach DISTKEY(entity_id) AS (
    SELECT
         event_info_event_time::BIGINT AS event_time  --## event_time ##
         , key_consumer_consumer_uuid AS consumer_uuid --## consumer_uuid ##
         , consumer_uuid AS entity_id    --## entity_id ##
         , key_payment_id
         , amount_amount
         , COALESCE(NULLIF(payment_method_credit_card_card_id, 'None'), NULLIF(payment_method_ach_bank_account_fingerprint, 'None')) AS payment_method_id
         , payment_status
         , payment_method_ach_bank_account_fingerprint
         , payment_source
         --- always use event table as the main table
    FROM red.raw_p_e_payment_processed
    WHERE par_region = 'US'
      AND par_process_date BETWEEN '2022-05-20' AND '2022-05-22'
    ORDER BY entity_id
);

----- Calculate the simulated feature values and map to entity_id + checkpoint_time -----
DROP TABLE IF EXISTS sandbox_analytics_us.tmp_feature_audit_feature_simulated_payment_ach;
CREATE TABLE sandbox_analytics_us.tmp_feature_audit_feature_simulated_payment_ach DISTKEY(entity_id) AS (

    SELECT t2.entity_id
        , t2.checkpoint_time
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 1*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN key_payment_id ::VARCHAR END), 0) AS sp_c_pymt_attmpt_cnt_incl_ach_h1_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 6*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN key_payment_id ::VARCHAR END), 0) AS sp_c_pymt_attmpt_cnt_incl_ach_h6_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 12*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN key_payment_id ::VARCHAR END), 0) AS sp_c_pymt_attmpt_cnt_incl_ach_h12_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 24*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN key_payment_id ::VARCHAR END), 0) AS sp_c_pymt_attmpt_cnt_incl_ach_h24_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 48*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN key_payment_id ::VARCHAR END), 0) AS sp_c_pymt_attmpt_cnt_incl_ach_h48_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 72*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN key_payment_id ::VARCHAR END), 0) AS sp_c_pymt_attmpt_cnt_incl_ach_h72_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 168*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN key_payment_id ::VARCHAR END), 0) AS sp_c_pymt_attmpt_cnt_incl_ach_h168_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 1*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_pymt_attmpt_amt_incl_ach_h1_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 6*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_pymt_attmpt_amt_incl_ach_h6_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 12*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_pymt_attmpt_amt_incl_ach_h12_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 24*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_pymt_attmpt_amt_incl_ach_h24_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 48*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_pymt_attmpt_amt_incl_ach_h48_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 72*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_pymt_attmpt_amt_incl_ach_h72_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 168*60*60*1000) AND (payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_pymt_attmpt_amt_incl_ach_h168_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 1*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN key_payment_id ::VARCHAR END), 0) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 6*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN key_payment_id ::VARCHAR END), 0) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 12*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN key_payment_id ::VARCHAR END), 0) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 24*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN key_payment_id ::VARCHAR END), 0) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 48*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN key_payment_id ::VARCHAR END), 0) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 72*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN key_payment_id ::VARCHAR END), 0) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0
        , COALESCE( COUNT( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 168*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN key_payment_id ::VARCHAR END), 0) AS sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 1*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 6*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 12*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 24*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 48*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 72*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0
        , COALESCE( SUM( CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 168*60*60*1000) AND ((payment_method_ach_bank_account_fingerprint = 'None' or payment_status != 'SUCCESS') AND LOWER(payment_source) IN ('consumer_portal', 'mobile_api')) THEN amount_amount ::DECIMAL(18,2) END), 0) AS sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 1*60*60*1000) THEN payment_method_id::VARCHAR END), 0) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 6*60*60*1000) THEN payment_method_id::VARCHAR END), 0) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 12*60*60*1000) THEN payment_method_id::VARCHAR END), 0) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 24*60*60*1000) THEN payment_method_id::VARCHAR END), 0) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 48*60*60*1000) THEN payment_method_id::VARCHAR END), 0) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 72*60*60*1000) THEN payment_method_id::VARCHAR END), 0) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 168*60*60*1000) THEN payment_method_id::VARCHAR END), 0) AS sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 1*60*60*1000) AND (payment_status = 'SUCCESSFUL') THEN payment_method_id ::VARCHAR END), 0) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 6*60*60*1000) AND (payment_status = 'SUCCESSFUL') THEN payment_method_id ::VARCHAR END), 0) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 12*60*60*1000) AND (payment_status = 'SUCCESSFUL') THEN payment_method_id ::VARCHAR END), 0) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 24*60*60*1000) AND (payment_status = 'SUCCESSFUL') THEN payment_method_id ::VARCHAR END), 0) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 48*60*60*1000) AND (payment_status = 'SUCCESSFUL') THEN payment_method_id ::VARCHAR END), 0) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 72*60*60*1000) AND (payment_status = 'SUCCESSFUL') THEN payment_method_id ::VARCHAR END), 0) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0
        , COALESCE( COUNT(DISTINCT  CASE WHEN (t2.checkpoint_time - t1.event_time BETWEEN 0 AND 168*60*60*1000) AND (payment_status = 'SUCCESSFUL') THEN payment_method_id ::VARCHAR END), 0) AS sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0
        FROM sandbox_analytics_us.tmp_feature_audit_feature_event_payment_ach t1
    RIGHT JOIN sandbox_analytics_us.tmp_feature_audit_feature_value_payment_ach t2
        ON t1.entity_id = t2.entity_id
        AND t1.event_time < t2.checkpoint_time
    GROUP BY 1, 2
);


----- Default and missing rate checking for features -----
SELECT
       par_process_date
       , COUNT(1) AS records_cnt
       , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_cnt_incl_ach_h1_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_cnt_incl_ach_h1_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_cnt_incl_ach_h6_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_cnt_incl_ach_h6_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_cnt_incl_ach_h12_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_cnt_incl_ach_h12_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_cnt_incl_ach_h24_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_cnt_incl_ach_h24_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_cnt_incl_ach_h48_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_cnt_incl_ach_h48_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_cnt_incl_ach_h72_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_cnt_incl_ach_h72_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_cnt_incl_ach_h168_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_cnt_incl_ach_h168_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_amt_incl_ach_h1_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_amt_incl_ach_h1_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_amt_incl_ach_h6_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_amt_incl_ach_h6_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_amt_incl_ach_h12_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_amt_incl_ach_h12_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_amt_incl_ach_h24_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_amt_incl_ach_h24_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_amt_incl_ach_h48_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_amt_incl_ach_h48_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_amt_incl_ach_h72_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_amt_incl_ach_h72_0
           , 1.0 * COUNT(CASE WHEN sp_c_pymt_attmpt_amt_incl_ach_h168_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_pymt_attmpt_amt_incl_ach_h168_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0
           , 1.0 * COUNT(CASE WHEN sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0
           , 1.0 * COUNT(CASE WHEN sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0
           , 1.0 * COUNT(CASE WHEN sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0
           , 1.0 * COUNT(CASE WHEN sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0
           , 1.0 * COUNT(CASE WHEN sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0
           , 1.0 * COUNT(CASE WHEN sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0
           , 1.0 * COUNT(CASE WHEN sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0
           , 1.0 * COUNT(CASE WHEN sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0
           , 1.0 * COUNT(CASE WHEN sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0
           , 1.0 * COUNT(CASE WHEN sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0
           , 1.0 * COUNT(CASE WHEN sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0
           , 1.0 * COUNT(CASE WHEN sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0
           , 1.0 * COUNT(CASE WHEN sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0
           , 1.0 * COUNT(CASE WHEN sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0
           , 1.0 * COUNT(CASE WHEN sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0 NOT IN ('', '-999', '-999.0', '0.0', '0') THEN 1 END) /
       NULLIF(COUNT(1),0) AS pct_value_sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0
           FROM sandbox_analytics_us.tmp_feature_audit_feature_value_payment_ach
group by 1
order by 1
;

----- match rate between feature value and simulated value -----
SELECT
    t1.par_process_date
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_cnt_incl_ach_h1_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_cnt_incl_ach_h1_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_cnt_incl_ach_h1_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_cnt_incl_ach_h6_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_cnt_incl_ach_h6_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_cnt_incl_ach_h6_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_cnt_incl_ach_h12_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_cnt_incl_ach_h12_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_cnt_incl_ach_h12_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_cnt_incl_ach_h24_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_cnt_incl_ach_h24_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_cnt_incl_ach_h24_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_cnt_incl_ach_h48_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_cnt_incl_ach_h48_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_cnt_incl_ach_h48_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_cnt_incl_ach_h72_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_cnt_incl_ach_h72_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_cnt_incl_ach_h72_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_cnt_incl_ach_h168_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_cnt_incl_ach_h168_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_cnt_incl_ach_h168_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_amt_incl_ach_h1_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h1_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_amt_incl_ach_h1_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_amt_incl_ach_h1_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_amt_incl_ach_h6_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h6_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_amt_incl_ach_h6_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_amt_incl_ach_h6_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_amt_incl_ach_h12_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h12_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_amt_incl_ach_h12_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_amt_incl_ach_h12_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_amt_incl_ach_h24_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h24_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_amt_incl_ach_h24_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_amt_incl_ach_h24_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_amt_incl_ach_h48_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h48_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_amt_incl_ach_h48_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_amt_incl_ach_h48_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_amt_incl_ach_h72_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h72_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_amt_incl_ach_h72_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_amt_incl_ach_h72_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_pymt_attmpt_amt_incl_ach_h168_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h168_0,'')::DECIMAL(18,2) - t2.sp_c_pymt_attmpt_amt_incl_ach_h168_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_pymt_attmpt_amt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_pymt_attmpt_amt_incl_ach_h168_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_cnt_incl_ach_h1_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_cnt_incl_ach_h6_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_cnt_incl_ach_h12_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_cnt_incl_ach_h24_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_cnt_incl_ach_h48_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_cnt_incl_ach_h72_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_cnt_incl_ach_h168_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_amt_incl_ach_h1_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_amt_incl_ach_h6_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_amt_incl_ach_h12_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_amt_incl_ach_h24_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_amt_incl_ach_h48_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_amt_incl_ach_h72_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0,'')::DECIMAL(18,2) - t2.sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_manual_pymt_attmpt_amt_incl_ach_h168_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) - t2.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h1_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) - t2.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h6_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) - t2.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h12_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) - t2.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h24_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) - t2.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h48_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) - t2.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h72_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) - t2.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_attempt_pymt_method_distinct_cnt_incl_ach_h168_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) - t2.sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_success_pymt_method_distinct_cnt_incl_ach_h1_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) - t2.sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_success_pymt_method_distinct_cnt_incl_ach_h6_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) - t2.sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_success_pymt_method_distinct_cnt_incl_ach_h12_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) - t2.sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_success_pymt_method_distinct_cnt_incl_ach_h24_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) - t2.sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_success_pymt_method_distinct_cnt_incl_ach_h48_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) - t2.sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_success_pymt_method_distinct_cnt_incl_ach_h72_0
, COUNT(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0 THEN 1 END) cnt_sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0
    , 1.0 * SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                AND ABS(NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) - t2.sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0::DECIMAL(18,2)) < 1
                THEN 1 ELSE 0 END)
                / NULLIF(SUM(CASE WHEN NULLIF(t1.sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0,'')::DECIMAL(18,2) > 0
                                THEN 1 ELSE 0 END), 0) pct_match_sp_c_success_pymt_method_distinct_cnt_incl_ach_h168_0
FROM sandbox_analytics_us.tmp_feature_audit_feature_value_payment_ach t1
         INNER JOIN sandbox_analytics_us.tmp_feature_audit_feature_simulated_payment_ach t2
                    ON t1.entity_id = t2.entity_id
                        AND t1.checkpoint_time = t2.checkpoint_time
GROUP BY 1
;
