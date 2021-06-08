%Componentes


R1=10e3;
R2=5e2;

R3=100e3;
R4=1e3;


R2tab=1e3;
R5tab=1e3;

R8=10e3;

C1=220e-9;
C2=110e-9;

C2tab=220e-9;
C3tab=220e-9;



R1
R1eq=(R1*R8/(R1+R8))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Exercicio 1 


f=1000;

w=2*pi*f;

ZC1=1/(j*w*C1);
ZC2=1/(j*w*C2)



fl=1/(R1eq*C1*2*pi)
fh=1/(R2*C2*2*pi)
fo=sqrt(fh*fl)





Zi=abs(ZC1+R1eq)
Zo=abs(1/(1/R2+1/ZC2))

Vl=R1eq/(R1eq+ZC1)
A=(1+R3/R4)*Vl
hpass=abs(ZC2/(ZC2+R2))
gain=abs(ZC2/(ZC2+R2)*A)
gain_db=20*log10(gain)


gain_dev=gain_db-40;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Exercicio2
t=1:0.1:8;



w=2*pi*power(10,t);

ZC1=1./(j*w*C1);
ZC2=1./(j*w*C2);



Vl=R1eq./(R1eq+ZC1);
A=(1+R3/R4).*Vl;
fgain_freq=abs(ZC2./(ZC2+R2).*A);
fgain_db_freq=20*log10(fgain_freq);

max_gain=max(fgain_db_freq)

aux=1



freq = figure();
plot (t, fgain_db_freq, "m");
legend("Gain");
xlabel ("log_{10}(f) [Hz]");
ylabel ("dB");
print (freq, "freq.eps", "-depsc");






% ---- Tabela com as constantes do circuito ----

components_tab = fopen("components_tab.tex", "w");

fprintf(components_tab, "$C_1\\;(F)$ & %.6e\\\\ \\hline\n", C1);
fprintf(components_tab, "$C_2\\;(F)$ & %.6e\\\\ \\hline\n", C2tab);
fprintf(components_tab, "$C_3\\;(F)$ & %.6e\\\\ \\hline\n", C3tab);
fprintf(components_tab, "$R_1\\;(\\Omega)$ & %.6e\\\\ \\hline\n", R1);
fprintf(components_tab, "$R_2\\;(\\Omega)$ & %.6e\\\\ \\hline\n", R2tab);
fprintf(components_tab, "$R_3\\;(\\Omega)$ & %.6e\\\\ \\hline\n", R3);
fprintf(components_tab, "$R_4\\;(\\Omega)$ & %.6e\\\\ \\hline\n", R4);
fprintf(components_tab, "$R_5\\;(\\Omega)$ & %.6e\\\\ \\hline\n", R5tab);
fprintf(components_tab, "$R_6\\;(\\Omega)$ & %.6e\\\\ \\hline\n", R8);


fclose(components_tab);



results_tab = fopen("results_tab.tex", "w");

fprintf(results_tab, "$Z_{in}\\;(\\Omega)$ & %.6e\\\\ \\hline\n", Zi);
fprintf(results_tab, "$Z_{out}\\;(\\Omega)$ & %.6e\\\\ \\hline\n", Zo);
fprintf(results_tab, "$Gain$ & %.6e\\\\ \\hline\n", gain);
fprintf(results_tab, "$f_{low \ cut \ off}\\;(Hz)$ & %.6e\\\\ \\hline\n", fl);
fprintf(results_tab, "$f_{high\ cut \ off}\\;(Hz)$ & %.6e\\\\ \\hline\n", fh);
fprintf(results_tab, "$f_{central}\\;(Hz)$ & %.6e\\\\ \\hline\n", fo);


fclose(results_tab);
