function R=distance_from_signal_using_correlation(s_s,r_s,ts,tau)
    convolution=conv(s_s,r_s);
    % figure;
    % plot(convolution)
    % hold on
    [m,i]=max(convolution);
    % plot(i,m, '.', 'MarkerSize', 30)
    % text(i,m,'Max point of convolution')
    % ylim([0,2*m])
    td=ts*i-tau;
    c=3e8;
    R=td*c/2;
end