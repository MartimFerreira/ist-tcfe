close all
clear all

pkg load control

%%EXAMPLE SYMBOLIC COMPUTATIONS

format long


%%%%%%%%%%%%%%%%%%%%%%% MAIN CALCULATIONS %%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%% VARIABLES THAT MAY BE CHANGED %%%%%%%%%%%%%%%%

fVs = 230; % independent voltage source

fRdet = 1; %resistor in envelope detector
fRreg = 1; % resistor in voltage regulator

fC = 1*(10^(-6)); % U capacitor in envelope detector

n = 230./12.; %number of turns in transformer
fL1 = 1; %inductance (left side of the transformer)
fL2 = fL1*n*n;

MagVs = 1; %magnitude of voltage imposed by voltage source

%%%%%%%%%%%%%%%%%%%%%%%%% NGSPICE INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%


ngspice_input = fopen("../sim/ngspice_input.txt", "w");

%%%  resistors
fprintf(ngspice_input,"Rdet mid1 0 %.12f\n", fRdet);
fprintf(ngspice_input,"Rreg mid1 out1 %.12f\n", fRreg);

%%% capacitor
fprintf(ngspice_input,"C mid1 0 %.12f\n", fC);

%%% diodes
fprintf(ngspice_input,"Dfw1 in1 fwout1 Default\n");
fprintf(ngspice_input,"Dfw2 in2 fwout1 Default\n");
fprintf(ngspice_input,"Dfw3 0 in2 Default\n");
fprintf(ngspice_input,"Dfw4 0 in1 Default\n");
fprintf(ngspice_input,"Ddet fwout1 mid1 Default\n");
fprintf(ngspice_input,"Dreg1 out1 d1d2 Default\n");
fprintf(ngspice_input,"Dreg2 d1d2 d2d3 Default\n");
fprintf(ngspice_input,"Dreg3 d2d3 0 Default\n");

%%% transformer
% www.seas.upenn.edu/~jan/spice/spice.transformer.html
% sourceforge.net/p/ngspice/discussion/133842/thread/87641fa4/
% forum.kicad.info/t/how-to-edit-transformer/19871/5
% www.analog.com/en/technical-articles/ltspice-basic-stepssimulating-transformers.html#
% ngspice.sourceforge.net/docs/ngspice-html-manual/manual.xhtml#subsec_Inductors
fprintf(ngspice_input,"L1 begin1 begin2 %.12f\n", fL1);
fprintf(ngspice_input,"L2 in1 in2 %.12f\n", fL2);
fprintf(ngspice_input,"K L1 L2 1 \n");
% if 1 doesnt work maybe try 0.99999


%%% voltage source
fprintf(ngspice_input,"Vs begin1 begin2 230 AC %.12f SIN(0.0 1.0 50.0) %.12f\n", MagVs, fVs);



%%%%%%%%%%%%%%%%%%%%%%%% TABLES %%%%%%%%%%%%%%%%%%%%%%


%data_tab = fopen("octave_data_tab.tex", "w");

%fprintf(data_tab, "$R_1\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR1);
%fprintf(data_tab, "$R_2\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR2);
%fprintf(data_tab, "$R_3\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR3);
%fprintf(data_tab, "$R_4\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR4);
%fprintf(data_tab, "$R_5\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR5);
%fprintf(data_tab, "$R_6\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR6);
%fprintf(data_tab, "$R_7\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fR7);
%fprintf(data_tab, "$V_s\\;(V)$ & %.12e \\\\ \\hline\n", fVs);
%fprintf(data_tab, "$C\\;(F)$ &   %.12e \\\\ \\hline\n", fC);
%fprintf(data_tab, "$K_b\\;(S)$ & %.12e \\\\ \\hline\n", fKb);
%fprintf(data_tab, "$K_d\\;(\\Omega)$ & %.12e \\\\ \\hline\n", fKd);

%fclose(data_tab);


%zero_time_tab = fopen("octave_zero_time_tab.tex", "w");

%fprintf(zero_time_tab, "$V_1$ & %.12e \\\\ \\hline\n", 0);
%fprintf(zero_time_tab, "$V_2$ & %.12e \\\\ \\hline\n", V20);
%fprintf(zero_time_tab, "$V_3$ & %.12e \\\\ \\hline\n", V30);
%fprintf(zero_time_tab, "$V_5$ & %.12e \\\\ \\hline\n", V50);
%fprintf(zero_time_tab, "$V_6$ & %.12e \\\\ \\hline\n", V60);
%fprintf(zero_time_tab, "$V_7$ & %.12e \\\\ \\hline\n", V70);
%fprintf(zero_time_tab, "$V_8$ & %.12e \\\\ \\hline\n", V80);
%fprintf(zero_time_tab, "$V_x$ & %.12e \\\\ \\hline\n", Vx);
%fprintf(zero_time_tab, "$I_x$ & %.12e\\\\ \\hline\n", Ix);
%fprintf(zero_time_tab, "$R_{eq}$ & %.12e \\\\ \\hline\n", Req);

%fclose(zero_time_tab);


