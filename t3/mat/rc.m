close all
clear all

pkg load control

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

format long

%%%%%%%%%%%%%%%%%%%%%%% VARIABLES THAT MAY BE CHANGED %%%%%%%%%%%%%%%%

Rdet = 1; %resistor in envelope detector
Rreg = 1; % resistor in voltage regulator

C = 1*10^(-6); % capacitor in envelope detector

n = 230./12.; %number of turns in transformer

fVs = 230; % independent voltage source

fL1 = 1; %inductance (left side of the transformer)
fL2 = fL1*n*n;

MagVs = 1; %magnitude of voltage imposed by voltage source

t=0:1e-5:2e-1;

v_on = 1;
R_on = 1;

%%%%%%%%%%%%%%%%%%%%%%% MAIN CALCULATIONS %%%%%%%%%%%%%%%%

%v1 = 230 + sin(100*pi*t);

%v2 = 1/n * v1;


%v_fwout2 = 0;


%v_in1(t) - v_in2(t) = v2(t);
%i_d1(t) = R(v_in1 - v_fwout1);
%i_d2(t) = R(v_in2 - v_fwout1);
%i_d3(t) = R(v_fwout2 - v_in2);
%i_d4(t) = R(v_fwout2 - v_in1);

%i_d3 + i_d1 = i_d2 + i_d4;

%i_det(t) = R(v_fwout1 - v_mid1);

%i_d1(t) + i_d2(t) = i_det(t);

%i_d1(t) = v_mid1/Rdet + C*d(v_mid1)/dt + i_out;

%i_d4(t) + i_d3(t) = i_out(t);



%v_e1 = v_fwout1 - i_fwout1 * R_on;
%v_e2 = v_e1 - v_on;

  
syms v1;
syms n;
syms v2;

syms v_in1 v_in2 v_fwout1 v_fwout2 i_fwout1 i_fwout2 i_2 sv_on sr_on c1 c2 c3 c4 c5 c6;

[c1 c2 c3 c4 c5] = solve( (v_in1 - v_fwout1 - sv_on)/sr_on == i_2, (v_in1 - v_fwout1 - sv_on)/sr_on + (v_in2 - v_fwout1 - sv_on)/sr_on == i_fwout1, (-v_in2 - sv_on)/sr_on == i_2 + (v_in2 - v_fwout1 - sv_on)/sr_on, (-v_in2 - sv_on)/sr_on + i_fwout1  == 0, v_in1 - v_in2 == v2, v_in1, v_in2, v_fwout1, i_fwout1, i_2 )



  
%%%%%%%%%%%%%%%%%%%%%%%%% NGSPICE INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%


ngspice_input = fopen("../sim/ngspice_input.txt", "w");

%%%  resistors
fprintf(ngspice_input,"Rdet mid1 0 %.12f\n", Rdet);
fprintf(ngspice_input,"Rreg mid1 out1 %.12f\n", Rreg);

%%% capacitor
fprintf(ngspice_input,"C mid1 0 %.12f\n", C);

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
% www.analog.com/en/technical-articles/ltspice-basic-steps-for-simulating-transformers.html#
% ngspice.sourceforge.net/docs/ngspice-html-manual/manual.xhtml#subsec_Inductors

fprintf(ngspice_input,"L1 begin1 begin2 %.12f\n", fL1);
fprintf(ngspice_input,"L2 in1 in2 %.12f\n", fL2);
fprintf(ngspice_input,"K L1 L2 1 Default\n");

% se 1 doesnt work maybe try 0.99999


%%% voltage source
fprintf(ngspice_input,"Vs begin1 begin2 %.12f AC %.12f SIN(0.0 1.0 50.0)\n", fVs, MagVs);




