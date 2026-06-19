# customer-credit-risk-scorecard
Thornfield Group — Customer Credit Risk Scorecard & Stress-Test Engine

Live Demo: [video link – when you have it]

---

Overview

This project builds a credit risk assessment and stress-testing engine for a 75-client SME loan portfolio. The dashboard evaluates portfolio health at baseline and under two interest rate shock scenarios (+200bps and +300bps).

The questions I wanted to answer:
1. Which clients are safe to offer deferred payment terms to?
2. How does the portfolio's risk profile change under rate shocks?
3. What's the expected loss exposure under worst-case conditions?
4. Where should the commercial team draw the line on credit extension?
5. Which clients need manual underwriting before approval? (See Methodology Evolution – this one got reframed.)

---

Tools Used

- Excel – dataset construction, cleaning, iterative formula correction
- MySQL – data validation and SQL-based sense checks throughout the build
- Power BI Desktop – dashboard visualisation and DAX-based summary tables
- GitHub – portfolio hosting and documentation

---

Methodology

Credit Decision Logic

Each client is assessed using a dual-factor approval framework. One passing condition isn't enough, either factor passing in isolation could mask risk the other would catch.

- Auto Approve: Interest Coverage Ratio (ICR) > 1.5 AND income-to-loan ratio >= 10
- Manual Review: ICR > 1.5 but income-to-loan ratio < 10 (healthy debt coverage but loan size disproportionate to income), OR ICR between 1.0 and 1.5 (borderline coverage)
- Auto Decline: ICR < 1.0 (insufficient coverage to service debt)

ICR is calculated as EBITDA proxy / interest expense. The standard formula for assessing how many times over a business's operating earnings cover its interest obligations.

The same thresholds were applied across all three scenarios so any classification shift reflects a genuine change in financial position, not an inconsistent yardstick.

Total Debt and Interest Expense

Interest expense is calculated as total_debt * (interest_rate / 100), rather than using the loan amount in isolation. Total debt is modelled as the loan amount multiplied by an industry-tier multiplier as Thornfield's loan isn't the client's only debt obligation.

- Low risk tier (3x): Legal, Finance, Engineering
- Medium risk tier (6x): Retail, Manufacturing, Tech, Logistics
- High risk tier (8x): Property, Hospitality, Construction

These multipliers are sector-based proxies. A company's actual leverage depends on liquidity, cash position, and credit history. But for this portfolio-level stress testing, sector classification is a reasonable proxy as it gives the industry-level analysis a structural basis.

Stress Scenarios

Three scenarios modelled by adjusting the interest rate:
- Baseline: Client's actual interest rate
- +200bps: +2 percentage points
- +300bps: +3 percentage points

---

Methodology Evolution 

This dataset went through several rounds of correction before the figures could be trusted. Documenting this honestly feels important not just because it's transparent, but because the corrections themselves reflect real analytical judgement.

Interest rate scaling inconsistency: The dataset originally mixed decimal (0.05) and percentage (10.99) representations in the same column.Which was eventually standardised to percentage form throughout. Meaning everything downstream had to be recalculated.

The order of operations in shocked ICR formulas: Early formulas applied the rate shock outside the brackets, producing nonsensical results (ICR appearing to improve under a rate increase). Which was corrected to EBITDA / (total_debt * ((rate + shock) / 100)).

The decision formula sign error: The income-to-loan ratio comparison operator was inverted (<= instead of >=). This meant the approval/decline logic was reversed for that condition. 

Total debt retrofit: The original ICR used loan amount alone, which produced unrealistically healthy coverage ratios (minimum ICR of 4.23, meaning no client would ever be high risk). Introducing the industry-tier total debt multiplier brought the ICR distribution into a realistic range (minimum being 0.53,  the maximum at 140).

Income-to-loan ratio recalculation: This was originally entered as a raw figure rather than calculated, leading to inconsistent scaling. Recalculated consistently as annual_income / loan_amount for all 75 clients.

Manual Underwriting (Reframed)

The original question set out to identify 10 clients needing manual underwriting. Once the logic was finalised, the manual review band sat at 44 clients out of 75 (59% of the portfolio). Higher than anticipated, yet not adjustable without compromising the integrity of the thresholds.

