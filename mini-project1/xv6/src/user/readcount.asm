
user/_readcount:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	7135                	addi	sp,sp,-160
   2:	ed06                	sd	ra,152(sp)
   4:	e922                	sd	s0,144(sp)
   6:	e14a                	sd	s2,128(sp)
   8:	1100                	addi	s0,sp,160
  int before = getreadcount();
   a:	00000097          	auipc	ra,0x0
   e:	458080e7          	jalr	1112(ra) # 462 <getreadcount>
  12:	892a                	mv	s2,a0
  printf("getreadcount before = %d\n", before);
  14:	85aa                	mv	a1,a0
  16:	00001517          	auipc	a0,0x1
  1a:	8da50513          	addi	a0,a0,-1830 # 8f0 <malloc+0xfc>
  1e:	00000097          	auipc	ra,0x0
  22:	71a080e7          	jalr	1818(ra) # 738 <printf>

  int fd = open("README", O_RDONLY);
  26:	4581                	li	a1,0
  28:	00001517          	auipc	a0,0x1
  2c:	8e850513          	addi	a0,a0,-1816 # 910 <malloc+0x11c>
  30:	00000097          	auipc	ra,0x0
  34:	3ba080e7          	jalr	954(ra) # 3ea <open>
  if(fd < 0){
  38:	08054063          	bltz	a0,b8 <main+0xb8>
  3c:	e526                	sd	s1,136(sp)
  3e:	fcce                	sd	s3,120(sp)
  40:	84aa                	mv	s1,a0
    exit(1);
  }

  char buf[100];
  int want = 100;
  int got = read(fd, buf, want);
  42:	06400613          	li	a2,100
  46:	f6840593          	addi	a1,s0,-152
  4a:	00000097          	auipc	ra,0x0
  4e:	378080e7          	jalr	888(ra) # 3c2 <read>
  52:	89aa                	mv	s3,a0
  close(fd);
  54:	8526                	mv	a0,s1
  56:	00000097          	auipc	ra,0x0
  5a:	37c080e7          	jalr	892(ra) # 3d2 <close>

  if(got < 0){
  5e:	0609cc63          	bltz	s3,d6 <main+0xd6>
    printf("read failed\n");
    exit(1);
  }

  int after = getreadcount();
  62:	00000097          	auipc	ra,0x0
  66:	400080e7          	jalr	1024(ra) # 462 <getreadcount>
  6a:	84aa                	mv	s1,a0
  printf("read returned      = %d\n", got);
  6c:	85ce                	mv	a1,s3
  6e:	00001517          	auipc	a0,0x1
  72:	8d250513          	addi	a0,a0,-1838 # 940 <malloc+0x14c>
  76:	00000097          	auipc	ra,0x0
  7a:	6c2080e7          	jalr	1730(ra) # 738 <printf>
  printf("getreadcount after = %d\n", after);
  7e:	85a6                	mv	a1,s1
  80:	00001517          	auipc	a0,0x1
  84:	8e050513          	addi	a0,a0,-1824 # 960 <malloc+0x16c>
  88:	00000097          	auipc	ra,0x0
  8c:	6b0080e7          	jalr	1712(ra) # 738 <printf>
  printf("delta              = %d\n", (after - before));
  90:	412484bb          	subw	s1,s1,s2
  94:	85a6                	mv	a1,s1
  96:	00001517          	auipc	a0,0x1
  9a:	8ea50513          	addi	a0,a0,-1814 # 980 <malloc+0x18c>
  9e:	00000097          	auipc	ra,0x0
  a2:	69a080e7          	jalr	1690(ra) # 738 <printf>

  if(got > 0 && (after - before) != got){
  a6:	01348463          	beq	s1,s3,ae <main+0xae>
  aa:	05304363          	bgtz	s3,f0 <main+0xf0>
    printf("note: delta != bytes read (wrap or concurrent reads)\n");
  }
  exit(0);
  ae:	4501                	li	a0,0
  b0:	00000097          	auipc	ra,0x0
  b4:	2fa080e7          	jalr	762(ra) # 3aa <exit>
  b8:	e526                	sd	s1,136(sp)
  ba:	fcce                	sd	s3,120(sp)
    printf("open README failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	85c50513          	addi	a0,a0,-1956 # 918 <malloc+0x124>
  c4:	00000097          	auipc	ra,0x0
  c8:	674080e7          	jalr	1652(ra) # 738 <printf>
    exit(1);
  cc:	4505                	li	a0,1
  ce:	00000097          	auipc	ra,0x0
  d2:	2dc080e7          	jalr	732(ra) # 3aa <exit>
    printf("read failed\n");
  d6:	00001517          	auipc	a0,0x1
  da:	85a50513          	addi	a0,a0,-1958 # 930 <malloc+0x13c>
  de:	00000097          	auipc	ra,0x0
  e2:	65a080e7          	jalr	1626(ra) # 738 <printf>
    exit(1);
  e6:	4505                	li	a0,1
  e8:	00000097          	auipc	ra,0x0
  ec:	2c2080e7          	jalr	706(ra) # 3aa <exit>
    printf("note: delta != bytes read (wrap or concurrent reads)\n");
  f0:	00001517          	auipc	a0,0x1
  f4:	8b050513          	addi	a0,a0,-1872 # 9a0 <malloc+0x1ac>
  f8:	00000097          	auipc	ra,0x0
  fc:	640080e7          	jalr	1600(ra) # 738 <printf>
 100:	b77d                	j	ae <main+0xae>

0000000000000102 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  extern int main();
  main();
 10a:	00000097          	auipc	ra,0x0
 10e:	ef6080e7          	jalr	-266(ra) # 0 <main>
  exit(0);
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	296080e7          	jalr	662(ra) # 3aa <exit>

000000000000011c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0xa>
    ;
  return os;
}
 134:	60a2                	ld	ra,8(sp)
 136:	6402                	ld	s0,0(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret

000000000000013c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e406                	sd	ra,8(sp)
 140:	e022                	sd	s0,0(sp)
 142:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 144:	00054783          	lbu	a5,0(a0)
 148:	cb91                	beqz	a5,15c <strcmp+0x20>
 14a:	0005c703          	lbu	a4,0(a1)
 14e:	00f71763          	bne	a4,a5,15c <strcmp+0x20>
    p++, q++;
 152:	0505                	addi	a0,a0,1
 154:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 156:	00054783          	lbu	a5,0(a0)
 15a:	fbe5                	bnez	a5,14a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 15c:	0005c503          	lbu	a0,0(a1)
}
 160:	40a7853b          	subw	a0,a5,a0
 164:	60a2                	ld	ra,8(sp)
 166:	6402                	ld	s0,0(sp)
 168:	0141                	addi	sp,sp,16
 16a:	8082                	ret

