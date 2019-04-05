%Programs for extracting sample frames from a interlaced sequence in YCbCr color coordinate, 
%down-sample Y to get progressive frames
%Convert YCbCr to YIQ
%covert to raster format for each component, perform multiplexing of I and Q using QAM
%multiplex  Y and QAM to get composite video
%demultiplexing using filtering and demodulation
%show both raster waveform and images and spectrum
%Assume the sequence is in MPEG420 format (704*480 Y pixels, 352*240 Cr/Cb pixels), saved in YUV format
%YUV format: save Y frame (480x704) first, followed by Cb (240x352), then Cr (240x352)
%Author:  Yao Wang 9/10/03


%FID = fopen('mobilcal_mpeg420_frame5_8.YUV','r');
FID = fopen('mobilcal58.YUV','r');
%This sequence contains 4 frames of the sequence only

%read 1 frame
[tempY,count]=fread(FID,[704,480*3/2],'uint8');

%extract Y component
tempY=tempY';
tempY1(1:480,:)=tempY(1:480,:);

%downsample tempY1 to be the same size as Cb and Cr
Yframe1=zeros(240,352);
Yframe1=(tempY1(1:2:480,1:2:704)+tempY1(1:2:480,2:2:704))/2;
%use averaging over the same line, but not across the lines because adjacent lines
%are from different fields.

%display frame1 Y
figure
imshow(uint8(Yframe1));
%imwrite(uint8(Yframe),'mobile_frame1_Y.jpg','JPG');

%extract Cb and Cr components
Cbframe1=zeros(240,352);
Cbframe1(1:2:240,1:352)=tempY(481:600,1:352);
Cbframe1(2:2:240,1:352)=tempY(481:600,353:704);
figure
imshow(uint8(Cbframe1));
%imwrite(uint8(Cbframe1),'mobile_frame1_Cb.jpg','JPG');
Crframe1=zeros(240,352);
Crframe1(1:2:240,1:352)=tempY(601:720,1:352);
Crframe1(2:2:240,1:352)=tempY(601:720,353:704);
figure
imshow(uint8(Crframe1));
%imwrite(uint8(Crframe1),'mobile_frame1_Cr.jpg','JPG');

%convert to RGB color coordinate
Yframe1=Yframe1-16;
Cbframe1=Cbframe1-128;
Crframe1=Crframe1-128;
Rframe=1.164*Yframe1+1.596*Crframe1;
Gframe=1.164*Yframe1-0.392*Cbframe1-0.813*Crframe1;
Bframe=1.164*Yframe1+2.017*Cbframe1;

rgbimage=zeros(240,352,3);
rgbimage(:,:,1)=Rframe;
rgbimage(:,:,2)=Gframe;
rgbimage(:,:,3)=Bframe;
figure;
imshow(uint8(rgbimage));
%imwrite(uint8(rgbimage),'mobile_frame1_RGB.jpg','JPG');

close all;

%convert RGB to YIQ
Yframe1=0.299*Rframe+0.587*Gframe+0.114*Bframe;
Iframe1=0.596*Rframe-0.275*Gframe-0.321*Bframe;
Qframe1=0.212*Rframe-0.523*Gframe+0.311*Bframe;

%convert Cb and Cr to I and Q
%cos(33^o)/1.14=0.8387/1.14=0.7357, sin(33^o)/2.03=0.5446/2.03=0.2683
%sin(33^o)/1.14=0.5446/1.14=0.4777, cos(33^o)/2.03=0.8387/2.03=0.4132
%Iframe1=0.7357*Crframe1-0.2683*Cbframe1;
%Qframe1=0.4777*Crframe1+0.4132*Cbframe1;
%This conversion did not work as well

figure
imshow(uint8(Yframe1));
%imwrite(uint8(Yframe1),'mobile_frame1_YCbCr2RGB2Y.jpg','JPG');
figure
imshow(uint8(Iframe1+128));
%imwrite(uint8(Iframe1+128),'mobile_frame1_I.jpg','JPG');
figure
imshow(uint8(Qframe1+128));
%imwrite(uint8(Qframe1+128),'mobile_frame1_Q.jpg','JPG');

close all;

%read next frame
[tempY_next,count]=fread(FID,[704,480*3/2],'uint8');

tempY_next=tempY_next';
tempY2(1:480,:)=tempY_next(1:480,:);
Yframe2(1:240,1:352)=(tempY2(1:2:480,1:2:704)+tempY2(1:2:480,2:2:704))/2;
figure
imshow(uint8(Yframe2));
Cbframe2=zeros(240,352);
Cbframe2(1:2:240,1:352)=tempY_next(481:600,1:352);
Cbframe2(2:2:240,1:352)=tempY_next(481:600,353:704);
figure
imshow(uint8(Cbframe2));
Crframe2=zeros(240,352);
Crframe2(1:2:240,1:352)=tempY_next(601:720,1:352);
Crframe2(2:2:240,1:352)=tempY_next(601:720,353:704);
figure
imshow(uint8(Crframe2));

