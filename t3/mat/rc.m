close all
clear all

pkg load control

pkg load symbolic

%%EXAMPLE SYMBOLIC COMPUTATIONS

format long

%%%%%%%%%%%%%%%%%%%%%%% VARIABLES THAT MAY BE CHANGED %%%%%%%%%%%%%%%%

Rdet = 10000; %resistor in envelope detector
Rreg = 5000; % resistor in voltage regulator

C = 5*10^(-5); % capacitor in envelope detector

n = 230./46.37; %number of turns in transformer

fVs = 230.; % independent voltage source

t=0:1e-5:2e-1;

v_on = 12.00007/18

r_d = (12.01317-11.98591)/(0.006430684-0.006064976) *4/18

%f= 50 Hz , w = 2*pi*f
w = 100*pi;

%R_on = 1;

N_diodes_series = 18;
N_diodes_parallel = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%----Theoretical Analysis ---%%%%%%%%%%%%%%%%%%%%%%%

%Ideal Transformer

v1 = 230 * cos(w*t);

v2 = 1/n * v1;


%----FULL WAVE BRIDGE RECTIFIER-----

v_fwout1 = abs(v2) - 2*v_on; 
v_fwout2 = 0;


%-----ENVELOPE DETECTOR-----

%toff calculation

A= 230/n;

syms ws real
syms Rdets real
syms Cs real
syms vons real
syms toffs real
syms toffs2 real 
syms As real
syms x real
syms y real
syms tons real


  f_toff = As*Cs*ws*sin(ws*toffs)*abs(cos(ws*toffs))/cos(ws*toffs) - As*abs(cos(ws*toffs))/Rdets +(2*vons)/Rdets;

  f_ton = As*abs(cos(ws*toffs2))*exp((-tons+toffs2)/(Rdets*Cs))- As*abs(cos(ws*tons));

% Substitute in values that are known
  newf = subs(f_toff, [ws,Rdets, Cs, vons,As], [w, Rdet, C, v_on, A]);

% Solve the resulting symbolic expression for toffs
[result] = solve(newf == 0, toffs);


% And if you need a numeric (rather than symbolic) result
  toff_1= double(result(1));
toff_2= double(result(2));

toff=toff_2;

newf_ton = subs(f_ton, [ws,Rdets, Cs, toffs2,As], [w, Rdet, C, toff, A]);


  %Newton

maxNumIter = 60000;
itCounter = 0;
tol=1e-5;
x0= 9.228000e-03; 
syms fp;   % derivative
fp = diff(newf_ton);

xcur = x0;
while ( (abs(subs(newf_ton,xcur))>tol)  &  (itCounter < maxNumIter) ) 
        xcur = double(xcur - subs(newf_ton,xcur)/subs(fp,xcur));
        itCounter = itCounter+1;
end

if( abs(subs(newf_ton,xcur))>tol )
  disp("not found")
end

    ton=xcur;


T = 2*pi/w;


% lecture 14
% When the diode is ON, v_o = v_s --- % t in interval [ON, OFF]
% When the diode is OFF, v_o = -R*i_c --- % t in interval [OFF, ON]


% links that may be helpful
% https://www.yanivplan.com/files/tutorial2vectors.pdf
% https://stackoverflow.com/questions/38174739/octave-replace-elements-in-a-vector-under-certain-circumstances

%ton_i = ton - T; % initial ton
%toff_i = toff; % initial toff

ton=ton-T;

disp("toff = ")
  disp(toff)
  disp("ton = ")
  disp(ton+T)
disp("T/2 = ")
disp(T/2)
disp("fwout1 max = ")
disp(max(v_fwout1))

v_mid1 = zeros(20001, 1); % fill v_mid1 vector with zeros (20001 is the size of vector t)

%if (ton_i < toff_i) %the diode is OFF in the beginning
%	for idx = 1:length(v_mid1);
 %               if(t(idx) > ton) toff = toff + T;
%		end
%		if(t(idx) > toff) ton = ton + T;
%		end
%		if (t(idx) >= toff && t(idx) < ton) % diode OFF
%		v_mid1(idx) = A*cos(w*toff_i)*e^(-(t(idx)-toff_i)/(Rdet*C));
%		else % diode ON
%		v_mid1(idx) = v_fwout1(idx) - v_on;
%		end
%		
%	end
%end

%if (ton_i > toff_i) %the diode is ON in the beginning
	for idx = 1:length(v_mid1);
                if((t(idx) > ton) && (toff<ton)) toff = toff + T/2;
		end
		if((t(idx) > toff) && (ton<toff)) ton = ton + T/2;
		end
		if (t(idx) >= ton) % diode ON
		v_mid1(idx) = v_fwout1(idx) - v_on;
		else % diode OFF
			 v_mid1(idx) = (abs(A*cos(w*toff))-3*v_on)*e^(-(t(idx)-toff)/(Rdet*C));
		end
		
	end
%end

