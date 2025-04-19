# Simple two-pass assembler for the insertion sort MIPS code

# 1. Define register map and encoders
REG = {
    '$zero':0, '$at':1, '$v0':2, '$v1':3,
    '$a0':4, '$a1':5, '$a2':6, '$a3':7,
    '$t0':8, '$t1':9, '$t2':10, '$t3':11,
    '$t4':12,'$t5':13,'$t6':14,'$t7':15,
    '$s0':16,'$s1':17,'$s2':18,'$s3':19,
    '$s4':20,'$s5':21,'$s6':22,'$s7':23,
    '$t8':24,'$t9':25,'$k0':26,'$k1':27,
    '$gp':28,'$sp':29,'$fp':30,'$ra':31
}
OPCODES = {
    'addi':0b001000, 'addiu':0b001001, 'lw':0b100011, 'sw':0b101011,
    'bge':0b000111, 'blt':0b000110
}
FUNCTS = {
    'add':0b100000, 'sub':0b100010, 'mul':0b011000, 'sll':0b000000
}

def reg_num(r):
    return REG[r]

def encode_R(mn, rd, rs, rt, shamt=0):
    opcode = 0
    funct = FUNCTS[mn]
    return f"{opcode:06b}{reg_num(rs):05b}{reg_num(rt):05b}{reg_num(rd):05b}{shamt:05b}{funct:06b}"

def encode_I(mn, rt, rs, imm):
    opcode = OPCODES[mn]
    return f"{opcode:06b}{reg_num(rs):05b}{reg_num(rt):05b}{imm & 0xffff:016b}"

def encode_J(addr):
    opcode = 0b000010
    return f"{opcode:06b}{addr & 0x03ffffff:026b}"

# 2. Insertion sort source
src = "Assembler/inser.txt".splitlines()

# 3. First pass: build symbol table
symbols = {}
pc = 0x00400000
text_mode = False

for line in src:
    l = line.strip()
    if l.startswith('.text'):
        text_mode = True
        continue
    if not text_mode: continue
    if l.endswith(':'):
        symbols[l[:-1]] = pc
    elif l and not l.startswith('.'):
        pc += 4

# 4. Second pass: assemble
pc = 0x00400000
machine = []
for line in src:
    l = line.split('#')[0].strip()
    if not text_mode and l.startswith('.text'):
        text_mode = True
        continue
    if not text_mode or not l or l.endswith(':') or l.startswith('.'):
        continue
    parts = l.replace(',', ' ').split()
    op = parts[0]
    codes = []
    if op == 'la':
        rt, lbl = parts[1], parts[2]
        addr = symbols[lbl]
        hi, lo = (addr>>16)&0xffff, addr&0xffff
        codes.append(encode_I('addi', rt, '$zero', hi<<16>>16))  # pseudo
    elif op == 'lw':
        rt, mem = parts[1], parts[2]
        off, rs = mem.replace(')','').split('(')
        codes.append(encode_I('lw', rt, rs, int(off)))
    elif op == 'li':
        rt, imm = parts[1], int(parts[2])
        codes.append(encode_I('addi', rt, '$zero', imm))
    elif op in ('bge','blt'):
        rs, rt, lbl = parts[1], parts[2], parts[3]
        target = symbols[lbl]
        offset = (target - (pc+4))//4
        codes.append(encode_I(op, rt, rs, offset))
    elif op == 'ble':
        rt, rs, lbl = parts[1], parts[2], parts[3]
        target = symbols[lbl]
        offset = (target - (pc+4))//4
        codes.append(encode_I('bge', rt, rs, offset))
    elif op == 'sll':
        rd, rs, sh = parts[1], parts[2], int(parts[3])
        codes.append(encode_R('sll', rd, '$zero', rs, sh))
    elif op == 'add':
        rd, rs, rt = parts[1], parts[2], parts[3]
        codes.append(encode_R('add', rd, rs, rt))
    elif op in ('addi','addiu'):
        rt, rs, imm = parts[1], parts[2], int(parts[3])
        codes.append(encode_I('addi', rt, rs, imm))
    elif op == 'sw':
        rt, mem = parts[1], parts[2]
        off, rs = mem.replace(')','').split('(')
        codes.append(encode_I('sw', rt, rs, int(off)))
    elif op == 'j':
        lbl = parts[1]
        addr = symbols[lbl]//4
        codes.append(encode_J(addr))
    # syscall => 00000000000000000000000000001100
    elif op == 'syscall':
        codes.append('00000000000000000000000000001100')
    else:
        # skip
        pass

    for code in codes:
        machine.append(f"{pc:08x}: {code}    # {l}")
    pc += 4

# 5. Display the machine code

with open("bin.txt", "w") as f:
    for line in machine:
        f.write(line + "\n")