Rather than tweaking the thresholds to get a "nicer" number, I treated this as a genuine finding. Under the consistent dual-factor criteria, Thornfield's SME client base shows structural risk concentration. Most clients fall into a borderline classification rather than the clean approval/decline split. In a volatile interest rate environment, that's a realistic outcome not a flaw.

---

Key Findings

- The portfolio is structurally vulnerable before any rate shock. At baseline, only 36% of clients (27 of 75) clear the dual-factor threshold. The rest require manual review (59%) or decline automatically (5%).

- Rate shocks convert borderline cases into declines, not healthy clients. The 27 auto-approve clients are identical across all three scenarios so  they're more resilient to rate movement. The deterioration is concentrated entirely in the manual review and decline bands. Baseline declines: 4. At +300bps: 8.

- Most of the shock impact happens at +200bps, not +300bps. Across nearly every industry, the bulk of ICR deterioration happens in the first 200bps. The extra 100bps does comparatively little damage. Engineering is the most striking example since it loses about 42% of its baseline ICR within the first 200bps alone.

- The expected loss exposure is concentrated in two sectors. Property and Hospitality account for 100% of the portfolio's expected loss contribution at £59,525. Hospitality: 50.4%. Property: 49.6%. No other industry including Construction ,which is also high-risk tier,  contributes measurable expected loss.

- Risk concentration doesn't map cleanly onto the debt-multiplier tier. Logistics (medium-risk tier) has the highest manual review count (8 clients), ahead of Property (high-risk tier). Sector-level debt multipliers are a useful proxy, but they don't capture client-level risk on their own.

---

Dashboard Structure

Page 1 – Portfolio Overview & Stress-Test Results
Headline KPIs, baseline decision split, three-scenario decision distribution, ICR distribution, and a baseline-vs-worst-case comparison.

Page 2 – Industry Deep-Dive
Average ICR by sector across all three scenarios, segmented into low/medium/high debt-multiplier tiers with a 1.5 threshold reference line. Shows how much of each sector's baseline coverage is lost at each shock stage.

Page 3 – Client-Level Risk & Credit Decisions
Scatter plot of all 75 clients by ICR and income-to-loan ratio against both decision thresholds. Plus expected loss concentration by industry, decision split isolated to high-risk tier, and manual review concentration by industry.

---

Answers to the Business Questions

| Question | Answer |
|---------|--------|
| Which clients are safe for deferred payment terms? | The 27 clients meeting both auto-approve conditions (ICR > 1.5 and income-to-loan ratio >= 10). Visualised on Page 3. |
| How does the portfolio change under rate shocks? | Approvals are stable. Declines roughly double. Most deterioration happens within the first 200bps. |
| What's Thornfield's expected loss exposure under worst-case conditions? | £59,525 – concentrated entirely in Property (49.6%) and Hospitality (50.4%). See Page 3. |
| Where should the commercial team draw the line? | At the dual-factor threshold itself (ICR > 1.5 and income-to-loan ratio >= 10). Clients failing either condition need human review. |

---

What I Learned

- SQL joins are useful for cross-validation – I ran sense checks against the Excel data to catch inconsistencies.
- Excel formulas need careful auditing – a single sign error can flip your entire approval logic.
- Portfolio-level assumptions (like industry-tier debt multipliers) are useful proxies, but they have limits. They don't always capture client-level reality.
- Sometimes the "wrong" answer (59% manual review) is the right answer – if you start tweaking thresholds to get a nicer number, you're no longer doing analysis.

What I'd Do Differently:
- Build the stress-test logic in SQL earlier since  I ended up doing multiple Excel iterations that could have been automated.
- Validate the income-to-loan ratio calculation before building the dashboard which would fix the manual entry issue causing more work than it should have.

---

Limitations

- Industry-tier debt multipliers are portfolio level assumptions, not client specific leverage measurements.
- Expected loss modelling reflects the dataset's existing contribution figures and hasn't been independently re-derived from first principles (PD * LGD * EAD).

---


