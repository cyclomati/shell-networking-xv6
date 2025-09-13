
user/_cfslog:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 2){
   8:	4789                	li	a5,2
   a:	02f50163          	beq	a0,a5,2c <main+0x2c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
    printf("usage: cfslog <0|1>\n");
  12:	00001517          	auipc	a0,0x1
  16:	89650513          	addi	a0,a0,-1898 # 8a8 <malloc+0x118>
  1a:	00000097          	auipc	ra,0x0
  1e:	6ba080e7          	jalr	1722(ra) # 6d4 <printf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	322080e7          	jalr	802(ra) # 346 <exit>
  2c:	e426                	sd	s1,8(sp)
  2e:	e04a                	sd	s2,0(sp)
  }
  int on = argv[1][0] == '1' ? 1 : 0;
  30:	659c                	ld	a5,8(a1)
  32:	0007c483          	lbu	s1,0(a5)
  36:	fcf48793          	addi	a5,s1,-49
  3a:	0017b793          	seqz	a5,a5
  3e:	893e                	mv	s2,a5
  int r = setcfslog(on);
  40:	853e                	mv	a0,a5
  42:	00000097          	auipc	ra,0x0
  46:	3c4080e7          	jalr	964(ra) # 406 <setcfslog>
  if(r < 0){
  4a:	02054763          	bltz	a0,78 <main+0x78>
    printf("cfslog: failed to set log %d\n", on);
    exit(1);
  }
  printf("cfslog: logging %s\n", on ? "enabled" : "disabled");
  4e:	03100793          	li	a5,49
  52:	00001597          	auipc	a1,0x1
  56:	84658593          	addi	a1,a1,-1978 # 898 <malloc+0x108>
  5a:	02f48d63          	beq	s1,a5,94 <main+0x94>
  5e:	00001517          	auipc	a0,0x1
  62:	88250513          	addi	a0,a0,-1918 # 8e0 <malloc+0x150>
  66:	00000097          	auipc	ra,0x0
  6a:	66e080e7          	jalr	1646(ra) # 6d4 <printf>
  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	2d6080e7          	jalr	726(ra) # 346 <exit>
    printf("cfslog: failed to set log %d\n", on);
  78:	85ca                	mv	a1,s2
  7a:	00001517          	auipc	a0,0x1
  7e:	84650513          	addi	a0,a0,-1978 # 8c0 <malloc+0x130>
  82:	00000097          	auipc	ra,0x0
  86:	652080e7          	jalr	1618(ra) # 6d4 <printf>
    exit(1);
  8a:	4505                	li	a0,1
  8c:	00000097          	auipc	ra,0x0
  90:	2ba080e7          	jalr	698(ra) # 346 <exit>
  printf("cfslog: logging %s\n", on ? "enabled" : "disabled");
  94:	00000597          	auipc	a1,0x0
  98:	7fc58593          	addi	a1,a1,2044 # 890 <malloc+0x100>
  9c:	b7c9                	j	5e <main+0x5e>

000000000000009e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e406                	sd	ra,8(sp)
  a2:	e022                	sd	s0,0(sp)
  a4:	0800                	addi	s0,sp,16
  extern int main();
  main();
  a6:	00000097          	auipc	ra,0x0
  aa:	f5a080e7          	jalr	-166(ra) # 0 <main>
  exit(0);
  ae:	4501                	li	a0,0
  b0:	00000097          	auipc	ra,0x0
  b4:	296080e7          	jalr	662(ra) # 346 <exit>