000000000000016c <strlen>:

uint
strlen(const char *s)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e406                	sd	ra,8(sp)
 170:	e022                	sd	s0,0(sp)
 172:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x28>
 17a:	00150793          	addi	a5,a0,1
 17e:	86be                	mv	a3,a5
 180:	0785                	addi	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	ff65                	bnez	a4,17e <strlen+0x12>
 188:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 18c:	60a2                	ld	ra,8(sp)
 18e:	6402                	ld	s0,0(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  for(n = 0; s[n]; n++)
 194:	4501                	li	a0,0
 196:	bfdd                	j	18c <strlen+0x20>

0000000000000198 <memset>:

void*
memset(void *dst, int c, uint n)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e406                	sd	ra,8(sp)
 19c:	e022                	sd	s0,0(sp)
 19e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1a0:	ca19                	beqz	a2,1b6 <memset+0x1e>
 1a2:	87aa                	mv	a5,a0
 1a4:	1602                	slli	a2,a2,0x20
 1a6:	9201                	srli	a2,a2,0x20
 1a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1b0:	0785                	addi	a5,a5,1
 1b2:	fee79de3          	bne	a5,a4,1ac <memset+0x14>
  }
  return dst;
}
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret

00000000000001be <strchr>:

char*
strchr(const char *s, char c)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c6:	00054783          	lbu	a5,0(a0)
 1ca:	cf81                	beqz	a5,1e2 <strchr+0x24>
    if(*s == c)
 1cc:	00f58763          	beq	a1,a5,1da <strchr+0x1c>
  for(; *s; s++)
 1d0:	0505                	addi	a0,a0,1
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	fbfd                	bnez	a5,1cc <strchr+0xe>
      return (char*)s;
  return 0;
 1d8:	4501                	li	a0,0
}
 1da:	60a2                	ld	ra,8(sp)
 1dc:	6402                	ld	s0,0(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret
  return 0;
 1e2:	4501                	li	a0,0
 1e4:	bfdd                	j	1da <strchr+0x1c>

00000000000001e6 <gets>:

char*
gets(char *buf, int max)
{
 1e6:	711d                	addi	sp,sp,-96
 1e8:	ec86                	sd	ra,88(sp)
 1ea:	e8a2                	sd	s0,80(sp)
 1ec:	e4a6                	sd	s1,72(sp)
 1ee:	e0ca                	sd	s2,64(sp)
 1f0:	fc4e                	sd	s3,56(sp)
 1f2:	f852                	sd	s4,48(sp)
 1f4:	f456                	sd	s5,40(sp)
 1f6:	f05a                	sd	s6,32(sp)
 1f8:	ec5e                	sd	s7,24(sp)
 1fa:	e862                	sd	s8,16(sp)
 1fc:	1080                	addi	s0,sp,96
 1fe:	8baa                	mv	s7,a0
 200:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 202:	892a                	mv	s2,a0
 204:	4481                	li	s1,0
    cc = read(0, &c, 1);
 206:	faf40b13          	addi	s6,s0,-81
 20a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 20c:	8c26                	mv	s8,s1
 20e:	0014899b          	addiw	s3,s1,1
 212:	84ce                	mv	s1,s3
 214:	0349d663          	bge	s3,s4,240 <gets+0x5a>
    cc = read(0, &c, 1);
 218:	8656                	mv	a2,s5
 21a:	85da                	mv	a1,s6
 21c:	4501                	li	a0,0
 21e:	00000097          	auipc	ra,0x0
 222:	1a4080e7          	jalr	420(ra) # 3c2 <read>
    if(cc < 1)
 226:	00a05d63          	blez	a0,240 <gets+0x5a>
      break;
    buf[i++] = c;
 22a:	faf44783          	lbu	a5,-81(s0)
 22e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 232:	0905                	addi	s2,s2,1
 234:	ff678713          	addi	a4,a5,-10
 238:	c319                	beqz	a4,23e <gets+0x58>
 23a:	17cd                	addi	a5,a5,-13
 23c:	fbe1                	bnez	a5,20c <gets+0x26>
    buf[i++] = c;
 23e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 240:	9c5e                	add	s8,s8,s7
 242:	000c0023          	sb	zero,0(s8)
  return buf;
}
 246:	855e                	mv	a0,s7
 248:	60e6                	ld	ra,88(sp)
 24a:	6446                	ld	s0,80(sp)
 24c:	64a6                	ld	s1,72(sp)
 24e:	6906                	ld	s2,64(sp)
 250:	79e2                	ld	s3,56(sp)
 252:	7a42                	ld	s4,48(sp)
 254:	7aa2                	ld	s5,40(sp)
 256:	7b02                	ld	s6,32(sp)
 258:	6be2                	ld	s7,24(sp)
 25a:	6c42                	ld	s8,16(sp)
 25c:	6125                	addi	sp,sp,96
 25e:	8082                	ret

0000000000000260 <stat>:

int
stat(const char *n, struct stat *st)
{
 260:	1101                	addi	sp,sp,-32
 262:	ec06                	sd	ra,24(sp)
 264:	e822                	sd	s0,16(sp)
 266:	e04a                	sd	s2,0(sp)
 268:	1000                	addi	s0,sp,32
 26a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26c:	4581                	li	a1,0
 26e:	00000097          	auipc	ra,0x0
 272:	17c080e7          	jalr	380(ra) # 3ea <open>
  if(fd < 0)
 276:	02054663          	bltz	a0,2a2 <stat+0x42>
 27a:	e426                	sd	s1,8(sp)
 27c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27e:	85ca                	mv	a1,s2
 280:	00000097          	auipc	ra,0x0
 284:	182080e7          	jalr	386(ra) # 402 <fstat>
 288:	892a                	mv	s2,a0
  close(fd);
 28a:	8526                	mv	a0,s1
 28c:	00000097          	auipc	ra,0x0
 290:	146080e7          	jalr	326(ra) # 3d2 <close>
  return r;
 294:	64a2                	ld	s1,8(sp)
}
 296:	854a                	mv	a0,s2
 298:	60e2                	ld	ra,24(sp)
 29a:	6442                	ld	s0,16(sp)
 29c:	6902                	ld	s2,0(sp)
 29e:	6105                	addi	sp,sp,32
 2a0:	8082                	ret
    return -1;
 2a2:	57fd                	li	a5,-1
 2a4:	893e                	mv	s2,a5
 2a6:	bfc5                	j	296 <stat+0x36>

00000000000002a8 <atoi>:

int
atoi(const char *s)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b0:	00054683          	lbu	a3,0(a0)
 2b4:	fd06879b          	addiw	a5,a3,-48
 2b8:	0ff7f793          	zext.b	a5,a5
 2bc:	4625                	li	a2,9
 2be:	02f66963          	bltu	a2,a5,2f0 <atoi+0x48>
 2c2:	872a                	mv	a4,a0
  n = 0;
 2c4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c6:	0705                	addi	a4,a4,1
 2c8:	0025179b          	slliw	a5,a0,0x2
 2cc:	9fa9                	addw	a5,a5,a0
 2ce:	0017979b          	slliw	a5,a5,0x1
 2d2:	9fb5                	addw	a5,a5,a3
 2d4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d8:	00074683          	lbu	a3,0(a4)
 2dc:	fd06879b          	addiw	a5,a3,-48
 2e0:	0ff7f793          	zext.b	a5,a5
 2e4:	fef671e3          	bgeu	a2,a5,2c6 <atoi+0x1e>
  return n;
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  n = 0;
 2f0:	4501                	li	a0,0
 2f2:	bfdd                	j	2e8 <atoi+0x40>

00000000000002f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fc:	02b57563          	bgeu	a0,a1,326 <memmove+0x32>
    while(n-- > 0)
 300:	00c05f63          	blez	a2,31e <memmove+0x2a>
 304:	1602                	slli	a2,a2,0x20
 306:	9201                	srli	a2,a2,0x20
 308:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 30c:	872a                	mv	a4,a0
      *dst++ = *src++;
 30e:	0585                	addi	a1,a1,1
 310:	0705                	addi	a4,a4,1
 312:	fff5c683          	lbu	a3,-1(a1)
 316:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31a:	fee79ae3          	bne	a5,a4,30e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
    while(n-- > 0)
 326:	fec05ce3          	blez	a2,31e <memmove+0x2a>
    dst += n;
 32a:	00c50733          	add	a4,a0,a2
    src += n;
 32e:	95b2                	add	a1,a1,a2
 330:	fff6079b          	addiw	a5,a2,-1
 334:	1782                	slli	a5,a5,0x20
 336:	9381                	srli	a5,a5,0x20
 338:	fff7c793          	not	a5,a5
 33c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33e:	15fd                	addi	a1,a1,-1
 340:	177d                	addi	a4,a4,-1
 342:	0005c683          	lbu	a3,0(a1)
 346:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 34a:	fef71ae3          	bne	a4,a5,33e <memmove+0x4a>
 34e:	bfc1                	j	31e <memmove+0x2a>

0000000000000350 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 350:	1141                	addi	sp,sp,-16
 352:	e406                	sd	ra,8(sp)
 354:	e022                	sd	s0,0(sp)
 356:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 358:	c61d                	beqz	a2,386 <memcmp+0x36>
 35a:	1602                	slli	a2,a2,0x20
 35c:	9201                	srli	a2,a2,0x20
 35e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 362:	00054783          	lbu	a5,0(a0)
 366:	0005c703          	lbu	a4,0(a1)
 36a:	00e79863          	bne	a5,a4,37a <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 36e:	0505                	addi	a0,a0,1
    p2++;
 370:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 372:	fed518e3          	bne	a0,a3,362 <memcmp+0x12>
  }
  return 0;
 376:	4501                	li	a0,0
 378:	a019                	j	37e <memcmp+0x2e>
      return *p1 - *p2;
 37a:	40e7853b          	subw	a0,a5,a4
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
  return 0;
 386:	4501                	li	a0,0
 388:	bfdd                	j	37e <memcmp+0x2e>

