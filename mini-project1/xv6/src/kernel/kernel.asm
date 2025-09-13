
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	c9010113          	addi	sp,sp,-880 # 80008c90 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000024:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000028:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037961b          	slliw	a2,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	963a                	add	a2,a2,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f46b7          	lui	a3,0xf4
    80000040:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9736                	add	a4,a4,a3
    80000046:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00279713          	slli	a4,a5,0x2
    8000004c:	973e                	add	a4,a4,a5
    8000004e:	070e                	slli	a4,a4,0x3
    80000050:	00009797          	auipc	a5,0x9
    80000054:	b0078793          	addi	a5,a5,-1280 # 80008b50 <timer_scratch>
    80000058:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    8000005c:	f394                	sd	a3,32(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	61e78793          	addi	a5,a5,1566 # 80006680 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	60a2                	ld	ra,8(sp)
    80000088:	6402                	ld	s0,0(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb1697>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	e6078793          	addi	a5,a5,-416 # 80000f0e <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	711d                	addi	sp,sp,-96
    80000104:	ec86                	sd	ra,88(sp)
    80000106:	e8a2                	sd	s0,80(sp)
    80000108:	e0ca                	sd	s2,64(sp)
    8000010a:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    8000010c:	04c05b63          	blez	a2,80000162 <consolewrite+0x60>
    80000110:	e4a6                	sd	s1,72(sp)
    80000112:	fc4e                	sd	s3,56(sp)
    80000114:	f852                	sd	s4,48(sp)
    80000116:	f456                	sd	s5,40(sp)
    80000118:	f05a                	sd	s6,32(sp)
    8000011a:	ec5e                	sd	s7,24(sp)
    8000011c:	8a2a                	mv	s4,a0
    8000011e:	84ae                	mv	s1,a1
    80000120:	89b2                	mv	s3,a2
    80000122:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000124:	faf40b93          	addi	s7,s0,-81
    80000128:	4b05                	li	s6,1
    8000012a:	5afd                	li	s5,-1
    8000012c:	86da                	mv	a3,s6
    8000012e:	8626                	mv	a2,s1
    80000130:	85d2                	mv	a1,s4
    80000132:	855e                	mv	a0,s7
    80000134:	00002097          	auipc	ra,0x2
    80000138:	7cc080e7          	jalr	1996(ra) # 80002900 <either_copyin>
    8000013c:	03550563          	beq	a0,s5,80000166 <consolewrite+0x64>
      break;
    uartputc(c);
    80000140:	faf44503          	lbu	a0,-81(s0)
    80000144:	00000097          	auipc	ra,0x0
    80000148:	7d8080e7          	jalr	2008(ra) # 8000091c <uartputc>
  for(i = 0; i < n; i++){
    8000014c:	2905                	addiw	s2,s2,1
    8000014e:	0485                	addi	s1,s1,1
    80000150:	fd299ee3          	bne	s3,s2,8000012c <consolewrite+0x2a>
    80000154:	64a6                	ld	s1,72(sp)
    80000156:	79e2                	ld	s3,56(sp)
    80000158:	7a42                	ld	s4,48(sp)
    8000015a:	7aa2                	ld	s5,40(sp)
    8000015c:	7b02                	ld	s6,32(sp)
    8000015e:	6be2                	ld	s7,24(sp)
    80000160:	a809                	j	80000172 <consolewrite+0x70>
    80000162:	4901                	li	s2,0
    80000164:	a039                	j	80000172 <consolewrite+0x70>
    80000166:	64a6                	ld	s1,72(sp)
    80000168:	79e2                	ld	s3,56(sp)
    8000016a:	7a42                	ld	s4,48(sp)
    8000016c:	7aa2                	ld	s5,40(sp)
    8000016e:	7b02                	ld	s6,32(sp)
    80000170:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80000172:	854a                	mv	a0,s2
    80000174:	60e6                	ld	ra,88(sp)
    80000176:	6446                	ld	s0,80(sp)
    80000178:	6906                	ld	s2,64(sp)
    8000017a:	6125                	addi	sp,sp,96
    8000017c:	8082                	ret

000000008000017e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000017e:	711d                	addi	sp,sp,-96
    80000180:	ec86                	sd	ra,88(sp)
    80000182:	e8a2                	sd	s0,80(sp)
    80000184:	e4a6                	sd	s1,72(sp)
    80000186:	e0ca                	sd	s2,64(sp)
    80000188:	fc4e                	sd	s3,56(sp)
    8000018a:	f852                	sd	s4,48(sp)
    8000018c:	f05a                	sd	s6,32(sp)
    8000018e:	ec5e                	sd	s7,24(sp)
    80000190:	1080                	addi	s0,sp,96
    80000192:	8b2a                	mv	s6,a0
    80000194:	8a2e                	mv	s4,a1
    80000196:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000198:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    8000019a:	00011517          	auipc	a0,0x11
    8000019e:	af650513          	addi	a0,a0,-1290 # 80010c90 <cons>
    800001a2:	00001097          	auipc	ra,0x1
    800001a6:	aba080e7          	jalr	-1350(ra) # 80000c5c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001aa:	00011497          	auipc	s1,0x11
    800001ae:	ae648493          	addi	s1,s1,-1306 # 80010c90 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001b2:	00011917          	auipc	s2,0x11
    800001b6:	b7690913          	addi	s2,s2,-1162 # 80010d28 <cons+0x98>
  while(n > 0){
    800001ba:	0d305563          	blez	s3,80000284 <consoleread+0x106>
    while(cons.r == cons.w){
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	0af71a63          	bne	a4,a5,8000027a <consoleread+0xfc>
      if(killed(myproc())){
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	9c2080e7          	jalr	-1598(ra) # 80001b8c <myproc>
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	57e080e7          	jalr	1406(ra) # 80002750 <killed>
    800001da:	e52d                	bnez	a0,80000244 <consoleread+0xc6>
      sleep(&cons.r, &cons.lock);
    800001dc:	85a6                	mv	a1,s1
    800001de:	854a                	mv	a0,s2
    800001e0:	00002097          	auipc	ra,0x2
    800001e4:	21c080e7          	jalr	540(ra) # 800023fc <sleep>
    while(cons.r == cons.w){
    800001e8:	0984a783          	lw	a5,152(s1)
    800001ec:	09c4a703          	lw	a4,156(s1)
    800001f0:	fcf70de3          	beq	a4,a5,800001ca <consoleread+0x4c>
    800001f4:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f6:	00011717          	auipc	a4,0x11
    800001fa:	a9a70713          	addi	a4,a4,-1382 # 80010c90 <cons>
    800001fe:	0017869b          	addiw	a3,a5,1
    80000202:	08d72c23          	sw	a3,152(a4)
    80000206:	07f7f693          	andi	a3,a5,127
    8000020a:	9736                	add	a4,a4,a3
    8000020c:	01874703          	lbu	a4,24(a4)
    80000210:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    80000214:	4691                	li	a3,4
    80000216:	04da8a63          	beq	s5,a3,8000026a <consoleread+0xec>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000021a:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000021e:	4685                	li	a3,1
    80000220:	faf40613          	addi	a2,s0,-81
    80000224:	85d2                	mv	a1,s4
    80000226:	855a                	mv	a0,s6
    80000228:	00002097          	auipc	ra,0x2
    8000022c:	682080e7          	jalr	1666(ra) # 800028aa <either_copyout>
    80000230:	57fd                	li	a5,-1
    80000232:	04f50863          	beq	a0,a5,80000282 <consoleread+0x104>
      break;

    dst++;
    80000236:	0a05                	addi	s4,s4,1
    --n;
    80000238:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000023a:	47a9                	li	a5,10
    8000023c:	04fa8f63          	beq	s5,a5,8000029a <consoleread+0x11c>
    80000240:	7aa2                	ld	s5,40(sp)
    80000242:	bfa5                	j	800001ba <consoleread+0x3c>
        release(&cons.lock);
    80000244:	00011517          	auipc	a0,0x11
    80000248:	a4c50513          	addi	a0,a0,-1460 # 80010c90 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	ac0080e7          	jalr	-1344(ra) # 80000d0c <release>
        return -1;
    80000254:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000256:	60e6                	ld	ra,88(sp)
    80000258:	6446                	ld	s0,80(sp)
    8000025a:	64a6                	ld	s1,72(sp)
    8000025c:	6906                	ld	s2,64(sp)
    8000025e:	79e2                	ld	s3,56(sp)
    80000260:	7a42                	ld	s4,48(sp)
    80000262:	7b02                	ld	s6,32(sp)
    80000264:	6be2                	ld	s7,24(sp)
    80000266:	6125                	addi	sp,sp,96
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0179fa63          	bgeu	s3,s7,8000027e <consoleread+0x100>
        cons.r--;
    8000026e:	00011717          	auipc	a4,0x11
    80000272:	aaf72d23          	sw	a5,-1350(a4) # 80010d28 <cons+0x98>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	a031                	j	80000284 <consoleread+0x106>
    8000027a:	f456                	sd	s5,40(sp)
    8000027c:	bfad                	j	800001f6 <consoleread+0x78>
    8000027e:	7aa2                	ld	s5,40(sp)
    80000280:	a011                	j	80000284 <consoleread+0x106>
    80000282:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000284:	00011517          	auipc	a0,0x11
    80000288:	a0c50513          	addi	a0,a0,-1524 # 80010c90 <cons>
    8000028c:	00001097          	auipc	ra,0x1
    80000290:	a80080e7          	jalr	-1408(ra) # 80000d0c <release>
  return target - n;
    80000294:	413b853b          	subw	a0,s7,s3
    80000298:	bf7d                	j	80000256 <consoleread+0xd8>
    8000029a:	7aa2                	ld	s5,40(sp)
    8000029c:	b7e5                	j	80000284 <consoleread+0x106>

000000008000029e <consputc>:
{
    8000029e:	1141                	addi	sp,sp,-16
    800002a0:	e406                	sd	ra,8(sp)
    800002a2:	e022                	sd	s0,0(sp)
    800002a4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800002a6:	10000793          	li	a5,256
    800002aa:	00f50a63          	beq	a0,a5,800002be <consputc+0x20>
    uartputc_sync(c);
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	590080e7          	jalr	1424(ra) # 8000083e <uartputc_sync>
}
    800002b6:	60a2                	ld	ra,8(sp)
    800002b8:	6402                	ld	s0,0(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002be:	4521                	li	a0,8
    800002c0:	00000097          	auipc	ra,0x0
    800002c4:	57e080e7          	jalr	1406(ra) # 8000083e <uartputc_sync>
    800002c8:	02000513          	li	a0,32
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	572080e7          	jalr	1394(ra) # 8000083e <uartputc_sync>
    800002d4:	4521                	li	a0,8
    800002d6:	00000097          	auipc	ra,0x0
    800002da:	568080e7          	jalr	1384(ra) # 8000083e <uartputc_sync>
    800002de:	bfe1                	j	800002b6 <consputc+0x18>

00000000800002e0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002e0:	1101                	addi	sp,sp,-32
    800002e2:	ec06                	sd	ra,24(sp)
    800002e4:	e822                	sd	s0,16(sp)
    800002e6:	e426                	sd	s1,8(sp)
    800002e8:	1000                	addi	s0,sp,32
    800002ea:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ec:	00011517          	auipc	a0,0x11
    800002f0:	9a450513          	addi	a0,a0,-1628 # 80010c90 <cons>
    800002f4:	00001097          	auipc	ra,0x1
    800002f8:	968080e7          	jalr	-1688(ra) # 80000c5c <acquire>

  switch(c){
    800002fc:	47d5                	li	a5,21
    800002fe:	0af48363          	beq	s1,a5,800003a4 <consoleintr+0xc4>
    80000302:	0297c963          	blt	a5,s1,80000334 <consoleintr+0x54>
    80000306:	47a1                	li	a5,8
    80000308:	0ef48a63          	beq	s1,a5,800003fc <consoleintr+0x11c>
    8000030c:	47c1                	li	a5,16
    8000030e:	10f49d63          	bne	s1,a5,80000428 <consoleintr+0x148>
  case C('P'):  // Print process list.
    procdump();
    80000312:	00002097          	auipc	ra,0x2
    80000316:	644080e7          	jalr	1604(ra) # 80002956 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000031a:	00011517          	auipc	a0,0x11
    8000031e:	97650513          	addi	a0,a0,-1674 # 80010c90 <cons>
    80000322:	00001097          	auipc	ra,0x1
    80000326:	9ea080e7          	jalr	-1558(ra) # 80000d0c <release>
}
    8000032a:	60e2                	ld	ra,24(sp)
    8000032c:	6442                	ld	s0,16(sp)
    8000032e:	64a2                	ld	s1,8(sp)
    80000330:	6105                	addi	sp,sp,32
    80000332:	8082                	ret
  switch(c){
    80000334:	07f00793          	li	a5,127
    80000338:	0cf48263          	beq	s1,a5,800003fc <consoleintr+0x11c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000033c:	00011717          	auipc	a4,0x11
    80000340:	95470713          	addi	a4,a4,-1708 # 80010c90 <cons>
    80000344:	0a072783          	lw	a5,160(a4)
    80000348:	09872703          	lw	a4,152(a4)
    8000034c:	9f99                	subw	a5,a5,a4
    8000034e:	07f00713          	li	a4,127
    80000352:	fcf764e3          	bltu	a4,a5,8000031a <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80000356:	47b5                	li	a5,13
    80000358:	0cf48b63          	beq	s1,a5,8000042e <consoleintr+0x14e>
      consputc(c);
    8000035c:	8526                	mv	a0,s1
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	f40080e7          	jalr	-192(ra) # 8000029e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000366:	00011717          	auipc	a4,0x11
    8000036a:	92a70713          	addi	a4,a4,-1750 # 80010c90 <cons>
    8000036e:	0a072683          	lw	a3,160(a4)
    80000372:	0016879b          	addiw	a5,a3,1
    80000376:	863e                	mv	a2,a5
    80000378:	0af72023          	sw	a5,160(a4)
    8000037c:	07f6f693          	andi	a3,a3,127
    80000380:	9736                	add	a4,a4,a3
    80000382:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000386:	ff648713          	addi	a4,s1,-10
    8000038a:	cb61                	beqz	a4,8000045a <consoleintr+0x17a>
    8000038c:	14f1                	addi	s1,s1,-4
    8000038e:	c4f1                	beqz	s1,8000045a <consoleintr+0x17a>
    80000390:	00011717          	auipc	a4,0x11
    80000394:	99872703          	lw	a4,-1640(a4) # 80010d28 <cons+0x98>
    80000398:	9f99                	subw	a5,a5,a4
    8000039a:	08000713          	li	a4,128
    8000039e:	f6e79ee3          	bne	a5,a4,8000031a <consoleintr+0x3a>
    800003a2:	a865                	j	8000045a <consoleintr+0x17a>
    800003a4:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800003a6:	00011717          	auipc	a4,0x11
    800003aa:	8ea70713          	addi	a4,a4,-1814 # 80010c90 <cons>
    800003ae:	0a072783          	lw	a5,160(a4)
    800003b2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003b6:	00011497          	auipc	s1,0x11
    800003ba:	8da48493          	addi	s1,s1,-1830 # 80010c90 <cons>
    while(cons.e != cons.w &&
    800003be:	4929                	li	s2,10
    800003c0:	02f70a63          	beq	a4,a5,800003f4 <consoleintr+0x114>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003c4:	37fd                	addiw	a5,a5,-1
    800003c6:	07f7f713          	andi	a4,a5,127
    800003ca:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003cc:	01874703          	lbu	a4,24(a4)
    800003d0:	03270463          	beq	a4,s2,800003f8 <consoleintr+0x118>
      cons.e--;
    800003d4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003d8:	10000513          	li	a0,256
    800003dc:	00000097          	auipc	ra,0x0
    800003e0:	ec2080e7          	jalr	-318(ra) # 8000029e <consputc>
    while(cons.e != cons.w &&
    800003e4:	0a04a783          	lw	a5,160(s1)
    800003e8:	09c4a703          	lw	a4,156(s1)
    800003ec:	fcf71ce3          	bne	a4,a5,800003c4 <consoleintr+0xe4>
    800003f0:	6902                	ld	s2,0(sp)
    800003f2:	b725                	j	8000031a <consoleintr+0x3a>
    800003f4:	6902                	ld	s2,0(sp)
    800003f6:	b715                	j	8000031a <consoleintr+0x3a>
    800003f8:	6902                	ld	s2,0(sp)
    800003fa:	b705                	j	8000031a <consoleintr+0x3a>
    if(cons.e != cons.w){
    800003fc:	00011717          	auipc	a4,0x11
    80000400:	89470713          	addi	a4,a4,-1900 # 80010c90 <cons>
    80000404:	0a072783          	lw	a5,160(a4)
    80000408:	09c72703          	lw	a4,156(a4)
    8000040c:	f0f707e3          	beq	a4,a5,8000031a <consoleintr+0x3a>
      cons.e--;
    80000410:	37fd                	addiw	a5,a5,-1
    80000412:	00011717          	auipc	a4,0x11
    80000416:	90f72f23          	sw	a5,-1762(a4) # 80010d30 <cons+0xa0>
      consputc(BACKSPACE);
    8000041a:	10000513          	li	a0,256
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	e80080e7          	jalr	-384(ra) # 8000029e <consputc>
    80000426:	bdd5                	j	8000031a <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000428:	ee0489e3          	beqz	s1,8000031a <consoleintr+0x3a>
    8000042c:	bf01                	j	8000033c <consoleintr+0x5c>
      consputc(c);
    8000042e:	4529                	li	a0,10
    80000430:	00000097          	auipc	ra,0x0
    80000434:	e6e080e7          	jalr	-402(ra) # 8000029e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000438:	00011797          	auipc	a5,0x11
    8000043c:	85878793          	addi	a5,a5,-1960 # 80010c90 <cons>
    80000440:	0a07a703          	lw	a4,160(a5)
    80000444:	0017069b          	addiw	a3,a4,1
    80000448:	8636                	mv	a2,a3
    8000044a:	0ad7a023          	sw	a3,160(a5)
    8000044e:	07f77713          	andi	a4,a4,127
    80000452:	97ba                	add	a5,a5,a4
    80000454:	4729                	li	a4,10
    80000456:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000045a:	00011797          	auipc	a5,0x11
    8000045e:	8cc7a923          	sw	a2,-1838(a5) # 80010d2c <cons+0x9c>
        wakeup(&cons.r);
    80000462:	00011517          	auipc	a0,0x11
    80000466:	8c650513          	addi	a0,a0,-1850 # 80010d28 <cons+0x98>
    8000046a:	00002097          	auipc	ra,0x2
    8000046e:	ff6080e7          	jalr	-10(ra) # 80002460 <wakeup>
    80000472:	b565                	j	8000031a <consoleintr+0x3a>

0000000080000474 <consoleinit>:

void
consoleinit(void)
{
    80000474:	1141                	addi	sp,sp,-16
    80000476:	e406                	sd	ra,8(sp)
    80000478:	e022                	sd	s0,0(sp)
    8000047a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000047c:	00008597          	auipc	a1,0x8
    80000480:	b8458593          	addi	a1,a1,-1148 # 80008000 <etext>
    80000484:	00011517          	auipc	a0,0x11
    80000488:	80c50513          	addi	a0,a0,-2036 # 80010c90 <cons>
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	736080e7          	jalr	1846(ra) # 80000bc2 <initlock>

  uartinit();
    80000494:	00000097          	auipc	ra,0x0
    80000498:	350080e7          	jalr	848(ra) # 800007e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000049c:	0004c797          	auipc	a5,0x4c
    800004a0:	b3478793          	addi	a5,a5,-1228 # 8004bfd0 <devsw>
    800004a4:	00000717          	auipc	a4,0x0
    800004a8:	cda70713          	addi	a4,a4,-806 # 8000017e <consoleread>
    800004ac:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004ae:	00000717          	auipc	a4,0x0
    800004b2:	c5470713          	addi	a4,a4,-940 # 80000102 <consolewrite>
    800004b6:	ef98                	sd	a4,24(a5)
}
    800004b8:	60a2                	ld	ra,8(sp)
    800004ba:	6402                	ld	s0,0(sp)
    800004bc:	0141                	addi	sp,sp,16
    800004be:	8082                	ret

00000000800004c0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004c0:	7179                	addi	sp,sp,-48
    800004c2:	f406                	sd	ra,40(sp)
    800004c4:	f022                	sd	s0,32(sp)
    800004c6:	e84a                	sd	s2,16(sp)
    800004c8:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004ca:	c219                	beqz	a2,800004d0 <printint+0x10>
    800004cc:	08054563          	bltz	a0,80000556 <printint+0x96>
    x = -xx;
  else
    x = xx;
    800004d0:	4301                	li	t1,0

  i = 0;
    800004d2:	fd040913          	addi	s2,s0,-48
    x = xx;
    800004d6:	86ca                	mv	a3,s2
  i = 0;
    800004d8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004da:	00008817          	auipc	a6,0x8
    800004de:	3f680813          	addi	a6,a6,1014 # 800088d0 <digits>
    800004e2:	88ba                	mv	a7,a4
    800004e4:	0017061b          	addiw	a2,a4,1
    800004e8:	8732                	mv	a4,a2
    800004ea:	02b577bb          	remuw	a5,a0,a1
    800004ee:	1782                	slli	a5,a5,0x20
    800004f0:	9381                	srli	a5,a5,0x20
    800004f2:	97c2                	add	a5,a5,a6
    800004f4:	0007c783          	lbu	a5,0(a5)
    800004f8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004fc:	87aa                	mv	a5,a0
    800004fe:	02b5553b          	divuw	a0,a0,a1
    80000502:	0685                	addi	a3,a3,1
    80000504:	fcb7ffe3          	bgeu	a5,a1,800004e2 <printint+0x22>

  if(sign)
    80000508:	00030c63          	beqz	t1,80000520 <printint+0x60>
    buf[i++] = '-';
    8000050c:	fe060793          	addi	a5,a2,-32
    80000510:	00878633          	add	a2,a5,s0
    80000514:	02d00793          	li	a5,45
    80000518:	fef60823          	sb	a5,-16(a2)
    8000051c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    80000520:	02e05663          	blez	a4,8000054c <printint+0x8c>
    80000524:	ec26                	sd	s1,24(sp)
    80000526:	377d                	addiw	a4,a4,-1
    80000528:	00e904b3          	add	s1,s2,a4
    8000052c:	197d                	addi	s2,s2,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	1702                	slli	a4,a4,0x20
    80000532:	9301                	srli	a4,a4,0x20
    80000534:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000538:	0004c503          	lbu	a0,0(s1)
    8000053c:	00000097          	auipc	ra,0x0
    80000540:	d62080e7          	jalr	-670(ra) # 8000029e <consputc>
  while(--i >= 0)
    80000544:	14fd                	addi	s1,s1,-1
    80000546:	ff2499e3          	bne	s1,s2,80000538 <printint+0x78>
    8000054a:	64e2                	ld	s1,24(sp)
}
    8000054c:	70a2                	ld	ra,40(sp)
    8000054e:	7402                	ld	s0,32(sp)
    80000550:	6942                	ld	s2,16(sp)
    80000552:	6145                	addi	sp,sp,48
    80000554:	8082                	ret
    x = -xx;
    80000556:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055a:	4305                	li	t1,1
    x = -xx;
    8000055c:	bf9d                	j	800004d2 <printint+0x12>

000000008000055e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000055e:	1101                	addi	sp,sp,-32
    80000560:	ec06                	sd	ra,24(sp)
    80000562:	e822                	sd	s0,16(sp)
    80000564:	e426                	sd	s1,8(sp)
    80000566:	1000                	addi	s0,sp,32
    80000568:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056a:	00010797          	auipc	a5,0x10
    8000056e:	7e07a323          	sw	zero,2022(a5) # 80010d50 <pr+0x18>
  printf("panic: ");
    80000572:	00008517          	auipc	a0,0x8
    80000576:	a9650513          	addi	a0,a0,-1386 # 80008008 <etext+0x8>
    8000057a:	00000097          	auipc	ra,0x0
    8000057e:	02e080e7          	jalr	46(ra) # 800005a8 <printf>
  printf(s);
    80000582:	8526                	mv	a0,s1
    80000584:	00000097          	auipc	ra,0x0
    80000588:	024080e7          	jalr	36(ra) # 800005a8 <printf>
  printf("\n");
    8000058c:	00008517          	auipc	a0,0x8
    80000590:	a8450513          	addi	a0,a0,-1404 # 80008010 <etext+0x10>
    80000594:	00000097          	auipc	ra,0x0
    80000598:	014080e7          	jalr	20(ra) # 800005a8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059c:	4785                	li	a5,1
    8000059e:	00008717          	auipc	a4,0x8
    800005a2:	56f72123          	sw	a5,1378(a4) # 80008b00 <panicked>
  for(;;)
    800005a6:	a001                	j	800005a6 <panic+0x48>

00000000800005a8 <printf>:
{
    800005a8:	7131                	addi	sp,sp,-192
    800005aa:	fc86                	sd	ra,120(sp)
    800005ac:	f8a2                	sd	s0,112(sp)
    800005ae:	e8d2                	sd	s4,80(sp)
    800005b0:	ec6e                	sd	s11,24(sp)
    800005b2:	0100                	addi	s0,sp,128
    800005b4:	8a2a                	mv	s4,a0
    800005b6:	e40c                	sd	a1,8(s0)
    800005b8:	e810                	sd	a2,16(s0)
    800005ba:	ec14                	sd	a3,24(s0)
    800005bc:	f018                	sd	a4,32(s0)
    800005be:	f41c                	sd	a5,40(s0)
    800005c0:	03043823          	sd	a6,48(s0)
    800005c4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c8:	00010d97          	auipc	s11,0x10
    800005cc:	788dad83          	lw	s11,1928(s11) # 80010d50 <pr+0x18>
  if(locking)
    800005d0:	040d9463          	bnez	s11,80000618 <printf+0x70>
  if (fmt == 0)
    800005d4:	040a0b63          	beqz	s4,8000062a <printf+0x82>
  va_start(ap, fmt);
    800005d8:	00840793          	addi	a5,s0,8
    800005dc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e0:	000a4503          	lbu	a0,0(s4)
    800005e4:	18050c63          	beqz	a0,8000077c <printf+0x1d4>
    800005e8:	f4a6                	sd	s1,104(sp)
    800005ea:	f0ca                	sd	s2,96(sp)
    800005ec:	ecce                	sd	s3,88(sp)
    800005ee:	e4d6                	sd	s5,72(sp)
    800005f0:	e0da                	sd	s6,64(sp)
    800005f2:	fc5e                	sd	s7,56(sp)
    800005f4:	f862                	sd	s8,48(sp)
    800005f6:	f466                	sd	s9,40(sp)
    800005f8:	f06a                	sd	s10,32(sp)
    800005fa:	4981                	li	s3,0
    if(c != '%'){
    800005fc:	02500b13          	li	s6,37
    switch(c){
    80000600:	07000b93          	li	s7,112
  consputc('x');
    80000604:	07800c93          	li	s9,120
    80000608:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000060a:	00008a97          	auipc	s5,0x8
    8000060e:	2c6a8a93          	addi	s5,s5,710 # 800088d0 <digits>
    switch(c){
    80000612:	07300c13          	li	s8,115
    80000616:	a0b9                	j	80000664 <printf+0xbc>
    acquire(&pr.lock);
    80000618:	00010517          	auipc	a0,0x10
    8000061c:	72050513          	addi	a0,a0,1824 # 80010d38 <pr>
    80000620:	00000097          	auipc	ra,0x0
    80000624:	63c080e7          	jalr	1596(ra) # 80000c5c <acquire>
    80000628:	b775                	j	800005d4 <printf+0x2c>
    8000062a:	f4a6                	sd	s1,104(sp)
    8000062c:	f0ca                	sd	s2,96(sp)
    8000062e:	ecce                	sd	s3,88(sp)
    80000630:	e4d6                	sd	s5,72(sp)
    80000632:	e0da                	sd	s6,64(sp)
    80000634:	fc5e                	sd	s7,56(sp)
    80000636:	f862                	sd	s8,48(sp)
    80000638:	f466                	sd	s9,40(sp)
    8000063a:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    8000063c:	00008517          	auipc	a0,0x8
    80000640:	9e450513          	addi	a0,a0,-1564 # 80008020 <etext+0x20>
    80000644:	00000097          	auipc	ra,0x0
    80000648:	f1a080e7          	jalr	-230(ra) # 8000055e <panic>
      consputc(c);
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	c52080e7          	jalr	-942(ra) # 8000029e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000654:	0019879b          	addiw	a5,s3,1
    80000658:	89be                	mv	s3,a5
    8000065a:	97d2                	add	a5,a5,s4
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c2>
    if(c != '%'){
    80000664:	ff6514e3          	bne	a0,s6,8000064c <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	0019879b          	addiw	a5,s3,1
    8000066c:	89be                	mv	s3,a5
    8000066e:	97d2                	add	a5,a5,s4
    80000670:	0007c783          	lbu	a5,0(a5)
    80000674:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000678:	10078a63          	beqz	a5,8000078c <printf+0x1e4>
    switch(c){
    8000067c:	05778a63          	beq	a5,s7,800006d0 <printf+0x128>
    80000680:	02fbf463          	bgeu	s7,a5,800006a8 <printf+0x100>
    80000684:	09878763          	beq	a5,s8,80000712 <printf+0x16a>
    80000688:	0d979663          	bne	a5,s9,80000754 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4605                	li	a2,1
    8000069a:	85ea                	mv	a1,s10
    8000069c:	4388                	lw	a0,0(a5)
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	e22080e7          	jalr	-478(ra) # 800004c0 <printint>
      break;
    800006a6:	b77d                	j	80000654 <printf+0xac>
    switch(c){
    800006a8:	0b678063          	beq	a5,s6,80000748 <printf+0x1a0>
    800006ac:	06400713          	li	a4,100
    800006b0:	0ae79263          	bne	a5,a4,80000754 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    800006b4:	f8843783          	ld	a5,-120(s0)
    800006b8:	00878713          	addi	a4,a5,8
    800006bc:	f8e43423          	sd	a4,-120(s0)
    800006c0:	4605                	li	a2,1
    800006c2:	45a9                	li	a1,10
    800006c4:	4388                	lw	a0,0(a5)
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	dfa080e7          	jalr	-518(ra) # 800004c0 <printint>
      break;
    800006ce:	b759                	j	80000654 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006d0:	f8843783          	ld	a5,-120(s0)
    800006d4:	00878713          	addi	a4,a5,8
    800006d8:	f8e43423          	sd	a4,-120(s0)
    800006dc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006e0:	03000513          	li	a0,48
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	bba080e7          	jalr	-1094(ra) # 8000029e <consputc>
  consputc('x');
    800006ec:	8566                	mv	a0,s9
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	bb0080e7          	jalr	-1104(ra) # 8000029e <consputc>
    800006f6:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b9c080e7          	jalr	-1124(ra) # 8000029e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x150>
    80000710:	b791                	j	80000654 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x192>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d51d                	beqz	a0,80000654 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b76080e7          	jalr	-1162(ra) # 8000029e <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x180>
    80000738:	bf31                	j	80000654 <printf+0xac>
        s = "(null)";
    8000073a:	00008497          	auipc	s1,0x8
    8000073e:	8de48493          	addi	s1,s1,-1826 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x180>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b54080e7          	jalr	-1196(ra) # 8000029e <consputc>
      break;
    80000752:	b709                	j	80000654 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b48080e7          	jalr	-1208(ra) # 8000029e <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b3e080e7          	jalr	-1218(ra) # 8000029e <consputc>
      break;
    80000768:	b5f5                	j	80000654 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	7d02                	ld	s10,32(sp)
  if(locking)
    8000077c:	020d9263          	bnez	s11,800007a0 <printf+0x1f8>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6de2                	ld	s11,24(sp)
    80000788:	6129                	addi	sp,sp,192
    8000078a:	8082                	ret
    8000078c:	74a6                	ld	s1,104(sp)
    8000078e:	7906                	ld	s2,96(sp)
    80000790:	69e6                	ld	s3,88(sp)
    80000792:	6aa6                	ld	s5,72(sp)
    80000794:	6b06                	ld	s6,64(sp)
    80000796:	7be2                	ld	s7,56(sp)
    80000798:	7c42                	ld	s8,48(sp)
    8000079a:	7ca2                	ld	s9,40(sp)
    8000079c:	7d02                	ld	s10,32(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d4>
    release(&pr.lock);
    800007a0:	00010517          	auipc	a0,0x10
    800007a4:	59850513          	addi	a0,a0,1432 # 80010d38 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	564080e7          	jalr	1380(ra) # 80000d0c <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d8>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1141                	addi	sp,sp,-16
    800007b4:	e406                	sd	ra,8(sp)
    800007b6:	e022                	sd	s0,0(sp)
    800007b8:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    800007ba:	00008597          	auipc	a1,0x8
    800007be:	87658593          	addi	a1,a1,-1930 # 80008030 <etext+0x30>
    800007c2:	00010517          	auipc	a0,0x10
    800007c6:	57650513          	addi	a0,a0,1398 # 80010d38 <pr>
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	3f8080e7          	jalr	1016(ra) # 80000bc2 <initlock>
  pr.locking = 1;
    800007d2:	4785                	li	a5,1
    800007d4:	00010717          	auipc	a4,0x10
    800007d8:	56f72e23          	sw	a5,1404(a4) # 80010d50 <pr+0x18>
}
    800007dc:	60a2                	ld	ra,8(sp)
    800007de:	6402                	ld	s0,0(sp)
    800007e0:	0141                	addi	sp,sp,16
    800007e2:	8082                	ret

00000000800007e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e406                	sd	ra,8(sp)
    800007e8:	e022                	sd	s0,0(sp)
    800007ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ec:	100007b7          	lui	a5,0x10000
    800007f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f4:	10000737          	lui	a4,0x10000
    800007f8:	f8000693          	li	a3,-128
    800007fc:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000800:	468d                	li	a3,3
    80000802:	10000637          	lui	a2,0x10000
    80000806:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000080e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000812:	8732                	mv	a4,a2
    80000814:	461d                	li	a2,7
    80000816:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081a:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000081e:	00008597          	auipc	a1,0x8
    80000822:	81a58593          	addi	a1,a1,-2022 # 80008038 <etext+0x38>
    80000826:	00010517          	auipc	a0,0x10
    8000082a:	53250513          	addi	a0,a0,1330 # 80010d58 <uart_tx_lock>
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	394080e7          	jalr	916(ra) # 80000bc2 <initlock>
}
    80000836:	60a2                	ld	ra,8(sp)
    80000838:	6402                	ld	s0,0(sp)
    8000083a:	0141                	addi	sp,sp,16
    8000083c:	8082                	ret

000000008000083e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000083e:	1101                	addi	sp,sp,-32
    80000840:	ec06                	sd	ra,24(sp)
    80000842:	e822                	sd	s0,16(sp)
    80000844:	e426                	sd	s1,8(sp)
    80000846:	1000                	addi	s0,sp,32
    80000848:	84aa                	mv	s1,a0
  push_off();
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	3c2080e7          	jalr	962(ra) # 80000c0c <push_off>

  if(panicked){
    80000852:	00008797          	auipc	a5,0x8
    80000856:	2ae7a783          	lw	a5,686(a5) # 80008b00 <panicked>
    8000085a:	eb85                	bnez	a5,8000088a <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085c:	10000737          	lui	a4,0x10000
    80000860:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000862:	00074783          	lbu	a5,0(a4)
    80000866:	0207f793          	andi	a5,a5,32
    8000086a:	dfe5                	beqz	a5,80000862 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086c:	0ff4f513          	zext.b	a0,s1
    80000870:	100007b7          	lui	a5,0x10000
    80000874:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	438080e7          	jalr	1080(ra) # 80000cb0 <pop_off>
}
    80000880:	60e2                	ld	ra,24(sp)
    80000882:	6442                	ld	s0,16(sp)
    80000884:	64a2                	ld	s1,8(sp)
    80000886:	6105                	addi	sp,sp,32
    80000888:	8082                	ret
    for(;;)
    8000088a:	a001                	j	8000088a <uartputc_sync+0x4c>

000000008000088c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088c:	00008797          	auipc	a5,0x8
    80000890:	27c7b783          	ld	a5,636(a5) # 80008b08 <uart_tx_r>
    80000894:	00008717          	auipc	a4,0x8
    80000898:	27c73703          	ld	a4,636(a4) # 80008b10 <uart_tx_w>
    8000089c:	06f70f63          	beq	a4,a5,8000091a <uartstart+0x8e>
{
    800008a0:	7139                	addi	sp,sp,-64
    800008a2:	fc06                	sd	ra,56(sp)
    800008a4:	f822                	sd	s0,48(sp)
    800008a6:	f426                	sd	s1,40(sp)
    800008a8:	f04a                	sd	s2,32(sp)
    800008aa:	ec4e                	sd	s3,24(sp)
    800008ac:	e852                	sd	s4,16(sp)
    800008ae:	e456                	sd	s5,8(sp)
    800008b0:	e05a                	sd	s6,0(sp)
    800008b2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b4:	10000937          	lui	s2,0x10000
    800008b8:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ba:	00010a97          	auipc	s5,0x10
    800008be:	49ea8a93          	addi	s5,s5,1182 # 80010d58 <uart_tx_lock>
    uart_tx_r += 1;
    800008c2:	00008497          	auipc	s1,0x8
    800008c6:	24648493          	addi	s1,s1,582 # 80008b08 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008ca:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ce:	00008997          	auipc	s3,0x8
    800008d2:	24298993          	addi	s3,s3,578 # 80008b10 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d6:	00094703          	lbu	a4,0(s2)
    800008da:	02077713          	andi	a4,a4,32
    800008de:	c705                	beqz	a4,80000906 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e0:	01f7f713          	andi	a4,a5,31
    800008e4:	9756                	add	a4,a4,s5
    800008e6:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ea:	0785                	addi	a5,a5,1
    800008ec:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008ee:	8526                	mv	a0,s1
    800008f0:	00002097          	auipc	ra,0x2
    800008f4:	b70080e7          	jalr	-1168(ra) # 80002460 <wakeup>
    WriteReg(THR, c);
    800008f8:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fc:	609c                	ld	a5,0(s1)
    800008fe:	0009b703          	ld	a4,0(s3)
    80000902:	fcf71ae3          	bne	a4,a5,800008d6 <uartstart+0x4a>
  }
}
    80000906:	70e2                	ld	ra,56(sp)
    80000908:	7442                	ld	s0,48(sp)
    8000090a:	74a2                	ld	s1,40(sp)
    8000090c:	7902                	ld	s2,32(sp)
    8000090e:	69e2                	ld	s3,24(sp)
    80000910:	6a42                	ld	s4,16(sp)
    80000912:	6aa2                	ld	s5,8(sp)
    80000914:	6b02                	ld	s6,0(sp)
    80000916:	6121                	addi	sp,sp,64
    80000918:	8082                	ret
    8000091a:	8082                	ret

000000008000091c <uartputc>:
{
    8000091c:	7179                	addi	sp,sp,-48
    8000091e:	f406                	sd	ra,40(sp)
    80000920:	f022                	sd	s0,32(sp)
    80000922:	ec26                	sd	s1,24(sp)
    80000924:	e84a                	sd	s2,16(sp)
    80000926:	e44e                	sd	s3,8(sp)
    80000928:	e052                	sd	s4,0(sp)
    8000092a:	1800                	addi	s0,sp,48
    8000092c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000092e:	00010517          	auipc	a0,0x10
    80000932:	42a50513          	addi	a0,a0,1066 # 80010d58 <uart_tx_lock>
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	326080e7          	jalr	806(ra) # 80000c5c <acquire>
  if(panicked){
    8000093e:	00008797          	auipc	a5,0x8
    80000942:	1c27a783          	lw	a5,450(a5) # 80008b00 <panicked>
    80000946:	ebc1                	bnez	a5,800009d6 <uartputc+0xba>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000948:	00008717          	auipc	a4,0x8
    8000094c:	1c873703          	ld	a4,456(a4) # 80008b10 <uart_tx_w>
    80000950:	00008797          	auipc	a5,0x8
    80000954:	1b87b783          	ld	a5,440(a5) # 80008b08 <uart_tx_r>
    80000958:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095c:	00010997          	auipc	s3,0x10
    80000960:	3fc98993          	addi	s3,s3,1020 # 80010d58 <uart_tx_lock>
    80000964:	00008497          	auipc	s1,0x8
    80000968:	1a448493          	addi	s1,s1,420 # 80008b08 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096c:	00008917          	auipc	s2,0x8
    80000970:	1a490913          	addi	s2,s2,420 # 80008b10 <uart_tx_w>
    80000974:	00e79f63          	bne	a5,a4,80000992 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000978:	85ce                	mv	a1,s3
    8000097a:	8526                	mv	a0,s1
    8000097c:	00002097          	auipc	ra,0x2
    80000980:	a80080e7          	jalr	-1408(ra) # 800023fc <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000984:	00093703          	ld	a4,0(s2)
    80000988:	609c                	ld	a5,0(s1)
    8000098a:	02078793          	addi	a5,a5,32
    8000098e:	fee785e3          	beq	a5,a4,80000978 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000992:	01f77693          	andi	a3,a4,31
    80000996:	00010797          	auipc	a5,0x10
    8000099a:	3c278793          	addi	a5,a5,962 # 80010d58 <uart_tx_lock>
    8000099e:	97b6                	add	a5,a5,a3
    800009a0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a4:	0705                	addi	a4,a4,1
    800009a6:	00008797          	auipc	a5,0x8
    800009aa:	16e7b523          	sd	a4,362(a5) # 80008b10 <uart_tx_w>
  uartstart();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	ede080e7          	jalr	-290(ra) # 8000088c <uartstart>
  release(&uart_tx_lock);
    800009b6:	00010517          	auipc	a0,0x10
    800009ba:	3a250513          	addi	a0,a0,930 # 80010d58 <uart_tx_lock>
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	34e080e7          	jalr	846(ra) # 80000d0c <release>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret
    for(;;)
    800009d6:	a001                	j	800009d6 <uartputc+0xba>

00000000800009d8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d8:	1141                	addi	sp,sp,-16
    800009da:	e406                	sd	ra,8(sp)
    800009dc:	e022                	sd	s0,0(sp)
    800009de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e0:	100007b7          	lui	a5,0x10000
    800009e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009e8:	8b85                	andi	a5,a5,1
    800009ea:	cb89                	beqz	a5,800009fc <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009ec:	100007b7          	lui	a5,0x10000
    800009f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f4:	60a2                	ld	ra,8(sp)
    800009f6:	6402                	ld	s0,0(sp)
    800009f8:	0141                	addi	sp,sp,16
    800009fa:	8082                	ret
    return -1;
    800009fc:	557d                	li	a0,-1
    800009fe:	bfdd                	j	800009f4 <uartgetc+0x1c>

0000000080000a00 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a00:	1101                	addi	sp,sp,-32
    80000a02:	ec06                	sd	ra,24(sp)
    80000a04:	e822                	sd	s0,16(sp)
    80000a06:	e426                	sd	s1,8(sp)
    80000a08:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a0a:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a0c:	00000097          	auipc	ra,0x0
    80000a10:	fcc080e7          	jalr	-52(ra) # 800009d8 <uartgetc>
    if(c == -1)
    80000a14:	00950763          	beq	a0,s1,80000a22 <uartintr+0x22>
      break;
    consoleintr(c);
    80000a18:	00000097          	auipc	ra,0x0
    80000a1c:	8c8080e7          	jalr	-1848(ra) # 800002e0 <consoleintr>
  while(1){
    80000a20:	b7f5                	j	80000a0c <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a22:	00010517          	auipc	a0,0x10
    80000a26:	33650513          	addi	a0,a0,822 # 80010d58 <uart_tx_lock>
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	232080e7          	jalr	562(ra) # 80000c5c <acquire>
  uartstart();
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	e5a080e7          	jalr	-422(ra) # 8000088c <uartstart>
  release(&uart_tx_lock);
    80000a3a:	00010517          	auipc	a0,0x10
    80000a3e:	31e50513          	addi	a0,a0,798 # 80010d58 <uart_tx_lock>
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	2ca080e7          	jalr	714(ra) # 80000d0c <release>
}
    80000a4a:	60e2                	ld	ra,24(sp)
    80000a4c:	6442                	ld	s0,16(sp)
    80000a4e:	64a2                	ld	s1,8(sp)
    80000a50:	6105                	addi	sp,sp,32
    80000a52:	8082                	ret

0000000080000a54 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a54:	1101                	addi	sp,sp,-32
    80000a56:	ec06                	sd	ra,24(sp)
    80000a58:	e822                	sd	s0,16(sp)
    80000a5a:	e426                	sd	s1,8(sp)
    80000a5c:	e04a                	sd	s2,0(sp)
    80000a5e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a60:	0004c797          	auipc	a5,0x4c
    80000a64:	70878793          	addi	a5,a5,1800 # 8004d168 <end>
    80000a68:	00f53733          	sltu	a4,a0,a5
    80000a6c:	47c5                	li	a5,17
    80000a6e:	07ee                	slli	a5,a5,0x1b
    80000a70:	17fd                	addi	a5,a5,-1
    80000a72:	00a7b7b3          	sltu	a5,a5,a0
    80000a76:	8fd9                	or	a5,a5,a4
    80000a78:	e7a1                	bnez	a5,80000ac0 <kfree+0x6c>
    80000a7a:	84aa                	mv	s1,a0
    80000a7c:	03451793          	slli	a5,a0,0x34
    80000a80:	e3a1                	bnez	a5,80000ac0 <kfree+0x6c>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a82:	6605                	lui	a2,0x1
    80000a84:	4585                	li	a1,1
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	2ce080e7          	jalr	718(ra) # 80000d54 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a8e:	00010917          	auipc	s2,0x10
    80000a92:	30290913          	addi	s2,s2,770 # 80010d90 <kmem>
    80000a96:	854a                	mv	a0,s2
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	1c4080e7          	jalr	452(ra) # 80000c5c <acquire>
  r->next = kmem.freelist;
    80000aa0:	01893783          	ld	a5,24(s2)
    80000aa4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aa6:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	260080e7          	jalr	608(ra) # 80000d0c <release>
}
    80000ab4:	60e2                	ld	ra,24(sp)
    80000ab6:	6442                	ld	s0,16(sp)
    80000ab8:	64a2                	ld	s1,8(sp)
    80000aba:	6902                	ld	s2,0(sp)
    80000abc:	6105                	addi	sp,sp,32
    80000abe:	8082                	ret
    panic("kfree");
    80000ac0:	00007517          	auipc	a0,0x7
    80000ac4:	58050513          	addi	a0,a0,1408 # 80008040 <etext+0x40>
    80000ac8:	00000097          	auipc	ra,0x0
    80000acc:	a96080e7          	jalr	-1386(ra) # 8000055e <panic>

0000000080000ad0 <freerange>:
{
    80000ad0:	7179                	addi	sp,sp,-48
    80000ad2:	f406                	sd	ra,40(sp)
    80000ad4:	f022                	sd	s0,32(sp)
    80000ad6:	ec26                	sd	s1,24(sp)
    80000ad8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ada:	6785                	lui	a5,0x1
    80000adc:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ae0:	00e504b3          	add	s1,a0,a4
    80000ae4:	777d                	lui	a4,0xfffff
    80000ae6:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae8:	94be                	add	s1,s1,a5
    80000aea:	0295e463          	bltu	a1,s1,80000b12 <freerange+0x42>
    80000aee:	e84a                	sd	s2,16(sp)
    80000af0:	e44e                	sd	s3,8(sp)
    80000af2:	e052                	sd	s4,0(sp)
    80000af4:	892e                	mv	s2,a1
    kfree(p);
    80000af6:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af8:	89be                	mv	s3,a5
    kfree(p);
    80000afa:	01448533          	add	a0,s1,s4
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	f56080e7          	jalr	-170(ra) # 80000a54 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b06:	94ce                	add	s1,s1,s3
    80000b08:	fe9979e3          	bgeu	s2,s1,80000afa <freerange+0x2a>
    80000b0c:	6942                	ld	s2,16(sp)
    80000b0e:	69a2                	ld	s3,8(sp)
    80000b10:	6a02                	ld	s4,0(sp)
}
    80000b12:	70a2                	ld	ra,40(sp)
    80000b14:	7402                	ld	s0,32(sp)
    80000b16:	64e2                	ld	s1,24(sp)
    80000b18:	6145                	addi	sp,sp,48
    80000b1a:	8082                	ret

0000000080000b1c <kinit>:
{
    80000b1c:	1141                	addi	sp,sp,-16
    80000b1e:	e406                	sd	ra,8(sp)
    80000b20:	e022                	sd	s0,0(sp)
    80000b22:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b24:	00007597          	auipc	a1,0x7
    80000b28:	52458593          	addi	a1,a1,1316 # 80008048 <etext+0x48>
    80000b2c:	00010517          	auipc	a0,0x10
    80000b30:	26450513          	addi	a0,a0,612 # 80010d90 <kmem>
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	08e080e7          	jalr	142(ra) # 80000bc2 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b3c:	45c5                	li	a1,17
    80000b3e:	05ee                	slli	a1,a1,0x1b
    80000b40:	0004c517          	auipc	a0,0x4c
    80000b44:	62850513          	addi	a0,a0,1576 # 8004d168 <end>
    80000b48:	00000097          	auipc	ra,0x0
    80000b4c:	f88080e7          	jalr	-120(ra) # 80000ad0 <freerange>
}
    80000b50:	60a2                	ld	ra,8(sp)
    80000b52:	6402                	ld	s0,0(sp)
    80000b54:	0141                	addi	sp,sp,16
    80000b56:	8082                	ret

0000000080000b58 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b58:	1101                	addi	sp,sp,-32
    80000b5a:	ec06                	sd	ra,24(sp)
    80000b5c:	e822                	sd	s0,16(sp)
    80000b5e:	e426                	sd	s1,8(sp)
    80000b60:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b62:	00010517          	auipc	a0,0x10
    80000b66:	22e50513          	addi	a0,a0,558 # 80010d90 <kmem>
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	0f2080e7          	jalr	242(ra) # 80000c5c <acquire>
  r = kmem.freelist;
    80000b72:	00010497          	auipc	s1,0x10
    80000b76:	2364b483          	ld	s1,566(s1) # 80010da8 <kmem+0x18>
  if(r)
    80000b7a:	c89d                	beqz	s1,80000bb0 <kalloc+0x58>
    kmem.freelist = r->next;
    80000b7c:	609c                	ld	a5,0(s1)
    80000b7e:	00010717          	auipc	a4,0x10
    80000b82:	22f73523          	sd	a5,554(a4) # 80010da8 <kmem+0x18>
  release(&kmem.lock);
    80000b86:	00010517          	auipc	a0,0x10
    80000b8a:	20a50513          	addi	a0,a0,522 # 80010d90 <kmem>
    80000b8e:	00000097          	auipc	ra,0x0
    80000b92:	17e080e7          	jalr	382(ra) # 80000d0c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b96:	6605                	lui	a2,0x1
    80000b98:	4595                	li	a1,5
    80000b9a:	8526                	mv	a0,s1
    80000b9c:	00000097          	auipc	ra,0x0
    80000ba0:	1b8080e7          	jalr	440(ra) # 80000d54 <memset>
  return (void*)r;
}
    80000ba4:	8526                	mv	a0,s1
    80000ba6:	60e2                	ld	ra,24(sp)
    80000ba8:	6442                	ld	s0,16(sp)
    80000baa:	64a2                	ld	s1,8(sp)
    80000bac:	6105                	addi	sp,sp,32
    80000bae:	8082                	ret
  release(&kmem.lock);
    80000bb0:	00010517          	auipc	a0,0x10
    80000bb4:	1e050513          	addi	a0,a0,480 # 80010d90 <kmem>
    80000bb8:	00000097          	auipc	ra,0x0
    80000bbc:	154080e7          	jalr	340(ra) # 80000d0c <release>
  if(r)
    80000bc0:	b7d5                	j	80000ba4 <kalloc+0x4c>

0000000080000bc2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000bc2:	1141                	addi	sp,sp,-16
    80000bc4:	e406                	sd	ra,8(sp)
    80000bc6:	e022                	sd	s0,0(sp)
    80000bc8:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bca:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bcc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bd0:	00053823          	sd	zero,16(a0)
}
    80000bd4:	60a2                	ld	ra,8(sp)
    80000bd6:	6402                	ld	s0,0(sp)
    80000bd8:	0141                	addi	sp,sp,16
    80000bda:	8082                	ret

0000000080000bdc <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bdc:	411c                	lw	a5,0(a0)
    80000bde:	e399                	bnez	a5,80000be4 <holding+0x8>
    80000be0:	4501                	li	a0,0
  return r;
}
    80000be2:	8082                	ret
{
    80000be4:	1101                	addi	sp,sp,-32
    80000be6:	ec06                	sd	ra,24(sp)
    80000be8:	e822                	sd	s0,16(sp)
    80000bea:	e426                	sd	s1,8(sp)
    80000bec:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bee:	691c                	ld	a5,16(a0)
    80000bf0:	84be                	mv	s1,a5
    80000bf2:	00001097          	auipc	ra,0x1
    80000bf6:	f7a080e7          	jalr	-134(ra) # 80001b6c <mycpu>
    80000bfa:	40a48533          	sub	a0,s1,a0
    80000bfe:	00153513          	seqz	a0,a0
}
    80000c02:	60e2                	ld	ra,24(sp)
    80000c04:	6442                	ld	s0,16(sp)
    80000c06:	64a2                	ld	s1,8(sp)
    80000c08:	6105                	addi	sp,sp,32
    80000c0a:	8082                	ret

0000000080000c0c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c0c:	1101                	addi	sp,sp,-32
    80000c0e:	ec06                	sd	ra,24(sp)
    80000c10:	e822                	sd	s0,16(sp)
    80000c12:	e426                	sd	s1,8(sp)
    80000c14:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c16:	100027f3          	csrr	a5,sstatus
    80000c1a:	84be                	mv	s1,a5
    80000c1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c20:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c22:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c26:	00001097          	auipc	ra,0x1
    80000c2a:	f46080e7          	jalr	-186(ra) # 80001b6c <mycpu>
    80000c2e:	5d3c                	lw	a5,120(a0)
    80000c30:	cf89                	beqz	a5,80000c4a <push_off+0x3e>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c32:	00001097          	auipc	ra,0x1
    80000c36:	f3a080e7          	jalr	-198(ra) # 80001b6c <mycpu>
    80000c3a:	5d3c                	lw	a5,120(a0)
    80000c3c:	2785                	addiw	a5,a5,1
    80000c3e:	dd3c                	sw	a5,120(a0)
}
    80000c40:	60e2                	ld	ra,24(sp)
    80000c42:	6442                	ld	s0,16(sp)
    80000c44:	64a2                	ld	s1,8(sp)
    80000c46:	6105                	addi	sp,sp,32
    80000c48:	8082                	ret
    mycpu()->intena = old;
    80000c4a:	00001097          	auipc	ra,0x1
    80000c4e:	f22080e7          	jalr	-222(ra) # 80001b6c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c52:	0014d793          	srli	a5,s1,0x1
    80000c56:	8b85                	andi	a5,a5,1
    80000c58:	dd7c                	sw	a5,124(a0)
    80000c5a:	bfe1                	j	80000c32 <push_off+0x26>

0000000080000c5c <acquire>:
{
    80000c5c:	1101                	addi	sp,sp,-32
    80000c5e:	ec06                	sd	ra,24(sp)
    80000c60:	e822                	sd	s0,16(sp)
    80000c62:	e426                	sd	s1,8(sp)
    80000c64:	1000                	addi	s0,sp,32
    80000c66:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c68:	00000097          	auipc	ra,0x0
    80000c6c:	fa4080e7          	jalr	-92(ra) # 80000c0c <push_off>
  if(holding(lk))
    80000c70:	8526                	mv	a0,s1
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	f6a080e7          	jalr	-150(ra) # 80000bdc <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c7a:	4705                	li	a4,1
  if(holding(lk))
    80000c7c:	e115                	bnez	a0,80000ca0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c7e:	87ba                	mv	a5,a4
    80000c80:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c84:	2781                	sext.w	a5,a5
    80000c86:	ffe5                	bnez	a5,80000c7e <acquire+0x22>
  __sync_synchronize();
    80000c88:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c8c:	00001097          	auipc	ra,0x1
    80000c90:	ee0080e7          	jalr	-288(ra) # 80001b6c <mycpu>
    80000c94:	e888                	sd	a0,16(s1)
}
    80000c96:	60e2                	ld	ra,24(sp)
    80000c98:	6442                	ld	s0,16(sp)
    80000c9a:	64a2                	ld	s1,8(sp)
    80000c9c:	6105                	addi	sp,sp,32
    80000c9e:	8082                	ret
    panic("acquire");
    80000ca0:	00007517          	auipc	a0,0x7
    80000ca4:	3b050513          	addi	a0,a0,944 # 80008050 <etext+0x50>
    80000ca8:	00000097          	auipc	ra,0x0
    80000cac:	8b6080e7          	jalr	-1866(ra) # 8000055e <panic>

0000000080000cb0 <pop_off>:

void
pop_off(void)
{
    80000cb0:	1141                	addi	sp,sp,-16
    80000cb2:	e406                	sd	ra,8(sp)
    80000cb4:	e022                	sd	s0,0(sp)
    80000cb6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000cb8:	00001097          	auipc	ra,0x1
    80000cbc:	eb4080e7          	jalr	-332(ra) # 80001b6c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cc0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000cc4:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000cc6:	e39d                	bnez	a5,80000cec <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000cc8:	5d3c                	lw	a5,120(a0)
    80000cca:	02f05963          	blez	a5,80000cfc <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000cce:	37fd                	addiw	a5,a5,-1
    80000cd0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cd2:	eb89                	bnez	a5,80000ce4 <pop_off+0x34>
    80000cd4:	5d7c                	lw	a5,124(a0)
    80000cd6:	c799                	beqz	a5,80000ce4 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cd8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cdc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ce0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000ce4:	60a2                	ld	ra,8(sp)
    80000ce6:	6402                	ld	s0,0(sp)
    80000ce8:	0141                	addi	sp,sp,16
    80000cea:	8082                	ret
    panic("pop_off - interruptible");
    80000cec:	00007517          	auipc	a0,0x7
    80000cf0:	36c50513          	addi	a0,a0,876 # 80008058 <etext+0x58>
    80000cf4:	00000097          	auipc	ra,0x0
    80000cf8:	86a080e7          	jalr	-1942(ra) # 8000055e <panic>
    panic("pop_off");
    80000cfc:	00007517          	auipc	a0,0x7
    80000d00:	37450513          	addi	a0,a0,884 # 80008070 <etext+0x70>
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	85a080e7          	jalr	-1958(ra) # 8000055e <panic>

0000000080000d0c <release>:
{
    80000d0c:	1101                	addi	sp,sp,-32
    80000d0e:	ec06                	sd	ra,24(sp)
    80000d10:	e822                	sd	s0,16(sp)
    80000d12:	e426                	sd	s1,8(sp)
    80000d14:	1000                	addi	s0,sp,32
    80000d16:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d18:	00000097          	auipc	ra,0x0
    80000d1c:	ec4080e7          	jalr	-316(ra) # 80000bdc <holding>
    80000d20:	c115                	beqz	a0,80000d44 <release+0x38>
  lk->cpu = 0;
    80000d22:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d26:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d2a:	0310000f          	fence	rw,w
    80000d2e:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d32:	00000097          	auipc	ra,0x0
    80000d36:	f7e080e7          	jalr	-130(ra) # 80000cb0 <pop_off>
}
    80000d3a:	60e2                	ld	ra,24(sp)
    80000d3c:	6442                	ld	s0,16(sp)
    80000d3e:	64a2                	ld	s1,8(sp)
    80000d40:	6105                	addi	sp,sp,32
    80000d42:	8082                	ret
    panic("release");
    80000d44:	00007517          	auipc	a0,0x7
    80000d48:	33450513          	addi	a0,a0,820 # 80008078 <etext+0x78>
    80000d4c:	00000097          	auipc	ra,0x0
    80000d50:	812080e7          	jalr	-2030(ra) # 8000055e <panic>

0000000080000d54 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d54:	1141                	addi	sp,sp,-16
    80000d56:	e406                	sd	ra,8(sp)
    80000d58:	e022                	sd	s0,0(sp)
    80000d5a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d5c:	ca19                	beqz	a2,80000d72 <memset+0x1e>
    80000d5e:	87aa                	mv	a5,a0
    80000d60:	1602                	slli	a2,a2,0x20
    80000d62:	9201                	srli	a2,a2,0x20
    80000d64:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d68:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d6c:	0785                	addi	a5,a5,1
    80000d6e:	fee79de3          	bne	a5,a4,80000d68 <memset+0x14>
  }
  return dst;
}
    80000d72:	60a2                	ld	ra,8(sp)
    80000d74:	6402                	ld	s0,0(sp)
    80000d76:	0141                	addi	sp,sp,16
    80000d78:	8082                	ret

0000000080000d7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d7a:	1141                	addi	sp,sp,-16
    80000d7c:	e406                	sd	ra,8(sp)
    80000d7e:	e022                	sd	s0,0(sp)
    80000d80:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d82:	c61d                	beqz	a2,80000db0 <memcmp+0x36>
    80000d84:	1602                	slli	a2,a2,0x20
    80000d86:	9201                	srli	a2,a2,0x20
    80000d88:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000d8c:	00054783          	lbu	a5,0(a0)
    80000d90:	0005c703          	lbu	a4,0(a1)
    80000d94:	00e79863          	bne	a5,a4,80000da4 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000d98:	0505                	addi	a0,a0,1
    80000d9a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d9c:	fed518e3          	bne	a0,a3,80000d8c <memcmp+0x12>
  }

  return 0;
    80000da0:	4501                	li	a0,0
    80000da2:	a019                	j	80000da8 <memcmp+0x2e>
      return *s1 - *s2;
    80000da4:	40e7853b          	subw	a0,a5,a4
}
    80000da8:	60a2                	ld	ra,8(sp)
    80000daa:	6402                	ld	s0,0(sp)
    80000dac:	0141                	addi	sp,sp,16
    80000dae:	8082                	ret
  return 0;
    80000db0:	4501                	li	a0,0
    80000db2:	bfdd                	j	80000da8 <memcmp+0x2e>

0000000080000db4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000db4:	1141                	addi	sp,sp,-16
    80000db6:	e406                	sd	ra,8(sp)
    80000db8:	e022                	sd	s0,0(sp)
    80000dba:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000dbc:	c205                	beqz	a2,80000ddc <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000dbe:	02a5e363          	bltu	a1,a0,80000de4 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000dc2:	1602                	slli	a2,a2,0x20
    80000dc4:	9201                	srli	a2,a2,0x20
    80000dc6:	00c587b3          	add	a5,a1,a2
{
    80000dca:	872a                	mv	a4,a0
      *d++ = *s++;
    80000dcc:	0585                	addi	a1,a1,1
    80000dce:	0705                	addi	a4,a4,1
    80000dd0:	fff5c683          	lbu	a3,-1(a1)
    80000dd4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000dd8:	feb79ae3          	bne	a5,a1,80000dcc <memmove+0x18>

  return dst;
}
    80000ddc:	60a2                	ld	ra,8(sp)
    80000dde:	6402                	ld	s0,0(sp)
    80000de0:	0141                	addi	sp,sp,16
    80000de2:	8082                	ret
  if(s < d && s + n > d){
    80000de4:	02061693          	slli	a3,a2,0x20
    80000de8:	9281                	srli	a3,a3,0x20
    80000dea:	00d58733          	add	a4,a1,a3
    80000dee:	fce57ae3          	bgeu	a0,a4,80000dc2 <memmove+0xe>
    d += n;
    80000df2:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000df4:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000df8:	1782                	slli	a5,a5,0x20
    80000dfa:	9381                	srli	a5,a5,0x20
    80000dfc:	fff7c793          	not	a5,a5
    80000e00:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000e02:	177d                	addi	a4,a4,-1
    80000e04:	16fd                	addi	a3,a3,-1
    80000e06:	00074603          	lbu	a2,0(a4)
    80000e0a:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000e0e:	fee79ae3          	bne	a5,a4,80000e02 <memmove+0x4e>
    80000e12:	b7e9                	j	80000ddc <memmove+0x28>

0000000080000e14 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e14:	1141                	addi	sp,sp,-16
    80000e16:	e406                	sd	ra,8(sp)
    80000e18:	e022                	sd	s0,0(sp)
    80000e1a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e1c:	00000097          	auipc	ra,0x0
    80000e20:	f98080e7          	jalr	-104(ra) # 80000db4 <memmove>
}
    80000e24:	60a2                	ld	ra,8(sp)
    80000e26:	6402                	ld	s0,0(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e406                	sd	ra,8(sp)
    80000e30:	e022                	sd	s0,0(sp)
    80000e32:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e34:	ce11                	beqz	a2,80000e50 <strncmp+0x24>
    80000e36:	00054783          	lbu	a5,0(a0)
    80000e3a:	cf89                	beqz	a5,80000e54 <strncmp+0x28>
    80000e3c:	0005c703          	lbu	a4,0(a1)
    80000e40:	00f71a63          	bne	a4,a5,80000e54 <strncmp+0x28>
    n--, p++, q++;
    80000e44:	367d                	addiw	a2,a2,-1
    80000e46:	0505                	addi	a0,a0,1
    80000e48:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e4a:	f675                	bnez	a2,80000e36 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000e4c:	4501                	li	a0,0
    80000e4e:	a801                	j	80000e5e <strncmp+0x32>
    80000e50:	4501                	li	a0,0
    80000e52:	a031                	j	80000e5e <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000e54:	00054503          	lbu	a0,0(a0)
    80000e58:	0005c783          	lbu	a5,0(a1)
    80000e5c:	9d1d                	subw	a0,a0,a5
}
    80000e5e:	60a2                	ld	ra,8(sp)
    80000e60:	6402                	ld	s0,0(sp)
    80000e62:	0141                	addi	sp,sp,16
    80000e64:	8082                	ret

0000000080000e66 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e406                	sd	ra,8(sp)
    80000e6a:	e022                	sd	s0,0(sp)
    80000e6c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e6e:	87aa                	mv	a5,a0
    80000e70:	a011                	j	80000e74 <strncpy+0xe>
    80000e72:	8636                	mv	a2,a3
    80000e74:	02c05863          	blez	a2,80000ea4 <strncpy+0x3e>
    80000e78:	fff6069b          	addiw	a3,a2,-1
    80000e7c:	8836                	mv	a6,a3
    80000e7e:	0785                	addi	a5,a5,1
    80000e80:	0005c703          	lbu	a4,0(a1)
    80000e84:	fee78fa3          	sb	a4,-1(a5)
    80000e88:	0585                	addi	a1,a1,1
    80000e8a:	f765                	bnez	a4,80000e72 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000e8c:	873e                	mv	a4,a5
    80000e8e:	01005b63          	blez	a6,80000ea4 <strncpy+0x3e>
    80000e92:	9fb1                	addw	a5,a5,a2
    80000e94:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e96:	0705                	addi	a4,a4,1
    80000e98:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e9c:	40e786bb          	subw	a3,a5,a4
    80000ea0:	fed04be3          	bgtz	a3,80000e96 <strncpy+0x30>
  return os;
}
    80000ea4:	60a2                	ld	ra,8(sp)
    80000ea6:	6402                	ld	s0,0(sp)
    80000ea8:	0141                	addi	sp,sp,16
    80000eaa:	8082                	ret

0000000080000eac <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000eac:	1141                	addi	sp,sp,-16
    80000eae:	e406                	sd	ra,8(sp)
    80000eb0:	e022                	sd	s0,0(sp)
    80000eb2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000eb4:	02c05363          	blez	a2,80000eda <safestrcpy+0x2e>
    80000eb8:	fff6069b          	addiw	a3,a2,-1
    80000ebc:	1682                	slli	a3,a3,0x20
    80000ebe:	9281                	srli	a3,a3,0x20
    80000ec0:	96ae                	add	a3,a3,a1
    80000ec2:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ec4:	00d58963          	beq	a1,a3,80000ed6 <safestrcpy+0x2a>
    80000ec8:	0585                	addi	a1,a1,1
    80000eca:	0785                	addi	a5,a5,1
    80000ecc:	fff5c703          	lbu	a4,-1(a1)
    80000ed0:	fee78fa3          	sb	a4,-1(a5)
    80000ed4:	fb65                	bnez	a4,80000ec4 <safestrcpy+0x18>
    ;
  *s = 0;
    80000ed6:	00078023          	sb	zero,0(a5)
  return os;
}
    80000eda:	60a2                	ld	ra,8(sp)
    80000edc:	6402                	ld	s0,0(sp)
    80000ede:	0141                	addi	sp,sp,16
    80000ee0:	8082                	ret

0000000080000ee2 <strlen>:

int
strlen(const char *s)
{
    80000ee2:	1141                	addi	sp,sp,-16
    80000ee4:	e406                	sd	ra,8(sp)
    80000ee6:	e022                	sd	s0,0(sp)
    80000ee8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000eea:	00054783          	lbu	a5,0(a0)
    80000eee:	cf91                	beqz	a5,80000f0a <strlen+0x28>
    80000ef0:	00150793          	addi	a5,a0,1
    80000ef4:	86be                	mv	a3,a5
    80000ef6:	0785                	addi	a5,a5,1
    80000ef8:	fff7c703          	lbu	a4,-1(a5)
    80000efc:	ff65                	bnez	a4,80000ef4 <strlen+0x12>
    80000efe:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000f02:	60a2                	ld	ra,8(sp)
    80000f04:	6402                	ld	s0,0(sp)
    80000f06:	0141                	addi	sp,sp,16
    80000f08:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f0a:	4501                	li	a0,0
    80000f0c:	bfdd                	j	80000f02 <strlen+0x20>

0000000080000f0e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f0e:	1141                	addi	sp,sp,-16
    80000f10:	e406                	sd	ra,8(sp)
    80000f12:	e022                	sd	s0,0(sp)
    80000f14:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f16:	00001097          	auipc	ra,0x1
    80000f1a:	c42080e7          	jalr	-958(ra) # 80001b58 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f1e:	00008717          	auipc	a4,0x8
    80000f22:	bfa70713          	addi	a4,a4,-1030 # 80008b18 <started>
  if(cpuid() == 0){
    80000f26:	c139                	beqz	a0,80000f6c <main+0x5e>
    while(started == 0)
    80000f28:	431c                	lw	a5,0(a4)
    80000f2a:	2781                	sext.w	a5,a5
    80000f2c:	dff5                	beqz	a5,80000f28 <main+0x1a>
      ;
    __sync_synchronize();
    80000f2e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000f32:	00001097          	auipc	ra,0x1
    80000f36:	c26080e7          	jalr	-986(ra) # 80001b58 <cpuid>
    80000f3a:	85aa                	mv	a1,a0
    80000f3c:	00007517          	auipc	a0,0x7
    80000f40:	15c50513          	addi	a0,a0,348 # 80008098 <etext+0x98>
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	664080e7          	jalr	1636(ra) # 800005a8 <printf>
    kvminithart();    // turn on paging
    80000f4c:	00000097          	auipc	ra,0x0
    80000f50:	0d8080e7          	jalr	216(ra) # 80001024 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f54:	00002097          	auipc	ra,0x2
    80000f58:	d90080e7          	jalr	-624(ra) # 80002ce4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f5c:	00005097          	auipc	ra,0x5
    80000f60:	768080e7          	jalr	1896(ra) # 800066c4 <plicinithart>
  }

  scheduler();        
    80000f64:	00001097          	auipc	ra,0x1
    80000f68:	2e4080e7          	jalr	740(ra) # 80002248 <scheduler>
    consoleinit();
    80000f6c:	fffff097          	auipc	ra,0xfffff
    80000f70:	508080e7          	jalr	1288(ra) # 80000474 <consoleinit>
    printfinit();
    80000f74:	00000097          	auipc	ra,0x0
    80000f78:	83e080e7          	jalr	-1986(ra) # 800007b2 <printfinit>
    printf("\n");
    80000f7c:	00007517          	auipc	a0,0x7
    80000f80:	09450513          	addi	a0,a0,148 # 80008010 <etext+0x10>
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	624080e7          	jalr	1572(ra) # 800005a8 <printf>
    printf("xv6 kernel is booting\n");
    80000f8c:	00007517          	auipc	a0,0x7
    80000f90:	0f450513          	addi	a0,a0,244 # 80008080 <etext+0x80>
    80000f94:	fffff097          	auipc	ra,0xfffff
    80000f98:	614080e7          	jalr	1556(ra) # 800005a8 <printf>
    printf("\n");
    80000f9c:	00007517          	auipc	a0,0x7
    80000fa0:	07450513          	addi	a0,a0,116 # 80008010 <etext+0x10>
    80000fa4:	fffff097          	auipc	ra,0xfffff
    80000fa8:	604080e7          	jalr	1540(ra) # 800005a8 <printf>
    kinit();         // physical page allocator
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	b70080e7          	jalr	-1168(ra) # 80000b1c <kinit>
    kvminit();       // create kernel page table
    80000fb4:	00000097          	auipc	ra,0x0
    80000fb8:	324080e7          	jalr	804(ra) # 800012d8 <kvminit>
    kvminithart();   // turn on paging
    80000fbc:	00000097          	auipc	ra,0x0
    80000fc0:	068080e7          	jalr	104(ra) # 80001024 <kvminithart>
    procinit();      // process table
    80000fc4:	00001097          	auipc	ra,0x1
    80000fc8:	ad2080e7          	jalr	-1326(ra) # 80001a96 <procinit>
    trapinit();      // trap vectors
    80000fcc:	00002097          	auipc	ra,0x2
    80000fd0:	cf0080e7          	jalr	-784(ra) # 80002cbc <trapinit>
    trapinithart();  // install kernel trap vector
    80000fd4:	00002097          	auipc	ra,0x2
    80000fd8:	d10080e7          	jalr	-752(ra) # 80002ce4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fdc:	00005097          	auipc	ra,0x5
    80000fe0:	6ce080e7          	jalr	1742(ra) # 800066aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fe4:	00005097          	auipc	ra,0x5
    80000fe8:	6e0080e7          	jalr	1760(ra) # 800066c4 <plicinithart>
    binit();         // buffer cache
    80000fec:	00002097          	auipc	ra,0x2
    80000ff0:	668080e7          	jalr	1640(ra) # 80003654 <binit>
    iinit();         // inode table
    80000ff4:	00003097          	auipc	ra,0x3
    80000ff8:	ce8080e7          	jalr	-792(ra) # 80003cdc <iinit>
    fileinit();      // file table
    80000ffc:	00004097          	auipc	ra,0x4
    80001000:	d02080e7          	jalr	-766(ra) # 80004cfe <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001004:	00005097          	auipc	ra,0x5
    80001008:	7c8080e7          	jalr	1992(ra) # 800067cc <virtio_disk_init>
    userinit();      // first user process
    8000100c:	00001097          	auipc	ra,0x1
    80001010:	ed6080e7          	jalr	-298(ra) # 80001ee2 <userinit>
    __sync_synchronize();
    80001014:	0330000f          	fence	rw,rw
    started = 1;
    80001018:	4785                	li	a5,1
    8000101a:	00008717          	auipc	a4,0x8
    8000101e:	aef72f23          	sw	a5,-1282(a4) # 80008b18 <started>
    80001022:	b789                	j	80000f64 <main+0x56>

0000000080001024 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001024:	1141                	addi	sp,sp,-16
    80001026:	e406                	sd	ra,8(sp)
    80001028:	e022                	sd	s0,0(sp)
    8000102a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000102c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001030:	00008797          	auipc	a5,0x8
    80001034:	af07b783          	ld	a5,-1296(a5) # 80008b20 <kernel_pagetable>
    80001038:	83b1                	srli	a5,a5,0xc
    8000103a:	577d                	li	a4,-1
    8000103c:	177e                	slli	a4,a4,0x3f
    8000103e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001040:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001044:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001048:	60a2                	ld	ra,8(sp)
    8000104a:	6402                	ld	s0,0(sp)
    8000104c:	0141                	addi	sp,sp,16
    8000104e:	8082                	ret

0000000080001050 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001050:	7139                	addi	sp,sp,-64
    80001052:	fc06                	sd	ra,56(sp)
    80001054:	f822                	sd	s0,48(sp)
    80001056:	f426                	sd	s1,40(sp)
    80001058:	f04a                	sd	s2,32(sp)
    8000105a:	ec4e                	sd	s3,24(sp)
    8000105c:	e852                	sd	s4,16(sp)
    8000105e:	e456                	sd	s5,8(sp)
    80001060:	e05a                	sd	s6,0(sp)
    80001062:	0080                	addi	s0,sp,64
    80001064:	84aa                	mv	s1,a0
    80001066:	89ae                	mv	s3,a1
    80001068:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    8000106a:	57fd                	li	a5,-1
    8000106c:	83e9                	srli	a5,a5,0x1a
    8000106e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001070:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80001072:	04b7e263          	bltu	a5,a1,800010b6 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80001076:	0149d933          	srl	s2,s3,s4
    8000107a:	1ff97913          	andi	s2,s2,511
    8000107e:	090e                	slli	s2,s2,0x3
    80001080:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001082:	00093483          	ld	s1,0(s2)
    80001086:	0014f793          	andi	a5,s1,1
    8000108a:	cf95                	beqz	a5,800010c6 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000108c:	80a9                	srli	s1,s1,0xa
    8000108e:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80001090:	3a5d                	addiw	s4,s4,-9
    80001092:	ff5a12e3          	bne	s4,s5,80001076 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80001096:	00c9d513          	srli	a0,s3,0xc
    8000109a:	1ff57513          	andi	a0,a0,511
    8000109e:	050e                	slli	a0,a0,0x3
    800010a0:	9526                	add	a0,a0,s1
}
    800010a2:	70e2                	ld	ra,56(sp)
    800010a4:	7442                	ld	s0,48(sp)
    800010a6:	74a2                	ld	s1,40(sp)
    800010a8:	7902                	ld	s2,32(sp)
    800010aa:	69e2                	ld	s3,24(sp)
    800010ac:	6a42                	ld	s4,16(sp)
    800010ae:	6aa2                	ld	s5,8(sp)
    800010b0:	6b02                	ld	s6,0(sp)
    800010b2:	6121                	addi	sp,sp,64
    800010b4:	8082                	ret
    panic("walk");
    800010b6:	00007517          	auipc	a0,0x7
    800010ba:	ffa50513          	addi	a0,a0,-6 # 800080b0 <etext+0xb0>
    800010be:	fffff097          	auipc	ra,0xfffff
    800010c2:	4a0080e7          	jalr	1184(ra) # 8000055e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010c6:	020b0663          	beqz	s6,800010f2 <walk+0xa2>
    800010ca:	00000097          	auipc	ra,0x0
    800010ce:	a8e080e7          	jalr	-1394(ra) # 80000b58 <kalloc>
    800010d2:	84aa                	mv	s1,a0
    800010d4:	d579                	beqz	a0,800010a2 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800010d6:	6605                	lui	a2,0x1
    800010d8:	4581                	li	a1,0
    800010da:	00000097          	auipc	ra,0x0
    800010de:	c7a080e7          	jalr	-902(ra) # 80000d54 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010e2:	00c4d793          	srli	a5,s1,0xc
    800010e6:	07aa                	slli	a5,a5,0xa
    800010e8:	0017e793          	ori	a5,a5,1
    800010ec:	00f93023          	sd	a5,0(s2)
    800010f0:	b745                	j	80001090 <walk+0x40>
        return 0;
    800010f2:	4501                	li	a0,0
    800010f4:	b77d                	j	800010a2 <walk+0x52>

00000000800010f6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010f6:	57fd                	li	a5,-1
    800010f8:	83e9                	srli	a5,a5,0x1a
    800010fa:	00b7f463          	bgeu	a5,a1,80001102 <walkaddr+0xc>
    return 0;
    800010fe:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001100:	8082                	ret
{
    80001102:	1141                	addi	sp,sp,-16
    80001104:	e406                	sd	ra,8(sp)
    80001106:	e022                	sd	s0,0(sp)
    80001108:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000110a:	4601                	li	a2,0
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	f44080e7          	jalr	-188(ra) # 80001050 <walk>
  if(pte == 0)
    80001114:	c901                	beqz	a0,80001124 <walkaddr+0x2e>
  if((*pte & PTE_V) == 0)
    80001116:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001118:	0117f693          	andi	a3,a5,17
    8000111c:	4745                	li	a4,17
    return 0;
    8000111e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001120:	00e68663          	beq	a3,a4,8000112c <walkaddr+0x36>
}
    80001124:	60a2                	ld	ra,8(sp)
    80001126:	6402                	ld	s0,0(sp)
    80001128:	0141                	addi	sp,sp,16
    8000112a:	8082                	ret
  pa = PTE2PA(*pte);
    8000112c:	83a9                	srli	a5,a5,0xa
    8000112e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001132:	bfcd                	j	80001124 <walkaddr+0x2e>

0000000080001134 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001134:	715d                	addi	sp,sp,-80
    80001136:	e486                	sd	ra,72(sp)
    80001138:	e0a2                	sd	s0,64(sp)
    8000113a:	fc26                	sd	s1,56(sp)
    8000113c:	f84a                	sd	s2,48(sp)
    8000113e:	f44e                	sd	s3,40(sp)
    80001140:	f052                	sd	s4,32(sp)
    80001142:	ec56                	sd	s5,24(sp)
    80001144:	e85a                	sd	s6,16(sp)
    80001146:	e45e                	sd	s7,8(sp)
    80001148:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000114a:	ca21                	beqz	a2,8000119a <mappages+0x66>
    8000114c:	8a2a                	mv	s4,a0
    8000114e:	8aba                	mv	s5,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001150:	777d                	lui	a4,0xfffff
    80001152:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001156:	fff58913          	addi	s2,a1,-1
    8000115a:	9932                	add	s2,s2,a2
    8000115c:	00e97933          	and	s2,s2,a4
  a = PGROUNDDOWN(va);
    80001160:	84be                	mv	s1,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001162:	4b05                	li	s6,1
    80001164:	40f689b3          	sub	s3,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001168:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    8000116a:	865a                	mv	a2,s6
    8000116c:	85a6                	mv	a1,s1
    8000116e:	8552                	mv	a0,s4
    80001170:	00000097          	auipc	ra,0x0
    80001174:	ee0080e7          	jalr	-288(ra) # 80001050 <walk>
    80001178:	c129                	beqz	a0,800011ba <mappages+0x86>
    if(*pte & PTE_V)
    8000117a:	611c                	ld	a5,0(a0)
    8000117c:	8b85                	andi	a5,a5,1
    8000117e:	e795                	bnez	a5,800011aa <mappages+0x76>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001180:	013487b3          	add	a5,s1,s3
    80001184:	83b1                	srli	a5,a5,0xc
    80001186:	07aa                	slli	a5,a5,0xa
    80001188:	0157e7b3          	or	a5,a5,s5
    8000118c:	0017e793          	ori	a5,a5,1
    80001190:	e11c                	sd	a5,0(a0)
    if(a == last)
    80001192:	05248063          	beq	s1,s2,800011d2 <mappages+0x9e>
    a += PGSIZE;
    80001196:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001198:	bfc9                	j	8000116a <mappages+0x36>
    panic("mappages: size");
    8000119a:	00007517          	auipc	a0,0x7
    8000119e:	f1e50513          	addi	a0,a0,-226 # 800080b8 <etext+0xb8>
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	3bc080e7          	jalr	956(ra) # 8000055e <panic>
      panic("mappages: remap");
    800011aa:	00007517          	auipc	a0,0x7
    800011ae:	f1e50513          	addi	a0,a0,-226 # 800080c8 <etext+0xc8>
    800011b2:	fffff097          	auipc	ra,0xfffff
    800011b6:	3ac080e7          	jalr	940(ra) # 8000055e <panic>
      return -1;
    800011ba:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011bc:	60a6                	ld	ra,72(sp)
    800011be:	6406                	ld	s0,64(sp)
    800011c0:	74e2                	ld	s1,56(sp)
    800011c2:	7942                	ld	s2,48(sp)
    800011c4:	79a2                	ld	s3,40(sp)
    800011c6:	7a02                	ld	s4,32(sp)
    800011c8:	6ae2                	ld	s5,24(sp)
    800011ca:	6b42                	ld	s6,16(sp)
    800011cc:	6ba2                	ld	s7,8(sp)
    800011ce:	6161                	addi	sp,sp,80
    800011d0:	8082                	ret
  return 0;
    800011d2:	4501                	li	a0,0
    800011d4:	b7e5                	j	800011bc <mappages+0x88>

00000000800011d6 <kvmmap>:
{
    800011d6:	1141                	addi	sp,sp,-16
    800011d8:	e406                	sd	ra,8(sp)
    800011da:	e022                	sd	s0,0(sp)
    800011dc:	0800                	addi	s0,sp,16
    800011de:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011e0:	86b2                	mv	a3,a2
    800011e2:	863e                	mv	a2,a5
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	f50080e7          	jalr	-176(ra) # 80001134 <mappages>
    800011ec:	e509                	bnez	a0,800011f6 <kvmmap+0x20>
}
    800011ee:	60a2                	ld	ra,8(sp)
    800011f0:	6402                	ld	s0,0(sp)
    800011f2:	0141                	addi	sp,sp,16
    800011f4:	8082                	ret
    panic("kvmmap");
    800011f6:	00007517          	auipc	a0,0x7
    800011fa:	ee250513          	addi	a0,a0,-286 # 800080d8 <etext+0xd8>
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	360080e7          	jalr	864(ra) # 8000055e <panic>

0000000080001206 <kvmmake>:
{
    80001206:	1101                	addi	sp,sp,-32
    80001208:	ec06                	sd	ra,24(sp)
    8000120a:	e822                	sd	s0,16(sp)
    8000120c:	e426                	sd	s1,8(sp)
    8000120e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001210:	00000097          	auipc	ra,0x0
    80001214:	948080e7          	jalr	-1720(ra) # 80000b58 <kalloc>
    80001218:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000121a:	6605                	lui	a2,0x1
    8000121c:	4581                	li	a1,0
    8000121e:	00000097          	auipc	ra,0x0
    80001222:	b36080e7          	jalr	-1226(ra) # 80000d54 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001226:	4719                	li	a4,6
    80001228:	6685                	lui	a3,0x1
    8000122a:	10000637          	lui	a2,0x10000
    8000122e:	85b2                	mv	a1,a2
    80001230:	8526                	mv	a0,s1
    80001232:	00000097          	auipc	ra,0x0
    80001236:	fa4080e7          	jalr	-92(ra) # 800011d6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000123a:	4719                	li	a4,6
    8000123c:	6685                	lui	a3,0x1
    8000123e:	10001637          	lui	a2,0x10001
    80001242:	85b2                	mv	a1,a2
    80001244:	8526                	mv	a0,s1
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	f90080e7          	jalr	-112(ra) # 800011d6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000124e:	4719                	li	a4,6
    80001250:	004006b7          	lui	a3,0x400
    80001254:	0c000637          	lui	a2,0xc000
    80001258:	85b2                	mv	a1,a2
    8000125a:	8526                	mv	a0,s1
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	f7a080e7          	jalr	-134(ra) # 800011d6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001264:	4729                	li	a4,10
    80001266:	80007697          	auipc	a3,0x80007
    8000126a:	d9a68693          	addi	a3,a3,-614 # 8000 <_entry-0x7fff8000>
    8000126e:	4605                	li	a2,1
    80001270:	067e                	slli	a2,a2,0x1f
    80001272:	85b2                	mv	a1,a2
    80001274:	8526                	mv	a0,s1
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	f60080e7          	jalr	-160(ra) # 800011d6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000127e:	4719                	li	a4,6
    80001280:	00007697          	auipc	a3,0x7
    80001284:	d8068693          	addi	a3,a3,-640 # 80008000 <etext>
    80001288:	47c5                	li	a5,17
    8000128a:	07ee                	slli	a5,a5,0x1b
    8000128c:	40d786b3          	sub	a3,a5,a3
    80001290:	00007617          	auipc	a2,0x7
    80001294:	d7060613          	addi	a2,a2,-656 # 80008000 <etext>
    80001298:	85b2                	mv	a1,a2
    8000129a:	8526                	mv	a0,s1
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	f3a080e7          	jalr	-198(ra) # 800011d6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012a4:	4729                	li	a4,10
    800012a6:	6685                	lui	a3,0x1
    800012a8:	00006617          	auipc	a2,0x6
    800012ac:	d5860613          	addi	a2,a2,-680 # 80007000 <_trampoline>
    800012b0:	040005b7          	lui	a1,0x4000
    800012b4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012b6:	05b2                	slli	a1,a1,0xc
    800012b8:	8526                	mv	a0,s1
    800012ba:	00000097          	auipc	ra,0x0
    800012be:	f1c080e7          	jalr	-228(ra) # 800011d6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800012c2:	8526                	mv	a0,s1
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	722080e7          	jalr	1826(ra) # 800019e6 <proc_mapstacks>
}
    800012cc:	8526                	mv	a0,s1
    800012ce:	60e2                	ld	ra,24(sp)
    800012d0:	6442                	ld	s0,16(sp)
    800012d2:	64a2                	ld	s1,8(sp)
    800012d4:	6105                	addi	sp,sp,32
    800012d6:	8082                	ret

00000000800012d8 <kvminit>:
{
    800012d8:	1141                	addi	sp,sp,-16
    800012da:	e406                	sd	ra,8(sp)
    800012dc:	e022                	sd	s0,0(sp)
    800012de:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012e0:	00000097          	auipc	ra,0x0
    800012e4:	f26080e7          	jalr	-218(ra) # 80001206 <kvmmake>
    800012e8:	00008797          	auipc	a5,0x8
    800012ec:	82a7bc23          	sd	a0,-1992(a5) # 80008b20 <kernel_pagetable>
}
    800012f0:	60a2                	ld	ra,8(sp)
    800012f2:	6402                	ld	s0,0(sp)
    800012f4:	0141                	addi	sp,sp,16
    800012f6:	8082                	ret

00000000800012f8 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012f8:	715d                	addi	sp,sp,-80
    800012fa:	e486                	sd	ra,72(sp)
    800012fc:	e0a2                	sd	s0,64(sp)
    800012fe:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001300:	03459793          	slli	a5,a1,0x34
    80001304:	e39d                	bnez	a5,8000132a <uvmunmap+0x32>
    80001306:	f84a                	sd	s2,48(sp)
    80001308:	f44e                	sd	s3,40(sp)
    8000130a:	f052                	sd	s4,32(sp)
    8000130c:	ec56                	sd	s5,24(sp)
    8000130e:	e85a                	sd	s6,16(sp)
    80001310:	e45e                	sd	s7,8(sp)
    80001312:	8a2a                	mv	s4,a0
    80001314:	892e                	mv	s2,a1
    80001316:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001318:	0632                	slli	a2,a2,0xc
    8000131a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000131e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001320:	6b05                	lui	s6,0x1
    80001322:	0935fb63          	bgeu	a1,s3,800013b8 <uvmunmap+0xc0>
    80001326:	fc26                	sd	s1,56(sp)
    80001328:	a8a9                	j	80001382 <uvmunmap+0x8a>
    8000132a:	fc26                	sd	s1,56(sp)
    8000132c:	f84a                	sd	s2,48(sp)
    8000132e:	f44e                	sd	s3,40(sp)
    80001330:	f052                	sd	s4,32(sp)
    80001332:	ec56                	sd	s5,24(sp)
    80001334:	e85a                	sd	s6,16(sp)
    80001336:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001338:	00007517          	auipc	a0,0x7
    8000133c:	da850513          	addi	a0,a0,-600 # 800080e0 <etext+0xe0>
    80001340:	fffff097          	auipc	ra,0xfffff
    80001344:	21e080e7          	jalr	542(ra) # 8000055e <panic>
      panic("uvmunmap: walk");
    80001348:	00007517          	auipc	a0,0x7
    8000134c:	db050513          	addi	a0,a0,-592 # 800080f8 <etext+0xf8>
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	20e080e7          	jalr	526(ra) # 8000055e <panic>
      panic("uvmunmap: not mapped");
    80001358:	00007517          	auipc	a0,0x7
    8000135c:	db050513          	addi	a0,a0,-592 # 80008108 <etext+0x108>
    80001360:	fffff097          	auipc	ra,0xfffff
    80001364:	1fe080e7          	jalr	510(ra) # 8000055e <panic>
      panic("uvmunmap: not a leaf");
    80001368:	00007517          	auipc	a0,0x7
    8000136c:	db850513          	addi	a0,a0,-584 # 80008120 <etext+0x120>
    80001370:	fffff097          	auipc	ra,0xfffff
    80001374:	1ee080e7          	jalr	494(ra) # 8000055e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001378:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000137c:	995a                	add	s2,s2,s6
    8000137e:	03397c63          	bgeu	s2,s3,800013b6 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001382:	4601                	li	a2,0
    80001384:	85ca                	mv	a1,s2
    80001386:	8552                	mv	a0,s4
    80001388:	00000097          	auipc	ra,0x0
    8000138c:	cc8080e7          	jalr	-824(ra) # 80001050 <walk>
    80001390:	84aa                	mv	s1,a0
    80001392:	d95d                	beqz	a0,80001348 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001394:	6108                	ld	a0,0(a0)
    80001396:	00157793          	andi	a5,a0,1
    8000139a:	dfdd                	beqz	a5,80001358 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000139c:	3ff57793          	andi	a5,a0,1023
    800013a0:	fd7784e3          	beq	a5,s7,80001368 <uvmunmap+0x70>
    if(do_free){
    800013a4:	fc0a8ae3          	beqz	s5,80001378 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800013a8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800013aa:	0532                	slli	a0,a0,0xc
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	6a8080e7          	jalr	1704(ra) # 80000a54 <kfree>
    800013b4:	b7d1                	j	80001378 <uvmunmap+0x80>
    800013b6:	74e2                	ld	s1,56(sp)
    800013b8:	7942                	ld	s2,48(sp)
    800013ba:	79a2                	ld	s3,40(sp)
    800013bc:	7a02                	ld	s4,32(sp)
    800013be:	6ae2                	ld	s5,24(sp)
    800013c0:	6b42                	ld	s6,16(sp)
    800013c2:	6ba2                	ld	s7,8(sp)
  }
}
    800013c4:	60a6                	ld	ra,72(sp)
    800013c6:	6406                	ld	s0,64(sp)
    800013c8:	6161                	addi	sp,sp,80
    800013ca:	8082                	ret

00000000800013cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013cc:	1101                	addi	sp,sp,-32
    800013ce:	ec06                	sd	ra,24(sp)
    800013d0:	e822                	sd	s0,16(sp)
    800013d2:	e426                	sd	s1,8(sp)
    800013d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013d6:	fffff097          	auipc	ra,0xfffff
    800013da:	782080e7          	jalr	1922(ra) # 80000b58 <kalloc>
    800013de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013e0:	c519                	beqz	a0,800013ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013e2:	6605                	lui	a2,0x1
    800013e4:	4581                	li	a1,0
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	96e080e7          	jalr	-1682(ra) # 80000d54 <memset>
  return pagetable;
}
    800013ee:	8526                	mv	a0,s1
    800013f0:	60e2                	ld	ra,24(sp)
    800013f2:	6442                	ld	s0,16(sp)
    800013f4:	64a2                	ld	s1,8(sp)
    800013f6:	6105                	addi	sp,sp,32
    800013f8:	8082                	ret

00000000800013fa <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013fa:	7179                	addi	sp,sp,-48
    800013fc:	f406                	sd	ra,40(sp)
    800013fe:	f022                	sd	s0,32(sp)
    80001400:	ec26                	sd	s1,24(sp)
    80001402:	e84a                	sd	s2,16(sp)
    80001404:	e44e                	sd	s3,8(sp)
    80001406:	e052                	sd	s4,0(sp)
    80001408:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000140a:	6785                	lui	a5,0x1
    8000140c:	04f67863          	bgeu	a2,a5,8000145c <uvmfirst+0x62>
    80001410:	89aa                	mv	s3,a0
    80001412:	8a2e                	mv	s4,a1
    80001414:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001416:	fffff097          	auipc	ra,0xfffff
    8000141a:	742080e7          	jalr	1858(ra) # 80000b58 <kalloc>
    8000141e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001420:	6605                	lui	a2,0x1
    80001422:	4581                	li	a1,0
    80001424:	00000097          	auipc	ra,0x0
    80001428:	930080e7          	jalr	-1744(ra) # 80000d54 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000142c:	4779                	li	a4,30
    8000142e:	86ca                	mv	a3,s2
    80001430:	6605                	lui	a2,0x1
    80001432:	4581                	li	a1,0
    80001434:	854e                	mv	a0,s3
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	cfe080e7          	jalr	-770(ra) # 80001134 <mappages>
  memmove(mem, src, sz);
    8000143e:	8626                	mv	a2,s1
    80001440:	85d2                	mv	a1,s4
    80001442:	854a                	mv	a0,s2
    80001444:	00000097          	auipc	ra,0x0
    80001448:	970080e7          	jalr	-1680(ra) # 80000db4 <memmove>
}
    8000144c:	70a2                	ld	ra,40(sp)
    8000144e:	7402                	ld	s0,32(sp)
    80001450:	64e2                	ld	s1,24(sp)
    80001452:	6942                	ld	s2,16(sp)
    80001454:	69a2                	ld	s3,8(sp)
    80001456:	6a02                	ld	s4,0(sp)
    80001458:	6145                	addi	sp,sp,48
    8000145a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000145c:	00007517          	auipc	a0,0x7
    80001460:	cdc50513          	addi	a0,a0,-804 # 80008138 <etext+0x138>
    80001464:	fffff097          	auipc	ra,0xfffff
    80001468:	0fa080e7          	jalr	250(ra) # 8000055e <panic>

000000008000146c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000146c:	1101                	addi	sp,sp,-32
    8000146e:	ec06                	sd	ra,24(sp)
    80001470:	e822                	sd	s0,16(sp)
    80001472:	e426                	sd	s1,8(sp)
    80001474:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001476:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001478:	00b67d63          	bgeu	a2,a1,80001492 <uvmdealloc+0x26>
    8000147c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000147e:	6785                	lui	a5,0x1
    80001480:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001482:	00f60733          	add	a4,a2,a5
    80001486:	76fd                	lui	a3,0xfffff
    80001488:	8f75                	and	a4,a4,a3
    8000148a:	97ae                	add	a5,a5,a1
    8000148c:	8ff5                	and	a5,a5,a3
    8000148e:	00f76863          	bltu	a4,a5,8000149e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001492:	8526                	mv	a0,s1
    80001494:	60e2                	ld	ra,24(sp)
    80001496:	6442                	ld	s0,16(sp)
    80001498:	64a2                	ld	s1,8(sp)
    8000149a:	6105                	addi	sp,sp,32
    8000149c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000149e:	8f99                	sub	a5,a5,a4
    800014a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014a2:	4685                	li	a3,1
    800014a4:	0007861b          	sext.w	a2,a5
    800014a8:	85ba                	mv	a1,a4
    800014aa:	00000097          	auipc	ra,0x0
    800014ae:	e4e080e7          	jalr	-434(ra) # 800012f8 <uvmunmap>
    800014b2:	b7c5                	j	80001492 <uvmdealloc+0x26>

00000000800014b4 <uvmalloc>:
  if(newsz < oldsz)
    800014b4:	0ab66d63          	bltu	a2,a1,8000156e <uvmalloc+0xba>
{
    800014b8:	715d                	addi	sp,sp,-80
    800014ba:	e486                	sd	ra,72(sp)
    800014bc:	e0a2                	sd	s0,64(sp)
    800014be:	f84a                	sd	s2,48(sp)
    800014c0:	f052                	sd	s4,32(sp)
    800014c2:	ec56                	sd	s5,24(sp)
    800014c4:	e45e                	sd	s7,8(sp)
    800014c6:	0880                	addi	s0,sp,80
    800014c8:	8aaa                	mv	s5,a0
    800014ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800014cc:	6785                	lui	a5,0x1
    800014ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014d0:	95be                	add	a1,a1,a5
    800014d2:	77fd                	lui	a5,0xfffff
    800014d4:	00f5f933          	and	s2,a1,a5
    800014d8:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014da:	08c97c63          	bgeu	s2,a2,80001572 <uvmalloc+0xbe>
    800014de:	fc26                	sd	s1,56(sp)
    800014e0:	f44e                	sd	s3,40(sp)
    800014e2:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    800014e4:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014e6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	66e080e7          	jalr	1646(ra) # 80000b58 <kalloc>
    800014f2:	84aa                	mv	s1,a0
    if(mem == 0){
    800014f4:	c90d                	beqz	a0,80001526 <uvmalloc+0x72>
    memset(mem, 0, PGSIZE);
    800014f6:	864e                	mv	a2,s3
    800014f8:	4581                	li	a1,0
    800014fa:	00000097          	auipc	ra,0x0
    800014fe:	85a080e7          	jalr	-1958(ra) # 80000d54 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001502:	875a                	mv	a4,s6
    80001504:	86a6                	mv	a3,s1
    80001506:	864e                	mv	a2,s3
    80001508:	85ca                	mv	a1,s2
    8000150a:	8556                	mv	a0,s5
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	c28080e7          	jalr	-984(ra) # 80001134 <mappages>
    80001514:	ed05                	bnez	a0,8000154c <uvmalloc+0x98>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001516:	994e                	add	s2,s2,s3
    80001518:	fd4969e3          	bltu	s2,s4,800014ea <uvmalloc+0x36>
  return newsz;
    8000151c:	8552                	mv	a0,s4
    8000151e:	74e2                	ld	s1,56(sp)
    80001520:	79a2                	ld	s3,40(sp)
    80001522:	6b42                	ld	s6,16(sp)
    80001524:	a821                	j	8000153c <uvmalloc+0x88>
      uvmdealloc(pagetable, a, oldsz);
    80001526:	865e                	mv	a2,s7
    80001528:	85ca                	mv	a1,s2
    8000152a:	8556                	mv	a0,s5
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	f40080e7          	jalr	-192(ra) # 8000146c <uvmdealloc>
      return 0;
    80001534:	4501                	li	a0,0
    80001536:	74e2                	ld	s1,56(sp)
    80001538:	79a2                	ld	s3,40(sp)
    8000153a:	6b42                	ld	s6,16(sp)
}
    8000153c:	60a6                	ld	ra,72(sp)
    8000153e:	6406                	ld	s0,64(sp)
    80001540:	7942                	ld	s2,48(sp)
    80001542:	7a02                	ld	s4,32(sp)
    80001544:	6ae2                	ld	s5,24(sp)
    80001546:	6ba2                	ld	s7,8(sp)
    80001548:	6161                	addi	sp,sp,80
    8000154a:	8082                	ret
      kfree(mem);
    8000154c:	8526                	mv	a0,s1
    8000154e:	fffff097          	auipc	ra,0xfffff
    80001552:	506080e7          	jalr	1286(ra) # 80000a54 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001556:	865e                	mv	a2,s7
    80001558:	85ca                	mv	a1,s2
    8000155a:	8556                	mv	a0,s5
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	f10080e7          	jalr	-240(ra) # 8000146c <uvmdealloc>
      return 0;
    80001564:	4501                	li	a0,0
    80001566:	74e2                	ld	s1,56(sp)
    80001568:	79a2                	ld	s3,40(sp)
    8000156a:	6b42                	ld	s6,16(sp)
    8000156c:	bfc1                	j	8000153c <uvmalloc+0x88>
    return oldsz;
    8000156e:	852e                	mv	a0,a1
}
    80001570:	8082                	ret
  return newsz;
    80001572:	8532                	mv	a0,a2
    80001574:	b7e1                	j	8000153c <uvmalloc+0x88>

0000000080001576 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001576:	7179                	addi	sp,sp,-48
    80001578:	f406                	sd	ra,40(sp)
    8000157a:	f022                	sd	s0,32(sp)
    8000157c:	ec26                	sd	s1,24(sp)
    8000157e:	e84a                	sd	s2,16(sp)
    80001580:	e44e                	sd	s3,8(sp)
    80001582:	1800                	addi	s0,sp,48
    80001584:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001586:	84aa                	mv	s1,a0
    80001588:	6905                	lui	s2,0x1
    8000158a:	992a                	add	s2,s2,a0
    8000158c:	a821                	j	800015a4 <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    8000158e:	00007517          	auipc	a0,0x7
    80001592:	bca50513          	addi	a0,a0,-1078 # 80008158 <etext+0x158>
    80001596:	fffff097          	auipc	ra,0xfffff
    8000159a:	fc8080e7          	jalr	-56(ra) # 8000055e <panic>
  for(int i = 0; i < 512; i++){
    8000159e:	04a1                	addi	s1,s1,8
    800015a0:	03248363          	beq	s1,s2,800015c6 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800015a4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015a6:	0017f713          	andi	a4,a5,1
    800015aa:	db75                	beqz	a4,8000159e <freewalk+0x28>
    800015ac:	00e7f713          	andi	a4,a5,14
    800015b0:	ff79                	bnez	a4,8000158e <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800015b2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800015b4:	00c79513          	slli	a0,a5,0xc
    800015b8:	00000097          	auipc	ra,0x0
    800015bc:	fbe080e7          	jalr	-66(ra) # 80001576 <freewalk>
      pagetable[i] = 0;
    800015c0:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015c4:	bfe9                	j	8000159e <freewalk+0x28>
    }
  }
  kfree((void*)pagetable);
    800015c6:	854e                	mv	a0,s3
    800015c8:	fffff097          	auipc	ra,0xfffff
    800015cc:	48c080e7          	jalr	1164(ra) # 80000a54 <kfree>
}
    800015d0:	70a2                	ld	ra,40(sp)
    800015d2:	7402                	ld	s0,32(sp)
    800015d4:	64e2                	ld	s1,24(sp)
    800015d6:	6942                	ld	s2,16(sp)
    800015d8:	69a2                	ld	s3,8(sp)
    800015da:	6145                	addi	sp,sp,48
    800015dc:	8082                	ret

00000000800015de <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015de:	1101                	addi	sp,sp,-32
    800015e0:	ec06                	sd	ra,24(sp)
    800015e2:	e822                	sd	s0,16(sp)
    800015e4:	e426                	sd	s1,8(sp)
    800015e6:	1000                	addi	s0,sp,32
    800015e8:	84aa                	mv	s1,a0
  if(sz > 0)
    800015ea:	e999                	bnez	a1,80001600 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015ec:	8526                	mv	a0,s1
    800015ee:	00000097          	auipc	ra,0x0
    800015f2:	f88080e7          	jalr	-120(ra) # 80001576 <freewalk>
}
    800015f6:	60e2                	ld	ra,24(sp)
    800015f8:	6442                	ld	s0,16(sp)
    800015fa:	64a2                	ld	s1,8(sp)
    800015fc:	6105                	addi	sp,sp,32
    800015fe:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001600:	6785                	lui	a5,0x1
    80001602:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001604:	95be                	add	a1,a1,a5
    80001606:	4685                	li	a3,1
    80001608:	00c5d613          	srli	a2,a1,0xc
    8000160c:	4581                	li	a1,0
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	cea080e7          	jalr	-790(ra) # 800012f8 <uvmunmap>
    80001616:	bfd9                	j	800015ec <uvmfree+0xe>

0000000080001618 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001618:	c669                	beqz	a2,800016e2 <uvmcopy+0xca>
{
    8000161a:	715d                	addi	sp,sp,-80
    8000161c:	e486                	sd	ra,72(sp)
    8000161e:	e0a2                	sd	s0,64(sp)
    80001620:	fc26                	sd	s1,56(sp)
    80001622:	f84a                	sd	s2,48(sp)
    80001624:	f44e                	sd	s3,40(sp)
    80001626:	f052                	sd	s4,32(sp)
    80001628:	ec56                	sd	s5,24(sp)
    8000162a:	e85a                	sd	s6,16(sp)
    8000162c:	e45e                	sd	s7,8(sp)
    8000162e:	0880                	addi	s0,sp,80
    80001630:	8b2a                	mv	s6,a0
    80001632:	8aae                	mv	s5,a1
    80001634:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001636:	4901                	li	s2,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001638:	6985                	lui	s3,0x1
    if((pte = walk(old, i, 0)) == 0)
    8000163a:	4601                	li	a2,0
    8000163c:	85ca                	mv	a1,s2
    8000163e:	855a                	mv	a0,s6
    80001640:	00000097          	auipc	ra,0x0
    80001644:	a10080e7          	jalr	-1520(ra) # 80001050 <walk>
    80001648:	c139                	beqz	a0,8000168e <uvmcopy+0x76>
    if((*pte & PTE_V) == 0)
    8000164a:	00053b83          	ld	s7,0(a0)
    8000164e:	001bf793          	andi	a5,s7,1
    80001652:	c7b1                	beqz	a5,8000169e <uvmcopy+0x86>
    if((mem = kalloc()) == 0)
    80001654:	fffff097          	auipc	ra,0xfffff
    80001658:	504080e7          	jalr	1284(ra) # 80000b58 <kalloc>
    8000165c:	84aa                	mv	s1,a0
    8000165e:	cd29                	beqz	a0,800016b8 <uvmcopy+0xa0>
    pa = PTE2PA(*pte);
    80001660:	00abd593          	srli	a1,s7,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80001664:	864e                	mv	a2,s3
    80001666:	05b2                	slli	a1,a1,0xc
    80001668:	fffff097          	auipc	ra,0xfffff
    8000166c:	74c080e7          	jalr	1868(ra) # 80000db4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001670:	3ffbf713          	andi	a4,s7,1023
    80001674:	86a6                	mv	a3,s1
    80001676:	864e                	mv	a2,s3
    80001678:	85ca                	mv	a1,s2
    8000167a:	8556                	mv	a0,s5
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	ab8080e7          	jalr	-1352(ra) # 80001134 <mappages>
    80001684:	e50d                	bnez	a0,800016ae <uvmcopy+0x96>
  for(i = 0; i < sz; i += PGSIZE){
    80001686:	994e                	add	s2,s2,s3
    80001688:	fb4969e3          	bltu	s2,s4,8000163a <uvmcopy+0x22>
    8000168c:	a081                	j	800016cc <uvmcopy+0xb4>
      panic("uvmcopy: pte should exist");
    8000168e:	00007517          	auipc	a0,0x7
    80001692:	ada50513          	addi	a0,a0,-1318 # 80008168 <etext+0x168>
    80001696:	fffff097          	auipc	ra,0xfffff
    8000169a:	ec8080e7          	jalr	-312(ra) # 8000055e <panic>
      panic("uvmcopy: page not present");
    8000169e:	00007517          	auipc	a0,0x7
    800016a2:	aea50513          	addi	a0,a0,-1302 # 80008188 <etext+0x188>
    800016a6:	fffff097          	auipc	ra,0xfffff
    800016aa:	eb8080e7          	jalr	-328(ra) # 8000055e <panic>
      kfree(mem);
    800016ae:	8526                	mv	a0,s1
    800016b0:	fffff097          	auipc	ra,0xfffff
    800016b4:	3a4080e7          	jalr	932(ra) # 80000a54 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016b8:	4685                	li	a3,1
    800016ba:	00c95613          	srli	a2,s2,0xc
    800016be:	4581                	li	a1,0
    800016c0:	8556                	mv	a0,s5
    800016c2:	00000097          	auipc	ra,0x0
    800016c6:	c36080e7          	jalr	-970(ra) # 800012f8 <uvmunmap>
  return -1;
    800016ca:	557d                	li	a0,-1
}
    800016cc:	60a6                	ld	ra,72(sp)
    800016ce:	6406                	ld	s0,64(sp)
    800016d0:	74e2                	ld	s1,56(sp)
    800016d2:	7942                	ld	s2,48(sp)
    800016d4:	79a2                	ld	s3,40(sp)
    800016d6:	7a02                	ld	s4,32(sp)
    800016d8:	6ae2                	ld	s5,24(sp)
    800016da:	6b42                	ld	s6,16(sp)
    800016dc:	6ba2                	ld	s7,8(sp)
    800016de:	6161                	addi	sp,sp,80
    800016e0:	8082                	ret
  return 0;
    800016e2:	4501                	li	a0,0
}
    800016e4:	8082                	ret

00000000800016e6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016e6:	1141                	addi	sp,sp,-16
    800016e8:	e406                	sd	ra,8(sp)
    800016ea:	e022                	sd	s0,0(sp)
    800016ec:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016ee:	4601                	li	a2,0
    800016f0:	00000097          	auipc	ra,0x0
    800016f4:	960080e7          	jalr	-1696(ra) # 80001050 <walk>
  if(pte == 0)
    800016f8:	c901                	beqz	a0,80001708 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016fa:	611c                	ld	a5,0(a0)
    800016fc:	9bbd                	andi	a5,a5,-17
    800016fe:	e11c                	sd	a5,0(a0)
}
    80001700:	60a2                	ld	ra,8(sp)
    80001702:	6402                	ld	s0,0(sp)
    80001704:	0141                	addi	sp,sp,16
    80001706:	8082                	ret
    panic("uvmclear");
    80001708:	00007517          	auipc	a0,0x7
    8000170c:	aa050513          	addi	a0,a0,-1376 # 800081a8 <etext+0x1a8>
    80001710:	fffff097          	auipc	ra,0xfffff
    80001714:	e4e080e7          	jalr	-434(ra) # 8000055e <panic>

0000000080001718 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001718:	c6bd                	beqz	a3,80001786 <copyout+0x6e>
{
    8000171a:	715d                	addi	sp,sp,-80
    8000171c:	e486                	sd	ra,72(sp)
    8000171e:	e0a2                	sd	s0,64(sp)
    80001720:	fc26                	sd	s1,56(sp)
    80001722:	f84a                	sd	s2,48(sp)
    80001724:	f44e                	sd	s3,40(sp)
    80001726:	f052                	sd	s4,32(sp)
    80001728:	ec56                	sd	s5,24(sp)
    8000172a:	e85a                	sd	s6,16(sp)
    8000172c:	e45e                	sd	s7,8(sp)
    8000172e:	e062                	sd	s8,0(sp)
    80001730:	0880                	addi	s0,sp,80
    80001732:	8b2a                	mv	s6,a0
    80001734:	8c2e                	mv	s8,a1
    80001736:	8a32                	mv	s4,a2
    80001738:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000173a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000173c:	6a85                	lui	s5,0x1
    8000173e:	a015                	j	80001762 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001740:	9562                	add	a0,a0,s8
    80001742:	0004861b          	sext.w	a2,s1
    80001746:	85d2                	mv	a1,s4
    80001748:	41250533          	sub	a0,a0,s2
    8000174c:	fffff097          	auipc	ra,0xfffff
    80001750:	668080e7          	jalr	1640(ra) # 80000db4 <memmove>

    len -= n;
    80001754:	409989b3          	sub	s3,s3,s1
    src += n;
    80001758:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000175a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000175e:	02098263          	beqz	s3,80001782 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001762:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001766:	85ca                	mv	a1,s2
    80001768:	855a                	mv	a0,s6
    8000176a:	00000097          	auipc	ra,0x0
    8000176e:	98c080e7          	jalr	-1652(ra) # 800010f6 <walkaddr>
    if(pa0 == 0)
    80001772:	cd01                	beqz	a0,8000178a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001774:	418904b3          	sub	s1,s2,s8
    80001778:	94d6                	add	s1,s1,s5
    if(n > len)
    8000177a:	fc99f3e3          	bgeu	s3,s1,80001740 <copyout+0x28>
    8000177e:	84ce                	mv	s1,s3
    80001780:	b7c1                	j	80001740 <copyout+0x28>
  }
  return 0;
    80001782:	4501                	li	a0,0
    80001784:	a021                	j	8000178c <copyout+0x74>
    80001786:	4501                	li	a0,0
}
    80001788:	8082                	ret
      return -1;
    8000178a:	557d                	li	a0,-1
}
    8000178c:	60a6                	ld	ra,72(sp)
    8000178e:	6406                	ld	s0,64(sp)
    80001790:	74e2                	ld	s1,56(sp)
    80001792:	7942                	ld	s2,48(sp)
    80001794:	79a2                	ld	s3,40(sp)
    80001796:	7a02                	ld	s4,32(sp)
    80001798:	6ae2                	ld	s5,24(sp)
    8000179a:	6b42                	ld	s6,16(sp)
    8000179c:	6ba2                	ld	s7,8(sp)
    8000179e:	6c02                	ld	s8,0(sp)
    800017a0:	6161                	addi	sp,sp,80
    800017a2:	8082                	ret

00000000800017a4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017a4:	caa5                	beqz	a3,80001814 <copyin+0x70>
{
    800017a6:	715d                	addi	sp,sp,-80
    800017a8:	e486                	sd	ra,72(sp)
    800017aa:	e0a2                	sd	s0,64(sp)
    800017ac:	fc26                	sd	s1,56(sp)
    800017ae:	f84a                	sd	s2,48(sp)
    800017b0:	f44e                	sd	s3,40(sp)
    800017b2:	f052                	sd	s4,32(sp)
    800017b4:	ec56                	sd	s5,24(sp)
    800017b6:	e85a                	sd	s6,16(sp)
    800017b8:	e45e                	sd	s7,8(sp)
    800017ba:	e062                	sd	s8,0(sp)
    800017bc:	0880                	addi	s0,sp,80
    800017be:	8b2a                	mv	s6,a0
    800017c0:	8a2e                	mv	s4,a1
    800017c2:	8c32                	mv	s8,a2
    800017c4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017c6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017c8:	6a85                	lui	s5,0x1
    800017ca:	a01d                	j	800017f0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017cc:	018505b3          	add	a1,a0,s8
    800017d0:	0004861b          	sext.w	a2,s1
    800017d4:	412585b3          	sub	a1,a1,s2
    800017d8:	8552                	mv	a0,s4
    800017da:	fffff097          	auipc	ra,0xfffff
    800017de:	5da080e7          	jalr	1498(ra) # 80000db4 <memmove>

    len -= n;
    800017e2:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017e6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017e8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017ec:	02098263          	beqz	s3,80001810 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017f0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017f4:	85ca                	mv	a1,s2
    800017f6:	855a                	mv	a0,s6
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	8fe080e7          	jalr	-1794(ra) # 800010f6 <walkaddr>
    if(pa0 == 0)
    80001800:	cd01                	beqz	a0,80001818 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001802:	418904b3          	sub	s1,s2,s8
    80001806:	94d6                	add	s1,s1,s5
    if(n > len)
    80001808:	fc99f2e3          	bgeu	s3,s1,800017cc <copyin+0x28>
    8000180c:	84ce                	mv	s1,s3
    8000180e:	bf7d                	j	800017cc <copyin+0x28>
  }
  return 0;
    80001810:	4501                	li	a0,0
    80001812:	a021                	j	8000181a <copyin+0x76>
    80001814:	4501                	li	a0,0
}
    80001816:	8082                	ret
      return -1;
    80001818:	557d                	li	a0,-1
}
    8000181a:	60a6                	ld	ra,72(sp)
    8000181c:	6406                	ld	s0,64(sp)
    8000181e:	74e2                	ld	s1,56(sp)
    80001820:	7942                	ld	s2,48(sp)
    80001822:	79a2                	ld	s3,40(sp)
    80001824:	7a02                	ld	s4,32(sp)
    80001826:	6ae2                	ld	s5,24(sp)
    80001828:	6b42                	ld	s6,16(sp)
    8000182a:	6ba2                	ld	s7,8(sp)
    8000182c:	6c02                	ld	s8,0(sp)
    8000182e:	6161                	addi	sp,sp,80
    80001830:	8082                	ret

0000000080001832 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001832:	cad5                	beqz	a3,800018e6 <copyinstr+0xb4>
{
    80001834:	715d                	addi	sp,sp,-80
    80001836:	e486                	sd	ra,72(sp)
    80001838:	e0a2                	sd	s0,64(sp)
    8000183a:	fc26                	sd	s1,56(sp)
    8000183c:	f84a                	sd	s2,48(sp)
    8000183e:	f44e                	sd	s3,40(sp)
    80001840:	f052                	sd	s4,32(sp)
    80001842:	ec56                	sd	s5,24(sp)
    80001844:	e85a                	sd	s6,16(sp)
    80001846:	e45e                	sd	s7,8(sp)
    80001848:	0880                	addi	s0,sp,80
    8000184a:	8aaa                	mv	s5,a0
    8000184c:	84ae                	mv	s1,a1
    8000184e:	8bb2                	mv	s7,a2
    80001850:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001852:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001854:	6a05                	lui	s4,0x1
    80001856:	a82d                	j	80001890 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001858:	00078023          	sb	zero,0(a5)
        got_null = 1;
    8000185c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000185e:	0017c793          	xori	a5,a5,1
    80001862:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001866:	60a6                	ld	ra,72(sp)
    80001868:	6406                	ld	s0,64(sp)
    8000186a:	74e2                	ld	s1,56(sp)
    8000186c:	7942                	ld	s2,48(sp)
    8000186e:	79a2                	ld	s3,40(sp)
    80001870:	7a02                	ld	s4,32(sp)
    80001872:	6ae2                	ld	s5,24(sp)
    80001874:	6b42                	ld	s6,16(sp)
    80001876:	6ba2                	ld	s7,8(sp)
    80001878:	6161                	addi	sp,sp,80
    8000187a:	8082                	ret
    8000187c:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001880:	9726                	add	a4,a4,s1
      --max;
    80001882:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80001886:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    8000188a:	04e58663          	beq	a1,a4,800018d6 <copyinstr+0xa4>
{
    8000188e:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001890:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001894:	85ca                	mv	a1,s2
    80001896:	8556                	mv	a0,s5
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	85e080e7          	jalr	-1954(ra) # 800010f6 <walkaddr>
    if(pa0 == 0)
    800018a0:	cd0d                	beqz	a0,800018da <copyinstr+0xa8>
    n = PGSIZE - (srcva - va0);
    800018a2:	417906b3          	sub	a3,s2,s7
    800018a6:	96d2                	add	a3,a3,s4
    if(n > max)
    800018a8:	00d9f363          	bgeu	s3,a3,800018ae <copyinstr+0x7c>
    800018ac:	86ce                	mv	a3,s3
    while(n > 0){
    800018ae:	ca85                	beqz	a3,800018de <copyinstr+0xac>
    char *p = (char *) (pa0 + (srcva - va0));
    800018b0:	01750633          	add	a2,a0,s7
    800018b4:	41260633          	sub	a2,a2,s2
    800018b8:	87a6                	mv	a5,s1
      if(*p == '\0'){
    800018ba:	8e05                	sub	a2,a2,s1
    while(n > 0){
    800018bc:	96a6                	add	a3,a3,s1
    800018be:	85be                	mv	a1,a5
      if(*p == '\0'){
    800018c0:	00f60733          	add	a4,a2,a5
    800018c4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffb1e98>
    800018c8:	db41                	beqz	a4,80001858 <copyinstr+0x26>
        *dst = *p;
    800018ca:	00e78023          	sb	a4,0(a5)
      dst++;
    800018ce:	0785                	addi	a5,a5,1
    while(n > 0){
    800018d0:	fed797e3          	bne	a5,a3,800018be <copyinstr+0x8c>
    800018d4:	b765                	j	8000187c <copyinstr+0x4a>
    800018d6:	4781                	li	a5,0
    800018d8:	b759                	j	8000185e <copyinstr+0x2c>
      return -1;
    800018da:	557d                	li	a0,-1
    800018dc:	b769                	j	80001866 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    800018de:	6b85                	lui	s7,0x1
    800018e0:	9bca                	add	s7,s7,s2
    800018e2:	87a6                	mv	a5,s1
    800018e4:	b76d                	j	8000188e <copyinstr+0x5c>
  int got_null = 0;
    800018e6:	4781                	li	a5,0
  if(got_null){
    800018e8:	0017c793          	xori	a5,a5,1
    800018ec:	40f0053b          	negw	a0,a5
}
    800018f0:	8082                	ret

00000000800018f2 <log_process_qquu>:
struct log_entry logs[MAX_LOG_ENTRIES];
int log_index = 0;

int jhjh =0 ;

void log_process_qquu(struct proc *p) {
    800018f2:	1141                	addi	sp,sp,-16
    800018f4:	e406                	sd	ra,8(sp)
    800018f6:	e022                	sd	s0,0(sp)
    800018f8:	0800                	addi	s0,sp,16
  if (log_index < MAX_LOG_ENTRIES) {
    800018fa:	00007797          	auipc	a5,0x7
    800018fe:	23a7a783          	lw	a5,570(a5) # 80008b34 <log_index>
    80001902:	6709                	lui	a4,0x2
    80001904:	75670713          	addi	a4,a4,1878 # 2756 <_entry-0x7fffd8aa>
    80001908:	02f74e63          	blt	a4,a5,80001944 <log_process_qquu+0x52>
    logs[log_index].pid = p->pid - 2;
    8000190c:	00479693          	slli	a3,a5,0x4
    80001910:	00019717          	auipc	a4,0x19
    80001914:	ef070713          	addi	a4,a4,-272 # 8001a800 <logs>
    80001918:	9736                	add	a4,a4,a3
    8000191a:	5914                	lw	a3,48(a0)
    8000191c:	36f9                	addiw	a3,a3,-2 # ffffffffffffeffe <end+0xffffffff7ffb1e96>
    8000191e:	c314                	sw	a3,0(a4)
    logs[log_index].time = jhjh;
    80001920:	00007697          	auipc	a3,0x7
    80001924:	2106a683          	lw	a3,528(a3) # 80008b30 <jhjh>
    80001928:	c354                	sw	a3,4(a4)
    logs[log_index].ticktime = ticks;
    8000192a:	00007697          	auipc	a3,0x7
    8000192e:	2166a683          	lw	a3,534(a3) # 80008b40 <ticks>
    80001932:	c714                	sw	a3,8(a4)
    logs[log_index].qquu = p->qquu;
    80001934:	23052683          	lw	a3,560(a0)
    80001938:	c754                	sw	a3,12(a4)
    log_index++;
    8000193a:	2785                	addiw	a5,a5,1
    8000193c:	00007717          	auipc	a4,0x7
    80001940:	1ef72c23          	sw	a5,504(a4) # 80008b34 <log_index>
  }
}
    80001944:	60a2                	ld	ra,8(sp)
    80001946:	6402                	ld	s0,0(sp)
    80001948:	0141                	addi	sp,sp,16
    8000194a:	8082                	ret

000000008000194c <count_trailing_zeros>:

  return p->slice_rem <= 0;
}


int count_trailing_zeros(uint64_t value) {
    8000194c:	1141                	addi	sp,sp,-16
    8000194e:	e406                	sd	ra,8(sp)
    80001950:	e022                	sd	s0,0(sp)
    80001952:	0800                	addi	s0,sp,16
    if (value == 0) {
    80001954:	cd19                	beqz	a0,80001972 <count_trailing_zeros+0x26>
    80001956:	87aa                	mv	a5,a0
        return 64; // If the value is zero, return 64 (all bits are zero)
    }
    
    int count = 0;
    while ((value & 1) == 0) { // While the least significant bit is 0
    80001958:	00157713          	andi	a4,a0,1
    8000195c:	ef11                	bnez	a4,80001978 <count_trailing_zeros+0x2c>
    int count = 0;
    8000195e:	4501                	li	a0,0
        count++;
    80001960:	2505                	addiw	a0,a0,1
        value >>= 1; // Right shift to check the next bit
    80001962:	8385                	srli	a5,a5,0x1
    while ((value & 1) == 0) { // While the least significant bit is 0
    80001964:	0017f713          	andi	a4,a5,1
    80001968:	df65                	beqz	a4,80001960 <count_trailing_zeros+0x14>
    }
    return count; // Return the count of trailing zeros
}
    8000196a:	60a2                	ld	ra,8(sp)
    8000196c:	6402                	ld	s0,0(sp)
    8000196e:	0141                	addi	sp,sp,16
    80001970:	8082                	ret
        return 64; // If the value is zero, return 64 (all bits are zero)
    80001972:	04000513          	li	a0,64
    80001976:	bfd5                	j	8000196a <count_trailing_zeros+0x1e>
    return count; // Return the count of trailing zeros
    80001978:	4501                	li	a0,0
    8000197a:	bfc5                	j	8000196a <count_trailing_zeros+0x1e>

000000008000197c <rg>:




int rg(int l, int r)
{
    8000197c:	1141                	addi	sp,sp,-16
    8000197e:	e406                	sd	ra,8(sp)
    80001980:	e022                	sd	s0,0(sp)
    80001982:	0800                	addi	s0,sp,16
  uint64 lbs_tr = (uint64)ticks + 0;
    80001984:	00007717          	auipc	a4,0x7
    80001988:	1bc76703          	lwu	a4,444(a4) # 80008b40 <ticks>
  lbs_tr = lbs_tr ^ (lbs_tr << 13);
    8000198c:	00d71793          	slli	a5,a4,0xd
    80001990:	8fb9                	xor	a5,a5,a4
  lbs_tr = lbs_tr ^ (lbs_tr >> 17);
    80001992:	0117d713          	srli	a4,a5,0x11
    80001996:	8f3d                	xor	a4,a4,a5
  lbs_tr = lbs_tr ^ (lbs_tr << 5);
    80001998:	00571793          	slli	a5,a4,0x5
    8000199c:	8fb9                	xor	a5,a5,a4

  lbs_tr = lbs_tr % (r - l);
    8000199e:	9d89                	subw	a1,a1,a0
    800019a0:	02b7f7b3          	remu	a5,a5,a1
  lbs_tr = lbs_tr + l;

  return lbs_tr;
}
    800019a4:	9d3d                	addw	a0,a0,a5
    800019a6:	60a2                	ld	ra,8(sp)
    800019a8:	6402                	ld	s0,0(sp)
    800019aa:	0141                	addi	sp,sp,16
    800019ac:	8082                	ret

00000000800019ae <max>:


int max(int a, int b)
{
    800019ae:	1141                	addi	sp,sp,-16
    800019b0:	e406                	sd	ra,8(sp)
    800019b2:	e022                	sd	s0,0(sp)
    800019b4:	0800                	addi	s0,sp,16

  if (a > b)
    800019b6:	87aa                	mv	a5,a0
    800019b8:	00b55363          	bge	a0,a1,800019be <max+0x10>
    800019bc:	87ae                	mv	a5,a1
  }
  else
  {
    return b;
  }
}
    800019be:	0007851b          	sext.w	a0,a5
    800019c2:	60a2                	ld	ra,8(sp)
    800019c4:	6402                	ld	s0,0(sp)
    800019c6:	0141                	addi	sp,sp,16
    800019c8:	8082                	ret

00000000800019ca <min>:

int min(int a, int b)
{
    800019ca:	1141                	addi	sp,sp,-16
    800019cc:	e406                	sd	ra,8(sp)
    800019ce:	e022                	sd	s0,0(sp)
    800019d0:	0800                	addi	s0,sp,16

  if (a < b)
    800019d2:	87aa                	mv	a5,a0
    800019d4:	00a5d363          	bge	a1,a0,800019da <min+0x10>
    800019d8:	87ae                	mv	a5,a1
  }
  else
  {
    return b;
  }
}
    800019da:	0007851b          	sext.w	a0,a5
    800019de:	60a2                	ld	ra,8(sp)
    800019e0:	6402                	ld	s0,0(sp)
    800019e2:	0141                	addi	sp,sp,16
    800019e4:	8082                	ret

00000000800019e6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    800019e6:	715d                	addi	sp,sp,-80
    800019e8:	e486                	sd	ra,72(sp)
    800019ea:	e0a2                	sd	s0,64(sp)
    800019ec:	fc26                	sd	s1,56(sp)
    800019ee:	f84a                	sd	s2,48(sp)
    800019f0:	f44e                	sd	s3,40(sp)
    800019f2:	f052                	sd	s4,32(sp)
    800019f4:	ec56                	sd	s5,24(sp)
    800019f6:	e85a                	sd	s6,16(sp)
    800019f8:	e45e                	sd	s7,8(sp)
    800019fa:	e062                	sd	s8,0(sp)
    800019fc:	0880                	addi	s0,sp,80
    800019fe:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001a00:	00010497          	auipc	s1,0x10
    80001a04:	80048493          	addi	s1,s1,-2048 # 80011200 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001a08:	8c26                	mv	s8,s1
    80001a0a:	000967b7          	lui	a5,0x96
    80001a0e:	2fd78793          	addi	a5,a5,765 # 962fd <_entry-0x7ff69d03>
    80001a12:	07b2                	slli	a5,a5,0xc
    80001a14:	96378793          	addi	a5,a5,-1693
    80001a18:	2fc96937          	lui	s2,0x2fc96
    80001a1c:	2fc90913          	addi	s2,s2,764 # 2fc962fc <_entry-0x50369d04>
    80001a20:	1902                	slli	s2,s2,0x20
    80001a22:	993e                	add	s2,s2,a5
    80001a24:	040009b7          	lui	s3,0x4000
    80001a28:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a2a:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001a2c:	4b99                	li	s7,6
    80001a2e:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++)
    80001a30:	00019a97          	auipc	s5,0x19
    80001a34:	dd0a8a93          	addi	s5,s5,-560 # 8001a800 <logs>
    char *pa = kalloc();
    80001a38:	fffff097          	auipc	ra,0xfffff
    80001a3c:	120080e7          	jalr	288(ra) # 80000b58 <kalloc>
    80001a40:	862a                	mv	a2,a0
    if (pa == 0)
    80001a42:	c131                	beqz	a0,80001a86 <proc_mapstacks+0xa0>
    uint64 va = KSTACK((int)(p - proc));
    80001a44:	418485b3          	sub	a1,s1,s8
    80001a48:	858d                	srai	a1,a1,0x3
    80001a4a:	032585b3          	mul	a1,a1,s2
    80001a4e:	05b6                	slli	a1,a1,0xd
    80001a50:	6789                	lui	a5,0x2
    80001a52:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001a54:	875e                	mv	a4,s7
    80001a56:	86da                	mv	a3,s6
    80001a58:	40b985b3          	sub	a1,s3,a1
    80001a5c:	8552                	mv	a0,s4
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	778080e7          	jalr	1912(ra) # 800011d6 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a66:	25848493          	addi	s1,s1,600
    80001a6a:	fd5497e3          	bne	s1,s5,80001a38 <proc_mapstacks+0x52>
  }
}
    80001a6e:	60a6                	ld	ra,72(sp)
    80001a70:	6406                	ld	s0,64(sp)
    80001a72:	74e2                	ld	s1,56(sp)
    80001a74:	7942                	ld	s2,48(sp)
    80001a76:	79a2                	ld	s3,40(sp)
    80001a78:	7a02                	ld	s4,32(sp)
    80001a7a:	6ae2                	ld	s5,24(sp)
    80001a7c:	6b42                	ld	s6,16(sp)
    80001a7e:	6ba2                	ld	s7,8(sp)
    80001a80:	6c02                	ld	s8,0(sp)
    80001a82:	6161                	addi	sp,sp,80
    80001a84:	8082                	ret
      panic("kalloc");
    80001a86:	00006517          	auipc	a0,0x6
    80001a8a:	73250513          	addi	a0,a0,1842 # 800081b8 <etext+0x1b8>
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	ad0080e7          	jalr	-1328(ra) # 8000055e <panic>

0000000080001a96 <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001a96:	7139                	addi	sp,sp,-64
    80001a98:	fc06                	sd	ra,56(sp)
    80001a9a:	f822                	sd	s0,48(sp)
    80001a9c:	f426                	sd	s1,40(sp)
    80001a9e:	f04a                	sd	s2,32(sp)
    80001aa0:	ec4e                	sd	s3,24(sp)
    80001aa2:	e852                	sd	s4,16(sp)
    80001aa4:	e456                	sd	s5,8(sp)
    80001aa6:	e05a                	sd	s6,0(sp)
    80001aa8:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001aaa:	00006597          	auipc	a1,0x6
    80001aae:	71658593          	addi	a1,a1,1814 # 800081c0 <etext+0x1c0>
    80001ab2:	0000f517          	auipc	a0,0xf
    80001ab6:	2fe50513          	addi	a0,a0,766 # 80010db0 <pid_lock>
    80001aba:	fffff097          	auipc	ra,0xfffff
    80001abe:	108080e7          	jalr	264(ra) # 80000bc2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001ac2:	00006597          	auipc	a1,0x6
    80001ac6:	70658593          	addi	a1,a1,1798 # 800081c8 <etext+0x1c8>
    80001aca:	0000f517          	auipc	a0,0xf
    80001ace:	2fe50513          	addi	a0,a0,766 # 80010dc8 <wait_lock>
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	0f0080e7          	jalr	240(ra) # 80000bc2 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001ada:	0000f497          	auipc	s1,0xf
    80001ade:	72648493          	addi	s1,s1,1830 # 80011200 <proc>
  {
    initlock(&p->lock, "proc");
    80001ae2:	00006b17          	auipc	s6,0x6
    80001ae6:	6f6b0b13          	addi	s6,s6,1782 # 800081d8 <etext+0x1d8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001aea:	8aa6                	mv	s5,s1
    80001aec:	000967b7          	lui	a5,0x96
    80001af0:	2fd78793          	addi	a5,a5,765 # 962fd <_entry-0x7ff69d03>
    80001af4:	07b2                	slli	a5,a5,0xc
    80001af6:	96378793          	addi	a5,a5,-1693
    80001afa:	2fc96937          	lui	s2,0x2fc96
    80001afe:	2fc90913          	addi	s2,s2,764 # 2fc962fc <_entry-0x50369d04>
    80001b02:	1902                	slli	s2,s2,0x20
    80001b04:	993e                	add	s2,s2,a5
    80001b06:	040009b7          	lui	s3,0x4000
    80001b0a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b0c:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001b0e:	00019a17          	auipc	s4,0x19
    80001b12:	cf2a0a13          	addi	s4,s4,-782 # 8001a800 <logs>
    initlock(&p->lock, "proc");
    80001b16:	85da                	mv	a1,s6
    80001b18:	8526                	mv	a0,s1
    80001b1a:	fffff097          	auipc	ra,0xfffff
    80001b1e:	0a8080e7          	jalr	168(ra) # 80000bc2 <initlock>
    p->state = UNUSED;
    80001b22:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001b26:	415487b3          	sub	a5,s1,s5
    80001b2a:	878d                	srai	a5,a5,0x3
    80001b2c:	032787b3          	mul	a5,a5,s2
    80001b30:	07b6                	slli	a5,a5,0xd
    80001b32:	6709                	lui	a4,0x2
    80001b34:	9fb9                	addw	a5,a5,a4
    80001b36:	40f987b3          	sub	a5,s3,a5
    80001b3a:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001b3c:	25848493          	addi	s1,s1,600
    80001b40:	fd449be3          	bne	s1,s4,80001b16 <procinit+0x80>
  }
}
    80001b44:	70e2                	ld	ra,56(sp)
    80001b46:	7442                	ld	s0,48(sp)
    80001b48:	74a2                	ld	s1,40(sp)
    80001b4a:	7902                	ld	s2,32(sp)
    80001b4c:	69e2                	ld	s3,24(sp)
    80001b4e:	6a42                	ld	s4,16(sp)
    80001b50:	6aa2                	ld	s5,8(sp)
    80001b52:	6b02                	ld	s6,0(sp)
    80001b54:	6121                	addi	sp,sp,64
    80001b56:	8082                	ret

0000000080001b58 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001b58:	1141                	addi	sp,sp,-16
    80001b5a:	e406                	sd	ra,8(sp)
    80001b5c:	e022                	sd	s0,0(sp)
    80001b5e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b60:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001b62:	2501                	sext.w	a0,a0
    80001b64:	60a2                	ld	ra,8(sp)
    80001b66:	6402                	ld	s0,0(sp)
    80001b68:	0141                	addi	sp,sp,16
    80001b6a:	8082                	ret

0000000080001b6c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001b6c:	1141                	addi	sp,sp,-16
    80001b6e:	e406                	sd	ra,8(sp)
    80001b70:	e022                	sd	s0,0(sp)
    80001b72:	0800                	addi	s0,sp,16
    80001b74:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001b76:	2781                	sext.w	a5,a5
    80001b78:	079e                	slli	a5,a5,0x7
  return c;
}
    80001b7a:	0000f517          	auipc	a0,0xf
    80001b7e:	26650513          	addi	a0,a0,614 # 80010de0 <cpus>
    80001b82:	953e                	add	a0,a0,a5
    80001b84:	60a2                	ld	ra,8(sp)
    80001b86:	6402                	ld	s0,0(sp)
    80001b88:	0141                	addi	sp,sp,16
    80001b8a:	8082                	ret

0000000080001b8c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001b8c:	1101                	addi	sp,sp,-32
    80001b8e:	ec06                	sd	ra,24(sp)
    80001b90:	e822                	sd	s0,16(sp)
    80001b92:	e426                	sd	s1,8(sp)
    80001b94:	1000                	addi	s0,sp,32
  push_off();
    80001b96:	fffff097          	auipc	ra,0xfffff
    80001b9a:	076080e7          	jalr	118(ra) # 80000c0c <push_off>
    80001b9e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001ba0:	2781                	sext.w	a5,a5
    80001ba2:	079e                	slli	a5,a5,0x7
    80001ba4:	0000f717          	auipc	a4,0xf
    80001ba8:	20c70713          	addi	a4,a4,524 # 80010db0 <pid_lock>
    80001bac:	97ba                	add	a5,a5,a4
    80001bae:	7b9c                	ld	a5,48(a5)
    80001bb0:	84be                	mv	s1,a5
  pop_off();
    80001bb2:	fffff097          	auipc	ra,0xfffff
    80001bb6:	0fe080e7          	jalr	254(ra) # 80000cb0 <pop_off>
  return p;
}
    80001bba:	8526                	mv	a0,s1
    80001bbc:	60e2                	ld	ra,24(sp)
    80001bbe:	6442                	ld	s0,16(sp)
    80001bc0:	64a2                	ld	s1,8(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret

0000000080001bc6 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001bc6:	1141                	addi	sp,sp,-16
    80001bc8:	e406                	sd	ra,8(sp)
    80001bca:	e022                	sd	s0,0(sp)
    80001bcc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001bce:	00000097          	auipc	ra,0x0
    80001bd2:	fbe080e7          	jalr	-66(ra) # 80001b8c <myproc>
    80001bd6:	fffff097          	auipc	ra,0xfffff
    80001bda:	136080e7          	jalr	310(ra) # 80000d0c <release>

  if (first)
    80001bde:	00007797          	auipc	a5,0x7
    80001be2:	e027a783          	lw	a5,-510(a5) # 800089e0 <first.0>
    80001be6:	eb89                	bnez	a5,80001bf8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001be8:	00001097          	auipc	ra,0x1
    80001bec:	118080e7          	jalr	280(ra) # 80002d00 <usertrapret>
}
    80001bf0:	60a2                	ld	ra,8(sp)
    80001bf2:	6402                	ld	s0,0(sp)
    80001bf4:	0141                	addi	sp,sp,16
    80001bf6:	8082                	ret
    first = 0;
    80001bf8:	00007797          	auipc	a5,0x7
    80001bfc:	de07a423          	sw	zero,-536(a5) # 800089e0 <first.0>
    fsinit(ROOTDEV);
    80001c00:	4505                	li	a0,1
    80001c02:	00002097          	auipc	ra,0x2
    80001c06:	05c080e7          	jalr	92(ra) # 80003c5e <fsinit>
    80001c0a:	bff9                	j	80001be8 <forkret+0x22>

0000000080001c0c <allocpid>:
{
    80001c0c:	1101                	addi	sp,sp,-32
    80001c0e:	ec06                	sd	ra,24(sp)
    80001c10:	e822                	sd	s0,16(sp)
    80001c12:	e426                	sd	s1,8(sp)
    80001c14:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001c16:	0000f517          	auipc	a0,0xf
    80001c1a:	19a50513          	addi	a0,a0,410 # 80010db0 <pid_lock>
    80001c1e:	fffff097          	auipc	ra,0xfffff
    80001c22:	03e080e7          	jalr	62(ra) # 80000c5c <acquire>
  pid = nextpid;
    80001c26:	00007797          	auipc	a5,0x7
    80001c2a:	dbe78793          	addi	a5,a5,-578 # 800089e4 <nextpid>
    80001c2e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001c30:	0014871b          	addiw	a4,s1,1
    80001c34:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001c36:	0000f517          	auipc	a0,0xf
    80001c3a:	17a50513          	addi	a0,a0,378 # 80010db0 <pid_lock>
    80001c3e:	fffff097          	auipc	ra,0xfffff
    80001c42:	0ce080e7          	jalr	206(ra) # 80000d0c <release>
}
    80001c46:	8526                	mv	a0,s1
    80001c48:	60e2                	ld	ra,24(sp)
    80001c4a:	6442                	ld	s0,16(sp)
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	6105                	addi	sp,sp,32
    80001c50:	8082                	ret

0000000080001c52 <proc_pagetable>:
{
    80001c52:	1101                	addi	sp,sp,-32
    80001c54:	ec06                	sd	ra,24(sp)
    80001c56:	e822                	sd	s0,16(sp)
    80001c58:	e426                	sd	s1,8(sp)
    80001c5a:	e04a                	sd	s2,0(sp)
    80001c5c:	1000                	addi	s0,sp,32
    80001c5e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	76c080e7          	jalr	1900(ra) # 800013cc <uvmcreate>
    80001c68:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001c6a:	c121                	beqz	a0,80001caa <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001c6c:	4729                	li	a4,10
    80001c6e:	00005697          	auipc	a3,0x5
    80001c72:	39268693          	addi	a3,a3,914 # 80007000 <_trampoline>
    80001c76:	6605                	lui	a2,0x1
    80001c78:	040005b7          	lui	a1,0x4000
    80001c7c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c7e:	05b2                	slli	a1,a1,0xc
    80001c80:	fffff097          	auipc	ra,0xfffff
    80001c84:	4b4080e7          	jalr	1204(ra) # 80001134 <mappages>
    80001c88:	02054863          	bltz	a0,80001cb8 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c8c:	4719                	li	a4,6
    80001c8e:	05893683          	ld	a3,88(s2)
    80001c92:	6605                	lui	a2,0x1
    80001c94:	020005b7          	lui	a1,0x2000
    80001c98:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c9a:	05b6                	slli	a1,a1,0xd
    80001c9c:	8526                	mv	a0,s1
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	496080e7          	jalr	1174(ra) # 80001134 <mappages>
    80001ca6:	02054163          	bltz	a0,80001cc8 <proc_pagetable+0x76>
}
    80001caa:	8526                	mv	a0,s1
    80001cac:	60e2                	ld	ra,24(sp)
    80001cae:	6442                	ld	s0,16(sp)
    80001cb0:	64a2                	ld	s1,8(sp)
    80001cb2:	6902                	ld	s2,0(sp)
    80001cb4:	6105                	addi	sp,sp,32
    80001cb6:	8082                	ret
    uvmfree(pagetable, 0);
    80001cb8:	4581                	li	a1,0
    80001cba:	8526                	mv	a0,s1
    80001cbc:	00000097          	auipc	ra,0x0
    80001cc0:	922080e7          	jalr	-1758(ra) # 800015de <uvmfree>
    return 0;
    80001cc4:	4481                	li	s1,0
    80001cc6:	b7d5                	j	80001caa <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001cc8:	4681                	li	a3,0
    80001cca:	4605                	li	a2,1
    80001ccc:	040005b7          	lui	a1,0x4000
    80001cd0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001cd2:	05b2                	slli	a1,a1,0xc
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	622080e7          	jalr	1570(ra) # 800012f8 <uvmunmap>
    uvmfree(pagetable, 0);
    80001cde:	4581                	li	a1,0
    80001ce0:	8526                	mv	a0,s1
    80001ce2:	00000097          	auipc	ra,0x0
    80001ce6:	8fc080e7          	jalr	-1796(ra) # 800015de <uvmfree>
    return 0;
    80001cea:	4481                	li	s1,0
    80001cec:	bf7d                	j	80001caa <proc_pagetable+0x58>

0000000080001cee <proc_freepagetable>:
{
    80001cee:	1101                	addi	sp,sp,-32
    80001cf0:	ec06                	sd	ra,24(sp)
    80001cf2:	e822                	sd	s0,16(sp)
    80001cf4:	e426                	sd	s1,8(sp)
    80001cf6:	e04a                	sd	s2,0(sp)
    80001cf8:	1000                	addi	s0,sp,32
    80001cfa:	84aa                	mv	s1,a0
    80001cfc:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001cfe:	4681                	li	a3,0
    80001d00:	4605                	li	a2,1
    80001d02:	040005b7          	lui	a1,0x4000
    80001d06:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d08:	05b2                	slli	a1,a1,0xc
    80001d0a:	fffff097          	auipc	ra,0xfffff
    80001d0e:	5ee080e7          	jalr	1518(ra) # 800012f8 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d12:	4681                	li	a3,0
    80001d14:	4605                	li	a2,1
    80001d16:	020005b7          	lui	a1,0x2000
    80001d1a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d1c:	05b6                	slli	a1,a1,0xd
    80001d1e:	8526                	mv	a0,s1
    80001d20:	fffff097          	auipc	ra,0xfffff
    80001d24:	5d8080e7          	jalr	1496(ra) # 800012f8 <uvmunmap>
  uvmfree(pagetable, sz);
    80001d28:	85ca                	mv	a1,s2
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	00000097          	auipc	ra,0x0
    80001d30:	8b2080e7          	jalr	-1870(ra) # 800015de <uvmfree>
}
    80001d34:	60e2                	ld	ra,24(sp)
    80001d36:	6442                	ld	s0,16(sp)
    80001d38:	64a2                	ld	s1,8(sp)
    80001d3a:	6902                	ld	s2,0(sp)
    80001d3c:	6105                	addi	sp,sp,32
    80001d3e:	8082                	ret

0000000080001d40 <freeproc>:
{
    80001d40:	1101                	addi	sp,sp,-32
    80001d42:	ec06                	sd	ra,24(sp)
    80001d44:	e822                	sd	s0,16(sp)
    80001d46:	e426                	sd	s1,8(sp)
    80001d48:	1000                	addi	s0,sp,32
    80001d4a:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001d4c:	6d28                	ld	a0,88(a0)
    80001d4e:	c509                	beqz	a0,80001d58 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001d50:	fffff097          	auipc	ra,0xfffff
    80001d54:	d04080e7          	jalr	-764(ra) # 80000a54 <kfree>
  p->trapframe = 0;
    80001d58:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001d5c:	68a8                	ld	a0,80(s1)
    80001d5e:	c511                	beqz	a0,80001d6a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001d60:	64ac                	ld	a1,72(s1)
    80001d62:	00000097          	auipc	ra,0x0
    80001d66:	f8c080e7          	jalr	-116(ra) # 80001cee <proc_freepagetable>
  p->pagetable = 0;
    80001d6a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001d6e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001d72:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001d76:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001d7a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001d7e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001d82:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001d86:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001d8a:	0004ac23          	sw	zero,24(s1)
}
    80001d8e:	60e2                	ld	ra,24(sp)
    80001d90:	6442                	ld	s0,16(sp)
    80001d92:	64a2                	ld	s1,8(sp)
    80001d94:	6105                	addi	sp,sp,32
    80001d96:	8082                	ret

0000000080001d98 <allocproc>:
{
    80001d98:	1101                	addi	sp,sp,-32
    80001d9a:	ec06                	sd	ra,24(sp)
    80001d9c:	e822                	sd	s0,16(sp)
    80001d9e:	e426                	sd	s1,8(sp)
    80001da0:	e04a                	sd	s2,0(sp)
    80001da2:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001da4:	0000f497          	auipc	s1,0xf
    80001da8:	45c48493          	addi	s1,s1,1116 # 80011200 <proc>
    80001dac:	00019917          	auipc	s2,0x19
    80001db0:	a5490913          	addi	s2,s2,-1452 # 8001a800 <logs>
    acquire(&p->lock);
    80001db4:	8526                	mv	a0,s1
    80001db6:	fffff097          	auipc	ra,0xfffff
    80001dba:	ea6080e7          	jalr	-346(ra) # 80000c5c <acquire>
    if (p->state == UNUSED)
    80001dbe:	4c9c                	lw	a5,24(s1)
    80001dc0:	cf81                	beqz	a5,80001dd8 <allocproc+0x40>
      release(&p->lock);
    80001dc2:	8526                	mv	a0,s1
    80001dc4:	fffff097          	auipc	ra,0xfffff
    80001dc8:	f48080e7          	jalr	-184(ra) # 80000d0c <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001dcc:	25848493          	addi	s1,s1,600
    80001dd0:	ff2492e3          	bne	s1,s2,80001db4 <allocproc+0x1c>
  return 0;
    80001dd4:	4481                	li	s1,0
    80001dd6:	a0f9                	j	80001ea4 <allocproc+0x10c>
  p->pid = allocpid();
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	e34080e7          	jalr	-460(ra) # 80001c0c <allocpid>
    80001de0:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001de2:	4785                	li	a5,1
    80001de4:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	d72080e7          	jalr	-654(ra) # 80000b58 <kalloc>
    80001dee:	892a                	mv	s2,a0
    80001df0:	eca8                	sd	a0,88(s1)
    80001df2:	c161                	beqz	a0,80001eb2 <allocproc+0x11a>
  p->pagetable = proc_pagetable(p);
    80001df4:	8526                	mv	a0,s1
    80001df6:	00000097          	auipc	ra,0x0
    80001dfa:	e5c080e7          	jalr	-420(ra) # 80001c52 <proc_pagetable>
    80001dfe:	892a                	mv	s2,a0
    80001e00:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001e02:	c561                	beqz	a0,80001eca <allocproc+0x132>
  memset(&p->context, 0, sizeof(p->context));
    80001e04:	07000613          	li	a2,112
    80001e08:	4581                	li	a1,0
    80001e0a:	06048513          	addi	a0,s1,96
    80001e0e:	fffff097          	auipc	ra,0xfffff
    80001e12:	f46080e7          	jalr	-186(ra) # 80000d54 <memset>
  p->context.ra = (uint64)forkret;
    80001e16:	00000797          	auipc	a5,0x0
    80001e1a:	db078793          	addi	a5,a5,-592 # 80001bc6 <forkret>
    80001e1e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001e20:	60bc                	ld	a5,64(s1)
    80001e22:	6705                	lui	a4,0x1
    80001e24:	97ba                	add	a5,a5,a4
    80001e26:	f4bc                	sd	a5,104(s1)
   memset(p->syscall_count, 0, sizeof(p->syscall_count));
    80001e28:	08000613          	li	a2,128
    80001e2c:	4581                	li	a1,0
    80001e2e:	17448513          	addi	a0,s1,372
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	f22080e7          	jalr	-222(ra) # 80000d54 <memset>
  p->rtime = 0;
    80001e3a:	1604a423          	sw	zero,360(s1)
  p->etime = 0;
    80001e3e:	1604a823          	sw	zero,368(s1)
  p->ctime = ticks;
    80001e42:	00007797          	auipc	a5,0x7
    80001e46:	cfe7a783          	lw	a5,-770(a5) # 80008b40 <ticks>
    80001e4a:	16f4a623          	sw	a5,364(s1)
  p->tickets = 1;
    80001e4e:	4705                	li	a4,1
    80001e50:	1ee4ac23          	sw	a4,504(s1)
  p->arrival_t =ticks;
    80001e54:	1782                	slli	a5,a5,0x20
    80001e56:	9381                	srli	a5,a5,0x20
    80001e58:	20f4b023          	sd	a5,512(s1)
  p->s_tcks = 0;
    80001e5c:	2004a623          	sw	zero,524(s1)
  p->hlp = 1;
    80001e60:	20e4ac23          	sw	a4,536(s1)
   p->twt = 0;
    80001e64:	2204a623          	sw	zero,556(s1)
  p->qquu = 0;
    80001e68:	2204a823          	sw	zero,560(s1)
  p->pqbb = 0;
    80001e6c:	2204aa23          	sw	zero,564(s1)
  p->ind_q = jghd[0];
    80001e70:	0000f797          	auipc	a5,0xf
    80001e74:	f4078793          	addi	a5,a5,-192 # 80010db0 <pid_lock>
    80001e78:	4307a703          	lw	a4,1072(a5)
    80001e7c:	22e4ac23          	sw	a4,568(s1)
  jghd[0]++;
    80001e80:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80001e82:	42e7a823          	sw	a4,1072(a5)
  arr_used_for_q[0]++;
    80001e86:	4407a703          	lw	a4,1088(a5)
    80001e8a:	2705                	addiw	a4,a4,1
    80001e8c:	44e7a023          	sw	a4,1088(a5)
  p->nice = 0;
    80001e90:	2204ae23          	sw	zero,572(s1)
  p->weight = nice_to_weight(p->nice);
    80001e94:	40000793          	li	a5,1024
    80001e98:	24f4b023          	sd	a5,576(s1)
  p->vruntime = 0;
    80001e9c:	2404b423          	sd	zero,584(s1)
  p->slice_rem = 0;
    80001ea0:	2404a823          	sw	zero,592(s1)
}
    80001ea4:	8526                	mv	a0,s1
    80001ea6:	60e2                	ld	ra,24(sp)
    80001ea8:	6442                	ld	s0,16(sp)
    80001eaa:	64a2                	ld	s1,8(sp)
    80001eac:	6902                	ld	s2,0(sp)
    80001eae:	6105                	addi	sp,sp,32
    80001eb0:	8082                	ret
    freeproc(p);
    80001eb2:	8526                	mv	a0,s1
    80001eb4:	00000097          	auipc	ra,0x0
    80001eb8:	e8c080e7          	jalr	-372(ra) # 80001d40 <freeproc>
    release(&p->lock);
    80001ebc:	8526                	mv	a0,s1
    80001ebe:	fffff097          	auipc	ra,0xfffff
    80001ec2:	e4e080e7          	jalr	-434(ra) # 80000d0c <release>
    return 0;
    80001ec6:	84ca                	mv	s1,s2
    80001ec8:	bff1                	j	80001ea4 <allocproc+0x10c>
    freeproc(p);
    80001eca:	8526                	mv	a0,s1
    80001ecc:	00000097          	auipc	ra,0x0
    80001ed0:	e74080e7          	jalr	-396(ra) # 80001d40 <freeproc>
    release(&p->lock);
    80001ed4:	8526                	mv	a0,s1
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	e36080e7          	jalr	-458(ra) # 80000d0c <release>
    return 0;
    80001ede:	84ca                	mv	s1,s2
    80001ee0:	b7d1                	j	80001ea4 <allocproc+0x10c>

0000000080001ee2 <userinit>:
{
    80001ee2:	1101                	addi	sp,sp,-32
    80001ee4:	ec06                	sd	ra,24(sp)
    80001ee6:	e822                	sd	s0,16(sp)
    80001ee8:	e426                	sd	s1,8(sp)
    80001eea:	1000                	addi	s0,sp,32
  p = allocproc();
    80001eec:	00000097          	auipc	ra,0x0
    80001ef0:	eac080e7          	jalr	-340(ra) # 80001d98 <allocproc>
    80001ef4:	84aa                	mv	s1,a0
  initproc = p;
    80001ef6:	00007797          	auipc	a5,0x7
    80001efa:	c2a7b923          	sd	a0,-974(a5) # 80008b28 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001efe:	03400613          	li	a2,52
    80001f02:	00007597          	auipc	a1,0x7
    80001f06:	aee58593          	addi	a1,a1,-1298 # 800089f0 <initcode>
    80001f0a:	6928                	ld	a0,80(a0)
    80001f0c:	fffff097          	auipc	ra,0xfffff
    80001f10:	4ee080e7          	jalr	1262(ra) # 800013fa <uvmfirst>
  p->sz = PGSIZE;
    80001f14:	6785                	lui	a5,0x1
    80001f16:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001f18:	6cb8                	ld	a4,88(s1)
    80001f1a:	00073c23          	sd	zero,24(a4)
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001f1e:	6cb8                	ld	a4,88(s1)
    80001f20:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f22:	4641                	li	a2,16
    80001f24:	00006597          	auipc	a1,0x6
    80001f28:	2bc58593          	addi	a1,a1,700 # 800081e0 <etext+0x1e0>
    80001f2c:	15848513          	addi	a0,s1,344
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	f7c080e7          	jalr	-132(ra) # 80000eac <safestrcpy>
  p->cwd = namei("/");
    80001f38:	00006517          	auipc	a0,0x6
    80001f3c:	2b850513          	addi	a0,a0,696 # 800081f0 <etext+0x1f0>
    80001f40:	00002097          	auipc	ra,0x2
    80001f44:	78a080e7          	jalr	1930(ra) # 800046ca <namei>
    80001f48:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001f4c:	478d                	li	a5,3
    80001f4e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001f50:	8526                	mv	a0,s1
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	dba080e7          	jalr	-582(ra) # 80000d0c <release>
}
    80001f5a:	60e2                	ld	ra,24(sp)
    80001f5c:	6442                	ld	s0,16(sp)
    80001f5e:	64a2                	ld	s1,8(sp)
    80001f60:	6105                	addi	sp,sp,32
    80001f62:	8082                	ret

0000000080001f64 <growproc>:
{
    80001f64:	1101                	addi	sp,sp,-32
    80001f66:	ec06                	sd	ra,24(sp)
    80001f68:	e822                	sd	s0,16(sp)
    80001f6a:	e426                	sd	s1,8(sp)
    80001f6c:	e04a                	sd	s2,0(sp)
    80001f6e:	1000                	addi	s0,sp,32
    80001f70:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001f72:	00000097          	auipc	ra,0x0
    80001f76:	c1a080e7          	jalr	-998(ra) # 80001b8c <myproc>
    80001f7a:	84aa                	mv	s1,a0
  sz = p->sz;
    80001f7c:	652c                	ld	a1,72(a0)
  if (n > 0)
    80001f7e:	01204c63          	bgtz	s2,80001f96 <growproc+0x32>
  else if (n < 0)
    80001f82:	02094663          	bltz	s2,80001fae <growproc+0x4a>
  p->sz = sz;
    80001f86:	e4ac                	sd	a1,72(s1)
  return 0;
    80001f88:	4501                	li	a0,0
}
    80001f8a:	60e2                	ld	ra,24(sp)
    80001f8c:	6442                	ld	s0,16(sp)
    80001f8e:	64a2                	ld	s1,8(sp)
    80001f90:	6902                	ld	s2,0(sp)
    80001f92:	6105                	addi	sp,sp,32
    80001f94:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001f96:	4691                	li	a3,4
    80001f98:	00b90633          	add	a2,s2,a1
    80001f9c:	6928                	ld	a0,80(a0)
    80001f9e:	fffff097          	auipc	ra,0xfffff
    80001fa2:	516080e7          	jalr	1302(ra) # 800014b4 <uvmalloc>
    80001fa6:	85aa                	mv	a1,a0
    80001fa8:	fd79                	bnez	a0,80001f86 <growproc+0x22>
      return -1;
    80001faa:	557d                	li	a0,-1
    80001fac:	bff9                	j	80001f8a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001fae:	00b90633          	add	a2,s2,a1
    80001fb2:	6928                	ld	a0,80(a0)
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	4b8080e7          	jalr	1208(ra) # 8000146c <uvmdealloc>
    80001fbc:	85aa                	mv	a1,a0
    80001fbe:	b7e1                	j	80001f86 <growproc+0x22>

0000000080001fc0 <fork>:
{
    80001fc0:	7139                	addi	sp,sp,-64
    80001fc2:	fc06                	sd	ra,56(sp)
    80001fc4:	f822                	sd	s0,48(sp)
    80001fc6:	f426                	sd	s1,40(sp)
    80001fc8:	e456                	sd	s5,8(sp)
    80001fca:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001fcc:	00000097          	auipc	ra,0x0
    80001fd0:	bc0080e7          	jalr	-1088(ra) # 80001b8c <myproc>
    80001fd4:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	dc2080e7          	jalr	-574(ra) # 80001d98 <allocproc>
    80001fde:	12050863          	beqz	a0,8000210e <fork+0x14e>
    80001fe2:	ec4e                	sd	s3,24(sp)
    80001fe4:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001fe6:	048ab603          	ld	a2,72(s5)
    80001fea:	692c                	ld	a1,80(a0)
    80001fec:	050ab503          	ld	a0,80(s5)
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	628080e7          	jalr	1576(ra) # 80001618 <uvmcopy>
    80001ff8:	04054c63          	bltz	a0,80002050 <fork+0x90>
    80001ffc:	f04a                	sd	s2,32(sp)
    80001ffe:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80002000:	048ab783          	ld	a5,72(s5)
    80002004:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80002008:	058ab683          	ld	a3,88(s5)
    8000200c:	87b6                	mv	a5,a3
    8000200e:	0589b703          	ld	a4,88(s3)
    80002012:	12068693          	addi	a3,a3,288
    80002016:	6388                	ld	a0,0(a5)
    80002018:	678c                	ld	a1,8(a5)
    8000201a:	6b90                	ld	a2,16(a5)
    8000201c:	e308                	sd	a0,0(a4)
    8000201e:	e70c                	sd	a1,8(a4)
    80002020:	eb10                	sd	a2,16(a4)
    80002022:	6f90                	ld	a2,24(a5)
    80002024:	ef10                	sd	a2,24(a4)
    80002026:	02078793          	addi	a5,a5,32 # 1020 <_entry-0x7fffefe0>
    8000202a:	02070713          	addi	a4,a4,32
    8000202e:	fed794e3          	bne	a5,a3,80002016 <fork+0x56>
  np->s1 = p->s1;
    80002032:	1f4aa783          	lw	a5,500(s5)
    80002036:	1ef9aa23          	sw	a5,500(s3)
  np->trapframe->a0 = 0;
    8000203a:	0589b783          	ld	a5,88(s3)
    8000203e:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80002042:	0d0a8493          	addi	s1,s5,208
    80002046:	0d098913          	addi	s2,s3,208
    8000204a:	150a8a13          	addi	s4,s5,336
    8000204e:	a015                	j	80002072 <fork+0xb2>
    freeproc(np);
    80002050:	854e                	mv	a0,s3
    80002052:	00000097          	auipc	ra,0x0
    80002056:	cee080e7          	jalr	-786(ra) # 80001d40 <freeproc>
    release(&np->lock);
    8000205a:	854e                	mv	a0,s3
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	cb0080e7          	jalr	-848(ra) # 80000d0c <release>
    return -1;
    80002064:	54fd                	li	s1,-1
    80002066:	69e2                	ld	s3,24(sp)
    80002068:	a861                	j	80002100 <fork+0x140>
  for (i = 0; i < NOFILE; i++)
    8000206a:	04a1                	addi	s1,s1,8
    8000206c:	0921                	addi	s2,s2,8
    8000206e:	01448b63          	beq	s1,s4,80002084 <fork+0xc4>
    if (p->ofile[i])
    80002072:	6088                	ld	a0,0(s1)
    80002074:	d97d                	beqz	a0,8000206a <fork+0xaa>
      np->ofile[i] = filedup(p->ofile[i]);
    80002076:	00003097          	auipc	ra,0x3
    8000207a:	d22080e7          	jalr	-734(ra) # 80004d98 <filedup>
    8000207e:	00a93023          	sd	a0,0(s2)
    80002082:	b7e5                	j	8000206a <fork+0xaa>
  np->cwd = idup(p->cwd);
    80002084:	150ab503          	ld	a0,336(s5)
    80002088:	00002097          	auipc	ra,0x2
    8000208c:	e1a080e7          	jalr	-486(ra) # 80003ea2 <idup>
    80002090:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002094:	4641                	li	a2,16
    80002096:	158a8593          	addi	a1,s5,344
    8000209a:	15898513          	addi	a0,s3,344
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	e0e080e7          	jalr	-498(ra) # 80000eac <safestrcpy>
  pid = np->pid;
    800020a6:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    800020aa:	854e                	mv	a0,s3
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	c60080e7          	jalr	-928(ra) # 80000d0c <release>
  acquire(&wait_lock);
    800020b4:	0000f517          	auipc	a0,0xf
    800020b8:	d1450513          	addi	a0,a0,-748 # 80010dc8 <wait_lock>
    800020bc:	fffff097          	auipc	ra,0xfffff
    800020c0:	ba0080e7          	jalr	-1120(ra) # 80000c5c <acquire>
  np->parent = p;
    800020c4:	0359bc23          	sd	s5,56(s3)
  np->tickets = np->parent->tickets;
    800020c8:	1f8aa783          	lw	a5,504(s5)
    800020cc:	1ef9ac23          	sw	a5,504(s3)
  release(&wait_lock);
    800020d0:	0000f517          	auipc	a0,0xf
    800020d4:	cf850513          	addi	a0,a0,-776 # 80010dc8 <wait_lock>
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	c34080e7          	jalr	-972(ra) # 80000d0c <release>
  acquire(&np->lock);
    800020e0:	854e                	mv	a0,s3
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	b7a080e7          	jalr	-1158(ra) # 80000c5c <acquire>
  np->state = RUNNABLE;
    800020ea:	478d                	li	a5,3
    800020ec:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800020f0:	854e                	mv	a0,s3
    800020f2:	fffff097          	auipc	ra,0xfffff
    800020f6:	c1a080e7          	jalr	-998(ra) # 80000d0c <release>
  return pid;
    800020fa:	7902                	ld	s2,32(sp)
    800020fc:	69e2                	ld	s3,24(sp)
    800020fe:	6a42                	ld	s4,16(sp)
}
    80002100:	8526                	mv	a0,s1
    80002102:	70e2                	ld	ra,56(sp)
    80002104:	7442                	ld	s0,48(sp)
    80002106:	74a2                	ld	s1,40(sp)
    80002108:	6aa2                	ld	s5,8(sp)
    8000210a:	6121                	addi	sp,sp,64
    8000210c:	8082                	ret
    return -1;
    8000210e:	54fd                	li	s1,-1
    80002110:	bfc5                	j	80002100 <fork+0x140>

0000000080002112 <nice_to_weight>:
{
    80002112:	1141                	addi	sp,sp,-16
    80002114:	e406                	sd	ra,8(sp)
    80002116:	e022                	sd	s0,0(sp)
    80002118:	0800                	addi	s0,sp,16
    8000211a:	87aa                	mv	a5,a0
  if(nice >  19) nice =  19;
    8000211c:	872a                	mv	a4,a0
    8000211e:	46cd                	li	a3,19
    80002120:	00a6d363          	bge	a3,a0,80002126 <nice_to_weight+0x14>
    80002124:	474d                	li	a4,19
  if(nice < -20) nice = -20;
    80002126:	0007069b          	sext.w	a3,a4
    8000212a:	5631                	li	a2,-20
    8000212c:	00c6d363          	bge	a3,a2,80002132 <nice_to_weight+0x20>
    80002130:	5731                	li	a4,-20
    80002132:	2701                	sext.w	a4,a4
  if(nice > 0){
    80002134:	02f05863          	blez	a5,80002164 <nice_to_weight+0x52>
    for(int i = 0; i < nice; i++){
    80002138:	4781                	li	a5,0
  uint64 w = 1024;
    8000213a:	40000513          	li	a0,1024
      w = (w * 4 + 2) / 5;
    8000213e:	ccccd637          	lui	a2,0xccccd
    80002142:	ccd60613          	addi	a2,a2,-819 # ffffffffcccccccd <end+0xffffffff4cc7fb65>
    80002146:	02061693          	slli	a3,a2,0x20
    8000214a:	96b2                	add	a3,a3,a2
    8000214c:	050a                	slli	a0,a0,0x2
    8000214e:	0509                	addi	a0,a0,2
    80002150:	02d53533          	mulhu	a0,a0,a3
    80002154:	8109                	srli	a0,a0,0x2
    for(int i = 0; i < nice; i++){
    80002156:	2785                	addiw	a5,a5,1
    80002158:	fee7cae3          	blt	a5,a4,8000214c <nice_to_weight+0x3a>
}
    8000215c:	60a2                	ld	ra,8(sp)
    8000215e:	6402                	ld	s0,0(sp)
    80002160:	0141                	addi	sp,sp,16
    80002162:	8082                	ret
  uint64 w = 1024;
    80002164:	40000513          	li	a0,1024
  } else if(nice < 0){
    80002168:	fe07dae3          	bgez	a5,8000215c <nice_to_weight+0x4a>
    for(int i = 0; i < -nice; i++){
    8000216c:	40e0073b          	negw	a4,a4
    80002170:	4681                	li	a3,0
      w = (w * 5 + 2) / 4;
    80002172:	00251793          	slli	a5,a0,0x2
    80002176:	97aa                	add	a5,a5,a0
    80002178:	0789                	addi	a5,a5,2
    8000217a:	0027d513          	srli	a0,a5,0x2
    for(int i = 0; i < -nice; i++){
    8000217e:	2685                	addiw	a3,a3,1
    80002180:	fee699e3          	bne	a3,a4,80002172 <nice_to_weight+0x60>
    80002184:	bfe1                	j	8000215c <nice_to_weight+0x4a>

0000000080002186 <runnable_count>:
{
    80002186:	7179                	addi	sp,sp,-48
    80002188:	f406                	sd	ra,40(sp)
    8000218a:	f022                	sd	s0,32(sp)
    8000218c:	ec26                	sd	s1,24(sp)
    8000218e:	e84a                	sd	s2,16(sp)
    80002190:	e44e                	sd	s3,8(sp)
    80002192:	e052                	sd	s4,0(sp)
    80002194:	1800                	addi	s0,sp,48
  int n = 0;
    80002196:	4a01                	li	s4,0
  for(p = proc; p < &proc[NPROC]; p++){
    80002198:	0000f497          	auipc	s1,0xf
    8000219c:	06848493          	addi	s1,s1,104 # 80011200 <proc>
    if(p->state == RUNNABLE) n++;
    800021a0:	498d                	li	s3,3
  for(p = proc; p < &proc[NPROC]; p++){
    800021a2:	00018917          	auipc	s2,0x18
    800021a6:	65e90913          	addi	s2,s2,1630 # 8001a800 <logs>
    800021aa:	a811                	j	800021be <runnable_count+0x38>
    release(&p->lock);
    800021ac:	8526                	mv	a0,s1
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	b5e080e7          	jalr	-1186(ra) # 80000d0c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800021b6:	25848493          	addi	s1,s1,600
    800021ba:	01248c63          	beq	s1,s2,800021d2 <runnable_count+0x4c>
    acquire(&p->lock);
    800021be:	8526                	mv	a0,s1
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	a9c080e7          	jalr	-1380(ra) # 80000c5c <acquire>
    if(p->state == RUNNABLE) n++;
    800021c8:	4c9c                	lw	a5,24(s1)
    800021ca:	ff3791e3          	bne	a5,s3,800021ac <runnable_count+0x26>
    800021ce:	2a05                	addiw	s4,s4,1
    800021d0:	bff1                	j	800021ac <runnable_count+0x26>
}
    800021d2:	8552                	mv	a0,s4
    800021d4:	70a2                	ld	ra,40(sp)
    800021d6:	7402                	ld	s0,32(sp)
    800021d8:	64e2                	ld	s1,24(sp)
    800021da:	6942                	ld	s2,16(sp)
    800021dc:	69a2                	ld	s3,8(sp)
    800021de:	6a02                	ld	s4,0(sp)
    800021e0:	6145                	addi	sp,sp,48
    800021e2:	8082                	ret

00000000800021e4 <cfs_update_vruntime>:
{
    800021e4:	1141                	addi	sp,sp,-16
    800021e6:	e406                	sd	ra,8(sp)
    800021e8:	e022                	sd	s0,0(sp)
    800021ea:	0800                	addi	s0,sp,16
  if(delta_ticks <= 0) return;
    800021ec:	00b05f63          	blez	a1,8000220a <cfs_update_vruntime+0x26>
  uint64 w = p->weight ? p->weight : 1024;
    800021f0:	24053783          	ld	a5,576(a0)
    800021f4:	e399                	bnez	a5,800021fa <cfs_update_vruntime+0x16>
    800021f6:	40000793          	li	a5,1024
  uint64 inc = ((uint64)delta_ticks * 1024ull * 1024ull) / w;
    800021fa:	05d2                	slli	a1,a1,0x14
    800021fc:	02f5d5b3          	divu	a1,a1,a5
  p->vruntime += inc;
    80002200:	24853783          	ld	a5,584(a0)
    80002204:	97ae                	add	a5,a5,a1
    80002206:	24f53423          	sd	a5,584(a0)
}
    8000220a:	60a2                	ld	ra,8(sp)
    8000220c:	6402                	ld	s0,0(sp)
    8000220e:	0141                	addi	sp,sp,16
    80002210:	8082                	ret

0000000080002212 <cfs_tick_and_should_preempt>:
{
    80002212:	1101                	addi	sp,sp,-32
    80002214:	ec06                	sd	ra,24(sp)
    80002216:	e822                	sd	s0,16(sp)
    80002218:	e426                	sd	s1,8(sp)
    8000221a:	1000                	addi	s0,sp,32
    8000221c:	84aa                	mv	s1,a0
  cfs_update_vruntime(p, 1);
    8000221e:	4585                	li	a1,1
    80002220:	00000097          	auipc	ra,0x0
    80002224:	fc4080e7          	jalr	-60(ra) # 800021e4 <cfs_update_vruntime>
  if(p->slice_rem > 0)
    80002228:	2504a783          	lw	a5,592(s1)
    8000222c:	00f05563          	blez	a5,80002236 <cfs_tick_and_should_preempt+0x24>
    p->slice_rem--;
    80002230:	37fd                	addiw	a5,a5,-1
    80002232:	24f4a823          	sw	a5,592(s1)
  return p->slice_rem <= 0;
    80002236:	2504a503          	lw	a0,592(s1)
}
    8000223a:	00152513          	slti	a0,a0,1
    8000223e:	60e2                	ld	ra,24(sp)
    80002240:	6442                	ld	s0,16(sp)
    80002242:	64a2                	ld	s1,8(sp)
    80002244:	6105                	addi	sp,sp,32
    80002246:	8082                	ret

0000000080002248 <scheduler>:
{  
    80002248:	7139                	addi	sp,sp,-64
    8000224a:	fc06                	sd	ra,56(sp)
    8000224c:	f822                	sd	s0,48(sp)
    8000224e:	f426                	sd	s1,40(sp)
    80002250:	f04a                	sd	s2,32(sp)
    80002252:	ec4e                	sd	s3,24(sp)
    80002254:	e852                	sd	s4,16(sp)
    80002256:	e456                	sd	s5,8(sp)
    80002258:	e05a                	sd	s6,0(sp)
    8000225a:	0080                	addi	s0,sp,64
    8000225c:	8792                	mv	a5,tp
  int id = r_tp();
    8000225e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002260:	00779a93          	slli	s5,a5,0x7
    80002264:	0000f717          	auipc	a4,0xf
    80002268:	b4c70713          	addi	a4,a4,-1204 # 80010db0 <pid_lock>
    8000226c:	9756                	add	a4,a4,s5
    8000226e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002272:	0000f717          	auipc	a4,0xf
    80002276:	b7670713          	addi	a4,a4,-1162 # 80010de8 <cpus+0x8>
    8000227a:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    8000227c:	498d                	li	s3,3
        p->state = RUNNING;
    8000227e:	4b11                	li	s6,4
        c->proc = p;
    80002280:	079e                	slli	a5,a5,0x7
    80002282:	0000fa17          	auipc	s4,0xf
    80002286:	b2ea0a13          	addi	s4,s4,-1234 # 80010db0 <pid_lock>
    8000228a:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000228c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002290:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002294:	10079073          	csrw	sstatus,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80002298:	0000f497          	auipc	s1,0xf
    8000229c:	f6848493          	addi	s1,s1,-152 # 80011200 <proc>
    800022a0:	00018917          	auipc	s2,0x18
    800022a4:	56090913          	addi	s2,s2,1376 # 8001a800 <logs>
    800022a8:	a811                	j	800022bc <scheduler+0x74>
      release(&p->lock);
    800022aa:	8526                	mv	a0,s1
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	a60080e7          	jalr	-1440(ra) # 80000d0c <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800022b4:	25848493          	addi	s1,s1,600
    800022b8:	fd248ae3          	beq	s1,s2,8000228c <scheduler+0x44>
      acquire(&p->lock);
    800022bc:	8526                	mv	a0,s1
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	99e080e7          	jalr	-1634(ra) # 80000c5c <acquire>
      if (p->state == RUNNABLE)
    800022c6:	4c9c                	lw	a5,24(s1)
    800022c8:	ff3791e3          	bne	a5,s3,800022aa <scheduler+0x62>
        p->state = RUNNING;
    800022cc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800022d0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800022d4:	06048593          	addi	a1,s1,96
    800022d8:	8556                	mv	a0,s5
    800022da:	00001097          	auipc	ra,0x1
    800022de:	978080e7          	jalr	-1672(ra) # 80002c52 <swtch>
        c->proc = 0;
    800022e2:	020a3823          	sd	zero,48(s4)
    800022e6:	b7d1                	j	800022aa <scheduler+0x62>

00000000800022e8 <sched>:
{
    800022e8:	7179                	addi	sp,sp,-48
    800022ea:	f406                	sd	ra,40(sp)
    800022ec:	f022                	sd	s0,32(sp)
    800022ee:	ec26                	sd	s1,24(sp)
    800022f0:	e84a                	sd	s2,16(sp)
    800022f2:	e44e                	sd	s3,8(sp)
    800022f4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800022f6:	00000097          	auipc	ra,0x0
    800022fa:	896080e7          	jalr	-1898(ra) # 80001b8c <myproc>
    800022fe:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	8dc080e7          	jalr	-1828(ra) # 80000bdc <holding>
    80002308:	cd25                	beqz	a0,80002380 <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000230a:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    8000230c:	2781                	sext.w	a5,a5
    8000230e:	079e                	slli	a5,a5,0x7
    80002310:	0000f717          	auipc	a4,0xf
    80002314:	aa070713          	addi	a4,a4,-1376 # 80010db0 <pid_lock>
    80002318:	97ba                	add	a5,a5,a4
    8000231a:	0a87a703          	lw	a4,168(a5)
    8000231e:	4785                	li	a5,1
    80002320:	06f71863          	bne	a4,a5,80002390 <sched+0xa8>
  if (p->state == RUNNING)
    80002324:	4c98                	lw	a4,24(s1)
    80002326:	4791                	li	a5,4
    80002328:	06f70c63          	beq	a4,a5,800023a0 <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000232c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002330:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002332:	efbd                	bnez	a5,800023b0 <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002334:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002336:	0000f917          	auipc	s2,0xf
    8000233a:	a7a90913          	addi	s2,s2,-1414 # 80010db0 <pid_lock>
    8000233e:	2781                	sext.w	a5,a5
    80002340:	079e                	slli	a5,a5,0x7
    80002342:	97ca                	add	a5,a5,s2
    80002344:	0ac7a983          	lw	s3,172(a5)
    80002348:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000234a:	2781                	sext.w	a5,a5
    8000234c:	079e                	slli	a5,a5,0x7
    8000234e:	07a1                	addi	a5,a5,8
    80002350:	0000f597          	auipc	a1,0xf
    80002354:	a9058593          	addi	a1,a1,-1392 # 80010de0 <cpus>
    80002358:	95be                	add	a1,a1,a5
    8000235a:	06048513          	addi	a0,s1,96
    8000235e:	00001097          	auipc	ra,0x1
    80002362:	8f4080e7          	jalr	-1804(ra) # 80002c52 <swtch>
    80002366:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002368:	2781                	sext.w	a5,a5
    8000236a:	079e                	slli	a5,a5,0x7
    8000236c:	993e                	add	s2,s2,a5
    8000236e:	0b392623          	sw	s3,172(s2)
}
    80002372:	70a2                	ld	ra,40(sp)
    80002374:	7402                	ld	s0,32(sp)
    80002376:	64e2                	ld	s1,24(sp)
    80002378:	6942                	ld	s2,16(sp)
    8000237a:	69a2                	ld	s3,8(sp)
    8000237c:	6145                	addi	sp,sp,48
    8000237e:	8082                	ret
    panic("sched p->lock");
    80002380:	00006517          	auipc	a0,0x6
    80002384:	e7850513          	addi	a0,a0,-392 # 800081f8 <etext+0x1f8>
    80002388:	ffffe097          	auipc	ra,0xffffe
    8000238c:	1d6080e7          	jalr	470(ra) # 8000055e <panic>
    panic("sched locks");
    80002390:	00006517          	auipc	a0,0x6
    80002394:	e7850513          	addi	a0,a0,-392 # 80008208 <etext+0x208>
    80002398:	ffffe097          	auipc	ra,0xffffe
    8000239c:	1c6080e7          	jalr	454(ra) # 8000055e <panic>
    panic("sched running");
    800023a0:	00006517          	auipc	a0,0x6
    800023a4:	e7850513          	addi	a0,a0,-392 # 80008218 <etext+0x218>
    800023a8:	ffffe097          	auipc	ra,0xffffe
    800023ac:	1b6080e7          	jalr	438(ra) # 8000055e <panic>
    panic("sched interruptible");
    800023b0:	00006517          	auipc	a0,0x6
    800023b4:	e7850513          	addi	a0,a0,-392 # 80008228 <etext+0x228>
    800023b8:	ffffe097          	auipc	ra,0xffffe
    800023bc:	1a6080e7          	jalr	422(ra) # 8000055e <panic>

00000000800023c0 <yield>:
{
    800023c0:	1101                	addi	sp,sp,-32
    800023c2:	ec06                	sd	ra,24(sp)
    800023c4:	e822                	sd	s0,16(sp)
    800023c6:	e426                	sd	s1,8(sp)
    800023c8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800023ca:	fffff097          	auipc	ra,0xfffff
    800023ce:	7c2080e7          	jalr	1986(ra) # 80001b8c <myproc>
    800023d2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	888080e7          	jalr	-1912(ra) # 80000c5c <acquire>
  p->state = RUNNABLE;
    800023dc:	478d                	li	a5,3
    800023de:	cc9c                	sw	a5,24(s1)
  sched();
    800023e0:	00000097          	auipc	ra,0x0
    800023e4:	f08080e7          	jalr	-248(ra) # 800022e8 <sched>
  release(&p->lock);
    800023e8:	8526                	mv	a0,s1
    800023ea:	fffff097          	auipc	ra,0xfffff
    800023ee:	922080e7          	jalr	-1758(ra) # 80000d0c <release>
}
    800023f2:	60e2                	ld	ra,24(sp)
    800023f4:	6442                	ld	s0,16(sp)
    800023f6:	64a2                	ld	s1,8(sp)
    800023f8:	6105                	addi	sp,sp,32
    800023fa:	8082                	ret

00000000800023fc <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800023fc:	7179                	addi	sp,sp,-48
    800023fe:	f406                	sd	ra,40(sp)
    80002400:	f022                	sd	s0,32(sp)
    80002402:	ec26                	sd	s1,24(sp)
    80002404:	e84a                	sd	s2,16(sp)
    80002406:	e44e                	sd	s3,8(sp)
    80002408:	1800                	addi	s0,sp,48
    8000240a:	89aa                	mv	s3,a0
    8000240c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000240e:	fffff097          	auipc	ra,0xfffff
    80002412:	77e080e7          	jalr	1918(ra) # 80001b8c <myproc>
    80002416:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	844080e7          	jalr	-1980(ra) # 80000c5c <acquire>
  release(lk);
    80002420:	854a                	mv	a0,s2
    80002422:	fffff097          	auipc	ra,0xfffff
    80002426:	8ea080e7          	jalr	-1814(ra) # 80000d0c <release>

  // Go to sleep.
  p->chan = chan;
    8000242a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000242e:	4789                	li	a5,2
    80002430:	cc9c                	sw	a5,24(s1)

  sched();
    80002432:	00000097          	auipc	ra,0x0
    80002436:	eb6080e7          	jalr	-330(ra) # 800022e8 <sched>

  // Tidy up.
  p->chan = 0;
    8000243a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000243e:	8526                	mv	a0,s1
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	8cc080e7          	jalr	-1844(ra) # 80000d0c <release>
  acquire(lk);
    80002448:	854a                	mv	a0,s2
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	812080e7          	jalr	-2030(ra) # 80000c5c <acquire>
}
    80002452:	70a2                	ld	ra,40(sp)
    80002454:	7402                	ld	s0,32(sp)
    80002456:	64e2                	ld	s1,24(sp)
    80002458:	6942                	ld	s2,16(sp)
    8000245a:	69a2                	ld	s3,8(sp)
    8000245c:	6145                	addi	sp,sp,48
    8000245e:	8082                	ret

0000000080002460 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002460:	7139                	addi	sp,sp,-64
    80002462:	fc06                	sd	ra,56(sp)
    80002464:	f822                	sd	s0,48(sp)
    80002466:	f426                	sd	s1,40(sp)
    80002468:	f04a                	sd	s2,32(sp)
    8000246a:	ec4e                	sd	s3,24(sp)
    8000246c:	e852                	sd	s4,16(sp)
    8000246e:	e456                	sd	s5,8(sp)
    80002470:	0080                	addi	s0,sp,64
    80002472:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002474:	0000f497          	auipc	s1,0xf
    80002478:	d8c48493          	addi	s1,s1,-628 # 80011200 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    8000247c:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    8000247e:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002480:	00018917          	auipc	s2,0x18
    80002484:	38090913          	addi	s2,s2,896 # 8001a800 <logs>
    80002488:	a811                	j	8000249c <wakeup+0x3c>
      }
      release(&p->lock);
    8000248a:	8526                	mv	a0,s1
    8000248c:	fffff097          	auipc	ra,0xfffff
    80002490:	880080e7          	jalr	-1920(ra) # 80000d0c <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002494:	25848493          	addi	s1,s1,600
    80002498:	03248663          	beq	s1,s2,800024c4 <wakeup+0x64>
    if (p != myproc())
    8000249c:	fffff097          	auipc	ra,0xfffff
    800024a0:	6f0080e7          	jalr	1776(ra) # 80001b8c <myproc>
    800024a4:	fe9508e3          	beq	a0,s1,80002494 <wakeup+0x34>
      acquire(&p->lock);
    800024a8:	8526                	mv	a0,s1
    800024aa:	ffffe097          	auipc	ra,0xffffe
    800024ae:	7b2080e7          	jalr	1970(ra) # 80000c5c <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    800024b2:	4c9c                	lw	a5,24(s1)
    800024b4:	fd379be3          	bne	a5,s3,8000248a <wakeup+0x2a>
    800024b8:	709c                	ld	a5,32(s1)
    800024ba:	fd4798e3          	bne	a5,s4,8000248a <wakeup+0x2a>
        p->state = RUNNABLE;
    800024be:	0154ac23          	sw	s5,24(s1)
    800024c2:	b7e1                	j	8000248a <wakeup+0x2a>
    }
  }
}
    800024c4:	70e2                	ld	ra,56(sp)
    800024c6:	7442                	ld	s0,48(sp)
    800024c8:	74a2                	ld	s1,40(sp)
    800024ca:	7902                	ld	s2,32(sp)
    800024cc:	69e2                	ld	s3,24(sp)
    800024ce:	6a42                	ld	s4,16(sp)
    800024d0:	6aa2                	ld	s5,8(sp)
    800024d2:	6121                	addi	sp,sp,64
    800024d4:	8082                	ret

00000000800024d6 <reparent>:
{
    800024d6:	7179                	addi	sp,sp,-48
    800024d8:	f406                	sd	ra,40(sp)
    800024da:	f022                	sd	s0,32(sp)
    800024dc:	ec26                	sd	s1,24(sp)
    800024de:	e84a                	sd	s2,16(sp)
    800024e0:	e44e                	sd	s3,8(sp)
    800024e2:	e052                	sd	s4,0(sp)
    800024e4:	1800                	addi	s0,sp,48
    800024e6:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800024e8:	0000f497          	auipc	s1,0xf
    800024ec:	d1848493          	addi	s1,s1,-744 # 80011200 <proc>
      pp->parent = initproc;
    800024f0:	00006a17          	auipc	s4,0x6
    800024f4:	638a0a13          	addi	s4,s4,1592 # 80008b28 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800024f8:	00018997          	auipc	s3,0x18
    800024fc:	30898993          	addi	s3,s3,776 # 8001a800 <logs>
    80002500:	a029                	j	8000250a <reparent+0x34>
    80002502:	25848493          	addi	s1,s1,600
    80002506:	01348d63          	beq	s1,s3,80002520 <reparent+0x4a>
    if (pp->parent == p)
    8000250a:	7c9c                	ld	a5,56(s1)
    8000250c:	ff279be3          	bne	a5,s2,80002502 <reparent+0x2c>
      pp->parent = initproc;
    80002510:	000a3503          	ld	a0,0(s4)
    80002514:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002516:	00000097          	auipc	ra,0x0
    8000251a:	f4a080e7          	jalr	-182(ra) # 80002460 <wakeup>
    8000251e:	b7d5                	j	80002502 <reparent+0x2c>
}
    80002520:	70a2                	ld	ra,40(sp)
    80002522:	7402                	ld	s0,32(sp)
    80002524:	64e2                	ld	s1,24(sp)
    80002526:	6942                	ld	s2,16(sp)
    80002528:	69a2                	ld	s3,8(sp)
    8000252a:	6a02                	ld	s4,0(sp)
    8000252c:	6145                	addi	sp,sp,48
    8000252e:	8082                	ret

0000000080002530 <exit>:
{
    80002530:	7179                	addi	sp,sp,-48
    80002532:	f406                	sd	ra,40(sp)
    80002534:	f022                	sd	s0,32(sp)
    80002536:	ec26                	sd	s1,24(sp)
    80002538:	e84a                	sd	s2,16(sp)
    8000253a:	e44e                	sd	s3,8(sp)
    8000253c:	e052                	sd	s4,0(sp)
    8000253e:	1800                	addi	s0,sp,48
    80002540:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002542:	fffff097          	auipc	ra,0xfffff
    80002546:	64a080e7          	jalr	1610(ra) # 80001b8c <myproc>
    8000254a:	89aa                	mv	s3,a0
  if (p == initproc)
    8000254c:	00006797          	auipc	a5,0x6
    80002550:	5dc7b783          	ld	a5,1500(a5) # 80008b28 <initproc>
    80002554:	0d050493          	addi	s1,a0,208
    80002558:	15050913          	addi	s2,a0,336
    8000255c:	00a79d63          	bne	a5,a0,80002576 <exit+0x46>
    panic("init exiting");
    80002560:	00006517          	auipc	a0,0x6
    80002564:	ce050513          	addi	a0,a0,-800 # 80008240 <etext+0x240>
    80002568:	ffffe097          	auipc	ra,0xffffe
    8000256c:	ff6080e7          	jalr	-10(ra) # 8000055e <panic>
  for (int fd = 0; fd < NOFILE; fd++)
    80002570:	04a1                	addi	s1,s1,8
    80002572:	01248b63          	beq	s1,s2,80002588 <exit+0x58>
    if (p->ofile[fd])
    80002576:	6088                	ld	a0,0(s1)
    80002578:	dd65                	beqz	a0,80002570 <exit+0x40>
      fileclose(f);
    8000257a:	00003097          	auipc	ra,0x3
    8000257e:	870080e7          	jalr	-1936(ra) # 80004dea <fileclose>
      p->ofile[fd] = 0;
    80002582:	0004b023          	sd	zero,0(s1)
    80002586:	b7ed                	j	80002570 <exit+0x40>
  begin_op();
    80002588:	00002097          	auipc	ra,0x2
    8000258c:	348080e7          	jalr	840(ra) # 800048d0 <begin_op>
  iput(p->cwd);
    80002590:	1509b503          	ld	a0,336(s3)
    80002594:	00002097          	auipc	ra,0x2
    80002598:	b0a080e7          	jalr	-1270(ra) # 8000409e <iput>
  end_op();
    8000259c:	00002097          	auipc	ra,0x2
    800025a0:	3b4080e7          	jalr	948(ra) # 80004950 <end_op>
  p->cwd = 0;
    800025a4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800025a8:	0000f517          	auipc	a0,0xf
    800025ac:	82050513          	addi	a0,a0,-2016 # 80010dc8 <wait_lock>
    800025b0:	ffffe097          	auipc	ra,0xffffe
    800025b4:	6ac080e7          	jalr	1708(ra) # 80000c5c <acquire>
  reparent(p);
    800025b8:	854e                	mv	a0,s3
    800025ba:	00000097          	auipc	ra,0x0
    800025be:	f1c080e7          	jalr	-228(ra) # 800024d6 <reparent>
  wakeup(p->parent);
    800025c2:	0389b503          	ld	a0,56(s3)
    800025c6:	00000097          	auipc	ra,0x0
    800025ca:	e9a080e7          	jalr	-358(ra) # 80002460 <wakeup>
  acquire(&p->lock);
    800025ce:	854e                	mv	a0,s3
    800025d0:	ffffe097          	auipc	ra,0xffffe
    800025d4:	68c080e7          	jalr	1676(ra) # 80000c5c <acquire>
  p->xstate = status;
    800025d8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800025dc:	4795                	li	a5,5
    800025de:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    800025e2:	00006797          	auipc	a5,0x6
    800025e6:	55e7a783          	lw	a5,1374(a5) # 80008b40 <ticks>
    800025ea:	16f9a823          	sw	a5,368(s3)
  release(&wait_lock);
    800025ee:	0000e517          	auipc	a0,0xe
    800025f2:	7da50513          	addi	a0,a0,2010 # 80010dc8 <wait_lock>
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	716080e7          	jalr	1814(ra) # 80000d0c <release>
  sched();
    800025fe:	00000097          	auipc	ra,0x0
    80002602:	cea080e7          	jalr	-790(ra) # 800022e8 <sched>
  panic("zombie exit");
    80002606:	00006517          	auipc	a0,0x6
    8000260a:	c4a50513          	addi	a0,a0,-950 # 80008250 <etext+0x250>
    8000260e:	ffffe097          	auipc	ra,0xffffe
    80002612:	f50080e7          	jalr	-176(ra) # 8000055e <panic>

0000000080002616 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002616:	7179                	addi	sp,sp,-48
    80002618:	f406                	sd	ra,40(sp)
    8000261a:	f022                	sd	s0,32(sp)
    8000261c:	ec26                	sd	s1,24(sp)
    8000261e:	e84a                	sd	s2,16(sp)
    80002620:	e44e                	sd	s3,8(sp)
    80002622:	1800                	addi	s0,sp,48
    80002624:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002626:	0000f497          	auipc	s1,0xf
    8000262a:	bda48493          	addi	s1,s1,-1062 # 80011200 <proc>
    8000262e:	00018997          	auipc	s3,0x18
    80002632:	1d298993          	addi	s3,s3,466 # 8001a800 <logs>
  {
    acquire(&p->lock);
    80002636:	8526                	mv	a0,s1
    80002638:	ffffe097          	auipc	ra,0xffffe
    8000263c:	624080e7          	jalr	1572(ra) # 80000c5c <acquire>
    if (p->pid == pid)
    80002640:	589c                	lw	a5,48(s1)
    80002642:	01278d63          	beq	a5,s2,8000265c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002646:	8526                	mv	a0,s1
    80002648:	ffffe097          	auipc	ra,0xffffe
    8000264c:	6c4080e7          	jalr	1732(ra) # 80000d0c <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002650:	25848493          	addi	s1,s1,600
    80002654:	ff3491e3          	bne	s1,s3,80002636 <kill+0x20>
  }
  return -1;
    80002658:	557d                	li	a0,-1
    8000265a:	a829                	j	80002674 <kill+0x5e>
      p->killed = 1;
    8000265c:	4785                	li	a5,1
    8000265e:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80002660:	4c98                	lw	a4,24(s1)
    80002662:	4789                	li	a5,2
    80002664:	00f70f63          	beq	a4,a5,80002682 <kill+0x6c>
      release(&p->lock);
    80002668:	8526                	mv	a0,s1
    8000266a:	ffffe097          	auipc	ra,0xffffe
    8000266e:	6a2080e7          	jalr	1698(ra) # 80000d0c <release>
      return 0;
    80002672:	4501                	li	a0,0
}
    80002674:	70a2                	ld	ra,40(sp)
    80002676:	7402                	ld	s0,32(sp)
    80002678:	64e2                	ld	s1,24(sp)
    8000267a:	6942                	ld	s2,16(sp)
    8000267c:	69a2                	ld	s3,8(sp)
    8000267e:	6145                	addi	sp,sp,48
    80002680:	8082                	ret
        p->state = RUNNABLE;
    80002682:	478d                	li	a5,3
    80002684:	cc9c                	sw	a5,24(s1)
    80002686:	b7cd                	j	80002668 <kill+0x52>

0000000080002688 <getSysCount>:

int getSysCount(int mask) 
{
    80002688:	7179                	addi	sp,sp,-48
    8000268a:	f406                	sd	ra,40(sp)
    8000268c:	f022                	sd	s0,32(sp)
    8000268e:	ec26                	sd	s1,24(sp)
    80002690:	e84a                	sd	s2,16(sp)
    80002692:	e44e                	sd	s3,8(sp)
    80002694:	1800                	addi	s0,sp,48
    80002696:	84aa                	mv	s1,a0
    80002698:	4901                	li	s2,0
  struct proc *p = myproc(); // Get the current process
    8000269a:	fffff097          	auipc	ra,0xfffff
    8000269e:	4f2080e7          	jalr	1266(ra) # 80001b8c <myproc>
    800026a2:	89aa                	mv	s3,a0
    800026a4:	4601                	li	a2,0
  
  
   for (int i = 1; i < NUMBER_OF_SYSCALLS; i++) {
    800026a6:	4785                	li	a5,1

    if ((mask>>i) & 1) j =i;
    800026a8:	85be                	mv	a1,a5
   for (int i = 1; i < NUMBER_OF_SYSCALLS; i++) {
    800026aa:	02000693          	li	a3,32
    800026ae:	a021                	j	800026b6 <getSysCount+0x2e>
    800026b0:	2785                	addiw	a5,a5,1
    800026b2:	00d78963          	beq	a5,a3,800026c4 <getSysCount+0x3c>
    if ((mask>>i) & 1) j =i;
    800026b6:	40f4d73b          	sraw	a4,s1,a5
    800026ba:	8b05                	andi	a4,a4,1
    800026bc:	db75                	beqz	a4,800026b0 <getSysCount+0x28>
    800026be:	893e                	mv	s2,a5
    800026c0:	862e                	mv	a2,a1
    800026c2:	b7fd                	j	800026b0 <getSysCount+0x28>
    800026c4:	c609                	beqz	a2,800026ce <getSysCount+0x46>
    800026c6:	00006797          	auipc	a5,0x6
    800026ca:	4727a923          	sw	s2,1138(a5) # 80008b38 <j>

   }
   printf("PID %d called %s %d times.\n",p-> pid, syscall_names[j-1], p->syscall_count[j]);
    800026ce:	00006497          	auipc	s1,0x6
    800026d2:	46a48493          	addi	s1,s1,1130 # 80008b38 <j>
    800026d6:	409c                	lw	a5,0(s1)
    800026d8:	00279693          	slli	a3,a5,0x2
    800026dc:	17068693          	addi	a3,a3,368
    800026e0:	96ce                	add	a3,a3,s3
    800026e2:	37fd                	addiw	a5,a5,-1
    800026e4:	078e                	slli	a5,a5,0x3
    800026e6:	00006717          	auipc	a4,0x6
    800026ea:	34270713          	addi	a4,a4,834 # 80008a28 <syscall_names>
    800026ee:	97ba                	add	a5,a5,a4
    800026f0:	42d4                	lw	a3,4(a3)
    800026f2:	6390                	ld	a2,0(a5)
    800026f4:	0309a583          	lw	a1,48(s3)
    800026f8:	00006517          	auipc	a0,0x6
    800026fc:	b6850513          	addi	a0,a0,-1176 # 80008260 <etext+0x260>
    80002700:	ffffe097          	auipc	ra,0xffffe
    80002704:	ea8080e7          	jalr	-344(ra) # 800005a8 <printf>
   return p->syscall_count[j];
    80002708:	409c                	lw	a5,0(s1)
    8000270a:	078a                	slli	a5,a5,0x2
    8000270c:	17078793          	addi	a5,a5,368
    80002710:	99be                	add	s3,s3,a5
}
    80002712:	0049a503          	lw	a0,4(s3)
    80002716:	70a2                	ld	ra,40(sp)
    80002718:	7402                	ld	s0,32(sp)
    8000271a:	64e2                	ld	s1,24(sp)
    8000271c:	6942                	ld	s2,16(sp)
    8000271e:	69a2                	ld	s3,8(sp)
    80002720:	6145                	addi	sp,sp,48
    80002722:	8082                	ret

0000000080002724 <setkilled>:

void setkilled(struct proc *p)
{
    80002724:	1101                	addi	sp,sp,-32
    80002726:	ec06                	sd	ra,24(sp)
    80002728:	e822                	sd	s0,16(sp)
    8000272a:	e426                	sd	s1,8(sp)
    8000272c:	1000                	addi	s0,sp,32
    8000272e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	52c080e7          	jalr	1324(ra) # 80000c5c <acquire>
  p->killed = 1;
    80002738:	4785                	li	a5,1
    8000273a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000273c:	8526                	mv	a0,s1
    8000273e:	ffffe097          	auipc	ra,0xffffe
    80002742:	5ce080e7          	jalr	1486(ra) # 80000d0c <release>
}
    80002746:	60e2                	ld	ra,24(sp)
    80002748:	6442                	ld	s0,16(sp)
    8000274a:	64a2                	ld	s1,8(sp)
    8000274c:	6105                	addi	sp,sp,32
    8000274e:	8082                	ret

0000000080002750 <killed>:

int killed(struct proc *p)
{
    80002750:	1101                	addi	sp,sp,-32
    80002752:	ec06                	sd	ra,24(sp)
    80002754:	e822                	sd	s0,16(sp)
    80002756:	e426                	sd	s1,8(sp)
    80002758:	e04a                	sd	s2,0(sp)
    8000275a:	1000                	addi	s0,sp,32
    8000275c:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    8000275e:	ffffe097          	auipc	ra,0xffffe
    80002762:	4fe080e7          	jalr	1278(ra) # 80000c5c <acquire>
  k = p->killed;
    80002766:	549c                	lw	a5,40(s1)
    80002768:	893e                	mv	s2,a5
  release(&p->lock);
    8000276a:	8526                	mv	a0,s1
    8000276c:	ffffe097          	auipc	ra,0xffffe
    80002770:	5a0080e7          	jalr	1440(ra) # 80000d0c <release>
  return k;
}
    80002774:	854a                	mv	a0,s2
    80002776:	60e2                	ld	ra,24(sp)
    80002778:	6442                	ld	s0,16(sp)
    8000277a:	64a2                	ld	s1,8(sp)
    8000277c:	6902                	ld	s2,0(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret

0000000080002782 <wait>:
{
    80002782:	715d                	addi	sp,sp,-80
    80002784:	e486                	sd	ra,72(sp)
    80002786:	e0a2                	sd	s0,64(sp)
    80002788:	fc26                	sd	s1,56(sp)
    8000278a:	f84a                	sd	s2,48(sp)
    8000278c:	f44e                	sd	s3,40(sp)
    8000278e:	f052                	sd	s4,32(sp)
    80002790:	ec56                	sd	s5,24(sp)
    80002792:	e85a                	sd	s6,16(sp)
    80002794:	e45e                	sd	s7,8(sp)
    80002796:	0880                	addi	s0,sp,80
    80002798:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000279a:	fffff097          	auipc	ra,0xfffff
    8000279e:	3f2080e7          	jalr	1010(ra) # 80001b8c <myproc>
    800027a2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800027a4:	0000e517          	auipc	a0,0xe
    800027a8:	62450513          	addi	a0,a0,1572 # 80010dc8 <wait_lock>
    800027ac:	ffffe097          	auipc	ra,0xffffe
    800027b0:	4b0080e7          	jalr	1200(ra) # 80000c5c <acquire>
        if (pp->state == ZOMBIE)
    800027b4:	4a15                	li	s4,5
        havekids = 1;
    800027b6:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800027b8:	00018997          	auipc	s3,0x18
    800027bc:	04898993          	addi	s3,s3,72 # 8001a800 <logs>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800027c0:	0000eb17          	auipc	s6,0xe
    800027c4:	608b0b13          	addi	s6,s6,1544 # 80010dc8 <wait_lock>
    800027c8:	a0c9                	j	8000288a <wait+0x108>
          pid = pp->pid;
    800027ca:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800027ce:	000b8e63          	beqz	s7,800027ea <wait+0x68>
    800027d2:	4691                	li	a3,4
    800027d4:	02c48613          	addi	a2,s1,44
    800027d8:	85de                	mv	a1,s7
    800027da:	05093503          	ld	a0,80(s2)
    800027de:	fffff097          	auipc	ra,0xfffff
    800027e2:	f3a080e7          	jalr	-198(ra) # 80001718 <copyout>
    800027e6:	04054063          	bltz	a0,80002826 <wait+0xa4>
          freeproc(pp);
    800027ea:	8526                	mv	a0,s1
    800027ec:	fffff097          	auipc	ra,0xfffff
    800027f0:	554080e7          	jalr	1364(ra) # 80001d40 <freeproc>
          release(&pp->lock);
    800027f4:	8526                	mv	a0,s1
    800027f6:	ffffe097          	auipc	ra,0xffffe
    800027fa:	516080e7          	jalr	1302(ra) # 80000d0c <release>
          release(&wait_lock);
    800027fe:	0000e517          	auipc	a0,0xe
    80002802:	5ca50513          	addi	a0,a0,1482 # 80010dc8 <wait_lock>
    80002806:	ffffe097          	auipc	ra,0xffffe
    8000280a:	506080e7          	jalr	1286(ra) # 80000d0c <release>
}
    8000280e:	854e                	mv	a0,s3
    80002810:	60a6                	ld	ra,72(sp)
    80002812:	6406                	ld	s0,64(sp)
    80002814:	74e2                	ld	s1,56(sp)
    80002816:	7942                	ld	s2,48(sp)
    80002818:	79a2                	ld	s3,40(sp)
    8000281a:	7a02                	ld	s4,32(sp)
    8000281c:	6ae2                	ld	s5,24(sp)
    8000281e:	6b42                	ld	s6,16(sp)
    80002820:	6ba2                	ld	s7,8(sp)
    80002822:	6161                	addi	sp,sp,80
    80002824:	8082                	ret
            release(&pp->lock);
    80002826:	8526                	mv	a0,s1
    80002828:	ffffe097          	auipc	ra,0xffffe
    8000282c:	4e4080e7          	jalr	1252(ra) # 80000d0c <release>
            release(&wait_lock);
    80002830:	0000e517          	auipc	a0,0xe
    80002834:	59850513          	addi	a0,a0,1432 # 80010dc8 <wait_lock>
    80002838:	ffffe097          	auipc	ra,0xffffe
    8000283c:	4d4080e7          	jalr	1236(ra) # 80000d0c <release>
            return -1;
    80002840:	59fd                	li	s3,-1
    80002842:	b7f1                	j	8000280e <wait+0x8c>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002844:	25848493          	addi	s1,s1,600
    80002848:	03348463          	beq	s1,s3,80002870 <wait+0xee>
      if (pp->parent == p)
    8000284c:	7c9c                	ld	a5,56(s1)
    8000284e:	ff279be3          	bne	a5,s2,80002844 <wait+0xc2>
        acquire(&pp->lock);
    80002852:	8526                	mv	a0,s1
    80002854:	ffffe097          	auipc	ra,0xffffe
    80002858:	408080e7          	jalr	1032(ra) # 80000c5c <acquire>
        if (pp->state == ZOMBIE)
    8000285c:	4c9c                	lw	a5,24(s1)
    8000285e:	f74786e3          	beq	a5,s4,800027ca <wait+0x48>
        release(&pp->lock);
    80002862:	8526                	mv	a0,s1
    80002864:	ffffe097          	auipc	ra,0xffffe
    80002868:	4a8080e7          	jalr	1192(ra) # 80000d0c <release>
        havekids = 1;
    8000286c:	8756                	mv	a4,s5
    8000286e:	bfd9                	j	80002844 <wait+0xc2>
    if (!havekids || killed(p))
    80002870:	c31d                	beqz	a4,80002896 <wait+0x114>
    80002872:	854a                	mv	a0,s2
    80002874:	00000097          	auipc	ra,0x0
    80002878:	edc080e7          	jalr	-292(ra) # 80002750 <killed>
    8000287c:	ed09                	bnez	a0,80002896 <wait+0x114>
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000287e:	85da                	mv	a1,s6
    80002880:	854a                	mv	a0,s2
    80002882:	00000097          	auipc	ra,0x0
    80002886:	b7a080e7          	jalr	-1158(ra) # 800023fc <sleep>
    havekids = 0;
    8000288a:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000288c:	0000f497          	auipc	s1,0xf
    80002890:	97448493          	addi	s1,s1,-1676 # 80011200 <proc>
    80002894:	bf65                	j	8000284c <wait+0xca>
      release(&wait_lock);
    80002896:	0000e517          	auipc	a0,0xe
    8000289a:	53250513          	addi	a0,a0,1330 # 80010dc8 <wait_lock>
    8000289e:	ffffe097          	auipc	ra,0xffffe
    800028a2:	46e080e7          	jalr	1134(ra) # 80000d0c <release>
      return -1;
    800028a6:	59fd                	li	s3,-1
    800028a8:	b79d                	j	8000280e <wait+0x8c>

00000000800028aa <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800028aa:	7179                	addi	sp,sp,-48
    800028ac:	f406                	sd	ra,40(sp)
    800028ae:	f022                	sd	s0,32(sp)
    800028b0:	ec26                	sd	s1,24(sp)
    800028b2:	e84a                	sd	s2,16(sp)
    800028b4:	e44e                	sd	s3,8(sp)
    800028b6:	e052                	sd	s4,0(sp)
    800028b8:	1800                	addi	s0,sp,48
    800028ba:	84aa                	mv	s1,a0
    800028bc:	8a2e                	mv	s4,a1
    800028be:	89b2                	mv	s3,a2
    800028c0:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800028c2:	fffff097          	auipc	ra,0xfffff
    800028c6:	2ca080e7          	jalr	714(ra) # 80001b8c <myproc>
  if (user_dst)
    800028ca:	c08d                	beqz	s1,800028ec <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    800028cc:	86ca                	mv	a3,s2
    800028ce:	864e                	mv	a2,s3
    800028d0:	85d2                	mv	a1,s4
    800028d2:	6928                	ld	a0,80(a0)
    800028d4:	fffff097          	auipc	ra,0xfffff
    800028d8:	e44080e7          	jalr	-444(ra) # 80001718 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800028dc:	70a2                	ld	ra,40(sp)
    800028de:	7402                	ld	s0,32(sp)
    800028e0:	64e2                	ld	s1,24(sp)
    800028e2:	6942                	ld	s2,16(sp)
    800028e4:	69a2                	ld	s3,8(sp)
    800028e6:	6a02                	ld	s4,0(sp)
    800028e8:	6145                	addi	sp,sp,48
    800028ea:	8082                	ret
    memmove((char *)dst, src, len);
    800028ec:	0009061b          	sext.w	a2,s2
    800028f0:	85ce                	mv	a1,s3
    800028f2:	8552                	mv	a0,s4
    800028f4:	ffffe097          	auipc	ra,0xffffe
    800028f8:	4c0080e7          	jalr	1216(ra) # 80000db4 <memmove>
    return 0;
    800028fc:	8526                	mv	a0,s1
    800028fe:	bff9                	j	800028dc <either_copyout+0x32>

0000000080002900 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002900:	7179                	addi	sp,sp,-48
    80002902:	f406                	sd	ra,40(sp)
    80002904:	f022                	sd	s0,32(sp)
    80002906:	ec26                	sd	s1,24(sp)
    80002908:	e84a                	sd	s2,16(sp)
    8000290a:	e44e                	sd	s3,8(sp)
    8000290c:	e052                	sd	s4,0(sp)
    8000290e:	1800                	addi	s0,sp,48
    80002910:	8a2a                	mv	s4,a0
    80002912:	84ae                	mv	s1,a1
    80002914:	89b2                	mv	s3,a2
    80002916:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002918:	fffff097          	auipc	ra,0xfffff
    8000291c:	274080e7          	jalr	628(ra) # 80001b8c <myproc>
  if (user_src)
    80002920:	c08d                	beqz	s1,80002942 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80002922:	86ca                	mv	a3,s2
    80002924:	864e                	mv	a2,s3
    80002926:	85d2                	mv	a1,s4
    80002928:	6928                	ld	a0,80(a0)
    8000292a:	fffff097          	auipc	ra,0xfffff
    8000292e:	e7a080e7          	jalr	-390(ra) # 800017a4 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002932:	70a2                	ld	ra,40(sp)
    80002934:	7402                	ld	s0,32(sp)
    80002936:	64e2                	ld	s1,24(sp)
    80002938:	6942                	ld	s2,16(sp)
    8000293a:	69a2                	ld	s3,8(sp)
    8000293c:	6a02                	ld	s4,0(sp)
    8000293e:	6145                	addi	sp,sp,48
    80002940:	8082                	ret
    memmove(dst, (char *)src, len);
    80002942:	0009061b          	sext.w	a2,s2
    80002946:	85ce                	mv	a1,s3
    80002948:	8552                	mv	a0,s4
    8000294a:	ffffe097          	auipc	ra,0xffffe
    8000294e:	46a080e7          	jalr	1130(ra) # 80000db4 <memmove>
    return 0;
    80002952:	8526                	mv	a0,s1
    80002954:	bff9                	j	80002932 <either_copyin+0x32>

0000000080002956 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002956:	7139                	addi	sp,sp,-64
    80002958:	fc06                	sd	ra,56(sp)
    8000295a:	f822                	sd	s0,48(sp)
    8000295c:	f426                	sd	s1,40(sp)
    8000295e:	f04a                	sd	s2,32(sp)
    80002960:	ec4e                	sd	s3,24(sp)
    80002962:	e852                	sd	s4,16(sp)
    80002964:	e456                	sd	s5,8(sp)
    80002966:	0080                	addi	s0,sp,64
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"}; */
  struct proc *p;
 // char *state;

  printf("\n");
    80002968:	00005517          	auipc	a0,0x5
    8000296c:	6a850513          	addi	a0,a0,1704 # 80008010 <etext+0x10>
    80002970:	ffffe097          	auipc	ra,0xffffe
    80002974:	c38080e7          	jalr	-968(ra) # 800005a8 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002978:	0000f497          	auipc	s1,0xf
    8000297c:	88848493          	addi	s1,s1,-1912 # 80011200 <proc>
    else
      state = "???"; */
    
    
    //printf("%d %s", p->pid, p->name);
     if(p->pid > 2){
    80002980:	4989                	li	s3,2
    printf("%d  %d  %d  %d  %d ", p->pid, p->qquu, p->twt, p->pqbb,p->ind_q);
    80002982:	00006a97          	auipc	s5,0x6
    80002986:	8fea8a93          	addi	s5,s5,-1794 # 80008280 <etext+0x280>
    //printf("#NN - %d %s %s %d %d %d %d", p->pid, p->state, p->name, p->qquu, p->tickcount, p->waittickcount, p->qquuposition);
    printf("\n");
    8000298a:	00005a17          	auipc	s4,0x5
    8000298e:	686a0a13          	addi	s4,s4,1670 # 80008010 <etext+0x10>
  for (p = proc; p < &proc[NPROC]; p++)
    80002992:	00018917          	auipc	s2,0x18
    80002996:	e6e90913          	addi	s2,s2,-402 # 8001a800 <logs>
    8000299a:	a029                	j	800029a4 <procdump+0x4e>
    8000299c:	25848493          	addi	s1,s1,600
    800029a0:	03248a63          	beq	s1,s2,800029d4 <procdump+0x7e>
    if (p->state == UNUSED)
    800029a4:	4c9c                	lw	a5,24(s1)
    800029a6:	dbfd                	beqz	a5,8000299c <procdump+0x46>
     if(p->pid > 2){
    800029a8:	588c                	lw	a1,48(s1)
    800029aa:	feb9d9e3          	bge	s3,a1,8000299c <procdump+0x46>
    printf("%d  %d  %d  %d  %d ", p->pid, p->qquu, p->twt, p->pqbb,p->ind_q);
    800029ae:	2384a783          	lw	a5,568(s1)
    800029b2:	2344a703          	lw	a4,564(s1)
    800029b6:	22c4a683          	lw	a3,556(s1)
    800029ba:	2304a603          	lw	a2,560(s1)
    800029be:	8556                	mv	a0,s5
    800029c0:	ffffe097          	auipc	ra,0xffffe
    800029c4:	be8080e7          	jalr	-1048(ra) # 800005a8 <printf>
    printf("\n");
    800029c8:	8552                	mv	a0,s4
    800029ca:	ffffe097          	auipc	ra,0xffffe
    800029ce:	bde080e7          	jalr	-1058(ra) # 800005a8 <printf>
    800029d2:	b7e9                	j	8000299c <procdump+0x46>
    }
  }
}
    800029d4:	70e2                	ld	ra,56(sp)
    800029d6:	7442                	ld	s0,48(sp)
    800029d8:	74a2                	ld	s1,40(sp)
    800029da:	7902                	ld	s2,32(sp)
    800029dc:	69e2                	ld	s3,24(sp)
    800029de:	6a42                	ld	s4,16(sp)
    800029e0:	6aa2                	ld	s5,8(sp)
    800029e2:	6121                	addi	sp,sp,64
    800029e4:	8082                	ret

00000000800029e6 <waitx>:

int
waitx(uint64 addr, uint *wtime, uint *rtime)
{
    800029e6:	711d                	addi	sp,sp,-96
    800029e8:	ec86                	sd	ra,88(sp)
    800029ea:	e8a2                	sd	s0,80(sp)
    800029ec:	e4a6                	sd	s1,72(sp)
    800029ee:	e0ca                	sd	s2,64(sp)
    800029f0:	fc4e                	sd	s3,56(sp)
    800029f2:	f852                	sd	s4,48(sp)
    800029f4:	f456                	sd	s5,40(sp)
    800029f6:	f05a                	sd	s6,32(sp)
    800029f8:	ec5e                	sd	s7,24(sp)
    800029fa:	e862                	sd	s8,16(sp)
    800029fc:	e466                	sd	s9,8(sp)
    800029fe:	1080                	addi	s0,sp,96
    80002a00:	8baa                	mv	s7,a0
    80002a02:	8c2e                	mv	s8,a1
    80002a04:	8cb2                	mv	s9,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    80002a06:	fffff097          	auipc	ra,0xfffff
    80002a0a:	186080e7          	jalr	390(ra) # 80001b8c <myproc>
    80002a0e:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002a10:	0000e517          	auipc	a0,0xe
    80002a14:	3b850513          	addi	a0,a0,952 # 80010dc8 <wait_lock>
    80002a18:	ffffe097          	auipc	ra,0xffffe
    80002a1c:	244080e7          	jalr	580(ra) # 80000c5c <acquire>
    havekids = 0;
    for (np = proc; np < &proc[NPROC]; np++) {
      if (np->parent == p) {
        havekids = 1;
        acquire(&np->lock);
        if (np->state == ZOMBIE) {
    80002a20:	4a15                	li	s4,5
        havekids = 1;
    80002a22:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++) {
    80002a24:	00018997          	auipc	s3,0x18
    80002a28:	ddc98993          	addi	s3,s3,-548 # 8001a800 <logs>
    }
    if (!havekids || killed(p)) {
      release(&wait_lock);
      return -1;
    }
    sleep(p, &wait_lock);
    80002a2c:	0000eb17          	auipc	s6,0xe
    80002a30:	39cb0b13          	addi	s6,s6,924 # 80010dc8 <wait_lock>
    80002a34:	a0ed                	j	80002b1e <waitx+0x138>
          pid    = np->pid;
    80002a36:	0304a983          	lw	s3,48(s1)
          if (rtime) *rtime = np->rtime;
    80002a3a:	000c8663          	beqz	s9,80002a46 <waitx+0x60>
    80002a3e:	1684a783          	lw	a5,360(s1)
    80002a42:	00fca023          	sw	a5,0(s9)
          if (wtime) *wtime = np->etime - np->ctime - np->rtime;
    80002a46:	000c0c63          	beqz	s8,80002a5e <waitx+0x78>
    80002a4a:	16c4a783          	lw	a5,364(s1)
    80002a4e:	1684a703          	lw	a4,360(s1)
    80002a52:	9f3d                	addw	a4,a4,a5
    80002a54:	1704a783          	lw	a5,368(s1)
    80002a58:	9f99                	subw	a5,a5,a4
    80002a5a:	00fc2023          	sw	a5,0(s8)
          if (addr != 0 && copyout(p->pagetable, addr,
    80002a5e:	000b8e63          	beqz	s7,80002a7a <waitx+0x94>
    80002a62:	4691                	li	a3,4
    80002a64:	02c48613          	addi	a2,s1,44
    80002a68:	85de                	mv	a1,s7
    80002a6a:	05093503          	ld	a0,80(s2)
    80002a6e:	fffff097          	auipc	ra,0xfffff
    80002a72:	caa080e7          	jalr	-854(ra) # 80001718 <copyout>
    80002a76:	04054263          	bltz	a0,80002aba <waitx+0xd4>
          freeproc(np);
    80002a7a:	8526                	mv	a0,s1
    80002a7c:	fffff097          	auipc	ra,0xfffff
    80002a80:	2c4080e7          	jalr	708(ra) # 80001d40 <freeproc>
          release(&np->lock);
    80002a84:	8526                	mv	a0,s1
    80002a86:	ffffe097          	auipc	ra,0xffffe
    80002a8a:	286080e7          	jalr	646(ra) # 80000d0c <release>
          release(&wait_lock);
    80002a8e:	0000e517          	auipc	a0,0xe
    80002a92:	33a50513          	addi	a0,a0,826 # 80010dc8 <wait_lock>
    80002a96:	ffffe097          	auipc	ra,0xffffe
    80002a9a:	276080e7          	jalr	630(ra) # 80000d0c <release>
  }
}
    80002a9e:	854e                	mv	a0,s3
    80002aa0:	60e6                	ld	ra,88(sp)
    80002aa2:	6446                	ld	s0,80(sp)
    80002aa4:	64a6                	ld	s1,72(sp)
    80002aa6:	6906                	ld	s2,64(sp)
    80002aa8:	79e2                	ld	s3,56(sp)
    80002aaa:	7a42                	ld	s4,48(sp)
    80002aac:	7aa2                	ld	s5,40(sp)
    80002aae:	7b02                	ld	s6,32(sp)
    80002ab0:	6be2                	ld	s7,24(sp)
    80002ab2:	6c42                	ld	s8,16(sp)
    80002ab4:	6ca2                	ld	s9,8(sp)
    80002ab6:	6125                	addi	sp,sp,96
    80002ab8:	8082                	ret
            release(&np->lock);
    80002aba:	8526                	mv	a0,s1
    80002abc:	ffffe097          	auipc	ra,0xffffe
    80002ac0:	250080e7          	jalr	592(ra) # 80000d0c <release>
            release(&wait_lock);
    80002ac4:	0000e517          	auipc	a0,0xe
    80002ac8:	30450513          	addi	a0,a0,772 # 80010dc8 <wait_lock>
    80002acc:	ffffe097          	auipc	ra,0xffffe
    80002ad0:	240080e7          	jalr	576(ra) # 80000d0c <release>
            return -1;
    80002ad4:	59fd                	li	s3,-1
    80002ad6:	b7e1                	j	80002a9e <waitx+0xb8>
    for (np = proc; np < &proc[NPROC]; np++) {
    80002ad8:	25848493          	addi	s1,s1,600
    80002adc:	03348463          	beq	s1,s3,80002b04 <waitx+0x11e>
      if (np->parent == p) {
    80002ae0:	7c9c                	ld	a5,56(s1)
    80002ae2:	ff279be3          	bne	a5,s2,80002ad8 <waitx+0xf2>
        acquire(&np->lock);
    80002ae6:	8526                	mv	a0,s1
    80002ae8:	ffffe097          	auipc	ra,0xffffe
    80002aec:	174080e7          	jalr	372(ra) # 80000c5c <acquire>
        if (np->state == ZOMBIE) {
    80002af0:	4c9c                	lw	a5,24(s1)
    80002af2:	f54782e3          	beq	a5,s4,80002a36 <waitx+0x50>
        release(&np->lock);
    80002af6:	8526                	mv	a0,s1
    80002af8:	ffffe097          	auipc	ra,0xffffe
    80002afc:	214080e7          	jalr	532(ra) # 80000d0c <release>
        havekids = 1;
    80002b00:	8756                	mv	a4,s5
    80002b02:	bfd9                	j	80002ad8 <waitx+0xf2>
    if (!havekids || killed(p)) {
    80002b04:	c31d                	beqz	a4,80002b2a <waitx+0x144>
    80002b06:	854a                	mv	a0,s2
    80002b08:	00000097          	auipc	ra,0x0
    80002b0c:	c48080e7          	jalr	-952(ra) # 80002750 <killed>
    80002b10:	ed09                	bnez	a0,80002b2a <waitx+0x144>
    sleep(p, &wait_lock);
    80002b12:	85da                	mv	a1,s6
    80002b14:	854a                	mv	a0,s2
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	8e6080e7          	jalr	-1818(ra) # 800023fc <sleep>
    havekids = 0;
    80002b1e:	4701                	li	a4,0
    for (np = proc; np < &proc[NPROC]; np++) {
    80002b20:	0000e497          	auipc	s1,0xe
    80002b24:	6e048493          	addi	s1,s1,1760 # 80011200 <proc>
    80002b28:	bf65                	j	80002ae0 <waitx+0xfa>
      release(&wait_lock);
    80002b2a:	0000e517          	auipc	a0,0xe
    80002b2e:	29e50513          	addi	a0,a0,670 # 80010dc8 <wait_lock>
    80002b32:	ffffe097          	auipc	ra,0xffffe
    80002b36:	1da080e7          	jalr	474(ra) # 80000d0c <release>
      return -1;
    80002b3a:	59fd                	li	s3,-1
    80002b3c:	b78d                	j	80002a9e <waitx+0xb8>

0000000080002b3e <update_time>:

void update_time()
{
    80002b3e:	1101                	addi	sp,sp,-32
    80002b40:	ec06                	sd	ra,24(sp)
    80002b42:	e822                	sd	s0,16(sp)
    80002b44:	e426                	sd	s1,8(sp)
    80002b46:	e04a                	sd	s2,0(sp)
    80002b48:	1000                	addi	s0,sp,32
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002b4a:	0000e497          	auipc	s1,0xe
    80002b4e:	6b648493          	addi	s1,s1,1718 # 80011200 <proc>
    80002b52:	00018917          	auipc	s2,0x18
    80002b56:	cae90913          	addi	s2,s2,-850 # 8001a800 <logs>
  {
    acquire(&p->lock);
    80002b5a:	8526                	mv	a0,s1
    80002b5c:	ffffe097          	auipc	ra,0xffffe
    80002b60:	100080e7          	jalr	256(ra) # 80000c5c <acquire>
    if (p->state == RUNNING)
    {
   
    }
    release(&p->lock);
    80002b64:	8526                	mv	a0,s1
    80002b66:	ffffe097          	auipc	ra,0xffffe
    80002b6a:	1a6080e7          	jalr	422(ra) # 80000d0c <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002b6e:	25848493          	addi	s1,s1,600
    80002b72:	ff2494e3          	bne	s1,s2,80002b5a <update_time+0x1c>
  }
}
    80002b76:	60e2                	ld	ra,24(sp)
    80002b78:	6442                	ld	s0,16(sp)
    80002b7a:	64a2                	ld	s1,8(sp)
    80002b7c:	6902                	ld	s2,0(sp)
    80002b7e:	6105                	addi	sp,sp,32
    80002b80:	8082                	ret

0000000080002b82 <print_logg>:


void print_logg() {
    80002b82:	7179                	addi	sp,sp,-48
    80002b84:	f406                	sd	ra,40(sp)
    80002b86:	f022                	sd	s0,32(sp)
    80002b88:	1800                	addi	s0,sp,48
    // Check if there are any log entries to print
    if (log_index == 0) {
    80002b8a:	00006797          	auipc	a5,0x6
    80002b8e:	faa7a783          	lw	a5,-86(a5) # 80008b34 <log_index>
    80002b92:	c7dd                	beqz	a5,80002c40 <print_logg+0xbe>
        printf("No log entries available.\n");
        return;
    }

    printf("Process qquu Log:\n");
    80002b94:	00005517          	auipc	a0,0x5
    80002b98:	72450513          	addi	a0,a0,1828 # 800082b8 <etext+0x2b8>
    80002b9c:	ffffe097          	auipc	ra,0xffffe
    80002ba0:	a0c080e7          	jalr	-1524(ra) # 800005a8 <printf>
    printf("----------------------------------------------------\n");
    80002ba4:	00005517          	auipc	a0,0x5
    80002ba8:	72c50513          	addi	a0,a0,1836 # 800082d0 <etext+0x2d0>
    80002bac:	ffffe097          	auipc	ra,0xffffe
    80002bb0:	9fc080e7          	jalr	-1540(ra) # 800005a8 <printf>
    printf("| PID | Time | qquu | TckTime\n");
    80002bb4:	00005517          	auipc	a0,0x5
    80002bb8:	75450513          	addi	a0,a0,1876 # 80008308 <etext+0x308>
    80002bbc:	ffffe097          	auipc	ra,0xffffe
    80002bc0:	9ec080e7          	jalr	-1556(ra) # 800005a8 <printf>
    printf("----------------------------------------------------\n");
    80002bc4:	00005517          	auipc	a0,0x5
    80002bc8:	70c50513          	addi	a0,a0,1804 # 800082d0 <etext+0x2d0>
    80002bcc:	ffffe097          	auipc	ra,0xffffe
    80002bd0:	9dc080e7          	jalr	-1572(ra) # 800005a8 <printf>

    // Loop through each log entry and print the details
    for (int i = 0; i < log_index; i++) {
    80002bd4:	00006797          	auipc	a5,0x6
    80002bd8:	f607a783          	lw	a5,-160(a5) # 80008b34 <log_index>
    80002bdc:	04f05663          	blez	a5,80002c28 <print_logg+0xa6>
    80002be0:	ec26                	sd	s1,24(sp)
    80002be2:	e84a                	sd	s2,16(sp)
    80002be4:	e44e                	sd	s3,8(sp)
    80002be6:	e052                	sd	s4,0(sp)
    80002be8:	00018497          	auipc	s1,0x18
    80002bec:	c1848493          	addi	s1,s1,-1000 # 8001a800 <logs>
    80002bf0:	4901                	li	s2,0
        printf("| %d | %d | %d | %d |\n", logs[i].pid, logs[i].time, logs[i].qquu, logs[i].ticktime) ;
    80002bf2:	00005a17          	auipc	s4,0x5
    80002bf6:	736a0a13          	addi	s4,s4,1846 # 80008328 <etext+0x328>
    for (int i = 0; i < log_index; i++) {
    80002bfa:	00006997          	auipc	s3,0x6
    80002bfe:	f3a98993          	addi	s3,s3,-198 # 80008b34 <log_index>
        printf("| %d | %d | %d | %d |\n", logs[i].pid, logs[i].time, logs[i].qquu, logs[i].ticktime) ;
    80002c02:	4498                	lw	a4,8(s1)
    80002c04:	44d4                	lw	a3,12(s1)
    80002c06:	40d0                	lw	a2,4(s1)
    80002c08:	408c                	lw	a1,0(s1)
    80002c0a:	8552                	mv	a0,s4
    80002c0c:	ffffe097          	auipc	ra,0xffffe
    80002c10:	99c080e7          	jalr	-1636(ra) # 800005a8 <printf>
    for (int i = 0; i < log_index; i++) {
    80002c14:	2905                	addiw	s2,s2,1
    80002c16:	04c1                	addi	s1,s1,16
    80002c18:	0009a783          	lw	a5,0(s3)
    80002c1c:	fef943e3          	blt	s2,a5,80002c02 <print_logg+0x80>
    80002c20:	64e2                	ld	s1,24(sp)
    80002c22:	6942                	ld	s2,16(sp)
    80002c24:	69a2                	ld	s3,8(sp)
    80002c26:	6a02                	ld	s4,0(sp)
    }

    printf("----------------------------------------------------\n");
    80002c28:	00005517          	auipc	a0,0x5
    80002c2c:	6a850513          	addi	a0,a0,1704 # 800082d0 <etext+0x2d0>
    80002c30:	ffffe097          	auipc	ra,0xffffe
    80002c34:	978080e7          	jalr	-1672(ra) # 800005a8 <printf>
}
    80002c38:	70a2                	ld	ra,40(sp)
    80002c3a:	7402                	ld	s0,32(sp)
    80002c3c:	6145                	addi	sp,sp,48
    80002c3e:	8082                	ret
        printf("No log entries available.\n");
    80002c40:	00005517          	auipc	a0,0x5
    80002c44:	65850513          	addi	a0,a0,1624 # 80008298 <etext+0x298>
    80002c48:	ffffe097          	auipc	ra,0xffffe
    80002c4c:	960080e7          	jalr	-1696(ra) # 800005a8 <printf>
        return;
    80002c50:	b7e5                	j	80002c38 <print_logg+0xb6>

0000000080002c52 <swtch>:
    80002c52:	00153023          	sd	ra,0(a0)
    80002c56:	00253423          	sd	sp,8(a0)
    80002c5a:	e900                	sd	s0,16(a0)
    80002c5c:	ed04                	sd	s1,24(a0)
    80002c5e:	03253023          	sd	s2,32(a0)
    80002c62:	03353423          	sd	s3,40(a0)
    80002c66:	03453823          	sd	s4,48(a0)
    80002c6a:	03553c23          	sd	s5,56(a0)
    80002c6e:	05653023          	sd	s6,64(a0)
    80002c72:	05753423          	sd	s7,72(a0)
    80002c76:	05853823          	sd	s8,80(a0)
    80002c7a:	05953c23          	sd	s9,88(a0)
    80002c7e:	07a53023          	sd	s10,96(a0)
    80002c82:	07b53423          	sd	s11,104(a0)
    80002c86:	0005b083          	ld	ra,0(a1)
    80002c8a:	0085b103          	ld	sp,8(a1)
    80002c8e:	6980                	ld	s0,16(a1)
    80002c90:	6d84                	ld	s1,24(a1)
    80002c92:	0205b903          	ld	s2,32(a1)
    80002c96:	0285b983          	ld	s3,40(a1)
    80002c9a:	0305ba03          	ld	s4,48(a1)
    80002c9e:	0385ba83          	ld	s5,56(a1)
    80002ca2:	0405bb03          	ld	s6,64(a1)
    80002ca6:	0485bb83          	ld	s7,72(a1)
    80002caa:	0505bc03          	ld	s8,80(a1)
    80002cae:	0585bc83          	ld	s9,88(a1)
    80002cb2:	0605bd03          	ld	s10,96(a1)
    80002cb6:	0685bd83          	ld	s11,104(a1)
    80002cba:	8082                	ret

0000000080002cbc <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002cbc:	1141                	addi	sp,sp,-16
    80002cbe:	e406                	sd	ra,8(sp)
    80002cc0:	e022                	sd	s0,0(sp)
    80002cc2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002cc4:	00005597          	auipc	a1,0x5
    80002cc8:	67c58593          	addi	a1,a1,1660 # 80008340 <etext+0x340>
    80002ccc:	0003f517          	auipc	a0,0x3f
    80002cd0:	0a450513          	addi	a0,a0,164 # 80041d70 <tickslock>
    80002cd4:	ffffe097          	auipc	ra,0xffffe
    80002cd8:	eee080e7          	jalr	-274(ra) # 80000bc2 <initlock>
}
    80002cdc:	60a2                	ld	ra,8(sp)
    80002cde:	6402                	ld	s0,0(sp)
    80002ce0:	0141                	addi	sp,sp,16
    80002ce2:	8082                	ret

0000000080002ce4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002ce4:	1141                	addi	sp,sp,-16
    80002ce6:	e406                	sd	ra,8(sp)
    80002ce8:	e022                	sd	s0,0(sp)
    80002cea:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002cec:	00004797          	auipc	a5,0x4
    80002cf0:	90478793          	addi	a5,a5,-1788 # 800065f0 <kernelvec>
    80002cf4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002cf8:	60a2                	ld	ra,8(sp)
    80002cfa:	6402                	ld	s0,0(sp)
    80002cfc:	0141                	addi	sp,sp,16
    80002cfe:	8082                	ret

0000000080002d00 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002d00:	1141                	addi	sp,sp,-16
    80002d02:	e406                	sd	ra,8(sp)
    80002d04:	e022                	sd	s0,0(sp)
    80002d06:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002d08:	fffff097          	auipc	ra,0xfffff
    80002d0c:	e84080e7          	jalr	-380(ra) # 80001b8c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d10:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002d14:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d16:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002d1a:	00004697          	auipc	a3,0x4
    80002d1e:	2e668693          	addi	a3,a3,742 # 80007000 <_trampoline>
    80002d22:	00004717          	auipc	a4,0x4
    80002d26:	2de70713          	addi	a4,a4,734 # 80007000 <_trampoline>
    80002d2a:	8f15                	sub	a4,a4,a3
    80002d2c:	040007b7          	lui	a5,0x4000
    80002d30:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002d32:	07b2                	slli	a5,a5,0xc
    80002d34:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d36:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002d3a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002d3c:	18002673          	csrr	a2,satp
    80002d40:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002d42:	6d30                	ld	a2,88(a0)
    80002d44:	6138                	ld	a4,64(a0)
    80002d46:	6585                	lui	a1,0x1
    80002d48:	972e                	add	a4,a4,a1
    80002d4a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002d4c:	6d38                	ld	a4,88(a0)
    80002d4e:	00000617          	auipc	a2,0x0
    80002d52:	14a60613          	addi	a2,a2,330 # 80002e98 <usertrap>
    80002d56:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002d58:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002d5a:	8612                	mv	a2,tp
    80002d5c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d5e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002d62:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002d66:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d6a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002d6e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d70:	6f18                	ld	a4,24(a4)
    80002d72:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002d76:	6928                	ld	a0,80(a0)
    80002d78:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002d7a:	00004717          	auipc	a4,0x4
    80002d7e:	32270713          	addi	a4,a4,802 # 8000709c <userret>
    80002d82:	8f15                	sub	a4,a4,a3
    80002d84:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002d86:	577d                	li	a4,-1
    80002d88:	177e                	slli	a4,a4,0x3f
    80002d8a:	8d59                	or	a0,a0,a4
    80002d8c:	9782                	jalr	a5
}
    80002d8e:	60a2                	ld	ra,8(sp)
    80002d90:	6402                	ld	s0,0(sp)
    80002d92:	0141                	addi	sp,sp,16
    80002d94:	8082                	ret

0000000080002d96 <clockintr>:
  w_sstatus(sstatus);
}


void clockintr()
{
    80002d96:	1141                	addi	sp,sp,-16
    80002d98:	e406                	sd	ra,8(sp)
    80002d9a:	e022                	sd	s0,0(sp)
    80002d9c:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    80002d9e:	0003f517          	auipc	a0,0x3f
    80002da2:	fd250513          	addi	a0,a0,-46 # 80041d70 <tickslock>
    80002da6:	ffffe097          	auipc	ra,0xffffe
    80002daa:	eb6080e7          	jalr	-330(ra) # 80000c5c <acquire>
  ticks++;
    80002dae:	00006717          	auipc	a4,0x6
    80002db2:	d9270713          	addi	a4,a4,-622 # 80008b40 <ticks>
    80002db6:	431c                	lw	a5,0(a4)
    80002db8:	2785                	addiw	a5,a5,1
    80002dba:	c31c                	sw	a5,0(a4)
  update_time();
    80002dbc:	00000097          	auipc	ra,0x0
    80002dc0:	d82080e7          	jalr	-638(ra) # 80002b3e <update_time>
  //   // {
  //   //   p->wtime++;
  //   // }
  //   release(&p->lock);
  // }
  wakeup(&ticks);
    80002dc4:	00006517          	auipc	a0,0x6
    80002dc8:	d7c50513          	addi	a0,a0,-644 # 80008b40 <ticks>
    80002dcc:	fffff097          	auipc	ra,0xfffff
    80002dd0:	694080e7          	jalr	1684(ra) # 80002460 <wakeup>
  release(&tickslock);
    80002dd4:	0003f517          	auipc	a0,0x3f
    80002dd8:	f9c50513          	addi	a0,a0,-100 # 80041d70 <tickslock>
    80002ddc:	ffffe097          	auipc	ra,0xffffe
    80002de0:	f30080e7          	jalr	-208(ra) # 80000d0c <release>
}
    80002de4:	60a2                	ld	ra,8(sp)
    80002de6:	6402                	ld	s0,0(sp)
    80002de8:	0141                	addi	sp,sp,16
    80002dea:	8082                	ret

0000000080002dec <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002dec:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80002df0:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80002df2:	0a07d263          	bgez	a5,80002e96 <devintr+0xaa>
{
    80002df6:	1101                	addi	sp,sp,-32
    80002df8:	ec06                	sd	ra,24(sp)
    80002dfa:	e822                	sd	s0,16(sp)
    80002dfc:	1000                	addi	s0,sp,32
      (scause & 0xff) == 9)
    80002dfe:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80002e02:	46a5                	li	a3,9
    80002e04:	00d70c63          	beq	a4,a3,80002e1c <devintr+0x30>
  else if (scause == 0x8000000000000001L)
    80002e08:	577d                	li	a4,-1
    80002e0a:	177e                	slli	a4,a4,0x3f
    80002e0c:	0705                	addi	a4,a4,1
    return 0;
    80002e0e:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002e10:	06e78263          	beq	a5,a4,80002e74 <devintr+0x88>
  }
}
    80002e14:	60e2                	ld	ra,24(sp)
    80002e16:	6442                	ld	s0,16(sp)
    80002e18:	6105                	addi	sp,sp,32
    80002e1a:	8082                	ret
    80002e1c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002e1e:	00004097          	auipc	ra,0x4
    80002e22:	8de080e7          	jalr	-1826(ra) # 800066fc <plic_claim>
    80002e26:	872a                	mv	a4,a0
    80002e28:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002e2a:	47a9                	li	a5,10
    80002e2c:	00f50963          	beq	a0,a5,80002e3e <devintr+0x52>
    else if (irq == VIRTIO0_IRQ)
    80002e30:	4785                	li	a5,1
    80002e32:	00f50b63          	beq	a0,a5,80002e48 <devintr+0x5c>
    return 1;
    80002e36:	4505                	li	a0,1
    else if (irq)
    80002e38:	ef09                	bnez	a4,80002e52 <devintr+0x66>
    80002e3a:	64a2                	ld	s1,8(sp)
    80002e3c:	bfe1                	j	80002e14 <devintr+0x28>
      uartintr();
    80002e3e:	ffffe097          	auipc	ra,0xffffe
    80002e42:	bc2080e7          	jalr	-1086(ra) # 80000a00 <uartintr>
    if (irq)
    80002e46:	a839                	j	80002e64 <devintr+0x78>
      virtio_disk_intr();
    80002e48:	00004097          	auipc	ra,0x4
    80002e4c:	dae080e7          	jalr	-594(ra) # 80006bf6 <virtio_disk_intr>
    if (irq)
    80002e50:	a811                	j	80002e64 <devintr+0x78>
      printf("unexpected interrupt irq=%d\n", irq);
    80002e52:	85ba                	mv	a1,a4
    80002e54:	00005517          	auipc	a0,0x5
    80002e58:	4f450513          	addi	a0,a0,1268 # 80008348 <etext+0x348>
    80002e5c:	ffffd097          	auipc	ra,0xffffd
    80002e60:	74c080e7          	jalr	1868(ra) # 800005a8 <printf>
      plic_complete(irq);
    80002e64:	8526                	mv	a0,s1
    80002e66:	00004097          	auipc	ra,0x4
    80002e6a:	8ba080e7          	jalr	-1862(ra) # 80006720 <plic_complete>
    return 1;
    80002e6e:	4505                	li	a0,1
    80002e70:	64a2                	ld	s1,8(sp)
    80002e72:	b74d                	j	80002e14 <devintr+0x28>
    if (cpuid() == 0)
    80002e74:	fffff097          	auipc	ra,0xfffff
    80002e78:	ce4080e7          	jalr	-796(ra) # 80001b58 <cpuid>
    80002e7c:	c901                	beqz	a0,80002e8c <devintr+0xa0>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002e7e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002e82:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002e84:	14479073          	csrw	sip,a5
    return 2;
    80002e88:	4509                	li	a0,2
    80002e8a:	b769                	j	80002e14 <devintr+0x28>
      clockintr();
    80002e8c:	00000097          	auipc	ra,0x0
    80002e90:	f0a080e7          	jalr	-246(ra) # 80002d96 <clockintr>
    80002e94:	b7ed                	j	80002e7e <devintr+0x92>
}
    80002e96:	8082                	ret

0000000080002e98 <usertrap>:
{
    80002e98:	1101                	addi	sp,sp,-32
    80002e9a:	ec06                	sd	ra,24(sp)
    80002e9c:	e822                	sd	s0,16(sp)
    80002e9e:	e426                	sd	s1,8(sp)
    80002ea0:	e04a                	sd	s2,0(sp)
    80002ea2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ea4:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002ea8:	1007f793          	andi	a5,a5,256
    80002eac:	e3b9                	bnez	a5,80002ef2 <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002eae:	00003797          	auipc	a5,0x3
    80002eb2:	74278793          	addi	a5,a5,1858 # 800065f0 <kernelvec>
    80002eb6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002eba:	fffff097          	auipc	ra,0xfffff
    80002ebe:	cd2080e7          	jalr	-814(ra) # 80001b8c <myproc>
    80002ec2:	84aa                	mv	s1,a0
  if (p == 0)
    80002ec4:	cd1d                	beqz	a0,80002f02 <usertrap+0x6a>
  p->trapframe->epc = r_sepc();
    80002ec6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ec8:	14102773          	csrr	a4,sepc
    80002ecc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ece:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002ed2:	47a1                	li	a5,8
    80002ed4:	02f70f63          	beq	a4,a5,80002f12 <usertrap+0x7a>
  } else if ((which_dev = devintr()) != 0) {
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	f14080e7          	jalr	-236(ra) # 80002dec <devintr>
    80002ee0:	892a                	mv	s2,a0
    80002ee2:	c149                	beqz	a0,80002f64 <usertrap+0xcc>
  if (killed(p))
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	86a080e7          	jalr	-1942(ra) # 80002750 <killed>
    80002eee:	cd55                	beqz	a0,80002faa <usertrap+0x112>
    80002ef0:	a845                	j	80002fa0 <usertrap+0x108>
    panic("usertrap: not from user mode");
    80002ef2:	00005517          	auipc	a0,0x5
    80002ef6:	47650513          	addi	a0,a0,1142 # 80008368 <etext+0x368>
    80002efa:	ffffd097          	auipc	ra,0xffffd
    80002efe:	664080e7          	jalr	1636(ra) # 8000055e <panic>
    panic("usertrap: no proc");
    80002f02:	00005517          	auipc	a0,0x5
    80002f06:	48650513          	addi	a0,a0,1158 # 80008388 <etext+0x388>
    80002f0a:	ffffd097          	auipc	ra,0xffffd
    80002f0e:	654080e7          	jalr	1620(ra) # 8000055e <panic>
    if (killed(p))
    80002f12:	00000097          	auipc	ra,0x0
    80002f16:	83e080e7          	jalr	-1986(ra) # 80002750 <killed>
    80002f1a:	ed1d                	bnez	a0,80002f58 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80002f1c:	6cb8                	ld	a4,88(s1)
    80002f1e:	6f1c                	ld	a5,24(a4)
    80002f20:	0791                	addi	a5,a5,4
    80002f22:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002f28:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f2c:	10079073          	csrw	sstatus,a5
    syscall();
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	2e6080e7          	jalr	742(ra) # 80003216 <syscall>
  if (killed(p))
    80002f38:	8526                	mv	a0,s1
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	816080e7          	jalr	-2026(ra) # 80002750 <killed>
    80002f42:	ed31                	bnez	a0,80002f9e <usertrap+0x106>
  usertrapret();
    80002f44:	00000097          	auipc	ra,0x0
    80002f48:	dbc080e7          	jalr	-580(ra) # 80002d00 <usertrapret>
}
    80002f4c:	60e2                	ld	ra,24(sp)
    80002f4e:	6442                	ld	s0,16(sp)
    80002f50:	64a2                	ld	s1,8(sp)
    80002f52:	6902                	ld	s2,0(sp)
    80002f54:	6105                	addi	sp,sp,32
    80002f56:	8082                	ret
      exit(-1);
    80002f58:	557d                	li	a0,-1
    80002f5a:	fffff097          	auipc	ra,0xfffff
    80002f5e:	5d6080e7          	jalr	1494(ra) # 80002530 <exit>
    80002f62:	bf6d                	j	80002f1c <usertrap+0x84>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f64:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002f68:	5890                	lw	a2,48(s1)
    80002f6a:	00005517          	auipc	a0,0x5
    80002f6e:	43650513          	addi	a0,a0,1078 # 800083a0 <etext+0x3a0>
    80002f72:	ffffd097          	auipc	ra,0xffffd
    80002f76:	636080e7          	jalr	1590(ra) # 800005a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f7a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f7e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f82:	00005517          	auipc	a0,0x5
    80002f86:	44e50513          	addi	a0,a0,1102 # 800083d0 <etext+0x3d0>
    80002f8a:	ffffd097          	auipc	ra,0xffffd
    80002f8e:	61e080e7          	jalr	1566(ra) # 800005a8 <printf>
    setkilled(p);
    80002f92:	8526                	mv	a0,s1
    80002f94:	fffff097          	auipc	ra,0xfffff
    80002f98:	790080e7          	jalr	1936(ra) # 80002724 <setkilled>
    80002f9c:	bf71                	j	80002f38 <usertrap+0xa0>
  if (killed(p))
    80002f9e:	4901                	li	s2,0
    exit(-1);
    80002fa0:	557d                	li	a0,-1
    80002fa2:	fffff097          	auipc	ra,0xfffff
    80002fa6:	58e080e7          	jalr	1422(ra) # 80002530 <exit>
  if (which_dev == 2) {
    80002faa:	4789                	li	a5,2
    80002fac:	f8f91ce3          	bne	s2,a5,80002f44 <usertrap+0xac>
    if (p != 0 && p->state == RUNNING) {
    80002fb0:	4c98                	lw	a4,24(s1)
    80002fb2:	4791                	li	a5,4
    80002fb4:	f8f718e3          	bne	a4,a5,80002f44 <usertrap+0xac>
      p->rtime++;
    80002fb8:	1684a783          	lw	a5,360(s1)
    80002fbc:	2785                	addiw	a5,a5,1
    80002fbe:	16f4a423          	sw	a5,360(s1)
      yield();
    80002fc2:	fffff097          	auipc	ra,0xfffff
    80002fc6:	3fe080e7          	jalr	1022(ra) # 800023c0 <yield>
    80002fca:	bfad                	j	80002f44 <usertrap+0xac>

0000000080002fcc <kerneltrap>:
{
    80002fcc:	7179                	addi	sp,sp,-48
    80002fce:	f406                	sd	ra,40(sp)
    80002fd0:	f022                	sd	s0,32(sp)
    80002fd2:	ec26                	sd	s1,24(sp)
    80002fd4:	e84a                	sd	s2,16(sp)
    80002fd6:	e44e                	sd	s3,8(sp)
    80002fd8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002fda:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002fde:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002fe2:	142027f3          	csrr	a5,scause
    80002fe6:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    80002fe8:	1004f793          	andi	a5,s1,256
    80002fec:	cb85                	beqz	a5,8000301c <kerneltrap+0x50>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002fee:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002ff2:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002ff4:	ef85                	bnez	a5,8000302c <kerneltrap+0x60>
  which_dev = devintr();
    80002ff6:	00000097          	auipc	ra,0x0
    80002ffa:	df6080e7          	jalr	-522(ra) # 80002dec <devintr>
  if (which_dev == 0) {
    80002ffe:	cd1d                	beqz	a0,8000303c <kerneltrap+0x70>
  if (which_dev == 2) {
    80003000:	4789                	li	a5,2
    80003002:	06f50a63          	beq	a0,a5,80003076 <kerneltrap+0xaa>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003006:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000300a:	10049073          	csrw	sstatus,s1
}
    8000300e:	70a2                	ld	ra,40(sp)
    80003010:	7402                	ld	s0,32(sp)
    80003012:	64e2                	ld	s1,24(sp)
    80003014:	6942                	ld	s2,16(sp)
    80003016:	69a2                	ld	s3,8(sp)
    80003018:	6145                	addi	sp,sp,48
    8000301a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000301c:	00005517          	auipc	a0,0x5
    80003020:	3d450513          	addi	a0,a0,980 # 800083f0 <etext+0x3f0>
    80003024:	ffffd097          	auipc	ra,0xffffd
    80003028:	53a080e7          	jalr	1338(ra) # 8000055e <panic>
    panic("kerneltrap: interrupts enabled");
    8000302c:	00005517          	auipc	a0,0x5
    80003030:	3ec50513          	addi	a0,a0,1004 # 80008418 <etext+0x418>
    80003034:	ffffd097          	auipc	ra,0xffffd
    80003038:	52a080e7          	jalr	1322(ra) # 8000055e <panic>
    printf("scause %p\n", scause);
    8000303c:	85ce                	mv	a1,s3
    8000303e:	00005517          	auipc	a0,0x5
    80003042:	3fa50513          	addi	a0,a0,1018 # 80008438 <etext+0x438>
    80003046:	ffffd097          	auipc	ra,0xffffd
    8000304a:	562080e7          	jalr	1378(ra) # 800005a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000304e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003052:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003056:	00005517          	auipc	a0,0x5
    8000305a:	3f250513          	addi	a0,a0,1010 # 80008448 <etext+0x448>
    8000305e:	ffffd097          	auipc	ra,0xffffd
    80003062:	54a080e7          	jalr	1354(ra) # 800005a8 <printf>
    panic("kerneltrap");
    80003066:	00005517          	auipc	a0,0x5
    8000306a:	3fa50513          	addi	a0,a0,1018 # 80008460 <etext+0x460>
    8000306e:	ffffd097          	auipc	ra,0xffffd
    80003072:	4f0080e7          	jalr	1264(ra) # 8000055e <panic>
    struct proc *p = myproc();
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	b16080e7          	jalr	-1258(ra) # 80001b8c <myproc>
    if (p != 0 && p->state == RUNNING) {
    8000307e:	d541                	beqz	a0,80003006 <kerneltrap+0x3a>
    80003080:	4d18                	lw	a4,24(a0)
    80003082:	4791                	li	a5,4
    80003084:	f8f711e3          	bne	a4,a5,80003006 <kerneltrap+0x3a>
      p->rtime++;
    80003088:	16852783          	lw	a5,360(a0)
    8000308c:	2785                	addiw	a5,a5,1
    8000308e:	16f52423          	sw	a5,360(a0)
      yield();
    80003092:	fffff097          	auipc	ra,0xfffff
    80003096:	32e080e7          	jalr	814(ra) # 800023c0 <yield>
    8000309a:	b7b5                	j	80003006 <kerneltrap+0x3a>

000000008000309c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000309c:	1101                	addi	sp,sp,-32
    8000309e:	ec06                	sd	ra,24(sp)
    800030a0:	e822                	sd	s0,16(sp)
    800030a2:	e426                	sd	s1,8(sp)
    800030a4:	1000                	addi	s0,sp,32
    800030a6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800030a8:	fffff097          	auipc	ra,0xfffff
    800030ac:	ae4080e7          	jalr	-1308(ra) # 80001b8c <myproc>
  switch (n) {
    800030b0:	4795                	li	a5,5
    800030b2:	0497e163          	bltu	a5,s1,800030f4 <argraw+0x58>
    800030b6:	048a                	slli	s1,s1,0x2
    800030b8:	00006717          	auipc	a4,0x6
    800030bc:	83070713          	addi	a4,a4,-2000 # 800088e8 <digits+0x18>
    800030c0:	94ba                	add	s1,s1,a4
    800030c2:	409c                	lw	a5,0(s1)
    800030c4:	97ba                	add	a5,a5,a4
    800030c6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800030c8:	6d3c                	ld	a5,88(a0)
    800030ca:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800030cc:	60e2                	ld	ra,24(sp)
    800030ce:	6442                	ld	s0,16(sp)
    800030d0:	64a2                	ld	s1,8(sp)
    800030d2:	6105                	addi	sp,sp,32
    800030d4:	8082                	ret
    return p->trapframe->a1;
    800030d6:	6d3c                	ld	a5,88(a0)
    800030d8:	7fa8                	ld	a0,120(a5)
    800030da:	bfcd                	j	800030cc <argraw+0x30>
    return p->trapframe->a2;
    800030dc:	6d3c                	ld	a5,88(a0)
    800030de:	63c8                	ld	a0,128(a5)
    800030e0:	b7f5                	j	800030cc <argraw+0x30>
    return p->trapframe->a3;
    800030e2:	6d3c                	ld	a5,88(a0)
    800030e4:	67c8                	ld	a0,136(a5)
    800030e6:	b7dd                	j	800030cc <argraw+0x30>
    return p->trapframe->a4;
    800030e8:	6d3c                	ld	a5,88(a0)
    800030ea:	6bc8                	ld	a0,144(a5)
    800030ec:	b7c5                	j	800030cc <argraw+0x30>
    return p->trapframe->a5;
    800030ee:	6d3c                	ld	a5,88(a0)
    800030f0:	6fc8                	ld	a0,152(a5)
    800030f2:	bfe9                	j	800030cc <argraw+0x30>
  panic("argraw");
    800030f4:	00005517          	auipc	a0,0x5
    800030f8:	37c50513          	addi	a0,a0,892 # 80008470 <etext+0x470>
    800030fc:	ffffd097          	auipc	ra,0xffffd
    80003100:	462080e7          	jalr	1122(ra) # 8000055e <panic>

0000000080003104 <fetchaddr>:
{
    80003104:	1101                	addi	sp,sp,-32
    80003106:	ec06                	sd	ra,24(sp)
    80003108:	e822                	sd	s0,16(sp)
    8000310a:	e426                	sd	s1,8(sp)
    8000310c:	e04a                	sd	s2,0(sp)
    8000310e:	1000                	addi	s0,sp,32
    80003110:	84aa                	mv	s1,a0
    80003112:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003114:	fffff097          	auipc	ra,0xfffff
    80003118:	a78080e7          	jalr	-1416(ra) # 80001b8c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000311c:	653c                	ld	a5,72(a0)
    8000311e:	02f4f863          	bgeu	s1,a5,8000314e <fetchaddr+0x4a>
    80003122:	00848713          	addi	a4,s1,8
    80003126:	02e7e663          	bltu	a5,a4,80003152 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000312a:	46a1                	li	a3,8
    8000312c:	8626                	mv	a2,s1
    8000312e:	85ca                	mv	a1,s2
    80003130:	6928                	ld	a0,80(a0)
    80003132:	ffffe097          	auipc	ra,0xffffe
    80003136:	672080e7          	jalr	1650(ra) # 800017a4 <copyin>
    8000313a:	00a03533          	snez	a0,a0
    8000313e:	40a0053b          	negw	a0,a0
}
    80003142:	60e2                	ld	ra,24(sp)
    80003144:	6442                	ld	s0,16(sp)
    80003146:	64a2                	ld	s1,8(sp)
    80003148:	6902                	ld	s2,0(sp)
    8000314a:	6105                	addi	sp,sp,32
    8000314c:	8082                	ret
    return -1;
    8000314e:	557d                	li	a0,-1
    80003150:	bfcd                	j	80003142 <fetchaddr+0x3e>
    80003152:	557d                	li	a0,-1
    80003154:	b7fd                	j	80003142 <fetchaddr+0x3e>

0000000080003156 <fetchstr>:
{
    80003156:	7179                	addi	sp,sp,-48
    80003158:	f406                	sd	ra,40(sp)
    8000315a:	f022                	sd	s0,32(sp)
    8000315c:	ec26                	sd	s1,24(sp)
    8000315e:	e84a                	sd	s2,16(sp)
    80003160:	e44e                	sd	s3,8(sp)
    80003162:	1800                	addi	s0,sp,48
    80003164:	89aa                	mv	s3,a0
    80003166:	84ae                	mv	s1,a1
    80003168:	8932                	mv	s2,a2
  struct proc *p = myproc();
    8000316a:	fffff097          	auipc	ra,0xfffff
    8000316e:	a22080e7          	jalr	-1502(ra) # 80001b8c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003172:	86ca                	mv	a3,s2
    80003174:	864e                	mv	a2,s3
    80003176:	85a6                	mv	a1,s1
    80003178:	6928                	ld	a0,80(a0)
    8000317a:	ffffe097          	auipc	ra,0xffffe
    8000317e:	6b8080e7          	jalr	1720(ra) # 80001832 <copyinstr>
    80003182:	00054e63          	bltz	a0,8000319e <fetchstr+0x48>
  return strlen(buf);
    80003186:	8526                	mv	a0,s1
    80003188:	ffffe097          	auipc	ra,0xffffe
    8000318c:	d5a080e7          	jalr	-678(ra) # 80000ee2 <strlen>
}
    80003190:	70a2                	ld	ra,40(sp)
    80003192:	7402                	ld	s0,32(sp)
    80003194:	64e2                	ld	s1,24(sp)
    80003196:	6942                	ld	s2,16(sp)
    80003198:	69a2                	ld	s3,8(sp)
    8000319a:	6145                	addi	sp,sp,48
    8000319c:	8082                	ret
    return -1;
    8000319e:	557d                	li	a0,-1
    800031a0:	bfc5                	j	80003190 <fetchstr+0x3a>

00000000800031a2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800031a2:	1101                	addi	sp,sp,-32
    800031a4:	ec06                	sd	ra,24(sp)
    800031a6:	e822                	sd	s0,16(sp)
    800031a8:	e426                	sd	s1,8(sp)
    800031aa:	1000                	addi	s0,sp,32
    800031ac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	eee080e7          	jalr	-274(ra) # 8000309c <argraw>
    800031b6:	c088                	sw	a0,0(s1)
    return 0;
}
    800031b8:	4501                	li	a0,0
    800031ba:	60e2                	ld	ra,24(sp)
    800031bc:	6442                	ld	s0,16(sp)
    800031be:	64a2                	ld	s1,8(sp)
    800031c0:	6105                	addi	sp,sp,32
    800031c2:	8082                	ret

00000000800031c4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800031c4:	1101                	addi	sp,sp,-32
    800031c6:	ec06                	sd	ra,24(sp)
    800031c8:	e822                	sd	s0,16(sp)
    800031ca:	e426                	sd	s1,8(sp)
    800031cc:	1000                	addi	s0,sp,32
    800031ce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	ecc080e7          	jalr	-308(ra) # 8000309c <argraw>
    800031d8:	e088                	sd	a0,0(s1)
  return 0;
}
    800031da:	4501                	li	a0,0
    800031dc:	60e2                	ld	ra,24(sp)
    800031de:	6442                	ld	s0,16(sp)
    800031e0:	64a2                	ld	s1,8(sp)
    800031e2:	6105                	addi	sp,sp,32
    800031e4:	8082                	ret

00000000800031e6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800031e6:	1101                	addi	sp,sp,-32
    800031e8:	ec06                	sd	ra,24(sp)
    800031ea:	e822                	sd	s0,16(sp)
    800031ec:	e426                	sd	s1,8(sp)
    800031ee:	e04a                	sd	s2,0(sp)
    800031f0:	1000                	addi	s0,sp,32
    800031f2:	892e                	mv	s2,a1
    800031f4:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	ea6080e7          	jalr	-346(ra) # 8000309c <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800031fe:	8626                	mv	a2,s1
    80003200:	85ca                	mv	a1,s2
    80003202:	00000097          	auipc	ra,0x0
    80003206:	f54080e7          	jalr	-172(ra) # 80003156 <fetchstr>
}
    8000320a:	60e2                	ld	ra,24(sp)
    8000320c:	6442                	ld	s0,16(sp)
    8000320e:	64a2                	ld	s1,8(sp)
    80003210:	6902                	ld	s2,0(sp)
    80003212:	6105                	addi	sp,sp,32
    80003214:	8082                	ret

0000000080003216 <syscall>:

};

void
syscall(void)
{
    80003216:	1101                	addi	sp,sp,-32
    80003218:	ec06                	sd	ra,24(sp)
    8000321a:	e822                	sd	s0,16(sp)
    8000321c:	e426                	sd	s1,8(sp)
    8000321e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003220:	fffff097          	auipc	ra,0xfffff
    80003224:	96c080e7          	jalr	-1684(ra) # 80001b8c <myproc>
    80003228:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000322a:	6d3c                	ld	a5,88(a0)
    8000322c:	77dc                	ld	a5,168(a5)
    8000322e:	0007869b          	sext.w	a3,a5
  
  
   
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003232:	37fd                	addiw	a5,a5,-1
    80003234:	4765                	li	a4,25
    80003236:	02f76863          	bltu	a4,a5,80003266 <syscall+0x50>
    8000323a:	00369713          	slli	a4,a3,0x3
    8000323e:	00005797          	auipc	a5,0x5
    80003242:	6c278793          	addi	a5,a5,1730 # 80008900 <syscalls>
    80003246:	97ba                	add	a5,a5,a4
    80003248:	6398                	ld	a4,0(a5)
    8000324a:	cf11                	beqz	a4,80003266 <syscall+0x50>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
     // Increment the syscall count for this syscall's parent
      if(p->parent!=NULL)  p->parent->syscall_count[num]++; // Ensure syscall_count is initialized
    8000324c:	7d1c                	ld	a5,56(a0)
    8000324e:	cb81                	beqz	a5,8000325e <syscall+0x48>
    80003250:	068a                	slli	a3,a3,0x2
    80003252:	97b6                	add	a5,a5,a3
    80003254:	1747a683          	lw	a3,372(a5)
    80003258:	2685                	addiw	a3,a3,1
    8000325a:	16d7aa23          	sw	a3,372(a5)
    p->trapframe->a0 = syscalls[num]();
    8000325e:	6ca4                	ld	s1,88(s1)
    80003260:	9702                	jalr	a4
    80003262:	f8a8                	sd	a0,112(s1)
    80003264:	a839                	j	80003282 <syscall+0x6c>
  
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003266:	15848613          	addi	a2,s1,344
    8000326a:	588c                	lw	a1,48(s1)
    8000326c:	00005517          	auipc	a0,0x5
    80003270:	20c50513          	addi	a0,a0,524 # 80008478 <etext+0x478>
    80003274:	ffffd097          	auipc	ra,0xffffd
    80003278:	334080e7          	jalr	820(ra) # 800005a8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000327c:	6cbc                	ld	a5,88(s1)
    8000327e:	577d                	li	a4,-1
    80003280:	fbb8                	sd	a4,112(a5)
  }
}
    80003282:	60e2                	ld	ra,24(sp)
    80003284:	6442                	ld	s0,16(sp)
    80003286:	64a2                	ld	s1,8(sp)
    80003288:	6105                	addi	sp,sp,32
    8000328a:	8082                	ret

000000008000328c <sys_getreadcount>:
#define NUMBER_OF_SYSCALLS 32 

// sysproc.c
uint64
sys_getreadcount(void)
{
    8000328c:	1141                	addi	sp,sp,-16
    8000328e:	e406                	sd	ra,8(sp)
    80003290:	e022                	sd	s0,0(sp)
    80003292:	0800                	addi	s0,sp,16
  return (uint64)get_readcount();  // returns a uint; wraps naturally
    80003294:	00002097          	auipc	ra,0x2
    80003298:	f20080e7          	jalr	-224(ra) # 800051b4 <get_readcount>
}
    8000329c:	1502                	slli	a0,a0,0x20
    8000329e:	9101                	srli	a0,a0,0x20
    800032a0:	60a2                	ld	ra,8(sp)
    800032a2:	6402                	ld	s0,0(sp)
    800032a4:	0141                	addi	sp,sp,16
    800032a6:	8082                	ret

00000000800032a8 <sys_printlog>:


uint64 
sys_printlog(void) {
    800032a8:	1141                	addi	sp,sp,-16
    800032aa:	e406                	sd	ra,8(sp)
    800032ac:	e022                	sd	s0,0(sp)
    800032ae:	0800                	addi	s0,sp,16
  print_logg();
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	8d2080e7          	jalr	-1838(ra) # 80002b82 <print_logg>
  return 0 ;
}
    800032b8:	4501                	li	a0,0
    800032ba:	60a2                	ld	ra,8(sp)
    800032bc:	6402                	ld	s0,0(sp)
    800032be:	0141                	addi	sp,sp,16
    800032c0:	8082                	ret

00000000800032c2 <sys_sigalarm>:


uint64
 sys_sigalarm(void) {
    800032c2:	1101                	addi	sp,sp,-32
    800032c4:	ec06                	sd	ra,24(sp)
    800032c6:	e822                	sd	s0,16(sp)
    800032c8:	1000                	addi	s0,sp,32
  int intervalj;
  uint64 handlerj;

  argint(0, &intervalj) ;
    800032ca:	fec40593          	addi	a1,s0,-20
    800032ce:	4501                	li	a0,0
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	ed2080e7          	jalr	-302(ra) # 800031a2 <argint>
  argaddr(1, &handlerj) ;
    800032d8:	fe040593          	addi	a1,s0,-32
    800032dc:	4505                	li	a0,1
    800032de:	00000097          	auipc	ra,0x0
    800032e2:	ee6080e7          	jalr	-282(ra) # 800031c4 <argaddr>
  

  struct proc *p = myproc();
    800032e6:	fffff097          	auipc	ra,0xfffff
    800032ea:	8a6080e7          	jalr	-1882(ra) # 80001b8c <myproc>
  
  p->ticks = intervalj;
    800032ee:	fec42783          	lw	a5,-20(s0)
    800032f2:	20f52423          	sw	a5,520(a0)

  p->handler = handlerj;
    800032f6:	fe043783          	ld	a5,-32(s0)
    800032fa:	20f53823          	sd	a5,528(a0)
  p->alarm_act = 1;  // Alarm is now active
    800032fe:	4785                	li	a5,1
    80003300:	22f52423          	sw	a5,552(a0)
  

  return 0;
}
    80003304:	4501                	li	a0,0
    80003306:	60e2                	ld	ra,24(sp)
    80003308:	6442                	ld	s0,16(sp)
    8000330a:	6105                	addi	sp,sp,32
    8000330c:	8082                	ret

000000008000330e <sys_sigreturn>:

uint64 
sys_sigreturn(void)
{
    8000330e:	1101                	addi	sp,sp,-32
    80003310:	ec06                	sd	ra,24(sp)
    80003312:	e822                	sd	s0,16(sp)
    80003314:	e426                	sd	s1,8(sp)
    80003316:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80003318:	fffff097          	auipc	ra,0xfffff
    8000331c:	874080e7          	jalr	-1932(ra) # 80001b8c <myproc>
    80003320:	84aa                	mv	s1,a0
  memmove(p->trapframe, p->alarm_tf, PGSIZE);
    80003322:	6605                	lui	a2,0x1
    80003324:	22053583          	ld	a1,544(a0)
    80003328:	6d28                	ld	a0,88(a0)
    8000332a:	ffffe097          	auipc	ra,0xffffe
    8000332e:	a8a080e7          	jalr	-1398(ra) # 80000db4 <memmove>
 
  kfree(p->alarm_tf);
    80003332:	2204b503          	ld	a0,544(s1)
    80003336:	ffffd097          	auipc	ra,0xffffd
    8000333a:	71e080e7          	jalr	1822(ra) # 80000a54 <kfree>
  p->hlp = 1;
    8000333e:	4785                	li	a5,1
    80003340:	20f4ac23          	sw	a5,536(s1)
  return myproc()->trapframe->a0;
    80003344:	fffff097          	auipc	ra,0xfffff
    80003348:	848080e7          	jalr	-1976(ra) # 80001b8c <myproc>
    8000334c:	6d3c                	ld	a5,88(a0)
}
    8000334e:	7ba8                	ld	a0,112(a5)
    80003350:	60e2                	ld	ra,24(sp)
    80003352:	6442                	ld	s0,16(sp)
    80003354:	64a2                	ld	s1,8(sp)
    80003356:	6105                	addi	sp,sp,32
    80003358:	8082                	ret

000000008000335a <sys_settickets>:

uint64
sys_settickets(void)
{
    8000335a:	1101                	addi	sp,sp,-32
    8000335c:	ec06                	sd	ra,24(sp)
    8000335e:	e822                	sd	s0,16(sp)
    80003360:	1000                	addi	s0,sp,32
    int n;
     (argint(0, &n)); 
    80003362:	fec40593          	addi	a1,s0,-20
    80003366:	4501                	li	a0,0
    80003368:	00000097          	auipc	ra,0x0
    8000336c:	e3a080e7          	jalr	-454(ra) # 800031a2 <argint>
     if( n < 1) {
    80003370:	fec42783          	lw	a5,-20(s0)
        return -1; // Invalid input
    80003374:	557d                	li	a0,-1
     if( n < 1) {
    80003376:	00f05b63          	blez	a5,8000338c <sys_settickets+0x32>
    }
    
    // Set the tickets for the calling process
    struct proc *p = myproc();
    8000337a:	fffff097          	auipc	ra,0xfffff
    8000337e:	812080e7          	jalr	-2030(ra) # 80001b8c <myproc>
    p->tickets = n;
    80003382:	fec42783          	lw	a5,-20(s0)
    80003386:	1ef52c23          	sw	a5,504(a0)
    
    return 0;
    8000338a:	4501                	li	a0,0
}
    8000338c:	60e2                	ld	ra,24(sp)
    8000338e:	6442                	ld	s0,16(sp)
    80003390:	6105                	addi	sp,sp,32
    80003392:	8082                	ret

0000000080003394 <sys_setcfslog>:



uint64
sys_setcfslog(void)
{
    80003394:	1101                	addi	sp,sp,-32
    80003396:	ec06                	sd	ra,24(sp)
    80003398:	e822                	sd	s0,16(sp)
    8000339a:	1000                	addi	s0,sp,32
  int on;
  if (argint(0, &on) < 0)
    8000339c:	fec40593          	addi	a1,s0,-20
    800033a0:	4501                	li	a0,0
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	e00080e7          	jalr	-512(ra) # 800031a2 <argint>
    800033aa:	00054d63          	bltz	a0,800033c4 <sys_setcfslog+0x30>
    return -1;
  cfs_logging_enabled = on;
    800033ae:	fec42783          	lw	a5,-20(s0)
    800033b2:	00005717          	auipc	a4,0x5
    800033b6:	78f72523          	sw	a5,1930(a4) # 80008b3c <cfs_logging_enabled>
  return 0;
    800033ba:	4501                	li	a0,0
}
    800033bc:	60e2                	ld	ra,24(sp)
    800033be:	6442                	ld	s0,16(sp)
    800033c0:	6105                	addi	sp,sp,32
    800033c2:	8082                	ret
    return -1;
    800033c4:	557d                	li	a0,-1
    800033c6:	bfdd                	j	800033bc <sys_setcfslog+0x28>

00000000800033c8 <sys_exit>:



uint64
sys_exit(void)
{
    800033c8:	1101                	addi	sp,sp,-32
    800033ca:	ec06                	sd	ra,24(sp)
    800033cc:	e822                	sd	s0,16(sp)
    800033ce:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800033d0:	fec40593          	addi	a1,s0,-20
    800033d4:	4501                	li	a0,0
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	dcc080e7          	jalr	-564(ra) # 800031a2 <argint>
  exit(n);
    800033de:	fec42503          	lw	a0,-20(s0)
    800033e2:	fffff097          	auipc	ra,0xfffff
    800033e6:	14e080e7          	jalr	334(ra) # 80002530 <exit>
  return 0; // not reached
}
    800033ea:	4501                	li	a0,0
    800033ec:	60e2                	ld	ra,24(sp)
    800033ee:	6442                	ld	s0,16(sp)
    800033f0:	6105                	addi	sp,sp,32
    800033f2:	8082                	ret

00000000800033f4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800033f4:	1141                	addi	sp,sp,-16
    800033f6:	e406                	sd	ra,8(sp)
    800033f8:	e022                	sd	s0,0(sp)
    800033fa:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800033fc:	ffffe097          	auipc	ra,0xffffe
    80003400:	790080e7          	jalr	1936(ra) # 80001b8c <myproc>
}
    80003404:	5908                	lw	a0,48(a0)
    80003406:	60a2                	ld	ra,8(sp)
    80003408:	6402                	ld	s0,0(sp)
    8000340a:	0141                	addi	sp,sp,16
    8000340c:	8082                	ret

000000008000340e <sys_fork>:

uint64
sys_fork(void)
{
    8000340e:	1141                	addi	sp,sp,-16
    80003410:	e406                	sd	ra,8(sp)
    80003412:	e022                	sd	s0,0(sp)
    80003414:	0800                	addi	s0,sp,16
  return fork();
    80003416:	fffff097          	auipc	ra,0xfffff
    8000341a:	baa080e7          	jalr	-1110(ra) # 80001fc0 <fork>
}
    8000341e:	60a2                	ld	ra,8(sp)
    80003420:	6402                	ld	s0,0(sp)
    80003422:	0141                	addi	sp,sp,16
    80003424:	8082                	ret

0000000080003426 <sys_wait>:

uint64
sys_wait(void)
{
    80003426:	1101                	addi	sp,sp,-32
    80003428:	ec06                	sd	ra,24(sp)
    8000342a:	e822                	sd	s0,16(sp)
    8000342c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000342e:	fe840593          	addi	a1,s0,-24
    80003432:	4501                	li	a0,0
    80003434:	00000097          	auipc	ra,0x0
    80003438:	d90080e7          	jalr	-624(ra) # 800031c4 <argaddr>
  return wait(p);
    8000343c:	fe843503          	ld	a0,-24(s0)
    80003440:	fffff097          	auipc	ra,0xfffff
    80003444:	342080e7          	jalr	834(ra) # 80002782 <wait>
}
    80003448:	60e2                	ld	ra,24(sp)
    8000344a:	6442                	ld	s0,16(sp)
    8000344c:	6105                	addi	sp,sp,32
    8000344e:	8082                	ret

0000000080003450 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003450:	7179                	addi	sp,sp,-48
    80003452:	f406                	sd	ra,40(sp)
    80003454:	f022                	sd	s0,32(sp)
    80003456:	ec26                	sd	s1,24(sp)
    80003458:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000345a:	fdc40593          	addi	a1,s0,-36
    8000345e:	4501                	li	a0,0
    80003460:	00000097          	auipc	ra,0x0
    80003464:	d42080e7          	jalr	-702(ra) # 800031a2 <argint>
  addr = myproc()->sz;
    80003468:	ffffe097          	auipc	ra,0xffffe
    8000346c:	724080e7          	jalr	1828(ra) # 80001b8c <myproc>
    80003470:	653c                	ld	a5,72(a0)
    80003472:	84be                	mv	s1,a5
  if (growproc(n) < 0)
    80003474:	fdc42503          	lw	a0,-36(s0)
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	aec080e7          	jalr	-1300(ra) # 80001f64 <growproc>
    80003480:	00054863          	bltz	a0,80003490 <sys_sbrk+0x40>
    return -1;
  return addr;
}
    80003484:	8526                	mv	a0,s1
    80003486:	70a2                	ld	ra,40(sp)
    80003488:	7402                	ld	s0,32(sp)
    8000348a:	64e2                	ld	s1,24(sp)
    8000348c:	6145                	addi	sp,sp,48
    8000348e:	8082                	ret
    return -1;
    80003490:	57fd                	li	a5,-1
    80003492:	84be                	mv	s1,a5
    80003494:	bfc5                	j	80003484 <sys_sbrk+0x34>

0000000080003496 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003496:	7139                	addi	sp,sp,-64
    80003498:	fc06                	sd	ra,56(sp)
    8000349a:	f822                	sd	s0,48(sp)
    8000349c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000349e:	fcc40593          	addi	a1,s0,-52
    800034a2:	4501                	li	a0,0
    800034a4:	00000097          	auipc	ra,0x0
    800034a8:	cfe080e7          	jalr	-770(ra) # 800031a2 <argint>
  acquire(&tickslock);
    800034ac:	0003f517          	auipc	a0,0x3f
    800034b0:	8c450513          	addi	a0,a0,-1852 # 80041d70 <tickslock>
    800034b4:	ffffd097          	auipc	ra,0xffffd
    800034b8:	7a8080e7          	jalr	1960(ra) # 80000c5c <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
    800034bc:	fcc42783          	lw	a5,-52(s0)
    800034c0:	cba9                	beqz	a5,80003512 <sys_sleep+0x7c>
    800034c2:	f426                	sd	s1,40(sp)
    800034c4:	f04a                	sd	s2,32(sp)
    800034c6:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    800034c8:	00005997          	auipc	s3,0x5
    800034cc:	6789a983          	lw	s3,1656(s3) # 80008b40 <ticks>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800034d0:	0003f917          	auipc	s2,0x3f
    800034d4:	8a090913          	addi	s2,s2,-1888 # 80041d70 <tickslock>
    800034d8:	00005497          	auipc	s1,0x5
    800034dc:	66848493          	addi	s1,s1,1640 # 80008b40 <ticks>
    if (killed(myproc()))
    800034e0:	ffffe097          	auipc	ra,0xffffe
    800034e4:	6ac080e7          	jalr	1708(ra) # 80001b8c <myproc>
    800034e8:	fffff097          	auipc	ra,0xfffff
    800034ec:	268080e7          	jalr	616(ra) # 80002750 <killed>
    800034f0:	ed15                	bnez	a0,8000352c <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800034f2:	85ca                	mv	a1,s2
    800034f4:	8526                	mv	a0,s1
    800034f6:	fffff097          	auipc	ra,0xfffff
    800034fa:	f06080e7          	jalr	-250(ra) # 800023fc <sleep>
  while (ticks - ticks0 < n)
    800034fe:	409c                	lw	a5,0(s1)
    80003500:	413787bb          	subw	a5,a5,s3
    80003504:	fcc42703          	lw	a4,-52(s0)
    80003508:	fce7ece3          	bltu	a5,a4,800034e0 <sys_sleep+0x4a>
    8000350c:	74a2                	ld	s1,40(sp)
    8000350e:	7902                	ld	s2,32(sp)
    80003510:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003512:	0003f517          	auipc	a0,0x3f
    80003516:	85e50513          	addi	a0,a0,-1954 # 80041d70 <tickslock>
    8000351a:	ffffd097          	auipc	ra,0xffffd
    8000351e:	7f2080e7          	jalr	2034(ra) # 80000d0c <release>
  return 0;
    80003522:	4501                	li	a0,0
}
    80003524:	70e2                	ld	ra,56(sp)
    80003526:	7442                	ld	s0,48(sp)
    80003528:	6121                	addi	sp,sp,64
    8000352a:	8082                	ret
      release(&tickslock);
    8000352c:	0003f517          	auipc	a0,0x3f
    80003530:	84450513          	addi	a0,a0,-1980 # 80041d70 <tickslock>
    80003534:	ffffd097          	auipc	ra,0xffffd
    80003538:	7d8080e7          	jalr	2008(ra) # 80000d0c <release>
      return -1;
    8000353c:	557d                	li	a0,-1
    8000353e:	74a2                	ld	s1,40(sp)
    80003540:	7902                	ld	s2,32(sp)
    80003542:	69e2                	ld	s3,24(sp)
    80003544:	b7c5                	j	80003524 <sys_sleep+0x8e>

0000000080003546 <sys_kill>:

uint64
sys_kill(void)
{
    80003546:	1101                	addi	sp,sp,-32
    80003548:	ec06                	sd	ra,24(sp)
    8000354a:	e822                	sd	s0,16(sp)
    8000354c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000354e:	fec40593          	addi	a1,s0,-20
    80003552:	4501                	li	a0,0
    80003554:	00000097          	auipc	ra,0x0
    80003558:	c4e080e7          	jalr	-946(ra) # 800031a2 <argint>
  return kill(pid);
    8000355c:	fec42503          	lw	a0,-20(s0)
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	0b6080e7          	jalr	182(ra) # 80002616 <kill>
}
    80003568:	60e2                	ld	ra,24(sp)
    8000356a:	6442                	ld	s0,16(sp)
    8000356c:	6105                	addi	sp,sp,32
    8000356e:	8082                	ret

0000000080003570 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003570:	1101                	addi	sp,sp,-32
    80003572:	ec06                	sd	ra,24(sp)
    80003574:	e822                	sd	s0,16(sp)
    80003576:	e426                	sd	s1,8(sp)
    80003578:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000357a:	0003e517          	auipc	a0,0x3e
    8000357e:	7f650513          	addi	a0,a0,2038 # 80041d70 <tickslock>
    80003582:	ffffd097          	auipc	ra,0xffffd
    80003586:	6da080e7          	jalr	1754(ra) # 80000c5c <acquire>
  xticks = ticks;
    8000358a:	00005797          	auipc	a5,0x5
    8000358e:	5b67a783          	lw	a5,1462(a5) # 80008b40 <ticks>
    80003592:	84be                	mv	s1,a5
  release(&tickslock);
    80003594:	0003e517          	auipc	a0,0x3e
    80003598:	7dc50513          	addi	a0,a0,2012 # 80041d70 <tickslock>
    8000359c:	ffffd097          	auipc	ra,0xffffd
    800035a0:	770080e7          	jalr	1904(ra) # 80000d0c <release>
  return xticks;
}
    800035a4:	02049513          	slli	a0,s1,0x20
    800035a8:	9101                	srli	a0,a0,0x20
    800035aa:	60e2                	ld	ra,24(sp)
    800035ac:	6442                	ld	s0,16(sp)
    800035ae:	64a2                	ld	s1,8(sp)
    800035b0:	6105                	addi	sp,sp,32
    800035b2:	8082                	ret

00000000800035b4 <sys_waitx>:

uint64
sys_waitx(void)
{
    800035b4:	715d                	addi	sp,sp,-80
    800035b6:	e486                	sd	ra,72(sp)
    800035b8:	e0a2                	sd	s0,64(sp)
    800035ba:	fc26                	sd	s1,56(sp)
    800035bc:	f84a                	sd	s2,48(sp)
    800035be:	f44e                	sd	s3,40(sp)
    800035c0:	0880                	addi	s0,sp,80
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    800035c2:	fc840593          	addi	a1,s0,-56
    800035c6:	4501                	li	a0,0
    800035c8:	00000097          	auipc	ra,0x0
    800035cc:	bfc080e7          	jalr	-1028(ra) # 800031c4 <argaddr>
  argaddr(1, &addr1); // user virtual memory
    800035d0:	fc040593          	addi	a1,s0,-64
    800035d4:	4505                	li	a0,1
    800035d6:	00000097          	auipc	ra,0x0
    800035da:	bee080e7          	jalr	-1042(ra) # 800031c4 <argaddr>
  argaddr(2, &addr2);
    800035de:	fb840593          	addi	a1,s0,-72
    800035e2:	4509                	li	a0,2
    800035e4:	00000097          	auipc	ra,0x0
    800035e8:	be0080e7          	jalr	-1056(ra) # 800031c4 <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    800035ec:	fb440913          	addi	s2,s0,-76
    800035f0:	fb040613          	addi	a2,s0,-80
    800035f4:	85ca                	mv	a1,s2
    800035f6:	fc843503          	ld	a0,-56(s0)
    800035fa:	fffff097          	auipc	ra,0xfffff
    800035fe:	3ec080e7          	jalr	1004(ra) # 800029e6 <waitx>
    80003602:	89aa                	mv	s3,a0
  struct proc *p = myproc();
    80003604:	ffffe097          	auipc	ra,0xffffe
    80003608:	588080e7          	jalr	1416(ra) # 80001b8c <myproc>
    8000360c:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    8000360e:	4691                	li	a3,4
    80003610:	864a                	mv	a2,s2
    80003612:	fc043583          	ld	a1,-64(s0)
    80003616:	6928                	ld	a0,80(a0)
    80003618:	ffffe097          	auipc	ra,0xffffe
    8000361c:	100080e7          	jalr	256(ra) # 80001718 <copyout>
    return -1;
    80003620:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003622:	00054f63          	bltz	a0,80003640 <sys_waitx+0x8c>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    80003626:	4691                	li	a3,4
    80003628:	fb040613          	addi	a2,s0,-80
    8000362c:	fb843583          	ld	a1,-72(s0)
    80003630:	68a8                	ld	a0,80(s1)
    80003632:	ffffe097          	auipc	ra,0xffffe
    80003636:	0e6080e7          	jalr	230(ra) # 80001718 <copyout>
    8000363a:	00054b63          	bltz	a0,80003650 <sys_waitx+0x9c>
    return -1;
  return ret;
    8000363e:	87ce                	mv	a5,s3
}
    80003640:	853e                	mv	a0,a5
    80003642:	60a6                	ld	ra,72(sp)
    80003644:	6406                	ld	s0,64(sp)
    80003646:	74e2                	ld	s1,56(sp)
    80003648:	7942                	ld	s2,48(sp)
    8000364a:	79a2                	ld	s3,40(sp)
    8000364c:	6161                	addi	sp,sp,80
    8000364e:	8082                	ret
    return -1;
    80003650:	57fd                	li	a5,-1
    80003652:	b7fd                	j	80003640 <sys_waitx+0x8c>

0000000080003654 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003654:	7179                	addi	sp,sp,-48
    80003656:	f406                	sd	ra,40(sp)
    80003658:	f022                	sd	s0,32(sp)
    8000365a:	ec26                	sd	s1,24(sp)
    8000365c:	e84a                	sd	s2,16(sp)
    8000365e:	e44e                	sd	s3,8(sp)
    80003660:	e052                	sd	s4,0(sp)
    80003662:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003664:	00005597          	auipc	a1,0x5
    80003668:	f2c58593          	addi	a1,a1,-212 # 80008590 <etext+0x590>
    8000366c:	0003e517          	auipc	a0,0x3e
    80003670:	71c50513          	addi	a0,a0,1820 # 80041d88 <bcache>
    80003674:	ffffd097          	auipc	ra,0xffffd
    80003678:	54e080e7          	jalr	1358(ra) # 80000bc2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000367c:	00046797          	auipc	a5,0x46
    80003680:	70c78793          	addi	a5,a5,1804 # 80049d88 <bcache+0x8000>
    80003684:	00047717          	auipc	a4,0x47
    80003688:	96c70713          	addi	a4,a4,-1684 # 80049ff0 <bcache+0x8268>
    8000368c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003690:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003694:	0003e497          	auipc	s1,0x3e
    80003698:	70c48493          	addi	s1,s1,1804 # 80041da0 <bcache+0x18>
    b->next = bcache.head.next;
    8000369c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000369e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800036a0:	00005a17          	auipc	s4,0x5
    800036a4:	ef8a0a13          	addi	s4,s4,-264 # 80008598 <etext+0x598>
    b->next = bcache.head.next;
    800036a8:	2b893783          	ld	a5,696(s2)
    800036ac:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800036ae:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800036b2:	85d2                	mv	a1,s4
    800036b4:	01048513          	addi	a0,s1,16
    800036b8:	00001097          	auipc	ra,0x1
    800036bc:	4ec080e7          	jalr	1260(ra) # 80004ba4 <initsleeplock>
    bcache.head.next->prev = b;
    800036c0:	2b893783          	ld	a5,696(s2)
    800036c4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800036c6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800036ca:	45848493          	addi	s1,s1,1112
    800036ce:	fd349de3          	bne	s1,s3,800036a8 <binit+0x54>
  }
}
    800036d2:	70a2                	ld	ra,40(sp)
    800036d4:	7402                	ld	s0,32(sp)
    800036d6:	64e2                	ld	s1,24(sp)
    800036d8:	6942                	ld	s2,16(sp)
    800036da:	69a2                	ld	s3,8(sp)
    800036dc:	6a02                	ld	s4,0(sp)
    800036de:	6145                	addi	sp,sp,48
    800036e0:	8082                	ret

00000000800036e2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800036e2:	7179                	addi	sp,sp,-48
    800036e4:	f406                	sd	ra,40(sp)
    800036e6:	f022                	sd	s0,32(sp)
    800036e8:	ec26                	sd	s1,24(sp)
    800036ea:	e84a                	sd	s2,16(sp)
    800036ec:	e44e                	sd	s3,8(sp)
    800036ee:	1800                	addi	s0,sp,48
    800036f0:	892a                	mv	s2,a0
    800036f2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800036f4:	0003e517          	auipc	a0,0x3e
    800036f8:	69450513          	addi	a0,a0,1684 # 80041d88 <bcache>
    800036fc:	ffffd097          	auipc	ra,0xffffd
    80003700:	560080e7          	jalr	1376(ra) # 80000c5c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003704:	00047497          	auipc	s1,0x47
    80003708:	93c4b483          	ld	s1,-1732(s1) # 8004a040 <bcache+0x82b8>
    8000370c:	00047797          	auipc	a5,0x47
    80003710:	8e478793          	addi	a5,a5,-1820 # 80049ff0 <bcache+0x8268>
    80003714:	02f48f63          	beq	s1,a5,80003752 <bread+0x70>
    80003718:	873e                	mv	a4,a5
    8000371a:	a021                	j	80003722 <bread+0x40>
    8000371c:	68a4                	ld	s1,80(s1)
    8000371e:	02e48a63          	beq	s1,a4,80003752 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003722:	449c                	lw	a5,8(s1)
    80003724:	ff279ce3          	bne	a5,s2,8000371c <bread+0x3a>
    80003728:	44dc                	lw	a5,12(s1)
    8000372a:	ff3799e3          	bne	a5,s3,8000371c <bread+0x3a>
      b->refcnt++;
    8000372e:	40bc                	lw	a5,64(s1)
    80003730:	2785                	addiw	a5,a5,1
    80003732:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003734:	0003e517          	auipc	a0,0x3e
    80003738:	65450513          	addi	a0,a0,1620 # 80041d88 <bcache>
    8000373c:	ffffd097          	auipc	ra,0xffffd
    80003740:	5d0080e7          	jalr	1488(ra) # 80000d0c <release>
      acquiresleep(&b->lock);
    80003744:	01048513          	addi	a0,s1,16
    80003748:	00001097          	auipc	ra,0x1
    8000374c:	496080e7          	jalr	1174(ra) # 80004bde <acquiresleep>
      return b;
    80003750:	a8b9                	j	800037ae <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003752:	00047497          	auipc	s1,0x47
    80003756:	8e64b483          	ld	s1,-1818(s1) # 8004a038 <bcache+0x82b0>
    8000375a:	00047797          	auipc	a5,0x47
    8000375e:	89678793          	addi	a5,a5,-1898 # 80049ff0 <bcache+0x8268>
    80003762:	00f48863          	beq	s1,a5,80003772 <bread+0x90>
    80003766:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003768:	40bc                	lw	a5,64(s1)
    8000376a:	cf81                	beqz	a5,80003782 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000376c:	64a4                	ld	s1,72(s1)
    8000376e:	fee49de3          	bne	s1,a4,80003768 <bread+0x86>
  panic("bget: no buffers");
    80003772:	00005517          	auipc	a0,0x5
    80003776:	e2e50513          	addi	a0,a0,-466 # 800085a0 <etext+0x5a0>
    8000377a:	ffffd097          	auipc	ra,0xffffd
    8000377e:	de4080e7          	jalr	-540(ra) # 8000055e <panic>
      b->dev = dev;
    80003782:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003786:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000378a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000378e:	4785                	li	a5,1
    80003790:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003792:	0003e517          	auipc	a0,0x3e
    80003796:	5f650513          	addi	a0,a0,1526 # 80041d88 <bcache>
    8000379a:	ffffd097          	auipc	ra,0xffffd
    8000379e:	572080e7          	jalr	1394(ra) # 80000d0c <release>
      acquiresleep(&b->lock);
    800037a2:	01048513          	addi	a0,s1,16
    800037a6:	00001097          	auipc	ra,0x1
    800037aa:	438080e7          	jalr	1080(ra) # 80004bde <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800037ae:	409c                	lw	a5,0(s1)
    800037b0:	cb89                	beqz	a5,800037c2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800037b2:	8526                	mv	a0,s1
    800037b4:	70a2                	ld	ra,40(sp)
    800037b6:	7402                	ld	s0,32(sp)
    800037b8:	64e2                	ld	s1,24(sp)
    800037ba:	6942                	ld	s2,16(sp)
    800037bc:	69a2                	ld	s3,8(sp)
    800037be:	6145                	addi	sp,sp,48
    800037c0:	8082                	ret
    virtio_disk_rw(b, 0);
    800037c2:	4581                	li	a1,0
    800037c4:	8526                	mv	a0,s1
    800037c6:	00003097          	auipc	ra,0x3
    800037ca:	202080e7          	jalr	514(ra) # 800069c8 <virtio_disk_rw>
    b->valid = 1;
    800037ce:	4785                	li	a5,1
    800037d0:	c09c                	sw	a5,0(s1)
  return b;
    800037d2:	b7c5                	j	800037b2 <bread+0xd0>

00000000800037d4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800037d4:	1101                	addi	sp,sp,-32
    800037d6:	ec06                	sd	ra,24(sp)
    800037d8:	e822                	sd	s0,16(sp)
    800037da:	e426                	sd	s1,8(sp)
    800037dc:	1000                	addi	s0,sp,32
    800037de:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800037e0:	0541                	addi	a0,a0,16
    800037e2:	00001097          	auipc	ra,0x1
    800037e6:	496080e7          	jalr	1174(ra) # 80004c78 <holdingsleep>
    800037ea:	cd01                	beqz	a0,80003802 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800037ec:	4585                	li	a1,1
    800037ee:	8526                	mv	a0,s1
    800037f0:	00003097          	auipc	ra,0x3
    800037f4:	1d8080e7          	jalr	472(ra) # 800069c8 <virtio_disk_rw>
}
    800037f8:	60e2                	ld	ra,24(sp)
    800037fa:	6442                	ld	s0,16(sp)
    800037fc:	64a2                	ld	s1,8(sp)
    800037fe:	6105                	addi	sp,sp,32
    80003800:	8082                	ret
    panic("bwrite");
    80003802:	00005517          	auipc	a0,0x5
    80003806:	db650513          	addi	a0,a0,-586 # 800085b8 <etext+0x5b8>
    8000380a:	ffffd097          	auipc	ra,0xffffd
    8000380e:	d54080e7          	jalr	-684(ra) # 8000055e <panic>

0000000080003812 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003812:	1101                	addi	sp,sp,-32
    80003814:	ec06                	sd	ra,24(sp)
    80003816:	e822                	sd	s0,16(sp)
    80003818:	e426                	sd	s1,8(sp)
    8000381a:	e04a                	sd	s2,0(sp)
    8000381c:	1000                	addi	s0,sp,32
    8000381e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003820:	01050913          	addi	s2,a0,16
    80003824:	854a                	mv	a0,s2
    80003826:	00001097          	auipc	ra,0x1
    8000382a:	452080e7          	jalr	1106(ra) # 80004c78 <holdingsleep>
    8000382e:	c535                	beqz	a0,8000389a <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80003830:	854a                	mv	a0,s2
    80003832:	00001097          	auipc	ra,0x1
    80003836:	402080e7          	jalr	1026(ra) # 80004c34 <releasesleep>

  acquire(&bcache.lock);
    8000383a:	0003e517          	auipc	a0,0x3e
    8000383e:	54e50513          	addi	a0,a0,1358 # 80041d88 <bcache>
    80003842:	ffffd097          	auipc	ra,0xffffd
    80003846:	41a080e7          	jalr	1050(ra) # 80000c5c <acquire>
  b->refcnt--;
    8000384a:	40bc                	lw	a5,64(s1)
    8000384c:	37fd                	addiw	a5,a5,-1
    8000384e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003850:	e79d                	bnez	a5,8000387e <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003852:	68b8                	ld	a4,80(s1)
    80003854:	64bc                	ld	a5,72(s1)
    80003856:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003858:	68b8                	ld	a4,80(s1)
    8000385a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000385c:	00046797          	auipc	a5,0x46
    80003860:	52c78793          	addi	a5,a5,1324 # 80049d88 <bcache+0x8000>
    80003864:	2b87b703          	ld	a4,696(a5)
    80003868:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000386a:	00046717          	auipc	a4,0x46
    8000386e:	78670713          	addi	a4,a4,1926 # 80049ff0 <bcache+0x8268>
    80003872:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003874:	2b87b703          	ld	a4,696(a5)
    80003878:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000387a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000387e:	0003e517          	auipc	a0,0x3e
    80003882:	50a50513          	addi	a0,a0,1290 # 80041d88 <bcache>
    80003886:	ffffd097          	auipc	ra,0xffffd
    8000388a:	486080e7          	jalr	1158(ra) # 80000d0c <release>
}
    8000388e:	60e2                	ld	ra,24(sp)
    80003890:	6442                	ld	s0,16(sp)
    80003892:	64a2                	ld	s1,8(sp)
    80003894:	6902                	ld	s2,0(sp)
    80003896:	6105                	addi	sp,sp,32
    80003898:	8082                	ret
    panic("brelse");
    8000389a:	00005517          	auipc	a0,0x5
    8000389e:	d2650513          	addi	a0,a0,-730 # 800085c0 <etext+0x5c0>
    800038a2:	ffffd097          	auipc	ra,0xffffd
    800038a6:	cbc080e7          	jalr	-836(ra) # 8000055e <panic>

00000000800038aa <bpin>:

void
bpin(struct buf *b) {
    800038aa:	1101                	addi	sp,sp,-32
    800038ac:	ec06                	sd	ra,24(sp)
    800038ae:	e822                	sd	s0,16(sp)
    800038b0:	e426                	sd	s1,8(sp)
    800038b2:	1000                	addi	s0,sp,32
    800038b4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800038b6:	0003e517          	auipc	a0,0x3e
    800038ba:	4d250513          	addi	a0,a0,1234 # 80041d88 <bcache>
    800038be:	ffffd097          	auipc	ra,0xffffd
    800038c2:	39e080e7          	jalr	926(ra) # 80000c5c <acquire>
  b->refcnt++;
    800038c6:	40bc                	lw	a5,64(s1)
    800038c8:	2785                	addiw	a5,a5,1
    800038ca:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800038cc:	0003e517          	auipc	a0,0x3e
    800038d0:	4bc50513          	addi	a0,a0,1212 # 80041d88 <bcache>
    800038d4:	ffffd097          	auipc	ra,0xffffd
    800038d8:	438080e7          	jalr	1080(ra) # 80000d0c <release>
}
    800038dc:	60e2                	ld	ra,24(sp)
    800038de:	6442                	ld	s0,16(sp)
    800038e0:	64a2                	ld	s1,8(sp)
    800038e2:	6105                	addi	sp,sp,32
    800038e4:	8082                	ret

00000000800038e6 <bunpin>:

void
bunpin(struct buf *b) {
    800038e6:	1101                	addi	sp,sp,-32
    800038e8:	ec06                	sd	ra,24(sp)
    800038ea:	e822                	sd	s0,16(sp)
    800038ec:	e426                	sd	s1,8(sp)
    800038ee:	1000                	addi	s0,sp,32
    800038f0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800038f2:	0003e517          	auipc	a0,0x3e
    800038f6:	49650513          	addi	a0,a0,1174 # 80041d88 <bcache>
    800038fa:	ffffd097          	auipc	ra,0xffffd
    800038fe:	362080e7          	jalr	866(ra) # 80000c5c <acquire>
  b->refcnt--;
    80003902:	40bc                	lw	a5,64(s1)
    80003904:	37fd                	addiw	a5,a5,-1
    80003906:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003908:	0003e517          	auipc	a0,0x3e
    8000390c:	48050513          	addi	a0,a0,1152 # 80041d88 <bcache>
    80003910:	ffffd097          	auipc	ra,0xffffd
    80003914:	3fc080e7          	jalr	1020(ra) # 80000d0c <release>
}
    80003918:	60e2                	ld	ra,24(sp)
    8000391a:	6442                	ld	s0,16(sp)
    8000391c:	64a2                	ld	s1,8(sp)
    8000391e:	6105                	addi	sp,sp,32
    80003920:	8082                	ret

0000000080003922 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003922:	1101                	addi	sp,sp,-32
    80003924:	ec06                	sd	ra,24(sp)
    80003926:	e822                	sd	s0,16(sp)
    80003928:	e426                	sd	s1,8(sp)
    8000392a:	e04a                	sd	s2,0(sp)
    8000392c:	1000                	addi	s0,sp,32
    8000392e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003930:	00d5d79b          	srliw	a5,a1,0xd
    80003934:	00047597          	auipc	a1,0x47
    80003938:	b305a583          	lw	a1,-1232(a1) # 8004a464 <sb+0x1c>
    8000393c:	9dbd                	addw	a1,a1,a5
    8000393e:	00000097          	auipc	ra,0x0
    80003942:	da4080e7          	jalr	-604(ra) # 800036e2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003946:	0074f713          	andi	a4,s1,7
    8000394a:	4785                	li	a5,1
    8000394c:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003950:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003952:	90d9                	srli	s1,s1,0x36
    80003954:	00950733          	add	a4,a0,s1
    80003958:	05874703          	lbu	a4,88(a4)
    8000395c:	00e7f6b3          	and	a3,a5,a4
    80003960:	c69d                	beqz	a3,8000398e <bfree+0x6c>
    80003962:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003964:	94aa                	add	s1,s1,a0
    80003966:	fff7c793          	not	a5,a5
    8000396a:	8f7d                	and	a4,a4,a5
    8000396c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003970:	00001097          	auipc	ra,0x1
    80003974:	14e080e7          	jalr	334(ra) # 80004abe <log_write>
  brelse(bp);
    80003978:	854a                	mv	a0,s2
    8000397a:	00000097          	auipc	ra,0x0
    8000397e:	e98080e7          	jalr	-360(ra) # 80003812 <brelse>
}
    80003982:	60e2                	ld	ra,24(sp)
    80003984:	6442                	ld	s0,16(sp)
    80003986:	64a2                	ld	s1,8(sp)
    80003988:	6902                	ld	s2,0(sp)
    8000398a:	6105                	addi	sp,sp,32
    8000398c:	8082                	ret
    panic("freeing free block");
    8000398e:	00005517          	auipc	a0,0x5
    80003992:	c3a50513          	addi	a0,a0,-966 # 800085c8 <etext+0x5c8>
    80003996:	ffffd097          	auipc	ra,0xffffd
    8000399a:	bc8080e7          	jalr	-1080(ra) # 8000055e <panic>

000000008000399e <balloc>:
{
    8000399e:	715d                	addi	sp,sp,-80
    800039a0:	e486                	sd	ra,72(sp)
    800039a2:	e0a2                	sd	s0,64(sp)
    800039a4:	fc26                	sd	s1,56(sp)
    800039a6:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800039a8:	00047797          	auipc	a5,0x47
    800039ac:	aa47a783          	lw	a5,-1372(a5) # 8004a44c <sb+0x4>
    800039b0:	10078263          	beqz	a5,80003ab4 <balloc+0x116>
    800039b4:	f84a                	sd	s2,48(sp)
    800039b6:	f44e                	sd	s3,40(sp)
    800039b8:	f052                	sd	s4,32(sp)
    800039ba:	ec56                	sd	s5,24(sp)
    800039bc:	e85a                	sd	s6,16(sp)
    800039be:	e45e                	sd	s7,8(sp)
    800039c0:	e062                	sd	s8,0(sp)
    800039c2:	8baa                	mv	s7,a0
    800039c4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800039c6:	00047b17          	auipc	s6,0x47
    800039ca:	a82b0b13          	addi	s6,s6,-1406 # 8004a448 <sb>
      m = 1 << (bi % 8);
    800039ce:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039d0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800039d2:	6c09                	lui	s8,0x2
    800039d4:	a049                	j	80003a56 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    800039d6:	97ca                	add	a5,a5,s2
    800039d8:	8e55                	or	a2,a2,a3
    800039da:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800039de:	854a                	mv	a0,s2
    800039e0:	00001097          	auipc	ra,0x1
    800039e4:	0de080e7          	jalr	222(ra) # 80004abe <log_write>
        brelse(bp);
    800039e8:	854a                	mv	a0,s2
    800039ea:	00000097          	auipc	ra,0x0
    800039ee:	e28080e7          	jalr	-472(ra) # 80003812 <brelse>
  bp = bread(dev, bno);
    800039f2:	85a6                	mv	a1,s1
    800039f4:	855e                	mv	a0,s7
    800039f6:	00000097          	auipc	ra,0x0
    800039fa:	cec080e7          	jalr	-788(ra) # 800036e2 <bread>
    800039fe:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003a00:	40000613          	li	a2,1024
    80003a04:	4581                	li	a1,0
    80003a06:	05850513          	addi	a0,a0,88
    80003a0a:	ffffd097          	auipc	ra,0xffffd
    80003a0e:	34a080e7          	jalr	842(ra) # 80000d54 <memset>
  log_write(bp);
    80003a12:	854a                	mv	a0,s2
    80003a14:	00001097          	auipc	ra,0x1
    80003a18:	0aa080e7          	jalr	170(ra) # 80004abe <log_write>
  brelse(bp);
    80003a1c:	854a                	mv	a0,s2
    80003a1e:	00000097          	auipc	ra,0x0
    80003a22:	df4080e7          	jalr	-524(ra) # 80003812 <brelse>
}
    80003a26:	7942                	ld	s2,48(sp)
    80003a28:	79a2                	ld	s3,40(sp)
    80003a2a:	7a02                	ld	s4,32(sp)
    80003a2c:	6ae2                	ld	s5,24(sp)
    80003a2e:	6b42                	ld	s6,16(sp)
    80003a30:	6ba2                	ld	s7,8(sp)
    80003a32:	6c02                	ld	s8,0(sp)
}
    80003a34:	8526                	mv	a0,s1
    80003a36:	60a6                	ld	ra,72(sp)
    80003a38:	6406                	ld	s0,64(sp)
    80003a3a:	74e2                	ld	s1,56(sp)
    80003a3c:	6161                	addi	sp,sp,80
    80003a3e:	8082                	ret
    brelse(bp);
    80003a40:	854a                	mv	a0,s2
    80003a42:	00000097          	auipc	ra,0x0
    80003a46:	dd0080e7          	jalr	-560(ra) # 80003812 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003a4a:	015c0abb          	addw	s5,s8,s5
    80003a4e:	004b2783          	lw	a5,4(s6)
    80003a52:	04fafa63          	bgeu	s5,a5,80003aa6 <balloc+0x108>
    bp = bread(dev, BBLOCK(b, sb));
    80003a56:	40dad59b          	sraiw	a1,s5,0xd
    80003a5a:	01cb2783          	lw	a5,28(s6)
    80003a5e:	9dbd                	addw	a1,a1,a5
    80003a60:	855e                	mv	a0,s7
    80003a62:	00000097          	auipc	ra,0x0
    80003a66:	c80080e7          	jalr	-896(ra) # 800036e2 <bread>
    80003a6a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a6c:	004b2503          	lw	a0,4(s6)
    80003a70:	84d6                	mv	s1,s5
    80003a72:	4701                	li	a4,0
    80003a74:	fca4f6e3          	bgeu	s1,a0,80003a40 <balloc+0xa2>
      m = 1 << (bi % 8);
    80003a78:	00777693          	andi	a3,a4,7
    80003a7c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003a80:	41f7579b          	sraiw	a5,a4,0x1f
    80003a84:	01d7d79b          	srliw	a5,a5,0x1d
    80003a88:	9fb9                	addw	a5,a5,a4
    80003a8a:	4037d79b          	sraiw	a5,a5,0x3
    80003a8e:	00f90633          	add	a2,s2,a5
    80003a92:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80003a96:	00c6f5b3          	and	a1,a3,a2
    80003a9a:	dd95                	beqz	a1,800039d6 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a9c:	2705                	addiw	a4,a4,1
    80003a9e:	2485                	addiw	s1,s1,1
    80003aa0:	fd471ae3          	bne	a4,s4,80003a74 <balloc+0xd6>
    80003aa4:	bf71                	j	80003a40 <balloc+0xa2>
    80003aa6:	7942                	ld	s2,48(sp)
    80003aa8:	79a2                	ld	s3,40(sp)
    80003aaa:	7a02                	ld	s4,32(sp)
    80003aac:	6ae2                	ld	s5,24(sp)
    80003aae:	6b42                	ld	s6,16(sp)
    80003ab0:	6ba2                	ld	s7,8(sp)
    80003ab2:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003ab4:	00005517          	auipc	a0,0x5
    80003ab8:	b2c50513          	addi	a0,a0,-1236 # 800085e0 <etext+0x5e0>
    80003abc:	ffffd097          	auipc	ra,0xffffd
    80003ac0:	aec080e7          	jalr	-1300(ra) # 800005a8 <printf>
  return 0;
    80003ac4:	4481                	li	s1,0
    80003ac6:	b7bd                	j	80003a34 <balloc+0x96>

0000000080003ac8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003ac8:	7179                	addi	sp,sp,-48
    80003aca:	f406                	sd	ra,40(sp)
    80003acc:	f022                	sd	s0,32(sp)
    80003ace:	ec26                	sd	s1,24(sp)
    80003ad0:	e84a                	sd	s2,16(sp)
    80003ad2:	e44e                	sd	s3,8(sp)
    80003ad4:	1800                	addi	s0,sp,48
    80003ad6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003ad8:	47ad                	li	a5,11
    80003ada:	02b7e563          	bltu	a5,a1,80003b04 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003ade:	02059793          	slli	a5,a1,0x20
    80003ae2:	01e7d593          	srli	a1,a5,0x1e
    80003ae6:	00b509b3          	add	s3,a0,a1
    80003aea:	0509a483          	lw	s1,80(s3)
    80003aee:	e8b5                	bnez	s1,80003b62 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003af0:	4108                	lw	a0,0(a0)
    80003af2:	00000097          	auipc	ra,0x0
    80003af6:	eac080e7          	jalr	-340(ra) # 8000399e <balloc>
    80003afa:	84aa                	mv	s1,a0
      if(addr == 0)
    80003afc:	c13d                	beqz	a0,80003b62 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003afe:	04a9a823          	sw	a0,80(s3)
    80003b02:	a085                	j	80003b62 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003b04:	ff45879b          	addiw	a5,a1,-12
    80003b08:	873e                	mv	a4,a5
    80003b0a:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80003b0c:	0ff00793          	li	a5,255
    80003b10:	08e7e163          	bltu	a5,a4,80003b92 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003b14:	08052483          	lw	s1,128(a0)
    80003b18:	ec81                	bnez	s1,80003b30 <bmap+0x68>
      addr = balloc(ip->dev);
    80003b1a:	4108                	lw	a0,0(a0)
    80003b1c:	00000097          	auipc	ra,0x0
    80003b20:	e82080e7          	jalr	-382(ra) # 8000399e <balloc>
    80003b24:	84aa                	mv	s1,a0
      if(addr == 0)
    80003b26:	cd15                	beqz	a0,80003b62 <bmap+0x9a>
    80003b28:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003b2a:	08a92023          	sw	a0,128(s2)
    80003b2e:	a011                	j	80003b32 <bmap+0x6a>
    80003b30:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003b32:	85a6                	mv	a1,s1
    80003b34:	00092503          	lw	a0,0(s2)
    80003b38:	00000097          	auipc	ra,0x0
    80003b3c:	baa080e7          	jalr	-1110(ra) # 800036e2 <bread>
    80003b40:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003b42:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003b46:	02099713          	slli	a4,s3,0x20
    80003b4a:	01e75593          	srli	a1,a4,0x1e
    80003b4e:	97ae                	add	a5,a5,a1
    80003b50:	89be                	mv	s3,a5
    80003b52:	4384                	lw	s1,0(a5)
    80003b54:	cc99                	beqz	s1,80003b72 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003b56:	8552                	mv	a0,s4
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	cba080e7          	jalr	-838(ra) # 80003812 <brelse>
    return addr;
    80003b60:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003b62:	8526                	mv	a0,s1
    80003b64:	70a2                	ld	ra,40(sp)
    80003b66:	7402                	ld	s0,32(sp)
    80003b68:	64e2                	ld	s1,24(sp)
    80003b6a:	6942                	ld	s2,16(sp)
    80003b6c:	69a2                	ld	s3,8(sp)
    80003b6e:	6145                	addi	sp,sp,48
    80003b70:	8082                	ret
      addr = balloc(ip->dev);
    80003b72:	00092503          	lw	a0,0(s2)
    80003b76:	00000097          	auipc	ra,0x0
    80003b7a:	e28080e7          	jalr	-472(ra) # 8000399e <balloc>
    80003b7e:	84aa                	mv	s1,a0
      if(addr){
    80003b80:	d979                	beqz	a0,80003b56 <bmap+0x8e>
        a[bn] = addr;
    80003b82:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003b86:	8552                	mv	a0,s4
    80003b88:	00001097          	auipc	ra,0x1
    80003b8c:	f36080e7          	jalr	-202(ra) # 80004abe <log_write>
    80003b90:	b7d9                	j	80003b56 <bmap+0x8e>
    80003b92:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003b94:	00005517          	auipc	a0,0x5
    80003b98:	a6450513          	addi	a0,a0,-1436 # 800085f8 <etext+0x5f8>
    80003b9c:	ffffd097          	auipc	ra,0xffffd
    80003ba0:	9c2080e7          	jalr	-1598(ra) # 8000055e <panic>

0000000080003ba4 <iget>:
{
    80003ba4:	7179                	addi	sp,sp,-48
    80003ba6:	f406                	sd	ra,40(sp)
    80003ba8:	f022                	sd	s0,32(sp)
    80003baa:	ec26                	sd	s1,24(sp)
    80003bac:	e84a                	sd	s2,16(sp)
    80003bae:	e44e                	sd	s3,8(sp)
    80003bb0:	e052                	sd	s4,0(sp)
    80003bb2:	1800                	addi	s0,sp,48
    80003bb4:	892a                	mv	s2,a0
    80003bb6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003bb8:	00047517          	auipc	a0,0x47
    80003bbc:	8b050513          	addi	a0,a0,-1872 # 8004a468 <itable>
    80003bc0:	ffffd097          	auipc	ra,0xffffd
    80003bc4:	09c080e7          	jalr	156(ra) # 80000c5c <acquire>
  empty = 0;
    80003bc8:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003bca:	00047497          	auipc	s1,0x47
    80003bce:	8b648493          	addi	s1,s1,-1866 # 8004a480 <itable+0x18>
    80003bd2:	00048697          	auipc	a3,0x48
    80003bd6:	33e68693          	addi	a3,a3,830 # 8004bf10 <log>
    80003bda:	a809                	j	80003bec <iget+0x48>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003bdc:	e781                	bnez	a5,80003be4 <iget+0x40>
    80003bde:	00099363          	bnez	s3,80003be4 <iget+0x40>
      empty = ip;
    80003be2:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003be4:	08848493          	addi	s1,s1,136
    80003be8:	02d48763          	beq	s1,a3,80003c16 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003bec:	449c                	lw	a5,8(s1)
    80003bee:	fef057e3          	blez	a5,80003bdc <iget+0x38>
    80003bf2:	4098                	lw	a4,0(s1)
    80003bf4:	ff2718e3          	bne	a4,s2,80003be4 <iget+0x40>
    80003bf8:	40d8                	lw	a4,4(s1)
    80003bfa:	ff4715e3          	bne	a4,s4,80003be4 <iget+0x40>
      ip->ref++;
    80003bfe:	2785                	addiw	a5,a5,1
    80003c00:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003c02:	00047517          	auipc	a0,0x47
    80003c06:	86650513          	addi	a0,a0,-1946 # 8004a468 <itable>
    80003c0a:	ffffd097          	auipc	ra,0xffffd
    80003c0e:	102080e7          	jalr	258(ra) # 80000d0c <release>
      return ip;
    80003c12:	89a6                	mv	s3,s1
    80003c14:	a025                	j	80003c3c <iget+0x98>
  if(empty == 0)
    80003c16:	02098c63          	beqz	s3,80003c4e <iget+0xaa>
  ip->dev = dev;
    80003c1a:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003c1e:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003c22:	4785                	li	a5,1
    80003c24:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003c28:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003c2c:	00047517          	auipc	a0,0x47
    80003c30:	83c50513          	addi	a0,a0,-1988 # 8004a468 <itable>
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	0d8080e7          	jalr	216(ra) # 80000d0c <release>
}
    80003c3c:	854e                	mv	a0,s3
    80003c3e:	70a2                	ld	ra,40(sp)
    80003c40:	7402                	ld	s0,32(sp)
    80003c42:	64e2                	ld	s1,24(sp)
    80003c44:	6942                	ld	s2,16(sp)
    80003c46:	69a2                	ld	s3,8(sp)
    80003c48:	6a02                	ld	s4,0(sp)
    80003c4a:	6145                	addi	sp,sp,48
    80003c4c:	8082                	ret
    panic("iget: no inodes");
    80003c4e:	00005517          	auipc	a0,0x5
    80003c52:	9c250513          	addi	a0,a0,-1598 # 80008610 <etext+0x610>
    80003c56:	ffffd097          	auipc	ra,0xffffd
    80003c5a:	908080e7          	jalr	-1784(ra) # 8000055e <panic>

0000000080003c5e <fsinit>:
fsinit(int dev) {
    80003c5e:	1101                	addi	sp,sp,-32
    80003c60:	ec06                	sd	ra,24(sp)
    80003c62:	e822                	sd	s0,16(sp)
    80003c64:	e426                	sd	s1,8(sp)
    80003c66:	e04a                	sd	s2,0(sp)
    80003c68:	1000                	addi	s0,sp,32
    80003c6a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003c6c:	4585                	li	a1,1
    80003c6e:	00000097          	auipc	ra,0x0
    80003c72:	a74080e7          	jalr	-1420(ra) # 800036e2 <bread>
    80003c76:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003c78:	02000613          	li	a2,32
    80003c7c:	05850593          	addi	a1,a0,88
    80003c80:	00046517          	auipc	a0,0x46
    80003c84:	7c850513          	addi	a0,a0,1992 # 8004a448 <sb>
    80003c88:	ffffd097          	auipc	ra,0xffffd
    80003c8c:	12c080e7          	jalr	300(ra) # 80000db4 <memmove>
  brelse(bp);
    80003c90:	8526                	mv	a0,s1
    80003c92:	00000097          	auipc	ra,0x0
    80003c96:	b80080e7          	jalr	-1152(ra) # 80003812 <brelse>
  if(sb.magic != FSMAGIC)
    80003c9a:	00046717          	auipc	a4,0x46
    80003c9e:	7ae72703          	lw	a4,1966(a4) # 8004a448 <sb>
    80003ca2:	102037b7          	lui	a5,0x10203
    80003ca6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003caa:	02f71163          	bne	a4,a5,80003ccc <fsinit+0x6e>
  initlog(dev, &sb);
    80003cae:	00046597          	auipc	a1,0x46
    80003cb2:	79a58593          	addi	a1,a1,1946 # 8004a448 <sb>
    80003cb6:	854a                	mv	a0,s2
    80003cb8:	00001097          	auipc	ra,0x1
    80003cbc:	b80080e7          	jalr	-1152(ra) # 80004838 <initlog>
}
    80003cc0:	60e2                	ld	ra,24(sp)
    80003cc2:	6442                	ld	s0,16(sp)
    80003cc4:	64a2                	ld	s1,8(sp)
    80003cc6:	6902                	ld	s2,0(sp)
    80003cc8:	6105                	addi	sp,sp,32
    80003cca:	8082                	ret
    panic("invalid file system");
    80003ccc:	00005517          	auipc	a0,0x5
    80003cd0:	95450513          	addi	a0,a0,-1708 # 80008620 <etext+0x620>
    80003cd4:	ffffd097          	auipc	ra,0xffffd
    80003cd8:	88a080e7          	jalr	-1910(ra) # 8000055e <panic>

0000000080003cdc <iinit>:
{
    80003cdc:	7179                	addi	sp,sp,-48
    80003cde:	f406                	sd	ra,40(sp)
    80003ce0:	f022                	sd	s0,32(sp)
    80003ce2:	ec26                	sd	s1,24(sp)
    80003ce4:	e84a                	sd	s2,16(sp)
    80003ce6:	e44e                	sd	s3,8(sp)
    80003ce8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003cea:	00005597          	auipc	a1,0x5
    80003cee:	94e58593          	addi	a1,a1,-1714 # 80008638 <etext+0x638>
    80003cf2:	00046517          	auipc	a0,0x46
    80003cf6:	77650513          	addi	a0,a0,1910 # 8004a468 <itable>
    80003cfa:	ffffd097          	auipc	ra,0xffffd
    80003cfe:	ec8080e7          	jalr	-312(ra) # 80000bc2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003d02:	00046497          	auipc	s1,0x46
    80003d06:	78e48493          	addi	s1,s1,1934 # 8004a490 <itable+0x28>
    80003d0a:	00048997          	auipc	s3,0x48
    80003d0e:	21698993          	addi	s3,s3,534 # 8004bf20 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003d12:	00005917          	auipc	s2,0x5
    80003d16:	92e90913          	addi	s2,s2,-1746 # 80008640 <etext+0x640>
    80003d1a:	85ca                	mv	a1,s2
    80003d1c:	8526                	mv	a0,s1
    80003d1e:	00001097          	auipc	ra,0x1
    80003d22:	e86080e7          	jalr	-378(ra) # 80004ba4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003d26:	08848493          	addi	s1,s1,136
    80003d2a:	ff3498e3          	bne	s1,s3,80003d1a <iinit+0x3e>
}
    80003d2e:	70a2                	ld	ra,40(sp)
    80003d30:	7402                	ld	s0,32(sp)
    80003d32:	64e2                	ld	s1,24(sp)
    80003d34:	6942                	ld	s2,16(sp)
    80003d36:	69a2                	ld	s3,8(sp)
    80003d38:	6145                	addi	sp,sp,48
    80003d3a:	8082                	ret

0000000080003d3c <ialloc>:
{
    80003d3c:	7139                	addi	sp,sp,-64
    80003d3e:	fc06                	sd	ra,56(sp)
    80003d40:	f822                	sd	s0,48(sp)
    80003d42:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003d44:	00046717          	auipc	a4,0x46
    80003d48:	71072703          	lw	a4,1808(a4) # 8004a454 <sb+0xc>
    80003d4c:	4785                	li	a5,1
    80003d4e:	06e7f463          	bgeu	a5,a4,80003db6 <ialloc+0x7a>
    80003d52:	f426                	sd	s1,40(sp)
    80003d54:	f04a                	sd	s2,32(sp)
    80003d56:	ec4e                	sd	s3,24(sp)
    80003d58:	e852                	sd	s4,16(sp)
    80003d5a:	e456                	sd	s5,8(sp)
    80003d5c:	e05a                	sd	s6,0(sp)
    80003d5e:	8aaa                	mv	s5,a0
    80003d60:	8b2e                	mv	s6,a1
    80003d62:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003d64:	00046a17          	auipc	s4,0x46
    80003d68:	6e4a0a13          	addi	s4,s4,1764 # 8004a448 <sb>
    80003d6c:	00495593          	srli	a1,s2,0x4
    80003d70:	018a2783          	lw	a5,24(s4)
    80003d74:	9dbd                	addw	a1,a1,a5
    80003d76:	8556                	mv	a0,s5
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	96a080e7          	jalr	-1686(ra) # 800036e2 <bread>
    80003d80:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003d82:	05850993          	addi	s3,a0,88
    80003d86:	00f97793          	andi	a5,s2,15
    80003d8a:	079a                	slli	a5,a5,0x6
    80003d8c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003d8e:	00099783          	lh	a5,0(s3)
    80003d92:	cf9d                	beqz	a5,80003dd0 <ialloc+0x94>
    brelse(bp);
    80003d94:	00000097          	auipc	ra,0x0
    80003d98:	a7e080e7          	jalr	-1410(ra) # 80003812 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003d9c:	0905                	addi	s2,s2,1
    80003d9e:	00ca2703          	lw	a4,12(s4)
    80003da2:	0009079b          	sext.w	a5,s2
    80003da6:	fce7e3e3          	bltu	a5,a4,80003d6c <ialloc+0x30>
    80003daa:	74a2                	ld	s1,40(sp)
    80003dac:	7902                	ld	s2,32(sp)
    80003dae:	69e2                	ld	s3,24(sp)
    80003db0:	6a42                	ld	s4,16(sp)
    80003db2:	6aa2                	ld	s5,8(sp)
    80003db4:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003db6:	00005517          	auipc	a0,0x5
    80003dba:	89250513          	addi	a0,a0,-1902 # 80008648 <etext+0x648>
    80003dbe:	ffffc097          	auipc	ra,0xffffc
    80003dc2:	7ea080e7          	jalr	2026(ra) # 800005a8 <printf>
  return 0;
    80003dc6:	4501                	li	a0,0
}
    80003dc8:	70e2                	ld	ra,56(sp)
    80003dca:	7442                	ld	s0,48(sp)
    80003dcc:	6121                	addi	sp,sp,64
    80003dce:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003dd0:	04000613          	li	a2,64
    80003dd4:	4581                	li	a1,0
    80003dd6:	854e                	mv	a0,s3
    80003dd8:	ffffd097          	auipc	ra,0xffffd
    80003ddc:	f7c080e7          	jalr	-132(ra) # 80000d54 <memset>
      dip->type = type;
    80003de0:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003de4:	8526                	mv	a0,s1
    80003de6:	00001097          	auipc	ra,0x1
    80003dea:	cd8080e7          	jalr	-808(ra) # 80004abe <log_write>
      brelse(bp);
    80003dee:	8526                	mv	a0,s1
    80003df0:	00000097          	auipc	ra,0x0
    80003df4:	a22080e7          	jalr	-1502(ra) # 80003812 <brelse>
      return iget(dev, inum);
    80003df8:	0009059b          	sext.w	a1,s2
    80003dfc:	8556                	mv	a0,s5
    80003dfe:	00000097          	auipc	ra,0x0
    80003e02:	da6080e7          	jalr	-602(ra) # 80003ba4 <iget>
    80003e06:	74a2                	ld	s1,40(sp)
    80003e08:	7902                	ld	s2,32(sp)
    80003e0a:	69e2                	ld	s3,24(sp)
    80003e0c:	6a42                	ld	s4,16(sp)
    80003e0e:	6aa2                	ld	s5,8(sp)
    80003e10:	6b02                	ld	s6,0(sp)
    80003e12:	bf5d                	j	80003dc8 <ialloc+0x8c>

0000000080003e14 <iupdate>:
{
    80003e14:	1101                	addi	sp,sp,-32
    80003e16:	ec06                	sd	ra,24(sp)
    80003e18:	e822                	sd	s0,16(sp)
    80003e1a:	e426                	sd	s1,8(sp)
    80003e1c:	e04a                	sd	s2,0(sp)
    80003e1e:	1000                	addi	s0,sp,32
    80003e20:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003e22:	415c                	lw	a5,4(a0)
    80003e24:	0047d79b          	srliw	a5,a5,0x4
    80003e28:	00046597          	auipc	a1,0x46
    80003e2c:	6385a583          	lw	a1,1592(a1) # 8004a460 <sb+0x18>
    80003e30:	9dbd                	addw	a1,a1,a5
    80003e32:	4108                	lw	a0,0(a0)
    80003e34:	00000097          	auipc	ra,0x0
    80003e38:	8ae080e7          	jalr	-1874(ra) # 800036e2 <bread>
    80003e3c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003e3e:	05850793          	addi	a5,a0,88
    80003e42:	40d8                	lw	a4,4(s1)
    80003e44:	8b3d                	andi	a4,a4,15
    80003e46:	071a                	slli	a4,a4,0x6
    80003e48:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003e4a:	04449703          	lh	a4,68(s1)
    80003e4e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003e52:	04649703          	lh	a4,70(s1)
    80003e56:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003e5a:	04849703          	lh	a4,72(s1)
    80003e5e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003e62:	04a49703          	lh	a4,74(s1)
    80003e66:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003e6a:	44f8                	lw	a4,76(s1)
    80003e6c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003e6e:	03400613          	li	a2,52
    80003e72:	05048593          	addi	a1,s1,80
    80003e76:	00c78513          	addi	a0,a5,12
    80003e7a:	ffffd097          	auipc	ra,0xffffd
    80003e7e:	f3a080e7          	jalr	-198(ra) # 80000db4 <memmove>
  log_write(bp);
    80003e82:	854a                	mv	a0,s2
    80003e84:	00001097          	auipc	ra,0x1
    80003e88:	c3a080e7          	jalr	-966(ra) # 80004abe <log_write>
  brelse(bp);
    80003e8c:	854a                	mv	a0,s2
    80003e8e:	00000097          	auipc	ra,0x0
    80003e92:	984080e7          	jalr	-1660(ra) # 80003812 <brelse>
}
    80003e96:	60e2                	ld	ra,24(sp)
    80003e98:	6442                	ld	s0,16(sp)
    80003e9a:	64a2                	ld	s1,8(sp)
    80003e9c:	6902                	ld	s2,0(sp)
    80003e9e:	6105                	addi	sp,sp,32
    80003ea0:	8082                	ret

0000000080003ea2 <idup>:
{
    80003ea2:	1101                	addi	sp,sp,-32
    80003ea4:	ec06                	sd	ra,24(sp)
    80003ea6:	e822                	sd	s0,16(sp)
    80003ea8:	e426                	sd	s1,8(sp)
    80003eaa:	1000                	addi	s0,sp,32
    80003eac:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003eae:	00046517          	auipc	a0,0x46
    80003eb2:	5ba50513          	addi	a0,a0,1466 # 8004a468 <itable>
    80003eb6:	ffffd097          	auipc	ra,0xffffd
    80003eba:	da6080e7          	jalr	-602(ra) # 80000c5c <acquire>
  ip->ref++;
    80003ebe:	449c                	lw	a5,8(s1)
    80003ec0:	2785                	addiw	a5,a5,1
    80003ec2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ec4:	00046517          	auipc	a0,0x46
    80003ec8:	5a450513          	addi	a0,a0,1444 # 8004a468 <itable>
    80003ecc:	ffffd097          	auipc	ra,0xffffd
    80003ed0:	e40080e7          	jalr	-448(ra) # 80000d0c <release>
}
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	60e2                	ld	ra,24(sp)
    80003ed8:	6442                	ld	s0,16(sp)
    80003eda:	64a2                	ld	s1,8(sp)
    80003edc:	6105                	addi	sp,sp,32
    80003ede:	8082                	ret

0000000080003ee0 <ilock>:
{
    80003ee0:	1101                	addi	sp,sp,-32
    80003ee2:	ec06                	sd	ra,24(sp)
    80003ee4:	e822                	sd	s0,16(sp)
    80003ee6:	e426                	sd	s1,8(sp)
    80003ee8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003eea:	c10d                	beqz	a0,80003f0c <ilock+0x2c>
    80003eec:	84aa                	mv	s1,a0
    80003eee:	451c                	lw	a5,8(a0)
    80003ef0:	00f05e63          	blez	a5,80003f0c <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003ef4:	0541                	addi	a0,a0,16
    80003ef6:	00001097          	auipc	ra,0x1
    80003efa:	ce8080e7          	jalr	-792(ra) # 80004bde <acquiresleep>
  if(ip->valid == 0){
    80003efe:	40bc                	lw	a5,64(s1)
    80003f00:	cf99                	beqz	a5,80003f1e <ilock+0x3e>
}
    80003f02:	60e2                	ld	ra,24(sp)
    80003f04:	6442                	ld	s0,16(sp)
    80003f06:	64a2                	ld	s1,8(sp)
    80003f08:	6105                	addi	sp,sp,32
    80003f0a:	8082                	ret
    80003f0c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003f0e:	00004517          	auipc	a0,0x4
    80003f12:	75250513          	addi	a0,a0,1874 # 80008660 <etext+0x660>
    80003f16:	ffffc097          	auipc	ra,0xffffc
    80003f1a:	648080e7          	jalr	1608(ra) # 8000055e <panic>
    80003f1e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003f20:	40dc                	lw	a5,4(s1)
    80003f22:	0047d79b          	srliw	a5,a5,0x4
    80003f26:	00046597          	auipc	a1,0x46
    80003f2a:	53a5a583          	lw	a1,1338(a1) # 8004a460 <sb+0x18>
    80003f2e:	9dbd                	addw	a1,a1,a5
    80003f30:	4088                	lw	a0,0(s1)
    80003f32:	fffff097          	auipc	ra,0xfffff
    80003f36:	7b0080e7          	jalr	1968(ra) # 800036e2 <bread>
    80003f3a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003f3c:	05850593          	addi	a1,a0,88
    80003f40:	40dc                	lw	a5,4(s1)
    80003f42:	8bbd                	andi	a5,a5,15
    80003f44:	079a                	slli	a5,a5,0x6
    80003f46:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003f48:	00059783          	lh	a5,0(a1)
    80003f4c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003f50:	00259783          	lh	a5,2(a1)
    80003f54:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003f58:	00459783          	lh	a5,4(a1)
    80003f5c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003f60:	00659783          	lh	a5,6(a1)
    80003f64:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003f68:	459c                	lw	a5,8(a1)
    80003f6a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003f6c:	03400613          	li	a2,52
    80003f70:	05b1                	addi	a1,a1,12
    80003f72:	05048513          	addi	a0,s1,80
    80003f76:	ffffd097          	auipc	ra,0xffffd
    80003f7a:	e3e080e7          	jalr	-450(ra) # 80000db4 <memmove>
    brelse(bp);
    80003f7e:	854a                	mv	a0,s2
    80003f80:	00000097          	auipc	ra,0x0
    80003f84:	892080e7          	jalr	-1902(ra) # 80003812 <brelse>
    ip->valid = 1;
    80003f88:	4785                	li	a5,1
    80003f8a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003f8c:	04449783          	lh	a5,68(s1)
    80003f90:	c399                	beqz	a5,80003f96 <ilock+0xb6>
    80003f92:	6902                	ld	s2,0(sp)
    80003f94:	b7bd                	j	80003f02 <ilock+0x22>
      panic("ilock: no type");
    80003f96:	00004517          	auipc	a0,0x4
    80003f9a:	6d250513          	addi	a0,a0,1746 # 80008668 <etext+0x668>
    80003f9e:	ffffc097          	auipc	ra,0xffffc
    80003fa2:	5c0080e7          	jalr	1472(ra) # 8000055e <panic>

0000000080003fa6 <iunlock>:
{
    80003fa6:	1101                	addi	sp,sp,-32
    80003fa8:	ec06                	sd	ra,24(sp)
    80003faa:	e822                	sd	s0,16(sp)
    80003fac:	e426                	sd	s1,8(sp)
    80003fae:	e04a                	sd	s2,0(sp)
    80003fb0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003fb2:	c905                	beqz	a0,80003fe2 <iunlock+0x3c>
    80003fb4:	84aa                	mv	s1,a0
    80003fb6:	01050913          	addi	s2,a0,16
    80003fba:	854a                	mv	a0,s2
    80003fbc:	00001097          	auipc	ra,0x1
    80003fc0:	cbc080e7          	jalr	-836(ra) # 80004c78 <holdingsleep>
    80003fc4:	cd19                	beqz	a0,80003fe2 <iunlock+0x3c>
    80003fc6:	449c                	lw	a5,8(s1)
    80003fc8:	00f05d63          	blez	a5,80003fe2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003fcc:	854a                	mv	a0,s2
    80003fce:	00001097          	auipc	ra,0x1
    80003fd2:	c66080e7          	jalr	-922(ra) # 80004c34 <releasesleep>
}
    80003fd6:	60e2                	ld	ra,24(sp)
    80003fd8:	6442                	ld	s0,16(sp)
    80003fda:	64a2                	ld	s1,8(sp)
    80003fdc:	6902                	ld	s2,0(sp)
    80003fde:	6105                	addi	sp,sp,32
    80003fe0:	8082                	ret
    panic("iunlock");
    80003fe2:	00004517          	auipc	a0,0x4
    80003fe6:	69650513          	addi	a0,a0,1686 # 80008678 <etext+0x678>
    80003fea:	ffffc097          	auipc	ra,0xffffc
    80003fee:	574080e7          	jalr	1396(ra) # 8000055e <panic>

0000000080003ff2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003ff2:	7179                	addi	sp,sp,-48
    80003ff4:	f406                	sd	ra,40(sp)
    80003ff6:	f022                	sd	s0,32(sp)
    80003ff8:	ec26                	sd	s1,24(sp)
    80003ffa:	e84a                	sd	s2,16(sp)
    80003ffc:	e44e                	sd	s3,8(sp)
    80003ffe:	1800                	addi	s0,sp,48
    80004000:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004002:	05050493          	addi	s1,a0,80
    80004006:	08050913          	addi	s2,a0,128
    8000400a:	a021                	j	80004012 <itrunc+0x20>
    8000400c:	0491                	addi	s1,s1,4
    8000400e:	01248d63          	beq	s1,s2,80004028 <itrunc+0x36>
    if(ip->addrs[i]){
    80004012:	408c                	lw	a1,0(s1)
    80004014:	dde5                	beqz	a1,8000400c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80004016:	0009a503          	lw	a0,0(s3)
    8000401a:	00000097          	auipc	ra,0x0
    8000401e:	908080e7          	jalr	-1784(ra) # 80003922 <bfree>
      ip->addrs[i] = 0;
    80004022:	0004a023          	sw	zero,0(s1)
    80004026:	b7dd                	j	8000400c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004028:	0809a583          	lw	a1,128(s3)
    8000402c:	ed99                	bnez	a1,8000404a <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000402e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004032:	854e                	mv	a0,s3
    80004034:	00000097          	auipc	ra,0x0
    80004038:	de0080e7          	jalr	-544(ra) # 80003e14 <iupdate>
}
    8000403c:	70a2                	ld	ra,40(sp)
    8000403e:	7402                	ld	s0,32(sp)
    80004040:	64e2                	ld	s1,24(sp)
    80004042:	6942                	ld	s2,16(sp)
    80004044:	69a2                	ld	s3,8(sp)
    80004046:	6145                	addi	sp,sp,48
    80004048:	8082                	ret
    8000404a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000404c:	0009a503          	lw	a0,0(s3)
    80004050:	fffff097          	auipc	ra,0xfffff
    80004054:	692080e7          	jalr	1682(ra) # 800036e2 <bread>
    80004058:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000405a:	05850493          	addi	s1,a0,88
    8000405e:	45850913          	addi	s2,a0,1112
    80004062:	a021                	j	8000406a <itrunc+0x78>
    80004064:	0491                	addi	s1,s1,4
    80004066:	01248b63          	beq	s1,s2,8000407c <itrunc+0x8a>
      if(a[j])
    8000406a:	408c                	lw	a1,0(s1)
    8000406c:	dde5                	beqz	a1,80004064 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    8000406e:	0009a503          	lw	a0,0(s3)
    80004072:	00000097          	auipc	ra,0x0
    80004076:	8b0080e7          	jalr	-1872(ra) # 80003922 <bfree>
    8000407a:	b7ed                	j	80004064 <itrunc+0x72>
    brelse(bp);
    8000407c:	8552                	mv	a0,s4
    8000407e:	fffff097          	auipc	ra,0xfffff
    80004082:	794080e7          	jalr	1940(ra) # 80003812 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004086:	0809a583          	lw	a1,128(s3)
    8000408a:	0009a503          	lw	a0,0(s3)
    8000408e:	00000097          	auipc	ra,0x0
    80004092:	894080e7          	jalr	-1900(ra) # 80003922 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004096:	0809a023          	sw	zero,128(s3)
    8000409a:	6a02                	ld	s4,0(sp)
    8000409c:	bf49                	j	8000402e <itrunc+0x3c>

000000008000409e <iput>:
{
    8000409e:	1101                	addi	sp,sp,-32
    800040a0:	ec06                	sd	ra,24(sp)
    800040a2:	e822                	sd	s0,16(sp)
    800040a4:	e426                	sd	s1,8(sp)
    800040a6:	1000                	addi	s0,sp,32
    800040a8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800040aa:	00046517          	auipc	a0,0x46
    800040ae:	3be50513          	addi	a0,a0,958 # 8004a468 <itable>
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	baa080e7          	jalr	-1110(ra) # 80000c5c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800040ba:	4498                	lw	a4,8(s1)
    800040bc:	4785                	li	a5,1
    800040be:	02f70263          	beq	a4,a5,800040e2 <iput+0x44>
  ip->ref--;
    800040c2:	449c                	lw	a5,8(s1)
    800040c4:	37fd                	addiw	a5,a5,-1
    800040c6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800040c8:	00046517          	auipc	a0,0x46
    800040cc:	3a050513          	addi	a0,a0,928 # 8004a468 <itable>
    800040d0:	ffffd097          	auipc	ra,0xffffd
    800040d4:	c3c080e7          	jalr	-964(ra) # 80000d0c <release>
}
    800040d8:	60e2                	ld	ra,24(sp)
    800040da:	6442                	ld	s0,16(sp)
    800040dc:	64a2                	ld	s1,8(sp)
    800040de:	6105                	addi	sp,sp,32
    800040e0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800040e2:	40bc                	lw	a5,64(s1)
    800040e4:	dff9                	beqz	a5,800040c2 <iput+0x24>
    800040e6:	04a49783          	lh	a5,74(s1)
    800040ea:	ffe1                	bnez	a5,800040c2 <iput+0x24>
    800040ec:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800040ee:	01048793          	addi	a5,s1,16
    800040f2:	893e                	mv	s2,a5
    800040f4:	853e                	mv	a0,a5
    800040f6:	00001097          	auipc	ra,0x1
    800040fa:	ae8080e7          	jalr	-1304(ra) # 80004bde <acquiresleep>
    release(&itable.lock);
    800040fe:	00046517          	auipc	a0,0x46
    80004102:	36a50513          	addi	a0,a0,874 # 8004a468 <itable>
    80004106:	ffffd097          	auipc	ra,0xffffd
    8000410a:	c06080e7          	jalr	-1018(ra) # 80000d0c <release>
    itrunc(ip);
    8000410e:	8526                	mv	a0,s1
    80004110:	00000097          	auipc	ra,0x0
    80004114:	ee2080e7          	jalr	-286(ra) # 80003ff2 <itrunc>
    ip->type = 0;
    80004118:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000411c:	8526                	mv	a0,s1
    8000411e:	00000097          	auipc	ra,0x0
    80004122:	cf6080e7          	jalr	-778(ra) # 80003e14 <iupdate>
    ip->valid = 0;
    80004126:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000412a:	854a                	mv	a0,s2
    8000412c:	00001097          	auipc	ra,0x1
    80004130:	b08080e7          	jalr	-1272(ra) # 80004c34 <releasesleep>
    acquire(&itable.lock);
    80004134:	00046517          	auipc	a0,0x46
    80004138:	33450513          	addi	a0,a0,820 # 8004a468 <itable>
    8000413c:	ffffd097          	auipc	ra,0xffffd
    80004140:	b20080e7          	jalr	-1248(ra) # 80000c5c <acquire>
    80004144:	6902                	ld	s2,0(sp)
    80004146:	bfb5                	j	800040c2 <iput+0x24>

0000000080004148 <iunlockput>:
{
    80004148:	1101                	addi	sp,sp,-32
    8000414a:	ec06                	sd	ra,24(sp)
    8000414c:	e822                	sd	s0,16(sp)
    8000414e:	e426                	sd	s1,8(sp)
    80004150:	1000                	addi	s0,sp,32
    80004152:	84aa                	mv	s1,a0
  iunlock(ip);
    80004154:	00000097          	auipc	ra,0x0
    80004158:	e52080e7          	jalr	-430(ra) # 80003fa6 <iunlock>
  iput(ip);
    8000415c:	8526                	mv	a0,s1
    8000415e:	00000097          	auipc	ra,0x0
    80004162:	f40080e7          	jalr	-192(ra) # 8000409e <iput>
}
    80004166:	60e2                	ld	ra,24(sp)
    80004168:	6442                	ld	s0,16(sp)
    8000416a:	64a2                	ld	s1,8(sp)
    8000416c:	6105                	addi	sp,sp,32
    8000416e:	8082                	ret

0000000080004170 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004170:	1141                	addi	sp,sp,-16
    80004172:	e406                	sd	ra,8(sp)
    80004174:	e022                	sd	s0,0(sp)
    80004176:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004178:	411c                	lw	a5,0(a0)
    8000417a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000417c:	415c                	lw	a5,4(a0)
    8000417e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004180:	04451783          	lh	a5,68(a0)
    80004184:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004188:	04a51783          	lh	a5,74(a0)
    8000418c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004190:	04c56783          	lwu	a5,76(a0)
    80004194:	e99c                	sd	a5,16(a1)
}
    80004196:	60a2                	ld	ra,8(sp)
    80004198:	6402                	ld	s0,0(sp)
    8000419a:	0141                	addi	sp,sp,16
    8000419c:	8082                	ret

000000008000419e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000419e:	457c                	lw	a5,76(a0)
    800041a0:	10d7e063          	bltu	a5,a3,800042a0 <readi+0x102>
{
    800041a4:	7159                	addi	sp,sp,-112
    800041a6:	f486                	sd	ra,104(sp)
    800041a8:	f0a2                	sd	s0,96(sp)
    800041aa:	eca6                	sd	s1,88(sp)
    800041ac:	e0d2                	sd	s4,64(sp)
    800041ae:	fc56                	sd	s5,56(sp)
    800041b0:	f85a                	sd	s6,48(sp)
    800041b2:	f45e                	sd	s7,40(sp)
    800041b4:	1880                	addi	s0,sp,112
    800041b6:	8b2a                	mv	s6,a0
    800041b8:	8bae                	mv	s7,a1
    800041ba:	8a32                	mv	s4,a2
    800041bc:	84b6                	mv	s1,a3
    800041be:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800041c0:	9f35                	addw	a4,a4,a3
    return 0;
    800041c2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800041c4:	0cd76563          	bltu	a4,a3,8000428e <readi+0xf0>
    800041c8:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800041ca:	00e7f463          	bgeu	a5,a4,800041d2 <readi+0x34>
    n = ip->size - off;
    800041ce:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800041d2:	0a0a8563          	beqz	s5,8000427c <readi+0xde>
    800041d6:	e8ca                	sd	s2,80(sp)
    800041d8:	f062                	sd	s8,32(sp)
    800041da:	ec66                	sd	s9,24(sp)
    800041dc:	e86a                	sd	s10,16(sp)
    800041de:	e46e                	sd	s11,8(sp)
    800041e0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800041e2:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800041e6:	5c7d                	li	s8,-1
    800041e8:	a82d                	j	80004222 <readi+0x84>
    800041ea:	020d1d93          	slli	s11,s10,0x20
    800041ee:	020ddd93          	srli	s11,s11,0x20
    800041f2:	05890613          	addi	a2,s2,88
    800041f6:	86ee                	mv	a3,s11
    800041f8:	963e                	add	a2,a2,a5
    800041fa:	85d2                	mv	a1,s4
    800041fc:	855e                	mv	a0,s7
    800041fe:	ffffe097          	auipc	ra,0xffffe
    80004202:	6ac080e7          	jalr	1708(ra) # 800028aa <either_copyout>
    80004206:	05850963          	beq	a0,s8,80004258 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000420a:	854a                	mv	a0,s2
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	606080e7          	jalr	1542(ra) # 80003812 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004214:	013d09bb          	addw	s3,s10,s3
    80004218:	009d04bb          	addw	s1,s10,s1
    8000421c:	9a6e                	add	s4,s4,s11
    8000421e:	0559f963          	bgeu	s3,s5,80004270 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80004222:	00a4d59b          	srliw	a1,s1,0xa
    80004226:	855a                	mv	a0,s6
    80004228:	00000097          	auipc	ra,0x0
    8000422c:	8a0080e7          	jalr	-1888(ra) # 80003ac8 <bmap>
    80004230:	85aa                	mv	a1,a0
    if(addr == 0)
    80004232:	c539                	beqz	a0,80004280 <readi+0xe2>
    bp = bread(ip->dev, addr);
    80004234:	000b2503          	lw	a0,0(s6)
    80004238:	fffff097          	auipc	ra,0xfffff
    8000423c:	4aa080e7          	jalr	1194(ra) # 800036e2 <bread>
    80004240:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004242:	3ff4f793          	andi	a5,s1,1023
    80004246:	40fc873b          	subw	a4,s9,a5
    8000424a:	413a86bb          	subw	a3,s5,s3
    8000424e:	8d3a                	mv	s10,a4
    80004250:	f8e6fde3          	bgeu	a3,a4,800041ea <readi+0x4c>
    80004254:	8d36                	mv	s10,a3
    80004256:	bf51                	j	800041ea <readi+0x4c>
      brelse(bp);
    80004258:	854a                	mv	a0,s2
    8000425a:	fffff097          	auipc	ra,0xfffff
    8000425e:	5b8080e7          	jalr	1464(ra) # 80003812 <brelse>
      tot = -1;
    80004262:	59fd                	li	s3,-1
      break;
    80004264:	6946                	ld	s2,80(sp)
    80004266:	7c02                	ld	s8,32(sp)
    80004268:	6ce2                	ld	s9,24(sp)
    8000426a:	6d42                	ld	s10,16(sp)
    8000426c:	6da2                	ld	s11,8(sp)
    8000426e:	a831                	j	8000428a <readi+0xec>
    80004270:	6946                	ld	s2,80(sp)
    80004272:	7c02                	ld	s8,32(sp)
    80004274:	6ce2                	ld	s9,24(sp)
    80004276:	6d42                	ld	s10,16(sp)
    80004278:	6da2                	ld	s11,8(sp)
    8000427a:	a801                	j	8000428a <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000427c:	89d6                	mv	s3,s5
    8000427e:	a031                	j	8000428a <readi+0xec>
    80004280:	6946                	ld	s2,80(sp)
    80004282:	7c02                	ld	s8,32(sp)
    80004284:	6ce2                	ld	s9,24(sp)
    80004286:	6d42                	ld	s10,16(sp)
    80004288:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000428a:	854e                	mv	a0,s3
    8000428c:	69a6                	ld	s3,72(sp)
}
    8000428e:	70a6                	ld	ra,104(sp)
    80004290:	7406                	ld	s0,96(sp)
    80004292:	64e6                	ld	s1,88(sp)
    80004294:	6a06                	ld	s4,64(sp)
    80004296:	7ae2                	ld	s5,56(sp)
    80004298:	7b42                	ld	s6,48(sp)
    8000429a:	7ba2                	ld	s7,40(sp)
    8000429c:	6165                	addi	sp,sp,112
    8000429e:	8082                	ret
    return 0;
    800042a0:	4501                	li	a0,0
}
    800042a2:	8082                	ret

00000000800042a4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800042a4:	457c                	lw	a5,76(a0)
    800042a6:	10d7e963          	bltu	a5,a3,800043b8 <writei+0x114>
{
    800042aa:	7159                	addi	sp,sp,-112
    800042ac:	f486                	sd	ra,104(sp)
    800042ae:	f0a2                	sd	s0,96(sp)
    800042b0:	e8ca                	sd	s2,80(sp)
    800042b2:	e0d2                	sd	s4,64(sp)
    800042b4:	fc56                	sd	s5,56(sp)
    800042b6:	f85a                	sd	s6,48(sp)
    800042b8:	f45e                	sd	s7,40(sp)
    800042ba:	1880                	addi	s0,sp,112
    800042bc:	8aaa                	mv	s5,a0
    800042be:	8bae                	mv	s7,a1
    800042c0:	8a32                	mv	s4,a2
    800042c2:	8936                	mv	s2,a3
    800042c4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800042c6:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800042ca:	00043737          	lui	a4,0x43
    800042ce:	0ef76763          	bltu	a4,a5,800043bc <writei+0x118>
    800042d2:	0ed7e563          	bltu	a5,a3,800043bc <writei+0x118>
    800042d6:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800042d8:	0c0b0863          	beqz	s6,800043a8 <writei+0x104>
    800042dc:	eca6                	sd	s1,88(sp)
    800042de:	f062                	sd	s8,32(sp)
    800042e0:	ec66                	sd	s9,24(sp)
    800042e2:	e86a                	sd	s10,16(sp)
    800042e4:	e46e                	sd	s11,8(sp)
    800042e6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800042e8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800042ec:	5c7d                	li	s8,-1
    800042ee:	a091                	j	80004332 <writei+0x8e>
    800042f0:	020d1d93          	slli	s11,s10,0x20
    800042f4:	020ddd93          	srli	s11,s11,0x20
    800042f8:	05848513          	addi	a0,s1,88
    800042fc:	86ee                	mv	a3,s11
    800042fe:	8652                	mv	a2,s4
    80004300:	85de                	mv	a1,s7
    80004302:	953e                	add	a0,a0,a5
    80004304:	ffffe097          	auipc	ra,0xffffe
    80004308:	5fc080e7          	jalr	1532(ra) # 80002900 <either_copyin>
    8000430c:	05850e63          	beq	a0,s8,80004368 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004310:	8526                	mv	a0,s1
    80004312:	00000097          	auipc	ra,0x0
    80004316:	7ac080e7          	jalr	1964(ra) # 80004abe <log_write>
    brelse(bp);
    8000431a:	8526                	mv	a0,s1
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	4f6080e7          	jalr	1270(ra) # 80003812 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004324:	013d09bb          	addw	s3,s10,s3
    80004328:	012d093b          	addw	s2,s10,s2
    8000432c:	9a6e                	add	s4,s4,s11
    8000432e:	0569f263          	bgeu	s3,s6,80004372 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80004332:	00a9559b          	srliw	a1,s2,0xa
    80004336:	8556                	mv	a0,s5
    80004338:	fffff097          	auipc	ra,0xfffff
    8000433c:	790080e7          	jalr	1936(ra) # 80003ac8 <bmap>
    80004340:	85aa                	mv	a1,a0
    if(addr == 0)
    80004342:	c905                	beqz	a0,80004372 <writei+0xce>
    bp = bread(ip->dev, addr);
    80004344:	000aa503          	lw	a0,0(s5)
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	39a080e7          	jalr	922(ra) # 800036e2 <bread>
    80004350:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004352:	3ff97793          	andi	a5,s2,1023
    80004356:	40fc873b          	subw	a4,s9,a5
    8000435a:	413b06bb          	subw	a3,s6,s3
    8000435e:	8d3a                	mv	s10,a4
    80004360:	f8e6f8e3          	bgeu	a3,a4,800042f0 <writei+0x4c>
    80004364:	8d36                	mv	s10,a3
    80004366:	b769                	j	800042f0 <writei+0x4c>
      brelse(bp);
    80004368:	8526                	mv	a0,s1
    8000436a:	fffff097          	auipc	ra,0xfffff
    8000436e:	4a8080e7          	jalr	1192(ra) # 80003812 <brelse>
  }

  if(off > ip->size)
    80004372:	04caa783          	lw	a5,76(s5)
    80004376:	0327fb63          	bgeu	a5,s2,800043ac <writei+0x108>
    ip->size = off;
    8000437a:	052aa623          	sw	s2,76(s5)
    8000437e:	64e6                	ld	s1,88(sp)
    80004380:	7c02                	ld	s8,32(sp)
    80004382:	6ce2                	ld	s9,24(sp)
    80004384:	6d42                	ld	s10,16(sp)
    80004386:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004388:	8556                	mv	a0,s5
    8000438a:	00000097          	auipc	ra,0x0
    8000438e:	a8a080e7          	jalr	-1398(ra) # 80003e14 <iupdate>

  return tot;
    80004392:	854e                	mv	a0,s3
    80004394:	69a6                	ld	s3,72(sp)
}
    80004396:	70a6                	ld	ra,104(sp)
    80004398:	7406                	ld	s0,96(sp)
    8000439a:	6946                	ld	s2,80(sp)
    8000439c:	6a06                	ld	s4,64(sp)
    8000439e:	7ae2                	ld	s5,56(sp)
    800043a0:	7b42                	ld	s6,48(sp)
    800043a2:	7ba2                	ld	s7,40(sp)
    800043a4:	6165                	addi	sp,sp,112
    800043a6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800043a8:	89da                	mv	s3,s6
    800043aa:	bff9                	j	80004388 <writei+0xe4>
    800043ac:	64e6                	ld	s1,88(sp)
    800043ae:	7c02                	ld	s8,32(sp)
    800043b0:	6ce2                	ld	s9,24(sp)
    800043b2:	6d42                	ld	s10,16(sp)
    800043b4:	6da2                	ld	s11,8(sp)
    800043b6:	bfc9                	j	80004388 <writei+0xe4>
    return -1;
    800043b8:	557d                	li	a0,-1
}
    800043ba:	8082                	ret
    return -1;
    800043bc:	557d                	li	a0,-1
    800043be:	bfe1                	j	80004396 <writei+0xf2>

00000000800043c0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800043c0:	1141                	addi	sp,sp,-16
    800043c2:	e406                	sd	ra,8(sp)
    800043c4:	e022                	sd	s0,0(sp)
    800043c6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800043c8:	4639                	li	a2,14
    800043ca:	ffffd097          	auipc	ra,0xffffd
    800043ce:	a62080e7          	jalr	-1438(ra) # 80000e2c <strncmp>
}
    800043d2:	60a2                	ld	ra,8(sp)
    800043d4:	6402                	ld	s0,0(sp)
    800043d6:	0141                	addi	sp,sp,16
    800043d8:	8082                	ret

00000000800043da <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800043da:	711d                	addi	sp,sp,-96
    800043dc:	ec86                	sd	ra,88(sp)
    800043de:	e8a2                	sd	s0,80(sp)
    800043e0:	e4a6                	sd	s1,72(sp)
    800043e2:	e0ca                	sd	s2,64(sp)
    800043e4:	fc4e                	sd	s3,56(sp)
    800043e6:	f852                	sd	s4,48(sp)
    800043e8:	f456                	sd	s5,40(sp)
    800043ea:	f05a                	sd	s6,32(sp)
    800043ec:	ec5e                	sd	s7,24(sp)
    800043ee:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800043f0:	04451703          	lh	a4,68(a0)
    800043f4:	4785                	li	a5,1
    800043f6:	00f71f63          	bne	a4,a5,80004414 <dirlookup+0x3a>
    800043fa:	892a                	mv	s2,a0
    800043fc:	8aae                	mv	s5,a1
    800043fe:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004400:	457c                	lw	a5,76(a0)
    80004402:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004404:	fa040a13          	addi	s4,s0,-96
    80004408:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000440a:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000440e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004410:	e79d                	bnez	a5,8000443e <dirlookup+0x64>
    80004412:	a88d                	j	80004484 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80004414:	00004517          	auipc	a0,0x4
    80004418:	26c50513          	addi	a0,a0,620 # 80008680 <etext+0x680>
    8000441c:	ffffc097          	auipc	ra,0xffffc
    80004420:	142080e7          	jalr	322(ra) # 8000055e <panic>
      panic("dirlookup read");
    80004424:	00004517          	auipc	a0,0x4
    80004428:	27450513          	addi	a0,a0,628 # 80008698 <etext+0x698>
    8000442c:	ffffc097          	auipc	ra,0xffffc
    80004430:	132080e7          	jalr	306(ra) # 8000055e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004434:	24c1                	addiw	s1,s1,16
    80004436:	04c92783          	lw	a5,76(s2)
    8000443a:	04f4f463          	bgeu	s1,a5,80004482 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000443e:	874e                	mv	a4,s3
    80004440:	86a6                	mv	a3,s1
    80004442:	8652                	mv	a2,s4
    80004444:	4581                	li	a1,0
    80004446:	854a                	mv	a0,s2
    80004448:	00000097          	auipc	ra,0x0
    8000444c:	d56080e7          	jalr	-682(ra) # 8000419e <readi>
    80004450:	fd351ae3          	bne	a0,s3,80004424 <dirlookup+0x4a>
    if(de.inum == 0)
    80004454:	fa045783          	lhu	a5,-96(s0)
    80004458:	dff1                	beqz	a5,80004434 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    8000445a:	85da                	mv	a1,s6
    8000445c:	8556                	mv	a0,s5
    8000445e:	00000097          	auipc	ra,0x0
    80004462:	f62080e7          	jalr	-158(ra) # 800043c0 <namecmp>
    80004466:	f579                	bnez	a0,80004434 <dirlookup+0x5a>
      if(poff)
    80004468:	000b8463          	beqz	s7,80004470 <dirlookup+0x96>
        *poff = off;
    8000446c:	009ba023          	sw	s1,0(s7) # 1000 <_entry-0x7ffff000>
      return iget(dp->dev, inum);
    80004470:	fa045583          	lhu	a1,-96(s0)
    80004474:	00092503          	lw	a0,0(s2)
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	72c080e7          	jalr	1836(ra) # 80003ba4 <iget>
    80004480:	a011                	j	80004484 <dirlookup+0xaa>
  return 0;
    80004482:	4501                	li	a0,0
}
    80004484:	60e6                	ld	ra,88(sp)
    80004486:	6446                	ld	s0,80(sp)
    80004488:	64a6                	ld	s1,72(sp)
    8000448a:	6906                	ld	s2,64(sp)
    8000448c:	79e2                	ld	s3,56(sp)
    8000448e:	7a42                	ld	s4,48(sp)
    80004490:	7aa2                	ld	s5,40(sp)
    80004492:	7b02                	ld	s6,32(sp)
    80004494:	6be2                	ld	s7,24(sp)
    80004496:	6125                	addi	sp,sp,96
    80004498:	8082                	ret

000000008000449a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000449a:	711d                	addi	sp,sp,-96
    8000449c:	ec86                	sd	ra,88(sp)
    8000449e:	e8a2                	sd	s0,80(sp)
    800044a0:	e4a6                	sd	s1,72(sp)
    800044a2:	e0ca                	sd	s2,64(sp)
    800044a4:	fc4e                	sd	s3,56(sp)
    800044a6:	f852                	sd	s4,48(sp)
    800044a8:	f456                	sd	s5,40(sp)
    800044aa:	f05a                	sd	s6,32(sp)
    800044ac:	ec5e                	sd	s7,24(sp)
    800044ae:	e862                	sd	s8,16(sp)
    800044b0:	e466                	sd	s9,8(sp)
    800044b2:	e06a                	sd	s10,0(sp)
    800044b4:	1080                	addi	s0,sp,96
    800044b6:	84aa                	mv	s1,a0
    800044b8:	8b2e                	mv	s6,a1
    800044ba:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800044bc:	00054703          	lbu	a4,0(a0)
    800044c0:	02f00793          	li	a5,47
    800044c4:	02f70363          	beq	a4,a5,800044ea <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800044c8:	ffffd097          	auipc	ra,0xffffd
    800044cc:	6c4080e7          	jalr	1732(ra) # 80001b8c <myproc>
    800044d0:	15053503          	ld	a0,336(a0)
    800044d4:	00000097          	auipc	ra,0x0
    800044d8:	9ce080e7          	jalr	-1586(ra) # 80003ea2 <idup>
    800044dc:	8a2a                	mv	s4,a0
  while(*path == '/')
    800044de:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    800044e2:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800044e4:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800044e6:	4b85                	li	s7,1
    800044e8:	a87d                	j	800045a6 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800044ea:	4585                	li	a1,1
    800044ec:	852e                	mv	a0,a1
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	6b6080e7          	jalr	1718(ra) # 80003ba4 <iget>
    800044f6:	8a2a                	mv	s4,a0
    800044f8:	b7dd                	j	800044de <namex+0x44>
      iunlockput(ip);
    800044fa:	8552                	mv	a0,s4
    800044fc:	00000097          	auipc	ra,0x0
    80004500:	c4c080e7          	jalr	-948(ra) # 80004148 <iunlockput>
      return 0;
    80004504:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004506:	8552                	mv	a0,s4
    80004508:	60e6                	ld	ra,88(sp)
    8000450a:	6446                	ld	s0,80(sp)
    8000450c:	64a6                	ld	s1,72(sp)
    8000450e:	6906                	ld	s2,64(sp)
    80004510:	79e2                	ld	s3,56(sp)
    80004512:	7a42                	ld	s4,48(sp)
    80004514:	7aa2                	ld	s5,40(sp)
    80004516:	7b02                	ld	s6,32(sp)
    80004518:	6be2                	ld	s7,24(sp)
    8000451a:	6c42                	ld	s8,16(sp)
    8000451c:	6ca2                	ld	s9,8(sp)
    8000451e:	6d02                	ld	s10,0(sp)
    80004520:	6125                	addi	sp,sp,96
    80004522:	8082                	ret
      iunlock(ip);
    80004524:	8552                	mv	a0,s4
    80004526:	00000097          	auipc	ra,0x0
    8000452a:	a80080e7          	jalr	-1408(ra) # 80003fa6 <iunlock>
      return ip;
    8000452e:	bfe1                	j	80004506 <namex+0x6c>
      iunlockput(ip);
    80004530:	8552                	mv	a0,s4
    80004532:	00000097          	auipc	ra,0x0
    80004536:	c16080e7          	jalr	-1002(ra) # 80004148 <iunlockput>
      return 0;
    8000453a:	8a4a                	mv	s4,s2
    8000453c:	b7e9                	j	80004506 <namex+0x6c>
  len = path - s;
    8000453e:	40990633          	sub	a2,s2,s1
    80004542:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004546:	09ac5c63          	bge	s8,s10,800045de <namex+0x144>
    memmove(name, s, DIRSIZ);
    8000454a:	8666                	mv	a2,s9
    8000454c:	85a6                	mv	a1,s1
    8000454e:	8556                	mv	a0,s5
    80004550:	ffffd097          	auipc	ra,0xffffd
    80004554:	864080e7          	jalr	-1948(ra) # 80000db4 <memmove>
    80004558:	84ca                	mv	s1,s2
  while(*path == '/')
    8000455a:	0004c783          	lbu	a5,0(s1)
    8000455e:	01379763          	bne	a5,s3,8000456c <namex+0xd2>
    path++;
    80004562:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004564:	0004c783          	lbu	a5,0(s1)
    80004568:	ff378de3          	beq	a5,s3,80004562 <namex+0xc8>
    ilock(ip);
    8000456c:	8552                	mv	a0,s4
    8000456e:	00000097          	auipc	ra,0x0
    80004572:	972080e7          	jalr	-1678(ra) # 80003ee0 <ilock>
    if(ip->type != T_DIR){
    80004576:	044a1783          	lh	a5,68(s4)
    8000457a:	f97790e3          	bne	a5,s7,800044fa <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000457e:	000b0563          	beqz	s6,80004588 <namex+0xee>
    80004582:	0004c783          	lbu	a5,0(s1)
    80004586:	dfd9                	beqz	a5,80004524 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004588:	4601                	li	a2,0
    8000458a:	85d6                	mv	a1,s5
    8000458c:	8552                	mv	a0,s4
    8000458e:	00000097          	auipc	ra,0x0
    80004592:	e4c080e7          	jalr	-436(ra) # 800043da <dirlookup>
    80004596:	892a                	mv	s2,a0
    80004598:	dd41                	beqz	a0,80004530 <namex+0x96>
    iunlockput(ip);
    8000459a:	8552                	mv	a0,s4
    8000459c:	00000097          	auipc	ra,0x0
    800045a0:	bac080e7          	jalr	-1108(ra) # 80004148 <iunlockput>
    ip = next;
    800045a4:	8a4a                	mv	s4,s2
  while(*path == '/')
    800045a6:	0004c783          	lbu	a5,0(s1)
    800045aa:	01379763          	bne	a5,s3,800045b8 <namex+0x11e>
    path++;
    800045ae:	0485                	addi	s1,s1,1
  while(*path == '/')
    800045b0:	0004c783          	lbu	a5,0(s1)
    800045b4:	ff378de3          	beq	a5,s3,800045ae <namex+0x114>
  if(*path == 0)
    800045b8:	cf9d                	beqz	a5,800045f6 <namex+0x15c>
  while(*path != '/' && *path != 0)
    800045ba:	0004c783          	lbu	a5,0(s1)
    800045be:	fd178713          	addi	a4,a5,-47
    800045c2:	cb19                	beqz	a4,800045d8 <namex+0x13e>
    800045c4:	cb91                	beqz	a5,800045d8 <namex+0x13e>
    800045c6:	8926                	mv	s2,s1
    path++;
    800045c8:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    800045ca:	00094783          	lbu	a5,0(s2)
    800045ce:	fd178713          	addi	a4,a5,-47
    800045d2:	d735                	beqz	a4,8000453e <namex+0xa4>
    800045d4:	fbf5                	bnez	a5,800045c8 <namex+0x12e>
    800045d6:	b7a5                	j	8000453e <namex+0xa4>
    800045d8:	8926                	mv	s2,s1
  len = path - s;
    800045da:	4d01                	li	s10,0
    800045dc:	4601                	li	a2,0
    memmove(name, s, len);
    800045de:	2601                	sext.w	a2,a2
    800045e0:	85a6                	mv	a1,s1
    800045e2:	8556                	mv	a0,s5
    800045e4:	ffffc097          	auipc	ra,0xffffc
    800045e8:	7d0080e7          	jalr	2000(ra) # 80000db4 <memmove>
    name[len] = 0;
    800045ec:	9d56                	add	s10,s10,s5
    800045ee:	000d0023          	sb	zero,0(s10)
    800045f2:	84ca                	mv	s1,s2
    800045f4:	b79d                	j	8000455a <namex+0xc0>
  if(nameiparent){
    800045f6:	f00b08e3          	beqz	s6,80004506 <namex+0x6c>
    iput(ip);
    800045fa:	8552                	mv	a0,s4
    800045fc:	00000097          	auipc	ra,0x0
    80004600:	aa2080e7          	jalr	-1374(ra) # 8000409e <iput>
    return 0;
    80004604:	4a01                	li	s4,0
    80004606:	b701                	j	80004506 <namex+0x6c>

0000000080004608 <dirlink>:
{
    80004608:	715d                	addi	sp,sp,-80
    8000460a:	e486                	sd	ra,72(sp)
    8000460c:	e0a2                	sd	s0,64(sp)
    8000460e:	f84a                	sd	s2,48(sp)
    80004610:	ec56                	sd	s5,24(sp)
    80004612:	e85a                	sd	s6,16(sp)
    80004614:	0880                	addi	s0,sp,80
    80004616:	892a                	mv	s2,a0
    80004618:	8aae                	mv	s5,a1
    8000461a:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000461c:	4601                	li	a2,0
    8000461e:	00000097          	auipc	ra,0x0
    80004622:	dbc080e7          	jalr	-580(ra) # 800043da <dirlookup>
    80004626:	e129                	bnez	a0,80004668 <dirlink+0x60>
    80004628:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000462a:	04c92483          	lw	s1,76(s2)
    8000462e:	cca9                	beqz	s1,80004688 <dirlink+0x80>
    80004630:	f44e                	sd	s3,40(sp)
    80004632:	f052                	sd	s4,32(sp)
    80004634:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004636:	fb040a13          	addi	s4,s0,-80
    8000463a:	49c1                	li	s3,16
    8000463c:	874e                	mv	a4,s3
    8000463e:	86a6                	mv	a3,s1
    80004640:	8652                	mv	a2,s4
    80004642:	4581                	li	a1,0
    80004644:	854a                	mv	a0,s2
    80004646:	00000097          	auipc	ra,0x0
    8000464a:	b58080e7          	jalr	-1192(ra) # 8000419e <readi>
    8000464e:	03351363          	bne	a0,s3,80004674 <dirlink+0x6c>
    if(de.inum == 0)
    80004652:	fb045783          	lhu	a5,-80(s0)
    80004656:	c79d                	beqz	a5,80004684 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004658:	24c1                	addiw	s1,s1,16
    8000465a:	04c92783          	lw	a5,76(s2)
    8000465e:	fcf4efe3          	bltu	s1,a5,8000463c <dirlink+0x34>
    80004662:	79a2                	ld	s3,40(sp)
    80004664:	7a02                	ld	s4,32(sp)
    80004666:	a00d                	j	80004688 <dirlink+0x80>
    iput(ip);
    80004668:	00000097          	auipc	ra,0x0
    8000466c:	a36080e7          	jalr	-1482(ra) # 8000409e <iput>
    return -1;
    80004670:	557d                	li	a0,-1
    80004672:	a0a9                	j	800046bc <dirlink+0xb4>
      panic("dirlink read");
    80004674:	00004517          	auipc	a0,0x4
    80004678:	03450513          	addi	a0,a0,52 # 800086a8 <etext+0x6a8>
    8000467c:	ffffc097          	auipc	ra,0xffffc
    80004680:	ee2080e7          	jalr	-286(ra) # 8000055e <panic>
    80004684:	79a2                	ld	s3,40(sp)
    80004686:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004688:	4639                	li	a2,14
    8000468a:	85d6                	mv	a1,s5
    8000468c:	fb240513          	addi	a0,s0,-78
    80004690:	ffffc097          	auipc	ra,0xffffc
    80004694:	7d6080e7          	jalr	2006(ra) # 80000e66 <strncpy>
  de.inum = inum;
    80004698:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000469c:	4741                	li	a4,16
    8000469e:	86a6                	mv	a3,s1
    800046a0:	fb040613          	addi	a2,s0,-80
    800046a4:	4581                	li	a1,0
    800046a6:	854a                	mv	a0,s2
    800046a8:	00000097          	auipc	ra,0x0
    800046ac:	bfc080e7          	jalr	-1028(ra) # 800042a4 <writei>
    800046b0:	1541                	addi	a0,a0,-16
    800046b2:	00a03533          	snez	a0,a0
    800046b6:	40a0053b          	negw	a0,a0
    800046ba:	74e2                	ld	s1,56(sp)
}
    800046bc:	60a6                	ld	ra,72(sp)
    800046be:	6406                	ld	s0,64(sp)
    800046c0:	7942                	ld	s2,48(sp)
    800046c2:	6ae2                	ld	s5,24(sp)
    800046c4:	6b42                	ld	s6,16(sp)
    800046c6:	6161                	addi	sp,sp,80
    800046c8:	8082                	ret

00000000800046ca <namei>:

struct inode*
namei(char *path)
{
    800046ca:	1101                	addi	sp,sp,-32
    800046cc:	ec06                	sd	ra,24(sp)
    800046ce:	e822                	sd	s0,16(sp)
    800046d0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800046d2:	fe040613          	addi	a2,s0,-32
    800046d6:	4581                	li	a1,0
    800046d8:	00000097          	auipc	ra,0x0
    800046dc:	dc2080e7          	jalr	-574(ra) # 8000449a <namex>
}
    800046e0:	60e2                	ld	ra,24(sp)
    800046e2:	6442                	ld	s0,16(sp)
    800046e4:	6105                	addi	sp,sp,32
    800046e6:	8082                	ret

00000000800046e8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800046e8:	1141                	addi	sp,sp,-16
    800046ea:	e406                	sd	ra,8(sp)
    800046ec:	e022                	sd	s0,0(sp)
    800046ee:	0800                	addi	s0,sp,16
    800046f0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800046f2:	4585                	li	a1,1
    800046f4:	00000097          	auipc	ra,0x0
    800046f8:	da6080e7          	jalr	-602(ra) # 8000449a <namex>
}
    800046fc:	60a2                	ld	ra,8(sp)
    800046fe:	6402                	ld	s0,0(sp)
    80004700:	0141                	addi	sp,sp,16
    80004702:	8082                	ret

0000000080004704 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004704:	1101                	addi	sp,sp,-32
    80004706:	ec06                	sd	ra,24(sp)
    80004708:	e822                	sd	s0,16(sp)
    8000470a:	e426                	sd	s1,8(sp)
    8000470c:	e04a                	sd	s2,0(sp)
    8000470e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004710:	00048917          	auipc	s2,0x48
    80004714:	80090913          	addi	s2,s2,-2048 # 8004bf10 <log>
    80004718:	01892583          	lw	a1,24(s2)
    8000471c:	02892503          	lw	a0,40(s2)
    80004720:	fffff097          	auipc	ra,0xfffff
    80004724:	fc2080e7          	jalr	-62(ra) # 800036e2 <bread>
    80004728:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000472a:	02c92603          	lw	a2,44(s2)
    8000472e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004730:	00c05f63          	blez	a2,8000474e <write_head+0x4a>
    80004734:	00048717          	auipc	a4,0x48
    80004738:	80c70713          	addi	a4,a4,-2036 # 8004bf40 <log+0x30>
    8000473c:	87aa                	mv	a5,a0
    8000473e:	060a                	slli	a2,a2,0x2
    80004740:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004742:	4314                	lw	a3,0(a4)
    80004744:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004746:	0711                	addi	a4,a4,4
    80004748:	0791                	addi	a5,a5,4
    8000474a:	fec79ce3          	bne	a5,a2,80004742 <write_head+0x3e>
  }
  bwrite(buf);
    8000474e:	8526                	mv	a0,s1
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	084080e7          	jalr	132(ra) # 800037d4 <bwrite>
  brelse(buf);
    80004758:	8526                	mv	a0,s1
    8000475a:	fffff097          	auipc	ra,0xfffff
    8000475e:	0b8080e7          	jalr	184(ra) # 80003812 <brelse>
}
    80004762:	60e2                	ld	ra,24(sp)
    80004764:	6442                	ld	s0,16(sp)
    80004766:	64a2                	ld	s1,8(sp)
    80004768:	6902                	ld	s2,0(sp)
    8000476a:	6105                	addi	sp,sp,32
    8000476c:	8082                	ret

000000008000476e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000476e:	00047797          	auipc	a5,0x47
    80004772:	7ce7a783          	lw	a5,1998(a5) # 8004bf3c <log+0x2c>
    80004776:	0cf05063          	blez	a5,80004836 <install_trans+0xc8>
{
    8000477a:	715d                	addi	sp,sp,-80
    8000477c:	e486                	sd	ra,72(sp)
    8000477e:	e0a2                	sd	s0,64(sp)
    80004780:	fc26                	sd	s1,56(sp)
    80004782:	f84a                	sd	s2,48(sp)
    80004784:	f44e                	sd	s3,40(sp)
    80004786:	f052                	sd	s4,32(sp)
    80004788:	ec56                	sd	s5,24(sp)
    8000478a:	e85a                	sd	s6,16(sp)
    8000478c:	e45e                	sd	s7,8(sp)
    8000478e:	0880                	addi	s0,sp,80
    80004790:	8b2a                	mv	s6,a0
    80004792:	00047a97          	auipc	s5,0x47
    80004796:	7aea8a93          	addi	s5,s5,1966 # 8004bf40 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000479a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000479c:	00047997          	auipc	s3,0x47
    800047a0:	77498993          	addi	s3,s3,1908 # 8004bf10 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800047a4:	40000b93          	li	s7,1024
    800047a8:	a00d                	j	800047ca <install_trans+0x5c>
    brelse(lbuf);
    800047aa:	854a                	mv	a0,s2
    800047ac:	fffff097          	auipc	ra,0xfffff
    800047b0:	066080e7          	jalr	102(ra) # 80003812 <brelse>
    brelse(dbuf);
    800047b4:	8526                	mv	a0,s1
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	05c080e7          	jalr	92(ra) # 80003812 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047be:	2a05                	addiw	s4,s4,1
    800047c0:	0a91                	addi	s5,s5,4
    800047c2:	02c9a783          	lw	a5,44(s3)
    800047c6:	04fa5d63          	bge	s4,a5,80004820 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800047ca:	0189a583          	lw	a1,24(s3)
    800047ce:	014585bb          	addw	a1,a1,s4
    800047d2:	2585                	addiw	a1,a1,1
    800047d4:	0289a503          	lw	a0,40(s3)
    800047d8:	fffff097          	auipc	ra,0xfffff
    800047dc:	f0a080e7          	jalr	-246(ra) # 800036e2 <bread>
    800047e0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800047e2:	000aa583          	lw	a1,0(s5)
    800047e6:	0289a503          	lw	a0,40(s3)
    800047ea:	fffff097          	auipc	ra,0xfffff
    800047ee:	ef8080e7          	jalr	-264(ra) # 800036e2 <bread>
    800047f2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800047f4:	865e                	mv	a2,s7
    800047f6:	05890593          	addi	a1,s2,88
    800047fa:	05850513          	addi	a0,a0,88
    800047fe:	ffffc097          	auipc	ra,0xffffc
    80004802:	5b6080e7          	jalr	1462(ra) # 80000db4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004806:	8526                	mv	a0,s1
    80004808:	fffff097          	auipc	ra,0xfffff
    8000480c:	fcc080e7          	jalr	-52(ra) # 800037d4 <bwrite>
    if(recovering == 0)
    80004810:	f80b1de3          	bnez	s6,800047aa <install_trans+0x3c>
      bunpin(dbuf);
    80004814:	8526                	mv	a0,s1
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	0d0080e7          	jalr	208(ra) # 800038e6 <bunpin>
    8000481e:	b771                	j	800047aa <install_trans+0x3c>
}
    80004820:	60a6                	ld	ra,72(sp)
    80004822:	6406                	ld	s0,64(sp)
    80004824:	74e2                	ld	s1,56(sp)
    80004826:	7942                	ld	s2,48(sp)
    80004828:	79a2                	ld	s3,40(sp)
    8000482a:	7a02                	ld	s4,32(sp)
    8000482c:	6ae2                	ld	s5,24(sp)
    8000482e:	6b42                	ld	s6,16(sp)
    80004830:	6ba2                	ld	s7,8(sp)
    80004832:	6161                	addi	sp,sp,80
    80004834:	8082                	ret
    80004836:	8082                	ret

0000000080004838 <initlog>:
{
    80004838:	7179                	addi	sp,sp,-48
    8000483a:	f406                	sd	ra,40(sp)
    8000483c:	f022                	sd	s0,32(sp)
    8000483e:	ec26                	sd	s1,24(sp)
    80004840:	e84a                	sd	s2,16(sp)
    80004842:	e44e                	sd	s3,8(sp)
    80004844:	1800                	addi	s0,sp,48
    80004846:	892a                	mv	s2,a0
    80004848:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000484a:	00047497          	auipc	s1,0x47
    8000484e:	6c648493          	addi	s1,s1,1734 # 8004bf10 <log>
    80004852:	00004597          	auipc	a1,0x4
    80004856:	e6658593          	addi	a1,a1,-410 # 800086b8 <etext+0x6b8>
    8000485a:	8526                	mv	a0,s1
    8000485c:	ffffc097          	auipc	ra,0xffffc
    80004860:	366080e7          	jalr	870(ra) # 80000bc2 <initlock>
  log.start = sb->logstart;
    80004864:	0149a583          	lw	a1,20(s3)
    80004868:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000486a:	0109a783          	lw	a5,16(s3)
    8000486e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004870:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004874:	854a                	mv	a0,s2
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	e6c080e7          	jalr	-404(ra) # 800036e2 <bread>
  log.lh.n = lh->n;
    8000487e:	4d30                	lw	a2,88(a0)
    80004880:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004882:	00c05f63          	blez	a2,800048a0 <initlog+0x68>
    80004886:	87aa                	mv	a5,a0
    80004888:	00047717          	auipc	a4,0x47
    8000488c:	6b870713          	addi	a4,a4,1720 # 8004bf40 <log+0x30>
    80004890:	060a                	slli	a2,a2,0x2
    80004892:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004894:	4ff4                	lw	a3,92(a5)
    80004896:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004898:	0791                	addi	a5,a5,4
    8000489a:	0711                	addi	a4,a4,4
    8000489c:	fec79ce3          	bne	a5,a2,80004894 <initlog+0x5c>
  brelse(buf);
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	f72080e7          	jalr	-142(ra) # 80003812 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800048a8:	4505                	li	a0,1
    800048aa:	00000097          	auipc	ra,0x0
    800048ae:	ec4080e7          	jalr	-316(ra) # 8000476e <install_trans>
  log.lh.n = 0;
    800048b2:	00047797          	auipc	a5,0x47
    800048b6:	6807a523          	sw	zero,1674(a5) # 8004bf3c <log+0x2c>
  write_head(); // clear the log
    800048ba:	00000097          	auipc	ra,0x0
    800048be:	e4a080e7          	jalr	-438(ra) # 80004704 <write_head>
}
    800048c2:	70a2                	ld	ra,40(sp)
    800048c4:	7402                	ld	s0,32(sp)
    800048c6:	64e2                	ld	s1,24(sp)
    800048c8:	6942                	ld	s2,16(sp)
    800048ca:	69a2                	ld	s3,8(sp)
    800048cc:	6145                	addi	sp,sp,48
    800048ce:	8082                	ret

00000000800048d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800048d0:	1101                	addi	sp,sp,-32
    800048d2:	ec06                	sd	ra,24(sp)
    800048d4:	e822                	sd	s0,16(sp)
    800048d6:	e426                	sd	s1,8(sp)
    800048d8:	e04a                	sd	s2,0(sp)
    800048da:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800048dc:	00047517          	auipc	a0,0x47
    800048e0:	63450513          	addi	a0,a0,1588 # 8004bf10 <log>
    800048e4:	ffffc097          	auipc	ra,0xffffc
    800048e8:	378080e7          	jalr	888(ra) # 80000c5c <acquire>
  while(1){
    if(log.committing){
    800048ec:	00047497          	auipc	s1,0x47
    800048f0:	62448493          	addi	s1,s1,1572 # 8004bf10 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800048f4:	4979                	li	s2,30
    800048f6:	a039                	j	80004904 <begin_op+0x34>
      sleep(&log, &log.lock);
    800048f8:	85a6                	mv	a1,s1
    800048fa:	8526                	mv	a0,s1
    800048fc:	ffffe097          	auipc	ra,0xffffe
    80004900:	b00080e7          	jalr	-1280(ra) # 800023fc <sleep>
    if(log.committing){
    80004904:	50dc                	lw	a5,36(s1)
    80004906:	fbed                	bnez	a5,800048f8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004908:	5098                	lw	a4,32(s1)
    8000490a:	2705                	addiw	a4,a4,1
    8000490c:	0027179b          	slliw	a5,a4,0x2
    80004910:	9fb9                	addw	a5,a5,a4
    80004912:	0017979b          	slliw	a5,a5,0x1
    80004916:	54d4                	lw	a3,44(s1)
    80004918:	9fb5                	addw	a5,a5,a3
    8000491a:	00f95963          	bge	s2,a5,8000492c <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000491e:	85a6                	mv	a1,s1
    80004920:	8526                	mv	a0,s1
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	ada080e7          	jalr	-1318(ra) # 800023fc <sleep>
    8000492a:	bfe9                	j	80004904 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000492c:	00047797          	auipc	a5,0x47
    80004930:	60e7a223          	sw	a4,1540(a5) # 8004bf30 <log+0x20>
      release(&log.lock);
    80004934:	00047517          	auipc	a0,0x47
    80004938:	5dc50513          	addi	a0,a0,1500 # 8004bf10 <log>
    8000493c:	ffffc097          	auipc	ra,0xffffc
    80004940:	3d0080e7          	jalr	976(ra) # 80000d0c <release>
      break;
    }
  }
}
    80004944:	60e2                	ld	ra,24(sp)
    80004946:	6442                	ld	s0,16(sp)
    80004948:	64a2                	ld	s1,8(sp)
    8000494a:	6902                	ld	s2,0(sp)
    8000494c:	6105                	addi	sp,sp,32
    8000494e:	8082                	ret

0000000080004950 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004950:	7139                	addi	sp,sp,-64
    80004952:	fc06                	sd	ra,56(sp)
    80004954:	f822                	sd	s0,48(sp)
    80004956:	f426                	sd	s1,40(sp)
    80004958:	f04a                	sd	s2,32(sp)
    8000495a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000495c:	00047497          	auipc	s1,0x47
    80004960:	5b448493          	addi	s1,s1,1460 # 8004bf10 <log>
    80004964:	8526                	mv	a0,s1
    80004966:	ffffc097          	auipc	ra,0xffffc
    8000496a:	2f6080e7          	jalr	758(ra) # 80000c5c <acquire>
  log.outstanding -= 1;
    8000496e:	509c                	lw	a5,32(s1)
    80004970:	37fd                	addiw	a5,a5,-1
    80004972:	893e                	mv	s2,a5
    80004974:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004976:	50dc                	lw	a5,36(s1)
    80004978:	efb1                	bnez	a5,800049d4 <end_op+0x84>
    panic("log.committing");
  if(log.outstanding == 0){
    8000497a:	06091863          	bnez	s2,800049ea <end_op+0x9a>
    do_commit = 1;
    log.committing = 1;
    8000497e:	00047497          	auipc	s1,0x47
    80004982:	59248493          	addi	s1,s1,1426 # 8004bf10 <log>
    80004986:	4785                	li	a5,1
    80004988:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000498a:	8526                	mv	a0,s1
    8000498c:	ffffc097          	auipc	ra,0xffffc
    80004990:	380080e7          	jalr	896(ra) # 80000d0c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004994:	54dc                	lw	a5,44(s1)
    80004996:	08f04063          	bgtz	a5,80004a16 <end_op+0xc6>
    acquire(&log.lock);
    8000499a:	00047517          	auipc	a0,0x47
    8000499e:	57650513          	addi	a0,a0,1398 # 8004bf10 <log>
    800049a2:	ffffc097          	auipc	ra,0xffffc
    800049a6:	2ba080e7          	jalr	698(ra) # 80000c5c <acquire>
    log.committing = 0;
    800049aa:	00047797          	auipc	a5,0x47
    800049ae:	5807a523          	sw	zero,1418(a5) # 8004bf34 <log+0x24>
    wakeup(&log);
    800049b2:	00047517          	auipc	a0,0x47
    800049b6:	55e50513          	addi	a0,a0,1374 # 8004bf10 <log>
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	aa6080e7          	jalr	-1370(ra) # 80002460 <wakeup>
    release(&log.lock);
    800049c2:	00047517          	auipc	a0,0x47
    800049c6:	54e50513          	addi	a0,a0,1358 # 8004bf10 <log>
    800049ca:	ffffc097          	auipc	ra,0xffffc
    800049ce:	342080e7          	jalr	834(ra) # 80000d0c <release>
}
    800049d2:	a825                	j	80004a0a <end_op+0xba>
    800049d4:	ec4e                	sd	s3,24(sp)
    800049d6:	e852                	sd	s4,16(sp)
    800049d8:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800049da:	00004517          	auipc	a0,0x4
    800049de:	ce650513          	addi	a0,a0,-794 # 800086c0 <etext+0x6c0>
    800049e2:	ffffc097          	auipc	ra,0xffffc
    800049e6:	b7c080e7          	jalr	-1156(ra) # 8000055e <panic>
    wakeup(&log);
    800049ea:	00047517          	auipc	a0,0x47
    800049ee:	52650513          	addi	a0,a0,1318 # 8004bf10 <log>
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	a6e080e7          	jalr	-1426(ra) # 80002460 <wakeup>
  release(&log.lock);
    800049fa:	00047517          	auipc	a0,0x47
    800049fe:	51650513          	addi	a0,a0,1302 # 8004bf10 <log>
    80004a02:	ffffc097          	auipc	ra,0xffffc
    80004a06:	30a080e7          	jalr	778(ra) # 80000d0c <release>
}
    80004a0a:	70e2                	ld	ra,56(sp)
    80004a0c:	7442                	ld	s0,48(sp)
    80004a0e:	74a2                	ld	s1,40(sp)
    80004a10:	7902                	ld	s2,32(sp)
    80004a12:	6121                	addi	sp,sp,64
    80004a14:	8082                	ret
    80004a16:	ec4e                	sd	s3,24(sp)
    80004a18:	e852                	sd	s4,16(sp)
    80004a1a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a1c:	00047a97          	auipc	s5,0x47
    80004a20:	524a8a93          	addi	s5,s5,1316 # 8004bf40 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004a24:	00047a17          	auipc	s4,0x47
    80004a28:	4eca0a13          	addi	s4,s4,1260 # 8004bf10 <log>
    80004a2c:	018a2583          	lw	a1,24(s4)
    80004a30:	012585bb          	addw	a1,a1,s2
    80004a34:	2585                	addiw	a1,a1,1
    80004a36:	028a2503          	lw	a0,40(s4)
    80004a3a:	fffff097          	auipc	ra,0xfffff
    80004a3e:	ca8080e7          	jalr	-856(ra) # 800036e2 <bread>
    80004a42:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004a44:	000aa583          	lw	a1,0(s5)
    80004a48:	028a2503          	lw	a0,40(s4)
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	c96080e7          	jalr	-874(ra) # 800036e2 <bread>
    80004a54:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004a56:	40000613          	li	a2,1024
    80004a5a:	05850593          	addi	a1,a0,88
    80004a5e:	05848513          	addi	a0,s1,88
    80004a62:	ffffc097          	auipc	ra,0xffffc
    80004a66:	352080e7          	jalr	850(ra) # 80000db4 <memmove>
    bwrite(to);  // write the log
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	d68080e7          	jalr	-664(ra) # 800037d4 <bwrite>
    brelse(from);
    80004a74:	854e                	mv	a0,s3
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	d9c080e7          	jalr	-612(ra) # 80003812 <brelse>
    brelse(to);
    80004a7e:	8526                	mv	a0,s1
    80004a80:	fffff097          	auipc	ra,0xfffff
    80004a84:	d92080e7          	jalr	-622(ra) # 80003812 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a88:	2905                	addiw	s2,s2,1
    80004a8a:	0a91                	addi	s5,s5,4
    80004a8c:	02ca2783          	lw	a5,44(s4)
    80004a90:	f8f94ee3          	blt	s2,a5,80004a2c <end_op+0xdc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004a94:	00000097          	auipc	ra,0x0
    80004a98:	c70080e7          	jalr	-912(ra) # 80004704 <write_head>
    install_trans(0); // Now install writes to home locations
    80004a9c:	4501                	li	a0,0
    80004a9e:	00000097          	auipc	ra,0x0
    80004aa2:	cd0080e7          	jalr	-816(ra) # 8000476e <install_trans>
    log.lh.n = 0;
    80004aa6:	00047797          	auipc	a5,0x47
    80004aaa:	4807ab23          	sw	zero,1174(a5) # 8004bf3c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004aae:	00000097          	auipc	ra,0x0
    80004ab2:	c56080e7          	jalr	-938(ra) # 80004704 <write_head>
    80004ab6:	69e2                	ld	s3,24(sp)
    80004ab8:	6a42                	ld	s4,16(sp)
    80004aba:	6aa2                	ld	s5,8(sp)
    80004abc:	bdf9                	j	8000499a <end_op+0x4a>

0000000080004abe <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004abe:	1101                	addi	sp,sp,-32
    80004ac0:	ec06                	sd	ra,24(sp)
    80004ac2:	e822                	sd	s0,16(sp)
    80004ac4:	e426                	sd	s1,8(sp)
    80004ac6:	1000                	addi	s0,sp,32
    80004ac8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004aca:	00047517          	auipc	a0,0x47
    80004ace:	44650513          	addi	a0,a0,1094 # 8004bf10 <log>
    80004ad2:	ffffc097          	auipc	ra,0xffffc
    80004ad6:	18a080e7          	jalr	394(ra) # 80000c5c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004ada:	00047617          	auipc	a2,0x47
    80004ade:	46262603          	lw	a2,1122(a2) # 8004bf3c <log+0x2c>
    80004ae2:	47f5                	li	a5,29
    80004ae4:	06c7c663          	blt	a5,a2,80004b50 <log_write+0x92>
    80004ae8:	00047797          	auipc	a5,0x47
    80004aec:	4447a783          	lw	a5,1092(a5) # 8004bf2c <log+0x1c>
    80004af0:	37fd                	addiw	a5,a5,-1
    80004af2:	04f65f63          	bge	a2,a5,80004b50 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004af6:	00047797          	auipc	a5,0x47
    80004afa:	43a7a783          	lw	a5,1082(a5) # 8004bf30 <log+0x20>
    80004afe:	06f05163          	blez	a5,80004b60 <log_write+0xa2>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004b02:	4781                	li	a5,0
    80004b04:	06c05663          	blez	a2,80004b70 <log_write+0xb2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b08:	44cc                	lw	a1,12(s1)
    80004b0a:	00047717          	auipc	a4,0x47
    80004b0e:	43670713          	addi	a4,a4,1078 # 8004bf40 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004b12:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b14:	4314                	lw	a3,0(a4)
    80004b16:	04b68d63          	beq	a3,a1,80004b70 <log_write+0xb2>
  for (i = 0; i < log.lh.n; i++) {
    80004b1a:	2785                	addiw	a5,a5,1
    80004b1c:	0711                	addi	a4,a4,4
    80004b1e:	fef61be3          	bne	a2,a5,80004b14 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004b22:	060a                	slli	a2,a2,0x2
    80004b24:	02060613          	addi	a2,a2,32
    80004b28:	00047797          	auipc	a5,0x47
    80004b2c:	3e878793          	addi	a5,a5,1000 # 8004bf10 <log>
    80004b30:	97b2                	add	a5,a5,a2
    80004b32:	44d8                	lw	a4,12(s1)
    80004b34:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004b36:	8526                	mv	a0,s1
    80004b38:	fffff097          	auipc	ra,0xfffff
    80004b3c:	d72080e7          	jalr	-654(ra) # 800038aa <bpin>
    log.lh.n++;
    80004b40:	00047717          	auipc	a4,0x47
    80004b44:	3d070713          	addi	a4,a4,976 # 8004bf10 <log>
    80004b48:	575c                	lw	a5,44(a4)
    80004b4a:	2785                	addiw	a5,a5,1
    80004b4c:	d75c                	sw	a5,44(a4)
    80004b4e:	a835                	j	80004b8a <log_write+0xcc>
    panic("too big a transaction");
    80004b50:	00004517          	auipc	a0,0x4
    80004b54:	b8050513          	addi	a0,a0,-1152 # 800086d0 <etext+0x6d0>
    80004b58:	ffffc097          	auipc	ra,0xffffc
    80004b5c:	a06080e7          	jalr	-1530(ra) # 8000055e <panic>
    panic("log_write outside of trans");
    80004b60:	00004517          	auipc	a0,0x4
    80004b64:	b8850513          	addi	a0,a0,-1144 # 800086e8 <etext+0x6e8>
    80004b68:	ffffc097          	auipc	ra,0xffffc
    80004b6c:	9f6080e7          	jalr	-1546(ra) # 8000055e <panic>
  log.lh.block[i] = b->blockno;
    80004b70:	00279693          	slli	a3,a5,0x2
    80004b74:	02068693          	addi	a3,a3,32
    80004b78:	00047717          	auipc	a4,0x47
    80004b7c:	39870713          	addi	a4,a4,920 # 8004bf10 <log>
    80004b80:	9736                	add	a4,a4,a3
    80004b82:	44d4                	lw	a3,12(s1)
    80004b84:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004b86:	faf608e3          	beq	a2,a5,80004b36 <log_write+0x78>
  }
  release(&log.lock);
    80004b8a:	00047517          	auipc	a0,0x47
    80004b8e:	38650513          	addi	a0,a0,902 # 8004bf10 <log>
    80004b92:	ffffc097          	auipc	ra,0xffffc
    80004b96:	17a080e7          	jalr	378(ra) # 80000d0c <release>
}
    80004b9a:	60e2                	ld	ra,24(sp)
    80004b9c:	6442                	ld	s0,16(sp)
    80004b9e:	64a2                	ld	s1,8(sp)
    80004ba0:	6105                	addi	sp,sp,32
    80004ba2:	8082                	ret

0000000080004ba4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004ba4:	1101                	addi	sp,sp,-32
    80004ba6:	ec06                	sd	ra,24(sp)
    80004ba8:	e822                	sd	s0,16(sp)
    80004baa:	e426                	sd	s1,8(sp)
    80004bac:	e04a                	sd	s2,0(sp)
    80004bae:	1000                	addi	s0,sp,32
    80004bb0:	84aa                	mv	s1,a0
    80004bb2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004bb4:	00004597          	auipc	a1,0x4
    80004bb8:	b5458593          	addi	a1,a1,-1196 # 80008708 <etext+0x708>
    80004bbc:	0521                	addi	a0,a0,8
    80004bbe:	ffffc097          	auipc	ra,0xffffc
    80004bc2:	004080e7          	jalr	4(ra) # 80000bc2 <initlock>
  lk->name = name;
    80004bc6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004bca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004bce:	0204a423          	sw	zero,40(s1)
}
    80004bd2:	60e2                	ld	ra,24(sp)
    80004bd4:	6442                	ld	s0,16(sp)
    80004bd6:	64a2                	ld	s1,8(sp)
    80004bd8:	6902                	ld	s2,0(sp)
    80004bda:	6105                	addi	sp,sp,32
    80004bdc:	8082                	ret

0000000080004bde <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004bde:	1101                	addi	sp,sp,-32
    80004be0:	ec06                	sd	ra,24(sp)
    80004be2:	e822                	sd	s0,16(sp)
    80004be4:	e426                	sd	s1,8(sp)
    80004be6:	e04a                	sd	s2,0(sp)
    80004be8:	1000                	addi	s0,sp,32
    80004bea:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004bec:	00850913          	addi	s2,a0,8
    80004bf0:	854a                	mv	a0,s2
    80004bf2:	ffffc097          	auipc	ra,0xffffc
    80004bf6:	06a080e7          	jalr	106(ra) # 80000c5c <acquire>
  while (lk->locked) {
    80004bfa:	409c                	lw	a5,0(s1)
    80004bfc:	cb89                	beqz	a5,80004c0e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004bfe:	85ca                	mv	a1,s2
    80004c00:	8526                	mv	a0,s1
    80004c02:	ffffd097          	auipc	ra,0xffffd
    80004c06:	7fa080e7          	jalr	2042(ra) # 800023fc <sleep>
  while (lk->locked) {
    80004c0a:	409c                	lw	a5,0(s1)
    80004c0c:	fbed                	bnez	a5,80004bfe <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004c0e:	4785                	li	a5,1
    80004c10:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004c12:	ffffd097          	auipc	ra,0xffffd
    80004c16:	f7a080e7          	jalr	-134(ra) # 80001b8c <myproc>
    80004c1a:	591c                	lw	a5,48(a0)
    80004c1c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004c1e:	854a                	mv	a0,s2
    80004c20:	ffffc097          	auipc	ra,0xffffc
    80004c24:	0ec080e7          	jalr	236(ra) # 80000d0c <release>
}
    80004c28:	60e2                	ld	ra,24(sp)
    80004c2a:	6442                	ld	s0,16(sp)
    80004c2c:	64a2                	ld	s1,8(sp)
    80004c2e:	6902                	ld	s2,0(sp)
    80004c30:	6105                	addi	sp,sp,32
    80004c32:	8082                	ret

0000000080004c34 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004c34:	1101                	addi	sp,sp,-32
    80004c36:	ec06                	sd	ra,24(sp)
    80004c38:	e822                	sd	s0,16(sp)
    80004c3a:	e426                	sd	s1,8(sp)
    80004c3c:	e04a                	sd	s2,0(sp)
    80004c3e:	1000                	addi	s0,sp,32
    80004c40:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c42:	00850913          	addi	s2,a0,8
    80004c46:	854a                	mv	a0,s2
    80004c48:	ffffc097          	auipc	ra,0xffffc
    80004c4c:	014080e7          	jalr	20(ra) # 80000c5c <acquire>
  lk->locked = 0;
    80004c50:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004c54:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004c58:	8526                	mv	a0,s1
    80004c5a:	ffffe097          	auipc	ra,0xffffe
    80004c5e:	806080e7          	jalr	-2042(ra) # 80002460 <wakeup>
  release(&lk->lk);
    80004c62:	854a                	mv	a0,s2
    80004c64:	ffffc097          	auipc	ra,0xffffc
    80004c68:	0a8080e7          	jalr	168(ra) # 80000d0c <release>
}
    80004c6c:	60e2                	ld	ra,24(sp)
    80004c6e:	6442                	ld	s0,16(sp)
    80004c70:	64a2                	ld	s1,8(sp)
    80004c72:	6902                	ld	s2,0(sp)
    80004c74:	6105                	addi	sp,sp,32
    80004c76:	8082                	ret

0000000080004c78 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004c78:	7179                	addi	sp,sp,-48
    80004c7a:	f406                	sd	ra,40(sp)
    80004c7c:	f022                	sd	s0,32(sp)
    80004c7e:	ec26                	sd	s1,24(sp)
    80004c80:	e84a                	sd	s2,16(sp)
    80004c82:	1800                	addi	s0,sp,48
    80004c84:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004c86:	00850913          	addi	s2,a0,8
    80004c8a:	854a                	mv	a0,s2
    80004c8c:	ffffc097          	auipc	ra,0xffffc
    80004c90:	fd0080e7          	jalr	-48(ra) # 80000c5c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004c94:	409c                	lw	a5,0(s1)
    80004c96:	ef91                	bnez	a5,80004cb2 <holdingsleep+0x3a>
    80004c98:	4481                	li	s1,0
  release(&lk->lk);
    80004c9a:	854a                	mv	a0,s2
    80004c9c:	ffffc097          	auipc	ra,0xffffc
    80004ca0:	070080e7          	jalr	112(ra) # 80000d0c <release>
  return r;
}
    80004ca4:	8526                	mv	a0,s1
    80004ca6:	70a2                	ld	ra,40(sp)
    80004ca8:	7402                	ld	s0,32(sp)
    80004caa:	64e2                	ld	s1,24(sp)
    80004cac:	6942                	ld	s2,16(sp)
    80004cae:	6145                	addi	sp,sp,48
    80004cb0:	8082                	ret
    80004cb2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004cb4:	0284a983          	lw	s3,40(s1)
    80004cb8:	ffffd097          	auipc	ra,0xffffd
    80004cbc:	ed4080e7          	jalr	-300(ra) # 80001b8c <myproc>
    80004cc0:	5904                	lw	s1,48(a0)
    80004cc2:	413484b3          	sub	s1,s1,s3
    80004cc6:	0014b493          	seqz	s1,s1
    80004cca:	69a2                	ld	s3,8(sp)
    80004ccc:	b7f9                	j	80004c9a <holdingsleep+0x22>

0000000080004cce <readcountinit>:
struct spinlock readcntlock;
uint readcount;  // wraps naturally on overflow

void
readcountinit(void)
{
    80004cce:	1141                	addi	sp,sp,-16
    80004cd0:	e406                	sd	ra,8(sp)
    80004cd2:	e022                	sd	s0,0(sp)
    80004cd4:	0800                	addi	s0,sp,16
  initlock(&readcntlock, "readcnt");
    80004cd6:	00004597          	auipc	a1,0x4
    80004cda:	a4258593          	addi	a1,a1,-1470 # 80008718 <etext+0x718>
    80004cde:	00047517          	auipc	a0,0x47
    80004ce2:	2da50513          	addi	a0,a0,730 # 8004bfb8 <readcntlock>
    80004ce6:	ffffc097          	auipc	ra,0xffffc
    80004cea:	edc080e7          	jalr	-292(ra) # 80000bc2 <initlock>
  readcount = 0;
    80004cee:	00004797          	auipc	a5,0x4
    80004cf2:	e407ab23          	sw	zero,-426(a5) # 80008b44 <readcount>
}
    80004cf6:	60a2                	ld	ra,8(sp)
    80004cf8:	6402                	ld	s0,0(sp)
    80004cfa:	0141                	addi	sp,sp,16
    80004cfc:	8082                	ret

0000000080004cfe <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004cfe:	1141                	addi	sp,sp,-16
    80004d00:	e406                	sd	ra,8(sp)
    80004d02:	e022                	sd	s0,0(sp)
    80004d04:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004d06:	00004597          	auipc	a1,0x4
    80004d0a:	a1a58593          	addi	a1,a1,-1510 # 80008720 <etext+0x720>
    80004d0e:	00047517          	auipc	a0,0x47
    80004d12:	36250513          	addi	a0,a0,866 # 8004c070 <ftable>
    80004d16:	ffffc097          	auipc	ra,0xffffc
    80004d1a:	eac080e7          	jalr	-340(ra) # 80000bc2 <initlock>
  readcountinit();
    80004d1e:	00000097          	auipc	ra,0x0
    80004d22:	fb0080e7          	jalr	-80(ra) # 80004cce <readcountinit>
}
    80004d26:	60a2                	ld	ra,8(sp)
    80004d28:	6402                	ld	s0,0(sp)
    80004d2a:	0141                	addi	sp,sp,16
    80004d2c:	8082                	ret

0000000080004d2e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004d2e:	1101                	addi	sp,sp,-32
    80004d30:	ec06                	sd	ra,24(sp)
    80004d32:	e822                	sd	s0,16(sp)
    80004d34:	e426                	sd	s1,8(sp)
    80004d36:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004d38:	00047517          	auipc	a0,0x47
    80004d3c:	33850513          	addi	a0,a0,824 # 8004c070 <ftable>
    80004d40:	ffffc097          	auipc	ra,0xffffc
    80004d44:	f1c080e7          	jalr	-228(ra) # 80000c5c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d48:	00047497          	auipc	s1,0x47
    80004d4c:	34048493          	addi	s1,s1,832 # 8004c088 <ftable+0x18>
    80004d50:	00048717          	auipc	a4,0x48
    80004d54:	2d870713          	addi	a4,a4,728 # 8004d028 <disk>
    if(f->ref == 0){
    80004d58:	40dc                	lw	a5,4(s1)
    80004d5a:	cf99                	beqz	a5,80004d78 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d5c:	02848493          	addi	s1,s1,40
    80004d60:	fee49ce3          	bne	s1,a4,80004d58 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004d64:	00047517          	auipc	a0,0x47
    80004d68:	30c50513          	addi	a0,a0,780 # 8004c070 <ftable>
    80004d6c:	ffffc097          	auipc	ra,0xffffc
    80004d70:	fa0080e7          	jalr	-96(ra) # 80000d0c <release>
  return 0;
    80004d74:	4481                	li	s1,0
    80004d76:	a819                	j	80004d8c <filealloc+0x5e>
      f->ref = 1;
    80004d78:	4785                	li	a5,1
    80004d7a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004d7c:	00047517          	auipc	a0,0x47
    80004d80:	2f450513          	addi	a0,a0,756 # 8004c070 <ftable>
    80004d84:	ffffc097          	auipc	ra,0xffffc
    80004d88:	f88080e7          	jalr	-120(ra) # 80000d0c <release>
}
    80004d8c:	8526                	mv	a0,s1
    80004d8e:	60e2                	ld	ra,24(sp)
    80004d90:	6442                	ld	s0,16(sp)
    80004d92:	64a2                	ld	s1,8(sp)
    80004d94:	6105                	addi	sp,sp,32
    80004d96:	8082                	ret

0000000080004d98 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004d98:	1101                	addi	sp,sp,-32
    80004d9a:	ec06                	sd	ra,24(sp)
    80004d9c:	e822                	sd	s0,16(sp)
    80004d9e:	e426                	sd	s1,8(sp)
    80004da0:	1000                	addi	s0,sp,32
    80004da2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004da4:	00047517          	auipc	a0,0x47
    80004da8:	2cc50513          	addi	a0,a0,716 # 8004c070 <ftable>
    80004dac:	ffffc097          	auipc	ra,0xffffc
    80004db0:	eb0080e7          	jalr	-336(ra) # 80000c5c <acquire>
  if(f->ref < 1)
    80004db4:	40dc                	lw	a5,4(s1)
    80004db6:	02f05263          	blez	a5,80004dda <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004dba:	2785                	addiw	a5,a5,1
    80004dbc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004dbe:	00047517          	auipc	a0,0x47
    80004dc2:	2b250513          	addi	a0,a0,690 # 8004c070 <ftable>
    80004dc6:	ffffc097          	auipc	ra,0xffffc
    80004dca:	f46080e7          	jalr	-186(ra) # 80000d0c <release>
  return f;
}
    80004dce:	8526                	mv	a0,s1
    80004dd0:	60e2                	ld	ra,24(sp)
    80004dd2:	6442                	ld	s0,16(sp)
    80004dd4:	64a2                	ld	s1,8(sp)
    80004dd6:	6105                	addi	sp,sp,32
    80004dd8:	8082                	ret
    panic("filedup");
    80004dda:	00004517          	auipc	a0,0x4
    80004dde:	94e50513          	addi	a0,a0,-1714 # 80008728 <etext+0x728>
    80004de2:	ffffb097          	auipc	ra,0xffffb
    80004de6:	77c080e7          	jalr	1916(ra) # 8000055e <panic>

0000000080004dea <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004dea:	7139                	addi	sp,sp,-64
    80004dec:	fc06                	sd	ra,56(sp)
    80004dee:	f822                	sd	s0,48(sp)
    80004df0:	f426                	sd	s1,40(sp)
    80004df2:	0080                	addi	s0,sp,64
    80004df4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004df6:	00047517          	auipc	a0,0x47
    80004dfa:	27a50513          	addi	a0,a0,634 # 8004c070 <ftable>
    80004dfe:	ffffc097          	auipc	ra,0xffffc
    80004e02:	e5e080e7          	jalr	-418(ra) # 80000c5c <acquire>
  if(f->ref < 1)
    80004e06:	40dc                	lw	a5,4(s1)
    80004e08:	04f05c63          	blez	a5,80004e60 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004e0c:	37fd                	addiw	a5,a5,-1
    80004e0e:	c0dc                	sw	a5,4(s1)
    80004e10:	06f04463          	bgtz	a5,80004e78 <fileclose+0x8e>
    80004e14:	f04a                	sd	s2,32(sp)
    80004e16:	ec4e                	sd	s3,24(sp)
    80004e18:	e852                	sd	s4,16(sp)
    80004e1a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004e1c:	0004a903          	lw	s2,0(s1)
    80004e20:	0094c783          	lbu	a5,9(s1)
    80004e24:	89be                	mv	s3,a5
    80004e26:	689c                	ld	a5,16(s1)
    80004e28:	8a3e                	mv	s4,a5
    80004e2a:	6c9c                	ld	a5,24(s1)
    80004e2c:	8abe                	mv	s5,a5
  f->ref = 0;
    80004e2e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004e32:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004e36:	00047517          	auipc	a0,0x47
    80004e3a:	23a50513          	addi	a0,a0,570 # 8004c070 <ftable>
    80004e3e:	ffffc097          	auipc	ra,0xffffc
    80004e42:	ece080e7          	jalr	-306(ra) # 80000d0c <release>

  if(ff.type == FD_PIPE){
    80004e46:	4785                	li	a5,1
    80004e48:	04f90563          	beq	s2,a5,80004e92 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004e4c:	ffe9079b          	addiw	a5,s2,-2
    80004e50:	4705                	li	a4,1
    80004e52:	04f77b63          	bgeu	a4,a5,80004ea8 <fileclose+0xbe>
    80004e56:	7902                	ld	s2,32(sp)
    80004e58:	69e2                	ld	s3,24(sp)
    80004e5a:	6a42                	ld	s4,16(sp)
    80004e5c:	6aa2                	ld	s5,8(sp)
    80004e5e:	a02d                	j	80004e88 <fileclose+0x9e>
    80004e60:	f04a                	sd	s2,32(sp)
    80004e62:	ec4e                	sd	s3,24(sp)
    80004e64:	e852                	sd	s4,16(sp)
    80004e66:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004e68:	00004517          	auipc	a0,0x4
    80004e6c:	8c850513          	addi	a0,a0,-1848 # 80008730 <etext+0x730>
    80004e70:	ffffb097          	auipc	ra,0xffffb
    80004e74:	6ee080e7          	jalr	1774(ra) # 8000055e <panic>
    release(&ftable.lock);
    80004e78:	00047517          	auipc	a0,0x47
    80004e7c:	1f850513          	addi	a0,a0,504 # 8004c070 <ftable>
    80004e80:	ffffc097          	auipc	ra,0xffffc
    80004e84:	e8c080e7          	jalr	-372(ra) # 80000d0c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004e88:	70e2                	ld	ra,56(sp)
    80004e8a:	7442                	ld	s0,48(sp)
    80004e8c:	74a2                	ld	s1,40(sp)
    80004e8e:	6121                	addi	sp,sp,64
    80004e90:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004e92:	85ce                	mv	a1,s3
    80004e94:	8552                	mv	a0,s4
    80004e96:	00000097          	auipc	ra,0x0
    80004e9a:	43e080e7          	jalr	1086(ra) # 800052d4 <pipeclose>
    80004e9e:	7902                	ld	s2,32(sp)
    80004ea0:	69e2                	ld	s3,24(sp)
    80004ea2:	6a42                	ld	s4,16(sp)
    80004ea4:	6aa2                	ld	s5,8(sp)
    80004ea6:	b7cd                	j	80004e88 <fileclose+0x9e>
    begin_op();
    80004ea8:	00000097          	auipc	ra,0x0
    80004eac:	a28080e7          	jalr	-1496(ra) # 800048d0 <begin_op>
    iput(ff.ip);
    80004eb0:	8556                	mv	a0,s5
    80004eb2:	fffff097          	auipc	ra,0xfffff
    80004eb6:	1ec080e7          	jalr	492(ra) # 8000409e <iput>
    end_op();
    80004eba:	00000097          	auipc	ra,0x0
    80004ebe:	a96080e7          	jalr	-1386(ra) # 80004950 <end_op>
    80004ec2:	7902                	ld	s2,32(sp)
    80004ec4:	69e2                	ld	s3,24(sp)
    80004ec6:	6a42                	ld	s4,16(sp)
    80004ec8:	6aa2                	ld	s5,8(sp)
    80004eca:	bf7d                	j	80004e88 <fileclose+0x9e>

0000000080004ecc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004ecc:	715d                	addi	sp,sp,-80
    80004ece:	e486                	sd	ra,72(sp)
    80004ed0:	e0a2                	sd	s0,64(sp)
    80004ed2:	fc26                	sd	s1,56(sp)
    80004ed4:	f052                	sd	s4,32(sp)
    80004ed6:	0880                	addi	s0,sp,80
    80004ed8:	84aa                	mv	s1,a0
    80004eda:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004edc:	ffffd097          	auipc	ra,0xffffd
    80004ee0:	cb0080e7          	jalr	-848(ra) # 80001b8c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004ee4:	409c                	lw	a5,0(s1)
    80004ee6:	37f9                	addiw	a5,a5,-2
    80004ee8:	4705                	li	a4,1
    80004eea:	04f76a63          	bltu	a4,a5,80004f3e <filestat+0x72>
    80004eee:	f84a                	sd	s2,48(sp)
    80004ef0:	f44e                	sd	s3,40(sp)
    80004ef2:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004ef4:	6c88                	ld	a0,24(s1)
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	fea080e7          	jalr	-22(ra) # 80003ee0 <ilock>
    stati(f->ip, &st);
    80004efe:	fb840913          	addi	s2,s0,-72
    80004f02:	85ca                	mv	a1,s2
    80004f04:	6c88                	ld	a0,24(s1)
    80004f06:	fffff097          	auipc	ra,0xfffff
    80004f0a:	26a080e7          	jalr	618(ra) # 80004170 <stati>
    iunlock(f->ip);
    80004f0e:	6c88                	ld	a0,24(s1)
    80004f10:	fffff097          	auipc	ra,0xfffff
    80004f14:	096080e7          	jalr	150(ra) # 80003fa6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004f18:	46e1                	li	a3,24
    80004f1a:	864a                	mv	a2,s2
    80004f1c:	85d2                	mv	a1,s4
    80004f1e:	0509b503          	ld	a0,80(s3)
    80004f22:	ffffc097          	auipc	ra,0xffffc
    80004f26:	7f6080e7          	jalr	2038(ra) # 80001718 <copyout>
    80004f2a:	41f5551b          	sraiw	a0,a0,0x1f
    80004f2e:	7942                	ld	s2,48(sp)
    80004f30:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004f32:	60a6                	ld	ra,72(sp)
    80004f34:	6406                	ld	s0,64(sp)
    80004f36:	74e2                	ld	s1,56(sp)
    80004f38:	7a02                	ld	s4,32(sp)
    80004f3a:	6161                	addi	sp,sp,80
    80004f3c:	8082                	ret
  return -1;
    80004f3e:	557d                	li	a0,-1
    80004f40:	bfcd                	j	80004f32 <filestat+0x66>

0000000080004f42 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004f42:	7179                	addi	sp,sp,-48
    80004f44:	f406                	sd	ra,40(sp)
    80004f46:	f022                	sd	s0,32(sp)
    80004f48:	e84a                	sd	s2,16(sp)
    80004f4a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004f4c:	00854783          	lbu	a5,8(a0)
    80004f50:	cbc5                	beqz	a5,80005000 <fileread+0xbe>
    80004f52:	ec26                	sd	s1,24(sp)
    80004f54:	e44e                	sd	s3,8(sp)
    80004f56:	84aa                	mv	s1,a0
    80004f58:	892e                	mv	s2,a1
    80004f5a:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f5c:	411c                	lw	a5,0(a0)
    80004f5e:	4705                	li	a4,1
    80004f60:	04e78963          	beq	a5,a4,80004fb2 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f64:	470d                	li	a4,3
    80004f66:	04e78f63          	beq	a5,a4,80004fc4 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f6a:	4709                	li	a4,2
    80004f6c:	08e79263          	bne	a5,a4,80004ff0 <fileread+0xae>
    ilock(f->ip);
    80004f70:	6d08                	ld	a0,24(a0)
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	f6e080e7          	jalr	-146(ra) # 80003ee0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004f7a:	874e                	mv	a4,s3
    80004f7c:	5094                	lw	a3,32(s1)
    80004f7e:	864a                	mv	a2,s2
    80004f80:	4585                	li	a1,1
    80004f82:	6c88                	ld	a0,24(s1)
    80004f84:	fffff097          	auipc	ra,0xfffff
    80004f88:	21a080e7          	jalr	538(ra) # 8000419e <readi>
    80004f8c:	892a                	mv	s2,a0
    80004f8e:	00a05563          	blez	a0,80004f98 <fileread+0x56>
      f->off += r;
    80004f92:	509c                	lw	a5,32(s1)
    80004f94:	9fa9                	addw	a5,a5,a0
    80004f96:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004f98:	6c88                	ld	a0,24(s1)
    80004f9a:	fffff097          	auipc	ra,0xfffff
    80004f9e:	00c080e7          	jalr	12(ra) # 80003fa6 <iunlock>
    80004fa2:	64e2                	ld	s1,24(sp)
    80004fa4:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004fa6:	854a                	mv	a0,s2
    80004fa8:	70a2                	ld	ra,40(sp)
    80004faa:	7402                	ld	s0,32(sp)
    80004fac:	6942                	ld	s2,16(sp)
    80004fae:	6145                	addi	sp,sp,48
    80004fb0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004fb2:	6908                	ld	a0,16(a0)
    80004fb4:	00000097          	auipc	ra,0x0
    80004fb8:	4b2080e7          	jalr	1202(ra) # 80005466 <piperead>
    80004fbc:	892a                	mv	s2,a0
    80004fbe:	64e2                	ld	s1,24(sp)
    80004fc0:	69a2                	ld	s3,8(sp)
    80004fc2:	b7d5                	j	80004fa6 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004fc4:	02451783          	lh	a5,36(a0)
    80004fc8:	03079693          	slli	a3,a5,0x30
    80004fcc:	92c1                	srli	a3,a3,0x30
    80004fce:	4725                	li	a4,9
    80004fd0:	02d76b63          	bltu	a4,a3,80005006 <fileread+0xc4>
    80004fd4:	0792                	slli	a5,a5,0x4
    80004fd6:	00047717          	auipc	a4,0x47
    80004fda:	fe270713          	addi	a4,a4,-30 # 8004bfb8 <readcntlock>
    80004fde:	97ba                	add	a5,a5,a4
    80004fe0:	6f9c                	ld	a5,24(a5)
    80004fe2:	c79d                	beqz	a5,80005010 <fileread+0xce>
    r = devsw[f->major].read(1, addr, n);
    80004fe4:	4505                	li	a0,1
    80004fe6:	9782                	jalr	a5
    80004fe8:	892a                	mv	s2,a0
    80004fea:	64e2                	ld	s1,24(sp)
    80004fec:	69a2                	ld	s3,8(sp)
    80004fee:	bf65                	j	80004fa6 <fileread+0x64>
    panic("fileread");
    80004ff0:	00003517          	auipc	a0,0x3
    80004ff4:	75050513          	addi	a0,a0,1872 # 80008740 <etext+0x740>
    80004ff8:	ffffb097          	auipc	ra,0xffffb
    80004ffc:	566080e7          	jalr	1382(ra) # 8000055e <panic>
    return -1;
    80005000:	57fd                	li	a5,-1
    80005002:	893e                	mv	s2,a5
    80005004:	b74d                	j	80004fa6 <fileread+0x64>
      return -1;
    80005006:	57fd                	li	a5,-1
    80005008:	893e                	mv	s2,a5
    8000500a:	64e2                	ld	s1,24(sp)
    8000500c:	69a2                	ld	s3,8(sp)
    8000500e:	bf61                	j	80004fa6 <fileread+0x64>
    80005010:	57fd                	li	a5,-1
    80005012:	893e                	mv	s2,a5
    80005014:	64e2                	ld	s1,24(sp)
    80005016:	69a2                	ld	s3,8(sp)
    80005018:	b779                	j	80004fa6 <fileread+0x64>

000000008000501a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000501a:	00954783          	lbu	a5,9(a0)
    8000501e:	12078d63          	beqz	a5,80005158 <filewrite+0x13e>
{
    80005022:	711d                	addi	sp,sp,-96
    80005024:	ec86                	sd	ra,88(sp)
    80005026:	e8a2                	sd	s0,80(sp)
    80005028:	e0ca                	sd	s2,64(sp)
    8000502a:	f456                	sd	s5,40(sp)
    8000502c:	f05a                	sd	s6,32(sp)
    8000502e:	1080                	addi	s0,sp,96
    80005030:	892a                	mv	s2,a0
    80005032:	8b2e                	mv	s6,a1
    80005034:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80005036:	411c                	lw	a5,0(a0)
    80005038:	4705                	li	a4,1
    8000503a:	02e78a63          	beq	a5,a4,8000506e <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000503e:	470d                	li	a4,3
    80005040:	02e78d63          	beq	a5,a4,8000507a <filewrite+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005044:	4709                	li	a4,2
    80005046:	0ee79b63          	bne	a5,a4,8000513c <filewrite+0x122>
    8000504a:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000504c:	0cc05663          	blez	a2,80005118 <filewrite+0xfe>
    80005050:	e4a6                	sd	s1,72(sp)
    80005052:	fc4e                	sd	s3,56(sp)
    80005054:	ec5e                	sd	s7,24(sp)
    80005056:	e862                	sd	s8,16(sp)
    80005058:	e466                	sd	s9,8(sp)
    int i = 0;
    8000505a:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    8000505c:	6b85                	lui	s7,0x1
    8000505e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005062:	6785                	lui	a5,0x1
    80005064:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80005068:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000506a:	4c05                	li	s8,1
    8000506c:	a849                	j	800050fe <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    8000506e:	6908                	ld	a0,16(a0)
    80005070:	00000097          	auipc	ra,0x0
    80005074:	2da080e7          	jalr	730(ra) # 8000534a <pipewrite>
    80005078:	a85d                	j	8000512e <filewrite+0x114>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000507a:	02451783          	lh	a5,36(a0)
    8000507e:	03079693          	slli	a3,a5,0x30
    80005082:	92c1                	srli	a3,a3,0x30
    80005084:	4725                	li	a4,9
    80005086:	0cd76b63          	bltu	a4,a3,8000515c <filewrite+0x142>
    8000508a:	0792                	slli	a5,a5,0x4
    8000508c:	00047717          	auipc	a4,0x47
    80005090:	f2c70713          	addi	a4,a4,-212 # 8004bfb8 <readcntlock>
    80005094:	97ba                	add	a5,a5,a4
    80005096:	739c                	ld	a5,32(a5)
    80005098:	c7e1                	beqz	a5,80005160 <filewrite+0x146>
    ret = devsw[f->major].write(1, addr, n);
    8000509a:	4505                	li	a0,1
    8000509c:	9782                	jalr	a5
    8000509e:	a841                	j	8000512e <filewrite+0x114>
      if(n1 > max)
    800050a0:	2981                	sext.w	s3,s3
      begin_op();
    800050a2:	00000097          	auipc	ra,0x0
    800050a6:	82e080e7          	jalr	-2002(ra) # 800048d0 <begin_op>
      ilock(f->ip);
    800050aa:	01893503          	ld	a0,24(s2)
    800050ae:	fffff097          	auipc	ra,0xfffff
    800050b2:	e32080e7          	jalr	-462(ra) # 80003ee0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800050b6:	874e                	mv	a4,s3
    800050b8:	02092683          	lw	a3,32(s2)
    800050bc:	016a0633          	add	a2,s4,s6
    800050c0:	85e2                	mv	a1,s8
    800050c2:	01893503          	ld	a0,24(s2)
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	1de080e7          	jalr	478(ra) # 800042a4 <writei>
    800050ce:	84aa                	mv	s1,a0
    800050d0:	00a05763          	blez	a0,800050de <filewrite+0xc4>
        f->off += r;
    800050d4:	02092783          	lw	a5,32(s2)
    800050d8:	9fa9                	addw	a5,a5,a0
    800050da:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800050de:	01893503          	ld	a0,24(s2)
    800050e2:	fffff097          	auipc	ra,0xfffff
    800050e6:	ec4080e7          	jalr	-316(ra) # 80003fa6 <iunlock>
      end_op();
    800050ea:	00000097          	auipc	ra,0x0
    800050ee:	866080e7          	jalr	-1946(ra) # 80004950 <end_op>

      if(r != n1){
    800050f2:	02999563          	bne	s3,s1,8000511c <filewrite+0x102>
        // error from writei
        break;
      }
      i += r;
    800050f6:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800050fa:	015a5963          	bge	s4,s5,8000510c <filewrite+0xf2>
      int n1 = n - i;
    800050fe:	414a87bb          	subw	a5,s5,s4
    80005102:	89be                	mv	s3,a5
      if(n1 > max)
    80005104:	f8fbdee3          	bge	s7,a5,800050a0 <filewrite+0x86>
    80005108:	89e6                	mv	s3,s9
    8000510a:	bf59                	j	800050a0 <filewrite+0x86>
    8000510c:	64a6                	ld	s1,72(sp)
    8000510e:	79e2                	ld	s3,56(sp)
    80005110:	6be2                	ld	s7,24(sp)
    80005112:	6c42                	ld	s8,16(sp)
    80005114:	6ca2                	ld	s9,8(sp)
    80005116:	a801                	j	80005126 <filewrite+0x10c>
    int i = 0;
    80005118:	4a01                	li	s4,0
    8000511a:	a031                	j	80005126 <filewrite+0x10c>
    8000511c:	64a6                	ld	s1,72(sp)
    8000511e:	79e2                	ld	s3,56(sp)
    80005120:	6be2                	ld	s7,24(sp)
    80005122:	6c42                	ld	s8,16(sp)
    80005124:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80005126:	034a9f63          	bne	s5,s4,80005164 <filewrite+0x14a>
    8000512a:	8556                	mv	a0,s5
    8000512c:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000512e:	60e6                	ld	ra,88(sp)
    80005130:	6446                	ld	s0,80(sp)
    80005132:	6906                	ld	s2,64(sp)
    80005134:	7aa2                	ld	s5,40(sp)
    80005136:	7b02                	ld	s6,32(sp)
    80005138:	6125                	addi	sp,sp,96
    8000513a:	8082                	ret
    8000513c:	e4a6                	sd	s1,72(sp)
    8000513e:	fc4e                	sd	s3,56(sp)
    80005140:	f852                	sd	s4,48(sp)
    80005142:	ec5e                	sd	s7,24(sp)
    80005144:	e862                	sd	s8,16(sp)
    80005146:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80005148:	00003517          	auipc	a0,0x3
    8000514c:	60850513          	addi	a0,a0,1544 # 80008750 <etext+0x750>
    80005150:	ffffb097          	auipc	ra,0xffffb
    80005154:	40e080e7          	jalr	1038(ra) # 8000055e <panic>
    return -1;
    80005158:	557d                	li	a0,-1
}
    8000515a:	8082                	ret
      return -1;
    8000515c:	557d                	li	a0,-1
    8000515e:	bfc1                	j	8000512e <filewrite+0x114>
    80005160:	557d                	li	a0,-1
    80005162:	b7f1                	j	8000512e <filewrite+0x114>
    ret = (i == n ? n : -1);
    80005164:	557d                	li	a0,-1
    80005166:	7a42                	ld	s4,48(sp)
    80005168:	b7d9                	j	8000512e <filewrite+0x114>

000000008000516a <add_readbytes>:

void
add_readbytes(int n)
{
  if(n <= 0) return;
    8000516a:	04a05463          	blez	a0,800051b2 <add_readbytes+0x48>
{
    8000516e:	1101                	addi	sp,sp,-32
    80005170:	ec06                	sd	ra,24(sp)
    80005172:	e822                	sd	s0,16(sp)
    80005174:	e426                	sd	s1,8(sp)
    80005176:	1000                	addi	s0,sp,32
    80005178:	84aa                	mv	s1,a0
  acquire(&readcntlock);
    8000517a:	00047517          	auipc	a0,0x47
    8000517e:	e3e50513          	addi	a0,a0,-450 # 8004bfb8 <readcntlock>
    80005182:	ffffc097          	auipc	ra,0xffffc
    80005186:	ada080e7          	jalr	-1318(ra) # 80000c5c <acquire>
  readcount += (uint)n;  // wrap on overflow (uint)
    8000518a:	00004717          	auipc	a4,0x4
    8000518e:	9ba70713          	addi	a4,a4,-1606 # 80008b44 <readcount>
    80005192:	431c                	lw	a5,0(a4)
    80005194:	9fa5                	addw	a5,a5,s1
    80005196:	c31c                	sw	a5,0(a4)
  release(&readcntlock);
    80005198:	00047517          	auipc	a0,0x47
    8000519c:	e2050513          	addi	a0,a0,-480 # 8004bfb8 <readcntlock>
    800051a0:	ffffc097          	auipc	ra,0xffffc
    800051a4:	b6c080e7          	jalr	-1172(ra) # 80000d0c <release>
}
    800051a8:	60e2                	ld	ra,24(sp)
    800051aa:	6442                	ld	s0,16(sp)
    800051ac:	64a2                	ld	s1,8(sp)
    800051ae:	6105                	addi	sp,sp,32
    800051b0:	8082                	ret
    800051b2:	8082                	ret

00000000800051b4 <get_readcount>:

uint
get_readcount(void)
{
    800051b4:	1101                	addi	sp,sp,-32
    800051b6:	ec06                	sd	ra,24(sp)
    800051b8:	e822                	sd	s0,16(sp)
    800051ba:	e426                	sd	s1,8(sp)
    800051bc:	1000                	addi	s0,sp,32
  acquire(&readcntlock);
    800051be:	00047517          	auipc	a0,0x47
    800051c2:	dfa50513          	addi	a0,a0,-518 # 8004bfb8 <readcntlock>
    800051c6:	ffffc097          	auipc	ra,0xffffc
    800051ca:	a96080e7          	jalr	-1386(ra) # 80000c5c <acquire>
  uint v = readcount;
    800051ce:	00004797          	auipc	a5,0x4
    800051d2:	9767a783          	lw	a5,-1674(a5) # 80008b44 <readcount>
    800051d6:	84be                	mv	s1,a5
  release(&readcntlock);
    800051d8:	00047517          	auipc	a0,0x47
    800051dc:	de050513          	addi	a0,a0,-544 # 8004bfb8 <readcntlock>
    800051e0:	ffffc097          	auipc	ra,0xffffc
    800051e4:	b2c080e7          	jalr	-1236(ra) # 80000d0c <release>
  return v;
}
    800051e8:	8526                	mv	a0,s1
    800051ea:	60e2                	ld	ra,24(sp)
    800051ec:	6442                	ld	s0,16(sp)
    800051ee:	64a2                	ld	s1,8(sp)
    800051f0:	6105                	addi	sp,sp,32
    800051f2:	8082                	ret

00000000800051f4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800051f4:	7179                	addi	sp,sp,-48
    800051f6:	f406                	sd	ra,40(sp)
    800051f8:	f022                	sd	s0,32(sp)
    800051fa:	ec26                	sd	s1,24(sp)
    800051fc:	e052                	sd	s4,0(sp)
    800051fe:	1800                	addi	s0,sp,48
    80005200:	84aa                	mv	s1,a0
    80005202:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005204:	0005b023          	sd	zero,0(a1)
    80005208:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000520c:	00000097          	auipc	ra,0x0
    80005210:	b22080e7          	jalr	-1246(ra) # 80004d2e <filealloc>
    80005214:	e088                	sd	a0,0(s1)
    80005216:	cd49                	beqz	a0,800052b0 <pipealloc+0xbc>
    80005218:	00000097          	auipc	ra,0x0
    8000521c:	b16080e7          	jalr	-1258(ra) # 80004d2e <filealloc>
    80005220:	00aa3023          	sd	a0,0(s4)
    80005224:	c141                	beqz	a0,800052a4 <pipealloc+0xb0>
    80005226:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005228:	ffffc097          	auipc	ra,0xffffc
    8000522c:	930080e7          	jalr	-1744(ra) # 80000b58 <kalloc>
    80005230:	892a                	mv	s2,a0
    80005232:	c13d                	beqz	a0,80005298 <pipealloc+0xa4>
    80005234:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80005236:	4985                	li	s3,1
    80005238:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000523c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005240:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005244:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80005248:	00003597          	auipc	a1,0x3
    8000524c:	26858593          	addi	a1,a1,616 # 800084b0 <etext+0x4b0>
    80005250:	ffffc097          	auipc	ra,0xffffc
    80005254:	972080e7          	jalr	-1678(ra) # 80000bc2 <initlock>
  (*f0)->type = FD_PIPE;
    80005258:	609c                	ld	a5,0(s1)
    8000525a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000525e:	609c                	ld	a5,0(s1)
    80005260:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005264:	609c                	ld	a5,0(s1)
    80005266:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000526a:	609c                	ld	a5,0(s1)
    8000526c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005270:	000a3783          	ld	a5,0(s4)
    80005274:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80005278:	000a3783          	ld	a5,0(s4)
    8000527c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005280:	000a3783          	ld	a5,0(s4)
    80005284:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80005288:	000a3783          	ld	a5,0(s4)
    8000528c:	0127b823          	sd	s2,16(a5)
  return 0;
    80005290:	4501                	li	a0,0
    80005292:	6942                	ld	s2,16(sp)
    80005294:	69a2                	ld	s3,8(sp)
    80005296:	a03d                	j	800052c4 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005298:	6088                	ld	a0,0(s1)
    8000529a:	c119                	beqz	a0,800052a0 <pipealloc+0xac>
    8000529c:	6942                	ld	s2,16(sp)
    8000529e:	a029                	j	800052a8 <pipealloc+0xb4>
    800052a0:	6942                	ld	s2,16(sp)
    800052a2:	a039                	j	800052b0 <pipealloc+0xbc>
    800052a4:	6088                	ld	a0,0(s1)
    800052a6:	c50d                	beqz	a0,800052d0 <pipealloc+0xdc>
    fileclose(*f0);
    800052a8:	00000097          	auipc	ra,0x0
    800052ac:	b42080e7          	jalr	-1214(ra) # 80004dea <fileclose>
  if(*f1)
    800052b0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800052b4:	557d                	li	a0,-1
  if(*f1)
    800052b6:	c799                	beqz	a5,800052c4 <pipealloc+0xd0>
    fileclose(*f1);
    800052b8:	853e                	mv	a0,a5
    800052ba:	00000097          	auipc	ra,0x0
    800052be:	b30080e7          	jalr	-1232(ra) # 80004dea <fileclose>
  return -1;
    800052c2:	557d                	li	a0,-1
}
    800052c4:	70a2                	ld	ra,40(sp)
    800052c6:	7402                	ld	s0,32(sp)
    800052c8:	64e2                	ld	s1,24(sp)
    800052ca:	6a02                	ld	s4,0(sp)
    800052cc:	6145                	addi	sp,sp,48
    800052ce:	8082                	ret
  return -1;
    800052d0:	557d                	li	a0,-1
    800052d2:	bfcd                	j	800052c4 <pipealloc+0xd0>

00000000800052d4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800052d4:	1101                	addi	sp,sp,-32
    800052d6:	ec06                	sd	ra,24(sp)
    800052d8:	e822                	sd	s0,16(sp)
    800052da:	e426                	sd	s1,8(sp)
    800052dc:	e04a                	sd	s2,0(sp)
    800052de:	1000                	addi	s0,sp,32
    800052e0:	84aa                	mv	s1,a0
    800052e2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800052e4:	ffffc097          	auipc	ra,0xffffc
    800052e8:	978080e7          	jalr	-1672(ra) # 80000c5c <acquire>
  if(writable){
    800052ec:	02090b63          	beqz	s2,80005322 <pipeclose+0x4e>
    pi->writeopen = 0;
    800052f0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800052f4:	21848513          	addi	a0,s1,536
    800052f8:	ffffd097          	auipc	ra,0xffffd
    800052fc:	168080e7          	jalr	360(ra) # 80002460 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005300:	2204a783          	lw	a5,544(s1)
    80005304:	e781                	bnez	a5,8000530c <pipeclose+0x38>
    80005306:	2244a783          	lw	a5,548(s1)
    8000530a:	c78d                	beqz	a5,80005334 <pipeclose+0x60>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    8000530c:	8526                	mv	a0,s1
    8000530e:	ffffc097          	auipc	ra,0xffffc
    80005312:	9fe080e7          	jalr	-1538(ra) # 80000d0c <release>
}
    80005316:	60e2                	ld	ra,24(sp)
    80005318:	6442                	ld	s0,16(sp)
    8000531a:	64a2                	ld	s1,8(sp)
    8000531c:	6902                	ld	s2,0(sp)
    8000531e:	6105                	addi	sp,sp,32
    80005320:	8082                	ret
    pi->readopen = 0;
    80005322:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005326:	21c48513          	addi	a0,s1,540
    8000532a:	ffffd097          	auipc	ra,0xffffd
    8000532e:	136080e7          	jalr	310(ra) # 80002460 <wakeup>
    80005332:	b7f9                	j	80005300 <pipeclose+0x2c>
    release(&pi->lock);
    80005334:	8526                	mv	a0,s1
    80005336:	ffffc097          	auipc	ra,0xffffc
    8000533a:	9d6080e7          	jalr	-1578(ra) # 80000d0c <release>
    kfree((char*)pi);
    8000533e:	8526                	mv	a0,s1
    80005340:	ffffb097          	auipc	ra,0xffffb
    80005344:	714080e7          	jalr	1812(ra) # 80000a54 <kfree>
    80005348:	b7f9                	j	80005316 <pipeclose+0x42>

000000008000534a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000534a:	7159                	addi	sp,sp,-112
    8000534c:	f486                	sd	ra,104(sp)
    8000534e:	f0a2                	sd	s0,96(sp)
    80005350:	eca6                	sd	s1,88(sp)
    80005352:	e8ca                	sd	s2,80(sp)
    80005354:	e4ce                	sd	s3,72(sp)
    80005356:	e0d2                	sd	s4,64(sp)
    80005358:	fc56                	sd	s5,56(sp)
    8000535a:	1880                	addi	s0,sp,112
    8000535c:	84aa                	mv	s1,a0
    8000535e:	8aae                	mv	s5,a1
    80005360:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005362:	ffffd097          	auipc	ra,0xffffd
    80005366:	82a080e7          	jalr	-2006(ra) # 80001b8c <myproc>
    8000536a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000536c:	8526                	mv	a0,s1
    8000536e:	ffffc097          	auipc	ra,0xffffc
    80005372:	8ee080e7          	jalr	-1810(ra) # 80000c5c <acquire>
  while(i < n){
    80005376:	0f405063          	blez	s4,80005456 <pipewrite+0x10c>
    8000537a:	f85a                	sd	s6,48(sp)
    8000537c:	f45e                	sd	s7,40(sp)
    8000537e:	f062                	sd	s8,32(sp)
    80005380:	ec66                	sd	s9,24(sp)
    80005382:	e86a                	sd	s10,16(sp)
  int i = 0;
    80005384:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005386:	f9f40c13          	addi	s8,s0,-97
    8000538a:	4b85                	li	s7,1
    8000538c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000538e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005392:	21c48c93          	addi	s9,s1,540
    80005396:	a099                	j	800053dc <pipewrite+0x92>
      release(&pi->lock);
    80005398:	8526                	mv	a0,s1
    8000539a:	ffffc097          	auipc	ra,0xffffc
    8000539e:	972080e7          	jalr	-1678(ra) # 80000d0c <release>
      return -1;
    800053a2:	597d                	li	s2,-1
    800053a4:	7b42                	ld	s6,48(sp)
    800053a6:	7ba2                	ld	s7,40(sp)
    800053a8:	7c02                	ld	s8,32(sp)
    800053aa:	6ce2                	ld	s9,24(sp)
    800053ac:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800053ae:	854a                	mv	a0,s2
    800053b0:	70a6                	ld	ra,104(sp)
    800053b2:	7406                	ld	s0,96(sp)
    800053b4:	64e6                	ld	s1,88(sp)
    800053b6:	6946                	ld	s2,80(sp)
    800053b8:	69a6                	ld	s3,72(sp)
    800053ba:	6a06                	ld	s4,64(sp)
    800053bc:	7ae2                	ld	s5,56(sp)
    800053be:	6165                	addi	sp,sp,112
    800053c0:	8082                	ret
      wakeup(&pi->nread);
    800053c2:	856a                	mv	a0,s10
    800053c4:	ffffd097          	auipc	ra,0xffffd
    800053c8:	09c080e7          	jalr	156(ra) # 80002460 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800053cc:	85a6                	mv	a1,s1
    800053ce:	8566                	mv	a0,s9
    800053d0:	ffffd097          	auipc	ra,0xffffd
    800053d4:	02c080e7          	jalr	44(ra) # 800023fc <sleep>
  while(i < n){
    800053d8:	05495e63          	bge	s2,s4,80005434 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    800053dc:	2204a783          	lw	a5,544(s1)
    800053e0:	dfc5                	beqz	a5,80005398 <pipewrite+0x4e>
    800053e2:	854e                	mv	a0,s3
    800053e4:	ffffd097          	auipc	ra,0xffffd
    800053e8:	36c080e7          	jalr	876(ra) # 80002750 <killed>
    800053ec:	f555                	bnez	a0,80005398 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800053ee:	2184a783          	lw	a5,536(s1)
    800053f2:	21c4a703          	lw	a4,540(s1)
    800053f6:	2007879b          	addiw	a5,a5,512
    800053fa:	fcf704e3          	beq	a4,a5,800053c2 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800053fe:	86de                	mv	a3,s7
    80005400:	01590633          	add	a2,s2,s5
    80005404:	85e2                	mv	a1,s8
    80005406:	0509b503          	ld	a0,80(s3)
    8000540a:	ffffc097          	auipc	ra,0xffffc
    8000540e:	39a080e7          	jalr	922(ra) # 800017a4 <copyin>
    80005412:	05650463          	beq	a0,s6,8000545a <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005416:	21c4a783          	lw	a5,540(s1)
    8000541a:	0017871b          	addiw	a4,a5,1
    8000541e:	20e4ae23          	sw	a4,540(s1)
    80005422:	1ff7f793          	andi	a5,a5,511
    80005426:	97a6                	add	a5,a5,s1
    80005428:	f9f44703          	lbu	a4,-97(s0)
    8000542c:	00e78c23          	sb	a4,24(a5)
      i++;
    80005430:	2905                	addiw	s2,s2,1
    80005432:	b75d                	j	800053d8 <pipewrite+0x8e>
    80005434:	7b42                	ld	s6,48(sp)
    80005436:	7ba2                	ld	s7,40(sp)
    80005438:	7c02                	ld	s8,32(sp)
    8000543a:	6ce2                	ld	s9,24(sp)
    8000543c:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000543e:	21848513          	addi	a0,s1,536
    80005442:	ffffd097          	auipc	ra,0xffffd
    80005446:	01e080e7          	jalr	30(ra) # 80002460 <wakeup>
  release(&pi->lock);
    8000544a:	8526                	mv	a0,s1
    8000544c:	ffffc097          	auipc	ra,0xffffc
    80005450:	8c0080e7          	jalr	-1856(ra) # 80000d0c <release>
  return i;
    80005454:	bfa9                	j	800053ae <pipewrite+0x64>
  int i = 0;
    80005456:	4901                	li	s2,0
    80005458:	b7dd                	j	8000543e <pipewrite+0xf4>
    8000545a:	7b42                	ld	s6,48(sp)
    8000545c:	7ba2                	ld	s7,40(sp)
    8000545e:	7c02                	ld	s8,32(sp)
    80005460:	6ce2                	ld	s9,24(sp)
    80005462:	6d42                	ld	s10,16(sp)
    80005464:	bfe9                	j	8000543e <pipewrite+0xf4>

0000000080005466 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005466:	711d                	addi	sp,sp,-96
    80005468:	ec86                	sd	ra,88(sp)
    8000546a:	e8a2                	sd	s0,80(sp)
    8000546c:	e4a6                	sd	s1,72(sp)
    8000546e:	e0ca                	sd	s2,64(sp)
    80005470:	fc4e                	sd	s3,56(sp)
    80005472:	f852                	sd	s4,48(sp)
    80005474:	f456                	sd	s5,40(sp)
    80005476:	1080                	addi	s0,sp,96
    80005478:	84aa                	mv	s1,a0
    8000547a:	892e                	mv	s2,a1
    8000547c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000547e:	ffffc097          	auipc	ra,0xffffc
    80005482:	70e080e7          	jalr	1806(ra) # 80001b8c <myproc>
    80005486:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005488:	8526                	mv	a0,s1
    8000548a:	ffffb097          	auipc	ra,0xffffb
    8000548e:	7d2080e7          	jalr	2002(ra) # 80000c5c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005492:	2184a703          	lw	a4,536(s1)
    80005496:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000549a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000549e:	02f71b63          	bne	a4,a5,800054d4 <piperead+0x6e>
    800054a2:	2244a783          	lw	a5,548(s1)
    800054a6:	c3b1                	beqz	a5,800054ea <piperead+0x84>
    if(killed(pr)){
    800054a8:	8552                	mv	a0,s4
    800054aa:	ffffd097          	auipc	ra,0xffffd
    800054ae:	2a6080e7          	jalr	678(ra) # 80002750 <killed>
    800054b2:	e50d                	bnez	a0,800054dc <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800054b4:	85a6                	mv	a1,s1
    800054b6:	854e                	mv	a0,s3
    800054b8:	ffffd097          	auipc	ra,0xffffd
    800054bc:	f44080e7          	jalr	-188(ra) # 800023fc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800054c0:	2184a703          	lw	a4,536(s1)
    800054c4:	21c4a783          	lw	a5,540(s1)
    800054c8:	fcf70de3          	beq	a4,a5,800054a2 <piperead+0x3c>
    800054cc:	f05a                	sd	s6,32(sp)
    800054ce:	ec5e                	sd	s7,24(sp)
    800054d0:	e862                	sd	s8,16(sp)
    800054d2:	a839                	j	800054f0 <piperead+0x8a>
    800054d4:	f05a                	sd	s6,32(sp)
    800054d6:	ec5e                	sd	s7,24(sp)
    800054d8:	e862                	sd	s8,16(sp)
    800054da:	a819                	j	800054f0 <piperead+0x8a>
      release(&pi->lock);
    800054dc:	8526                	mv	a0,s1
    800054de:	ffffc097          	auipc	ra,0xffffc
    800054e2:	82e080e7          	jalr	-2002(ra) # 80000d0c <release>
      return -1;
    800054e6:	59fd                	li	s3,-1
    800054e8:	a88d                	j	8000555a <piperead+0xf4>
    800054ea:	f05a                	sd	s6,32(sp)
    800054ec:	ec5e                	sd	s7,24(sp)
    800054ee:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800054f0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800054f2:	faf40c13          	addi	s8,s0,-81
    800054f6:	4b85                	li	s7,1
    800054f8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800054fa:	05505263          	blez	s5,8000553e <piperead+0xd8>
    if(pi->nread == pi->nwrite)
    800054fe:	2184a783          	lw	a5,536(s1)
    80005502:	21c4a703          	lw	a4,540(s1)
    80005506:	02f70c63          	beq	a4,a5,8000553e <piperead+0xd8>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000550a:	0017871b          	addiw	a4,a5,1
    8000550e:	20e4ac23          	sw	a4,536(s1)
    80005512:	1ff7f793          	andi	a5,a5,511
    80005516:	97a6                	add	a5,a5,s1
    80005518:	0187c783          	lbu	a5,24(a5)
    8000551c:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005520:	86de                	mv	a3,s7
    80005522:	8662                	mv	a2,s8
    80005524:	85ca                	mv	a1,s2
    80005526:	050a3503          	ld	a0,80(s4)
    8000552a:	ffffc097          	auipc	ra,0xffffc
    8000552e:	1ee080e7          	jalr	494(ra) # 80001718 <copyout>
    80005532:	01650663          	beq	a0,s6,8000553e <piperead+0xd8>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005536:	2985                	addiw	s3,s3,1
    80005538:	0905                	addi	s2,s2,1
    8000553a:	fd3a92e3          	bne	s5,s3,800054fe <piperead+0x98>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000553e:	21c48513          	addi	a0,s1,540
    80005542:	ffffd097          	auipc	ra,0xffffd
    80005546:	f1e080e7          	jalr	-226(ra) # 80002460 <wakeup>
  release(&pi->lock);
    8000554a:	8526                	mv	a0,s1
    8000554c:	ffffb097          	auipc	ra,0xffffb
    80005550:	7c0080e7          	jalr	1984(ra) # 80000d0c <release>
    80005554:	7b02                	ld	s6,32(sp)
    80005556:	6be2                	ld	s7,24(sp)
    80005558:	6c42                	ld	s8,16(sp)
  return i;
}
    8000555a:	854e                	mv	a0,s3
    8000555c:	60e6                	ld	ra,88(sp)
    8000555e:	6446                	ld	s0,80(sp)
    80005560:	64a6                	ld	s1,72(sp)
    80005562:	6906                	ld	s2,64(sp)
    80005564:	79e2                	ld	s3,56(sp)
    80005566:	7a42                	ld	s4,48(sp)
    80005568:	7aa2                	ld	s5,40(sp)
    8000556a:	6125                	addi	sp,sp,96
    8000556c:	8082                	ret

000000008000556e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000556e:	1141                	addi	sp,sp,-16
    80005570:	e406                	sd	ra,8(sp)
    80005572:	e022                	sd	s0,0(sp)
    80005574:	0800                	addi	s0,sp,16
    80005576:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005578:	0035151b          	slliw	a0,a0,0x3
    8000557c:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    8000557e:	8b89                	andi	a5,a5,2
    80005580:	c399                	beqz	a5,80005586 <flags2perm+0x18>
      perm |= PTE_W;
    80005582:	00456513          	ori	a0,a0,4
    return perm;
}
    80005586:	60a2                	ld	ra,8(sp)
    80005588:	6402                	ld	s0,0(sp)
    8000558a:	0141                	addi	sp,sp,16
    8000558c:	8082                	ret

000000008000558e <exec>:

int
exec(char *path, char **argv)
{
    8000558e:	de010113          	addi	sp,sp,-544
    80005592:	20113c23          	sd	ra,536(sp)
    80005596:	20813823          	sd	s0,528(sp)
    8000559a:	20913423          	sd	s1,520(sp)
    8000559e:	21213023          	sd	s2,512(sp)
    800055a2:	1400                	addi	s0,sp,544
    800055a4:	892a                	mv	s2,a0
    800055a6:	dea43823          	sd	a0,-528(s0)
    800055aa:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800055ae:	ffffc097          	auipc	ra,0xffffc
    800055b2:	5de080e7          	jalr	1502(ra) # 80001b8c <myproc>
    800055b6:	84aa                	mv	s1,a0

  begin_op();
    800055b8:	fffff097          	auipc	ra,0xfffff
    800055bc:	318080e7          	jalr	792(ra) # 800048d0 <begin_op>

  if((ip = namei(path)) == 0){
    800055c0:	854a                	mv	a0,s2
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	108080e7          	jalr	264(ra) # 800046ca <namei>
    800055ca:	c525                	beqz	a0,80005632 <exec+0xa4>
    800055cc:	fbd2                	sd	s4,496(sp)
    800055ce:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800055d0:	fffff097          	auipc	ra,0xfffff
    800055d4:	910080e7          	jalr	-1776(ra) # 80003ee0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800055d8:	04000713          	li	a4,64
    800055dc:	4681                	li	a3,0
    800055de:	e5040613          	addi	a2,s0,-432
    800055e2:	4581                	li	a1,0
    800055e4:	8552                	mv	a0,s4
    800055e6:	fffff097          	auipc	ra,0xfffff
    800055ea:	bb8080e7          	jalr	-1096(ra) # 8000419e <readi>
    800055ee:	04000793          	li	a5,64
    800055f2:	00f51a63          	bne	a0,a5,80005606 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800055f6:	e5042703          	lw	a4,-432(s0)
    800055fa:	464c47b7          	lui	a5,0x464c4
    800055fe:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005602:	02f70e63          	beq	a4,a5,8000563e <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005606:	8552                	mv	a0,s4
    80005608:	fffff097          	auipc	ra,0xfffff
    8000560c:	b40080e7          	jalr	-1216(ra) # 80004148 <iunlockput>
    end_op();
    80005610:	fffff097          	auipc	ra,0xfffff
    80005614:	340080e7          	jalr	832(ra) # 80004950 <end_op>
  }
  return -1;
    80005618:	557d                	li	a0,-1
    8000561a:	7a5e                	ld	s4,496(sp)
}
    8000561c:	21813083          	ld	ra,536(sp)
    80005620:	21013403          	ld	s0,528(sp)
    80005624:	20813483          	ld	s1,520(sp)
    80005628:	20013903          	ld	s2,512(sp)
    8000562c:	22010113          	addi	sp,sp,544
    80005630:	8082                	ret
    end_op();
    80005632:	fffff097          	auipc	ra,0xfffff
    80005636:	31e080e7          	jalr	798(ra) # 80004950 <end_op>
    return -1;
    8000563a:	557d                	li	a0,-1
    8000563c:	b7c5                	j	8000561c <exec+0x8e>
    8000563e:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005640:	8526                	mv	a0,s1
    80005642:	ffffc097          	auipc	ra,0xffffc
    80005646:	610080e7          	jalr	1552(ra) # 80001c52 <proc_pagetable>
    8000564a:	8b2a                	mv	s6,a0
    8000564c:	2c050363          	beqz	a0,80005912 <exec+0x384>
    80005650:	ffce                	sd	s3,504(sp)
    80005652:	f7d6                	sd	s5,488(sp)
    80005654:	efde                	sd	s7,472(sp)
    80005656:	ebe2                	sd	s8,464(sp)
    80005658:	e7e6                	sd	s9,456(sp)
    8000565a:	e3ea                	sd	s10,448(sp)
    8000565c:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000565e:	e8845783          	lhu	a5,-376(s0)
    80005662:	10078563          	beqz	a5,8000576c <exec+0x1de>
    80005666:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000566a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000566c:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000566e:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80005672:	6c85                	lui	s9,0x1
    80005674:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005678:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000567c:	6a85                	lui	s5,0x1
    8000567e:	a0b5                	j	800056ea <exec+0x15c>
      panic("loadseg: address should exist");
    80005680:	00003517          	auipc	a0,0x3
    80005684:	0e050513          	addi	a0,a0,224 # 80008760 <etext+0x760>
    80005688:	ffffb097          	auipc	ra,0xffffb
    8000568c:	ed6080e7          	jalr	-298(ra) # 8000055e <panic>
    if(sz - i < PGSIZE)
    80005690:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005692:	874a                	mv	a4,s2
    80005694:	009b86bb          	addw	a3,s7,s1
    80005698:	4581                	li	a1,0
    8000569a:	8552                	mv	a0,s4
    8000569c:	fffff097          	auipc	ra,0xfffff
    800056a0:	b02080e7          	jalr	-1278(ra) # 8000419e <readi>
    800056a4:	26a91b63          	bne	s2,a0,8000591a <exec+0x38c>
  for(i = 0; i < sz; i += PGSIZE){
    800056a8:	009a84bb          	addw	s1,s5,s1
    800056ac:	0334f463          	bgeu	s1,s3,800056d4 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    800056b0:	02049593          	slli	a1,s1,0x20
    800056b4:	9181                	srli	a1,a1,0x20
    800056b6:	95e2                	add	a1,a1,s8
    800056b8:	855a                	mv	a0,s6
    800056ba:	ffffc097          	auipc	ra,0xffffc
    800056be:	a3c080e7          	jalr	-1476(ra) # 800010f6 <walkaddr>
    800056c2:	862a                	mv	a2,a0
    if(pa == 0)
    800056c4:	dd55                	beqz	a0,80005680 <exec+0xf2>
    if(sz - i < PGSIZE)
    800056c6:	409987bb          	subw	a5,s3,s1
    800056ca:	893e                	mv	s2,a5
    800056cc:	fcfcf2e3          	bgeu	s9,a5,80005690 <exec+0x102>
    800056d0:	8956                	mv	s2,s5
    800056d2:	bf7d                	j	80005690 <exec+0x102>
    sz = sz1;
    800056d4:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800056d8:	2d05                	addiw	s10,s10,1
    800056da:	e0843783          	ld	a5,-504(s0)
    800056de:	0387869b          	addiw	a3,a5,56
    800056e2:	e8845783          	lhu	a5,-376(s0)
    800056e6:	08fd5463          	bge	s10,a5,8000576e <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800056ea:	e0d43423          	sd	a3,-504(s0)
    800056ee:	876e                	mv	a4,s11
    800056f0:	e1840613          	addi	a2,s0,-488
    800056f4:	4581                	li	a1,0
    800056f6:	8552                	mv	a0,s4
    800056f8:	fffff097          	auipc	ra,0xfffff
    800056fc:	aa6080e7          	jalr	-1370(ra) # 8000419e <readi>
    80005700:	21b51b63          	bne	a0,s11,80005916 <exec+0x388>
    if(ph.type != ELF_PROG_LOAD)
    80005704:	e1842783          	lw	a5,-488(s0)
    80005708:	4705                	li	a4,1
    8000570a:	fce797e3          	bne	a5,a4,800056d8 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    8000570e:	e4043483          	ld	s1,-448(s0)
    80005712:	e3843783          	ld	a5,-456(s0)
    80005716:	22f4e263          	bltu	s1,a5,8000593a <exec+0x3ac>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000571a:	e2843783          	ld	a5,-472(s0)
    8000571e:	94be                	add	s1,s1,a5
    80005720:	22f4e063          	bltu	s1,a5,80005940 <exec+0x3b2>
    if(ph.vaddr % PGSIZE != 0)
    80005724:	de843703          	ld	a4,-536(s0)
    80005728:	8ff9                	and	a5,a5,a4
    8000572a:	20079e63          	bnez	a5,80005946 <exec+0x3b8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000572e:	e1c42503          	lw	a0,-484(s0)
    80005732:	00000097          	auipc	ra,0x0
    80005736:	e3c080e7          	jalr	-452(ra) # 8000556e <flags2perm>
    8000573a:	86aa                	mv	a3,a0
    8000573c:	8626                	mv	a2,s1
    8000573e:	85ca                	mv	a1,s2
    80005740:	855a                	mv	a0,s6
    80005742:	ffffc097          	auipc	ra,0xffffc
    80005746:	d72080e7          	jalr	-654(ra) # 800014b4 <uvmalloc>
    8000574a:	dea43c23          	sd	a0,-520(s0)
    8000574e:	1e050f63          	beqz	a0,8000594c <exec+0x3be>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005752:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005756:	00098863          	beqz	s3,80005766 <exec+0x1d8>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000575a:	e2843c03          	ld	s8,-472(s0)
    8000575e:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005762:	4481                	li	s1,0
    80005764:	b7b1                	j	800056b0 <exec+0x122>
    sz = sz1;
    80005766:	df843903          	ld	s2,-520(s0)
    8000576a:	b7bd                	j	800056d8 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000576c:	4901                	li	s2,0
  iunlockput(ip);
    8000576e:	8552                	mv	a0,s4
    80005770:	fffff097          	auipc	ra,0xfffff
    80005774:	9d8080e7          	jalr	-1576(ra) # 80004148 <iunlockput>
  end_op();
    80005778:	fffff097          	auipc	ra,0xfffff
    8000577c:	1d8080e7          	jalr	472(ra) # 80004950 <end_op>
  p = myproc();
    80005780:	ffffc097          	auipc	ra,0xffffc
    80005784:	40c080e7          	jalr	1036(ra) # 80001b8c <myproc>
    80005788:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000578a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000578e:	6985                	lui	s3,0x1
    80005790:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005792:	99ca                	add	s3,s3,s2
    80005794:	77fd                	lui	a5,0xfffff
    80005796:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000579a:	4691                	li	a3,4
    8000579c:	6609                	lui	a2,0x2
    8000579e:	964e                	add	a2,a2,s3
    800057a0:	85ce                	mv	a1,s3
    800057a2:	855a                	mv	a0,s6
    800057a4:	ffffc097          	auipc	ra,0xffffc
    800057a8:	d10080e7          	jalr	-752(ra) # 800014b4 <uvmalloc>
    800057ac:	8a2a                	mv	s4,a0
    800057ae:	e115                	bnez	a0,800057d2 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    800057b0:	85ce                	mv	a1,s3
    800057b2:	855a                	mv	a0,s6
    800057b4:	ffffc097          	auipc	ra,0xffffc
    800057b8:	53a080e7          	jalr	1338(ra) # 80001cee <proc_freepagetable>
  return -1;
    800057bc:	557d                	li	a0,-1
    800057be:	79fe                	ld	s3,504(sp)
    800057c0:	7a5e                	ld	s4,496(sp)
    800057c2:	7abe                	ld	s5,488(sp)
    800057c4:	7b1e                	ld	s6,480(sp)
    800057c6:	6bfe                	ld	s7,472(sp)
    800057c8:	6c5e                	ld	s8,464(sp)
    800057ca:	6cbe                	ld	s9,456(sp)
    800057cc:	6d1e                	ld	s10,448(sp)
    800057ce:	7dfa                	ld	s11,440(sp)
    800057d0:	b5b1                	j	8000561c <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    800057d2:	75f9                	lui	a1,0xffffe
    800057d4:	95aa                	add	a1,a1,a0
    800057d6:	855a                	mv	a0,s6
    800057d8:	ffffc097          	auipc	ra,0xffffc
    800057dc:	f0e080e7          	jalr	-242(ra) # 800016e6 <uvmclear>
  stackbase = sp - PGSIZE;
    800057e0:	800a0b93          	addi	s7,s4,-2048
    800057e4:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    800057e8:	e0043783          	ld	a5,-512(s0)
    800057ec:	6388                	ld	a0,0(a5)
  sp = sz;
    800057ee:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800057f0:	4481                	li	s1,0
    ustack[argc] = sp;
    800057f2:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800057f6:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800057fa:	c135                	beqz	a0,8000585e <exec+0x2d0>
    sp -= strlen(argv[argc]) + 1;
    800057fc:	ffffb097          	auipc	ra,0xffffb
    80005800:	6e6080e7          	jalr	1766(ra) # 80000ee2 <strlen>
    80005804:	0015079b          	addiw	a5,a0,1
    80005808:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000580c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005810:	15796163          	bltu	s2,s7,80005952 <exec+0x3c4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005814:	e0043d83          	ld	s11,-512(s0)
    80005818:	000db983          	ld	s3,0(s11)
    8000581c:	854e                	mv	a0,s3
    8000581e:	ffffb097          	auipc	ra,0xffffb
    80005822:	6c4080e7          	jalr	1732(ra) # 80000ee2 <strlen>
    80005826:	0015069b          	addiw	a3,a0,1
    8000582a:	864e                	mv	a2,s3
    8000582c:	85ca                	mv	a1,s2
    8000582e:	855a                	mv	a0,s6
    80005830:	ffffc097          	auipc	ra,0xffffc
    80005834:	ee8080e7          	jalr	-280(ra) # 80001718 <copyout>
    80005838:	10054f63          	bltz	a0,80005956 <exec+0x3c8>
    ustack[argc] = sp;
    8000583c:	00349793          	slli	a5,s1,0x3
    80005840:	97e6                	add	a5,a5,s9
    80005842:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffb1e98>
  for(argc = 0; argv[argc]; argc++) {
    80005846:	0485                	addi	s1,s1,1
    80005848:	008d8793          	addi	a5,s11,8
    8000584c:	e0f43023          	sd	a5,-512(s0)
    80005850:	008db503          	ld	a0,8(s11)
    80005854:	c509                	beqz	a0,8000585e <exec+0x2d0>
    if(argc >= MAXARG)
    80005856:	fb8493e3          	bne	s1,s8,800057fc <exec+0x26e>
  sz = sz1;
    8000585a:	89d2                	mv	s3,s4
    8000585c:	bf91                	j	800057b0 <exec+0x222>
  ustack[argc] = 0;
    8000585e:	00349793          	slli	a5,s1,0x3
    80005862:	f9078793          	addi	a5,a5,-112
    80005866:	97a2                	add	a5,a5,s0
    80005868:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000586c:	00349693          	slli	a3,s1,0x3
    80005870:	06a1                	addi	a3,a3,8
    80005872:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005876:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000587a:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000587c:	f3796ae3          	bltu	s2,s7,800057b0 <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005880:	e9040613          	addi	a2,s0,-368
    80005884:	85ca                	mv	a1,s2
    80005886:	855a                	mv	a0,s6
    80005888:	ffffc097          	auipc	ra,0xffffc
    8000588c:	e90080e7          	jalr	-368(ra) # 80001718 <copyout>
    80005890:	f20540e3          	bltz	a0,800057b0 <exec+0x222>
  p->trapframe->a1 = sp;
    80005894:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005898:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000589c:	df043783          	ld	a5,-528(s0)
    800058a0:	0007c703          	lbu	a4,0(a5)
    800058a4:	cf11                	beqz	a4,800058c0 <exec+0x332>
    800058a6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800058a8:	02f00693          	li	a3,47
    800058ac:	a029                	j	800058b6 <exec+0x328>
  for(last=s=path; *s; s++)
    800058ae:	0785                	addi	a5,a5,1
    800058b0:	fff7c703          	lbu	a4,-1(a5)
    800058b4:	c711                	beqz	a4,800058c0 <exec+0x332>
    if(*s == '/')
    800058b6:	fed71ce3          	bne	a4,a3,800058ae <exec+0x320>
      last = s+1;
    800058ba:	def43823          	sd	a5,-528(s0)
    800058be:	bfc5                	j	800058ae <exec+0x320>
  safestrcpy(p->name, last, sizeof(p->name));
    800058c0:	4641                	li	a2,16
    800058c2:	df043583          	ld	a1,-528(s0)
    800058c6:	158a8513          	addi	a0,s5,344
    800058ca:	ffffb097          	auipc	ra,0xffffb
    800058ce:	5e2080e7          	jalr	1506(ra) # 80000eac <safestrcpy>
  oldpagetable = p->pagetable;
    800058d2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800058d6:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800058da:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800058de:	058ab783          	ld	a5,88(s5)
    800058e2:	e6843703          	ld	a4,-408(s0)
    800058e6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800058e8:	058ab783          	ld	a5,88(s5)
    800058ec:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800058f0:	85ea                	mv	a1,s10
    800058f2:	ffffc097          	auipc	ra,0xffffc
    800058f6:	3fc080e7          	jalr	1020(ra) # 80001cee <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800058fa:	0004851b          	sext.w	a0,s1
    800058fe:	79fe                	ld	s3,504(sp)
    80005900:	7a5e                	ld	s4,496(sp)
    80005902:	7abe                	ld	s5,488(sp)
    80005904:	7b1e                	ld	s6,480(sp)
    80005906:	6bfe                	ld	s7,472(sp)
    80005908:	6c5e                	ld	s8,464(sp)
    8000590a:	6cbe                	ld	s9,456(sp)
    8000590c:	6d1e                	ld	s10,448(sp)
    8000590e:	7dfa                	ld	s11,440(sp)
    80005910:	b331                	j	8000561c <exec+0x8e>
    80005912:	7b1e                	ld	s6,480(sp)
    80005914:	b9cd                	j	80005606 <exec+0x78>
    80005916:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000591a:	df843583          	ld	a1,-520(s0)
    8000591e:	855a                	mv	a0,s6
    80005920:	ffffc097          	auipc	ra,0xffffc
    80005924:	3ce080e7          	jalr	974(ra) # 80001cee <proc_freepagetable>
  if(ip){
    80005928:	79fe                	ld	s3,504(sp)
    8000592a:	7abe                	ld	s5,488(sp)
    8000592c:	7b1e                	ld	s6,480(sp)
    8000592e:	6bfe                	ld	s7,472(sp)
    80005930:	6c5e                	ld	s8,464(sp)
    80005932:	6cbe                	ld	s9,456(sp)
    80005934:	6d1e                	ld	s10,448(sp)
    80005936:	7dfa                	ld	s11,440(sp)
    80005938:	b1f9                	j	80005606 <exec+0x78>
    8000593a:	df243c23          	sd	s2,-520(s0)
    8000593e:	bff1                	j	8000591a <exec+0x38c>
    80005940:	df243c23          	sd	s2,-520(s0)
    80005944:	bfd9                	j	8000591a <exec+0x38c>
    80005946:	df243c23          	sd	s2,-520(s0)
    8000594a:	bfc1                	j	8000591a <exec+0x38c>
    8000594c:	df243c23          	sd	s2,-520(s0)
    80005950:	b7e9                	j	8000591a <exec+0x38c>
  sz = sz1;
    80005952:	89d2                	mv	s3,s4
    80005954:	bdb1                	j	800057b0 <exec+0x222>
    80005956:	89d2                	mv	s3,s4
    80005958:	bda1                	j	800057b0 <exec+0x222>

000000008000595a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000595a:	7179                	addi	sp,sp,-48
    8000595c:	f406                	sd	ra,40(sp)
    8000595e:	f022                	sd	s0,32(sp)
    80005960:	ec26                	sd	s1,24(sp)
    80005962:	e84a                	sd	s2,16(sp)
    80005964:	1800                	addi	s0,sp,48
    80005966:	892e                	mv	s2,a1
    80005968:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000596a:	fdc40593          	addi	a1,s0,-36
    8000596e:	ffffe097          	auipc	ra,0xffffe
    80005972:	834080e7          	jalr	-1996(ra) # 800031a2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005976:	fdc42703          	lw	a4,-36(s0)
    8000597a:	47bd                	li	a5,15
    8000597c:	02e7ec63          	bltu	a5,a4,800059b4 <argfd+0x5a>
    80005980:	ffffc097          	auipc	ra,0xffffc
    80005984:	20c080e7          	jalr	524(ra) # 80001b8c <myproc>
    80005988:	fdc42703          	lw	a4,-36(s0)
    8000598c:	00371793          	slli	a5,a4,0x3
    80005990:	0d078793          	addi	a5,a5,208
    80005994:	953e                	add	a0,a0,a5
    80005996:	611c                	ld	a5,0(a0)
    80005998:	c385                	beqz	a5,800059b8 <argfd+0x5e>
    return -1;
  if(pfd)
    8000599a:	00090463          	beqz	s2,800059a2 <argfd+0x48>
    *pfd = fd;
    8000599e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800059a2:	4501                	li	a0,0
  if(pf)
    800059a4:	c091                	beqz	s1,800059a8 <argfd+0x4e>
    *pf = f;
    800059a6:	e09c                	sd	a5,0(s1)
}
    800059a8:	70a2                	ld	ra,40(sp)
    800059aa:	7402                	ld	s0,32(sp)
    800059ac:	64e2                	ld	s1,24(sp)
    800059ae:	6942                	ld	s2,16(sp)
    800059b0:	6145                	addi	sp,sp,48
    800059b2:	8082                	ret
    return -1;
    800059b4:	557d                	li	a0,-1
    800059b6:	bfcd                	j	800059a8 <argfd+0x4e>
    800059b8:	557d                	li	a0,-1
    800059ba:	b7fd                	j	800059a8 <argfd+0x4e>

00000000800059bc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800059bc:	1101                	addi	sp,sp,-32
    800059be:	ec06                	sd	ra,24(sp)
    800059c0:	e822                	sd	s0,16(sp)
    800059c2:	e426                	sd	s1,8(sp)
    800059c4:	1000                	addi	s0,sp,32
    800059c6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800059c8:	ffffc097          	auipc	ra,0xffffc
    800059cc:	1c4080e7          	jalr	452(ra) # 80001b8c <myproc>
    800059d0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800059d2:	0d050793          	addi	a5,a0,208
    800059d6:	4501                	li	a0,0
    800059d8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800059da:	6398                	ld	a4,0(a5)
    800059dc:	cb19                	beqz	a4,800059f2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800059de:	2505                	addiw	a0,a0,1
    800059e0:	07a1                	addi	a5,a5,8
    800059e2:	fed51ce3          	bne	a0,a3,800059da <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800059e6:	557d                	li	a0,-1
}
    800059e8:	60e2                	ld	ra,24(sp)
    800059ea:	6442                	ld	s0,16(sp)
    800059ec:	64a2                	ld	s1,8(sp)
    800059ee:	6105                	addi	sp,sp,32
    800059f0:	8082                	ret
      p->ofile[fd] = f;
    800059f2:	00351793          	slli	a5,a0,0x3
    800059f6:	0d078793          	addi	a5,a5,208
    800059fa:	963e                	add	a2,a2,a5
    800059fc:	e204                	sd	s1,0(a2)
      return fd;
    800059fe:	b7ed                	j	800059e8 <fdalloc+0x2c>

0000000080005a00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005a00:	715d                	addi	sp,sp,-80
    80005a02:	e486                	sd	ra,72(sp)
    80005a04:	e0a2                	sd	s0,64(sp)
    80005a06:	fc26                	sd	s1,56(sp)
    80005a08:	f84a                	sd	s2,48(sp)
    80005a0a:	f44e                	sd	s3,40(sp)
    80005a0c:	f052                	sd	s4,32(sp)
    80005a0e:	ec56                	sd	s5,24(sp)
    80005a10:	e85a                	sd	s6,16(sp)
    80005a12:	0880                	addi	s0,sp,80
    80005a14:	892e                	mv	s2,a1
    80005a16:	8a2e                	mv	s4,a1
    80005a18:	8ab2                	mv	s5,a2
    80005a1a:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005a1c:	fb040593          	addi	a1,s0,-80
    80005a20:	fffff097          	auipc	ra,0xfffff
    80005a24:	cc8080e7          	jalr	-824(ra) # 800046e8 <nameiparent>
    80005a28:	84aa                	mv	s1,a0
    80005a2a:	14050b63          	beqz	a0,80005b80 <create+0x180>
    return 0;

  ilock(dp);
    80005a2e:	ffffe097          	auipc	ra,0xffffe
    80005a32:	4b2080e7          	jalr	1202(ra) # 80003ee0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005a36:	4601                	li	a2,0
    80005a38:	fb040593          	addi	a1,s0,-80
    80005a3c:	8526                	mv	a0,s1
    80005a3e:	fffff097          	auipc	ra,0xfffff
    80005a42:	99c080e7          	jalr	-1636(ra) # 800043da <dirlookup>
    80005a46:	89aa                	mv	s3,a0
    80005a48:	c921                	beqz	a0,80005a98 <create+0x98>
    iunlockput(dp);
    80005a4a:	8526                	mv	a0,s1
    80005a4c:	ffffe097          	auipc	ra,0xffffe
    80005a50:	6fc080e7          	jalr	1788(ra) # 80004148 <iunlockput>
    ilock(ip);
    80005a54:	854e                	mv	a0,s3
    80005a56:	ffffe097          	auipc	ra,0xffffe
    80005a5a:	48a080e7          	jalr	1162(ra) # 80003ee0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005a5e:	4789                	li	a5,2
    80005a60:	02f91563          	bne	s2,a5,80005a8a <create+0x8a>
    80005a64:	0449d783          	lhu	a5,68(s3)
    80005a68:	37f9                	addiw	a5,a5,-2
    80005a6a:	17c2                	slli	a5,a5,0x30
    80005a6c:	93c1                	srli	a5,a5,0x30
    80005a6e:	4705                	li	a4,1
    80005a70:	00f76d63          	bltu	a4,a5,80005a8a <create+0x8a>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005a74:	854e                	mv	a0,s3
    80005a76:	60a6                	ld	ra,72(sp)
    80005a78:	6406                	ld	s0,64(sp)
    80005a7a:	74e2                	ld	s1,56(sp)
    80005a7c:	7942                	ld	s2,48(sp)
    80005a7e:	79a2                	ld	s3,40(sp)
    80005a80:	7a02                	ld	s4,32(sp)
    80005a82:	6ae2                	ld	s5,24(sp)
    80005a84:	6b42                	ld	s6,16(sp)
    80005a86:	6161                	addi	sp,sp,80
    80005a88:	8082                	ret
    iunlockput(ip);
    80005a8a:	854e                	mv	a0,s3
    80005a8c:	ffffe097          	auipc	ra,0xffffe
    80005a90:	6bc080e7          	jalr	1724(ra) # 80004148 <iunlockput>
    return 0;
    80005a94:	4981                	li	s3,0
    80005a96:	bff9                	j	80005a74 <create+0x74>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005a98:	85ca                	mv	a1,s2
    80005a9a:	4088                	lw	a0,0(s1)
    80005a9c:	ffffe097          	auipc	ra,0xffffe
    80005aa0:	2a0080e7          	jalr	672(ra) # 80003d3c <ialloc>
    80005aa4:	892a                	mv	s2,a0
    80005aa6:	c531                	beqz	a0,80005af2 <create+0xf2>
  ilock(ip);
    80005aa8:	ffffe097          	auipc	ra,0xffffe
    80005aac:	438080e7          	jalr	1080(ra) # 80003ee0 <ilock>
  ip->major = major;
    80005ab0:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80005ab4:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80005ab8:	4785                	li	a5,1
    80005aba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005abe:	854a                	mv	a0,s2
    80005ac0:	ffffe097          	auipc	ra,0xffffe
    80005ac4:	354080e7          	jalr	852(ra) # 80003e14 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005ac8:	4705                	li	a4,1
    80005aca:	02ea0a63          	beq	s4,a4,80005afe <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005ace:	00492603          	lw	a2,4(s2)
    80005ad2:	fb040593          	addi	a1,s0,-80
    80005ad6:	8526                	mv	a0,s1
    80005ad8:	fffff097          	auipc	ra,0xfffff
    80005adc:	b30080e7          	jalr	-1232(ra) # 80004608 <dirlink>
    80005ae0:	06054e63          	bltz	a0,80005b5c <create+0x15c>
  iunlockput(dp);
    80005ae4:	8526                	mv	a0,s1
    80005ae6:	ffffe097          	auipc	ra,0xffffe
    80005aea:	662080e7          	jalr	1634(ra) # 80004148 <iunlockput>
  return ip;
    80005aee:	89ca                	mv	s3,s2
    80005af0:	b751                	j	80005a74 <create+0x74>
    iunlockput(dp);
    80005af2:	8526                	mv	a0,s1
    80005af4:	ffffe097          	auipc	ra,0xffffe
    80005af8:	654080e7          	jalr	1620(ra) # 80004148 <iunlockput>
    return 0;
    80005afc:	bfa5                	j	80005a74 <create+0x74>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005afe:	00492603          	lw	a2,4(s2)
    80005b02:	00003597          	auipc	a1,0x3
    80005b06:	c7e58593          	addi	a1,a1,-898 # 80008780 <etext+0x780>
    80005b0a:	854a                	mv	a0,s2
    80005b0c:	fffff097          	auipc	ra,0xfffff
    80005b10:	afc080e7          	jalr	-1284(ra) # 80004608 <dirlink>
    80005b14:	04054463          	bltz	a0,80005b5c <create+0x15c>
    80005b18:	40d0                	lw	a2,4(s1)
    80005b1a:	00003597          	auipc	a1,0x3
    80005b1e:	c6e58593          	addi	a1,a1,-914 # 80008788 <etext+0x788>
    80005b22:	854a                	mv	a0,s2
    80005b24:	fffff097          	auipc	ra,0xfffff
    80005b28:	ae4080e7          	jalr	-1308(ra) # 80004608 <dirlink>
    80005b2c:	02054863          	bltz	a0,80005b5c <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005b30:	00492603          	lw	a2,4(s2)
    80005b34:	fb040593          	addi	a1,s0,-80
    80005b38:	8526                	mv	a0,s1
    80005b3a:	fffff097          	auipc	ra,0xfffff
    80005b3e:	ace080e7          	jalr	-1330(ra) # 80004608 <dirlink>
    80005b42:	00054d63          	bltz	a0,80005b5c <create+0x15c>
    dp->nlink++;  // for ".."
    80005b46:	04a4d783          	lhu	a5,74(s1)
    80005b4a:	2785                	addiw	a5,a5,1
    80005b4c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005b50:	8526                	mv	a0,s1
    80005b52:	ffffe097          	auipc	ra,0xffffe
    80005b56:	2c2080e7          	jalr	706(ra) # 80003e14 <iupdate>
    80005b5a:	b769                	j	80005ae4 <create+0xe4>
  ip->nlink = 0;
    80005b5c:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005b60:	854a                	mv	a0,s2
    80005b62:	ffffe097          	auipc	ra,0xffffe
    80005b66:	2b2080e7          	jalr	690(ra) # 80003e14 <iupdate>
  iunlockput(ip);
    80005b6a:	854a                	mv	a0,s2
    80005b6c:	ffffe097          	auipc	ra,0xffffe
    80005b70:	5dc080e7          	jalr	1500(ra) # 80004148 <iunlockput>
  iunlockput(dp);
    80005b74:	8526                	mv	a0,s1
    80005b76:	ffffe097          	auipc	ra,0xffffe
    80005b7a:	5d2080e7          	jalr	1490(ra) # 80004148 <iunlockput>
  return 0;
    80005b7e:	bddd                	j	80005a74 <create+0x74>
    return 0;
    80005b80:	89aa                	mv	s3,a0
    80005b82:	bdcd                	j	80005a74 <create+0x74>

0000000080005b84 <sys_dup>:
{
    80005b84:	7179                	addi	sp,sp,-48
    80005b86:	f406                	sd	ra,40(sp)
    80005b88:	f022                	sd	s0,32(sp)
    80005b8a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005b8c:	fd840613          	addi	a2,s0,-40
    80005b90:	4581                	li	a1,0
    80005b92:	4501                	li	a0,0
    80005b94:	00000097          	auipc	ra,0x0
    80005b98:	dc6080e7          	jalr	-570(ra) # 8000595a <argfd>
    return -1;
    80005b9c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005b9e:	02054763          	bltz	a0,80005bcc <sys_dup+0x48>
    80005ba2:	ec26                	sd	s1,24(sp)
    80005ba4:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005ba6:	fd843483          	ld	s1,-40(s0)
    80005baa:	8526                	mv	a0,s1
    80005bac:	00000097          	auipc	ra,0x0
    80005bb0:	e10080e7          	jalr	-496(ra) # 800059bc <fdalloc>
    80005bb4:	892a                	mv	s2,a0
    return -1;
    80005bb6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005bb8:	00054f63          	bltz	a0,80005bd6 <sys_dup+0x52>
  filedup(f);
    80005bbc:	8526                	mv	a0,s1
    80005bbe:	fffff097          	auipc	ra,0xfffff
    80005bc2:	1da080e7          	jalr	474(ra) # 80004d98 <filedup>
  return fd;
    80005bc6:	87ca                	mv	a5,s2
    80005bc8:	64e2                	ld	s1,24(sp)
    80005bca:	6942                	ld	s2,16(sp)
}
    80005bcc:	853e                	mv	a0,a5
    80005bce:	70a2                	ld	ra,40(sp)
    80005bd0:	7402                	ld	s0,32(sp)
    80005bd2:	6145                	addi	sp,sp,48
    80005bd4:	8082                	ret
    80005bd6:	64e2                	ld	s1,24(sp)
    80005bd8:	6942                	ld	s2,16(sp)
    80005bda:	bfcd                	j	80005bcc <sys_dup+0x48>

0000000080005bdc <sys_read>:
{
    80005bdc:	7139                	addi	sp,sp,-64
    80005bde:	fc06                	sd	ra,56(sp)
    80005be0:	f822                	sd	s0,48(sp)
    80005be2:	0080                	addi	s0,sp,64
  if (argfd(0, 0, &f) < 0)
    80005be4:	fd840613          	addi	a2,s0,-40
    80005be8:	4581                	li	a1,0
    80005bea:	4501                	li	a0,0
    80005bec:	00000097          	auipc	ra,0x0
    80005bf0:	d6e080e7          	jalr	-658(ra) # 8000595a <argfd>
    return -1;
    80005bf4:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80005bf6:	04054663          	bltz	a0,80005c42 <sys_read+0x66>
  if (argaddr(1, &p) < 0)
    80005bfa:	fc840593          	addi	a1,s0,-56
    80005bfe:	4505                	li	a0,1
    80005c00:	ffffd097          	auipc	ra,0xffffd
    80005c04:	5c4080e7          	jalr	1476(ra) # 800031c4 <argaddr>
    return -1;
    80005c08:	57fd                	li	a5,-1
  if (argaddr(1, &p) < 0)
    80005c0a:	02054c63          	bltz	a0,80005c42 <sys_read+0x66>
  if (argint(2, &n) < 0)
    80005c0e:	fd440593          	addi	a1,s0,-44
    80005c12:	4509                	li	a0,2
    80005c14:	ffffd097          	auipc	ra,0xffffd
    80005c18:	58e080e7          	jalr	1422(ra) # 800031a2 <argint>
    return -1;
    80005c1c:	57fd                	li	a5,-1
  if (argint(2, &n) < 0)
    80005c1e:	02054263          	bltz	a0,80005c42 <sys_read+0x66>
    80005c22:	f426                	sd	s1,40(sp)
  int r = fileread(f, p, n);   // bytes read or <0
    80005c24:	fd442603          	lw	a2,-44(s0)
    80005c28:	fc843583          	ld	a1,-56(s0)
    80005c2c:	fd843503          	ld	a0,-40(s0)
    80005c30:	fffff097          	auipc	ra,0xfffff
    80005c34:	312080e7          	jalr	786(ra) # 80004f42 <fileread>
    80005c38:	84aa                	mv	s1,a0
  if (r > 0)
    80005c3a:	00a04963          	bgtz	a0,80005c4c <sys_read+0x70>
  return r;
    80005c3e:	87a6                	mv	a5,s1
    80005c40:	74a2                	ld	s1,40(sp)
}
    80005c42:	853e                	mv	a0,a5
    80005c44:	70e2                	ld	ra,56(sp)
    80005c46:	7442                	ld	s0,48(sp)
    80005c48:	6121                	addi	sp,sp,64
    80005c4a:	8082                	ret
    add_readbytes(r);          // update global counter (wraps naturally)
    80005c4c:	fffff097          	auipc	ra,0xfffff
    80005c50:	51e080e7          	jalr	1310(ra) # 8000516a <add_readbytes>
    80005c54:	b7ed                	j	80005c3e <sys_read+0x62>

0000000080005c56 <sys_write>:
{
    80005c56:	7179                	addi	sp,sp,-48
    80005c58:	f406                	sd	ra,40(sp)
    80005c5a:	f022                	sd	s0,32(sp)
    80005c5c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005c5e:	fd840593          	addi	a1,s0,-40
    80005c62:	4505                	li	a0,1
    80005c64:	ffffd097          	auipc	ra,0xffffd
    80005c68:	560080e7          	jalr	1376(ra) # 800031c4 <argaddr>
  argint(2, &n);
    80005c6c:	fe440593          	addi	a1,s0,-28
    80005c70:	4509                	li	a0,2
    80005c72:	ffffd097          	auipc	ra,0xffffd
    80005c76:	530080e7          	jalr	1328(ra) # 800031a2 <argint>
  if(argfd(0, 0, &f) < 0)
    80005c7a:	fe840613          	addi	a2,s0,-24
    80005c7e:	4581                	li	a1,0
    80005c80:	4501                	li	a0,0
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	cd8080e7          	jalr	-808(ra) # 8000595a <argfd>
    80005c8a:	87aa                	mv	a5,a0
    return -1;
    80005c8c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005c8e:	0007cc63          	bltz	a5,80005ca6 <sys_write+0x50>
  return filewrite(f, p, n);
    80005c92:	fe442603          	lw	a2,-28(s0)
    80005c96:	fd843583          	ld	a1,-40(s0)
    80005c9a:	fe843503          	ld	a0,-24(s0)
    80005c9e:	fffff097          	auipc	ra,0xfffff
    80005ca2:	37c080e7          	jalr	892(ra) # 8000501a <filewrite>
}
    80005ca6:	70a2                	ld	ra,40(sp)
    80005ca8:	7402                	ld	s0,32(sp)
    80005caa:	6145                	addi	sp,sp,48
    80005cac:	8082                	ret

0000000080005cae <sys_close>:
{
    80005cae:	1101                	addi	sp,sp,-32
    80005cb0:	ec06                	sd	ra,24(sp)
    80005cb2:	e822                	sd	s0,16(sp)
    80005cb4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005cb6:	fe040613          	addi	a2,s0,-32
    80005cba:	fec40593          	addi	a1,s0,-20
    80005cbe:	4501                	li	a0,0
    80005cc0:	00000097          	auipc	ra,0x0
    80005cc4:	c9a080e7          	jalr	-870(ra) # 8000595a <argfd>
    return -1;
    80005cc8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005cca:	02054563          	bltz	a0,80005cf4 <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80005cce:	ffffc097          	auipc	ra,0xffffc
    80005cd2:	ebe080e7          	jalr	-322(ra) # 80001b8c <myproc>
    80005cd6:	fec42783          	lw	a5,-20(s0)
    80005cda:	078e                	slli	a5,a5,0x3
    80005cdc:	0d078793          	addi	a5,a5,208
    80005ce0:	953e                	add	a0,a0,a5
    80005ce2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005ce6:	fe043503          	ld	a0,-32(s0)
    80005cea:	fffff097          	auipc	ra,0xfffff
    80005cee:	100080e7          	jalr	256(ra) # 80004dea <fileclose>
  return 0;
    80005cf2:	4781                	li	a5,0
}
    80005cf4:	853e                	mv	a0,a5
    80005cf6:	60e2                	ld	ra,24(sp)
    80005cf8:	6442                	ld	s0,16(sp)
    80005cfa:	6105                	addi	sp,sp,32
    80005cfc:	8082                	ret

0000000080005cfe <sys_fstat>:
{
    80005cfe:	1101                	addi	sp,sp,-32
    80005d00:	ec06                	sd	ra,24(sp)
    80005d02:	e822                	sd	s0,16(sp)
    80005d04:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005d06:	fe040593          	addi	a1,s0,-32
    80005d0a:	4505                	li	a0,1
    80005d0c:	ffffd097          	auipc	ra,0xffffd
    80005d10:	4b8080e7          	jalr	1208(ra) # 800031c4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005d14:	fe840613          	addi	a2,s0,-24
    80005d18:	4581                	li	a1,0
    80005d1a:	4501                	li	a0,0
    80005d1c:	00000097          	auipc	ra,0x0
    80005d20:	c3e080e7          	jalr	-962(ra) # 8000595a <argfd>
    80005d24:	87aa                	mv	a5,a0
    return -1;
    80005d26:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005d28:	0007ca63          	bltz	a5,80005d3c <sys_fstat+0x3e>
  return filestat(f, st);
    80005d2c:	fe043583          	ld	a1,-32(s0)
    80005d30:	fe843503          	ld	a0,-24(s0)
    80005d34:	fffff097          	auipc	ra,0xfffff
    80005d38:	198080e7          	jalr	408(ra) # 80004ecc <filestat>
}
    80005d3c:	60e2                	ld	ra,24(sp)
    80005d3e:	6442                	ld	s0,16(sp)
    80005d40:	6105                	addi	sp,sp,32
    80005d42:	8082                	ret

0000000080005d44 <sys_link>:
{
    80005d44:	7169                	addi	sp,sp,-304
    80005d46:	f606                	sd	ra,296(sp)
    80005d48:	f222                	sd	s0,288(sp)
    80005d4a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d4c:	08000613          	li	a2,128
    80005d50:	ed040593          	addi	a1,s0,-304
    80005d54:	4501                	li	a0,0
    80005d56:	ffffd097          	auipc	ra,0xffffd
    80005d5a:	490080e7          	jalr	1168(ra) # 800031e6 <argstr>
    return -1;
    80005d5e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d60:	12054663          	bltz	a0,80005e8c <sys_link+0x148>
    80005d64:	08000613          	li	a2,128
    80005d68:	f5040593          	addi	a1,s0,-176
    80005d6c:	4505                	li	a0,1
    80005d6e:	ffffd097          	auipc	ra,0xffffd
    80005d72:	478080e7          	jalr	1144(ra) # 800031e6 <argstr>
    return -1;
    80005d76:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d78:	10054a63          	bltz	a0,80005e8c <sys_link+0x148>
    80005d7c:	ee26                	sd	s1,280(sp)
  begin_op();
    80005d7e:	fffff097          	auipc	ra,0xfffff
    80005d82:	b52080e7          	jalr	-1198(ra) # 800048d0 <begin_op>
  if((ip = namei(old)) == 0){
    80005d86:	ed040513          	addi	a0,s0,-304
    80005d8a:	fffff097          	auipc	ra,0xfffff
    80005d8e:	940080e7          	jalr	-1728(ra) # 800046ca <namei>
    80005d92:	84aa                	mv	s1,a0
    80005d94:	c949                	beqz	a0,80005e26 <sys_link+0xe2>
  ilock(ip);
    80005d96:	ffffe097          	auipc	ra,0xffffe
    80005d9a:	14a080e7          	jalr	330(ra) # 80003ee0 <ilock>
  if(ip->type == T_DIR){
    80005d9e:	04449703          	lh	a4,68(s1)
    80005da2:	4785                	li	a5,1
    80005da4:	08f70863          	beq	a4,a5,80005e34 <sys_link+0xf0>
    80005da8:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005daa:	04a4d783          	lhu	a5,74(s1)
    80005dae:	2785                	addiw	a5,a5,1
    80005db0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005db4:	8526                	mv	a0,s1
    80005db6:	ffffe097          	auipc	ra,0xffffe
    80005dba:	05e080e7          	jalr	94(ra) # 80003e14 <iupdate>
  iunlock(ip);
    80005dbe:	8526                	mv	a0,s1
    80005dc0:	ffffe097          	auipc	ra,0xffffe
    80005dc4:	1e6080e7          	jalr	486(ra) # 80003fa6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005dc8:	fd040593          	addi	a1,s0,-48
    80005dcc:	f5040513          	addi	a0,s0,-176
    80005dd0:	fffff097          	auipc	ra,0xfffff
    80005dd4:	918080e7          	jalr	-1768(ra) # 800046e8 <nameiparent>
    80005dd8:	892a                	mv	s2,a0
    80005dda:	cd35                	beqz	a0,80005e56 <sys_link+0x112>
  ilock(dp);
    80005ddc:	ffffe097          	auipc	ra,0xffffe
    80005de0:	104080e7          	jalr	260(ra) # 80003ee0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005de4:	854a                	mv	a0,s2
    80005de6:	00092703          	lw	a4,0(s2)
    80005dea:	409c                	lw	a5,0(s1)
    80005dec:	06f71063          	bne	a4,a5,80005e4c <sys_link+0x108>
    80005df0:	40d0                	lw	a2,4(s1)
    80005df2:	fd040593          	addi	a1,s0,-48
    80005df6:	fffff097          	auipc	ra,0xfffff
    80005dfa:	812080e7          	jalr	-2030(ra) # 80004608 <dirlink>
    80005dfe:	04054763          	bltz	a0,80005e4c <sys_link+0x108>
  iunlockput(dp);
    80005e02:	854a                	mv	a0,s2
    80005e04:	ffffe097          	auipc	ra,0xffffe
    80005e08:	344080e7          	jalr	836(ra) # 80004148 <iunlockput>
  iput(ip);
    80005e0c:	8526                	mv	a0,s1
    80005e0e:	ffffe097          	auipc	ra,0xffffe
    80005e12:	290080e7          	jalr	656(ra) # 8000409e <iput>
  end_op();
    80005e16:	fffff097          	auipc	ra,0xfffff
    80005e1a:	b3a080e7          	jalr	-1222(ra) # 80004950 <end_op>
  return 0;
    80005e1e:	4781                	li	a5,0
    80005e20:	64f2                	ld	s1,280(sp)
    80005e22:	6952                	ld	s2,272(sp)
    80005e24:	a0a5                	j	80005e8c <sys_link+0x148>
    end_op();
    80005e26:	fffff097          	auipc	ra,0xfffff
    80005e2a:	b2a080e7          	jalr	-1238(ra) # 80004950 <end_op>
    return -1;
    80005e2e:	57fd                	li	a5,-1
    80005e30:	64f2                	ld	s1,280(sp)
    80005e32:	a8a9                	j	80005e8c <sys_link+0x148>
    iunlockput(ip);
    80005e34:	8526                	mv	a0,s1
    80005e36:	ffffe097          	auipc	ra,0xffffe
    80005e3a:	312080e7          	jalr	786(ra) # 80004148 <iunlockput>
    end_op();
    80005e3e:	fffff097          	auipc	ra,0xfffff
    80005e42:	b12080e7          	jalr	-1262(ra) # 80004950 <end_op>
    return -1;
    80005e46:	57fd                	li	a5,-1
    80005e48:	64f2                	ld	s1,280(sp)
    80005e4a:	a089                	j	80005e8c <sys_link+0x148>
    iunlockput(dp);
    80005e4c:	854a                	mv	a0,s2
    80005e4e:	ffffe097          	auipc	ra,0xffffe
    80005e52:	2fa080e7          	jalr	762(ra) # 80004148 <iunlockput>
  ilock(ip);
    80005e56:	8526                	mv	a0,s1
    80005e58:	ffffe097          	auipc	ra,0xffffe
    80005e5c:	088080e7          	jalr	136(ra) # 80003ee0 <ilock>
  ip->nlink--;
    80005e60:	04a4d783          	lhu	a5,74(s1)
    80005e64:	37fd                	addiw	a5,a5,-1
    80005e66:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005e6a:	8526                	mv	a0,s1
    80005e6c:	ffffe097          	auipc	ra,0xffffe
    80005e70:	fa8080e7          	jalr	-88(ra) # 80003e14 <iupdate>
  iunlockput(ip);
    80005e74:	8526                	mv	a0,s1
    80005e76:	ffffe097          	auipc	ra,0xffffe
    80005e7a:	2d2080e7          	jalr	722(ra) # 80004148 <iunlockput>
  end_op();
    80005e7e:	fffff097          	auipc	ra,0xfffff
    80005e82:	ad2080e7          	jalr	-1326(ra) # 80004950 <end_op>
  return -1;
    80005e86:	57fd                	li	a5,-1
    80005e88:	64f2                	ld	s1,280(sp)
    80005e8a:	6952                	ld	s2,272(sp)
}
    80005e8c:	853e                	mv	a0,a5
    80005e8e:	70b2                	ld	ra,296(sp)
    80005e90:	7412                	ld	s0,288(sp)
    80005e92:	6155                	addi	sp,sp,304
    80005e94:	8082                	ret

0000000080005e96 <sys_unlink>:
{
    80005e96:	7151                	addi	sp,sp,-240
    80005e98:	f586                	sd	ra,232(sp)
    80005e9a:	f1a2                	sd	s0,224(sp)
    80005e9c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005e9e:	08000613          	li	a2,128
    80005ea2:	f3040593          	addi	a1,s0,-208
    80005ea6:	4501                	li	a0,0
    80005ea8:	ffffd097          	auipc	ra,0xffffd
    80005eac:	33e080e7          	jalr	830(ra) # 800031e6 <argstr>
    80005eb0:	1a054763          	bltz	a0,8000605e <sys_unlink+0x1c8>
    80005eb4:	eda6                	sd	s1,216(sp)
  begin_op();
    80005eb6:	fffff097          	auipc	ra,0xfffff
    80005eba:	a1a080e7          	jalr	-1510(ra) # 800048d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005ebe:	fb040593          	addi	a1,s0,-80
    80005ec2:	f3040513          	addi	a0,s0,-208
    80005ec6:	fffff097          	auipc	ra,0xfffff
    80005eca:	822080e7          	jalr	-2014(ra) # 800046e8 <nameiparent>
    80005ece:	84aa                	mv	s1,a0
    80005ed0:	c165                	beqz	a0,80005fb0 <sys_unlink+0x11a>
  ilock(dp);
    80005ed2:	ffffe097          	auipc	ra,0xffffe
    80005ed6:	00e080e7          	jalr	14(ra) # 80003ee0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005eda:	00003597          	auipc	a1,0x3
    80005ede:	8a658593          	addi	a1,a1,-1882 # 80008780 <etext+0x780>
    80005ee2:	fb040513          	addi	a0,s0,-80
    80005ee6:	ffffe097          	auipc	ra,0xffffe
    80005eea:	4da080e7          	jalr	1242(ra) # 800043c0 <namecmp>
    80005eee:	14050963          	beqz	a0,80006040 <sys_unlink+0x1aa>
    80005ef2:	00003597          	auipc	a1,0x3
    80005ef6:	89658593          	addi	a1,a1,-1898 # 80008788 <etext+0x788>
    80005efa:	fb040513          	addi	a0,s0,-80
    80005efe:	ffffe097          	auipc	ra,0xffffe
    80005f02:	4c2080e7          	jalr	1218(ra) # 800043c0 <namecmp>
    80005f06:	12050d63          	beqz	a0,80006040 <sys_unlink+0x1aa>
    80005f0a:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005f0c:	f2c40613          	addi	a2,s0,-212
    80005f10:	fb040593          	addi	a1,s0,-80
    80005f14:	8526                	mv	a0,s1
    80005f16:	ffffe097          	auipc	ra,0xffffe
    80005f1a:	4c4080e7          	jalr	1220(ra) # 800043da <dirlookup>
    80005f1e:	892a                	mv	s2,a0
    80005f20:	10050f63          	beqz	a0,8000603e <sys_unlink+0x1a8>
    80005f24:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80005f26:	ffffe097          	auipc	ra,0xffffe
    80005f2a:	fba080e7          	jalr	-70(ra) # 80003ee0 <ilock>
  if(ip->nlink < 1)
    80005f2e:	04a91783          	lh	a5,74(s2)
    80005f32:	08f05663          	blez	a5,80005fbe <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005f36:	04491703          	lh	a4,68(s2)
    80005f3a:	4785                	li	a5,1
    80005f3c:	08f70963          	beq	a4,a5,80005fce <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
    80005f40:	fc040993          	addi	s3,s0,-64
    80005f44:	4641                	li	a2,16
    80005f46:	4581                	li	a1,0
    80005f48:	854e                	mv	a0,s3
    80005f4a:	ffffb097          	auipc	ra,0xffffb
    80005f4e:	e0a080e7          	jalr	-502(ra) # 80000d54 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005f52:	4741                	li	a4,16
    80005f54:	f2c42683          	lw	a3,-212(s0)
    80005f58:	864e                	mv	a2,s3
    80005f5a:	4581                	li	a1,0
    80005f5c:	8526                	mv	a0,s1
    80005f5e:	ffffe097          	auipc	ra,0xffffe
    80005f62:	346080e7          	jalr	838(ra) # 800042a4 <writei>
    80005f66:	47c1                	li	a5,16
    80005f68:	0af51863          	bne	a0,a5,80006018 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    80005f6c:	04491703          	lh	a4,68(s2)
    80005f70:	4785                	li	a5,1
    80005f72:	0af70b63          	beq	a4,a5,80006028 <sys_unlink+0x192>
  iunlockput(dp);
    80005f76:	8526                	mv	a0,s1
    80005f78:	ffffe097          	auipc	ra,0xffffe
    80005f7c:	1d0080e7          	jalr	464(ra) # 80004148 <iunlockput>
  ip->nlink--;
    80005f80:	04a95783          	lhu	a5,74(s2)
    80005f84:	37fd                	addiw	a5,a5,-1
    80005f86:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005f8a:	854a                	mv	a0,s2
    80005f8c:	ffffe097          	auipc	ra,0xffffe
    80005f90:	e88080e7          	jalr	-376(ra) # 80003e14 <iupdate>
  iunlockput(ip);
    80005f94:	854a                	mv	a0,s2
    80005f96:	ffffe097          	auipc	ra,0xffffe
    80005f9a:	1b2080e7          	jalr	434(ra) # 80004148 <iunlockput>
  end_op();
    80005f9e:	fffff097          	auipc	ra,0xfffff
    80005fa2:	9b2080e7          	jalr	-1614(ra) # 80004950 <end_op>
  return 0;
    80005fa6:	4501                	li	a0,0
    80005fa8:	64ee                	ld	s1,216(sp)
    80005faa:	694e                	ld	s2,208(sp)
    80005fac:	69ae                	ld	s3,200(sp)
    80005fae:	a065                	j	80006056 <sys_unlink+0x1c0>
    end_op();
    80005fb0:	fffff097          	auipc	ra,0xfffff
    80005fb4:	9a0080e7          	jalr	-1632(ra) # 80004950 <end_op>
    return -1;
    80005fb8:	557d                	li	a0,-1
    80005fba:	64ee                	ld	s1,216(sp)
    80005fbc:	a869                	j	80006056 <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    80005fbe:	00002517          	auipc	a0,0x2
    80005fc2:	7d250513          	addi	a0,a0,2002 # 80008790 <etext+0x790>
    80005fc6:	ffffa097          	auipc	ra,0xffffa
    80005fca:	598080e7          	jalr	1432(ra) # 8000055e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005fce:	04c92703          	lw	a4,76(s2)
    80005fd2:	02000793          	li	a5,32
    80005fd6:	f6e7f5e3          	bgeu	a5,a4,80005f40 <sys_unlink+0xaa>
    80005fda:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005fdc:	4741                	li	a4,16
    80005fde:	86ce                	mv	a3,s3
    80005fe0:	f1840613          	addi	a2,s0,-232
    80005fe4:	4581                	li	a1,0
    80005fe6:	854a                	mv	a0,s2
    80005fe8:	ffffe097          	auipc	ra,0xffffe
    80005fec:	1b6080e7          	jalr	438(ra) # 8000419e <readi>
    80005ff0:	47c1                	li	a5,16
    80005ff2:	00f51b63          	bne	a0,a5,80006008 <sys_unlink+0x172>
    if(de.inum != 0)
    80005ff6:	f1845783          	lhu	a5,-232(s0)
    80005ffa:	e7a5                	bnez	a5,80006062 <sys_unlink+0x1cc>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005ffc:	29c1                	addiw	s3,s3,16
    80005ffe:	04c92783          	lw	a5,76(s2)
    80006002:	fcf9ede3          	bltu	s3,a5,80005fdc <sys_unlink+0x146>
    80006006:	bf2d                	j	80005f40 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80006008:	00002517          	auipc	a0,0x2
    8000600c:	7a050513          	addi	a0,a0,1952 # 800087a8 <etext+0x7a8>
    80006010:	ffffa097          	auipc	ra,0xffffa
    80006014:	54e080e7          	jalr	1358(ra) # 8000055e <panic>
    panic("unlink: writei");
    80006018:	00002517          	auipc	a0,0x2
    8000601c:	7a850513          	addi	a0,a0,1960 # 800087c0 <etext+0x7c0>
    80006020:	ffffa097          	auipc	ra,0xffffa
    80006024:	53e080e7          	jalr	1342(ra) # 8000055e <panic>
    dp->nlink--;
    80006028:	04a4d783          	lhu	a5,74(s1)
    8000602c:	37fd                	addiw	a5,a5,-1
    8000602e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006032:	8526                	mv	a0,s1
    80006034:	ffffe097          	auipc	ra,0xffffe
    80006038:	de0080e7          	jalr	-544(ra) # 80003e14 <iupdate>
    8000603c:	bf2d                	j	80005f76 <sys_unlink+0xe0>
    8000603e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80006040:	8526                	mv	a0,s1
    80006042:	ffffe097          	auipc	ra,0xffffe
    80006046:	106080e7          	jalr	262(ra) # 80004148 <iunlockput>
  end_op();
    8000604a:	fffff097          	auipc	ra,0xfffff
    8000604e:	906080e7          	jalr	-1786(ra) # 80004950 <end_op>
  return -1;
    80006052:	557d                	li	a0,-1
    80006054:	64ee                	ld	s1,216(sp)
}
    80006056:	70ae                	ld	ra,232(sp)
    80006058:	740e                	ld	s0,224(sp)
    8000605a:	616d                	addi	sp,sp,240
    8000605c:	8082                	ret
    return -1;
    8000605e:	557d                	li	a0,-1
    80006060:	bfdd                	j	80006056 <sys_unlink+0x1c0>
    iunlockput(ip);
    80006062:	854a                	mv	a0,s2
    80006064:	ffffe097          	auipc	ra,0xffffe
    80006068:	0e4080e7          	jalr	228(ra) # 80004148 <iunlockput>
    goto bad;
    8000606c:	694e                	ld	s2,208(sp)
    8000606e:	69ae                	ld	s3,200(sp)
    80006070:	bfc1                	j	80006040 <sys_unlink+0x1aa>

0000000080006072 <sys_open>:

uint64
sys_open(void)
{
    80006072:	7131                	addi	sp,sp,-192
    80006074:	fd06                	sd	ra,184(sp)
    80006076:	f922                	sd	s0,176(sp)
    80006078:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000607a:	f4c40593          	addi	a1,s0,-180
    8000607e:	4505                	li	a0,1
    80006080:	ffffd097          	auipc	ra,0xffffd
    80006084:	122080e7          	jalr	290(ra) # 800031a2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006088:	08000613          	li	a2,128
    8000608c:	f5040593          	addi	a1,s0,-176
    80006090:	4501                	li	a0,0
    80006092:	ffffd097          	auipc	ra,0xffffd
    80006096:	154080e7          	jalr	340(ra) # 800031e6 <argstr>
    8000609a:	87aa                	mv	a5,a0
    return -1;
    8000609c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000609e:	0a07cf63          	bltz	a5,8000615c <sys_open+0xea>
    800060a2:	f526                	sd	s1,168(sp)

  begin_op();
    800060a4:	fffff097          	auipc	ra,0xfffff
    800060a8:	82c080e7          	jalr	-2004(ra) # 800048d0 <begin_op>

  if(omode & O_CREATE){
    800060ac:	f4c42783          	lw	a5,-180(s0)
    800060b0:	2007f793          	andi	a5,a5,512
    800060b4:	cfdd                	beqz	a5,80006172 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    800060b6:	4681                	li	a3,0
    800060b8:	4601                	li	a2,0
    800060ba:	4589                	li	a1,2
    800060bc:	f5040513          	addi	a0,s0,-176
    800060c0:	00000097          	auipc	ra,0x0
    800060c4:	940080e7          	jalr	-1728(ra) # 80005a00 <create>
    800060c8:	84aa                	mv	s1,a0
    if(ip == 0){
    800060ca:	cd49                	beqz	a0,80006164 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800060cc:	04449703          	lh	a4,68(s1)
    800060d0:	478d                	li	a5,3
    800060d2:	00f71763          	bne	a4,a5,800060e0 <sys_open+0x6e>
    800060d6:	0464d703          	lhu	a4,70(s1)
    800060da:	47a5                	li	a5,9
    800060dc:	0ee7e263          	bltu	a5,a4,800061c0 <sys_open+0x14e>
    800060e0:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800060e2:	fffff097          	auipc	ra,0xfffff
    800060e6:	c4c080e7          	jalr	-948(ra) # 80004d2e <filealloc>
    800060ea:	892a                	mv	s2,a0
    800060ec:	cd65                	beqz	a0,800061e4 <sys_open+0x172>
    800060ee:	ed4e                	sd	s3,152(sp)
    800060f0:	00000097          	auipc	ra,0x0
    800060f4:	8cc080e7          	jalr	-1844(ra) # 800059bc <fdalloc>
    800060f8:	89aa                	mv	s3,a0
    800060fa:	0c054f63          	bltz	a0,800061d8 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800060fe:	04449703          	lh	a4,68(s1)
    80006102:	478d                	li	a5,3
    80006104:	0ef70d63          	beq	a4,a5,800061fe <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006108:	4789                	li	a5,2
    8000610a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000610e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80006112:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006116:	f4c42783          	lw	a5,-180(s0)
    8000611a:	0017f713          	andi	a4,a5,1
    8000611e:	00174713          	xori	a4,a4,1
    80006122:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006126:	0037f713          	andi	a4,a5,3
    8000612a:	00e03733          	snez	a4,a4
    8000612e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80006132:	4007f793          	andi	a5,a5,1024
    80006136:	c791                	beqz	a5,80006142 <sys_open+0xd0>
    80006138:	04449703          	lh	a4,68(s1)
    8000613c:	4789                	li	a5,2
    8000613e:	0cf70763          	beq	a4,a5,8000620c <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    80006142:	8526                	mv	a0,s1
    80006144:	ffffe097          	auipc	ra,0xffffe
    80006148:	e62080e7          	jalr	-414(ra) # 80003fa6 <iunlock>
  end_op();
    8000614c:	fffff097          	auipc	ra,0xfffff
    80006150:	804080e7          	jalr	-2044(ra) # 80004950 <end_op>

  return fd;
    80006154:	854e                	mv	a0,s3
    80006156:	74aa                	ld	s1,168(sp)
    80006158:	790a                	ld	s2,160(sp)
    8000615a:	69ea                	ld	s3,152(sp)
}
    8000615c:	70ea                	ld	ra,184(sp)
    8000615e:	744a                	ld	s0,176(sp)
    80006160:	6129                	addi	sp,sp,192
    80006162:	8082                	ret
      end_op();
    80006164:	ffffe097          	auipc	ra,0xffffe
    80006168:	7ec080e7          	jalr	2028(ra) # 80004950 <end_op>
      return -1;
    8000616c:	557d                	li	a0,-1
    8000616e:	74aa                	ld	s1,168(sp)
    80006170:	b7f5                	j	8000615c <sys_open+0xea>
    if((ip = namei(path)) == 0){
    80006172:	f5040513          	addi	a0,s0,-176
    80006176:	ffffe097          	auipc	ra,0xffffe
    8000617a:	554080e7          	jalr	1364(ra) # 800046ca <namei>
    8000617e:	84aa                	mv	s1,a0
    80006180:	c90d                	beqz	a0,800061b2 <sys_open+0x140>
    ilock(ip);
    80006182:	ffffe097          	auipc	ra,0xffffe
    80006186:	d5e080e7          	jalr	-674(ra) # 80003ee0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000618a:	04449703          	lh	a4,68(s1)
    8000618e:	4785                	li	a5,1
    80006190:	f2f71ee3          	bne	a4,a5,800060cc <sys_open+0x5a>
    80006194:	f4c42783          	lw	a5,-180(s0)
    80006198:	d7a1                	beqz	a5,800060e0 <sys_open+0x6e>
      iunlockput(ip);
    8000619a:	8526                	mv	a0,s1
    8000619c:	ffffe097          	auipc	ra,0xffffe
    800061a0:	fac080e7          	jalr	-84(ra) # 80004148 <iunlockput>
      end_op();
    800061a4:	ffffe097          	auipc	ra,0xffffe
    800061a8:	7ac080e7          	jalr	1964(ra) # 80004950 <end_op>
      return -1;
    800061ac:	557d                	li	a0,-1
    800061ae:	74aa                	ld	s1,168(sp)
    800061b0:	b775                	j	8000615c <sys_open+0xea>
      end_op();
    800061b2:	ffffe097          	auipc	ra,0xffffe
    800061b6:	79e080e7          	jalr	1950(ra) # 80004950 <end_op>
      return -1;
    800061ba:	557d                	li	a0,-1
    800061bc:	74aa                	ld	s1,168(sp)
    800061be:	bf79                	j	8000615c <sys_open+0xea>
    iunlockput(ip);
    800061c0:	8526                	mv	a0,s1
    800061c2:	ffffe097          	auipc	ra,0xffffe
    800061c6:	f86080e7          	jalr	-122(ra) # 80004148 <iunlockput>
    end_op();
    800061ca:	ffffe097          	auipc	ra,0xffffe
    800061ce:	786080e7          	jalr	1926(ra) # 80004950 <end_op>
    return -1;
    800061d2:	557d                	li	a0,-1
    800061d4:	74aa                	ld	s1,168(sp)
    800061d6:	b759                	j	8000615c <sys_open+0xea>
      fileclose(f);
    800061d8:	854a                	mv	a0,s2
    800061da:	fffff097          	auipc	ra,0xfffff
    800061de:	c10080e7          	jalr	-1008(ra) # 80004dea <fileclose>
    800061e2:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800061e4:	8526                	mv	a0,s1
    800061e6:	ffffe097          	auipc	ra,0xffffe
    800061ea:	f62080e7          	jalr	-158(ra) # 80004148 <iunlockput>
    end_op();
    800061ee:	ffffe097          	auipc	ra,0xffffe
    800061f2:	762080e7          	jalr	1890(ra) # 80004950 <end_op>
    return -1;
    800061f6:	557d                	li	a0,-1
    800061f8:	74aa                	ld	s1,168(sp)
    800061fa:	790a                	ld	s2,160(sp)
    800061fc:	b785                	j	8000615c <sys_open+0xea>
    f->type = FD_DEVICE;
    800061fe:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80006202:	04649783          	lh	a5,70(s1)
    80006206:	02f91223          	sh	a5,36(s2)
    8000620a:	b721                	j	80006112 <sys_open+0xa0>
    itrunc(ip);
    8000620c:	8526                	mv	a0,s1
    8000620e:	ffffe097          	auipc	ra,0xffffe
    80006212:	de4080e7          	jalr	-540(ra) # 80003ff2 <itrunc>
    80006216:	b735                	j	80006142 <sys_open+0xd0>

0000000080006218 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006218:	7175                	addi	sp,sp,-144
    8000621a:	e506                	sd	ra,136(sp)
    8000621c:	e122                	sd	s0,128(sp)
    8000621e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006220:	ffffe097          	auipc	ra,0xffffe
    80006224:	6b0080e7          	jalr	1712(ra) # 800048d0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006228:	08000613          	li	a2,128
    8000622c:	f7040593          	addi	a1,s0,-144
    80006230:	4501                	li	a0,0
    80006232:	ffffd097          	auipc	ra,0xffffd
    80006236:	fb4080e7          	jalr	-76(ra) # 800031e6 <argstr>
    8000623a:	02054963          	bltz	a0,8000626c <sys_mkdir+0x54>
    8000623e:	4681                	li	a3,0
    80006240:	4601                	li	a2,0
    80006242:	4585                	li	a1,1
    80006244:	f7040513          	addi	a0,s0,-144
    80006248:	fffff097          	auipc	ra,0xfffff
    8000624c:	7b8080e7          	jalr	1976(ra) # 80005a00 <create>
    80006250:	cd11                	beqz	a0,8000626c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006252:	ffffe097          	auipc	ra,0xffffe
    80006256:	ef6080e7          	jalr	-266(ra) # 80004148 <iunlockput>
  end_op();
    8000625a:	ffffe097          	auipc	ra,0xffffe
    8000625e:	6f6080e7          	jalr	1782(ra) # 80004950 <end_op>
  return 0;
    80006262:	4501                	li	a0,0
}
    80006264:	60aa                	ld	ra,136(sp)
    80006266:	640a                	ld	s0,128(sp)
    80006268:	6149                	addi	sp,sp,144
    8000626a:	8082                	ret
    end_op();
    8000626c:	ffffe097          	auipc	ra,0xffffe
    80006270:	6e4080e7          	jalr	1764(ra) # 80004950 <end_op>
    return -1;
    80006274:	557d                	li	a0,-1
    80006276:	b7fd                	j	80006264 <sys_mkdir+0x4c>

0000000080006278 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006278:	7135                	addi	sp,sp,-160
    8000627a:	ed06                	sd	ra,152(sp)
    8000627c:	e922                	sd	s0,144(sp)
    8000627e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80006280:	ffffe097          	auipc	ra,0xffffe
    80006284:	650080e7          	jalr	1616(ra) # 800048d0 <begin_op>
  argint(1, &major);
    80006288:	f6c40593          	addi	a1,s0,-148
    8000628c:	4505                	li	a0,1
    8000628e:	ffffd097          	auipc	ra,0xffffd
    80006292:	f14080e7          	jalr	-236(ra) # 800031a2 <argint>
  argint(2, &minor);
    80006296:	f6840593          	addi	a1,s0,-152
    8000629a:	4509                	li	a0,2
    8000629c:	ffffd097          	auipc	ra,0xffffd
    800062a0:	f06080e7          	jalr	-250(ra) # 800031a2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800062a4:	08000613          	li	a2,128
    800062a8:	f7040593          	addi	a1,s0,-144
    800062ac:	4501                	li	a0,0
    800062ae:	ffffd097          	auipc	ra,0xffffd
    800062b2:	f38080e7          	jalr	-200(ra) # 800031e6 <argstr>
    800062b6:	02054b63          	bltz	a0,800062ec <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800062ba:	f6841683          	lh	a3,-152(s0)
    800062be:	f6c41603          	lh	a2,-148(s0)
    800062c2:	458d                	li	a1,3
    800062c4:	f7040513          	addi	a0,s0,-144
    800062c8:	fffff097          	auipc	ra,0xfffff
    800062cc:	738080e7          	jalr	1848(ra) # 80005a00 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800062d0:	cd11                	beqz	a0,800062ec <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800062d2:	ffffe097          	auipc	ra,0xffffe
    800062d6:	e76080e7          	jalr	-394(ra) # 80004148 <iunlockput>
  end_op();
    800062da:	ffffe097          	auipc	ra,0xffffe
    800062de:	676080e7          	jalr	1654(ra) # 80004950 <end_op>
  return 0;
    800062e2:	4501                	li	a0,0
}
    800062e4:	60ea                	ld	ra,152(sp)
    800062e6:	644a                	ld	s0,144(sp)
    800062e8:	610d                	addi	sp,sp,160
    800062ea:	8082                	ret
    end_op();
    800062ec:	ffffe097          	auipc	ra,0xffffe
    800062f0:	664080e7          	jalr	1636(ra) # 80004950 <end_op>
    return -1;
    800062f4:	557d                	li	a0,-1
    800062f6:	b7fd                	j	800062e4 <sys_mknod+0x6c>

00000000800062f8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800062f8:	7135                	addi	sp,sp,-160
    800062fa:	ed06                	sd	ra,152(sp)
    800062fc:	e922                	sd	s0,144(sp)
    800062fe:	e14a                	sd	s2,128(sp)
    80006300:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80006302:	ffffc097          	auipc	ra,0xffffc
    80006306:	88a080e7          	jalr	-1910(ra) # 80001b8c <myproc>
    8000630a:	892a                	mv	s2,a0
  
  begin_op();
    8000630c:	ffffe097          	auipc	ra,0xffffe
    80006310:	5c4080e7          	jalr	1476(ra) # 800048d0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006314:	08000613          	li	a2,128
    80006318:	f6040593          	addi	a1,s0,-160
    8000631c:	4501                	li	a0,0
    8000631e:	ffffd097          	auipc	ra,0xffffd
    80006322:	ec8080e7          	jalr	-312(ra) # 800031e6 <argstr>
    80006326:	04054d63          	bltz	a0,80006380 <sys_chdir+0x88>
    8000632a:	e526                	sd	s1,136(sp)
    8000632c:	f6040513          	addi	a0,s0,-160
    80006330:	ffffe097          	auipc	ra,0xffffe
    80006334:	39a080e7          	jalr	922(ra) # 800046ca <namei>
    80006338:	84aa                	mv	s1,a0
    8000633a:	c131                	beqz	a0,8000637e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000633c:	ffffe097          	auipc	ra,0xffffe
    80006340:	ba4080e7          	jalr	-1116(ra) # 80003ee0 <ilock>
  if(ip->type != T_DIR){
    80006344:	04449703          	lh	a4,68(s1)
    80006348:	4785                	li	a5,1
    8000634a:	04f71163          	bne	a4,a5,8000638c <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000634e:	8526                	mv	a0,s1
    80006350:	ffffe097          	auipc	ra,0xffffe
    80006354:	c56080e7          	jalr	-938(ra) # 80003fa6 <iunlock>
  iput(p->cwd);
    80006358:	15093503          	ld	a0,336(s2)
    8000635c:	ffffe097          	auipc	ra,0xffffe
    80006360:	d42080e7          	jalr	-702(ra) # 8000409e <iput>
  end_op();
    80006364:	ffffe097          	auipc	ra,0xffffe
    80006368:	5ec080e7          	jalr	1516(ra) # 80004950 <end_op>
  p->cwd = ip;
    8000636c:	14993823          	sd	s1,336(s2)
  return 0;
    80006370:	4501                	li	a0,0
    80006372:	64aa                	ld	s1,136(sp)
}
    80006374:	60ea                	ld	ra,152(sp)
    80006376:	644a                	ld	s0,144(sp)
    80006378:	690a                	ld	s2,128(sp)
    8000637a:	610d                	addi	sp,sp,160
    8000637c:	8082                	ret
    8000637e:	64aa                	ld	s1,136(sp)
    end_op();
    80006380:	ffffe097          	auipc	ra,0xffffe
    80006384:	5d0080e7          	jalr	1488(ra) # 80004950 <end_op>
    return -1;
    80006388:	557d                	li	a0,-1
    8000638a:	b7ed                	j	80006374 <sys_chdir+0x7c>
    iunlockput(ip);
    8000638c:	8526                	mv	a0,s1
    8000638e:	ffffe097          	auipc	ra,0xffffe
    80006392:	dba080e7          	jalr	-582(ra) # 80004148 <iunlockput>
    end_op();
    80006396:	ffffe097          	auipc	ra,0xffffe
    8000639a:	5ba080e7          	jalr	1466(ra) # 80004950 <end_op>
    return -1;
    8000639e:	557d                	li	a0,-1
    800063a0:	64aa                	ld	s1,136(sp)
    800063a2:	bfc9                	j	80006374 <sys_chdir+0x7c>

00000000800063a4 <sys_exec>:

uint64
sys_exec(void)
{
    800063a4:	7105                	addi	sp,sp,-480
    800063a6:	ef86                	sd	ra,472(sp)
    800063a8:	eba2                	sd	s0,464(sp)
    800063aa:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800063ac:	e2840593          	addi	a1,s0,-472
    800063b0:	4505                	li	a0,1
    800063b2:	ffffd097          	auipc	ra,0xffffd
    800063b6:	e12080e7          	jalr	-494(ra) # 800031c4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800063ba:	08000613          	li	a2,128
    800063be:	f3040593          	addi	a1,s0,-208
    800063c2:	4501                	li	a0,0
    800063c4:	ffffd097          	auipc	ra,0xffffd
    800063c8:	e22080e7          	jalr	-478(ra) # 800031e6 <argstr>
    800063cc:	87aa                	mv	a5,a0
    return -1;
    800063ce:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800063d0:	0e07ce63          	bltz	a5,800064cc <sys_exec+0x128>
    800063d4:	e7a6                	sd	s1,456(sp)
    800063d6:	e3ca                	sd	s2,448(sp)
    800063d8:	ff4e                	sd	s3,440(sp)
    800063da:	fb52                	sd	s4,432(sp)
    800063dc:	f756                	sd	s5,424(sp)
    800063de:	f35a                	sd	s6,416(sp)
    800063e0:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800063e2:	e3040a13          	addi	s4,s0,-464
    800063e6:	10000613          	li	a2,256
    800063ea:	4581                	li	a1,0
    800063ec:	8552                	mv	a0,s4
    800063ee:	ffffb097          	auipc	ra,0xffffb
    800063f2:	966080e7          	jalr	-1690(ra) # 80000d54 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800063f6:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800063f8:	89d2                	mv	s3,s4
    800063fa:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800063fc:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006400:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80006402:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006406:	00391513          	slli	a0,s2,0x3
    8000640a:	85d6                	mv	a1,s5
    8000640c:	e2843783          	ld	a5,-472(s0)
    80006410:	953e                	add	a0,a0,a5
    80006412:	ffffd097          	auipc	ra,0xffffd
    80006416:	cf2080e7          	jalr	-782(ra) # 80003104 <fetchaddr>
    8000641a:	02054a63          	bltz	a0,8000644e <sys_exec+0xaa>
    if(uarg == 0){
    8000641e:	e2043783          	ld	a5,-480(s0)
    80006422:	cbb1                	beqz	a5,80006476 <sys_exec+0xd2>
    argv[i] = kalloc();
    80006424:	ffffa097          	auipc	ra,0xffffa
    80006428:	734080e7          	jalr	1844(ra) # 80000b58 <kalloc>
    8000642c:	85aa                	mv	a1,a0
    8000642e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006432:	cd11                	beqz	a0,8000644e <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006434:	865a                	mv	a2,s6
    80006436:	e2043503          	ld	a0,-480(s0)
    8000643a:	ffffd097          	auipc	ra,0xffffd
    8000643e:	d1c080e7          	jalr	-740(ra) # 80003156 <fetchstr>
    80006442:	00054663          	bltz	a0,8000644e <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80006446:	0905                	addi	s2,s2,1
    80006448:	09a1                	addi	s3,s3,8
    8000644a:	fb791ee3          	bne	s2,s7,80006406 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000644e:	100a0a13          	addi	s4,s4,256
    80006452:	6088                	ld	a0,0(s1)
    80006454:	c525                	beqz	a0,800064bc <sys_exec+0x118>
    kfree(argv[i]);
    80006456:	ffffa097          	auipc	ra,0xffffa
    8000645a:	5fe080e7          	jalr	1534(ra) # 80000a54 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000645e:	04a1                	addi	s1,s1,8
    80006460:	ff4499e3          	bne	s1,s4,80006452 <sys_exec+0xae>
  return -1;
    80006464:	557d                	li	a0,-1
    80006466:	64be                	ld	s1,456(sp)
    80006468:	691e                	ld	s2,448(sp)
    8000646a:	79fa                	ld	s3,440(sp)
    8000646c:	7a5a                	ld	s4,432(sp)
    8000646e:	7aba                	ld	s5,424(sp)
    80006470:	7b1a                	ld	s6,416(sp)
    80006472:	6bfa                	ld	s7,408(sp)
    80006474:	a8a1                	j	800064cc <sys_exec+0x128>
      argv[i] = 0;
    80006476:	0009079b          	sext.w	a5,s2
    8000647a:	e3040593          	addi	a1,s0,-464
    8000647e:	078e                	slli	a5,a5,0x3
    80006480:	97ae                	add	a5,a5,a1
    80006482:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80006486:	f3040513          	addi	a0,s0,-208
    8000648a:	fffff097          	auipc	ra,0xfffff
    8000648e:	104080e7          	jalr	260(ra) # 8000558e <exec>
    80006492:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006494:	100a0a13          	addi	s4,s4,256
    80006498:	6088                	ld	a0,0(s1)
    8000649a:	c901                	beqz	a0,800064aa <sys_exec+0x106>
    kfree(argv[i]);
    8000649c:	ffffa097          	auipc	ra,0xffffa
    800064a0:	5b8080e7          	jalr	1464(ra) # 80000a54 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800064a4:	04a1                	addi	s1,s1,8
    800064a6:	ff4499e3          	bne	s1,s4,80006498 <sys_exec+0xf4>
  return ret;
    800064aa:	854a                	mv	a0,s2
    800064ac:	64be                	ld	s1,456(sp)
    800064ae:	691e                	ld	s2,448(sp)
    800064b0:	79fa                	ld	s3,440(sp)
    800064b2:	7a5a                	ld	s4,432(sp)
    800064b4:	7aba                	ld	s5,424(sp)
    800064b6:	7b1a                	ld	s6,416(sp)
    800064b8:	6bfa                	ld	s7,408(sp)
    800064ba:	a809                	j	800064cc <sys_exec+0x128>
  return -1;
    800064bc:	557d                	li	a0,-1
    800064be:	64be                	ld	s1,456(sp)
    800064c0:	691e                	ld	s2,448(sp)
    800064c2:	79fa                	ld	s3,440(sp)
    800064c4:	7a5a                	ld	s4,432(sp)
    800064c6:	7aba                	ld	s5,424(sp)
    800064c8:	7b1a                	ld	s6,416(sp)
    800064ca:	6bfa                	ld	s7,408(sp)
}
    800064cc:	60fe                	ld	ra,472(sp)
    800064ce:	645e                	ld	s0,464(sp)
    800064d0:	613d                	addi	sp,sp,480
    800064d2:	8082                	ret

00000000800064d4 <sys_pipe>:

uint64
sys_pipe(void)
{
    800064d4:	7139                	addi	sp,sp,-64
    800064d6:	fc06                	sd	ra,56(sp)
    800064d8:	f822                	sd	s0,48(sp)
    800064da:	f426                	sd	s1,40(sp)
    800064dc:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800064de:	ffffb097          	auipc	ra,0xffffb
    800064e2:	6ae080e7          	jalr	1710(ra) # 80001b8c <myproc>
    800064e6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800064e8:	fd840593          	addi	a1,s0,-40
    800064ec:	4501                	li	a0,0
    800064ee:	ffffd097          	auipc	ra,0xffffd
    800064f2:	cd6080e7          	jalr	-810(ra) # 800031c4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800064f6:	fc840593          	addi	a1,s0,-56
    800064fa:	fd040513          	addi	a0,s0,-48
    800064fe:	fffff097          	auipc	ra,0xfffff
    80006502:	cf6080e7          	jalr	-778(ra) # 800051f4 <pipealloc>
    return -1;
    80006506:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006508:	0c054763          	bltz	a0,800065d6 <sys_pipe+0x102>
  fd0 = -1;
    8000650c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006510:	fd043503          	ld	a0,-48(s0)
    80006514:	fffff097          	auipc	ra,0xfffff
    80006518:	4a8080e7          	jalr	1192(ra) # 800059bc <fdalloc>
    8000651c:	fca42223          	sw	a0,-60(s0)
    80006520:	08054e63          	bltz	a0,800065bc <sys_pipe+0xe8>
    80006524:	fc843503          	ld	a0,-56(s0)
    80006528:	fffff097          	auipc	ra,0xfffff
    8000652c:	494080e7          	jalr	1172(ra) # 800059bc <fdalloc>
    80006530:	fca42023          	sw	a0,-64(s0)
    80006534:	06054a63          	bltz	a0,800065a8 <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006538:	4691                	li	a3,4
    8000653a:	fc440613          	addi	a2,s0,-60
    8000653e:	fd843583          	ld	a1,-40(s0)
    80006542:	68a8                	ld	a0,80(s1)
    80006544:	ffffb097          	auipc	ra,0xffffb
    80006548:	1d4080e7          	jalr	468(ra) # 80001718 <copyout>
    8000654c:	02054063          	bltz	a0,8000656c <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006550:	4691                	li	a3,4
    80006552:	fc040613          	addi	a2,s0,-64
    80006556:	fd843583          	ld	a1,-40(s0)
    8000655a:	95b6                	add	a1,a1,a3
    8000655c:	68a8                	ld	a0,80(s1)
    8000655e:	ffffb097          	auipc	ra,0xffffb
    80006562:	1ba080e7          	jalr	442(ra) # 80001718 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006566:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006568:	06055763          	bgez	a0,800065d6 <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    8000656c:	fc442783          	lw	a5,-60(s0)
    80006570:	078e                	slli	a5,a5,0x3
    80006572:	0d078793          	addi	a5,a5,208
    80006576:	97a6                	add	a5,a5,s1
    80006578:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000657c:	fc042783          	lw	a5,-64(s0)
    80006580:	078e                	slli	a5,a5,0x3
    80006582:	0d078793          	addi	a5,a5,208
    80006586:	97a6                	add	a5,a5,s1
    80006588:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000658c:	fd043503          	ld	a0,-48(s0)
    80006590:	fffff097          	auipc	ra,0xfffff
    80006594:	85a080e7          	jalr	-1958(ra) # 80004dea <fileclose>
    fileclose(wf);
    80006598:	fc843503          	ld	a0,-56(s0)
    8000659c:	fffff097          	auipc	ra,0xfffff
    800065a0:	84e080e7          	jalr	-1970(ra) # 80004dea <fileclose>
    return -1;
    800065a4:	57fd                	li	a5,-1
    800065a6:	a805                	j	800065d6 <sys_pipe+0x102>
    if(fd0 >= 0)
    800065a8:	fc442783          	lw	a5,-60(s0)
    800065ac:	0007c863          	bltz	a5,800065bc <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    800065b0:	078e                	slli	a5,a5,0x3
    800065b2:	0d078793          	addi	a5,a5,208
    800065b6:	97a6                	add	a5,a5,s1
    800065b8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800065bc:	fd043503          	ld	a0,-48(s0)
    800065c0:	fffff097          	auipc	ra,0xfffff
    800065c4:	82a080e7          	jalr	-2006(ra) # 80004dea <fileclose>
    fileclose(wf);
    800065c8:	fc843503          	ld	a0,-56(s0)
    800065cc:	fffff097          	auipc	ra,0xfffff
    800065d0:	81e080e7          	jalr	-2018(ra) # 80004dea <fileclose>
    return -1;
    800065d4:	57fd                	li	a5,-1
}
    800065d6:	853e                	mv	a0,a5
    800065d8:	70e2                	ld	ra,56(sp)
    800065da:	7442                	ld	s0,48(sp)
    800065dc:	74a2                	ld	s1,40(sp)
    800065de:	6121                	addi	sp,sp,64
    800065e0:	8082                	ret
	...

00000000800065f0 <kernelvec>:
    800065f0:	7111                	addi	sp,sp,-256
    800065f2:	e006                	sd	ra,0(sp)
    800065f4:	e40a                	sd	sp,8(sp)
    800065f6:	e80e                	sd	gp,16(sp)
    800065f8:	ec12                	sd	tp,24(sp)
    800065fa:	f016                	sd	t0,32(sp)
    800065fc:	f41a                	sd	t1,40(sp)
    800065fe:	f81e                	sd	t2,48(sp)
    80006600:	fc22                	sd	s0,56(sp)
    80006602:	e0a6                	sd	s1,64(sp)
    80006604:	e4aa                	sd	a0,72(sp)
    80006606:	e8ae                	sd	a1,80(sp)
    80006608:	ecb2                	sd	a2,88(sp)
    8000660a:	f0b6                	sd	a3,96(sp)
    8000660c:	f4ba                	sd	a4,104(sp)
    8000660e:	f8be                	sd	a5,112(sp)
    80006610:	fcc2                	sd	a6,120(sp)
    80006612:	e146                	sd	a7,128(sp)
    80006614:	e54a                	sd	s2,136(sp)
    80006616:	e94e                	sd	s3,144(sp)
    80006618:	ed52                	sd	s4,152(sp)
    8000661a:	f156                	sd	s5,160(sp)
    8000661c:	f55a                	sd	s6,168(sp)
    8000661e:	f95e                	sd	s7,176(sp)
    80006620:	fd62                	sd	s8,184(sp)
    80006622:	e1e6                	sd	s9,192(sp)
    80006624:	e5ea                	sd	s10,200(sp)
    80006626:	e9ee                	sd	s11,208(sp)
    80006628:	edf2                	sd	t3,216(sp)
    8000662a:	f1f6                	sd	t4,224(sp)
    8000662c:	f5fa                	sd	t5,232(sp)
    8000662e:	f9fe                	sd	t6,240(sp)
    80006630:	99dfc0ef          	jal	80002fcc <kerneltrap>
    80006634:	6082                	ld	ra,0(sp)
    80006636:	6122                	ld	sp,8(sp)
    80006638:	61c2                	ld	gp,16(sp)
    8000663a:	7282                	ld	t0,32(sp)
    8000663c:	7322                	ld	t1,40(sp)
    8000663e:	73c2                	ld	t2,48(sp)
    80006640:	7462                	ld	s0,56(sp)
    80006642:	6486                	ld	s1,64(sp)
    80006644:	6526                	ld	a0,72(sp)
    80006646:	65c6                	ld	a1,80(sp)
    80006648:	6666                	ld	a2,88(sp)
    8000664a:	7686                	ld	a3,96(sp)
    8000664c:	7726                	ld	a4,104(sp)
    8000664e:	77c6                	ld	a5,112(sp)
    80006650:	7866                	ld	a6,120(sp)
    80006652:	688a                	ld	a7,128(sp)
    80006654:	692a                	ld	s2,136(sp)
    80006656:	69ca                	ld	s3,144(sp)
    80006658:	6a6a                	ld	s4,152(sp)
    8000665a:	7a8a                	ld	s5,160(sp)
    8000665c:	7b2a                	ld	s6,168(sp)
    8000665e:	7bca                	ld	s7,176(sp)
    80006660:	7c6a                	ld	s8,184(sp)
    80006662:	6c8e                	ld	s9,192(sp)
    80006664:	6d2e                	ld	s10,200(sp)
    80006666:	6dce                	ld	s11,208(sp)
    80006668:	6e6e                	ld	t3,216(sp)
    8000666a:	7e8e                	ld	t4,224(sp)
    8000666c:	7f2e                	ld	t5,232(sp)
    8000666e:	7fce                	ld	t6,240(sp)
    80006670:	6111                	addi	sp,sp,256
    80006672:	10200073          	sret
    80006676:	00000013          	nop
    8000667a:	00000013          	nop
    8000667e:	0001                	nop

0000000080006680 <timervec>:
    80006680:	34051573          	csrrw	a0,mscratch,a0
    80006684:	e10c                	sd	a1,0(a0)
    80006686:	e510                	sd	a2,8(a0)
    80006688:	e914                	sd	a3,16(a0)
    8000668a:	6d0c                	ld	a1,24(a0)
    8000668c:	7110                	ld	a2,32(a0)
    8000668e:	6194                	ld	a3,0(a1)
    80006690:	96b2                	add	a3,a3,a2
    80006692:	e194                	sd	a3,0(a1)
    80006694:	4589                	li	a1,2
    80006696:	14459073          	csrw	sip,a1
    8000669a:	6914                	ld	a3,16(a0)
    8000669c:	6510                	ld	a2,8(a0)
    8000669e:	610c                	ld	a1,0(a0)
    800066a0:	34051573          	csrrw	a0,mscratch,a0
    800066a4:	30200073          	mret
    800066a8:	0001                	nop

00000000800066aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800066aa:	1141                	addi	sp,sp,-16
    800066ac:	e406                	sd	ra,8(sp)
    800066ae:	e022                	sd	s0,0(sp)
    800066b0:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800066b2:	0c000737          	lui	a4,0xc000
    800066b6:	4785                	li	a5,1
    800066b8:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800066ba:	c35c                	sw	a5,4(a4)
}
    800066bc:	60a2                	ld	ra,8(sp)
    800066be:	6402                	ld	s0,0(sp)
    800066c0:	0141                	addi	sp,sp,16
    800066c2:	8082                	ret

00000000800066c4 <plicinithart>:

void
plicinithart(void)
{
    800066c4:	1141                	addi	sp,sp,-16
    800066c6:	e406                	sd	ra,8(sp)
    800066c8:	e022                	sd	s0,0(sp)
    800066ca:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800066cc:	ffffb097          	auipc	ra,0xffffb
    800066d0:	48c080e7          	jalr	1164(ra) # 80001b58 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800066d4:	0085171b          	slliw	a4,a0,0x8
    800066d8:	0c0027b7          	lui	a5,0xc002
    800066dc:	97ba                	add	a5,a5,a4
    800066de:	40200713          	li	a4,1026
    800066e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800066e6:	00d5151b          	slliw	a0,a0,0xd
    800066ea:	0c2017b7          	lui	a5,0xc201
    800066ee:	97aa                	add	a5,a5,a0
    800066f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800066f4:	60a2                	ld	ra,8(sp)
    800066f6:	6402                	ld	s0,0(sp)
    800066f8:	0141                	addi	sp,sp,16
    800066fa:	8082                	ret

00000000800066fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800066fc:	1141                	addi	sp,sp,-16
    800066fe:	e406                	sd	ra,8(sp)
    80006700:	e022                	sd	s0,0(sp)
    80006702:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006704:	ffffb097          	auipc	ra,0xffffb
    80006708:	454080e7          	jalr	1108(ra) # 80001b58 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000670c:	00d5151b          	slliw	a0,a0,0xd
    80006710:	0c2017b7          	lui	a5,0xc201
    80006714:	97aa                	add	a5,a5,a0
  return irq;
}
    80006716:	43c8                	lw	a0,4(a5)
    80006718:	60a2                	ld	ra,8(sp)
    8000671a:	6402                	ld	s0,0(sp)
    8000671c:	0141                	addi	sp,sp,16
    8000671e:	8082                	ret

0000000080006720 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006720:	1101                	addi	sp,sp,-32
    80006722:	ec06                	sd	ra,24(sp)
    80006724:	e822                	sd	s0,16(sp)
    80006726:	e426                	sd	s1,8(sp)
    80006728:	1000                	addi	s0,sp,32
    8000672a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000672c:	ffffb097          	auipc	ra,0xffffb
    80006730:	42c080e7          	jalr	1068(ra) # 80001b58 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006734:	00d5179b          	slliw	a5,a0,0xd
    80006738:	0c201737          	lui	a4,0xc201
    8000673c:	97ba                	add	a5,a5,a4
    8000673e:	c3c4                	sw	s1,4(a5)
}
    80006740:	60e2                	ld	ra,24(sp)
    80006742:	6442                	ld	s0,16(sp)
    80006744:	64a2                	ld	s1,8(sp)
    80006746:	6105                	addi	sp,sp,32
    80006748:	8082                	ret

000000008000674a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000674a:	1141                	addi	sp,sp,-16
    8000674c:	e406                	sd	ra,8(sp)
    8000674e:	e022                	sd	s0,0(sp)
    80006750:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006752:	479d                	li	a5,7
    80006754:	04a7cc63          	blt	a5,a0,800067ac <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006758:	00047797          	auipc	a5,0x47
    8000675c:	8d078793          	addi	a5,a5,-1840 # 8004d028 <disk>
    80006760:	97aa                	add	a5,a5,a0
    80006762:	0187c783          	lbu	a5,24(a5)
    80006766:	ebb9                	bnez	a5,800067bc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006768:	00451693          	slli	a3,a0,0x4
    8000676c:	00047797          	auipc	a5,0x47
    80006770:	8bc78793          	addi	a5,a5,-1860 # 8004d028 <disk>
    80006774:	6398                	ld	a4,0(a5)
    80006776:	9736                	add	a4,a4,a3
    80006778:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    8000677c:	6398                	ld	a4,0(a5)
    8000677e:	9736                	add	a4,a4,a3
    80006780:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006784:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006788:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000678c:	97aa                	add	a5,a5,a0
    8000678e:	4705                	li	a4,1
    80006790:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006794:	00047517          	auipc	a0,0x47
    80006798:	8ac50513          	addi	a0,a0,-1876 # 8004d040 <disk+0x18>
    8000679c:	ffffc097          	auipc	ra,0xffffc
    800067a0:	cc4080e7          	jalr	-828(ra) # 80002460 <wakeup>
}
    800067a4:	60a2                	ld	ra,8(sp)
    800067a6:	6402                	ld	s0,0(sp)
    800067a8:	0141                	addi	sp,sp,16
    800067aa:	8082                	ret
    panic("free_desc 1");
    800067ac:	00002517          	auipc	a0,0x2
    800067b0:	02450513          	addi	a0,a0,36 # 800087d0 <etext+0x7d0>
    800067b4:	ffffa097          	auipc	ra,0xffffa
    800067b8:	daa080e7          	jalr	-598(ra) # 8000055e <panic>
    panic("free_desc 2");
    800067bc:	00002517          	auipc	a0,0x2
    800067c0:	02450513          	addi	a0,a0,36 # 800087e0 <etext+0x7e0>
    800067c4:	ffffa097          	auipc	ra,0xffffa
    800067c8:	d9a080e7          	jalr	-614(ra) # 8000055e <panic>

00000000800067cc <virtio_disk_init>:
{
    800067cc:	1101                	addi	sp,sp,-32
    800067ce:	ec06                	sd	ra,24(sp)
    800067d0:	e822                	sd	s0,16(sp)
    800067d2:	e426                	sd	s1,8(sp)
    800067d4:	e04a                	sd	s2,0(sp)
    800067d6:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800067d8:	00002597          	auipc	a1,0x2
    800067dc:	01858593          	addi	a1,a1,24 # 800087f0 <etext+0x7f0>
    800067e0:	00047517          	auipc	a0,0x47
    800067e4:	97050513          	addi	a0,a0,-1680 # 8004d150 <disk+0x128>
    800067e8:	ffffa097          	auipc	ra,0xffffa
    800067ec:	3da080e7          	jalr	986(ra) # 80000bc2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800067f0:	100017b7          	lui	a5,0x10001
    800067f4:	4398                	lw	a4,0(a5)
    800067f6:	2701                	sext.w	a4,a4
    800067f8:	747277b7          	lui	a5,0x74727
    800067fc:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006800:	16f71463          	bne	a4,a5,80006968 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006804:	100017b7          	lui	a5,0x10001
    80006808:	43dc                	lw	a5,4(a5)
    8000680a:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000680c:	4709                	li	a4,2
    8000680e:	14e79d63          	bne	a5,a4,80006968 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006812:	100017b7          	lui	a5,0x10001
    80006816:	479c                	lw	a5,8(a5)
    80006818:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000681a:	14e79763          	bne	a5,a4,80006968 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000681e:	100017b7          	lui	a5,0x10001
    80006822:	47d8                	lw	a4,12(a5)
    80006824:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006826:	554d47b7          	lui	a5,0x554d4
    8000682a:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000682e:	12f71d63          	bne	a4,a5,80006968 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006832:	100017b7          	lui	a5,0x10001
    80006836:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000683a:	4705                	li	a4,1
    8000683c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000683e:	470d                	li	a4,3
    80006840:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006842:	10001737          	lui	a4,0x10001
    80006846:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006848:	c7ffe6b7          	lui	a3,0xc7ffe
    8000684c:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fb15f7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006850:	8f75                	and	a4,a4,a3
    80006852:	100016b7          	lui	a3,0x10001
    80006856:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006858:	472d                	li	a4,11
    8000685a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000685c:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006860:	439c                	lw	a5,0(a5)
    80006862:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006866:	8ba1                	andi	a5,a5,8
    80006868:	10078863          	beqz	a5,80006978 <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000686c:	100017b7          	lui	a5,0x10001
    80006870:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006874:	43fc                	lw	a5,68(a5)
    80006876:	2781                	sext.w	a5,a5
    80006878:	10079863          	bnez	a5,80006988 <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000687c:	100017b7          	lui	a5,0x10001
    80006880:	5bdc                	lw	a5,52(a5)
    80006882:	2781                	sext.w	a5,a5
  if(max == 0)
    80006884:	10078a63          	beqz	a5,80006998 <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006888:	471d                	li	a4,7
    8000688a:	10f77f63          	bgeu	a4,a5,800069a8 <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    8000688e:	ffffa097          	auipc	ra,0xffffa
    80006892:	2ca080e7          	jalr	714(ra) # 80000b58 <kalloc>
    80006896:	00046497          	auipc	s1,0x46
    8000689a:	79248493          	addi	s1,s1,1938 # 8004d028 <disk>
    8000689e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800068a0:	ffffa097          	auipc	ra,0xffffa
    800068a4:	2b8080e7          	jalr	696(ra) # 80000b58 <kalloc>
    800068a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800068aa:	ffffa097          	auipc	ra,0xffffa
    800068ae:	2ae080e7          	jalr	686(ra) # 80000b58 <kalloc>
    800068b2:	87aa                	mv	a5,a0
    800068b4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800068b6:	6088                	ld	a0,0(s1)
    800068b8:	10050063          	beqz	a0,800069b8 <virtio_disk_init+0x1ec>
    800068bc:	00046717          	auipc	a4,0x46
    800068c0:	77473703          	ld	a4,1908(a4) # 8004d030 <disk+0x8>
    800068c4:	cb75                	beqz	a4,800069b8 <virtio_disk_init+0x1ec>
    800068c6:	cbed                	beqz	a5,800069b8 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800068c8:	6605                	lui	a2,0x1
    800068ca:	4581                	li	a1,0
    800068cc:	ffffa097          	auipc	ra,0xffffa
    800068d0:	488080e7          	jalr	1160(ra) # 80000d54 <memset>
  memset(disk.avail, 0, PGSIZE);
    800068d4:	00046497          	auipc	s1,0x46
    800068d8:	75448493          	addi	s1,s1,1876 # 8004d028 <disk>
    800068dc:	6605                	lui	a2,0x1
    800068de:	4581                	li	a1,0
    800068e0:	6488                	ld	a0,8(s1)
    800068e2:	ffffa097          	auipc	ra,0xffffa
    800068e6:	472080e7          	jalr	1138(ra) # 80000d54 <memset>
  memset(disk.used, 0, PGSIZE);
    800068ea:	6605                	lui	a2,0x1
    800068ec:	4581                	li	a1,0
    800068ee:	6888                	ld	a0,16(s1)
    800068f0:	ffffa097          	auipc	ra,0xffffa
    800068f4:	464080e7          	jalr	1124(ra) # 80000d54 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800068f8:	100017b7          	lui	a5,0x10001
    800068fc:	4721                	li	a4,8
    800068fe:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006900:	4098                	lw	a4,0(s1)
    80006902:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006906:	40d8                	lw	a4,4(s1)
    80006908:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000690c:	649c                	ld	a5,8(s1)
    8000690e:	0007869b          	sext.w	a3,a5
    80006912:	10001737          	lui	a4,0x10001
    80006916:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000691a:	9781                	srai	a5,a5,0x20
    8000691c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006920:	689c                	ld	a5,16(s1)
    80006922:	0007869b          	sext.w	a3,a5
    80006926:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000692a:	9781                	srai	a5,a5,0x20
    8000692c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006930:	4785                	li	a5,1
    80006932:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006934:	00f48c23          	sb	a5,24(s1)
    80006938:	00f48ca3          	sb	a5,25(s1)
    8000693c:	00f48d23          	sb	a5,26(s1)
    80006940:	00f48da3          	sb	a5,27(s1)
    80006944:	00f48e23          	sb	a5,28(s1)
    80006948:	00f48ea3          	sb	a5,29(s1)
    8000694c:	00f48f23          	sb	a5,30(s1)
    80006950:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006954:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006958:	07272823          	sw	s2,112(a4)
}
    8000695c:	60e2                	ld	ra,24(sp)
    8000695e:	6442                	ld	s0,16(sp)
    80006960:	64a2                	ld	s1,8(sp)
    80006962:	6902                	ld	s2,0(sp)
    80006964:	6105                	addi	sp,sp,32
    80006966:	8082                	ret
    panic("could not find virtio disk");
    80006968:	00002517          	auipc	a0,0x2
    8000696c:	e9850513          	addi	a0,a0,-360 # 80008800 <etext+0x800>
    80006970:	ffffa097          	auipc	ra,0xffffa
    80006974:	bee080e7          	jalr	-1042(ra) # 8000055e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006978:	00002517          	auipc	a0,0x2
    8000697c:	ea850513          	addi	a0,a0,-344 # 80008820 <etext+0x820>
    80006980:	ffffa097          	auipc	ra,0xffffa
    80006984:	bde080e7          	jalr	-1058(ra) # 8000055e <panic>
    panic("virtio disk should not be ready");
    80006988:	00002517          	auipc	a0,0x2
    8000698c:	eb850513          	addi	a0,a0,-328 # 80008840 <etext+0x840>
    80006990:	ffffa097          	auipc	ra,0xffffa
    80006994:	bce080e7          	jalr	-1074(ra) # 8000055e <panic>
    panic("virtio disk has no queue 0");
    80006998:	00002517          	auipc	a0,0x2
    8000699c:	ec850513          	addi	a0,a0,-312 # 80008860 <etext+0x860>
    800069a0:	ffffa097          	auipc	ra,0xffffa
    800069a4:	bbe080e7          	jalr	-1090(ra) # 8000055e <panic>
    panic("virtio disk max queue too short");
    800069a8:	00002517          	auipc	a0,0x2
    800069ac:	ed850513          	addi	a0,a0,-296 # 80008880 <etext+0x880>
    800069b0:	ffffa097          	auipc	ra,0xffffa
    800069b4:	bae080e7          	jalr	-1106(ra) # 8000055e <panic>
    panic("virtio disk kalloc");
    800069b8:	00002517          	auipc	a0,0x2
    800069bc:	ee850513          	addi	a0,a0,-280 # 800088a0 <etext+0x8a0>
    800069c0:	ffffa097          	auipc	ra,0xffffa
    800069c4:	b9e080e7          	jalr	-1122(ra) # 8000055e <panic>

00000000800069c8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800069c8:	711d                	addi	sp,sp,-96
    800069ca:	ec86                	sd	ra,88(sp)
    800069cc:	e8a2                	sd	s0,80(sp)
    800069ce:	e4a6                	sd	s1,72(sp)
    800069d0:	e0ca                	sd	s2,64(sp)
    800069d2:	fc4e                	sd	s3,56(sp)
    800069d4:	f852                	sd	s4,48(sp)
    800069d6:	f456                	sd	s5,40(sp)
    800069d8:	f05a                	sd	s6,32(sp)
    800069da:	ec5e                	sd	s7,24(sp)
    800069dc:	e862                	sd	s8,16(sp)
    800069de:	1080                	addi	s0,sp,96
    800069e0:	89aa                	mv	s3,a0
    800069e2:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800069e4:	00c52b83          	lw	s7,12(a0)
    800069e8:	001b9b9b          	slliw	s7,s7,0x1
    800069ec:	1b82                	slli	s7,s7,0x20
    800069ee:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800069f2:	00046517          	auipc	a0,0x46
    800069f6:	75e50513          	addi	a0,a0,1886 # 8004d150 <disk+0x128>
    800069fa:	ffffa097          	auipc	ra,0xffffa
    800069fe:	262080e7          	jalr	610(ra) # 80000c5c <acquire>
  for(int i = 0; i < NUM; i++){
    80006a02:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006a04:	00046a97          	auipc	s5,0x46
    80006a08:	624a8a93          	addi	s5,s5,1572 # 8004d028 <disk>
  for(int i = 0; i < 3; i++){
    80006a0c:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006a0e:	5c7d                	li	s8,-1
    80006a10:	a885                	j	80006a80 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006a12:	00fa8733          	add	a4,s5,a5
    80006a16:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006a1a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006a1c:	0207c563          	bltz	a5,80006a46 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006a20:	2905                	addiw	s2,s2,1
    80006a22:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006a24:	07490263          	beq	s2,s4,80006a88 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006a28:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006a2a:	00046717          	auipc	a4,0x46
    80006a2e:	5fe70713          	addi	a4,a4,1534 # 8004d028 <disk>
    80006a32:	4781                	li	a5,0
    if(disk.free[i]){
    80006a34:	01874683          	lbu	a3,24(a4)
    80006a38:	fee9                	bnez	a3,80006a12 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80006a3a:	2785                	addiw	a5,a5,1
    80006a3c:	0705                	addi	a4,a4,1
    80006a3e:	fe979be3          	bne	a5,s1,80006a34 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006a42:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006a46:	03205163          	blez	s2,80006a68 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006a4a:	fa042503          	lw	a0,-96(s0)
    80006a4e:	00000097          	auipc	ra,0x0
    80006a52:	cfc080e7          	jalr	-772(ra) # 8000674a <free_desc>
      for(int j = 0; j < i; j++)
    80006a56:	4785                	li	a5,1
    80006a58:	0127d863          	bge	a5,s2,80006a68 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    80006a5c:	fa442503          	lw	a0,-92(s0)
    80006a60:	00000097          	auipc	ra,0x0
    80006a64:	cea080e7          	jalr	-790(ra) # 8000674a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006a68:	00046597          	auipc	a1,0x46
    80006a6c:	6e858593          	addi	a1,a1,1768 # 8004d150 <disk+0x128>
    80006a70:	00046517          	auipc	a0,0x46
    80006a74:	5d050513          	addi	a0,a0,1488 # 8004d040 <disk+0x18>
    80006a78:	ffffc097          	auipc	ra,0xffffc
    80006a7c:	984080e7          	jalr	-1660(ra) # 800023fc <sleep>
  for(int i = 0; i < 3; i++){
    80006a80:	fa040613          	addi	a2,s0,-96
    80006a84:	4901                	li	s2,0
    80006a86:	b74d                	j	80006a28 <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006a88:	fa042503          	lw	a0,-96(s0)
    80006a8c:	00451693          	slli	a3,a0,0x4

  if(write)
    80006a90:	00046797          	auipc	a5,0x46
    80006a94:	59878793          	addi	a5,a5,1432 # 8004d028 <disk>
    80006a98:	00451713          	slli	a4,a0,0x4
    80006a9c:	0a070713          	addi	a4,a4,160
    80006aa0:	973e                	add	a4,a4,a5
    80006aa2:	01603633          	snez	a2,s6
    80006aa6:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006aa8:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006aac:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006ab0:	6398                	ld	a4,0(a5)
    80006ab2:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006ab4:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006ab8:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006aba:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006abc:	6390                	ld	a2,0(a5)
    80006abe:	00d60833          	add	a6,a2,a3
    80006ac2:	4741                	li	a4,16
    80006ac4:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006ac8:	4585                	li	a1,1
    80006aca:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80006ace:	fa442703          	lw	a4,-92(s0)
    80006ad2:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006ad6:	0712                	slli	a4,a4,0x4
    80006ad8:	963a                	add	a2,a2,a4
    80006ada:	05898813          	addi	a6,s3,88
    80006ade:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006ae2:	0007b883          	ld	a7,0(a5)
    80006ae6:	9746                	add	a4,a4,a7
    80006ae8:	40000613          	li	a2,1024
    80006aec:	c710                	sw	a2,8(a4)
  if(write)
    80006aee:	001b3613          	seqz	a2,s6
    80006af2:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006af6:	8e4d                	or	a2,a2,a1
    80006af8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006afc:	fa842603          	lw	a2,-88(s0)
    80006b00:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006b04:	00451813          	slli	a6,a0,0x4
    80006b08:	02080813          	addi	a6,a6,32
    80006b0c:	983e                	add	a6,a6,a5
    80006b0e:	577d                	li	a4,-1
    80006b10:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006b14:	0612                	slli	a2,a2,0x4
    80006b16:	98b2                	add	a7,a7,a2
    80006b18:	03068713          	addi	a4,a3,48
    80006b1c:	973e                	add	a4,a4,a5
    80006b1e:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006b22:	6398                	ld	a4,0(a5)
    80006b24:	9732                	add	a4,a4,a2
    80006b26:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006b28:	4689                	li	a3,2
    80006b2a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006b2e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006b32:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80006b36:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006b3a:	6794                	ld	a3,8(a5)
    80006b3c:	0026d703          	lhu	a4,2(a3)
    80006b40:	8b1d                	andi	a4,a4,7
    80006b42:	0706                	slli	a4,a4,0x1
    80006b44:	96ba                	add	a3,a3,a4
    80006b46:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006b4a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006b4e:	6798                	ld	a4,8(a5)
    80006b50:	00275783          	lhu	a5,2(a4)
    80006b54:	2785                	addiw	a5,a5,1
    80006b56:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006b5a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006b5e:	100017b7          	lui	a5,0x10001
    80006b62:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006b66:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006b6a:	00046917          	auipc	s2,0x46
    80006b6e:	5e690913          	addi	s2,s2,1510 # 8004d150 <disk+0x128>
  while(b->disk == 1) {
    80006b72:	84ae                	mv	s1,a1
    80006b74:	00b79c63          	bne	a5,a1,80006b8c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006b78:	85ca                	mv	a1,s2
    80006b7a:	854e                	mv	a0,s3
    80006b7c:	ffffc097          	auipc	ra,0xffffc
    80006b80:	880080e7          	jalr	-1920(ra) # 800023fc <sleep>
  while(b->disk == 1) {
    80006b84:	0049a783          	lw	a5,4(s3)
    80006b88:	fe9788e3          	beq	a5,s1,80006b78 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006b8c:	fa042903          	lw	s2,-96(s0)
    80006b90:	00491713          	slli	a4,s2,0x4
    80006b94:	02070713          	addi	a4,a4,32
    80006b98:	00046797          	auipc	a5,0x46
    80006b9c:	49078793          	addi	a5,a5,1168 # 8004d028 <disk>
    80006ba0:	97ba                	add	a5,a5,a4
    80006ba2:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006ba6:	00046997          	auipc	s3,0x46
    80006baa:	48298993          	addi	s3,s3,1154 # 8004d028 <disk>
    80006bae:	00491713          	slli	a4,s2,0x4
    80006bb2:	0009b783          	ld	a5,0(s3)
    80006bb6:	97ba                	add	a5,a5,a4
    80006bb8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006bbc:	854a                	mv	a0,s2
    80006bbe:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006bc2:	00000097          	auipc	ra,0x0
    80006bc6:	b88080e7          	jalr	-1144(ra) # 8000674a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006bca:	8885                	andi	s1,s1,1
    80006bcc:	f0ed                	bnez	s1,80006bae <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006bce:	00046517          	auipc	a0,0x46
    80006bd2:	58250513          	addi	a0,a0,1410 # 8004d150 <disk+0x128>
    80006bd6:	ffffa097          	auipc	ra,0xffffa
    80006bda:	136080e7          	jalr	310(ra) # 80000d0c <release>
}
    80006bde:	60e6                	ld	ra,88(sp)
    80006be0:	6446                	ld	s0,80(sp)
    80006be2:	64a6                	ld	s1,72(sp)
    80006be4:	6906                	ld	s2,64(sp)
    80006be6:	79e2                	ld	s3,56(sp)
    80006be8:	7a42                	ld	s4,48(sp)
    80006bea:	7aa2                	ld	s5,40(sp)
    80006bec:	7b02                	ld	s6,32(sp)
    80006bee:	6be2                	ld	s7,24(sp)
    80006bf0:	6c42                	ld	s8,16(sp)
    80006bf2:	6125                	addi	sp,sp,96
    80006bf4:	8082                	ret

0000000080006bf6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006bf6:	1101                	addi	sp,sp,-32
    80006bf8:	ec06                	sd	ra,24(sp)
    80006bfa:	e822                	sd	s0,16(sp)
    80006bfc:	e426                	sd	s1,8(sp)
    80006bfe:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006c00:	00046497          	auipc	s1,0x46
    80006c04:	42848493          	addi	s1,s1,1064 # 8004d028 <disk>
    80006c08:	00046517          	auipc	a0,0x46
    80006c0c:	54850513          	addi	a0,a0,1352 # 8004d150 <disk+0x128>
    80006c10:	ffffa097          	auipc	ra,0xffffa
    80006c14:	04c080e7          	jalr	76(ra) # 80000c5c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006c18:	100017b7          	lui	a5,0x10001
    80006c1c:	53bc                	lw	a5,96(a5)
    80006c1e:	8b8d                	andi	a5,a5,3
    80006c20:	10001737          	lui	a4,0x10001
    80006c24:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006c26:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006c2a:	689c                	ld	a5,16(s1)
    80006c2c:	0204d703          	lhu	a4,32(s1)
    80006c30:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006c34:	04f70a63          	beq	a4,a5,80006c88 <virtio_disk_intr+0x92>
    __sync_synchronize();
    80006c38:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006c3c:	6898                	ld	a4,16(s1)
    80006c3e:	0204d783          	lhu	a5,32(s1)
    80006c42:	8b9d                	andi	a5,a5,7
    80006c44:	078e                	slli	a5,a5,0x3
    80006c46:	97ba                	add	a5,a5,a4
    80006c48:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006c4a:	00479713          	slli	a4,a5,0x4
    80006c4e:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80006c52:	9726                	add	a4,a4,s1
    80006c54:	01074703          	lbu	a4,16(a4)
    80006c58:	e729                	bnez	a4,80006ca2 <virtio_disk_intr+0xac>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006c5a:	0792                	slli	a5,a5,0x4
    80006c5c:	02078793          	addi	a5,a5,32
    80006c60:	97a6                	add	a5,a5,s1
    80006c62:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006c64:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006c68:	ffffb097          	auipc	ra,0xffffb
    80006c6c:	7f8080e7          	jalr	2040(ra) # 80002460 <wakeup>

    disk.used_idx += 1;
    80006c70:	0204d783          	lhu	a5,32(s1)
    80006c74:	2785                	addiw	a5,a5,1
    80006c76:	17c2                	slli	a5,a5,0x30
    80006c78:	93c1                	srli	a5,a5,0x30
    80006c7a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006c7e:	6898                	ld	a4,16(s1)
    80006c80:	00275703          	lhu	a4,2(a4)
    80006c84:	faf71ae3          	bne	a4,a5,80006c38 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006c88:	00046517          	auipc	a0,0x46
    80006c8c:	4c850513          	addi	a0,a0,1224 # 8004d150 <disk+0x128>
    80006c90:	ffffa097          	auipc	ra,0xffffa
    80006c94:	07c080e7          	jalr	124(ra) # 80000d0c <release>
}
    80006c98:	60e2                	ld	ra,24(sp)
    80006c9a:	6442                	ld	s0,16(sp)
    80006c9c:	64a2                	ld	s1,8(sp)
    80006c9e:	6105                	addi	sp,sp,32
    80006ca0:	8082                	ret
      panic("virtio_disk_intr status");
    80006ca2:	00002517          	auipc	a0,0x2
    80006ca6:	c1650513          	addi	a0,a0,-1002 # 800088b8 <etext+0x8b8>
    80006caa:	ffffa097          	auipc	ra,0xffffa
    80006cae:	8b4080e7          	jalr	-1868(ra) # 8000055e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
