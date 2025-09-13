
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	32a080e7          	jalr	810(ra) # 336 <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	2fe080e7          	jalr	766(ra) # 336 <strlen>
  40:	47b5                	li	a5,13
  42:	00a7f863          	bgeu	a5,a0,52 <fmtname+0x52>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  46:	8526                	mv	a0,s1
  48:	60e2                	ld	ra,24(sp)
  4a:	6442                	ld	s0,16(sp)
  4c:	64a2                	ld	s1,8(sp)
  4e:	6105                	addi	sp,sp,32
  50:	8082                	ret
  52:	e04a                	sd	s2,0(sp)
  memmove(buf, p, strlen(p));
  54:	8526                	mv	a0,s1
  56:	00000097          	auipc	ra,0x0
  5a:	2e0080e7          	jalr	736(ra) # 336 <strlen>
  5e:	862a                	mv	a2,a0
  60:	85a6                	mv	a1,s1
  62:	00001517          	auipc	a0,0x1
  66:	fae50513          	addi	a0,a0,-82 # 1010 <buf.0>
  6a:	00000097          	auipc	ra,0x0
  6e:	454080e7          	jalr	1108(ra) # 4be <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  72:	8526                	mv	a0,s1
  74:	00000097          	auipc	ra,0x0
  78:	2c2080e7          	jalr	706(ra) # 336 <strlen>
  7c:	892a                	mv	s2,a0
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2b6080e7          	jalr	694(ra) # 336 <strlen>
  88:	02091793          	slli	a5,s2,0x20
  8c:	9381                	srli	a5,a5,0x20
  8e:	4639                	li	a2,14
  90:	9e09                	subw	a2,a2,a0
  92:	02000593          	li	a1,32
  96:	00001517          	auipc	a0,0x1
  9a:	f7a50513          	addi	a0,a0,-134 # 1010 <buf.0>
  9e:	953e                	add	a0,a0,a5
  a0:	00000097          	auipc	ra,0x0
  a4:	2c2080e7          	jalr	706(ra) # 362 <memset>
  return buf;
  a8:	00001497          	auipc	s1,0x1
  ac:	f6848493          	addi	s1,s1,-152 # 1010 <buf.0>
  b0:	6902                	ld	s2,0(sp)
  b2:	bf51                	j	46 <fmtname+0x46>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	da010113          	addi	sp,sp,-608
  b8:	24113c23          	sd	ra,600(sp)
  bc:	24813823          	sd	s0,592(sp)
  c0:	25213023          	sd	s2,576(sp)
  c4:	1480                	addi	s0,sp,608
  c6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c8:	4581                	li	a1,0
  ca:	00000097          	auipc	ra,0x0
  ce:	4ea080e7          	jalr	1258(ra) # 5b4 <open>
  d2:	06054b63          	bltz	a0,148 <ls+0x94>
  d6:	24913423          	sd	s1,584(sp)
  da:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  dc:	da840593          	addi	a1,s0,-600
  e0:	00000097          	auipc	ra,0x0
  e4:	4ec080e7          	jalr	1260(ra) # 5cc <fstat>
  e8:	06054b63          	bltz	a0,15e <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  ec:	db041783          	lh	a5,-592(s0)
  f0:	4705                	li	a4,1
  f2:	08e78863          	beq	a5,a4,182 <ls+0xce>
  f6:	37f9                	addiw	a5,a5,-2
  f8:	17c2                	slli	a5,a5,0x30
  fa:	93c1                	srli	a5,a5,0x30
  fc:	02f76663          	bltu	a4,a5,128 <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 100:	854a                	mv	a0,s2
 102:	00000097          	auipc	ra,0x0
 106:	efe080e7          	jalr	-258(ra) # 0 <fmtname>
 10a:	85aa                	mv	a1,a0
 10c:	db843703          	ld	a4,-584(s0)
 110:	dac42683          	lw	a3,-596(s0)
 114:	db041603          	lh	a2,-592(s0)
 118:	00001517          	auipc	a0,0x1
 11c:	9d850513          	addi	a0,a0,-1576 # af0 <malloc+0x132>
 120:	00000097          	auipc	ra,0x0
 124:	7e2080e7          	jalr	2018(ra) # 902 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 128:	8526                	mv	a0,s1
 12a:	00000097          	auipc	ra,0x0
 12e:	472080e7          	jalr	1138(ra) # 59c <close>
 132:	24813483          	ld	s1,584(sp)
}
 136:	25813083          	ld	ra,600(sp)
 13a:	25013403          	ld	s0,592(sp)
 13e:	24013903          	ld	s2,576(sp)
 142:	26010113          	addi	sp,sp,608
 146:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 148:	864a                	mv	a2,s2
 14a:	00001597          	auipc	a1,0x1
 14e:	97658593          	addi	a1,a1,-1674 # ac0 <malloc+0x102>
 152:	4509                	li	a0,2
 154:	00000097          	auipc	ra,0x0
 158:	780080e7          	jalr	1920(ra) # 8d4 <fprintf>
    return;
 15c:	bfe9                	j	136 <ls+0x82>
    fprintf(2, "ls: cannot stat %s\n", path);
 15e:	864a                	mv	a2,s2
 160:	00001597          	auipc	a1,0x1
 164:	97858593          	addi	a1,a1,-1672 # ad8 <malloc+0x11a>
 168:	4509                	li	a0,2
 16a:	00000097          	auipc	ra,0x0
 16e:	76a080e7          	jalr	1898(ra) # 8d4 <fprintf>
    close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	428080e7          	jalr	1064(ra) # 59c <close>
    return;
 17c:	24813483          	ld	s1,584(sp)
 180:	bf5d                	j	136 <ls+0x82>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 182:	854a                	mv	a0,s2
 184:	00000097          	auipc	ra,0x0
 188:	1b2080e7          	jalr	434(ra) # 336 <strlen>
 18c:	2541                	addiw	a0,a0,16
 18e:	20000793          	li	a5,512
 192:	00a7fb63          	bgeu	a5,a0,1a8 <ls+0xf4>
      printf("ls: path too long\n");
 196:	00001517          	auipc	a0,0x1
 19a:	96a50513          	addi	a0,a0,-1686 # b00 <malloc+0x142>
 19e:	00000097          	auipc	ra,0x0
 1a2:	764080e7          	jalr	1892(ra) # 902 <printf>
      break;
 1a6:	b749                	j	128 <ls+0x74>
 1a8:	23313c23          	sd	s3,568(sp)
    strcpy(buf, path);
 1ac:	85ca                	mv	a1,s2
 1ae:	dd040513          	addi	a0,s0,-560
 1b2:	00000097          	auipc	ra,0x0
 1b6:	134080e7          	jalr	308(ra) # 2e6 <strcpy>
    p = buf+strlen(buf);
 1ba:	dd040513          	addi	a0,s0,-560
 1be:	00000097          	auipc	ra,0x0
 1c2:	178080e7          	jalr	376(ra) # 336 <strlen>
 1c6:	1502                	slli	a0,a0,0x20
 1c8:	9101                	srli	a0,a0,0x20
 1ca:	dd040793          	addi	a5,s0,-560
 1ce:	00a78733          	add	a4,a5,a0
 1d2:	893a                	mv	s2,a4
    *p++ = '/';
 1d4:	00170793          	addi	a5,a4,1
 1d8:	89be                	mv	s3,a5
 1da:	02f00793          	li	a5,47
 1de:	00f70023          	sb	a5,0(a4)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e2:	a819                	j	1f8 <ls+0x144>
        printf("ls: cannot stat %s\n", buf);
 1e4:	dd040593          	addi	a1,s0,-560
 1e8:	00001517          	auipc	a0,0x1
 1ec:	8f050513          	addi	a0,a0,-1808 # ad8 <malloc+0x11a>
 1f0:	00000097          	auipc	ra,0x0
 1f4:	712080e7          	jalr	1810(ra) # 902 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f8:	4641                	li	a2,16
 1fa:	dc040593          	addi	a1,s0,-576
 1fe:	8526                	mv	a0,s1
 200:	00000097          	auipc	ra,0x0
 204:	38c080e7          	jalr	908(ra) # 58c <read>
 208:	47c1                	li	a5,16
 20a:	04f51f63          	bne	a0,a5,268 <ls+0x1b4>
      if(de.inum == 0)
 20e:	dc045783          	lhu	a5,-576(s0)
 212:	d3fd                	beqz	a5,1f8 <ls+0x144>
      memmove(p, de.name, DIRSIZ);
 214:	4639                	li	a2,14
 216:	dc240593          	addi	a1,s0,-574
 21a:	854e                	mv	a0,s3
 21c:	00000097          	auipc	ra,0x0
 220:	2a2080e7          	jalr	674(ra) # 4be <memmove>
      p[DIRSIZ] = 0;
 224:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 228:	da840593          	addi	a1,s0,-600
 22c:	dd040513          	addi	a0,s0,-560
 230:	00000097          	auipc	ra,0x0
 234:	1fa080e7          	jalr	506(ra) # 42a <stat>
 238:	fa0546e3          	bltz	a0,1e4 <ls+0x130>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 23c:	dd040513          	addi	a0,s0,-560
 240:	00000097          	auipc	ra,0x0
 244:	dc0080e7          	jalr	-576(ra) # 0 <fmtname>
 248:	85aa                	mv	a1,a0
 24a:	db843703          	ld	a4,-584(s0)
 24e:	dac42683          	lw	a3,-596(s0)
 252:	db041603          	lh	a2,-592(s0)
 256:	00001517          	auipc	a0,0x1
 25a:	8c250513          	addi	a0,a0,-1854 # b18 <malloc+0x15a>
 25e:	00000097          	auipc	ra,0x0
 262:	6a4080e7          	jalr	1700(ra) # 902 <printf>
 266:	bf49                	j	1f8 <ls+0x144>
 268:	23813983          	ld	s3,568(sp)
 26c:	bd75                	j	128 <ls+0x74>

