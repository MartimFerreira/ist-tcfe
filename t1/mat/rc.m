close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

printf("Dados:\n");
R1 = 1039.30068064;
R2 = 2010.9087471;
R3 = 3041.24242148; 
R4 = 4183.83562625;
R5 = 3095.83437009;
R6 = 2021.17084711;
R7 = 1022.26630661;
Va = 5.17979967502;
Id = 0.00100439545365; 
Kb = 0.00708750963899;
Kc = 8185.75062147;


%Node Analysis results:
%V1; 
%V2; 
%V3; 
%V4; 
%V5;
%V6; 
%V7; 

%Mesh Analysis results:
%Vb; 
%Vc; 
%Ib; 
%Ic; 
%I1;
%I2; 
%I3; 
%I4; 

%Mesh Analysis Equations

%  R6*I3 + R7*I3 - Vc + R4*(I3-I1) == 0;
%  Va - R4*(I3-I1) - Vb + R1*I1 == 0;
%  Vc == Kc*Ic;
%  Ib == Kb*Vb;
%  I3 == Ic;
%  I4 == Id;
%  (I2-I1)*R3 == Vb;
%  I2 == Ib;

M = [0, -1, 0, 0, -R4, 0, R4+R6+R7, 0;
      -1, 0, 0, 0, R1+R4, 0, -R4, 0;
      0, 1, 0, -Kc, 0, 0, 0, 0;
      -Kb, 0, 1, 0, 0, 0, 0, 0;
      0, 0, 0, 1, 0, 0, -1, 0;
      0, 0, 0, 0, 0, 0, 0, 1;
      -1, 0, 0, 0, -R3, R3, 0, 0;
      0, 0, -1, 0, 0, 1, 0, 0];
b = [0; -Va; 0; 0; 0; Id; 0; 0];

x = M \ b;

Vb = x(1);
    Vc = x(2);
    Ib = x(3);
    Ic = x(4);
    I1 = x(5);
    I2 = x(6);
    I3 = x(7);
    I4 = x(8);

%Testes

V0 = 0;
V1 = Va + V0;
V6 = V0 - R6 * Ic;
V7 = V6 - R7 * Ic;
V4 = V7 + Kc*Ic;
I1teste = Ic - (V4 - V0)/R4;
V2 = V1 + I1teste*R1;
Vbteste = V2 - V4;
Ibteste = Kb*Vbteste;
I5 = Id - Ibteste;
V5 = V4 + I5*R5;
V3 = V2 + Ib*R2;
%I3 = Vbteste/R3;
SomaIno4 = -I1+Ibteste + I5 + Ic-Id - (Ic-I1);
SomaIno0 = I1 -Ic + Ic - I1;
SomaIno2 = Ibteste - I1 - I2+I1;
 

printf("\nResultados:\n")
printf ("V0 = %f\n", V0)
printf ("V1 = %f\n", V1)
printf ("V2 = %f\n", V2)
printf ("V3 = %f\n", V3)
printf ("V4 = %f\n", V4)
printf ("V5 = %f\n", V5)
printf ("V6 = %f\n", V6)
printf ("V7 = %f\n", V7)

printf ("\nIb = %f\n", Ib)
printf ("Ic = %f\n", Ic)

printf ("\nImalha1 = %f\n", I1)
printf ("Imalha2 = %f\n", I2)
printf ("Imalha3 = %f\n", I3)
printf ("Imalha4 = %f\n", I4)

printf ("\nVb = %f\n", Vb) 
printf ("Vc = %f\n", Vc)

printf("\nTestes:\n")
printf("Soma I no no4 = %f\n", SomaIno4)
printf("Soma I no no0 = %f\n", SomaIno0)
printf("Soma I no no2 = %f\n", SomaIno2)


%node analysis

%  (V2-V1)/R1 +(V2-V4)/R3 -(V3-V2)/R2 == 0; (node 2)
%  (V3-V2)/R2 - (v2-v4)*Kb == 0;            (node 3)
%  (V0-V6)/R6 -(V6-V7)/R7  == 0;            (node 6)
%  (V5-V4)/R5 + Kb(V2-V4)*Kb ==0;           (node 5)
%  (V4-V7) - Kc(V0-V6)/R6 ==0;              (super node)
%  (V2-V4)/R3 +(V5-V4)/R5 -(V6-V7)/R7 -(V4-V0)/R4== 0; (node 4)
%  V1-V0 == Va;
%  V0 == 0;

Mn = [ 1, 0, 0, 0, 0, 0, 0;
       -(1/R1), (1/R1) + (1/R2) + (1/R3), -(1/R2), -(1/R3), 0, 0, 0;
       0, -(1/R2) - Kb, (1/R2), Kb, 0, 0, 0;
       0, 0, 0, 0, 0, -(1/R6) - (1/R7), 1/R7;
       0, Kb, 0, -Kb - (1/R5), (1/R5), 0, 0;
       0, 0, 0, 1, 0, (Kc/R6), -1;
       0, (1/R3), 0, -(1/R3) - (1/R4) - (1/R5), (1/R5), (1/R7), -(1/R7)];
bn = [Va; 0; 0; 0; Id; 0; Id];

