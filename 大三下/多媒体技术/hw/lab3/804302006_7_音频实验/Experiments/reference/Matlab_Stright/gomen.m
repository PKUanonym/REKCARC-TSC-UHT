f0raw0=MulticueF0v14(x0,fs);
ap0=exstraightAPind(x0,fs,f0raw0);
n3sgram0=exstraightspec(x0,f0raw0,fs);

f0raw1=MulticueF0v14(x1,fs);
ap1=exstraightAPind(x1,fs,f0raw1);
n3sgram1=exstraightspec(x1,f0raw1,fs);

f0raw2=MulticueF0v14(x2,fs);
ap2=exstraightAPind(x2,fs,f0raw2);
n3sgram2=exstraightspec(x2,f0raw2,fs);

[new_f0raw01,new_ap01,new_n3sgram01]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw1,ap1,n3sgram1,62,449,79,386,0.1);sy01_1=exstraightsynth(new_f0raw01,new_n3sgram01,new_ap01,fs);
[new_f0raw01,new_ap01,new_n3sgram01]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw1,ap1,n3sgram1,62,449,79,386,0.2);sy01_2=exstraightsynth(new_f0raw01,new_n3sgram01,new_ap01,fs);
[new_f0raw01,new_ap01,new_n3sgram01]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw1,ap1,n3sgram1,62,449,79,386,0.3);sy01_3=exstraightsynth(new_f0raw01,new_n3sgram01,new_ap01,fs);
[new_f0raw01,new_ap01,new_n3sgram01]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw1,ap1,n3sgram1,62,449,79,386,0.4);sy01_4=exstraightsynth(new_f0raw01,new_n3sgram01,new_ap01,fs);
[new_f0raw01,new_ap01,new_n3sgram01]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw1,ap1,n3sgram1,62,449,79,386,0.5);sy01_5=exstraightsynth(new_f0raw01,new_n3sgram01,new_ap01,fs);
[new_f0raw01,new_ap01,new_n3sgram01]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw1,ap1,n3sgram1,62,449,79,386,0.6);sy01_6=exstraightsynth(new_f0raw01,new_n3sgram01,new_ap01,fs);
[new_f0raw01,new_ap01,new_n3sgram01]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw1,ap1,n3sgram1,62,449,79,386,0.7);sy01_7=exstraightsynth(new_f0raw01,new_n3sgram01,new_ap01,fs);
[new_f0raw01,new_ap01,new_n3sgram01]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw1,ap1,n3sgram1,62,449,79,386,0.8);sy01_8=exstraightsynth(new_f0raw01,new_n3sgram01,new_ap01,fs);
[new_f0raw01,new_ap01,new_n3sgram01]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw1,ap1,n3sgram1,62,449,79,386,0.9);sy01_9=exstraightsynth(new_f0raw01,new_n3sgram01,new_ap01,fs);

