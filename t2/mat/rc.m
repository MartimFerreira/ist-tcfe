close all
clear all

pkg load control

%%EXAMPLE SYMBOLIC COMPUTATIONS

format long

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

fclose(data);


%%%%%%%%%%%%%%%%%%%%%%% MAIN CALCULATIONS %%%%%%%%%%%%%%%%555

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


%%%%%%%%% t < 0


M = [ 1, 0, 0, -1, 0, 0, 0, 0;
      -(1/fR1), (1/fR1) + (1/fR2) + (1/fR3), -(1/fR2),0,  -(1/fR3), 0, 0, 0;
      0, -(1/fR2) - fKb, (1/fR2), 0, fKb, 0, 0, 0;
      0, 0, 0, 1, 0, 0, 0, 0; 
      0, fKb, 0, 0, -fKb - (1/fR5), (1/fR5), 0, 0; 
      0, 0, 0, (1/fR6), 0, 0, -(1/fR6) - (1/fR7), (1/fR7); 
      0, 0, 0, -fKd/fR6, 1, 0, fKd/fR6, -1; 
      0, (1/fR3), 0, (1/fR4),-(1/fR3)-(1/fR4)-(1/fR5),(1/fR5),(1/fR7),-(1/fR7);];


b = [fVs; 0; 0; 0; 0; 0; 0; 0];
x = M \ b;
 
V1 = x(1)
V2 = x(2)
V3 = x(3)
V4 = x(4)
V5 = x(5)
V6 = x(6)
V7 = x(7)
V8 = x(8)
Vx= V6-V8;


I1=(V1-V2)/fR1
I2=(V2-V3)/fR2 
I3=(V2-V5)/fR3 
I4=(-V5)/fR4
I5=(V5-V6)/fR5 
I6=(-V7)/fR6
I7=(V7-V8)/fR7 



%%%%%% t = 0
M0 = [(1/fR1) + (1/fR2) + (1/fR3), -(1/fR2), -(1/fR3), 0, 0, 0, 0;
      -1/fR2 - fKb, 1/fR2, fKb, 0, 0, 0, 0;
      fKb, 0, -fKb - 1/fR5, 1/fR5, 0, 0, -1;
      0, 0, 0, 0, -1/fR6 - 1/fR7, 1/fR7, 0; 
      0, 0, 1, 0, fKd/fR6, -1, 0; 
      0, 0, 0, 1, 0, -1, 0;
      1/fR3, 0, -1/fR3 - 1/fR4 - 1/fR5, 1/fR5, 1/fR7, -1/fR7, -1;];



b0 = [0; 0; 0; 0; 0; Vx; 0];

x0 = M0 \ b0;
 
V20 = x0(1)
V30 = x0(2)
V50 = x0(3)
V60 = x0(4)
V70 = x0(5)
V80 = x0(6)
Ix  = x0(7)

Req= Vx/Ix


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%alinea 3, 4 e 5

Vsp= 1; 
f=1000; 
w= 2*pi*f;
Zc = 1/(j*w*fC); 

Mp = [ 1, 0, 0, 0, 0, 0, 0;                                                           %no1
      -(1/fR1), (1/fR1) + (1/fR2) + (1/fR3), -(1/fR2), -(1/fR3), 0, 0, 0;             %no2
      0, -(1/fR2) - fKb, (1/fR2), fKb, 0, 0, 0;                                       %no3
      0, fKb, 0,-fKb - (1/fR5), (1/fR5)+(1/Zc), 0,-(1/Zc);                            %no6
      0, 0, 0, 0, 0, -(1/fR6) - (1/fR7), (1/fR7);                                     %no7 
      0, 0, 0, 1, 0, fKd/fR6, -1;                                                     %no8
      0, (1/fR3), 0,-(1/fR3)-(1/fR4)-(1/fR5),(1/fR5)+(1/Zc),(1/fR7),-(1/fR7)-(1/Zc);]; %supernode


bp = [Vsp; 0; 0; 0; 0; 0; 0];
xp = Mp \ bp;

V1p = xp(1)
V2p = xp(2)
V3p = xp(3)
V5p = xp(4)
V6p = xp(5)
V7p = xp(6)
V8p = xp(7)

AV1p= abs(V1p)
AV2p= abs(V2p)
AV3p= abs(V3p)
AV5p= abs(V5p)
AV6p= abs(V6p)
AV7p= abs(V7p)
AV8p= abs(V8p)

t=0:1e-6:20e-3;

