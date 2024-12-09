clc;clearvars;
msg='signal';
t=0:0.01:3;
n_test=100;
correct_bit_rate1=zeros(size(t));
correct_bit_rate2=zeros(size(t));
correct_bit_rate3=zeros(size(t));
idx=0;
for noise_std=t
    idx=idx+1;
    for j=1:n_test
        coded=coding_amp(msg,1);
        noise=noise_std*randn(1,length(coded));
        decoded_msg=decoding_amp(coded+noise,1);
        if(strcmp(msg,decoded_msg))
            correct_bit_rate1(idx)=correct_bit_rate1(idx)+1;
        end
        coded=coding_amp(msg,2);
        noise=noise_std*randn(1,length(coded));
        decoded_msg=decoding_amp(coded+noise,2);
        if(strcmp(msg,decoded_msg))
            correct_bit_rate2(idx)=correct_bit_rate2(idx)+1;
        end
        coded=coding_amp(msg,3);
        noise=noise_std*randn(1,length(coded));
        decoded_msg=decoding_amp(coded+noise,3);
        if(strcmp(msg,decoded_msg))
            correct_bit_rate3(idx)=correct_bit_rate3(idx)+1;
        end
    end
end
correct_bit_rate1=correct_bit_rate1/n_test;
correct_bit_rate2=correct_bit_rate2/n_test;
correct_bit_rate3=correct_bit_rate3/n_test;
figure;
hold on;
plot(t,correct_bit_rate1,'LineWidth',2);
plot(t,correct_bit_rate2,'LineWidth',2);
plot(t,correct_bit_rate3,'LineWidth',2);
lgd=legend('Bitrate 1','Bitrate 2','Bitrate 3');
lgd.FontSize = 20;
tle=title('Percentage of correctly decoded messages');
tle.FontSize=20;
xlabel('Noise');
hold off;