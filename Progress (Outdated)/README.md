# Group-17 CPU

Hey guys, I set up this repository so we can all share our modules and testbenches.  

Plan Dates:

>NOV 29: Working Basic Insturctions + Testbenches  
>DEC 3:  Mini CPU + Mini Testbench  
>DEC 17: Final Bus CPU + Final Testbench + Final Datasheet  

Instruction Distribution:

>ADDU ADDIU INSTR + TB        : James, Saifullah  
>JR INSTR + TB                : Timur, Savraj  
>Register File + Control      : Andy, Soma  

CPU V0.9 is a 2 cycle mini cpu without store working. V1 is the fully working CPU.  

TASKS:  

>Testing individual modules  
>Write testbenches to test instructions    
>>Around 2 to 3 per instruction testing certain functionality  
>>Testbench should contain a RAM similair to mini_cpu_tb, with instructions  
>>>Insturctions should be in HEX, use a MIPS assembly to hex converter  

>>Only the register $2 and RAM addresses can be asserted, so if you want to test a value write it into one of those 

>Write full Testsuit ssh  
>Write Datasheet  
>
