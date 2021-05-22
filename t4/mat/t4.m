% ---- GAIN STAGE ----

% values
VT=25e-3
BFN=178.7
VAFN=69.7
RE1=100
RC1=1000
RB1=80000
RB2=20000
VBEON=0.7
VCC=12
RS=100

% slide 6
RB=1/(1/RB1+1/RB2)
VEQ=RB2/(RB1+RB2)*VCC % in the slides this expression is equal to -VEQ (switch voltage source terminals)
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE1*IE1
VO1=VCC-RC1*IC1
VCE=VO1-VE1

% slide 7
gm1=IC1/VT
rpi1=BFN/gm1
ro1=VAFN/IC1

% slide 8
AV1 = RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)

AV1simple = gm1*RC1/(1+gm1*RE1)

% slide 12
RE1=0 % why are there two values for RE1 (0 and 100)? and why is there information repeated?
AV1 = RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
% shouldn't it be: AV1 = RB/(RS+RB)*RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RB*RS/(RB+RS)+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)
AV1simple = gm1*RC1/(1+gm1*RE1)

RE1=100

% slide 13
ZI1 = ((ro1+RC1+RE1)*(RB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)
ZX = ro1*((RB+rpi1)*RE1/(RB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RB)+1/RE1+gm1*rpi1/(rpi1+RB)))
ZO1 = 1/(1/ZX+1/RC1)
% in the slides it is ZI1 = 1/(1/RB1+1/RB2+1/rpi1) and ZO1 = 1/(1/RC1+1/ro1)


% slide 12
% vo/vi=Ratio with RE1=0
% we need to know VS!!! ---> Ration as a function of frequency
% Ratio = - gm1 * (RC1*ro1)/(RC1+ro1) * ((RB1*RB2+rpi1*RB2+rpi1*RB1)/(rpi1*RB1*RB2)) / (RS+(RB1*RB2+rpi1*RB2+rpi1*RB1)/(rpi1*RB1*RB2)) * VS







% ---- OUTPUT STAGE ----

% values
BFP = 227.3
VAFP = 37.2
RE2 = 100
VEBON = 0.7

% slide 14
VI2 = VO1 % shouldn't it be VI2 = VO-VEBON ?
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2

% slide 15
gm2 = IC2/VT
go2 = IC2/VAFP
gpi2 = gm2/BFP
ge2 = 1/RE2
% in the slides it is gpi2=1/rpi2, ge1=1/RE2 and go2=1/ro2

AV2 = gm2/(gm2+gpi2+go2+ge2) % it's the ratio vo/vi


% slide 16
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2)
ZO2 = 1/(gm2+gpi2+go2+ge2)


% 8 decades and 10 points per decade => 80 points
k = 80
freq=logspace(1,8, k);

%vmag_plot = figure ();
%semilogx (freq, mag2db(V6f_mag), "r");
%hold on;
%semilogx (freq, mag2db(V1f_mag), "b");
%hold on;
%semilogx (freq, mag2db(Vcf_mag), "g");

%xlabel ("f[Hz]");
%ylabel ("Vo(f)/Vi(f)[dB]"); % is it in dB?
%legenda= legend("Frequency response "); 
%print (vmag_plot, "vmag_plot.eps", "-depsc");






% Point 2 explanation (why both stages can be connected without significant signal loss)

% thanks to a coupling capacitor and a bias circuit

% https://www.audioholics.com/audio-amplifier/amplifier-classes
% Note: there are different types of audio amplifiers

% https://www.youtube.com/watch?v=-fIpj2eHL0k
% In the gain stage we have a NPN transistor (positive part of the signal).
% In the output stage we have a PNP transistor (negative part of the signal).

% https://www.electronics-tutorials.ws/amplifier/amp_1.html
% In the Common Emitter Transistor, for the transistor to operate within its “Active Region” some form of “Base Biasing” was required. This small Base Bias voltage added to the input signal allowed the transistor to reproduce the full input waveform at its output with no loss of signal.

% https://www.allaboutcircuits.com/worksheets/bjt-amplifier-troubleshooting/
% https://www.electronics-tutorials.ws/amplifier/class-ab-amplifier.html
% https://www.pearsonhighered.com/assets/samplechapter/0/1/3/4/0134420101.pdf
% https://wiki.analog.com/university/courses/electronics/text/chapter-10
% https://www.sciencedirect.com/topics/computer-science/amplifier-stage