000000000000038a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 392:	00000097          	auipc	ra,0x0
 396:	f62080e7          	jalr	-158(ra) # 2f4 <memmove>
}
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a2:	4885                	li	a7,1
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3aa:	4889                	li	a7,2
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b2:	488d                	li	a7,3
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ba:	4891                	li	a7,4
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <read>:
.global read
read:
 li a7, SYS_read
 3c2:	4895                	li	a7,5
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <write>:
.global write
write:
 li a7, SYS_write
 3ca:	48c1                	li	a7,16
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <close>:
.global close
close:
 li a7, SYS_close
 3d2:	48d5                	li	a7,21
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <kill>:
.global kill
kill:
 li a7, SYS_kill
 3da:	4899                	li	a7,6
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e2:	489d                	li	a7,7
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <open>:
.global open
open:
 li a7, SYS_open
 3ea:	48bd                	li	a7,15
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f2:	48c5                	li	a7,17
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fa:	48c9                	li	a7,18
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 402:	48a1                	li	a7,8
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <link>:
.global link
link:
 li a7, SYS_link
 40a:	48cd                	li	a7,19
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 412:	48d1                	li	a7,20
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41a:	48a5                	li	a7,9
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <dup>:
.global dup
dup:
 li a7, SYS_dup
 422:	48a9                	li	a7,10
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42a:	48ad                	li	a7,11
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 432:	48b1                	li	a7,12
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43a:	48b5                	li	a7,13
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 442:	48b9                	li	a7,14
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 44a:	48d9                	li	a7,22
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 452:	48dd                	li	a7,23
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <printlog>:
.global printlog
printlog:
 li a7, SYS_printlog
 45a:	48e1                	li	a7,24
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 462:	48e5                	li	a7,25
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <setcfslog>:
.global setcfslog
setcfslog:
 li a7, SYS_setcfslog
 46a:	48e9                	li	a7,26
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	00000097          	auipc	ra,0x0
 488:	f46080e7          	jalr	-186(ra) # 3ca <write>
}
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	6105                	addi	sp,sp,32
 492:	8082                	ret

