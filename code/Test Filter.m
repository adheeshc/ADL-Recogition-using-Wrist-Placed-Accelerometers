Fs = 32;
t = linspace(0,10,270);
y2 = filter(Hd,ax);
plot(t,ax,t,y2)
xlabel('Time (s)')
ylabel('Amplitude')
legend('Original Signal','Filtered Data')