00000000000000b8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e406                	sd	ra,8(sp)
  bc:	e022                	sd	s0,0(sp)
  be:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c0:	87aa                	mv	a5,a0
  c2:	0585                	addi	a1,a1,1
  c4:	0785                	addi	a5,a5,1
  c6:	fff5c703          	lbu	a4,-1(a1)
  ca:	fee78fa3          	sb	a4,-1(a5)
  ce:	fb75                	bnez	a4,c2 <strcpy+0xa>
    ;
  return os;
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cb91                	beqz	a5,f8 <strcmp+0x20>
  e6:	0005c703          	lbu	a4,0(a1)
  ea:	00f71763          	bne	a4,a5,f8 <strcmp+0x20>
    p++, q++;
  ee:	0505                	addi	a0,a0,1
  f0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  f2:	00054783          	lbu	a5,0(a0)
  f6:	fbe5                	bnez	a5,e6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  f8:	0005c503          	lbu	a0,0(a1)
}
  fc:	40a7853b          	subw	a0,a5,a0
 100:	60a2                	ld	ra,8(sp)
 102:	6402                	ld	s0,0(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strlen>:

uint
strlen(const char *s)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 110:	00054783          	lbu	a5,0(a0)
 114:	cf91                	beqz	a5,130 <strlen+0x28>
 116:	00150793          	addi	a5,a0,1
 11a:	86be                	mv	a3,a5
 11c:	0785                	addi	a5,a5,1
 11e:	fff7c703          	lbu	a4,-1(a5)
 122:	ff65                	bnez	a4,11a <strlen+0x12>
 124:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 128:	60a2                	ld	ra,8(sp)
 12a:	6402                	ld	s0,0(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret
  for(n = 0; s[n]; n++)
 130:	4501                	li	a0,0
 132:	bfdd                	j	128 <strlen+0x20>

0000000000000134 <memset>:

void*
memset(void *dst, int c, uint n)
{
 134:	1141                	addi	sp,sp,-16
 136:	e406                	sd	ra,8(sp)
 138:	e022                	sd	s0,0(sp)
 13a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 13c:	ca19                	beqz	a2,152 <memset+0x1e>
 13e:	87aa                	mv	a5,a0
 140:	1602                	slli	a2,a2,0x20
 142:	9201                	srli	a2,a2,0x20
 144:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 148:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 14c:	0785                	addi	a5,a5,1
 14e:	fee79de3          	bne	a5,a4,148 <memset+0x14>
  }
  return dst;
}
 152:	60a2                	ld	ra,8(sp)
 154:	6402                	ld	s0,0(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strchr>:

char*
strchr(const char *s, char c)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e406                	sd	ra,8(sp)
 15e:	e022                	sd	s0,0(sp)
 160:	0800                	addi	s0,sp,16
  for(; *s; s++)
 162:	00054783          	lbu	a5,0(a0)
 166:	cf81                	beqz	a5,17e <strchr+0x24>
    if(*s == c)
 168:	00f58763          	beq	a1,a5,176 <strchr+0x1c>
  for(; *s; s++)
 16c:	0505                	addi	a0,a0,1
 16e:	00054783          	lbu	a5,0(a0)
 172:	fbfd                	bnez	a5,168 <strchr+0xe>
      return (char*)s;
  return 0;
 174:	4501                	li	a0,0
}
 176:	60a2                	ld	ra,8(sp)
 178:	6402                	ld	s0,0(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret
  return 0;
 17e:	4501                	li	a0,0
 180:	bfdd                	j	176 <strchr+0x1c>

0000000000000182 <gets>:

char*
gets(char *buf, int max)
{
 182:	711d                	addi	sp,sp,-96
 184:	ec86                	sd	ra,88(sp)
 186:	e8a2                	sd	s0,80(sp)
 188:	e4a6                	sd	s1,72(sp)
 18a:	e0ca                	sd	s2,64(sp)
 18c:	fc4e                	sd	s3,56(sp)
 18e:	f852                	sd	s4,48(sp)
 190:	f456                	sd	s5,40(sp)
 192:	f05a                	sd	s6,32(sp)
 194:	ec5e                	sd	s7,24(sp)
 196:	e862                	sd	s8,16(sp)
 198:	1080                	addi	s0,sp,96
 19a:	8baa                	mv	s7,a0
 19c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	892a                	mv	s2,a0
 1a0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1a2:	faf40b13          	addi	s6,s0,-81
 1a6:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1a8:	8c26                	mv	s8,s1
 1aa:	0014899b          	addiw	s3,s1,1
 1ae:	84ce                	mv	s1,s3
 1b0:	0349d663          	bge	s3,s4,1dc <gets+0x5a>
    cc = read(0, &c, 1);
 1b4:	8656                	mv	a2,s5
 1b6:	85da                	mv	a1,s6
 1b8:	4501                	li	a0,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	1a4080e7          	jalr	420(ra) # 35e <read>
    if(cc < 1)
 1c2:	00a05d63          	blez	a0,1dc <gets+0x5a>
      break;
    buf[i++] = c;
 1c6:	faf44783          	lbu	a5,-81(s0)
 1ca:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ce:	0905                	addi	s2,s2,1
 1d0:	ff678713          	addi	a4,a5,-10
 1d4:	c319                	beqz	a4,1da <gets+0x58>
 1d6:	17cd                	addi	a5,a5,-13
 1d8:	fbe1                	bnez	a5,1a8 <gets+0x26>
    buf[i++] = c;
 1da:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1dc:	9c5e                	add	s8,s8,s7
 1de:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1e2:	855e                	mv	a0,s7
 1e4:	60e6                	ld	ra,88(sp)
 1e6:	6446                	ld	s0,80(sp)
 1e8:	64a6                	ld	s1,72(sp)
 1ea:	6906                	ld	s2,64(sp)
 1ec:	79e2                	ld	s3,56(sp)
 1ee:	7a42                	ld	s4,48(sp)
 1f0:	7aa2                	ld	s5,40(sp)
 1f2:	7b02                	ld	s6,32(sp)
 1f4:	6be2                	ld	s7,24(sp)
 1f6:	6c42                	ld	s8,16(sp)
 1f8:	6125                	addi	sp,sp,96
 1fa:	8082                	ret

00000000000001fc <stat>:

int
stat(const char *n, struct stat *st)
{
 1fc:	1101                	addi	sp,sp,-32
 1fe:	ec06                	sd	ra,24(sp)
 200:	e822                	sd	s0,16(sp)
 202:	e04a                	sd	s2,0(sp)
 204:	1000                	addi	s0,sp,32
 206:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 208:	4581                	li	a1,0
 20a:	00000097          	auipc	ra,0x0
 20e:	17c080e7          	jalr	380(ra) # 386 <open>
  if(fd < 0)
 212:	02054663          	bltz	a0,23e <stat+0x42>
 216:	e426                	sd	s1,8(sp)
 218:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21a:	85ca                	mv	a1,s2
 21c:	00000097          	auipc	ra,0x0
 220:	182080e7          	jalr	386(ra) # 39e <fstat>
 224:	892a                	mv	s2,a0
  close(fd);
 226:	8526                	mv	a0,s1
 228:	00000097          	auipc	ra,0x0
 22c:	146080e7          	jalr	326(ra) # 36e <close>
  return r;
 230:	64a2                	ld	s1,8(sp)
}
 232:	854a                	mv	a0,s2
 234:	60e2                	ld	ra,24(sp)
 236:	6442                	ld	s0,16(sp)
 238:	6902                	ld	s2,0(sp)
 23a:	6105                	addi	sp,sp,32
 23c:	8082                	ret
    return -1;
 23e:	57fd                	li	a5,-1
 240:	893e                	mv	s2,a5
 242:	bfc5                	j	232 <stat+0x36>

0000000000000244 <atoi>:

int
atoi(const char *s)
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24c:	00054683          	lbu	a3,0(a0)
 250:	fd06879b          	addiw	a5,a3,-48
 254:	0ff7f793          	zext.b	a5,a5
 258:	4625                	li	a2,9
 25a:	02f66963          	bltu	a2,a5,28c <atoi+0x48>
 25e:	872a                	mv	a4,a0
  n = 0;
 260:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 262:	0705                	addi	a4,a4,1
 264:	0025179b          	slliw	a5,a0,0x2
 268:	9fa9                	addw	a5,a5,a0
 26a:	0017979b          	slliw	a5,a5,0x1
 26e:	9fb5                	addw	a5,a5,a3
 270:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 274:	00074683          	lbu	a3,0(a4)
 278:	fd06879b          	addiw	a5,a3,-48
 27c:	0ff7f793          	zext.b	a5,a5
 280:	fef671e3          	bgeu	a2,a5,262 <atoi+0x1e>
  return n;
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  n = 0;
 28c:	4501                	li	a0,0
 28e:	bfdd                	j	284 <atoi+0x40>

0000000000000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 298:	02b57563          	bgeu	a0,a1,2c2 <memmove+0x32>
    while(n-- > 0)
 29c:	00c05f63          	blez	a2,2ba <memmove+0x2a>
 2a0:	1602                	slli	a2,a2,0x20
 2a2:	9201                	srli	a2,a2,0x20
 2a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2aa:	0585                	addi	a1,a1,1
 2ac:	0705                	addi	a4,a4,1
 2ae:	fff5c683          	lbu	a3,-1(a1)
 2b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b6:	fee79ae3          	bne	a5,a4,2aa <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
    while(n-- > 0)
 2c2:	fec05ce3          	blez	a2,2ba <memmove+0x2a>
    dst += n;
 2c6:	00c50733          	add	a4,a0,a2
    src += n;
 2ca:	95b2                	add	a1,a1,a2
 2cc:	fff6079b          	addiw	a5,a2,-1
 2d0:	1782                	slli	a5,a5,0x20
 2d2:	9381                	srli	a5,a5,0x20
 2d4:	fff7c793          	not	a5,a5
 2d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2da:	15fd                	addi	a1,a1,-1
 2dc:	177d                	addi	a4,a4,-1
 2de:	0005c683          	lbu	a3,0(a1)
 2e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e6:	fef71ae3          	bne	a4,a5,2da <memmove+0x4a>
 2ea:	bfc1                	j	2ba <memmove+0x2a>

00000000000002ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f4:	c61d                	beqz	a2,322 <memcmp+0x36>
 2f6:	1602                	slli	a2,a2,0x20
 2f8:	9201                	srli	a2,a2,0x20
 2fa:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2fe:	00054783          	lbu	a5,0(a0)
 302:	0005c703          	lbu	a4,0(a1)
 306:	00e79863          	bne	a5,a4,316 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 30a:	0505                	addi	a0,a0,1
    p2++;
 30c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 30e:	fed518e3          	bne	a0,a3,2fe <memcmp+0x12>
  }
  return 0;
 312:	4501                	li	a0,0
 314:	a019                	j	31a <memcmp+0x2e>
      return *p1 - *p2;
 316:	40e7853b          	subw	a0,a5,a4
}
 31a:	60a2                	ld	ra,8(sp)
 31c:	6402                	ld	s0,0(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
  return 0;
 322:	4501                	li	a0,0
 324:	bfdd                	j	31a <memcmp+0x2e>

0000000000000326 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 32e:	00000097          	auipc	ra,0x0
 332:	f62080e7          	jalr	-158(ra) # 290 <memmove>
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 33e:	4885                	li	a7,1
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <exit>:
.global exit
exit:
 li a7, SYS_exit
 346:	4889                	li	a7,2
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <wait>:
.global wait
wait:
 li a7, SYS_wait
 34e:	488d                	li	a7,3
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 356:	4891                	li	a7,4
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <read>:
.global read
read:
 li a7, SYS_read
 35e:	4895                	li	a7,5
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <write>:
.global write
write:
 li a7, SYS_write
 366:	48c1                	li	a7,16
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <close>:
.global close
close:
 li a7, SYS_close
 36e:	48d5                	li	a7,21
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <kill>:
.global kill
kill:
 li a7, SYS_kill
 376:	4899                	li	a7,6
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <exec>:
.global exec
exec:
 li a7, SYS_exec
 37e:	489d                	li	a7,7
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <open>:
.global open
open:
 li a7, SYS_open
 386:	48bd                	li	a7,15
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 38e:	48c5                	li	a7,17
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 396:	48c9                	li	a7,18
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 39e:	48a1                	li	a7,8
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <link>:
.global link
link:
 li a7, SYS_link
 3a6:	48cd                	li	a7,19
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ae:	48d1                	li	a7,20
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b6:	48a5                	li	a7,9
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <dup>:
.global dup
dup:
 li a7, SYS_dup
 3be:	48a9                	li	a7,10
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c6:	48ad                	li	a7,11
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ce:	48b1                	li	a7,12
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3d6:	48b5                	li	a7,13
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3de:	48b9                	li	a7,14
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3e6:	48d9                	li	a7,22
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 3ee:	48dd                	li	a7,23
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <printlog>:
.global printlog
printlog:
 li a7, SYS_printlog
 3f6:	48e1                	li	a7,24
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 3fe:	48e5                	li	a7,25
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <setcfslog>:
.global setcfslog
setcfslog:
 li a7, SYS_setcfslog
 406:	48e9                	li	a7,26
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 40e:	1101                	addi	sp,sp,-32
 410:	ec06                	sd	ra,24(sp)
 412:	e822                	sd	s0,16(sp)
 414:	1000                	addi	s0,sp,32
 416:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41a:	4605                	li	a2,1
 41c:	fef40593          	addi	a1,s0,-17
 420:	00000097          	auipc	ra,0x0
 424:	f46080e7          	jalr	-186(ra) # 366 <write>
}
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6105                	addi	sp,sp,32
 42e:	8082                	ret

0000000000000430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	7139                	addi	sp,sp,-64
 432:	fc06                	sd	ra,56(sp)
 434:	f822                	sd	s0,48(sp)
 436:	f04a                	sd	s2,32(sp)
 438:	ec4e                	sd	s3,24(sp)
 43a:	0080                	addi	s0,sp,64
 43c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43e:	cad9                	beqz	a3,4d4 <printint+0xa4>
 440:	01f5d79b          	srliw	a5,a1,0x1f
 444:	cbc1                	beqz	a5,4d4 <printint+0xa4>
    neg = 1;
    x = -xx;
 446:	40b005bb          	negw	a1,a1
    neg = 1;
 44a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 44c:	fc040993          	addi	s3,s0,-64
  neg = 0;
 450:	86ce                	mv	a3,s3
  i = 0;
 452:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 454:	00000817          	auipc	a6,0x0
 458:	50480813          	addi	a6,a6,1284 # 958 <digits>
 45c:	88ba                	mv	a7,a4
 45e:	0017051b          	addiw	a0,a4,1
 462:	872a                	mv	a4,a0
 464:	02c5f7bb          	remuw	a5,a1,a2
 468:	1782                	slli	a5,a5,0x20
 46a:	9381                	srli	a5,a5,0x20
 46c:	97c2                	add	a5,a5,a6
 46e:	0007c783          	lbu	a5,0(a5)
 472:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 476:	87ae                	mv	a5,a1
 478:	02c5d5bb          	divuw	a1,a1,a2
 47c:	0685                	addi	a3,a3,1
 47e:	fcc7ffe3          	bgeu	a5,a2,45c <printint+0x2c>
  if(neg)
 482:	00030c63          	beqz	t1,49a <printint+0x6a>
    buf[i++] = '-';
 486:	fd050793          	addi	a5,a0,-48
 48a:	00878533          	add	a0,a5,s0
 48e:	02d00793          	li	a5,45
 492:	fef50823          	sb	a5,-16(a0)
 496:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 49a:	02e05763          	blez	a4,4c8 <printint+0x98>
 49e:	f426                	sd	s1,40(sp)
 4a0:	377d                	addiw	a4,a4,-1
 4a2:	00e984b3          	add	s1,s3,a4
 4a6:	19fd                	addi	s3,s3,-1
 4a8:	99ba                	add	s3,s3,a4
 4aa:	1702                	slli	a4,a4,0x20
 4ac:	9301                	srli	a4,a4,0x20
 4ae:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4b2:	0004c583          	lbu	a1,0(s1)
 4b6:	854a                	mv	a0,s2
 4b8:	00000097          	auipc	ra,0x0
 4bc:	f56080e7          	jalr	-170(ra) # 40e <putc>
  while(--i >= 0)
 4c0:	14fd                	addi	s1,s1,-1
 4c2:	ff3498e3          	bne	s1,s3,4b2 <printint+0x82>
 4c6:	74a2                	ld	s1,40(sp)
}
 4c8:	70e2                	ld	ra,56(sp)
 4ca:	7442                	ld	s0,48(sp)
 4cc:	7902                	ld	s2,32(sp)
 4ce:	69e2                	ld	s3,24(sp)
 4d0:	6121                	addi	sp,sp,64
 4d2:	8082                	ret
  neg = 0;
 4d4:	4301                	li	t1,0
 4d6:	bf9d                	j	44c <printint+0x1c>

