SELECT 
    Industry,
    ROUND(AVG(ICR_Baseline), 2) as avg_baseline,
    ROUND(AVG(`ICR under +200bps shock`), 2) as avg_200bps,
    ROUND(AVG(`ICR under +300bps shock`), 2) as avg_300bps
FROM credit_risk_clients
GROUP BY Industry
ORDER BY Industry;