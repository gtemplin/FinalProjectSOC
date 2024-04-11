# FinalProjectSOC

## Tutorial links
- Pynq hardware design: https://discuss.pynq.io/t/tutorial-creating-a-hardware-design-for-pynq/145
- Using hardware design: https://discuss.pynq.io/t/tutorial-using-a-new-hardware-design-with-pynq-axi-gpio/146
- Setting up DMA in pynq: https://discuss.pynq.io/t/tutorial-pynq-dma-part-1-hardware-design/3133
- Using DMA in pynq: https://discuss.pynq.io/t/tutorial-pynq-dma-part-2-using-the-dma-from-pynq/3134

## DMA Port Descriptions
#### AXI Masters Communicate with DRAM
- M_AXI_MM2S reads data from DRAM (connect to 64-bit Zynq HP AXI-Slave port) (READ channel)
- M_AXI_S2MM writes data to DRAM (connect to 64-bit Zynq HP AXI-Slave port) (WRITE channel)
#### AXI Streams Communicate with IP Blocks 
- M_AXIS_MM2S will stream data input to the READ channel, routing that input to an attached IP block 
- S_AXIS_S2MM will receive a stream of input data from the IP block, and that stream will be routed to the WRITE channel, which will send data back to DRAM

## Streaming 
- READ channel will stall if the master stream sees that the IP block is not ready for more data
- WRITE channel will stall the IP if a DMA 'write' command has not yet started

## Control 
- The AXI-LITE port in the DMA can be used for control