0000000000000494 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 494:	7139                	addi	sp,sp,-64
 496:	fc06                	sd	ra,56(sp)
 498:	f822                	sd	s0,48(sp)
 49a:	f04a                	sd	s2,32(sp)
 49c:	ec4e                	sd	s3,24(sp)
 49e:	0080                	addi	s0,sp,64
 4a0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a2:	cad9                	beqz	a3,538 <printint+0xa4>
 4a4:	01f5d79b          	srliw	a5,a1,0x1f
 4a8:	cbc1                	beqz	a5,538 <printint+0xa4>
    neg = 1;
    x = -xx;
 4aa:	40b005bb          	negw	a1,a1
    neg = 1;
 4ae:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4b0:	fc040993          	addi	s3,s0,-64
  neg = 0;
 4b4:	86ce                	mv	a3,s3
  i = 0;
 4b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b8:	00000817          	auipc	a6,0x0
 4bc:	58080813          	addi	a6,a6,1408 # a38 <digits>
 4c0:	88ba                	mv	a7,a4
 4c2:	0017051b          	addiw	a0,a4,1
 4c6:	872a                	mv	a4,a0
 4c8:	02c5f7bb          	remuw	a5,a1,a2
 4cc:	1782                	slli	a5,a5,0x20
 4ce:	9381                	srli	a5,a5,0x20
 4d0:	97c2                	add	a5,a5,a6
 4d2:	0007c783          	lbu	a5,0(a5)
 4d6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4da:	87ae                	mv	a5,a1
 4dc:	02c5d5bb          	divuw	a1,a1,a2
 4e0:	0685                	addi	a3,a3,1
 4e2:	fcc7ffe3          	bgeu	a5,a2,4c0 <printint+0x2c>
  if(neg)
 4e6:	00030c63          	beqz	t1,4fe <printint+0x6a>
    buf[i++] = '-';
 4ea:	fd050793          	addi	a5,a0,-48
 4ee:	00878533          	add	a0,a5,s0
 4f2:	02d00793          	li	a5,45
 4f6:	fef50823          	sb	a5,-16(a0)
 4fa:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4fe:	02e05763          	blez	a4,52c <printint+0x98>
 502:	f426                	sd	s1,40(sp)
 504:	377d                	addiw	a4,a4,-1
 506:	00e984b3          	add	s1,s3,a4
 50a:	19fd                	addi	s3,s3,-1
 50c:	99ba                	add	s3,s3,a4
 50e:	1702                	slli	a4,a4,0x20
 510:	9301                	srli	a4,a4,0x20
 512:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 516:	0004c583          	lbu	a1,0(s1)
 51a:	854a                	mv	a0,s2
 51c:	00000097          	auipc	ra,0x0
 520:	f56080e7          	jalr	-170(ra) # 472 <putc>
  while(--i >= 0)
 524:	14fd                	addi	s1,s1,-1
 526:	ff3498e3          	bne	s1,s3,516 <printint+0x82>
 52a:	74a2                	ld	s1,40(sp)
}
 52c:	70e2                	ld	ra,56(sp)
 52e:	7442                	ld	s0,48(sp)
 530:	7902                	ld	s2,32(sp)
 532:	69e2                	ld	s3,24(sp)
 534:	6121                	addi	sp,sp,64
 536:	8082                	ret
  neg = 0;
 538:	4301                	li	t1,0
 53a:	bf9d                	j	4b0 <printint+0x1c>