000000000000026e <main>:

int
main(int argc, char *argv[])
{
 26e:	1101                	addi	sp,sp,-32
 270:	ec06                	sd	ra,24(sp)
 272:	e822                	sd	s0,16(sp)
 274:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 276:	4785                	li	a5,1
 278:	02a7db63          	bge	a5,a0,2ae <main+0x40>
 27c:	e426                	sd	s1,8(sp)
 27e:	e04a                	sd	s2,0(sp)
 280:	00858493          	addi	s1,a1,8
 284:	ffe5091b          	addiw	s2,a0,-2
 288:	02091793          	slli	a5,s2,0x20
 28c:	01d7d913          	srli	s2,a5,0x1d
 290:	05c1                	addi	a1,a1,16
 292:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 294:	6088                	ld	a0,0(s1)
 296:	00000097          	auipc	ra,0x0
 29a:	e1e080e7          	jalr	-482(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 29e:	04a1                	addi	s1,s1,8
 2a0:	ff249ae3          	bne	s1,s2,294 <main+0x26>
  exit(0);
 2a4:	4501                	li	a0,0
 2a6:	00000097          	auipc	ra,0x0
 2aa:	2ce080e7          	jalr	718(ra) # 574 <exit>
 2ae:	e426                	sd	s1,8(sp)
 2b0:	e04a                	sd	s2,0(sp)
    ls(".");
 2b2:	00001517          	auipc	a0,0x1
 2b6:	87650513          	addi	a0,a0,-1930 # b28 <malloc+0x16a>
 2ba:	00000097          	auipc	ra,0x0
 2be:	dfa080e7          	jalr	-518(ra) # b4 <ls>
    exit(0);
 2c2:	4501                	li	a0,0
 2c4:	00000097          	auipc	ra,0x0
 2c8:	2b0080e7          	jalr	688(ra) # 574 <exit>

00000000000002cc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2d4:	00000097          	auipc	ra,0x0
 2d8:	f9a080e7          	jalr	-102(ra) # 26e <main>
  exit(0);
 2dc:	4501                	li	a0,0
 2de:	00000097          	auipc	ra,0x0
 2e2:	296080e7          	jalr	662(ra) # 574 <exit>

00000000000002e6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ee:	87aa                	mv	a5,a0
 2f0:	0585                	addi	a1,a1,1
 2f2:	0785                	addi	a5,a5,1
 2f4:	fff5c703          	lbu	a4,-1(a1)
 2f8:	fee78fa3          	sb	a4,-1(a5)
 2fc:	fb75                	bnez	a4,2f0 <strcpy+0xa>
    ;
  return os;
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 30e:	00054783          	lbu	a5,0(a0)
 312:	cb91                	beqz	a5,326 <strcmp+0x20>
 314:	0005c703          	lbu	a4,0(a1)
 318:	00f71763          	bne	a4,a5,326 <strcmp+0x20>
    p++, q++;
 31c:	0505                	addi	a0,a0,1
 31e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 320:	00054783          	lbu	a5,0(a0)
 324:	fbe5                	bnez	a5,314 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 326:	0005c503          	lbu	a0,0(a1)
}
 32a:	40a7853b          	subw	a0,a5,a0
 32e:	60a2                	ld	ra,8(sp)
 330:	6402                	ld	s0,0(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <strlen>:

uint
strlen(const char *s)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 33e:	00054783          	lbu	a5,0(a0)
 342:	cf91                	beqz	a5,35e <strlen+0x28>
 344:	00150793          	addi	a5,a0,1
 348:	86be                	mv	a3,a5
 34a:	0785                	addi	a5,a5,1
 34c:	fff7c703          	lbu	a4,-1(a5)
 350:	ff65                	bnez	a4,348 <strlen+0x12>
 352:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
  for(n = 0; s[n]; n++)
 35e:	4501                	li	a0,0
 360:	bfdd                	j	356 <strlen+0x20>

0000000000000362 <memset>:

void*
memset(void *dst, int c, uint n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e406                	sd	ra,8(sp)
 366:	e022                	sd	s0,0(sp)
 368:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 36a:	ca19                	beqz	a2,380 <memset+0x1e>
 36c:	87aa                	mv	a5,a0
 36e:	1602                	slli	a2,a2,0x20
 370:	9201                	srli	a2,a2,0x20
 372:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 376:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 37a:	0785                	addi	a5,a5,1
 37c:	fee79de3          	bne	a5,a4,376 <memset+0x14>
  }
  return dst;
}
 380:	60a2                	ld	ra,8(sp)
 382:	6402                	ld	s0,0(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret

0000000000000388 <strchr>:

char*
strchr(const char *s, char c)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 390:	00054783          	lbu	a5,0(a0)
 394:	cf81                	beqz	a5,3ac <strchr+0x24>
    if(*s == c)
 396:	00f58763          	beq	a1,a5,3a4 <strchr+0x1c>
  for(; *s; s++)
 39a:	0505                	addi	a0,a0,1
 39c:	00054783          	lbu	a5,0(a0)
 3a0:	fbfd                	bnez	a5,396 <strchr+0xe>
      return (char*)s;
  return 0;
 3a2:	4501                	li	a0,0
}
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret
  return 0;
 3ac:	4501                	li	a0,0
 3ae:	bfdd                	j	3a4 <strchr+0x1c>

00000000000003b0 <gets>:

char*
gets(char *buf, int max)
{
 3b0:	711d                	addi	sp,sp,-96
 3b2:	ec86                	sd	ra,88(sp)
 3b4:	e8a2                	sd	s0,80(sp)
 3b6:	e4a6                	sd	s1,72(sp)
 3b8:	e0ca                	sd	s2,64(sp)
 3ba:	fc4e                	sd	s3,56(sp)
 3bc:	f852                	sd	s4,48(sp)
 3be:	f456                	sd	s5,40(sp)
 3c0:	f05a                	sd	s6,32(sp)
 3c2:	ec5e                	sd	s7,24(sp)
 3c4:	e862                	sd	s8,16(sp)
 3c6:	1080                	addi	s0,sp,96
 3c8:	8baa                	mv	s7,a0
 3ca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3cc:	892a                	mv	s2,a0
 3ce:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3d0:	faf40b13          	addi	s6,s0,-81
 3d4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 3d6:	8c26                	mv	s8,s1
 3d8:	0014899b          	addiw	s3,s1,1
 3dc:	84ce                	mv	s1,s3
 3de:	0349d663          	bge	s3,s4,40a <gets+0x5a>
    cc = read(0, &c, 1);
 3e2:	8656                	mv	a2,s5
 3e4:	85da                	mv	a1,s6
 3e6:	4501                	li	a0,0
 3e8:	00000097          	auipc	ra,0x0
 3ec:	1a4080e7          	jalr	420(ra) # 58c <read>
    if(cc < 1)
 3f0:	00a05d63          	blez	a0,40a <gets+0x5a>
      break;
    buf[i++] = c;
 3f4:	faf44783          	lbu	a5,-81(s0)
 3f8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3fc:	0905                	addi	s2,s2,1
 3fe:	ff678713          	addi	a4,a5,-10
 402:	c319                	beqz	a4,408 <gets+0x58>
 404:	17cd                	addi	a5,a5,-13
 406:	fbe1                	bnez	a5,3d6 <gets+0x26>
    buf[i++] = c;
 408:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 40a:	9c5e                	add	s8,s8,s7
 40c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 410:	855e                	mv	a0,s7
 412:	60e6                	ld	ra,88(sp)
 414:	6446                	ld	s0,80(sp)
 416:	64a6                	ld	s1,72(sp)
 418:	6906                	ld	s2,64(sp)
 41a:	79e2                	ld	s3,56(sp)
 41c:	7a42                	ld	s4,48(sp)
 41e:	7aa2                	ld	s5,40(sp)
 420:	7b02                	ld	s6,32(sp)
 422:	6be2                	ld	s7,24(sp)
 424:	6c42                	ld	s8,16(sp)
 426:	6125                	addi	sp,sp,96
 428:	8082                	ret

000000000000042a <stat>:

int
stat(const char *n, struct stat *st)
{
 42a:	1101                	addi	sp,sp,-32
 42c:	ec06                	sd	ra,24(sp)
 42e:	e822                	sd	s0,16(sp)
 430:	e04a                	sd	s2,0(sp)
 432:	1000                	addi	s0,sp,32
 434:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 436:	4581                	li	a1,0
 438:	00000097          	auipc	ra,0x0
 43c:	17c080e7          	jalr	380(ra) # 5b4 <open>
  if(fd < 0)
 440:	02054663          	bltz	a0,46c <stat+0x42>
 444:	e426                	sd	s1,8(sp)
 446:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 448:	85ca                	mv	a1,s2
 44a:	00000097          	auipc	ra,0x0
 44e:	182080e7          	jalr	386(ra) # 5cc <fstat>
 452:	892a                	mv	s2,a0
  close(fd);
 454:	8526                	mv	a0,s1
 456:	00000097          	auipc	ra,0x0
 45a:	146080e7          	jalr	326(ra) # 59c <close>
  return r;
 45e:	64a2                	ld	s1,8(sp)
}
 460:	854a                	mv	a0,s2
 462:	60e2                	ld	ra,24(sp)
 464:	6442                	ld	s0,16(sp)
 466:	6902                	ld	s2,0(sp)
 468:	6105                	addi	sp,sp,32
 46a:	8082                	ret
    return -1;
 46c:	57fd                	li	a5,-1
 46e:	893e                	mv	s2,a5
 470:	bfc5                	j	460 <stat+0x36>

0000000000000472 <atoi>:

int
atoi(const char *s)
{
 472:	1141                	addi	sp,sp,-16
 474:	e406                	sd	ra,8(sp)
 476:	e022                	sd	s0,0(sp)
 478:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 47a:	00054683          	lbu	a3,0(a0)
 47e:	fd06879b          	addiw	a5,a3,-48
 482:	0ff7f793          	zext.b	a5,a5
 486:	4625                	li	a2,9
 488:	02f66963          	bltu	a2,a5,4ba <atoi+0x48>
 48c:	872a                	mv	a4,a0
  n = 0;
 48e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 490:	0705                	addi	a4,a4,1
 492:	0025179b          	slliw	a5,a0,0x2
 496:	9fa9                	addw	a5,a5,a0
 498:	0017979b          	slliw	a5,a5,0x1
 49c:	9fb5                	addw	a5,a5,a3
 49e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4a2:	00074683          	lbu	a3,0(a4)
 4a6:	fd06879b          	addiw	a5,a3,-48
 4aa:	0ff7f793          	zext.b	a5,a5
 4ae:	fef671e3          	bgeu	a2,a5,490 <atoi+0x1e>
  return n;
}
 4b2:	60a2                	ld	ra,8(sp)
 4b4:	6402                	ld	s0,0(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret
  n = 0;
 4ba:	4501                	li	a0,0
 4bc:	bfdd                	j	4b2 <atoi+0x40>

00000000000004be <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4be:	1141                	addi	sp,sp,-16
 4c0:	e406                	sd	ra,8(sp)
 4c2:	e022                	sd	s0,0(sp)
 4c4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4c6:	02b57563          	bgeu	a0,a1,4f0 <memmove+0x32>
    while(n-- > 0)
 4ca:	00c05f63          	blez	a2,4e8 <memmove+0x2a>
 4ce:	1602                	slli	a2,a2,0x20
 4d0:	9201                	srli	a2,a2,0x20
 4d2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4d6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4d8:	0585                	addi	a1,a1,1
 4da:	0705                	addi	a4,a4,1
 4dc:	fff5c683          	lbu	a3,-1(a1)
 4e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4e4:	fee79ae3          	bne	a5,a4,4d8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4e8:	60a2                	ld	ra,8(sp)
 4ea:	6402                	ld	s0,0(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret
    while(n-- > 0)
 4f0:	fec05ce3          	blez	a2,4e8 <memmove+0x2a>
    dst += n;
 4f4:	00c50733          	add	a4,a0,a2
    src += n;
 4f8:	95b2                	add	a1,a1,a2
 4fa:	fff6079b          	addiw	a5,a2,-1
 4fe:	1782                	slli	a5,a5,0x20
 500:	9381                	srli	a5,a5,0x20
 502:	fff7c793          	not	a5,a5
 506:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 508:	15fd                	addi	a1,a1,-1
 50a:	177d                	addi	a4,a4,-1
 50c:	0005c683          	lbu	a3,0(a1)
 510:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 514:	fef71ae3          	bne	a4,a5,508 <memmove+0x4a>
 518:	bfc1                	j	4e8 <memmove+0x2a>

000000000000051a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 51a:	1141                	addi	sp,sp,-16
 51c:	e406                	sd	ra,8(sp)
 51e:	e022                	sd	s0,0(sp)
 520:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 522:	c61d                	beqz	a2,550 <memcmp+0x36>
 524:	1602                	slli	a2,a2,0x20
 526:	9201                	srli	a2,a2,0x20
 528:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 52c:	00054783          	lbu	a5,0(a0)
 530:	0005c703          	lbu	a4,0(a1)
 534:	00e79863          	bne	a5,a4,544 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 538:	0505                	addi	a0,a0,1
    p2++;
 53a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 53c:	fed518e3          	bne	a0,a3,52c <memcmp+0x12>
  }
  return 0;
 540:	4501                	li	a0,0
 542:	a019                	j	548 <memcmp+0x2e>
      return *p1 - *p2;
 544:	40e7853b          	subw	a0,a5,a4
}
 548:	60a2                	ld	ra,8(sp)
 54a:	6402                	ld	s0,0(sp)
 54c:	0141                	addi	sp,sp,16
 54e:	8082                	ret
  return 0;
 550:	4501                	li	a0,0
 552:	bfdd                	j	548 <memcmp+0x2e>

0000000000000554 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 554:	1141                	addi	sp,sp,-16
 556:	e406                	sd	ra,8(sp)
 558:	e022                	sd	s0,0(sp)
 55a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 55c:	00000097          	auipc	ra,0x0
 560:	f62080e7          	jalr	-158(ra) # 4be <memmove>
}
 564:	60a2                	ld	ra,8(sp)
 566:	6402                	ld	s0,0(sp)
 568:	0141                	addi	sp,sp,16
 56a:	8082                	ret

000000000000056c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 56c:	4885                	li	a7,1
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <exit>:
.global exit
exit:
 li a7, SYS_exit
 574:	4889                	li	a7,2
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <wait>:
.global wait
wait:
 li a7, SYS_wait
 57c:	488d                	li	a7,3
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 584:	4891                	li	a7,4
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <read>:
.global read
read:
 li a7, SYS_read
 58c:	4895                	li	a7,5
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <write>:
.global write
write:
 li a7, SYS_write
 594:	48c1                	li	a7,16
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <close>:
.global close
close:
 li a7, SYS_close
 59c:	48d5                	li	a7,21
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a4:	4899                	li	a7,6
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <exec>:
.global exec
exec:
 li a7, SYS_exec
 5ac:	489d                	li	a7,7
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <open>:
.global open
open:
 li a7, SYS_open
 5b4:	48bd                	li	a7,15
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5bc:	48c5                	li	a7,17
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c4:	48c9                	li	a7,18
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5cc:	48a1                	li	a7,8
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <link>:
.global link
link:
 li a7, SYS_link
 5d4:	48cd                	li	a7,19
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5dc:	48d1                	li	a7,20
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e4:	48a5                	li	a7,9
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ec:	48a9                	li	a7,10
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f4:	48ad                	li	a7,11
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5fc:	48b1                	li	a7,12
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 604:	48b5                	li	a7,13
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 60c:	48b9                	li	a7,14
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 614:	48d9                	li	a7,22
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
 61c:	48dd                	li	a7,23
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <printlog>:
.global printlog
printlog:
 li a7, SYS_printlog
 624:	48e1                	li	a7,24
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 62c:	48e5                	li	a7,25
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <setcfslog>:
.global setcfslog
setcfslog:
 li a7, SYS_setcfslog
 634:	48e9                	li	a7,26
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 63c:	1101                	addi	sp,sp,-32
 63e:	ec06                	sd	ra,24(sp)
 640:	e822                	sd	s0,16(sp)
 642:	1000                	addi	s0,sp,32
 644:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 648:	4605                	li	a2,1
 64a:	fef40593          	addi	a1,s0,-17
 64e:	00000097          	auipc	ra,0x0
 652:	f46080e7          	jalr	-186(ra) # 594 <write>
}
 656:	60e2                	ld	ra,24(sp)
 658:	6442                	ld	s0,16(sp)
 65a:	6105                	addi	sp,sp,32
 65c:	8082                	ret

