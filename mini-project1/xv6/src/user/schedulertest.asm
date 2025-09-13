
user/_schedulertest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"

#define NFORK 10
#define IO 5

int main(void) {
   0:	711d                	addi	sp,sp,-96
   2:	ec86                	sd	ra,88(sp)
   4:	e8a2                	sd	s0,80(sp)
   6:	e4a6                	sd	s1,72(sp)
   8:	e0ca                	sd	s2,64(sp)
   a:	fc4e                	sd	s3,56(sp)
   c:	f852                	sd	s4,48(sp)
   e:	f456                	sd	s5,40(sp)
  10:	f05a                	sd	s6,32(sp)
  12:	ec5e                	sd	s7,24(sp)
  14:	1080                	addi	s0,sp,96
  int n, pid;
  int started = 0;

  printf("schedulertest: starting %d children (IO=%d)\n", NFORK, IO);
  16:	4615                	li	a2,5
  18:	45a9                	li	a1,10
  1a:	00001517          	auipc	a0,0x1
  1e:	91650513          	addi	a0,a0,-1770 # 930 <malloc+0xfc>
  22:	00000097          	auipc	ra,0x0
  26:	756080e7          	jalr	1878(ra) # 778 <printf>
  setcfslog(1);
  2a:	4505                	li	a0,1
  2c:	00000097          	auipc	ra,0x0
  30:	47e080e7          	jalr	1150(ra) # 4aa <setcfslog>
  int started = 0;
  34:	4481                	li	s1,0

  for (n = 0; n < NFORK; n++) {
  36:	4929                	li	s2,10
    pid = fork();
  38:	00000097          	auipc	ra,0x0
  3c:	3aa080e7          	jalr	938(ra) # 3e2 <fork>
    if (pid < 0)
  40:	0c054f63          	bltz	a0,11e <main+0x11e>
      break;
    if (pid == 0) {
  44:	c941                	beqz	a0,d4 <main+0xd4>
      } else {
        for (volatile int i = 0; i < 1000000000; i++) { } // CPU-bound
      }
      exit(0);
    } else {
      started++;
  46:	2485                	addiw	s1,s1,1
  for (n = 0; n < NFORK; n++) {
  48:	ff2498e3          	bne	s1,s2,38 <main+0x38>
    }
  }

  // Parent waits and prints per-child stats (requires waitx)
  int exited = 0;
  int w = 0, r = 0;
  4c:	fa042623          	sw	zero,-84(s0)
  50:	fa042423          	sw	zero,-88(s0)
  int started = 0;
  54:	4981                	li	s3,0
  56:	4a01                	li	s4,0
  58:	4901                	li	s2,0
  long long sumw = 0, sumr = 0;
  int cpid;

  while (exited < started && (cpid = waitx(0, &w, &r)) > 0) {
  5a:	fa840b13          	addi	s6,s0,-88
  5e:	fac40a93          	addi	s5,s0,-84
    printf("child %d: runtime=%d wait=%d\n", cpid, r, w);
  62:	00001b97          	auipc	s7,0x1
  66:	8feb8b93          	addi	s7,s7,-1794 # 960 <malloc+0x12c>
  while (exited < started && (cpid = waitx(0, &w, &r)) > 0) {
  6a:	865a                	mv	a2,s6
  6c:	85d6                	mv	a1,s5
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	41a080e7          	jalr	1050(ra) # 48a <waitx>
  78:	85aa                	mv	a1,a0
  7a:	0aa05963          	blez	a0,12c <main+0x12c>
    printf("child %d: runtime=%d wait=%d\n", cpid, r, w);
  7e:	fac42683          	lw	a3,-84(s0)
  82:	fa842603          	lw	a2,-88(s0)
  86:	855e                	mv	a0,s7
  88:	00000097          	auipc	ra,0x0
  8c:	6f0080e7          	jalr	1776(ra) # 778 <printf>
    sumw += w;
  90:	fac42783          	lw	a5,-84(s0)
  94:	9a3e                	add	s4,s4,a5
    sumr += r;
  96:	fa842783          	lw	a5,-88(s0)
  9a:	99be                	add	s3,s3,a5
    exited++;
  9c:	2905                	addiw	s2,s2,1
  while (exited < started && (cpid = waitx(0, &w, &r)) > 0) {
  9e:	fc9916e3          	bne	s2,s1,6a <main+0x6a>
  }

  if (exited > 0) {
    printf("schedulertest: done. pid=%d avg_runtime=%d avg_wait=%d\n",
           exited, (int)(sumr / exited), (int)(sumw / exited));
  a2:	032a46b3          	div	a3,s4,s2
  a6:	0329c633          	div	a2,s3,s2
    printf("schedulertest: done. pid=%d avg_runtime=%d avg_wait=%d\n",
  aa:	2681                	sext.w	a3,a3
  ac:	2601                	sext.w	a2,a2
  ae:	85ca                	mv	a1,s2
  b0:	00001517          	auipc	a0,0x1
  b4:	8d050513          	addi	a0,a0,-1840 # 980 <malloc+0x14c>
  b8:	00000097          	auipc	ra,0x0
  bc:	6c0080e7          	jalr	1728(ra) # 778 <printf>
  } else {
    printf("schedulertest: no children waited\n");
  }

  
  setcfslog(0);
  c0:	4501                	li	a0,0
  c2:	00000097          	auipc	ra,0x0
  c6:	3e8080e7          	jalr	1000(ra) # 4aa <setcfslog>

  exit(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	31e080e7          	jalr	798(ra) # 3ea <exit>
      if (n < IO) {
  d4:	4791                	li	a5,4
  d6:	0297dd63          	bge	a5,s1,110 <main+0x110>
        for (volatile int i = 0; i < 1000000000; i++) { } // CPU-bound
  da:	fa042223          	sw	zero,-92(s0)
  de:	fa442703          	lw	a4,-92(s0)
  e2:	2701                	sext.w	a4,a4
  e4:	3b9ad7b7          	lui	a5,0x3b9ad
  e8:	9ff78793          	addi	a5,a5,-1537 # 3b9ac9ff <base+0x3b9ab9ef>
  ec:	00e7cd63          	blt	a5,a4,106 <main+0x106>
  f0:	873e                	mv	a4,a5
  f2:	fa442783          	lw	a5,-92(s0)
  f6:	2785                	addiw	a5,a5,1
  f8:	faf42223          	sw	a5,-92(s0)
  fc:	fa442783          	lw	a5,-92(s0)
 100:	2781                	sext.w	a5,a5
 102:	fef758e3          	bge	a4,a5,f2 <main+0xf2>
      exit(0);
 106:	4501                	li	a0,0
 108:	00000097          	auipc	ra,0x0
 10c:	2e2080e7          	jalr	738(ra) # 3ea <exit>
        sleep(200);               // IO-bound-ish
 110:	0c800513          	li	a0,200
 114:	00000097          	auipc	ra,0x0
 118:	366080e7          	jalr	870(ra) # 47a <sleep>
 11c:	b7ed                	j	106 <main+0x106>
  int w = 0, r = 0;
 11e:	fa042623          	sw	zero,-84(s0)
 122:	fa042423          	sw	zero,-88(s0)
  while (exited < started && (cpid = waitx(0, &w, &r)) > 0) {
 126:	f29047e3          	bgtz	s1,54 <main+0x54>
 12a:	a019                	j	130 <main+0x130>
  if (exited > 0) {
 12c:	f7204be3          	bgtz	s2,a2 <main+0xa2>
    printf("schedulertest: no children waited\n");
 130:	00001517          	auipc	a0,0x1
 134:	88850513          	addi	a0,a0,-1912 # 9b8 <malloc+0x184>
 138:	00000097          	auipc	ra,0x0
 13c:	640080e7          	jalr	1600(ra) # 778 <printf>
 140:	b741                	j	c0 <main+0xc0>

0000000000000142 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 142:	1141                	addi	sp,sp,-16
 144:	e406                	sd	ra,8(sp)
 146:	e022                	sd	s0,0(sp)
 148:	0800                	addi	s0,sp,16
  extern int main();
  main();
 14a:	00000097          	auipc	ra,0x0
 14e:	eb6080e7          	jalr	-330(ra) # 0 <main>
  exit(0);
 152:	4501                	li	a0,0
 154:	00000097          	auipc	ra,0x0
 158:	296080e7          	jalr	662(ra) # 3ea <exit>

000000000000015c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 164:	87aa                	mv	a5,a0
 166:	0585                	addi	a1,a1,1
 168:	0785                	addi	a5,a5,1
 16a:	fff5c703          	lbu	a4,-1(a1)
 16e:	fee78fa3          	sb	a4,-1(a5)
 172:	fb75                	bnez	a4,166 <strcpy+0xa>
    ;
  return os;
}
 174:	60a2                	ld	ra,8(sp)
 176:	6402                	ld	s0,0(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e406                	sd	ra,8(sp)
 180:	e022                	sd	s0,0(sp)
 182:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 184:	00054783          	lbu	a5,0(a0)
 188:	cb91                	beqz	a5,19c <strcmp+0x20>
 18a:	0005c703          	lbu	a4,0(a1)
 18e:	00f71763          	bne	a4,a5,19c <strcmp+0x20>
    p++, q++;
 192:	0505                	addi	a0,a0,1
 194:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 196:	00054783          	lbu	a5,0(a0)
 19a:	fbe5                	bnez	a5,18a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 19c:	0005c503          	lbu	a0,0(a1)
}
 1a0:	40a7853b          	subw	a0,a5,a0
 1a4:	60a2                	ld	ra,8(sp)
 1a6:	6402                	ld	s0,0(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret

00000000000001ac <strlen>:

uint
strlen(const char *s)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	cf91                	beqz	a5,1d4 <strlen+0x28>
 1ba:	00150793          	addi	a5,a0,1
 1be:	86be                	mv	a3,a5
 1c0:	0785                	addi	a5,a5,1
 1c2:	fff7c703          	lbu	a4,-1(a5)
 1c6:	ff65                	bnez	a4,1be <strlen+0x12>
 1c8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1cc:	60a2                	ld	ra,8(sp)
 1ce:	6402                	ld	s0,0(sp)
 1d0:	0141                	addi	sp,sp,16
 1d2:	8082                	ret
  for(n = 0; s[n]; n++)
 1d4:	4501                	li	a0,0
 1d6:	bfdd                	j	1cc <strlen+0x20>

00000000000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e406                	sd	ra,8(sp)
 1dc:	e022                	sd	s0,0(sp)
 1de:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e0:	ca19                	beqz	a2,1f6 <memset+0x1e>
 1e2:	87aa                	mv	a5,a0
 1e4:	1602                	slli	a2,a2,0x20
 1e6:	9201                	srli	a2,a2,0x20
 1e8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ec:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f0:	0785                	addi	a5,a5,1
 1f2:	fee79de3          	bne	a5,a4,1ec <memset+0x14>
  }
  return dst;
}
 1f6:	60a2                	ld	ra,8(sp)
 1f8:	6402                	ld	s0,0(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret

00000000000001fe <strchr>:

char*
strchr(const char *s, char c)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e406                	sd	ra,8(sp)
 202:	e022                	sd	s0,0(sp)
 204:	0800                	addi	s0,sp,16
  for(; *s; s++)
 206:	00054783          	lbu	a5,0(a0)
 20a:	cf81                	beqz	a5,222 <strchr+0x24>
    if(*s == c)
 20c:	00f58763          	beq	a1,a5,21a <strchr+0x1c>
  for(; *s; s++)
 210:	0505                	addi	a0,a0,1
 212:	00054783          	lbu	a5,0(a0)
 216:	fbfd                	bnez	a5,20c <strchr+0xe>
      return (char*)s;
  return 0;
 218:	4501                	li	a0,0
}
 21a:	60a2                	ld	ra,8(sp)
 21c:	6402                	ld	s0,0(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  return 0;
 222:	4501                	li	a0,0
 224:	bfdd                	j	21a <strchr+0x1c>

0000000000000226 <gets>:

char*
gets(char *buf, int max)
{
 226:	711d                	addi	sp,sp,-96
 228:	ec86                	sd	ra,88(sp)
 22a:	e8a2                	sd	s0,80(sp)
 22c:	e4a6                	sd	s1,72(sp)
 22e:	e0ca                	sd	s2,64(sp)
 230:	fc4e                	sd	s3,56(sp)
 232:	f852                	sd	s4,48(sp)
 234:	f456                	sd	s5,40(sp)
 236:	f05a                	sd	s6,32(sp)
 238:	ec5e                	sd	s7,24(sp)
 23a:	e862                	sd	s8,16(sp)
 23c:	1080                	addi	s0,sp,96
 23e:	8baa                	mv	s7,a0
 240:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 242:	892a                	mv	s2,a0
 244:	4481                	li	s1,0
    cc = read(0, &c, 1);
 246:	faf40b13          	addi	s6,s0,-81
 24a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 24c:	8c26                	mv	s8,s1
 24e:	0014899b          	addiw	s3,s1,1
 252:	84ce                	mv	s1,s3
 254:	0349d663          	bge	s3,s4,280 <gets+0x5a>
    cc = read(0, &c, 1);
 258:	8656                	mv	a2,s5
 25a:	85da                	mv	a1,s6
 25c:	4501                	li	a0,0
 25e:	00000097          	auipc	ra,0x0
 262:	1a4080e7          	jalr	420(ra) # 402 <read>
    if(cc < 1)
 266:	00a05d63          	blez	a0,280 <gets+0x5a>
      break;
    buf[i++] = c;
 26a:	faf44783          	lbu	a5,-81(s0)
 26e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 272:	0905                	addi	s2,s2,1
 274:	ff678713          	addi	a4,a5,-10
 278:	c319                	beqz	a4,27e <gets+0x58>
 27a:	17cd                	addi	a5,a5,-13
 27c:	fbe1                	bnez	a5,24c <gets+0x26>
    buf[i++] = c;
 27e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 280:	9c5e                	add	s8,s8,s7
 282:	000c0023          	sb	zero,0(s8)
  return buf;
}
 286:	855e                	mv	a0,s7
 288:	60e6                	ld	ra,88(sp)
 28a:	6446                	ld	s0,80(sp)
 28c:	64a6                	ld	s1,72(sp)
 28e:	6906                	ld	s2,64(sp)
 290:	79e2                	ld	s3,56(sp)
 292:	7a42                	ld	s4,48(sp)
 294:	7aa2                	ld	s5,40(sp)
 296:	7b02                	ld	s6,32(sp)
 298:	6be2                	ld	s7,24(sp)
 29a:	6c42                	ld	s8,16(sp)
 29c:	6125                	addi	sp,sp,96
 29e:	8082                	ret

00000000000002a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2a0:	1101                	addi	sp,sp,-32
 2a2:	ec06                	sd	ra,24(sp)
 2a4:	e822                	sd	s0,16(sp)
 2a6:	e04a                	sd	s2,0(sp)
 2a8:	1000                	addi	s0,sp,32
 2aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ac:	4581                	li	a1,0
 2ae:	00000097          	auipc	ra,0x0
 2b2:	17c080e7          	jalr	380(ra) # 42a <open>
  if(fd < 0)
 2b6:	02054663          	bltz	a0,2e2 <stat+0x42>
 2ba:	e426                	sd	s1,8(sp)
 2bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2be:	85ca                	mv	a1,s2
 2c0:	00000097          	auipc	ra,0x0
 2c4:	182080e7          	jalr	386(ra) # 442 <fstat>
 2c8:	892a                	mv	s2,a0
  close(fd);
 2ca:	8526                	mv	a0,s1
 2cc:	00000097          	auipc	ra,0x0
 2d0:	146080e7          	jalr	326(ra) # 412 <close>
  return r;
 2d4:	64a2                	ld	s1,8(sp)
}
 2d6:	854a                	mv	a0,s2
 2d8:	60e2                	ld	ra,24(sp)
 2da:	6442                	ld	s0,16(sp)
 2dc:	6902                	ld	s2,0(sp)
 2de:	6105                	addi	sp,sp,32
 2e0:	8082                	ret
    return -1;
 2e2:	57fd                	li	a5,-1
 2e4:	893e                	mv	s2,a5
 2e6:	bfc5                	j	2d6 <stat+0x36>

00000000000002e8 <atoi>:

int
atoi(const char *s)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f0:	00054683          	lbu	a3,0(a0)
 2f4:	fd06879b          	addiw	a5,a3,-48
 2f8:	0ff7f793          	zext.b	a5,a5
 2fc:	4625                	li	a2,9
 2fe:	02f66963          	bltu	a2,a5,330 <atoi+0x48>
 302:	872a                	mv	a4,a0
  n = 0;
 304:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 306:	0705                	addi	a4,a4,1
 308:	0025179b          	slliw	a5,a0,0x2
 30c:	9fa9                	addw	a5,a5,a0
 30e:	0017979b          	slliw	a5,a5,0x1
 312:	9fb5                	addw	a5,a5,a3
 314:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 318:	00074683          	lbu	a3,0(a4)
 31c:	fd06879b          	addiw	a5,a3,-48
 320:	0ff7f793          	zext.b	a5,a5
 324:	fef671e3          	bgeu	a2,a5,306 <atoi+0x1e>
  return n;
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  n = 0;
 330:	4501                	li	a0,0
 332:	bfdd                	j	328 <atoi+0x40>

0000000000000334 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e406                	sd	ra,8(sp)
 338:	e022                	sd	s0,0(sp)
 33a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 33c:	02b57563          	bgeu	a0,a1,366 <memmove+0x32>
    while(n-- > 0)
 340:	00c05f63          	blez	a2,35e <memmove+0x2a>
 344:	1602                	slli	a2,a2,0x20
 346:	9201                	srli	a2,a2,0x20
 348:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 34c:	872a                	mv	a4,a0
      *dst++ = *src++;
 34e:	0585                	addi	a1,a1,1
 350:	0705                	addi	a4,a4,1
 352:	fff5c683          	lbu	a3,-1(a1)
 356:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 35a:	fee79ae3          	bne	a5,a4,34e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
    while(n-- > 0)
 366:	fec05ce3          	blez	a2,35e <memmove+0x2a>
    dst += n;
 36a:	00c50733          	add	a4,a0,a2
    src += n;
 36e:	95b2                	add	a1,a1,a2
 370:	fff6079b          	addiw	a5,a2,-1
 374:	1782                	slli	a5,a5,0x20
 376:	9381                	srli	a5,a5,0x20
 378:	fff7c793          	not	a5,a5
 37c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 37e:	15fd                	addi	a1,a1,-1
 380:	177d                	addi	a4,a4,-1
 382:	0005c683          	lbu	a3,0(a1)
 386:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 38a:	fef71ae3          	bne	a4,a5,37e <memmove+0x4a>
 38e:	bfc1                	j	35e <memmove+0x2a>

0000000000000390 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 390:	1141                	addi	sp,sp,-16
 392:	e406                	sd	ra,8(sp)
 394:	e022                	sd	s0,0(sp)
 396:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 398:	c61d                	beqz	a2,3c6 <memcmp+0x36>
 39a:	1602                	slli	a2,a2,0x20
 39c:	9201                	srli	a2,a2,0x20
 39e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3a2:	00054783          	lbu	a5,0(a0)
 3a6:	0005c703          	lbu	a4,0(a1)
 3aa:	00e79863          	bne	a5,a4,3ba <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 3ae:	0505                	addi	a0,a0,1
    p2++;
 3b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b2:	fed518e3          	bne	a0,a3,3a2 <memcmp+0x12>
  }
  return 0;
 3b6:	4501                	li	a0,0
 3b8:	a019                	j	3be <memcmp+0x2e>
      return *p1 - *p2;
 3ba:	40e7853b          	subw	a0,a5,a4
}
 3be:	60a2                	ld	ra,8(sp)
 3c0:	6402                	ld	s0,0(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
  return 0;
 3c6:	4501                	li	a0,0
 3c8:	bfdd                	j	3be <memcmp+0x2e>

00000000000003ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e406                	sd	ra,8(sp)
 3ce:	e022                	sd	s0,0(sp)
 3d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d2:	00000097          	auipc	ra,0x0
 3d6:	f62080e7          	jalr	-158(ra) # 334 <memmove>
}
 3da:	60a2                	ld	ra,8(sp)
 3dc:	6402                	ld	s0,0(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e2:	4885                	li	a7,1
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ea:	4889                	li	a7,2
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f2:	488d                	li	a7,3
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3fa:	4891                	li	a7,4
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <read>:
.global read
read:
 li a7, SYS_read
 402:	4895                	li	a7,5
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <write>:
.global write
write:
 li a7, SYS_write
 40a:	48c1                	li	a7,16
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <close>:
.global close
close:
 li a7, SYS_close
 412:	48d5                	li	a7,21
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <kill>:
.global kill
kill:
 li a7, SYS_kill
 41a:	4899                	li	a7,6
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <exec>:
.global exec
exec:
 li a7, SYS_exec
 422:	489d                	li	a7,7
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <open>:
.global open
open:
 li a7, SYS_open
 42a:	48bd                	li	a7,15
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 432:	48c5                	li	a7,17
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43a:	48c9                	li	a7,18
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 442:	48a1                	li	a7,8
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <link>:
.global link
link:
 li a7, SYS_link
 44a:	48cd                	li	a7,19
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 452:	48d1                	li	a7,20
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 45a:	48a5                	li	a7,9
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <dup>:
.global dup
dup:
 li a7, SYS_dup
 462:	48a9                	li	a7,10
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 46a:	48ad                	li	a7,11
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 472:	48b1                	li	a7,12
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 47a:	48b5                	li	a7,13
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 482:	48b9                	li	a7,14
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 48a:	48d9                	li	a7,22
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 492:	48dd                	li	a7,23
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <printlog>:
.global printlog
printlog:
 li a7, SYS_printlog
 49a:	48e1                	li	a7,24
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 4a2:	48e5                	li	a7,25
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <setcfslog>:
.global setcfslog
setcfslog:
 li a7, SYS_setcfslog
 4aa:	48e9                	li	a7,26
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b2:	1101                	addi	sp,sp,-32
 4b4:	ec06                	sd	ra,24(sp)
 4b6:	e822                	sd	s0,16(sp)
 4b8:	1000                	addi	s0,sp,32
 4ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4be:	4605                	li	a2,1
 4c0:	fef40593          	addi	a1,s0,-17
 4c4:	00000097          	auipc	ra,0x0
 4c8:	f46080e7          	jalr	-186(ra) # 40a <write>
}
 4cc:	60e2                	ld	ra,24(sp)
 4ce:	6442                	ld	s0,16(sp)
 4d0:	6105                	addi	sp,sp,32
 4d2:	8082                	ret

00000000000004d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d4:	7139                	addi	sp,sp,-64
 4d6:	fc06                	sd	ra,56(sp)
 4d8:	f822                	sd	s0,48(sp)
 4da:	f04a                	sd	s2,32(sp)
 4dc:	ec4e                	sd	s3,24(sp)
 4de:	0080                	addi	s0,sp,64
 4e0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e2:	cad9                	beqz	a3,578 <printint+0xa4>
 4e4:	01f5d79b          	srliw	a5,a1,0x1f
 4e8:	cbc1                	beqz	a5,578 <printint+0xa4>
    neg = 1;
    x = -xx;
 4ea:	40b005bb          	negw	a1,a1
    neg = 1;
 4ee:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4f0:	fc040993          	addi	s3,s0,-64
  neg = 0;
 4f4:	86ce                	mv	a3,s3
  i = 0;
 4f6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f8:	00000817          	auipc	a6,0x0
 4fc:	54880813          	addi	a6,a6,1352 # a40 <digits>
 500:	88ba                	mv	a7,a4
 502:	0017051b          	addiw	a0,a4,1
 506:	872a                	mv	a4,a0
 508:	02c5f7bb          	remuw	a5,a1,a2
 50c:	1782                	slli	a5,a5,0x20
 50e:	9381                	srli	a5,a5,0x20
 510:	97c2                	add	a5,a5,a6
 512:	0007c783          	lbu	a5,0(a5)
 516:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 51a:	87ae                	mv	a5,a1
 51c:	02c5d5bb          	divuw	a1,a1,a2
 520:	0685                	addi	a3,a3,1
 522:	fcc7ffe3          	bgeu	a5,a2,500 <printint+0x2c>
  if(neg)
 526:	00030c63          	beqz	t1,53e <printint+0x6a>
    buf[i++] = '-';
 52a:	fd050793          	addi	a5,a0,-48
 52e:	00878533          	add	a0,a5,s0
 532:	02d00793          	li	a5,45
 536:	fef50823          	sb	a5,-16(a0)
 53a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 53e:	02e05763          	blez	a4,56c <printint+0x98>
 542:	f426                	sd	s1,40(sp)
 544:	377d                	addiw	a4,a4,-1
 546:	00e984b3          	add	s1,s3,a4
 54a:	19fd                	addi	s3,s3,-1
 54c:	99ba                	add	s3,s3,a4
 54e:	1702                	slli	a4,a4,0x20
 550:	9301                	srli	a4,a4,0x20
 552:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 556:	0004c583          	lbu	a1,0(s1)
 55a:	854a                	mv	a0,s2
 55c:	00000097          	auipc	ra,0x0
 560:	f56080e7          	jalr	-170(ra) # 4b2 <putc>
  while(--i >= 0)
 564:	14fd                	addi	s1,s1,-1
 566:	ff3498e3          	bne	s1,s3,556 <printint+0x82>
 56a:	74a2                	ld	s1,40(sp)
}
 56c:	70e2                	ld	ra,56(sp)
 56e:	7442                	ld	s0,48(sp)
 570:	7902                	ld	s2,32(sp)
 572:	69e2                	ld	s3,24(sp)
 574:	6121                	addi	sp,sp,64
 576:	8082                	ret
  neg = 0;
 578:	4301                	li	t1,0
 57a:	bf9d                	j	4f0 <printint+0x1c>

000000000000057c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57c:	715d                	addi	sp,sp,-80
 57e:	e486                	sd	ra,72(sp)
 580:	e0a2                	sd	s0,64(sp)
 582:	f84a                	sd	s2,48(sp)
 584:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 586:	0005c903          	lbu	s2,0(a1)
 58a:	1a090b63          	beqz	s2,740 <vprintf+0x1c4>
 58e:	fc26                	sd	s1,56(sp)
 590:	f44e                	sd	s3,40(sp)
 592:	f052                	sd	s4,32(sp)
 594:	ec56                	sd	s5,24(sp)
 596:	e85a                	sd	s6,16(sp)
 598:	e45e                	sd	s7,8(sp)
 59a:	8aaa                	mv	s5,a0
 59c:	8bb2                	mv	s7,a2
 59e:	00158493          	addi	s1,a1,1
  state = 0;
 5a2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5a4:	02500a13          	li	s4,37
 5a8:	4b55                	li	s6,21
 5aa:	a839                	j	5c8 <vprintf+0x4c>
        putc(fd, c);
 5ac:	85ca                	mv	a1,s2
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	f02080e7          	jalr	-254(ra) # 4b2 <putc>
 5b8:	a019                	j	5be <vprintf+0x42>
    } else if(state == '%'){
 5ba:	01498d63          	beq	s3,s4,5d4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5be:	0485                	addi	s1,s1,1
 5c0:	fff4c903          	lbu	s2,-1(s1)
 5c4:	16090863          	beqz	s2,734 <vprintf+0x1b8>
    if(state == 0){
 5c8:	fe0999e3          	bnez	s3,5ba <vprintf+0x3e>
      if(c == '%'){
 5cc:	ff4910e3          	bne	s2,s4,5ac <vprintf+0x30>
        state = '%';
 5d0:	89d2                	mv	s3,s4
 5d2:	b7f5                	j	5be <vprintf+0x42>
      if(c == 'd'){
 5d4:	13490563          	beq	s2,s4,6fe <vprintf+0x182>
 5d8:	f9d9079b          	addiw	a5,s2,-99
 5dc:	0ff7f793          	zext.b	a5,a5
 5e0:	12fb6863          	bltu	s6,a5,710 <vprintf+0x194>
 5e4:	f9d9079b          	addiw	a5,s2,-99
 5e8:	0ff7f713          	zext.b	a4,a5
 5ec:	12eb6263          	bltu	s6,a4,710 <vprintf+0x194>
 5f0:	00271793          	slli	a5,a4,0x2
 5f4:	00000717          	auipc	a4,0x0
 5f8:	3f470713          	addi	a4,a4,1012 # 9e8 <malloc+0x1b4>
 5fc:	97ba                	add	a5,a5,a4
 5fe:	439c                	lw	a5,0(a5)
 600:	97ba                	add	a5,a5,a4
 602:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 604:	008b8913          	addi	s2,s7,8
 608:	4685                	li	a3,1
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	ec2080e7          	jalr	-318(ra) # 4d4 <printint>
 61a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b745                	j	5be <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 620:	008b8913          	addi	s2,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	ea6080e7          	jalr	-346(ra) # 4d4 <printint>
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	b751                	j	5be <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4641                	li	a2,16
 644:	000ba583          	lw	a1,0(s7)
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	e8a080e7          	jalr	-374(ra) # 4d4 <printint>
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	b7a5                	j	5be <vprintf+0x42>
 658:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 65a:	008b8793          	addi	a5,s7,8
 65e:	8c3e                	mv	s8,a5
 660:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 664:	03000593          	li	a1,48
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e48080e7          	jalr	-440(ra) # 4b2 <putc>
  putc(fd, 'x');
 672:	07800593          	li	a1,120
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e3a080e7          	jalr	-454(ra) # 4b2 <putc>
 680:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 682:	00000b97          	auipc	s7,0x0
 686:	3beb8b93          	addi	s7,s7,958 # a40 <digits>
 68a:	03c9d793          	srli	a5,s3,0x3c
 68e:	97de                	add	a5,a5,s7
 690:	0007c583          	lbu	a1,0(a5)
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	e1c080e7          	jalr	-484(ra) # 4b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69e:	0992                	slli	s3,s3,0x4
 6a0:	397d                	addiw	s2,s2,-1
 6a2:	fe0914e3          	bnez	s2,68a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 6a6:	8be2                	mv	s7,s8
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	6c02                	ld	s8,0(sp)
 6ac:	bf09                	j	5be <vprintf+0x42>
        s = va_arg(ap, char*);
 6ae:	008b8993          	addi	s3,s7,8
 6b2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6b6:	02090163          	beqz	s2,6d8 <vprintf+0x15c>
        while(*s != 0){
 6ba:	00094583          	lbu	a1,0(s2)
 6be:	c9a5                	beqz	a1,72e <vprintf+0x1b2>
          putc(fd, *s);
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	df0080e7          	jalr	-528(ra) # 4b2 <putc>
          s++;
 6ca:	0905                	addi	s2,s2,1
        while(*s != 0){
 6cc:	00094583          	lbu	a1,0(s2)
 6d0:	f9e5                	bnez	a1,6c0 <vprintf+0x144>
        s = va_arg(ap, char*);
 6d2:	8bce                	mv	s7,s3
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b5e5                	j	5be <vprintf+0x42>
          s = "(null)";
 6d8:	00000917          	auipc	s2,0x0
 6dc:	30890913          	addi	s2,s2,776 # 9e0 <malloc+0x1ac>
        while(*s != 0){
 6e0:	02800593          	li	a1,40
 6e4:	bff1                	j	6c0 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 6e6:	008b8913          	addi	s2,s7,8
 6ea:	000bc583          	lbu	a1,0(s7)
 6ee:	8556                	mv	a0,s5
 6f0:	00000097          	auipc	ra,0x0
 6f4:	dc2080e7          	jalr	-574(ra) # 4b2 <putc>
 6f8:	8bca                	mv	s7,s2
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b5c9                	j	5be <vprintf+0x42>
        putc(fd, c);
 6fe:	02500593          	li	a1,37
 702:	8556                	mv	a0,s5
 704:	00000097          	auipc	ra,0x0
 708:	dae080e7          	jalr	-594(ra) # 4b2 <putc>
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bd45                	j	5be <vprintf+0x42>
        putc(fd, '%');
 710:	02500593          	li	a1,37
 714:	8556                	mv	a0,s5
 716:	00000097          	auipc	ra,0x0
 71a:	d9c080e7          	jalr	-612(ra) # 4b2 <putc>
        putc(fd, c);
 71e:	85ca                	mv	a1,s2
 720:	8556                	mv	a0,s5
 722:	00000097          	auipc	ra,0x0
 726:	d90080e7          	jalr	-624(ra) # 4b2 <putc>
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bd49                	j	5be <vprintf+0x42>
        s = va_arg(ap, char*);
 72e:	8bce                	mv	s7,s3
      state = 0;
 730:	4981                	li	s3,0
 732:	b571                	j	5be <vprintf+0x42>
 734:	74e2                	ld	s1,56(sp)
 736:	79a2                	ld	s3,40(sp)
 738:	7a02                	ld	s4,32(sp)
 73a:	6ae2                	ld	s5,24(sp)
 73c:	6b42                	ld	s6,16(sp)
 73e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 740:	60a6                	ld	ra,72(sp)
 742:	6406                	ld	s0,64(sp)
 744:	7942                	ld	s2,48(sp)
 746:	6161                	addi	sp,sp,80
 748:	8082                	ret

000000000000074a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 74a:	715d                	addi	sp,sp,-80
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	e010                	sd	a2,0(s0)
 754:	e414                	sd	a3,8(s0)
 756:	e818                	sd	a4,16(s0)
 758:	ec1c                	sd	a5,24(s0)
 75a:	03043023          	sd	a6,32(s0)
 75e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 762:	8622                	mv	a2,s0
 764:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 768:	00000097          	auipc	ra,0x0
 76c:	e14080e7          	jalr	-492(ra) # 57c <vprintf>
}
 770:	60e2                	ld	ra,24(sp)
 772:	6442                	ld	s0,16(sp)
 774:	6161                	addi	sp,sp,80
 776:	8082                	ret

0000000000000778 <printf>:

void
printf(const char *fmt, ...)
{
 778:	711d                	addi	sp,sp,-96
 77a:	ec06                	sd	ra,24(sp)
 77c:	e822                	sd	s0,16(sp)
 77e:	1000                	addi	s0,sp,32
 780:	e40c                	sd	a1,8(s0)
 782:	e810                	sd	a2,16(s0)
 784:	ec14                	sd	a3,24(s0)
 786:	f018                	sd	a4,32(s0)
 788:	f41c                	sd	a5,40(s0)
 78a:	03043823          	sd	a6,48(s0)
 78e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 792:	00840613          	addi	a2,s0,8
 796:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 79a:	85aa                	mv	a1,a0
 79c:	4505                	li	a0,1
 79e:	00000097          	auipc	ra,0x0
 7a2:	dde080e7          	jalr	-546(ra) # 57c <vprintf>
}
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6442                	ld	s0,16(sp)
 7aa:	6125                	addi	sp,sp,96
 7ac:	8082                	ret

00000000000007ae <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ae:	1141                	addi	sp,sp,-16
 7b0:	e406                	sd	ra,8(sp)
 7b2:	e022                	sd	s0,0(sp)
 7b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ba:	00001797          	auipc	a5,0x1
 7be:	8467b783          	ld	a5,-1978(a5) # 1000 <freep>
 7c2:	a039                	j	7d0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c4:	6398                	ld	a4,0(a5)
 7c6:	00e7e463          	bltu	a5,a4,7ce <free+0x20>
 7ca:	00e6ea63          	bltu	a3,a4,7de <free+0x30>
{
 7ce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d0:	fed7fae3          	bgeu	a5,a3,7c4 <free+0x16>
 7d4:	6398                	ld	a4,0(a5)
 7d6:	00e6e463          	bltu	a3,a4,7de <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7da:	fee7eae3          	bltu	a5,a4,7ce <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7de:	ff852583          	lw	a1,-8(a0)
 7e2:	6390                	ld	a2,0(a5)
 7e4:	02059813          	slli	a6,a1,0x20
 7e8:	01c85713          	srli	a4,a6,0x1c
 7ec:	9736                	add	a4,a4,a3
 7ee:	02e60563          	beq	a2,a4,818 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7f2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7f6:	4790                	lw	a2,8(a5)
 7f8:	02061593          	slli	a1,a2,0x20
 7fc:	01c5d713          	srli	a4,a1,0x1c
 800:	973e                	add	a4,a4,a5
 802:	02e68263          	beq	a3,a4,826 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 806:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 808:	00000717          	auipc	a4,0x0
 80c:	7ef73c23          	sd	a5,2040(a4) # 1000 <freep>
}
 810:	60a2                	ld	ra,8(sp)
 812:	6402                	ld	s0,0(sp)
 814:	0141                	addi	sp,sp,16
 816:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 818:	4618                	lw	a4,8(a2)
 81a:	9f2d                	addw	a4,a4,a1
 81c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 820:	6398                	ld	a4,0(a5)
 822:	6310                	ld	a2,0(a4)
 824:	b7f9                	j	7f2 <free+0x44>
    p->s.size += bp->s.size;
 826:	ff852703          	lw	a4,-8(a0)
 82a:	9f31                	addw	a4,a4,a2
 82c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 82e:	ff053683          	ld	a3,-16(a0)
 832:	bfd1                	j	806 <free+0x58>

0000000000000834 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 834:	7139                	addi	sp,sp,-64
 836:	fc06                	sd	ra,56(sp)
 838:	f822                	sd	s0,48(sp)
 83a:	f04a                	sd	s2,32(sp)
 83c:	ec4e                	sd	s3,24(sp)
 83e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 840:	02051993          	slli	s3,a0,0x20
 844:	0209d993          	srli	s3,s3,0x20
 848:	09bd                	addi	s3,s3,15
 84a:	0049d993          	srli	s3,s3,0x4
 84e:	2985                	addiw	s3,s3,1
 850:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 852:	00000517          	auipc	a0,0x0
 856:	7ae53503          	ld	a0,1966(a0) # 1000 <freep>
 85a:	c905                	beqz	a0,88a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85e:	4798                	lw	a4,8(a5)
 860:	09377a63          	bgeu	a4,s3,8f4 <malloc+0xc0>
 864:	f426                	sd	s1,40(sp)
 866:	e852                	sd	s4,16(sp)
 868:	e456                	sd	s5,8(sp)
 86a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 86c:	8a4e                	mv	s4,s3
 86e:	6705                	lui	a4,0x1
 870:	00e9f363          	bgeu	s3,a4,876 <malloc+0x42>
 874:	6a05                	lui	s4,0x1
 876:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87e:	00000497          	auipc	s1,0x0
 882:	78248493          	addi	s1,s1,1922 # 1000 <freep>
  if(p == (char*)-1)
 886:	5afd                	li	s5,-1
 888:	a089                	j	8ca <malloc+0x96>
 88a:	f426                	sd	s1,40(sp)
 88c:	e852                	sd	s4,16(sp)
 88e:	e456                	sd	s5,8(sp)
 890:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 892:	00000797          	auipc	a5,0x0
 896:	77e78793          	addi	a5,a5,1918 # 1010 <base>
 89a:	00000717          	auipc	a4,0x0
 89e:	76f73323          	sd	a5,1894(a4) # 1000 <freep>
 8a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a8:	b7d1                	j	86c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8aa:	6398                	ld	a4,0(a5)
 8ac:	e118                	sd	a4,0(a0)
 8ae:	a8b9                	j	90c <malloc+0xd8>
  hp->s.size = nu;
 8b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b4:	0541                	addi	a0,a0,16
 8b6:	00000097          	auipc	ra,0x0
 8ba:	ef8080e7          	jalr	-264(ra) # 7ae <free>
  return freep;
 8be:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8c0:	c135                	beqz	a0,924 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c4:	4798                	lw	a4,8(a5)
 8c6:	03277363          	bgeu	a4,s2,8ec <malloc+0xb8>
    if(p == freep)
 8ca:	6098                	ld	a4,0(s1)
 8cc:	853e                	mv	a0,a5
 8ce:	fef71ae3          	bne	a4,a5,8c2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8d2:	8552                	mv	a0,s4
 8d4:	00000097          	auipc	ra,0x0
 8d8:	b9e080e7          	jalr	-1122(ra) # 472 <sbrk>
  if(p == (char*)-1)
 8dc:	fd551ae3          	bne	a0,s5,8b0 <malloc+0x7c>
        return 0;
 8e0:	4501                	li	a0,0
 8e2:	74a2                	ld	s1,40(sp)
 8e4:	6a42                	ld	s4,16(sp)
 8e6:	6aa2                	ld	s5,8(sp)
 8e8:	6b02                	ld	s6,0(sp)
 8ea:	a03d                	j	918 <malloc+0xe4>
 8ec:	74a2                	ld	s1,40(sp)
 8ee:	6a42                	ld	s4,16(sp)
 8f0:	6aa2                	ld	s5,8(sp)
 8f2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f4:	fae90be3          	beq	s2,a4,8aa <malloc+0x76>
        p->s.size -= nunits;
 8f8:	4137073b          	subw	a4,a4,s3
 8fc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fe:	02071693          	slli	a3,a4,0x20
 902:	01c6d713          	srli	a4,a3,0x1c
 906:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 908:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 90c:	00000717          	auipc	a4,0x0
 910:	6ea73a23          	sd	a0,1780(a4) # 1000 <freep>
      return (void*)(p + 1);
 914:	01078513          	addi	a0,a5,16
  }
}
 918:	70e2                	ld	ra,56(sp)
 91a:	7442                	ld	s0,48(sp)
 91c:	7902                	ld	s2,32(sp)
 91e:	69e2                	ld	s3,24(sp)
 920:	6121                	addi	sp,sp,64
 922:	8082                	ret
 924:	74a2                	ld	s1,40(sp)
 926:	6a42                	ld	s4,16(sp)
 928:	6aa2                	ld	s5,8(sp)
 92a:	6b02                	ld	s6,0(sp)
 92c:	b7f5                	j	918 <malloc+0xe4>
