close all
clear all

pkg load control

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

format long

%%%%%%%%%%%%%%%%%%%%%%% VARIABLES THAT MAY BE CHANGED %%%%%%%%%%%%%%%%

Rdet = 1000; %resistor in envelope detector
Rreg = 10; % resistor in voltage regulator

C = 5*10^(-4); % capacitor in envelope detector

n = 230./14.5; %number of turns in transformer

fVs = 230.; % independent voltage source

fL1 = 1; %inductance (left side of the transformer)
fL2 = fL1*n*n;

t=0:1e-5:2e-1;

v_on = 11.97740/18

%f= 50 Hz , w = 2*pi*f
w = 100*pi;

%R_on = 1;

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

  
%syms v1;
%syms sn;
%syms v2;

%syms v_in1 v_in2 v_fwout1 v_fwout2 i_fwout1 i_fwout2 i_2 sv_on sr_on c1 c2 c3 c4 c5 c6;

%[c1 c2 c3 c4 c5] = solve( (v_in1 - v_fwout1 - sv_on)/sr_on == i_2, (v_in1 - v_fwout1 - sv_on)/sr_on + (v_in2 - v_fwout1 - sv_on)/sr_on == i_fwout1, (-v_in2 - sv_on)/sr_on == i_2 + (v_in2 - v_fwout1 - sv_on)/sr_on, (-v_in2 - sv_on)/sr_on + i_fwout1  == 0, v_in1 - v_in2 == v2, v_in1, v_in2, v_fwout1, i_fwout1, i_2 )


%%%%%%%%%%%%%%%%%%%%%%%%%%----Theoretical Analysis ---%%%%%%%%%%%%%%%%%%%%%%%

  %Ideal Transformer
  v1 = 230 + cos(w*t);

v2 = 1/n * v1;


%----FULL WAVE BRIDGE RECTIFIER-----

v_fwout1 = abs(v2) - 2*v_on; 
v_fwout2 = 0;


%-----ENVELOPE DETECTOR-----

toff=(1/w)* atan(1/(w*Rdet*C))


%Newton Method to find ton



function [solution, no_iterations] = Newton(f, dfdx, x0, eps)
    x = x0;
    f_value = f(x);
    iteration_counter = 0;
    disp(" ")
    disp("iteration counter= %d     x=%f     f(x)=%f", iteration_counter, x, f_value)
    while abs(f_value) > eps && iteration_counter < 100
        try
            x = x - (f_value)/dfdx(x);
        catch
            printf("Error! - derivative zero for x = \n", x)
            exit(1)
        end
        f_value = f(x);
        iteration_counter = iteration_counter + 1;
        disp("iteration counter= %d     x=%f     f(x)=%f", iteration_counter, x, f_value)
    end
    % Here, either a solution is found, or too many iterations
    if abs(f_value) > eps
        iteration_counter = -1;
    end
    solution = x
    no_iterations = iteration_counter;
end

function Newtons_method()
  f = @(x) cos(w*toff)*exp((-x-toff)/(Rdet*C))-cos(x);
dfdx = @(x) -(cos(w*toff)/(Rdet*C))*exp((-x-toff)/(Rdet*C))+ sin(x);
    eps = 1e-6;
    x0 = 1./100.;
    vec = Newton(f, dfdx, x0, eps);
    if no_iterations > 0   % Solution found
        printf("Number of function calls: %d\n", 1 + 2*no_iterations)
        printf("A solution is: %f\n", solution)
    else
        printf("Abort execution.\n")
    end
end

ton = vec(1)


% lecture 14
% at t=0 the diode is on ------> v(fwout1)-von = v(mid1) ---- incluir Von?
% at t=tOFF the diode goes off  ------> v(mid1)-v(fwout2) = v(mid1) = Acos(w*toff)*exp((-t+toff)/(Rdet*C)) ---- saber A
% at t=tON the diode goes on again ------> v(fwout1) = v(mid1) ---- incluir Von?

