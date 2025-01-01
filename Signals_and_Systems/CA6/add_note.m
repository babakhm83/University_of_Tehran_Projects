function music_out=add_note(is_half,note,music_in)
    Notes = ["C" "C#" "D" "D#" "E" "F" "F#" "G" "G#" "A" "A#" "B"];
    Freqs = [523.25 554.37 587.33 622.25 659.25 698.46 739.99 783.99 830.61 880 932.33 987.77];
    d = dictionary(Notes,Freqs);
    t_start=0;
    t_end=0.5;
    T=t_end-t_start;
    fs=8000;
    ts=1/fs;
    t_normal=t_start:ts:t_end-ts;
    t_half=t_start:ts:t_end/2-ts;
    tau=0.025;
    if(is_half)
        music_out=[music_in sin(2*pi*d(note)*t_half)];
    else
        music_out=[music_in sin(2*pi*d(note)*t_normal)];
    end
    silence=zeros([1,tau*fs]);
    music_out=[music_out silence];
end