pkg load control


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


Zi=(ZC1+R1eq)
Zireal=real(Zi)
Ziimag=imag(Zi)
Zo=(1/(1/R2+1/ZC2))
Zoreal=real(Zo)
Zoimag=imag(Zo)


Vl=R1eq/(R1eq+ZC1)
A=(1+R3/R4)*Vl
hpass=abs(ZC2/(ZC2+R2))
gain=abs(ZC2/(ZC2+R2)*A)
phase_1=arg(ZC2/(ZC2+R2)*A)
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
fgain_phase_rad=arg(ZC2./(ZC2+R2).*A);
fgain_phase= rad2deg(fgain_phase_rad);
fgain_db_freq=20*log10(fgain_freq);

max_gain=max(fgain_db_freq)





freq = figure();
plot (t, fgain_db_freq, "m");
legend("Gain");
xlabel ("log_{10}(f) [Hz]");
ylabel ("dB");
print (freq, "freq.eps", "-depsc");


angle = figure();
plot (t, fgain_phase, "b");
legend("Phase");
xlabel ("log_{10}(f) [Hz]");
ylabel ("[Degree]");
print (angle, "angle.eps", "-depsc");







% ---- Tabela com as constantes do circuito ----

components_tab = fopen("components_tab.tex", "w");

fprintf(components_tab, "$C_1\\;(nF)$ & %.0f\\\\ \\hline\n", C1*10^9);
fprintf(components_tab, "$C_2\\;(nF)$ & %.0f\\\\ \\hline\n", C2tab*10^9);
fprintf(components_tab, "$C_3\\;(nF)$ & %.0f\\\\ \\hline\n", C3tab*10^9);
fprintf(components_tab, "$R_1\\;(k\\Omega)$ & %.0f\\\\ \\hline\n", R1/1000);
fprintf(components_tab, "$R_2\\;(k\\Omega)$ & %.0f\\\\ \\hline\n", R2tab/1000);
fprintf(components_tab, "$R_3\\;(k\\Omega)$ & %.0f\\\\ \\hline\n", R3/1000);
fprintf(components_tab, "$R_4\\;(k\\Omega)$ & %.0f\\\\ \\hline\n", R4/1000);
fprintf(components_tab, "$R_5\\;(k\\Omega)$ & %.0f\\\\ \\hline\n", R5tab/1000);
fprintf(components_tab, "$R_6\\;(k\\Omega)$ & %.0f\\\\ \\hline\n", R8/1000);


fclose(components_tab);



results_tab = fopen("results_tab.tex", "w");

fprintf(results_tab, "$Z_{in}\\;(K\\Omega)$ & %.6e %.6e i\\\\ \\hline\n", Zireal/1000, Ziimag/1000);
fprintf(results_tab, "$Z_{out}\\;(K\\Omega)$ & %.6e  %.6e i\\\\ \\hline\n", Zoreal/1000, Zoimag/1000);
fprintf(results_tab, "$Gain$ & %.6e\\\\ \\hline\n", gain);
fprintf(results_tab, "$f_{low \\ cut \\ off}\\;(Hz)$ & %.6e\\\\ \\hline\n", fl);
fprintf(results_tab, "$f_{high\\ cut \\ off}\\;(Hz)$ & %.6e\\\\ \\hline\n", fh);
fprintf(results_tab, "$f_{central}\\;(Hz)$ & %.6e\\\\ \\hline\n", fo);


fclose(results_tab);
