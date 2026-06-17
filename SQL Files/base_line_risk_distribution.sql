
SELECT baseline_decision, COUNT(*) AS count
FROM credit_risk_clients
GROUP BY baseline_decision;