[new_f0raw02,new_ap02,new_n3sgram02]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw2,ap2,n3sgram2,62,449,103,452,0.1);sy02_1=exstraightsynth(new_f0raw02,new_n3sgram02,new_ap02,fs);
[new_f0raw02,new_ap02,new_n3sgram02]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw2,ap2,n3sgram2,62,449,103,452,0.2);sy02_2=exstraightsynth(new_f0raw02,new_n3sgram02,new_ap02,fs);
[new_f0raw02,new_ap02,new_n3sgram02]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw2,ap2,n3sgram2,62,449,103,452,0.3);sy02_3=exstraightsynth(new_f0raw02,new_n3sgram02,new_ap02,fs);
[new_f0raw02,new_ap02,new_n3sgram02]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw2,ap2,n3sgram2,62,449,103,452,0.4);sy02_4=exstraightsynth(new_f0raw02,new_n3sgram02,new_ap02,fs);
[new_f0raw02,new_ap02,new_n3sgram02]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw2,ap2,n3sgram2,62,449,103,452,0.5);sy02_5=exstraightsynth(new_f0raw02,new_n3sgram02,new_ap02,fs);
[new_f0raw02,new_ap02,new_n3sgram02]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw2,ap2,n3sgram2,62,449,103,452,0.6);sy02_6=exstraightsynth(new_f0raw02,new_n3sgram02,new_ap02,fs);
[new_f0raw02,new_ap02,new_n3sgram02]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw2,ap2,n3sgram2,62,449,103,452,0.7);sy02_7=exstraightsynth(new_f0raw02,new_n3sgram02,new_ap02,fs);
[new_f0raw02,new_ap02,new_n3sgram02]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw2,ap2,n3sgram2,62,449,103,452,0.8);sy02_8=exstraightsynth(new_f0raw02,new_n3sgram02,new_ap02,fs);
[new_f0raw02,new_ap02,new_n3sgram02]=mergeSyllable(f0raw0,ap0,n3sgram0,f0raw2,ap2,n3sgram2,62,449,103,452,0.9);sy02_9=exstraightsynth(new_f0raw02,new_n3sgram02,new_ap02,fs);

[new_f0raw10,new_ap10,new_n3sgram10]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw0,ap0,n3sgram0,79,386,62,449,0.1);sy10_1=exstraightsynth(new_f0raw10,new_n3sgram10,new_ap10,fs);
[new_f0raw10,new_ap10,new_n3sgram10]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw0,ap0,n3sgram0,79,386,62,449,0.2);sy10_2=exstraightsynth(new_f0raw10,new_n3sgram10,new_ap10,fs);
[new_f0raw10,new_ap10,new_n3sgram10]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw0,ap0,n3sgram0,79,386,62,449,0.3);sy10_3=exstraightsynth(new_f0raw10,new_n3sgram10,new_ap10,fs);
[new_f0raw10,new_ap10,new_n3sgram10]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw0,ap0,n3sgram0,79,386,62,449,0.4);sy10_4=exstraightsynth(new_f0raw10,new_n3sgram10,new_ap10,fs);
[new_f0raw10,new_ap10,new_n3sgram10]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw0,ap0,n3sgram0,79,386,62,449,0.5);sy10_5=exstraightsynth(new_f0raw10,new_n3sgram10,new_ap10,fs);
[new_f0raw10,new_ap10,new_n3sgram10]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw0,ap0,n3sgram0,79,386,62,449,0.6);sy10_6=exstraightsynth(new_f0raw10,new_n3sgram10,new_ap10,fs);
[new_f0raw10,new_ap10,new_n3sgram10]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw0,ap0,n3sgram0,79,386,62,449,0.7);sy10_7=exstraightsynth(new_f0raw10,new_n3sgram10,new_ap10,fs);
[new_f0raw10,new_ap10,new_n3sgram10]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw0,ap0,n3sgram0,79,386,62,449,0.8);sy10_8=exstraightsynth(new_f0raw10,new_n3sgram10,new_ap10,fs);
[new_f0raw10,new_ap10,new_n3sgram10]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw0,ap0,n3sgram0,79,386,62,449,0.9);sy10_9=exstraightsynth(new_f0raw10,new_n3sgram10,new_ap10,fs);

