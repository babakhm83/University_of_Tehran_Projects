function [is_half,note,music_out]=extract_note(music_in)
    Notes = ["C" "C#" "D" "D#" "E" "F" "F#" "G" "G#" "A" "A#" "B"];
    Freqs = [523.25 554.37 587.33 622.25 659.25 698.46 739.99 783.99 830.61 880 932.33 987.77];
    t_start=0;
    t_end=0.5;
    T=t_end-t_start;
    fs=8000;
    tau=0.025;
    len=length(music_in);
    idx_normal=(T)*fs;
    idx_half=(T/2)*fs;
    if(idx_normal+tau*fs>len || music_in(idx_half+1)==0)
        is_half=true;
        music_out=music_in(idx_half+tau*fs+1:len);
        X=fftshift(fft(music_in(1:idx_half)));
        X=X/max(abs(X));
        [~,new_freq]=max(X(length(X)/2+2:length(X)));
        new_freq=new_freq*2/T;
    else
        is_half=false;
        music_out=music_in(idx_normal+tau*fs+1:len);
        X=fftshift(fft(music_in(1:idx_normal)));
        X=X/max(abs(X));
        [~,new_freq]=max(abs(X(length(X)/2+2:length(X))));
        new_freq=new_freq/T;
    end
    min_dif=1e5;
    for i=1:length(Freqs)
        if(abs(new_freq-Freqs(i))<min_dif)
            min_dif=abs(new_freq-Freqs(i));
            note=Notes(i);
        end
    end
end