000000000000065e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65e:	7139                	addi	sp,sp,-64
 660:	fc06                	sd	ra,56(sp)
 662:	f822                	sd	s0,48(sp)
 664:	f04a                	sd	s2,32(sp)
 666:	ec4e                	sd	s3,24(sp)
 668:	0080                	addi	s0,sp,64
 66a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66c:	cad9                	beqz	a3,702 <printint+0xa4>
 66e:	01f5d79b          	srliw	a5,a1,0x1f
 672:	cbc1                	beqz	a5,702 <printint+0xa4>
    neg = 1;
    x = -xx;
 674:	40b005bb          	negw	a1,a1
    neg = 1;
 678:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 67a:	fc040993          	addi	s3,s0,-64
  neg = 0;
 67e:	86ce                	mv	a3,s3
  i = 0;
 680:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 682:	00000817          	auipc	a6,0x0
 686:	50e80813          	addi	a6,a6,1294 # b90 <digits>
 68a:	88ba                	mv	a7,a4
 68c:	0017051b          	addiw	a0,a4,1
 690:	872a                	mv	a4,a0
 692:	02c5f7bb          	remuw	a5,a1,a2
 696:	1782                	slli	a5,a5,0x20
 698:	9381                	srli	a5,a5,0x20
 69a:	97c2                	add	a5,a5,a6
 69c:	0007c783          	lbu	a5,0(a5)
 6a0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6a4:	87ae                	mv	a5,a1
 6a6:	02c5d5bb          	divuw	a1,a1,a2
 6aa:	0685                	addi	a3,a3,1
 6ac:	fcc7ffe3          	bgeu	a5,a2,68a <printint+0x2c>
  if(neg)
 6b0:	00030c63          	beqz	t1,6c8 <printint+0x6a>
    buf[i++] = '-';
 6b4:	fd050793          	addi	a5,a0,-48
 6b8:	00878533          	add	a0,a5,s0
 6bc:	02d00793          	li	a5,45
 6c0:	fef50823          	sb	a5,-16(a0)
 6c4:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 6c8:	02e05763          	blez	a4,6f6 <printint+0x98>
 6cc:	f426                	sd	s1,40(sp)
 6ce:	377d                	addiw	a4,a4,-1
 6d0:	00e984b3          	add	s1,s3,a4
 6d4:	19fd                	addi	s3,s3,-1
 6d6:	99ba                	add	s3,s3,a4
 6d8:	1702                	slli	a4,a4,0x20
 6da:	9301                	srli	a4,a4,0x20
 6dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6e0:	0004c583          	lbu	a1,0(s1)
 6e4:	854a                	mv	a0,s2
 6e6:	00000097          	auipc	ra,0x0
 6ea:	f56080e7          	jalr	-170(ra) # 63c <putc>
  while(--i >= 0)
 6ee:	14fd                	addi	s1,s1,-1
 6f0:	ff3498e3          	bne	s1,s3,6e0 <printint+0x82>
 6f4:	74a2                	ld	s1,40(sp)
}
 6f6:	70e2                	ld	ra,56(sp)
 6f8:	7442                	ld	s0,48(sp)
 6fa:	7902                	ld	s2,32(sp)
 6fc:	69e2                	ld	s3,24(sp)
 6fe:	6121                	addi	sp,sp,64
 700:	8082                	ret
  neg = 0;
 702:	4301                	li	t1,0
 704:	bf9d                	j	67a <printint+0x1c>

