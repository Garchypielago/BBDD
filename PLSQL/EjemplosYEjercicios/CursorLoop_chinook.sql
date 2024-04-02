Declare
    Cursor c1 is (select t.name,t.composer
                    from track t
                        join playlisttrack p on p.trackid = t.trackid
                    where p.playlistid = 10); 
    Nombre      track.name%type;          
    compositor  track.composer%type;
                
Begin
    Open c1;
    Loop 
        fetch c1 into Nombre, compositor;
        EXIT WHEN c1%notfound;
        DBMS_OUTPUT.PUT_LINE('Nombre:'||Nombre);
        DBMS_OUTPUT.PUT_LINE('Compositor:'||compositor);
    end loop;
    Close c1;
    
End;