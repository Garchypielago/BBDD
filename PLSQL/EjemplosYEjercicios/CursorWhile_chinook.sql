Declare
    Cursor c1 is (select t.name,t.composer
                    from track t
                        join playlisttrack p on p.trackid = t.trackid
                    where p.playlistid = 10); 
    Nombre      track.name%type;          
    compositor  track.composer%type;
                
Begin
    Open c1;
    fetch c1 into Nombre, compositor;
    While c1%found loop
        DBMS_OUTPUT.PUT_LINE('Nombre:'||Nombre);
        DBMS_OUTPUT.PUT_LINE('Compositor:'||compositor);
        fetch c1 into Nombre, compositor;
    end loop;
    Close c1;
    
End;