%t(idx) <= toff_i || 
%for idx = 1:length(v_mid1);
%	if (ton_i < toff_i)
%		if (t(idx) < ton) % diode OFF
%		v_mid1(idx) = -Rdet*C*sin(w*t(idx))*cos(w*t(idx))/abs(cos(w*t(idx)))- v_on;
%		else % diode ON
%		v_mid1(idx) = v_fwout1(idx) - v_on;
%		end
%		%ton = ton + T/2; % after half a period there is a new ton
%		%toff = toff + T/2; % after half a period there is a new toff
%	 %the diode is ON in the beginning
%	else % when testing I realised this was the part of the loop it used
%		if (t(idx) < toff) % diode ON
%		v_mid1(idx) = v_fwout1(idx) - v_on;
%		else % diode OFF
%		v_mid1(idx) = -Rdet*C*sin(w*t(idx))*cos(w*t(idx))/abs(cos(w*t(idx)))- v_on;
%		end
%		%ton = ton + T/2; % after half a period there is a new ton
%		%toff = toff + T/2; % after half a period there is a new toff
%	end
%	%if (t(idx)==toff) 
%	%ton = ton + T/2; % after half a period there is a new ton
%	%end
%	%if (t(idx)==ton)
%	%toff = toff + T/2; % after half a period there is a new toff
%	%end
%end

%v_mid1 = zeros(20001, 1); % fill v_mid1 vector with zeros (20001 is the size of vector t)
%for idx = 1:length(v_mid1);
%     %the diode is OFF in the beginning
%	if (ton < toff)
%		if (t(idx) < ton) % diode OFF
%		v_mid1(idx) = -Rdet*C*sin(w*t(idx))*cos(w*t(idx))/abs(cos(w*t(idx)))- v_on;
%		else % diode ON
%		v_mid1(idx) = v_fwout1(idx) - v_on;
%		end
%		%ton = ton + T/2; % after half a period there is a new ton
%		%toff = toff + T/2; % after half a period there is a new toff
%	 %the diode is ON in the beginning
%	else % when testing I realised this was the part of the loop it used
%		if (t(idx) < toff) % diode ON
%		v_mid1(idx) = v_fwout1(idx) - v_on;
%		else % diode OFF
%		v_mid1(idx) = -Rdet*C*sin(w*t(idx))*cos(w*t(idx))/abs(cos(w*t(idx)))- v_on;
%		end
%		%ton = ton + T/2; % after half a period there is a new ton
%		%toff = toff + T/2; % after half a period there is a new toff
%	end
%	%if (t(idx)==toff) 
%	%ton = ton + T/2; % after half a period there is a new ton
%	%end
%	%if (t(idx)==ton)
%	%toff = toff + T/2; % after half a period there is a new toff
%	%end
%end

%print vector t --- working
%g=sprintf('%f ', t);
%fprintf('Answer: %s\n', g)

%print vector v_fwout1 --- working
%g=sprintf('%f ', v_fwout1);
%fprintf('Answer: %s\n', g)

%print vector v_mid1
%g=sprintf("%f ", v_mid1);
%fprintf("Answer: %s\n", g)


%%%%%%%%%%%% Voltage Regulator %%%%%%%%%%%%%%%%%%%%%

v_mid_DC = mean (v_mid1);
v_mid_AC = v_mid1-v_mid_DC;

v_out_DC = N_diodes_series * v_on;

diode_total_res = N_diodes_series/N_diodes_parallel * r_d;
  
v_out_AC = v_mid_AC * diode_total_res/(diode_total_res + Rreg);


DC_deviation = v_out_DC - 12
  voltage_ripple = max(v_out_AC) - min(v_out_AC)
  cost = 77*0.1 + (Rdet+Rreg)/1000 + C*10^6
  theoretical_merit = 1/(cost * (voltage_ripple + DC_deviation + 10^(-6)))

  ngspice_ripple = 12.01317 - 11.98591
  ngspice_deviation = 12.00007 - 12
  merit = 1/(cost * (ngspice_ripple + ngspice_deviation + 10^(-6)))


%%%%%%%%%%%%%%%% Graph %%%%%%%%%%%%%%%

%v_fwout1_plot = figure ();
%plot (t, v_fwout1, "g");

%xlabel ("t [s]");
%ylabel ("v_{fwout1}(t) [V]");
%print (v_fwout1_plot, "v_fwout1_plot.eps", "-depsc");

%v_mid1_plot = figure ();
%plot (t, v_mid1, "g");

%xlabel ("t [s]");
%ylabel ("v_{mid1}(t) [V]");
%print (v_mid1_plot, "v_mid1_plot.eps", "-depsc");


v_out_plot = figure ();

plot (t, v_out_DC+v_out_AC, "b");
hold on;
plot (t, v_mid1, "r");

xlabel ("t [s]");
ylabel ("v_{OUT}, v_{MID1} [V]");
legenda= legend("v_{OUT}" , "v_{MID1}");
print (v_out_plot, "v_out_plot.eps", "-depsc");


v_centered_output_plot = figure ();

plot (t, v_out_AC*1000, "r");