ct=exp(j*w*t); 

V1s= imag(ct*V1p); 
V2s= imag(ct*V2p);
V3s= imag(ct*V3p);
V5s= imag(ct*V5p);
V6s= imag(ct*V6p);
V7s= imag(ct*V7p);
V8s= imag(ct*V8p);


t_3=0:1e-6:20e-3;


A = V60 - imag(V6p);

v6_natural = A * exp(-t_3/(Req*fC));

v6natural_plot = figure ();
plot (t_3*1000, v6_natural, "g");

xlabel ("t[ms]");
ylabel ("v6(t) [V]");
print (v6natural_plot, "v6natural_plot.eps", "-depsc");


t_neg= 0:1e-6:5e-03;
V6_vector =linspace(V6,V6,5e03+1);
Vs_vector =linspace(fVs,fVs,5e03+1);

V6_verticalx = linspace(0,0,100);
V6_verticaly = linspace(V6,V60,100);
Vs_verticalx = linspace(0,0,100);
Vs_verticaly = linspace(0,fVs,100);


vfinal_plot = figure ();
plot((t_neg-5e-03)*1000, V6_vector, "g"); 
hold on; 
plot((t_neg-5e-03)*1000, Vs_vector, "b");
hold on; 
plot (t*1000, V6s+v6_natural, "g");
hold on;
plot (t*1000, V1s, "b");
hold on; 
plot(V6_verticalx,V6_verticaly, "g");
hold on; 
plot(Vs_verticalx,Vs_verticaly, "b");


xlabel ("t[ms]");
ylabel ("v6(t), vs(t) [V]");
legenda= legend("V6(t)" ,"Vs(t)"); 
print (vfinal_plot, "vfinal_plot.eps", "-depsc");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%alinea6

k=5
cont=1; 
freq=logspace(-1,6,7*k);


V1f =linspace(1,1,7*k);
V2f =linspace(1,1,7*k);
V3f =linspace(1,1,7*k);
V5f =linspace(1,1,7*k);
V6f =linspace(1,1,7*k);
V7f =linspace(1,1,7*k);
V8f =linspace(1,1,7*k);

Vsf= 1; 

for i= freq
      wf = 2*pi*i;

      Zcf = 1/(j*wf*fC)


      Mf = [ 1, 0, 0, 0, 0, 0, 0;                                                           %no1
            -(1/fR1), (1/fR1) + (1/fR2) + (1/fR3), -(1/fR2), -(1/fR3), 0, 0, 0;             %no2
            0, -(1/fR2) - fKb, (1/fR2), fKb, 0, 0, 0;                                       %no3
            0, fKb, 0,-fKb - (1/fR5), (1/fR5)+(1/Zcf), 0,-(1/Zcf);                          %no6
            0, 0, 0, 0, 0, -(1/fR6) - (1/fR7), (1/fR7);                                     %no7 
            0, 0, 0, 1, 0, fKd/fR6, -1;                                                     %no8
            0, (1/fR3), 0,-(1/fR3)-(1/fR4)-(1/fR5),(1/fR5)+(1/Zcf),(1/fR7),-(1/fR7)-(1/Zcf);] %supernode

      bf = [Vsf; 0; 0; 0; 0; 0; 0];
      xf = Mf \ bf

      V1f(cont) = xf(1);
      V2f(cont) = xf(2);
      V3f(cont) = xf(3);
      V5f(cont) = xf(4);
      V6f(cont) = xf(5);
      V7f(cont) = xf(6);
      V8f(cont) = xf(7);
      cont++;

endfor


V1f_mag =abs(V1f);
V2f_mag =abs(V2f);
V3f_mag =abs(V3f);
V5f_mag =abs(V5f);
V6f_mag =abs(V6f);
V7f_mag =abs(V7f);
V8f_mag =abs(V8f);
Vcf_mag =abs(V6f - V8f);

V1f_phase =angle(V1f);
V2f_phase =angle(V2f);
V3f_phase =angle(V3f);
V5f_phase =angle(V5f);
V6f_phase =angle(V6f);
V7f_phase =angle(V7f);
V8f_phase =angle(V8f);
Vcf_phase =angle(V6f - V8f);

vphase_plot = figure ();
semilogx (freq, V6f_phase*(180/pi), "g");
hold on;
semilogx (freq, V1f_phase*(180/pi), "b");
hold on;
semilogx (freq, Vcf_phase*(180/pi), "r");

