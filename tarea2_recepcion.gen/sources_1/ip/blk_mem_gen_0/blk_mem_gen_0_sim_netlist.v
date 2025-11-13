// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Tue Nov 11 01:36:31 2025
// Host        : BastiPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/Xilinx/ProySuperDigitales/IPD432-2025/tarea2_recepcion.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    enb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [9:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [9:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [9:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [9:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [9:0]doutb;

  wire [9:0]addra;
  wire [9:0]addrb;
  wire clka;
  wire clkb;
  wire [9:0]dina;
  wire [9:0]dinb;
  wire [9:0]douta;
  wire [9:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.7865 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "10" *) 
  (* C_READ_WIDTH_B = "10" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "10" *) 
  (* C_WRITE_WIDTH_B = "10" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_11 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[9:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
gydSV72FvW4hnoyUt6yZFJHfJqjRQWPUfYIuDKP0fpjrPOkLRbJGBr4Z9msYTvoIHRlYtXJ2YMY0
d1TIQb+FK4gKsTRru9wr397OxuFBsTRf4e+ZjpYZEdsnqYWcgMSzhN4yhPvO06GyZO15y/LKBxa8
3OKwxVlOLYXhv+sxdXg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WHB6Zbfa5Qi47krP9T4L8UnPOlr881dWx7UcYaZfNGIQQM0gadcoXbhucIpRaUuyOKxv6yhKveRN
h0l+N9+KX6rbZ6+TRhP9JAMuPhlpI7T42QtRv5zx9+m3ct5S0NMszbFaK8zeTAYra5BGP7BHmtkr
MpKfLK5sFyaTE/A7ACtAace9MwFTHDZdl9uUs4aY6KJlm6GaypKduiqkNugukJp5vlFPX/ZapJqG
KMtMhI6grhcuYb1FJrwRZ4jW7hs9HxddSdGLzsZ0HsBcO/qaCPTst+ZA0YIQfd5ULlFmPqq39FfO
p1P+2hEH2n+LycbMj5cn4Dxfqv2R8eucM78R3w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
SmAzQA1VEuJXtJi5vXa2Jg7YvRqAJs6PX9HTZ1YqrJw4VfonBW3726gJ81BjlizpMkcf/Uk5sFIK
aPedVhEs4xCIZylz7gXYDshtytOA/pXUID2qV9nXr8qfI+FydSADUF3ScYDZmlkclFqlZrGq6DQ7
da3lJAzt2h/iR+cczrA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
iAph5JWb/chMQpLPX1UoLjQDxN5l2I8McM/k2xN5wRht7HXoE6F5yV8luDjn3zkI6vnfUYo7BaI1
mogRRx+R3XcwxvhHr+lngh4+/YLVex1TFncl+kiUMAsu3M/FjFSiqGMVMdKTNLDqr35DuZJVyuiF
lTwXob/KkbQDJiJjBEoxbt+968rKRKRyJGcqIjm4mqRBdqMcgo3HOJFG74SFsWAQrxvXfBhdLSG3
OfoLfls9XDojBjp7G83k0h82g1eeWgBfydm/OcX9o48Pst93NvI4ua8WShZL8MCvRWYqWZrrjrWi
cfUjXAF5SDACjq1/OU6arz/Idz6/a7AP/jmexw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BY49GZBxBT/gjZDPyaSWlti/sctckoR7jK6NuWdhnF9tiyNfVU7BqjjwxSnyMi0Uucv1BKHXC18h
8hQbFWnNtrq71ilURotXux7sssHlVJ2i1CsJWU18DOcBWxm2ai89uwvxDJh3TJkBJixB5KPvsDhL
lWOjTvZWPoR+Ixy+Tzo+U5Vx7z7SOakRwTrn3u7+c3vmCEBphE+HKeJExhBAoOEd0SXK5iwXaByW
D7Wb7zq6NNUmnCyaJ2BG9kGxLVsf+md7SlocuaFsYyaRZhwPyTucxIlz1tLYwcytKzx0ovoax3no
nYgzlzP/F0/PDWk9BqXgr/tuclc4EZYX0cf4ng==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qGnCvL35qO7cbUEKCL50yDv1UvezcqBz601zctKop1954QlcjemzZWZHg1zJ00nJaToNdH2S8AKX
n8hNJvbQ+x5HEGL5DoSU9m5qjXd8xxocnZ0yzuZX/dGCT8kDn3gWJR2Gz13pT+w2LQUno1fX+MsC
ehgwvjBBT6GeYjdxHi+aybQUP9AblSxX/z3vh857SGCPohEWvghOgORCHAe45YD+ZWnL62FLxMM2
c+Ozq/Au/Q4q1Yzlzcfv8Mnsvg7OqOeEamQHbuYOfdkJUuYqOwsskEWW348u7FXtsf8m7P3pZyyz
IWyTDAW4igGguMPLHfbtK/twZx8ScJQmOKzglg==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hz+6K8+wh5/fukU4ZWNDXGsq6hreSVCSPP67nA6kUz9Vpjy4TtTnOrrl1BWY0ivEC7Ldyw8VI60A
VO/WPlt409LdAZdMZGsEZ1JuTZ0m9LPcgu9CPCyoMECctmd8LHE+otY6etTmYABB9syY61rk2hrv
RgbcyT/HCK9TzWxSm+XMqvx2nvagCLkMDPh/JZv51fj2zcKaBPnxsz8rnDipaeo0fEyVRC3Y1F/V
U3RmXojBjIumPHSJkQ537dENJEIA0Ra65u8EM/+ItUn1bcryLcIbKy1xGadrHmHdHRUoRcAodO2C
B48bNVeL0VnGg8P9ACIB04lMNzn5p6A1tPOb4Q==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
YDpb+UeT0rJ543Q8wCo2xSS3gpVAT+JoStgBlV5IMjJoUOWkiOPn691FGChmDi3BTq5NxC73KHHR
1galACCjeTGq6cv+0Zc2Ocm1oobdrnSPHp7TMDr5Zle8FX6WywJCiGdoWBODggZSlbOASIK/PVfY
cZM2z60M6RSvzsi3TnYHiKYHpju8THVoSgRd6r31GcbiSy9TjjARERXan0OVc79jGuAg90mmDEEq
91eqmn6NZ9yLI2fgBjFUZbtFCpmJ8WGxOL1h39niWnRK3ZXnk8jcpnZUlxLbYTPO0Z3vVr1zrvcn
RVQloU0OLqg7M95zSs7NtX5Vzvb6jGbMehWV+WMMyxWmxL2XOwsAwPSeX2dI2r77pioY7X6VzH7f
/JxMAnq9udra3WGPsUkD1G0CvPkCC3zdxjpVaflY37ztX9UONhKtzMQa8lJc1IL8GhXRY3R9Lg2c
HIeXSGkpNNuFDqKT6Khe/6Casq+SjFJq+IH9IUtz6RUZTkbFb0Xhgm2P

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q+63zFEYw/LeMgxa7g8g79GGvSyIKDKD8RvvC4DHDQuGObf6n9OGZX4e17v/E/+EDEwUhsWQHFDI
Lp/aH+6fNRmhu9BEWVjxq2WRrQSl4eQjfIaSOXu2dlYh3JjRJwiUp4LteVh8RFAf5t5sRQO4dRIK
x+h28yliSgibaWEAv5FaJQ1EFbNwmgedAaSYjgf2A3afBUcBh5Uy9VHbW/zRzdhhJdsVNBjZYcFy
CVLOcf1toCRp8J4U5FlnFMOzFegUbdXFQhq2VmIhPRxWjrfTk6iR4BcMEN9UMij/5IHRAeBdksyD
CqEKsyFxosbI5KVMRZ1Ln75Zipn0JdsGekHkxg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DPUa5DLPYRWvbPnX0U412yoWvvvHyuq43DrYmDJGTK0cR5U4U6th8icYgizC1/hUAEzt19kM/hVa
zZh7bXSWACYLpcfhPY8dRTVGDZVjpbkraw0ceBryLP7jc6Jt5JdNw88tZtZpprCB7nQ25lUL82Hf
WTwL1ZqgGIvtfHhxO0JF5L5ES5giedwQ6u5ffXG3UB6ELcpQD1NvpW5lAz4mfXyvVDCAPZN581TF
tlAy79iKbPKlJ2zFn1BS2cuRIHHe2JRxwPo+0n5VD5CXVgg+lCYxTnCxI8CdyFaTumbs4IfAKwVI
wSN/btbwDUhW9hAHWHIRo+BpdJ4qeGcTDPKtsA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mf5hcf6JE6yLm0jNCQnHMVmogjLlPz6re0FwG67yvOJ3FuEorru0emIeAKEwgOoxjUYNWvcM7QAH
/UEeB2EIdjLl6glPAUda0HjtaCU2rdncVdM8k6DSMBggc4yo18Qx5F+1TD/RoBgoo0jNkMdDy6wJ
JHjqlN+R01z3yYIMQ9f2z6ZaYncbBYEp4+YAb7g1D7CSMxP5cFRpQznRpYp0JwqJfT9CHzlKgdab
8B288NxeLM66iYodiTS+GSRGLGtDWXpz9yeiuiPe6kJxae2GJyHIMSfluO/0Slc3m24DQNdbojf8
jdc0G2UnrDe5mCUTfYiDmpOWTUJOdYo0FK0N2g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21680)
`pragma protect data_block
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
8F9ywC7iGBbsyg/pxwvwOM1daAc=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
