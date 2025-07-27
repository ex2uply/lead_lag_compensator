clc; clear; close all;

% Plant Transfer function
numG = 4;
denG = [1 2 0];
G = tf(numG, denG);

% --- (A) WITHOUT COMPENSATOR ---
sys = feedback(G, 1);

figure;
step(sys);
title('Step Response: Plant only');
info = stepinfo(sys);

[GM, PM, Wcg, Wcp] = margin(G);

[y_no, t_no] = step(sys);
ss_err_no = abs(1 - y_no(end));

% --- (B) WITH LEAD COMPENSATOR ---
numLead = [1 2.9]; denLead = [1 5.4];
Gc_lead = tf(numLead, denLead);

sys_lead_open = series(Gc_lead, G);
sys_lead = feedback(sys_lead_open, 1);

figure;
step(sys_lead);
title('Step Response: With Lead Compensator');
info_lead = stepinfo(sys_lead);

[GM_lead, PM_lead, Wcg_lead, Wcp_lead] = margin(Gc_lead*G);

[y_lead, t_lead] = step(sys_lead);
ss_err_lead = abs(1 - y_lead(end));

% --- (C) WITH LAG COMPENSATOR ---
numLag = [1 0.111]; denLag = [1 0.01];
Gc_lag = tf(numLag, denLag);

sys_lag_open = series(Gc_lag, G);
sys_lag = feedback(sys_lag_open, 1);

figure;
step(sys_lag);
title('Step Response: With Lag Compensator');
info_lag = stepinfo(sys_lag);

[GM_lag, PM_lag, Wcg_lag, Wcp_lag] = margin(Gc_lag*G);

[y_lag, t_lag] = step(sys_lag);
ss_err_lag = abs(1 - y_lag(end));

% --- (D) WITH LEAD-LAG COMPENSATOR ---
Gc_leadlag = series(Gc_lead, Gc_lag);

sys_leadlag_open = series(Gc_leadlag, G);
sys_leadlag = feedback(sys_leadlag_open, 1);

figure;
step(sys_leadlag);
title('Step Response: With Lead-Lag Compensator');
info_leadlag = stepinfo(sys_leadlag);

[GM_leadlag, PM_leadlag, Wcg_leadlag, Wcp_leadlag] = margin(Gc_leadlag*G);

[y_leadlag, t_leadlag] = step(sys_leadlag);
ss_err_leadlag = abs(1 - y_leadlag(end));

% --- Display Results (Observation Table) ---
fprintf('\n\nRESULTS FOR OBSERVATION TABLE\n');
fprintf('-------------------------------------------------------------\n');
fprintf('Case\t\t\tRise\tSettling\tSS Err\tPhaseMargin\n');
fprintf('-------------------------------------------------------------\n');
fprintf('Plant only\t\t%.3f\t%.3f\t\t%.3f\t%.2f°\n', info.RiseTime, info.SettlingTime, ss_err_no, PM);
fprintf('Lead Compensator\t%.3f\t%.3f\t\t%.3f\t%.2f°\n', info_lead.RiseTime, info_lead.SettlingTime, ss_err_lead, PM_lead);
fprintf('Lag Compensator\t\t%.3f\t%.3f\t\t%.3f\t%.2f°\n', info_lag.RiseTime, info_lag.SettlingTime, ss_err_lag, PM_lag);
fprintf('Lead-Lag Compensator\t%.3f\t%.3f\t\t%.3f\t%.2f°\n', info_leadlag.RiseTime, info_leadlag.SettlingTime, ss_err_leadlag, PM_leadlag);
fprintf('-------------------------------------------------------------\n');