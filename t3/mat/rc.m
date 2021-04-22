close all
clear all

pkg load control

%%EXAMPLE SYMBOLIC COMPUTATIONS

format long


%%%%%%%%%%%%%%%%%%%%%%% MAIN CALCULATIONS %%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%% NGSPICE INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%

ngspice_1_input = fopen("../sim/ngspice_1_input.txt", "w");

fprintf(ngspice_1_input,"R1 1 2 %.12f\n", fR1);
fprintf(ngspice_1_input,"R2 2 3 %.12f\n", fR2);
fprintf(ngspice_1_input,"R3 2 5 %.12f\n", fR3);
fprintf(ngspice_1_input,"R4 0 5 %.12f\n", fR4);
fprintf(ngspice_1_input,"R5 5 6 %.12f\n", fR5);
fprintf(ngspice_1_input,"R6 0 7 %.12f\n", fR6);

%Fonte de tensão imaginária
fprintf(ngspice_1_input,"Vi 7 im %.12f\n",0); 

fprintf(ngspice_1_input,"R7 im 8 %.12f\n", fR7);
fprintf(ngspice_1_input,"C1 6 8 %.12f\n", fC);
fprintf(ngspice_1_input,"Vs 1 0 %.12f\n", fVs);
fprintf(ngspice_1_input,"Gb 6 3 2 5 %.12f\n", fKb);
fprintf(ngspice_1_input,"Hd 5 8 Vi %.12f\n", fKd);

fclose(ngspice_1_input);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


ngspice_2_input = fopen("../sim/ngspice_2_input.txt", "w");

fprintf(ngspice_2_input,"R1 1 2 %.12f\n", fR1);
fprintf(ngspice_2_input,"R2 2 3 %.12f\n", fR2);
fprintf(ngspice_2_input,"R3 2 5 %.12f\n", fR3);
fprintf(ngspice_2_input,"R4 0 5 %.12f\n", fR4);
fprintf(ngspice_2_input,"R5 5 6 %.12f\n", fR5);
fprintf(ngspice_2_input,"R6 0 7 %.12f\n", fR6);

%Fonte de tensão imaginária
fprintf(ngspice_2_input,"Vi 7 im %.12f\n", 0); 

fprintf(ngspice_2_input,"R7 im 8 %.12f\n", fR7);
fprintf(ngspice_2_input,"Vs 1 0 %.12f\n", 0);
fprintf(ngspice_2_input,"Vx 6 8 %.12f\n", Vx);
fprintf(ngspice_2_input,"Gb 6 3 2 5 %.12f\n", fKb);
fprintf(ngspice_2_input,"Hd 5 8 Vi %.12f\n", fKd);

fclose(ngspice_2_input);


%%%%%%%%%%%%%%%%%%%%%%%% TABLES %%%%%%%%%%%%%%%%%%%%%%


data_tab = fopen("octave_data_tab.tex", "w");

fprintf(data_tab, "$R_1\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR1);
fprintf(data_tab, "$R_2\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR2);
fprintf(data_tab, "$R_3\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR3);
fprintf(data_tab, "$R_4\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR4);
fprintf(data_tab, "$R_5\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR5);
fprintf(data_tab, "$R_6\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR6);
fprintf(data_tab, "$R_7\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR7);
fprintf(data_tab, "$V_s\\;(V)$ & %.12e \\\\ \\hline\n", fVs);
fprintf(data_tab, "$C\\;(F)$ &   %.12e \\\\ \\hline\n", fC);
fprintf(data_tab, "$K_b\\;(S)$ & %.12e \\\\ \\hline\n", fKb);
fprintf(data_tab, "$K_d\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fKd);

fclose(data_tab);


zero_time_tab = fopen("octave_zero_time_tab.tex", "w");

fprintf(zero_time_tab, "$V_1$ & %.12e \\\\ \\hline\n", 0);
fprintf(zero_time_tab, "$V_2$ & %.12e \\\\ \\hline\n", V20);
fprintf(zero_time_tab, "$V_3$ & %.12e \\\\ \\hline\n", V30);
fprintf(zero_time_tab, "$V_5$ & %.12e \\\\ \\hline\n", V50);
fprintf(zero_time_tab, "$V_6$ & %.12e \\\\ \\hline\n", V60);
fprintf(zero_time_tab, "$V_7$ & %.12e \\\\ \\hline\n", V70);
fprintf(zero_time_tab, "$V_8$ & %.12e \\\\ \\hline\n", V80);
fprintf(zero_time_tab, "$V_x$ & %.12e \\\\ \\hline\n", Vx);
fprintf(zero_time_tab, "$I_x$ & %.12e\\\\ \\hline\n", Ix);
fprintf(zero_time_tab, "$R_{eq}$ & %.12e \\\\ \\hline\n", Req);

fclose(zero_time_tab);