xlabel ("f[Hz]");
ylabel ("v6, vs, vc [Degree]");
legenda= legend("phase of V6" , "phase of Vs", "phase of Vc" ); 
print (vphase_plot, "vphase_plot.eps", "-depsc");

vmag_plot = figure ();
semilogx (freq, mag2db(V6f_mag), "g");
hold on;
semilogx (freq, mag2db(V1f_mag), "b");
hold on;
semilogx (freq, mag2db(Vcf_mag), "r");

xlabel ("f[Hz]");
ylabel ("v6, vs, vc [dB]");
legenda= legend("magnitude of V6" , "magnitude of Vs", "magnitude of Vc" ); 
print (vmag_plot, "vmag_plot.eps", "-depsc");



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ngspice_1_input = fopen("../sim/ngspice_1_input.txt", "w");

fprintf(ngspice_1_input,"R1 1 2 %f\n", fR1);
fprintf(ngspice_1_input,"R2 2 3 %f\n", fR2);
fprintf(ngspice_1_input,"R3 2 5 %f\n", fR3);
fprintf(ngspice_1_input,"R4 0 5 %f\n", fR4);
fprintf(ngspice_1_input,"R5 5 6 %f\n", fR5);
fprintf(ngspice_1_input,"R6 0 7 %f\n", fR6);

%Fonte de tensão imaginária
fprintf(ngspice_1_input,"Vi 7 im %f\n",0); 

fprintf(ngspice_1_input,"R7 im 8 %f\n", fR7);
fprintf(ngspice_1_input,"Vs 1 0 %f\n", fVs);
fprintf(ngspice_1_input,"Gb 6 3 2 5 %f\n", fKb);
fprintf(ngspice_1_input,"Hd 5 8 Vi %f\n", fKd);

fclose(ngspice_1_input);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


ngspice_2_input = fopen("../sim/ngspice_2_input.txt", "w");

fprintf(ngspice_2_input,"R1 1 2 %f\n", fR1);
fprintf(ngspice_2_input,"R2 2 3 %f\n", fR2);
fprintf(ngspice_2_input,"R3 2 5 %f\n", fR3);
fprintf(ngspice_2_input,"R4 0 5 %f\n", fR4);
fprintf(ngspice_2_input,"R5 5 6 %f\n", fR5);
fprintf(ngspice_2_input,"R6 0 7 %f\n", fR6);

%Fonte de tensão imaginária
fprintf(ngspice_2_input,"Vi 7 im %f\n", 0); 

fprintf(ngspice_2_input,"R7 im 8 %f\n", fR7);
fprintf(ngspice_2_input,"Vs 1 0 %f\n", 0);
fprintf(ngspice_2_input,"Vx 6 8 %f\n", Vx);
fprintf(ngspice_2_input,"Gb 6 3 2 5 %f\n", fKb);
fprintf(ngspice_2_input,"Hd 5 8 Vi %f\n", fKd);

fclose(ngspice_2_input);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ngspice_3_input = fopen("../sim/ngspice_3_input.txt", "w");

fprintf(ngspice_3_input,"R1 1 2 %f\n", fR1);
fprintf(ngspice_3_input,"R2 2 3 %f\n", fR2);
fprintf(ngspice_3_input,"R3 2 5 %f\n", fR3);
fprintf(ngspice_3_input,"R4 0 5 %f\n", fR4);
fprintf(ngspice_3_input,"R5 5 6 %f\n", fR5);
fprintf(ngspice_3_input,"R6 0 7 %f\n", fR6);

%Fonte de tensão imaginária
fprintf(ngspice_3_input,"Vi 7 im %f\n", 0); 

fprintf(ngspice_3_input,"R7 im 8 %f\n", fR7);
fprintf(ngspice_3_input,"Vs 1 0 %f\n", 0);
fprintf(ngspice_3_input,"C1 6 8 %f\n", fC);
fprintf(ngspice_3_input,"Gb 6 3 2 5 %f\n", fKb);
fprintf(ngspice_3_input,"Hd 5 8 Vi %f\n", fKd);
fprintf(ngspice_3_input,".ic v(6) = %f v(8) = %f\n", V60, V80);

fclose(ngspice_3_input);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ngspice_4_input = fopen("../sim/ngspice_4_input.txt", "w");

