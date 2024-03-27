How to Use SMW Built-in ACE Patch

Thank you for downloading the SMW Built-in ACE Patch!
This patch is a research tool that allows you to execute any code in Super Mario World at any time you want

Please read and understand the following information carefully before you use this tool


1. Files
The SMW Built-in ACE Patch consists of the following files

    SMW_Built-in_ACE_Patch_JP.asm (Patch for Japanese ROM)
    SMW_Built-in_ACE_Patch_US.asm (Patch for US ROM)
    Folders for English and Japanese explanations
        - README.txt
        - sample.txt

Note that the unedited ROM of the Japanese or North American version of Super Mario World is required to use this patch
Please prepare the ROM by yourself using a dumper


2. How to Patch
How to patch (how to use this tool).

    You have to download Asar first. Go to this site (https://www.smwcentral.net/?p=section&a=details&id=2595) and download the zip file, and unzip it.
    Move asar.exe onto SMW_Built-in_ACE_Patch folder.
    The ROM must be a .smc file with header. If you are unsure, go to this site (https://emu.web-g-p.com/info/system/header_smc.html) and add the header
    If the extension of the ROM is .sfc, change it to .smc.
    Put the ROM in the folder SMW Built-in ACE Patch (same level as asar.exe).
    Start asar.exe
    If your ROM is Japanese version, drag and drop the file SMW_Built-in_ACE_Patch_JP.asm from the folder onto the Asar window
    If your ROM is North American version, drag and drop the file SMW_Built-in_ACE_Patch_US.asm from the folder onto the Asar window
    Press the Enter key.
    Drag and drop your ROM file from the folder onto the Asar window.
    Press the Enter key.
    Done! The ROM placed in the folder has been patched


3. How to Use
This section explains how to use this tool.

How to open/close the Code Editor
    The SMW Built-in ACE Patch has a Code Editor where you can write instructions of up to 256 Bytes.
    The Code Editor is closed by default.
    You can open the Code Editor by pressing Select and the R button (used for right scrolling) at the same time.
    You can close the Code Editor by pressing Select and the L button (used for left scrolling) at the same time.

How to use the Code Editor
    You can write instructions up to 256 bytes using hexadecimal numbers in the Code Editor.
    Codes must be written in order from the top left.
    Use D-pad to move the cursor.
    Press R to increment a value by 1 and L to decrement by 1.
    Press R and L at the same time to quickly increment a value.
    Press Select and X at the same time to clear all codes.

How to execute a code
    With the Code Editor closed, press the R and L buttons simultaneously to execute the code you have written.
    If there is no sound when executing the code, check that the top left corner is not set to $00.
    If a sound is heard when the buttons are pressed, the code has been executed.

Other
    You can only use the Code Editor and execute arbitrary codes in the level or on the map.
    Also, you can not use the tool when the game is paused.


4. Technical Information
This section explains technical information.
If you are not familiar with assembly, skip this section.

    a. This patch makes a use of BRK to detect the code end, so BRK works incorrectly.
    To execute BRK correctly, delete or comment out 2 bytes from org $00ffe6.
    In this case, you must write RTL (opecode $6b) at the end of your code.
    b. Your codes are written in 256 bytes from Untouched RAM $7f9d00, and executed as a long subroutine.
    c. I expand 5 bytes from Intended RAM $7f8182 so that the tool is run every frame.


5. Known Issues
This section explains bugs the developer (tomoha) has already realised.

    Closing the Code Editor on the over world messes up the graphics.
    Enter and leave a level will recover it.

If you find other issues, contact me please.


6. Cautions

    This tool provides an environment where you can freely execute arbitrary code, so using this without a good understanding of the 65C816 assembly may cause crashes (but it's a good experience I believe).
    If you use tools such as Lunar Magic or apply other patches, this tool will won't work.
    If you use this tool in a Classic mini or similar, be aware of inaccurate reproduction of emulation such as WDM or OpenBus (the tool itself works).


7. Licence

    The main points is that you are basically free to modify SMW_Built-in_ACE_Patch.asm, but you must not modify the following parts (to prevent cheating in RTA)
            a. one byte below of org $009356 (one byte below of org $0093c1 for US patch)
            b. 5 bytes below subroutine executeArbitraryCode in org $03e055 (5 bytes below subroutine executeArbitraryCode in org $03e05c for US patch)


8. Q&A 

    Q. The code is too unreadable. Please learn programming before you write program.
    A. I am not a programmer nor does I know much about programming (as I know nothing other than 65C816). I would be happy if you could rewrite it by yourself.

    Q. I have an idea for the next update.
    A. Please contact me, then I will consider. If my technical skills can handle it, though. ......

    Q. I don't know assembly language(?) but I'd like to execute some arbitrary code!
    A. Try the code in sample.txt. I bet you'll have fun!


9. Credits

    For the Code Editor program, I modified Hex Editor program by SethBling and Mally.
    https://docs.google.com/document/d/1v_OOxPMX4ztkPQkqe3HeSpazmDA-ljRt7Mv2wd5JrKw/edit

    T.T helped me so much in graphics and debug.
    https://twitter.com/T_T_colony?s=20&t=S4ckalGtrLfSTiZ1AmERIw

    I would like to appreciate to these three fellow researchers.
