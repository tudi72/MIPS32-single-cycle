# SINGLE-CYCLE CPU DESIGN

# Basic CPU design

The schema is based on the following components. The processor cotains a classic design for MIPS 32. 

![image](https://user-images.githubusercontent.com/33194623/149621276-be0324af-9535-41ca-956e-b39ace072ccc.png)

Instructions permited for this processor are. 

![image](https://user-images.githubusercontent.com/33194623/149621326-39d476cf-962e-4fd5-8beb-e13f493d7b8e.png)
![image](https://user-images.githubusercontent.com/33194623/149621347-5bc5a206-c0aa-429f-809a-194c39346811.png)
![image](https://user-images.githubusercontent.com/33194623/149621360-9d6145b5-6141-4b12-8004-ca884b8c4e13.png)

# Program S

The assembly program merges two images into one image. We use the RISC-V calling convention.
Suppose that the input addresses for the subroutine are stored in the data memory at following addresses:

* 0x00000004: inputImgA
* 0x00000008: inputImgB
* 0x0000000C: outputImg

For instance, at address 0x00000004 the address of inputImgA is stored (where the image begins).
After returning from the subroutine, program should write the returned result (i.e. the number of pixels of the output image) into the data memory at address of 0x00000010.

Algorithm of program S is designed in the following way: 
* set aplha channel to 0xFF
* output color channel (i.e., red, green and blue) is computed as the sum of corresponding channels of the input pixels. There is no need to treat overflow (i.e. if the sum is greather than 0xFF, only lower 8 bits are used).
Only the images with the same size can be merged. Input images have always the same size.
