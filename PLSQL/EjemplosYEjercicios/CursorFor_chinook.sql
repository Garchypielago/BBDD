Declare
    Cursor c1 is (select t.name,t.composer
                    from track t
                        join playlisttrack p on p.trackid = t.trackid
                    where p.playlistid = 10); 
    /* No necesito tener variables para recorrer el cursor     
    Nombre      track.name%type;      
    compositor  track.composer%type;*/
                
Begin
    for i in c1 loop
        DBMS_OUTPUT.PUT_LINE('Nombre:'||i.name);
        DBMS_OUTPUT.PUT_LINE('Compositor:'||i.composer);       
    end loop;
    -- Ni abro ni cierro el cursor Close c1;
    
End;