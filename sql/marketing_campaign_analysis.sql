CREATE DATABASE campaign_analysis;
USE campaign_analysis;
-- Ad Campaign Performance Analysis
-- Dataset: Merketing Campaign Performance (Kaggle)
-- Author: Rute Melo
-- Description: SQL queries to analyse the campaign ROI, channel performance, audience segments and cost efficiency.

-- 0. DATA PREPARATION
-- Note: Acquisition_Cost is stored as formated as currency ($XX,XXX.XX}. For the calculations through this scrip I will cast it as numeric.

-- 1. OVERVIEW: Key Performance Metrics across all campaigns
SELECT 
  COUNT(DISTINCT Campaign_ID) AS total_campaigns,
  COUNT(DISTINCT Company) AS total_companies,
  ROUND(AVG(ROI), 2) AS avg_roi,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct,
  SUM(Clicks) AS total_clicks,
  SUM(Impressions) AS total_impressions,
  ROUND(SUM(Clicks) * 100.0 / SUM(Impressions), 2) AS overall_ctr_pct,
  ROUND(AVG(Engagement_Score), 2) AS avg_engagement_score
FROM marketing_campaign_dataset;

-- 2. CHANNEL PERFORMANCE: Which channel provides the best results?
SELECT
  Channel_Used,
  COUNT(Campaign_ID) AS num_campaigns,
  ROUND(AVG(ROI), 2) AS avg_roi,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct,
  SUM(Clicks) AS total_clicks,
  SUM(Impressions) AS total_impressions,
  ROUND(SUM(Clicks) * 100.0 / SUM(Impressions), 2) AS overall_ctr_pct,
  ROUND(AVG(Engagement_Score), 2) AS avg_engagement_score
FROM marketing_campaign_dataset
GROUP BY Channel_Used
ORDER BY avg_roi DESC;

-- 3. CAMPAIGN PERFORMANCE BY TYPE: Email vs Social Media vs Influencer vs Search vs Display
SELECT
  Campaign_Type,
  COUNT(Campaign_ID) AS num_campaigns,
  ROUND(AVG(ROI), 2) AS avg_roi,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct,
  ROUND(AVG(Engagement_Score), 2) AS avg_engagement_score,
  SUM(Clicks) AS total_clicks
FROM marketing_campaign_dataset
GROUP BY Campaign_Type
ORDER BY avg_roi DESC;

-- 4. AUDIENCE SEGMENTATION: Which target audience has the best conversion?
SELECT
  Target_Audience,
  COUNT(Campaign_ID) AS num_campaigns,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct,
  ROUND(AVG(ROI), 2) AS avg_roi,
  ROUND(AVG(Engagement_Score), 2) AS avg_engagement_score
FROM marketing_campaign_dataset
GROUP BY Target_Audience
ORDER BY avg_conversion_rate_pct DESC;

-- 5. CUSTOMER SEGMENT PERFORMANCE: Best performing segments
SELECT
  Customer_Segment,
  COUNT(Campaign_ID) AS num_campaigns,
  ROUND(AVG(ROI), 2) AS avg_roi,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct,
  SUM(Clicks) AS total_clicks,
  ROUND(AVG(Engagement_Score), 2) AS avg_engagement_score
FROM marketing_campaign_dataset
GROUP BY Customer_Segment
ORDER BY avg_roi DESC;

-- 6. LOCATION PERFORMANCE: ROI by city
SELECT
  Location,
  COUNT(Campaign_ID) AS num_campaigns,
  ROUND(AVG(ROI), 2) AS avg_roi,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct,
  SUM(Clicks) AS total_clicks,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct,
  SUM(Clicks) AS total_clicks
FROM marketing_campaign_dataset
GROUP BY Location
ORDER BY avg_roi DESC;

-- 7. COST EFFICIENCY: Acquisition cost vs ROI
SELECT
  Campaign_ID,
  Company,
  Campaign_Type,
  Channel_Used,
  ROI,
  CAST(REPLACE(REPLACE (Acquisition_Cost, '$', ''), ',', '') AS DECIMAL (10, 2)) AS acquisition_cost_numeric,
  Conversion_Rate,
  ROUND(ROI/CAST(REPLACE(REPLACE (Acquisition_Cost, '$', ''), ',', '') AS DECIMAL (10, 2)) * 1000, 4) AS roi_per_1000_spent
FROM marketing_campaign_dataset
ORDER BY roi_per_1000_spent DESC
LIMIT 20;

-- 8. CAMPAIGN DURATION IMPACT: Does longer campaigns equal better ROI?
SELECT
  Duration,
  COUNT(Campaign_ID) AS num_campaigns,
  ROUND(AVG(ROI), 2) AS avg_roi,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct,
  ROUND(AVG(Clicks), 0) AS avg_clicks
FROM marketing_campaign_dataset
GROUP BY Duration
ORDER BY avg_roi DESC;

-- 9. COMPANY LEADERBOARD: Top & bottom performancers by ROI
-- Top 5
SELECT
  Company,
  COUNT(Campaign_ID) AS num_campaigns,
  ROUND(AVG(ROI), 2) AS avg_roi,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct
FROM marketing_campaign_dataset
GROUP BY Company
ORDER BY avg_roi DESC
LIMIT 5;

-- Bottom 5
SELECT
  Company,
  COUNT(Campaign_ID) AS num_campaigns,
  ROUND(AVG(ROI), 2) AS avg_roi,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct
FROM marketing_campaign_dataset
GROUP BY Company
ORDER BY avg_roi ASC
LIMIT 5;

-- 10. MONTHLY TREND: Evolution of ROI over time
SELECT 
    DATE_FORMAT(`Date`, '%Y-%m') AS yearmonth,
    COUNT(Campaign_ID) AS num_campaigns,
    ROUND(AVG(ROI), 2) AS avg_roi,
    ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct,
    SUM(Clicks) AS total_clicks
FROM marketing_campaign_dataset
GROUP BY yearmonth
ORDER BY yearmonth ASC;


  

-- 11. BEST CHANNEL PER CAMPAIGN TYPE
SELECT
  Campaign_Type,
  Channel_Used,
  COUNT(Campaign_ID) AS num_campaigns,
  ROUND(AVG(ROI), 2) AS avg_roi,
  ROUND(AVG(Conversion_Rate) * 100, 2) AS avg_conversion_rate_pct
FROM marketing_campaign_dataset
GROUP BY Campaign_Type, Channel_Used
ORDER BY Campaign_Type, avg_ROI DESC;

-- 12. HIGH VALUE CAMPAIGNS. Both ROI and conversion rate above average
SELECT
	Campaign_ID,
    Company,
    Campaign_Type,
    Channel_Used,
    Target_Audience,
    Customer_Segment,
    Location,
    ROI,
    ROUND (Conversion_Rate * 100, 2) AS conversion_rate_pct,
    Engagement_Score
FROM marketing_campaign_dataset
WHERE ROI > (SELECT AVG (ROI) FROM marketing_campaign_dataset) AND Conversion_Rate > (SELECT AVG(Conversion_Rate) FROM marketing_campaign_dataset)
ORDER BY ROI DESC;
LIMIT 25;
