# a1 = first image pixel
# a2 = second image pixel
# a3 = third image pixel
# t0 = width of the image
# t1 = height of the image
#t6 = return address of merge 
	
	lw a1,0x04(zero)
	lw a2,0x08(zero)
	lw a3,0x0C(zero)
	
	jal s0,merge
	sw a0, 0x10(zero)

loop:	beq zero,zero,loop
##################################################################
# a1,a2,a3 used for images
# t4,t5,t6
merge: 
	lw t0,0x00(a1)  #load image signature
	sw t0,0x00(a3) #   store the signature
	
	lw t0,0x04(a1)	# t0 <- width
	sw t0,0x04(a3) # store the width
	
	lw t1,0x08(a1)  # t1 <- height
	sw t1,0x08(a3) #store the height
	
	jal t5,compute_length # a0 = length,t0 = 0 ,t3 = 1
	add t4,a0,zero		# t4 <- temporary length	
	
	addi a1,a1,0x0C	# a1 <- index of first pixel
	addi a2,a2, 0x0C	#a2 <- index of first pixel
	addi a3,a3,0x0C	# a3 <- index of the first pixel
	
# t0,t1,t2 
# a1,a2,a3
# t4,t5,t6	
inner_loop:	
		lw t0,0x00(a1)	# a1 <- img1[next pixel]
		lw t1,0x00(a2)	# a2 <- img2[next pixel]
		adduqb t2,t1,t0	# adduqb a3 <- a1 + a2 (for each pixel)
	
		jal t0,set_alpha_channel
		
		or t2,t2,t6 	# set alpha channel
			
		sw t2,0x00(a3) # img3[next pixe] <- [FF][a1 + a2]
		
		sub t4,t4,t3	# t4 <- t4 - 1 ,loop length decreases 
		addi t5,t5,4	# t5 <- next pixel
		
		addi a1,a1,0x04
		addi a2,a2,0x04
		addi a3,a3,0x04
		beq t4,zero,exit_merge
		jal inner_loop
		
exit_merge:jalr s0
################################################################
# a0,t0,t1,t3,t5 used
# t3 = 1 constant 
# a0 = total length (width * height)
# t0 = 0 after this function 
# t1 = height (unchanged)
# t5 = return addres from compute_length
compute_length:
	addi t3,zero,1 #preparing methods for 
	beq t0,zero,exit_compute_length
	inner_compute:
		add a0,a0,t1
		sub t0,t0,t3
		beq t0,zero,exit_compute_length
		jal inner_compute
exit_compute_length:
	jalr t5
################################################################
set_alpha_channel:
	addi t1,zero,4
	lui t6,0xFF	#load 0XFF
	sll t6,t6,t1	
	sll t6,t6,t1
	sll t6,t6,t1	# t6 = 0xFF00_0000
	jalr t0