xlabel ("t [s]");
ylabel ("v_{out} [mV]");
legenda= legend("v_{out}");
print (v_centered_output_plot, "v_centered_output_plot.eps", "-depsc");
  
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



fprintf(ngspice_input,"E1 in1 im begin1 0 %.12f\n", 1./n);
fprintf(ngspice_input,"Vim in2 im 0\n");
fprintf(ngspice_input,"F1 im1 0 Vim %.12f\n", 1./n);
fprintf(ngspice_input,"R2 begin1 im1 1\n"); 


%%% voltage source
fprintf(ngspice_input,"Vs begin1 0 SIN(0.000000000000 %.12f 50.0 0.0 0.0 -90)\n", fVs);

fclose(ngspice_input);

%%%%%%%%%%%%%%%%%%%%%%%% TABLES %%%%%%%%%%%%%%%%%%%%%%


merit_tab = fopen("merit_tab.tex", "w");

fprintf(merit_tab, "$Average\\;DC\\;Deviation\\;(\\mu V)$ & %.6f & %.6f\\\\ \\hline\n", ngspice_deviation*1000000, DC_deviation*1000000);
fprintf(merit_tab, "$Voltage\\;Ripple\\;(mV)$ & %.6f & %.6f\\\\ \\hline\n", ngspice_ripple*1000, voltage_ripple*1000);
fprintf(merit_tab, "$Cost\\;(MU)$ & \\multicolumn{2}{|c|}{%.6f}\\\\ \\hline\n", cost);
fprintf(merit_tab, "$Merit$ & %.6f & %.6f\\\\ \\hline\n", merit, theoretical_merit);

fclose(merit_tab);



resistance_tab = fopen("resistance_tab.tex", "w");

fprintf(resistance_tab, "$Rdet$& %.1f\\\\ \\hline\n", Rdet);
fprintf(resistance_tab, "$Rreg$& %.1f\\\\ \\hline\n", Rreg);
fprintf(resistance_tab, "$C$& %.6f\\\\ \\hline\n", C);
fprintf(resistance_tab, "$n$& %.6f\\\\ \\hline\n", n);
fprintf(resistance_tab, "$V_{on}$& %.6f\\\\ \\hline\n", v_on);
fprintf(resistance_tab, "$R_d$& %.6f\\\\ \\hline\n", r_d);


fclose(merit_tab);





















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Tentativas de newton que nao quis apagar%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






 %newton 1;

%f_ton = @(x) abs(cos(w*toff))*exp((-x+toff)/(Rdet*C))-abs(cos(w*x));
%dfdx = @(x) (-abs(cos(w*toff))*(1/(Rdet*C)))*exp((-x+toff)/(Rdet*C))+ w*sin(x*w)*(cos(w*x)/abs(cos(w*x)));
%    eps = 1e-6;
%    x0 = toff + 1/10;


%    x = x0;
%    f_value = f_ton(x);
%    iteration_counter = 0;

    
%    while abs(f_value) > eps && iteration_counter < 100000000
%        try
%            x = x - (f_value)/dfdx(x);
%        catch
%            printf("Error! - derivative zero for x = \n", x)
%            exit(1)
%        end
%        f_value = f_ton(x);
%        iteration_counter = iteration_counter + 1;
%        
%   end
%    % Here, either a solution is found, or too many iterations
%    if abs(f_value) > eps
%        iteration_counter = -1;
%    end
%    ton = x
%    no_iterations = iteration_counter;













 %function [solution, no_iterations] = Newton(f, dfdx, x0, eps)
 %   x = x0;
 %   f_value = f(x);
 %   iteration_counter = 0;
 %   disp(" ")
 %   disp("iteration counter= %d     x=%f     f(x)=%f", iteration_counter, x, f_value)
 %   while abs(f_value) > eps && iteration_counter < 100
 %       try
 %           x = x - (f_value)/dfdx(x);
 %       catch
 %           printf("Error! - derivative zero for x = \n", x)
 %           exit(1)
 %       end
 %       f_value = f(x);
 %       iteration_counter = iteration_counter + 1;
 %       disp("iteration counter= %d     x=%f     f(x)=%f", iteration_counter, x, f_value)
 %   end
 %   % Here, either a solution is found, or too many iterations
 %   if abs(f_value) > eps
 %       iteration_counter = -1;
 %   end
 %   solution = x
 %   no_iterations = iteration_counter;
%end

%function Newtons_method()
%  f = @(x) cos(w*toff)*exp((-x-toff)/(Rdet*C))-cos(x);
%dfdx = @(x) -(cos(w*toff)/(Rdet*C))*exp((-x-toff)/(Rdet*C))+ sin(x);
%    eps = 1e-6;
%    x0 = 1./100.;
%    vec = Newton(f, dfdx, x0, eps);
%    if no_iterations > 0   % Solution found
%        printf("Number of function calls: %d\n", 1 + 2*no_iterations)
%        printf("A solution is: %f\n", solution)
%    else
%        printf("Abort execution.\n")
%    end
% end



%ton = vec(1)
