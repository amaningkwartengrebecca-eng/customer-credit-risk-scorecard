
use Credit_Risk_Analysis;

CREATE TABLE credit_risk_clients (
    client_id INT PRIMARY KEY,
    annual_income DECIMAL(15,2),
    loan_amnt DECIMAL(15,2),
    interest_rate DECIMAL(5,4),
    credit_history_length INT,
    income_to_loan_ratio INT,
    ebitda_proxy DECIMAL(15,2),
    floating_debt_flag INT,
    industry VARCHAR(50),
    interest_expense DECIMAL(15,2),
    icr_baseline DECIMAL(10,4),
    icr_200bps DECIMAL(10,4),
    icr_300bps DECIMAL(10,4),
    baseline_decision VARCHAR(20),
    shock_decision_300bps VARCHAR(20),
    vulnerable_300bps VARCHAR(20),
    expected_loss_contrib DECIMAL(15,2)
);

select * from credit_risk_clients;

