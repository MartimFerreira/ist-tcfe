close all
clear all

%%EXAMPLE SYMBOLIC COMPUTATIONS

pkg load symbolic

printf("Dados:\n")
R1 = 1039.30068064
R2 = 2010.9087471
R3 = 3041.24242148 
R4 = 4183.83562625
R5 = 3095.83437009
R6 = 2021.17084711
R7 = 1022.26630661
Va = 5.17979967502
Id = 0.00100439545365 
Kb = 0.00708750963899 
Kc = 8185.75062147
%Vb; not known
%Vc; not known
%Ib; not known
%Ic; not known

%Mesh Currents
%I1; not known
%I2; not known
%I3; not known
%I4; not known

%mesh analysis

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
      I3 = Vbteste/R3;
SomaIno4 = I3 + I5 + Ic-Id - (Ic-I1);
SomaIno0 = I1 -Ic + Ic - I1;
SomaIno2 = Ibteste - I1 - I3;


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
