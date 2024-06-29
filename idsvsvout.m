close all;
clear all;
clc;
k_n = 120e-6; V_tn = 0.6; k_p = 100e-6; V_tp = -0.6; V_DD = 3.3; 
V_in = linspace(0, V_DD, 5);V_out = linspace(0, V_DD, 100);
I_ds_n = zeros(length(V_in), length(V_out));I_ds_p = zeros(length(V_in), length(V_out));
for i = 1:length(V_in)
    V_gs_n = V_in(i);
    V_gs_p = V_in(i) - V_DD;
    for j = 1:length(V_out)
        V_ds_n = V_out(j);
        V_ds_p = V_out(j) - V_DD;
        if V_gs_n < V_tn
            I_ds_n(i, j) = 0; % nMOS cutoff
        elseif V_ds_n < (V_gs_n - V_tn)
            I_ds_n(i, j) = k_n * ((V_gs_n - V_tn) * V_ds_n - 0.5 * V_ds_n^2); % nMOS triode
        else
            I_ds_n(i, j) = 0.5 * k_n * (V_gs_n - V_tn)^2; % nMOS saturation
        end
        if V_gs_p > V_tp
            I_ds_p(i, j) = 0; % pMOS cutoff
        elseif V_ds_p > (V_gs_p - V_tp)
            I_ds_p(i, j) = k_p * ((V_gs_p - V_tp) * V_ds_p - 0.5 * V_ds_p^2); % pMOS triode
        else
            I_ds_p(i, j) = 0.5 * k_p * (V_gs_p - V_tp)^2; % pMOS saturation
        end
    end
end
figure;
hold on;
colors = lines(length(V_in));
for i = 1:length(V_in)
    plot(V_out, I_ds_n(i, :), 'Color', colors(i, :), 'LineWidth', 1.5, 'DisplayName', sprintf('nMOS V_{in} = %.1f V', V_in(i)));
    plot(V_out, I_ds_p(i, :), '--', 'Color', colors(i, :), 'LineWidth', 1.5, 'DisplayName', sprintf('pMOS V_{in} = %.1f V', V_in(i)));
end
xlabel('V_{out} (V)');
ylabel('I_{ds} (A)');
title('I_{ds} vs. V_{out} for different V_{in}');
grid on;
