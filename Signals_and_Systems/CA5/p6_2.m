clc;clearvars;
msg='signal';
t=0:0.01:3;
n_test=100;
correct_bit_rate1=zeros(size(t));
correct_bit_rate5=zeros(size(t));
idx=0;
for noise_std=t
    idx=idx+1;
    for j=1:n_test
        coded=coding_freq(msg,1);
        noise=noise_std*randn(1,length(coded));
        decoded_msg=decoding_freq(coded+noise,1);
        if(strcmp(msg,decoded_msg))
            correct_bit_rate1(idx)=correct_bit_rate1(idx)+1;
        end
        coded=coding_freq(msg,5);
        noise=noise_std*randn(1,length(coded));
        decoded_msg=decoding_freq(coded+noise,5);
        if(strcmp(msg,decoded_msg))
            correct_bit_rate5(idx)=correct_bit_rate5(idx)+1;
        end
    end
end
correct_bit_rate1=correct_bit_rate1/n_test;
correct_bit_rate5=correct_bit_rate5/n_test;
figure;
hold on;
plot(t,correct_bit_rate1,'LineWidth',2);
plot(t,correct_bit_rate5,'LineWidth',2);
lgd=legend('Bitrate 1','Bitrate 5');
lgd.FontSize = 20;
tle=title('Percentage of correctly decoded messages');
tle.FontSize=20;
xlabel('Noise');
hold off;