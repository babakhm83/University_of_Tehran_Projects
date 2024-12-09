function R=distance_from_signal_using_threshold(s,ts,thresh)
    c=3e8;
    td=ts*find(s>=thresh*max(s),1)-ts;
    % figure;
    % yline(thresh*max(s),'--b')
    % hold on
    % plot(s)
    % legend('Received Signal','Threshold')
    R=td*c/2;
end