-- LINDA ATC

-- Use this file to insert your own functions and macros.
-- Be careful with syntax as it could ruin the whole VRIDRV system.
-- Use unique function names to not interfer with exising system or aircraft functions.

--[[

EXAMPLE

--]]



-- ## sys functions - do not assign ###############

   ATCnum = 0
   ATCinit = 0
   ATCexit = 0
   ATCenter = 0

function ATC_show ()
    if ATCinit ~= 1 then
    ipc.setowndisplay("LINDA ATC", 1, 75, 10,20)
    end
    ATCinit = 1

    if ATCnum > 0 and ATCnum <= 10 and ATCenter == 0 then
       table_empty ()

    elseif ATCnum > 0 and ATCnum <= 10 and ATCenter == 1 then
       table_entered ()

    elseif ATCnum == 11 then
       table_question_down ()

    elseif ATCnum == 0 then
       table_question_up ()

    elseif ATCnum == 12 or ATCnum == -1 then
       ATCnum = 1
       ATCcount = 1
       ipc.display(" ", 1)
       ATCexit = 0
    end
end

function table_empty ()

    if ATCcount == 1 then
        ipc.display("\n1 <--\n2 \n3 \n4 \n5 \n6 \n7 \n8 \n9 \n0 \n")
        elseif ATCcount == 2 then
        ipc.display("\n1 \n2 <--\n3 \n4 \n5 \n6 \n7 \n8 \n9 \n0 \n")
        elseif ATCcount == 3 then
        ipc.display("\n1 \n2 \n3 <--\n4 \n5 \n6 \n7 \n8 \n9 \n0 \n")
        elseif ATCcount == 4 then
        ipc.display("\n1 \n2 \n3 \n4 <--\n5 \n6 \n7 \n8 \n9 \n0 \n")
        elseif ATCcount == 5 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 <--\n6 \n7 \n8 \n9 \n0 \n")
        elseif ATCcount == 6 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 <--\n7 \n8 \n9 \n0 \n")
        elseif ATCcount == 7 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 \n7 <--\n8 \n9 \n0 \n")
        elseif ATCcount == 8 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 \n7 \n8 <--\n9 \n0 \n")
        elseif ATCcount == 9 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 \n7 \n8 \n9 <--\n0 \n")
        elseif ATCcount == 0 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 \n7 \n8 \n9 \n0 <--\n")
        end
        ATCexit = 1
end

function table_entered ()

    if ATCcount == 1 then
        ipc.display("\n1 <-- Entered\n2 \n3 \n4 \n5 \n6 \n7 \n8 \n9 \n0 \n", 16384)
        elseif ATCcount == 2 then
        ipc.display("\n1 \n2 <-- Entered\n3 \n4 \n5 \n6 \n7 \n8 \n9 \n0 \n", 16384)
        elseif ATCcount == 3 then
        ipc.display("\n1 \n2 \n3 <-- Entered\n4 \n5 \n6 \n7 \n8 \n9 \n0 \n", 16384)
        elseif ATCcount == 4 then
        ipc.display("\n1 \n2 \n3 \n4 <-- Entered\n5 \n6 \n7 \n8 \n9 \n0 \n", 16384)
        elseif ATCcount == 5 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 <-- Entered\n6 \n7 \n8 \n9 \n0 \n", 16384)
        elseif ATCcount == 6 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 <-- Entered\n7 \n8 \n9 \n0 \n", 16384)
        elseif ATCcount == 7 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 \n7 <-- Entered\n8 \n9 \n0 \n", 16384)
        elseif ATCcount == 8 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 \n7 \n8 <-- Entered\n9 \n0 \n", 16384)
        elseif ATCcount == 9 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 \n7 \n8 \n9 <-- Entered\n0 \n", 16384)
        elseif ATCcount == 0 then
        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 \n7 \n8 \n9 \n0 <-- Entered\n", 16384)
        end
        ATCnum = 1
        ATCexit = 1
        ATCcount = 1
        ATCenter = 0
        ipc.sleep(250)
        table_empty ()
end

function table_question_down ()

        ipc.display("\n1 \n2 \n3 \n4 \n5 \n6 \n7 \n8 \n9 \n0 \n--> close window?")
        ATCexit = 1
end

function table_question_up ()

        ipc.display("--> close window?\n1 \n2 \n3 \n4 \n5 \n6 \n7 \n8 \n9 \n0")
        ATCexit = 1
end


-- ## ATC Functions ###############

function ATCmain_open ()
--### Opens ATC Window
    ipc.control(66513)  --open

    ATC_show ()
end

function ATCmain_close ()
--### Closes ATC window
    ipc.control(66514)  --close
end

function ATCmain_toggle ()
--### toggles ATC window
    ipc.control(65564, 0)
end


function ATC_down ()
--### Select ATC menu number downwards
    ATCnum = ATCnum + 1

    if ATCnum ~= 10 then
        ATCcount = ATCnum
    elseif ATCnum == 10 then
        ATCcount = 0
    elseif ATCnum >= 12 then
        ATCnum = 0
    end

    ATC_show ()
end

function ATC_up ()
--### Select ATC menu number upwards
    if ATCexit == 0 then
       ATCnum = 2
       ATCcount = 1
       ATC_show ()
    end

    ATCnum = ATCnum - 1

    if ATCnum == 10 then
        ATCcount = 0

    ATCnum = 10

    elseif ATCnum > 0 and ATCnum < 10 then
        ATCcount = ATCnum
    elseif ATCnum == 0 or ATCnum == -1 then
        ATCcount = 1
    end

    ATC_show ()
end

function ATC_enter ()
    ATCenter = 1

    if ATCnum > 0 then
   		ATCvar = ATCnum + 66171
   	elseif ATCnum == 0 then
   		ATCvar = 66181
   	end

   ipc.control(ATCvar)

   ATC_show ()
end


function ATC_close ()
        ATCnum = 1
       ATCcount = 1
       ipc.display(" ", 1)
       ATCexit = 0

end



_log("[LIB]  ATC library loaded...")

