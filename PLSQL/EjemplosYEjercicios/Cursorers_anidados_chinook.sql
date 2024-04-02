Declare
    Cursor c1 (v_artista artist.artistid%type) is (select *
                    from album a
                    where a.artistid = v_artista); 
    
    Cursor c2 (v_album album.albumid%type) IS (Select *
                                            from track t
                                            where t.albumid = v_album);                                        

    Nombre artist.name%type;
    codigo artist.artistid%type;
Begin
    
    Select artist.name, artist.artistid 
        into Nombre, codigo
       from artist 
       where artistid = &artista;
       DBMS_OUTPUT.PUT_LINE('Artista: '||Nombre);

    for i in c1(codigo) loop
        DBMS_OUTPUT.PUT_LINE('Título album: '||i.title);
        for j in c2(i.albumid) loop
            DBMS_OUTPUT.PUT_LINE('Título canción: '||j.name);
        End Loop;
    end loop;
    -- Ni abro ni cierro el cursor Close c1;
    
End;