00000000000004d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d8:	715d                	addi	sp,sp,-80
 4da:	e486                	sd	ra,72(sp)
 4dc:	e0a2                	sd	s0,64(sp)
 4de:	f84a                	sd	s2,48(sp)
 4e0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4e2:	0005c903          	lbu	s2,0(a1)
 4e6:	1a090b63          	beqz	s2,69c <vprintf+0x1c4>
 4ea:	fc26                	sd	s1,56(sp)
 4ec:	f44e                	sd	s3,40(sp)
 4ee:	f052                	sd	s4,32(sp)
 4f0:	ec56                	sd	s5,24(sp)
 4f2:	e85a                	sd	s6,16(sp)
 4f4:	e45e                	sd	s7,8(sp)
 4f6:	8aaa                	mv	s5,a0
 4f8:	8bb2                	mv	s7,a2
 4fa:	00158493          	addi	s1,a1,1
  state = 0;
 4fe:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 500:	02500a13          	li	s4,37
 504:	4b55                	li	s6,21
 506:	a839                	j	524 <vprintf+0x4c>
        putc(fd, c);
 508:	85ca                	mv	a1,s2
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	f02080e7          	jalr	-254(ra) # 40e <putc>
 514:	a019                	j	51a <vprintf+0x42>
    } else if(state == '%'){
 516:	01498d63          	beq	s3,s4,530 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 51a:	0485                	addi	s1,s1,1
 51c:	fff4c903          	lbu	s2,-1(s1)
 520:	16090863          	beqz	s2,690 <vprintf+0x1b8>
    if(state == 0){
 524:	fe0999e3          	bnez	s3,516 <vprintf+0x3e>
      if(c == '%'){
 528:	ff4910e3          	bne	s2,s4,508 <vprintf+0x30>
        state = '%';
 52c:	89d2                	mv	s3,s4
 52e:	b7f5                	j	51a <vprintf+0x42>
      if(c == 'd'){
 530:	13490563          	beq	s2,s4,65a <vprintf+0x182>
 534:	f9d9079b          	addiw	a5,s2,-99
 538:	0ff7f793          	zext.b	a5,a5
 53c:	12fb6863          	bltu	s6,a5,66c <vprintf+0x194>
 540:	f9d9079b          	addiw	a5,s2,-99
 544:	0ff7f713          	zext.b	a4,a5
 548:	12eb6263          	bltu	s6,a4,66c <vprintf+0x194>
 54c:	00271793          	slli	a5,a4,0x2
 550:	00000717          	auipc	a4,0x0
 554:	3b070713          	addi	a4,a4,944 # 900 <malloc+0x170>
 558:	97ba                	add	a5,a5,a4
 55a:	439c                	lw	a5,0(a5)
 55c:	97ba                	add	a5,a5,a4
 55e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 560:	008b8913          	addi	s2,s7,8
 564:	4685                	li	a3,1
 566:	4629                	li	a2,10
 568:	000ba583          	lw	a1,0(s7)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	ec2080e7          	jalr	-318(ra) # 430 <printint>
 576:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 578:	4981                	li	s3,0
 57a:	b745                	j	51a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57c:	008b8913          	addi	s2,s7,8
 580:	4681                	li	a3,0
 582:	4629                	li	a2,10
 584:	000ba583          	lw	a1,0(s7)
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	ea6080e7          	jalr	-346(ra) # 430 <printint>
 592:	8bca                	mv	s7,s2
      state = 0;
 594:	4981                	li	s3,0
 596:	b751                	j	51a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 598:	008b8913          	addi	s2,s7,8
 59c:	4681                	li	a3,0
 59e:	4641                	li	a2,16
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e8a080e7          	jalr	-374(ra) # 430 <printint>
 5ae:	8bca                	mv	s7,s2
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b7a5                	j	51a <vprintf+0x42>
 5b4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5b6:	008b8793          	addi	a5,s7,8
 5ba:	8c3e                	mv	s8,a5
 5bc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5c0:	03000593          	li	a1,48
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e48080e7          	jalr	-440(ra) # 40e <putc>
  putc(fd, 'x');
 5ce:	07800593          	li	a1,120
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e3a080e7          	jalr	-454(ra) # 40e <putc>
 5dc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5de:	00000b97          	auipc	s7,0x0
 5e2:	37ab8b93          	addi	s7,s7,890 # 958 <digits>
 5e6:	03c9d793          	srli	a5,s3,0x3c
 5ea:	97de                	add	a5,a5,s7
 5ec:	0007c583          	lbu	a1,0(a5)
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e1c080e7          	jalr	-484(ra) # 40e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5fa:	0992                	slli	s3,s3,0x4
 5fc:	397d                	addiw	s2,s2,-1
 5fe:	fe0914e3          	bnez	s2,5e6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 602:	8be2                	mv	s7,s8
      state = 0;
 604:	4981                	li	s3,0
 606:	6c02                	ld	s8,0(sp)
 608:	bf09                	j	51a <vprintf+0x42>
        s = va_arg(ap, char*);
 60a:	008b8993          	addi	s3,s7,8
 60e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 612:	02090163          	beqz	s2,634 <vprintf+0x15c>
        while(*s != 0){
 616:	00094583          	lbu	a1,0(s2)
 61a:	c9a5                	beqz	a1,68a <vprintf+0x1b2>
          putc(fd, *s);
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	df0080e7          	jalr	-528(ra) # 40e <putc>
          s++;
 626:	0905                	addi	s2,s2,1
        while(*s != 0){
 628:	00094583          	lbu	a1,0(s2)
 62c:	f9e5                	bnez	a1,61c <vprintf+0x144>
        s = va_arg(ap, char*);
 62e:	8bce                	mv	s7,s3
      state = 0;
 630:	4981                	li	s3,0
 632:	b5e5                	j	51a <vprintf+0x42>
          s = "(null)";
 634:	00000917          	auipc	s2,0x0
 638:	2c490913          	addi	s2,s2,708 # 8f8 <malloc+0x168>
        while(*s != 0){
 63c:	02800593          	li	a1,40
 640:	bff1                	j	61c <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 642:	008b8913          	addi	s2,s7,8
 646:	000bc583          	lbu	a1,0(s7)
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	dc2080e7          	jalr	-574(ra) # 40e <putc>
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
 658:	b5c9                	j	51a <vprintf+0x42>
        putc(fd, c);
 65a:	02500593          	li	a1,37
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	dae080e7          	jalr	-594(ra) # 40e <putc>
      state = 0;
 668:	4981                	li	s3,0
 66a:	bd45                	j	51a <vprintf+0x42>
        putc(fd, '%');
 66c:	02500593          	li	a1,37
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	d9c080e7          	jalr	-612(ra) # 40e <putc>
        putc(fd, c);
 67a:	85ca                	mv	a1,s2
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	d90080e7          	jalr	-624(ra) # 40e <putc>
      state = 0;
 686:	4981                	li	s3,0
 688:	bd49                	j	51a <vprintf+0x42>
        s = va_arg(ap, char*);
 68a:	8bce                	mv	s7,s3
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b571                	j	51a <vprintf+0x42>
 690:	74e2                	ld	s1,56(sp)
 692:	79a2                	ld	s3,40(sp)
 694:	7a02                	ld	s4,32(sp)
 696:	6ae2                	ld	s5,24(sp)
 698:	6b42                	ld	s6,16(sp)
 69a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 69c:	60a6                	ld	ra,72(sp)
 69e:	6406                	ld	s0,64(sp)
 6a0:	7942                	ld	s2,48(sp)
 6a2:	6161                	addi	sp,sp,80
 6a4:	8082                	ret

00000000000006a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6a6:	715d                	addi	sp,sp,-80
 6a8:	ec06                	sd	ra,24(sp)
 6aa:	e822                	sd	s0,16(sp)
 6ac:	1000                	addi	s0,sp,32
 6ae:	e010                	sd	a2,0(s0)
 6b0:	e414                	sd	a3,8(s0)
 6b2:	e818                	sd	a4,16(s0)
 6b4:	ec1c                	sd	a5,24(s0)
 6b6:	03043023          	sd	a6,32(s0)
 6ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6be:	8622                	mv	a2,s0
 6c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6c4:	00000097          	auipc	ra,0x0
 6c8:	e14080e7          	jalr	-492(ra) # 4d8 <vprintf>
}
 6cc:	60e2                	ld	ra,24(sp)
 6ce:	6442                	ld	s0,16(sp)
 6d0:	6161                	addi	sp,sp,80
 6d2:	8082                	ret

00000000000006d4 <printf>:

void
printf(const char *fmt, ...)
{
 6d4:	711d                	addi	sp,sp,-96
 6d6:	ec06                	sd	ra,24(sp)
 6d8:	e822                	sd	s0,16(sp)
 6da:	1000                	addi	s0,sp,32
 6dc:	e40c                	sd	a1,8(s0)
 6de:	e810                	sd	a2,16(s0)
 6e0:	ec14                	sd	a3,24(s0)
 6e2:	f018                	sd	a4,32(s0)
 6e4:	f41c                	sd	a5,40(s0)
 6e6:	03043823          	sd	a6,48(s0)
 6ea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ee:	00840613          	addi	a2,s0,8
 6f2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6f6:	85aa                	mv	a1,a0
 6f8:	4505                	li	a0,1
 6fa:	00000097          	auipc	ra,0x0
 6fe:	dde080e7          	jalr	-546(ra) # 4d8 <vprintf>
}
 702:	60e2                	ld	ra,24(sp)
 704:	6442                	ld	s0,16(sp)
 706:	6125                	addi	sp,sp,96
 708:	8082                	ret

000000000000070a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70a:	1141                	addi	sp,sp,-16
 70c:	e406                	sd	ra,8(sp)
 70e:	e022                	sd	s0,0(sp)
 710:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 712:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	00001797          	auipc	a5,0x1
 71a:	8ea7b783          	ld	a5,-1814(a5) # 1000 <freep>
 71e:	a039                	j	72c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	6398                	ld	a4,0(a5)
 722:	00e7e463          	bltu	a5,a4,72a <free+0x20>
 726:	00e6ea63          	bltu	a3,a4,73a <free+0x30>
{
 72a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	fed7fae3          	bgeu	a5,a3,720 <free+0x16>
 730:	6398                	ld	a4,0(a5)
 732:	00e6e463          	bltu	a3,a4,73a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 736:	fee7eae3          	bltu	a5,a4,72a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 73a:	ff852583          	lw	a1,-8(a0)
 73e:	6390                	ld	a2,0(a5)
 740:	02059813          	slli	a6,a1,0x20
 744:	01c85713          	srli	a4,a6,0x1c
 748:	9736                	add	a4,a4,a3
 74a:	02e60563          	beq	a2,a4,774 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 74e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 752:	4790                	lw	a2,8(a5)
 754:	02061593          	slli	a1,a2,0x20
 758:	01c5d713          	srli	a4,a1,0x1c
 75c:	973e                	add	a4,a4,a5
 75e:	02e68263          	beq	a3,a4,782 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 762:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 764:	00001717          	auipc	a4,0x1
 768:	88f73e23          	sd	a5,-1892(a4) # 1000 <freep>
}
 76c:	60a2                	ld	ra,8(sp)
 76e:	6402                	ld	s0,0(sp)
 770:	0141                	addi	sp,sp,16
 772:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 774:	4618                	lw	a4,8(a2)
 776:	9f2d                	addw	a4,a4,a1
 778:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77c:	6398                	ld	a4,0(a5)
 77e:	6310                	ld	a2,0(a4)
 780:	b7f9                	j	74e <free+0x44>
    p->s.size += bp->s.size;
 782:	ff852703          	lw	a4,-8(a0)
 786:	9f31                	addw	a4,a4,a2
 788:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 78a:	ff053683          	ld	a3,-16(a0)
 78e:	bfd1                	j	762 <free+0x58>

0000000000000790 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 790:	7139                	addi	sp,sp,-64
 792:	fc06                	sd	ra,56(sp)
 794:	f822                	sd	s0,48(sp)
 796:	f04a                	sd	s2,32(sp)
 798:	ec4e                	sd	s3,24(sp)
 79a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79c:	02051993          	slli	s3,a0,0x20
 7a0:	0209d993          	srli	s3,s3,0x20
 7a4:	09bd                	addi	s3,s3,15
 7a6:	0049d993          	srli	s3,s3,0x4
 7aa:	2985                	addiw	s3,s3,1
 7ac:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7ae:	00001517          	auipc	a0,0x1
 7b2:	85253503          	ld	a0,-1966(a0) # 1000 <freep>
 7b6:	c905                	beqz	a0,7e6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ba:	4798                	lw	a4,8(a5)
 7bc:	09377a63          	bgeu	a4,s3,850 <malloc+0xc0>
 7c0:	f426                	sd	s1,40(sp)
 7c2:	e852                	sd	s4,16(sp)
 7c4:	e456                	sd	s5,8(sp)
 7c6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7c8:	8a4e                	mv	s4,s3
 7ca:	6705                	lui	a4,0x1
 7cc:	00e9f363          	bgeu	s3,a4,7d2 <malloc+0x42>
 7d0:	6a05                	lui	s4,0x1
 7d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7da:	00001497          	auipc	s1,0x1
 7de:	82648493          	addi	s1,s1,-2010 # 1000 <freep>
  if(p == (char*)-1)
 7e2:	5afd                	li	s5,-1
 7e4:	a089                	j	826 <malloc+0x96>
 7e6:	f426                	sd	s1,40(sp)
 7e8:	e852                	sd	s4,16(sp)
 7ea:	e456                	sd	s5,8(sp)
 7ec:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7ee:	00001797          	auipc	a5,0x1
 7f2:	82278793          	addi	a5,a5,-2014 # 1010 <base>
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80f73523          	sd	a5,-2038(a4) # 1000 <freep>
 7fe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 800:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 804:	b7d1                	j	7c8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 806:	6398                	ld	a4,0(a5)
 808:	e118                	sd	a4,0(a0)
 80a:	a8b9                	j	868 <malloc+0xd8>
  hp->s.size = nu;
 80c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 810:	0541                	addi	a0,a0,16
 812:	00000097          	auipc	ra,0x0
 816:	ef8080e7          	jalr	-264(ra) # 70a <free>
  return freep;
 81a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 81c:	c135                	beqz	a0,880 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 820:	4798                	lw	a4,8(a5)
 822:	03277363          	bgeu	a4,s2,848 <malloc+0xb8>
    if(p == freep)
 826:	6098                	ld	a4,0(s1)
 828:	853e                	mv	a0,a5
 82a:	fef71ae3          	bne	a4,a5,81e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 82e:	8552                	mv	a0,s4
 830:	00000097          	auipc	ra,0x0
 834:	b9e080e7          	jalr	-1122(ra) # 3ce <sbrk>
  if(p == (char*)-1)
 838:	fd551ae3          	bne	a0,s5,80c <malloc+0x7c>
        return 0;
 83c:	4501                	li	a0,0
 83e:	74a2                	ld	s1,40(sp)
 840:	6a42                	ld	s4,16(sp)
 842:	6aa2                	ld	s5,8(sp)
 844:	6b02                	ld	s6,0(sp)
 846:	a03d                	j	874 <malloc+0xe4>
 848:	74a2                	ld	s1,40(sp)
 84a:	6a42                	ld	s4,16(sp)
 84c:	6aa2                	ld	s5,8(sp)
 84e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 850:	fae90be3          	beq	s2,a4,806 <malloc+0x76>
        p->s.size -= nunits;
 854:	4137073b          	subw	a4,a4,s3
 858:	c798                	sw	a4,8(a5)
        p += p->s.size;
 85a:	02071693          	slli	a3,a4,0x20
 85e:	01c6d713          	srli	a4,a3,0x1c
 862:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 864:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 868:	00000717          	auipc	a4,0x0
 86c:	78a73c23          	sd	a0,1944(a4) # 1000 <freep>
      return (void*)(p + 1);
 870:	01078513          	addi	a0,a5,16
  }
}
 874:	70e2                	ld	ra,56(sp)
 876:	7442                	ld	s0,48(sp)
 878:	7902                	ld	s2,32(sp)
 87a:	69e2                	ld	s3,24(sp)
 87c:	6121                	addi	sp,sp,64
 87e:	8082                	ret
 880:	74a2                	ld	s1,40(sp)
 882:	6a42                	ld	s4,16(sp)
 884:	6aa2                	ld	s5,8(sp)
 886:	6b02                	ld	s6,0(sp)
 888:	b7f5                	j	874 <malloc+0xe4>
