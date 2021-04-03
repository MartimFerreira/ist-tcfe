close all
clear all

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

fclose(data)


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


%%%%%% t = 0
M0 = [(1/fR1) + (1/fR2) + (1/fR3), -(1/fR2), -(1/fR3), 0, 0, 0, 0;
      1/fR2 - fKb, 1/fR2, fKb, 0, 0, 0, 0;
      fKb, 0, -fKb - 1/fR5, 1/fR5, 0, 0, 1;
      0, 0, 0, 0, -1/fR6 - 1/fR7, 1/fR7, 0; 
      0, 0, 1, 0, fKd/fR6, -1, 0; 
      0, 0, 0, 1, 0, -1, 0; 
	      1/fR3, 0, -1/fR3 - 1/fR4 - 1/fR5, 1/fR5, 1/fR7, -1/fR7, 0;];


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%alinea4

Vsp= 1; 
f=1000; 
w= 2*pi*f;
Zc = 1/(j*w*fC); 


Mp = [ 1, 0, 0, 0, 0, 0, 0;                                                           %no1
      -(1/fR1), (1/fR1) + (1/fR2) + (1/fR3), -(1/fR2),0,  -(1/fR3), 0, 0;             %no2
      0, -(1/fR2) - fKb, (1/fR2), 0, fKb, 0, 0;                                       %no3
      0, fKb, 0,-fKb - (1/fR5), (1/fR5)+(1/Zc), 0,-(1/Zc);                            %no6
      0, 0, 0, 0, 0, -(1/fR6) - (1/fR7), (1/fR7);                                     %no7 
      0, 0, 0, 1, 0, fKd/fR6, -1;                                                     %no8
	0, (1/fR3), 0,-(1/fR3)-(1/fR4)-(1/fR5),(1/fR5)-(1/Zc),(1/fR7),-(1/fR7)+(1/Zc);]; %supernode

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%alinea5

t=0:1e-6:20e-3;

ct=exp(j*w*t); 

V1s= imag(ct*V1p); 
V2s= imag(ct*V2p);
V3s= imag(ct*V3p);
V5s= imag(ct*V5p);
V6s= imag(ct*V6p);
V7s= imag(ct*V7p);
V8s= imag(ct*V8p);

vfinal_plot = figure ();
plot (t*1000, V6s, "g");
hold on;
plot (t*1000, V1s, "b");

xlabel ("t[ms]");
ylabel ("v6(t), vs(t) [V]");
print (vfinal_plot, "vfinal_plot.eps", "-depsc");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
fprintf(ngspice_1_input,"Vs 0 1 %f\n", fVs);
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
fprintf(ngspice_2_input,"Vx 6 8 %f\n", V6-V8);
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
fprintf(ngspice_3_input,".ic v(6) = %f v(8) = %f\n", V6, V8);

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
fprintf(ngspice_4_input,".ic v(6) = %f v(8) = %f\n", V6, V8);

fclose(ngspice_4_input);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





 