fprintf(ngspice_4_input,"R1 1 2 %f\n", fR1);
fprintf(ngspice_4_input,"R2 2 3 %f\n", fR2);
fprintf(ngspice_4_input,"R3 2 5 %f\n", fR3);
fprintf(ngspice_4_input,"R4 0 5 %f\n", fR4);
fprintf(ngspice_4_input,"R5 5 6 %f\n", fR5);
fprintf(ngspice_4_input,"R6 0 7 %f\n", fR6);

%Fonte de tensão imaginária
fprintf(ngspice_4_input,"Vi 7 im %f\n", 0); 

fprintf(ngspice_4_input,"R7 im 8 %f\n", fR7);
fprintf(ngspice_4_input,"Vs 1 0 SIN(0.0 1.0 1000.0) AC 1.0 0.0\n");
fprintf(ngspice_4_input,"C1 6 8 %f\n", fC);
fprintf(ngspice_4_input,"Gb 6 3 2 5 %f\n", fKb);
fprintf(ngspice_4_input,"Hd 5 8 Vi %f\n", fKd);
fprintf(ngspice_4_input,".ic v(6) = %f v(8) = %f\n", V60, V80);

fclose(ngspice_4_input);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Tables%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


negative_time_tab = fopen("octave_negative_time_tab.tex", "w");

fprintf(negative_time_tab, "$I_1$ & %f \\\\ \\hline", I1);
fprintf(negative_time_tab, "$I_2$ & %f \\\\ \\hline", I2);
fprintf(negative_time_tab, "$I_3$ & %f \\\\ \\hline", I3);
fprintf(negative_time_tab, "$I_4$ & %f \\\\ \\hline", I4);
fprintf(negative_time_tab, "$I_5$ & %f \\\\ \\hline", I5);
fprintf(negative_time_tab, "$I_6$ & %f \\\\ \\hline", I6);
fprintf(negative_time_tab, "$I_7$ & %f \\\\ \\hline", I7);
fprintf(negative_time_tab, "$V_0$ & %f \\\\ \\hline", V4);
fprintf(negative_time_tab, "$V_1$ & %f \\\\ \\hline", V1);
fprintf(negative_time_tab, "$V_2$ & %f \\\\ \\hline", V2);
fprintf(negative_time_tab, "$V_3$ & %f \\\\ \\hline", V3);
fprintf(negative_time_tab, "$V_5$ & %f \\\\ \\hline", V5);
fprintf(negative_time_tab, "$V_6$ & %f \\\\ \\hline", V6);
fprintf(negative_time_tab, "$V_7$ & %f \\\\ \\hline", V7);
fprintf(negative_time_tab, "$V_8$ & %f \\\\ \\hline", V8);

fclose(negative_time_tab);

zero_time_tab = fopen("octave_zero_time_tab.tex", "w");

fprintf(zero_time_tab, "$V_0$ & %f \\\\ \\hline", 0);
fprintf(zero_time_tab, "$V_1$ & %f \\\\ \\hline", 0);
fprintf(zero_time_tab, "$V_2$ & %f \\\\ \\hline", V20);
fprintf(zero_time_tab, "$V_3$ & %f \\\\ \\hline", V30);
fprintf(zero_time_tab, "$V_5$ & %f \\\\ \\hline", V50);
fprintf(zero_time_tab, "$V_6$ & %f \\\\ \\hline", V60);
fprintf(zero_time_tab, "$V_7$ & %f \\\\ \\hline", V70);
fprintf(zero_time_tab, "$V_8$ & %f \\\\ \\hline", V80);
fprintf(zero_time_tab, "$V_x$ & %f \\\\ \\hline", Vx);
fprintf(zero_time_tab, "$I_x$ & %f \\\\ \\hline", Ix);
fprintf(zero_time_tab, "$R_e_q$ & %f \\\\ \\hline", Req);

fclose(zero_time_tab);


complex_tab = fopen("octave_complex_tab.tex", "w");

fprintf(complex_tab, "$A_V_1$ & %f \\\\ \\hline", AV1p);
fprintf(complex_tab, "$A_V_2$ & %f \\\\ \\hline", AV2p);
fprintf(complex_tab, "$A_V_3$ & %f \\\\ \\hline", AV3p);
fprintf(complex_tab, "$A_V_5$ & %f \\\\ \\hline", AV5p);
fprintf(complex_tab, "$A_V_6$ & %f \\\\ \\hline", AV6p);
fprintf(complex_tab, "$A_V_7$ & %f \\\\ \\hline", AV7p);
fprintf(complex_tab, "$A_V_8$ & %f \\\\ \\hline", AV8p);

fclose(complex_tab);

