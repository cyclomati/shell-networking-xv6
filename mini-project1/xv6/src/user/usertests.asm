
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	f04a                	sd	s2,32(sp)
       a:	ec4e                	sd	s3,24(sp)
       c:	0080                	addi	s0,sp,64
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
       e:	4785                	li	a5,1
      10:	07fe                	slli	a5,a5,0x1f
      12:	fcf43023          	sd	a5,-64(s0)
      16:	57fd                	li	a5,-1
      18:	fcf43423          	sd	a5,-56(s0)

  for(int ai = 0; ai < 2; ai++){
      1c:	fc040493          	addi	s1,s0,-64
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      20:	20100993          	li	s3,513
    uint64 addr = addrs[ai];
      24:	0004b903          	ld	s2,0(s1)
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      28:	85ce                	mv	a1,s3
      2a:	854a                	mv	a0,s2
      2c:	00006097          	auipc	ra,0x6
      30:	e96080e7          	jalr	-362(ra) # 5ec2 <open>
    if(fd >= 0){
      34:	00055e63          	bgez	a0,50 <copyinstr1+0x50>
  for(int ai = 0; ai < 2; ai++){
      38:	04a1                	addi	s1,s1,8
      3a:	fd040793          	addi	a5,s0,-48
      3e:	fef493e3          	bne	s1,a5,24 <copyinstr1+0x24>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      42:	70e2                	ld	ra,56(sp)
      44:	7442                	ld	s0,48(sp)
      46:	74a2                	ld	s1,40(sp)
      48:	7902                	ld	s2,32(sp)
      4a:	69e2                	ld	s3,24(sp)
      4c:	6121                	addi	sp,sp,64
      4e:	8082                	ret
      printf("open(%p) returned %d, not -1\n", addr, fd);
      50:	862a                	mv	a2,a0
      52:	85ca                	mv	a1,s2
      54:	00006517          	auipc	a0,0x6
      58:	37c50513          	addi	a0,a0,892 # 63d0 <malloc+0x104>
      5c:	00006097          	auipc	ra,0x6
      60:	1b4080e7          	jalr	436(ra) # 6210 <printf>
      exit(1);
      64:	4505                	li	a0,1
      66:	00006097          	auipc	ra,0x6
      6a:	e1c080e7          	jalr	-484(ra) # 5e82 <exit>

000000000000006e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      6e:	0000a797          	auipc	a5,0xa
      72:	4fa78793          	addi	a5,a5,1274 # a568 <uninit>
      76:	0000d697          	auipc	a3,0xd
      7a:	c0268693          	addi	a3,a3,-1022 # cc78 <buf>
    if(uninit[i] != '\0'){
      7e:	0007c703          	lbu	a4,0(a5)
      82:	e709                	bnez	a4,8c <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      84:	0785                	addi	a5,a5,1
      86:	fed79ce3          	bne	a5,a3,7e <bsstest+0x10>
      8a:	8082                	ret
{
      8c:	1141                	addi	sp,sp,-16
      8e:	e406                	sd	ra,8(sp)
      90:	e022                	sd	s0,0(sp)
      92:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      94:	85aa                	mv	a1,a0
      96:	00006517          	auipc	a0,0x6
      9a:	35a50513          	addi	a0,a0,858 # 63f0 <malloc+0x124>
      9e:	00006097          	auipc	ra,0x6
      a2:	172080e7          	jalr	370(ra) # 6210 <printf>
      exit(1);
      a6:	4505                	li	a0,1
      a8:	00006097          	auipc	ra,0x6
      ac:	dda080e7          	jalr	-550(ra) # 5e82 <exit>

00000000000000b0 <opentest>:
{
      b0:	1101                	addi	sp,sp,-32
      b2:	ec06                	sd	ra,24(sp)
      b4:	e822                	sd	s0,16(sp)
      b6:	e426                	sd	s1,8(sp)
      b8:	1000                	addi	s0,sp,32
      ba:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      bc:	4581                	li	a1,0
      be:	00006517          	auipc	a0,0x6
      c2:	34a50513          	addi	a0,a0,842 # 6408 <malloc+0x13c>
      c6:	00006097          	auipc	ra,0x6
      ca:	dfc080e7          	jalr	-516(ra) # 5ec2 <open>
  if(fd < 0){
      ce:	02054663          	bltz	a0,fa <opentest+0x4a>
  close(fd);
      d2:	00006097          	auipc	ra,0x6
      d6:	dd8080e7          	jalr	-552(ra) # 5eaa <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00006517          	auipc	a0,0x6
      e0:	34c50513          	addi	a0,a0,844 # 6428 <malloc+0x15c>
      e4:	00006097          	auipc	ra,0x6
      e8:	dde080e7          	jalr	-546(ra) # 5ec2 <open>
  if(fd >= 0){
      ec:	02055563          	bgez	a0,116 <opentest+0x66>
}
      f0:	60e2                	ld	ra,24(sp)
      f2:	6442                	ld	s0,16(sp)
      f4:	64a2                	ld	s1,8(sp)
      f6:	6105                	addi	sp,sp,32
      f8:	8082                	ret
    printf("%s: open echo failed!\n", s);
      fa:	85a6                	mv	a1,s1
      fc:	00006517          	auipc	a0,0x6
     100:	31450513          	addi	a0,a0,788 # 6410 <malloc+0x144>
     104:	00006097          	auipc	ra,0x6
     108:	10c080e7          	jalr	268(ra) # 6210 <printf>
    exit(1);
     10c:	4505                	li	a0,1
     10e:	00006097          	auipc	ra,0x6
     112:	d74080e7          	jalr	-652(ra) # 5e82 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     116:	85a6                	mv	a1,s1
     118:	00006517          	auipc	a0,0x6
     11c:	32050513          	addi	a0,a0,800 # 6438 <malloc+0x16c>
     120:	00006097          	auipc	ra,0x6
     124:	0f0080e7          	jalr	240(ra) # 6210 <printf>
    exit(1);
     128:	4505                	li	a0,1
     12a:	00006097          	auipc	ra,0x6
     12e:	d58080e7          	jalr	-680(ra) # 5e82 <exit>

0000000000000132 <truncate2>:
{
     132:	7179                	addi	sp,sp,-48
     134:	f406                	sd	ra,40(sp)
     136:	f022                	sd	s0,32(sp)
     138:	ec26                	sd	s1,24(sp)
     13a:	e84a                	sd	s2,16(sp)
     13c:	e44e                	sd	s3,8(sp)
     13e:	1800                	addi	s0,sp,48
     140:	89aa                	mv	s3,a0
  unlink("truncfile");
     142:	00006517          	auipc	a0,0x6
     146:	31e50513          	addi	a0,a0,798 # 6460 <malloc+0x194>
     14a:	00006097          	auipc	ra,0x6
     14e:	d88080e7          	jalr	-632(ra) # 5ed2 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     152:	60100593          	li	a1,1537
     156:	00006517          	auipc	a0,0x6
     15a:	30a50513          	addi	a0,a0,778 # 6460 <malloc+0x194>
     15e:	00006097          	auipc	ra,0x6
     162:	d64080e7          	jalr	-668(ra) # 5ec2 <open>
     166:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     168:	4611                	li	a2,4
     16a:	00006597          	auipc	a1,0x6
     16e:	30658593          	addi	a1,a1,774 # 6470 <malloc+0x1a4>
     172:	00006097          	auipc	ra,0x6
     176:	d30080e7          	jalr	-720(ra) # 5ea2 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     17a:	40100593          	li	a1,1025
     17e:	00006517          	auipc	a0,0x6
     182:	2e250513          	addi	a0,a0,738 # 6460 <malloc+0x194>
     186:	00006097          	auipc	ra,0x6
     18a:	d3c080e7          	jalr	-708(ra) # 5ec2 <open>
     18e:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     190:	4605                	li	a2,1
     192:	00006597          	auipc	a1,0x6
     196:	2e658593          	addi	a1,a1,742 # 6478 <malloc+0x1ac>
     19a:	8526                	mv	a0,s1
     19c:	00006097          	auipc	ra,0x6
     1a0:	d06080e7          	jalr	-762(ra) # 5ea2 <write>
  if(n != -1){
     1a4:	57fd                	li	a5,-1
     1a6:	02f51b63          	bne	a0,a5,1dc <truncate2+0xaa>
  unlink("truncfile");
     1aa:	00006517          	auipc	a0,0x6
     1ae:	2b650513          	addi	a0,a0,694 # 6460 <malloc+0x194>
     1b2:	00006097          	auipc	ra,0x6
     1b6:	d20080e7          	jalr	-736(ra) # 5ed2 <unlink>
  close(fd1);
     1ba:	8526                	mv	a0,s1
     1bc:	00006097          	auipc	ra,0x6
     1c0:	cee080e7          	jalr	-786(ra) # 5eaa <close>
  close(fd2);
     1c4:	854a                	mv	a0,s2
     1c6:	00006097          	auipc	ra,0x6
     1ca:	ce4080e7          	jalr	-796(ra) # 5eaa <close>
}
     1ce:	70a2                	ld	ra,40(sp)
     1d0:	7402                	ld	s0,32(sp)
     1d2:	64e2                	ld	s1,24(sp)
     1d4:	6942                	ld	s2,16(sp)
     1d6:	69a2                	ld	s3,8(sp)
     1d8:	6145                	addi	sp,sp,48
     1da:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1dc:	862a                	mv	a2,a0
     1de:	85ce                	mv	a1,s3
     1e0:	00006517          	auipc	a0,0x6
     1e4:	2a050513          	addi	a0,a0,672 # 6480 <malloc+0x1b4>
     1e8:	00006097          	auipc	ra,0x6
     1ec:	028080e7          	jalr	40(ra) # 6210 <printf>
    exit(1);
     1f0:	4505                	li	a0,1
     1f2:	00006097          	auipc	ra,0x6
     1f6:	c90080e7          	jalr	-880(ra) # 5e82 <exit>

00000000000001fa <createtest>:
{
     1fa:	7139                	addi	sp,sp,-64
     1fc:	fc06                	sd	ra,56(sp)
     1fe:	f822                	sd	s0,48(sp)
     200:	f426                	sd	s1,40(sp)
     202:	f04a                	sd	s2,32(sp)
     204:	ec4e                	sd	s3,24(sp)
     206:	e852                	sd	s4,16(sp)
     208:	0080                	addi	s0,sp,64
  name[0] = 'a';
     20a:	06100793          	li	a5,97
     20e:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     212:	fc040523          	sb	zero,-54(s0)
     216:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
     21a:	fc840a13          	addi	s4,s0,-56
     21e:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
     222:	06400913          	li	s2,100
    name[1] = '0' + i;
     226:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
     22a:	85ce                	mv	a1,s3
     22c:	8552                	mv	a0,s4
     22e:	00006097          	auipc	ra,0x6
     232:	c94080e7          	jalr	-876(ra) # 5ec2 <open>
    close(fd);
     236:	00006097          	auipc	ra,0x6
     23a:	c74080e7          	jalr	-908(ra) # 5eaa <close>
  for(i = 0; i < N; i++){
     23e:	2485                	addiw	s1,s1,1
     240:	0ff4f493          	zext.b	s1,s1
     244:	ff2491e3          	bne	s1,s2,226 <createtest+0x2c>
  name[0] = 'a';
     248:	06100793          	li	a5,97
     24c:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     250:	fc040523          	sb	zero,-54(s0)
     254:	03000493          	li	s1,48
    unlink(name);
     258:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
     25c:	06400913          	li	s2,100
    name[1] = '0' + i;
     260:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     264:	854e                	mv	a0,s3
     266:	00006097          	auipc	ra,0x6
     26a:	c6c080e7          	jalr	-916(ra) # 5ed2 <unlink>
  for(i = 0; i < N; i++){
     26e:	2485                	addiw	s1,s1,1
     270:	0ff4f493          	zext.b	s1,s1
     274:	ff2496e3          	bne	s1,s2,260 <createtest+0x66>
}
     278:	70e2                	ld	ra,56(sp)
     27a:	7442                	ld	s0,48(sp)
     27c:	74a2                	ld	s1,40(sp)
     27e:	7902                	ld	s2,32(sp)
     280:	69e2                	ld	s3,24(sp)
     282:	6a42                	ld	s4,16(sp)
     284:	6121                	addi	sp,sp,64
     286:	8082                	ret

0000000000000288 <bigwrite>:
{
     288:	711d                	addi	sp,sp,-96
     28a:	ec86                	sd	ra,88(sp)
     28c:	e8a2                	sd	s0,80(sp)
     28e:	e4a6                	sd	s1,72(sp)
     290:	e0ca                	sd	s2,64(sp)
     292:	fc4e                	sd	s3,56(sp)
     294:	f852                	sd	s4,48(sp)
     296:	f456                	sd	s5,40(sp)
     298:	f05a                	sd	s6,32(sp)
     29a:	ec5e                	sd	s7,24(sp)
     29c:	e862                	sd	s8,16(sp)
     29e:	e466                	sd	s9,8(sp)
     2a0:	1080                	addi	s0,sp,96
     2a2:	8caa                	mv	s9,a0
  unlink("bigwrite");
     2a4:	00006517          	auipc	a0,0x6
     2a8:	20450513          	addi	a0,a0,516 # 64a8 <malloc+0x1dc>
     2ac:	00006097          	auipc	ra,0x6
     2b0:	c26080e7          	jalr	-986(ra) # 5ed2 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2b8:	20200b93          	li	s7,514
     2bc:	00006a17          	auipc	s4,0x6
     2c0:	1eca0a13          	addi	s4,s4,492 # 64a8 <malloc+0x1dc>
     2c4:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     2c6:	0000d997          	auipc	s3,0xd
     2ca:	9b298993          	addi	s3,s3,-1614 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2ce:	6a8d                	lui	s5,0x3
     2d0:	1c9a8a93          	addi	s5,s5,457 # 31c9 <fourteen+0x2d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2d4:	85de                	mv	a1,s7
     2d6:	8552                	mv	a0,s4
     2d8:	00006097          	auipc	ra,0x6
     2dc:	bea080e7          	jalr	-1046(ra) # 5ec2 <open>
     2e0:	892a                	mv	s2,a0
    if(fd < 0){
     2e2:	04054a63          	bltz	a0,336 <bigwrite+0xae>
     2e6:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     2e8:	8626                	mv	a2,s1
     2ea:	85ce                	mv	a1,s3
     2ec:	854a                	mv	a0,s2
     2ee:	00006097          	auipc	ra,0x6
     2f2:	bb4080e7          	jalr	-1100(ra) # 5ea2 <write>
      if(cc != sz){
     2f6:	04951e63          	bne	a0,s1,352 <bigwrite+0xca>
    for(i = 0; i < 2; i++){
     2fa:	3c7d                	addiw	s8,s8,-1
     2fc:	fe0c16e3          	bnez	s8,2e8 <bigwrite+0x60>
    close(fd);
     300:	854a                	mv	a0,s2
     302:	00006097          	auipc	ra,0x6
     306:	ba8080e7          	jalr	-1112(ra) # 5eaa <close>
    unlink("bigwrite");
     30a:	8552                	mv	a0,s4
     30c:	00006097          	auipc	ra,0x6
     310:	bc6080e7          	jalr	-1082(ra) # 5ed2 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     314:	1d74849b          	addiw	s1,s1,471
     318:	fb549ee3          	bne	s1,s5,2d4 <bigwrite+0x4c>
}
     31c:	60e6                	ld	ra,88(sp)
     31e:	6446                	ld	s0,80(sp)
     320:	64a6                	ld	s1,72(sp)
     322:	6906                	ld	s2,64(sp)
     324:	79e2                	ld	s3,56(sp)
     326:	7a42                	ld	s4,48(sp)
     328:	7aa2                	ld	s5,40(sp)
     32a:	7b02                	ld	s6,32(sp)
     32c:	6be2                	ld	s7,24(sp)
     32e:	6c42                	ld	s8,16(sp)
     330:	6ca2                	ld	s9,8(sp)
     332:	6125                	addi	sp,sp,96
     334:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     336:	85e6                	mv	a1,s9
     338:	00006517          	auipc	a0,0x6
     33c:	18050513          	addi	a0,a0,384 # 64b8 <malloc+0x1ec>
     340:	00006097          	auipc	ra,0x6
     344:	ed0080e7          	jalr	-304(ra) # 6210 <printf>
      exit(1);
     348:	4505                	li	a0,1
     34a:	00006097          	auipc	ra,0x6
     34e:	b38080e7          	jalr	-1224(ra) # 5e82 <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     352:	86aa                	mv	a3,a0
     354:	8626                	mv	a2,s1
     356:	85e6                	mv	a1,s9
     358:	00006517          	auipc	a0,0x6
     35c:	18050513          	addi	a0,a0,384 # 64d8 <malloc+0x20c>
     360:	00006097          	auipc	ra,0x6
     364:	eb0080e7          	jalr	-336(ra) # 6210 <printf>
        exit(1);
     368:	4505                	li	a0,1
     36a:	00006097          	auipc	ra,0x6
     36e:	b18080e7          	jalr	-1256(ra) # 5e82 <exit>

0000000000000372 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     372:	7139                	addi	sp,sp,-64
     374:	fc06                	sd	ra,56(sp)
     376:	f822                	sd	s0,48(sp)
     378:	f426                	sd	s1,40(sp)
     37a:	f04a                	sd	s2,32(sp)
     37c:	ec4e                	sd	s3,24(sp)
     37e:	e852                	sd	s4,16(sp)
     380:	e456                	sd	s5,8(sp)
     382:	e05a                	sd	s6,0(sp)
     384:	0080                	addi	s0,sp,64
  int assumed_free = 600;
  
  unlink("junk");
     386:	00006517          	auipc	a0,0x6
     38a:	16a50513          	addi	a0,a0,362 # 64f0 <malloc+0x224>
     38e:	00006097          	auipc	ra,0x6
     392:	b44080e7          	jalr	-1212(ra) # 5ed2 <unlink>
     396:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     39a:	20100a93          	li	s5,513
     39e:	00006997          	auipc	s3,0x6
     3a2:	15298993          	addi	s3,s3,338 # 64f0 <malloc+0x224>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     3a6:	4b05                	li	s6,1
     3a8:	5a7d                	li	s4,-1
     3aa:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     3ae:	85d6                	mv	a1,s5
     3b0:	854e                	mv	a0,s3
     3b2:	00006097          	auipc	ra,0x6
     3b6:	b10080e7          	jalr	-1264(ra) # 5ec2 <open>
     3ba:	84aa                	mv	s1,a0
    if(fd < 0){
     3bc:	06054b63          	bltz	a0,432 <badwrite+0xc0>
    write(fd, (char*)0xffffffffffL, 1);
     3c0:	865a                	mv	a2,s6
     3c2:	85d2                	mv	a1,s4
     3c4:	00006097          	auipc	ra,0x6
     3c8:	ade080e7          	jalr	-1314(ra) # 5ea2 <write>
    close(fd);
     3cc:	8526                	mv	a0,s1
     3ce:	00006097          	auipc	ra,0x6
     3d2:	adc080e7          	jalr	-1316(ra) # 5eaa <close>
    unlink("junk");
     3d6:	854e                	mv	a0,s3
     3d8:	00006097          	auipc	ra,0x6
     3dc:	afa080e7          	jalr	-1286(ra) # 5ed2 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3e0:	397d                	addiw	s2,s2,-1
     3e2:	fc0916e3          	bnez	s2,3ae <badwrite+0x3c>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3e6:	20100593          	li	a1,513
     3ea:	00006517          	auipc	a0,0x6
     3ee:	10650513          	addi	a0,a0,262 # 64f0 <malloc+0x224>
     3f2:	00006097          	auipc	ra,0x6
     3f6:	ad0080e7          	jalr	-1328(ra) # 5ec2 <open>
     3fa:	84aa                	mv	s1,a0
  if(fd < 0){
     3fc:	04054863          	bltz	a0,44c <badwrite+0xda>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     400:	4605                	li	a2,1
     402:	00006597          	auipc	a1,0x6
     406:	07658593          	addi	a1,a1,118 # 6478 <malloc+0x1ac>
     40a:	00006097          	auipc	ra,0x6
     40e:	a98080e7          	jalr	-1384(ra) # 5ea2 <write>
     412:	4785                	li	a5,1
     414:	04f50963          	beq	a0,a5,466 <badwrite+0xf4>
    printf("write failed\n");
     418:	00006517          	auipc	a0,0x6
     41c:	0f850513          	addi	a0,a0,248 # 6510 <malloc+0x244>
     420:	00006097          	auipc	ra,0x6
     424:	df0080e7          	jalr	-528(ra) # 6210 <printf>
    exit(1);
     428:	4505                	li	a0,1
     42a:	00006097          	auipc	ra,0x6
     42e:	a58080e7          	jalr	-1448(ra) # 5e82 <exit>
      printf("open junk failed\n");
     432:	00006517          	auipc	a0,0x6
     436:	0c650513          	addi	a0,a0,198 # 64f8 <malloc+0x22c>
     43a:	00006097          	auipc	ra,0x6
     43e:	dd6080e7          	jalr	-554(ra) # 6210 <printf>
      exit(1);
     442:	4505                	li	a0,1
     444:	00006097          	auipc	ra,0x6
     448:	a3e080e7          	jalr	-1474(ra) # 5e82 <exit>
    printf("open junk failed\n");
     44c:	00006517          	auipc	a0,0x6
     450:	0ac50513          	addi	a0,a0,172 # 64f8 <malloc+0x22c>
     454:	00006097          	auipc	ra,0x6
     458:	dbc080e7          	jalr	-580(ra) # 6210 <printf>
    exit(1);
     45c:	4505                	li	a0,1
     45e:	00006097          	auipc	ra,0x6
     462:	a24080e7          	jalr	-1500(ra) # 5e82 <exit>
  }
  close(fd);
     466:	8526                	mv	a0,s1
     468:	00006097          	auipc	ra,0x6
     46c:	a42080e7          	jalr	-1470(ra) # 5eaa <close>
  unlink("junk");
     470:	00006517          	auipc	a0,0x6
     474:	08050513          	addi	a0,a0,128 # 64f0 <malloc+0x224>
     478:	00006097          	auipc	ra,0x6
     47c:	a5a080e7          	jalr	-1446(ra) # 5ed2 <unlink>

  exit(0);
     480:	4501                	li	a0,0
     482:	00006097          	auipc	ra,0x6
     486:	a00080e7          	jalr	-1536(ra) # 5e82 <exit>

000000000000048a <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     48a:	711d                	addi	sp,sp,-96
     48c:	ec86                	sd	ra,88(sp)
     48e:	e8a2                	sd	s0,80(sp)
     490:	e4a6                	sd	s1,72(sp)
     492:	e0ca                	sd	s2,64(sp)
     494:	fc4e                	sd	s3,56(sp)
     496:	f852                	sd	s4,48(sp)
     498:	f456                	sd	s5,40(sp)
     49a:	1080                	addi	s0,sp,96
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     49c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     49e:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     4a2:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4a6:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
     4aa:	40000a93          	li	s5,1024
    name[0] = 'z';
     4ae:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     4b2:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     4b6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ba:	01b7571b          	srliw	a4,a4,0x1b
     4be:	009707bb          	addw	a5,a4,s1
     4c2:	4057d69b          	sraiw	a3,a5,0x5
     4c6:	0306869b          	addiw	a3,a3,48
     4ca:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     4ce:	8bfd                	andi	a5,a5,31
     4d0:	9f99                	subw	a5,a5,a4
     4d2:	0307879b          	addiw	a5,a5,48
     4d6:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     4da:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     4de:	854a                	mv	a0,s2
     4e0:	00006097          	auipc	ra,0x6
     4e4:	9f2080e7          	jalr	-1550(ra) # 5ed2 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4e8:	85d2                	mv	a1,s4
     4ea:	854a                	mv	a0,s2
     4ec:	00006097          	auipc	ra,0x6
     4f0:	9d6080e7          	jalr	-1578(ra) # 5ec2 <open>
    if(fd < 0){
     4f4:	00054963          	bltz	a0,506 <outofinodes+0x7c>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4f8:	00006097          	auipc	ra,0x6
     4fc:	9b2080e7          	jalr	-1614(ra) # 5eaa <close>
  for(int i = 0; i < nzz; i++){
     500:	2485                	addiw	s1,s1,1
     502:	fb5496e3          	bne	s1,s5,4ae <outofinodes+0x24>
     506:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     508:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     50c:	fa040a13          	addi	s4,s0,-96
  for(int i = 0; i < nzz; i++){
     510:	40000993          	li	s3,1024
    name[0] = 'z';
     514:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     518:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     51c:	41f4d71b          	sraiw	a4,s1,0x1f
     520:	01b7571b          	srliw	a4,a4,0x1b
     524:	009707bb          	addw	a5,a4,s1
     528:	4057d69b          	sraiw	a3,a5,0x5
     52c:	0306869b          	addiw	a3,a3,48
     530:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     534:	8bfd                	andi	a5,a5,31
     536:	9f99                	subw	a5,a5,a4
     538:	0307879b          	addiw	a5,a5,48
     53c:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     540:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     544:	8552                	mv	a0,s4
     546:	00006097          	auipc	ra,0x6
     54a:	98c080e7          	jalr	-1652(ra) # 5ed2 <unlink>
  for(int i = 0; i < nzz; i++){
     54e:	2485                	addiw	s1,s1,1
     550:	fd3492e3          	bne	s1,s3,514 <outofinodes+0x8a>
  }
}
     554:	60e6                	ld	ra,88(sp)
     556:	6446                	ld	s0,80(sp)
     558:	64a6                	ld	s1,72(sp)
     55a:	6906                	ld	s2,64(sp)
     55c:	79e2                	ld	s3,56(sp)
     55e:	7a42                	ld	s4,48(sp)
     560:	7aa2                	ld	s5,40(sp)
     562:	6125                	addi	sp,sp,96
     564:	8082                	ret

0000000000000566 <copyin>:
{
     566:	7159                	addi	sp,sp,-112
     568:	f486                	sd	ra,104(sp)
     56a:	f0a2                	sd	s0,96(sp)
     56c:	eca6                	sd	s1,88(sp)
     56e:	e8ca                	sd	s2,80(sp)
     570:	e4ce                	sd	s3,72(sp)
     572:	e0d2                	sd	s4,64(sp)
     574:	fc56                	sd	s5,56(sp)
     576:	f85a                	sd	s6,48(sp)
     578:	f45e                	sd	s7,40(sp)
     57a:	f062                	sd	s8,32(sp)
     57c:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     57e:	4785                	li	a5,1
     580:	07fe                	slli	a5,a5,0x1f
     582:	faf43023          	sd	a5,-96(s0)
     586:	57fd                	li	a5,-1
     588:	faf43423          	sd	a5,-88(s0)
  for(int ai = 0; ai < 2; ai++){
     58c:	fa040913          	addi	s2,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     590:	20100b93          	li	s7,513
     594:	00006a97          	auipc	s5,0x6
     598:	f8ca8a93          	addi	s5,s5,-116 # 6520 <malloc+0x254>
    int n = write(fd, (void*)addr, 8192);
     59c:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
     59e:	4b05                	li	s6,1
    if(pipe(fds) < 0){
     5a0:	f9840c13          	addi	s8,s0,-104
    uint64 addr = addrs[ai];
     5a4:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     5a8:	85de                	mv	a1,s7
     5aa:	8556                	mv	a0,s5
     5ac:	00006097          	auipc	ra,0x6
     5b0:	916080e7          	jalr	-1770(ra) # 5ec2 <open>
     5b4:	84aa                	mv	s1,a0
    if(fd < 0){
     5b6:	08054b63          	bltz	a0,64c <copyin+0xe6>
    int n = write(fd, (void*)addr, 8192);
     5ba:	8652                	mv	a2,s4
     5bc:	85ce                	mv	a1,s3
     5be:	00006097          	auipc	ra,0x6
     5c2:	8e4080e7          	jalr	-1820(ra) # 5ea2 <write>
    if(n >= 0){
     5c6:	0a055063          	bgez	a0,666 <copyin+0x100>
    close(fd);
     5ca:	8526                	mv	a0,s1
     5cc:	00006097          	auipc	ra,0x6
     5d0:	8de080e7          	jalr	-1826(ra) # 5eaa <close>
    unlink("copyin1");
     5d4:	8556                	mv	a0,s5
     5d6:	00006097          	auipc	ra,0x6
     5da:	8fc080e7          	jalr	-1796(ra) # 5ed2 <unlink>
    n = write(1, (char*)addr, 8192);
     5de:	8652                	mv	a2,s4
     5e0:	85ce                	mv	a1,s3
     5e2:	855a                	mv	a0,s6
     5e4:	00006097          	auipc	ra,0x6
     5e8:	8be080e7          	jalr	-1858(ra) # 5ea2 <write>
    if(n > 0){
     5ec:	08a04c63          	bgtz	a0,684 <copyin+0x11e>
    if(pipe(fds) < 0){
     5f0:	8562                	mv	a0,s8
     5f2:	00006097          	auipc	ra,0x6
     5f6:	8a0080e7          	jalr	-1888(ra) # 5e92 <pipe>
     5fa:	0a054463          	bltz	a0,6a2 <copyin+0x13c>
    n = write(fds[1], (char*)addr, 8192);
     5fe:	8652                	mv	a2,s4
     600:	85ce                	mv	a1,s3
     602:	f9c42503          	lw	a0,-100(s0)
     606:	00006097          	auipc	ra,0x6
     60a:	89c080e7          	jalr	-1892(ra) # 5ea2 <write>
    if(n > 0){
     60e:	0aa04763          	bgtz	a0,6bc <copyin+0x156>
    close(fds[0]);
     612:	f9842503          	lw	a0,-104(s0)
     616:	00006097          	auipc	ra,0x6
     61a:	894080e7          	jalr	-1900(ra) # 5eaa <close>
    close(fds[1]);
     61e:	f9c42503          	lw	a0,-100(s0)
     622:	00006097          	auipc	ra,0x6
     626:	888080e7          	jalr	-1912(ra) # 5eaa <close>
  for(int ai = 0; ai < 2; ai++){
     62a:	0921                	addi	s2,s2,8
     62c:	fb040793          	addi	a5,s0,-80
     630:	f6f91ae3          	bne	s2,a5,5a4 <copyin+0x3e>
}
     634:	70a6                	ld	ra,104(sp)
     636:	7406                	ld	s0,96(sp)
     638:	64e6                	ld	s1,88(sp)
     63a:	6946                	ld	s2,80(sp)
     63c:	69a6                	ld	s3,72(sp)
     63e:	6a06                	ld	s4,64(sp)
     640:	7ae2                	ld	s5,56(sp)
     642:	7b42                	ld	s6,48(sp)
     644:	7ba2                	ld	s7,40(sp)
     646:	7c02                	ld	s8,32(sp)
     648:	6165                	addi	sp,sp,112
     64a:	8082                	ret
      printf("open(copyin1) failed\n");
     64c:	00006517          	auipc	a0,0x6
     650:	edc50513          	addi	a0,a0,-292 # 6528 <malloc+0x25c>
     654:	00006097          	auipc	ra,0x6
     658:	bbc080e7          	jalr	-1092(ra) # 6210 <printf>
      exit(1);
     65c:	4505                	li	a0,1
     65e:	00006097          	auipc	ra,0x6
     662:	824080e7          	jalr	-2012(ra) # 5e82 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     666:	862a                	mv	a2,a0
     668:	85ce                	mv	a1,s3
     66a:	00006517          	auipc	a0,0x6
     66e:	ed650513          	addi	a0,a0,-298 # 6540 <malloc+0x274>
     672:	00006097          	auipc	ra,0x6
     676:	b9e080e7          	jalr	-1122(ra) # 6210 <printf>
      exit(1);
     67a:	4505                	li	a0,1
     67c:	00006097          	auipc	ra,0x6
     680:	806080e7          	jalr	-2042(ra) # 5e82 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     684:	862a                	mv	a2,a0
     686:	85ce                	mv	a1,s3
     688:	00006517          	auipc	a0,0x6
     68c:	ee850513          	addi	a0,a0,-280 # 6570 <malloc+0x2a4>
     690:	00006097          	auipc	ra,0x6
     694:	b80080e7          	jalr	-1152(ra) # 6210 <printf>
      exit(1);
     698:	4505                	li	a0,1
     69a:	00005097          	auipc	ra,0x5
     69e:	7e8080e7          	jalr	2024(ra) # 5e82 <exit>
      printf("pipe() failed\n");
     6a2:	00006517          	auipc	a0,0x6
     6a6:	efe50513          	addi	a0,a0,-258 # 65a0 <malloc+0x2d4>
     6aa:	00006097          	auipc	ra,0x6
     6ae:	b66080e7          	jalr	-1178(ra) # 6210 <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	00005097          	auipc	ra,0x5
     6b8:	7ce080e7          	jalr	1998(ra) # 5e82 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     6bc:	862a                	mv	a2,a0
     6be:	85ce                	mv	a1,s3
     6c0:	00006517          	auipc	a0,0x6
     6c4:	ef050513          	addi	a0,a0,-272 # 65b0 <malloc+0x2e4>
     6c8:	00006097          	auipc	ra,0x6
     6cc:	b48080e7          	jalr	-1208(ra) # 6210 <printf>
      exit(1);
     6d0:	4505                	li	a0,1
     6d2:	00005097          	auipc	ra,0x5
     6d6:	7b0080e7          	jalr	1968(ra) # 5e82 <exit>

00000000000006da <copyout>:
{
     6da:	7159                	addi	sp,sp,-112
     6dc:	f486                	sd	ra,104(sp)
     6de:	f0a2                	sd	s0,96(sp)
     6e0:	eca6                	sd	s1,88(sp)
     6e2:	e8ca                	sd	s2,80(sp)
     6e4:	e4ce                	sd	s3,72(sp)
     6e6:	e0d2                	sd	s4,64(sp)
     6e8:	fc56                	sd	s5,56(sp)
     6ea:	f85a                	sd	s6,48(sp)
     6ec:	f45e                	sd	s7,40(sp)
     6ee:	f062                	sd	s8,32(sp)
     6f0:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     6f2:	4785                	li	a5,1
     6f4:	07fe                	slli	a5,a5,0x1f
     6f6:	faf43023          	sd	a5,-96(s0)
     6fa:	57fd                	li	a5,-1
     6fc:	faf43423          	sd	a5,-88(s0)
  for(int ai = 0; ai < 2; ai++){
     700:	fa040913          	addi	s2,s0,-96
    int fd = open("README", 0);
     704:	00006b97          	auipc	s7,0x6
     708:	edcb8b93          	addi	s7,s7,-292 # 65e0 <malloc+0x314>
    int n = read(fd, (void*)addr, 8192);
     70c:	6a09                	lui	s4,0x2
    if(pipe(fds) < 0){
     70e:	f9840b13          	addi	s6,s0,-104
    n = write(fds[1], "x", 1);
     712:	4a85                	li	s5,1
     714:	00006c17          	auipc	s8,0x6
     718:	d64c0c13          	addi	s8,s8,-668 # 6478 <malloc+0x1ac>
    uint64 addr = addrs[ai];
     71c:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     720:	4581                	li	a1,0
     722:	855e                	mv	a0,s7
     724:	00005097          	auipc	ra,0x5
     728:	79e080e7          	jalr	1950(ra) # 5ec2 <open>
     72c:	84aa                	mv	s1,a0
    if(fd < 0){
     72e:	08054763          	bltz	a0,7bc <copyout+0xe2>
    int n = read(fd, (void*)addr, 8192);
     732:	8652                	mv	a2,s4
     734:	85ce                	mv	a1,s3
     736:	00005097          	auipc	ra,0x5
     73a:	764080e7          	jalr	1892(ra) # 5e9a <read>
    if(n > 0){
     73e:	08a04c63          	bgtz	a0,7d6 <copyout+0xfc>
    close(fd);
     742:	8526                	mv	a0,s1
     744:	00005097          	auipc	ra,0x5
     748:	766080e7          	jalr	1894(ra) # 5eaa <close>
    if(pipe(fds) < 0){
     74c:	855a                	mv	a0,s6
     74e:	00005097          	auipc	ra,0x5
     752:	744080e7          	jalr	1860(ra) # 5e92 <pipe>
     756:	08054f63          	bltz	a0,7f4 <copyout+0x11a>
    n = write(fds[1], "x", 1);
     75a:	8656                	mv	a2,s5
     75c:	85e2                	mv	a1,s8
     75e:	f9c42503          	lw	a0,-100(s0)
     762:	00005097          	auipc	ra,0x5
     766:	740080e7          	jalr	1856(ra) # 5ea2 <write>
    if(n != 1){
     76a:	0b551263          	bne	a0,s5,80e <copyout+0x134>
    n = read(fds[0], (void*)addr, 8192);
     76e:	8652                	mv	a2,s4
     770:	85ce                	mv	a1,s3
     772:	f9842503          	lw	a0,-104(s0)
     776:	00005097          	auipc	ra,0x5
     77a:	724080e7          	jalr	1828(ra) # 5e9a <read>
    if(n > 0){
     77e:	0aa04563          	bgtz	a0,828 <copyout+0x14e>
    close(fds[0]);
     782:	f9842503          	lw	a0,-104(s0)
     786:	00005097          	auipc	ra,0x5
     78a:	724080e7          	jalr	1828(ra) # 5eaa <close>
    close(fds[1]);
     78e:	f9c42503          	lw	a0,-100(s0)
     792:	00005097          	auipc	ra,0x5
     796:	718080e7          	jalr	1816(ra) # 5eaa <close>
  for(int ai = 0; ai < 2; ai++){
     79a:	0921                	addi	s2,s2,8
     79c:	fb040793          	addi	a5,s0,-80
     7a0:	f6f91ee3          	bne	s2,a5,71c <copyout+0x42>
}
     7a4:	70a6                	ld	ra,104(sp)
     7a6:	7406                	ld	s0,96(sp)
     7a8:	64e6                	ld	s1,88(sp)
     7aa:	6946                	ld	s2,80(sp)
     7ac:	69a6                	ld	s3,72(sp)
     7ae:	6a06                	ld	s4,64(sp)
     7b0:	7ae2                	ld	s5,56(sp)
     7b2:	7b42                	ld	s6,48(sp)
     7b4:	7ba2                	ld	s7,40(sp)
     7b6:	7c02                	ld	s8,32(sp)
     7b8:	6165                	addi	sp,sp,112
     7ba:	8082                	ret
      printf("open(README) failed\n");
     7bc:	00006517          	auipc	a0,0x6
     7c0:	e2c50513          	addi	a0,a0,-468 # 65e8 <malloc+0x31c>
     7c4:	00006097          	auipc	ra,0x6
     7c8:	a4c080e7          	jalr	-1460(ra) # 6210 <printf>
      exit(1);
     7cc:	4505                	li	a0,1
     7ce:	00005097          	auipc	ra,0x5
     7d2:	6b4080e7          	jalr	1716(ra) # 5e82 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7d6:	862a                	mv	a2,a0
     7d8:	85ce                	mv	a1,s3
     7da:	00006517          	auipc	a0,0x6
     7de:	e2650513          	addi	a0,a0,-474 # 6600 <malloc+0x334>
     7e2:	00006097          	auipc	ra,0x6
     7e6:	a2e080e7          	jalr	-1490(ra) # 6210 <printf>
      exit(1);
     7ea:	4505                	li	a0,1
     7ec:	00005097          	auipc	ra,0x5
     7f0:	696080e7          	jalr	1686(ra) # 5e82 <exit>
      printf("pipe() failed\n");
     7f4:	00006517          	auipc	a0,0x6
     7f8:	dac50513          	addi	a0,a0,-596 # 65a0 <malloc+0x2d4>
     7fc:	00006097          	auipc	ra,0x6
     800:	a14080e7          	jalr	-1516(ra) # 6210 <printf>
      exit(1);
     804:	4505                	li	a0,1
     806:	00005097          	auipc	ra,0x5
     80a:	67c080e7          	jalr	1660(ra) # 5e82 <exit>
      printf("pipe write failed\n");
     80e:	00006517          	auipc	a0,0x6
     812:	e2250513          	addi	a0,a0,-478 # 6630 <malloc+0x364>
     816:	00006097          	auipc	ra,0x6
     81a:	9fa080e7          	jalr	-1542(ra) # 6210 <printf>
      exit(1);
     81e:	4505                	li	a0,1
     820:	00005097          	auipc	ra,0x5
     824:	662080e7          	jalr	1634(ra) # 5e82 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     828:	862a                	mv	a2,a0
     82a:	85ce                	mv	a1,s3
     82c:	00006517          	auipc	a0,0x6
     830:	e1c50513          	addi	a0,a0,-484 # 6648 <malloc+0x37c>
     834:	00006097          	auipc	ra,0x6
     838:	9dc080e7          	jalr	-1572(ra) # 6210 <printf>
      exit(1);
     83c:	4505                	li	a0,1
     83e:	00005097          	auipc	ra,0x5
     842:	644080e7          	jalr	1604(ra) # 5e82 <exit>

0000000000000846 <truncate1>:
{
     846:	711d                	addi	sp,sp,-96
     848:	ec86                	sd	ra,88(sp)
     84a:	e8a2                	sd	s0,80(sp)
     84c:	e4a6                	sd	s1,72(sp)
     84e:	e0ca                	sd	s2,64(sp)
     850:	fc4e                	sd	s3,56(sp)
     852:	f852                	sd	s4,48(sp)
     854:	f456                	sd	s5,40(sp)
     856:	1080                	addi	s0,sp,96
     858:	8a2a                	mv	s4,a0
  unlink("truncfile");
     85a:	00006517          	auipc	a0,0x6
     85e:	c0650513          	addi	a0,a0,-1018 # 6460 <malloc+0x194>
     862:	00005097          	auipc	ra,0x5
     866:	670080e7          	jalr	1648(ra) # 5ed2 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     86a:	60100593          	li	a1,1537
     86e:	00006517          	auipc	a0,0x6
     872:	bf250513          	addi	a0,a0,-1038 # 6460 <malloc+0x194>
     876:	00005097          	auipc	ra,0x5
     87a:	64c080e7          	jalr	1612(ra) # 5ec2 <open>
     87e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     880:	4611                	li	a2,4
     882:	00006597          	auipc	a1,0x6
     886:	bee58593          	addi	a1,a1,-1042 # 6470 <malloc+0x1a4>
     88a:	00005097          	auipc	ra,0x5
     88e:	618080e7          	jalr	1560(ra) # 5ea2 <write>
  close(fd1);
     892:	8526                	mv	a0,s1
     894:	00005097          	auipc	ra,0x5
     898:	616080e7          	jalr	1558(ra) # 5eaa <close>
  int fd2 = open("truncfile", O_RDONLY);
     89c:	4581                	li	a1,0
     89e:	00006517          	auipc	a0,0x6
     8a2:	bc250513          	addi	a0,a0,-1086 # 6460 <malloc+0x194>
     8a6:	00005097          	auipc	ra,0x5
     8aa:	61c080e7          	jalr	1564(ra) # 5ec2 <open>
     8ae:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     8b0:	02000613          	li	a2,32
     8b4:	fa040593          	addi	a1,s0,-96
     8b8:	00005097          	auipc	ra,0x5
     8bc:	5e2080e7          	jalr	1506(ra) # 5e9a <read>
  if(n != 4){
     8c0:	4791                	li	a5,4
     8c2:	0cf51e63          	bne	a0,a5,99e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     8c6:	40100593          	li	a1,1025
     8ca:	00006517          	auipc	a0,0x6
     8ce:	b9650513          	addi	a0,a0,-1130 # 6460 <malloc+0x194>
     8d2:	00005097          	auipc	ra,0x5
     8d6:	5f0080e7          	jalr	1520(ra) # 5ec2 <open>
     8da:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     8dc:	4581                	li	a1,0
     8de:	00006517          	auipc	a0,0x6
     8e2:	b8250513          	addi	a0,a0,-1150 # 6460 <malloc+0x194>
     8e6:	00005097          	auipc	ra,0x5
     8ea:	5dc080e7          	jalr	1500(ra) # 5ec2 <open>
     8ee:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     8f0:	02000613          	li	a2,32
     8f4:	fa040593          	addi	a1,s0,-96
     8f8:	00005097          	auipc	ra,0x5
     8fc:	5a2080e7          	jalr	1442(ra) # 5e9a <read>
     900:	8aaa                	mv	s5,a0
  if(n != 0){
     902:	ed4d                	bnez	a0,9bc <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     904:	02000613          	li	a2,32
     908:	fa040593          	addi	a1,s0,-96
     90c:	8526                	mv	a0,s1
     90e:	00005097          	auipc	ra,0x5
     912:	58c080e7          	jalr	1420(ra) # 5e9a <read>
     916:	8aaa                	mv	s5,a0
  if(n != 0){
     918:	e971                	bnez	a0,9ec <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     91a:	4619                	li	a2,6
     91c:	00006597          	auipc	a1,0x6
     920:	dbc58593          	addi	a1,a1,-580 # 66d8 <malloc+0x40c>
     924:	854e                	mv	a0,s3
     926:	00005097          	auipc	ra,0x5
     92a:	57c080e7          	jalr	1404(ra) # 5ea2 <write>
  n = read(fd3, buf, sizeof(buf));
     92e:	02000613          	li	a2,32
     932:	fa040593          	addi	a1,s0,-96
     936:	854a                	mv	a0,s2
     938:	00005097          	auipc	ra,0x5
     93c:	562080e7          	jalr	1378(ra) # 5e9a <read>
  if(n != 6){
     940:	4799                	li	a5,6
     942:	0cf51d63          	bne	a0,a5,a1c <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     946:	02000613          	li	a2,32
     94a:	fa040593          	addi	a1,s0,-96
     94e:	8526                	mv	a0,s1
     950:	00005097          	auipc	ra,0x5
     954:	54a080e7          	jalr	1354(ra) # 5e9a <read>
  if(n != 2){
     958:	4789                	li	a5,2
     95a:	0ef51063          	bne	a0,a5,a3a <truncate1+0x1f4>
  unlink("truncfile");
     95e:	00006517          	auipc	a0,0x6
     962:	b0250513          	addi	a0,a0,-1278 # 6460 <malloc+0x194>
     966:	00005097          	auipc	ra,0x5
     96a:	56c080e7          	jalr	1388(ra) # 5ed2 <unlink>
  close(fd1);
     96e:	854e                	mv	a0,s3
     970:	00005097          	auipc	ra,0x5
     974:	53a080e7          	jalr	1338(ra) # 5eaa <close>
  close(fd2);
     978:	8526                	mv	a0,s1
     97a:	00005097          	auipc	ra,0x5
     97e:	530080e7          	jalr	1328(ra) # 5eaa <close>
  close(fd3);
     982:	854a                	mv	a0,s2
     984:	00005097          	auipc	ra,0x5
     988:	526080e7          	jalr	1318(ra) # 5eaa <close>
}
     98c:	60e6                	ld	ra,88(sp)
     98e:	6446                	ld	s0,80(sp)
     990:	64a6                	ld	s1,72(sp)
     992:	6906                	ld	s2,64(sp)
     994:	79e2                	ld	s3,56(sp)
     996:	7a42                	ld	s4,48(sp)
     998:	7aa2                	ld	s5,40(sp)
     99a:	6125                	addi	sp,sp,96
     99c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     99e:	862a                	mv	a2,a0
     9a0:	85d2                	mv	a1,s4
     9a2:	00006517          	auipc	a0,0x6
     9a6:	cd650513          	addi	a0,a0,-810 # 6678 <malloc+0x3ac>
     9aa:	00006097          	auipc	ra,0x6
     9ae:	866080e7          	jalr	-1946(ra) # 6210 <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	4ce080e7          	jalr	1230(ra) # 5e82 <exit>
    printf("aaa fd3=%d\n", fd3);
     9bc:	85ca                	mv	a1,s2
     9be:	00006517          	auipc	a0,0x6
     9c2:	cda50513          	addi	a0,a0,-806 # 6698 <malloc+0x3cc>
     9c6:	00006097          	auipc	ra,0x6
     9ca:	84a080e7          	jalr	-1974(ra) # 6210 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9ce:	8656                	mv	a2,s5
     9d0:	85d2                	mv	a1,s4
     9d2:	00006517          	auipc	a0,0x6
     9d6:	cd650513          	addi	a0,a0,-810 # 66a8 <malloc+0x3dc>
     9da:	00006097          	auipc	ra,0x6
     9de:	836080e7          	jalr	-1994(ra) # 6210 <printf>
    exit(1);
     9e2:	4505                	li	a0,1
     9e4:	00005097          	auipc	ra,0x5
     9e8:	49e080e7          	jalr	1182(ra) # 5e82 <exit>
    printf("bbb fd2=%d\n", fd2);
     9ec:	85a6                	mv	a1,s1
     9ee:	00006517          	auipc	a0,0x6
     9f2:	cda50513          	addi	a0,a0,-806 # 66c8 <malloc+0x3fc>
     9f6:	00006097          	auipc	ra,0x6
     9fa:	81a080e7          	jalr	-2022(ra) # 6210 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9fe:	8656                	mv	a2,s5
     a00:	85d2                	mv	a1,s4
     a02:	00006517          	auipc	a0,0x6
     a06:	ca650513          	addi	a0,a0,-858 # 66a8 <malloc+0x3dc>
     a0a:	00006097          	auipc	ra,0x6
     a0e:	806080e7          	jalr	-2042(ra) # 6210 <printf>
    exit(1);
     a12:	4505                	li	a0,1
     a14:	00005097          	auipc	ra,0x5
     a18:	46e080e7          	jalr	1134(ra) # 5e82 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     a1c:	862a                	mv	a2,a0
     a1e:	85d2                	mv	a1,s4
     a20:	00006517          	auipc	a0,0x6
     a24:	cc050513          	addi	a0,a0,-832 # 66e0 <malloc+0x414>
     a28:	00005097          	auipc	ra,0x5
     a2c:	7e8080e7          	jalr	2024(ra) # 6210 <printf>
    exit(1);
     a30:	4505                	li	a0,1
     a32:	00005097          	auipc	ra,0x5
     a36:	450080e7          	jalr	1104(ra) # 5e82 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     a3a:	862a                	mv	a2,a0
     a3c:	85d2                	mv	a1,s4
     a3e:	00006517          	auipc	a0,0x6
     a42:	cc250513          	addi	a0,a0,-830 # 6700 <malloc+0x434>
     a46:	00005097          	auipc	ra,0x5
     a4a:	7ca080e7          	jalr	1994(ra) # 6210 <printf>
    exit(1);
     a4e:	4505                	li	a0,1
     a50:	00005097          	auipc	ra,0x5
     a54:	432080e7          	jalr	1074(ra) # 5e82 <exit>

0000000000000a58 <writetest>:
{
     a58:	715d                	addi	sp,sp,-80
     a5a:	e486                	sd	ra,72(sp)
     a5c:	e0a2                	sd	s0,64(sp)
     a5e:	fc26                	sd	s1,56(sp)
     a60:	f84a                	sd	s2,48(sp)
     a62:	f44e                	sd	s3,40(sp)
     a64:	f052                	sd	s4,32(sp)
     a66:	ec56                	sd	s5,24(sp)
     a68:	e85a                	sd	s6,16(sp)
     a6a:	e45e                	sd	s7,8(sp)
     a6c:	0880                	addi	s0,sp,80
     a6e:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
     a70:	20200593          	li	a1,514
     a74:	00006517          	auipc	a0,0x6
     a78:	cac50513          	addi	a0,a0,-852 # 6720 <malloc+0x454>
     a7c:	00005097          	auipc	ra,0x5
     a80:	446080e7          	jalr	1094(ra) # 5ec2 <open>
  if(fd < 0){
     a84:	0a054d63          	bltz	a0,b3e <writetest+0xe6>
     a88:	89aa                	mv	s3,a0
     a8a:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a8c:	44a9                	li	s1,10
     a8e:	00006a17          	auipc	s4,0x6
     a92:	cbaa0a13          	addi	s4,s4,-838 # 6748 <malloc+0x47c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a96:	00006b17          	auipc	s6,0x6
     a9a:	ceab0b13          	addi	s6,s6,-790 # 6780 <malloc+0x4b4>
  for(i = 0; i < N; i++){
     a9e:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     aa2:	8626                	mv	a2,s1
     aa4:	85d2                	mv	a1,s4
     aa6:	854e                	mv	a0,s3
     aa8:	00005097          	auipc	ra,0x5
     aac:	3fa080e7          	jalr	1018(ra) # 5ea2 <write>
     ab0:	0a951563          	bne	a0,s1,b5a <writetest+0x102>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     ab4:	8626                	mv	a2,s1
     ab6:	85da                	mv	a1,s6
     ab8:	854e                	mv	a0,s3
     aba:	00005097          	auipc	ra,0x5
     abe:	3e8080e7          	jalr	1000(ra) # 5ea2 <write>
     ac2:	0a951b63          	bne	a0,s1,b78 <writetest+0x120>
  for(i = 0; i < N; i++){
     ac6:	2905                	addiw	s2,s2,1
     ac8:	fd591de3          	bne	s2,s5,aa2 <writetest+0x4a>
  close(fd);
     acc:	854e                	mv	a0,s3
     ace:	00005097          	auipc	ra,0x5
     ad2:	3dc080e7          	jalr	988(ra) # 5eaa <close>
  fd = open("small", O_RDONLY);
     ad6:	4581                	li	a1,0
     ad8:	00006517          	auipc	a0,0x6
     adc:	c4850513          	addi	a0,a0,-952 # 6720 <malloc+0x454>
     ae0:	00005097          	auipc	ra,0x5
     ae4:	3e2080e7          	jalr	994(ra) # 5ec2 <open>
     ae8:	84aa                	mv	s1,a0
  if(fd < 0){
     aea:	0a054663          	bltz	a0,b96 <writetest+0x13e>
  i = read(fd, buf, N*SZ*2);
     aee:	7d000613          	li	a2,2000
     af2:	0000c597          	auipc	a1,0xc
     af6:	18658593          	addi	a1,a1,390 # cc78 <buf>
     afa:	00005097          	auipc	ra,0x5
     afe:	3a0080e7          	jalr	928(ra) # 5e9a <read>
  if(i != N*SZ*2){
     b02:	7d000793          	li	a5,2000
     b06:	0af51663          	bne	a0,a5,bb2 <writetest+0x15a>
  close(fd);
     b0a:	8526                	mv	a0,s1
     b0c:	00005097          	auipc	ra,0x5
     b10:	39e080e7          	jalr	926(ra) # 5eaa <close>
  if(unlink("small") < 0){
     b14:	00006517          	auipc	a0,0x6
     b18:	c0c50513          	addi	a0,a0,-1012 # 6720 <malloc+0x454>
     b1c:	00005097          	auipc	ra,0x5
     b20:	3b6080e7          	jalr	950(ra) # 5ed2 <unlink>
     b24:	0a054563          	bltz	a0,bce <writetest+0x176>
}
     b28:	60a6                	ld	ra,72(sp)
     b2a:	6406                	ld	s0,64(sp)
     b2c:	74e2                	ld	s1,56(sp)
     b2e:	7942                	ld	s2,48(sp)
     b30:	79a2                	ld	s3,40(sp)
     b32:	7a02                	ld	s4,32(sp)
     b34:	6ae2                	ld	s5,24(sp)
     b36:	6b42                	ld	s6,16(sp)
     b38:	6ba2                	ld	s7,8(sp)
     b3a:	6161                	addi	sp,sp,80
     b3c:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     b3e:	85de                	mv	a1,s7
     b40:	00006517          	auipc	a0,0x6
     b44:	be850513          	addi	a0,a0,-1048 # 6728 <malloc+0x45c>
     b48:	00005097          	auipc	ra,0x5
     b4c:	6c8080e7          	jalr	1736(ra) # 6210 <printf>
    exit(1);
     b50:	4505                	li	a0,1
     b52:	00005097          	auipc	ra,0x5
     b56:	330080e7          	jalr	816(ra) # 5e82 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     b5a:	864a                	mv	a2,s2
     b5c:	85de                	mv	a1,s7
     b5e:	00006517          	auipc	a0,0x6
     b62:	bfa50513          	addi	a0,a0,-1030 # 6758 <malloc+0x48c>
     b66:	00005097          	auipc	ra,0x5
     b6a:	6aa080e7          	jalr	1706(ra) # 6210 <printf>
      exit(1);
     b6e:	4505                	li	a0,1
     b70:	00005097          	auipc	ra,0x5
     b74:	312080e7          	jalr	786(ra) # 5e82 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b78:	864a                	mv	a2,s2
     b7a:	85de                	mv	a1,s7
     b7c:	00006517          	auipc	a0,0x6
     b80:	c1450513          	addi	a0,a0,-1004 # 6790 <malloc+0x4c4>
     b84:	00005097          	auipc	ra,0x5
     b88:	68c080e7          	jalr	1676(ra) # 6210 <printf>
      exit(1);
     b8c:	4505                	li	a0,1
     b8e:	00005097          	auipc	ra,0x5
     b92:	2f4080e7          	jalr	756(ra) # 5e82 <exit>
    printf("%s: error: open small failed!\n", s);
     b96:	85de                	mv	a1,s7
     b98:	00006517          	auipc	a0,0x6
     b9c:	c2050513          	addi	a0,a0,-992 # 67b8 <malloc+0x4ec>
     ba0:	00005097          	auipc	ra,0x5
     ba4:	670080e7          	jalr	1648(ra) # 6210 <printf>
    exit(1);
     ba8:	4505                	li	a0,1
     baa:	00005097          	auipc	ra,0x5
     bae:	2d8080e7          	jalr	728(ra) # 5e82 <exit>
    printf("%s: read failed\n", s);
     bb2:	85de                	mv	a1,s7
     bb4:	00006517          	auipc	a0,0x6
     bb8:	c2450513          	addi	a0,a0,-988 # 67d8 <malloc+0x50c>
     bbc:	00005097          	auipc	ra,0x5
     bc0:	654080e7          	jalr	1620(ra) # 6210 <printf>
    exit(1);
     bc4:	4505                	li	a0,1
     bc6:	00005097          	auipc	ra,0x5
     bca:	2bc080e7          	jalr	700(ra) # 5e82 <exit>
    printf("%s: unlink small failed\n", s);
     bce:	85de                	mv	a1,s7
     bd0:	00006517          	auipc	a0,0x6
     bd4:	c2050513          	addi	a0,a0,-992 # 67f0 <malloc+0x524>
     bd8:	00005097          	auipc	ra,0x5
     bdc:	638080e7          	jalr	1592(ra) # 6210 <printf>
    exit(1);
     be0:	4505                	li	a0,1
     be2:	00005097          	auipc	ra,0x5
     be6:	2a0080e7          	jalr	672(ra) # 5e82 <exit>

0000000000000bea <writebig>:
{
     bea:	7139                	addi	sp,sp,-64
     bec:	fc06                	sd	ra,56(sp)
     bee:	f822                	sd	s0,48(sp)
     bf0:	f426                	sd	s1,40(sp)
     bf2:	f04a                	sd	s2,32(sp)
     bf4:	ec4e                	sd	s3,24(sp)
     bf6:	e852                	sd	s4,16(sp)
     bf8:	e456                	sd	s5,8(sp)
     bfa:	e05a                	sd	s6,0(sp)
     bfc:	0080                	addi	s0,sp,64
     bfe:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
     c00:	20200593          	li	a1,514
     c04:	00006517          	auipc	a0,0x6
     c08:	c0c50513          	addi	a0,a0,-1012 # 6810 <malloc+0x544>
     c0c:	00005097          	auipc	ra,0x5
     c10:	2b6080e7          	jalr	694(ra) # 5ec2 <open>
  if(fd < 0){
     c14:	08054263          	bltz	a0,c98 <writebig+0xae>
     c18:	8a2a                	mv	s4,a0
     c1a:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     c1c:	0000c997          	auipc	s3,0xc
     c20:	05c98993          	addi	s3,s3,92 # cc78 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
     c24:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
     c28:	10c00a93          	li	s5,268
    ((int*)buf)[0] = i;
     c2c:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
     c30:	864a                	mv	a2,s2
     c32:	85ce                	mv	a1,s3
     c34:	8552                	mv	a0,s4
     c36:	00005097          	auipc	ra,0x5
     c3a:	26c080e7          	jalr	620(ra) # 5ea2 <write>
     c3e:	07251b63          	bne	a0,s2,cb4 <writebig+0xca>
  for(i = 0; i < MAXFILE; i++){
     c42:	2485                	addiw	s1,s1,1
     c44:	ff5494e3          	bne	s1,s5,c2c <writebig+0x42>
  close(fd);
     c48:	8552                	mv	a0,s4
     c4a:	00005097          	auipc	ra,0x5
     c4e:	260080e7          	jalr	608(ra) # 5eaa <close>
  fd = open("big", O_RDONLY);
     c52:	4581                	li	a1,0
     c54:	00006517          	auipc	a0,0x6
     c58:	bbc50513          	addi	a0,a0,-1092 # 6810 <malloc+0x544>
     c5c:	00005097          	auipc	ra,0x5
     c60:	266080e7          	jalr	614(ra) # 5ec2 <open>
     c64:	8a2a                	mv	s4,a0
  n = 0;
     c66:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c68:	40000993          	li	s3,1024
     c6c:	0000c917          	auipc	s2,0xc
     c70:	00c90913          	addi	s2,s2,12 # cc78 <buf>
  if(fd < 0){
     c74:	04054f63          	bltz	a0,cd2 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     c78:	864e                	mv	a2,s3
     c7a:	85ca                	mv	a1,s2
     c7c:	8552                	mv	a0,s4
     c7e:	00005097          	auipc	ra,0x5
     c82:	21c080e7          	jalr	540(ra) # 5e9a <read>
    if(i == 0){
     c86:	c525                	beqz	a0,cee <writebig+0x104>
    } else if(i != BSIZE){
     c88:	0b351f63          	bne	a0,s3,d46 <writebig+0x15c>
    if(((int*)buf)[0] != n){
     c8c:	00092683          	lw	a3,0(s2)
     c90:	0c969a63          	bne	a3,s1,d64 <writebig+0x17a>
    n++;
     c94:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c96:	b7cd                	j	c78 <writebig+0x8e>
    printf("%s: error: creat big failed!\n", s);
     c98:	85da                	mv	a1,s6
     c9a:	00006517          	auipc	a0,0x6
     c9e:	b7e50513          	addi	a0,a0,-1154 # 6818 <malloc+0x54c>
     ca2:	00005097          	auipc	ra,0x5
     ca6:	56e080e7          	jalr	1390(ra) # 6210 <printf>
    exit(1);
     caa:	4505                	li	a0,1
     cac:	00005097          	auipc	ra,0x5
     cb0:	1d6080e7          	jalr	470(ra) # 5e82 <exit>
      printf("%s: error: write big file failed\n", s, i);
     cb4:	8626                	mv	a2,s1
     cb6:	85da                	mv	a1,s6
     cb8:	00006517          	auipc	a0,0x6
     cbc:	b8050513          	addi	a0,a0,-1152 # 6838 <malloc+0x56c>
     cc0:	00005097          	auipc	ra,0x5
     cc4:	550080e7          	jalr	1360(ra) # 6210 <printf>
      exit(1);
     cc8:	4505                	li	a0,1
     cca:	00005097          	auipc	ra,0x5
     cce:	1b8080e7          	jalr	440(ra) # 5e82 <exit>
    printf("%s: error: open big failed!\n", s);
     cd2:	85da                	mv	a1,s6
     cd4:	00006517          	auipc	a0,0x6
     cd8:	b8c50513          	addi	a0,a0,-1140 # 6860 <malloc+0x594>
     cdc:	00005097          	auipc	ra,0x5
     ce0:	534080e7          	jalr	1332(ra) # 6210 <printf>
    exit(1);
     ce4:	4505                	li	a0,1
     ce6:	00005097          	auipc	ra,0x5
     cea:	19c080e7          	jalr	412(ra) # 5e82 <exit>
      if(n == MAXFILE - 1){
     cee:	10b00793          	li	a5,267
     cf2:	02f48b63          	beq	s1,a5,d28 <writebig+0x13e>
  close(fd);
     cf6:	8552                	mv	a0,s4
     cf8:	00005097          	auipc	ra,0x5
     cfc:	1b2080e7          	jalr	434(ra) # 5eaa <close>
  if(unlink("big") < 0){
     d00:	00006517          	auipc	a0,0x6
     d04:	b1050513          	addi	a0,a0,-1264 # 6810 <malloc+0x544>
     d08:	00005097          	auipc	ra,0x5
     d0c:	1ca080e7          	jalr	458(ra) # 5ed2 <unlink>
     d10:	06054963          	bltz	a0,d82 <writebig+0x198>
}
     d14:	70e2                	ld	ra,56(sp)
     d16:	7442                	ld	s0,48(sp)
     d18:	74a2                	ld	s1,40(sp)
     d1a:	7902                	ld	s2,32(sp)
     d1c:	69e2                	ld	s3,24(sp)
     d1e:	6a42                	ld	s4,16(sp)
     d20:	6aa2                	ld	s5,8(sp)
     d22:	6b02                	ld	s6,0(sp)
     d24:	6121                	addi	sp,sp,64
     d26:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     d28:	8626                	mv	a2,s1
     d2a:	85da                	mv	a1,s6
     d2c:	00006517          	auipc	a0,0x6
     d30:	b5450513          	addi	a0,a0,-1196 # 6880 <malloc+0x5b4>
     d34:	00005097          	auipc	ra,0x5
     d38:	4dc080e7          	jalr	1244(ra) # 6210 <printf>
        exit(1);
     d3c:	4505                	li	a0,1
     d3e:	00005097          	auipc	ra,0x5
     d42:	144080e7          	jalr	324(ra) # 5e82 <exit>
      printf("%s: read failed %d\n", s, i);
     d46:	862a                	mv	a2,a0
     d48:	85da                	mv	a1,s6
     d4a:	00006517          	auipc	a0,0x6
     d4e:	b5e50513          	addi	a0,a0,-1186 # 68a8 <malloc+0x5dc>
     d52:	00005097          	auipc	ra,0x5
     d56:	4be080e7          	jalr	1214(ra) # 6210 <printf>
      exit(1);
     d5a:	4505                	li	a0,1
     d5c:	00005097          	auipc	ra,0x5
     d60:	126080e7          	jalr	294(ra) # 5e82 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d64:	8626                	mv	a2,s1
     d66:	85da                	mv	a1,s6
     d68:	00006517          	auipc	a0,0x6
     d6c:	b5850513          	addi	a0,a0,-1192 # 68c0 <malloc+0x5f4>
     d70:	00005097          	auipc	ra,0x5
     d74:	4a0080e7          	jalr	1184(ra) # 6210 <printf>
      exit(1);
     d78:	4505                	li	a0,1
     d7a:	00005097          	auipc	ra,0x5
     d7e:	108080e7          	jalr	264(ra) # 5e82 <exit>
    printf("%s: unlink big failed\n", s);
     d82:	85da                	mv	a1,s6
     d84:	00006517          	auipc	a0,0x6
     d88:	b6450513          	addi	a0,a0,-1180 # 68e8 <malloc+0x61c>
     d8c:	00005097          	auipc	ra,0x5
     d90:	484080e7          	jalr	1156(ra) # 6210 <printf>
    exit(1);
     d94:	4505                	li	a0,1
     d96:	00005097          	auipc	ra,0x5
     d9a:	0ec080e7          	jalr	236(ra) # 5e82 <exit>

0000000000000d9e <unlinkread>:
{
     d9e:	7179                	addi	sp,sp,-48
     da0:	f406                	sd	ra,40(sp)
     da2:	f022                	sd	s0,32(sp)
     da4:	ec26                	sd	s1,24(sp)
     da6:	e84a                	sd	s2,16(sp)
     da8:	e44e                	sd	s3,8(sp)
     daa:	1800                	addi	s0,sp,48
     dac:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     dae:	20200593          	li	a1,514
     db2:	00006517          	auipc	a0,0x6
     db6:	b4e50513          	addi	a0,a0,-1202 # 6900 <malloc+0x634>
     dba:	00005097          	auipc	ra,0x5
     dbe:	108080e7          	jalr	264(ra) # 5ec2 <open>
  if(fd < 0){
     dc2:	0e054563          	bltz	a0,eac <unlinkread+0x10e>
     dc6:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     dc8:	4615                	li	a2,5
     dca:	00006597          	auipc	a1,0x6
     dce:	b6658593          	addi	a1,a1,-1178 # 6930 <malloc+0x664>
     dd2:	00005097          	auipc	ra,0x5
     dd6:	0d0080e7          	jalr	208(ra) # 5ea2 <write>
  close(fd);
     dda:	8526                	mv	a0,s1
     ddc:	00005097          	auipc	ra,0x5
     de0:	0ce080e7          	jalr	206(ra) # 5eaa <close>
  fd = open("unlinkread", O_RDWR);
     de4:	4589                	li	a1,2
     de6:	00006517          	auipc	a0,0x6
     dea:	b1a50513          	addi	a0,a0,-1254 # 6900 <malloc+0x634>
     dee:	00005097          	auipc	ra,0x5
     df2:	0d4080e7          	jalr	212(ra) # 5ec2 <open>
     df6:	84aa                	mv	s1,a0
  if(fd < 0){
     df8:	0c054863          	bltz	a0,ec8 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     dfc:	00006517          	auipc	a0,0x6
     e00:	b0450513          	addi	a0,a0,-1276 # 6900 <malloc+0x634>
     e04:	00005097          	auipc	ra,0x5
     e08:	0ce080e7          	jalr	206(ra) # 5ed2 <unlink>
     e0c:	ed61                	bnez	a0,ee4 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     e0e:	20200593          	li	a1,514
     e12:	00006517          	auipc	a0,0x6
     e16:	aee50513          	addi	a0,a0,-1298 # 6900 <malloc+0x634>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	0a8080e7          	jalr	168(ra) # 5ec2 <open>
     e22:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     e24:	460d                	li	a2,3
     e26:	00006597          	auipc	a1,0x6
     e2a:	b5258593          	addi	a1,a1,-1198 # 6978 <malloc+0x6ac>
     e2e:	00005097          	auipc	ra,0x5
     e32:	074080e7          	jalr	116(ra) # 5ea2 <write>
  close(fd1);
     e36:	854a                	mv	a0,s2
     e38:	00005097          	auipc	ra,0x5
     e3c:	072080e7          	jalr	114(ra) # 5eaa <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     e40:	660d                	lui	a2,0x3
     e42:	0000c597          	auipc	a1,0xc
     e46:	e3658593          	addi	a1,a1,-458 # cc78 <buf>
     e4a:	8526                	mv	a0,s1
     e4c:	00005097          	auipc	ra,0x5
     e50:	04e080e7          	jalr	78(ra) # 5e9a <read>
     e54:	4795                	li	a5,5
     e56:	0af51563          	bne	a0,a5,f00 <unlinkread+0x162>
  if(buf[0] != 'h'){
     e5a:	0000c717          	auipc	a4,0xc
     e5e:	e1e74703          	lbu	a4,-482(a4) # cc78 <buf>
     e62:	06800793          	li	a5,104
     e66:	0af71b63          	bne	a4,a5,f1c <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e6a:	4629                	li	a2,10
     e6c:	0000c597          	auipc	a1,0xc
     e70:	e0c58593          	addi	a1,a1,-500 # cc78 <buf>
     e74:	8526                	mv	a0,s1
     e76:	00005097          	auipc	ra,0x5
     e7a:	02c080e7          	jalr	44(ra) # 5ea2 <write>
     e7e:	47a9                	li	a5,10
     e80:	0af51c63          	bne	a0,a5,f38 <unlinkread+0x19a>
  close(fd);
     e84:	8526                	mv	a0,s1
     e86:	00005097          	auipc	ra,0x5
     e8a:	024080e7          	jalr	36(ra) # 5eaa <close>
  unlink("unlinkread");
     e8e:	00006517          	auipc	a0,0x6
     e92:	a7250513          	addi	a0,a0,-1422 # 6900 <malloc+0x634>
     e96:	00005097          	auipc	ra,0x5
     e9a:	03c080e7          	jalr	60(ra) # 5ed2 <unlink>
}
     e9e:	70a2                	ld	ra,40(sp)
     ea0:	7402                	ld	s0,32(sp)
     ea2:	64e2                	ld	s1,24(sp)
     ea4:	6942                	ld	s2,16(sp)
     ea6:	69a2                	ld	s3,8(sp)
     ea8:	6145                	addi	sp,sp,48
     eaa:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     eac:	85ce                	mv	a1,s3
     eae:	00006517          	auipc	a0,0x6
     eb2:	a6250513          	addi	a0,a0,-1438 # 6910 <malloc+0x644>
     eb6:	00005097          	auipc	ra,0x5
     eba:	35a080e7          	jalr	858(ra) # 6210 <printf>
    exit(1);
     ebe:	4505                	li	a0,1
     ec0:	00005097          	auipc	ra,0x5
     ec4:	fc2080e7          	jalr	-62(ra) # 5e82 <exit>
    printf("%s: open unlinkread failed\n", s);
     ec8:	85ce                	mv	a1,s3
     eca:	00006517          	auipc	a0,0x6
     ece:	a6e50513          	addi	a0,a0,-1426 # 6938 <malloc+0x66c>
     ed2:	00005097          	auipc	ra,0x5
     ed6:	33e080e7          	jalr	830(ra) # 6210 <printf>
    exit(1);
     eda:	4505                	li	a0,1
     edc:	00005097          	auipc	ra,0x5
     ee0:	fa6080e7          	jalr	-90(ra) # 5e82 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ee4:	85ce                	mv	a1,s3
     ee6:	00006517          	auipc	a0,0x6
     eea:	a7250513          	addi	a0,a0,-1422 # 6958 <malloc+0x68c>
     eee:	00005097          	auipc	ra,0x5
     ef2:	322080e7          	jalr	802(ra) # 6210 <printf>
    exit(1);
     ef6:	4505                	li	a0,1
     ef8:	00005097          	auipc	ra,0x5
     efc:	f8a080e7          	jalr	-118(ra) # 5e82 <exit>
    printf("%s: unlinkread read failed", s);
     f00:	85ce                	mv	a1,s3
     f02:	00006517          	auipc	a0,0x6
     f06:	a7e50513          	addi	a0,a0,-1410 # 6980 <malloc+0x6b4>
     f0a:	00005097          	auipc	ra,0x5
     f0e:	306080e7          	jalr	774(ra) # 6210 <printf>
    exit(1);
     f12:	4505                	li	a0,1
     f14:	00005097          	auipc	ra,0x5
     f18:	f6e080e7          	jalr	-146(ra) # 5e82 <exit>
    printf("%s: unlinkread wrong data\n", s);
     f1c:	85ce                	mv	a1,s3
     f1e:	00006517          	auipc	a0,0x6
     f22:	a8250513          	addi	a0,a0,-1406 # 69a0 <malloc+0x6d4>
     f26:	00005097          	auipc	ra,0x5
     f2a:	2ea080e7          	jalr	746(ra) # 6210 <printf>
    exit(1);
     f2e:	4505                	li	a0,1
     f30:	00005097          	auipc	ra,0x5
     f34:	f52080e7          	jalr	-174(ra) # 5e82 <exit>
    printf("%s: unlinkread write failed\n", s);
     f38:	85ce                	mv	a1,s3
     f3a:	00006517          	auipc	a0,0x6
     f3e:	a8650513          	addi	a0,a0,-1402 # 69c0 <malloc+0x6f4>
     f42:	00005097          	auipc	ra,0x5
     f46:	2ce080e7          	jalr	718(ra) # 6210 <printf>
    exit(1);
     f4a:	4505                	li	a0,1
     f4c:	00005097          	auipc	ra,0x5
     f50:	f36080e7          	jalr	-202(ra) # 5e82 <exit>

0000000000000f54 <linktest>:
{
     f54:	1101                	addi	sp,sp,-32
     f56:	ec06                	sd	ra,24(sp)
     f58:	e822                	sd	s0,16(sp)
     f5a:	e426                	sd	s1,8(sp)
     f5c:	e04a                	sd	s2,0(sp)
     f5e:	1000                	addi	s0,sp,32
     f60:	892a                	mv	s2,a0
  unlink("lf1");
     f62:	00006517          	auipc	a0,0x6
     f66:	a7e50513          	addi	a0,a0,-1410 # 69e0 <malloc+0x714>
     f6a:	00005097          	auipc	ra,0x5
     f6e:	f68080e7          	jalr	-152(ra) # 5ed2 <unlink>
  unlink("lf2");
     f72:	00006517          	auipc	a0,0x6
     f76:	a7650513          	addi	a0,a0,-1418 # 69e8 <malloc+0x71c>
     f7a:	00005097          	auipc	ra,0x5
     f7e:	f58080e7          	jalr	-168(ra) # 5ed2 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f82:	20200593          	li	a1,514
     f86:	00006517          	auipc	a0,0x6
     f8a:	a5a50513          	addi	a0,a0,-1446 # 69e0 <malloc+0x714>
     f8e:	00005097          	auipc	ra,0x5
     f92:	f34080e7          	jalr	-204(ra) # 5ec2 <open>
  if(fd < 0){
     f96:	10054763          	bltz	a0,10a4 <linktest+0x150>
     f9a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f9c:	4615                	li	a2,5
     f9e:	00006597          	auipc	a1,0x6
     fa2:	99258593          	addi	a1,a1,-1646 # 6930 <malloc+0x664>
     fa6:	00005097          	auipc	ra,0x5
     faa:	efc080e7          	jalr	-260(ra) # 5ea2 <write>
     fae:	4795                	li	a5,5
     fb0:	10f51863          	bne	a0,a5,10c0 <linktest+0x16c>
  close(fd);
     fb4:	8526                	mv	a0,s1
     fb6:	00005097          	auipc	ra,0x5
     fba:	ef4080e7          	jalr	-268(ra) # 5eaa <close>
  if(link("lf1", "lf2") < 0){
     fbe:	00006597          	auipc	a1,0x6
     fc2:	a2a58593          	addi	a1,a1,-1494 # 69e8 <malloc+0x71c>
     fc6:	00006517          	auipc	a0,0x6
     fca:	a1a50513          	addi	a0,a0,-1510 # 69e0 <malloc+0x714>
     fce:	00005097          	auipc	ra,0x5
     fd2:	f14080e7          	jalr	-236(ra) # 5ee2 <link>
     fd6:	10054363          	bltz	a0,10dc <linktest+0x188>
  unlink("lf1");
     fda:	00006517          	auipc	a0,0x6
     fde:	a0650513          	addi	a0,a0,-1530 # 69e0 <malloc+0x714>
     fe2:	00005097          	auipc	ra,0x5
     fe6:	ef0080e7          	jalr	-272(ra) # 5ed2 <unlink>
  if(open("lf1", 0) >= 0){
     fea:	4581                	li	a1,0
     fec:	00006517          	auipc	a0,0x6
     ff0:	9f450513          	addi	a0,a0,-1548 # 69e0 <malloc+0x714>
     ff4:	00005097          	auipc	ra,0x5
     ff8:	ece080e7          	jalr	-306(ra) # 5ec2 <open>
     ffc:	0e055e63          	bgez	a0,10f8 <linktest+0x1a4>
  fd = open("lf2", 0);
    1000:	4581                	li	a1,0
    1002:	00006517          	auipc	a0,0x6
    1006:	9e650513          	addi	a0,a0,-1562 # 69e8 <malloc+0x71c>
    100a:	00005097          	auipc	ra,0x5
    100e:	eb8080e7          	jalr	-328(ra) # 5ec2 <open>
    1012:	84aa                	mv	s1,a0
  if(fd < 0){
    1014:	10054063          	bltz	a0,1114 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1018:	660d                	lui	a2,0x3
    101a:	0000c597          	auipc	a1,0xc
    101e:	c5e58593          	addi	a1,a1,-930 # cc78 <buf>
    1022:	00005097          	auipc	ra,0x5
    1026:	e78080e7          	jalr	-392(ra) # 5e9a <read>
    102a:	4795                	li	a5,5
    102c:	10f51263          	bne	a0,a5,1130 <linktest+0x1dc>
  close(fd);
    1030:	8526                	mv	a0,s1
    1032:	00005097          	auipc	ra,0x5
    1036:	e78080e7          	jalr	-392(ra) # 5eaa <close>
  if(link("lf2", "lf2") >= 0){
    103a:	00006597          	auipc	a1,0x6
    103e:	9ae58593          	addi	a1,a1,-1618 # 69e8 <malloc+0x71c>
    1042:	852e                	mv	a0,a1
    1044:	00005097          	auipc	ra,0x5
    1048:	e9e080e7          	jalr	-354(ra) # 5ee2 <link>
    104c:	10055063          	bgez	a0,114c <linktest+0x1f8>
  unlink("lf2");
    1050:	00006517          	auipc	a0,0x6
    1054:	99850513          	addi	a0,a0,-1640 # 69e8 <malloc+0x71c>
    1058:	00005097          	auipc	ra,0x5
    105c:	e7a080e7          	jalr	-390(ra) # 5ed2 <unlink>
  if(link("lf2", "lf1") >= 0){
    1060:	00006597          	auipc	a1,0x6
    1064:	98058593          	addi	a1,a1,-1664 # 69e0 <malloc+0x714>
    1068:	00006517          	auipc	a0,0x6
    106c:	98050513          	addi	a0,a0,-1664 # 69e8 <malloc+0x71c>
    1070:	00005097          	auipc	ra,0x5
    1074:	e72080e7          	jalr	-398(ra) # 5ee2 <link>
    1078:	0e055863          	bgez	a0,1168 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    107c:	00006597          	auipc	a1,0x6
    1080:	96458593          	addi	a1,a1,-1692 # 69e0 <malloc+0x714>
    1084:	00006517          	auipc	a0,0x6
    1088:	a6c50513          	addi	a0,a0,-1428 # 6af0 <malloc+0x824>
    108c:	00005097          	auipc	ra,0x5
    1090:	e56080e7          	jalr	-426(ra) # 5ee2 <link>
    1094:	0e055863          	bgez	a0,1184 <linktest+0x230>
}
    1098:	60e2                	ld	ra,24(sp)
    109a:	6442                	ld	s0,16(sp)
    109c:	64a2                	ld	s1,8(sp)
    109e:	6902                	ld	s2,0(sp)
    10a0:	6105                	addi	sp,sp,32
    10a2:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    10a4:	85ca                	mv	a1,s2
    10a6:	00006517          	auipc	a0,0x6
    10aa:	94a50513          	addi	a0,a0,-1718 # 69f0 <malloc+0x724>
    10ae:	00005097          	auipc	ra,0x5
    10b2:	162080e7          	jalr	354(ra) # 6210 <printf>
    exit(1);
    10b6:	4505                	li	a0,1
    10b8:	00005097          	auipc	ra,0x5
    10bc:	dca080e7          	jalr	-566(ra) # 5e82 <exit>
    printf("%s: write lf1 failed\n", s);
    10c0:	85ca                	mv	a1,s2
    10c2:	00006517          	auipc	a0,0x6
    10c6:	94650513          	addi	a0,a0,-1722 # 6a08 <malloc+0x73c>
    10ca:	00005097          	auipc	ra,0x5
    10ce:	146080e7          	jalr	326(ra) # 6210 <printf>
    exit(1);
    10d2:	4505                	li	a0,1
    10d4:	00005097          	auipc	ra,0x5
    10d8:	dae080e7          	jalr	-594(ra) # 5e82 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    10dc:	85ca                	mv	a1,s2
    10de:	00006517          	auipc	a0,0x6
    10e2:	94250513          	addi	a0,a0,-1726 # 6a20 <malloc+0x754>
    10e6:	00005097          	auipc	ra,0x5
    10ea:	12a080e7          	jalr	298(ra) # 6210 <printf>
    exit(1);
    10ee:	4505                	li	a0,1
    10f0:	00005097          	auipc	ra,0x5
    10f4:	d92080e7          	jalr	-622(ra) # 5e82 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    10f8:	85ca                	mv	a1,s2
    10fa:	00006517          	auipc	a0,0x6
    10fe:	94650513          	addi	a0,a0,-1722 # 6a40 <malloc+0x774>
    1102:	00005097          	auipc	ra,0x5
    1106:	10e080e7          	jalr	270(ra) # 6210 <printf>
    exit(1);
    110a:	4505                	li	a0,1
    110c:	00005097          	auipc	ra,0x5
    1110:	d76080e7          	jalr	-650(ra) # 5e82 <exit>
    printf("%s: open lf2 failed\n", s);
    1114:	85ca                	mv	a1,s2
    1116:	00006517          	auipc	a0,0x6
    111a:	95a50513          	addi	a0,a0,-1702 # 6a70 <malloc+0x7a4>
    111e:	00005097          	auipc	ra,0x5
    1122:	0f2080e7          	jalr	242(ra) # 6210 <printf>
    exit(1);
    1126:	4505                	li	a0,1
    1128:	00005097          	auipc	ra,0x5
    112c:	d5a080e7          	jalr	-678(ra) # 5e82 <exit>
    printf("%s: read lf2 failed\n", s);
    1130:	85ca                	mv	a1,s2
    1132:	00006517          	auipc	a0,0x6
    1136:	95650513          	addi	a0,a0,-1706 # 6a88 <malloc+0x7bc>
    113a:	00005097          	auipc	ra,0x5
    113e:	0d6080e7          	jalr	214(ra) # 6210 <printf>
    exit(1);
    1142:	4505                	li	a0,1
    1144:	00005097          	auipc	ra,0x5
    1148:	d3e080e7          	jalr	-706(ra) # 5e82 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    114c:	85ca                	mv	a1,s2
    114e:	00006517          	auipc	a0,0x6
    1152:	95250513          	addi	a0,a0,-1710 # 6aa0 <malloc+0x7d4>
    1156:	00005097          	auipc	ra,0x5
    115a:	0ba080e7          	jalr	186(ra) # 6210 <printf>
    exit(1);
    115e:	4505                	li	a0,1
    1160:	00005097          	auipc	ra,0x5
    1164:	d22080e7          	jalr	-734(ra) # 5e82 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1168:	85ca                	mv	a1,s2
    116a:	00006517          	auipc	a0,0x6
    116e:	95e50513          	addi	a0,a0,-1698 # 6ac8 <malloc+0x7fc>
    1172:	00005097          	auipc	ra,0x5
    1176:	09e080e7          	jalr	158(ra) # 6210 <printf>
    exit(1);
    117a:	4505                	li	a0,1
    117c:	00005097          	auipc	ra,0x5
    1180:	d06080e7          	jalr	-762(ra) # 5e82 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1184:	85ca                	mv	a1,s2
    1186:	00006517          	auipc	a0,0x6
    118a:	97250513          	addi	a0,a0,-1678 # 6af8 <malloc+0x82c>
    118e:	00005097          	auipc	ra,0x5
    1192:	082080e7          	jalr	130(ra) # 6210 <printf>
    exit(1);
    1196:	4505                	li	a0,1
    1198:	00005097          	auipc	ra,0x5
    119c:	cea080e7          	jalr	-790(ra) # 5e82 <exit>

00000000000011a0 <validatetest>:
{
    11a0:	7139                	addi	sp,sp,-64
    11a2:	fc06                	sd	ra,56(sp)
    11a4:	f822                	sd	s0,48(sp)
    11a6:	f426                	sd	s1,40(sp)
    11a8:	f04a                	sd	s2,32(sp)
    11aa:	ec4e                	sd	s3,24(sp)
    11ac:	e852                	sd	s4,16(sp)
    11ae:	e456                	sd	s5,8(sp)
    11b0:	e05a                	sd	s6,0(sp)
    11b2:	0080                	addi	s0,sp,64
    11b4:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    11b6:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    11b8:	00006997          	auipc	s3,0x6
    11bc:	96098993          	addi	s3,s3,-1696 # 6b18 <malloc+0x84c>
    11c0:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    11c2:	6a85                	lui	s5,0x1
    11c4:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    11c8:	85a6                	mv	a1,s1
    11ca:	854e                	mv	a0,s3
    11cc:	00005097          	auipc	ra,0x5
    11d0:	d16080e7          	jalr	-746(ra) # 5ee2 <link>
    11d4:	01251f63          	bne	a0,s2,11f2 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    11d8:	94d6                	add	s1,s1,s5
    11da:	ff4497e3          	bne	s1,s4,11c8 <validatetest+0x28>
}
    11de:	70e2                	ld	ra,56(sp)
    11e0:	7442                	ld	s0,48(sp)
    11e2:	74a2                	ld	s1,40(sp)
    11e4:	7902                	ld	s2,32(sp)
    11e6:	69e2                	ld	s3,24(sp)
    11e8:	6a42                	ld	s4,16(sp)
    11ea:	6aa2                	ld	s5,8(sp)
    11ec:	6b02                	ld	s6,0(sp)
    11ee:	6121                	addi	sp,sp,64
    11f0:	8082                	ret
      printf("%s: link should not succeed\n", s);
    11f2:	85da                	mv	a1,s6
    11f4:	00006517          	auipc	a0,0x6
    11f8:	93450513          	addi	a0,a0,-1740 # 6b28 <malloc+0x85c>
    11fc:	00005097          	auipc	ra,0x5
    1200:	014080e7          	jalr	20(ra) # 6210 <printf>
      exit(1);
    1204:	4505                	li	a0,1
    1206:	00005097          	auipc	ra,0x5
    120a:	c7c080e7          	jalr	-900(ra) # 5e82 <exit>

000000000000120e <bigdir>:
{
    120e:	711d                	addi	sp,sp,-96
    1210:	ec86                	sd	ra,88(sp)
    1212:	e8a2                	sd	s0,80(sp)
    1214:	e4a6                	sd	s1,72(sp)
    1216:	e0ca                	sd	s2,64(sp)
    1218:	fc4e                	sd	s3,56(sp)
    121a:	f852                	sd	s4,48(sp)
    121c:	f456                	sd	s5,40(sp)
    121e:	f05a                	sd	s6,32(sp)
    1220:	ec5e                	sd	s7,24(sp)
    1222:	1080                	addi	s0,sp,96
    1224:	8baa                	mv	s7,a0
  unlink("bd");
    1226:	00006517          	auipc	a0,0x6
    122a:	92250513          	addi	a0,a0,-1758 # 6b48 <malloc+0x87c>
    122e:	00005097          	auipc	ra,0x5
    1232:	ca4080e7          	jalr	-860(ra) # 5ed2 <unlink>
  fd = open("bd", O_CREATE);
    1236:	20000593          	li	a1,512
    123a:	00006517          	auipc	a0,0x6
    123e:	90e50513          	addi	a0,a0,-1778 # 6b48 <malloc+0x87c>
    1242:	00005097          	auipc	ra,0x5
    1246:	c80080e7          	jalr	-896(ra) # 5ec2 <open>
  if(fd < 0){
    124a:	0c054c63          	bltz	a0,1322 <bigdir+0x114>
  close(fd);
    124e:	00005097          	auipc	ra,0x5
    1252:	c5c080e7          	jalr	-932(ra) # 5eaa <close>
  for(i = 0; i < N; i++){
    1256:	4901                	li	s2,0
    name[0] = 'x';
    1258:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    125c:	fa040a13          	addi	s4,s0,-96
    1260:	00006997          	auipc	s3,0x6
    1264:	8e898993          	addi	s3,s3,-1816 # 6b48 <malloc+0x87c>
  for(i = 0; i < N; i++){
    1268:	1f400b13          	li	s6,500
    name[0] = 'x';
    126c:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
    1270:	41f9571b          	sraiw	a4,s2,0x1f
    1274:	01a7571b          	srliw	a4,a4,0x1a
    1278:	012707bb          	addw	a5,a4,s2
    127c:	4067d69b          	sraiw	a3,a5,0x6
    1280:	0306869b          	addiw	a3,a3,48
    1284:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
    1288:	03f7f793          	andi	a5,a5,63
    128c:	9f99                	subw	a5,a5,a4
    128e:	0307879b          	addiw	a5,a5,48
    1292:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
    1296:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
    129a:	85d2                	mv	a1,s4
    129c:	854e                	mv	a0,s3
    129e:	00005097          	auipc	ra,0x5
    12a2:	c44080e7          	jalr	-956(ra) # 5ee2 <link>
    12a6:	84aa                	mv	s1,a0
    12a8:	e959                	bnez	a0,133e <bigdir+0x130>
  for(i = 0; i < N; i++){
    12aa:	2905                	addiw	s2,s2,1
    12ac:	fd6910e3          	bne	s2,s6,126c <bigdir+0x5e>
  unlink("bd");
    12b0:	00006517          	auipc	a0,0x6
    12b4:	89850513          	addi	a0,a0,-1896 # 6b48 <malloc+0x87c>
    12b8:	00005097          	auipc	ra,0x5
    12bc:	c1a080e7          	jalr	-998(ra) # 5ed2 <unlink>
    name[0] = 'x';
    12c0:	07800993          	li	s3,120
    if(unlink(name) != 0){
    12c4:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
    12c8:	1f400a13          	li	s4,500
    name[0] = 'x';
    12cc:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
    12d0:	41f4d71b          	sraiw	a4,s1,0x1f
    12d4:	01a7571b          	srliw	a4,a4,0x1a
    12d8:	009707bb          	addw	a5,a4,s1
    12dc:	4067d69b          	sraiw	a3,a5,0x6
    12e0:	0306869b          	addiw	a3,a3,48
    12e4:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
    12e8:	03f7f793          	andi	a5,a5,63
    12ec:	9f99                	subw	a5,a5,a4
    12ee:	0307879b          	addiw	a5,a5,48
    12f2:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
    12f6:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
    12fa:	854a                	mv	a0,s2
    12fc:	00005097          	auipc	ra,0x5
    1300:	bd6080e7          	jalr	-1066(ra) # 5ed2 <unlink>
    1304:	ed29                	bnez	a0,135e <bigdir+0x150>
  for(i = 0; i < N; i++){
    1306:	2485                	addiw	s1,s1,1
    1308:	fd4492e3          	bne	s1,s4,12cc <bigdir+0xbe>
}
    130c:	60e6                	ld	ra,88(sp)
    130e:	6446                	ld	s0,80(sp)
    1310:	64a6                	ld	s1,72(sp)
    1312:	6906                	ld	s2,64(sp)
    1314:	79e2                	ld	s3,56(sp)
    1316:	7a42                	ld	s4,48(sp)
    1318:	7aa2                	ld	s5,40(sp)
    131a:	7b02                	ld	s6,32(sp)
    131c:	6be2                	ld	s7,24(sp)
    131e:	6125                	addi	sp,sp,96
    1320:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1322:	85de                	mv	a1,s7
    1324:	00006517          	auipc	a0,0x6
    1328:	82c50513          	addi	a0,a0,-2004 # 6b50 <malloc+0x884>
    132c:	00005097          	auipc	ra,0x5
    1330:	ee4080e7          	jalr	-284(ra) # 6210 <printf>
    exit(1);
    1334:	4505                	li	a0,1
    1336:	00005097          	auipc	ra,0x5
    133a:	b4c080e7          	jalr	-1204(ra) # 5e82 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    133e:	fa040613          	addi	a2,s0,-96
    1342:	85de                	mv	a1,s7
    1344:	00006517          	auipc	a0,0x6
    1348:	82c50513          	addi	a0,a0,-2004 # 6b70 <malloc+0x8a4>
    134c:	00005097          	auipc	ra,0x5
    1350:	ec4080e7          	jalr	-316(ra) # 6210 <printf>
      exit(1);
    1354:	4505                	li	a0,1
    1356:	00005097          	auipc	ra,0x5
    135a:	b2c080e7          	jalr	-1236(ra) # 5e82 <exit>
      printf("%s: bigdir unlink failed", s);
    135e:	85de                	mv	a1,s7
    1360:	00006517          	auipc	a0,0x6
    1364:	83050513          	addi	a0,a0,-2000 # 6b90 <malloc+0x8c4>
    1368:	00005097          	auipc	ra,0x5
    136c:	ea8080e7          	jalr	-344(ra) # 6210 <printf>
      exit(1);
    1370:	4505                	li	a0,1
    1372:	00005097          	auipc	ra,0x5
    1376:	b10080e7          	jalr	-1264(ra) # 5e82 <exit>

000000000000137a <pgbug>:
{
    137a:	7179                	addi	sp,sp,-48
    137c:	f406                	sd	ra,40(sp)
    137e:	f022                	sd	s0,32(sp)
    1380:	ec26                	sd	s1,24(sp)
    1382:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1384:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1388:	00008497          	auipc	s1,0x8
    138c:	c7848493          	addi	s1,s1,-904 # 9000 <big>
    1390:	fd840593          	addi	a1,s0,-40
    1394:	6088                	ld	a0,0(s1)
    1396:	00005097          	auipc	ra,0x5
    139a:	b24080e7          	jalr	-1244(ra) # 5eba <exec>
  pipe(big);
    139e:	6088                	ld	a0,0(s1)
    13a0:	00005097          	auipc	ra,0x5
    13a4:	af2080e7          	jalr	-1294(ra) # 5e92 <pipe>
  exit(0);
    13a8:	4501                	li	a0,0
    13aa:	00005097          	auipc	ra,0x5
    13ae:	ad8080e7          	jalr	-1320(ra) # 5e82 <exit>

00000000000013b2 <badarg>:
{
    13b2:	7139                	addi	sp,sp,-64
    13b4:	fc06                	sd	ra,56(sp)
    13b6:	f822                	sd	s0,48(sp)
    13b8:	f426                	sd	s1,40(sp)
    13ba:	f04a                	sd	s2,32(sp)
    13bc:	ec4e                	sd	s3,24(sp)
    13be:	e852                	sd	s4,16(sp)
    13c0:	0080                	addi	s0,sp,64
    13c2:	64b1                	lui	s1,0xc
    13c4:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    13c8:	597d                	li	s2,-1
    13ca:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    13ce:	fc040a13          	addi	s4,s0,-64
    13d2:	00005997          	auipc	s3,0x5
    13d6:	03698993          	addi	s3,s3,54 # 6408 <malloc+0x13c>
    argv[0] = (char*)0xffffffff;
    13da:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    13de:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    13e2:	85d2                	mv	a1,s4
    13e4:	854e                	mv	a0,s3
    13e6:	00005097          	auipc	ra,0x5
    13ea:	ad4080e7          	jalr	-1324(ra) # 5eba <exec>
  for(int i = 0; i < 50000; i++){
    13ee:	34fd                	addiw	s1,s1,-1
    13f0:	f4ed                	bnez	s1,13da <badarg+0x28>
  exit(0);
    13f2:	4501                	li	a0,0
    13f4:	00005097          	auipc	ra,0x5
    13f8:	a8e080e7          	jalr	-1394(ra) # 5e82 <exit>

00000000000013fc <copyinstr2>:
{
    13fc:	7155                	addi	sp,sp,-208
    13fe:	e586                	sd	ra,200(sp)
    1400:	e1a2                	sd	s0,192(sp)
    1402:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1404:	f6840793          	addi	a5,s0,-152
    1408:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    140c:	07800713          	li	a4,120
    1410:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1414:	0785                	addi	a5,a5,1
    1416:	fed79de3          	bne	a5,a3,1410 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    141a:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    141e:	f6840513          	addi	a0,s0,-152
    1422:	00005097          	auipc	ra,0x5
    1426:	ab0080e7          	jalr	-1360(ra) # 5ed2 <unlink>
  if(ret != -1){
    142a:	57fd                	li	a5,-1
    142c:	0ef51063          	bne	a0,a5,150c <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    1430:	20100593          	li	a1,513
    1434:	f6840513          	addi	a0,s0,-152
    1438:	00005097          	auipc	ra,0x5
    143c:	a8a080e7          	jalr	-1398(ra) # 5ec2 <open>
  if(fd != -1){
    1440:	57fd                	li	a5,-1
    1442:	0ef51563          	bne	a0,a5,152c <copyinstr2+0x130>
  ret = link(b, b);
    1446:	f6840513          	addi	a0,s0,-152
    144a:	85aa                	mv	a1,a0
    144c:	00005097          	auipc	ra,0x5
    1450:	a96080e7          	jalr	-1386(ra) # 5ee2 <link>
  if(ret != -1){
    1454:	57fd                	li	a5,-1
    1456:	0ef51b63          	bne	a0,a5,154c <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    145a:	00007797          	auipc	a5,0x7
    145e:	98e78793          	addi	a5,a5,-1650 # 7de8 <malloc+0x1b1c>
    1462:	f4f43c23          	sd	a5,-168(s0)
    1466:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    146a:	f5840593          	addi	a1,s0,-168
    146e:	f6840513          	addi	a0,s0,-152
    1472:	00005097          	auipc	ra,0x5
    1476:	a48080e7          	jalr	-1464(ra) # 5eba <exec>
  if(ret != -1){
    147a:	57fd                	li	a5,-1
    147c:	0ef51963          	bne	a0,a5,156e <copyinstr2+0x172>
  int pid = fork();
    1480:	00005097          	auipc	ra,0x5
    1484:	9fa080e7          	jalr	-1542(ra) # 5e7a <fork>
  if(pid < 0){
    1488:	10054363          	bltz	a0,158e <copyinstr2+0x192>
  if(pid == 0){
    148c:	12051463          	bnez	a0,15b4 <copyinstr2+0x1b8>
    1490:	00008797          	auipc	a5,0x8
    1494:	0d078793          	addi	a5,a5,208 # 9560 <big.0>
    1498:	00009697          	auipc	a3,0x9
    149c:	0c868693          	addi	a3,a3,200 # a560 <big.0+0x1000>
      big[i] = 'x';
    14a0:	07800713          	li	a4,120
    14a4:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    14a8:	0785                	addi	a5,a5,1
    14aa:	fed79de3          	bne	a5,a3,14a4 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    14ae:	00009797          	auipc	a5,0x9
    14b2:	0a078923          	sb	zero,178(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    14b6:	00007797          	auipc	a5,0x7
    14ba:	37a78793          	addi	a5,a5,890 # 8830 <malloc+0x2564>
    14be:	6390                	ld	a2,0(a5)
    14c0:	6794                	ld	a3,8(a5)
    14c2:	6b98                	ld	a4,16(a5)
    14c4:	f2c43823          	sd	a2,-208(s0)
    14c8:	f2d43c23          	sd	a3,-200(s0)
    14cc:	f4e43023          	sd	a4,-192(s0)
    14d0:	6f9c                	ld	a5,24(a5)
    14d2:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    14d6:	f3040593          	addi	a1,s0,-208
    14da:	00005517          	auipc	a0,0x5
    14de:	f2e50513          	addi	a0,a0,-210 # 6408 <malloc+0x13c>
    14e2:	00005097          	auipc	ra,0x5
    14e6:	9d8080e7          	jalr	-1576(ra) # 5eba <exec>
    if(ret != -1){
    14ea:	57fd                	li	a5,-1
    14ec:	0af50e63          	beq	a0,a5,15a8 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    14f0:	85be                	mv	a1,a5
    14f2:	00005517          	auipc	a0,0x5
    14f6:	74650513          	addi	a0,a0,1862 # 6c38 <malloc+0x96c>
    14fa:	00005097          	auipc	ra,0x5
    14fe:	d16080e7          	jalr	-746(ra) # 6210 <printf>
      exit(1);
    1502:	4505                	li	a0,1
    1504:	00005097          	auipc	ra,0x5
    1508:	97e080e7          	jalr	-1666(ra) # 5e82 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    150c:	862a                	mv	a2,a0
    150e:	f6840593          	addi	a1,s0,-152
    1512:	00005517          	auipc	a0,0x5
    1516:	69e50513          	addi	a0,a0,1694 # 6bb0 <malloc+0x8e4>
    151a:	00005097          	auipc	ra,0x5
    151e:	cf6080e7          	jalr	-778(ra) # 6210 <printf>
    exit(1);
    1522:	4505                	li	a0,1
    1524:	00005097          	auipc	ra,0x5
    1528:	95e080e7          	jalr	-1698(ra) # 5e82 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    152c:	862a                	mv	a2,a0
    152e:	f6840593          	addi	a1,s0,-152
    1532:	00005517          	auipc	a0,0x5
    1536:	69e50513          	addi	a0,a0,1694 # 6bd0 <malloc+0x904>
    153a:	00005097          	auipc	ra,0x5
    153e:	cd6080e7          	jalr	-810(ra) # 6210 <printf>
    exit(1);
    1542:	4505                	li	a0,1
    1544:	00005097          	auipc	ra,0x5
    1548:	93e080e7          	jalr	-1730(ra) # 5e82 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    154c:	f6840593          	addi	a1,s0,-152
    1550:	86aa                	mv	a3,a0
    1552:	862e                	mv	a2,a1
    1554:	00005517          	auipc	a0,0x5
    1558:	69c50513          	addi	a0,a0,1692 # 6bf0 <malloc+0x924>
    155c:	00005097          	auipc	ra,0x5
    1560:	cb4080e7          	jalr	-844(ra) # 6210 <printf>
    exit(1);
    1564:	4505                	li	a0,1
    1566:	00005097          	auipc	ra,0x5
    156a:	91c080e7          	jalr	-1764(ra) # 5e82 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    156e:	863e                	mv	a2,a5
    1570:	f6840593          	addi	a1,s0,-152
    1574:	00005517          	auipc	a0,0x5
    1578:	6a450513          	addi	a0,a0,1700 # 6c18 <malloc+0x94c>
    157c:	00005097          	auipc	ra,0x5
    1580:	c94080e7          	jalr	-876(ra) # 6210 <printf>
    exit(1);
    1584:	4505                	li	a0,1
    1586:	00005097          	auipc	ra,0x5
    158a:	8fc080e7          	jalr	-1796(ra) # 5e82 <exit>
    printf("fork failed\n");
    158e:	00006517          	auipc	a0,0x6
    1592:	b0a50513          	addi	a0,a0,-1270 # 7098 <malloc+0xdcc>
    1596:	00005097          	auipc	ra,0x5
    159a:	c7a080e7          	jalr	-902(ra) # 6210 <printf>
    exit(1);
    159e:	4505                	li	a0,1
    15a0:	00005097          	auipc	ra,0x5
    15a4:	8e2080e7          	jalr	-1822(ra) # 5e82 <exit>
    exit(747); // OK
    15a8:	2eb00513          	li	a0,747
    15ac:	00005097          	auipc	ra,0x5
    15b0:	8d6080e7          	jalr	-1834(ra) # 5e82 <exit>
  int st = 0;
    15b4:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    15b8:	f5440513          	addi	a0,s0,-172
    15bc:	00005097          	auipc	ra,0x5
    15c0:	8ce080e7          	jalr	-1842(ra) # 5e8a <wait>
  if(st != 747){
    15c4:	f5442703          	lw	a4,-172(s0)
    15c8:	2eb00793          	li	a5,747
    15cc:	00f71663          	bne	a4,a5,15d8 <copyinstr2+0x1dc>
}
    15d0:	60ae                	ld	ra,200(sp)
    15d2:	640e                	ld	s0,192(sp)
    15d4:	6169                	addi	sp,sp,208
    15d6:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    15d8:	00005517          	auipc	a0,0x5
    15dc:	68850513          	addi	a0,a0,1672 # 6c60 <malloc+0x994>
    15e0:	00005097          	auipc	ra,0x5
    15e4:	c30080e7          	jalr	-976(ra) # 6210 <printf>
    exit(1);
    15e8:	4505                	li	a0,1
    15ea:	00005097          	auipc	ra,0x5
    15ee:	898080e7          	jalr	-1896(ra) # 5e82 <exit>

00000000000015f2 <truncate3>:
{
    15f2:	7175                	addi	sp,sp,-144
    15f4:	e506                	sd	ra,136(sp)
    15f6:	e122                	sd	s0,128(sp)
    15f8:	fc66                	sd	s9,56(sp)
    15fa:	0900                	addi	s0,sp,144
    15fc:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    15fe:	60100593          	li	a1,1537
    1602:	00005517          	auipc	a0,0x5
    1606:	e5e50513          	addi	a0,a0,-418 # 6460 <malloc+0x194>
    160a:	00005097          	auipc	ra,0x5
    160e:	8b8080e7          	jalr	-1864(ra) # 5ec2 <open>
    1612:	00005097          	auipc	ra,0x5
    1616:	898080e7          	jalr	-1896(ra) # 5eaa <close>
  pid = fork();
    161a:	00005097          	auipc	ra,0x5
    161e:	860080e7          	jalr	-1952(ra) # 5e7a <fork>
  if(pid < 0){
    1622:	08054b63          	bltz	a0,16b8 <truncate3+0xc6>
  if(pid == 0){
    1626:	ed65                	bnez	a0,171e <truncate3+0x12c>
    1628:	fca6                	sd	s1,120(sp)
    162a:	f8ca                	sd	s2,112(sp)
    162c:	f4ce                	sd	s3,104(sp)
    162e:	f0d2                	sd	s4,96(sp)
    1630:	ecd6                	sd	s5,88(sp)
    1632:	e8da                	sd	s6,80(sp)
    1634:	e4de                	sd	s7,72(sp)
    1636:	e0e2                	sd	s8,64(sp)
    1638:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    163c:	4a85                	li	s5,1
    163e:	00005997          	auipc	s3,0x5
    1642:	e2298993          	addi	s3,s3,-478 # 6460 <malloc+0x194>
      int n = write(fd, "1234567890", 10);
    1646:	4a29                	li	s4,10
    1648:	00005b17          	auipc	s6,0x5
    164c:	678b0b13          	addi	s6,s6,1656 # 6cc0 <malloc+0x9f4>
      read(fd, buf, sizeof(buf));
    1650:	f7840c13          	addi	s8,s0,-136
    1654:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1658:	85d6                	mv	a1,s5
    165a:	854e                	mv	a0,s3
    165c:	00005097          	auipc	ra,0x5
    1660:	866080e7          	jalr	-1946(ra) # 5ec2 <open>
    1664:	84aa                	mv	s1,a0
      if(fd < 0){
    1666:	06054f63          	bltz	a0,16e4 <truncate3+0xf2>
      int n = write(fd, "1234567890", 10);
    166a:	8652                	mv	a2,s4
    166c:	85da                	mv	a1,s6
    166e:	00005097          	auipc	ra,0x5
    1672:	834080e7          	jalr	-1996(ra) # 5ea2 <write>
      if(n != 10){
    1676:	09451563          	bne	a0,s4,1700 <truncate3+0x10e>
      close(fd);
    167a:	8526                	mv	a0,s1
    167c:	00005097          	auipc	ra,0x5
    1680:	82e080e7          	jalr	-2002(ra) # 5eaa <close>
      fd = open("truncfile", O_RDONLY);
    1684:	4581                	li	a1,0
    1686:	854e                	mv	a0,s3
    1688:	00005097          	auipc	ra,0x5
    168c:	83a080e7          	jalr	-1990(ra) # 5ec2 <open>
    1690:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1692:	865e                	mv	a2,s7
    1694:	85e2                	mv	a1,s8
    1696:	00005097          	auipc	ra,0x5
    169a:	804080e7          	jalr	-2044(ra) # 5e9a <read>
      close(fd);
    169e:	8526                	mv	a0,s1
    16a0:	00005097          	auipc	ra,0x5
    16a4:	80a080e7          	jalr	-2038(ra) # 5eaa <close>
    for(int i = 0; i < 100; i++){
    16a8:	397d                	addiw	s2,s2,-1
    16aa:	fa0917e3          	bnez	s2,1658 <truncate3+0x66>
    exit(0);
    16ae:	4501                	li	a0,0
    16b0:	00004097          	auipc	ra,0x4
    16b4:	7d2080e7          	jalr	2002(ra) # 5e82 <exit>
    16b8:	fca6                	sd	s1,120(sp)
    16ba:	f8ca                	sd	s2,112(sp)
    16bc:	f4ce                	sd	s3,104(sp)
    16be:	f0d2                	sd	s4,96(sp)
    16c0:	ecd6                	sd	s5,88(sp)
    16c2:	e8da                	sd	s6,80(sp)
    16c4:	e4de                	sd	s7,72(sp)
    16c6:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    16c8:	85e6                	mv	a1,s9
    16ca:	00005517          	auipc	a0,0x5
    16ce:	5c650513          	addi	a0,a0,1478 # 6c90 <malloc+0x9c4>
    16d2:	00005097          	auipc	ra,0x5
    16d6:	b3e080e7          	jalr	-1218(ra) # 6210 <printf>
    exit(1);
    16da:	4505                	li	a0,1
    16dc:	00004097          	auipc	ra,0x4
    16e0:	7a6080e7          	jalr	1958(ra) # 5e82 <exit>
        printf("%s: open failed\n", s);
    16e4:	85e6                	mv	a1,s9
    16e6:	00005517          	auipc	a0,0x5
    16ea:	5c250513          	addi	a0,a0,1474 # 6ca8 <malloc+0x9dc>
    16ee:	00005097          	auipc	ra,0x5
    16f2:	b22080e7          	jalr	-1246(ra) # 6210 <printf>
        exit(1);
    16f6:	4505                	li	a0,1
    16f8:	00004097          	auipc	ra,0x4
    16fc:	78a080e7          	jalr	1930(ra) # 5e82 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1700:	862a                	mv	a2,a0
    1702:	85e6                	mv	a1,s9
    1704:	00005517          	auipc	a0,0x5
    1708:	5cc50513          	addi	a0,a0,1484 # 6cd0 <malloc+0xa04>
    170c:	00005097          	auipc	ra,0x5
    1710:	b04080e7          	jalr	-1276(ra) # 6210 <printf>
        exit(1);
    1714:	4505                	li	a0,1
    1716:	00004097          	auipc	ra,0x4
    171a:	76c080e7          	jalr	1900(ra) # 5e82 <exit>
    171e:	fca6                	sd	s1,120(sp)
    1720:	f8ca                	sd	s2,112(sp)
    1722:	f4ce                	sd	s3,104(sp)
    1724:	f0d2                	sd	s4,96(sp)
    1726:	ecd6                	sd	s5,88(sp)
    1728:	e8da                	sd	s6,80(sp)
    172a:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    172e:	60100a93          	li	s5,1537
    1732:	00005a17          	auipc	s4,0x5
    1736:	d2ea0a13          	addi	s4,s4,-722 # 6460 <malloc+0x194>
    int n = write(fd, "xxx", 3);
    173a:	498d                	li	s3,3
    173c:	00005b17          	auipc	s6,0x5
    1740:	5b4b0b13          	addi	s6,s6,1460 # 6cf0 <malloc+0xa24>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1744:	85d6                	mv	a1,s5
    1746:	8552                	mv	a0,s4
    1748:	00004097          	auipc	ra,0x4
    174c:	77a080e7          	jalr	1914(ra) # 5ec2 <open>
    1750:	84aa                	mv	s1,a0
    if(fd < 0){
    1752:	04054863          	bltz	a0,17a2 <truncate3+0x1b0>
    int n = write(fd, "xxx", 3);
    1756:	864e                	mv	a2,s3
    1758:	85da                	mv	a1,s6
    175a:	00004097          	auipc	ra,0x4
    175e:	748080e7          	jalr	1864(ra) # 5ea2 <write>
    if(n != 3){
    1762:	07351063          	bne	a0,s3,17c2 <truncate3+0x1d0>
    close(fd);
    1766:	8526                	mv	a0,s1
    1768:	00004097          	auipc	ra,0x4
    176c:	742080e7          	jalr	1858(ra) # 5eaa <close>
  for(int i = 0; i < 150; i++){
    1770:	397d                	addiw	s2,s2,-1
    1772:	fc0919e3          	bnez	s2,1744 <truncate3+0x152>
    1776:	e4de                	sd	s7,72(sp)
    1778:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    177a:	f9c40513          	addi	a0,s0,-100
    177e:	00004097          	auipc	ra,0x4
    1782:	70c080e7          	jalr	1804(ra) # 5e8a <wait>
  unlink("truncfile");
    1786:	00005517          	auipc	a0,0x5
    178a:	cda50513          	addi	a0,a0,-806 # 6460 <malloc+0x194>
    178e:	00004097          	auipc	ra,0x4
    1792:	744080e7          	jalr	1860(ra) # 5ed2 <unlink>
  exit(xstatus);
    1796:	f9c42503          	lw	a0,-100(s0)
    179a:	00004097          	auipc	ra,0x4
    179e:	6e8080e7          	jalr	1768(ra) # 5e82 <exit>
    17a2:	e4de                	sd	s7,72(sp)
    17a4:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    17a6:	85e6                	mv	a1,s9
    17a8:	00005517          	auipc	a0,0x5
    17ac:	50050513          	addi	a0,a0,1280 # 6ca8 <malloc+0x9dc>
    17b0:	00005097          	auipc	ra,0x5
    17b4:	a60080e7          	jalr	-1440(ra) # 6210 <printf>
      exit(1);
    17b8:	4505                	li	a0,1
    17ba:	00004097          	auipc	ra,0x4
    17be:	6c8080e7          	jalr	1736(ra) # 5e82 <exit>
    17c2:	e4de                	sd	s7,72(sp)
    17c4:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    17c6:	862a                	mv	a2,a0
    17c8:	85e6                	mv	a1,s9
    17ca:	00005517          	auipc	a0,0x5
    17ce:	52e50513          	addi	a0,a0,1326 # 6cf8 <malloc+0xa2c>
    17d2:	00005097          	auipc	ra,0x5
    17d6:	a3e080e7          	jalr	-1474(ra) # 6210 <printf>
      exit(1);
    17da:	4505                	li	a0,1
    17dc:	00004097          	auipc	ra,0x4
    17e0:	6a6080e7          	jalr	1702(ra) # 5e82 <exit>

00000000000017e4 <exectest>:
{
    17e4:	715d                	addi	sp,sp,-80
    17e6:	e486                	sd	ra,72(sp)
    17e8:	e0a2                	sd	s0,64(sp)
    17ea:	f84a                	sd	s2,48(sp)
    17ec:	0880                	addi	s0,sp,80
    17ee:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    17f0:	00005797          	auipc	a5,0x5
    17f4:	c1878793          	addi	a5,a5,-1000 # 6408 <malloc+0x13c>
    17f8:	fcf43023          	sd	a5,-64(s0)
    17fc:	00005797          	auipc	a5,0x5
    1800:	51c78793          	addi	a5,a5,1308 # 6d18 <malloc+0xa4c>
    1804:	fcf43423          	sd	a5,-56(s0)
    1808:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    180c:	00005517          	auipc	a0,0x5
    1810:	51450513          	addi	a0,a0,1300 # 6d20 <malloc+0xa54>
    1814:	00004097          	auipc	ra,0x4
    1818:	6be080e7          	jalr	1726(ra) # 5ed2 <unlink>
  pid = fork();
    181c:	00004097          	auipc	ra,0x4
    1820:	65e080e7          	jalr	1630(ra) # 5e7a <fork>
  if(pid < 0) {
    1824:	04054763          	bltz	a0,1872 <exectest+0x8e>
    1828:	fc26                	sd	s1,56(sp)
    182a:	84aa                	mv	s1,a0
  if(pid == 0) {
    182c:	ed41                	bnez	a0,18c4 <exectest+0xe0>
    close(1);
    182e:	4505                	li	a0,1
    1830:	00004097          	auipc	ra,0x4
    1834:	67a080e7          	jalr	1658(ra) # 5eaa <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1838:	20100593          	li	a1,513
    183c:	00005517          	auipc	a0,0x5
    1840:	4e450513          	addi	a0,a0,1252 # 6d20 <malloc+0xa54>
    1844:	00004097          	auipc	ra,0x4
    1848:	67e080e7          	jalr	1662(ra) # 5ec2 <open>
    if(fd < 0) {
    184c:	04054263          	bltz	a0,1890 <exectest+0xac>
    if(fd != 1) {
    1850:	4785                	li	a5,1
    1852:	04f50d63          	beq	a0,a5,18ac <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    1856:	85ca                	mv	a1,s2
    1858:	00005517          	auipc	a0,0x5
    185c:	4e850513          	addi	a0,a0,1256 # 6d40 <malloc+0xa74>
    1860:	00005097          	auipc	ra,0x5
    1864:	9b0080e7          	jalr	-1616(ra) # 6210 <printf>
      exit(1);
    1868:	4505                	li	a0,1
    186a:	00004097          	auipc	ra,0x4
    186e:	618080e7          	jalr	1560(ra) # 5e82 <exit>
    1872:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    1874:	85ca                	mv	a1,s2
    1876:	00005517          	auipc	a0,0x5
    187a:	41a50513          	addi	a0,a0,1050 # 6c90 <malloc+0x9c4>
    187e:	00005097          	auipc	ra,0x5
    1882:	992080e7          	jalr	-1646(ra) # 6210 <printf>
     exit(1);
    1886:	4505                	li	a0,1
    1888:	00004097          	auipc	ra,0x4
    188c:	5fa080e7          	jalr	1530(ra) # 5e82 <exit>
      printf("%s: create failed\n", s);
    1890:	85ca                	mv	a1,s2
    1892:	00005517          	auipc	a0,0x5
    1896:	49650513          	addi	a0,a0,1174 # 6d28 <malloc+0xa5c>
    189a:	00005097          	auipc	ra,0x5
    189e:	976080e7          	jalr	-1674(ra) # 6210 <printf>
      exit(1);
    18a2:	4505                	li	a0,1
    18a4:	00004097          	auipc	ra,0x4
    18a8:	5de080e7          	jalr	1502(ra) # 5e82 <exit>
    if(exec("echo", echoargv) < 0){
    18ac:	fc040593          	addi	a1,s0,-64
    18b0:	00005517          	auipc	a0,0x5
    18b4:	b5850513          	addi	a0,a0,-1192 # 6408 <malloc+0x13c>
    18b8:	00004097          	auipc	ra,0x4
    18bc:	602080e7          	jalr	1538(ra) # 5eba <exec>
    18c0:	02054163          	bltz	a0,18e2 <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    18c4:	fdc40513          	addi	a0,s0,-36
    18c8:	00004097          	auipc	ra,0x4
    18cc:	5c2080e7          	jalr	1474(ra) # 5e8a <wait>
    18d0:	02951763          	bne	a0,s1,18fe <exectest+0x11a>
  if(xstatus != 0)
    18d4:	fdc42503          	lw	a0,-36(s0)
    18d8:	cd0d                	beqz	a0,1912 <exectest+0x12e>
    exit(xstatus);
    18da:	00004097          	auipc	ra,0x4
    18de:	5a8080e7          	jalr	1448(ra) # 5e82 <exit>
      printf("%s: exec echo failed\n", s);
    18e2:	85ca                	mv	a1,s2
    18e4:	00005517          	auipc	a0,0x5
    18e8:	46c50513          	addi	a0,a0,1132 # 6d50 <malloc+0xa84>
    18ec:	00005097          	auipc	ra,0x5
    18f0:	924080e7          	jalr	-1756(ra) # 6210 <printf>
      exit(1);
    18f4:	4505                	li	a0,1
    18f6:	00004097          	auipc	ra,0x4
    18fa:	58c080e7          	jalr	1420(ra) # 5e82 <exit>
    printf("%s: wait failed!\n", s);
    18fe:	85ca                	mv	a1,s2
    1900:	00005517          	auipc	a0,0x5
    1904:	46850513          	addi	a0,a0,1128 # 6d68 <malloc+0xa9c>
    1908:	00005097          	auipc	ra,0x5
    190c:	908080e7          	jalr	-1784(ra) # 6210 <printf>
    1910:	b7d1                	j	18d4 <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    1912:	4581                	li	a1,0
    1914:	00005517          	auipc	a0,0x5
    1918:	40c50513          	addi	a0,a0,1036 # 6d20 <malloc+0xa54>
    191c:	00004097          	auipc	ra,0x4
    1920:	5a6080e7          	jalr	1446(ra) # 5ec2 <open>
  if(fd < 0) {
    1924:	02054a63          	bltz	a0,1958 <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    1928:	4609                	li	a2,2
    192a:	fb840593          	addi	a1,s0,-72
    192e:	00004097          	auipc	ra,0x4
    1932:	56c080e7          	jalr	1388(ra) # 5e9a <read>
    1936:	4789                	li	a5,2
    1938:	02f50e63          	beq	a0,a5,1974 <exectest+0x190>
    printf("%s: read failed\n", s);
    193c:	85ca                	mv	a1,s2
    193e:	00005517          	auipc	a0,0x5
    1942:	e9a50513          	addi	a0,a0,-358 # 67d8 <malloc+0x50c>
    1946:	00005097          	auipc	ra,0x5
    194a:	8ca080e7          	jalr	-1846(ra) # 6210 <printf>
    exit(1);
    194e:	4505                	li	a0,1
    1950:	00004097          	auipc	ra,0x4
    1954:	532080e7          	jalr	1330(ra) # 5e82 <exit>
    printf("%s: open failed\n", s);
    1958:	85ca                	mv	a1,s2
    195a:	00005517          	auipc	a0,0x5
    195e:	34e50513          	addi	a0,a0,846 # 6ca8 <malloc+0x9dc>
    1962:	00005097          	auipc	ra,0x5
    1966:	8ae080e7          	jalr	-1874(ra) # 6210 <printf>
    exit(1);
    196a:	4505                	li	a0,1
    196c:	00004097          	auipc	ra,0x4
    1970:	516080e7          	jalr	1302(ra) # 5e82 <exit>
  unlink("echo-ok");
    1974:	00005517          	auipc	a0,0x5
    1978:	3ac50513          	addi	a0,a0,940 # 6d20 <malloc+0xa54>
    197c:	00004097          	auipc	ra,0x4
    1980:	556080e7          	jalr	1366(ra) # 5ed2 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1984:	fb844703          	lbu	a4,-72(s0)
    1988:	04f00793          	li	a5,79
    198c:	00f71863          	bne	a4,a5,199c <exectest+0x1b8>
    1990:	fb944703          	lbu	a4,-71(s0)
    1994:	04b00793          	li	a5,75
    1998:	02f70063          	beq	a4,a5,19b8 <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    199c:	85ca                	mv	a1,s2
    199e:	00005517          	auipc	a0,0x5
    19a2:	3e250513          	addi	a0,a0,994 # 6d80 <malloc+0xab4>
    19a6:	00005097          	auipc	ra,0x5
    19aa:	86a080e7          	jalr	-1942(ra) # 6210 <printf>
    exit(1);
    19ae:	4505                	li	a0,1
    19b0:	00004097          	auipc	ra,0x4
    19b4:	4d2080e7          	jalr	1234(ra) # 5e82 <exit>
    exit(0);
    19b8:	4501                	li	a0,0
    19ba:	00004097          	auipc	ra,0x4
    19be:	4c8080e7          	jalr	1224(ra) # 5e82 <exit>

00000000000019c2 <pipe1>:
{
    19c2:	711d                	addi	sp,sp,-96
    19c4:	ec86                	sd	ra,88(sp)
    19c6:	e8a2                	sd	s0,80(sp)
    19c8:	e862                	sd	s8,16(sp)
    19ca:	1080                	addi	s0,sp,96
    19cc:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    19ce:	fa840513          	addi	a0,s0,-88
    19d2:	00004097          	auipc	ra,0x4
    19d6:	4c0080e7          	jalr	1216(ra) # 5e92 <pipe>
    19da:	ed35                	bnez	a0,1a56 <pipe1+0x94>
    19dc:	e4a6                	sd	s1,72(sp)
    19de:	fc4e                	sd	s3,56(sp)
    19e0:	84aa                	mv	s1,a0
  pid = fork();
    19e2:	00004097          	auipc	ra,0x4
    19e6:	498080e7          	jalr	1176(ra) # 5e7a <fork>
    19ea:	89aa                	mv	s3,a0
  if(pid == 0){
    19ec:	c951                	beqz	a0,1a80 <pipe1+0xbe>
  } else if(pid > 0){
    19ee:	18a05d63          	blez	a0,1b88 <pipe1+0x1c6>
    19f2:	e0ca                	sd	s2,64(sp)
    19f4:	f852                	sd	s4,48(sp)
    close(fds[1]);
    19f6:	fac42503          	lw	a0,-84(s0)
    19fa:	00004097          	auipc	ra,0x4
    19fe:	4b0080e7          	jalr	1200(ra) # 5eaa <close>
    total = 0;
    1a02:	89a6                	mv	s3,s1
    cc = 1;
    1a04:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1a06:	0000ba17          	auipc	s4,0xb
    1a0a:	272a0a13          	addi	s4,s4,626 # cc78 <buf>
    1a0e:	864a                	mv	a2,s2
    1a10:	85d2                	mv	a1,s4
    1a12:	fa842503          	lw	a0,-88(s0)
    1a16:	00004097          	auipc	ra,0x4
    1a1a:	484080e7          	jalr	1156(ra) # 5e9a <read>
    1a1e:	85aa                	mv	a1,a0
    1a20:	10a05963          	blez	a0,1b32 <pipe1+0x170>
    1a24:	0000b797          	auipc	a5,0xb
    1a28:	25478793          	addi	a5,a5,596 # cc78 <buf>
    1a2c:	00b4863b          	addw	a2,s1,a1
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1a30:	0007c683          	lbu	a3,0(a5)
    1a34:	0ff4f713          	zext.b	a4,s1
    1a38:	0ce69b63          	bne	a3,a4,1b0e <pipe1+0x14c>
    1a3c:	2485                	addiw	s1,s1,1
      for(i = 0; i < n; i++){
    1a3e:	0785                	addi	a5,a5,1
    1a40:	fec498e3          	bne	s1,a2,1a30 <pipe1+0x6e>
      total += n;
    1a44:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    1a48:	0019191b          	slliw	s2,s2,0x1
      if(cc > sizeof(buf))
    1a4c:	678d                	lui	a5,0x3
    1a4e:	fd27f0e3          	bgeu	a5,s2,1a0e <pipe1+0x4c>
        cc = sizeof(buf);
    1a52:	893e                	mv	s2,a5
    1a54:	bf6d                	j	1a0e <pipe1+0x4c>
    1a56:	e4a6                	sd	s1,72(sp)
    1a58:	e0ca                	sd	s2,64(sp)
    1a5a:	fc4e                	sd	s3,56(sp)
    1a5c:	f852                	sd	s4,48(sp)
    1a5e:	f456                	sd	s5,40(sp)
    1a60:	f05a                	sd	s6,32(sp)
    1a62:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    1a64:	85e2                	mv	a1,s8
    1a66:	00005517          	auipc	a0,0x5
    1a6a:	33250513          	addi	a0,a0,818 # 6d98 <malloc+0xacc>
    1a6e:	00004097          	auipc	ra,0x4
    1a72:	7a2080e7          	jalr	1954(ra) # 6210 <printf>
    exit(1);
    1a76:	4505                	li	a0,1
    1a78:	00004097          	auipc	ra,0x4
    1a7c:	40a080e7          	jalr	1034(ra) # 5e82 <exit>
    1a80:	e0ca                	sd	s2,64(sp)
    1a82:	f852                	sd	s4,48(sp)
    1a84:	f456                	sd	s5,40(sp)
    1a86:	f05a                	sd	s6,32(sp)
    1a88:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1a8a:	fa842503          	lw	a0,-88(s0)
    1a8e:	00004097          	auipc	ra,0x4
    1a92:	41c080e7          	jalr	1052(ra) # 5eaa <close>
    for(n = 0; n < N; n++){
    1a96:	0000bb17          	auipc	s6,0xb
    1a9a:	1e2b0b13          	addi	s6,s6,482 # cc78 <buf>
    1a9e:	416004bb          	negw	s1,s6
    1aa2:	0ff4f493          	zext.b	s1,s1
    1aa6:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1aaa:	40900a13          	li	s4,1033
    1aae:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1ab0:	6a85                	lui	s5,0x1
    1ab2:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x31>
{
    1ab6:	87da                	mv	a5,s6
        buf[i] = seq++;
    1ab8:	0097873b          	addw	a4,a5,s1
    1abc:	00e78023          	sb	a4,0(a5) # 3000 <sbrklast+0x44>
      for(i = 0; i < SZ; i++)
    1ac0:	0785                	addi	a5,a5,1
    1ac2:	ff279be3          	bne	a5,s2,1ab8 <pipe1+0xf6>
      if(write(fds[1], buf, SZ) != SZ){
    1ac6:	8652                	mv	a2,s4
    1ac8:	85de                	mv	a1,s7
    1aca:	fac42503          	lw	a0,-84(s0)
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	3d4080e7          	jalr	980(ra) # 5ea2 <write>
    1ad6:	01451e63          	bne	a0,s4,1af2 <pipe1+0x130>
    1ada:	4099899b          	addiw	s3,s3,1033
    for(n = 0; n < N; n++){
    1ade:	24a5                	addiw	s1,s1,9
    1ae0:	0ff4f493          	zext.b	s1,s1
    1ae4:	fd5999e3          	bne	s3,s5,1ab6 <pipe1+0xf4>
    exit(0);
    1ae8:	4501                	li	a0,0
    1aea:	00004097          	auipc	ra,0x4
    1aee:	398080e7          	jalr	920(ra) # 5e82 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1af2:	85e2                	mv	a1,s8
    1af4:	00005517          	auipc	a0,0x5
    1af8:	2bc50513          	addi	a0,a0,700 # 6db0 <malloc+0xae4>
    1afc:	00004097          	auipc	ra,0x4
    1b00:	714080e7          	jalr	1812(ra) # 6210 <printf>
        exit(1);
    1b04:	4505                	li	a0,1
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	37c080e7          	jalr	892(ra) # 5e82 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1b0e:	85e2                	mv	a1,s8
    1b10:	00005517          	auipc	a0,0x5
    1b14:	2b850513          	addi	a0,a0,696 # 6dc8 <malloc+0xafc>
    1b18:	00004097          	auipc	ra,0x4
    1b1c:	6f8080e7          	jalr	1784(ra) # 6210 <printf>
          return;
    1b20:	64a6                	ld	s1,72(sp)
    1b22:	6906                	ld	s2,64(sp)
    1b24:	79e2                	ld	s3,56(sp)
    1b26:	7a42                	ld	s4,48(sp)
}
    1b28:	60e6                	ld	ra,88(sp)
    1b2a:	6446                	ld	s0,80(sp)
    1b2c:	6c42                	ld	s8,16(sp)
    1b2e:	6125                	addi	sp,sp,96
    1b30:	8082                	ret
    if(total != N * SZ){
    1b32:	6785                	lui	a5,0x1
    1b34:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x31>
    1b38:	02f98363          	beq	s3,a5,1b5e <pipe1+0x19c>
    1b3c:	f456                	sd	s5,40(sp)
    1b3e:	f05a                	sd	s6,32(sp)
    1b40:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    1b42:	85ce                	mv	a1,s3
    1b44:	00005517          	auipc	a0,0x5
    1b48:	29c50513          	addi	a0,a0,668 # 6de0 <malloc+0xb14>
    1b4c:	00004097          	auipc	ra,0x4
    1b50:	6c4080e7          	jalr	1732(ra) # 6210 <printf>
      exit(1);
    1b54:	4505                	li	a0,1
    1b56:	00004097          	auipc	ra,0x4
    1b5a:	32c080e7          	jalr	812(ra) # 5e82 <exit>
    1b5e:	f456                	sd	s5,40(sp)
    1b60:	f05a                	sd	s6,32(sp)
    1b62:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1b64:	fa842503          	lw	a0,-88(s0)
    1b68:	00004097          	auipc	ra,0x4
    1b6c:	342080e7          	jalr	834(ra) # 5eaa <close>
    wait(&xstatus);
    1b70:	fa440513          	addi	a0,s0,-92
    1b74:	00004097          	auipc	ra,0x4
    1b78:	316080e7          	jalr	790(ra) # 5e8a <wait>
    exit(xstatus);
    1b7c:	fa442503          	lw	a0,-92(s0)
    1b80:	00004097          	auipc	ra,0x4
    1b84:	302080e7          	jalr	770(ra) # 5e82 <exit>
    1b88:	e0ca                	sd	s2,64(sp)
    1b8a:	f852                	sd	s4,48(sp)
    1b8c:	f456                	sd	s5,40(sp)
    1b8e:	f05a                	sd	s6,32(sp)
    1b90:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1b92:	85e2                	mv	a1,s8
    1b94:	00005517          	auipc	a0,0x5
    1b98:	26c50513          	addi	a0,a0,620 # 6e00 <malloc+0xb34>
    1b9c:	00004097          	auipc	ra,0x4
    1ba0:	674080e7          	jalr	1652(ra) # 6210 <printf>
    exit(1);
    1ba4:	4505                	li	a0,1
    1ba6:	00004097          	auipc	ra,0x4
    1baa:	2dc080e7          	jalr	732(ra) # 5e82 <exit>

0000000000001bae <exitwait>:
{
    1bae:	715d                	addi	sp,sp,-80
    1bb0:	e486                	sd	ra,72(sp)
    1bb2:	e0a2                	sd	s0,64(sp)
    1bb4:	fc26                	sd	s1,56(sp)
    1bb6:	f84a                	sd	s2,48(sp)
    1bb8:	f44e                	sd	s3,40(sp)
    1bba:	f052                	sd	s4,32(sp)
    1bbc:	ec56                	sd	s5,24(sp)
    1bbe:	0880                	addi	s0,sp,80
    1bc0:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    1bc2:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    1bc4:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    1bc8:	06400a13          	li	s4,100
    pid = fork();
    1bcc:	00004097          	auipc	ra,0x4
    1bd0:	2ae080e7          	jalr	686(ra) # 5e7a <fork>
    1bd4:	84aa                	mv	s1,a0
    if(pid < 0){
    1bd6:	02054a63          	bltz	a0,1c0a <exitwait+0x5c>
    if(pid){
    1bda:	c151                	beqz	a0,1c5e <exitwait+0xb0>
      if(wait(&xstate) != pid){
    1bdc:	854e                	mv	a0,s3
    1bde:	00004097          	auipc	ra,0x4
    1be2:	2ac080e7          	jalr	684(ra) # 5e8a <wait>
    1be6:	04951063          	bne	a0,s1,1c26 <exitwait+0x78>
      if(i != xstate) {
    1bea:	fbc42783          	lw	a5,-68(s0)
    1bee:	05279a63          	bne	a5,s2,1c42 <exitwait+0x94>
  for(i = 0; i < 100; i++){
    1bf2:	2905                	addiw	s2,s2,1
    1bf4:	fd491ce3          	bne	s2,s4,1bcc <exitwait+0x1e>
}
    1bf8:	60a6                	ld	ra,72(sp)
    1bfa:	6406                	ld	s0,64(sp)
    1bfc:	74e2                	ld	s1,56(sp)
    1bfe:	7942                	ld	s2,48(sp)
    1c00:	79a2                	ld	s3,40(sp)
    1c02:	7a02                	ld	s4,32(sp)
    1c04:	6ae2                	ld	s5,24(sp)
    1c06:	6161                	addi	sp,sp,80
    1c08:	8082                	ret
      printf("%s: fork failed\n", s);
    1c0a:	85d6                	mv	a1,s5
    1c0c:	00005517          	auipc	a0,0x5
    1c10:	08450513          	addi	a0,a0,132 # 6c90 <malloc+0x9c4>
    1c14:	00004097          	auipc	ra,0x4
    1c18:	5fc080e7          	jalr	1532(ra) # 6210 <printf>
      exit(1);
    1c1c:	4505                	li	a0,1
    1c1e:	00004097          	auipc	ra,0x4
    1c22:	264080e7          	jalr	612(ra) # 5e82 <exit>
        printf("%s: wait wrong pid\n", s);
    1c26:	85d6                	mv	a1,s5
    1c28:	00005517          	auipc	a0,0x5
    1c2c:	1f050513          	addi	a0,a0,496 # 6e18 <malloc+0xb4c>
    1c30:	00004097          	auipc	ra,0x4
    1c34:	5e0080e7          	jalr	1504(ra) # 6210 <printf>
        exit(1);
    1c38:	4505                	li	a0,1
    1c3a:	00004097          	auipc	ra,0x4
    1c3e:	248080e7          	jalr	584(ra) # 5e82 <exit>
        printf("%s: wait wrong exit status\n", s);
    1c42:	85d6                	mv	a1,s5
    1c44:	00005517          	auipc	a0,0x5
    1c48:	1ec50513          	addi	a0,a0,492 # 6e30 <malloc+0xb64>
    1c4c:	00004097          	auipc	ra,0x4
    1c50:	5c4080e7          	jalr	1476(ra) # 6210 <printf>
        exit(1);
    1c54:	4505                	li	a0,1
    1c56:	00004097          	auipc	ra,0x4
    1c5a:	22c080e7          	jalr	556(ra) # 5e82 <exit>
      exit(i);
    1c5e:	854a                	mv	a0,s2
    1c60:	00004097          	auipc	ra,0x4
    1c64:	222080e7          	jalr	546(ra) # 5e82 <exit>

0000000000001c68 <twochildren>:
{
    1c68:	1101                	addi	sp,sp,-32
    1c6a:	ec06                	sd	ra,24(sp)
    1c6c:	e822                	sd	s0,16(sp)
    1c6e:	e426                	sd	s1,8(sp)
    1c70:	e04a                	sd	s2,0(sp)
    1c72:	1000                	addi	s0,sp,32
    1c74:	892a                	mv	s2,a0
    1c76:	3e800493          	li	s1,1000
    int pid1 = fork();
    1c7a:	00004097          	auipc	ra,0x4
    1c7e:	200080e7          	jalr	512(ra) # 5e7a <fork>
    if(pid1 < 0){
    1c82:	02054c63          	bltz	a0,1cba <twochildren+0x52>
    if(pid1 == 0){
    1c86:	c921                	beqz	a0,1cd6 <twochildren+0x6e>
      int pid2 = fork();
    1c88:	00004097          	auipc	ra,0x4
    1c8c:	1f2080e7          	jalr	498(ra) # 5e7a <fork>
      if(pid2 < 0){
    1c90:	04054763          	bltz	a0,1cde <twochildren+0x76>
      if(pid2 == 0){
    1c94:	c13d                	beqz	a0,1cfa <twochildren+0x92>
        wait(0);
    1c96:	4501                	li	a0,0
    1c98:	00004097          	auipc	ra,0x4
    1c9c:	1f2080e7          	jalr	498(ra) # 5e8a <wait>
        wait(0);
    1ca0:	4501                	li	a0,0
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	1e8080e7          	jalr	488(ra) # 5e8a <wait>
  for(int i = 0; i < 1000; i++){
    1caa:	34fd                	addiw	s1,s1,-1
    1cac:	f4f9                	bnez	s1,1c7a <twochildren+0x12>
}
    1cae:	60e2                	ld	ra,24(sp)
    1cb0:	6442                	ld	s0,16(sp)
    1cb2:	64a2                	ld	s1,8(sp)
    1cb4:	6902                	ld	s2,0(sp)
    1cb6:	6105                	addi	sp,sp,32
    1cb8:	8082                	ret
      printf("%s: fork failed\n", s);
    1cba:	85ca                	mv	a1,s2
    1cbc:	00005517          	auipc	a0,0x5
    1cc0:	fd450513          	addi	a0,a0,-44 # 6c90 <malloc+0x9c4>
    1cc4:	00004097          	auipc	ra,0x4
    1cc8:	54c080e7          	jalr	1356(ra) # 6210 <printf>
      exit(1);
    1ccc:	4505                	li	a0,1
    1cce:	00004097          	auipc	ra,0x4
    1cd2:	1b4080e7          	jalr	436(ra) # 5e82 <exit>
      exit(0);
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	1ac080e7          	jalr	428(ra) # 5e82 <exit>
        printf("%s: fork failed\n", s);
    1cde:	85ca                	mv	a1,s2
    1ce0:	00005517          	auipc	a0,0x5
    1ce4:	fb050513          	addi	a0,a0,-80 # 6c90 <malloc+0x9c4>
    1ce8:	00004097          	auipc	ra,0x4
    1cec:	528080e7          	jalr	1320(ra) # 6210 <printf>
        exit(1);
    1cf0:	4505                	li	a0,1
    1cf2:	00004097          	auipc	ra,0x4
    1cf6:	190080e7          	jalr	400(ra) # 5e82 <exit>
        exit(0);
    1cfa:	00004097          	auipc	ra,0x4
    1cfe:	188080e7          	jalr	392(ra) # 5e82 <exit>

0000000000001d02 <forkfork>:
{
    1d02:	7179                	addi	sp,sp,-48
    1d04:	f406                	sd	ra,40(sp)
    1d06:	f022                	sd	s0,32(sp)
    1d08:	ec26                	sd	s1,24(sp)
    1d0a:	1800                	addi	s0,sp,48
    1d0c:	84aa                	mv	s1,a0
    int pid = fork();
    1d0e:	00004097          	auipc	ra,0x4
    1d12:	16c080e7          	jalr	364(ra) # 5e7a <fork>
    if(pid < 0){
    1d16:	04054163          	bltz	a0,1d58 <forkfork+0x56>
    if(pid == 0){
    1d1a:	cd29                	beqz	a0,1d74 <forkfork+0x72>
    int pid = fork();
    1d1c:	00004097          	auipc	ra,0x4
    1d20:	15e080e7          	jalr	350(ra) # 5e7a <fork>
    if(pid < 0){
    1d24:	02054a63          	bltz	a0,1d58 <forkfork+0x56>
    if(pid == 0){
    1d28:	c531                	beqz	a0,1d74 <forkfork+0x72>
    wait(&xstatus);
    1d2a:	fdc40513          	addi	a0,s0,-36
    1d2e:	00004097          	auipc	ra,0x4
    1d32:	15c080e7          	jalr	348(ra) # 5e8a <wait>
    if(xstatus != 0) {
    1d36:	fdc42783          	lw	a5,-36(s0)
    1d3a:	ebbd                	bnez	a5,1db0 <forkfork+0xae>
    wait(&xstatus);
    1d3c:	fdc40513          	addi	a0,s0,-36
    1d40:	00004097          	auipc	ra,0x4
    1d44:	14a080e7          	jalr	330(ra) # 5e8a <wait>
    if(xstatus != 0) {
    1d48:	fdc42783          	lw	a5,-36(s0)
    1d4c:	e3b5                	bnez	a5,1db0 <forkfork+0xae>
}
    1d4e:	70a2                	ld	ra,40(sp)
    1d50:	7402                	ld	s0,32(sp)
    1d52:	64e2                	ld	s1,24(sp)
    1d54:	6145                	addi	sp,sp,48
    1d56:	8082                	ret
      printf("%s: fork failed", s);
    1d58:	85a6                	mv	a1,s1
    1d5a:	00005517          	auipc	a0,0x5
    1d5e:	0f650513          	addi	a0,a0,246 # 6e50 <malloc+0xb84>
    1d62:	00004097          	auipc	ra,0x4
    1d66:	4ae080e7          	jalr	1198(ra) # 6210 <printf>
      exit(1);
    1d6a:	4505                	li	a0,1
    1d6c:	00004097          	auipc	ra,0x4
    1d70:	116080e7          	jalr	278(ra) # 5e82 <exit>
{
    1d74:	0c800493          	li	s1,200
        int pid1 = fork();
    1d78:	00004097          	auipc	ra,0x4
    1d7c:	102080e7          	jalr	258(ra) # 5e7a <fork>
        if(pid1 < 0){
    1d80:	00054f63          	bltz	a0,1d9e <forkfork+0x9c>
        if(pid1 == 0){
    1d84:	c115                	beqz	a0,1da8 <forkfork+0xa6>
        wait(0);
    1d86:	4501                	li	a0,0
    1d88:	00004097          	auipc	ra,0x4
    1d8c:	102080e7          	jalr	258(ra) # 5e8a <wait>
      for(int j = 0; j < 200; j++){
    1d90:	34fd                	addiw	s1,s1,-1
    1d92:	f0fd                	bnez	s1,1d78 <forkfork+0x76>
      exit(0);
    1d94:	4501                	li	a0,0
    1d96:	00004097          	auipc	ra,0x4
    1d9a:	0ec080e7          	jalr	236(ra) # 5e82 <exit>
          exit(1);
    1d9e:	4505                	li	a0,1
    1da0:	00004097          	auipc	ra,0x4
    1da4:	0e2080e7          	jalr	226(ra) # 5e82 <exit>
          exit(0);
    1da8:	00004097          	auipc	ra,0x4
    1dac:	0da080e7          	jalr	218(ra) # 5e82 <exit>
      printf("%s: fork in child failed", s);
    1db0:	85a6                	mv	a1,s1
    1db2:	00005517          	auipc	a0,0x5
    1db6:	0ae50513          	addi	a0,a0,174 # 6e60 <malloc+0xb94>
    1dba:	00004097          	auipc	ra,0x4
    1dbe:	456080e7          	jalr	1110(ra) # 6210 <printf>
      exit(1);
    1dc2:	4505                	li	a0,1
    1dc4:	00004097          	auipc	ra,0x4
    1dc8:	0be080e7          	jalr	190(ra) # 5e82 <exit>

0000000000001dcc <reparent2>:
{
    1dcc:	1101                	addi	sp,sp,-32
    1dce:	ec06                	sd	ra,24(sp)
    1dd0:	e822                	sd	s0,16(sp)
    1dd2:	e426                	sd	s1,8(sp)
    1dd4:	1000                	addi	s0,sp,32
    1dd6:	32000493          	li	s1,800
    int pid1 = fork();
    1dda:	00004097          	auipc	ra,0x4
    1dde:	0a0080e7          	jalr	160(ra) # 5e7a <fork>
    if(pid1 < 0){
    1de2:	00054f63          	bltz	a0,1e00 <reparent2+0x34>
    if(pid1 == 0){
    1de6:	c915                	beqz	a0,1e1a <reparent2+0x4e>
    wait(0);
    1de8:	4501                	li	a0,0
    1dea:	00004097          	auipc	ra,0x4
    1dee:	0a0080e7          	jalr	160(ra) # 5e8a <wait>
  for(int i = 0; i < 800; i++){
    1df2:	34fd                	addiw	s1,s1,-1
    1df4:	f0fd                	bnez	s1,1dda <reparent2+0xe>
  exit(0);
    1df6:	4501                	li	a0,0
    1df8:	00004097          	auipc	ra,0x4
    1dfc:	08a080e7          	jalr	138(ra) # 5e82 <exit>
      printf("fork failed\n");
    1e00:	00005517          	auipc	a0,0x5
    1e04:	29850513          	addi	a0,a0,664 # 7098 <malloc+0xdcc>
    1e08:	00004097          	auipc	ra,0x4
    1e0c:	408080e7          	jalr	1032(ra) # 6210 <printf>
      exit(1);
    1e10:	4505                	li	a0,1
    1e12:	00004097          	auipc	ra,0x4
    1e16:	070080e7          	jalr	112(ra) # 5e82 <exit>
      fork();
    1e1a:	00004097          	auipc	ra,0x4
    1e1e:	060080e7          	jalr	96(ra) # 5e7a <fork>
      fork();
    1e22:	00004097          	auipc	ra,0x4
    1e26:	058080e7          	jalr	88(ra) # 5e7a <fork>
      exit(0);
    1e2a:	4501                	li	a0,0
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	056080e7          	jalr	86(ra) # 5e82 <exit>

0000000000001e34 <createdelete>:
{
    1e34:	7135                	addi	sp,sp,-160
    1e36:	ed06                	sd	ra,152(sp)
    1e38:	e922                	sd	s0,144(sp)
    1e3a:	e526                	sd	s1,136(sp)
    1e3c:	e14a                	sd	s2,128(sp)
    1e3e:	fcce                	sd	s3,120(sp)
    1e40:	f8d2                	sd	s4,112(sp)
    1e42:	f4d6                	sd	s5,104(sp)
    1e44:	f0da                	sd	s6,96(sp)
    1e46:	ecde                	sd	s7,88(sp)
    1e48:	e8e2                	sd	s8,80(sp)
    1e4a:	e4e6                	sd	s9,72(sp)
    1e4c:	e0ea                	sd	s10,64(sp)
    1e4e:	fc6e                	sd	s11,56(sp)
    1e50:	1100                	addi	s0,sp,160
    1e52:	8daa                	mv	s11,a0
  for(pi = 0; pi < NCHILD; pi++){
    1e54:	4901                	li	s2,0
    1e56:	4991                	li	s3,4
    pid = fork();
    1e58:	00004097          	auipc	ra,0x4
    1e5c:	022080e7          	jalr	34(ra) # 5e7a <fork>
    1e60:	84aa                	mv	s1,a0
    if(pid < 0){
    1e62:	04054263          	bltz	a0,1ea6 <createdelete+0x72>
    if(pid == 0){
    1e66:	cd31                	beqz	a0,1ec2 <createdelete+0x8e>
  for(pi = 0; pi < NCHILD; pi++){
    1e68:	2905                	addiw	s2,s2,1
    1e6a:	ff3917e3          	bne	s2,s3,1e58 <createdelete+0x24>
    1e6e:	4491                	li	s1,4
    wait(&xstatus);
    1e70:	f6c40913          	addi	s2,s0,-148
    1e74:	854a                	mv	a0,s2
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	014080e7          	jalr	20(ra) # 5e8a <wait>
    if(xstatus != 0)
    1e7e:	f6c42a83          	lw	s5,-148(s0)
    1e82:	0e0a9663          	bnez	s5,1f6e <createdelete+0x13a>
  for(pi = 0; pi < NCHILD; pi++){
    1e86:	34fd                	addiw	s1,s1,-1
    1e88:	f4f5                	bnez	s1,1e74 <createdelete+0x40>
  name[0] = name[1] = name[2] = 0;
    1e8a:	f6040923          	sb	zero,-142(s0)
    1e8e:	03000913          	li	s2,48
    1e92:	5a7d                	li	s4,-1
      if((i == 0 || i >= N/2) && fd < 0){
    1e94:	4d25                	li	s10,9
    1e96:	07000c93          	li	s9,112
      fd = open(name, 0);
    1e9a:	f7040c13          	addi	s8,s0,-144
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1e9e:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1ea0:	07400b13          	li	s6,116
    1ea4:	a28d                	j	2006 <createdelete+0x1d2>
      printf("fork failed\n", s);
    1ea6:	85ee                	mv	a1,s11
    1ea8:	00005517          	auipc	a0,0x5
    1eac:	1f050513          	addi	a0,a0,496 # 7098 <malloc+0xdcc>
    1eb0:	00004097          	auipc	ra,0x4
    1eb4:	360080e7          	jalr	864(ra) # 6210 <printf>
      exit(1);
    1eb8:	4505                	li	a0,1
    1eba:	00004097          	auipc	ra,0x4
    1ebe:	fc8080e7          	jalr	-56(ra) # 5e82 <exit>
      name[0] = 'p' + pi;
    1ec2:	0709091b          	addiw	s2,s2,112
    1ec6:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    1eca:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1ece:	f7040913          	addi	s2,s0,-144
    1ed2:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    1ed6:	4a51                	li	s4,20
    1ed8:	a081                	j	1f18 <createdelete+0xe4>
          printf("%s: create failed\n", s);
    1eda:	85ee                	mv	a1,s11
    1edc:	00005517          	auipc	a0,0x5
    1ee0:	e4c50513          	addi	a0,a0,-436 # 6d28 <malloc+0xa5c>
    1ee4:	00004097          	auipc	ra,0x4
    1ee8:	32c080e7          	jalr	812(ra) # 6210 <printf>
          exit(1);
    1eec:	4505                	li	a0,1
    1eee:	00004097          	auipc	ra,0x4
    1ef2:	f94080e7          	jalr	-108(ra) # 5e82 <exit>
          name[1] = '0' + (i / 2);
    1ef6:	01f4d79b          	srliw	a5,s1,0x1f
    1efa:	9fa5                	addw	a5,a5,s1
    1efc:	4017d79b          	sraiw	a5,a5,0x1
    1f00:	0307879b          	addiw	a5,a5,48
    1f04:	f6f408a3          	sb	a5,-143(s0)
          if(unlink(name) < 0){
    1f08:	854a                	mv	a0,s2
    1f0a:	00004097          	auipc	ra,0x4
    1f0e:	fc8080e7          	jalr	-56(ra) # 5ed2 <unlink>
    1f12:	04054063          	bltz	a0,1f52 <createdelete+0x11e>
      for(i = 0; i < N; i++){
    1f16:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1f18:	0304879b          	addiw	a5,s1,48
    1f1c:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1f20:	85ce                	mv	a1,s3
    1f22:	854a                	mv	a0,s2
    1f24:	00004097          	auipc	ra,0x4
    1f28:	f9e080e7          	jalr	-98(ra) # 5ec2 <open>
        if(fd < 0){
    1f2c:	fa0547e3          	bltz	a0,1eda <createdelete+0xa6>
        close(fd);
    1f30:	00004097          	auipc	ra,0x4
    1f34:	f7a080e7          	jalr	-134(ra) # 5eaa <close>
        if(i > 0 && (i % 2 ) == 0){
    1f38:	fc905fe3          	blez	s1,1f16 <createdelete+0xe2>
    1f3c:	0014f793          	andi	a5,s1,1
    1f40:	dbdd                	beqz	a5,1ef6 <createdelete+0xc2>
      for(i = 0; i < N; i++){
    1f42:	2485                	addiw	s1,s1,1
    1f44:	fd449ae3          	bne	s1,s4,1f18 <createdelete+0xe4>
      exit(0);
    1f48:	4501                	li	a0,0
    1f4a:	00004097          	auipc	ra,0x4
    1f4e:	f38080e7          	jalr	-200(ra) # 5e82 <exit>
            printf("%s: unlink failed\n", s);
    1f52:	85ee                	mv	a1,s11
    1f54:	00005517          	auipc	a0,0x5
    1f58:	f2c50513          	addi	a0,a0,-212 # 6e80 <malloc+0xbb4>
    1f5c:	00004097          	auipc	ra,0x4
    1f60:	2b4080e7          	jalr	692(ra) # 6210 <printf>
            exit(1);
    1f64:	4505                	li	a0,1
    1f66:	00004097          	auipc	ra,0x4
    1f6a:	f1c080e7          	jalr	-228(ra) # 5e82 <exit>
      exit(1);
    1f6e:	4505                	li	a0,1
    1f70:	00004097          	auipc	ra,0x4
    1f74:	f12080e7          	jalr	-238(ra) # 5e82 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f78:	054bf863          	bgeu	s7,s4,1fc8 <createdelete+0x194>
      if(fd >= 0)
    1f7c:	06055863          	bgez	a0,1fec <createdelete+0x1b8>
    for(pi = 0; pi < NCHILD; pi++){
    1f80:	2485                	addiw	s1,s1,1
    1f82:	0ff4f493          	zext.b	s1,s1
    1f86:	07648863          	beq	s1,s6,1ff6 <createdelete+0x1c2>
      name[0] = 'p' + pi;
    1f8a:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1f8e:	f72408a3          	sb	s2,-143(s0)
      fd = open(name, 0);
    1f92:	4581                	li	a1,0
    1f94:	8562                	mv	a0,s8
    1f96:	00004097          	auipc	ra,0x4
    1f9a:	f2c080e7          	jalr	-212(ra) # 5ec2 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1f9e:	01f5579b          	srliw	a5,a0,0x1f
    1fa2:	dbf9                	beqz	a5,1f78 <createdelete+0x144>
    1fa4:	fc098ae3          	beqz	s3,1f78 <createdelete+0x144>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1fa8:	f7040613          	addi	a2,s0,-144
    1fac:	85ee                	mv	a1,s11
    1fae:	00005517          	auipc	a0,0x5
    1fb2:	eea50513          	addi	a0,a0,-278 # 6e98 <malloc+0xbcc>
    1fb6:	00004097          	auipc	ra,0x4
    1fba:	25a080e7          	jalr	602(ra) # 6210 <printf>
        exit(1);
    1fbe:	4505                	li	a0,1
    1fc0:	00004097          	auipc	ra,0x4
    1fc4:	ec2080e7          	jalr	-318(ra) # 5e82 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1fc8:	fa054ce3          	bltz	a0,1f80 <createdelete+0x14c>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1fcc:	f7040613          	addi	a2,s0,-144
    1fd0:	85ee                	mv	a1,s11
    1fd2:	00005517          	auipc	a0,0x5
    1fd6:	eee50513          	addi	a0,a0,-274 # 6ec0 <malloc+0xbf4>
    1fda:	00004097          	auipc	ra,0x4
    1fde:	236080e7          	jalr	566(ra) # 6210 <printf>
        exit(1);
    1fe2:	4505                	li	a0,1
    1fe4:	00004097          	auipc	ra,0x4
    1fe8:	e9e080e7          	jalr	-354(ra) # 5e82 <exit>
        close(fd);
    1fec:	00004097          	auipc	ra,0x4
    1ff0:	ebe080e7          	jalr	-322(ra) # 5eaa <close>
    1ff4:	b771                	j	1f80 <createdelete+0x14c>
  for(i = 0; i < N; i++){
    1ff6:	2a85                	addiw	s5,s5,1
    1ff8:	2a05                	addiw	s4,s4,1
    1ffa:	2905                	addiw	s2,s2,1
    1ffc:	0ff97913          	zext.b	s2,s2
    2000:	47d1                	li	a5,20
    2002:	00fa8a63          	beq	s5,a5,2016 <createdelete+0x1e2>
      if((i == 0 || i >= N/2) && fd < 0){
    2006:	001ab993          	seqz	s3,s5
    200a:	015d27b3          	slt	a5,s10,s5
    200e:	00f9e9b3          	or	s3,s3,a5
    2012:	84e6                	mv	s1,s9
    2014:	bf9d                	j	1f8a <createdelete+0x156>
    2016:	03000993          	li	s3,48
    201a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    201e:	4b11                	li	s6,4
      unlink(name);
    2020:	f7040a13          	addi	s4,s0,-144
  for(i = 0; i < N; i++){
    2024:	08400a93          	li	s5,132
  name[0] = name[1] = name[2] = 0;
    2028:	84da                	mv	s1,s6
      name[0] = 'p' + i;
    202a:	f7240823          	sb	s2,-144(s0)
      name[1] = '0' + i;
    202e:	f73408a3          	sb	s3,-143(s0)
      unlink(name);
    2032:	8552                	mv	a0,s4
    2034:	00004097          	auipc	ra,0x4
    2038:	e9e080e7          	jalr	-354(ra) # 5ed2 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    203c:	34fd                	addiw	s1,s1,-1
    203e:	f4f5                	bnez	s1,202a <createdelete+0x1f6>
  for(i = 0; i < N; i++){
    2040:	2905                	addiw	s2,s2,1
    2042:	0ff97913          	zext.b	s2,s2
    2046:	2985                	addiw	s3,s3,1
    2048:	0ff9f993          	zext.b	s3,s3
    204c:	fd591ee3          	bne	s2,s5,2028 <createdelete+0x1f4>
}
    2050:	60ea                	ld	ra,152(sp)
    2052:	644a                	ld	s0,144(sp)
    2054:	64aa                	ld	s1,136(sp)
    2056:	690a                	ld	s2,128(sp)
    2058:	79e6                	ld	s3,120(sp)
    205a:	7a46                	ld	s4,112(sp)
    205c:	7aa6                	ld	s5,104(sp)
    205e:	7b06                	ld	s6,96(sp)
    2060:	6be6                	ld	s7,88(sp)
    2062:	6c46                	ld	s8,80(sp)
    2064:	6ca6                	ld	s9,72(sp)
    2066:	6d06                	ld	s10,64(sp)
    2068:	7de2                	ld	s11,56(sp)
    206a:	610d                	addi	sp,sp,160
    206c:	8082                	ret

000000000000206e <linkunlink>:
{
    206e:	711d                	addi	sp,sp,-96
    2070:	ec86                	sd	ra,88(sp)
    2072:	e8a2                	sd	s0,80(sp)
    2074:	e4a6                	sd	s1,72(sp)
    2076:	e0ca                	sd	s2,64(sp)
    2078:	fc4e                	sd	s3,56(sp)
    207a:	f852                	sd	s4,48(sp)
    207c:	f456                	sd	s5,40(sp)
    207e:	f05a                	sd	s6,32(sp)
    2080:	ec5e                	sd	s7,24(sp)
    2082:	e862                	sd	s8,16(sp)
    2084:	e466                	sd	s9,8(sp)
    2086:	e06a                	sd	s10,0(sp)
    2088:	1080                	addi	s0,sp,96
    208a:	84aa                	mv	s1,a0
  unlink("x");
    208c:	00004517          	auipc	a0,0x4
    2090:	3ec50513          	addi	a0,a0,1004 # 6478 <malloc+0x1ac>
    2094:	00004097          	auipc	ra,0x4
    2098:	e3e080e7          	jalr	-450(ra) # 5ed2 <unlink>
  pid = fork();
    209c:	00004097          	auipc	ra,0x4
    20a0:	dde080e7          	jalr	-546(ra) # 5e7a <fork>
  if(pid < 0){
    20a4:	04054363          	bltz	a0,20ea <linkunlink+0x7c>
    20a8:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    20aa:	06100913          	li	s2,97
    20ae:	c111                	beqz	a0,20b2 <linkunlink+0x44>
    20b0:	4905                	li	s2,1
    20b2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    20b6:	41c65ab7          	lui	s5,0x41c65
    20ba:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c551f5>
    20be:	6a0d                	lui	s4,0x3
    20c0:	039a0a1b          	addiw	s4,s4,57 # 3039 <sbrklast+0x7d>
    if((x % 3) == 0){
    20c4:	000ab9b7          	lui	s3,0xab
    20c8:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9ae33>
    20cc:	09b2                	slli	s3,s3,0xc
    20ce:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    20d2:	4b85                	li	s7,1
      unlink("x");
    20d4:	00004b17          	auipc	s6,0x4
    20d8:	3a4b0b13          	addi	s6,s6,932 # 6478 <malloc+0x1ac>
      link("cat", "x");
    20dc:	00005c97          	auipc	s9,0x5
    20e0:	e0cc8c93          	addi	s9,s9,-500 # 6ee8 <malloc+0xc1c>
      close(open("x", O_RDWR | O_CREATE));
    20e4:	20200c13          	li	s8,514
    20e8:	a089                	j	212a <linkunlink+0xbc>
    printf("%s: fork failed\n", s);
    20ea:	85a6                	mv	a1,s1
    20ec:	00005517          	auipc	a0,0x5
    20f0:	ba450513          	addi	a0,a0,-1116 # 6c90 <malloc+0x9c4>
    20f4:	00004097          	auipc	ra,0x4
    20f8:	11c080e7          	jalr	284(ra) # 6210 <printf>
    exit(1);
    20fc:	4505                	li	a0,1
    20fe:	00004097          	auipc	ra,0x4
    2102:	d84080e7          	jalr	-636(ra) # 5e82 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2106:	85e2                	mv	a1,s8
    2108:	855a                	mv	a0,s6
    210a:	00004097          	auipc	ra,0x4
    210e:	db8080e7          	jalr	-584(ra) # 5ec2 <open>
    2112:	00004097          	auipc	ra,0x4
    2116:	d98080e7          	jalr	-616(ra) # 5eaa <close>
    211a:	a031                	j	2126 <linkunlink+0xb8>
      unlink("x");
    211c:	855a                	mv	a0,s6
    211e:	00004097          	auipc	ra,0x4
    2122:	db4080e7          	jalr	-588(ra) # 5ed2 <unlink>
  for(i = 0; i < 100; i++){
    2126:	34fd                	addiw	s1,s1,-1
    2128:	c895                	beqz	s1,215c <linkunlink+0xee>
    x = x * 1103515245 + 12345;
    212a:	035907bb          	mulw	a5,s2,s5
    212e:	00fa07bb          	addw	a5,s4,a5
    2132:	893e                	mv	s2,a5
    if((x % 3) == 0){
    2134:	02079713          	slli	a4,a5,0x20
    2138:	9301                	srli	a4,a4,0x20
    213a:	03370733          	mul	a4,a4,s3
    213e:	9305                	srli	a4,a4,0x21
    2140:	0017169b          	slliw	a3,a4,0x1
    2144:	9f35                	addw	a4,a4,a3
    2146:	9f99                	subw	a5,a5,a4
    2148:	dfdd                	beqz	a5,2106 <linkunlink+0x98>
    } else if((x % 3) == 1){
    214a:	fd7799e3          	bne	a5,s7,211c <linkunlink+0xae>
      link("cat", "x");
    214e:	85da                	mv	a1,s6
    2150:	8566                	mv	a0,s9
    2152:	00004097          	auipc	ra,0x4
    2156:	d90080e7          	jalr	-624(ra) # 5ee2 <link>
    215a:	b7f1                	j	2126 <linkunlink+0xb8>
  if(pid)
    215c:	020d0563          	beqz	s10,2186 <linkunlink+0x118>
    wait(0);
    2160:	4501                	li	a0,0
    2162:	00004097          	auipc	ra,0x4
    2166:	d28080e7          	jalr	-728(ra) # 5e8a <wait>
}
    216a:	60e6                	ld	ra,88(sp)
    216c:	6446                	ld	s0,80(sp)
    216e:	64a6                	ld	s1,72(sp)
    2170:	6906                	ld	s2,64(sp)
    2172:	79e2                	ld	s3,56(sp)
    2174:	7a42                	ld	s4,48(sp)
    2176:	7aa2                	ld	s5,40(sp)
    2178:	7b02                	ld	s6,32(sp)
    217a:	6be2                	ld	s7,24(sp)
    217c:	6c42                	ld	s8,16(sp)
    217e:	6ca2                	ld	s9,8(sp)
    2180:	6d02                	ld	s10,0(sp)
    2182:	6125                	addi	sp,sp,96
    2184:	8082                	ret
    exit(0);
    2186:	4501                	li	a0,0
    2188:	00004097          	auipc	ra,0x4
    218c:	cfa080e7          	jalr	-774(ra) # 5e82 <exit>

0000000000002190 <forktest>:
{
    2190:	7179                	addi	sp,sp,-48
    2192:	f406                	sd	ra,40(sp)
    2194:	f022                	sd	s0,32(sp)
    2196:	ec26                	sd	s1,24(sp)
    2198:	e84a                	sd	s2,16(sp)
    219a:	e44e                	sd	s3,8(sp)
    219c:	1800                	addi	s0,sp,48
    219e:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    21a0:	4481                	li	s1,0
    21a2:	3e800913          	li	s2,1000
    pid = fork();
    21a6:	00004097          	auipc	ra,0x4
    21aa:	cd4080e7          	jalr	-812(ra) # 5e7a <fork>
    if(pid < 0)
    21ae:	08054263          	bltz	a0,2232 <forktest+0xa2>
    if(pid == 0)
    21b2:	c115                	beqz	a0,21d6 <forktest+0x46>
  for(n=0; n<N; n++){
    21b4:	2485                	addiw	s1,s1,1
    21b6:	ff2498e3          	bne	s1,s2,21a6 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    21ba:	85ce                	mv	a1,s3
    21bc:	00005517          	auipc	a0,0x5
    21c0:	d7c50513          	addi	a0,a0,-644 # 6f38 <malloc+0xc6c>
    21c4:	00004097          	auipc	ra,0x4
    21c8:	04c080e7          	jalr	76(ra) # 6210 <printf>
    exit(1);
    21cc:	4505                	li	a0,1
    21ce:	00004097          	auipc	ra,0x4
    21d2:	cb4080e7          	jalr	-844(ra) # 5e82 <exit>
      exit(0);
    21d6:	00004097          	auipc	ra,0x4
    21da:	cac080e7          	jalr	-852(ra) # 5e82 <exit>
    printf("%s: no fork at all!\n", s);
    21de:	85ce                	mv	a1,s3
    21e0:	00005517          	auipc	a0,0x5
    21e4:	d1050513          	addi	a0,a0,-752 # 6ef0 <malloc+0xc24>
    21e8:	00004097          	auipc	ra,0x4
    21ec:	028080e7          	jalr	40(ra) # 6210 <printf>
    exit(1);
    21f0:	4505                	li	a0,1
    21f2:	00004097          	auipc	ra,0x4
    21f6:	c90080e7          	jalr	-880(ra) # 5e82 <exit>
      printf("%s: wait stopped early\n", s);
    21fa:	85ce                	mv	a1,s3
    21fc:	00005517          	auipc	a0,0x5
    2200:	d0c50513          	addi	a0,a0,-756 # 6f08 <malloc+0xc3c>
    2204:	00004097          	auipc	ra,0x4
    2208:	00c080e7          	jalr	12(ra) # 6210 <printf>
      exit(1);
    220c:	4505                	li	a0,1
    220e:	00004097          	auipc	ra,0x4
    2212:	c74080e7          	jalr	-908(ra) # 5e82 <exit>
    printf("%s: wait got too many\n", s);
    2216:	85ce                	mv	a1,s3
    2218:	00005517          	auipc	a0,0x5
    221c:	d0850513          	addi	a0,a0,-760 # 6f20 <malloc+0xc54>
    2220:	00004097          	auipc	ra,0x4
    2224:	ff0080e7          	jalr	-16(ra) # 6210 <printf>
    exit(1);
    2228:	4505                	li	a0,1
    222a:	00004097          	auipc	ra,0x4
    222e:	c58080e7          	jalr	-936(ra) # 5e82 <exit>
  if (n == 0) {
    2232:	d4d5                	beqz	s1,21de <forktest+0x4e>
  for(; n > 0; n--){
    2234:	00905b63          	blez	s1,224a <forktest+0xba>
    if(wait(0) < 0){
    2238:	4501                	li	a0,0
    223a:	00004097          	auipc	ra,0x4
    223e:	c50080e7          	jalr	-944(ra) # 5e8a <wait>
    2242:	fa054ce3          	bltz	a0,21fa <forktest+0x6a>
  for(; n > 0; n--){
    2246:	34fd                	addiw	s1,s1,-1
    2248:	f8e5                	bnez	s1,2238 <forktest+0xa8>
  if(wait(0) != -1){
    224a:	4501                	li	a0,0
    224c:	00004097          	auipc	ra,0x4
    2250:	c3e080e7          	jalr	-962(ra) # 5e8a <wait>
    2254:	57fd                	li	a5,-1
    2256:	fcf510e3          	bne	a0,a5,2216 <forktest+0x86>
}
    225a:	70a2                	ld	ra,40(sp)
    225c:	7402                	ld	s0,32(sp)
    225e:	64e2                	ld	s1,24(sp)
    2260:	6942                	ld	s2,16(sp)
    2262:	69a2                	ld	s3,8(sp)
    2264:	6145                	addi	sp,sp,48
    2266:	8082                	ret

0000000000002268 <kernmem>:
{
    2268:	715d                	addi	sp,sp,-80
    226a:	e486                	sd	ra,72(sp)
    226c:	e0a2                	sd	s0,64(sp)
    226e:	fc26                	sd	s1,56(sp)
    2270:	f84a                	sd	s2,48(sp)
    2272:	f44e                	sd	s3,40(sp)
    2274:	f052                	sd	s4,32(sp)
    2276:	ec56                	sd	s5,24(sp)
    2278:	e85a                	sd	s6,16(sp)
    227a:	0880                	addi	s0,sp,80
    227c:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    227e:	4485                	li	s1,1
    2280:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    2282:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    2286:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2288:	69b1                	lui	s3,0xc
    228a:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    228e:	1003d937          	lui	s2,0x1003d
    2292:	090e                	slli	s2,s2,0x3
    2294:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    2298:	00004097          	auipc	ra,0x4
    229c:	be2080e7          	jalr	-1054(ra) # 5e7a <fork>
    if(pid < 0){
    22a0:	02054963          	bltz	a0,22d2 <kernmem+0x6a>
    if(pid == 0){
    22a4:	c529                	beqz	a0,22ee <kernmem+0x86>
    wait(&xstatus);
    22a6:	8556                	mv	a0,s5
    22a8:	00004097          	auipc	ra,0x4
    22ac:	be2080e7          	jalr	-1054(ra) # 5e8a <wait>
    if(xstatus != -1)  // did kernel kill child?
    22b0:	fbc42783          	lw	a5,-68(s0)
    22b4:	05479e63          	bne	a5,s4,2310 <kernmem+0xa8>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    22b8:	94ce                	add	s1,s1,s3
    22ba:	fd249fe3          	bne	s1,s2,2298 <kernmem+0x30>
}
    22be:	60a6                	ld	ra,72(sp)
    22c0:	6406                	ld	s0,64(sp)
    22c2:	74e2                	ld	s1,56(sp)
    22c4:	7942                	ld	s2,48(sp)
    22c6:	79a2                	ld	s3,40(sp)
    22c8:	7a02                	ld	s4,32(sp)
    22ca:	6ae2                	ld	s5,24(sp)
    22cc:	6b42                	ld	s6,16(sp)
    22ce:	6161                	addi	sp,sp,80
    22d0:	8082                	ret
      printf("%s: fork failed\n", s);
    22d2:	85da                	mv	a1,s6
    22d4:	00005517          	auipc	a0,0x5
    22d8:	9bc50513          	addi	a0,a0,-1604 # 6c90 <malloc+0x9c4>
    22dc:	00004097          	auipc	ra,0x4
    22e0:	f34080e7          	jalr	-204(ra) # 6210 <printf>
      exit(1);
    22e4:	4505                	li	a0,1
    22e6:	00004097          	auipc	ra,0x4
    22ea:	b9c080e7          	jalr	-1124(ra) # 5e82 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    22ee:	0004c683          	lbu	a3,0(s1)
    22f2:	8626                	mv	a2,s1
    22f4:	85da                	mv	a1,s6
    22f6:	00005517          	auipc	a0,0x5
    22fa:	c6a50513          	addi	a0,a0,-918 # 6f60 <malloc+0xc94>
    22fe:	00004097          	auipc	ra,0x4
    2302:	f12080e7          	jalr	-238(ra) # 6210 <printf>
      exit(1);
    2306:	4505                	li	a0,1
    2308:	00004097          	auipc	ra,0x4
    230c:	b7a080e7          	jalr	-1158(ra) # 5e82 <exit>
      exit(1);
    2310:	4505                	li	a0,1
    2312:	00004097          	auipc	ra,0x4
    2316:	b70080e7          	jalr	-1168(ra) # 5e82 <exit>

000000000000231a <MAXVAplus>:
{
    231a:	7139                	addi	sp,sp,-64
    231c:	fc06                	sd	ra,56(sp)
    231e:	f822                	sd	s0,48(sp)
    2320:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    2322:	4785                	li	a5,1
    2324:	179a                	slli	a5,a5,0x26
    2326:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    232a:	fc843783          	ld	a5,-56(s0)
    232e:	c3b9                	beqz	a5,2374 <MAXVAplus+0x5a>
    2330:	f426                	sd	s1,40(sp)
    2332:	f04a                	sd	s2,32(sp)
    2334:	ec4e                	sd	s3,24(sp)
    2336:	89aa                	mv	s3,a0
    wait(&xstatus);
    2338:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    233c:	54fd                	li	s1,-1
    pid = fork();
    233e:	00004097          	auipc	ra,0x4
    2342:	b3c080e7          	jalr	-1220(ra) # 5e7a <fork>
    if(pid < 0){
    2346:	02054b63          	bltz	a0,237c <MAXVAplus+0x62>
    if(pid == 0){
    234a:	c539                	beqz	a0,2398 <MAXVAplus+0x7e>
    wait(&xstatus);
    234c:	854a                	mv	a0,s2
    234e:	00004097          	auipc	ra,0x4
    2352:	b3c080e7          	jalr	-1220(ra) # 5e8a <wait>
    if(xstatus != -1)  // did kernel kill child?
    2356:	fc442783          	lw	a5,-60(s0)
    235a:	06979563          	bne	a5,s1,23c4 <MAXVAplus+0xaa>
  for( ; a != 0; a <<= 1){
    235e:	fc843783          	ld	a5,-56(s0)
    2362:	0786                	slli	a5,a5,0x1
    2364:	fcf43423          	sd	a5,-56(s0)
    2368:	fc843783          	ld	a5,-56(s0)
    236c:	fbe9                	bnez	a5,233e <MAXVAplus+0x24>
    236e:	74a2                	ld	s1,40(sp)
    2370:	7902                	ld	s2,32(sp)
    2372:	69e2                	ld	s3,24(sp)
}
    2374:	70e2                	ld	ra,56(sp)
    2376:	7442                	ld	s0,48(sp)
    2378:	6121                	addi	sp,sp,64
    237a:	8082                	ret
      printf("%s: fork failed\n", s);
    237c:	85ce                	mv	a1,s3
    237e:	00005517          	auipc	a0,0x5
    2382:	91250513          	addi	a0,a0,-1774 # 6c90 <malloc+0x9c4>
    2386:	00004097          	auipc	ra,0x4
    238a:	e8a080e7          	jalr	-374(ra) # 6210 <printf>
      exit(1);
    238e:	4505                	li	a0,1
    2390:	00004097          	auipc	ra,0x4
    2394:	af2080e7          	jalr	-1294(ra) # 5e82 <exit>
      *(char*)a = 99;
    2398:	fc843783          	ld	a5,-56(s0)
    239c:	06300713          	li	a4,99
    23a0:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    23a4:	fc843603          	ld	a2,-56(s0)
    23a8:	85ce                	mv	a1,s3
    23aa:	00005517          	auipc	a0,0x5
    23ae:	bd650513          	addi	a0,a0,-1066 # 6f80 <malloc+0xcb4>
    23b2:	00004097          	auipc	ra,0x4
    23b6:	e5e080e7          	jalr	-418(ra) # 6210 <printf>
      exit(1);
    23ba:	4505                	li	a0,1
    23bc:	00004097          	auipc	ra,0x4
    23c0:	ac6080e7          	jalr	-1338(ra) # 5e82 <exit>
      exit(1);
    23c4:	4505                	li	a0,1
    23c6:	00004097          	auipc	ra,0x4
    23ca:	abc080e7          	jalr	-1348(ra) # 5e82 <exit>

00000000000023ce <bigargtest>:
{
    23ce:	7179                	addi	sp,sp,-48
    23d0:	f406                	sd	ra,40(sp)
    23d2:	f022                	sd	s0,32(sp)
    23d4:	ec26                	sd	s1,24(sp)
    23d6:	1800                	addi	s0,sp,48
    23d8:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    23da:	00005517          	auipc	a0,0x5
    23de:	bbe50513          	addi	a0,a0,-1090 # 6f98 <malloc+0xccc>
    23e2:	00004097          	auipc	ra,0x4
    23e6:	af0080e7          	jalr	-1296(ra) # 5ed2 <unlink>
  pid = fork();
    23ea:	00004097          	auipc	ra,0x4
    23ee:	a90080e7          	jalr	-1392(ra) # 5e7a <fork>
  if(pid == 0){
    23f2:	c121                	beqz	a0,2432 <bigargtest+0x64>
  } else if(pid < 0){
    23f4:	0a054263          	bltz	a0,2498 <bigargtest+0xca>
  wait(&xstatus);
    23f8:	fdc40513          	addi	a0,s0,-36
    23fc:	00004097          	auipc	ra,0x4
    2400:	a8e080e7          	jalr	-1394(ra) # 5e8a <wait>
  if(xstatus != 0)
    2404:	fdc42503          	lw	a0,-36(s0)
    2408:	e555                	bnez	a0,24b4 <bigargtest+0xe6>
  fd = open("bigarg-ok", 0);
    240a:	4581                	li	a1,0
    240c:	00005517          	auipc	a0,0x5
    2410:	b8c50513          	addi	a0,a0,-1140 # 6f98 <malloc+0xccc>
    2414:	00004097          	auipc	ra,0x4
    2418:	aae080e7          	jalr	-1362(ra) # 5ec2 <open>
  if(fd < 0){
    241c:	0a054063          	bltz	a0,24bc <bigargtest+0xee>
  close(fd);
    2420:	00004097          	auipc	ra,0x4
    2424:	a8a080e7          	jalr	-1398(ra) # 5eaa <close>
}
    2428:	70a2                	ld	ra,40(sp)
    242a:	7402                	ld	s0,32(sp)
    242c:	64e2                	ld	s1,24(sp)
    242e:	6145                	addi	sp,sp,48
    2430:	8082                	ret
    2432:	00007797          	auipc	a5,0x7
    2436:	02e78793          	addi	a5,a5,46 # 9460 <args.1>
    243a:	00007697          	auipc	a3,0x7
    243e:	11e68693          	addi	a3,a3,286 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2442:	00005717          	auipc	a4,0x5
    2446:	b6670713          	addi	a4,a4,-1178 # 6fa8 <malloc+0xcdc>
    244a:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    244c:	07a1                	addi	a5,a5,8
    244e:	fed79ee3          	bne	a5,a3,244a <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2452:	00007797          	auipc	a5,0x7
    2456:	1007b323          	sd	zero,262(a5) # 9558 <args.1+0xf8>
    exec("echo", args);
    245a:	00007597          	auipc	a1,0x7
    245e:	00658593          	addi	a1,a1,6 # 9460 <args.1>
    2462:	00004517          	auipc	a0,0x4
    2466:	fa650513          	addi	a0,a0,-90 # 6408 <malloc+0x13c>
    246a:	00004097          	auipc	ra,0x4
    246e:	a50080e7          	jalr	-1456(ra) # 5eba <exec>
    fd = open("bigarg-ok", O_CREATE);
    2472:	20000593          	li	a1,512
    2476:	00005517          	auipc	a0,0x5
    247a:	b2250513          	addi	a0,a0,-1246 # 6f98 <malloc+0xccc>
    247e:	00004097          	auipc	ra,0x4
    2482:	a44080e7          	jalr	-1468(ra) # 5ec2 <open>
    close(fd);
    2486:	00004097          	auipc	ra,0x4
    248a:	a24080e7          	jalr	-1500(ra) # 5eaa <close>
    exit(0);
    248e:	4501                	li	a0,0
    2490:	00004097          	auipc	ra,0x4
    2494:	9f2080e7          	jalr	-1550(ra) # 5e82 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2498:	85a6                	mv	a1,s1
    249a:	00005517          	auipc	a0,0x5
    249e:	bee50513          	addi	a0,a0,-1042 # 7088 <malloc+0xdbc>
    24a2:	00004097          	auipc	ra,0x4
    24a6:	d6e080e7          	jalr	-658(ra) # 6210 <printf>
    exit(1);
    24aa:	4505                	li	a0,1
    24ac:	00004097          	auipc	ra,0x4
    24b0:	9d6080e7          	jalr	-1578(ra) # 5e82 <exit>
    exit(xstatus);
    24b4:	00004097          	auipc	ra,0x4
    24b8:	9ce080e7          	jalr	-1586(ra) # 5e82 <exit>
    printf("%s: bigarg test failed!\n", s);
    24bc:	85a6                	mv	a1,s1
    24be:	00005517          	auipc	a0,0x5
    24c2:	bea50513          	addi	a0,a0,-1046 # 70a8 <malloc+0xddc>
    24c6:	00004097          	auipc	ra,0x4
    24ca:	d4a080e7          	jalr	-694(ra) # 6210 <printf>
    exit(1);
    24ce:	4505                	li	a0,1
    24d0:	00004097          	auipc	ra,0x4
    24d4:	9b2080e7          	jalr	-1614(ra) # 5e82 <exit>

00000000000024d8 <stacktest>:
{
    24d8:	7179                	addi	sp,sp,-48
    24da:	f406                	sd	ra,40(sp)
    24dc:	f022                	sd	s0,32(sp)
    24de:	ec26                	sd	s1,24(sp)
    24e0:	1800                	addi	s0,sp,48
    24e2:	84aa                	mv	s1,a0
  pid = fork();
    24e4:	00004097          	auipc	ra,0x4
    24e8:	996080e7          	jalr	-1642(ra) # 5e7a <fork>
  if(pid == 0) {
    24ec:	c115                	beqz	a0,2510 <stacktest+0x38>
  } else if(pid < 0){
    24ee:	04054463          	bltz	a0,2536 <stacktest+0x5e>
  wait(&xstatus);
    24f2:	fdc40513          	addi	a0,s0,-36
    24f6:	00004097          	auipc	ra,0x4
    24fa:	994080e7          	jalr	-1644(ra) # 5e8a <wait>
  if(xstatus == -1)  // kernel killed child?
    24fe:	fdc42503          	lw	a0,-36(s0)
    2502:	57fd                	li	a5,-1
    2504:	04f50763          	beq	a0,a5,2552 <stacktest+0x7a>
    exit(xstatus);
    2508:	00004097          	auipc	ra,0x4
    250c:	97a080e7          	jalr	-1670(ra) # 5e82 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2510:	878a                	mv	a5,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2512:	80078793          	addi	a5,a5,-2048
    2516:	8007c603          	lbu	a2,-2048(a5)
    251a:	85a6                	mv	a1,s1
    251c:	00005517          	auipc	a0,0x5
    2520:	bac50513          	addi	a0,a0,-1108 # 70c8 <malloc+0xdfc>
    2524:	00004097          	auipc	ra,0x4
    2528:	cec080e7          	jalr	-788(ra) # 6210 <printf>
    exit(1);
    252c:	4505                	li	a0,1
    252e:	00004097          	auipc	ra,0x4
    2532:	954080e7          	jalr	-1708(ra) # 5e82 <exit>
    printf("%s: fork failed\n", s);
    2536:	85a6                	mv	a1,s1
    2538:	00004517          	auipc	a0,0x4
    253c:	75850513          	addi	a0,a0,1880 # 6c90 <malloc+0x9c4>
    2540:	00004097          	auipc	ra,0x4
    2544:	cd0080e7          	jalr	-816(ra) # 6210 <printf>
    exit(1);
    2548:	4505                	li	a0,1
    254a:	00004097          	auipc	ra,0x4
    254e:	938080e7          	jalr	-1736(ra) # 5e82 <exit>
    exit(0);
    2552:	4501                	li	a0,0
    2554:	00004097          	auipc	ra,0x4
    2558:	92e080e7          	jalr	-1746(ra) # 5e82 <exit>

000000000000255c <textwrite>:
{
    255c:	7179                	addi	sp,sp,-48
    255e:	f406                	sd	ra,40(sp)
    2560:	f022                	sd	s0,32(sp)
    2562:	ec26                	sd	s1,24(sp)
    2564:	1800                	addi	s0,sp,48
    2566:	84aa                	mv	s1,a0
  pid = fork();
    2568:	00004097          	auipc	ra,0x4
    256c:	912080e7          	jalr	-1774(ra) # 5e7a <fork>
  if(pid == 0) {
    2570:	c115                	beqz	a0,2594 <textwrite+0x38>
  } else if(pid < 0){
    2572:	02054963          	bltz	a0,25a4 <textwrite+0x48>
  wait(&xstatus);
    2576:	fdc40513          	addi	a0,s0,-36
    257a:	00004097          	auipc	ra,0x4
    257e:	910080e7          	jalr	-1776(ra) # 5e8a <wait>
  if(xstatus == -1)  // kernel killed child?
    2582:	fdc42503          	lw	a0,-36(s0)
    2586:	57fd                	li	a5,-1
    2588:	02f50c63          	beq	a0,a5,25c0 <textwrite+0x64>
    exit(xstatus);
    258c:	00004097          	auipc	ra,0x4
    2590:	8f6080e7          	jalr	-1802(ra) # 5e82 <exit>
    *addr = 10;
    2594:	47a9                	li	a5,10
    2596:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    259a:	4505                	li	a0,1
    259c:	00004097          	auipc	ra,0x4
    25a0:	8e6080e7          	jalr	-1818(ra) # 5e82 <exit>
    printf("%s: fork failed\n", s);
    25a4:	85a6                	mv	a1,s1
    25a6:	00004517          	auipc	a0,0x4
    25aa:	6ea50513          	addi	a0,a0,1770 # 6c90 <malloc+0x9c4>
    25ae:	00004097          	auipc	ra,0x4
    25b2:	c62080e7          	jalr	-926(ra) # 6210 <printf>
    exit(1);
    25b6:	4505                	li	a0,1
    25b8:	00004097          	auipc	ra,0x4
    25bc:	8ca080e7          	jalr	-1846(ra) # 5e82 <exit>
    exit(0);
    25c0:	4501                	li	a0,0
    25c2:	00004097          	auipc	ra,0x4
    25c6:	8c0080e7          	jalr	-1856(ra) # 5e82 <exit>

00000000000025ca <manywrites>:
{
    25ca:	7159                	addi	sp,sp,-112
    25cc:	f486                	sd	ra,104(sp)
    25ce:	f0a2                	sd	s0,96(sp)
    25d0:	eca6                	sd	s1,88(sp)
    25d2:	e8ca                	sd	s2,80(sp)
    25d4:	e4ce                	sd	s3,72(sp)
    25d6:	ec66                	sd	s9,24(sp)
    25d8:	1880                	addi	s0,sp,112
    25da:	8caa                	mv	s9,a0
  for(int ci = 0; ci < nchildren; ci++){
    25dc:	4901                	li	s2,0
    25de:	4991                	li	s3,4
    int pid = fork();
    25e0:	00004097          	auipc	ra,0x4
    25e4:	89a080e7          	jalr	-1894(ra) # 5e7a <fork>
    25e8:	84aa                	mv	s1,a0
    if(pid < 0){
    25ea:	04054063          	bltz	a0,262a <manywrites+0x60>
    if(pid == 0){
    25ee:	c12d                	beqz	a0,2650 <manywrites+0x86>
  for(int ci = 0; ci < nchildren; ci++){
    25f0:	2905                	addiw	s2,s2,1
    25f2:	ff3917e3          	bne	s2,s3,25e0 <manywrites+0x16>
    25f6:	4491                	li	s1,4
    wait(&st);
    25f8:	f9840913          	addi	s2,s0,-104
    int st = 0;
    25fc:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    2600:	854a                	mv	a0,s2
    2602:	00004097          	auipc	ra,0x4
    2606:	888080e7          	jalr	-1912(ra) # 5e8a <wait>
    if(st != 0)
    260a:	f9842503          	lw	a0,-104(s0)
    260e:	12051363          	bnez	a0,2734 <manywrites+0x16a>
  for(int ci = 0; ci < nchildren; ci++){
    2612:	34fd                	addiw	s1,s1,-1
    2614:	f4e5                	bnez	s1,25fc <manywrites+0x32>
    2616:	e0d2                	sd	s4,64(sp)
    2618:	fc56                	sd	s5,56(sp)
    261a:	f85a                	sd	s6,48(sp)
    261c:	f45e                	sd	s7,40(sp)
    261e:	f062                	sd	s8,32(sp)
    2620:	e86a                	sd	s10,16(sp)
  exit(0);
    2622:	00004097          	auipc	ra,0x4
    2626:	860080e7          	jalr	-1952(ra) # 5e82 <exit>
    262a:	e0d2                	sd	s4,64(sp)
    262c:	fc56                	sd	s5,56(sp)
    262e:	f85a                	sd	s6,48(sp)
    2630:	f45e                	sd	s7,40(sp)
    2632:	f062                	sd	s8,32(sp)
    2634:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    2636:	00005517          	auipc	a0,0x5
    263a:	a6250513          	addi	a0,a0,-1438 # 7098 <malloc+0xdcc>
    263e:	00004097          	auipc	ra,0x4
    2642:	bd2080e7          	jalr	-1070(ra) # 6210 <printf>
      exit(1);
    2646:	4505                	li	a0,1
    2648:	00004097          	auipc	ra,0x4
    264c:	83a080e7          	jalr	-1990(ra) # 5e82 <exit>
    2650:	e0d2                	sd	s4,64(sp)
    2652:	fc56                	sd	s5,56(sp)
    2654:	f85a                	sd	s6,48(sp)
    2656:	f45e                	sd	s7,40(sp)
    2658:	f062                	sd	s8,32(sp)
    265a:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    265c:	06200793          	li	a5,98
    2660:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    2664:	0619079b          	addiw	a5,s2,97
    2668:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    266c:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    2670:	f9840513          	addi	a0,s0,-104
    2674:	00004097          	auipc	ra,0x4
    2678:	85e080e7          	jalr	-1954(ra) # 5ed2 <unlink>
    267c:	47f9                	li	a5,30
    267e:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    2680:	f9840b93          	addi	s7,s0,-104
    2684:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    2688:	6a8d                	lui	s5,0x3
    268a:	0000ac17          	auipc	s8,0xa
    268e:	5eec0c13          	addi	s8,s8,1518 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2692:	8a26                	mv	s4,s1
    2694:	02094b63          	bltz	s2,26ca <manywrites+0x100>
          int fd = open(name, O_CREATE | O_RDWR);
    2698:	85da                	mv	a1,s6
    269a:	855e                	mv	a0,s7
    269c:	00004097          	auipc	ra,0x4
    26a0:	826080e7          	jalr	-2010(ra) # 5ec2 <open>
    26a4:	89aa                	mv	s3,a0
          if(fd < 0){
    26a6:	04054763          	bltz	a0,26f4 <manywrites+0x12a>
          int cc = write(fd, buf, sz);
    26aa:	8656                	mv	a2,s5
    26ac:	85e2                	mv	a1,s8
    26ae:	00003097          	auipc	ra,0x3
    26b2:	7f4080e7          	jalr	2036(ra) # 5ea2 <write>
          if(cc != sz){
    26b6:	05551f63          	bne	a0,s5,2714 <manywrites+0x14a>
          close(fd);
    26ba:	854e                	mv	a0,s3
    26bc:	00003097          	auipc	ra,0x3
    26c0:	7ee080e7          	jalr	2030(ra) # 5eaa <close>
        for(int i = 0; i < ci+1; i++){
    26c4:	2a05                	addiw	s4,s4,1
    26c6:	fd4959e3          	bge	s2,s4,2698 <manywrites+0xce>
        unlink(name);
    26ca:	f9840513          	addi	a0,s0,-104
    26ce:	00004097          	auipc	ra,0x4
    26d2:	804080e7          	jalr	-2044(ra) # 5ed2 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    26d6:	fffd079b          	addiw	a5,s10,-1
    26da:	8d3e                	mv	s10,a5
    26dc:	fbdd                	bnez	a5,2692 <manywrites+0xc8>
      unlink(name);
    26de:	f9840513          	addi	a0,s0,-104
    26e2:	00003097          	auipc	ra,0x3
    26e6:	7f0080e7          	jalr	2032(ra) # 5ed2 <unlink>
      exit(0);
    26ea:	4501                	li	a0,0
    26ec:	00003097          	auipc	ra,0x3
    26f0:	796080e7          	jalr	1942(ra) # 5e82 <exit>
            printf("%s: cannot create %s\n", s, name);
    26f4:	f9840613          	addi	a2,s0,-104
    26f8:	85e6                	mv	a1,s9
    26fa:	00005517          	auipc	a0,0x5
    26fe:	9f650513          	addi	a0,a0,-1546 # 70f0 <malloc+0xe24>
    2702:	00004097          	auipc	ra,0x4
    2706:	b0e080e7          	jalr	-1266(ra) # 6210 <printf>
            exit(1);
    270a:	4505                	li	a0,1
    270c:	00003097          	auipc	ra,0x3
    2710:	776080e7          	jalr	1910(ra) # 5e82 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2714:	86aa                	mv	a3,a0
    2716:	660d                	lui	a2,0x3
    2718:	85e6                	mv	a1,s9
    271a:	00004517          	auipc	a0,0x4
    271e:	dbe50513          	addi	a0,a0,-578 # 64d8 <malloc+0x20c>
    2722:	00004097          	auipc	ra,0x4
    2726:	aee080e7          	jalr	-1298(ra) # 6210 <printf>
            exit(1);
    272a:	4505                	li	a0,1
    272c:	00003097          	auipc	ra,0x3
    2730:	756080e7          	jalr	1878(ra) # 5e82 <exit>
    2734:	e0d2                	sd	s4,64(sp)
    2736:	fc56                	sd	s5,56(sp)
    2738:	f85a                	sd	s6,48(sp)
    273a:	f45e                	sd	s7,40(sp)
    273c:	f062                	sd	s8,32(sp)
    273e:	e86a                	sd	s10,16(sp)
      exit(st);
    2740:	00003097          	auipc	ra,0x3
    2744:	742080e7          	jalr	1858(ra) # 5e82 <exit>

0000000000002748 <copyinstr3>:
{
    2748:	7179                	addi	sp,sp,-48
    274a:	f406                	sd	ra,40(sp)
    274c:	f022                	sd	s0,32(sp)
    274e:	ec26                	sd	s1,24(sp)
    2750:	1800                	addi	s0,sp,48
  sbrk(8192);
    2752:	6509                	lui	a0,0x2
    2754:	00003097          	auipc	ra,0x3
    2758:	7b6080e7          	jalr	1974(ra) # 5f0a <sbrk>
  uint64 top = (uint64) sbrk(0);
    275c:	4501                	li	a0,0
    275e:	00003097          	auipc	ra,0x3
    2762:	7ac080e7          	jalr	1964(ra) # 5f0a <sbrk>
  if((top % PGSIZE) != 0){
    2766:	03451793          	slli	a5,a0,0x34
    276a:	e3c9                	bnez	a5,27ec <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    276c:	4501                	li	a0,0
    276e:	00003097          	auipc	ra,0x3
    2772:	79c080e7          	jalr	1948(ra) # 5f0a <sbrk>
  if(top % PGSIZE){
    2776:	03451793          	slli	a5,a0,0x34
    277a:	e3d9                	bnez	a5,2800 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    277c:	fff50493          	addi	s1,a0,-1 # 1fff <createdelete+0x1cb>
  *b = 'x';
    2780:	07800793          	li	a5,120
    2784:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2788:	8526                	mv	a0,s1
    278a:	00003097          	auipc	ra,0x3
    278e:	748080e7          	jalr	1864(ra) # 5ed2 <unlink>
  if(ret != -1){
    2792:	57fd                	li	a5,-1
    2794:	08f51363          	bne	a0,a5,281a <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2798:	20100593          	li	a1,513
    279c:	8526                	mv	a0,s1
    279e:	00003097          	auipc	ra,0x3
    27a2:	724080e7          	jalr	1828(ra) # 5ec2 <open>
  if(fd != -1){
    27a6:	57fd                	li	a5,-1
    27a8:	08f51863          	bne	a0,a5,2838 <copyinstr3+0xf0>
  ret = link(b, b);
    27ac:	85a6                	mv	a1,s1
    27ae:	8526                	mv	a0,s1
    27b0:	00003097          	auipc	ra,0x3
    27b4:	732080e7          	jalr	1842(ra) # 5ee2 <link>
  if(ret != -1){
    27b8:	57fd                	li	a5,-1
    27ba:	08f51e63          	bne	a0,a5,2856 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    27be:	00005797          	auipc	a5,0x5
    27c2:	62a78793          	addi	a5,a5,1578 # 7de8 <malloc+0x1b1c>
    27c6:	fcf43823          	sd	a5,-48(s0)
    27ca:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    27ce:	fd040593          	addi	a1,s0,-48
    27d2:	8526                	mv	a0,s1
    27d4:	00003097          	auipc	ra,0x3
    27d8:	6e6080e7          	jalr	1766(ra) # 5eba <exec>
  if(ret != -1){
    27dc:	57fd                	li	a5,-1
    27de:	08f51c63          	bne	a0,a5,2876 <copyinstr3+0x12e>
}
    27e2:	70a2                	ld	ra,40(sp)
    27e4:	7402                	ld	s0,32(sp)
    27e6:	64e2                	ld	s1,24(sp)
    27e8:	6145                	addi	sp,sp,48
    27ea:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    27ec:	0347d513          	srli	a0,a5,0x34
    27f0:	6785                	lui	a5,0x1
    27f2:	40a7853b          	subw	a0,a5,a0
    27f6:	00003097          	auipc	ra,0x3
    27fa:	714080e7          	jalr	1812(ra) # 5f0a <sbrk>
    27fe:	b7bd                	j	276c <copyinstr3+0x24>
    printf("oops\n");
    2800:	00005517          	auipc	a0,0x5
    2804:	90850513          	addi	a0,a0,-1784 # 7108 <malloc+0xe3c>
    2808:	00004097          	auipc	ra,0x4
    280c:	a08080e7          	jalr	-1528(ra) # 6210 <printf>
    exit(1);
    2810:	4505                	li	a0,1
    2812:	00003097          	auipc	ra,0x3
    2816:	670080e7          	jalr	1648(ra) # 5e82 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    281a:	862a                	mv	a2,a0
    281c:	85a6                	mv	a1,s1
    281e:	00004517          	auipc	a0,0x4
    2822:	39250513          	addi	a0,a0,914 # 6bb0 <malloc+0x8e4>
    2826:	00004097          	auipc	ra,0x4
    282a:	9ea080e7          	jalr	-1558(ra) # 6210 <printf>
    exit(1);
    282e:	4505                	li	a0,1
    2830:	00003097          	auipc	ra,0x3
    2834:	652080e7          	jalr	1618(ra) # 5e82 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2838:	862a                	mv	a2,a0
    283a:	85a6                	mv	a1,s1
    283c:	00004517          	auipc	a0,0x4
    2840:	39450513          	addi	a0,a0,916 # 6bd0 <malloc+0x904>
    2844:	00004097          	auipc	ra,0x4
    2848:	9cc080e7          	jalr	-1588(ra) # 6210 <printf>
    exit(1);
    284c:	4505                	li	a0,1
    284e:	00003097          	auipc	ra,0x3
    2852:	634080e7          	jalr	1588(ra) # 5e82 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2856:	86aa                	mv	a3,a0
    2858:	8626                	mv	a2,s1
    285a:	85a6                	mv	a1,s1
    285c:	00004517          	auipc	a0,0x4
    2860:	39450513          	addi	a0,a0,916 # 6bf0 <malloc+0x924>
    2864:	00004097          	auipc	ra,0x4
    2868:	9ac080e7          	jalr	-1620(ra) # 6210 <printf>
    exit(1);
    286c:	4505                	li	a0,1
    286e:	00003097          	auipc	ra,0x3
    2872:	614080e7          	jalr	1556(ra) # 5e82 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2876:	863e                	mv	a2,a5
    2878:	85a6                	mv	a1,s1
    287a:	00004517          	auipc	a0,0x4
    287e:	39e50513          	addi	a0,a0,926 # 6c18 <malloc+0x94c>
    2882:	00004097          	auipc	ra,0x4
    2886:	98e080e7          	jalr	-1650(ra) # 6210 <printf>
    exit(1);
    288a:	4505                	li	a0,1
    288c:	00003097          	auipc	ra,0x3
    2890:	5f6080e7          	jalr	1526(ra) # 5e82 <exit>

0000000000002894 <rwsbrk>:
{
    2894:	1101                	addi	sp,sp,-32
    2896:	ec06                	sd	ra,24(sp)
    2898:	e822                	sd	s0,16(sp)
    289a:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    289c:	6509                	lui	a0,0x2
    289e:	00003097          	auipc	ra,0x3
    28a2:	66c080e7          	jalr	1644(ra) # 5f0a <sbrk>
  if(a == 0xffffffffffffffffLL) {
    28a6:	57fd                	li	a5,-1
    28a8:	06f50463          	beq	a0,a5,2910 <rwsbrk+0x7c>
    28ac:	e426                	sd	s1,8(sp)
    28ae:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    28b0:	7579                	lui	a0,0xffffe
    28b2:	00003097          	auipc	ra,0x3
    28b6:	658080e7          	jalr	1624(ra) # 5f0a <sbrk>
    28ba:	57fd                	li	a5,-1
    28bc:	06f50963          	beq	a0,a5,292e <rwsbrk+0x9a>
    28c0:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    28c2:	20100593          	li	a1,513
    28c6:	00005517          	auipc	a0,0x5
    28ca:	88250513          	addi	a0,a0,-1918 # 7148 <malloc+0xe7c>
    28ce:	00003097          	auipc	ra,0x3
    28d2:	5f4080e7          	jalr	1524(ra) # 5ec2 <open>
    28d6:	892a                	mv	s2,a0
  if(fd < 0){
    28d8:	06054963          	bltz	a0,294a <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    28dc:	6785                	lui	a5,0x1
    28de:	94be                	add	s1,s1,a5
    28e0:	40000613          	li	a2,1024
    28e4:	85a6                	mv	a1,s1
    28e6:	00003097          	auipc	ra,0x3
    28ea:	5bc080e7          	jalr	1468(ra) # 5ea2 <write>
    28ee:	862a                	mv	a2,a0
  if(n >= 0){
    28f0:	06054a63          	bltz	a0,2964 <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    28f4:	85a6                	mv	a1,s1
    28f6:	00005517          	auipc	a0,0x5
    28fa:	87250513          	addi	a0,a0,-1934 # 7168 <malloc+0xe9c>
    28fe:	00004097          	auipc	ra,0x4
    2902:	912080e7          	jalr	-1774(ra) # 6210 <printf>
    exit(1);
    2906:	4505                	li	a0,1
    2908:	00003097          	auipc	ra,0x3
    290c:	57a080e7          	jalr	1402(ra) # 5e82 <exit>
    2910:	e426                	sd	s1,8(sp)
    2912:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2914:	00004517          	auipc	a0,0x4
    2918:	7fc50513          	addi	a0,a0,2044 # 7110 <malloc+0xe44>
    291c:	00004097          	auipc	ra,0x4
    2920:	8f4080e7          	jalr	-1804(ra) # 6210 <printf>
    exit(1);
    2924:	4505                	li	a0,1
    2926:	00003097          	auipc	ra,0x3
    292a:	55c080e7          	jalr	1372(ra) # 5e82 <exit>
    292e:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    2930:	00004517          	auipc	a0,0x4
    2934:	7f850513          	addi	a0,a0,2040 # 7128 <malloc+0xe5c>
    2938:	00004097          	auipc	ra,0x4
    293c:	8d8080e7          	jalr	-1832(ra) # 6210 <printf>
    exit(1);
    2940:	4505                	li	a0,1
    2942:	00003097          	auipc	ra,0x3
    2946:	540080e7          	jalr	1344(ra) # 5e82 <exit>
    printf("open(rwsbrk) failed\n");
    294a:	00005517          	auipc	a0,0x5
    294e:	80650513          	addi	a0,a0,-2042 # 7150 <malloc+0xe84>
    2952:	00004097          	auipc	ra,0x4
    2956:	8be080e7          	jalr	-1858(ra) # 6210 <printf>
    exit(1);
    295a:	4505                	li	a0,1
    295c:	00003097          	auipc	ra,0x3
    2960:	526080e7          	jalr	1318(ra) # 5e82 <exit>
  close(fd);
    2964:	854a                	mv	a0,s2
    2966:	00003097          	auipc	ra,0x3
    296a:	544080e7          	jalr	1348(ra) # 5eaa <close>
  unlink("rwsbrk");
    296e:	00004517          	auipc	a0,0x4
    2972:	7da50513          	addi	a0,a0,2010 # 7148 <malloc+0xe7c>
    2976:	00003097          	auipc	ra,0x3
    297a:	55c080e7          	jalr	1372(ra) # 5ed2 <unlink>
  fd = open("README", O_RDONLY);
    297e:	4581                	li	a1,0
    2980:	00004517          	auipc	a0,0x4
    2984:	c6050513          	addi	a0,a0,-928 # 65e0 <malloc+0x314>
    2988:	00003097          	auipc	ra,0x3
    298c:	53a080e7          	jalr	1338(ra) # 5ec2 <open>
    2990:	892a                	mv	s2,a0
  if(fd < 0){
    2992:	02054963          	bltz	a0,29c4 <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    2996:	4629                	li	a2,10
    2998:	85a6                	mv	a1,s1
    299a:	00003097          	auipc	ra,0x3
    299e:	500080e7          	jalr	1280(ra) # 5e9a <read>
    29a2:	862a                	mv	a2,a0
  if(n >= 0){
    29a4:	02054d63          	bltz	a0,29de <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    29a8:	85a6                	mv	a1,s1
    29aa:	00004517          	auipc	a0,0x4
    29ae:	7ee50513          	addi	a0,a0,2030 # 7198 <malloc+0xecc>
    29b2:	00004097          	auipc	ra,0x4
    29b6:	85e080e7          	jalr	-1954(ra) # 6210 <printf>
    exit(1);
    29ba:	4505                	li	a0,1
    29bc:	00003097          	auipc	ra,0x3
    29c0:	4c6080e7          	jalr	1222(ra) # 5e82 <exit>
    printf("open(rwsbrk) failed\n");
    29c4:	00004517          	auipc	a0,0x4
    29c8:	78c50513          	addi	a0,a0,1932 # 7150 <malloc+0xe84>
    29cc:	00004097          	auipc	ra,0x4
    29d0:	844080e7          	jalr	-1980(ra) # 6210 <printf>
    exit(1);
    29d4:	4505                	li	a0,1
    29d6:	00003097          	auipc	ra,0x3
    29da:	4ac080e7          	jalr	1196(ra) # 5e82 <exit>
  close(fd);
    29de:	854a                	mv	a0,s2
    29e0:	00003097          	auipc	ra,0x3
    29e4:	4ca080e7          	jalr	1226(ra) # 5eaa <close>
  exit(0);
    29e8:	4501                	li	a0,0
    29ea:	00003097          	auipc	ra,0x3
    29ee:	498080e7          	jalr	1176(ra) # 5e82 <exit>

00000000000029f2 <sbrkbasic>:
{
    29f2:	715d                	addi	sp,sp,-80
    29f4:	e486                	sd	ra,72(sp)
    29f6:	e0a2                	sd	s0,64(sp)
    29f8:	ec56                	sd	s5,24(sp)
    29fa:	0880                	addi	s0,sp,80
    29fc:	8aaa                	mv	s5,a0
  pid = fork();
    29fe:	00003097          	auipc	ra,0x3
    2a02:	47c080e7          	jalr	1148(ra) # 5e7a <fork>
  if(pid < 0){
    2a06:	04054063          	bltz	a0,2a46 <sbrkbasic+0x54>
  if(pid == 0){
    2a0a:	e925                	bnez	a0,2a7a <sbrkbasic+0x88>
    a = sbrk(TOOMUCH);
    2a0c:	40000537          	lui	a0,0x40000
    2a10:	00003097          	auipc	ra,0x3
    2a14:	4fa080e7          	jalr	1274(ra) # 5f0a <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2a18:	57fd                	li	a5,-1
    2a1a:	04f50763          	beq	a0,a5,2a68 <sbrkbasic+0x76>
    2a1e:	fc26                	sd	s1,56(sp)
    2a20:	f84a                	sd	s2,48(sp)
    2a22:	f44e                	sd	s3,40(sp)
    2a24:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    2a26:	400007b7          	lui	a5,0x40000
    2a2a:	97aa                	add	a5,a5,a0
      *b = 99;
    2a2c:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2a30:	6705                	lui	a4,0x1
      *b = 99;
    2a32:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2a36:	953a                	add	a0,a0,a4
    2a38:	fef51de3          	bne	a0,a5,2a32 <sbrkbasic+0x40>
    exit(1);
    2a3c:	4505                	li	a0,1
    2a3e:	00003097          	auipc	ra,0x3
    2a42:	444080e7          	jalr	1092(ra) # 5e82 <exit>
    2a46:	fc26                	sd	s1,56(sp)
    2a48:	f84a                	sd	s2,48(sp)
    2a4a:	f44e                	sd	s3,40(sp)
    2a4c:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    2a4e:	00004517          	auipc	a0,0x4
    2a52:	77250513          	addi	a0,a0,1906 # 71c0 <malloc+0xef4>
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	7ba080e7          	jalr	1978(ra) # 6210 <printf>
    exit(1);
    2a5e:	4505                	li	a0,1
    2a60:	00003097          	auipc	ra,0x3
    2a64:	422080e7          	jalr	1058(ra) # 5e82 <exit>
    2a68:	fc26                	sd	s1,56(sp)
    2a6a:	f84a                	sd	s2,48(sp)
    2a6c:	f44e                	sd	s3,40(sp)
    2a6e:	f052                	sd	s4,32(sp)
      exit(0);
    2a70:	4501                	li	a0,0
    2a72:	00003097          	auipc	ra,0x3
    2a76:	410080e7          	jalr	1040(ra) # 5e82 <exit>
  wait(&xstatus);
    2a7a:	fbc40513          	addi	a0,s0,-68
    2a7e:	00003097          	auipc	ra,0x3
    2a82:	40c080e7          	jalr	1036(ra) # 5e8a <wait>
  if(xstatus == 1){
    2a86:	fbc42703          	lw	a4,-68(s0)
    2a8a:	4785                	li	a5,1
    2a8c:	02f70263          	beq	a4,a5,2ab0 <sbrkbasic+0xbe>
    2a90:	fc26                	sd	s1,56(sp)
    2a92:	f84a                	sd	s2,48(sp)
    2a94:	f44e                	sd	s3,40(sp)
    2a96:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    2a98:	4501                	li	a0,0
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	470080e7          	jalr	1136(ra) # 5f0a <sbrk>
    2aa2:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2aa4:	4901                	li	s2,0
    b = sbrk(1);
    2aa6:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    2aa8:	6a05                	lui	s4,0x1
    2aaa:	388a0a13          	addi	s4,s4,904 # 1388 <pgbug+0xe>
    2aae:	a025                	j	2ad6 <sbrkbasic+0xe4>
    2ab0:	fc26                	sd	s1,56(sp)
    2ab2:	f84a                	sd	s2,48(sp)
    2ab4:	f44e                	sd	s3,40(sp)
    2ab6:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2ab8:	85d6                	mv	a1,s5
    2aba:	00004517          	auipc	a0,0x4
    2abe:	72650513          	addi	a0,a0,1830 # 71e0 <malloc+0xf14>
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	74e080e7          	jalr	1870(ra) # 6210 <printf>
    exit(1);
    2aca:	4505                	li	a0,1
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	3b6080e7          	jalr	950(ra) # 5e82 <exit>
    2ad4:	84be                	mv	s1,a5
    b = sbrk(1);
    2ad6:	854e                	mv	a0,s3
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	432080e7          	jalr	1074(ra) # 5f0a <sbrk>
    if(b != a){
    2ae0:	04951b63          	bne	a0,s1,2b36 <sbrkbasic+0x144>
    *b = 1;
    2ae4:	01348023          	sb	s3,0(s1)
    a = b + 1;
    2ae8:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2aec:	2905                	addiw	s2,s2,1
    2aee:	ff4913e3          	bne	s2,s4,2ad4 <sbrkbasic+0xe2>
  pid = fork();
    2af2:	00003097          	auipc	ra,0x3
    2af6:	388080e7          	jalr	904(ra) # 5e7a <fork>
    2afa:	892a                	mv	s2,a0
  if(pid < 0){
    2afc:	04054e63          	bltz	a0,2b58 <sbrkbasic+0x166>
  c = sbrk(1);
    2b00:	4505                	li	a0,1
    2b02:	00003097          	auipc	ra,0x3
    2b06:	408080e7          	jalr	1032(ra) # 5f0a <sbrk>
  c = sbrk(1);
    2b0a:	4505                	li	a0,1
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	3fe080e7          	jalr	1022(ra) # 5f0a <sbrk>
  if(c != a + 1){
    2b14:	0489                	addi	s1,s1,2
    2b16:	04950f63          	beq	a0,s1,2b74 <sbrkbasic+0x182>
    printf("%s: sbrk test failed post-fork\n", s);
    2b1a:	85d6                	mv	a1,s5
    2b1c:	00004517          	auipc	a0,0x4
    2b20:	72450513          	addi	a0,a0,1828 # 7240 <malloc+0xf74>
    2b24:	00003097          	auipc	ra,0x3
    2b28:	6ec080e7          	jalr	1772(ra) # 6210 <printf>
    exit(1);
    2b2c:	4505                	li	a0,1
    2b2e:	00003097          	auipc	ra,0x3
    2b32:	354080e7          	jalr	852(ra) # 5e82 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2b36:	872a                	mv	a4,a0
    2b38:	86a6                	mv	a3,s1
    2b3a:	864a                	mv	a2,s2
    2b3c:	85d6                	mv	a1,s5
    2b3e:	00004517          	auipc	a0,0x4
    2b42:	6c250513          	addi	a0,a0,1730 # 7200 <malloc+0xf34>
    2b46:	00003097          	auipc	ra,0x3
    2b4a:	6ca080e7          	jalr	1738(ra) # 6210 <printf>
      exit(1);
    2b4e:	4505                	li	a0,1
    2b50:	00003097          	auipc	ra,0x3
    2b54:	332080e7          	jalr	818(ra) # 5e82 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2b58:	85d6                	mv	a1,s5
    2b5a:	00004517          	auipc	a0,0x4
    2b5e:	6c650513          	addi	a0,a0,1734 # 7220 <malloc+0xf54>
    2b62:	00003097          	auipc	ra,0x3
    2b66:	6ae080e7          	jalr	1710(ra) # 6210 <printf>
    exit(1);
    2b6a:	4505                	li	a0,1
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	316080e7          	jalr	790(ra) # 5e82 <exit>
  if(pid == 0)
    2b74:	00091763          	bnez	s2,2b82 <sbrkbasic+0x190>
    exit(0);
    2b78:	4501                	li	a0,0
    2b7a:	00003097          	auipc	ra,0x3
    2b7e:	308080e7          	jalr	776(ra) # 5e82 <exit>
  wait(&xstatus);
    2b82:	fbc40513          	addi	a0,s0,-68
    2b86:	00003097          	auipc	ra,0x3
    2b8a:	304080e7          	jalr	772(ra) # 5e8a <wait>
  exit(xstatus);
    2b8e:	fbc42503          	lw	a0,-68(s0)
    2b92:	00003097          	auipc	ra,0x3
    2b96:	2f0080e7          	jalr	752(ra) # 5e82 <exit>

0000000000002b9a <sbrkmuch>:
{
    2b9a:	7179                	addi	sp,sp,-48
    2b9c:	f406                	sd	ra,40(sp)
    2b9e:	f022                	sd	s0,32(sp)
    2ba0:	ec26                	sd	s1,24(sp)
    2ba2:	e84a                	sd	s2,16(sp)
    2ba4:	e44e                	sd	s3,8(sp)
    2ba6:	e052                	sd	s4,0(sp)
    2ba8:	1800                	addi	s0,sp,48
    2baa:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2bac:	4501                	li	a0,0
    2bae:	00003097          	auipc	ra,0x3
    2bb2:	35c080e7          	jalr	860(ra) # 5f0a <sbrk>
    2bb6:	892a                	mv	s2,a0
  a = sbrk(0);
    2bb8:	4501                	li	a0,0
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	350080e7          	jalr	848(ra) # 5f0a <sbrk>
    2bc2:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2bc4:	06400537          	lui	a0,0x6400
    2bc8:	9d05                	subw	a0,a0,s1
    2bca:	00003097          	auipc	ra,0x3
    2bce:	340080e7          	jalr	832(ra) # 5f0a <sbrk>
  if (p != a) {
    2bd2:	0ca49a63          	bne	s1,a0,2ca6 <sbrkmuch+0x10c>
  char *eee = sbrk(0);
    2bd6:	4501                	li	a0,0
    2bd8:	00003097          	auipc	ra,0x3
    2bdc:	332080e7          	jalr	818(ra) # 5f0a <sbrk>
    2be0:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2be2:	00a4f963          	bgeu	s1,a0,2bf4 <sbrkmuch+0x5a>
    *pp = 1;
    2be6:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2be8:	6705                	lui	a4,0x1
    *pp = 1;
    2bea:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2bee:	94ba                	add	s1,s1,a4
    2bf0:	fef4ede3          	bltu	s1,a5,2bea <sbrkmuch+0x50>
  *lastaddr = 99;
    2bf4:	064007b7          	lui	a5,0x6400
    2bf8:	06300713          	li	a4,99
    2bfc:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2c00:	4501                	li	a0,0
    2c02:	00003097          	auipc	ra,0x3
    2c06:	308080e7          	jalr	776(ra) # 5f0a <sbrk>
    2c0a:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2c0c:	757d                	lui	a0,0xfffff
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	2fc080e7          	jalr	764(ra) # 5f0a <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2c16:	57fd                	li	a5,-1
    2c18:	0af50563          	beq	a0,a5,2cc2 <sbrkmuch+0x128>
  c = sbrk(0);
    2c1c:	4501                	li	a0,0
    2c1e:	00003097          	auipc	ra,0x3
    2c22:	2ec080e7          	jalr	748(ra) # 5f0a <sbrk>
  if(c != a - PGSIZE){
    2c26:	80048793          	addi	a5,s1,-2048
    2c2a:	80078793          	addi	a5,a5,-2048
    2c2e:	0af51863          	bne	a0,a5,2cde <sbrkmuch+0x144>
  a = sbrk(0);
    2c32:	4501                	li	a0,0
    2c34:	00003097          	auipc	ra,0x3
    2c38:	2d6080e7          	jalr	726(ra) # 5f0a <sbrk>
    2c3c:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2c3e:	6505                	lui	a0,0x1
    2c40:	00003097          	auipc	ra,0x3
    2c44:	2ca080e7          	jalr	714(ra) # 5f0a <sbrk>
    2c48:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2c4a:	0aa49a63          	bne	s1,a0,2cfe <sbrkmuch+0x164>
    2c4e:	4501                	li	a0,0
    2c50:	00003097          	auipc	ra,0x3
    2c54:	2ba080e7          	jalr	698(ra) # 5f0a <sbrk>
    2c58:	6785                	lui	a5,0x1
    2c5a:	97a6                	add	a5,a5,s1
    2c5c:	0af51163          	bne	a0,a5,2cfe <sbrkmuch+0x164>
  if(*lastaddr == 99){
    2c60:	064007b7          	lui	a5,0x6400
    2c64:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2c68:	06300793          	li	a5,99
    2c6c:	0af70963          	beq	a4,a5,2d1e <sbrkmuch+0x184>
  a = sbrk(0);
    2c70:	4501                	li	a0,0
    2c72:	00003097          	auipc	ra,0x3
    2c76:	298080e7          	jalr	664(ra) # 5f0a <sbrk>
    2c7a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2c7c:	4501                	li	a0,0
    2c7e:	00003097          	auipc	ra,0x3
    2c82:	28c080e7          	jalr	652(ra) # 5f0a <sbrk>
    2c86:	40a9053b          	subw	a0,s2,a0
    2c8a:	00003097          	auipc	ra,0x3
    2c8e:	280080e7          	jalr	640(ra) # 5f0a <sbrk>
  if(c != a){
    2c92:	0aa49463          	bne	s1,a0,2d3a <sbrkmuch+0x1a0>
}
    2c96:	70a2                	ld	ra,40(sp)
    2c98:	7402                	ld	s0,32(sp)
    2c9a:	64e2                	ld	s1,24(sp)
    2c9c:	6942                	ld	s2,16(sp)
    2c9e:	69a2                	ld	s3,8(sp)
    2ca0:	6a02                	ld	s4,0(sp)
    2ca2:	6145                	addi	sp,sp,48
    2ca4:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2ca6:	85ce                	mv	a1,s3
    2ca8:	00004517          	auipc	a0,0x4
    2cac:	5b850513          	addi	a0,a0,1464 # 7260 <malloc+0xf94>
    2cb0:	00003097          	auipc	ra,0x3
    2cb4:	560080e7          	jalr	1376(ra) # 6210 <printf>
    exit(1);
    2cb8:	4505                	li	a0,1
    2cba:	00003097          	auipc	ra,0x3
    2cbe:	1c8080e7          	jalr	456(ra) # 5e82 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2cc2:	85ce                	mv	a1,s3
    2cc4:	00004517          	auipc	a0,0x4
    2cc8:	5e450513          	addi	a0,a0,1508 # 72a8 <malloc+0xfdc>
    2ccc:	00003097          	auipc	ra,0x3
    2cd0:	544080e7          	jalr	1348(ra) # 6210 <printf>
    exit(1);
    2cd4:	4505                	li	a0,1
    2cd6:	00003097          	auipc	ra,0x3
    2cda:	1ac080e7          	jalr	428(ra) # 5e82 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2cde:	86aa                	mv	a3,a0
    2ce0:	8626                	mv	a2,s1
    2ce2:	85ce                	mv	a1,s3
    2ce4:	00004517          	auipc	a0,0x4
    2ce8:	5e450513          	addi	a0,a0,1508 # 72c8 <malloc+0xffc>
    2cec:	00003097          	auipc	ra,0x3
    2cf0:	524080e7          	jalr	1316(ra) # 6210 <printf>
    exit(1);
    2cf4:	4505                	li	a0,1
    2cf6:	00003097          	auipc	ra,0x3
    2cfa:	18c080e7          	jalr	396(ra) # 5e82 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2cfe:	86d2                	mv	a3,s4
    2d00:	8626                	mv	a2,s1
    2d02:	85ce                	mv	a1,s3
    2d04:	00004517          	auipc	a0,0x4
    2d08:	60450513          	addi	a0,a0,1540 # 7308 <malloc+0x103c>
    2d0c:	00003097          	auipc	ra,0x3
    2d10:	504080e7          	jalr	1284(ra) # 6210 <printf>
    exit(1);
    2d14:	4505                	li	a0,1
    2d16:	00003097          	auipc	ra,0x3
    2d1a:	16c080e7          	jalr	364(ra) # 5e82 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2d1e:	85ce                	mv	a1,s3
    2d20:	00004517          	auipc	a0,0x4
    2d24:	61850513          	addi	a0,a0,1560 # 7338 <malloc+0x106c>
    2d28:	00003097          	auipc	ra,0x3
    2d2c:	4e8080e7          	jalr	1256(ra) # 6210 <printf>
    exit(1);
    2d30:	4505                	li	a0,1
    2d32:	00003097          	auipc	ra,0x3
    2d36:	150080e7          	jalr	336(ra) # 5e82 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2d3a:	86aa                	mv	a3,a0
    2d3c:	8626                	mv	a2,s1
    2d3e:	85ce                	mv	a1,s3
    2d40:	00004517          	auipc	a0,0x4
    2d44:	63050513          	addi	a0,a0,1584 # 7370 <malloc+0x10a4>
    2d48:	00003097          	auipc	ra,0x3
    2d4c:	4c8080e7          	jalr	1224(ra) # 6210 <printf>
    exit(1);
    2d50:	4505                	li	a0,1
    2d52:	00003097          	auipc	ra,0x3
    2d56:	130080e7          	jalr	304(ra) # 5e82 <exit>

0000000000002d5a <sbrkarg>:
{
    2d5a:	7179                	addi	sp,sp,-48
    2d5c:	f406                	sd	ra,40(sp)
    2d5e:	f022                	sd	s0,32(sp)
    2d60:	ec26                	sd	s1,24(sp)
    2d62:	e84a                	sd	s2,16(sp)
    2d64:	e44e                	sd	s3,8(sp)
    2d66:	1800                	addi	s0,sp,48
    2d68:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2d6a:	6505                	lui	a0,0x1
    2d6c:	00003097          	auipc	ra,0x3
    2d70:	19e080e7          	jalr	414(ra) # 5f0a <sbrk>
    2d74:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2d76:	20100593          	li	a1,513
    2d7a:	00004517          	auipc	a0,0x4
    2d7e:	61e50513          	addi	a0,a0,1566 # 7398 <malloc+0x10cc>
    2d82:	00003097          	auipc	ra,0x3
    2d86:	140080e7          	jalr	320(ra) # 5ec2 <open>
    2d8a:	84aa                	mv	s1,a0
  unlink("sbrk");
    2d8c:	00004517          	auipc	a0,0x4
    2d90:	60c50513          	addi	a0,a0,1548 # 7398 <malloc+0x10cc>
    2d94:	00003097          	auipc	ra,0x3
    2d98:	13e080e7          	jalr	318(ra) # 5ed2 <unlink>
  if(fd < 0)  {
    2d9c:	0404c163          	bltz	s1,2dde <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2da0:	6605                	lui	a2,0x1
    2da2:	85ca                	mv	a1,s2
    2da4:	8526                	mv	a0,s1
    2da6:	00003097          	auipc	ra,0x3
    2daa:	0fc080e7          	jalr	252(ra) # 5ea2 <write>
    2dae:	04054663          	bltz	a0,2dfa <sbrkarg+0xa0>
  close(fd);
    2db2:	8526                	mv	a0,s1
    2db4:	00003097          	auipc	ra,0x3
    2db8:	0f6080e7          	jalr	246(ra) # 5eaa <close>
  a = sbrk(PGSIZE);
    2dbc:	6505                	lui	a0,0x1
    2dbe:	00003097          	auipc	ra,0x3
    2dc2:	14c080e7          	jalr	332(ra) # 5f0a <sbrk>
  if(pipe((int *) a) != 0){
    2dc6:	00003097          	auipc	ra,0x3
    2dca:	0cc080e7          	jalr	204(ra) # 5e92 <pipe>
    2dce:	e521                	bnez	a0,2e16 <sbrkarg+0xbc>
}
    2dd0:	70a2                	ld	ra,40(sp)
    2dd2:	7402                	ld	s0,32(sp)
    2dd4:	64e2                	ld	s1,24(sp)
    2dd6:	6942                	ld	s2,16(sp)
    2dd8:	69a2                	ld	s3,8(sp)
    2dda:	6145                	addi	sp,sp,48
    2ddc:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2dde:	85ce                	mv	a1,s3
    2de0:	00004517          	auipc	a0,0x4
    2de4:	5c050513          	addi	a0,a0,1472 # 73a0 <malloc+0x10d4>
    2de8:	00003097          	auipc	ra,0x3
    2dec:	428080e7          	jalr	1064(ra) # 6210 <printf>
    exit(1);
    2df0:	4505                	li	a0,1
    2df2:	00003097          	auipc	ra,0x3
    2df6:	090080e7          	jalr	144(ra) # 5e82 <exit>
    printf("%s: write sbrk failed\n", s);
    2dfa:	85ce                	mv	a1,s3
    2dfc:	00004517          	auipc	a0,0x4
    2e00:	5bc50513          	addi	a0,a0,1468 # 73b8 <malloc+0x10ec>
    2e04:	00003097          	auipc	ra,0x3
    2e08:	40c080e7          	jalr	1036(ra) # 6210 <printf>
    exit(1);
    2e0c:	4505                	li	a0,1
    2e0e:	00003097          	auipc	ra,0x3
    2e12:	074080e7          	jalr	116(ra) # 5e82 <exit>
    printf("%s: pipe() failed\n", s);
    2e16:	85ce                	mv	a1,s3
    2e18:	00004517          	auipc	a0,0x4
    2e1c:	f8050513          	addi	a0,a0,-128 # 6d98 <malloc+0xacc>
    2e20:	00003097          	auipc	ra,0x3
    2e24:	3f0080e7          	jalr	1008(ra) # 6210 <printf>
    exit(1);
    2e28:	4505                	li	a0,1
    2e2a:	00003097          	auipc	ra,0x3
    2e2e:	058080e7          	jalr	88(ra) # 5e82 <exit>

0000000000002e32 <argptest>:
{
    2e32:	1101                	addi	sp,sp,-32
    2e34:	ec06                	sd	ra,24(sp)
    2e36:	e822                	sd	s0,16(sp)
    2e38:	e426                	sd	s1,8(sp)
    2e3a:	e04a                	sd	s2,0(sp)
    2e3c:	1000                	addi	s0,sp,32
    2e3e:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2e40:	4581                	li	a1,0
    2e42:	00004517          	auipc	a0,0x4
    2e46:	58e50513          	addi	a0,a0,1422 # 73d0 <malloc+0x1104>
    2e4a:	00003097          	auipc	ra,0x3
    2e4e:	078080e7          	jalr	120(ra) # 5ec2 <open>
  if (fd < 0) {
    2e52:	02054b63          	bltz	a0,2e88 <argptest+0x56>
    2e56:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2e58:	4501                	li	a0,0
    2e5a:	00003097          	auipc	ra,0x3
    2e5e:	0b0080e7          	jalr	176(ra) # 5f0a <sbrk>
    2e62:	567d                	li	a2,-1
    2e64:	00c505b3          	add	a1,a0,a2
    2e68:	8526                	mv	a0,s1
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	030080e7          	jalr	48(ra) # 5e9a <read>
  close(fd);
    2e72:	8526                	mv	a0,s1
    2e74:	00003097          	auipc	ra,0x3
    2e78:	036080e7          	jalr	54(ra) # 5eaa <close>
}
    2e7c:	60e2                	ld	ra,24(sp)
    2e7e:	6442                	ld	s0,16(sp)
    2e80:	64a2                	ld	s1,8(sp)
    2e82:	6902                	ld	s2,0(sp)
    2e84:	6105                	addi	sp,sp,32
    2e86:	8082                	ret
    printf("%s: open failed\n", s);
    2e88:	85ca                	mv	a1,s2
    2e8a:	00004517          	auipc	a0,0x4
    2e8e:	e1e50513          	addi	a0,a0,-482 # 6ca8 <malloc+0x9dc>
    2e92:	00003097          	auipc	ra,0x3
    2e96:	37e080e7          	jalr	894(ra) # 6210 <printf>
    exit(1);
    2e9a:	4505                	li	a0,1
    2e9c:	00003097          	auipc	ra,0x3
    2ea0:	fe6080e7          	jalr	-26(ra) # 5e82 <exit>

0000000000002ea4 <sbrkbugs>:
{
    2ea4:	1141                	addi	sp,sp,-16
    2ea6:	e406                	sd	ra,8(sp)
    2ea8:	e022                	sd	s0,0(sp)
    2eaa:	0800                	addi	s0,sp,16
  int pid = fork();
    2eac:	00003097          	auipc	ra,0x3
    2eb0:	fce080e7          	jalr	-50(ra) # 5e7a <fork>
  if(pid < 0){
    2eb4:	02054263          	bltz	a0,2ed8 <sbrkbugs+0x34>
  if(pid == 0){
    2eb8:	ed0d                	bnez	a0,2ef2 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	050080e7          	jalr	80(ra) # 5f0a <sbrk>
    sbrk(-sz);
    2ec2:	40a0053b          	negw	a0,a0
    2ec6:	00003097          	auipc	ra,0x3
    2eca:	044080e7          	jalr	68(ra) # 5f0a <sbrk>
    exit(0);
    2ece:	4501                	li	a0,0
    2ed0:	00003097          	auipc	ra,0x3
    2ed4:	fb2080e7          	jalr	-78(ra) # 5e82 <exit>
    printf("fork failed\n");
    2ed8:	00004517          	auipc	a0,0x4
    2edc:	1c050513          	addi	a0,a0,448 # 7098 <malloc+0xdcc>
    2ee0:	00003097          	auipc	ra,0x3
    2ee4:	330080e7          	jalr	816(ra) # 6210 <printf>
    exit(1);
    2ee8:	4505                	li	a0,1
    2eea:	00003097          	auipc	ra,0x3
    2eee:	f98080e7          	jalr	-104(ra) # 5e82 <exit>
  wait(0);
    2ef2:	4501                	li	a0,0
    2ef4:	00003097          	auipc	ra,0x3
    2ef8:	f96080e7          	jalr	-106(ra) # 5e8a <wait>
  pid = fork();
    2efc:	00003097          	auipc	ra,0x3
    2f00:	f7e080e7          	jalr	-130(ra) # 5e7a <fork>
  if(pid < 0){
    2f04:	02054563          	bltz	a0,2f2e <sbrkbugs+0x8a>
  if(pid == 0){
    2f08:	e121                	bnez	a0,2f48 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2f0a:	00003097          	auipc	ra,0x3
    2f0e:	000080e7          	jalr	ra # 5f0a <sbrk>
    sbrk(-(sz - 3500));
    2f12:	6785                	lui	a5,0x1
    2f14:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0xe>
    2f18:	40a7853b          	subw	a0,a5,a0
    2f1c:	00003097          	auipc	ra,0x3
    2f20:	fee080e7          	jalr	-18(ra) # 5f0a <sbrk>
    exit(0);
    2f24:	4501                	li	a0,0
    2f26:	00003097          	auipc	ra,0x3
    2f2a:	f5c080e7          	jalr	-164(ra) # 5e82 <exit>
    printf("fork failed\n");
    2f2e:	00004517          	auipc	a0,0x4
    2f32:	16a50513          	addi	a0,a0,362 # 7098 <malloc+0xdcc>
    2f36:	00003097          	auipc	ra,0x3
    2f3a:	2da080e7          	jalr	730(ra) # 6210 <printf>
    exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	00003097          	auipc	ra,0x3
    2f44:	f42080e7          	jalr	-190(ra) # 5e82 <exit>
  wait(0);
    2f48:	4501                	li	a0,0
    2f4a:	00003097          	auipc	ra,0x3
    2f4e:	f40080e7          	jalr	-192(ra) # 5e8a <wait>
  pid = fork();
    2f52:	00003097          	auipc	ra,0x3
    2f56:	f28080e7          	jalr	-216(ra) # 5e7a <fork>
  if(pid < 0){
    2f5a:	02054a63          	bltz	a0,2f8e <sbrkbugs+0xea>
  if(pid == 0){
    2f5e:	e529                	bnez	a0,2fa8 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2f60:	00003097          	auipc	ra,0x3
    2f64:	faa080e7          	jalr	-86(ra) # 5f0a <sbrk>
    2f68:	67ad                	lui	a5,0xb
    2f6a:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    2f6e:	40a7853b          	subw	a0,a5,a0
    2f72:	00003097          	auipc	ra,0x3
    2f76:	f98080e7          	jalr	-104(ra) # 5f0a <sbrk>
    sbrk(-10);
    2f7a:	5559                	li	a0,-10
    2f7c:	00003097          	auipc	ra,0x3
    2f80:	f8e080e7          	jalr	-114(ra) # 5f0a <sbrk>
    exit(0);
    2f84:	4501                	li	a0,0
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	efc080e7          	jalr	-260(ra) # 5e82 <exit>
    printf("fork failed\n");
    2f8e:	00004517          	auipc	a0,0x4
    2f92:	10a50513          	addi	a0,a0,266 # 7098 <malloc+0xdcc>
    2f96:	00003097          	auipc	ra,0x3
    2f9a:	27a080e7          	jalr	634(ra) # 6210 <printf>
    exit(1);
    2f9e:	4505                	li	a0,1
    2fa0:	00003097          	auipc	ra,0x3
    2fa4:	ee2080e7          	jalr	-286(ra) # 5e82 <exit>
  wait(0);
    2fa8:	4501                	li	a0,0
    2faa:	00003097          	auipc	ra,0x3
    2fae:	ee0080e7          	jalr	-288(ra) # 5e8a <wait>
  exit(0);
    2fb2:	4501                	li	a0,0
    2fb4:	00003097          	auipc	ra,0x3
    2fb8:	ece080e7          	jalr	-306(ra) # 5e82 <exit>

0000000000002fbc <sbrklast>:
{
    2fbc:	7179                	addi	sp,sp,-48
    2fbe:	f406                	sd	ra,40(sp)
    2fc0:	f022                	sd	s0,32(sp)
    2fc2:	ec26                	sd	s1,24(sp)
    2fc4:	e84a                	sd	s2,16(sp)
    2fc6:	e44e                	sd	s3,8(sp)
    2fc8:	e052                	sd	s4,0(sp)
    2fca:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2fcc:	4501                	li	a0,0
    2fce:	00003097          	auipc	ra,0x3
    2fd2:	f3c080e7          	jalr	-196(ra) # 5f0a <sbrk>
  if((top % 4096) != 0)
    2fd6:	03451793          	slli	a5,a0,0x34
    2fda:	ebd9                	bnez	a5,3070 <sbrklast+0xb4>
  sbrk(4096);
    2fdc:	6505                	lui	a0,0x1
    2fde:	00003097          	auipc	ra,0x3
    2fe2:	f2c080e7          	jalr	-212(ra) # 5f0a <sbrk>
  sbrk(10);
    2fe6:	4529                	li	a0,10
    2fe8:	00003097          	auipc	ra,0x3
    2fec:	f22080e7          	jalr	-222(ra) # 5f0a <sbrk>
  sbrk(-20);
    2ff0:	5531                	li	a0,-20
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	f18080e7          	jalr	-232(ra) # 5f0a <sbrk>
  top = (uint64) sbrk(0);
    2ffa:	4501                	li	a0,0
    2ffc:	00003097          	auipc	ra,0x3
    3000:	f0e080e7          	jalr	-242(ra) # 5f0a <sbrk>
    3004:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    3006:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0x6c>
  p[0] = 'x';
    300a:	07800993          	li	s3,120
    300e:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    3012:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    3016:	20200593          	li	a1,514
    301a:	854a                	mv	a0,s2
    301c:	00003097          	auipc	ra,0x3
    3020:	ea6080e7          	jalr	-346(ra) # 5ec2 <open>
    3024:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    3026:	4605                	li	a2,1
    3028:	85ca                	mv	a1,s2
    302a:	00003097          	auipc	ra,0x3
    302e:	e78080e7          	jalr	-392(ra) # 5ea2 <write>
  close(fd);
    3032:	8552                	mv	a0,s4
    3034:	00003097          	auipc	ra,0x3
    3038:	e76080e7          	jalr	-394(ra) # 5eaa <close>
  fd = open(p, O_RDWR);
    303c:	4589                	li	a1,2
    303e:	854a                	mv	a0,s2
    3040:	00003097          	auipc	ra,0x3
    3044:	e82080e7          	jalr	-382(ra) # 5ec2 <open>
  p[0] = '\0';
    3048:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    304c:	4605                	li	a2,1
    304e:	85ca                	mv	a1,s2
    3050:	00003097          	auipc	ra,0x3
    3054:	e4a080e7          	jalr	-438(ra) # 5e9a <read>
  if(p[0] != 'x')
    3058:	fc04c783          	lbu	a5,-64(s1)
    305c:	03379463          	bne	a5,s3,3084 <sbrklast+0xc8>
}
    3060:	70a2                	ld	ra,40(sp)
    3062:	7402                	ld	s0,32(sp)
    3064:	64e2                	ld	s1,24(sp)
    3066:	6942                	ld	s2,16(sp)
    3068:	69a2                	ld	s3,8(sp)
    306a:	6a02                	ld	s4,0(sp)
    306c:	6145                	addi	sp,sp,48
    306e:	8082                	ret
    sbrk(4096 - (top % 4096));
    3070:	0347d513          	srli	a0,a5,0x34
    3074:	6785                	lui	a5,0x1
    3076:	40a7853b          	subw	a0,a5,a0
    307a:	00003097          	auipc	ra,0x3
    307e:	e90080e7          	jalr	-368(ra) # 5f0a <sbrk>
    3082:	bfa9                	j	2fdc <sbrklast+0x20>
    exit(1);
    3084:	4505                	li	a0,1
    3086:	00003097          	auipc	ra,0x3
    308a:	dfc080e7          	jalr	-516(ra) # 5e82 <exit>

000000000000308e <sbrk8000>:
{
    308e:	1141                	addi	sp,sp,-16
    3090:	e406                	sd	ra,8(sp)
    3092:	e022                	sd	s0,0(sp)
    3094:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    3096:	80000537          	lui	a0,0x80000
    309a:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    309c:	00003097          	auipc	ra,0x3
    30a0:	e6e080e7          	jalr	-402(ra) # 5f0a <sbrk>
  volatile char *top = sbrk(0);
    30a4:	4501                	li	a0,0
    30a6:	00003097          	auipc	ra,0x3
    30aa:	e64080e7          	jalr	-412(ra) # 5f0a <sbrk>
  *(top-1) = *(top-1) + 1;
    30ae:	fff54783          	lbu	a5,-1(a0)
    30b2:	0785                	addi	a5,a5,1 # 1001 <linktest+0xad>
    30b4:	0ff7f793          	zext.b	a5,a5
    30b8:	fef50fa3          	sb	a5,-1(a0)
}
    30bc:	60a2                	ld	ra,8(sp)
    30be:	6402                	ld	s0,0(sp)
    30c0:	0141                	addi	sp,sp,16
    30c2:	8082                	ret

00000000000030c4 <execout>:
{
    30c4:	711d                	addi	sp,sp,-96
    30c6:	ec86                	sd	ra,88(sp)
    30c8:	e8a2                	sd	s0,80(sp)
    30ca:	e4a6                	sd	s1,72(sp)
    30cc:	e0ca                	sd	s2,64(sp)
    30ce:	fc4e                	sd	s3,56(sp)
    30d0:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
    30d2:	4901                	li	s2,0
    30d4:	49bd                	li	s3,15
    int pid = fork();
    30d6:	00003097          	auipc	ra,0x3
    30da:	da4080e7          	jalr	-604(ra) # 5e7a <fork>
    30de:	84aa                	mv	s1,a0
    if(pid < 0){
    30e0:	02054263          	bltz	a0,3104 <execout+0x40>
    } else if(pid == 0){
    30e4:	cd1d                	beqz	a0,3122 <execout+0x5e>
      wait((int*)0);
    30e6:	4501                	li	a0,0
    30e8:	00003097          	auipc	ra,0x3
    30ec:	da2080e7          	jalr	-606(ra) # 5e8a <wait>
  for(int avail = 0; avail < 15; avail++){
    30f0:	2905                	addiw	s2,s2,1
    30f2:	ff3912e3          	bne	s2,s3,30d6 <execout+0x12>
    30f6:	f852                	sd	s4,48(sp)
    30f8:	f456                	sd	s5,40(sp)
  exit(0);
    30fa:	4501                	li	a0,0
    30fc:	00003097          	auipc	ra,0x3
    3100:	d86080e7          	jalr	-634(ra) # 5e82 <exit>
    3104:	f852                	sd	s4,48(sp)
    3106:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    3108:	00004517          	auipc	a0,0x4
    310c:	f9050513          	addi	a0,a0,-112 # 7098 <malloc+0xdcc>
    3110:	00003097          	auipc	ra,0x3
    3114:	100080e7          	jalr	256(ra) # 6210 <printf>
      exit(1);
    3118:	4505                	li	a0,1
    311a:	00003097          	auipc	ra,0x3
    311e:	d68080e7          	jalr	-664(ra) # 5e82 <exit>
    3122:	f852                	sd	s4,48(sp)
    3124:	f456                	sd	s5,40(sp)
        uint64 a = (uint64) sbrk(4096);
    3126:	6985                	lui	s3,0x1
        if(a == 0xffffffffffffffffLL)
    3128:	5a7d                	li	s4,-1
        *(char*)(a + 4096 - 1) = 1;
    312a:	4a85                	li	s5,1
        uint64 a = (uint64) sbrk(4096);
    312c:	854e                	mv	a0,s3
    312e:	00003097          	auipc	ra,0x3
    3132:	ddc080e7          	jalr	-548(ra) # 5f0a <sbrk>
        if(a == 0xffffffffffffffffLL)
    3136:	01450663          	beq	a0,s4,3142 <execout+0x7e>
        *(char*)(a + 4096 - 1) = 1;
    313a:	954e                	add	a0,a0,s3
    313c:	ff550fa3          	sb	s5,-1(a0)
      while(1){
    3140:	b7f5                	j	312c <execout+0x68>
        sbrk(-4096);
    3142:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
    3144:	01205a63          	blez	s2,3158 <execout+0x94>
        sbrk(-4096);
    3148:	854e                	mv	a0,s3
    314a:	00003097          	auipc	ra,0x3
    314e:	dc0080e7          	jalr	-576(ra) # 5f0a <sbrk>
      for(int i = 0; i < avail; i++)
    3152:	2485                	addiw	s1,s1,1
    3154:	ff249ae3          	bne	s1,s2,3148 <execout+0x84>
      close(1);
    3158:	4505                	li	a0,1
    315a:	00003097          	auipc	ra,0x3
    315e:	d50080e7          	jalr	-688(ra) # 5eaa <close>
      char *args[] = { "echo", "x", 0 };
    3162:	00003797          	auipc	a5,0x3
    3166:	2a678793          	addi	a5,a5,678 # 6408 <malloc+0x13c>
    316a:	faf43423          	sd	a5,-88(s0)
    316e:	00003797          	auipc	a5,0x3
    3172:	30a78793          	addi	a5,a5,778 # 6478 <malloc+0x1ac>
    3176:	faf43823          	sd	a5,-80(s0)
    317a:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    317e:	fa840593          	addi	a1,s0,-88
    3182:	00003517          	auipc	a0,0x3
    3186:	28650513          	addi	a0,a0,646 # 6408 <malloc+0x13c>
    318a:	00003097          	auipc	ra,0x3
    318e:	d30080e7          	jalr	-720(ra) # 5eba <exec>
      exit(0);
    3192:	4501                	li	a0,0
    3194:	00003097          	auipc	ra,0x3
    3198:	cee080e7          	jalr	-786(ra) # 5e82 <exit>

000000000000319c <fourteen>:
{
    319c:	1101                	addi	sp,sp,-32
    319e:	ec06                	sd	ra,24(sp)
    31a0:	e822                	sd	s0,16(sp)
    31a2:	e426                	sd	s1,8(sp)
    31a4:	1000                	addi	s0,sp,32
    31a6:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    31a8:	00004517          	auipc	a0,0x4
    31ac:	40050513          	addi	a0,a0,1024 # 75a8 <malloc+0x12dc>
    31b0:	00003097          	auipc	ra,0x3
    31b4:	d3a080e7          	jalr	-710(ra) # 5eea <mkdir>
    31b8:	e165                	bnez	a0,3298 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    31ba:	00004517          	auipc	a0,0x4
    31be:	24650513          	addi	a0,a0,582 # 7400 <malloc+0x1134>
    31c2:	00003097          	auipc	ra,0x3
    31c6:	d28080e7          	jalr	-728(ra) # 5eea <mkdir>
    31ca:	e56d                	bnez	a0,32b4 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    31cc:	20000593          	li	a1,512
    31d0:	00004517          	auipc	a0,0x4
    31d4:	28850513          	addi	a0,a0,648 # 7458 <malloc+0x118c>
    31d8:	00003097          	auipc	ra,0x3
    31dc:	cea080e7          	jalr	-790(ra) # 5ec2 <open>
  if(fd < 0){
    31e0:	0e054863          	bltz	a0,32d0 <fourteen+0x134>
  close(fd);
    31e4:	00003097          	auipc	ra,0x3
    31e8:	cc6080e7          	jalr	-826(ra) # 5eaa <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    31ec:	4581                	li	a1,0
    31ee:	00004517          	auipc	a0,0x4
    31f2:	2e250513          	addi	a0,a0,738 # 74d0 <malloc+0x1204>
    31f6:	00003097          	auipc	ra,0x3
    31fa:	ccc080e7          	jalr	-820(ra) # 5ec2 <open>
  if(fd < 0){
    31fe:	0e054763          	bltz	a0,32ec <fourteen+0x150>
  close(fd);
    3202:	00003097          	auipc	ra,0x3
    3206:	ca8080e7          	jalr	-856(ra) # 5eaa <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    320a:	00004517          	auipc	a0,0x4
    320e:	33650513          	addi	a0,a0,822 # 7540 <malloc+0x1274>
    3212:	00003097          	auipc	ra,0x3
    3216:	cd8080e7          	jalr	-808(ra) # 5eea <mkdir>
    321a:	c57d                	beqz	a0,3308 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    321c:	00004517          	auipc	a0,0x4
    3220:	37c50513          	addi	a0,a0,892 # 7598 <malloc+0x12cc>
    3224:	00003097          	auipc	ra,0x3
    3228:	cc6080e7          	jalr	-826(ra) # 5eea <mkdir>
    322c:	cd65                	beqz	a0,3324 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    322e:	00004517          	auipc	a0,0x4
    3232:	36a50513          	addi	a0,a0,874 # 7598 <malloc+0x12cc>
    3236:	00003097          	auipc	ra,0x3
    323a:	c9c080e7          	jalr	-868(ra) # 5ed2 <unlink>
  unlink("12345678901234/12345678901234");
    323e:	00004517          	auipc	a0,0x4
    3242:	30250513          	addi	a0,a0,770 # 7540 <malloc+0x1274>
    3246:	00003097          	auipc	ra,0x3
    324a:	c8c080e7          	jalr	-884(ra) # 5ed2 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    324e:	00004517          	auipc	a0,0x4
    3252:	28250513          	addi	a0,a0,642 # 74d0 <malloc+0x1204>
    3256:	00003097          	auipc	ra,0x3
    325a:	c7c080e7          	jalr	-900(ra) # 5ed2 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    325e:	00004517          	auipc	a0,0x4
    3262:	1fa50513          	addi	a0,a0,506 # 7458 <malloc+0x118c>
    3266:	00003097          	auipc	ra,0x3
    326a:	c6c080e7          	jalr	-916(ra) # 5ed2 <unlink>
  unlink("12345678901234/123456789012345");
    326e:	00004517          	auipc	a0,0x4
    3272:	19250513          	addi	a0,a0,402 # 7400 <malloc+0x1134>
    3276:	00003097          	auipc	ra,0x3
    327a:	c5c080e7          	jalr	-932(ra) # 5ed2 <unlink>
  unlink("12345678901234");
    327e:	00004517          	auipc	a0,0x4
    3282:	32a50513          	addi	a0,a0,810 # 75a8 <malloc+0x12dc>
    3286:	00003097          	auipc	ra,0x3
    328a:	c4c080e7          	jalr	-948(ra) # 5ed2 <unlink>
}
    328e:	60e2                	ld	ra,24(sp)
    3290:	6442                	ld	s0,16(sp)
    3292:	64a2                	ld	s1,8(sp)
    3294:	6105                	addi	sp,sp,32
    3296:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3298:	85a6                	mv	a1,s1
    329a:	00004517          	auipc	a0,0x4
    329e:	13e50513          	addi	a0,a0,318 # 73d8 <malloc+0x110c>
    32a2:	00003097          	auipc	ra,0x3
    32a6:	f6e080e7          	jalr	-146(ra) # 6210 <printf>
    exit(1);
    32aa:	4505                	li	a0,1
    32ac:	00003097          	auipc	ra,0x3
    32b0:	bd6080e7          	jalr	-1066(ra) # 5e82 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    32b4:	85a6                	mv	a1,s1
    32b6:	00004517          	auipc	a0,0x4
    32ba:	16a50513          	addi	a0,a0,362 # 7420 <malloc+0x1154>
    32be:	00003097          	auipc	ra,0x3
    32c2:	f52080e7          	jalr	-174(ra) # 6210 <printf>
    exit(1);
    32c6:	4505                	li	a0,1
    32c8:	00003097          	auipc	ra,0x3
    32cc:	bba080e7          	jalr	-1094(ra) # 5e82 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    32d0:	85a6                	mv	a1,s1
    32d2:	00004517          	auipc	a0,0x4
    32d6:	1b650513          	addi	a0,a0,438 # 7488 <malloc+0x11bc>
    32da:	00003097          	auipc	ra,0x3
    32de:	f36080e7          	jalr	-202(ra) # 6210 <printf>
    exit(1);
    32e2:	4505                	li	a0,1
    32e4:	00003097          	auipc	ra,0x3
    32e8:	b9e080e7          	jalr	-1122(ra) # 5e82 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    32ec:	85a6                	mv	a1,s1
    32ee:	00004517          	auipc	a0,0x4
    32f2:	21250513          	addi	a0,a0,530 # 7500 <malloc+0x1234>
    32f6:	00003097          	auipc	ra,0x3
    32fa:	f1a080e7          	jalr	-230(ra) # 6210 <printf>
    exit(1);
    32fe:	4505                	li	a0,1
    3300:	00003097          	auipc	ra,0x3
    3304:	b82080e7          	jalr	-1150(ra) # 5e82 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3308:	85a6                	mv	a1,s1
    330a:	00004517          	auipc	a0,0x4
    330e:	25650513          	addi	a0,a0,598 # 7560 <malloc+0x1294>
    3312:	00003097          	auipc	ra,0x3
    3316:	efe080e7          	jalr	-258(ra) # 6210 <printf>
    exit(1);
    331a:	4505                	li	a0,1
    331c:	00003097          	auipc	ra,0x3
    3320:	b66080e7          	jalr	-1178(ra) # 5e82 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    3324:	85a6                	mv	a1,s1
    3326:	00004517          	auipc	a0,0x4
    332a:	29250513          	addi	a0,a0,658 # 75b8 <malloc+0x12ec>
    332e:	00003097          	auipc	ra,0x3
    3332:	ee2080e7          	jalr	-286(ra) # 6210 <printf>
    exit(1);
    3336:	4505                	li	a0,1
    3338:	00003097          	auipc	ra,0x3
    333c:	b4a080e7          	jalr	-1206(ra) # 5e82 <exit>

0000000000003340 <diskfull>:
{
    3340:	b6010113          	addi	sp,sp,-1184
    3344:	48113c23          	sd	ra,1176(sp)
    3348:	48813823          	sd	s0,1168(sp)
    334c:	48913423          	sd	s1,1160(sp)
    3350:	49213023          	sd	s2,1152(sp)
    3354:	47313c23          	sd	s3,1144(sp)
    3358:	47413823          	sd	s4,1136(sp)
    335c:	47513423          	sd	s5,1128(sp)
    3360:	47613023          	sd	s6,1120(sp)
    3364:	45713c23          	sd	s7,1112(sp)
    3368:	45813823          	sd	s8,1104(sp)
    336c:	45913423          	sd	s9,1096(sp)
    3370:	45a13023          	sd	s10,1088(sp)
    3374:	43b13c23          	sd	s11,1080(sp)
    3378:	4a010413          	addi	s0,sp,1184
    337c:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    3380:	00004517          	auipc	a0,0x4
    3384:	27050513          	addi	a0,a0,624 # 75f0 <malloc+0x1324>
    3388:	00003097          	auipc	ra,0x3
    338c:	b4a080e7          	jalr	-1206(ra) # 5ed2 <unlink>
  for(fi = 0; done == 0; fi++){
    3390:	4a81                	li	s5,0
    name[0] = 'b';
    3392:	06200d13          	li	s10,98
    name[1] = 'i';
    3396:	06900c93          	li	s9,105
    name[2] = 'g';
    339a:	06700c13          	li	s8,103
    unlink(name);
    339e:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33a2:	60200b93          	li	s7,1538
    33a6:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
    33aa:	b9040a13          	addi	s4,s0,-1136
    33ae:	aa49                	j	3540 <diskfull+0x200>
      printf("%s: could not create file %s\n", s, name);
    33b0:	b7040613          	addi	a2,s0,-1168
    33b4:	b6843583          	ld	a1,-1176(s0)
    33b8:	00004517          	auipc	a0,0x4
    33bc:	24850513          	addi	a0,a0,584 # 7600 <malloc+0x1334>
    33c0:	00003097          	auipc	ra,0x3
    33c4:	e50080e7          	jalr	-432(ra) # 6210 <printf>
      break;
    33c8:	a821                	j	33e0 <diskfull+0xa0>
        close(fd);
    33ca:	854e                	mv	a0,s3
    33cc:	00003097          	auipc	ra,0x3
    33d0:	ade080e7          	jalr	-1314(ra) # 5eaa <close>
    close(fd);
    33d4:	854e                	mv	a0,s3
    33d6:	00003097          	auipc	ra,0x3
    33da:	ad4080e7          	jalr	-1324(ra) # 5eaa <close>
  for(fi = 0; done == 0; fi++){
    33de:	2a85                	addiw	s5,s5,1 # 3001 <sbrklast+0x45>
  for(int i = 0; i < nzz; i++){
    33e0:	4481                	li	s1,0
    name[0] = 'z';
    33e2:	07a00993          	li	s3,122
    unlink(name);
    33e6:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33ea:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    33ee:	08000b13          	li	s6,128
    name[0] = 'z';
    33f2:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    33f6:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    33fa:	41f4d71b          	sraiw	a4,s1,0x1f
    33fe:	01b7571b          	srliw	a4,a4,0x1b
    3402:	009707bb          	addw	a5,a4,s1
    3406:	4057d69b          	sraiw	a3,a5,0x5
    340a:	0306869b          	addiw	a3,a3,48
    340e:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    3412:	8bfd                	andi	a5,a5,31
    3414:	9f99                	subw	a5,a5,a4
    3416:	0307879b          	addiw	a5,a5,48
    341a:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    341e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3422:	854a                	mv	a0,s2
    3424:	00003097          	auipc	ra,0x3
    3428:	aae080e7          	jalr	-1362(ra) # 5ed2 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    342c:	85d2                	mv	a1,s4
    342e:	854a                	mv	a0,s2
    3430:	00003097          	auipc	ra,0x3
    3434:	a92080e7          	jalr	-1390(ra) # 5ec2 <open>
    if(fd < 0)
    3438:	00054963          	bltz	a0,344a <diskfull+0x10a>
    close(fd);
    343c:	00003097          	auipc	ra,0x3
    3440:	a6e080e7          	jalr	-1426(ra) # 5eaa <close>
  for(int i = 0; i < nzz; i++){
    3444:	2485                	addiw	s1,s1,1
    3446:	fb6496e3          	bne	s1,s6,33f2 <diskfull+0xb2>
  if(mkdir("diskfulldir") == 0)
    344a:	00004517          	auipc	a0,0x4
    344e:	1a650513          	addi	a0,a0,422 # 75f0 <malloc+0x1324>
    3452:	00003097          	auipc	ra,0x3
    3456:	a98080e7          	jalr	-1384(ra) # 5eea <mkdir>
    345a:	12050c63          	beqz	a0,3592 <diskfull+0x252>
  unlink("diskfulldir");
    345e:	00004517          	auipc	a0,0x4
    3462:	19250513          	addi	a0,a0,402 # 75f0 <malloc+0x1324>
    3466:	00003097          	auipc	ra,0x3
    346a:	a6c080e7          	jalr	-1428(ra) # 5ed2 <unlink>
  for(int i = 0; i < nzz; i++){
    346e:	4481                	li	s1,0
    name[0] = 'z';
    3470:	07a00913          	li	s2,122
    unlink(name);
    3474:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    3478:	08000993          	li	s3,128
    name[0] = 'z';
    347c:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    3480:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    3484:	41f4d71b          	sraiw	a4,s1,0x1f
    3488:	01b7571b          	srliw	a4,a4,0x1b
    348c:	009707bb          	addw	a5,a4,s1
    3490:	4057d69b          	sraiw	a3,a5,0x5
    3494:	0306869b          	addiw	a3,a3,48
    3498:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    349c:	8bfd                	andi	a5,a5,31
    349e:	9f99                	subw	a5,a5,a4
    34a0:	0307879b          	addiw	a5,a5,48
    34a4:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    34a8:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    34ac:	8552                	mv	a0,s4
    34ae:	00003097          	auipc	ra,0x3
    34b2:	a24080e7          	jalr	-1500(ra) # 5ed2 <unlink>
  for(int i = 0; i < nzz; i++){
    34b6:	2485                	addiw	s1,s1,1
    34b8:	fd3492e3          	bne	s1,s3,347c <diskfull+0x13c>
  for(int i = 0; i < fi; i++){
    34bc:	03505f63          	blez	s5,34fa <diskfull+0x1ba>
    34c0:	4481                	li	s1,0
    name[0] = 'b';
    34c2:	06200b13          	li	s6,98
    name[1] = 'i';
    34c6:	06900a13          	li	s4,105
    name[2] = 'g';
    34ca:	06700993          	li	s3,103
    unlink(name);
    34ce:	b9040913          	addi	s2,s0,-1136
    name[0] = 'b';
    34d2:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    34d6:	b94408a3          	sb	s4,-1135(s0)
    name[2] = 'g';
    34da:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + i;
    34de:	0304879b          	addiw	a5,s1,48
    34e2:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    34e6:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    34ea:	854a                	mv	a0,s2
    34ec:	00003097          	auipc	ra,0x3
    34f0:	9e6080e7          	jalr	-1562(ra) # 5ed2 <unlink>
  for(int i = 0; i < fi; i++){
    34f4:	2485                	addiw	s1,s1,1
    34f6:	fd549ee3          	bne	s1,s5,34d2 <diskfull+0x192>
}
    34fa:	49813083          	ld	ra,1176(sp)
    34fe:	49013403          	ld	s0,1168(sp)
    3502:	48813483          	ld	s1,1160(sp)
    3506:	48013903          	ld	s2,1152(sp)
    350a:	47813983          	ld	s3,1144(sp)
    350e:	47013a03          	ld	s4,1136(sp)
    3512:	46813a83          	ld	s5,1128(sp)
    3516:	46013b03          	ld	s6,1120(sp)
    351a:	45813b83          	ld	s7,1112(sp)
    351e:	45013c03          	ld	s8,1104(sp)
    3522:	44813c83          	ld	s9,1096(sp)
    3526:	44013d03          	ld	s10,1088(sp)
    352a:	43813d83          	ld	s11,1080(sp)
    352e:	4a010113          	addi	sp,sp,1184
    3532:	8082                	ret
    close(fd);
    3534:	854e                	mv	a0,s3
    3536:	00003097          	auipc	ra,0x3
    353a:	974080e7          	jalr	-1676(ra) # 5eaa <close>
  for(fi = 0; done == 0; fi++){
    353e:	2a85                	addiw	s5,s5,1
    name[0] = 'b';
    3540:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    3544:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    3548:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    354c:	030a879b          	addiw	a5,s5,48
    3550:	b6f409a3          	sb	a5,-1165(s0)
    name[4] = '\0';
    3554:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    3558:	855a                	mv	a0,s6
    355a:	00003097          	auipc	ra,0x3
    355e:	978080e7          	jalr	-1672(ra) # 5ed2 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3562:	85de                	mv	a1,s7
    3564:	855a                	mv	a0,s6
    3566:	00003097          	auipc	ra,0x3
    356a:	95c080e7          	jalr	-1700(ra) # 5ec2 <open>
    356e:	89aa                	mv	s3,a0
    if(fd < 0){
    3570:	e40540e3          	bltz	a0,33b0 <diskfull+0x70>
    3574:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
    3576:	40000913          	li	s2,1024
    357a:	864a                	mv	a2,s2
    357c:	85d2                	mv	a1,s4
    357e:	854e                	mv	a0,s3
    3580:	00003097          	auipc	ra,0x3
    3584:	922080e7          	jalr	-1758(ra) # 5ea2 <write>
    3588:	e52511e3          	bne	a0,s2,33ca <diskfull+0x8a>
    for(int i = 0; i < MAXFILE; i++){
    358c:	34fd                	addiw	s1,s1,-1
    358e:	f4f5                	bnez	s1,357a <diskfull+0x23a>
    3590:	b755                	j	3534 <diskfull+0x1f4>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3592:	00004517          	auipc	a0,0x4
    3596:	08e50513          	addi	a0,a0,142 # 7620 <malloc+0x1354>
    359a:	00003097          	auipc	ra,0x3
    359e:	c76080e7          	jalr	-906(ra) # 6210 <printf>
    35a2:	bd75                	j	345e <diskfull+0x11e>

00000000000035a4 <iputtest>:
{
    35a4:	1101                	addi	sp,sp,-32
    35a6:	ec06                	sd	ra,24(sp)
    35a8:	e822                	sd	s0,16(sp)
    35aa:	e426                	sd	s1,8(sp)
    35ac:	1000                	addi	s0,sp,32
    35ae:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    35b0:	00004517          	auipc	a0,0x4
    35b4:	0a050513          	addi	a0,a0,160 # 7650 <malloc+0x1384>
    35b8:	00003097          	auipc	ra,0x3
    35bc:	932080e7          	jalr	-1742(ra) # 5eea <mkdir>
    35c0:	04054563          	bltz	a0,360a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    35c4:	00004517          	auipc	a0,0x4
    35c8:	08c50513          	addi	a0,a0,140 # 7650 <malloc+0x1384>
    35cc:	00003097          	auipc	ra,0x3
    35d0:	926080e7          	jalr	-1754(ra) # 5ef2 <chdir>
    35d4:	04054963          	bltz	a0,3626 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    35d8:	00004517          	auipc	a0,0x4
    35dc:	0b850513          	addi	a0,a0,184 # 7690 <malloc+0x13c4>
    35e0:	00003097          	auipc	ra,0x3
    35e4:	8f2080e7          	jalr	-1806(ra) # 5ed2 <unlink>
    35e8:	04054d63          	bltz	a0,3642 <iputtest+0x9e>
  if(chdir("/") < 0){
    35ec:	00004517          	auipc	a0,0x4
    35f0:	0d450513          	addi	a0,a0,212 # 76c0 <malloc+0x13f4>
    35f4:	00003097          	auipc	ra,0x3
    35f8:	8fe080e7          	jalr	-1794(ra) # 5ef2 <chdir>
    35fc:	06054163          	bltz	a0,365e <iputtest+0xba>
}
    3600:	60e2                	ld	ra,24(sp)
    3602:	6442                	ld	s0,16(sp)
    3604:	64a2                	ld	s1,8(sp)
    3606:	6105                	addi	sp,sp,32
    3608:	8082                	ret
    printf("%s: mkdir failed\n", s);
    360a:	85a6                	mv	a1,s1
    360c:	00004517          	auipc	a0,0x4
    3610:	04c50513          	addi	a0,a0,76 # 7658 <malloc+0x138c>
    3614:	00003097          	auipc	ra,0x3
    3618:	bfc080e7          	jalr	-1028(ra) # 6210 <printf>
    exit(1);
    361c:	4505                	li	a0,1
    361e:	00003097          	auipc	ra,0x3
    3622:	864080e7          	jalr	-1948(ra) # 5e82 <exit>
    printf("%s: chdir iputdir failed\n", s);
    3626:	85a6                	mv	a1,s1
    3628:	00004517          	auipc	a0,0x4
    362c:	04850513          	addi	a0,a0,72 # 7670 <malloc+0x13a4>
    3630:	00003097          	auipc	ra,0x3
    3634:	be0080e7          	jalr	-1056(ra) # 6210 <printf>
    exit(1);
    3638:	4505                	li	a0,1
    363a:	00003097          	auipc	ra,0x3
    363e:	848080e7          	jalr	-1976(ra) # 5e82 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3642:	85a6                	mv	a1,s1
    3644:	00004517          	auipc	a0,0x4
    3648:	05c50513          	addi	a0,a0,92 # 76a0 <malloc+0x13d4>
    364c:	00003097          	auipc	ra,0x3
    3650:	bc4080e7          	jalr	-1084(ra) # 6210 <printf>
    exit(1);
    3654:	4505                	li	a0,1
    3656:	00003097          	auipc	ra,0x3
    365a:	82c080e7          	jalr	-2004(ra) # 5e82 <exit>
    printf("%s: chdir / failed\n", s);
    365e:	85a6                	mv	a1,s1
    3660:	00004517          	auipc	a0,0x4
    3664:	06850513          	addi	a0,a0,104 # 76c8 <malloc+0x13fc>
    3668:	00003097          	auipc	ra,0x3
    366c:	ba8080e7          	jalr	-1112(ra) # 6210 <printf>
    exit(1);
    3670:	4505                	li	a0,1
    3672:	00003097          	auipc	ra,0x3
    3676:	810080e7          	jalr	-2032(ra) # 5e82 <exit>

000000000000367a <exitiputtest>:
{
    367a:	7179                	addi	sp,sp,-48
    367c:	f406                	sd	ra,40(sp)
    367e:	f022                	sd	s0,32(sp)
    3680:	ec26                	sd	s1,24(sp)
    3682:	1800                	addi	s0,sp,48
    3684:	84aa                	mv	s1,a0
  pid = fork();
    3686:	00002097          	auipc	ra,0x2
    368a:	7f4080e7          	jalr	2036(ra) # 5e7a <fork>
  if(pid < 0){
    368e:	04054663          	bltz	a0,36da <exitiputtest+0x60>
  if(pid == 0){
    3692:	ed45                	bnez	a0,374a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3694:	00004517          	auipc	a0,0x4
    3698:	fbc50513          	addi	a0,a0,-68 # 7650 <malloc+0x1384>
    369c:	00003097          	auipc	ra,0x3
    36a0:	84e080e7          	jalr	-1970(ra) # 5eea <mkdir>
    36a4:	04054963          	bltz	a0,36f6 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    36a8:	00004517          	auipc	a0,0x4
    36ac:	fa850513          	addi	a0,a0,-88 # 7650 <malloc+0x1384>
    36b0:	00003097          	auipc	ra,0x3
    36b4:	842080e7          	jalr	-1982(ra) # 5ef2 <chdir>
    36b8:	04054d63          	bltz	a0,3712 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    36bc:	00004517          	auipc	a0,0x4
    36c0:	fd450513          	addi	a0,a0,-44 # 7690 <malloc+0x13c4>
    36c4:	00003097          	auipc	ra,0x3
    36c8:	80e080e7          	jalr	-2034(ra) # 5ed2 <unlink>
    36cc:	06054163          	bltz	a0,372e <exitiputtest+0xb4>
    exit(0);
    36d0:	4501                	li	a0,0
    36d2:	00002097          	auipc	ra,0x2
    36d6:	7b0080e7          	jalr	1968(ra) # 5e82 <exit>
    printf("%s: fork failed\n", s);
    36da:	85a6                	mv	a1,s1
    36dc:	00003517          	auipc	a0,0x3
    36e0:	5b450513          	addi	a0,a0,1460 # 6c90 <malloc+0x9c4>
    36e4:	00003097          	auipc	ra,0x3
    36e8:	b2c080e7          	jalr	-1236(ra) # 6210 <printf>
    exit(1);
    36ec:	4505                	li	a0,1
    36ee:	00002097          	auipc	ra,0x2
    36f2:	794080e7          	jalr	1940(ra) # 5e82 <exit>
      printf("%s: mkdir failed\n", s);
    36f6:	85a6                	mv	a1,s1
    36f8:	00004517          	auipc	a0,0x4
    36fc:	f6050513          	addi	a0,a0,-160 # 7658 <malloc+0x138c>
    3700:	00003097          	auipc	ra,0x3
    3704:	b10080e7          	jalr	-1264(ra) # 6210 <printf>
      exit(1);
    3708:	4505                	li	a0,1
    370a:	00002097          	auipc	ra,0x2
    370e:	778080e7          	jalr	1912(ra) # 5e82 <exit>
      printf("%s: child chdir failed\n", s);
    3712:	85a6                	mv	a1,s1
    3714:	00004517          	auipc	a0,0x4
    3718:	fcc50513          	addi	a0,a0,-52 # 76e0 <malloc+0x1414>
    371c:	00003097          	auipc	ra,0x3
    3720:	af4080e7          	jalr	-1292(ra) # 6210 <printf>
      exit(1);
    3724:	4505                	li	a0,1
    3726:	00002097          	auipc	ra,0x2
    372a:	75c080e7          	jalr	1884(ra) # 5e82 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    372e:	85a6                	mv	a1,s1
    3730:	00004517          	auipc	a0,0x4
    3734:	f7050513          	addi	a0,a0,-144 # 76a0 <malloc+0x13d4>
    3738:	00003097          	auipc	ra,0x3
    373c:	ad8080e7          	jalr	-1320(ra) # 6210 <printf>
      exit(1);
    3740:	4505                	li	a0,1
    3742:	00002097          	auipc	ra,0x2
    3746:	740080e7          	jalr	1856(ra) # 5e82 <exit>
  wait(&xstatus);
    374a:	fdc40513          	addi	a0,s0,-36
    374e:	00002097          	auipc	ra,0x2
    3752:	73c080e7          	jalr	1852(ra) # 5e8a <wait>
  exit(xstatus);
    3756:	fdc42503          	lw	a0,-36(s0)
    375a:	00002097          	auipc	ra,0x2
    375e:	728080e7          	jalr	1832(ra) # 5e82 <exit>

0000000000003762 <dirtest>:
{
    3762:	1101                	addi	sp,sp,-32
    3764:	ec06                	sd	ra,24(sp)
    3766:	e822                	sd	s0,16(sp)
    3768:	e426                	sd	s1,8(sp)
    376a:	1000                	addi	s0,sp,32
    376c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    376e:	00004517          	auipc	a0,0x4
    3772:	f8a50513          	addi	a0,a0,-118 # 76f8 <malloc+0x142c>
    3776:	00002097          	auipc	ra,0x2
    377a:	774080e7          	jalr	1908(ra) # 5eea <mkdir>
    377e:	04054563          	bltz	a0,37c8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    3782:	00004517          	auipc	a0,0x4
    3786:	f7650513          	addi	a0,a0,-138 # 76f8 <malloc+0x142c>
    378a:	00002097          	auipc	ra,0x2
    378e:	768080e7          	jalr	1896(ra) # 5ef2 <chdir>
    3792:	04054963          	bltz	a0,37e4 <dirtest+0x82>
  if(chdir("..") < 0){
    3796:	00004517          	auipc	a0,0x4
    379a:	f8250513          	addi	a0,a0,-126 # 7718 <malloc+0x144c>
    379e:	00002097          	auipc	ra,0x2
    37a2:	754080e7          	jalr	1876(ra) # 5ef2 <chdir>
    37a6:	04054d63          	bltz	a0,3800 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    37aa:	00004517          	auipc	a0,0x4
    37ae:	f4e50513          	addi	a0,a0,-178 # 76f8 <malloc+0x142c>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	720080e7          	jalr	1824(ra) # 5ed2 <unlink>
    37ba:	06054163          	bltz	a0,381c <dirtest+0xba>
}
    37be:	60e2                	ld	ra,24(sp)
    37c0:	6442                	ld	s0,16(sp)
    37c2:	64a2                	ld	s1,8(sp)
    37c4:	6105                	addi	sp,sp,32
    37c6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    37c8:	85a6                	mv	a1,s1
    37ca:	00004517          	auipc	a0,0x4
    37ce:	e8e50513          	addi	a0,a0,-370 # 7658 <malloc+0x138c>
    37d2:	00003097          	auipc	ra,0x3
    37d6:	a3e080e7          	jalr	-1474(ra) # 6210 <printf>
    exit(1);
    37da:	4505                	li	a0,1
    37dc:	00002097          	auipc	ra,0x2
    37e0:	6a6080e7          	jalr	1702(ra) # 5e82 <exit>
    printf("%s: chdir dir0 failed\n", s);
    37e4:	85a6                	mv	a1,s1
    37e6:	00004517          	auipc	a0,0x4
    37ea:	f1a50513          	addi	a0,a0,-230 # 7700 <malloc+0x1434>
    37ee:	00003097          	auipc	ra,0x3
    37f2:	a22080e7          	jalr	-1502(ra) # 6210 <printf>
    exit(1);
    37f6:	4505                	li	a0,1
    37f8:	00002097          	auipc	ra,0x2
    37fc:	68a080e7          	jalr	1674(ra) # 5e82 <exit>
    printf("%s: chdir .. failed\n", s);
    3800:	85a6                	mv	a1,s1
    3802:	00004517          	auipc	a0,0x4
    3806:	f1e50513          	addi	a0,a0,-226 # 7720 <malloc+0x1454>
    380a:	00003097          	auipc	ra,0x3
    380e:	a06080e7          	jalr	-1530(ra) # 6210 <printf>
    exit(1);
    3812:	4505                	li	a0,1
    3814:	00002097          	auipc	ra,0x2
    3818:	66e080e7          	jalr	1646(ra) # 5e82 <exit>
    printf("%s: unlink dir0 failed\n", s);
    381c:	85a6                	mv	a1,s1
    381e:	00004517          	auipc	a0,0x4
    3822:	f1a50513          	addi	a0,a0,-230 # 7738 <malloc+0x146c>
    3826:	00003097          	auipc	ra,0x3
    382a:	9ea080e7          	jalr	-1558(ra) # 6210 <printf>
    exit(1);
    382e:	4505                	li	a0,1
    3830:	00002097          	auipc	ra,0x2
    3834:	652080e7          	jalr	1618(ra) # 5e82 <exit>

0000000000003838 <subdir>:
{
    3838:	1101                	addi	sp,sp,-32
    383a:	ec06                	sd	ra,24(sp)
    383c:	e822                	sd	s0,16(sp)
    383e:	e426                	sd	s1,8(sp)
    3840:	e04a                	sd	s2,0(sp)
    3842:	1000                	addi	s0,sp,32
    3844:	892a                	mv	s2,a0
  unlink("ff");
    3846:	00004517          	auipc	a0,0x4
    384a:	03a50513          	addi	a0,a0,58 # 7880 <malloc+0x15b4>
    384e:	00002097          	auipc	ra,0x2
    3852:	684080e7          	jalr	1668(ra) # 5ed2 <unlink>
  if(mkdir("dd") != 0){
    3856:	00004517          	auipc	a0,0x4
    385a:	efa50513          	addi	a0,a0,-262 # 7750 <malloc+0x1484>
    385e:	00002097          	auipc	ra,0x2
    3862:	68c080e7          	jalr	1676(ra) # 5eea <mkdir>
    3866:	38051663          	bnez	a0,3bf2 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    386a:	20200593          	li	a1,514
    386e:	00004517          	auipc	a0,0x4
    3872:	f0250513          	addi	a0,a0,-254 # 7770 <malloc+0x14a4>
    3876:	00002097          	auipc	ra,0x2
    387a:	64c080e7          	jalr	1612(ra) # 5ec2 <open>
    387e:	84aa                	mv	s1,a0
  if(fd < 0){
    3880:	38054763          	bltz	a0,3c0e <subdir+0x3d6>
  write(fd, "ff", 2);
    3884:	4609                	li	a2,2
    3886:	00004597          	auipc	a1,0x4
    388a:	ffa58593          	addi	a1,a1,-6 # 7880 <malloc+0x15b4>
    388e:	00002097          	auipc	ra,0x2
    3892:	614080e7          	jalr	1556(ra) # 5ea2 <write>
  close(fd);
    3896:	8526                	mv	a0,s1
    3898:	00002097          	auipc	ra,0x2
    389c:	612080e7          	jalr	1554(ra) # 5eaa <close>
  if(unlink("dd") >= 0){
    38a0:	00004517          	auipc	a0,0x4
    38a4:	eb050513          	addi	a0,a0,-336 # 7750 <malloc+0x1484>
    38a8:	00002097          	auipc	ra,0x2
    38ac:	62a080e7          	jalr	1578(ra) # 5ed2 <unlink>
    38b0:	36055d63          	bgez	a0,3c2a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    38b4:	00004517          	auipc	a0,0x4
    38b8:	f1450513          	addi	a0,a0,-236 # 77c8 <malloc+0x14fc>
    38bc:	00002097          	auipc	ra,0x2
    38c0:	62e080e7          	jalr	1582(ra) # 5eea <mkdir>
    38c4:	38051163          	bnez	a0,3c46 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    38c8:	20200593          	li	a1,514
    38cc:	00004517          	auipc	a0,0x4
    38d0:	f2450513          	addi	a0,a0,-220 # 77f0 <malloc+0x1524>
    38d4:	00002097          	auipc	ra,0x2
    38d8:	5ee080e7          	jalr	1518(ra) # 5ec2 <open>
    38dc:	84aa                	mv	s1,a0
  if(fd < 0){
    38de:	38054263          	bltz	a0,3c62 <subdir+0x42a>
  write(fd, "FF", 2);
    38e2:	4609                	li	a2,2
    38e4:	00004597          	auipc	a1,0x4
    38e8:	f3c58593          	addi	a1,a1,-196 # 7820 <malloc+0x1554>
    38ec:	00002097          	auipc	ra,0x2
    38f0:	5b6080e7          	jalr	1462(ra) # 5ea2 <write>
  close(fd);
    38f4:	8526                	mv	a0,s1
    38f6:	00002097          	auipc	ra,0x2
    38fa:	5b4080e7          	jalr	1460(ra) # 5eaa <close>
  fd = open("dd/dd/../ff", 0);
    38fe:	4581                	li	a1,0
    3900:	00004517          	auipc	a0,0x4
    3904:	f2850513          	addi	a0,a0,-216 # 7828 <malloc+0x155c>
    3908:	00002097          	auipc	ra,0x2
    390c:	5ba080e7          	jalr	1466(ra) # 5ec2 <open>
    3910:	84aa                	mv	s1,a0
  if(fd < 0){
    3912:	36054663          	bltz	a0,3c7e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3916:	660d                	lui	a2,0x3
    3918:	00009597          	auipc	a1,0x9
    391c:	36058593          	addi	a1,a1,864 # cc78 <buf>
    3920:	00002097          	auipc	ra,0x2
    3924:	57a080e7          	jalr	1402(ra) # 5e9a <read>
  if(cc != 2 || buf[0] != 'f'){
    3928:	4789                	li	a5,2
    392a:	36f51863          	bne	a0,a5,3c9a <subdir+0x462>
    392e:	00009717          	auipc	a4,0x9
    3932:	34a74703          	lbu	a4,842(a4) # cc78 <buf>
    3936:	06600793          	li	a5,102
    393a:	36f71063          	bne	a4,a5,3c9a <subdir+0x462>
  close(fd);
    393e:	8526                	mv	a0,s1
    3940:	00002097          	auipc	ra,0x2
    3944:	56a080e7          	jalr	1386(ra) # 5eaa <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3948:	00004597          	auipc	a1,0x4
    394c:	f3058593          	addi	a1,a1,-208 # 7878 <malloc+0x15ac>
    3950:	00004517          	auipc	a0,0x4
    3954:	ea050513          	addi	a0,a0,-352 # 77f0 <malloc+0x1524>
    3958:	00002097          	auipc	ra,0x2
    395c:	58a080e7          	jalr	1418(ra) # 5ee2 <link>
    3960:	34051b63          	bnez	a0,3cb6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3964:	00004517          	auipc	a0,0x4
    3968:	e8c50513          	addi	a0,a0,-372 # 77f0 <malloc+0x1524>
    396c:	00002097          	auipc	ra,0x2
    3970:	566080e7          	jalr	1382(ra) # 5ed2 <unlink>
    3974:	34051f63          	bnez	a0,3cd2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3978:	4581                	li	a1,0
    397a:	00004517          	auipc	a0,0x4
    397e:	e7650513          	addi	a0,a0,-394 # 77f0 <malloc+0x1524>
    3982:	00002097          	auipc	ra,0x2
    3986:	540080e7          	jalr	1344(ra) # 5ec2 <open>
    398a:	36055263          	bgez	a0,3cee <subdir+0x4b6>
  if(chdir("dd") != 0){
    398e:	00004517          	auipc	a0,0x4
    3992:	dc250513          	addi	a0,a0,-574 # 7750 <malloc+0x1484>
    3996:	00002097          	auipc	ra,0x2
    399a:	55c080e7          	jalr	1372(ra) # 5ef2 <chdir>
    399e:	36051663          	bnez	a0,3d0a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    39a2:	00004517          	auipc	a0,0x4
    39a6:	f6e50513          	addi	a0,a0,-146 # 7910 <malloc+0x1644>
    39aa:	00002097          	auipc	ra,0x2
    39ae:	548080e7          	jalr	1352(ra) # 5ef2 <chdir>
    39b2:	36051a63          	bnez	a0,3d26 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    39b6:	00004517          	auipc	a0,0x4
    39ba:	f8a50513          	addi	a0,a0,-118 # 7940 <malloc+0x1674>
    39be:	00002097          	auipc	ra,0x2
    39c2:	534080e7          	jalr	1332(ra) # 5ef2 <chdir>
    39c6:	36051e63          	bnez	a0,3d42 <subdir+0x50a>
  if(chdir("./..") != 0){
    39ca:	00004517          	auipc	a0,0x4
    39ce:	fa650513          	addi	a0,a0,-90 # 7970 <malloc+0x16a4>
    39d2:	00002097          	auipc	ra,0x2
    39d6:	520080e7          	jalr	1312(ra) # 5ef2 <chdir>
    39da:	38051263          	bnez	a0,3d5e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    39de:	4581                	li	a1,0
    39e0:	00004517          	auipc	a0,0x4
    39e4:	e9850513          	addi	a0,a0,-360 # 7878 <malloc+0x15ac>
    39e8:	00002097          	auipc	ra,0x2
    39ec:	4da080e7          	jalr	1242(ra) # 5ec2 <open>
    39f0:	84aa                	mv	s1,a0
  if(fd < 0){
    39f2:	38054463          	bltz	a0,3d7a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    39f6:	660d                	lui	a2,0x3
    39f8:	00009597          	auipc	a1,0x9
    39fc:	28058593          	addi	a1,a1,640 # cc78 <buf>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	49a080e7          	jalr	1178(ra) # 5e9a <read>
    3a08:	4789                	li	a5,2
    3a0a:	38f51663          	bne	a0,a5,3d96 <subdir+0x55e>
  close(fd);
    3a0e:	8526                	mv	a0,s1
    3a10:	00002097          	auipc	ra,0x2
    3a14:	49a080e7          	jalr	1178(ra) # 5eaa <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3a18:	4581                	li	a1,0
    3a1a:	00004517          	auipc	a0,0x4
    3a1e:	dd650513          	addi	a0,a0,-554 # 77f0 <malloc+0x1524>
    3a22:	00002097          	auipc	ra,0x2
    3a26:	4a0080e7          	jalr	1184(ra) # 5ec2 <open>
    3a2a:	38055463          	bgez	a0,3db2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3a2e:	20200593          	li	a1,514
    3a32:	00004517          	auipc	a0,0x4
    3a36:	fce50513          	addi	a0,a0,-50 # 7a00 <malloc+0x1734>
    3a3a:	00002097          	auipc	ra,0x2
    3a3e:	488080e7          	jalr	1160(ra) # 5ec2 <open>
    3a42:	38055663          	bgez	a0,3dce <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3a46:	20200593          	li	a1,514
    3a4a:	00004517          	auipc	a0,0x4
    3a4e:	fe650513          	addi	a0,a0,-26 # 7a30 <malloc+0x1764>
    3a52:	00002097          	auipc	ra,0x2
    3a56:	470080e7          	jalr	1136(ra) # 5ec2 <open>
    3a5a:	38055863          	bgez	a0,3dea <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3a5e:	20000593          	li	a1,512
    3a62:	00004517          	auipc	a0,0x4
    3a66:	cee50513          	addi	a0,a0,-786 # 7750 <malloc+0x1484>
    3a6a:	00002097          	auipc	ra,0x2
    3a6e:	458080e7          	jalr	1112(ra) # 5ec2 <open>
    3a72:	38055a63          	bgez	a0,3e06 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3a76:	4589                	li	a1,2
    3a78:	00004517          	auipc	a0,0x4
    3a7c:	cd850513          	addi	a0,a0,-808 # 7750 <malloc+0x1484>
    3a80:	00002097          	auipc	ra,0x2
    3a84:	442080e7          	jalr	1090(ra) # 5ec2 <open>
    3a88:	38055d63          	bgez	a0,3e22 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3a8c:	4585                	li	a1,1
    3a8e:	00004517          	auipc	a0,0x4
    3a92:	cc250513          	addi	a0,a0,-830 # 7750 <malloc+0x1484>
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	42c080e7          	jalr	1068(ra) # 5ec2 <open>
    3a9e:	3a055063          	bgez	a0,3e3e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3aa2:	00004597          	auipc	a1,0x4
    3aa6:	01e58593          	addi	a1,a1,30 # 7ac0 <malloc+0x17f4>
    3aaa:	00004517          	auipc	a0,0x4
    3aae:	f5650513          	addi	a0,a0,-170 # 7a00 <malloc+0x1734>
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	430080e7          	jalr	1072(ra) # 5ee2 <link>
    3aba:	3a050063          	beqz	a0,3e5a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3abe:	00004597          	auipc	a1,0x4
    3ac2:	00258593          	addi	a1,a1,2 # 7ac0 <malloc+0x17f4>
    3ac6:	00004517          	auipc	a0,0x4
    3aca:	f6a50513          	addi	a0,a0,-150 # 7a30 <malloc+0x1764>
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	414080e7          	jalr	1044(ra) # 5ee2 <link>
    3ad6:	3a050063          	beqz	a0,3e76 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3ada:	00004597          	auipc	a1,0x4
    3ade:	d9e58593          	addi	a1,a1,-610 # 7878 <malloc+0x15ac>
    3ae2:	00004517          	auipc	a0,0x4
    3ae6:	c8e50513          	addi	a0,a0,-882 # 7770 <malloc+0x14a4>
    3aea:	00002097          	auipc	ra,0x2
    3aee:	3f8080e7          	jalr	1016(ra) # 5ee2 <link>
    3af2:	3a050063          	beqz	a0,3e92 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3af6:	00004517          	auipc	a0,0x4
    3afa:	f0a50513          	addi	a0,a0,-246 # 7a00 <malloc+0x1734>
    3afe:	00002097          	auipc	ra,0x2
    3b02:	3ec080e7          	jalr	1004(ra) # 5eea <mkdir>
    3b06:	3a050463          	beqz	a0,3eae <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3b0a:	00004517          	auipc	a0,0x4
    3b0e:	f2650513          	addi	a0,a0,-218 # 7a30 <malloc+0x1764>
    3b12:	00002097          	auipc	ra,0x2
    3b16:	3d8080e7          	jalr	984(ra) # 5eea <mkdir>
    3b1a:	3a050863          	beqz	a0,3eca <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3b1e:	00004517          	auipc	a0,0x4
    3b22:	d5a50513          	addi	a0,a0,-678 # 7878 <malloc+0x15ac>
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	3c4080e7          	jalr	964(ra) # 5eea <mkdir>
    3b2e:	3a050c63          	beqz	a0,3ee6 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3b32:	00004517          	auipc	a0,0x4
    3b36:	efe50513          	addi	a0,a0,-258 # 7a30 <malloc+0x1764>
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	398080e7          	jalr	920(ra) # 5ed2 <unlink>
    3b42:	3c050063          	beqz	a0,3f02 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3b46:	00004517          	auipc	a0,0x4
    3b4a:	eba50513          	addi	a0,a0,-326 # 7a00 <malloc+0x1734>
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	384080e7          	jalr	900(ra) # 5ed2 <unlink>
    3b56:	3c050463          	beqz	a0,3f1e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3b5a:	00004517          	auipc	a0,0x4
    3b5e:	c1650513          	addi	a0,a0,-1002 # 7770 <malloc+0x14a4>
    3b62:	00002097          	auipc	ra,0x2
    3b66:	390080e7          	jalr	912(ra) # 5ef2 <chdir>
    3b6a:	3c050863          	beqz	a0,3f3a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3b6e:	00004517          	auipc	a0,0x4
    3b72:	0a250513          	addi	a0,a0,162 # 7c10 <malloc+0x1944>
    3b76:	00002097          	auipc	ra,0x2
    3b7a:	37c080e7          	jalr	892(ra) # 5ef2 <chdir>
    3b7e:	3c050c63          	beqz	a0,3f56 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3b82:	00004517          	auipc	a0,0x4
    3b86:	cf650513          	addi	a0,a0,-778 # 7878 <malloc+0x15ac>
    3b8a:	00002097          	auipc	ra,0x2
    3b8e:	348080e7          	jalr	840(ra) # 5ed2 <unlink>
    3b92:	3e051063          	bnez	a0,3f72 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3b96:	00004517          	auipc	a0,0x4
    3b9a:	bda50513          	addi	a0,a0,-1062 # 7770 <malloc+0x14a4>
    3b9e:	00002097          	auipc	ra,0x2
    3ba2:	334080e7          	jalr	820(ra) # 5ed2 <unlink>
    3ba6:	3e051463          	bnez	a0,3f8e <subdir+0x756>
  if(unlink("dd") == 0){
    3baa:	00004517          	auipc	a0,0x4
    3bae:	ba650513          	addi	a0,a0,-1114 # 7750 <malloc+0x1484>
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	320080e7          	jalr	800(ra) # 5ed2 <unlink>
    3bba:	3e050863          	beqz	a0,3faa <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3bbe:	00004517          	auipc	a0,0x4
    3bc2:	0c250513          	addi	a0,a0,194 # 7c80 <malloc+0x19b4>
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	30c080e7          	jalr	780(ra) # 5ed2 <unlink>
    3bce:	3e054c63          	bltz	a0,3fc6 <subdir+0x78e>
  if(unlink("dd") < 0){
    3bd2:	00004517          	auipc	a0,0x4
    3bd6:	b7e50513          	addi	a0,a0,-1154 # 7750 <malloc+0x1484>
    3bda:	00002097          	auipc	ra,0x2
    3bde:	2f8080e7          	jalr	760(ra) # 5ed2 <unlink>
    3be2:	40054063          	bltz	a0,3fe2 <subdir+0x7aa>
}
    3be6:	60e2                	ld	ra,24(sp)
    3be8:	6442                	ld	s0,16(sp)
    3bea:	64a2                	ld	s1,8(sp)
    3bec:	6902                	ld	s2,0(sp)
    3bee:	6105                	addi	sp,sp,32
    3bf0:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3bf2:	85ca                	mv	a1,s2
    3bf4:	00004517          	auipc	a0,0x4
    3bf8:	b6450513          	addi	a0,a0,-1180 # 7758 <malloc+0x148c>
    3bfc:	00002097          	auipc	ra,0x2
    3c00:	614080e7          	jalr	1556(ra) # 6210 <printf>
    exit(1);
    3c04:	4505                	li	a0,1
    3c06:	00002097          	auipc	ra,0x2
    3c0a:	27c080e7          	jalr	636(ra) # 5e82 <exit>
    printf("%s: create dd/ff failed\n", s);
    3c0e:	85ca                	mv	a1,s2
    3c10:	00004517          	auipc	a0,0x4
    3c14:	b6850513          	addi	a0,a0,-1176 # 7778 <malloc+0x14ac>
    3c18:	00002097          	auipc	ra,0x2
    3c1c:	5f8080e7          	jalr	1528(ra) # 6210 <printf>
    exit(1);
    3c20:	4505                	li	a0,1
    3c22:	00002097          	auipc	ra,0x2
    3c26:	260080e7          	jalr	608(ra) # 5e82 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3c2a:	85ca                	mv	a1,s2
    3c2c:	00004517          	auipc	a0,0x4
    3c30:	b6c50513          	addi	a0,a0,-1172 # 7798 <malloc+0x14cc>
    3c34:	00002097          	auipc	ra,0x2
    3c38:	5dc080e7          	jalr	1500(ra) # 6210 <printf>
    exit(1);
    3c3c:	4505                	li	a0,1
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	244080e7          	jalr	580(ra) # 5e82 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3c46:	85ca                	mv	a1,s2
    3c48:	00004517          	auipc	a0,0x4
    3c4c:	b8850513          	addi	a0,a0,-1144 # 77d0 <malloc+0x1504>
    3c50:	00002097          	auipc	ra,0x2
    3c54:	5c0080e7          	jalr	1472(ra) # 6210 <printf>
    exit(1);
    3c58:	4505                	li	a0,1
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	228080e7          	jalr	552(ra) # 5e82 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3c62:	85ca                	mv	a1,s2
    3c64:	00004517          	auipc	a0,0x4
    3c68:	b9c50513          	addi	a0,a0,-1124 # 7800 <malloc+0x1534>
    3c6c:	00002097          	auipc	ra,0x2
    3c70:	5a4080e7          	jalr	1444(ra) # 6210 <printf>
    exit(1);
    3c74:	4505                	li	a0,1
    3c76:	00002097          	auipc	ra,0x2
    3c7a:	20c080e7          	jalr	524(ra) # 5e82 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3c7e:	85ca                	mv	a1,s2
    3c80:	00004517          	auipc	a0,0x4
    3c84:	bb850513          	addi	a0,a0,-1096 # 7838 <malloc+0x156c>
    3c88:	00002097          	auipc	ra,0x2
    3c8c:	588080e7          	jalr	1416(ra) # 6210 <printf>
    exit(1);
    3c90:	4505                	li	a0,1
    3c92:	00002097          	auipc	ra,0x2
    3c96:	1f0080e7          	jalr	496(ra) # 5e82 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3c9a:	85ca                	mv	a1,s2
    3c9c:	00004517          	auipc	a0,0x4
    3ca0:	bbc50513          	addi	a0,a0,-1092 # 7858 <malloc+0x158c>
    3ca4:	00002097          	auipc	ra,0x2
    3ca8:	56c080e7          	jalr	1388(ra) # 6210 <printf>
    exit(1);
    3cac:	4505                	li	a0,1
    3cae:	00002097          	auipc	ra,0x2
    3cb2:	1d4080e7          	jalr	468(ra) # 5e82 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3cb6:	85ca                	mv	a1,s2
    3cb8:	00004517          	auipc	a0,0x4
    3cbc:	bd050513          	addi	a0,a0,-1072 # 7888 <malloc+0x15bc>
    3cc0:	00002097          	auipc	ra,0x2
    3cc4:	550080e7          	jalr	1360(ra) # 6210 <printf>
    exit(1);
    3cc8:	4505                	li	a0,1
    3cca:	00002097          	auipc	ra,0x2
    3cce:	1b8080e7          	jalr	440(ra) # 5e82 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3cd2:	85ca                	mv	a1,s2
    3cd4:	00004517          	auipc	a0,0x4
    3cd8:	bdc50513          	addi	a0,a0,-1060 # 78b0 <malloc+0x15e4>
    3cdc:	00002097          	auipc	ra,0x2
    3ce0:	534080e7          	jalr	1332(ra) # 6210 <printf>
    exit(1);
    3ce4:	4505                	li	a0,1
    3ce6:	00002097          	auipc	ra,0x2
    3cea:	19c080e7          	jalr	412(ra) # 5e82 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3cee:	85ca                	mv	a1,s2
    3cf0:	00004517          	auipc	a0,0x4
    3cf4:	be050513          	addi	a0,a0,-1056 # 78d0 <malloc+0x1604>
    3cf8:	00002097          	auipc	ra,0x2
    3cfc:	518080e7          	jalr	1304(ra) # 6210 <printf>
    exit(1);
    3d00:	4505                	li	a0,1
    3d02:	00002097          	auipc	ra,0x2
    3d06:	180080e7          	jalr	384(ra) # 5e82 <exit>
    printf("%s: chdir dd failed\n", s);
    3d0a:	85ca                	mv	a1,s2
    3d0c:	00004517          	auipc	a0,0x4
    3d10:	bec50513          	addi	a0,a0,-1044 # 78f8 <malloc+0x162c>
    3d14:	00002097          	auipc	ra,0x2
    3d18:	4fc080e7          	jalr	1276(ra) # 6210 <printf>
    exit(1);
    3d1c:	4505                	li	a0,1
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	164080e7          	jalr	356(ra) # 5e82 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3d26:	85ca                	mv	a1,s2
    3d28:	00004517          	auipc	a0,0x4
    3d2c:	bf850513          	addi	a0,a0,-1032 # 7920 <malloc+0x1654>
    3d30:	00002097          	auipc	ra,0x2
    3d34:	4e0080e7          	jalr	1248(ra) # 6210 <printf>
    exit(1);
    3d38:	4505                	li	a0,1
    3d3a:	00002097          	auipc	ra,0x2
    3d3e:	148080e7          	jalr	328(ra) # 5e82 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3d42:	85ca                	mv	a1,s2
    3d44:	00004517          	auipc	a0,0x4
    3d48:	c0c50513          	addi	a0,a0,-1012 # 7950 <malloc+0x1684>
    3d4c:	00002097          	auipc	ra,0x2
    3d50:	4c4080e7          	jalr	1220(ra) # 6210 <printf>
    exit(1);
    3d54:	4505                	li	a0,1
    3d56:	00002097          	auipc	ra,0x2
    3d5a:	12c080e7          	jalr	300(ra) # 5e82 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3d5e:	85ca                	mv	a1,s2
    3d60:	00004517          	auipc	a0,0x4
    3d64:	c1850513          	addi	a0,a0,-1000 # 7978 <malloc+0x16ac>
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	4a8080e7          	jalr	1192(ra) # 6210 <printf>
    exit(1);
    3d70:	4505                	li	a0,1
    3d72:	00002097          	auipc	ra,0x2
    3d76:	110080e7          	jalr	272(ra) # 5e82 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3d7a:	85ca                	mv	a1,s2
    3d7c:	00004517          	auipc	a0,0x4
    3d80:	c1450513          	addi	a0,a0,-1004 # 7990 <malloc+0x16c4>
    3d84:	00002097          	auipc	ra,0x2
    3d88:	48c080e7          	jalr	1164(ra) # 6210 <printf>
    exit(1);
    3d8c:	4505                	li	a0,1
    3d8e:	00002097          	auipc	ra,0x2
    3d92:	0f4080e7          	jalr	244(ra) # 5e82 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3d96:	85ca                	mv	a1,s2
    3d98:	00004517          	auipc	a0,0x4
    3d9c:	c1850513          	addi	a0,a0,-1000 # 79b0 <malloc+0x16e4>
    3da0:	00002097          	auipc	ra,0x2
    3da4:	470080e7          	jalr	1136(ra) # 6210 <printf>
    exit(1);
    3da8:	4505                	li	a0,1
    3daa:	00002097          	auipc	ra,0x2
    3dae:	0d8080e7          	jalr	216(ra) # 5e82 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3db2:	85ca                	mv	a1,s2
    3db4:	00004517          	auipc	a0,0x4
    3db8:	c1c50513          	addi	a0,a0,-996 # 79d0 <malloc+0x1704>
    3dbc:	00002097          	auipc	ra,0x2
    3dc0:	454080e7          	jalr	1108(ra) # 6210 <printf>
    exit(1);
    3dc4:	4505                	li	a0,1
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	0bc080e7          	jalr	188(ra) # 5e82 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3dce:	85ca                	mv	a1,s2
    3dd0:	00004517          	auipc	a0,0x4
    3dd4:	c4050513          	addi	a0,a0,-960 # 7a10 <malloc+0x1744>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	438080e7          	jalr	1080(ra) # 6210 <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	0a0080e7          	jalr	160(ra) # 5e82 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3dea:	85ca                	mv	a1,s2
    3dec:	00004517          	auipc	a0,0x4
    3df0:	c5450513          	addi	a0,a0,-940 # 7a40 <malloc+0x1774>
    3df4:	00002097          	auipc	ra,0x2
    3df8:	41c080e7          	jalr	1052(ra) # 6210 <printf>
    exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	00002097          	auipc	ra,0x2
    3e02:	084080e7          	jalr	132(ra) # 5e82 <exit>
    printf("%s: create dd succeeded!\n", s);
    3e06:	85ca                	mv	a1,s2
    3e08:	00004517          	auipc	a0,0x4
    3e0c:	c5850513          	addi	a0,a0,-936 # 7a60 <malloc+0x1794>
    3e10:	00002097          	auipc	ra,0x2
    3e14:	400080e7          	jalr	1024(ra) # 6210 <printf>
    exit(1);
    3e18:	4505                	li	a0,1
    3e1a:	00002097          	auipc	ra,0x2
    3e1e:	068080e7          	jalr	104(ra) # 5e82 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3e22:	85ca                	mv	a1,s2
    3e24:	00004517          	auipc	a0,0x4
    3e28:	c5c50513          	addi	a0,a0,-932 # 7a80 <malloc+0x17b4>
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	3e4080e7          	jalr	996(ra) # 6210 <printf>
    exit(1);
    3e34:	4505                	li	a0,1
    3e36:	00002097          	auipc	ra,0x2
    3e3a:	04c080e7          	jalr	76(ra) # 5e82 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3e3e:	85ca                	mv	a1,s2
    3e40:	00004517          	auipc	a0,0x4
    3e44:	c6050513          	addi	a0,a0,-928 # 7aa0 <malloc+0x17d4>
    3e48:	00002097          	auipc	ra,0x2
    3e4c:	3c8080e7          	jalr	968(ra) # 6210 <printf>
    exit(1);
    3e50:	4505                	li	a0,1
    3e52:	00002097          	auipc	ra,0x2
    3e56:	030080e7          	jalr	48(ra) # 5e82 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3e5a:	85ca                	mv	a1,s2
    3e5c:	00004517          	auipc	a0,0x4
    3e60:	c7450513          	addi	a0,a0,-908 # 7ad0 <malloc+0x1804>
    3e64:	00002097          	auipc	ra,0x2
    3e68:	3ac080e7          	jalr	940(ra) # 6210 <printf>
    exit(1);
    3e6c:	4505                	li	a0,1
    3e6e:	00002097          	auipc	ra,0x2
    3e72:	014080e7          	jalr	20(ra) # 5e82 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3e76:	85ca                	mv	a1,s2
    3e78:	00004517          	auipc	a0,0x4
    3e7c:	c8050513          	addi	a0,a0,-896 # 7af8 <malloc+0x182c>
    3e80:	00002097          	auipc	ra,0x2
    3e84:	390080e7          	jalr	912(ra) # 6210 <printf>
    exit(1);
    3e88:	4505                	li	a0,1
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	ff8080e7          	jalr	-8(ra) # 5e82 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3e92:	85ca                	mv	a1,s2
    3e94:	00004517          	auipc	a0,0x4
    3e98:	c8c50513          	addi	a0,a0,-884 # 7b20 <malloc+0x1854>
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	374080e7          	jalr	884(ra) # 6210 <printf>
    exit(1);
    3ea4:	4505                	li	a0,1
    3ea6:	00002097          	auipc	ra,0x2
    3eaa:	fdc080e7          	jalr	-36(ra) # 5e82 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3eae:	85ca                	mv	a1,s2
    3eb0:	00004517          	auipc	a0,0x4
    3eb4:	c9850513          	addi	a0,a0,-872 # 7b48 <malloc+0x187c>
    3eb8:	00002097          	auipc	ra,0x2
    3ebc:	358080e7          	jalr	856(ra) # 6210 <printf>
    exit(1);
    3ec0:	4505                	li	a0,1
    3ec2:	00002097          	auipc	ra,0x2
    3ec6:	fc0080e7          	jalr	-64(ra) # 5e82 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3eca:	85ca                	mv	a1,s2
    3ecc:	00004517          	auipc	a0,0x4
    3ed0:	c9c50513          	addi	a0,a0,-868 # 7b68 <malloc+0x189c>
    3ed4:	00002097          	auipc	ra,0x2
    3ed8:	33c080e7          	jalr	828(ra) # 6210 <printf>
    exit(1);
    3edc:	4505                	li	a0,1
    3ede:	00002097          	auipc	ra,0x2
    3ee2:	fa4080e7          	jalr	-92(ra) # 5e82 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3ee6:	85ca                	mv	a1,s2
    3ee8:	00004517          	auipc	a0,0x4
    3eec:	ca050513          	addi	a0,a0,-864 # 7b88 <malloc+0x18bc>
    3ef0:	00002097          	auipc	ra,0x2
    3ef4:	320080e7          	jalr	800(ra) # 6210 <printf>
    exit(1);
    3ef8:	4505                	li	a0,1
    3efa:	00002097          	auipc	ra,0x2
    3efe:	f88080e7          	jalr	-120(ra) # 5e82 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3f02:	85ca                	mv	a1,s2
    3f04:	00004517          	auipc	a0,0x4
    3f08:	cac50513          	addi	a0,a0,-852 # 7bb0 <malloc+0x18e4>
    3f0c:	00002097          	auipc	ra,0x2
    3f10:	304080e7          	jalr	772(ra) # 6210 <printf>
    exit(1);
    3f14:	4505                	li	a0,1
    3f16:	00002097          	auipc	ra,0x2
    3f1a:	f6c080e7          	jalr	-148(ra) # 5e82 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3f1e:	85ca                	mv	a1,s2
    3f20:	00004517          	auipc	a0,0x4
    3f24:	cb050513          	addi	a0,a0,-848 # 7bd0 <malloc+0x1904>
    3f28:	00002097          	auipc	ra,0x2
    3f2c:	2e8080e7          	jalr	744(ra) # 6210 <printf>
    exit(1);
    3f30:	4505                	li	a0,1
    3f32:	00002097          	auipc	ra,0x2
    3f36:	f50080e7          	jalr	-176(ra) # 5e82 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3f3a:	85ca                	mv	a1,s2
    3f3c:	00004517          	auipc	a0,0x4
    3f40:	cb450513          	addi	a0,a0,-844 # 7bf0 <malloc+0x1924>
    3f44:	00002097          	auipc	ra,0x2
    3f48:	2cc080e7          	jalr	716(ra) # 6210 <printf>
    exit(1);
    3f4c:	4505                	li	a0,1
    3f4e:	00002097          	auipc	ra,0x2
    3f52:	f34080e7          	jalr	-204(ra) # 5e82 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3f56:	85ca                	mv	a1,s2
    3f58:	00004517          	auipc	a0,0x4
    3f5c:	cc050513          	addi	a0,a0,-832 # 7c18 <malloc+0x194c>
    3f60:	00002097          	auipc	ra,0x2
    3f64:	2b0080e7          	jalr	688(ra) # 6210 <printf>
    exit(1);
    3f68:	4505                	li	a0,1
    3f6a:	00002097          	auipc	ra,0x2
    3f6e:	f18080e7          	jalr	-232(ra) # 5e82 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3f72:	85ca                	mv	a1,s2
    3f74:	00004517          	auipc	a0,0x4
    3f78:	93c50513          	addi	a0,a0,-1732 # 78b0 <malloc+0x15e4>
    3f7c:	00002097          	auipc	ra,0x2
    3f80:	294080e7          	jalr	660(ra) # 6210 <printf>
    exit(1);
    3f84:	4505                	li	a0,1
    3f86:	00002097          	auipc	ra,0x2
    3f8a:	efc080e7          	jalr	-260(ra) # 5e82 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3f8e:	85ca                	mv	a1,s2
    3f90:	00004517          	auipc	a0,0x4
    3f94:	ca850513          	addi	a0,a0,-856 # 7c38 <malloc+0x196c>
    3f98:	00002097          	auipc	ra,0x2
    3f9c:	278080e7          	jalr	632(ra) # 6210 <printf>
    exit(1);
    3fa0:	4505                	li	a0,1
    3fa2:	00002097          	auipc	ra,0x2
    3fa6:	ee0080e7          	jalr	-288(ra) # 5e82 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3faa:	85ca                	mv	a1,s2
    3fac:	00004517          	auipc	a0,0x4
    3fb0:	cac50513          	addi	a0,a0,-852 # 7c58 <malloc+0x198c>
    3fb4:	00002097          	auipc	ra,0x2
    3fb8:	25c080e7          	jalr	604(ra) # 6210 <printf>
    exit(1);
    3fbc:	4505                	li	a0,1
    3fbe:	00002097          	auipc	ra,0x2
    3fc2:	ec4080e7          	jalr	-316(ra) # 5e82 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3fc6:	85ca                	mv	a1,s2
    3fc8:	00004517          	auipc	a0,0x4
    3fcc:	cc050513          	addi	a0,a0,-832 # 7c88 <malloc+0x19bc>
    3fd0:	00002097          	auipc	ra,0x2
    3fd4:	240080e7          	jalr	576(ra) # 6210 <printf>
    exit(1);
    3fd8:	4505                	li	a0,1
    3fda:	00002097          	auipc	ra,0x2
    3fde:	ea8080e7          	jalr	-344(ra) # 5e82 <exit>
    printf("%s: unlink dd failed\n", s);
    3fe2:	85ca                	mv	a1,s2
    3fe4:	00004517          	auipc	a0,0x4
    3fe8:	cc450513          	addi	a0,a0,-828 # 7ca8 <malloc+0x19dc>
    3fec:	00002097          	auipc	ra,0x2
    3ff0:	224080e7          	jalr	548(ra) # 6210 <printf>
    exit(1);
    3ff4:	4505                	li	a0,1
    3ff6:	00002097          	auipc	ra,0x2
    3ffa:	e8c080e7          	jalr	-372(ra) # 5e82 <exit>

0000000000003ffe <rmdot>:
{
    3ffe:	1101                	addi	sp,sp,-32
    4000:	ec06                	sd	ra,24(sp)
    4002:	e822                	sd	s0,16(sp)
    4004:	e426                	sd	s1,8(sp)
    4006:	1000                	addi	s0,sp,32
    4008:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    400a:	00004517          	auipc	a0,0x4
    400e:	cb650513          	addi	a0,a0,-842 # 7cc0 <malloc+0x19f4>
    4012:	00002097          	auipc	ra,0x2
    4016:	ed8080e7          	jalr	-296(ra) # 5eea <mkdir>
    401a:	e549                	bnez	a0,40a4 <rmdot+0xa6>
  if(chdir("dots") != 0){
    401c:	00004517          	auipc	a0,0x4
    4020:	ca450513          	addi	a0,a0,-860 # 7cc0 <malloc+0x19f4>
    4024:	00002097          	auipc	ra,0x2
    4028:	ece080e7          	jalr	-306(ra) # 5ef2 <chdir>
    402c:	e951                	bnez	a0,40c0 <rmdot+0xc2>
  if(unlink(".") == 0){
    402e:	00003517          	auipc	a0,0x3
    4032:	ac250513          	addi	a0,a0,-1342 # 6af0 <malloc+0x824>
    4036:	00002097          	auipc	ra,0x2
    403a:	e9c080e7          	jalr	-356(ra) # 5ed2 <unlink>
    403e:	cd59                	beqz	a0,40dc <rmdot+0xde>
  if(unlink("..") == 0){
    4040:	00003517          	auipc	a0,0x3
    4044:	6d850513          	addi	a0,a0,1752 # 7718 <malloc+0x144c>
    4048:	00002097          	auipc	ra,0x2
    404c:	e8a080e7          	jalr	-374(ra) # 5ed2 <unlink>
    4050:	c545                	beqz	a0,40f8 <rmdot+0xfa>
  if(chdir("/") != 0){
    4052:	00003517          	auipc	a0,0x3
    4056:	66e50513          	addi	a0,a0,1646 # 76c0 <malloc+0x13f4>
    405a:	00002097          	auipc	ra,0x2
    405e:	e98080e7          	jalr	-360(ra) # 5ef2 <chdir>
    4062:	e94d                	bnez	a0,4114 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    4064:	00004517          	auipc	a0,0x4
    4068:	cc450513          	addi	a0,a0,-828 # 7d28 <malloc+0x1a5c>
    406c:	00002097          	auipc	ra,0x2
    4070:	e66080e7          	jalr	-410(ra) # 5ed2 <unlink>
    4074:	cd55                	beqz	a0,4130 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    4076:	00004517          	auipc	a0,0x4
    407a:	cda50513          	addi	a0,a0,-806 # 7d50 <malloc+0x1a84>
    407e:	00002097          	auipc	ra,0x2
    4082:	e54080e7          	jalr	-428(ra) # 5ed2 <unlink>
    4086:	c179                	beqz	a0,414c <rmdot+0x14e>
  if(unlink("dots") != 0){
    4088:	00004517          	auipc	a0,0x4
    408c:	c3850513          	addi	a0,a0,-968 # 7cc0 <malloc+0x19f4>
    4090:	00002097          	auipc	ra,0x2
    4094:	e42080e7          	jalr	-446(ra) # 5ed2 <unlink>
    4098:	e961                	bnez	a0,4168 <rmdot+0x16a>
}
    409a:	60e2                	ld	ra,24(sp)
    409c:	6442                	ld	s0,16(sp)
    409e:	64a2                	ld	s1,8(sp)
    40a0:	6105                	addi	sp,sp,32
    40a2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    40a4:	85a6                	mv	a1,s1
    40a6:	00004517          	auipc	a0,0x4
    40aa:	c2250513          	addi	a0,a0,-990 # 7cc8 <malloc+0x19fc>
    40ae:	00002097          	auipc	ra,0x2
    40b2:	162080e7          	jalr	354(ra) # 6210 <printf>
    exit(1);
    40b6:	4505                	li	a0,1
    40b8:	00002097          	auipc	ra,0x2
    40bc:	dca080e7          	jalr	-566(ra) # 5e82 <exit>
    printf("%s: chdir dots failed\n", s);
    40c0:	85a6                	mv	a1,s1
    40c2:	00004517          	auipc	a0,0x4
    40c6:	c1e50513          	addi	a0,a0,-994 # 7ce0 <malloc+0x1a14>
    40ca:	00002097          	auipc	ra,0x2
    40ce:	146080e7          	jalr	326(ra) # 6210 <printf>
    exit(1);
    40d2:	4505                	li	a0,1
    40d4:	00002097          	auipc	ra,0x2
    40d8:	dae080e7          	jalr	-594(ra) # 5e82 <exit>
    printf("%s: rm . worked!\n", s);
    40dc:	85a6                	mv	a1,s1
    40de:	00004517          	auipc	a0,0x4
    40e2:	c1a50513          	addi	a0,a0,-998 # 7cf8 <malloc+0x1a2c>
    40e6:	00002097          	auipc	ra,0x2
    40ea:	12a080e7          	jalr	298(ra) # 6210 <printf>
    exit(1);
    40ee:	4505                	li	a0,1
    40f0:	00002097          	auipc	ra,0x2
    40f4:	d92080e7          	jalr	-622(ra) # 5e82 <exit>
    printf("%s: rm .. worked!\n", s);
    40f8:	85a6                	mv	a1,s1
    40fa:	00004517          	auipc	a0,0x4
    40fe:	c1650513          	addi	a0,a0,-1002 # 7d10 <malloc+0x1a44>
    4102:	00002097          	auipc	ra,0x2
    4106:	10e080e7          	jalr	270(ra) # 6210 <printf>
    exit(1);
    410a:	4505                	li	a0,1
    410c:	00002097          	auipc	ra,0x2
    4110:	d76080e7          	jalr	-650(ra) # 5e82 <exit>
    printf("%s: chdir / failed\n", s);
    4114:	85a6                	mv	a1,s1
    4116:	00003517          	auipc	a0,0x3
    411a:	5b250513          	addi	a0,a0,1458 # 76c8 <malloc+0x13fc>
    411e:	00002097          	auipc	ra,0x2
    4122:	0f2080e7          	jalr	242(ra) # 6210 <printf>
    exit(1);
    4126:	4505                	li	a0,1
    4128:	00002097          	auipc	ra,0x2
    412c:	d5a080e7          	jalr	-678(ra) # 5e82 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    4130:	85a6                	mv	a1,s1
    4132:	00004517          	auipc	a0,0x4
    4136:	bfe50513          	addi	a0,a0,-1026 # 7d30 <malloc+0x1a64>
    413a:	00002097          	auipc	ra,0x2
    413e:	0d6080e7          	jalr	214(ra) # 6210 <printf>
    exit(1);
    4142:	4505                	li	a0,1
    4144:	00002097          	auipc	ra,0x2
    4148:	d3e080e7          	jalr	-706(ra) # 5e82 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    414c:	85a6                	mv	a1,s1
    414e:	00004517          	auipc	a0,0x4
    4152:	c0a50513          	addi	a0,a0,-1014 # 7d58 <malloc+0x1a8c>
    4156:	00002097          	auipc	ra,0x2
    415a:	0ba080e7          	jalr	186(ra) # 6210 <printf>
    exit(1);
    415e:	4505                	li	a0,1
    4160:	00002097          	auipc	ra,0x2
    4164:	d22080e7          	jalr	-734(ra) # 5e82 <exit>
    printf("%s: unlink dots failed!\n", s);
    4168:	85a6                	mv	a1,s1
    416a:	00004517          	auipc	a0,0x4
    416e:	c0e50513          	addi	a0,a0,-1010 # 7d78 <malloc+0x1aac>
    4172:	00002097          	auipc	ra,0x2
    4176:	09e080e7          	jalr	158(ra) # 6210 <printf>
    exit(1);
    417a:	4505                	li	a0,1
    417c:	00002097          	auipc	ra,0x2
    4180:	d06080e7          	jalr	-762(ra) # 5e82 <exit>

0000000000004184 <dirfile>:
{
    4184:	1101                	addi	sp,sp,-32
    4186:	ec06                	sd	ra,24(sp)
    4188:	e822                	sd	s0,16(sp)
    418a:	e426                	sd	s1,8(sp)
    418c:	e04a                	sd	s2,0(sp)
    418e:	1000                	addi	s0,sp,32
    4190:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4192:	20000593          	li	a1,512
    4196:	00004517          	auipc	a0,0x4
    419a:	c0250513          	addi	a0,a0,-1022 # 7d98 <malloc+0x1acc>
    419e:	00002097          	auipc	ra,0x2
    41a2:	d24080e7          	jalr	-732(ra) # 5ec2 <open>
  if(fd < 0){
    41a6:	0e054d63          	bltz	a0,42a0 <dirfile+0x11c>
  close(fd);
    41aa:	00002097          	auipc	ra,0x2
    41ae:	d00080e7          	jalr	-768(ra) # 5eaa <close>
  if(chdir("dirfile") == 0){
    41b2:	00004517          	auipc	a0,0x4
    41b6:	be650513          	addi	a0,a0,-1050 # 7d98 <malloc+0x1acc>
    41ba:	00002097          	auipc	ra,0x2
    41be:	d38080e7          	jalr	-712(ra) # 5ef2 <chdir>
    41c2:	cd6d                	beqz	a0,42bc <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    41c4:	4581                	li	a1,0
    41c6:	00004517          	auipc	a0,0x4
    41ca:	c1a50513          	addi	a0,a0,-998 # 7de0 <malloc+0x1b14>
    41ce:	00002097          	auipc	ra,0x2
    41d2:	cf4080e7          	jalr	-780(ra) # 5ec2 <open>
  if(fd >= 0){
    41d6:	10055163          	bgez	a0,42d8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    41da:	20000593          	li	a1,512
    41de:	00004517          	auipc	a0,0x4
    41e2:	c0250513          	addi	a0,a0,-1022 # 7de0 <malloc+0x1b14>
    41e6:	00002097          	auipc	ra,0x2
    41ea:	cdc080e7          	jalr	-804(ra) # 5ec2 <open>
  if(fd >= 0){
    41ee:	10055363          	bgez	a0,42f4 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    41f2:	00004517          	auipc	a0,0x4
    41f6:	bee50513          	addi	a0,a0,-1042 # 7de0 <malloc+0x1b14>
    41fa:	00002097          	auipc	ra,0x2
    41fe:	cf0080e7          	jalr	-784(ra) # 5eea <mkdir>
    4202:	10050763          	beqz	a0,4310 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    4206:	00004517          	auipc	a0,0x4
    420a:	bda50513          	addi	a0,a0,-1062 # 7de0 <malloc+0x1b14>
    420e:	00002097          	auipc	ra,0x2
    4212:	cc4080e7          	jalr	-828(ra) # 5ed2 <unlink>
    4216:	10050b63          	beqz	a0,432c <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    421a:	00004597          	auipc	a1,0x4
    421e:	bc658593          	addi	a1,a1,-1082 # 7de0 <malloc+0x1b14>
    4222:	00002517          	auipc	a0,0x2
    4226:	3be50513          	addi	a0,a0,958 # 65e0 <malloc+0x314>
    422a:	00002097          	auipc	ra,0x2
    422e:	cb8080e7          	jalr	-840(ra) # 5ee2 <link>
    4232:	10050b63          	beqz	a0,4348 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    4236:	00004517          	auipc	a0,0x4
    423a:	b6250513          	addi	a0,a0,-1182 # 7d98 <malloc+0x1acc>
    423e:	00002097          	auipc	ra,0x2
    4242:	c94080e7          	jalr	-876(ra) # 5ed2 <unlink>
    4246:	10051f63          	bnez	a0,4364 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    424a:	4589                	li	a1,2
    424c:	00003517          	auipc	a0,0x3
    4250:	8a450513          	addi	a0,a0,-1884 # 6af0 <malloc+0x824>
    4254:	00002097          	auipc	ra,0x2
    4258:	c6e080e7          	jalr	-914(ra) # 5ec2 <open>
  if(fd >= 0){
    425c:	12055263          	bgez	a0,4380 <dirfile+0x1fc>
  fd = open(".", 0);
    4260:	4581                	li	a1,0
    4262:	00003517          	auipc	a0,0x3
    4266:	88e50513          	addi	a0,a0,-1906 # 6af0 <malloc+0x824>
    426a:	00002097          	auipc	ra,0x2
    426e:	c58080e7          	jalr	-936(ra) # 5ec2 <open>
    4272:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    4274:	4605                	li	a2,1
    4276:	00002597          	auipc	a1,0x2
    427a:	20258593          	addi	a1,a1,514 # 6478 <malloc+0x1ac>
    427e:	00002097          	auipc	ra,0x2
    4282:	c24080e7          	jalr	-988(ra) # 5ea2 <write>
    4286:	10a04b63          	bgtz	a0,439c <dirfile+0x218>
  close(fd);
    428a:	8526                	mv	a0,s1
    428c:	00002097          	auipc	ra,0x2
    4290:	c1e080e7          	jalr	-994(ra) # 5eaa <close>
}
    4294:	60e2                	ld	ra,24(sp)
    4296:	6442                	ld	s0,16(sp)
    4298:	64a2                	ld	s1,8(sp)
    429a:	6902                	ld	s2,0(sp)
    429c:	6105                	addi	sp,sp,32
    429e:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    42a0:	85ca                	mv	a1,s2
    42a2:	00004517          	auipc	a0,0x4
    42a6:	afe50513          	addi	a0,a0,-1282 # 7da0 <malloc+0x1ad4>
    42aa:	00002097          	auipc	ra,0x2
    42ae:	f66080e7          	jalr	-154(ra) # 6210 <printf>
    exit(1);
    42b2:	4505                	li	a0,1
    42b4:	00002097          	auipc	ra,0x2
    42b8:	bce080e7          	jalr	-1074(ra) # 5e82 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    42bc:	85ca                	mv	a1,s2
    42be:	00004517          	auipc	a0,0x4
    42c2:	b0250513          	addi	a0,a0,-1278 # 7dc0 <malloc+0x1af4>
    42c6:	00002097          	auipc	ra,0x2
    42ca:	f4a080e7          	jalr	-182(ra) # 6210 <printf>
    exit(1);
    42ce:	4505                	li	a0,1
    42d0:	00002097          	auipc	ra,0x2
    42d4:	bb2080e7          	jalr	-1102(ra) # 5e82 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    42d8:	85ca                	mv	a1,s2
    42da:	00004517          	auipc	a0,0x4
    42de:	b1650513          	addi	a0,a0,-1258 # 7df0 <malloc+0x1b24>
    42e2:	00002097          	auipc	ra,0x2
    42e6:	f2e080e7          	jalr	-210(ra) # 6210 <printf>
    exit(1);
    42ea:	4505                	li	a0,1
    42ec:	00002097          	auipc	ra,0x2
    42f0:	b96080e7          	jalr	-1130(ra) # 5e82 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    42f4:	85ca                	mv	a1,s2
    42f6:	00004517          	auipc	a0,0x4
    42fa:	afa50513          	addi	a0,a0,-1286 # 7df0 <malloc+0x1b24>
    42fe:	00002097          	auipc	ra,0x2
    4302:	f12080e7          	jalr	-238(ra) # 6210 <printf>
    exit(1);
    4306:	4505                	li	a0,1
    4308:	00002097          	auipc	ra,0x2
    430c:	b7a080e7          	jalr	-1158(ra) # 5e82 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4310:	85ca                	mv	a1,s2
    4312:	00004517          	auipc	a0,0x4
    4316:	b0650513          	addi	a0,a0,-1274 # 7e18 <malloc+0x1b4c>
    431a:	00002097          	auipc	ra,0x2
    431e:	ef6080e7          	jalr	-266(ra) # 6210 <printf>
    exit(1);
    4322:	4505                	li	a0,1
    4324:	00002097          	auipc	ra,0x2
    4328:	b5e080e7          	jalr	-1186(ra) # 5e82 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    432c:	85ca                	mv	a1,s2
    432e:	00004517          	auipc	a0,0x4
    4332:	b1250513          	addi	a0,a0,-1262 # 7e40 <malloc+0x1b74>
    4336:	00002097          	auipc	ra,0x2
    433a:	eda080e7          	jalr	-294(ra) # 6210 <printf>
    exit(1);
    433e:	4505                	li	a0,1
    4340:	00002097          	auipc	ra,0x2
    4344:	b42080e7          	jalr	-1214(ra) # 5e82 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4348:	85ca                	mv	a1,s2
    434a:	00004517          	auipc	a0,0x4
    434e:	b1e50513          	addi	a0,a0,-1250 # 7e68 <malloc+0x1b9c>
    4352:	00002097          	auipc	ra,0x2
    4356:	ebe080e7          	jalr	-322(ra) # 6210 <printf>
    exit(1);
    435a:	4505                	li	a0,1
    435c:	00002097          	auipc	ra,0x2
    4360:	b26080e7          	jalr	-1242(ra) # 5e82 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4364:	85ca                	mv	a1,s2
    4366:	00004517          	auipc	a0,0x4
    436a:	b2a50513          	addi	a0,a0,-1238 # 7e90 <malloc+0x1bc4>
    436e:	00002097          	auipc	ra,0x2
    4372:	ea2080e7          	jalr	-350(ra) # 6210 <printf>
    exit(1);
    4376:	4505                	li	a0,1
    4378:	00002097          	auipc	ra,0x2
    437c:	b0a080e7          	jalr	-1270(ra) # 5e82 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4380:	85ca                	mv	a1,s2
    4382:	00004517          	auipc	a0,0x4
    4386:	b2e50513          	addi	a0,a0,-1234 # 7eb0 <malloc+0x1be4>
    438a:	00002097          	auipc	ra,0x2
    438e:	e86080e7          	jalr	-378(ra) # 6210 <printf>
    exit(1);
    4392:	4505                	li	a0,1
    4394:	00002097          	auipc	ra,0x2
    4398:	aee080e7          	jalr	-1298(ra) # 5e82 <exit>
    printf("%s: write . succeeded!\n", s);
    439c:	85ca                	mv	a1,s2
    439e:	00004517          	auipc	a0,0x4
    43a2:	b3a50513          	addi	a0,a0,-1222 # 7ed8 <malloc+0x1c0c>
    43a6:	00002097          	auipc	ra,0x2
    43aa:	e6a080e7          	jalr	-406(ra) # 6210 <printf>
    exit(1);
    43ae:	4505                	li	a0,1
    43b0:	00002097          	auipc	ra,0x2
    43b4:	ad2080e7          	jalr	-1326(ra) # 5e82 <exit>

00000000000043b8 <iref>:
{
    43b8:	715d                	addi	sp,sp,-80
    43ba:	e486                	sd	ra,72(sp)
    43bc:	e0a2                	sd	s0,64(sp)
    43be:	fc26                	sd	s1,56(sp)
    43c0:	f84a                	sd	s2,48(sp)
    43c2:	f44e                	sd	s3,40(sp)
    43c4:	f052                	sd	s4,32(sp)
    43c6:	ec56                	sd	s5,24(sp)
    43c8:	e85a                	sd	s6,16(sp)
    43ca:	e45e                	sd	s7,8(sp)
    43cc:	0880                	addi	s0,sp,80
    43ce:	8baa                	mv	s7,a0
    43d0:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    43d4:	00004a97          	auipc	s5,0x4
    43d8:	b1ca8a93          	addi	s5,s5,-1252 # 7ef0 <malloc+0x1c24>
    mkdir("");
    43dc:	00003497          	auipc	s1,0x3
    43e0:	61c48493          	addi	s1,s1,1564 # 79f8 <malloc+0x172c>
    link("README", "");
    43e4:	00002b17          	auipc	s6,0x2
    43e8:	1fcb0b13          	addi	s6,s6,508 # 65e0 <malloc+0x314>
    fd = open("", O_CREATE);
    43ec:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    43f0:	00004997          	auipc	s3,0x4
    43f4:	9f898993          	addi	s3,s3,-1544 # 7de8 <malloc+0x1b1c>
    43f8:	a891                	j	444c <iref+0x94>
      printf("%s: mkdir irefd failed\n", s);
    43fa:	85de                	mv	a1,s7
    43fc:	00004517          	auipc	a0,0x4
    4400:	afc50513          	addi	a0,a0,-1284 # 7ef8 <malloc+0x1c2c>
    4404:	00002097          	auipc	ra,0x2
    4408:	e0c080e7          	jalr	-500(ra) # 6210 <printf>
      exit(1);
    440c:	4505                	li	a0,1
    440e:	00002097          	auipc	ra,0x2
    4412:	a74080e7          	jalr	-1420(ra) # 5e82 <exit>
      printf("%s: chdir irefd failed\n", s);
    4416:	85de                	mv	a1,s7
    4418:	00004517          	auipc	a0,0x4
    441c:	af850513          	addi	a0,a0,-1288 # 7f10 <malloc+0x1c44>
    4420:	00002097          	auipc	ra,0x2
    4424:	df0080e7          	jalr	-528(ra) # 6210 <printf>
      exit(1);
    4428:	4505                	li	a0,1
    442a:	00002097          	auipc	ra,0x2
    442e:	a58080e7          	jalr	-1448(ra) # 5e82 <exit>
      close(fd);
    4432:	00002097          	auipc	ra,0x2
    4436:	a78080e7          	jalr	-1416(ra) # 5eaa <close>
    443a:	a881                	j	448a <iref+0xd2>
    unlink("xx");
    443c:	854e                	mv	a0,s3
    443e:	00002097          	auipc	ra,0x2
    4442:	a94080e7          	jalr	-1388(ra) # 5ed2 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4446:	397d                	addiw	s2,s2,-1
    4448:	04090e63          	beqz	s2,44a4 <iref+0xec>
    if(mkdir("irefd") != 0){
    444c:	8556                	mv	a0,s5
    444e:	00002097          	auipc	ra,0x2
    4452:	a9c080e7          	jalr	-1380(ra) # 5eea <mkdir>
    4456:	f155                	bnez	a0,43fa <iref+0x42>
    if(chdir("irefd") != 0){
    4458:	8556                	mv	a0,s5
    445a:	00002097          	auipc	ra,0x2
    445e:	a98080e7          	jalr	-1384(ra) # 5ef2 <chdir>
    4462:	f955                	bnez	a0,4416 <iref+0x5e>
    mkdir("");
    4464:	8526                	mv	a0,s1
    4466:	00002097          	auipc	ra,0x2
    446a:	a84080e7          	jalr	-1404(ra) # 5eea <mkdir>
    link("README", "");
    446e:	85a6                	mv	a1,s1
    4470:	855a                	mv	a0,s6
    4472:	00002097          	auipc	ra,0x2
    4476:	a70080e7          	jalr	-1424(ra) # 5ee2 <link>
    fd = open("", O_CREATE);
    447a:	85d2                	mv	a1,s4
    447c:	8526                	mv	a0,s1
    447e:	00002097          	auipc	ra,0x2
    4482:	a44080e7          	jalr	-1468(ra) # 5ec2 <open>
    if(fd >= 0)
    4486:	fa0556e3          	bgez	a0,4432 <iref+0x7a>
    fd = open("xx", O_CREATE);
    448a:	85d2                	mv	a1,s4
    448c:	854e                	mv	a0,s3
    448e:	00002097          	auipc	ra,0x2
    4492:	a34080e7          	jalr	-1484(ra) # 5ec2 <open>
    if(fd >= 0)
    4496:	fa0543e3          	bltz	a0,443c <iref+0x84>
      close(fd);
    449a:	00002097          	auipc	ra,0x2
    449e:	a10080e7          	jalr	-1520(ra) # 5eaa <close>
    44a2:	bf69                	j	443c <iref+0x84>
    44a4:	03300493          	li	s1,51
    chdir("..");
    44a8:	00003997          	auipc	s3,0x3
    44ac:	27098993          	addi	s3,s3,624 # 7718 <malloc+0x144c>
    unlink("irefd");
    44b0:	00004917          	auipc	s2,0x4
    44b4:	a4090913          	addi	s2,s2,-1472 # 7ef0 <malloc+0x1c24>
    chdir("..");
    44b8:	854e                	mv	a0,s3
    44ba:	00002097          	auipc	ra,0x2
    44be:	a38080e7          	jalr	-1480(ra) # 5ef2 <chdir>
    unlink("irefd");
    44c2:	854a                	mv	a0,s2
    44c4:	00002097          	auipc	ra,0x2
    44c8:	a0e080e7          	jalr	-1522(ra) # 5ed2 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    44cc:	34fd                	addiw	s1,s1,-1
    44ce:	f4ed                	bnez	s1,44b8 <iref+0x100>
  chdir("/");
    44d0:	00003517          	auipc	a0,0x3
    44d4:	1f050513          	addi	a0,a0,496 # 76c0 <malloc+0x13f4>
    44d8:	00002097          	auipc	ra,0x2
    44dc:	a1a080e7          	jalr	-1510(ra) # 5ef2 <chdir>
}
    44e0:	60a6                	ld	ra,72(sp)
    44e2:	6406                	ld	s0,64(sp)
    44e4:	74e2                	ld	s1,56(sp)
    44e6:	7942                	ld	s2,48(sp)
    44e8:	79a2                	ld	s3,40(sp)
    44ea:	7a02                	ld	s4,32(sp)
    44ec:	6ae2                	ld	s5,24(sp)
    44ee:	6b42                	ld	s6,16(sp)
    44f0:	6ba2                	ld	s7,8(sp)
    44f2:	6161                	addi	sp,sp,80
    44f4:	8082                	ret

00000000000044f6 <openiputtest>:
{
    44f6:	7179                	addi	sp,sp,-48
    44f8:	f406                	sd	ra,40(sp)
    44fa:	f022                	sd	s0,32(sp)
    44fc:	ec26                	sd	s1,24(sp)
    44fe:	1800                	addi	s0,sp,48
    4500:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4502:	00004517          	auipc	a0,0x4
    4506:	a2650513          	addi	a0,a0,-1498 # 7f28 <malloc+0x1c5c>
    450a:	00002097          	auipc	ra,0x2
    450e:	9e0080e7          	jalr	-1568(ra) # 5eea <mkdir>
    4512:	04054263          	bltz	a0,4556 <openiputtest+0x60>
  pid = fork();
    4516:	00002097          	auipc	ra,0x2
    451a:	964080e7          	jalr	-1692(ra) # 5e7a <fork>
  if(pid < 0){
    451e:	04054a63          	bltz	a0,4572 <openiputtest+0x7c>
  if(pid == 0){
    4522:	e93d                	bnez	a0,4598 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4524:	4589                	li	a1,2
    4526:	00004517          	auipc	a0,0x4
    452a:	a0250513          	addi	a0,a0,-1534 # 7f28 <malloc+0x1c5c>
    452e:	00002097          	auipc	ra,0x2
    4532:	994080e7          	jalr	-1644(ra) # 5ec2 <open>
    if(fd >= 0){
    4536:	04054c63          	bltz	a0,458e <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    453a:	85a6                	mv	a1,s1
    453c:	00004517          	auipc	a0,0x4
    4540:	a0c50513          	addi	a0,a0,-1524 # 7f48 <malloc+0x1c7c>
    4544:	00002097          	auipc	ra,0x2
    4548:	ccc080e7          	jalr	-820(ra) # 6210 <printf>
      exit(1);
    454c:	4505                	li	a0,1
    454e:	00002097          	auipc	ra,0x2
    4552:	934080e7          	jalr	-1740(ra) # 5e82 <exit>
    printf("%s: mkdir oidir failed\n", s);
    4556:	85a6                	mv	a1,s1
    4558:	00004517          	auipc	a0,0x4
    455c:	9d850513          	addi	a0,a0,-1576 # 7f30 <malloc+0x1c64>
    4560:	00002097          	auipc	ra,0x2
    4564:	cb0080e7          	jalr	-848(ra) # 6210 <printf>
    exit(1);
    4568:	4505                	li	a0,1
    456a:	00002097          	auipc	ra,0x2
    456e:	918080e7          	jalr	-1768(ra) # 5e82 <exit>
    printf("%s: fork failed\n", s);
    4572:	85a6                	mv	a1,s1
    4574:	00002517          	auipc	a0,0x2
    4578:	71c50513          	addi	a0,a0,1820 # 6c90 <malloc+0x9c4>
    457c:	00002097          	auipc	ra,0x2
    4580:	c94080e7          	jalr	-876(ra) # 6210 <printf>
    exit(1);
    4584:	4505                	li	a0,1
    4586:	00002097          	auipc	ra,0x2
    458a:	8fc080e7          	jalr	-1796(ra) # 5e82 <exit>
    exit(0);
    458e:	4501                	li	a0,0
    4590:	00002097          	auipc	ra,0x2
    4594:	8f2080e7          	jalr	-1806(ra) # 5e82 <exit>
  sleep(1);
    4598:	4505                	li	a0,1
    459a:	00002097          	auipc	ra,0x2
    459e:	978080e7          	jalr	-1672(ra) # 5f12 <sleep>
  if(unlink("oidir") != 0){
    45a2:	00004517          	auipc	a0,0x4
    45a6:	98650513          	addi	a0,a0,-1658 # 7f28 <malloc+0x1c5c>
    45aa:	00002097          	auipc	ra,0x2
    45ae:	928080e7          	jalr	-1752(ra) # 5ed2 <unlink>
    45b2:	cd19                	beqz	a0,45d0 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    45b4:	85a6                	mv	a1,s1
    45b6:	00003517          	auipc	a0,0x3
    45ba:	8ca50513          	addi	a0,a0,-1846 # 6e80 <malloc+0xbb4>
    45be:	00002097          	auipc	ra,0x2
    45c2:	c52080e7          	jalr	-942(ra) # 6210 <printf>
    exit(1);
    45c6:	4505                	li	a0,1
    45c8:	00002097          	auipc	ra,0x2
    45cc:	8ba080e7          	jalr	-1862(ra) # 5e82 <exit>
  wait(&xstatus);
    45d0:	fdc40513          	addi	a0,s0,-36
    45d4:	00002097          	auipc	ra,0x2
    45d8:	8b6080e7          	jalr	-1866(ra) # 5e8a <wait>
  exit(xstatus);
    45dc:	fdc42503          	lw	a0,-36(s0)
    45e0:	00002097          	auipc	ra,0x2
    45e4:	8a2080e7          	jalr	-1886(ra) # 5e82 <exit>

00000000000045e8 <forkforkfork>:
{
    45e8:	1101                	addi	sp,sp,-32
    45ea:	ec06                	sd	ra,24(sp)
    45ec:	e822                	sd	s0,16(sp)
    45ee:	e426                	sd	s1,8(sp)
    45f0:	1000                	addi	s0,sp,32
    45f2:	84aa                	mv	s1,a0
  unlink("stopforking");
    45f4:	00004517          	auipc	a0,0x4
    45f8:	97c50513          	addi	a0,a0,-1668 # 7f70 <malloc+0x1ca4>
    45fc:	00002097          	auipc	ra,0x2
    4600:	8d6080e7          	jalr	-1834(ra) # 5ed2 <unlink>
  int pid = fork();
    4604:	00002097          	auipc	ra,0x2
    4608:	876080e7          	jalr	-1930(ra) # 5e7a <fork>
  if(pid < 0){
    460c:	04054563          	bltz	a0,4656 <forkforkfork+0x6e>
  if(pid == 0){
    4610:	c12d                	beqz	a0,4672 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4612:	4551                	li	a0,20
    4614:	00002097          	auipc	ra,0x2
    4618:	8fe080e7          	jalr	-1794(ra) # 5f12 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    461c:	20200593          	li	a1,514
    4620:	00004517          	auipc	a0,0x4
    4624:	95050513          	addi	a0,a0,-1712 # 7f70 <malloc+0x1ca4>
    4628:	00002097          	auipc	ra,0x2
    462c:	89a080e7          	jalr	-1894(ra) # 5ec2 <open>
    4630:	00002097          	auipc	ra,0x2
    4634:	87a080e7          	jalr	-1926(ra) # 5eaa <close>
  wait(0);
    4638:	4501                	li	a0,0
    463a:	00002097          	auipc	ra,0x2
    463e:	850080e7          	jalr	-1968(ra) # 5e8a <wait>
  sleep(10); // one second
    4642:	4529                	li	a0,10
    4644:	00002097          	auipc	ra,0x2
    4648:	8ce080e7          	jalr	-1842(ra) # 5f12 <sleep>
}
    464c:	60e2                	ld	ra,24(sp)
    464e:	6442                	ld	s0,16(sp)
    4650:	64a2                	ld	s1,8(sp)
    4652:	6105                	addi	sp,sp,32
    4654:	8082                	ret
    printf("%s: fork failed", s);
    4656:	85a6                	mv	a1,s1
    4658:	00002517          	auipc	a0,0x2
    465c:	7f850513          	addi	a0,a0,2040 # 6e50 <malloc+0xb84>
    4660:	00002097          	auipc	ra,0x2
    4664:	bb0080e7          	jalr	-1104(ra) # 6210 <printf>
    exit(1);
    4668:	4505                	li	a0,1
    466a:	00002097          	auipc	ra,0x2
    466e:	818080e7          	jalr	-2024(ra) # 5e82 <exit>
      int fd = open("stopforking", 0);
    4672:	4581                	li	a1,0
    4674:	00004517          	auipc	a0,0x4
    4678:	8fc50513          	addi	a0,a0,-1796 # 7f70 <malloc+0x1ca4>
    467c:	00002097          	auipc	ra,0x2
    4680:	846080e7          	jalr	-1978(ra) # 5ec2 <open>
      if(fd >= 0){
    4684:	02055763          	bgez	a0,46b2 <forkforkfork+0xca>
      if(fork() < 0){
    4688:	00001097          	auipc	ra,0x1
    468c:	7f2080e7          	jalr	2034(ra) # 5e7a <fork>
    4690:	fe0551e3          	bgez	a0,4672 <forkforkfork+0x8a>
        close(open("stopforking", O_CREATE|O_RDWR));
    4694:	20200593          	li	a1,514
    4698:	00004517          	auipc	a0,0x4
    469c:	8d850513          	addi	a0,a0,-1832 # 7f70 <malloc+0x1ca4>
    46a0:	00002097          	auipc	ra,0x2
    46a4:	822080e7          	jalr	-2014(ra) # 5ec2 <open>
    46a8:	00002097          	auipc	ra,0x2
    46ac:	802080e7          	jalr	-2046(ra) # 5eaa <close>
    46b0:	b7c9                	j	4672 <forkforkfork+0x8a>
        exit(0);
    46b2:	4501                	li	a0,0
    46b4:	00001097          	auipc	ra,0x1
    46b8:	7ce080e7          	jalr	1998(ra) # 5e82 <exit>

00000000000046bc <killstatus>:
{
    46bc:	715d                	addi	sp,sp,-80
    46be:	e486                	sd	ra,72(sp)
    46c0:	e0a2                	sd	s0,64(sp)
    46c2:	fc26                	sd	s1,56(sp)
    46c4:	f84a                	sd	s2,48(sp)
    46c6:	f44e                	sd	s3,40(sp)
    46c8:	f052                	sd	s4,32(sp)
    46ca:	ec56                	sd	s5,24(sp)
    46cc:	e85a                	sd	s6,16(sp)
    46ce:	0880                	addi	s0,sp,80
    46d0:	8b2a                	mv	s6,a0
    46d2:	06400913          	li	s2,100
    sleep(1);
    46d6:	4a85                	li	s5,1
    wait(&xst);
    46d8:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    46dc:	59fd                	li	s3,-1
    int pid1 = fork();
    46de:	00001097          	auipc	ra,0x1
    46e2:	79c080e7          	jalr	1948(ra) # 5e7a <fork>
    46e6:	84aa                	mv	s1,a0
    if(pid1 < 0){
    46e8:	02054e63          	bltz	a0,4724 <killstatus+0x68>
    if(pid1 == 0){
    46ec:	c931                	beqz	a0,4740 <killstatus+0x84>
    sleep(1);
    46ee:	8556                	mv	a0,s5
    46f0:	00002097          	auipc	ra,0x2
    46f4:	822080e7          	jalr	-2014(ra) # 5f12 <sleep>
    kill(pid1);
    46f8:	8526                	mv	a0,s1
    46fa:	00001097          	auipc	ra,0x1
    46fe:	7b8080e7          	jalr	1976(ra) # 5eb2 <kill>
    wait(&xst);
    4702:	8552                	mv	a0,s4
    4704:	00001097          	auipc	ra,0x1
    4708:	786080e7          	jalr	1926(ra) # 5e8a <wait>
    if(xst != -1) {
    470c:	fbc42783          	lw	a5,-68(s0)
    4710:	03379d63          	bne	a5,s3,474a <killstatus+0x8e>
  for(int i = 0; i < 100; i++){
    4714:	397d                	addiw	s2,s2,-1
    4716:	fc0914e3          	bnez	s2,46de <killstatus+0x22>
  exit(0);
    471a:	4501                	li	a0,0
    471c:	00001097          	auipc	ra,0x1
    4720:	766080e7          	jalr	1894(ra) # 5e82 <exit>
      printf("%s: fork failed\n", s);
    4724:	85da                	mv	a1,s6
    4726:	00002517          	auipc	a0,0x2
    472a:	56a50513          	addi	a0,a0,1386 # 6c90 <malloc+0x9c4>
    472e:	00002097          	auipc	ra,0x2
    4732:	ae2080e7          	jalr	-1310(ra) # 6210 <printf>
      exit(1);
    4736:	4505                	li	a0,1
    4738:	00001097          	auipc	ra,0x1
    473c:	74a080e7          	jalr	1866(ra) # 5e82 <exit>
        getpid();
    4740:	00001097          	auipc	ra,0x1
    4744:	7c2080e7          	jalr	1986(ra) # 5f02 <getpid>
      while(1) {
    4748:	bfe5                	j	4740 <killstatus+0x84>
       printf("%s: status should be -1\n", s);
    474a:	85da                	mv	a1,s6
    474c:	00004517          	auipc	a0,0x4
    4750:	83450513          	addi	a0,a0,-1996 # 7f80 <malloc+0x1cb4>
    4754:	00002097          	auipc	ra,0x2
    4758:	abc080e7          	jalr	-1348(ra) # 6210 <printf>
       exit(1);
    475c:	4505                	li	a0,1
    475e:	00001097          	auipc	ra,0x1
    4762:	724080e7          	jalr	1828(ra) # 5e82 <exit>

0000000000004766 <preempt>:
{
    4766:	7139                	addi	sp,sp,-64
    4768:	fc06                	sd	ra,56(sp)
    476a:	f822                	sd	s0,48(sp)
    476c:	f426                	sd	s1,40(sp)
    476e:	f04a                	sd	s2,32(sp)
    4770:	ec4e                	sd	s3,24(sp)
    4772:	e852                	sd	s4,16(sp)
    4774:	0080                	addi	s0,sp,64
    4776:	892a                	mv	s2,a0
  pid1 = fork();
    4778:	00001097          	auipc	ra,0x1
    477c:	702080e7          	jalr	1794(ra) # 5e7a <fork>
  if(pid1 < 0) {
    4780:	00054563          	bltz	a0,478a <preempt+0x24>
    4784:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4786:	e105                	bnez	a0,47a6 <preempt+0x40>
    for(;;)
    4788:	a001                	j	4788 <preempt+0x22>
    printf("%s: fork failed", s);
    478a:	85ca                	mv	a1,s2
    478c:	00002517          	auipc	a0,0x2
    4790:	6c450513          	addi	a0,a0,1732 # 6e50 <malloc+0xb84>
    4794:	00002097          	auipc	ra,0x2
    4798:	a7c080e7          	jalr	-1412(ra) # 6210 <printf>
    exit(1);
    479c:	4505                	li	a0,1
    479e:	00001097          	auipc	ra,0x1
    47a2:	6e4080e7          	jalr	1764(ra) # 5e82 <exit>
  pid2 = fork();
    47a6:	00001097          	auipc	ra,0x1
    47aa:	6d4080e7          	jalr	1748(ra) # 5e7a <fork>
    47ae:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    47b0:	00054463          	bltz	a0,47b8 <preempt+0x52>
  if(pid2 == 0)
    47b4:	e105                	bnez	a0,47d4 <preempt+0x6e>
    for(;;)
    47b6:	a001                	j	47b6 <preempt+0x50>
    printf("%s: fork failed\n", s);
    47b8:	85ca                	mv	a1,s2
    47ba:	00002517          	auipc	a0,0x2
    47be:	4d650513          	addi	a0,a0,1238 # 6c90 <malloc+0x9c4>
    47c2:	00002097          	auipc	ra,0x2
    47c6:	a4e080e7          	jalr	-1458(ra) # 6210 <printf>
    exit(1);
    47ca:	4505                	li	a0,1
    47cc:	00001097          	auipc	ra,0x1
    47d0:	6b6080e7          	jalr	1718(ra) # 5e82 <exit>
  pipe(pfds);
    47d4:	fc840513          	addi	a0,s0,-56
    47d8:	00001097          	auipc	ra,0x1
    47dc:	6ba080e7          	jalr	1722(ra) # 5e92 <pipe>
  pid3 = fork();
    47e0:	00001097          	auipc	ra,0x1
    47e4:	69a080e7          	jalr	1690(ra) # 5e7a <fork>
    47e8:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    47ea:	02054e63          	bltz	a0,4826 <preempt+0xc0>
  if(pid3 == 0){
    47ee:	e525                	bnez	a0,4856 <preempt+0xf0>
    close(pfds[0]);
    47f0:	fc842503          	lw	a0,-56(s0)
    47f4:	00001097          	auipc	ra,0x1
    47f8:	6b6080e7          	jalr	1718(ra) # 5eaa <close>
    if(write(pfds[1], "x", 1) != 1)
    47fc:	4605                	li	a2,1
    47fe:	00002597          	auipc	a1,0x2
    4802:	c7a58593          	addi	a1,a1,-902 # 6478 <malloc+0x1ac>
    4806:	fcc42503          	lw	a0,-52(s0)
    480a:	00001097          	auipc	ra,0x1
    480e:	698080e7          	jalr	1688(ra) # 5ea2 <write>
    4812:	4785                	li	a5,1
    4814:	02f51763          	bne	a0,a5,4842 <preempt+0xdc>
    close(pfds[1]);
    4818:	fcc42503          	lw	a0,-52(s0)
    481c:	00001097          	auipc	ra,0x1
    4820:	68e080e7          	jalr	1678(ra) # 5eaa <close>
    for(;;)
    4824:	a001                	j	4824 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4826:	85ca                	mv	a1,s2
    4828:	00002517          	auipc	a0,0x2
    482c:	46850513          	addi	a0,a0,1128 # 6c90 <malloc+0x9c4>
    4830:	00002097          	auipc	ra,0x2
    4834:	9e0080e7          	jalr	-1568(ra) # 6210 <printf>
     exit(1);
    4838:	4505                	li	a0,1
    483a:	00001097          	auipc	ra,0x1
    483e:	648080e7          	jalr	1608(ra) # 5e82 <exit>
      printf("%s: preempt write error", s);
    4842:	85ca                	mv	a1,s2
    4844:	00003517          	auipc	a0,0x3
    4848:	75c50513          	addi	a0,a0,1884 # 7fa0 <malloc+0x1cd4>
    484c:	00002097          	auipc	ra,0x2
    4850:	9c4080e7          	jalr	-1596(ra) # 6210 <printf>
    4854:	b7d1                	j	4818 <preempt+0xb2>
  close(pfds[1]);
    4856:	fcc42503          	lw	a0,-52(s0)
    485a:	00001097          	auipc	ra,0x1
    485e:	650080e7          	jalr	1616(ra) # 5eaa <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4862:	660d                	lui	a2,0x3
    4864:	00008597          	auipc	a1,0x8
    4868:	41458593          	addi	a1,a1,1044 # cc78 <buf>
    486c:	fc842503          	lw	a0,-56(s0)
    4870:	00001097          	auipc	ra,0x1
    4874:	62a080e7          	jalr	1578(ra) # 5e9a <read>
    4878:	4785                	li	a5,1
    487a:	02f50363          	beq	a0,a5,48a0 <preempt+0x13a>
    printf("%s: preempt read error", s);
    487e:	85ca                	mv	a1,s2
    4880:	00003517          	auipc	a0,0x3
    4884:	73850513          	addi	a0,a0,1848 # 7fb8 <malloc+0x1cec>
    4888:	00002097          	auipc	ra,0x2
    488c:	988080e7          	jalr	-1656(ra) # 6210 <printf>
}
    4890:	70e2                	ld	ra,56(sp)
    4892:	7442                	ld	s0,48(sp)
    4894:	74a2                	ld	s1,40(sp)
    4896:	7902                	ld	s2,32(sp)
    4898:	69e2                	ld	s3,24(sp)
    489a:	6a42                	ld	s4,16(sp)
    489c:	6121                	addi	sp,sp,64
    489e:	8082                	ret
  close(pfds[0]);
    48a0:	fc842503          	lw	a0,-56(s0)
    48a4:	00001097          	auipc	ra,0x1
    48a8:	606080e7          	jalr	1542(ra) # 5eaa <close>
  printf("kill... ");
    48ac:	00003517          	auipc	a0,0x3
    48b0:	72450513          	addi	a0,a0,1828 # 7fd0 <malloc+0x1d04>
    48b4:	00002097          	auipc	ra,0x2
    48b8:	95c080e7          	jalr	-1700(ra) # 6210 <printf>
  kill(pid1);
    48bc:	8526                	mv	a0,s1
    48be:	00001097          	auipc	ra,0x1
    48c2:	5f4080e7          	jalr	1524(ra) # 5eb2 <kill>
  kill(pid2);
    48c6:	854e                	mv	a0,s3
    48c8:	00001097          	auipc	ra,0x1
    48cc:	5ea080e7          	jalr	1514(ra) # 5eb2 <kill>
  kill(pid3);
    48d0:	8552                	mv	a0,s4
    48d2:	00001097          	auipc	ra,0x1
    48d6:	5e0080e7          	jalr	1504(ra) # 5eb2 <kill>
  printf("wait... ");
    48da:	00003517          	auipc	a0,0x3
    48de:	70650513          	addi	a0,a0,1798 # 7fe0 <malloc+0x1d14>
    48e2:	00002097          	auipc	ra,0x2
    48e6:	92e080e7          	jalr	-1746(ra) # 6210 <printf>
  wait(0);
    48ea:	4501                	li	a0,0
    48ec:	00001097          	auipc	ra,0x1
    48f0:	59e080e7          	jalr	1438(ra) # 5e8a <wait>
  wait(0);
    48f4:	4501                	li	a0,0
    48f6:	00001097          	auipc	ra,0x1
    48fa:	594080e7          	jalr	1428(ra) # 5e8a <wait>
  wait(0);
    48fe:	4501                	li	a0,0
    4900:	00001097          	auipc	ra,0x1
    4904:	58a080e7          	jalr	1418(ra) # 5e8a <wait>
    4908:	b761                	j	4890 <preempt+0x12a>

000000000000490a <reparent>:
{
    490a:	7179                	addi	sp,sp,-48
    490c:	f406                	sd	ra,40(sp)
    490e:	f022                	sd	s0,32(sp)
    4910:	ec26                	sd	s1,24(sp)
    4912:	e84a                	sd	s2,16(sp)
    4914:	e44e                	sd	s3,8(sp)
    4916:	e052                	sd	s4,0(sp)
    4918:	1800                	addi	s0,sp,48
    491a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    491c:	00001097          	auipc	ra,0x1
    4920:	5e6080e7          	jalr	1510(ra) # 5f02 <getpid>
    4924:	8a2a                	mv	s4,a0
    4926:	0c800913          	li	s2,200
    int pid = fork();
    492a:	00001097          	auipc	ra,0x1
    492e:	550080e7          	jalr	1360(ra) # 5e7a <fork>
    4932:	84aa                	mv	s1,a0
    if(pid < 0){
    4934:	02054263          	bltz	a0,4958 <reparent+0x4e>
    if(pid){
    4938:	cd21                	beqz	a0,4990 <reparent+0x86>
      if(wait(0) != pid){
    493a:	4501                	li	a0,0
    493c:	00001097          	auipc	ra,0x1
    4940:	54e080e7          	jalr	1358(ra) # 5e8a <wait>
    4944:	02951863          	bne	a0,s1,4974 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4948:	397d                	addiw	s2,s2,-1
    494a:	fe0910e3          	bnez	s2,492a <reparent+0x20>
  exit(0);
    494e:	4501                	li	a0,0
    4950:	00001097          	auipc	ra,0x1
    4954:	532080e7          	jalr	1330(ra) # 5e82 <exit>
      printf("%s: fork failed\n", s);
    4958:	85ce                	mv	a1,s3
    495a:	00002517          	auipc	a0,0x2
    495e:	33650513          	addi	a0,a0,822 # 6c90 <malloc+0x9c4>
    4962:	00002097          	auipc	ra,0x2
    4966:	8ae080e7          	jalr	-1874(ra) # 6210 <printf>
      exit(1);
    496a:	4505                	li	a0,1
    496c:	00001097          	auipc	ra,0x1
    4970:	516080e7          	jalr	1302(ra) # 5e82 <exit>
        printf("%s: wait wrong pid\n", s);
    4974:	85ce                	mv	a1,s3
    4976:	00002517          	auipc	a0,0x2
    497a:	4a250513          	addi	a0,a0,1186 # 6e18 <malloc+0xb4c>
    497e:	00002097          	auipc	ra,0x2
    4982:	892080e7          	jalr	-1902(ra) # 6210 <printf>
        exit(1);
    4986:	4505                	li	a0,1
    4988:	00001097          	auipc	ra,0x1
    498c:	4fa080e7          	jalr	1274(ra) # 5e82 <exit>
      int pid2 = fork();
    4990:	00001097          	auipc	ra,0x1
    4994:	4ea080e7          	jalr	1258(ra) # 5e7a <fork>
      if(pid2 < 0){
    4998:	00054763          	bltz	a0,49a6 <reparent+0x9c>
      exit(0);
    499c:	4501                	li	a0,0
    499e:	00001097          	auipc	ra,0x1
    49a2:	4e4080e7          	jalr	1252(ra) # 5e82 <exit>
        kill(master_pid);
    49a6:	8552                	mv	a0,s4
    49a8:	00001097          	auipc	ra,0x1
    49ac:	50a080e7          	jalr	1290(ra) # 5eb2 <kill>
        exit(1);
    49b0:	4505                	li	a0,1
    49b2:	00001097          	auipc	ra,0x1
    49b6:	4d0080e7          	jalr	1232(ra) # 5e82 <exit>

00000000000049ba <sbrkfail>:
{
    49ba:	7175                	addi	sp,sp,-144
    49bc:	e506                	sd	ra,136(sp)
    49be:	e122                	sd	s0,128(sp)
    49c0:	fca6                	sd	s1,120(sp)
    49c2:	f8ca                	sd	s2,112(sp)
    49c4:	f4ce                	sd	s3,104(sp)
    49c6:	f0d2                	sd	s4,96(sp)
    49c8:	ecd6                	sd	s5,88(sp)
    49ca:	e8da                	sd	s6,80(sp)
    49cc:	e4de                	sd	s7,72(sp)
    49ce:	0900                	addi	s0,sp,144
    49d0:	8baa                	mv	s7,a0
  if(pipe(fds) != 0){
    49d2:	fa040513          	addi	a0,s0,-96
    49d6:	00001097          	auipc	ra,0x1
    49da:	4bc080e7          	jalr	1212(ra) # 5e92 <pipe>
    49de:	e919                	bnez	a0,49f4 <sbrkfail+0x3a>
    49e0:	f7040493          	addi	s1,s0,-144
    49e4:	f9840993          	addi	s3,s0,-104
    49e8:	8926                	mv	s2,s1
    if(pids[i] != -1)
    49ea:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    49ec:	f9f40b13          	addi	s6,s0,-97
    49f0:	4a85                	li	s5,1
    49f2:	a08d                	j	4a54 <sbrkfail+0x9a>
    printf("%s: pipe() failed\n", s);
    49f4:	85de                	mv	a1,s7
    49f6:	00002517          	auipc	a0,0x2
    49fa:	3a250513          	addi	a0,a0,930 # 6d98 <malloc+0xacc>
    49fe:	00002097          	auipc	ra,0x2
    4a02:	812080e7          	jalr	-2030(ra) # 6210 <printf>
    exit(1);
    4a06:	4505                	li	a0,1
    4a08:	00001097          	auipc	ra,0x1
    4a0c:	47a080e7          	jalr	1146(ra) # 5e82 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4a10:	00001097          	auipc	ra,0x1
    4a14:	4fa080e7          	jalr	1274(ra) # 5f0a <sbrk>
    4a18:	064007b7          	lui	a5,0x6400
    4a1c:	40a7853b          	subw	a0,a5,a0
    4a20:	00001097          	auipc	ra,0x1
    4a24:	4ea080e7          	jalr	1258(ra) # 5f0a <sbrk>
      write(fds[1], "x", 1);
    4a28:	4605                	li	a2,1
    4a2a:	00002597          	auipc	a1,0x2
    4a2e:	a4e58593          	addi	a1,a1,-1458 # 6478 <malloc+0x1ac>
    4a32:	fa442503          	lw	a0,-92(s0)
    4a36:	00001097          	auipc	ra,0x1
    4a3a:	46c080e7          	jalr	1132(ra) # 5ea2 <write>
      for(;;) sleep(1000);
    4a3e:	3e800493          	li	s1,1000
    4a42:	8526                	mv	a0,s1
    4a44:	00001097          	auipc	ra,0x1
    4a48:	4ce080e7          	jalr	1230(ra) # 5f12 <sleep>
    4a4c:	bfdd                	j	4a42 <sbrkfail+0x88>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4a4e:	0911                	addi	s2,s2,4
    4a50:	03390463          	beq	s2,s3,4a78 <sbrkfail+0xbe>
    if((pids[i] = fork()) == 0){
    4a54:	00001097          	auipc	ra,0x1
    4a58:	426080e7          	jalr	1062(ra) # 5e7a <fork>
    4a5c:	00a92023          	sw	a0,0(s2)
    4a60:	d945                	beqz	a0,4a10 <sbrkfail+0x56>
    if(pids[i] != -1)
    4a62:	ff4506e3          	beq	a0,s4,4a4e <sbrkfail+0x94>
      read(fds[0], &scratch, 1);
    4a66:	8656                	mv	a2,s5
    4a68:	85da                	mv	a1,s6
    4a6a:	fa042503          	lw	a0,-96(s0)
    4a6e:	00001097          	auipc	ra,0x1
    4a72:	42c080e7          	jalr	1068(ra) # 5e9a <read>
    4a76:	bfe1                	j	4a4e <sbrkfail+0x94>
  c = sbrk(PGSIZE);
    4a78:	6505                	lui	a0,0x1
    4a7a:	00001097          	auipc	ra,0x1
    4a7e:	490080e7          	jalr	1168(ra) # 5f0a <sbrk>
    4a82:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4a84:	597d                	li	s2,-1
    4a86:	a021                	j	4a8e <sbrkfail+0xd4>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4a88:	0491                	addi	s1,s1,4
    4a8a:	01348f63          	beq	s1,s3,4aa8 <sbrkfail+0xee>
    if(pids[i] == -1)
    4a8e:	4088                	lw	a0,0(s1)
    4a90:	ff250ce3          	beq	a0,s2,4a88 <sbrkfail+0xce>
    kill(pids[i]);
    4a94:	00001097          	auipc	ra,0x1
    4a98:	41e080e7          	jalr	1054(ra) # 5eb2 <kill>
    wait(0);
    4a9c:	4501                	li	a0,0
    4a9e:	00001097          	auipc	ra,0x1
    4aa2:	3ec080e7          	jalr	1004(ra) # 5e8a <wait>
    4aa6:	b7cd                	j	4a88 <sbrkfail+0xce>
  if(c == (char*)0xffffffffffffffffL){
    4aa8:	57fd                	li	a5,-1
    4aaa:	04fa0263          	beq	s4,a5,4aee <sbrkfail+0x134>
  pid = fork();
    4aae:	00001097          	auipc	ra,0x1
    4ab2:	3cc080e7          	jalr	972(ra) # 5e7a <fork>
    4ab6:	84aa                	mv	s1,a0
  if(pid < 0){
    4ab8:	04054963          	bltz	a0,4b0a <sbrkfail+0x150>
  if(pid == 0){
    4abc:	c52d                	beqz	a0,4b26 <sbrkfail+0x16c>
  wait(&xstatus);
    4abe:	fac40513          	addi	a0,s0,-84
    4ac2:	00001097          	auipc	ra,0x1
    4ac6:	3c8080e7          	jalr	968(ra) # 5e8a <wait>
  if(xstatus != -1 && xstatus != 2)
    4aca:	fac42783          	lw	a5,-84(s0)
    4ace:	00178713          	addi	a4,a5,1 # 6400001 <base+0x63f0389>
    4ad2:	c319                	beqz	a4,4ad8 <sbrkfail+0x11e>
    4ad4:	17f9                	addi	a5,a5,-2
    4ad6:	efd1                	bnez	a5,4b72 <sbrkfail+0x1b8>
}
    4ad8:	60aa                	ld	ra,136(sp)
    4ada:	640a                	ld	s0,128(sp)
    4adc:	74e6                	ld	s1,120(sp)
    4ade:	7946                	ld	s2,112(sp)
    4ae0:	79a6                	ld	s3,104(sp)
    4ae2:	7a06                	ld	s4,96(sp)
    4ae4:	6ae6                	ld	s5,88(sp)
    4ae6:	6b46                	ld	s6,80(sp)
    4ae8:	6ba6                	ld	s7,72(sp)
    4aea:	6149                	addi	sp,sp,144
    4aec:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4aee:	85de                	mv	a1,s7
    4af0:	00003517          	auipc	a0,0x3
    4af4:	50050513          	addi	a0,a0,1280 # 7ff0 <malloc+0x1d24>
    4af8:	00001097          	auipc	ra,0x1
    4afc:	718080e7          	jalr	1816(ra) # 6210 <printf>
    exit(1);
    4b00:	4505                	li	a0,1
    4b02:	00001097          	auipc	ra,0x1
    4b06:	380080e7          	jalr	896(ra) # 5e82 <exit>
    printf("%s: fork failed\n", s);
    4b0a:	85de                	mv	a1,s7
    4b0c:	00002517          	auipc	a0,0x2
    4b10:	18450513          	addi	a0,a0,388 # 6c90 <malloc+0x9c4>
    4b14:	00001097          	auipc	ra,0x1
    4b18:	6fc080e7          	jalr	1788(ra) # 6210 <printf>
    exit(1);
    4b1c:	4505                	li	a0,1
    4b1e:	00001097          	auipc	ra,0x1
    4b22:	364080e7          	jalr	868(ra) # 5e82 <exit>
    a = sbrk(0);
    4b26:	4501                	li	a0,0
    4b28:	00001097          	auipc	ra,0x1
    4b2c:	3e2080e7          	jalr	994(ra) # 5f0a <sbrk>
    4b30:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4b32:	3e800537          	lui	a0,0x3e800
    4b36:	00001097          	auipc	ra,0x1
    4b3a:	3d4080e7          	jalr	980(ra) # 5f0a <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4b3e:	87ca                	mv	a5,s2
    4b40:	3e800737          	lui	a4,0x3e800
    4b44:	993a                	add	s2,s2,a4
    4b46:	6705                	lui	a4,0x1
      n += *(a+i);
    4b48:	0007c603          	lbu	a2,0(a5)
    4b4c:	9e25                	addw	a2,a2,s1
    4b4e:	84b2                	mv	s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4b50:	97ba                	add	a5,a5,a4
    4b52:	fef91be3          	bne	s2,a5,4b48 <sbrkfail+0x18e>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4b56:	85de                	mv	a1,s7
    4b58:	00003517          	auipc	a0,0x3
    4b5c:	4b850513          	addi	a0,a0,1208 # 8010 <malloc+0x1d44>
    4b60:	00001097          	auipc	ra,0x1
    4b64:	6b0080e7          	jalr	1712(ra) # 6210 <printf>
    exit(1);
    4b68:	4505                	li	a0,1
    4b6a:	00001097          	auipc	ra,0x1
    4b6e:	318080e7          	jalr	792(ra) # 5e82 <exit>
    exit(1);
    4b72:	4505                	li	a0,1
    4b74:	00001097          	auipc	ra,0x1
    4b78:	30e080e7          	jalr	782(ra) # 5e82 <exit>

0000000000004b7c <mem>:
{
    4b7c:	7139                	addi	sp,sp,-64
    4b7e:	fc06                	sd	ra,56(sp)
    4b80:	f822                	sd	s0,48(sp)
    4b82:	f426                	sd	s1,40(sp)
    4b84:	f04a                	sd	s2,32(sp)
    4b86:	ec4e                	sd	s3,24(sp)
    4b88:	0080                	addi	s0,sp,64
    4b8a:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4b8c:	00001097          	auipc	ra,0x1
    4b90:	2ee080e7          	jalr	750(ra) # 5e7a <fork>
    m1 = 0;
    4b94:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4b96:	6909                	lui	s2,0x2
    4b98:	71190913          	addi	s2,s2,1809 # 2711 <manywrites+0x147>
  if((pid = fork()) == 0){
    4b9c:	c115                	beqz	a0,4bc0 <mem+0x44>
    wait(&xstatus);
    4b9e:	fcc40513          	addi	a0,s0,-52
    4ba2:	00001097          	auipc	ra,0x1
    4ba6:	2e8080e7          	jalr	744(ra) # 5e8a <wait>
    if(xstatus == -1){
    4baa:	fcc42503          	lw	a0,-52(s0)
    4bae:	57fd                	li	a5,-1
    4bb0:	06f50363          	beq	a0,a5,4c16 <mem+0x9a>
    exit(xstatus);
    4bb4:	00001097          	auipc	ra,0x1
    4bb8:	2ce080e7          	jalr	718(ra) # 5e82 <exit>
      *(char**)m2 = m1;
    4bbc:	e104                	sd	s1,0(a0)
      m1 = m2;
    4bbe:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4bc0:	854a                	mv	a0,s2
    4bc2:	00001097          	auipc	ra,0x1
    4bc6:	70a080e7          	jalr	1802(ra) # 62cc <malloc>
    4bca:	f96d                	bnez	a0,4bbc <mem+0x40>
    while(m1){
    4bcc:	c881                	beqz	s1,4bdc <mem+0x60>
      m2 = *(char**)m1;
    4bce:	8526                	mv	a0,s1
    4bd0:	6084                	ld	s1,0(s1)
      free(m1);
    4bd2:	00001097          	auipc	ra,0x1
    4bd6:	674080e7          	jalr	1652(ra) # 6246 <free>
    while(m1){
    4bda:	f8f5                	bnez	s1,4bce <mem+0x52>
    m1 = malloc(1024*20);
    4bdc:	6515                	lui	a0,0x5
    4bde:	00001097          	auipc	ra,0x1
    4be2:	6ee080e7          	jalr	1774(ra) # 62cc <malloc>
    if(m1 == 0){
    4be6:	c911                	beqz	a0,4bfa <mem+0x7e>
    free(m1);
    4be8:	00001097          	auipc	ra,0x1
    4bec:	65e080e7          	jalr	1630(ra) # 6246 <free>
    exit(0);
    4bf0:	4501                	li	a0,0
    4bf2:	00001097          	auipc	ra,0x1
    4bf6:	290080e7          	jalr	656(ra) # 5e82 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4bfa:	85ce                	mv	a1,s3
    4bfc:	00003517          	auipc	a0,0x3
    4c00:	44450513          	addi	a0,a0,1092 # 8040 <malloc+0x1d74>
    4c04:	00001097          	auipc	ra,0x1
    4c08:	60c080e7          	jalr	1548(ra) # 6210 <printf>
      exit(1);
    4c0c:	4505                	li	a0,1
    4c0e:	00001097          	auipc	ra,0x1
    4c12:	274080e7          	jalr	628(ra) # 5e82 <exit>
      exit(0);
    4c16:	4501                	li	a0,0
    4c18:	00001097          	auipc	ra,0x1
    4c1c:	26a080e7          	jalr	618(ra) # 5e82 <exit>

0000000000004c20 <sharedfd>:
{
    4c20:	7159                	addi	sp,sp,-112
    4c22:	f486                	sd	ra,104(sp)
    4c24:	f0a2                	sd	s0,96(sp)
    4c26:	eca6                	sd	s1,88(sp)
    4c28:	f85a                	sd	s6,48(sp)
    4c2a:	1880                	addi	s0,sp,112
    4c2c:	84aa                	mv	s1,a0
    4c2e:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    4c30:	00003517          	auipc	a0,0x3
    4c34:	43050513          	addi	a0,a0,1072 # 8060 <malloc+0x1d94>
    4c38:	00001097          	auipc	ra,0x1
    4c3c:	29a080e7          	jalr	666(ra) # 5ed2 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4c40:	20200593          	li	a1,514
    4c44:	00003517          	auipc	a0,0x3
    4c48:	41c50513          	addi	a0,a0,1052 # 8060 <malloc+0x1d94>
    4c4c:	00001097          	auipc	ra,0x1
    4c50:	276080e7          	jalr	630(ra) # 5ec2 <open>
  if(fd < 0){
    4c54:	06054063          	bltz	a0,4cb4 <sharedfd+0x94>
    4c58:	e8ca                	sd	s2,80(sp)
    4c5a:	e4ce                	sd	s3,72(sp)
    4c5c:	e0d2                	sd	s4,64(sp)
    4c5e:	fc56                	sd	s5,56(sp)
    4c60:	89aa                	mv	s3,a0
  pid = fork();
    4c62:	00001097          	auipc	ra,0x1
    4c66:	218080e7          	jalr	536(ra) # 5e7a <fork>
    4c6a:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4c6c:	07000593          	li	a1,112
    4c70:	e119                	bnez	a0,4c76 <sharedfd+0x56>
    4c72:	06300593          	li	a1,99
    4c76:	4629                	li	a2,10
    4c78:	fa040513          	addi	a0,s0,-96
    4c7c:	00001097          	auipc	ra,0x1
    4c80:	ff4080e7          	jalr	-12(ra) # 5c70 <memset>
    4c84:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4c88:	fa040a13          	addi	s4,s0,-96
    4c8c:	4929                	li	s2,10
    4c8e:	864a                	mv	a2,s2
    4c90:	85d2                	mv	a1,s4
    4c92:	854e                	mv	a0,s3
    4c94:	00001097          	auipc	ra,0x1
    4c98:	20e080e7          	jalr	526(ra) # 5ea2 <write>
    4c9c:	03251f63          	bne	a0,s2,4cda <sharedfd+0xba>
  for(i = 0; i < N; i++){
    4ca0:	34fd                	addiw	s1,s1,-1
    4ca2:	f4f5                	bnez	s1,4c8e <sharedfd+0x6e>
  if(pid == 0) {
    4ca4:	040a9a63          	bnez	s5,4cf8 <sharedfd+0xd8>
    4ca8:	f45e                	sd	s7,40(sp)
    exit(0);
    4caa:	4501                	li	a0,0
    4cac:	00001097          	auipc	ra,0x1
    4cb0:	1d6080e7          	jalr	470(ra) # 5e82 <exit>
    4cb4:	e8ca                	sd	s2,80(sp)
    4cb6:	e4ce                	sd	s3,72(sp)
    4cb8:	e0d2                	sd	s4,64(sp)
    4cba:	fc56                	sd	s5,56(sp)
    4cbc:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4cbe:	85a6                	mv	a1,s1
    4cc0:	00003517          	auipc	a0,0x3
    4cc4:	3b050513          	addi	a0,a0,944 # 8070 <malloc+0x1da4>
    4cc8:	00001097          	auipc	ra,0x1
    4ccc:	548080e7          	jalr	1352(ra) # 6210 <printf>
    exit(1);
    4cd0:	4505                	li	a0,1
    4cd2:	00001097          	auipc	ra,0x1
    4cd6:	1b0080e7          	jalr	432(ra) # 5e82 <exit>
    4cda:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    4cdc:	85da                	mv	a1,s6
    4cde:	00003517          	auipc	a0,0x3
    4ce2:	3ba50513          	addi	a0,a0,954 # 8098 <malloc+0x1dcc>
    4ce6:	00001097          	auipc	ra,0x1
    4cea:	52a080e7          	jalr	1322(ra) # 6210 <printf>
      exit(1);
    4cee:	4505                	li	a0,1
    4cf0:	00001097          	auipc	ra,0x1
    4cf4:	192080e7          	jalr	402(ra) # 5e82 <exit>
    wait(&xstatus);
    4cf8:	f9c40513          	addi	a0,s0,-100
    4cfc:	00001097          	auipc	ra,0x1
    4d00:	18e080e7          	jalr	398(ra) # 5e8a <wait>
    if(xstatus != 0)
    4d04:	f9c42a03          	lw	s4,-100(s0)
    4d08:	000a0863          	beqz	s4,4d18 <sharedfd+0xf8>
    4d0c:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    4d0e:	8552                	mv	a0,s4
    4d10:	00001097          	auipc	ra,0x1
    4d14:	172080e7          	jalr	370(ra) # 5e82 <exit>
    4d18:	f45e                	sd	s7,40(sp)
  close(fd);
    4d1a:	854e                	mv	a0,s3
    4d1c:	00001097          	auipc	ra,0x1
    4d20:	18e080e7          	jalr	398(ra) # 5eaa <close>
  fd = open("sharedfd", 0);
    4d24:	4581                	li	a1,0
    4d26:	00003517          	auipc	a0,0x3
    4d2a:	33a50513          	addi	a0,a0,826 # 8060 <malloc+0x1d94>
    4d2e:	00001097          	auipc	ra,0x1
    4d32:	194080e7          	jalr	404(ra) # 5ec2 <open>
    4d36:	8baa                	mv	s7,a0
  nc = np = 0;
    4d38:	89d2                	mv	s3,s4
  if(fd < 0){
    4d3a:	02054563          	bltz	a0,4d64 <sharedfd+0x144>
    4d3e:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4d42:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4d46:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4d4a:	4629                	li	a2,10
    4d4c:	fa040593          	addi	a1,s0,-96
    4d50:	855e                	mv	a0,s7
    4d52:	00001097          	auipc	ra,0x1
    4d56:	148080e7          	jalr	328(ra) # 5e9a <read>
    4d5a:	02a05f63          	blez	a0,4d98 <sharedfd+0x178>
    4d5e:	fa040793          	addi	a5,s0,-96
    4d62:	a01d                	j	4d88 <sharedfd+0x168>
    printf("%s: cannot open sharedfd for reading\n", s);
    4d64:	85da                	mv	a1,s6
    4d66:	00003517          	auipc	a0,0x3
    4d6a:	35250513          	addi	a0,a0,850 # 80b8 <malloc+0x1dec>
    4d6e:	00001097          	auipc	ra,0x1
    4d72:	4a2080e7          	jalr	1186(ra) # 6210 <printf>
    exit(1);
    4d76:	4505                	li	a0,1
    4d78:	00001097          	auipc	ra,0x1
    4d7c:	10a080e7          	jalr	266(ra) # 5e82 <exit>
        nc++;
    4d80:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    4d82:	0785                	addi	a5,a5,1
    4d84:	fd2783e3          	beq	a5,s2,4d4a <sharedfd+0x12a>
      if(buf[i] == 'c')
    4d88:	0007c703          	lbu	a4,0(a5)
    4d8c:	fe970ae3          	beq	a4,s1,4d80 <sharedfd+0x160>
      if(buf[i] == 'p')
    4d90:	ff5719e3          	bne	a4,s5,4d82 <sharedfd+0x162>
        np++;
    4d94:	2985                	addiw	s3,s3,1
    4d96:	b7f5                	j	4d82 <sharedfd+0x162>
  close(fd);
    4d98:	855e                	mv	a0,s7
    4d9a:	00001097          	auipc	ra,0x1
    4d9e:	110080e7          	jalr	272(ra) # 5eaa <close>
  unlink("sharedfd");
    4da2:	00003517          	auipc	a0,0x3
    4da6:	2be50513          	addi	a0,a0,702 # 8060 <malloc+0x1d94>
    4daa:	00001097          	auipc	ra,0x1
    4dae:	128080e7          	jalr	296(ra) # 5ed2 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4db2:	6789                	lui	a5,0x2
    4db4:	71078793          	addi	a5,a5,1808 # 2710 <manywrites+0x146>
    4db8:	00fa1963          	bne	s4,a5,4dca <sharedfd+0x1aa>
    4dbc:	01499763          	bne	s3,s4,4dca <sharedfd+0x1aa>
    exit(0);
    4dc0:	4501                	li	a0,0
    4dc2:	00001097          	auipc	ra,0x1
    4dc6:	0c0080e7          	jalr	192(ra) # 5e82 <exit>
    printf("%s: nc/np test fails\n", s);
    4dca:	85da                	mv	a1,s6
    4dcc:	00003517          	auipc	a0,0x3
    4dd0:	31450513          	addi	a0,a0,788 # 80e0 <malloc+0x1e14>
    4dd4:	00001097          	auipc	ra,0x1
    4dd8:	43c080e7          	jalr	1084(ra) # 6210 <printf>
    exit(1);
    4ddc:	4505                	li	a0,1
    4dde:	00001097          	auipc	ra,0x1
    4de2:	0a4080e7          	jalr	164(ra) # 5e82 <exit>

0000000000004de6 <fourfiles>:
{
    4de6:	7135                	addi	sp,sp,-160
    4de8:	ed06                	sd	ra,152(sp)
    4dea:	e922                	sd	s0,144(sp)
    4dec:	e526                	sd	s1,136(sp)
    4dee:	e14a                	sd	s2,128(sp)
    4df0:	fcce                	sd	s3,120(sp)
    4df2:	f8d2                	sd	s4,112(sp)
    4df4:	f4d6                	sd	s5,104(sp)
    4df6:	f0da                	sd	s6,96(sp)
    4df8:	ecde                	sd	s7,88(sp)
    4dfa:	e8e2                	sd	s8,80(sp)
    4dfc:	e4e6                	sd	s9,72(sp)
    4dfe:	e0ea                	sd	s10,64(sp)
    4e00:	fc6e                	sd	s11,56(sp)
    4e02:	1100                	addi	s0,sp,160
    4e04:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4e06:	00003797          	auipc	a5,0x3
    4e0a:	2f278793          	addi	a5,a5,754 # 80f8 <malloc+0x1e2c>
    4e0e:	f6f43823          	sd	a5,-144(s0)
    4e12:	00003797          	auipc	a5,0x3
    4e16:	2ee78793          	addi	a5,a5,750 # 8100 <malloc+0x1e34>
    4e1a:	f6f43c23          	sd	a5,-136(s0)
    4e1e:	00003797          	auipc	a5,0x3
    4e22:	2ea78793          	addi	a5,a5,746 # 8108 <malloc+0x1e3c>
    4e26:	f8f43023          	sd	a5,-128(s0)
    4e2a:	00003797          	auipc	a5,0x3
    4e2e:	2e678793          	addi	a5,a5,742 # 8110 <malloc+0x1e44>
    4e32:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4e36:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4e3a:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4e3c:	4481                	li	s1,0
    4e3e:	4a11                	li	s4,4
    fname = names[pi];
    4e40:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4e44:	854e                	mv	a0,s3
    4e46:	00001097          	auipc	ra,0x1
    4e4a:	08c080e7          	jalr	140(ra) # 5ed2 <unlink>
    pid = fork();
    4e4e:	00001097          	auipc	ra,0x1
    4e52:	02c080e7          	jalr	44(ra) # 5e7a <fork>
    if(pid < 0){
    4e56:	04054263          	bltz	a0,4e9a <fourfiles+0xb4>
    if(pid == 0){
    4e5a:	cd31                	beqz	a0,4eb6 <fourfiles+0xd0>
  for(pi = 0; pi < NCHILD; pi++){
    4e5c:	2485                	addiw	s1,s1,1
    4e5e:	0921                	addi	s2,s2,8
    4e60:	ff4490e3          	bne	s1,s4,4e40 <fourfiles+0x5a>
    4e64:	4491                	li	s1,4
    wait(&xstatus);
    4e66:	f6c40913          	addi	s2,s0,-148
    4e6a:	854a                	mv	a0,s2
    4e6c:	00001097          	auipc	ra,0x1
    4e70:	01e080e7          	jalr	30(ra) # 5e8a <wait>
    if(xstatus != 0)
    4e74:	f6c42b03          	lw	s6,-148(s0)
    4e78:	0c0b1863          	bnez	s6,4f48 <fourfiles+0x162>
  for(pi = 0; pi < NCHILD; pi++){
    4e7c:	34fd                	addiw	s1,s1,-1
    4e7e:	f4f5                	bnez	s1,4e6a <fourfiles+0x84>
    4e80:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e84:	6a8d                	lui	s5,0x3
    4e86:	00008a17          	auipc	s4,0x8
    4e8a:	df2a0a13          	addi	s4,s4,-526 # cc78 <buf>
    if(total != N*SZ){
    4e8e:	6d05                	lui	s10,0x1
    4e90:	770d0d13          	addi	s10,s10,1904 # 1770 <truncate3+0x17e>
  for(i = 0; i < NCHILD; i++){
    4e94:	03400d93          	li	s11,52
    4e98:	a8dd                	j	4f8e <fourfiles+0x1a8>
      printf("fork failed\n", s);
    4e9a:	85e6                	mv	a1,s9
    4e9c:	00002517          	auipc	a0,0x2
    4ea0:	1fc50513          	addi	a0,a0,508 # 7098 <malloc+0xdcc>
    4ea4:	00001097          	auipc	ra,0x1
    4ea8:	36c080e7          	jalr	876(ra) # 6210 <printf>
      exit(1);
    4eac:	4505                	li	a0,1
    4eae:	00001097          	auipc	ra,0x1
    4eb2:	fd4080e7          	jalr	-44(ra) # 5e82 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4eb6:	20200593          	li	a1,514
    4eba:	854e                	mv	a0,s3
    4ebc:	00001097          	auipc	ra,0x1
    4ec0:	006080e7          	jalr	6(ra) # 5ec2 <open>
    4ec4:	892a                	mv	s2,a0
      if(fd < 0){
    4ec6:	04054663          	bltz	a0,4f12 <fourfiles+0x12c>
      memset(buf, '0'+pi, SZ);
    4eca:	1f400613          	li	a2,500
    4ece:	0304859b          	addiw	a1,s1,48
    4ed2:	00008517          	auipc	a0,0x8
    4ed6:	da650513          	addi	a0,a0,-602 # cc78 <buf>
    4eda:	00001097          	auipc	ra,0x1
    4ede:	d96080e7          	jalr	-618(ra) # 5c70 <memset>
    4ee2:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4ee4:	1f400993          	li	s3,500
    4ee8:	00008a17          	auipc	s4,0x8
    4eec:	d90a0a13          	addi	s4,s4,-624 # cc78 <buf>
    4ef0:	864e                	mv	a2,s3
    4ef2:	85d2                	mv	a1,s4
    4ef4:	854a                	mv	a0,s2
    4ef6:	00001097          	auipc	ra,0x1
    4efa:	fac080e7          	jalr	-84(ra) # 5ea2 <write>
    4efe:	85aa                	mv	a1,a0
    4f00:	03351763          	bne	a0,s3,4f2e <fourfiles+0x148>
      for(i = 0; i < N; i++){
    4f04:	34fd                	addiw	s1,s1,-1
    4f06:	f4ed                	bnez	s1,4ef0 <fourfiles+0x10a>
      exit(0);
    4f08:	4501                	li	a0,0
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	f78080e7          	jalr	-136(ra) # 5e82 <exit>
        printf("create failed\n", s);
    4f12:	85e6                	mv	a1,s9
    4f14:	00003517          	auipc	a0,0x3
    4f18:	20450513          	addi	a0,a0,516 # 8118 <malloc+0x1e4c>
    4f1c:	00001097          	auipc	ra,0x1
    4f20:	2f4080e7          	jalr	756(ra) # 6210 <printf>
        exit(1);
    4f24:	4505                	li	a0,1
    4f26:	00001097          	auipc	ra,0x1
    4f2a:	f5c080e7          	jalr	-164(ra) # 5e82 <exit>
          printf("write failed %d\n", n);
    4f2e:	00003517          	auipc	a0,0x3
    4f32:	1fa50513          	addi	a0,a0,506 # 8128 <malloc+0x1e5c>
    4f36:	00001097          	auipc	ra,0x1
    4f3a:	2da080e7          	jalr	730(ra) # 6210 <printf>
          exit(1);
    4f3e:	4505                	li	a0,1
    4f40:	00001097          	auipc	ra,0x1
    4f44:	f42080e7          	jalr	-190(ra) # 5e82 <exit>
      exit(xstatus);
    4f48:	855a                	mv	a0,s6
    4f4a:	00001097          	auipc	ra,0x1
    4f4e:	f38080e7          	jalr	-200(ra) # 5e82 <exit>
          printf("wrong char\n", s);
    4f52:	85e6                	mv	a1,s9
    4f54:	00003517          	auipc	a0,0x3
    4f58:	1ec50513          	addi	a0,a0,492 # 8140 <malloc+0x1e74>
    4f5c:	00001097          	auipc	ra,0x1
    4f60:	2b4080e7          	jalr	692(ra) # 6210 <printf>
          exit(1);
    4f64:	4505                	li	a0,1
    4f66:	00001097          	auipc	ra,0x1
    4f6a:	f1c080e7          	jalr	-228(ra) # 5e82 <exit>
    close(fd);
    4f6e:	854e                	mv	a0,s3
    4f70:	00001097          	auipc	ra,0x1
    4f74:	f3a080e7          	jalr	-198(ra) # 5eaa <close>
    if(total != N*SZ){
    4f78:	05a91e63          	bne	s2,s10,4fd4 <fourfiles+0x1ee>
    unlink(fname);
    4f7c:	8562                	mv	a0,s8
    4f7e:	00001097          	auipc	ra,0x1
    4f82:	f54080e7          	jalr	-172(ra) # 5ed2 <unlink>
  for(i = 0; i < NCHILD; i++){
    4f86:	0ba1                	addi	s7,s7,8
    4f88:	2485                	addiw	s1,s1,1
    4f8a:	07b48363          	beq	s1,s11,4ff0 <fourfiles+0x20a>
    fname = names[i];
    4f8e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4f92:	4581                	li	a1,0
    4f94:	8562                	mv	a0,s8
    4f96:	00001097          	auipc	ra,0x1
    4f9a:	f2c080e7          	jalr	-212(ra) # 5ec2 <open>
    4f9e:	89aa                	mv	s3,a0
    total = 0;
    4fa0:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4fa2:	8656                	mv	a2,s5
    4fa4:	85d2                	mv	a1,s4
    4fa6:	854e                	mv	a0,s3
    4fa8:	00001097          	auipc	ra,0x1
    4fac:	ef2080e7          	jalr	-270(ra) # 5e9a <read>
    4fb0:	faa05fe3          	blez	a0,4f6e <fourfiles+0x188>
    4fb4:	00008797          	auipc	a5,0x8
    4fb8:	cc478793          	addi	a5,a5,-828 # cc78 <buf>
    4fbc:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4fc0:	0007c703          	lbu	a4,0(a5)
    4fc4:	f89717e3          	bne	a4,s1,4f52 <fourfiles+0x16c>
      for(j = 0; j < n; j++){
    4fc8:	0785                	addi	a5,a5,1
    4fca:	fed79be3          	bne	a5,a3,4fc0 <fourfiles+0x1da>
      total += n;
    4fce:	00a9093b          	addw	s2,s2,a0
    4fd2:	bfc1                	j	4fa2 <fourfiles+0x1bc>
      printf("wrong length %d\n", total);
    4fd4:	85ca                	mv	a1,s2
    4fd6:	00003517          	auipc	a0,0x3
    4fda:	17a50513          	addi	a0,a0,378 # 8150 <malloc+0x1e84>
    4fde:	00001097          	auipc	ra,0x1
    4fe2:	232080e7          	jalr	562(ra) # 6210 <printf>
      exit(1);
    4fe6:	4505                	li	a0,1
    4fe8:	00001097          	auipc	ra,0x1
    4fec:	e9a080e7          	jalr	-358(ra) # 5e82 <exit>
}
    4ff0:	60ea                	ld	ra,152(sp)
    4ff2:	644a                	ld	s0,144(sp)
    4ff4:	64aa                	ld	s1,136(sp)
    4ff6:	690a                	ld	s2,128(sp)
    4ff8:	79e6                	ld	s3,120(sp)
    4ffa:	7a46                	ld	s4,112(sp)
    4ffc:	7aa6                	ld	s5,104(sp)
    4ffe:	7b06                	ld	s6,96(sp)
    5000:	6be6                	ld	s7,88(sp)
    5002:	6c46                	ld	s8,80(sp)
    5004:	6ca6                	ld	s9,72(sp)
    5006:	6d06                	ld	s10,64(sp)
    5008:	7de2                	ld	s11,56(sp)
    500a:	610d                	addi	sp,sp,160
    500c:	8082                	ret

000000000000500e <concreate>:
{
    500e:	7171                	addi	sp,sp,-176
    5010:	f506                	sd	ra,168(sp)
    5012:	f122                	sd	s0,160(sp)
    5014:	ed26                	sd	s1,152(sp)
    5016:	e94a                	sd	s2,144(sp)
    5018:	e54e                	sd	s3,136(sp)
    501a:	e152                	sd	s4,128(sp)
    501c:	fcd6                	sd	s5,120(sp)
    501e:	f8da                	sd	s6,112(sp)
    5020:	f4de                	sd	s7,104(sp)
    5022:	f0e2                	sd	s8,96(sp)
    5024:	ece6                	sd	s9,88(sp)
    5026:	e8ea                	sd	s10,80(sp)
    5028:	1900                	addi	s0,sp,176
    502a:	8d2a                	mv	s10,a0
  file[0] = 'C';
    502c:	04300793          	li	a5,67
    5030:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    5034:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    5038:	4901                	li	s2,0
    unlink(file);
    503a:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    503e:	55555b37          	lui	s6,0x55555
    5042:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x555458de>
    5046:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    5048:	20200c13          	li	s8,514
      link("C0", file);
    504c:	00003c97          	auipc	s9,0x3
    5050:	11cc8c93          	addi	s9,s9,284 # 8168 <malloc+0x1e9c>
      wait(&xstatus);
    5054:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    5058:	02800a13          	li	s4,40
    505c:	a4d5                	j	5340 <concreate+0x332>
      link("C0", file);
    505e:	85ce                	mv	a1,s3
    5060:	8566                	mv	a0,s9
    5062:	00001097          	auipc	ra,0x1
    5066:	e80080e7          	jalr	-384(ra) # 5ee2 <link>
    if(pid == 0) {
    506a:	ac7d                	j	5328 <concreate+0x31a>
    } else if(pid == 0 && (i % 5) == 1){
    506c:	666667b7          	lui	a5,0x66666
    5070:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666569ef>
    5074:	02f907b3          	mul	a5,s2,a5
    5078:	9785                	srai	a5,a5,0x21
    507a:	41f9571b          	sraiw	a4,s2,0x1f
    507e:	9f99                	subw	a5,a5,a4
    5080:	0027971b          	slliw	a4,a5,0x2
    5084:	9fb9                	addw	a5,a5,a4
    5086:	40f9093b          	subw	s2,s2,a5
    508a:	4785                	li	a5,1
    508c:	02f90b63          	beq	s2,a5,50c2 <concreate+0xb4>
      fd = open(file, O_CREATE | O_RDWR);
    5090:	20200593          	li	a1,514
    5094:	f9840513          	addi	a0,s0,-104
    5098:	00001097          	auipc	ra,0x1
    509c:	e2a080e7          	jalr	-470(ra) # 5ec2 <open>
      if(fd < 0){
    50a0:	26055b63          	bgez	a0,5316 <concreate+0x308>
        printf("concreate create %s failed\n", file);
    50a4:	f9840593          	addi	a1,s0,-104
    50a8:	00003517          	auipc	a0,0x3
    50ac:	0c850513          	addi	a0,a0,200 # 8170 <malloc+0x1ea4>
    50b0:	00001097          	auipc	ra,0x1
    50b4:	160080e7          	jalr	352(ra) # 6210 <printf>
        exit(1);
    50b8:	4505                	li	a0,1
    50ba:	00001097          	auipc	ra,0x1
    50be:	dc8080e7          	jalr	-568(ra) # 5e82 <exit>
      link("C0", file);
    50c2:	f9840593          	addi	a1,s0,-104
    50c6:	00003517          	auipc	a0,0x3
    50ca:	0a250513          	addi	a0,a0,162 # 8168 <malloc+0x1e9c>
    50ce:	00001097          	auipc	ra,0x1
    50d2:	e14080e7          	jalr	-492(ra) # 5ee2 <link>
      exit(0);
    50d6:	4501                	li	a0,0
    50d8:	00001097          	auipc	ra,0x1
    50dc:	daa080e7          	jalr	-598(ra) # 5e82 <exit>
        exit(1);
    50e0:	4505                	li	a0,1
    50e2:	00001097          	auipc	ra,0x1
    50e6:	da0080e7          	jalr	-608(ra) # 5e82 <exit>
  memset(fa, 0, sizeof(fa));
    50ea:	02800613          	li	a2,40
    50ee:	4581                	li	a1,0
    50f0:	f7040513          	addi	a0,s0,-144
    50f4:	00001097          	auipc	ra,0x1
    50f8:	b7c080e7          	jalr	-1156(ra) # 5c70 <memset>
  fd = open(".", 0);
    50fc:	4581                	li	a1,0
    50fe:	00002517          	auipc	a0,0x2
    5102:	9f250513          	addi	a0,a0,-1550 # 6af0 <malloc+0x824>
    5106:	00001097          	auipc	ra,0x1
    510a:	dbc080e7          	jalr	-580(ra) # 5ec2 <open>
    510e:	892a                	mv	s2,a0
  n = 0;
    5110:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    5112:	f6040a13          	addi	s4,s0,-160
    5116:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    5118:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    511c:	02700b93          	li	s7,39
      fa[i] = 1;
    5120:	4c05                	li	s8,1
  while(read(fd, &de, sizeof(de)) > 0){
    5122:	864e                	mv	a2,s3
    5124:	85d2                	mv	a1,s4
    5126:	854a                	mv	a0,s2
    5128:	00001097          	auipc	ra,0x1
    512c:	d72080e7          	jalr	-654(ra) # 5e9a <read>
    5130:	06a05f63          	blez	a0,51ae <concreate+0x1a0>
    if(de.inum == 0)
    5134:	f6045783          	lhu	a5,-160(s0)
    5138:	d7ed                	beqz	a5,5122 <concreate+0x114>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    513a:	f6244783          	lbu	a5,-158(s0)
    513e:	ff5792e3          	bne	a5,s5,5122 <concreate+0x114>
    5142:	f6444783          	lbu	a5,-156(s0)
    5146:	fff1                	bnez	a5,5122 <concreate+0x114>
      i = de.name[1] - '0';
    5148:	f6344783          	lbu	a5,-157(s0)
    514c:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    5150:	00fbef63          	bltu	s7,a5,516e <concreate+0x160>
      if(fa[i]){
    5154:	fa078713          	addi	a4,a5,-96
    5158:	9722                	add	a4,a4,s0
    515a:	fd074703          	lbu	a4,-48(a4) # fd0 <linktest+0x7c>
    515e:	eb05                	bnez	a4,518e <concreate+0x180>
      fa[i] = 1;
    5160:	fa078793          	addi	a5,a5,-96
    5164:	97a2                	add	a5,a5,s0
    5166:	fd878823          	sb	s8,-48(a5)
      n++;
    516a:	2b05                	addiw	s6,s6,1
    516c:	bf5d                	j	5122 <concreate+0x114>
        printf("%s: concreate weird file %s\n", s, de.name);
    516e:	f6240613          	addi	a2,s0,-158
    5172:	85ea                	mv	a1,s10
    5174:	00003517          	auipc	a0,0x3
    5178:	01c50513          	addi	a0,a0,28 # 8190 <malloc+0x1ec4>
    517c:	00001097          	auipc	ra,0x1
    5180:	094080e7          	jalr	148(ra) # 6210 <printf>
        exit(1);
    5184:	4505                	li	a0,1
    5186:	00001097          	auipc	ra,0x1
    518a:	cfc080e7          	jalr	-772(ra) # 5e82 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    518e:	f6240613          	addi	a2,s0,-158
    5192:	85ea                	mv	a1,s10
    5194:	00003517          	auipc	a0,0x3
    5198:	01c50513          	addi	a0,a0,28 # 81b0 <malloc+0x1ee4>
    519c:	00001097          	auipc	ra,0x1
    51a0:	074080e7          	jalr	116(ra) # 6210 <printf>
        exit(1);
    51a4:	4505                	li	a0,1
    51a6:	00001097          	auipc	ra,0x1
    51aa:	cdc080e7          	jalr	-804(ra) # 5e82 <exit>
  close(fd);
    51ae:	854a                	mv	a0,s2
    51b0:	00001097          	auipc	ra,0x1
    51b4:	cfa080e7          	jalr	-774(ra) # 5eaa <close>
  if(n != N){
    51b8:	02800793          	li	a5,40
    51bc:	00fb1a63          	bne	s6,a5,51d0 <concreate+0x1c2>
    if(((i % 3) == 0 && pid == 0) ||
    51c0:	55555a37          	lui	s4,0x55555
    51c4:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x555458de>
      close(open(file, 0));
    51c8:	f9840993          	addi	s3,s0,-104
  for(i = 0; i < N; i++){
    51cc:	8ada                	mv	s5,s6
    51ce:	a0d9                	j	5294 <concreate+0x286>
    printf("%s: concreate not enough files in directory listing\n", s);
    51d0:	85ea                	mv	a1,s10
    51d2:	00003517          	auipc	a0,0x3
    51d6:	00650513          	addi	a0,a0,6 # 81d8 <malloc+0x1f0c>
    51da:	00001097          	auipc	ra,0x1
    51de:	036080e7          	jalr	54(ra) # 6210 <printf>
    exit(1);
    51e2:	4505                	li	a0,1
    51e4:	00001097          	auipc	ra,0x1
    51e8:	c9e080e7          	jalr	-866(ra) # 5e82 <exit>
      printf("%s: fork failed\n", s);
    51ec:	85ea                	mv	a1,s10
    51ee:	00002517          	auipc	a0,0x2
    51f2:	aa250513          	addi	a0,a0,-1374 # 6c90 <malloc+0x9c4>
    51f6:	00001097          	auipc	ra,0x1
    51fa:	01a080e7          	jalr	26(ra) # 6210 <printf>
      exit(1);
    51fe:	4505                	li	a0,1
    5200:	00001097          	auipc	ra,0x1
    5204:	c82080e7          	jalr	-894(ra) # 5e82 <exit>
      close(open(file, 0));
    5208:	4581                	li	a1,0
    520a:	854e                	mv	a0,s3
    520c:	00001097          	auipc	ra,0x1
    5210:	cb6080e7          	jalr	-842(ra) # 5ec2 <open>
    5214:	00001097          	auipc	ra,0x1
    5218:	c96080e7          	jalr	-874(ra) # 5eaa <close>
      close(open(file, 0));
    521c:	4581                	li	a1,0
    521e:	854e                	mv	a0,s3
    5220:	00001097          	auipc	ra,0x1
    5224:	ca2080e7          	jalr	-862(ra) # 5ec2 <open>
    5228:	00001097          	auipc	ra,0x1
    522c:	c82080e7          	jalr	-894(ra) # 5eaa <close>
      close(open(file, 0));
    5230:	4581                	li	a1,0
    5232:	854e                	mv	a0,s3
    5234:	00001097          	auipc	ra,0x1
    5238:	c8e080e7          	jalr	-882(ra) # 5ec2 <open>
    523c:	00001097          	auipc	ra,0x1
    5240:	c6e080e7          	jalr	-914(ra) # 5eaa <close>
      close(open(file, 0));
    5244:	4581                	li	a1,0
    5246:	854e                	mv	a0,s3
    5248:	00001097          	auipc	ra,0x1
    524c:	c7a080e7          	jalr	-902(ra) # 5ec2 <open>
    5250:	00001097          	auipc	ra,0x1
    5254:	c5a080e7          	jalr	-934(ra) # 5eaa <close>
      close(open(file, 0));
    5258:	4581                	li	a1,0
    525a:	854e                	mv	a0,s3
    525c:	00001097          	auipc	ra,0x1
    5260:	c66080e7          	jalr	-922(ra) # 5ec2 <open>
    5264:	00001097          	auipc	ra,0x1
    5268:	c46080e7          	jalr	-954(ra) # 5eaa <close>
      close(open(file, 0));
    526c:	4581                	li	a1,0
    526e:	854e                	mv	a0,s3
    5270:	00001097          	auipc	ra,0x1
    5274:	c52080e7          	jalr	-942(ra) # 5ec2 <open>
    5278:	00001097          	auipc	ra,0x1
    527c:	c32080e7          	jalr	-974(ra) # 5eaa <close>
    if(pid == 0)
    5280:	08090663          	beqz	s2,530c <concreate+0x2fe>
      wait(0);
    5284:	4501                	li	a0,0
    5286:	00001097          	auipc	ra,0x1
    528a:	c04080e7          	jalr	-1020(ra) # 5e8a <wait>
  for(i = 0; i < N; i++){
    528e:	2485                	addiw	s1,s1,1
    5290:	0f548d63          	beq	s1,s5,538a <concreate+0x37c>
    file[1] = '0' + i;
    5294:	0304879b          	addiw	a5,s1,48
    5298:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    529c:	00001097          	auipc	ra,0x1
    52a0:	bde080e7          	jalr	-1058(ra) # 5e7a <fork>
    52a4:	892a                	mv	s2,a0
    if(pid < 0){
    52a6:	f40543e3          	bltz	a0,51ec <concreate+0x1de>
    if(((i % 3) == 0 && pid == 0) ||
    52aa:	03448733          	mul	a4,s1,s4
    52ae:	9301                	srli	a4,a4,0x20
    52b0:	41f4d79b          	sraiw	a5,s1,0x1f
    52b4:	9f1d                	subw	a4,a4,a5
    52b6:	0017179b          	slliw	a5,a4,0x1
    52ba:	9fb9                	addw	a5,a5,a4
    52bc:	40f487bb          	subw	a5,s1,a5
    52c0:	00a7e733          	or	a4,a5,a0
    52c4:	2701                	sext.w	a4,a4
    52c6:	d329                	beqz	a4,5208 <concreate+0x1fa>
       ((i % 3) == 1 && pid != 0)){
    52c8:	c119                	beqz	a0,52ce <concreate+0x2c0>
    if(((i % 3) == 0 && pid == 0) ||
    52ca:	17fd                	addi	a5,a5,-1
       ((i % 3) == 1 && pid != 0)){
    52cc:	df95                	beqz	a5,5208 <concreate+0x1fa>
      unlink(file);
    52ce:	854e                	mv	a0,s3
    52d0:	00001097          	auipc	ra,0x1
    52d4:	c02080e7          	jalr	-1022(ra) # 5ed2 <unlink>
      unlink(file);
    52d8:	854e                	mv	a0,s3
    52da:	00001097          	auipc	ra,0x1
    52de:	bf8080e7          	jalr	-1032(ra) # 5ed2 <unlink>
      unlink(file);
    52e2:	854e                	mv	a0,s3
    52e4:	00001097          	auipc	ra,0x1
    52e8:	bee080e7          	jalr	-1042(ra) # 5ed2 <unlink>
      unlink(file);
    52ec:	854e                	mv	a0,s3
    52ee:	00001097          	auipc	ra,0x1
    52f2:	be4080e7          	jalr	-1052(ra) # 5ed2 <unlink>
      unlink(file);
    52f6:	854e                	mv	a0,s3
    52f8:	00001097          	auipc	ra,0x1
    52fc:	bda080e7          	jalr	-1062(ra) # 5ed2 <unlink>
      unlink(file);
    5300:	854e                	mv	a0,s3
    5302:	00001097          	auipc	ra,0x1
    5306:	bd0080e7          	jalr	-1072(ra) # 5ed2 <unlink>
    530a:	bf9d                	j	5280 <concreate+0x272>
      exit(0);
    530c:	4501                	li	a0,0
    530e:	00001097          	auipc	ra,0x1
    5312:	b74080e7          	jalr	-1164(ra) # 5e82 <exit>
      close(fd);
    5316:	00001097          	auipc	ra,0x1
    531a:	b94080e7          	jalr	-1132(ra) # 5eaa <close>
    if(pid == 0) {
    531e:	bb65                	j	50d6 <concreate+0xc8>
      close(fd);
    5320:	00001097          	auipc	ra,0x1
    5324:	b8a080e7          	jalr	-1142(ra) # 5eaa <close>
      wait(&xstatus);
    5328:	8556                	mv	a0,s5
    532a:	00001097          	auipc	ra,0x1
    532e:	b60080e7          	jalr	-1184(ra) # 5e8a <wait>
      if(xstatus != 0)
    5332:	f5c42483          	lw	s1,-164(s0)
    5336:	da0495e3          	bnez	s1,50e0 <concreate+0xd2>
  for(i = 0; i < N; i++){
    533a:	2905                	addiw	s2,s2,1
    533c:	db4907e3          	beq	s2,s4,50ea <concreate+0xdc>
    file[1] = '0' + i;
    5340:	0309079b          	addiw	a5,s2,48
    5344:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    5348:	854e                	mv	a0,s3
    534a:	00001097          	auipc	ra,0x1
    534e:	b88080e7          	jalr	-1144(ra) # 5ed2 <unlink>
    pid = fork();
    5352:	00001097          	auipc	ra,0x1
    5356:	b28080e7          	jalr	-1240(ra) # 5e7a <fork>
    if(pid && (i % 3) == 1){
    535a:	d00509e3          	beqz	a0,506c <concreate+0x5e>
    535e:	036907b3          	mul	a5,s2,s6
    5362:	9381                	srli	a5,a5,0x20
    5364:	41f9571b          	sraiw	a4,s2,0x1f
    5368:	9f99                	subw	a5,a5,a4
    536a:	0017971b          	slliw	a4,a5,0x1
    536e:	9fb9                	addw	a5,a5,a4
    5370:	40f907bb          	subw	a5,s2,a5
    5374:	cf7785e3          	beq	a5,s7,505e <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    5378:	85e2                	mv	a1,s8
    537a:	854e                	mv	a0,s3
    537c:	00001097          	auipc	ra,0x1
    5380:	b46080e7          	jalr	-1210(ra) # 5ec2 <open>
      if(fd < 0){
    5384:	f8055ee3          	bgez	a0,5320 <concreate+0x312>
    5388:	bb31                	j	50a4 <concreate+0x96>
}
    538a:	70aa                	ld	ra,168(sp)
    538c:	740a                	ld	s0,160(sp)
    538e:	64ea                	ld	s1,152(sp)
    5390:	694a                	ld	s2,144(sp)
    5392:	69aa                	ld	s3,136(sp)
    5394:	6a0a                	ld	s4,128(sp)
    5396:	7ae6                	ld	s5,120(sp)
    5398:	7b46                	ld	s6,112(sp)
    539a:	7ba6                	ld	s7,104(sp)
    539c:	7c06                	ld	s8,96(sp)
    539e:	6ce6                	ld	s9,88(sp)
    53a0:	6d46                	ld	s10,80(sp)
    53a2:	614d                	addi	sp,sp,176
    53a4:	8082                	ret

00000000000053a6 <bigfile>:
{
    53a6:	7139                	addi	sp,sp,-64
    53a8:	fc06                	sd	ra,56(sp)
    53aa:	f822                	sd	s0,48(sp)
    53ac:	f426                	sd	s1,40(sp)
    53ae:	f04a                	sd	s2,32(sp)
    53b0:	ec4e                	sd	s3,24(sp)
    53b2:	e852                	sd	s4,16(sp)
    53b4:	e456                	sd	s5,8(sp)
    53b6:	e05a                	sd	s6,0(sp)
    53b8:	0080                	addi	s0,sp,64
    53ba:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    53bc:	00003517          	auipc	a0,0x3
    53c0:	e5450513          	addi	a0,a0,-428 # 8210 <malloc+0x1f44>
    53c4:	00001097          	auipc	ra,0x1
    53c8:	b0e080e7          	jalr	-1266(ra) # 5ed2 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    53cc:	20200593          	li	a1,514
    53d0:	00003517          	auipc	a0,0x3
    53d4:	e4050513          	addi	a0,a0,-448 # 8210 <malloc+0x1f44>
    53d8:	00001097          	auipc	ra,0x1
    53dc:	aea080e7          	jalr	-1302(ra) # 5ec2 <open>
  if(fd < 0){
    53e0:	0a054463          	bltz	a0,5488 <bigfile+0xe2>
    53e4:	8a2a                	mv	s4,a0
    53e6:	4481                	li	s1,0
    memset(buf, i, SZ);
    53e8:	25800913          	li	s2,600
    53ec:	00008997          	auipc	s3,0x8
    53f0:	88c98993          	addi	s3,s3,-1908 # cc78 <buf>
  for(i = 0; i < N; i++){
    53f4:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    53f6:	864a                	mv	a2,s2
    53f8:	85a6                	mv	a1,s1
    53fa:	854e                	mv	a0,s3
    53fc:	00001097          	auipc	ra,0x1
    5400:	874080e7          	jalr	-1932(ra) # 5c70 <memset>
    if(write(fd, buf, SZ) != SZ){
    5404:	864a                	mv	a2,s2
    5406:	85ce                	mv	a1,s3
    5408:	8552                	mv	a0,s4
    540a:	00001097          	auipc	ra,0x1
    540e:	a98080e7          	jalr	-1384(ra) # 5ea2 <write>
    5412:	09251963          	bne	a0,s2,54a4 <bigfile+0xfe>
  for(i = 0; i < N; i++){
    5416:	2485                	addiw	s1,s1,1
    5418:	fd549fe3          	bne	s1,s5,53f6 <bigfile+0x50>
  close(fd);
    541c:	8552                	mv	a0,s4
    541e:	00001097          	auipc	ra,0x1
    5422:	a8c080e7          	jalr	-1396(ra) # 5eaa <close>
  fd = open("bigfile.dat", 0);
    5426:	4581                	li	a1,0
    5428:	00003517          	auipc	a0,0x3
    542c:	de850513          	addi	a0,a0,-536 # 8210 <malloc+0x1f44>
    5430:	00001097          	auipc	ra,0x1
    5434:	a92080e7          	jalr	-1390(ra) # 5ec2 <open>
    5438:	8aaa                	mv	s5,a0
  total = 0;
    543a:	4a01                	li	s4,0
  for(i = 0; ; i++){
    543c:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    543e:	12c00993          	li	s3,300
    5442:	00008917          	auipc	s2,0x8
    5446:	83690913          	addi	s2,s2,-1994 # cc78 <buf>
  if(fd < 0){
    544a:	06054b63          	bltz	a0,54c0 <bigfile+0x11a>
    cc = read(fd, buf, SZ/2);
    544e:	864e                	mv	a2,s3
    5450:	85ca                	mv	a1,s2
    5452:	8556                	mv	a0,s5
    5454:	00001097          	auipc	ra,0x1
    5458:	a46080e7          	jalr	-1466(ra) # 5e9a <read>
    if(cc < 0){
    545c:	08054063          	bltz	a0,54dc <bigfile+0x136>
    if(cc == 0)
    5460:	c961                	beqz	a0,5530 <bigfile+0x18a>
    if(cc != SZ/2){
    5462:	09351b63          	bne	a0,s3,54f8 <bigfile+0x152>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5466:	01f4d79b          	srliw	a5,s1,0x1f
    546a:	9fa5                	addw	a5,a5,s1
    546c:	4017d79b          	sraiw	a5,a5,0x1
    5470:	00094703          	lbu	a4,0(s2)
    5474:	0af71063          	bne	a4,a5,5514 <bigfile+0x16e>
    5478:	12b94703          	lbu	a4,299(s2)
    547c:	08f71c63          	bne	a4,a5,5514 <bigfile+0x16e>
    total += cc;
    5480:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    5484:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5486:	b7e1                	j	544e <bigfile+0xa8>
    printf("%s: cannot create bigfile", s);
    5488:	85da                	mv	a1,s6
    548a:	00003517          	auipc	a0,0x3
    548e:	d9650513          	addi	a0,a0,-618 # 8220 <malloc+0x1f54>
    5492:	00001097          	auipc	ra,0x1
    5496:	d7e080e7          	jalr	-642(ra) # 6210 <printf>
    exit(1);
    549a:	4505                	li	a0,1
    549c:	00001097          	auipc	ra,0x1
    54a0:	9e6080e7          	jalr	-1562(ra) # 5e82 <exit>
      printf("%s: write bigfile failed\n", s);
    54a4:	85da                	mv	a1,s6
    54a6:	00003517          	auipc	a0,0x3
    54aa:	d9a50513          	addi	a0,a0,-614 # 8240 <malloc+0x1f74>
    54ae:	00001097          	auipc	ra,0x1
    54b2:	d62080e7          	jalr	-670(ra) # 6210 <printf>
      exit(1);
    54b6:	4505                	li	a0,1
    54b8:	00001097          	auipc	ra,0x1
    54bc:	9ca080e7          	jalr	-1590(ra) # 5e82 <exit>
    printf("%s: cannot open bigfile\n", s);
    54c0:	85da                	mv	a1,s6
    54c2:	00003517          	auipc	a0,0x3
    54c6:	d9e50513          	addi	a0,a0,-610 # 8260 <malloc+0x1f94>
    54ca:	00001097          	auipc	ra,0x1
    54ce:	d46080e7          	jalr	-698(ra) # 6210 <printf>
    exit(1);
    54d2:	4505                	li	a0,1
    54d4:	00001097          	auipc	ra,0x1
    54d8:	9ae080e7          	jalr	-1618(ra) # 5e82 <exit>
      printf("%s: read bigfile failed\n", s);
    54dc:	85da                	mv	a1,s6
    54de:	00003517          	auipc	a0,0x3
    54e2:	da250513          	addi	a0,a0,-606 # 8280 <malloc+0x1fb4>
    54e6:	00001097          	auipc	ra,0x1
    54ea:	d2a080e7          	jalr	-726(ra) # 6210 <printf>
      exit(1);
    54ee:	4505                	li	a0,1
    54f0:	00001097          	auipc	ra,0x1
    54f4:	992080e7          	jalr	-1646(ra) # 5e82 <exit>
      printf("%s: short read bigfile\n", s);
    54f8:	85da                	mv	a1,s6
    54fa:	00003517          	auipc	a0,0x3
    54fe:	da650513          	addi	a0,a0,-602 # 82a0 <malloc+0x1fd4>
    5502:	00001097          	auipc	ra,0x1
    5506:	d0e080e7          	jalr	-754(ra) # 6210 <printf>
      exit(1);
    550a:	4505                	li	a0,1
    550c:	00001097          	auipc	ra,0x1
    5510:	976080e7          	jalr	-1674(ra) # 5e82 <exit>
      printf("%s: read bigfile wrong data\n", s);
    5514:	85da                	mv	a1,s6
    5516:	00003517          	auipc	a0,0x3
    551a:	da250513          	addi	a0,a0,-606 # 82b8 <malloc+0x1fec>
    551e:	00001097          	auipc	ra,0x1
    5522:	cf2080e7          	jalr	-782(ra) # 6210 <printf>
      exit(1);
    5526:	4505                	li	a0,1
    5528:	00001097          	auipc	ra,0x1
    552c:	95a080e7          	jalr	-1702(ra) # 5e82 <exit>
  close(fd);
    5530:	8556                	mv	a0,s5
    5532:	00001097          	auipc	ra,0x1
    5536:	978080e7          	jalr	-1672(ra) # 5eaa <close>
  if(total != N*SZ){
    553a:	678d                	lui	a5,0x3
    553c:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrkbugs+0x3c>
    5540:	02fa1463          	bne	s4,a5,5568 <bigfile+0x1c2>
  unlink("bigfile.dat");
    5544:	00003517          	auipc	a0,0x3
    5548:	ccc50513          	addi	a0,a0,-820 # 8210 <malloc+0x1f44>
    554c:	00001097          	auipc	ra,0x1
    5550:	986080e7          	jalr	-1658(ra) # 5ed2 <unlink>
}
    5554:	70e2                	ld	ra,56(sp)
    5556:	7442                	ld	s0,48(sp)
    5558:	74a2                	ld	s1,40(sp)
    555a:	7902                	ld	s2,32(sp)
    555c:	69e2                	ld	s3,24(sp)
    555e:	6a42                	ld	s4,16(sp)
    5560:	6aa2                	ld	s5,8(sp)
    5562:	6b02                	ld	s6,0(sp)
    5564:	6121                	addi	sp,sp,64
    5566:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5568:	85da                	mv	a1,s6
    556a:	00003517          	auipc	a0,0x3
    556e:	d6e50513          	addi	a0,a0,-658 # 82d8 <malloc+0x200c>
    5572:	00001097          	auipc	ra,0x1
    5576:	c9e080e7          	jalr	-866(ra) # 6210 <printf>
    exit(1);
    557a:	4505                	li	a0,1
    557c:	00001097          	auipc	ra,0x1
    5580:	906080e7          	jalr	-1786(ra) # 5e82 <exit>

0000000000005584 <fsfull>:
{
    5584:	7171                	addi	sp,sp,-176
    5586:	f506                	sd	ra,168(sp)
    5588:	f122                	sd	s0,160(sp)
    558a:	ed26                	sd	s1,152(sp)
    558c:	e94a                	sd	s2,144(sp)
    558e:	e54e                	sd	s3,136(sp)
    5590:	e152                	sd	s4,128(sp)
    5592:	fcd6                	sd	s5,120(sp)
    5594:	f8da                	sd	s6,112(sp)
    5596:	f4de                	sd	s7,104(sp)
    5598:	f0e2                	sd	s8,96(sp)
    559a:	ece6                	sd	s9,88(sp)
    559c:	e8ea                	sd	s10,80(sp)
    559e:	e4ee                	sd	s11,72(sp)
    55a0:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    55a2:	00003517          	auipc	a0,0x3
    55a6:	d5650513          	addi	a0,a0,-682 # 82f8 <malloc+0x202c>
    55aa:	00001097          	auipc	ra,0x1
    55ae:	c66080e7          	jalr	-922(ra) # 6210 <printf>
  for(nfiles = 0; ; nfiles++){
    55b2:	4481                	li	s1,0
    name[0] = 'f';
    55b4:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    55b8:	10625cb7          	lui	s9,0x10625
    55bc:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061515b>
    name[2] = '0' + (nfiles % 1000) / 100;
    55c0:	51eb8ab7          	lui	s5,0x51eb8
    55c4:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea88a7>
    name[3] = '0' + (nfiles % 100) / 10;
    55c8:	66666a37          	lui	s4,0x66666
    55cc:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666569ef>
    printf("writing %s\n", name);
    55d0:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    55d4:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    55d8:	039487b3          	mul	a5,s1,s9
    55dc:	9799                	srai	a5,a5,0x26
    55de:	41f4d69b          	sraiw	a3,s1,0x1f
    55e2:	9f95                	subw	a5,a5,a3
    55e4:	0307871b          	addiw	a4,a5,48
    55e8:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    55ec:	3e800713          	li	a4,1000
    55f0:	02f707bb          	mulw	a5,a4,a5
    55f4:	40f487bb          	subw	a5,s1,a5
    55f8:	03578733          	mul	a4,a5,s5
    55fc:	9715                	srai	a4,a4,0x25
    55fe:	41f7d79b          	sraiw	a5,a5,0x1f
    5602:	40f707bb          	subw	a5,a4,a5
    5606:	0307879b          	addiw	a5,a5,48
    560a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    560e:	035487b3          	mul	a5,s1,s5
    5612:	9795                	srai	a5,a5,0x25
    5614:	9f95                	subw	a5,a5,a3
    5616:	06400713          	li	a4,100
    561a:	02f707bb          	mulw	a5,a4,a5
    561e:	40f487bb          	subw	a5,s1,a5
    5622:	03478733          	mul	a4,a5,s4
    5626:	9709                	srai	a4,a4,0x22
    5628:	41f7d79b          	sraiw	a5,a5,0x1f
    562c:	40f707bb          	subw	a5,a4,a5
    5630:	0307879b          	addiw	a5,a5,48
    5634:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5638:	03448733          	mul	a4,s1,s4
    563c:	9709                	srai	a4,a4,0x22
    563e:	9f15                	subw	a4,a4,a3
    5640:	0027179b          	slliw	a5,a4,0x2
    5644:	9fb9                	addw	a5,a5,a4
    5646:	0017979b          	slliw	a5,a5,0x1
    564a:	40f487bb          	subw	a5,s1,a5
    564e:	0307879b          	addiw	a5,a5,48
    5652:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5656:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    565a:	85ea                	mv	a1,s10
    565c:	00003517          	auipc	a0,0x3
    5660:	cac50513          	addi	a0,a0,-852 # 8308 <malloc+0x203c>
    5664:	00001097          	auipc	ra,0x1
    5668:	bac080e7          	jalr	-1108(ra) # 6210 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    566c:	20200593          	li	a1,514
    5670:	856a                	mv	a0,s10
    5672:	00001097          	auipc	ra,0x1
    5676:	850080e7          	jalr	-1968(ra) # 5ec2 <open>
    567a:	892a                	mv	s2,a0
    if(fd < 0){
    567c:	10055163          	bgez	a0,577e <fsfull+0x1fa>
      printf("open %s failed\n", name);
    5680:	f5040593          	addi	a1,s0,-176
    5684:	00003517          	auipc	a0,0x3
    5688:	c9450513          	addi	a0,a0,-876 # 8318 <malloc+0x204c>
    568c:	00001097          	auipc	ra,0x1
    5690:	b84080e7          	jalr	-1148(ra) # 6210 <printf>
  while(nfiles >= 0){
    5694:	0a04ce63          	bltz	s1,5750 <fsfull+0x1cc>
    name[0] = 'f';
    5698:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    569c:	10625a37          	lui	s4,0x10625
    56a0:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061515b>
    name[2] = '0' + (nfiles % 1000) / 100;
    56a4:	3e800b93          	li	s7,1000
    56a8:	51eb89b7          	lui	s3,0x51eb8
    56ac:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea88a7>
    name[3] = '0' + (nfiles % 100) / 10;
    56b0:	06400b13          	li	s6,100
    56b4:	66666937          	lui	s2,0x66666
    56b8:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666569ef>
    unlink(name);
    56bc:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    56c0:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    56c4:	034487b3          	mul	a5,s1,s4
    56c8:	9799                	srai	a5,a5,0x26
    56ca:	41f4d69b          	sraiw	a3,s1,0x1f
    56ce:	9f95                	subw	a5,a5,a3
    56d0:	0307871b          	addiw	a4,a5,48
    56d4:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    56d8:	02fb87bb          	mulw	a5,s7,a5
    56dc:	40f487bb          	subw	a5,s1,a5
    56e0:	03378733          	mul	a4,a5,s3
    56e4:	9715                	srai	a4,a4,0x25
    56e6:	41f7d79b          	sraiw	a5,a5,0x1f
    56ea:	40f707bb          	subw	a5,a4,a5
    56ee:	0307879b          	addiw	a5,a5,48
    56f2:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    56f6:	033487b3          	mul	a5,s1,s3
    56fa:	9795                	srai	a5,a5,0x25
    56fc:	9f95                	subw	a5,a5,a3
    56fe:	02fb07bb          	mulw	a5,s6,a5
    5702:	40f487bb          	subw	a5,s1,a5
    5706:	03278733          	mul	a4,a5,s2
    570a:	9709                	srai	a4,a4,0x22
    570c:	41f7d79b          	sraiw	a5,a5,0x1f
    5710:	40f707bb          	subw	a5,a4,a5
    5714:	0307879b          	addiw	a5,a5,48
    5718:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    571c:	03248733          	mul	a4,s1,s2
    5720:	9709                	srai	a4,a4,0x22
    5722:	9f15                	subw	a4,a4,a3
    5724:	0027179b          	slliw	a5,a4,0x2
    5728:	9fb9                	addw	a5,a5,a4
    572a:	0017979b          	slliw	a5,a5,0x1
    572e:	40f487bb          	subw	a5,s1,a5
    5732:	0307879b          	addiw	a5,a5,48
    5736:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    573a:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    573e:	8556                	mv	a0,s5
    5740:	00000097          	auipc	ra,0x0
    5744:	792080e7          	jalr	1938(ra) # 5ed2 <unlink>
    nfiles--;
    5748:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    574a:	57fd                	li	a5,-1
    574c:	f6f49ae3          	bne	s1,a5,56c0 <fsfull+0x13c>
  printf("fsfull test finished\n");
    5750:	00003517          	auipc	a0,0x3
    5754:	be850513          	addi	a0,a0,-1048 # 8338 <malloc+0x206c>
    5758:	00001097          	auipc	ra,0x1
    575c:	ab8080e7          	jalr	-1352(ra) # 6210 <printf>
}
    5760:	70aa                	ld	ra,168(sp)
    5762:	740a                	ld	s0,160(sp)
    5764:	64ea                	ld	s1,152(sp)
    5766:	694a                	ld	s2,144(sp)
    5768:	69aa                	ld	s3,136(sp)
    576a:	6a0a                	ld	s4,128(sp)
    576c:	7ae6                	ld	s5,120(sp)
    576e:	7b46                	ld	s6,112(sp)
    5770:	7ba6                	ld	s7,104(sp)
    5772:	7c06                	ld	s8,96(sp)
    5774:	6ce6                	ld	s9,88(sp)
    5776:	6d46                	ld	s10,80(sp)
    5778:	6da6                	ld	s11,72(sp)
    577a:	614d                	addi	sp,sp,176
    577c:	8082                	ret
    int total = 0;
    577e:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    5780:	40000c13          	li	s8,1024
    5784:	00007b97          	auipc	s7,0x7
    5788:	4f4b8b93          	addi	s7,s7,1268 # cc78 <buf>
      if(cc < BSIZE)
    578c:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    5790:	8662                	mv	a2,s8
    5792:	85de                	mv	a1,s7
    5794:	854a                	mv	a0,s2
    5796:	00000097          	auipc	ra,0x0
    579a:	70c080e7          	jalr	1804(ra) # 5ea2 <write>
      if(cc < BSIZE)
    579e:	00ab5563          	bge	s6,a0,57a8 <fsfull+0x224>
      total += cc;
    57a2:	00a989bb          	addw	s3,s3,a0
    while(1){
    57a6:	b7ed                	j	5790 <fsfull+0x20c>
    printf("wrote %d bytes\n", total);
    57a8:	85ce                	mv	a1,s3
    57aa:	00003517          	auipc	a0,0x3
    57ae:	b7e50513          	addi	a0,a0,-1154 # 8328 <malloc+0x205c>
    57b2:	00001097          	auipc	ra,0x1
    57b6:	a5e080e7          	jalr	-1442(ra) # 6210 <printf>
    close(fd);
    57ba:	854a                	mv	a0,s2
    57bc:	00000097          	auipc	ra,0x0
    57c0:	6ee080e7          	jalr	1774(ra) # 5eaa <close>
    if(total == 0)
    57c4:	ec0988e3          	beqz	s3,5694 <fsfull+0x110>
  for(nfiles = 0; ; nfiles++){
    57c8:	2485                	addiw	s1,s1,1
    57ca:	b529                	j	55d4 <fsfull+0x50>

00000000000057cc <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    57cc:	7179                	addi	sp,sp,-48
    57ce:	f406                	sd	ra,40(sp)
    57d0:	f022                	sd	s0,32(sp)
    57d2:	ec26                	sd	s1,24(sp)
    57d4:	e84a                	sd	s2,16(sp)
    57d6:	1800                	addi	s0,sp,48
    57d8:	84aa                	mv	s1,a0
    57da:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    57dc:	00003517          	auipc	a0,0x3
    57e0:	b7450513          	addi	a0,a0,-1164 # 8350 <malloc+0x2084>
    57e4:	00001097          	auipc	ra,0x1
    57e8:	a2c080e7          	jalr	-1492(ra) # 6210 <printf>
  if((pid = fork()) < 0) {
    57ec:	00000097          	auipc	ra,0x0
    57f0:	68e080e7          	jalr	1678(ra) # 5e7a <fork>
    57f4:	02054e63          	bltz	a0,5830 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    57f8:	c929                	beqz	a0,584a <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    57fa:	fdc40513          	addi	a0,s0,-36
    57fe:	00000097          	auipc	ra,0x0
    5802:	68c080e7          	jalr	1676(ra) # 5e8a <wait>
    if(xstatus != 0) 
    5806:	fdc42783          	lw	a5,-36(s0)
    580a:	c7b9                	beqz	a5,5858 <run+0x8c>
      printf("FAILED\n");
    580c:	00003517          	auipc	a0,0x3
    5810:	b6c50513          	addi	a0,a0,-1172 # 8378 <malloc+0x20ac>
    5814:	00001097          	auipc	ra,0x1
    5818:	9fc080e7          	jalr	-1540(ra) # 6210 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    581c:	fdc42503          	lw	a0,-36(s0)
  }
}
    5820:	00153513          	seqz	a0,a0
    5824:	70a2                	ld	ra,40(sp)
    5826:	7402                	ld	s0,32(sp)
    5828:	64e2                	ld	s1,24(sp)
    582a:	6942                	ld	s2,16(sp)
    582c:	6145                	addi	sp,sp,48
    582e:	8082                	ret
    printf("runtest: fork error\n");
    5830:	00003517          	auipc	a0,0x3
    5834:	b3050513          	addi	a0,a0,-1232 # 8360 <malloc+0x2094>
    5838:	00001097          	auipc	ra,0x1
    583c:	9d8080e7          	jalr	-1576(ra) # 6210 <printf>
    exit(1);
    5840:	4505                	li	a0,1
    5842:	00000097          	auipc	ra,0x0
    5846:	640080e7          	jalr	1600(ra) # 5e82 <exit>
    f(s);
    584a:	854a                	mv	a0,s2
    584c:	9482                	jalr	s1
    exit(0);
    584e:	4501                	li	a0,0
    5850:	00000097          	auipc	ra,0x0
    5854:	632080e7          	jalr	1586(ra) # 5e82 <exit>
      printf("OK\n");
    5858:	00003517          	auipc	a0,0x3
    585c:	b2850513          	addi	a0,a0,-1240 # 8380 <malloc+0x20b4>
    5860:	00001097          	auipc	ra,0x1
    5864:	9b0080e7          	jalr	-1616(ra) # 6210 <printf>
    5868:	bf55                	j	581c <run+0x50>

000000000000586a <runtests>:

int
runtests(struct test *tests, char *justone) {
    586a:	1101                	addi	sp,sp,-32
    586c:	ec06                	sd	ra,24(sp)
    586e:	e822                	sd	s0,16(sp)
    5870:	e426                	sd	s1,8(sp)
    5872:	e04a                	sd	s2,0(sp)
    5874:	1000                	addi	s0,sp,32
    5876:	84aa                	mv	s1,a0
    5878:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    587a:	6508                	ld	a0,8(a0)
    587c:	ed01                	bnez	a0,5894 <runtests+0x2a>
    587e:	a82d                	j	58b8 <runtests+0x4e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
    5880:	648c                	ld	a1,8(s1)
    5882:	6088                	ld	a0,0(s1)
    5884:	00000097          	auipc	ra,0x0
    5888:	f48080e7          	jalr	-184(ra) # 57cc <run>
    588c:	cd09                	beqz	a0,58a6 <runtests+0x3c>
  for (struct test *t = tests; t->s != 0; t++) {
    588e:	04c1                	addi	s1,s1,16
    5890:	6488                	ld	a0,8(s1)
    5892:	c11d                	beqz	a0,58b8 <runtests+0x4e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5894:	fe0906e3          	beqz	s2,5880 <runtests+0x16>
    5898:	85ca                	mv	a1,s2
    589a:	00000097          	auipc	ra,0x0
    589e:	37a080e7          	jalr	890(ra) # 5c14 <strcmp>
    58a2:	f575                	bnez	a0,588e <runtests+0x24>
    58a4:	bff1                	j	5880 <runtests+0x16>
        printf("SOME TESTS FAILED\n");
    58a6:	00003517          	auipc	a0,0x3
    58aa:	ae250513          	addi	a0,a0,-1310 # 8388 <malloc+0x20bc>
    58ae:	00001097          	auipc	ra,0x1
    58b2:	962080e7          	jalr	-1694(ra) # 6210 <printf>
        return 1;
    58b6:	4505                	li	a0,1
      }
    }
  }
  return 0;
}
    58b8:	60e2                	ld	ra,24(sp)
    58ba:	6442                	ld	s0,16(sp)
    58bc:	64a2                	ld	s1,8(sp)
    58be:	6902                	ld	s2,0(sp)
    58c0:	6105                	addi	sp,sp,32
    58c2:	8082                	ret

00000000000058c4 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    58c4:	7139                	addi	sp,sp,-64
    58c6:	fc06                	sd	ra,56(sp)
    58c8:	f822                	sd	s0,48(sp)
    58ca:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    58cc:	fc840513          	addi	a0,s0,-56
    58d0:	00000097          	auipc	ra,0x0
    58d4:	5c2080e7          	jalr	1474(ra) # 5e92 <pipe>
    58d8:	06054b63          	bltz	a0,594e <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    58dc:	00000097          	auipc	ra,0x0
    58e0:	59e080e7          	jalr	1438(ra) # 5e7a <fork>

  if(pid < 0){
    58e4:	08054663          	bltz	a0,5970 <countfree+0xac>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    58e8:	e955                	bnez	a0,599c <countfree+0xd8>
    58ea:	f426                	sd	s1,40(sp)
    58ec:	f04a                	sd	s2,32(sp)
    58ee:	ec4e                	sd	s3,24(sp)
    58f0:	e852                	sd	s4,16(sp)
    close(fds[0]);
    58f2:	fc842503          	lw	a0,-56(s0)
    58f6:	00000097          	auipc	ra,0x0
    58fa:	5b4080e7          	jalr	1460(ra) # 5eaa <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
    58fe:	6905                	lui	s2,0x1
      if(a == 0xffffffffffffffff){
    5900:	59fd                	li	s3,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5902:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5904:	00001a17          	auipc	s4,0x1
    5908:	b74a0a13          	addi	s4,s4,-1164 # 6478 <malloc+0x1ac>
      uint64 a = (uint64) sbrk(4096);
    590c:	854a                	mv	a0,s2
    590e:	00000097          	auipc	ra,0x0
    5912:	5fc080e7          	jalr	1532(ra) # 5f0a <sbrk>
      if(a == 0xffffffffffffffff){
    5916:	07350e63          	beq	a0,s3,5992 <countfree+0xce>
      *(char *)(a + 4096 - 1) = 1;
    591a:	954a                	add	a0,a0,s2
    591c:	fe950fa3          	sb	s1,-1(a0)
      if(write(fds[1], "x", 1) != 1){
    5920:	8626                	mv	a2,s1
    5922:	85d2                	mv	a1,s4
    5924:	fcc42503          	lw	a0,-52(s0)
    5928:	00000097          	auipc	ra,0x0
    592c:	57a080e7          	jalr	1402(ra) # 5ea2 <write>
    5930:	fc950ee3          	beq	a0,s1,590c <countfree+0x48>
        printf("write() failed in countfree()\n");
    5934:	00003517          	auipc	a0,0x3
    5938:	aac50513          	addi	a0,a0,-1364 # 83e0 <malloc+0x2114>
    593c:	00001097          	auipc	ra,0x1
    5940:	8d4080e7          	jalr	-1836(ra) # 6210 <printf>
        exit(1);
    5944:	4505                	li	a0,1
    5946:	00000097          	auipc	ra,0x0
    594a:	53c080e7          	jalr	1340(ra) # 5e82 <exit>
    594e:	f426                	sd	s1,40(sp)
    5950:	f04a                	sd	s2,32(sp)
    5952:	ec4e                	sd	s3,24(sp)
    5954:	e852                	sd	s4,16(sp)
    printf("pipe() failed in countfree()\n");
    5956:	00003517          	auipc	a0,0x3
    595a:	a4a50513          	addi	a0,a0,-1462 # 83a0 <malloc+0x20d4>
    595e:	00001097          	auipc	ra,0x1
    5962:	8b2080e7          	jalr	-1870(ra) # 6210 <printf>
    exit(1);
    5966:	4505                	li	a0,1
    5968:	00000097          	auipc	ra,0x0
    596c:	51a080e7          	jalr	1306(ra) # 5e82 <exit>
    5970:	f426                	sd	s1,40(sp)
    5972:	f04a                	sd	s2,32(sp)
    5974:	ec4e                	sd	s3,24(sp)
    5976:	e852                	sd	s4,16(sp)
    printf("fork failed in countfree()\n");
    5978:	00003517          	auipc	a0,0x3
    597c:	a4850513          	addi	a0,a0,-1464 # 83c0 <malloc+0x20f4>
    5980:	00001097          	auipc	ra,0x1
    5984:	890080e7          	jalr	-1904(ra) # 6210 <printf>
    exit(1);
    5988:	4505                	li	a0,1
    598a:	00000097          	auipc	ra,0x0
    598e:	4f8080e7          	jalr	1272(ra) # 5e82 <exit>
      }
    }

    exit(0);
    5992:	4501                	li	a0,0
    5994:	00000097          	auipc	ra,0x0
    5998:	4ee080e7          	jalr	1262(ra) # 5e82 <exit>
    599c:	f426                	sd	s1,40(sp)
    599e:	f04a                	sd	s2,32(sp)
    59a0:	ec4e                	sd	s3,24(sp)
  }

  close(fds[1]);
    59a2:	fcc42503          	lw	a0,-52(s0)
    59a6:	00000097          	auipc	ra,0x0
    59aa:	504080e7          	jalr	1284(ra) # 5eaa <close>

  int n = 0;
    59ae:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    59b0:	fc740993          	addi	s3,s0,-57
    59b4:	4905                	li	s2,1
    59b6:	864a                	mv	a2,s2
    59b8:	85ce                	mv	a1,s3
    59ba:	fc842503          	lw	a0,-56(s0)
    59be:	00000097          	auipc	ra,0x0
    59c2:	4dc080e7          	jalr	1244(ra) # 5e9a <read>
    if(cc < 0){
    59c6:	00054563          	bltz	a0,59d0 <countfree+0x10c>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    59ca:	c10d                	beqz	a0,59ec <countfree+0x128>
      break;
    n += 1;
    59cc:	2485                	addiw	s1,s1,1
  while(1){
    59ce:	b7e5                	j	59b6 <countfree+0xf2>
    59d0:	e852                	sd	s4,16(sp)
      printf("read() failed in countfree()\n");
    59d2:	00003517          	auipc	a0,0x3
    59d6:	a2e50513          	addi	a0,a0,-1490 # 8400 <malloc+0x2134>
    59da:	00001097          	auipc	ra,0x1
    59de:	836080e7          	jalr	-1994(ra) # 6210 <printf>
      exit(1);
    59e2:	4505                	li	a0,1
    59e4:	00000097          	auipc	ra,0x0
    59e8:	49e080e7          	jalr	1182(ra) # 5e82 <exit>
  }

  close(fds[0]);
    59ec:	fc842503          	lw	a0,-56(s0)
    59f0:	00000097          	auipc	ra,0x0
    59f4:	4ba080e7          	jalr	1210(ra) # 5eaa <close>
  wait((int*)0);
    59f8:	4501                	li	a0,0
    59fa:	00000097          	auipc	ra,0x0
    59fe:	490080e7          	jalr	1168(ra) # 5e8a <wait>
  
  return n;
}
    5a02:	8526                	mv	a0,s1
    5a04:	74a2                	ld	s1,40(sp)
    5a06:	7902                	ld	s2,32(sp)
    5a08:	69e2                	ld	s3,24(sp)
    5a0a:	70e2                	ld	ra,56(sp)
    5a0c:	7442                	ld	s0,48(sp)
    5a0e:	6121                	addi	sp,sp,64
    5a10:	8082                	ret

0000000000005a12 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5a12:	7159                	addi	sp,sp,-112
    5a14:	f486                	sd	ra,104(sp)
    5a16:	f0a2                	sd	s0,96(sp)
    5a18:	eca6                	sd	s1,88(sp)
    5a1a:	e8ca                	sd	s2,80(sp)
    5a1c:	e4ce                	sd	s3,72(sp)
    5a1e:	e0d2                	sd	s4,64(sp)
    5a20:	fc56                	sd	s5,56(sp)
    5a22:	f85a                	sd	s6,48(sp)
    5a24:	f45e                	sd	s7,40(sp)
    5a26:	f062                	sd	s8,32(sp)
    5a28:	ec66                	sd	s9,24(sp)
    5a2a:	e86a                	sd	s10,16(sp)
    5a2c:	e46e                	sd	s11,8(sp)
    5a2e:	1880                	addi	s0,sp,112
    5a30:	8a2a                	mv	s4,a0
    5a32:	89ae                	mv	s3,a1
    5a34:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
      if(continuous != 2) {
    5a36:	ffe58b93          	addi	s7,a1,-2
    5a3a:	01703bb3          	snez	s7,s7
    printf("usertests starting\n");
    5a3e:	00003b17          	auipc	s6,0x3
    5a42:	9e2b0b13          	addi	s6,s6,-1566 # 8420 <malloc+0x2154>
    if (runtests(quicktests, justone)) {
    5a46:	00003a97          	auipc	s5,0x3
    5a4a:	5caa8a93          	addi	s5,s5,1482 # 9010 <quicktests>
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone)) {
    5a4e:	00004c17          	auipc	s8,0x4
    5a52:	992c0c13          	addi	s8,s8,-1646 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    5a56:	00003d97          	auipc	s11,0x3
    5a5a:	9e2d8d93          	addi	s11,s11,-1566 # 8438 <malloc+0x216c>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5a5e:	00003d17          	auipc	s10,0x3
    5a62:	9fad0d13          	addi	s10,s10,-1542 # 8458 <malloc+0x218c>
      if(continuous != 2) {
    5a66:	4c89                	li	s9,2
    5a68:	a839                	j	5a86 <drivetests+0x74>
        printf("usertests slow tests starting\n");
    5a6a:	856e                	mv	a0,s11
    5a6c:	00000097          	auipc	ra,0x0
    5a70:	7a4080e7          	jalr	1956(ra) # 6210 <printf>
    5a74:	a081                	j	5ab4 <drivetests+0xa2>
    if((free1 = countfree()) < free0) {
    5a76:	00000097          	auipc	ra,0x0
    5a7a:	e4e080e7          	jalr	-434(ra) # 58c4 <countfree>
    5a7e:	04954663          	blt	a0,s1,5aca <drivetests+0xb8>
        return 1;
      }
    }
  } while(continuous);
    5a82:	06098163          	beqz	s3,5ae4 <drivetests+0xd2>
    printf("usertests starting\n");
    5a86:	855a                	mv	a0,s6
    5a88:	00000097          	auipc	ra,0x0
    5a8c:	788080e7          	jalr	1928(ra) # 6210 <printf>
    int free0 = countfree();
    5a90:	00000097          	auipc	ra,0x0
    5a94:	e34080e7          	jalr	-460(ra) # 58c4 <countfree>
    5a98:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    5a9a:	85ca                	mv	a1,s2
    5a9c:	8556                	mv	a0,s5
    5a9e:	00000097          	auipc	ra,0x0
    5aa2:	dcc080e7          	jalr	-564(ra) # 586a <runtests>
      if(continuous != 2) {
    5aa6:	c119                	beqz	a0,5aac <drivetests+0x9a>
    5aa8:	020b9c63          	bnez	s7,5ae0 <drivetests+0xce>
    if(!quick) {
    5aac:	fc0a15e3          	bnez	s4,5a76 <drivetests+0x64>
      if (justone == 0)
    5ab0:	fa090de3          	beqz	s2,5a6a <drivetests+0x58>
      if (runtests(slowtests, justone)) {
    5ab4:	85ca                	mv	a1,s2
    5ab6:	8562                	mv	a0,s8
    5ab8:	00000097          	auipc	ra,0x0
    5abc:	db2080e7          	jalr	-590(ra) # 586a <runtests>
        if(continuous != 2) {
    5ac0:	d95d                	beqz	a0,5a76 <drivetests+0x64>
    5ac2:	fa0b8ae3          	beqz	s7,5a76 <drivetests+0x64>
          return 1;
    5ac6:	4505                	li	a0,1
    5ac8:	a839                	j	5ae6 <drivetests+0xd4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5aca:	8626                	mv	a2,s1
    5acc:	85aa                	mv	a1,a0
    5ace:	856a                	mv	a0,s10
    5ad0:	00000097          	auipc	ra,0x0
    5ad4:	740080e7          	jalr	1856(ra) # 6210 <printf>
      if(continuous != 2) {
    5ad8:	fb9987e3          	beq	s3,s9,5a86 <drivetests+0x74>
        return 1;
    5adc:	4505                	li	a0,1
    5ade:	a021                	j	5ae6 <drivetests+0xd4>
        return 1;
    5ae0:	4505                	li	a0,1
    5ae2:	a011                	j	5ae6 <drivetests+0xd4>
  return 0;
    5ae4:	854e                	mv	a0,s3
}
    5ae6:	70a6                	ld	ra,104(sp)
    5ae8:	7406                	ld	s0,96(sp)
    5aea:	64e6                	ld	s1,88(sp)
    5aec:	6946                	ld	s2,80(sp)
    5aee:	69a6                	ld	s3,72(sp)
    5af0:	6a06                	ld	s4,64(sp)
    5af2:	7ae2                	ld	s5,56(sp)
    5af4:	7b42                	ld	s6,48(sp)
    5af6:	7ba2                	ld	s7,40(sp)
    5af8:	7c02                	ld	s8,32(sp)
    5afa:	6ce2                	ld	s9,24(sp)
    5afc:	6d42                	ld	s10,16(sp)
    5afe:	6da2                	ld	s11,8(sp)
    5b00:	6165                	addi	sp,sp,112
    5b02:	8082                	ret

0000000000005b04 <main>:

int
main(int argc, char *argv[])
{
    5b04:	1101                	addi	sp,sp,-32
    5b06:	ec06                	sd	ra,24(sp)
    5b08:	e822                	sd	s0,16(sp)
    5b0a:	e426                	sd	s1,8(sp)
    5b0c:	e04a                	sd	s2,0(sp)
    5b0e:	1000                	addi	s0,sp,32
    5b10:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5b12:	4789                	li	a5,2
    5b14:	02f50263          	beq	a0,a5,5b38 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5b18:	4785                	li	a5,1
    5b1a:	08a7c063          	blt	a5,a0,5b9a <main+0x96>
  char *justone = 0;
    5b1e:	4601                	li	a2,0
  int quick = 0;
    5b20:	4501                	li	a0,0
  int continuous = 0;
    5b22:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5b24:	00000097          	auipc	ra,0x0
    5b28:	eee080e7          	jalr	-274(ra) # 5a12 <drivetests>
    5b2c:	c951                	beqz	a0,5bc0 <main+0xbc>
    exit(1);
    5b2e:	4505                	li	a0,1
    5b30:	00000097          	auipc	ra,0x0
    5b34:	352080e7          	jalr	850(ra) # 5e82 <exit>
    5b38:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5b3a:	00003597          	auipc	a1,0x3
    5b3e:	94e58593          	addi	a1,a1,-1714 # 8488 <malloc+0x21bc>
    5b42:	00893503          	ld	a0,8(s2) # 1008 <linktest+0xb4>
    5b46:	00000097          	auipc	ra,0x0
    5b4a:	0ce080e7          	jalr	206(ra) # 5c14 <strcmp>
    5b4e:	85aa                	mv	a1,a0
    5b50:	e501                	bnez	a0,5b58 <main+0x54>
  char *justone = 0;
    5b52:	4601                	li	a2,0
    quick = 1;
    5b54:	4505                	li	a0,1
    5b56:	b7f9                	j	5b24 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5b58:	00003597          	auipc	a1,0x3
    5b5c:	93858593          	addi	a1,a1,-1736 # 8490 <malloc+0x21c4>
    5b60:	00893503          	ld	a0,8(s2)
    5b64:	00000097          	auipc	ra,0x0
    5b68:	0b0080e7          	jalr	176(ra) # 5c14 <strcmp>
    5b6c:	c521                	beqz	a0,5bb4 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5b6e:	00003597          	auipc	a1,0x3
    5b72:	97258593          	addi	a1,a1,-1678 # 84e0 <malloc+0x2214>
    5b76:	00893503          	ld	a0,8(s2)
    5b7a:	00000097          	auipc	ra,0x0
    5b7e:	09a080e7          	jalr	154(ra) # 5c14 <strcmp>
    5b82:	cd05                	beqz	a0,5bba <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    5b84:	00893603          	ld	a2,8(s2)
    5b88:	00064703          	lbu	a4,0(a2) # 3000 <sbrklast+0x44>
    5b8c:	02d00793          	li	a5,45
    5b90:	00f70563          	beq	a4,a5,5b9a <main+0x96>
  int quick = 0;
    5b94:	4501                	li	a0,0
  int continuous = 0;
    5b96:	4581                	li	a1,0
    5b98:	b771                	j	5b24 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5b9a:	00003517          	auipc	a0,0x3
    5b9e:	8fe50513          	addi	a0,a0,-1794 # 8498 <malloc+0x21cc>
    5ba2:	00000097          	auipc	ra,0x0
    5ba6:	66e080e7          	jalr	1646(ra) # 6210 <printf>
    exit(1);
    5baa:	4505                	li	a0,1
    5bac:	00000097          	auipc	ra,0x0
    5bb0:	2d6080e7          	jalr	726(ra) # 5e82 <exit>
  char *justone = 0;
    5bb4:	4601                	li	a2,0
    continuous = 1;
    5bb6:	4585                	li	a1,1
    5bb8:	b7b5                	j	5b24 <main+0x20>
    continuous = 2;
    5bba:	85a6                	mv	a1,s1
  char *justone = 0;
    5bbc:	4601                	li	a2,0
    5bbe:	b79d                	j	5b24 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5bc0:	00003517          	auipc	a0,0x3
    5bc4:	90850513          	addi	a0,a0,-1784 # 84c8 <malloc+0x21fc>
    5bc8:	00000097          	auipc	ra,0x0
    5bcc:	648080e7          	jalr	1608(ra) # 6210 <printf>
  exit(0);
    5bd0:	4501                	li	a0,0
    5bd2:	00000097          	auipc	ra,0x0
    5bd6:	2b0080e7          	jalr	688(ra) # 5e82 <exit>

0000000000005bda <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5bda:	1141                	addi	sp,sp,-16
    5bdc:	e406                	sd	ra,8(sp)
    5bde:	e022                	sd	s0,0(sp)
    5be0:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5be2:	00000097          	auipc	ra,0x0
    5be6:	f22080e7          	jalr	-222(ra) # 5b04 <main>
  exit(0);
    5bea:	4501                	li	a0,0
    5bec:	00000097          	auipc	ra,0x0
    5bf0:	296080e7          	jalr	662(ra) # 5e82 <exit>

0000000000005bf4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5bf4:	1141                	addi	sp,sp,-16
    5bf6:	e406                	sd	ra,8(sp)
    5bf8:	e022                	sd	s0,0(sp)
    5bfa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5bfc:	87aa                	mv	a5,a0
    5bfe:	0585                	addi	a1,a1,1
    5c00:	0785                	addi	a5,a5,1
    5c02:	fff5c703          	lbu	a4,-1(a1)
    5c06:	fee78fa3          	sb	a4,-1(a5)
    5c0a:	fb75                	bnez	a4,5bfe <strcpy+0xa>
    ;
  return os;
}
    5c0c:	60a2                	ld	ra,8(sp)
    5c0e:	6402                	ld	s0,0(sp)
    5c10:	0141                	addi	sp,sp,16
    5c12:	8082                	ret

0000000000005c14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5c14:	1141                	addi	sp,sp,-16
    5c16:	e406                	sd	ra,8(sp)
    5c18:	e022                	sd	s0,0(sp)
    5c1a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5c1c:	00054783          	lbu	a5,0(a0)
    5c20:	cb91                	beqz	a5,5c34 <strcmp+0x20>
    5c22:	0005c703          	lbu	a4,0(a1)
    5c26:	00f71763          	bne	a4,a5,5c34 <strcmp+0x20>
    p++, q++;
    5c2a:	0505                	addi	a0,a0,1
    5c2c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5c2e:	00054783          	lbu	a5,0(a0)
    5c32:	fbe5                	bnez	a5,5c22 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    5c34:	0005c503          	lbu	a0,0(a1)
}
    5c38:	40a7853b          	subw	a0,a5,a0
    5c3c:	60a2                	ld	ra,8(sp)
    5c3e:	6402                	ld	s0,0(sp)
    5c40:	0141                	addi	sp,sp,16
    5c42:	8082                	ret

0000000000005c44 <strlen>:

uint
strlen(const char *s)
{
    5c44:	1141                	addi	sp,sp,-16
    5c46:	e406                	sd	ra,8(sp)
    5c48:	e022                	sd	s0,0(sp)
    5c4a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5c4c:	00054783          	lbu	a5,0(a0)
    5c50:	cf91                	beqz	a5,5c6c <strlen+0x28>
    5c52:	00150793          	addi	a5,a0,1
    5c56:	86be                	mv	a3,a5
    5c58:	0785                	addi	a5,a5,1
    5c5a:	fff7c703          	lbu	a4,-1(a5)
    5c5e:	ff65                	bnez	a4,5c56 <strlen+0x12>
    5c60:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    5c64:	60a2                	ld	ra,8(sp)
    5c66:	6402                	ld	s0,0(sp)
    5c68:	0141                	addi	sp,sp,16
    5c6a:	8082                	ret
  for(n = 0; s[n]; n++)
    5c6c:	4501                	li	a0,0
    5c6e:	bfdd                	j	5c64 <strlen+0x20>

0000000000005c70 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5c70:	1141                	addi	sp,sp,-16
    5c72:	e406                	sd	ra,8(sp)
    5c74:	e022                	sd	s0,0(sp)
    5c76:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5c78:	ca19                	beqz	a2,5c8e <memset+0x1e>
    5c7a:	87aa                	mv	a5,a0
    5c7c:	1602                	slli	a2,a2,0x20
    5c7e:	9201                	srli	a2,a2,0x20
    5c80:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5c84:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5c88:	0785                	addi	a5,a5,1
    5c8a:	fee79de3          	bne	a5,a4,5c84 <memset+0x14>
  }
  return dst;
}
    5c8e:	60a2                	ld	ra,8(sp)
    5c90:	6402                	ld	s0,0(sp)
    5c92:	0141                	addi	sp,sp,16
    5c94:	8082                	ret

0000000000005c96 <strchr>:

char*
strchr(const char *s, char c)
{
    5c96:	1141                	addi	sp,sp,-16
    5c98:	e406                	sd	ra,8(sp)
    5c9a:	e022                	sd	s0,0(sp)
    5c9c:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5c9e:	00054783          	lbu	a5,0(a0)
    5ca2:	cf81                	beqz	a5,5cba <strchr+0x24>
    if(*s == c)
    5ca4:	00f58763          	beq	a1,a5,5cb2 <strchr+0x1c>
  for(; *s; s++)
    5ca8:	0505                	addi	a0,a0,1
    5caa:	00054783          	lbu	a5,0(a0)
    5cae:	fbfd                	bnez	a5,5ca4 <strchr+0xe>
      return (char*)s;
  return 0;
    5cb0:	4501                	li	a0,0
}
    5cb2:	60a2                	ld	ra,8(sp)
    5cb4:	6402                	ld	s0,0(sp)
    5cb6:	0141                	addi	sp,sp,16
    5cb8:	8082                	ret
  return 0;
    5cba:	4501                	li	a0,0
    5cbc:	bfdd                	j	5cb2 <strchr+0x1c>

0000000000005cbe <gets>:

char*
gets(char *buf, int max)
{
    5cbe:	711d                	addi	sp,sp,-96
    5cc0:	ec86                	sd	ra,88(sp)
    5cc2:	e8a2                	sd	s0,80(sp)
    5cc4:	e4a6                	sd	s1,72(sp)
    5cc6:	e0ca                	sd	s2,64(sp)
    5cc8:	fc4e                	sd	s3,56(sp)
    5cca:	f852                	sd	s4,48(sp)
    5ccc:	f456                	sd	s5,40(sp)
    5cce:	f05a                	sd	s6,32(sp)
    5cd0:	ec5e                	sd	s7,24(sp)
    5cd2:	e862                	sd	s8,16(sp)
    5cd4:	1080                	addi	s0,sp,96
    5cd6:	8baa                	mv	s7,a0
    5cd8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5cda:	892a                	mv	s2,a0
    5cdc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    5cde:	faf40b13          	addi	s6,s0,-81
    5ce2:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
    5ce4:	8c26                	mv	s8,s1
    5ce6:	0014899b          	addiw	s3,s1,1
    5cea:	84ce                	mv	s1,s3
    5cec:	0349d663          	bge	s3,s4,5d18 <gets+0x5a>
    cc = read(0, &c, 1);
    5cf0:	8656                	mv	a2,s5
    5cf2:	85da                	mv	a1,s6
    5cf4:	4501                	li	a0,0
    5cf6:	00000097          	auipc	ra,0x0
    5cfa:	1a4080e7          	jalr	420(ra) # 5e9a <read>
    if(cc < 1)
    5cfe:	00a05d63          	blez	a0,5d18 <gets+0x5a>
      break;
    buf[i++] = c;
    5d02:	faf44783          	lbu	a5,-81(s0)
    5d06:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5d0a:	0905                	addi	s2,s2,1
    5d0c:	ff678713          	addi	a4,a5,-10
    5d10:	c319                	beqz	a4,5d16 <gets+0x58>
    5d12:	17cd                	addi	a5,a5,-13
    5d14:	fbe1                	bnez	a5,5ce4 <gets+0x26>
    buf[i++] = c;
    5d16:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    5d18:	9c5e                	add	s8,s8,s7
    5d1a:	000c0023          	sb	zero,0(s8)
  return buf;
}
    5d1e:	855e                	mv	a0,s7
    5d20:	60e6                	ld	ra,88(sp)
    5d22:	6446                	ld	s0,80(sp)
    5d24:	64a6                	ld	s1,72(sp)
    5d26:	6906                	ld	s2,64(sp)
    5d28:	79e2                	ld	s3,56(sp)
    5d2a:	7a42                	ld	s4,48(sp)
    5d2c:	7aa2                	ld	s5,40(sp)
    5d2e:	7b02                	ld	s6,32(sp)
    5d30:	6be2                	ld	s7,24(sp)
    5d32:	6c42                	ld	s8,16(sp)
    5d34:	6125                	addi	sp,sp,96
    5d36:	8082                	ret

0000000000005d38 <stat>:

int
stat(const char *n, struct stat *st)
{
    5d38:	1101                	addi	sp,sp,-32
    5d3a:	ec06                	sd	ra,24(sp)
    5d3c:	e822                	sd	s0,16(sp)
    5d3e:	e04a                	sd	s2,0(sp)
    5d40:	1000                	addi	s0,sp,32
    5d42:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5d44:	4581                	li	a1,0
    5d46:	00000097          	auipc	ra,0x0
    5d4a:	17c080e7          	jalr	380(ra) # 5ec2 <open>
  if(fd < 0)
    5d4e:	02054663          	bltz	a0,5d7a <stat+0x42>
    5d52:	e426                	sd	s1,8(sp)
    5d54:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5d56:	85ca                	mv	a1,s2
    5d58:	00000097          	auipc	ra,0x0
    5d5c:	182080e7          	jalr	386(ra) # 5eda <fstat>
    5d60:	892a                	mv	s2,a0
  close(fd);
    5d62:	8526                	mv	a0,s1
    5d64:	00000097          	auipc	ra,0x0
    5d68:	146080e7          	jalr	326(ra) # 5eaa <close>
  return r;
    5d6c:	64a2                	ld	s1,8(sp)
}
    5d6e:	854a                	mv	a0,s2
    5d70:	60e2                	ld	ra,24(sp)
    5d72:	6442                	ld	s0,16(sp)
    5d74:	6902                	ld	s2,0(sp)
    5d76:	6105                	addi	sp,sp,32
    5d78:	8082                	ret
    return -1;
    5d7a:	57fd                	li	a5,-1
    5d7c:	893e                	mv	s2,a5
    5d7e:	bfc5                	j	5d6e <stat+0x36>

0000000000005d80 <atoi>:

int
atoi(const char *s)
{
    5d80:	1141                	addi	sp,sp,-16
    5d82:	e406                	sd	ra,8(sp)
    5d84:	e022                	sd	s0,0(sp)
    5d86:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5d88:	00054683          	lbu	a3,0(a0)
    5d8c:	fd06879b          	addiw	a5,a3,-48
    5d90:	0ff7f793          	zext.b	a5,a5
    5d94:	4625                	li	a2,9
    5d96:	02f66963          	bltu	a2,a5,5dc8 <atoi+0x48>
    5d9a:	872a                	mv	a4,a0
  n = 0;
    5d9c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5d9e:	0705                	addi	a4,a4,1
    5da0:	0025179b          	slliw	a5,a0,0x2
    5da4:	9fa9                	addw	a5,a5,a0
    5da6:	0017979b          	slliw	a5,a5,0x1
    5daa:	9fb5                	addw	a5,a5,a3
    5dac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5db0:	00074683          	lbu	a3,0(a4)
    5db4:	fd06879b          	addiw	a5,a3,-48
    5db8:	0ff7f793          	zext.b	a5,a5
    5dbc:	fef671e3          	bgeu	a2,a5,5d9e <atoi+0x1e>
  return n;
}
    5dc0:	60a2                	ld	ra,8(sp)
    5dc2:	6402                	ld	s0,0(sp)
    5dc4:	0141                	addi	sp,sp,16
    5dc6:	8082                	ret
  n = 0;
    5dc8:	4501                	li	a0,0
    5dca:	bfdd                	j	5dc0 <atoi+0x40>

0000000000005dcc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5dcc:	1141                	addi	sp,sp,-16
    5dce:	e406                	sd	ra,8(sp)
    5dd0:	e022                	sd	s0,0(sp)
    5dd2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5dd4:	02b57563          	bgeu	a0,a1,5dfe <memmove+0x32>
    while(n-- > 0)
    5dd8:	00c05f63          	blez	a2,5df6 <memmove+0x2a>
    5ddc:	1602                	slli	a2,a2,0x20
    5dde:	9201                	srli	a2,a2,0x20
    5de0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5de4:	872a                	mv	a4,a0
      *dst++ = *src++;
    5de6:	0585                	addi	a1,a1,1
    5de8:	0705                	addi	a4,a4,1
    5dea:	fff5c683          	lbu	a3,-1(a1)
    5dee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5df2:	fee79ae3          	bne	a5,a4,5de6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5df6:	60a2                	ld	ra,8(sp)
    5df8:	6402                	ld	s0,0(sp)
    5dfa:	0141                	addi	sp,sp,16
    5dfc:	8082                	ret
    while(n-- > 0)
    5dfe:	fec05ce3          	blez	a2,5df6 <memmove+0x2a>
    dst += n;
    5e02:	00c50733          	add	a4,a0,a2
    src += n;
    5e06:	95b2                	add	a1,a1,a2
    5e08:	fff6079b          	addiw	a5,a2,-1
    5e0c:	1782                	slli	a5,a5,0x20
    5e0e:	9381                	srli	a5,a5,0x20
    5e10:	fff7c793          	not	a5,a5
    5e14:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5e16:	15fd                	addi	a1,a1,-1
    5e18:	177d                	addi	a4,a4,-1
    5e1a:	0005c683          	lbu	a3,0(a1)
    5e1e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5e22:	fef71ae3          	bne	a4,a5,5e16 <memmove+0x4a>
    5e26:	bfc1                	j	5df6 <memmove+0x2a>

0000000000005e28 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5e28:	1141                	addi	sp,sp,-16
    5e2a:	e406                	sd	ra,8(sp)
    5e2c:	e022                	sd	s0,0(sp)
    5e2e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5e30:	c61d                	beqz	a2,5e5e <memcmp+0x36>
    5e32:	1602                	slli	a2,a2,0x20
    5e34:	9201                	srli	a2,a2,0x20
    5e36:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    5e3a:	00054783          	lbu	a5,0(a0)
    5e3e:	0005c703          	lbu	a4,0(a1)
    5e42:	00e79863          	bne	a5,a4,5e52 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    5e46:	0505                	addi	a0,a0,1
    p2++;
    5e48:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5e4a:	fed518e3          	bne	a0,a3,5e3a <memcmp+0x12>
  }
  return 0;
    5e4e:	4501                	li	a0,0
    5e50:	a019                	j	5e56 <memcmp+0x2e>
      return *p1 - *p2;
    5e52:	40e7853b          	subw	a0,a5,a4
}
    5e56:	60a2                	ld	ra,8(sp)
    5e58:	6402                	ld	s0,0(sp)
    5e5a:	0141                	addi	sp,sp,16
    5e5c:	8082                	ret
  return 0;
    5e5e:	4501                	li	a0,0
    5e60:	bfdd                	j	5e56 <memcmp+0x2e>

0000000000005e62 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5e62:	1141                	addi	sp,sp,-16
    5e64:	e406                	sd	ra,8(sp)
    5e66:	e022                	sd	s0,0(sp)
    5e68:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5e6a:	00000097          	auipc	ra,0x0
    5e6e:	f62080e7          	jalr	-158(ra) # 5dcc <memmove>
}
    5e72:	60a2                	ld	ra,8(sp)
    5e74:	6402                	ld	s0,0(sp)
    5e76:	0141                	addi	sp,sp,16
    5e78:	8082                	ret

0000000000005e7a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5e7a:	4885                	li	a7,1
 ecall
    5e7c:	00000073          	ecall
 ret
    5e80:	8082                	ret

0000000000005e82 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5e82:	4889                	li	a7,2
 ecall
    5e84:	00000073          	ecall
 ret
    5e88:	8082                	ret

0000000000005e8a <wait>:
.global wait
wait:
 li a7, SYS_wait
    5e8a:	488d                	li	a7,3
 ecall
    5e8c:	00000073          	ecall
 ret
    5e90:	8082                	ret

0000000000005e92 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5e92:	4891                	li	a7,4
 ecall
    5e94:	00000073          	ecall
 ret
    5e98:	8082                	ret

0000000000005e9a <read>:
.global read
read:
 li a7, SYS_read
    5e9a:	4895                	li	a7,5
 ecall
    5e9c:	00000073          	ecall
 ret
    5ea0:	8082                	ret

0000000000005ea2 <write>:
.global write
write:
 li a7, SYS_write
    5ea2:	48c1                	li	a7,16
 ecall
    5ea4:	00000073          	ecall
 ret
    5ea8:	8082                	ret

0000000000005eaa <close>:
.global close
close:
 li a7, SYS_close
    5eaa:	48d5                	li	a7,21
 ecall
    5eac:	00000073          	ecall
 ret
    5eb0:	8082                	ret

0000000000005eb2 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5eb2:	4899                	li	a7,6
 ecall
    5eb4:	00000073          	ecall
 ret
    5eb8:	8082                	ret

0000000000005eba <exec>:
.global exec
exec:
 li a7, SYS_exec
    5eba:	489d                	li	a7,7
 ecall
    5ebc:	00000073          	ecall
 ret
    5ec0:	8082                	ret

0000000000005ec2 <open>:
.global open
open:
 li a7, SYS_open
    5ec2:	48bd                	li	a7,15
 ecall
    5ec4:	00000073          	ecall
 ret
    5ec8:	8082                	ret

0000000000005eca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5eca:	48c5                	li	a7,17
 ecall
    5ecc:	00000073          	ecall
 ret
    5ed0:	8082                	ret

0000000000005ed2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5ed2:	48c9                	li	a7,18
 ecall
    5ed4:	00000073          	ecall
 ret
    5ed8:	8082                	ret

0000000000005eda <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5eda:	48a1                	li	a7,8
 ecall
    5edc:	00000073          	ecall
 ret
    5ee0:	8082                	ret

0000000000005ee2 <link>:
.global link
link:
 li a7, SYS_link
    5ee2:	48cd                	li	a7,19
 ecall
    5ee4:	00000073          	ecall
 ret
    5ee8:	8082                	ret

0000000000005eea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5eea:	48d1                	li	a7,20
 ecall
    5eec:	00000073          	ecall
 ret
    5ef0:	8082                	ret

0000000000005ef2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5ef2:	48a5                	li	a7,9
 ecall
    5ef4:	00000073          	ecall
 ret
    5ef8:	8082                	ret

0000000000005efa <dup>:
.global dup
dup:
 li a7, SYS_dup
    5efa:	48a9                	li	a7,10
 ecall
    5efc:	00000073          	ecall
 ret
    5f00:	8082                	ret

0000000000005f02 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5f02:	48ad                	li	a7,11
 ecall
    5f04:	00000073          	ecall
 ret
    5f08:	8082                	ret

0000000000005f0a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5f0a:	48b1                	li	a7,12
 ecall
    5f0c:	00000073          	ecall
 ret
    5f10:	8082                	ret

0000000000005f12 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5f12:	48b5                	li	a7,13
 ecall
    5f14:	00000073          	ecall
 ret
    5f18:	8082                	ret

0000000000005f1a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5f1a:	48b9                	li	a7,14
 ecall
    5f1c:	00000073          	ecall
 ret
    5f20:	8082                	ret

0000000000005f22 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5f22:	48d9                	li	a7,22
 ecall
    5f24:	00000073          	ecall
 ret
    5f28:	8082                	ret

0000000000005f2a <settickets>:
.global settickets
settickets:
 li a7, SYS_settickets
    5f2a:	48dd                	li	a7,23
 ecall
    5f2c:	00000073          	ecall
 ret
    5f30:	8082                	ret

0000000000005f32 <printlog>:
.global printlog
printlog:
 li a7, SYS_printlog
    5f32:	48e1                	li	a7,24
 ecall
    5f34:	00000073          	ecall
 ret
    5f38:	8082                	ret

0000000000005f3a <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
    5f3a:	48e5                	li	a7,25
 ecall
    5f3c:	00000073          	ecall
 ret
    5f40:	8082                	ret

0000000000005f42 <setcfslog>:
.global setcfslog
setcfslog:
 li a7, SYS_setcfslog
    5f42:	48e9                	li	a7,26
 ecall
    5f44:	00000073          	ecall
 ret
    5f48:	8082                	ret

0000000000005f4a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5f4a:	1101                	addi	sp,sp,-32
    5f4c:	ec06                	sd	ra,24(sp)
    5f4e:	e822                	sd	s0,16(sp)
    5f50:	1000                	addi	s0,sp,32
    5f52:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5f56:	4605                	li	a2,1
    5f58:	fef40593          	addi	a1,s0,-17
    5f5c:	00000097          	auipc	ra,0x0
    5f60:	f46080e7          	jalr	-186(ra) # 5ea2 <write>
}
    5f64:	60e2                	ld	ra,24(sp)
    5f66:	6442                	ld	s0,16(sp)
    5f68:	6105                	addi	sp,sp,32
    5f6a:	8082                	ret

0000000000005f6c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5f6c:	7139                	addi	sp,sp,-64
    5f6e:	fc06                	sd	ra,56(sp)
    5f70:	f822                	sd	s0,48(sp)
    5f72:	f04a                	sd	s2,32(sp)
    5f74:	ec4e                	sd	s3,24(sp)
    5f76:	0080                	addi	s0,sp,64
    5f78:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5f7a:	cad9                	beqz	a3,6010 <printint+0xa4>
    5f7c:	01f5d79b          	srliw	a5,a1,0x1f
    5f80:	cbc1                	beqz	a5,6010 <printint+0xa4>
    neg = 1;
    x = -xx;
    5f82:	40b005bb          	negw	a1,a1
    neg = 1;
    5f86:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    5f88:	fc040993          	addi	s3,s0,-64
  neg = 0;
    5f8c:	86ce                	mv	a3,s3
  i = 0;
    5f8e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5f90:	00003817          	auipc	a6,0x3
    5f94:	91880813          	addi	a6,a6,-1768 # 88a8 <digits>
    5f98:	88ba                	mv	a7,a4
    5f9a:	0017051b          	addiw	a0,a4,1
    5f9e:	872a                	mv	a4,a0
    5fa0:	02c5f7bb          	remuw	a5,a1,a2
    5fa4:	1782                	slli	a5,a5,0x20
    5fa6:	9381                	srli	a5,a5,0x20
    5fa8:	97c2                	add	a5,a5,a6
    5faa:	0007c783          	lbu	a5,0(a5)
    5fae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5fb2:	87ae                	mv	a5,a1
    5fb4:	02c5d5bb          	divuw	a1,a1,a2
    5fb8:	0685                	addi	a3,a3,1
    5fba:	fcc7ffe3          	bgeu	a5,a2,5f98 <printint+0x2c>
  if(neg)
    5fbe:	00030c63          	beqz	t1,5fd6 <printint+0x6a>
    buf[i++] = '-';
    5fc2:	fd050793          	addi	a5,a0,-48
    5fc6:	00878533          	add	a0,a5,s0
    5fca:	02d00793          	li	a5,45
    5fce:	fef50823          	sb	a5,-16(a0)
    5fd2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    5fd6:	02e05763          	blez	a4,6004 <printint+0x98>
    5fda:	f426                	sd	s1,40(sp)
    5fdc:	377d                	addiw	a4,a4,-1
    5fde:	00e984b3          	add	s1,s3,a4
    5fe2:	19fd                	addi	s3,s3,-1
    5fe4:	99ba                	add	s3,s3,a4
    5fe6:	1702                	slli	a4,a4,0x20
    5fe8:	9301                	srli	a4,a4,0x20
    5fea:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5fee:	0004c583          	lbu	a1,0(s1)
    5ff2:	854a                	mv	a0,s2
    5ff4:	00000097          	auipc	ra,0x0
    5ff8:	f56080e7          	jalr	-170(ra) # 5f4a <putc>
  while(--i >= 0)
    5ffc:	14fd                	addi	s1,s1,-1
    5ffe:	ff3498e3          	bne	s1,s3,5fee <printint+0x82>
    6002:	74a2                	ld	s1,40(sp)
}
    6004:	70e2                	ld	ra,56(sp)
    6006:	7442                	ld	s0,48(sp)
    6008:	7902                	ld	s2,32(sp)
    600a:	69e2                	ld	s3,24(sp)
    600c:	6121                	addi	sp,sp,64
    600e:	8082                	ret
  neg = 0;
    6010:	4301                	li	t1,0
    6012:	bf9d                	j	5f88 <printint+0x1c>

0000000000006014 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    6014:	715d                	addi	sp,sp,-80
    6016:	e486                	sd	ra,72(sp)
    6018:	e0a2                	sd	s0,64(sp)
    601a:	f84a                	sd	s2,48(sp)
    601c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    601e:	0005c903          	lbu	s2,0(a1)
    6022:	1a090b63          	beqz	s2,61d8 <vprintf+0x1c4>
    6026:	fc26                	sd	s1,56(sp)
    6028:	f44e                	sd	s3,40(sp)
    602a:	f052                	sd	s4,32(sp)
    602c:	ec56                	sd	s5,24(sp)
    602e:	e85a                	sd	s6,16(sp)
    6030:	e45e                	sd	s7,8(sp)
    6032:	8aaa                	mv	s5,a0
    6034:	8bb2                	mv	s7,a2
    6036:	00158493          	addi	s1,a1,1
  state = 0;
    603a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    603c:	02500a13          	li	s4,37
    6040:	4b55                	li	s6,21
    6042:	a839                	j	6060 <vprintf+0x4c>
        putc(fd, c);
    6044:	85ca                	mv	a1,s2
    6046:	8556                	mv	a0,s5
    6048:	00000097          	auipc	ra,0x0
    604c:	f02080e7          	jalr	-254(ra) # 5f4a <putc>
    6050:	a019                	j	6056 <vprintf+0x42>
    } else if(state == '%'){
    6052:	01498d63          	beq	s3,s4,606c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    6056:	0485                	addi	s1,s1,1
    6058:	fff4c903          	lbu	s2,-1(s1)
    605c:	16090863          	beqz	s2,61cc <vprintf+0x1b8>
    if(state == 0){
    6060:	fe0999e3          	bnez	s3,6052 <vprintf+0x3e>
      if(c == '%'){
    6064:	ff4910e3          	bne	s2,s4,6044 <vprintf+0x30>
        state = '%';
    6068:	89d2                	mv	s3,s4
    606a:	b7f5                	j	6056 <vprintf+0x42>
      if(c == 'd'){
    606c:	13490563          	beq	s2,s4,6196 <vprintf+0x182>
    6070:	f9d9079b          	addiw	a5,s2,-99
    6074:	0ff7f793          	zext.b	a5,a5
    6078:	12fb6863          	bltu	s6,a5,61a8 <vprintf+0x194>
    607c:	f9d9079b          	addiw	a5,s2,-99
    6080:	0ff7f713          	zext.b	a4,a5
    6084:	12eb6263          	bltu	s6,a4,61a8 <vprintf+0x194>
    6088:	00271793          	slli	a5,a4,0x2
    608c:	00002717          	auipc	a4,0x2
    6090:	7c470713          	addi	a4,a4,1988 # 8850 <malloc+0x2584>
    6094:	97ba                	add	a5,a5,a4
    6096:	439c                	lw	a5,0(a5)
    6098:	97ba                	add	a5,a5,a4
    609a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    609c:	008b8913          	addi	s2,s7,8
    60a0:	4685                	li	a3,1
    60a2:	4629                	li	a2,10
    60a4:	000ba583          	lw	a1,0(s7)
    60a8:	8556                	mv	a0,s5
    60aa:	00000097          	auipc	ra,0x0
    60ae:	ec2080e7          	jalr	-318(ra) # 5f6c <printint>
    60b2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    60b4:	4981                	li	s3,0
    60b6:	b745                	j	6056 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    60b8:	008b8913          	addi	s2,s7,8
    60bc:	4681                	li	a3,0
    60be:	4629                	li	a2,10
    60c0:	000ba583          	lw	a1,0(s7)
    60c4:	8556                	mv	a0,s5
    60c6:	00000097          	auipc	ra,0x0
    60ca:	ea6080e7          	jalr	-346(ra) # 5f6c <printint>
    60ce:	8bca                	mv	s7,s2
      state = 0;
    60d0:	4981                	li	s3,0
    60d2:	b751                	j	6056 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    60d4:	008b8913          	addi	s2,s7,8
    60d8:	4681                	li	a3,0
    60da:	4641                	li	a2,16
    60dc:	000ba583          	lw	a1,0(s7)
    60e0:	8556                	mv	a0,s5
    60e2:	00000097          	auipc	ra,0x0
    60e6:	e8a080e7          	jalr	-374(ra) # 5f6c <printint>
    60ea:	8bca                	mv	s7,s2
      state = 0;
    60ec:	4981                	li	s3,0
    60ee:	b7a5                	j	6056 <vprintf+0x42>
    60f0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    60f2:	008b8793          	addi	a5,s7,8
    60f6:	8c3e                	mv	s8,a5
    60f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    60fc:	03000593          	li	a1,48
    6100:	8556                	mv	a0,s5
    6102:	00000097          	auipc	ra,0x0
    6106:	e48080e7          	jalr	-440(ra) # 5f4a <putc>
  putc(fd, 'x');
    610a:	07800593          	li	a1,120
    610e:	8556                	mv	a0,s5
    6110:	00000097          	auipc	ra,0x0
    6114:	e3a080e7          	jalr	-454(ra) # 5f4a <putc>
    6118:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    611a:	00002b97          	auipc	s7,0x2
    611e:	78eb8b93          	addi	s7,s7,1934 # 88a8 <digits>
    6122:	03c9d793          	srli	a5,s3,0x3c
    6126:	97de                	add	a5,a5,s7
    6128:	0007c583          	lbu	a1,0(a5)
    612c:	8556                	mv	a0,s5
    612e:	00000097          	auipc	ra,0x0
    6132:	e1c080e7          	jalr	-484(ra) # 5f4a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    6136:	0992                	slli	s3,s3,0x4
    6138:	397d                	addiw	s2,s2,-1
    613a:	fe0914e3          	bnez	s2,6122 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
    613e:	8be2                	mv	s7,s8
      state = 0;
    6140:	4981                	li	s3,0
    6142:	6c02                	ld	s8,0(sp)
    6144:	bf09                	j	6056 <vprintf+0x42>
        s = va_arg(ap, char*);
    6146:	008b8993          	addi	s3,s7,8
    614a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    614e:	02090163          	beqz	s2,6170 <vprintf+0x15c>
        while(*s != 0){
    6152:	00094583          	lbu	a1,0(s2)
    6156:	c9a5                	beqz	a1,61c6 <vprintf+0x1b2>
          putc(fd, *s);
    6158:	8556                	mv	a0,s5
    615a:	00000097          	auipc	ra,0x0
    615e:	df0080e7          	jalr	-528(ra) # 5f4a <putc>
          s++;
    6162:	0905                	addi	s2,s2,1
        while(*s != 0){
    6164:	00094583          	lbu	a1,0(s2)
    6168:	f9e5                	bnez	a1,6158 <vprintf+0x144>
        s = va_arg(ap, char*);
    616a:	8bce                	mv	s7,s3
      state = 0;
    616c:	4981                	li	s3,0
    616e:	b5e5                	j	6056 <vprintf+0x42>
          s = "(null)";
    6170:	00002917          	auipc	s2,0x2
    6174:	6b890913          	addi	s2,s2,1720 # 8828 <malloc+0x255c>
        while(*s != 0){
    6178:	02800593          	li	a1,40
    617c:	bff1                	j	6158 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    617e:	008b8913          	addi	s2,s7,8
    6182:	000bc583          	lbu	a1,0(s7)
    6186:	8556                	mv	a0,s5
    6188:	00000097          	auipc	ra,0x0
    618c:	dc2080e7          	jalr	-574(ra) # 5f4a <putc>
    6190:	8bca                	mv	s7,s2
      state = 0;
    6192:	4981                	li	s3,0
    6194:	b5c9                	j	6056 <vprintf+0x42>
        putc(fd, c);
    6196:	02500593          	li	a1,37
    619a:	8556                	mv	a0,s5
    619c:	00000097          	auipc	ra,0x0
    61a0:	dae080e7          	jalr	-594(ra) # 5f4a <putc>
      state = 0;
    61a4:	4981                	li	s3,0
    61a6:	bd45                	j	6056 <vprintf+0x42>
        putc(fd, '%');
    61a8:	02500593          	li	a1,37
    61ac:	8556                	mv	a0,s5
    61ae:	00000097          	auipc	ra,0x0
    61b2:	d9c080e7          	jalr	-612(ra) # 5f4a <putc>
        putc(fd, c);
    61b6:	85ca                	mv	a1,s2
    61b8:	8556                	mv	a0,s5
    61ba:	00000097          	auipc	ra,0x0
    61be:	d90080e7          	jalr	-624(ra) # 5f4a <putc>
      state = 0;
    61c2:	4981                	li	s3,0
    61c4:	bd49                	j	6056 <vprintf+0x42>
        s = va_arg(ap, char*);
    61c6:	8bce                	mv	s7,s3
      state = 0;
    61c8:	4981                	li	s3,0
    61ca:	b571                	j	6056 <vprintf+0x42>
    61cc:	74e2                	ld	s1,56(sp)
    61ce:	79a2                	ld	s3,40(sp)
    61d0:	7a02                	ld	s4,32(sp)
    61d2:	6ae2                	ld	s5,24(sp)
    61d4:	6b42                	ld	s6,16(sp)
    61d6:	6ba2                	ld	s7,8(sp)
    }
  }
}
    61d8:	60a6                	ld	ra,72(sp)
    61da:	6406                	ld	s0,64(sp)
    61dc:	7942                	ld	s2,48(sp)
    61de:	6161                	addi	sp,sp,80
    61e0:	8082                	ret

00000000000061e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    61e2:	715d                	addi	sp,sp,-80
    61e4:	ec06                	sd	ra,24(sp)
    61e6:	e822                	sd	s0,16(sp)
    61e8:	1000                	addi	s0,sp,32
    61ea:	e010                	sd	a2,0(s0)
    61ec:	e414                	sd	a3,8(s0)
    61ee:	e818                	sd	a4,16(s0)
    61f0:	ec1c                	sd	a5,24(s0)
    61f2:	03043023          	sd	a6,32(s0)
    61f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    61fa:	8622                	mv	a2,s0
    61fc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    6200:	00000097          	auipc	ra,0x0
    6204:	e14080e7          	jalr	-492(ra) # 6014 <vprintf>
}
    6208:	60e2                	ld	ra,24(sp)
    620a:	6442                	ld	s0,16(sp)
    620c:	6161                	addi	sp,sp,80
    620e:	8082                	ret

0000000000006210 <printf>:

void
printf(const char *fmt, ...)
{
    6210:	711d                	addi	sp,sp,-96
    6212:	ec06                	sd	ra,24(sp)
    6214:	e822                	sd	s0,16(sp)
    6216:	1000                	addi	s0,sp,32
    6218:	e40c                	sd	a1,8(s0)
    621a:	e810                	sd	a2,16(s0)
    621c:	ec14                	sd	a3,24(s0)
    621e:	f018                	sd	a4,32(s0)
    6220:	f41c                	sd	a5,40(s0)
    6222:	03043823          	sd	a6,48(s0)
    6226:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    622a:	00840613          	addi	a2,s0,8
    622e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    6232:	85aa                	mv	a1,a0
    6234:	4505                	li	a0,1
    6236:	00000097          	auipc	ra,0x0
    623a:	dde080e7          	jalr	-546(ra) # 6014 <vprintf>
}
    623e:	60e2                	ld	ra,24(sp)
    6240:	6442                	ld	s0,16(sp)
    6242:	6125                	addi	sp,sp,96
    6244:	8082                	ret

0000000000006246 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    6246:	1141                	addi	sp,sp,-16
    6248:	e406                	sd	ra,8(sp)
    624a:	e022                	sd	s0,0(sp)
    624c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    624e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6252:	00003797          	auipc	a5,0x3
    6256:	1fe7b783          	ld	a5,510(a5) # 9450 <freep>
    625a:	a039                	j	6268 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    625c:	6398                	ld	a4,0(a5)
    625e:	00e7e463          	bltu	a5,a4,6266 <free+0x20>
    6262:	00e6ea63          	bltu	a3,a4,6276 <free+0x30>
{
    6266:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6268:	fed7fae3          	bgeu	a5,a3,625c <free+0x16>
    626c:	6398                	ld	a4,0(a5)
    626e:	00e6e463          	bltu	a3,a4,6276 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6272:	fee7eae3          	bltu	a5,a4,6266 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    6276:	ff852583          	lw	a1,-8(a0)
    627a:	6390                	ld	a2,0(a5)
    627c:	02059813          	slli	a6,a1,0x20
    6280:	01c85713          	srli	a4,a6,0x1c
    6284:	9736                	add	a4,a4,a3
    6286:	02e60563          	beq	a2,a4,62b0 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    628a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    628e:	4790                	lw	a2,8(a5)
    6290:	02061593          	slli	a1,a2,0x20
    6294:	01c5d713          	srli	a4,a1,0x1c
    6298:	973e                	add	a4,a4,a5
    629a:	02e68263          	beq	a3,a4,62be <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    629e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    62a0:	00003717          	auipc	a4,0x3
    62a4:	1af73823          	sd	a5,432(a4) # 9450 <freep>
}
    62a8:	60a2                	ld	ra,8(sp)
    62aa:	6402                	ld	s0,0(sp)
    62ac:	0141                	addi	sp,sp,16
    62ae:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    62b0:	4618                	lw	a4,8(a2)
    62b2:	9f2d                	addw	a4,a4,a1
    62b4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    62b8:	6398                	ld	a4,0(a5)
    62ba:	6310                	ld	a2,0(a4)
    62bc:	b7f9                	j	628a <free+0x44>
    p->s.size += bp->s.size;
    62be:	ff852703          	lw	a4,-8(a0)
    62c2:	9f31                	addw	a4,a4,a2
    62c4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    62c6:	ff053683          	ld	a3,-16(a0)
    62ca:	bfd1                	j	629e <free+0x58>

00000000000062cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    62cc:	7139                	addi	sp,sp,-64
    62ce:	fc06                	sd	ra,56(sp)
    62d0:	f822                	sd	s0,48(sp)
    62d2:	f04a                	sd	s2,32(sp)
    62d4:	ec4e                	sd	s3,24(sp)
    62d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    62d8:	02051993          	slli	s3,a0,0x20
    62dc:	0209d993          	srli	s3,s3,0x20
    62e0:	09bd                	addi	s3,s3,15
    62e2:	0049d993          	srli	s3,s3,0x4
    62e6:	2985                	addiw	s3,s3,1
    62e8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    62ea:	00003517          	auipc	a0,0x3
    62ee:	16653503          	ld	a0,358(a0) # 9450 <freep>
    62f2:	c905                	beqz	a0,6322 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    62f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    62f6:	4798                	lw	a4,8(a5)
    62f8:	09377a63          	bgeu	a4,s3,638c <malloc+0xc0>
    62fc:	f426                	sd	s1,40(sp)
    62fe:	e852                	sd	s4,16(sp)
    6300:	e456                	sd	s5,8(sp)
    6302:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    6304:	8a4e                	mv	s4,s3
    6306:	6705                	lui	a4,0x1
    6308:	00e9f363          	bgeu	s3,a4,630e <malloc+0x42>
    630c:	6a05                	lui	s4,0x1
    630e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6312:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6316:	00003497          	auipc	s1,0x3
    631a:	13a48493          	addi	s1,s1,314 # 9450 <freep>
  if(p == (char*)-1)
    631e:	5afd                	li	s5,-1
    6320:	a089                	j	6362 <malloc+0x96>
    6322:	f426                	sd	s1,40(sp)
    6324:	e852                	sd	s4,16(sp)
    6326:	e456                	sd	s5,8(sp)
    6328:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    632a:	0000a797          	auipc	a5,0xa
    632e:	94e78793          	addi	a5,a5,-1714 # fc78 <base>
    6332:	00003717          	auipc	a4,0x3
    6336:	10f73f23          	sd	a5,286(a4) # 9450 <freep>
    633a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    633c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6340:	b7d1                	j	6304 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    6342:	6398                	ld	a4,0(a5)
    6344:	e118                	sd	a4,0(a0)
    6346:	a8b9                	j	63a4 <malloc+0xd8>
  hp->s.size = nu;
    6348:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    634c:	0541                	addi	a0,a0,16
    634e:	00000097          	auipc	ra,0x0
    6352:	ef8080e7          	jalr	-264(ra) # 6246 <free>
  return freep;
    6356:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    6358:	c135                	beqz	a0,63bc <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    635a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    635c:	4798                	lw	a4,8(a5)
    635e:	03277363          	bgeu	a4,s2,6384 <malloc+0xb8>
    if(p == freep)
    6362:	6098                	ld	a4,0(s1)
    6364:	853e                	mv	a0,a5
    6366:	fef71ae3          	bne	a4,a5,635a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    636a:	8552                	mv	a0,s4
    636c:	00000097          	auipc	ra,0x0
    6370:	b9e080e7          	jalr	-1122(ra) # 5f0a <sbrk>
  if(p == (char*)-1)
    6374:	fd551ae3          	bne	a0,s5,6348 <malloc+0x7c>
        return 0;
    6378:	4501                	li	a0,0
    637a:	74a2                	ld	s1,40(sp)
    637c:	6a42                	ld	s4,16(sp)
    637e:	6aa2                	ld	s5,8(sp)
    6380:	6b02                	ld	s6,0(sp)
    6382:	a03d                	j	63b0 <malloc+0xe4>
    6384:	74a2                	ld	s1,40(sp)
    6386:	6a42                	ld	s4,16(sp)
    6388:	6aa2                	ld	s5,8(sp)
    638a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    638c:	fae90be3          	beq	s2,a4,6342 <malloc+0x76>
        p->s.size -= nunits;
    6390:	4137073b          	subw	a4,a4,s3
    6394:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6396:	02071693          	slli	a3,a4,0x20
    639a:	01c6d713          	srli	a4,a3,0x1c
    639e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    63a0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    63a4:	00003717          	auipc	a4,0x3
    63a8:	0aa73623          	sd	a0,172(a4) # 9450 <freep>
      return (void*)(p + 1);
    63ac:	01078513          	addi	a0,a5,16
  }
}
    63b0:	70e2                	ld	ra,56(sp)
    63b2:	7442                	ld	s0,48(sp)
    63b4:	7902                	ld	s2,32(sp)
    63b6:	69e2                	ld	s3,24(sp)
    63b8:	6121                	addi	sp,sp,64
    63ba:	8082                	ret
    63bc:	74a2                	ld	s1,40(sp)
    63be:	6a42                	ld	s4,16(sp)
    63c0:	6aa2                	ld	s5,8(sp)
    63c2:	6b02                	ld	s6,0(sp)
    63c4:	b7f5                	j	63b0 <malloc+0xe4>