T = 2*pi/w;
% When the diode is ON, v_fwout1(t)-von = v_mid1(t) --- % t in interval [ON, OFF]
% When the diode is OFF, v(mid1) = Acos(w*toff)*exp((-t+toff)/(Rdet*C)) --- % t in interval [OFF, ON]


% know which one comes first ton or toff

% ton value (example)
ton = toff + 0.8*T;
% declaration of vector with respective size

i = 0;
if i <= 20001 % size of vector t
	% the diode is OFF in the beginning
	if (ton < toff)
		if (t(i) < ton)
		v_mid(i) = v_fwout1(i) - v_on
		elseif (t(i) >= ton && t(i) < toff)
		v_mid(i) = -Rdet*C*sin(w*t(i))*cos(w*t(i))/abs(cos(w*t(i)))- v_on
		endif
		ton = ton + T/2; % after half a period there is a new ton
		toff = toff + T/2; % after half a period there is a new toff
	% the diode is ON in the beginning
	elseif (ton > toff)
		if (t(i) < toff)
		v_mid(i) = v_fwout1(i) - v_on
		elseif (t(i) >= toff && t(i) < toff)
		v_mid(i) = -Rdet*C*sin(w*t(i))*cos(w*t(i))/abs(cos(w*t(i)))- v_on
		endif
		ton = ton + T/2; % after half a period there is a new ton
		toff = toff + T/2; % after half a period there is a new toff
	else
	print("Error in calculations!\n")
	
	endif
i = i+1;
endif


%-----VOLTAGE REGULATOR-----



  
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