[new_f0raw12,new_ap12,new_n3sgram12]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw2,ap2,n3sgram2,79,386,103,452,0.1);sy12_1=exstraightsynth(new_f0raw12,new_n3sgram12,new_ap12,fs);
[new_f0raw12,new_ap12,new_n3sgram12]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw2,ap2,n3sgram2,79,386,103,452,0.2);sy12_2=exstraightsynth(new_f0raw12,new_n3sgram12,new_ap12,fs);
[new_f0raw12,new_ap12,new_n3sgram12]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw2,ap2,n3sgram2,79,386,103,452,0.3);sy12_3=exstraightsynth(new_f0raw12,new_n3sgram12,new_ap12,fs);
[new_f0raw12,new_ap12,new_n3sgram12]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw2,ap2,n3sgram2,79,386,103,452,0.4);sy12_4=exstraightsynth(new_f0raw12,new_n3sgram12,new_ap12,fs);
[new_f0raw12,new_ap12,new_n3sgram12]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw2,ap2,n3sgram2,79,386,103,452,0.5);sy12_5=exstraightsynth(new_f0raw12,new_n3sgram12,new_ap12,fs);
[new_f0raw12,new_ap12,new_n3sgram12]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw2,ap2,n3sgram2,79,386,103,452,0.6);sy12_6=exstraightsynth(new_f0raw12,new_n3sgram12,new_ap12,fs);
[new_f0raw12,new_ap12,new_n3sgram12]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw2,ap2,n3sgram2,79,386,103,452,0.7);sy12_7=exstraightsynth(new_f0raw12,new_n3sgram12,new_ap12,fs);
[new_f0raw12,new_ap12,new_n3sgram12]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw2,ap2,n3sgram2,79,386,103,452,0.8);sy12_8=exstraightsynth(new_f0raw12,new_n3sgram12,new_ap12,fs);
[new_f0raw12,new_ap12,new_n3sgram12]=mergeSyllable(f0raw1,ap1,n3sgram1,f0raw2,ap2,n3sgram2,79,386,103,452,0.9);sy12_9=exstraightsynth(new_f0raw12,new_n3sgram12,new_ap12,fs);

[new_f0raw20,new_ap20,new_n3sgram20]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw0,ap0,n3sgram0,103,452,62,449,0.1);sy20_1=exstraightsynth(new_f0raw20,new_n3sgram20,new_ap20,fs);
[new_f0raw20,new_ap20,new_n3sgram20]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw0,ap0,n3sgram0,103,452,62,449,0.2);sy20_2=exstraightsynth(new_f0raw20,new_n3sgram20,new_ap20,fs);
[new_f0raw20,new_ap20,new_n3sgram20]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw0,ap0,n3sgram0,103,452,62,449,0.3);sy20_3=exstraightsynth(new_f0raw20,new_n3sgram20,new_ap20,fs);
[new_f0raw20,new_ap20,new_n3sgram20]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw0,ap0,n3sgram0,103,452,62,449,0.4);sy20_4=exstraightsynth(new_f0raw20,new_n3sgram20,new_ap20,fs);
[new_f0raw20,new_ap20,new_n3sgram20]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw0,ap0,n3sgram0,103,452,62,449,0.5);sy20_5=exstraightsynth(new_f0raw20,new_n3sgram20,new_ap20,fs);
[new_f0raw20,new_ap20,new_n3sgram20]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw0,ap0,n3sgram0,103,452,62,449,0.6);sy20_6=exstraightsynth(new_f0raw20,new_n3sgram20,new_ap20,fs);
[new_f0raw20,new_ap20,new_n3sgram20]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw0,ap0,n3sgram0,103,452,62,449,0.7);sy20_7=exstraightsynth(new_f0raw20,new_n3sgram20,new_ap20,fs);
[new_f0raw20,new_ap20,new_n3sgram20]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw0,ap0,n3sgram0,103,452,62,449,0.8);sy20_8=exstraightsynth(new_f0raw20,new_n3sgram20,new_ap20,fs);
[new_f0raw20,new_ap20,new_n3sgram20]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw0,ap0,n3sgram0,103,452,62,449,0.9);sy20_9=exstraightsynth(new_f0raw20,new_n3sgram20,new_ap20,fs);