000000000000053c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53c:	715d                	addi	sp,sp,-80
 53e:	e486                	sd	ra,72(sp)
 540:	e0a2                	sd	s0,64(sp)
 542:	f84a                	sd	s2,48(sp)
 544:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 546:	0005c903          	lbu	s2,0(a1)
 54a:	1a090b63          	beqz	s2,700 <vprintf+0x1c4>
 54e:	fc26                	sd	s1,56(sp)
 550:	f44e                	sd	s3,40(sp)
 552:	f052                	sd	s4,32(sp)
 554:	ec56                	sd	s5,24(sp)
 556:	e85a                	sd	s6,16(sp)
 558:	e45e                	sd	s7,8(sp)
 55a:	8aaa                	mv	s5,a0
 55c:	8bb2                	mv	s7,a2
 55e:	00158493          	addi	s1,a1,1
  state = 0;
 562:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 564:	02500a13          	li	s4,37
 568:	4b55                	li	s6,21
 56a:	a839                	j	588 <vprintf+0x4c>
        putc(fd, c);
 56c:	85ca                	mv	a1,s2
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	f02080e7          	jalr	-254(ra) # 472 <putc>
 578:	a019                	j	57e <vprintf+0x42>
    } else if(state == '%'){
 57a:	01498d63          	beq	s3,s4,594 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 57e:	0485                	addi	s1,s1,1
 580:	fff4c903          	lbu	s2,-1(s1)
 584:	16090863          	beqz	s2,6f4 <vprintf+0x1b8>
    if(state == 0){
 588:	fe0999e3          	bnez	s3,57a <vprintf+0x3e>
      if(c == '%'){
 58c:	ff4910e3          	bne	s2,s4,56c <vprintf+0x30>
        state = '%';
 590:	89d2                	mv	s3,s4
 592:	b7f5                	j	57e <vprintf+0x42>
      if(c == 'd'){
 594:	13490563          	beq	s2,s4,6be <vprintf+0x182>
 598:	f9d9079b          	addiw	a5,s2,-99
 59c:	0ff7f793          	zext.b	a5,a5
 5a0:	12fb6863          	bltu	s6,a5,6d0 <vprintf+0x194>
 5a4:	f9d9079b          	addiw	a5,s2,-99
 5a8:	0ff7f713          	zext.b	a4,a5
 5ac:	12eb6263          	bltu	s6,a4,6d0 <vprintf+0x194>
 5b0:	00271793          	slli	a5,a4,0x2
 5b4:	00000717          	auipc	a4,0x0
 5b8:	42c70713          	addi	a4,a4,1068 # 9e0 <malloc+0x1ec>
 5bc:	97ba                	add	a5,a5,a4
 5be:	439c                	lw	a5,0(a5)
 5c0:	97ba                	add	a5,a5,a4
 5c2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4685                	li	a3,1
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	ec2080e7          	jalr	-318(ra) # 494 <printint>
 5da:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b745                	j	57e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	008b8913          	addi	s2,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000ba583          	lw	a1,0(s7)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	ea6080e7          	jalr	-346(ra) # 494 <printint>
 5f6:	8bca                	mv	s7,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b751                	j	57e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5fc:	008b8913          	addi	s2,s7,8
 600:	4681                	li	a3,0
 602:	4641                	li	a2,16
 604:	000ba583          	lw	a1,0(s7)
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e8a080e7          	jalr	-374(ra) # 494 <printint>
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
 616:	b7a5                	j	57e <vprintf+0x42>
 618:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 61a:	008b8793          	addi	a5,s7,8
 61e:	8c3e                	mv	s8,a5
 620:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 624:	03000593          	li	a1,48
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	e48080e7          	jalr	-440(ra) # 472 <putc>
  putc(fd, 'x');
 632:	07800593          	li	a1,120
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e3a080e7          	jalr	-454(ra) # 472 <putc>
 640:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 642:	00000b97          	auipc	s7,0x0
 646:	3f6b8b93          	addi	s7,s7,1014 # a38 <digits>
 64a:	03c9d793          	srli	a5,s3,0x3c
 64e:	97de                	add	a5,a5,s7
 650:	0007c583          	lbu	a1,0(a5)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e1c080e7          	jalr	-484(ra) # 472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65e:	0992                	slli	s3,s3,0x4
 660:	397d                	addiw	s2,s2,-1
 662:	fe0914e3          	bnez	s2,64a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 666:	8be2                	mv	s7,s8
      state = 0;
 668:	4981                	li	s3,0
 66a:	6c02                	ld	s8,0(sp)
 66c:	bf09                	j	57e <vprintf+0x42>
        s = va_arg(ap, char*);
 66e:	008b8993          	addi	s3,s7,8
 672:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 676:	02090163          	beqz	s2,698 <vprintf+0x15c>
        while(*s != 0){
 67a:	00094583          	lbu	a1,0(s2)
 67e:	c9a5                	beqz	a1,6ee <vprintf+0x1b2>
          putc(fd, *s);
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	df0080e7          	jalr	-528(ra) # 472 <putc>
          s++;
 68a:	0905                	addi	s2,s2,1
        while(*s != 0){
 68c:	00094583          	lbu	a1,0(s2)
 690:	f9e5                	bnez	a1,680 <vprintf+0x144>
        s = va_arg(ap, char*);
 692:	8bce                	mv	s7,s3
      state = 0;
 694:	4981                	li	s3,0
 696:	b5e5                	j	57e <vprintf+0x42>
          s = "(null)";
 698:	00000917          	auipc	s2,0x0
 69c:	34090913          	addi	s2,s2,832 # 9d8 <malloc+0x1e4>
        while(*s != 0){
 6a0:	02800593          	li	a1,40
 6a4:	bff1                	j	680 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	000bc583          	lbu	a1,0(s7)
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	dc2080e7          	jalr	-574(ra) # 472 <putc>
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b5c9                	j	57e <vprintf+0x42>
        putc(fd, c);
 6be:	02500593          	li	a1,37
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	dae080e7          	jalr	-594(ra) # 472 <putc>
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bd45                	j	57e <vprintf+0x42>
        putc(fd, '%');
 6d0:	02500593          	li	a1,37
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	d9c080e7          	jalr	-612(ra) # 472 <putc>
        putc(fd, c);
 6de:	85ca                	mv	a1,s2
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	d90080e7          	jalr	-624(ra) # 472 <putc>
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	bd49                	j	57e <vprintf+0x42>
        s = va_arg(ap, char*);
 6ee:	8bce                	mv	s7,s3
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b571                	j	57e <vprintf+0x42>
 6f4:	74e2                	ld	s1,56(sp)
 6f6:	79a2                	ld	s3,40(sp)
 6f8:	7a02                	ld	s4,32(sp)
 6fa:	6ae2                	ld	s5,24(sp)
 6fc:	6b42                	ld	s6,16(sp)
 6fe:	6ba2                	ld	s7,8(sp)
    }
  }
}
 700:	60a6                	ld	ra,72(sp)
 702:	6406                	ld	s0,64(sp)
 704:	7942                	ld	s2,48(sp)
 706:	6161                	addi	sp,sp,80
 708:	8082                	ret

000000000000070a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70a:	715d                	addi	sp,sp,-80
 70c:	ec06                	sd	ra,24(sp)
 70e:	e822                	sd	s0,16(sp)
 710:	1000                	addi	s0,sp,32
 712:	e010                	sd	a2,0(s0)
 714:	e414                	sd	a3,8(s0)
 716:	e818                	sd	a4,16(s0)
 718:	ec1c                	sd	a5,24(s0)
 71a:	03043023          	sd	a6,32(s0)
 71e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 722:	8622                	mv	a2,s0
 724:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 728:	00000097          	auipc	ra,0x0
 72c:	e14080e7          	jalr	-492(ra) # 53c <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6161                	addi	sp,sp,80
 736:	8082                	ret

0000000000000738 <printf>:

void
printf(const char *fmt, ...)
{
 738:	711d                	addi	sp,sp,-96
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e40c                	sd	a1,8(s0)
 742:	e810                	sd	a2,16(s0)
 744:	ec14                	sd	a3,24(s0)
 746:	f018                	sd	a4,32(s0)
 748:	f41c                	sd	a5,40(s0)
 74a:	03043823          	sd	a6,48(s0)
 74e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	00840613          	addi	a2,s0,8
 756:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75a:	85aa                	mv	a1,a0
 75c:	4505                	li	a0,1
 75e:	00000097          	auipc	ra,0x0
 762:	dde080e7          	jalr	-546(ra) # 53c <vprintf>
}
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76e:	1141                	addi	sp,sp,-16
 770:	e406                	sd	ra,8(sp)
 772:	e022                	sd	s0,0(sp)
 774:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 776:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77a:	00001797          	auipc	a5,0x1
 77e:	8867b783          	ld	a5,-1914(a5) # 1000 <freep>
 782:	a039                	j	790 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 784:	6398                	ld	a4,0(a5)
 786:	00e7e463          	bltu	a5,a4,78e <free+0x20>
 78a:	00e6ea63          	bltu	a3,a4,79e <free+0x30>
{
 78e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	fed7fae3          	bgeu	a5,a3,784 <free+0x16>
 794:	6398                	ld	a4,0(a5)
 796:	00e6e463          	bltu	a3,a4,79e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	fee7eae3          	bltu	a5,a4,78e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 79e:	ff852583          	lw	a1,-8(a0)
 7a2:	6390                	ld	a2,0(a5)
 7a4:	02059813          	slli	a6,a1,0x20
 7a8:	01c85713          	srli	a4,a6,0x1c
 7ac:	9736                	add	a4,a4,a3
 7ae:	02e60563          	beq	a2,a4,7d8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7b6:	4790                	lw	a2,8(a5)
 7b8:	02061593          	slli	a1,a2,0x20
 7bc:	01c5d713          	srli	a4,a1,0x1c
 7c0:	973e                	add	a4,a4,a5
 7c2:	02e68263          	beq	a3,a4,7e6 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7c6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c8:	00001717          	auipc	a4,0x1
 7cc:	82f73c23          	sd	a5,-1992(a4) # 1000 <freep>
}
 7d0:	60a2                	ld	ra,8(sp)
 7d2:	6402                	ld	s0,0(sp)
 7d4:	0141                	addi	sp,sp,16
 7d6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7d8:	4618                	lw	a4,8(a2)
 7da:	9f2d                	addw	a4,a4,a1
 7dc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	6398                	ld	a4,0(a5)
 7e2:	6310                	ld	a2,0(a4)
 7e4:	b7f9                	j	7b2 <free+0x44>
    p->s.size += bp->s.size;
 7e6:	ff852703          	lw	a4,-8(a0)
 7ea:	9f31                	addw	a4,a4,a2
 7ec:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ee:	ff053683          	ld	a3,-16(a0)
 7f2:	bfd1                	j	7c6 <free+0x58>

00000000000007f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f4:	7139                	addi	sp,sp,-64
 7f6:	fc06                	sd	ra,56(sp)
 7f8:	f822                	sd	s0,48(sp)
 7fa:	f04a                	sd	s2,32(sp)
 7fc:	ec4e                	sd	s3,24(sp)
 7fe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 800:	02051993          	slli	s3,a0,0x20
 804:	0209d993          	srli	s3,s3,0x20
 808:	09bd                	addi	s3,s3,15
 80a:	0049d993          	srli	s3,s3,0x4
 80e:	2985                	addiw	s3,s3,1
 810:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 812:	00000517          	auipc	a0,0x0
 816:	7ee53503          	ld	a0,2030(a0) # 1000 <freep>
 81a:	c905                	beqz	a0,84a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81e:	4798                	lw	a4,8(a5)
 820:	09377a63          	bgeu	a4,s3,8b4 <malloc+0xc0>
 824:	f426                	sd	s1,40(sp)
 826:	e852                	sd	s4,16(sp)
 828:	e456                	sd	s5,8(sp)
 82a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 82c:	8a4e                	mv	s4,s3
 82e:	6705                	lui	a4,0x1
 830:	00e9f363          	bgeu	s3,a4,836 <malloc+0x42>
 834:	6a05                	lui	s4,0x1
 836:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 83a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83e:	00000497          	auipc	s1,0x0
 842:	7c248493          	addi	s1,s1,1986 # 1000 <freep>
  if(p == (char*)-1)
 846:	5afd                	li	s5,-1
 848:	a089                	j	88a <malloc+0x96>
 84a:	f426                	sd	s1,40(sp)
 84c:	e852                	sd	s4,16(sp)
 84e:	e456                	sd	s5,8(sp)
 850:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 852:	00000797          	auipc	a5,0x0
 856:	7be78793          	addi	a5,a5,1982 # 1010 <base>
 85a:	00000717          	auipc	a4,0x0
 85e:	7af73323          	sd	a5,1958(a4) # 1000 <freep>
 862:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 864:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 868:	b7d1                	j	82c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 86a:	6398                	ld	a4,0(a5)
 86c:	e118                	sd	a4,0(a0)
 86e:	a8b9                	j	8cc <malloc+0xd8>
  hp->s.size = nu;
 870:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 874:	0541                	addi	a0,a0,16
 876:	00000097          	auipc	ra,0x0
 87a:	ef8080e7          	jalr	-264(ra) # 76e <free>
  return freep;
 87e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 880:	c135                	beqz	a0,8e4 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 882:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 884:	4798                	lw	a4,8(a5)
 886:	03277363          	bgeu	a4,s2,8ac <malloc+0xb8>
    if(p == freep)
 88a:	6098                	ld	a4,0(s1)
 88c:	853e                	mv	a0,a5
 88e:	fef71ae3          	bne	a4,a5,882 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 892:	8552                	mv	a0,s4
 894:	00000097          	auipc	ra,0x0
 898:	b9e080e7          	jalr	-1122(ra) # 432 <sbrk>
  if(p == (char*)-1)
 89c:	fd551ae3          	bne	a0,s5,870 <malloc+0x7c>
        return 0;
 8a0:	4501                	li	a0,0
 8a2:	74a2                	ld	s1,40(sp)
 8a4:	6a42                	ld	s4,16(sp)
 8a6:	6aa2                	ld	s5,8(sp)
 8a8:	6b02                	ld	s6,0(sp)
 8aa:	a03d                	j	8d8 <malloc+0xe4>
 8ac:	74a2                	ld	s1,40(sp)
 8ae:	6a42                	ld	s4,16(sp)
 8b0:	6aa2                	ld	s5,8(sp)
 8b2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8b4:	fae90be3          	beq	s2,a4,86a <malloc+0x76>
        p->s.size -= nunits;
 8b8:	4137073b          	subw	a4,a4,s3
 8bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8be:	02071693          	slli	a3,a4,0x20
 8c2:	01c6d713          	srli	a4,a3,0x1c
 8c6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8cc:	00000717          	auipc	a4,0x0
 8d0:	72a73a23          	sd	a0,1844(a4) # 1000 <freep>
      return (void*)(p + 1);
 8d4:	01078513          	addi	a0,a5,16
  }
}
 8d8:	70e2                	ld	ra,56(sp)
 8da:	7442                	ld	s0,48(sp)
 8dc:	7902                	ld	s2,32(sp)
 8de:	69e2                	ld	s3,24(sp)
 8e0:	6121                	addi	sp,sp,64
 8e2:	8082                	ret
 8e4:	74a2                	ld	s1,40(sp)
 8e6:	6a42                	ld	s4,16(sp)
 8e8:	6aa2                	ld	s5,8(sp)
 8ea:	6b02                	ld	s6,0(sp)
 8ec:	b7f5                	j	8d8 <malloc+0xe4>
