function grayed_image=mygrayfun(colored_image)
    grayed_image=0.299*colored_image(:,:,1)+0.578*colored_image(:,:,2)+0.114*colored_image(:,:,3);
end