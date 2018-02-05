function ram_init(filename : string) return memory_array is
    variable temp : memory_array;
    file file_ptr : text;
    variable line_line : line;
    variable line_text : string(1 to 14);
    variable tmp_hexnum : string(1 to 2);
    variable lines_read : integer := 0;
    begin
        file_open(file_ptr,filename,READ_MODE);
        while (lines_read < 32 and not endfile(file_ptr)) loop
            readline (file_ptr,line_line);
            read (line_line,line_text);
            tmp_hexnum := line_text(10 to 11);
            temp(lines_read) := hex_to_bin(tmp_hexnum);
            lines_read := lines_read + 1;
        end loop;
        file_close(file_ptr);
    return temp;
end function;
signal ram : memory_array := ram_init(filename=>"../RAM.HEX");