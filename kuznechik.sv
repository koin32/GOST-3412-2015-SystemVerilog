`timescale 1ns/1ps

module kuz_gf_mul (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] y
);
    always_comb begin
        automatic logic [7:0] r  = 8'h00;
        automatic logic [7:0] aa = a;
        automatic logic [7:0] bb = b;
        r = 8'h00; aa = a; bb = b;
        for (int i = 0; i < 8; i++) begin
            if (bb[0]) r = r ^ aa;
            if (aa[7]) aa = (aa << 1) ^ 8'hC3;
            else       aa = (aa << 1);
            bb = bb >> 1;
        end
        y = r;
    end
endmodule

module kuz_pi (
    input  logic [7:0] x,
    output logic [7:0] y
);
    always_comb case (x)
        8'd0:y=8'd252;   8'd1:y=8'd238;   8'd2:y=8'd221;   8'd3:y=8'd17;
        8'd4:y=8'd207;   8'd5:y=8'd110;   8'd6:y=8'd49;    8'd7:y=8'd22;
        8'd8:y=8'd251;   8'd9:y=8'd196;   8'd10:y=8'd250;  8'd11:y=8'd218;
        8'd12:y=8'd35;   8'd13:y=8'd197;  8'd14:y=8'd4;    8'd15:y=8'd77;
        8'd16:y=8'd233;  8'd17:y=8'd119;  8'd18:y=8'd240;  8'd19:y=8'd219;
        8'd20:y=8'd147;  8'd21:y=8'd46;   8'd22:y=8'd153;  8'd23:y=8'd186;
        8'd24:y=8'd23;   8'd25:y=8'd54;   8'd26:y=8'd241;  8'd27:y=8'd187;
        8'd28:y=8'd20;   8'd29:y=8'd205;  8'd30:y=8'd95;   8'd31:y=8'd193;
        8'd32:y=8'd249;  8'd33:y=8'd24;   8'd34:y=8'd101;  8'd35:y=8'd90;
        8'd36:y=8'd226;  8'd37:y=8'd92;   8'd38:y=8'd239;  8'd39:y=8'd33;
        8'd40:y=8'd129;  8'd41:y=8'd28;   8'd42:y=8'd60;   8'd43:y=8'd66;
        8'd44:y=8'd139;  8'd45:y=8'd1;    8'd46:y=8'd142;  8'd47:y=8'd79;
        8'd48:y=8'd5;    8'd49:y=8'd132;  8'd50:y=8'd2;    8'd51:y=8'd174;
        8'd52:y=8'd227;  8'd53:y=8'd106;  8'd54:y=8'd143;  8'd55:y=8'd160;
        8'd56:y=8'd6;    8'd57:y=8'd11;   8'd58:y=8'd237;  8'd59:y=8'd152;
        8'd60:y=8'd127;  8'd61:y=8'd212;  8'd62:y=8'd211;  8'd63:y=8'd31;
        8'd64:y=8'd235;  8'd65:y=8'd52;   8'd66:y=8'd44;   8'd67:y=8'd81;
        8'd68:y=8'd234;  8'd69:y=8'd200;  8'd70:y=8'd72;   8'd71:y=8'd171;
        8'd72:y=8'd242;  8'd73:y=8'd42;   8'd74:y=8'd104;  8'd75:y=8'd162;
        8'd76:y=8'd253;  8'd77:y=8'd58;   8'd78:y=8'd206;  8'd79:y=8'd204;
        8'd80:y=8'd181;  8'd81:y=8'd112;  8'd82:y=8'd14;   8'd83:y=8'd86;
        8'd84:y=8'd8;    8'd85:y=8'd12;   8'd86:y=8'd118;  8'd87:y=8'd18;
        8'd88:y=8'd191;  8'd89:y=8'd114;  8'd90:y=8'd19;   8'd91:y=8'd71;
        8'd92:y=8'd156;  8'd93:y=8'd183;  8'd94:y=8'd93;   8'd95:y=8'd135;
        8'd96:y=8'd21;   8'd97:y=8'd161;  8'd98:y=8'd150;  8'd99:y=8'd41;
        8'd100:y=8'd16;  8'd101:y=8'd123; 8'd102:y=8'd154; 8'd103:y=8'd199;
        8'd104:y=8'd243; 8'd105:y=8'd145; 8'd106:y=8'd120; 8'd107:y=8'd111;
        8'd108:y=8'd157; 8'd109:y=8'd158; 8'd110:y=8'd178; 8'd111:y=8'd177;
        8'd112:y=8'd50;  8'd113:y=8'd117; 8'd114:y=8'd25;  8'd115:y=8'd61;
        8'd116:y=8'd255; 8'd117:y=8'd53;  8'd118:y=8'd138; 8'd119:y=8'd126;
        8'd120:y=8'd109; 8'd121:y=8'd84;  8'd122:y=8'd198; 8'd123:y=8'd128;
        8'd124:y=8'd195; 8'd125:y=8'd189; 8'd126:y=8'd13;  8'd127:y=8'd87;
        8'd128:y=8'd223; 8'd129:y=8'd245; 8'd130:y=8'd36;  8'd131:y=8'd169;
        8'd132:y=8'd62;  8'd133:y=8'd168; 8'd134:y=8'd67;  8'd135:y=8'd201;
        8'd136:y=8'd215; 8'd137:y=8'd121; 8'd138:y=8'd214; 8'd139:y=8'd246;
        8'd140:y=8'd124; 8'd141:y=8'd34;  8'd142:y=8'd185; 8'd143:y=8'd3;
        8'd144:y=8'd224; 8'd145:y=8'd15;  8'd146:y=8'd236; 8'd147:y=8'd222;
        8'd148:y=8'd122; 8'd149:y=8'd148; 8'd150:y=8'd176; 8'd151:y=8'd188;
        8'd152:y=8'd220; 8'd153:y=8'd232; 8'd154:y=8'd40;  8'd155:y=8'd80;
        8'd156:y=8'd78;  8'd157:y=8'd51;  8'd158:y=8'd10;  8'd159:y=8'd74;
        8'd160:y=8'd167; 8'd161:y=8'd151; 8'd162:y=8'd96;  8'd163:y=8'd115;
        8'd164:y=8'd30;  8'd165:y=8'd0;   8'd166:y=8'd98;  8'd167:y=8'd68;
        8'd168:y=8'd26;  8'd169:y=8'd184; 8'd170:y=8'd56;  8'd171:y=8'd130;
        8'd172:y=8'd100; 8'd173:y=8'd159; 8'd174:y=8'd38;  8'd175:y=8'd65;
        8'd176:y=8'd173; 8'd177:y=8'd69;  8'd178:y=8'd70;  8'd179:y=8'd146;
        8'd180:y=8'd39;  8'd181:y=8'd94;  8'd182:y=8'd85;  8'd183:y=8'd47;
        8'd184:y=8'd140; 8'd185:y=8'd163; 8'd186:y=8'd165; 8'd187:y=8'd125;
        8'd188:y=8'd105; 8'd189:y=8'd213; 8'd190:y=8'd149; 8'd191:y=8'd59;
        8'd192:y=8'd7;   8'd193:y=8'd88;  8'd194:y=8'd179; 8'd195:y=8'd64;
        8'd196:y=8'd134; 8'd197:y=8'd172; 8'd198:y=8'd29;  8'd199:y=8'd247;
        8'd200:y=8'd48;  8'd201:y=8'd55;  8'd202:y=8'd107; 8'd203:y=8'd228;
        8'd204:y=8'd136; 8'd205:y=8'd217; 8'd206:y=8'd231; 8'd207:y=8'd137;
        8'd208:y=8'd225; 8'd209:y=8'd27;  8'd210:y=8'd131; 8'd211:y=8'd73;
        8'd212:y=8'd76;  8'd213:y=8'd63;  8'd214:y=8'd248; 8'd215:y=8'd254;
        8'd216:y=8'd141; 8'd217:y=8'd83;  8'd218:y=8'd170; 8'd219:y=8'd144;
        8'd220:y=8'd202; 8'd221:y=8'd216; 8'd222:y=8'd133; 8'd223:y=8'd97;
        8'd224:y=8'd32;  8'd225:y=8'd113; 8'd226:y=8'd103; 8'd227:y=8'd164;
        8'd228:y=8'd45;  8'd229:y=8'd43;  8'd230:y=8'd9;   8'd231:y=8'd91;
        8'd232:y=8'd203; 8'd233:y=8'd155; 8'd234:y=8'd37;  8'd235:y=8'd208;
        8'd236:y=8'd190; 8'd237:y=8'd229; 8'd238:y=8'd108; 8'd239:y=8'd82;
        8'd240:y=8'd89;  8'd241:y=8'd166; 8'd242:y=8'd116; 8'd243:y=8'd210;
        8'd244:y=8'd230; 8'd245:y=8'd244; 8'd246:y=8'd180; 8'd247:y=8'd192;
        8'd248:y=8'd209; 8'd249:y=8'd102; 8'd250:y=8'd175; 8'd251:y=8'd194;
        8'd252:y=8'd57;  8'd253:y=8'd75;  8'd254:y=8'd99;  8'd255:y=8'd182;
        default: y = 8'd0;
    endcase
endmodule

module kuz_pi_inv (
    input  logic [7:0] x,
    output logic [7:0] y
);
    always_comb case (x)
        8'd0:y=8'd165;   8'd1:y=8'd45;    8'd2:y=8'd50;    8'd3:y=8'd143;
        8'd4:y=8'd14;    8'd5:y=8'd48;    8'd6:y=8'd56;    8'd7:y=8'd192;
        8'd8:y=8'd84;    8'd9:y=8'd230;   8'd10:y=8'd158;  8'd11:y=8'd57;
        8'd12:y=8'd85;   8'd13:y=8'd126;  8'd14:y=8'd82;   8'd15:y=8'd145;
        8'd16:y=8'd100;  8'd17:y=8'd3;    8'd18:y=8'd87;   8'd19:y=8'd90;
        8'd20:y=8'd28;   8'd21:y=8'd96;   8'd22:y=8'd7;    8'd23:y=8'd24;
        8'd24:y=8'd33;   8'd25:y=8'd114;  8'd26:y=8'd168;  8'd27:y=8'd209;
        8'd28:y=8'd41;   8'd29:y=8'd198;  8'd30:y=8'd164;  8'd31:y=8'd63;
        8'd32:y=8'd224;  8'd33:y=8'd39;   8'd34:y=8'd141;  8'd35:y=8'd12;
        8'd36:y=8'd130;  8'd37:y=8'd234;  8'd38:y=8'd174;  8'd39:y=8'd180;
        8'd40:y=8'd154;  8'd41:y=8'd99;   8'd42:y=8'd73;   8'd43:y=8'd229;
        8'd44:y=8'd66;   8'd45:y=8'd228;  8'd46:y=8'd21;   8'd47:y=8'd183;
        8'd48:y=8'd200;  8'd49:y=8'd6;    8'd50:y=8'd112;  8'd51:y=8'd157;
        8'd52:y=8'd65;   8'd53:y=8'd117;  8'd54:y=8'd25;   8'd55:y=8'd201;
        8'd56:y=8'd170;  8'd57:y=8'd252;  8'd58:y=8'd77;   8'd59:y=8'd191;
        8'd60:y=8'd42;   8'd61:y=8'd115;  8'd62:y=8'd132;  8'd63:y=8'd213;
        8'd64:y=8'd195;  8'd65:y=8'd175;  8'd66:y=8'd43;   8'd67:y=8'd134;
        8'd68:y=8'd167;  8'd69:y=8'd177;  8'd70:y=8'd178;  8'd71:y=8'd91;
        8'd72:y=8'd70;   8'd73:y=8'd211;  8'd74:y=8'd159;  8'd75:y=8'd253;
        8'd76:y=8'd212;  8'd77:y=8'd15;   8'd78:y=8'd156;  8'd79:y=8'd47;
        8'd80:y=8'd155;  8'd81:y=8'd67;   8'd82:y=8'd239;  8'd83:y=8'd217;
        8'd84:y=8'd121;  8'd85:y=8'd182;  8'd86:y=8'd83;   8'd87:y=8'd127;
        8'd88:y=8'd193;  8'd89:y=8'd240;  8'd90:y=8'd35;   8'd91:y=8'd231;
        8'd92:y=8'd37;   8'd93:y=8'd94;   8'd94:y=8'd181;  8'd95:y=8'd30;
        8'd96:y=8'd162;  8'd97:y=8'd223;  8'd98:y=8'd166;  8'd99:y=8'd254;
        8'd100:y=8'd172; 8'd101:y=8'd34;  8'd102:y=8'd249; 8'd103:y=8'd226;
        8'd104:y=8'd74;  8'd105:y=8'd188; 8'd106:y=8'd53;  8'd107:y=8'd202;
        8'd108:y=8'd238; 8'd109:y=8'd120; 8'd110:y=8'd5;   8'd111:y=8'd107;
        8'd112:y=8'd81;  8'd113:y=8'd225; 8'd114:y=8'd89;  8'd115:y=8'd163;
        8'd116:y=8'd242; 8'd117:y=8'd113; 8'd118:y=8'd86;  8'd119:y=8'd17;
        8'd120:y=8'd106; 8'd121:y=8'd137; 8'd122:y=8'd148; 8'd123:y=8'd101;
        8'd124:y=8'd140; 8'd125:y=8'd187; 8'd126:y=8'd119; 8'd127:y=8'd60;
        8'd128:y=8'd123; 8'd129:y=8'd40;  8'd130:y=8'd171; 8'd131:y=8'd210;
        8'd132:y=8'd49;  8'd133:y=8'd222; 8'd134:y=8'd196; 8'd135:y=8'd95;
        8'd136:y=8'd204; 8'd137:y=8'd207; 8'd138:y=8'd118; 8'd139:y=8'd44;
        8'd140:y=8'd184; 8'd141:y=8'd216; 8'd142:y=8'd46;  8'd143:y=8'd54;
        8'd144:y=8'd219; 8'd145:y=8'd105; 8'd146:y=8'd179; 8'd147:y=8'd20;
        8'd148:y=8'd149; 8'd149:y=8'd190; 8'd150:y=8'd98;  8'd151:y=8'd161;
        8'd152:y=8'd59;  8'd153:y=8'd22;  8'd154:y=8'd102; 8'd155:y=8'd233;
        8'd156:y=8'd92;  8'd157:y=8'd108; 8'd158:y=8'd109; 8'd159:y=8'd173;
        8'd160:y=8'd55;  8'd161:y=8'd97;  8'd162:y=8'd75;  8'd163:y=8'd185;
        8'd164:y=8'd227; 8'd165:y=8'd186; 8'd166:y=8'd241; 8'd167:y=8'd160;
        8'd168:y=8'd133; 8'd169:y=8'd131; 8'd170:y=8'd218; 8'd171:y=8'd71;
        8'd172:y=8'd197; 8'd173:y=8'd176; 8'd174:y=8'd51;  8'd175:y=8'd250;
        8'd176:y=8'd150; 8'd177:y=8'd111; 8'd178:y=8'd110; 8'd179:y=8'd194;
        8'd180:y=8'd246; 8'd181:y=8'd80;  8'd182:y=8'd255; 8'd183:y=8'd93;
        8'd184:y=8'd169; 8'd185:y=8'd142; 8'd186:y=8'd23;  8'd187:y=8'd27;
        8'd188:y=8'd151; 8'd189:y=8'd125; 8'd190:y=8'd236; 8'd191:y=8'd88;
        8'd192:y=8'd247; 8'd193:y=8'd31;  8'd194:y=8'd251; 8'd195:y=8'd124;
        8'd196:y=8'd9;   8'd197:y=8'd13;  8'd198:y=8'd122; 8'd199:y=8'd103;
        8'd200:y=8'd69;  8'd201:y=8'd135; 8'd202:y=8'd220; 8'd203:y=8'd232;
        8'd204:y=8'd79;  8'd205:y=8'd29;  8'd206:y=8'd78;  8'd207:y=8'd4;
        8'd208:y=8'd235; 8'd209:y=8'd248; 8'd210:y=8'd243; 8'd211:y=8'd62;
        8'd212:y=8'd61;  8'd213:y=8'd189; 8'd214:y=8'd138; 8'd215:y=8'd136;
        8'd216:y=8'd221; 8'd217:y=8'd205; 8'd218:y=8'd11;  8'd219:y=8'd19;
        8'd220:y=8'd152; 8'd221:y=8'd2;   8'd222:y=8'd147; 8'd223:y=8'd128;
        8'd224:y=8'd144; 8'd225:y=8'd208; 8'd226:y=8'd36;  8'd227:y=8'd52;
        8'd228:y=8'd203; 8'd229:y=8'd237; 8'd230:y=8'd244; 8'd231:y=8'd206;
        8'd232:y=8'd153; 8'd233:y=8'd16;  8'd234:y=8'd68;  8'd235:y=8'd64;
        8'd236:y=8'd146; 8'd237:y=8'd58;  8'd238:y=8'd1;   8'd239:y=8'd38;
        8'd240:y=8'd18;  8'd241:y=8'd26;  8'd242:y=8'd72;  8'd243:y=8'd104;
        8'd244:y=8'd245; 8'd245:y=8'd129; 8'd246:y=8'd139; 8'd247:y=8'd199;
        8'd248:y=8'd214; 8'd249:y=8'd32;  8'd250:y=8'd10;  8'd251:y=8'd8;
        8'd252:y=8'd0;   8'd253:y=8'd76;  8'd254:y=8'd215; 8'd255:y=8'd116;
        default: y = 8'd0;
    endcase
endmodule

module kuz_sub_fwd (
    input  logic [127:0] in,
    output logic [127:0] out
);
    genvar g;
    generate
        for (g = 0; g < 16; g++) begin : sbf
            kuz_pi u (.x(in[g*8+:8]), .y(out[g*8+:8]));
        end
    endgenerate
endmodule

module kuz_sub_inv (
    input  logic [127:0] in,
    output logic [127:0] out
);
    genvar g;
    generate
        for (g = 0; g < 16; g++) begin : sbi
            kuz_pi_inv u (.x(in[g*8+:8]), .y(out[g*8+:8]));
        end
    endgenerate
endmodule

module kuz_R (
    input  logic [127:0] in,
    output logic [127:0] out
);
    localparam logic [7:0] LC [0:15] = '{
        8'd1,   8'd148, 8'd32,  8'd133,
        8'd16,  8'd194, 8'd192, 8'd1,
        8'd251, 8'd1,   8'd192, 8'd194,
        8'd16,  8'd133, 8'd32,  8'd148
    };

    logic [7:0] p [0:15];
    genvar k;
    generate
        for (k = 0; k < 16; k++) begin : gr
            kuz_gf_mul u (.a(LC[k]), .b(in[k*8+:8]), .y(p[k]));
        end
    endgenerate

    logic [7:0] lv;
    assign lv = p[0]^p[1]^p[2]^p[3]^p[4]^p[5]^p[6]^p[7]^
                p[8]^p[9]^p[10]^p[11]^p[12]^p[13]^p[14]^p[15];

    assign out = {lv, in[127:8]};
endmodule

module kuz_R_inv (
    input  logic [127:0] in,
    output logic [127:0] out
);
    localparam logic [7:0] LC [0:15] = '{
        8'd1,   8'd148, 8'd32,  8'd133,
        8'd16,  8'd194, 8'd192, 8'd1,
        8'd251, 8'd1,   8'd192, 8'd194,
        8'd16,  8'd133, 8'd32,  8'd148
    };

    logic [7:0] p [1:15];
    genvar k;
    generate
        for (k = 1; k < 16; k++) begin : gri
            kuz_gf_mul u (.a(LC[k]), .b(in[(k-1)*8+:8]), .y(p[k]));
        end
    endgenerate

    logic [7:0] a0;
    assign a0 = in[127:120]
              ^ p[1]^p[2]^p[3]^p[4]^p[5]^p[6]^p[7]
              ^ p[8]^p[9]^p[10]^p[11]^p[12]^p[13]^p[14]^p[15];

    assign out = {in[119:0], a0};
endmodule

module kuz_L (
    input  logic [127:0] in,
    output logic [127:0] out
);
    logic [127:0] s [0:16];
    assign s[0] = in;
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin : lc
            kuz_R u (.in(s[i]), .out(s[i+1]));
        end
    endgenerate
    assign out = s[16];
endmodule

module kuz_L_inv (
    input  logic [127:0] in,
    output logic [127:0] out
);
    logic [127:0] s [0:16];
    assign s[0] = in;
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin : lic
            kuz_R_inv u (.in(s[i]), .out(s[i+1]));
        end
    endgenerate
    assign out = s[16];
endmodule

module kuz_SL (
    input  logic [127:0] in,
    output logic [127:0] out
);
    logic [127:0] t;
    kuz_sub_fwd u_s (.in(in), .out(t));
    kuz_L       u_l (.in(t),  .out(out));
endmodule

module kuz_Cconst (
    input  logic [7:0]   idx,   
    output logic [127:0] C
);
    logic [127:0] vec;
    always_comb begin
        vec    = 128'h0;
        vec[7:0] = idx;   
    end
    kuz_L u_l (.in(vec), .out(C));
endmodule

module kuz_Cconst_p #(parameter IDX = 1) (
    output logic [127:0] C
);
    kuz_Cconst u (.idx(8'(IDX)), .C(C));
endmodule

module kuz_keysched (
    input  logic [255:0] key,
    output logic [127:0] rk [0:9]
);
    assign rk[0] = key[255:128];
    assign rk[1] = key[127:0];

    logic [127:0] CA [0:31];

    kuz_Cconst_p #(.IDX( 1)) cc00(.C(CA[ 0]));
    kuz_Cconst_p #(.IDX( 2)) cc01(.C(CA[ 1]));
    kuz_Cconst_p #(.IDX( 3)) cc02(.C(CA[ 2]));
    kuz_Cconst_p #(.IDX( 4)) cc03(.C(CA[ 3]));
    kuz_Cconst_p #(.IDX( 5)) cc04(.C(CA[ 4]));
    kuz_Cconst_p #(.IDX( 6)) cc05(.C(CA[ 5]));
    kuz_Cconst_p #(.IDX( 7)) cc06(.C(CA[ 6]));
    kuz_Cconst_p #(.IDX( 8)) cc07(.C(CA[ 7]));
    kuz_Cconst_p #(.IDX( 9)) cc08(.C(CA[ 8]));
    kuz_Cconst_p #(.IDX(10)) cc09(.C(CA[ 9]));
    kuz_Cconst_p #(.IDX(11)) cc10(.C(CA[10]));
    kuz_Cconst_p #(.IDX(12)) cc11(.C(CA[11]));
    kuz_Cconst_p #(.IDX(13)) cc12(.C(CA[12]));
    kuz_Cconst_p #(.IDX(14)) cc13(.C(CA[13]));
    kuz_Cconst_p #(.IDX(15)) cc14(.C(CA[14]));
    kuz_Cconst_p #(.IDX(16)) cc15(.C(CA[15]));
    kuz_Cconst_p #(.IDX(17)) cc16(.C(CA[16]));
    kuz_Cconst_p #(.IDX(18)) cc17(.C(CA[17]));
    kuz_Cconst_p #(.IDX(19)) cc18(.C(CA[18]));
    kuz_Cconst_p #(.IDX(20)) cc19(.C(CA[19]));
    kuz_Cconst_p #(.IDX(21)) cc20(.C(CA[20]));
    kuz_Cconst_p #(.IDX(22)) cc21(.C(CA[21]));
    kuz_Cconst_p #(.IDX(23)) cc22(.C(CA[22]));
    kuz_Cconst_p #(.IDX(24)) cc23(.C(CA[23]));
    kuz_Cconst_p #(.IDX(25)) cc24(.C(CA[24]));
    kuz_Cconst_p #(.IDX(26)) cc25(.C(CA[25]));
    kuz_Cconst_p #(.IDX(27)) cc26(.C(CA[26]));
    kuz_Cconst_p #(.IDX(28)) cc27(.C(CA[27]));
    kuz_Cconst_p #(.IDX(29)) cc28(.C(CA[28]));
    kuz_Cconst_p #(.IDX(30)) cc29(.C(CA[29]));
    kuz_Cconst_p #(.IDX(31)) cc30(.C(CA[30]));
    kuz_Cconst_p #(.IDX(32)) cc31(.C(CA[31]));

    // Feistel chain
    logic [127:0] fa [0:32];
    logic [127:0] fb [0:32];
    assign fa[0] = rk[0];
    assign fb[0] = rk[1];

    genvar fi;
    generate
        for (fi = 0; fi < 32; fi++) begin : Fc
            logic [127:0] sl_out;
            kuz_SL u_sl (.in(fa[fi] ^ CA[fi]), .out(sl_out));
            assign fa[fi+1] = sl_out ^ fb[fi];
            assign fb[fi+1] = fa[fi];
        end
    endgenerate

    assign rk[2] = fa[8];   assign rk[3] = fb[8];
    assign rk[4] = fa[16];  assign rk[5] = fb[16];
    assign rk[6] = fa[24];  assign rk[7] = fb[24];
    assign rk[8] = fa[32];  assign rk[9] = fb[32];
endmodule

module kuz_enc (
    input  logic [127:0] pt,
    input  logic [127:0] rk [0:9],
    output logic [127:0] ct
);
    logic [127:0] s [0:9];
    assign s[0] = pt;
    genvar i;
    generate
        for (i = 0; i < 9; i++) begin : er
            logic [127:0] x;
            assign x = s[i] ^ rk[i];
            kuz_SL u (.in(x), .out(s[i+1]));
        end
    endgenerate
    assign ct = s[9] ^ rk[9];
endmodule

module kuz_dec (
    input  logic [127:0] ct,
    input  logic [127:0] rk [0:9],
    output logic [127:0] pt
);
    logic [127:0] s [0:9];
    assign s[0] = ct ^ rk[9];
    genvar i;
    generate
        for (i = 0; i < 9; i++) begin : dr
            logic [127:0] li, si;
            kuz_L_inv   u_li (.in(s[i]),  .out(li));
            kuz_sub_inv u_si (.in(li),    .out(si));
            assign s[i+1] = si ^ rk[8-i];
        end
    endgenerate
    assign pt = s[9];
endmodule

module grasshopper (
    input  logic         clk,
    input  logic         rst_n,
    input  logic         start,
    input  logic         decrypt,
    input  logic [127:0] data_in,
    input  logic [255:0] key,
    output logic [127:0] data_out,
    output logic         valid
);
    logic [127:0] rk [0:9];
    kuz_keysched u_ks (.key(key), .rk(rk));

    logic [127:0] enc_out, dec_out;
    kuz_enc u_enc (.pt(data_in), .rk(rk), .ct(enc_out));
    kuz_dec u_dec (.ct(data_in), .rk(rk), .pt(dec_out));

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 128'h0;
            valid    <= 1'b0;
        end else begin
            valid    <= start;
            if (start)
                data_out <= decrypt ? dec_out : enc_out;
        end
    end
endmodule
