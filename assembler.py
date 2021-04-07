# 汇编器
def bin2verilog(bin_vec, str_prog):
    rom_str = "raom"
    res_str = ""
    th = 0
    for i in bin_vec:
        if (th % 2 == 0):
            temp_str0 = str_prog[th // 2][0] + " " + str_prog[th // 2][1]
            res_str += '//' + temp_str0 + "\n"
        temp_str = "raom[%d]=8'b%s;\n" % (th, i)
        res_str += temp_str

        if ((th + 1) % 2 == 0):
            res_str += "\n"
        th += 1
    return res_str


def assembler(prog_str):
    vec0 = prog_str.split('\n')  # 先按行分
    vec1 = []  # 存储分割好后的字符串,左边指令，右边数据
    res_data = []
    for i in vec0:
        if ((not i.isspace()) and len(i) > 0):
            vec1.append(i.split())
    # print(vec1)
    for i in vec1:
        # print(i[0])
        bin_code = to_bin(int(i[1]), 13) + op2num(i[0])
        res_data.append(bin_code[0:8])
        res_data.append(bin_code[8:16])
    return res_data, vec1


def to_bin(dec_num, bin_len):
    str0 = bin(dec_num)[2:]
    if (len(str0) > bin_len):
        return str0
    add_str = "0" * (bin_len - len(str0))
    return add_str + str0


def op2num(opcode):
    if (opcode == 'HLT'):
        return '000'
    elif (opcode == 'SKZ'):
        return '001'
    elif (opcode == 'ADD'):
        return '010'
    elif (opcode == 'ANDD'):
        return '011'
    elif (opcode == 'XORR'):
        return '100'
    elif (opcode == 'LDA'):
        return '101'
    elif (opcode == 'STO'):
        return '110'
    elif (opcode == 'JMP'):
        return '111'
    else:
        return


'''
SKZ =3'b001, //为0跳过下一条指令
ADD =3'b010, //
ANDD=3'b011,
XORR=3'b100,
LDA =3'b101, //读地址数据到累加器
STO =3'b110, //写累加器数据到指定地址
JMP =3'b111; //无条件跳转
'''

prot_str = '''
HLT 1
STO 300
STO 301
HLT 0
STO 302
HLT 5
STO 400
HLT 255
STO 401

LDA 300
ADD 301
STO 303

LDA 301
STO 300

LDA 303
STO 301

LDA 400
ADD 401
STO 400

SKZ 100
JMP 18

'''

ass=assembler(prot_str)
#print(ass[0])
print(bin2verilog(ass[0],ass[1]))