xn = Mn \ bn;

V0n= 0; 
V1n = xn(1);
V2n = xn(2);
V3n = xn(3);
V4n = xn(4);
V5n= xn(5);
V6n= xn(6);
V7n= xn(7);

    %Testes2

ImalhaA= (V2n-V1n)/R1; 
ImalhaB= (V3n-V2n)/R2;
ImalhaC= -(V7n-V6n)/R7;
ImalhaD= -(V4n-V5n)/R5 +ImalhaB;

Itorco12= (V2n-V1n)/R1 
Itorco23= (V3n-V2n)/R2
Itorco24= (V4n-V2n)/R3
Itorco45= (V4n-V5n)/R5 
Itorco67= (V6n-V7n)/R7 
Itorco06= (V0n-V6n)/R6



SomaVmalhaA=(V4n-V0n)+(V2n-V4n)+(V1n-V2n)+(V0n-V1n); 
SomaVmalhaB=(V3n-V5n)+(V2n-V3n)+(V4n-V2n)+(V5n-V4n); 
SomaVmalhaC=(V6n-V0n)+(V7n-V6n)+(V4n-V7n)+(V0n-V4n); 
SomaVmalhaD=(V5n-V7n)+(V4n-V5n)+(V7n-V4n);



printf("\nResultados nós:\n")
printf ("V0n = %f\n", V0n)
printf ("V1n = %f\n", V1n)
printf ("V2n = %f\n", V2n)
printf ("V3n = %f\n", V3n)
printf ("V4n = %f\n", V4n)
printf ("V5n = %f\n", V5n)
printf ("V6n = %f\n", V6n)
printf ("V7n = %f\n", V7n)


printf("\nTestes 2:\n")
printf("Soma V malha A = %f\n", SomaVmalhaA)
printf("Soma V malha B= %f\n", SomaVmalhaB)
printf("Soma V malha C= %f\n", SomaVmalhaC)
printf("Soma V malha D = %f\n", SomaVmalhaD)


printf("\n I malha A teste = %f\n", ImalhaA)
printf(" I malha B teste = %f\n", ImalhaB)
printf(" I malha C teste = %f\n", ImalhaC)
printf(" I malha D teste = %f\n", ImalhaD)

printf ("\nImalhaA = %f\n", I1)
printf ("ImalhaB = %f\n", I2)
printf ("ImalhaC = %f\n", I3)
printf ("ImalhaD = %f\n", I4)


printf("\nCorrentes - através dos potenciais dos nós:\n")
printf ("\nItorco12 = %f\n", Itorco12)
printf ("Itorco23 = %f\n", Itorco23)
printf ("Itorco24 = %f\n", Itorco24)
printf ("Itorco24_c = %f\n", (I1-I2))
printf ("Itorco45_c = %f\n", (I2-I4))
printf ("Itorco45= %f\n", Itorco45)
printf ("Itorco67= %f\n", Itorco67)
printf ("Itorco06= %f\n", Itorco06)

printf("\n Potenciais - através das correntes nas malhas:\n")
printf ("V0 = %f\n", V0)
printf ("V1 = %f\n", V1)
printf ("V2 = %f\n", V2)
printf ("V3 = %f\n", V3)
printf ("V4 = %f\n", V4)
printf ("V5 = %f\n", V5)
printf ("V6 = %f\n", V6)
printf ("V7 = %f\n", V7)

%Write Tables

node_tab = fopen("octave_node_tab.tex", "w");

fprintf(node_tab, "$V_0$ & %f \\\\ \\hline", V0n);
fprintf(node_tab, "$V_1$ & %f \\\\ \\hline", V1n);
fprintf(node_tab, "$V_2$ & %f \\\\ \\hline", V2n);
fprintf(node_tab, "$V_3$ & %f \\\\ \\hline", V3n);
fprintf(node_tab, "$V_4$ & %f \\\\ \\hline", V4n);
fprintf(node_tab, "$V_5$ & %f \\\\ \\hline", V5n);
fprintf(node_tab, "$V_6$ & %f \\\\ \\hline", V6n);
fprintf(node_tab, "$V_7$ & %f \\\\ \\hline", V7n);

fclose(node_tab);


mesh_tab = fopen("octave_mesh_tab.tex", "w");

fprintf(mesh_tab, "$I_A$ & %f \\\\ \\hline", I1);
fprintf(mesh_tab, "$I_B$ & %f \\\\ \\hline", I2);
fprintf(mesh_tab, "$I_C$ & %f \\\\ \\hline", I3);
fprintf(mesh_tab, "$I_D$ & %f \\\\ \\hline", I4);

fclose(mesh_tab)

comp_tab = fopen("octave_comparison_tab.tex", "w");

fprintf(comp_tab, "$I_A$ & %f & %f  \\\\ \\hline", I1, ImalhaA);
fprintf(comp_tab, "$I_B$ & %f & %f \\\\ \\hline", I2, ImalhaB);
fprintf(comp_tab, "$I_C$ & %f & %f \\\\ \\hline", I3, ImalhaC);
fprintf(comp_tab, "$I_D$ & %f & %f \\\\ \\hline", I4, ImalhaD);

fclose(comp_tab)