fprintf(ngspice_input,"Dreg01 out1 d01 Default\n");
fprintf(ngspice_input,"Dreg02 d01 d02 Default\n");
fprintf(ngspice_input,"Dreg03 d02 d03 Default\n");
fprintf(ngspice_input,"Dreg04 d03 d04 Default\n");
fprintf(ngspice_input,"Dreg05 d04 d05 Default\n");
fprintf(ngspice_input,"Dreg06 d05 d06 Default\n");
fprintf(ngspice_input,"Dreg07 d06 d07 Default\n");
fprintf(ngspice_input,"Dreg08 d07 d08 Default\n");
fprintf(ngspice_input,"Dreg09 d08 d09 Default\n");
fprintf(ngspice_input,"Dreg010 d09 d010 Default\n");
fprintf(ngspice_input,"Dreg011 d010 d011 Default\n");
fprintf(ngspice_input,"Dreg012 d011 d012 Default\n");
fprintf(ngspice_input,"Dreg013 d012 d013 Default\n");
fprintf(ngspice_input,"Dreg014 d013 d014 Default\n");
fprintf(ngspice_input,"Dreg015 d014 d015 Default\n");
fprintf(ngspice_input,"Dreg016 d015 d016 Default\n");
fprintf(ngspice_input,"Dreg017 d016 d017 Default\n");
fprintf(ngspice_input,"Dreg018 d017 0 Default\n");
fprintf(ngspice_input,"Dreg11 out1 d11 Default\n");
fprintf(ngspice_input,"Dreg12 d11 d12 Default\n");
fprintf(ngspice_input,"Dreg13 d12 d13 Default\n");
fprintf(ngspice_input,"Dreg14 d13 d14 Default\n");
fprintf(ngspice_input,"Dreg15 d14 d15 Default\n");
fprintf(ngspice_input,"Dreg16 d15 d16 Default\n");
fprintf(ngspice_input,"Dreg17 d16 d17 Default\n");
fprintf(ngspice_input,"Dreg18 d17 d18 Default\n");
fprintf(ngspice_input,"Dreg19 d18 d19 Default\n");
fprintf(ngspice_input,"Dreg110 d19 d110 Default\n");
fprintf(ngspice_input,"Dreg111 d110 d111 Default\n");
fprintf(ngspice_input,"Dreg112 d111 d112 Default\n");
fprintf(ngspice_input,"Dreg113 d112 d113 Default\n");
fprintf(ngspice_input,"Dreg114 d113 d114 Default\n");
fprintf(ngspice_input,"Dreg115 d114 d115 Default\n");
fprintf(ngspice_input,"Dreg116 d115 d116 Default\n");
fprintf(ngspice_input,"Dreg117 d116 d117 Default\n");
fprintf(ngspice_input,"Dreg118 d117 0 Default\n");
fprintf(ngspice_input,"Dreg21 out1 d21 Default\n");
fprintf(ngspice_input,"Dreg22 d21 d22 Default\n");
fprintf(ngspice_input,"Dreg23 d22 d23 Default\n");
fprintf(ngspice_input,"Dreg24 d23 d24 Default\n");
fprintf(ngspice_input,"Dreg25 d24 d25 Default\n");
fprintf(ngspice_input,"Dreg26 d25 d26 Default\n");
fprintf(ngspice_input,"Dreg27 d26 d27 Default\n");
fprintf(ngspice_input,"Dreg28 d27 d28 Default\n");
fprintf(ngspice_input,"Dreg29 d28 d29 Default\n");
fprintf(ngspice_input,"Dreg210 d29 d210 Default\n");
fprintf(ngspice_input,"Dreg211 d210 d211 Default\n");
fprintf(ngspice_input,"Dreg212 d211 d212 Default\n");
fprintf(ngspice_input,"Dreg213 d212 d213 Default\n");
fprintf(ngspice_input,"Dreg214 d213 d214 Default\n");
fprintf(ngspice_input,"Dreg215 d214 d215 Default\n");
fprintf(ngspice_input,"Dreg216 d215 d216 Default\n");
fprintf(ngspice_input,"Dreg217 d216 d217 Default\n");
fprintf(ngspice_input,"Dreg218 d217 0 Default\n");
fprintf(ngspice_input,"Dreg31 out1 d31 Default\n");
fprintf(ngspice_input,"Dreg32 d31 d32 Default\n");
fprintf(ngspice_input,"Dreg33 d32 d33 Default\n");
fprintf(ngspice_input,"Dreg34 d33 d34 Default\n");
fprintf(ngspice_input,"Dreg35 d34 d35 Default\n");
fprintf(ngspice_input,"Dreg36 d35 d36 Default\n");
fprintf(ngspice_input,"Dreg37 d36 d37 Default\n");
fprintf(ngspice_input,"Dreg38 d37 d38 Default\n");
fprintf(ngspice_input,"Dreg39 d38 d39 Default\n");
fprintf(ngspice_input,"Dreg310 d39 d310 Default\n");
fprintf(ngspice_input,"Dreg311 d310 d311 Default\n");
fprintf(ngspice_input,"Dreg312 d311 d312 Default\n");
fprintf(ngspice_input,"Dreg313 d312 d313 Default\n");
fprintf(ngspice_input,"Dreg314 d313 d314 Default\n");
fprintf(ngspice_input,"Dreg315 d314 d315 Default\n");
fprintf(ngspice_input,"Dreg316 d315 d316 Default\n");
fprintf(ngspice_input,"Dreg317 d316 d317 Default\n");
fprintf(ngspice_input,"Dreg318 d317 0 Default\n");

%%% transformer
% www.seas.upenn.edu/~jan/spice/spice.transformer.html
% sourceforge.net/p/ngspice/discussion/133842/thread/87641fa4/
% forum.kicad.info/t/how-to-edit-transformer/19871/5
% www.analog.com/en/technical-articles/ltspice-basic-stepssimulating-transformers.html#
% ngspice.sourceforge.net/docs/ngspice-html-manual/manual.xhtml#subsec_Inductors

fprintf(ngspice_input,"E1 in1 im begin1 0 %.12f\n", 1./n);
fprintf(ngspice_input,"Vim in2 im 0\n");
fprintf(ngspice_input,"F1 im1 0 Vim %.12f\n", 1./n);
fprintf(ngspice_input,"R2 begin1 im1 1\n"); 


%%% voltage source
fprintf(ngspice_input,"Vs begin1 0 SIN(0.000000000000 %.12f 50.0 0.0 0.0 -90)\n", fVs);

fclose(ngspice_input);

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