Yframe2=Yframe2-16;
Cbframe2=Cbframe2-128;
Crframe2=Crframe2-128;

Rframe=1.164*Yframe2+1.596*Crframe2;
Gframe=1.164*Yframe2-0.392*Cbframe2-0.813*Crframe2;
Bframe=1.164*Yframe2+2.017*Cbframe2;

rgbimage=zeros(240,352,3);
rgbimage(:,:,1)=Rframe;
rgbimage(:,:,2)=Gframe;
rgbimage(:,:,3)=Bframe;
figure;
imshow(uint8(rgbimage));
%imwrite(uint8(rgbimage),'mobile_frame1_RGB.jpg','JPG');

close all;

%convert RGB to YIQ
Yframe2=0.299*Rframe+0.587*Gframe+0.114*Bframe;
Iframe2=0.596*Rframe-0.275*Gframe-0.321*Bframe;
Qframe2=0.212*Rframe-0.523*Gframe+0.311*Bframe;


figure
imshow(uint8(Yframe2));
figure
imshow(uint8(Iframe2+128));
figure
imshow(uint8(Qframe2+128));

pause;
close all;

%convert the frame data to a 1D vector (raster)
Y_vector1=im2col(Yframe1',[1,1],'distinct');
I_vector1=im2col(Iframe1',[1,1],'distinct');
Q_vector1=im2col(Qframe1',[1,1],'distinct');
%convert the frame data to a 1D vector (raster)
Y_vector2=im2col(Yframe2',[1,1],'distinct');
I_vector2=im2col(Iframe2',[1,1],'distinct');
Q_vector2=im2col(Qframe2',[1,1],'distinct');


%This vector contain raster data from 2 frames
Y_vector=[Y_vector1,Y_vector2];
I_vector=[I_vector1,I_vector2];
Q_vector=[Q_vector1,Q_vector2];
fclose(FID);

%plot the raster waveform for first 5 lines

figure;
Fs=30*352*240; %sampling rate
subplot(1,3,1),plot([0:1/Fs:352*5/Fs-1/Fs],Y_vector(1:352*5));
ylabel('Gray Level');
xlabel('Time');
title('Y Waveform')
axis ([0,7E-4,0,256]);
subplot(1,3,2),plot([0:1/Fs:352*5/Fs-1/Fs],I_vector(1:352*5));
ylabel('Gray Level');
xlabel('Time');
title('I Waveform')
axis ([0,7E-4,-128,128]);
subplot(1,3,3),plot([0:1/Fs:352*5/Fs-1/Fs],Q_vector(1:352*5));
ylabel('Gray Level');
xlabel('Time');
title('Q Waveform')
axis ([0,7E-4,-128,128]);

%compute and plot the spectrum
figure;
%using FFT window size of 10 lines to compute the spectrum
%when using 1 line only, does not show the periodic structure
%when using 20 lines, not enough averaging, more noisy then 10 lines
[YP,F]=spectrum(Y_vector,352*10,0,hanning(352*10),Fs);
subplot(1,3,1);semilogy(F,YP(:,1));
axis ([0,13E5,1E-1,1E6]);
title('Y Spectrum')
[IP,F]=spectrum(I_vector,352*10,0,hanning(352*10),Fs);
subplot(1,3,2);semilogy(F,IP(:,1));
axis ([0,13E5,1E-1,1E6]);
title('I Spectrum')
[QP,F]=spectrum(Q_vector,352*10,0,hanning(352*10),Fs);
subplot(1,3,3);semilogy(F,QP(:,1));
axis ([0,13E5,1E-1,1E6]);
title('Q Spectrum')

pause;
close all;

%QAM multiplexing of I and Q
%maximum Y frequency  fy=30*240*352/2*0.7=0.887 MHz
%choose carrier frequency fc=30*240/2*225=0.81 MHz
%there are 112.5 cyles per line

%sampling interval=1/30*352*240
%digital frequency =fc*sampling_interval=0.3196
%2*pi*fc*sampling_interval=2.0081

fc=30*240/2*225;
fcd=fc/Fs; %digital frequency (1/Fs is sampling interval)
w=2*pi*fcd;
n=0:1:352*240*2-1;
wn=w*n;
QAM=zeros(1,352*240*2);
%implementing QAM modulation
QAM=I_vector.*cos(wn)+Q_vector.*sin(wn);

%plot waveforms of I, Q, and QAM I+Q
subplot(1,3,1),plot([0:1/Fs:352*1/Fs-1/Fs],I_vector(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('I Waveform')
axis ([0,1.5E-4,-80,80]);
subplot(1,3,2),plot([0:1/Fs:352*1/Fs-1/Fs],Q_vector(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('Q Waveform')
axis ([0,1.5E-4,-80,80]);

subplot(1,3,3),plot([0:1/Fs:352*1/Fs-1/Fs],QAM(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('QAM multiplexed I & Q')
axis ([0,1.5E-4,-80,80]);

%plot spectrum of I, Q, and QAM I+Q
figure;
subplot(1,3,1);semilogy(F,IP(:,1));
axis ([0,13E5,1E-1,1E6]);
title('I Spectrum');
subplot(1,3,2);semilogy(F,QP(:,1));
axis ([0,13E5,1E-1,1E6]);
title('Q Spectrum')
[QAMP,F]=spectrum(QAM,352*10,0,hanning(352*10),Fs);
subplot(1,3,3);semilogy(F,QAMP(:,1));
axis ([0,13E5,1E-1,1E6]);
title('QAM I+Q Spectrum')


%multiplex Y and QAM
video=Y_vector+QAM;

%plot waveform
figure;
subplot(1,2,1),plot([0:1/Fs:352*1/Fs-1/Fs],Y_vector(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('Y Waveform')
subplot(1,2,2),plot([0:1/Fs:352*1/Fs-1/Fs],video(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('Composite Waveform')

%plot spectrum
figure;
subplot(1,2,1);semilogy(F,YP(:,1));
axis ([0,13E5,1E2,1E6]);
title('Y Spectrum')
[videoP,F]=spectrum(video,352*10,0,hanning(352*10),Fs);
subplot(1,2,2);semilogy(F,videoP(:,1));
axis ([0,13E5,1E2,1E6]);
title('Composite Video Spectrum')

%detailed view
figure;
subplot(1,2,1);semilogy(F,videoP(:,1));
axis([0,30*240*25,1E2,1E6])
title('Composite Spectrum (beginning)');

subplot(1,2,2);semilogy(F,videoP(:,1));
axis([30*240*200/2,30*240*250/2,1E2,1E6])
title('Composite Spectrum (near f_c)');

pause;
close all;

%view composite video as a monochrome signl
Yframe1_nofilt=col2im(video(1:352*240),[1 1],[352 240])';
figure;
imshow(uint8(Yframe1_nofilt));
title('Image seen by B/W TV without filtering');
%imwrite(uint8(Yframe1_nofilt),'mobile_frame1_Y_nofilt.jpg','JPG');

%filter the composite signal with low pass filter

%filter design
%cut-off frequency f_LPF=30*240/2*180=0.648
%with NTSC f_LPF=3,fc=3.58, f_LPF/fc=0.8380
%with our choice f_LPF=0.648,fc=0.81, f_LPF/fc=0.8025
f_LPF=30*240/2*150; 
%chose this number to realize response at f=0.648=-25dB,at 0.81=-50dB
fir_length=20;
LPF=fir1(fir_length,f_LPF/(Fs/2));
figure;
plot(LPF);
figure;
freqz(LPF,1,256,Fs);

%filter the data

video_LPF_shift=conv(video,LPF);
video_LPF=video_LPF_shift(11:352*240*2+10);
%view composite video as a monochrome signl
video2Y_frame=col2im(video_LPF(1:352*240),[1 1],[352 240])';
figure;
imshow(uint8(video2Y_frame));
title('Image seen by B/W TV with filtering');
%imwrite(uint8(video2Y_frame),'mobile_frame1_recovered_Y_filt.jpg','JPG');

%plot spectrum
figure;
subplot(1,2,1);semilogy(F,YP(:,1));
axis ([0,13E5,1E2,1E6]);
title('Y Spectrum')
[videoLPFP,F]=spectrum(video_LPF,352*10,0,hanning(352*10),Fs);
subplot(1,2,2);semilogy(F,videoLPFP(:,1));
axis ([0,13E5,1E2,1E6]);
title('Extracted Y Spectrum')

%plot waveform
figure;
subplot(1,3,1),plot([0:1/Fs:352*1/Fs-1/Fs],Y_vector(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('Y Waveform');axis([0,1.5E-4,0,256]);
subplot(1,3,2),plot([0:1/Fs:352*1/Fs-1/Fs],video(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('Composite Waveform');axis([0,1.5E-4,0,256]);
subplot(1,3,3),plot([0:1/Fs:352*1/Fs-1/Fs],video_LPF(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('Y from Composite using LPF');axis([0,1.5E-4,0,256]);

close all;

%extract QAM I and Q
video2QAM=video-video_LPF;

%plot spectrum
figure;
subplot(1,2,1);semilogy(F,QAMP(:,1));
axis ([0,13E5,1E2,1E6]);
title('QAM Spectrum')
[video2QAMP,F]=spectrum(video2QAM,352*10,0,hanning(352*10),Fs);
subplot(1,2,2);semilogy(F,video2QAMP(:,1));
axis ([0,13E5,1E2,1E6]);
title('Extracted QAM Spectrum')


%plot waveform
figure;
subplot(1,2,1),plot([0:1/Fs:352*1/Fs-1/Fs],QAM(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('QAM Waveform');axis([0,1.5E-4,-80,80]);
subplot(1,2,2),plot([0:1/Fs:352*1/Fs-1/Fs],video2QAM(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('Demultiplexed QAM');axis([0,1.5E-4,-80,80]);

close all;
%QAM demodulation

QAM2I_noflt=video2QAM.*cos(wn)*2;
QAM2Q_noflt=video2QAM.*sin(wn)*2;

close all;
%filter design
%cut-off frequency f_LPF=0.25MHz
%with NTSC f_LPF=3,fc=3.58, f_LPF/fc=0.8380
%with our choice f_LPF=0.648,fc=0.81, f_LPF/fc=0.8025
f_LPF=0.2E6; 

fir_length=20;
LPF=fir1(fir_length,f_LPF/(Fs/2));
figure;
plot(LPF);
figure;
freqz(LPF,1,256,Fs);


%filter the data

QAM2I_shift=conv(QAM2I_noflt,LPF);
QAM2I=QAM2I_shift(11:352*240*2+10);
figure;
subplot(1,3,1),plot([0:1/Fs:352*1/Fs-1/Fs],I_vector(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('Original I');axis([0,1.5E-4,-80,80]);
subplot(1,3,2),plot([0:1/Fs:352*1/Fs-1/Fs],QAM2I_noflt(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('Demodulated I');axis([0,1.5E-4,-80,80]);
subplot(1,3,3),plot([0:1/Fs:352*1/Fs-1/Fs],QAM2I(1:352*1));
ylabel('Gray Level');
xlabel('Time');
title('Demodulation+LPF I');axis([0,1.5E-4,-80,80]);

%view extracted I as a monochrome signl
QAM2I_frame=col2im(QAM2I(1:352*240),[1 1],[352 240])';
%imwrite(uint8(Yframe1_nofilt),'mobile_frame1_Y_nofilt.jpg','JPG');

QAM2Q_shift=conv(QAM2Q_noflt,LPF);
QAM2Q=QAM2Q_shift(11:352*240*2+10);
%view extracted I as a monochrome signl
QAM2Q_frame=col2im(QAM2Q(1:352*240),[1 1],[352 240])';
%imwrite(uint8(Yframe1_nofilt),'mobile_frame1_Y_nofilt.jpg','JPG');


figure;
subplot(2,2,1);imagesc(Iframe1);title('original I');colormap(gray);
subplot(2,2,2);imagesc(Qframe1);title('original Q');
subplot(2,2,3);imagesc(QAM2I_frame);title('Recovered I');
subplot(2,2,4);imagesc(QAM2Q_frame);title('Recovered Q');
figure;
subplot(1,3,1);semilogy(F,IP(:,1));
axis ([0,13E5,1E2,1E6]);
title('I Spectrum')
[QAM2I_nofltP,F]=spectrum(QAM2I_noflt,352*10,0,hanning(352*10),Fs);
subplot(1,3,2);semilogy(F,QAM2I_nofltP(:,1));
axis ([0,13E5,1E2,1E6]);
title('Extracted I Spectrum w/o LPF')
[QAM2IP,F]=spectrum(QAM2I,352*10,0,hanning(352*10),Fs);
subplot(1,3,3);semilogy(F,QAM2IP(:,1));
axis ([0,13E5,1E2,1E6]);
title('Extracted I Spectrum after LPF')

%convert to RGB to display in color

Rframe=video2Y_frame+0.956*QAM2I_frame+0.620*QAM2Q_frame;
Gframe=video2Y_frame-0.272*QAM2I_frame-0.647*QAM2Q_frame;
Bframe=video2Y_frame-1.108*QAM2I_frame+1.7*QAM2Q_frame;

rgbimage=zeros(240,352,3);
rgbimage(:,:,1)=Rframe;
rgbimage(:,:,2)=Gframe;
rgbimage(:,:,3)=Bframe;
figure;
imshow(uint8(rgbimage));
title('Recovered color frame');
%imwrite(uint8(rgbimage),'mobile_frame1_RGB_recovered.jpg','JPG');

%show original RGB color image
Rframe=Yframe1+0.956*Iframe1+0.620*Qframe1;
Gframe=Yframe1-0.272*Iframe1-0.647*Qframe1;
Bframe=Yframe1-1.108*Iframe1+1.7*Qframe1;

rgbimage=zeros(240,352,3);
rgbimage(:,:,1)=Rframe;
rgbimage(:,:,2)=Gframe;
rgbimage(:,:,3)=Bframe;
figure;
imshow(uint8(rgbimage));
title('Original color frame');
