music=[];
music=add_note(true,'D',music);
music=add_note(true,'D',music);
music=add_note(false,'G',music);
music=add_note(false,'F#',music);
music=add_note(false,'D',music);

music=add_note(true,'D',music);
music=add_note(true,'E',music);
music=add_note(true,'E',music);
music=add_note(true,'D',music);
music=add_note(true,'F#',music);
music=add_note(true,'D',music);
music=add_note(false,'E',music);

music=add_note(false,'D',music);
music=add_note(false,'E',music);
music=add_note(false,'F#',music);
music=add_note(false,'E',music);

music=add_note(true,'D',music);
music=add_note(true,'E',music);
music=add_note(true,'E',music);
music=add_note(true,'D',music);
music=add_note(true,'F#',music);
music=add_note(true,'D',music);
music=add_note(false,'E',music);

music=add_note(false,'D',music);
music=add_note(true,'E',music);
music=add_note(true,'D',music);
music=add_note(false,'F#',music);
music=add_note(false,'E',music);

music=add_note(false,'D',music);
music=add_note(true,'E',music);
music=add_note(true,'D',music);
music=add_note(false,'F#',music);
music=add_note(false,'E',music);

music=add_note(true,'D',music);
music=add_note(true,'D',music);
music=add_note(false,'E',music);
music=add_note(true,'F#',music);
music=add_note(true,'E',music);
music=add_note(false,'F#',music);

music=add_note(true,'F#',music);
music=add_note(true,'E',music);
music=add_note(false,'F#',music);
music=add_note(false,'F#',music);
music=add_note(false,'D',music);

fs=8000;
sound(music,fs);
audiowrite('music1.wav',music,fs);