0000000000000706 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 706:	715d                	addi	sp,sp,-80
 708:	e486                	sd	ra,72(sp)
 70a:	e0a2                	sd	s0,64(sp)
 70c:	f84a                	sd	s2,48(sp)
 70e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 710:	0005c903          	lbu	s2,0(a1)
 714:	1a090b63          	beqz	s2,8ca <vprintf+0x1c4>
 718:	fc26                	sd	s1,56(sp)
 71a:	f44e                	sd	s3,40(sp)
 71c:	f052                	sd	s4,32(sp)
 71e:	ec56                	sd	s5,24(sp)
 720:	e85a                	sd	s6,16(sp)
 722:	e45e                	sd	s7,8(sp)
 724:	8aaa                	mv	s5,a0
 726:	8bb2                	mv	s7,a2
 728:	00158493          	addi	s1,a1,1
  state = 0;
 72c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 72e:	02500a13          	li	s4,37
 732:	4b55                	li	s6,21
 734:	a839                	j	752 <vprintf+0x4c>
        putc(fd, c);
 736:	85ca                	mv	a1,s2
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	f02080e7          	jalr	-254(ra) # 63c <putc>
 742:	a019                	j	748 <vprintf+0x42>
    } else if(state == '%'){
 744:	01498d63          	beq	s3,s4,75e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 748:	0485                	addi	s1,s1,1
 74a:	fff4c903          	lbu	s2,-1(s1)
 74e:	16090863          	beqz	s2,8be <vprintf+0x1b8>
    if(state == 0){
 752:	fe0999e3          	bnez	s3,744 <vprintf+0x3e>
      if(c == '%'){
 756:	ff4910e3          	bne	s2,s4,736 <vprintf+0x30>
        state = '%';
 75a:	89d2                	mv	s3,s4
 75c:	b7f5                	j	748 <vprintf+0x42>
      if(c == 'd'){
 75e:	13490563          	beq	s2,s4,888 <vprintf+0x182>
 762:	f9d9079b          	addiw	a5,s2,-99
 766:	0ff7f793          	zext.b	a5,a5
 76a:	12fb6863          	bltu	s6,a5,89a <vprintf+0x194>
 76e:	f9d9079b          	addiw	a5,s2,-99
 772:	0ff7f713          	zext.b	a4,a5
 776:	12eb6263          	bltu	s6,a4,89a <vprintf+0x194>
 77a:	00271793          	slli	a5,a4,0x2
 77e:	00000717          	auipc	a4,0x0
 782:	3ba70713          	addi	a4,a4,954 # b38 <malloc+0x17a>
 786:	97ba                	add	a5,a5,a4
 788:	439c                	lw	a5,0(a5)
 78a:	97ba                	add	a5,a5,a4
 78c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 78e:	008b8913          	addi	s2,s7,8
 792:	4685                	li	a3,1
 794:	4629                	li	a2,10
 796:	000ba583          	lw	a1,0(s7)
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	ec2080e7          	jalr	-318(ra) # 65e <printint>
 7a4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	b745                	j	748 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7aa:	008b8913          	addi	s2,s7,8
 7ae:	4681                	li	a3,0
 7b0:	4629                	li	a2,10
 7b2:	000ba583          	lw	a1,0(s7)
 7b6:	8556                	mv	a0,s5
 7b8:	00000097          	auipc	ra,0x0
 7bc:	ea6080e7          	jalr	-346(ra) # 65e <printint>
 7c0:	8bca                	mv	s7,s2
      state = 0;
 7c2:	4981                	li	s3,0
 7c4:	b751                	j	748 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7c6:	008b8913          	addi	s2,s7,8
 7ca:	4681                	li	a3,0
 7cc:	4641                	li	a2,16
 7ce:	000ba583          	lw	a1,0(s7)
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	e8a080e7          	jalr	-374(ra) # 65e <printint>
 7dc:	8bca                	mv	s7,s2
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b7a5                	j	748 <vprintf+0x42>
 7e2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7e4:	008b8793          	addi	a5,s7,8
 7e8:	8c3e                	mv	s8,a5
 7ea:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ee:	03000593          	li	a1,48
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e48080e7          	jalr	-440(ra) # 63c <putc>
  putc(fd, 'x');
 7fc:	07800593          	li	a1,120
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	e3a080e7          	jalr	-454(ra) # 63c <putc>
 80a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80c:	00000b97          	auipc	s7,0x0
 810:	384b8b93          	addi	s7,s7,900 # b90 <digits>
 814:	03c9d793          	srli	a5,s3,0x3c
 818:	97de                	add	a5,a5,s7
 81a:	0007c583          	lbu	a1,0(a5)
 81e:	8556                	mv	a0,s5
 820:	00000097          	auipc	ra,0x0
 824:	e1c080e7          	jalr	-484(ra) # 63c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 828:	0992                	slli	s3,s3,0x4
 82a:	397d                	addiw	s2,s2,-1
 82c:	fe0914e3          	bnez	s2,814 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 830:	8be2                	mv	s7,s8
      state = 0;
 832:	4981                	li	s3,0
 834:	6c02                	ld	s8,0(sp)
 836:	bf09                	j	748 <vprintf+0x42>
        s = va_arg(ap, char*);
 838:	008b8993          	addi	s3,s7,8
 83c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 840:	02090163          	beqz	s2,862 <vprintf+0x15c>
        while(*s != 0){
 844:	00094583          	lbu	a1,0(s2)
 848:	c9a5                	beqz	a1,8b8 <vprintf+0x1b2>
          putc(fd, *s);
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	df0080e7          	jalr	-528(ra) # 63c <putc>
          s++;
 854:	0905                	addi	s2,s2,1
        while(*s != 0){
 856:	00094583          	lbu	a1,0(s2)
 85a:	f9e5                	bnez	a1,84a <vprintf+0x144>
        s = va_arg(ap, char*);
 85c:	8bce                	mv	s7,s3
      state = 0;
 85e:	4981                	li	s3,0
 860:	b5e5                	j	748 <vprintf+0x42>
          s = "(null)";
 862:	00000917          	auipc	s2,0x0
 866:	2ce90913          	addi	s2,s2,718 # b30 <malloc+0x172>
        while(*s != 0){
 86a:	02800593          	li	a1,40
 86e:	bff1                	j	84a <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 870:	008b8913          	addi	s2,s7,8
 874:	000bc583          	lbu	a1,0(s7)
 878:	8556                	mv	a0,s5
 87a:	00000097          	auipc	ra,0x0
 87e:	dc2080e7          	jalr	-574(ra) # 63c <putc>
 882:	8bca                	mv	s7,s2
      state = 0;
 884:	4981                	li	s3,0
 886:	b5c9                	j	748 <vprintf+0x42>
        putc(fd, c);
 888:	02500593          	li	a1,37
 88c:	8556                	mv	a0,s5
 88e:	00000097          	auipc	ra,0x0
 892:	dae080e7          	jalr	-594(ra) # 63c <putc>
      state = 0;
 896:	4981                	li	s3,0
 898:	bd45                	j	748 <vprintf+0x42>
        putc(fd, '%');
 89a:	02500593          	li	a1,37
 89e:	8556                	mv	a0,s5
 8a0:	00000097          	auipc	ra,0x0
 8a4:	d9c080e7          	jalr	-612(ra) # 63c <putc>
        putc(fd, c);
 8a8:	85ca                	mv	a1,s2
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	d90080e7          	jalr	-624(ra) # 63c <putc>
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	bd49                	j	748 <vprintf+0x42>
        s = va_arg(ap, char*);
 8b8:	8bce                	mv	s7,s3
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	b571                	j	748 <vprintf+0x42>
 8be:	74e2                	ld	s1,56(sp)
 8c0:	79a2                	ld	s3,40(sp)
 8c2:	7a02                	ld	s4,32(sp)
 8c4:	6ae2                	ld	s5,24(sp)
 8c6:	6b42                	ld	s6,16(sp)
 8c8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8ca:	60a6                	ld	ra,72(sp)
 8cc:	6406                	ld	s0,64(sp)
 8ce:	7942                	ld	s2,48(sp)
 8d0:	6161                	addi	sp,sp,80
 8d2:	8082                	ret

00000000000008d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d4:	715d                	addi	sp,sp,-80
 8d6:	ec06                	sd	ra,24(sp)
 8d8:	e822                	sd	s0,16(sp)
 8da:	1000                	addi	s0,sp,32
 8dc:	e010                	sd	a2,0(s0)
 8de:	e414                	sd	a3,8(s0)
 8e0:	e818                	sd	a4,16(s0)
 8e2:	ec1c                	sd	a5,24(s0)
 8e4:	03043023          	sd	a6,32(s0)
 8e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ec:	8622                	mv	a2,s0
 8ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f2:	00000097          	auipc	ra,0x0
 8f6:	e14080e7          	jalr	-492(ra) # 706 <vprintf>
}
 8fa:	60e2                	ld	ra,24(sp)
 8fc:	6442                	ld	s0,16(sp)
 8fe:	6161                	addi	sp,sp,80
 900:	8082                	ret

0000000000000902 <printf>:

void
printf(const char *fmt, ...)
{
 902:	711d                	addi	sp,sp,-96
 904:	ec06                	sd	ra,24(sp)
 906:	e822                	sd	s0,16(sp)
 908:	1000                	addi	s0,sp,32
 90a:	e40c                	sd	a1,8(s0)
 90c:	e810                	sd	a2,16(s0)
 90e:	ec14                	sd	a3,24(s0)
 910:	f018                	sd	a4,32(s0)
 912:	f41c                	sd	a5,40(s0)
 914:	03043823          	sd	a6,48(s0)
 918:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 91c:	00840613          	addi	a2,s0,8
 920:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 924:	85aa                	mv	a1,a0
 926:	4505                	li	a0,1
 928:	00000097          	auipc	ra,0x0
 92c:	dde080e7          	jalr	-546(ra) # 706 <vprintf>
}
 930:	60e2                	ld	ra,24(sp)
 932:	6442                	ld	s0,16(sp)
 934:	6125                	addi	sp,sp,96
 936:	8082                	ret

0000000000000938 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 938:	1141                	addi	sp,sp,-16
 93a:	e406                	sd	ra,8(sp)
 93c:	e022                	sd	s0,0(sp)
 93e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 940:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 944:	00000797          	auipc	a5,0x0
 948:	6bc7b783          	ld	a5,1724(a5) # 1000 <freep>
 94c:	a039                	j	95a <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94e:	6398                	ld	a4,0(a5)
 950:	00e7e463          	bltu	a5,a4,958 <free+0x20>
 954:	00e6ea63          	bltu	a3,a4,968 <free+0x30>
{
 958:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95a:	fed7fae3          	bgeu	a5,a3,94e <free+0x16>
 95e:	6398                	ld	a4,0(a5)
 960:	00e6e463          	bltu	a3,a4,968 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 964:	fee7eae3          	bltu	a5,a4,958 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 968:	ff852583          	lw	a1,-8(a0)
 96c:	6390                	ld	a2,0(a5)
 96e:	02059813          	slli	a6,a1,0x20
 972:	01c85713          	srli	a4,a6,0x1c
 976:	9736                	add	a4,a4,a3
 978:	02e60563          	beq	a2,a4,9a2 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 97c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 980:	4790                	lw	a2,8(a5)
 982:	02061593          	slli	a1,a2,0x20
 986:	01c5d713          	srli	a4,a1,0x1c
 98a:	973e                	add	a4,a4,a5
 98c:	02e68263          	beq	a3,a4,9b0 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 990:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 992:	00000717          	auipc	a4,0x0
 996:	66f73723          	sd	a5,1646(a4) # 1000 <freep>
}
 99a:	60a2                	ld	ra,8(sp)
 99c:	6402                	ld	s0,0(sp)
 99e:	0141                	addi	sp,sp,16
 9a0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 9a2:	4618                	lw	a4,8(a2)
 9a4:	9f2d                	addw	a4,a4,a1
 9a6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9aa:	6398                	ld	a4,0(a5)
 9ac:	6310                	ld	a2,0(a4)
 9ae:	b7f9                	j	97c <free+0x44>
    p->s.size += bp->s.size;
 9b0:	ff852703          	lw	a4,-8(a0)
 9b4:	9f31                	addw	a4,a4,a2
 9b6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9b8:	ff053683          	ld	a3,-16(a0)
 9bc:	bfd1                	j	990 <free+0x58>

00000000000009be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9be:	7139                	addi	sp,sp,-64
 9c0:	fc06                	sd	ra,56(sp)
 9c2:	f822                	sd	s0,48(sp)
 9c4:	f04a                	sd	s2,32(sp)
 9c6:	ec4e                	sd	s3,24(sp)
 9c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ca:	02051993          	slli	s3,a0,0x20
 9ce:	0209d993          	srli	s3,s3,0x20
 9d2:	09bd                	addi	s3,s3,15
 9d4:	0049d993          	srli	s3,s3,0x4
 9d8:	2985                	addiw	s3,s3,1
 9da:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9dc:	00000517          	auipc	a0,0x0
 9e0:	62453503          	ld	a0,1572(a0) # 1000 <freep>
 9e4:	c905                	beqz	a0,a14 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e8:	4798                	lw	a4,8(a5)
 9ea:	09377a63          	bgeu	a4,s3,a7e <malloc+0xc0>
 9ee:	f426                	sd	s1,40(sp)
 9f0:	e852                	sd	s4,16(sp)
 9f2:	e456                	sd	s5,8(sp)
 9f4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9f6:	8a4e                	mv	s4,s3
 9f8:	6705                	lui	a4,0x1
 9fa:	00e9f363          	bgeu	s3,a4,a00 <malloc+0x42>
 9fe:	6a05                	lui	s4,0x1
 a00:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a04:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a08:	00000497          	auipc	s1,0x0
 a0c:	5f848493          	addi	s1,s1,1528 # 1000 <freep>
  if(p == (char*)-1)
 a10:	5afd                	li	s5,-1
 a12:	a089                	j	a54 <malloc+0x96>
 a14:	f426                	sd	s1,40(sp)
 a16:	e852                	sd	s4,16(sp)
 a18:	e456                	sd	s5,8(sp)
 a1a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a1c:	00000797          	auipc	a5,0x0
 a20:	60478793          	addi	a5,a5,1540 # 1020 <base>
 a24:	00000717          	auipc	a4,0x0
 a28:	5cf73e23          	sd	a5,1500(a4) # 1000 <freep>
 a2c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a2e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a32:	b7d1                	j	9f6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a34:	6398                	ld	a4,0(a5)
 a36:	e118                	sd	a4,0(a0)
 a38:	a8b9                	j	a96 <malloc+0xd8>
  hp->s.size = nu;
 a3a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a3e:	0541                	addi	a0,a0,16
 a40:	00000097          	auipc	ra,0x0
 a44:	ef8080e7          	jalr	-264(ra) # 938 <free>
  return freep;
 a48:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a4a:	c135                	beqz	a0,aae <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a4e:	4798                	lw	a4,8(a5)
 a50:	03277363          	bgeu	a4,s2,a76 <malloc+0xb8>
    if(p == freep)
 a54:	6098                	ld	a4,0(s1)
 a56:	853e                	mv	a0,a5
 a58:	fef71ae3          	bne	a4,a5,a4c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a5c:	8552                	mv	a0,s4
 a5e:	00000097          	auipc	ra,0x0
 a62:	b9e080e7          	jalr	-1122(ra) # 5fc <sbrk>
  if(p == (char*)-1)
 a66:	fd551ae3          	bne	a0,s5,a3a <malloc+0x7c>
        return 0;
 a6a:	4501                	li	a0,0
 a6c:	74a2                	ld	s1,40(sp)
 a6e:	6a42                	ld	s4,16(sp)
 a70:	6aa2                	ld	s5,8(sp)
 a72:	6b02                	ld	s6,0(sp)
 a74:	a03d                	j	aa2 <malloc+0xe4>
 a76:	74a2                	ld	s1,40(sp)
 a78:	6a42                	ld	s4,16(sp)
 a7a:	6aa2                	ld	s5,8(sp)
 a7c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a7e:	fae90be3          	beq	s2,a4,a34 <malloc+0x76>
        p->s.size -= nunits;
 a82:	4137073b          	subw	a4,a4,s3
 a86:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a88:	02071693          	slli	a3,a4,0x20
 a8c:	01c6d713          	srli	a4,a3,0x1c
 a90:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a92:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a96:	00000717          	auipc	a4,0x0
 a9a:	56a73523          	sd	a0,1386(a4) # 1000 <freep>
      return (void*)(p + 1);
 a9e:	01078513          	addi	a0,a5,16
  }
}
 aa2:	70e2                	ld	ra,56(sp)
 aa4:	7442                	ld	s0,48(sp)
 aa6:	7902                	ld	s2,32(sp)
 aa8:	69e2                	ld	s3,24(sp)
 aaa:	6121                	addi	sp,sp,64
 aac:	8082                	ret
 aae:	74a2                	ld	s1,40(sp)
 ab0:	6a42                	ld	s4,16(sp)
 ab2:	6aa2                	ld	s5,8(sp)
 ab4:	6b02                	ld	s6,0(sp)
 ab6:	b7f5                	j	aa2 <malloc+0xe4>