[new_f0raw21,new_ap21,new_n3sgram21]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw1,ap1,n3sgram1,103,452,79,386,0.1);sy21_1=exstraightsynth(new_f0raw21,new_n3sgram21,new_ap21,fs);
[new_f0raw21,new_ap21,new_n3sgram21]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw1,ap1,n3sgram1,103,452,79,386,0.2);sy21_2=exstraightsynth(new_f0raw21,new_n3sgram21,new_ap21,fs);
[new_f0raw21,new_ap21,new_n3sgram21]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw1,ap1,n3sgram1,103,452,79,386,0.3);sy21_3=exstraightsynth(new_f0raw21,new_n3sgram21,new_ap21,fs);
[new_f0raw21,new_ap21,new_n3sgram21]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw1,ap1,n3sgram1,103,452,79,386,0.4);sy21_4=exstraightsynth(new_f0raw21,new_n3sgram21,new_ap21,fs);
[new_f0raw21,new_ap21,new_n3sgram21]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw1,ap1,n3sgram1,103,452,79,386,0.5);sy21_5=exstraightsynth(new_f0raw21,new_n3sgram21,new_ap21,fs);
[new_f0raw21,new_ap21,new_n3sgram21]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw1,ap1,n3sgram1,103,452,79,386,0.6);sy21_6=exstraightsynth(new_f0raw21,new_n3sgram21,new_ap21,fs);
[new_f0raw21,new_ap21,new_n3sgram21]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw1,ap1,n3sgram1,103,452,79,386,0.7);sy21_7=exstraightsynth(new_f0raw21,new_n3sgram21,new_ap21,fs);
[new_f0raw21,new_ap21,new_n3sgram21]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw1,ap1,n3sgram1,103,452,79,386,0.8);sy21_8=exstraightsynth(new_f0raw21,new_n3sgram21,new_ap21,fs);
[new_f0raw21,new_ap21,new_n3sgram21]=mergeSyllable(f0raw2,ap2,n3sgram2,f0raw1,ap1,n3sgram1,103,452,79,386,0.9);sy21_9=exstraightsynth(new_f0raw21,new_n3sgram21,new_ap21,fs);

soundsc(sy01_1,fs);
soundsc(sy01_2,fs);
soundsc(sy01_3,fs);
soundsc(sy01_4,fs);
soundsc(sy01_5,fs);
soundsc(sy01_6,fs);
soundsc(sy01_7,fs);
soundsc(sy01_8,fs);
soundsc(sy01_9,fs);

soundsc(sy02_1,fs);
soundsc(sy02_2,fs);
soundsc(sy02_3,fs);
soundsc(sy02_4,fs);
soundsc(sy02_5,fs);
soundsc(sy02_6,fs);
soundsc(sy02_7,fs);
soundsc(sy02_8,fs);
soundsc(sy02_9,fs);

soundsc(sy10_1,fs);
soundsc(sy10_2,fs);
soundsc(sy10_3,fs);
soundsc(sy10_4,fs);
soundsc(sy10_5,fs);
soundsc(sy10_6,fs);
soundsc(sy10_7,fs);
soundsc(sy10_8,fs);
soundsc(sy10_9,fs);

soundsc(sy12_1,fs);
soundsc(sy12_2,fs);
soundsc(sy12_3,fs);
soundsc(sy12_4,fs);
soundsc(sy12_5,fs);
soundsc(sy12_6,fs);
soundsc(sy12_7,fs);
soundsc(sy12_8,fs);
soundsc(sy12_9,fs);

soundsc(sy20_1,fs);
soundsc(sy20_2,fs);
soundsc(sy20_3,fs);
soundsc(sy20_4,fs);
soundsc(sy20_5,fs);
soundsc(sy20_6,fs);
soundsc(sy20_7,fs);
soundsc(sy20_8,fs);
soundsc(sy20_9,fs);

soundsc(sy21_1,fs);
soundsc(sy21_2,fs);
soundsc(sy21_3,fs);
soundsc(sy21_4,fs);
soundsc(sy21_5,fs);
soundsc(sy21_6,fs);
soundsc(sy21_7,fs);
soundsc(sy21_8,fs);
soundsc(sy21_9,fs);