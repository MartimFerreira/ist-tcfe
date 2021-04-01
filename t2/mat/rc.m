close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

format long

%{
pkg load symbolic

syms t
syms R
syms C
syms vi(t)
syms vo(t)
syms i(t)

i(t)=C*diff(vo,t)

printf("\n\nKVL equation:\n");

vi(t) = R*i(t)+vo(t)

syms vo_n(t) %natural solution
syms vo_f(t) %forced solution

printf("\n\nSolution is of the form");

v(t) = vo_n(t) + vo_f(t)

printf("\n\nNatural solution:\n");
syms A
syms wn

vi(t) = 0 %no excitation
i_n(t) = C*diff(vo_n, t)


printf("\n\n Natural solution is of the form");
vo_n(t) = A*exp(wn*t)

R*i_n(t)+vo_n(t) == 0

R*C*wn*vo_n(t)+vo_n(t) == 0

R*C*wn+1==0

solve(ans, wn)


%%EXAMPLE NUMERIC COMPUTATIONS

R=1e3 %Ohm
C=100e-9 %F

f = 1000 %Hz
w = 2*pi*f; %rad/s

%time axis: 0 to 10ms with 1us steps
t=0:1e-6:10e-3; %s

Zc = 1/(j*w*C)
Cgain = Zc/(R+Zc)
Gain = abs(Cgain)
Phase = angle(Cgain)

vi = 1*cos(w*t);
vo = Gain*cos(w*t+Phase);

hf = figure ();
plot (t*1000, vi, "g");
hold on;
plot (t*1000, vo, "b");

xlabel ("t[ms]");
ylabel ("vi(t), vo(t) [V]");
print (hf, "forced.eps", "-depsc");


%}



%%%%%%%%%%%%%%%CREATE-NGSPICE-INPUT-DATA-FILE%%%%%%%%%%%%%%%%%%

data = fopen("../data.txt", "r");

fR1 = 0;
fR2 = 0;
fR3 = 0;
fR4 = 0;
fR5 = 0;
fR6 = 0;
fR7 = 0;
fVs = 0;
fC = 0;
fKb = 0;
fKd = 0;

trash = fscanf(data, "\n\nPlease enter the lowest student number in your group: ");
trash = fscanf(data, "\n\nUnits for the values: V, mA, kOhm, mS and uF\n\nValues:  ");
[fR1, fR2, fR3, fR4, fR5, fR6, fR7, count, errmsg] = fscanf(data, "R1 = %f \nR2 = %f \nR3 = %f \nR4 = %f \nR5 = %f \nR6 = %f \nR7 = %f \n", "C");
[fVs, fC, fKb, fKd, count, errmsg] = fscanf(data, "Vs = %f \nC = %f \nKb = %f \nKd = %f", "C");

fclose(data)


fR1 = fR1 * 1000;
fR2 = fR2 * 1000;
fR3 = fR3 * 1000;
fR4 = fR4 * 1000;
fR5 = fR5 * 1000;
fR6 = fR6 * 1000;
fR7 = fR7 * 1000;
fC = fC/1000000;
fKb = fKb/1000;
fKd = fKd*1000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ngspice_2_input = fopen("../sim/ngspice_2_input.txt", "w");

fprintf(ngspice_2_input,"R1 1 2 %f", fR1);
fprintf(ngspice_2_input,"R2 2 3 %f", fR2);
fprintf(ngspice_2_input,"R3 2 5 %f", fR3);
fprintf(ngspice_2_input,"R4 0 5 %f", fR4);
fprintf(ngspice_2_input,"R5 5 6 %f", fR5);
fprintf(ngspice_2_input,"R6 0 7 %f", fR6);

%Fonte de tensão imaginária
fprintf(ngspice_2_input,"Vi 7 im %f", 0); 

fprintf(ngspice_2_input,"R7 im 8 %f", fR7);
fprintf(ngspice_2_input,"Vs 2 3 %f", 0);
fprintf(ngspice_2_input,"Vx 6 8 %f", V6-V8);
fprintf(ngspice_2_input,"Gb 6 3 2 5 %f", fKb);
fprintf(ngspice_2_input,"Hd 5 8 Vi %f", fKd);

fclose(ngspice_2_input);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ngspice_3_input = fopen("../sim/ngspice_3_input.txt", "w");

fprintf(ngspice_3_input,"R1 1 2 %f", fR1);
fprintf(ngspice_3_input,"R2 2 3 %f", fR2);
fprintf(ngspice_3_input,"R3 2 5 %f", fR3);
fprintf(ngspice_3_input,"R4 0 5 %f", fR4);
fprintf(ngspice_3_input,"R5 5 6 %f", fR5);
fprintf(ngspice_3_input,"R6 0 7 %f", fR6);

%Fonte de tensão imaginária
fprintf(ngspice_3_input,"Vi 7 im %f", 0); 

fprintf(ngspice_3_input,"R7 im 8 %f", fR7);
fprintf(ngspice_3_input,"Vs 2 3 %f", 0);
fprintf(ngspice_3_input,"C1 6 8 %f", fC);
fprintf(ngspice_3_input,"Gb 6 3 2 5 %f", fKb);
fprintf(ngspice_3_input,"Hd 5 8 Vi %f", fKd);

fclose(ngspice_3_input);
