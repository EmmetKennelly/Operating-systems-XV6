
_nettests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#endif

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 08             	sub    $0x8,%esp
  //int i;
  uint16 dport = NET_TESTS_PORT;

  printf(1,"nettests running on port %d\n", dport);
  11:	68 f3 65 00 00       	push   $0x65f3
  16:	68 16 11 00 00       	push   $0x1116
  1b:	6a 01                	push   $0x1
  1d:	e8 0e 0c 00 00       	call   c30 <printf>
attempts1=4000;
  printf(1,"testing one ping: ");
  22:	58                   	pop    %eax
  23:	5a                   	pop    %edx
  24:	68 33 11 00 00       	push   $0x1133
  29:	6a 01                	push   $0x1
attempts1=4000;
  2b:	c7 05 18 15 00 00 a0 	movl   $0xfa0,0x1518
  32:	0f 00 00 
  printf(1,"testing one ping: ");
  35:	e8 f6 0b 00 00       	call   c30 <printf>
 ping(2000, dport, 2);
  3a:	e8 e1 06 00 00       	call   720 <ping.constprop.1>
 ping(2000, dport, 2);
  3f:	e8 dc 06 00 00       	call   720 <ping.constprop.1>
  printf(1,"OK\n");
  44:	59                   	pop    %ecx
  45:	58                   	pop    %eax
  46:	68 75 11 00 00       	push   $0x1175
  4b:	6a 01                	push   $0x1
  4d:	e8 de 0b 00 00       	call   c30 <printf>
  //attempts1=20;
  printf(1,"testing single-process pings: ");
  52:	58                   	pop    %eax
  53:	5a                   	pop    %edx
  54:	68 e0 11 00 00       	push   $0x11e0
  59:	6a 01                	push   $0x1
  5b:	e8 d0 0b 00 00       	call   c30 <printf>
  //for (i = 0; i < 100; i++)
   // ping(2000, dport, 1);
  printf(1,"OK\n");
  60:	59                   	pop    %ecx
  61:	58                   	pop    %eax
  62:	68 75 11 00 00       	push   $0x1175
  67:	6a 01                	push   $0x1
  69:	e8 c2 0b 00 00       	call   c30 <printf>





  printf(1,"testing multi-process pings: ");
  6e:	58                   	pop    %eax
  6f:	5a                   	pop    %edx
  70:	68 46 11 00 00       	push   $0x1146
  75:	6a 01                	push   $0x1
  77:	e8 b4 0b 00 00       	call   c30 <printf>
  }
  for (i = 0; i < 10; i++){
    if (wait()<0)
      exit();
  }*/
  printf(1,"OK\n");
  7c:	59                   	pop    %ecx
  7d:	58                   	pop    %eax
  7e:	68 75 11 00 00       	push   $0x1175
  83:	6a 01                	push   $0x1
  85:	e8 a6 0b 00 00       	call   c30 <printf>
  
  printf(1,"testing DNS\n");
  8a:	58                   	pop    %eax
  8b:	5a                   	pop    %edx
  8c:	68 64 11 00 00       	push   $0x1164
  91:	6a 01                	push   $0x1
  93:	e8 98 0b 00 00       	call   c30 <printf>
  dns();
  98:	e8 23 00 00 00       	call   c0 <dns>
  printf(1,"DNS OK\n");
  9d:	59                   	pop    %ecx
  9e:	58                   	pop    %eax
  9f:	68 71 11 00 00       	push   $0x1171
  a4:	6a 01                	push   $0x1
  a6:	e8 85 0b 00 00       	call   c30 <printf>
  
  printf(1,"all tests passed.\n");
  ab:	58                   	pop    %eax
  ac:	5a                   	pop    %edx
  ad:	68 79 11 00 00       	push   $0x1179
  b2:	6a 01                	push   $0x1
  b4:	e8 77 0b 00 00       	call   c30 <printf>
  exit();
  b9:	e8 14 0a 00 00       	call   ad2 <exit>
  be:	66 90                	xchg   %ax,%ax

000000c0 <dns>:
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	57                   	push   %edi
  c4:	56                   	push   %esi
  c5:	53                   	push   %ebx
  memset(obuf, 0, N);
  c6:	8d 85 18 f8 ff ff    	lea    -0x7e8(%ebp),%eax
  memset(ibuf, 0, N);
  cc:	8d bd 00 fc ff ff    	lea    -0x400(%ebp),%edi
{
  d2:	81 ec 00 08 00 00    	sub    $0x800,%esp
  memset(obuf, 0, N);
  d8:	68 e8 03 00 00       	push   $0x3e8
  dd:	6a 00                	push   $0x0
  df:	50                   	push   %eax
  e0:	e8 4b 08 00 00       	call   930 <memset>
  memset(ibuf, 0, N);
  e5:	83 c4 0c             	add    $0xc,%esp
  e8:	68 e8 03 00 00       	push   $0x3e8
  ed:	6a 00                	push   $0x0
  ef:	57                   	push   %edi
  f0:	e8 3b 08 00 00       	call   930 <memset>
  if((fd = connect(dst, 10000, 53)) < 0){
  f5:	83 c4 0c             	add    $0xc,%esp
  f8:	6a 35                	push   $0x35
  fa:	68 10 27 00 00       	push   $0x2710
  ff:	68 08 08 08 08       	push   $0x8080808
 104:	e8 71 0a 00 00       	call   b7a <connect>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	89 85 04 f8 ff ff    	mov    %eax,-0x7fc(%ebp)
 114:	0f 88 e4 05 00 00    	js     6fe <dns+0x63e>
  hdr->id = htons(6828);
 11a:	b8 1a ac ff ff       	mov    $0xffffac1a,%eax
  hdr->rd = 1;
 11f:	80 8d 1a f8 ff ff 01 	orb    $0x1,-0x7e6(%ebp)
  for(char *c = host; c < host+strlen(host)+1; c++) {
 126:	bb 88 0f 00 00       	mov    $0xf88,%ebx
  hdr->id = htons(6828);
 12b:	66 89 85 18 f8 ff ff 	mov    %ax,-0x7e8(%ebp)
  hdr->qdcount = htons(1);
 132:	b8 00 01 00 00       	mov    $0x100,%eax
  char *l = host; 
 137:	89 de                	mov    %ebx,%esi
  hdr->qdcount = htons(1);
 139:	66 89 85 1c f8 ff ff 	mov    %ax,-0x7e4(%ebp)
 140:	8d 85 24 f8 ff ff    	lea    -0x7dc(%ebp),%eax
 146:	89 85 14 f8 ff ff    	mov    %eax,-0x7ec(%ebp)
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(char *c = host; c < host+strlen(host)+1; c++) {
 150:	83 ec 0c             	sub    $0xc,%esp
 153:	68 88 0f 00 00       	push   $0xf88
 158:	e8 a3 07 00 00       	call   900 <strlen>
 15d:	05 89 0f 00 00       	add    $0xf89,%eax
 162:	83 c4 10             	add    $0x10,%esp
 165:	39 c3                	cmp    %eax,%ebx
 167:	0f 83 7f 00 00 00    	jae    1ec <dns+0x12c>
    if(*c == '.') {
 16d:	80 3b 2e             	cmpb   $0x2e,(%ebx)
 170:	8d 53 01             	lea    0x1(%ebx),%edx
 173:	74 04                	je     179 <dns+0xb9>
  for(char *c = host; c < host+strlen(host)+1; c++) {
 175:	89 d3                	mov    %edx,%ebx
 177:	eb d7                	jmp    150 <dns+0x90>
      *qn++ = (char) (c-l);
 179:	8b 85 14 f8 ff ff    	mov    -0x7ec(%ebp),%eax
 17f:	8d 48 01             	lea    0x1(%eax),%ecx
 182:	89 8d 10 f8 ff ff    	mov    %ecx,-0x7f0(%ebp)
 188:	89 d9                	mov    %ebx,%ecx
 18a:	29 f1                	sub    %esi,%ecx
      for(char *d = l; d < c; d++) {
 18c:	39 f3                	cmp    %esi,%ebx
      *qn++ = (char) (c-l);
 18e:	88 08                	mov    %cl,(%eax)
      for(char *d = l; d < c; d++) {
 190:	0f 86 a0 04 00 00    	jbe    636 <dns+0x576>
 196:	89 9d 0c f8 ff ff    	mov    %ebx,-0x7f4(%ebp)
 19c:	31 c0                	xor    %eax,%eax
 19e:	8b 9d 14 f8 ff ff    	mov    -0x7ec(%ebp),%ebx
 1a4:	89 95 14 f8 ff ff    	mov    %edx,-0x7ec(%ebp)
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        *qn++ = *d;
 1b0:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
 1b4:	88 54 03 01          	mov    %dl,0x1(%ebx,%eax,1)
 1b8:	83 c0 01             	add    $0x1,%eax
      for(char *d = l; d < c; d++) {
 1bb:	39 c8                	cmp    %ecx,%eax
 1bd:	75 f1                	jne    1b0 <dns+0xf0>
 1bf:	8b 9d 0c f8 ff ff    	mov    -0x7f4(%ebp),%ebx
 1c5:	83 c6 01             	add    $0x1,%esi
 1c8:	b8 01 00 00 00       	mov    $0x1,%eax
 1cd:	29 f0                	sub    %esi,%eax
 1cf:	8b 95 14 f8 ff ff    	mov    -0x7ec(%ebp),%edx
 1d5:	01 c3                	add    %eax,%ebx
 1d7:	03 9d 10 f8 ff ff    	add    -0x7f0(%ebp),%ebx
      l = c+1; // skip .
 1dd:	89 d6                	mov    %edx,%esi
 1df:	89 9d 14 f8 ff ff    	mov    %ebx,-0x7ec(%ebp)
  for(char *c = host; c < host+strlen(host)+1; c++) {
 1e5:	89 d3                	mov    %edx,%ebx
 1e7:	e9 64 ff ff ff       	jmp    150 <dns+0x90>
  *qn = '\0';
 1ec:	8b 85 14 f8 ff ff    	mov    -0x7ec(%ebp),%eax
  len += strlen(qname) + 1;
 1f2:	83 ec 0c             	sub    $0xc,%esp
  *qn = '\0';
 1f5:	c6 00 00             	movb   $0x0,(%eax)
  len += strlen(qname) + 1;
 1f8:	8d 85 24 f8 ff ff    	lea    -0x7dc(%ebp),%eax
 1fe:	50                   	push   %eax
 1ff:	e8 fc 06 00 00       	call   900 <strlen>
 204:	89 c3                	mov    %eax,%ebx
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
 206:	8d 85 24 f8 ff ff    	lea    -0x7dc(%ebp),%eax
  len += sizeof(struct dns_question);
 20c:	83 c3 11             	add    $0x11,%ebx
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
 20f:	89 04 24             	mov    %eax,(%esp)
 212:	e8 e9 06 00 00       	call   900 <strlen>
  h->qtype = htons(0x1);
 217:	c7 84 05 25 f8 ff ff 	movl   $0x1000100,-0x7db(%ebp,%eax,1)
 21e:	00 01 00 01 
  if(write(fd, obuf, len) < 0){
 222:	8d 85 18 f8 ff ff    	lea    -0x7e8(%ebp),%eax
 228:	83 c4 0c             	add    $0xc,%esp
 22b:	53                   	push   %ebx
 22c:	50                   	push   %eax
 22d:	ff b5 04 f8 ff ff    	pushl  -0x7fc(%ebp)
 233:	e8 ba 08 00 00       	call   af2 <write>
 238:	83 c4 10             	add    $0x10,%esp
 23b:	85 c0                	test   %eax,%eax
 23d:	0f 88 a8 04 00 00    	js     6eb <dns+0x62b>
  int cc = read(fd, ibuf, sizeof(ibuf));
 243:	83 ec 04             	sub    $0x4,%esp
 246:	68 e8 03 00 00       	push   $0x3e8
 24b:	57                   	push   %edi
 24c:	ff b5 04 f8 ff ff    	pushl  -0x7fc(%ebp)
 252:	e8 93 08 00 00       	call   aea <read>
  if(cc < 0){
 257:	83 c4 10             	add    $0x10,%esp
 25a:	85 c0                	test   %eax,%eax
  int cc = read(fd, ibuf, sizeof(ibuf));
 25c:	89 85 00 f8 ff ff    	mov    %eax,-0x800(%ebp)
  if(cc < 0){
 262:	0f 88 70 04 00 00    	js     6d8 <dns+0x618>
printf(1,"dns len %d\n",cc);
 268:	8b b5 00 f8 ff ff    	mov    -0x800(%ebp),%esi
 26e:	83 ec 04             	sub    $0x4,%esp
 271:	56                   	push   %esi
 272:	68 dc 0f 00 00       	push   $0xfdc
 277:	6a 01                	push   $0x1
 279:	e8 b2 09 00 00       	call   c30 <printf>
ibuf[cc]=0;
 27e:	89 f0                	mov    %esi,%eax
for (int y=0;y<cc;y++)
 280:	83 c4 10             	add    $0x10,%esp
ibuf[cc]=0;
 283:	c6 84 35 00 fc ff ff 	movb   $0x0,-0x400(%ebp,%esi,1)
 28a:	00 
for (int y=0;y<cc;y++)
 28b:	85 c0                	test   %eax,%eax
 28d:	89 fe                	mov    %edi,%esi
 28f:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
 292:	74 21                	je     2b5 <dns+0x1f5>
 294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
   printf(1,"%x ",ibuf[y]);
 298:	0f b6 06             	movzbl (%esi),%eax
 29b:	83 ec 04             	sub    $0x4,%esp
 29e:	83 c6 01             	add    $0x1,%esi
 2a1:	50                   	push   %eax
 2a2:	68 ef 0f 00 00       	push   $0xfef
 2a7:	6a 01                	push   $0x1
 2a9:	e8 82 09 00 00       	call   c30 <printf>
for (int y=0;y<cc;y++)
 2ae:	83 c4 10             	add    $0x10,%esp
 2b1:	39 f3                	cmp    %esi,%ebx
 2b3:	75 e3                	jne    298 <dns+0x1d8>
printf(1,"\nhere\n");
 2b5:	83 ec 08             	sub    $0x8,%esp
 2b8:	68 e8 0f 00 00       	push   $0xfe8
 2bd:	6a 01                	push   $0x1
 2bf:	e8 6c 09 00 00       	call   c30 <printf>
  if(!hdr->qr) {
 2c4:	83 c4 10             	add    $0x10,%esp
 2c7:	80 bd 02 fc ff ff 00 	cmpb   $0x0,-0x3fe(%ebp)
 2ce:	0f 89 ff 03 00 00    	jns    6d3 <dns+0x613>
  if(hdr->id != htons(6828))
 2d4:	0f b7 85 00 fc ff ff 	movzwl -0x400(%ebp),%eax
 2db:	66 3d 1a ac          	cmp    $0xac1a,%ax
 2df:	74 18                	je     2f9 <dns+0x239>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
 2e1:	66 c1 c0 08          	rol    $0x8,%ax
    printf(1,"DNS wrong id: %d\n", ntohs(hdr->id));
 2e5:	53                   	push   %ebx
 2e6:	0f b7 c0             	movzwl %ax,%eax
 2e9:	50                   	push   %eax
 2ea:	68 f3 0f 00 00       	push   $0xff3
 2ef:	6a 01                	push   $0x1
 2f1:	e8 3a 09 00 00       	call   c30 <printf>
 2f6:	83 c4 10             	add    $0x10,%esp
  if(hdr->rcode != 0) {
 2f9:	0f b6 85 03 fc ff ff 	movzbl -0x3fd(%ebp),%eax
 300:	83 e0 0f             	and    $0xf,%eax
 303:	0f 85 b4 03 00 00    	jne    6bd <dns+0x5fd>
  printf(1,"here2\n");
 309:	83 ec 08             	sub    $0x8,%esp
 30c:	68 1a 10 00 00       	push   $0x101a
 311:	6a 01                	push   $0x1
 313:	e8 18 09 00 00       	call   c30 <printf>
 318:	0f b7 85 04 fc ff ff 	movzwl -0x3fc(%ebp),%eax
  printf(1,"qdcount: %x\n", ntohs(hdr->qdcount));
 31f:	83 c4 0c             	add    $0xc,%esp
 322:	66 c1 c0 08          	rol    $0x8,%ax
 326:	0f b7 c0             	movzwl %ax,%eax
 329:	50                   	push   %eax
 32a:	68 21 10 00 00       	push   $0x1021
 32f:	6a 01                	push   $0x1
 331:	e8 fa 08 00 00       	call   c30 <printf>
 336:	0f b7 85 06 fc ff ff 	movzwl -0x3fa(%ebp),%eax
  printf(1,"ancount: %x\n", ntohs(hdr->ancount));
 33d:	83 c4 0c             	add    $0xc,%esp
 340:	66 c1 c0 08          	rol    $0x8,%ax
 344:	0f b7 c0             	movzwl %ax,%eax
 347:	50                   	push   %eax
 348:	68 2e 10 00 00       	push   $0x102e
 34d:	6a 01                	push   $0x1
 34f:	e8 dc 08 00 00       	call   c30 <printf>
 354:	0f b7 85 08 fc ff ff 	movzwl -0x3f8(%ebp),%eax
  printf(1,"nscount: %x\n", ntohs(hdr->nscount));
 35b:	83 c4 0c             	add    $0xc,%esp
 35e:	66 c1 c0 08          	rol    $0x8,%ax
 362:	0f b7 c0             	movzwl %ax,%eax
 365:	50                   	push   %eax
 366:	68 3b 10 00 00       	push   $0x103b
 36b:	6a 01                	push   $0x1
 36d:	e8 be 08 00 00       	call   c30 <printf>
 372:	0f b7 85 0a fc ff ff 	movzwl -0x3f6(%ebp),%eax
  printf(1,"arcount: %x\n", ntohs(hdr->arcount));
 379:	83 c4 0c             	add    $0xc,%esp
 37c:	66 c1 c0 08          	rol    $0x8,%ax
 380:	0f b7 c0             	movzwl %ax,%eax
 383:	50                   	push   %eax
 384:	68 48 10 00 00       	push   $0x1048
 389:	6a 01                	push   $0x1
 38b:	e8 a0 08 00 00       	call   c30 <printf>
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
 390:	83 c4 10             	add    $0x10,%esp
 393:	66 83 bd 04 fc ff ff 	cmpw   $0x0,-0x3fc(%ebp)
 39a:	00 
 39b:	0f 84 a8 02 00 00    	je     649 <dns+0x589>
  len = sizeof(struct dns);
 3a1:	be 0c 00 00 00       	mov    $0xc,%esi
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
 3a6:	31 c9                	xor    %ecx,%ecx
  len = sizeof(struct dns);
 3a8:	89 f2                	mov    %esi,%edx
 3aa:	89 ce                	mov    %ecx,%esi
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    char *qn = (char *) (ibuf+len);
 3b0:	8d 1c 17             	lea    (%edi,%edx,1),%ebx
  while(*qn != '\0') {
 3b3:	0f be 0b             	movsbl (%ebx),%ecx
 3b6:	84 c9                	test   %cl,%cl
 3b8:	74 3c                	je     3f6 <dns+0x336>
    if(l == 0)
 3ba:	85 c9                	test   %ecx,%ecx
 3bc:	74 38                	je     3f6 <dns+0x336>
 3be:	89 d8                	mov    %ebx,%eax
    for(int i = 0; i < l; i++) {
 3c0:	85 c9                	test   %ecx,%ecx
 3c2:	0f 8e f8 01 00 00    	jle    5c0 <dns+0x500>
 3c8:	01 c1                	add    %eax,%ecx
 3ca:	89 95 14 f8 ff ff    	mov    %edx,-0x7ec(%ebp)
      *qn = *(qn+1);
 3d0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      qn++;
 3d4:	83 c0 01             	add    $0x1,%eax
      *qn = *(qn+1);
 3d7:	88 50 ff             	mov    %dl,-0x1(%eax)
    for(int i = 0; i < l; i++) {
 3da:	39 c8                	cmp    %ecx,%eax
 3dc:	75 f2                	jne    3d0 <dns+0x310>
 3de:	8b 95 14 f8 ff ff    	mov    -0x7ec(%ebp),%edx
    *qn++ = '.';
 3e4:	8d 41 01             	lea    0x1(%ecx),%eax
 3e7:	c6 01 2e             	movb   $0x2e,(%ecx)
  while(*qn != '\0') {
 3ea:	0f be 49 01          	movsbl 0x1(%ecx),%ecx
 3ee:	84 c9                	test   %cl,%cl
 3f0:	74 04                	je     3f6 <dns+0x336>
    if(l == 0)
 3f2:	85 c9                	test   %ecx,%ecx
 3f4:	75 ca                	jne    3c0 <dns+0x300>
    len += strlen(qn)+1;
 3f6:	83 ec 0c             	sub    $0xc,%esp
 3f9:	89 95 14 f8 ff ff    	mov    %edx,-0x7ec(%ebp)
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
 3ff:	83 c6 01             	add    $0x1,%esi
    len += strlen(qn)+1;
 402:	53                   	push   %ebx
 403:	e8 f8 04 00 00       	call   900 <strlen>
    len += sizeof(struct dns_question);
 408:	8b 95 14 f8 ff ff    	mov    -0x7ec(%ebp),%edx
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
 40e:	83 c4 10             	add    $0x10,%esp
    len += sizeof(struct dns_question);
 411:	8d 54 10 05          	lea    0x5(%eax,%edx,1),%edx
 415:	0f b7 85 04 fc ff ff 	movzwl -0x3fc(%ebp),%eax
 41c:	66 c1 c0 08          	rol    $0x8,%ax
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
 420:	0f b7 c0             	movzwl %ax,%eax
 423:	39 c6                	cmp    %eax,%esi
 425:	7c 89                	jl     3b0 <dns+0x2f0>
 427:	89 d6                	mov    %edx,%esi
printf(1,"here3\n");
 429:	83 ec 08             	sub    $0x8,%esp
 42c:	68 55 10 00 00       	push   $0x1055
 431:	6a 01                	push   $0x1
 433:	e8 f8 07 00 00       	call   c30 <printf>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
 438:	83 c4 10             	add    $0x10,%esp
 43b:	66 83 bd 06 fc ff ff 	cmpw   $0x0,-0x3fa(%ebp)
 442:	00 
 443:	0f 84 0c 02 00 00    	je     655 <dns+0x595>
 449:	85 db                	test   %ebx,%ebx
 44b:	b8 15 11 00 00       	mov    $0x1115,%eax
  int record = 0;
 450:	c7 85 0c f8 ff ff 00 	movl   $0x0,-0x7f4(%ebp)
 457:	00 00 00 
 45a:	0f 45 c3             	cmovne %ebx,%eax
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
 45d:	c7 85 14 f8 ff ff 00 	movl   $0x0,-0x7ec(%ebp)
 464:	00 00 00 
 467:	89 85 08 f8 ff ff    	mov    %eax,-0x7f8(%ebp)
 46d:	eb 53                	jmp    4c2 <dns+0x402>
 46f:	90                   	nop
      printf(1,"here4\n");
 470:	83 ec 08             	sub    $0x8,%esp
 473:	89 85 10 f8 ff ff    	mov    %eax,-0x7f0(%ebp)
 479:	68 5c 10 00 00       	push   $0x105c
 47e:	6a 01                	push   $0x1
 480:	e8 ab 07 00 00       	call   c30 <printf>
    struct dns_data *d = (struct dns_data *) (ibuf+len);
 485:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
 48b:	83 c4 10             	add    $0x10,%esp
    struct dns_data *d = (struct dns_data *) (ibuf+len);
 48e:	8d 14 07             	lea    (%edi,%eax,1),%edx
    len += sizeof(struct dns_data);
 491:	8d 70 0a             	lea    0xa(%eax),%esi
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
 494:	66 81 3a 00 01       	cmpw   $0x100,(%edx)
 499:	0f 84 89 00 00 00    	je     528 <dns+0x468>
 49f:	0f b7 85 06 fc ff ff 	movzwl -0x3fa(%ebp),%eax
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
 4a6:	83 85 14 f8 ff ff 01 	addl   $0x1,-0x7ec(%ebp)
 4ad:	8b 9d 14 f8 ff ff    	mov    -0x7ec(%ebp),%ebx
 4b3:	66 c1 c0 08          	rol    $0x8,%ax
 4b7:	0f b7 c0             	movzwl %ax,%eax
 4ba:	39 c3                	cmp    %eax,%ebx
 4bc:	0f 8d 05 01 00 00    	jge    5c7 <dns+0x507>
    char *qn = (char *) (ibuf+len);
 4c2:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
      len += 2;
 4c5:	8d 46 02             	lea    0x2(%esi),%eax
    if((int) qn[0] > 63) {  // compression?
 4c8:	0f b6 19             	movzbl (%ecx),%ebx
 4cb:	80 fb 3f             	cmp    $0x3f,%bl
 4ce:	7f a0                	jg     470 <dns+0x3b0>
  while(*qn != '\0') {
 4d0:	84 db                	test   %bl,%bl
    int l = *qn;
 4d2:	0f be d3             	movsbl %bl,%edx
    if(l == 0)
 4d5:	89 c8                	mov    %ecx,%eax
  while(*qn != '\0') {
 4d7:	74 37                	je     510 <dns+0x450>
 4d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(int i = 0; i < l; i++) {
 4e0:	85 d2                	test   %edx,%edx
 4e2:	0f 8e c8 00 00 00    	jle    5b0 <dns+0x4f0>
 4e8:	01 c2                	add    %eax,%edx
 4ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *qn = *(qn+1);
 4f0:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
      qn++;
 4f4:	83 c0 01             	add    $0x1,%eax
      *qn = *(qn+1);
 4f7:	88 58 ff             	mov    %bl,-0x1(%eax)
    for(int i = 0; i < l; i++) {
 4fa:	39 d0                	cmp    %edx,%eax
 4fc:	75 f2                	jne    4f0 <dns+0x430>
    *qn++ = '.';
 4fe:	8d 42 01             	lea    0x1(%edx),%eax
 501:	c6 02 2e             	movb   $0x2e,(%edx)
  while(*qn != '\0') {
 504:	0f be 52 01          	movsbl 0x1(%edx),%edx
 508:	84 d2                	test   %dl,%dl
 50a:	74 04                	je     510 <dns+0x450>
    if(l == 0)
 50c:	85 d2                	test   %edx,%edx
 50e:	75 d0                	jne    4e0 <dns+0x420>
      len += strlen(qn)+1;
 510:	83 ec 0c             	sub    $0xc,%esp
 513:	51                   	push   %ecx
 514:	e8 e7 03 00 00       	call   900 <strlen>
 519:	83 c4 10             	add    $0x10,%esp
 51c:	8d 44 30 01          	lea    0x1(%eax,%esi,1),%eax
 520:	e9 4b ff ff ff       	jmp    470 <dns+0x3b0>
 525:	8d 76 00             	lea    0x0(%esi),%esi
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
 528:	66 81 7a 08 00 04    	cmpw   $0x400,0x8(%edx)
 52e:	0f 85 6b ff ff ff    	jne    49f <dns+0x3df>
      printf(1,"DNS arecord for %s is ", qname ? qname : "" );
 534:	83 ec 04             	sub    $0x4,%esp
 537:	ff b5 08 f8 ff ff    	pushl  -0x7f8(%ebp)
      uint8 *ip = (ibuf+len);
 53d:	01 fe                	add    %edi,%esi
      printf(1,"DNS arecord for %s is ", qname ? qname : "" );
 53f:	68 63 10 00 00       	push   $0x1063
 544:	6a 01                	push   $0x1
 546:	e8 e5 06 00 00       	call   c30 <printf>
      printf(1,"%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
 54b:	58                   	pop    %eax
 54c:	5a                   	pop    %edx
 54d:	0f b6 56 03          	movzbl 0x3(%esi),%edx
 551:	52                   	push   %edx
 552:	0f b6 56 02          	movzbl 0x2(%esi),%edx
 556:	52                   	push   %edx
 557:	0f b6 56 01          	movzbl 0x1(%esi),%edx
 55b:	52                   	push   %edx
 55c:	0f b6 16             	movzbl (%esi),%edx
 55f:	52                   	push   %edx
 560:	68 7a 10 00 00       	push   $0x107a
 565:	6a 01                	push   $0x1
 567:	e8 c4 06 00 00       	call   c30 <printf>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
 56c:	83 c4 20             	add    $0x20,%esp
 56f:	80 3e 80             	cmpb   $0x80,(%esi)
 572:	0f 85 32 01 00 00    	jne    6aa <dns+0x5ea>
 578:	80 7e 01 34          	cmpb   $0x34,0x1(%esi)
 57c:	0f 85 28 01 00 00    	jne    6aa <dns+0x5ea>
 582:	80 7e 02 81          	cmpb   $0x81,0x2(%esi)
 586:	0f 85 1e 01 00 00    	jne    6aa <dns+0x5ea>
 58c:	80 7e 03 7e          	cmpb   $0x7e,0x3(%esi)
 590:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
 596:	0f 85 0e 01 00 00    	jne    6aa <dns+0x5ea>
      len += 4;
 59c:	8d 70 0e             	lea    0xe(%eax),%esi
      record = 1;
 59f:	c7 85 0c f8 ff ff 01 	movl   $0x1,-0x7f4(%ebp)
 5a6:	00 00 00 
 5a9:	e9 f1 fe ff ff       	jmp    49f <dns+0x3df>
 5ae:	66 90                	xchg   %ax,%ax
    for(int i = 0; i < l; i++) {
 5b0:	89 c2                	mov    %eax,%edx
 5b2:	e9 47 ff ff ff       	jmp    4fe <dns+0x43e>
 5b7:	89 f6                	mov    %esi,%esi
 5b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 5c0:	89 c1                	mov    %eax,%ecx
 5c2:	e9 1d fe ff ff       	jmp    3e4 <dns+0x324>
printf(1,"here5\n");
 5c7:	83 ec 08             	sub    $0x8,%esp
 5ca:	68 98 10 00 00       	push   $0x1098
 5cf:	6a 01                	push   $0x1
 5d1:	e8 5a 06 00 00       	call   c30 <printf>
  if(len != cc) {
 5d6:	83 c4 10             	add    $0x10,%esp
 5d9:	39 b5 00 f8 ff ff    	cmp    %esi,-0x800(%ebp)
 5df:	0f 85 89 00 00 00    	jne    66e <dns+0x5ae>
printf(1,"here6\n");
 5e5:	83 ec 08             	sub    $0x8,%esp
 5e8:	68 9f 10 00 00       	push   $0x109f
 5ed:	6a 01                	push   $0x1
 5ef:	e8 3c 06 00 00       	call   c30 <printf>
  if(!record) {
 5f4:	8b 85 0c f8 ff ff    	mov    -0x7f4(%ebp),%eax
 5fa:	83 c4 10             	add    $0x10,%esp
 5fd:	85 c0                	test   %eax,%eax
 5ff:	0f 84 92 00 00 00    	je     697 <dns+0x5d7>
printf(1,"here7\n");
 605:	83 ec 08             	sub    $0x8,%esp
 608:	68 c1 10 00 00       	push   $0x10c1
 60d:	6a 01                	push   $0x1
 60f:	e8 1c 06 00 00       	call   c30 <printf>
printf(1,"here1\n");
 614:	59                   	pop    %ecx
 615:	5b                   	pop    %ebx
 616:	68 c8 10 00 00       	push   $0x10c8
 61b:	6a 01                	push   $0x1
 61d:	e8 0e 06 00 00       	call   c30 <printf>
  close(fd);
 622:	5e                   	pop    %esi
 623:	ff b5 04 f8 ff ff    	pushl  -0x7fc(%ebp)
 629:	e8 cc 04 00 00       	call   afa <close>
}  
 62e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 631:	5b                   	pop    %ebx
 632:	5e                   	pop    %esi
 633:	5f                   	pop    %edi
 634:	5d                   	pop    %ebp
 635:	c3                   	ret    
      *qn++ = (char) (c-l);
 636:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
      l = c+1; // skip .
 63c:	89 d6                	mov    %edx,%esi
      *qn++ = (char) (c-l);
 63e:	89 85 14 f8 ff ff    	mov    %eax,-0x7ec(%ebp)
 644:	e9 9c fb ff ff       	jmp    1e5 <dns+0x125>
  char *qname = 0;
 649:	31 db                	xor    %ebx,%ebx
  len = sizeof(struct dns);
 64b:	be 0c 00 00 00       	mov    $0xc,%esi
 650:	e9 d4 fd ff ff       	jmp    429 <dns+0x369>
printf(1,"here5\n");
 655:	50                   	push   %eax
 656:	50                   	push   %eax
 657:	68 98 10 00 00       	push   $0x1098
 65c:	6a 01                	push   $0x1
 65e:	e8 cd 05 00 00       	call   c30 <printf>
  if(len != cc) {
 663:	83 c4 10             	add    $0x10,%esp
 666:	39 b5 00 f8 ff ff    	cmp    %esi,-0x800(%ebp)
 66c:	74 18                	je     686 <dns+0x5c6>
    printf(1,"Processed %d data bytes but received %d\n", len, cc);
 66e:	ff b5 00 f8 ff ff    	pushl  -0x800(%ebp)
 674:	56                   	push   %esi
 675:	68 8c 11 00 00       	push   $0x118c
 67a:	6a 01                	push   $0x1
 67c:	e8 af 05 00 00       	call   c30 <printf>
    exit();
 681:	e8 4c 04 00 00       	call   ad2 <exit>
printf(1,"here6\n");
 686:	52                   	push   %edx
 687:	52                   	push   %edx
 688:	68 9f 10 00 00       	push   $0x109f
 68d:	6a 01                	push   $0x1
 68f:	e8 9c 05 00 00       	call   c30 <printf>
 694:	83 c4 10             	add    $0x10,%esp
    printf(1,"Didn't receive an arecord\n");
 697:	57                   	push   %edi
 698:	57                   	push   %edi
 699:	68 a6 10 00 00       	push   $0x10a6
 69e:	6a 01                	push   $0x1
 6a0:	e8 8b 05 00 00       	call   c30 <printf>
    exit();
 6a5:	e8 28 04 00 00       	call   ad2 <exit>
        printf(1,"wrong ip address");
 6aa:	50                   	push   %eax
 6ab:	50                   	push   %eax
 6ac:	68 87 10 00 00       	push   $0x1087
 6b1:	6a 01                	push   $0x1
 6b3:	e8 78 05 00 00       	call   c30 <printf>
        exit();
 6b8:	e8 15 04 00 00       	call   ad2 <exit>
    printf(1,"DNS rcode error: %x\n", hdr->rcode);
 6bd:	0f b6 c0             	movzbl %al,%eax
 6c0:	51                   	push   %ecx
 6c1:	50                   	push   %eax
 6c2:	68 05 10 00 00       	push   $0x1005
 6c7:	6a 01                	push   $0x1
 6c9:	e8 62 05 00 00       	call   c30 <printf>
    exit();
 6ce:	e8 ff 03 00 00       	call   ad2 <exit>
    exit();
 6d3:	e8 fa 03 00 00       	call   ad2 <exit>
    printf(1, "dns: recv() failed\n");
 6d8:	56                   	push   %esi
 6d9:	56                   	push   %esi
 6da:	68 c8 0f 00 00       	push   $0xfc8
 6df:	6a 01                	push   $0x1
 6e1:	e8 4a 05 00 00       	call   c30 <printf>
    exit();
 6e6:	e8 e7 03 00 00       	call   ad2 <exit>
    printf(1, "dns: send() failed\n");
 6eb:	57                   	push   %edi
 6ec:	57                   	push   %edi
 6ed:	68 b4 0f 00 00       	push   $0xfb4
 6f2:	6a 01                	push   $0x1
 6f4:	e8 37 05 00 00       	call   c30 <printf>
    exit();
 6f9:	e8 d4 03 00 00       	call   ad2 <exit>
    printf(1, "ping: connect() failed\n");
 6fe:	50                   	push   %eax
 6ff:	50                   	push   %eax
 700:	68 9c 0f 00 00       	push   $0xf9c
 705:	6a 01                	push   $0x1
 707:	e8 24 05 00 00       	call   c30 <printf>
    exit();
 70c:	e8 c1 03 00 00       	call   ad2 <exit>
 711:	eb 0d                	jmp    720 <ping.constprop.1>
 713:	90                   	nop
 714:	90                   	nop
 715:	90                   	nop
 716:	90                   	nop
 717:	90                   	nop
 718:	90                   	nop
 719:	90                   	nop
 71a:	90                   	nop
 71b:	90                   	nop
 71c:	90                   	nop
 71d:	90                   	nop
 71e:	90                   	nop
 71f:	90                   	nop

00000720 <ping.constprop.1>:
ping(uint16 sport, uint16 dport, int attempts)
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	81 ec ac 00 00 00    	sub    $0xac,%esp
  if (attempts1 <40)return;
 72c:	83 3d 18 15 00 00 27 	cmpl   $0x27,0x1518
  char obuf[13] = "hello world!";
 733:	c7 85 5b ff ff ff 68 	movl   $0x6c6c6568,-0xa5(%ebp)
 73a:	65 6c 6c 
 73d:	c7 85 5f ff ff ff 6f 	movl   $0x6f77206f,-0xa1(%ebp)
 744:	20 77 6f 
 747:	c7 85 63 ff ff ff 72 	movl   $0x21646c72,-0x9d(%ebp)
 74e:	6c 64 21 
 751:	c6 85 67 ff ff ff 00 	movb   $0x0,-0x99(%ebp)
  if (attempts1 <40)return;
 758:	7f 08                	jg     762 <ping.constprop.1+0x42>
}
 75a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 75d:	5b                   	pop    %ebx
 75e:	5e                   	pop    %esi
 75f:	5f                   	pop    %edi
 760:	5d                   	pop    %ebp
 761:	c3                   	ret    
  if((fd = connect(dst, sport, dport)) < 0){
 762:	50                   	push   %eax
 763:	68 f3 65 00 00       	push   $0x65f3
 768:	68 d0 07 00 00       	push   $0x7d0
 76d:	68 02 02 00 0a       	push   $0xa000202
 772:	e8 03 04 00 00       	call   b7a <connect>
 777:	83 c4 10             	add    $0x10,%esp
 77a:	85 c0                	test   %eax,%eax
 77c:	89 c3                	mov    %eax,%ebx
 77e:	0f 88 e2 00 00 00    	js     866 <ping.constprop.1+0x146>
    if(write(fd, obuf, sizeof(obuf)) < 0){
 784:	8d bd 5b ff ff ff    	lea    -0xa5(%ebp),%edi
 78a:	50                   	push   %eax
 78b:	6a 0d                	push   $0xd
 78d:	57                   	push   %edi
 78e:	53                   	push   %ebx
 78f:	e8 5e 03 00 00       	call   af2 <write>
 794:	83 c4 10             	add    $0x10,%esp
 797:	85 c0                	test   %eax,%eax
 799:	0f 88 a1 00 00 00    	js     840 <ping.constprop.1+0x120>
 79f:	50                   	push   %eax
 7a0:	6a 0d                	push   $0xd
 7a2:	57                   	push   %edi
 7a3:	53                   	push   %ebx
 7a4:	e8 49 03 00 00       	call   af2 <write>
 7a9:	83 c4 10             	add    $0x10,%esp
 7ac:	85 c0                	test   %eax,%eax
 7ae:	0f 88 8c 00 00 00    	js     840 <ping.constprop.1+0x120>
  int cc = read(fd, ibuf, sizeof(ibuf));
 7b4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
 7ba:	50                   	push   %eax
 7bb:	68 80 00 00 00       	push   $0x80
 7c0:	56                   	push   %esi
 7c1:	53                   	push   %ebx
 7c2:	e8 23 03 00 00       	call   aea <read>
  if(cc < 0){
 7c7:	83 c4 10             	add    $0x10,%esp
 7ca:	85 c0                	test   %eax,%eax
 7cc:	0f 88 81 00 00 00    	js     853 <ping.constprop.1+0x133>
    printf(1,"**read return %d %s**:\n",cc,ibuf);
 7d2:	56                   	push   %esi
 7d3:	50                   	push   %eax
 7d4:	68 f9 10 00 00       	push   $0x10f9
 7d9:	6a 01                	push   $0x1
  ibuf[cc]=0;
 7db:	c6 84 05 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%eax,1)
 7e2:	00 
    printf(1,"**read return %d %s**:\n",cc,ibuf);
 7e3:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
 7e9:	e8 42 04 00 00       	call   c30 <printf>
    printf(1,ibuf);
 7ee:	5a                   	pop    %edx
 7ef:	59                   	pop    %ecx
 7f0:	56                   	push   %esi
 7f1:	6a 01                	push   $0x1
 7f3:	e8 38 04 00 00       	call   c30 <printf>
    printf(1,":**\n");
 7f8:	58                   	pop    %eax
 7f9:	5a                   	pop    %edx
 7fa:	68 11 11 00 00       	push   $0x1111
 7ff:	6a 01                	push   $0x1
 801:	e8 2a 04 00 00       	call   c30 <printf>
  close(fd);
 806:	89 1c 24             	mov    %ebx,(%esp)
 809:	e8 ec 02 00 00       	call   afa <close>
  if (strcmp(obuf, ibuf) || cc != sizeof(obuf)){
 80e:	59                   	pop    %ecx
 80f:	5b                   	pop    %ebx
 810:	56                   	push   %esi
 811:	57                   	push   %edi
 812:	e8 99 00 00 00       	call   8b0 <strcmp>
 817:	8b 95 54 ff ff ff    	mov    -0xac(%ebp),%edx
 81d:	83 c4 10             	add    $0x10,%esp
 820:	83 fa 0d             	cmp    $0xd,%edx
 823:	75 08                	jne    82d <ping.constprop.1+0x10d>
 825:	85 c0                	test   %eax,%eax
 827:	0f 84 2d ff ff ff    	je     75a <ping.constprop.1+0x3a>
    printf(1, "ping didn't receive correct payload\n");
 82d:	50                   	push   %eax
 82e:	50                   	push   %eax
 82f:	68 b8 11 00 00       	push   $0x11b8
 834:	6a 01                	push   $0x1
 836:	e8 f5 03 00 00       	call   c30 <printf>
    exit();
 83b:	e8 92 02 00 00       	call   ad2 <exit>
      printf(1, "ping: send() failed\n");
 840:	57                   	push   %edi
 841:	57                   	push   %edi
 842:	68 cf 10 00 00       	push   $0x10cf
 847:	6a 01                	push   $0x1
 849:	e8 e2 03 00 00       	call   c30 <printf>
      exit();
 84e:	e8 7f 02 00 00       	call   ad2 <exit>
    printf(1, "ping: recv() failed\n");
 853:	56                   	push   %esi
 854:	56                   	push   %esi
 855:	68 e4 10 00 00       	push   $0x10e4
 85a:	6a 01                	push   $0x1
 85c:	e8 cf 03 00 00       	call   c30 <printf>
    exit();
 861:	e8 6c 02 00 00       	call   ad2 <exit>
    printf(1, "ping: connect() failed\n");
 866:	50                   	push   %eax
 867:	50                   	push   %eax
 868:	68 9c 0f 00 00       	push   $0xf9c
 86d:	6a 01                	push   $0x1
 86f:	e8 bc 03 00 00       	call   c30 <printf>
    exit();
 874:	e8 59 02 00 00       	call   ad2 <exit>
 879:	66 90                	xchg   %ax,%ax
 87b:	66 90                	xchg   %ax,%ax
 87d:	66 90                	xchg   %ax,%ax
 87f:	90                   	nop

00000880 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp
 883:	53                   	push   %ebx
 884:	8b 45 08             	mov    0x8(%ebp),%eax
 887:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 88a:	89 c2                	mov    %eax,%edx
 88c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 890:	83 c1 01             	add    $0x1,%ecx
 893:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 897:	83 c2 01             	add    $0x1,%edx
 89a:	84 db                	test   %bl,%bl
 89c:	88 5a ff             	mov    %bl,-0x1(%edx)
 89f:	75 ef                	jne    890 <strcpy+0x10>
    ;
  return os;
}
 8a1:	5b                   	pop    %ebx
 8a2:	5d                   	pop    %ebp
 8a3:	c3                   	ret    
 8a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000008b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	53                   	push   %ebx
 8b4:	8b 55 08             	mov    0x8(%ebp),%edx
 8b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 8ba:	0f b6 02             	movzbl (%edx),%eax
 8bd:	0f b6 19             	movzbl (%ecx),%ebx
 8c0:	84 c0                	test   %al,%al
 8c2:	75 1c                	jne    8e0 <strcmp+0x30>
 8c4:	eb 2a                	jmp    8f0 <strcmp+0x40>
 8c6:	8d 76 00             	lea    0x0(%esi),%esi
 8c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 8d0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 8d3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 8d6:	83 c1 01             	add    $0x1,%ecx
 8d9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 8dc:	84 c0                	test   %al,%al
 8de:	74 10                	je     8f0 <strcmp+0x40>
 8e0:	38 d8                	cmp    %bl,%al
 8e2:	74 ec                	je     8d0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 8e4:	29 d8                	sub    %ebx,%eax
}
 8e6:	5b                   	pop    %ebx
 8e7:	5d                   	pop    %ebp
 8e8:	c3                   	ret    
 8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8f0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 8f2:	29 d8                	sub    %ebx,%eax
}
 8f4:	5b                   	pop    %ebx
 8f5:	5d                   	pop    %ebp
 8f6:	c3                   	ret    
 8f7:	89 f6                	mov    %esi,%esi
 8f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000900 <strlen>:

uint
strlen(char *s)
{
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 906:	80 39 00             	cmpb   $0x0,(%ecx)
 909:	74 15                	je     920 <strlen+0x20>
 90b:	31 d2                	xor    %edx,%edx
 90d:	8d 76 00             	lea    0x0(%esi),%esi
 910:	83 c2 01             	add    $0x1,%edx
 913:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 917:	89 d0                	mov    %edx,%eax
 919:	75 f5                	jne    910 <strlen+0x10>
    ;
  return n;
}
 91b:	5d                   	pop    %ebp
 91c:	c3                   	ret    
 91d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 920:	31 c0                	xor    %eax,%eax
}
 922:	5d                   	pop    %ebp
 923:	c3                   	ret    
 924:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 92a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000930 <memset>:

void*
memset(void *dst, int c, uint n)
{
 930:	55                   	push   %ebp
 931:	89 e5                	mov    %esp,%ebp
 933:	57                   	push   %edi
 934:	8b 55 08             	mov    0x8(%ebp),%edx
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
}
static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 937:	8b 4d 10             	mov    0x10(%ebp),%ecx
 93a:	8b 45 0c             	mov    0xc(%ebp),%eax
 93d:	89 d7                	mov    %edx,%edi
 93f:	fc                   	cld    
 940:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 942:	89 d0                	mov    %edx,%eax
 944:	5f                   	pop    %edi
 945:	5d                   	pop    %ebp
 946:	c3                   	ret    
 947:	89 f6                	mov    %esi,%esi
 949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000950 <strchr>:

char*
strchr(const char *s, char c)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	53                   	push   %ebx
 954:	8b 45 08             	mov    0x8(%ebp),%eax
 957:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 95a:	0f b6 10             	movzbl (%eax),%edx
 95d:	84 d2                	test   %dl,%dl
 95f:	74 1d                	je     97e <strchr+0x2e>
    if(*s == c)
 961:	38 d3                	cmp    %dl,%bl
 963:	89 d9                	mov    %ebx,%ecx
 965:	75 0d                	jne    974 <strchr+0x24>
 967:	eb 17                	jmp    980 <strchr+0x30>
 969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 970:	38 ca                	cmp    %cl,%dl
 972:	74 0c                	je     980 <strchr+0x30>
  for(; *s; s++)
 974:	83 c0 01             	add    $0x1,%eax
 977:	0f b6 10             	movzbl (%eax),%edx
 97a:	84 d2                	test   %dl,%dl
 97c:	75 f2                	jne    970 <strchr+0x20>
      return (char*)s;
  return 0;
 97e:	31 c0                	xor    %eax,%eax
}
 980:	5b                   	pop    %ebx
 981:	5d                   	pop    %ebp
 982:	c3                   	ret    
 983:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000990 <gets>:

char*
gets(char *buf, int max)
{
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	57                   	push   %edi
 994:	56                   	push   %esi
 995:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 996:	31 f6                	xor    %esi,%esi
 998:	89 f3                	mov    %esi,%ebx
{
 99a:	83 ec 1c             	sub    $0x1c,%esp
 99d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 9a0:	eb 2f                	jmp    9d1 <gets+0x41>
 9a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 9a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 9ab:	83 ec 04             	sub    $0x4,%esp
 9ae:	6a 01                	push   $0x1
 9b0:	50                   	push   %eax
 9b1:	6a 00                	push   $0x0
 9b3:	e8 32 01 00 00       	call   aea <read>
    if(cc < 1)
 9b8:	83 c4 10             	add    $0x10,%esp
 9bb:	85 c0                	test   %eax,%eax
 9bd:	7e 1c                	jle    9db <gets+0x4b>
      break;
    buf[i++] = c;
 9bf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 9c3:	83 c7 01             	add    $0x1,%edi
 9c6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 9c9:	3c 0a                	cmp    $0xa,%al
 9cb:	74 23                	je     9f0 <gets+0x60>
 9cd:	3c 0d                	cmp    $0xd,%al
 9cf:	74 1f                	je     9f0 <gets+0x60>
  for(i=0; i+1 < max; ){
 9d1:	83 c3 01             	add    $0x1,%ebx
 9d4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 9d7:	89 fe                	mov    %edi,%esi
 9d9:	7c cd                	jl     9a8 <gets+0x18>
 9db:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 9dd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 9e0:	c6 03 00             	movb   $0x0,(%ebx)
}
 9e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9e6:	5b                   	pop    %ebx
 9e7:	5e                   	pop    %esi
 9e8:	5f                   	pop    %edi
 9e9:	5d                   	pop    %ebp
 9ea:	c3                   	ret    
 9eb:	90                   	nop
 9ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9f0:	8b 75 08             	mov    0x8(%ebp),%esi
 9f3:	8b 45 08             	mov    0x8(%ebp),%eax
 9f6:	01 de                	add    %ebx,%esi
 9f8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 9fa:	c6 03 00             	movb   $0x0,(%ebx)
}
 9fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a00:	5b                   	pop    %ebx
 a01:	5e                   	pop    %esi
 a02:	5f                   	pop    %edi
 a03:	5d                   	pop    %ebp
 a04:	c3                   	ret    
 a05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a10 <stat>:

int
stat(char *n, struct stat *st)
{
 a10:	55                   	push   %ebp
 a11:	89 e5                	mov    %esp,%ebp
 a13:	56                   	push   %esi
 a14:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 a15:	83 ec 08             	sub    $0x8,%esp
 a18:	6a 00                	push   $0x0
 a1a:	ff 75 08             	pushl  0x8(%ebp)
 a1d:	e8 f0 00 00 00       	call   b12 <open>
  if(fd < 0)
 a22:	83 c4 10             	add    $0x10,%esp
 a25:	85 c0                	test   %eax,%eax
 a27:	78 27                	js     a50 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 a29:	83 ec 08             	sub    $0x8,%esp
 a2c:	ff 75 0c             	pushl  0xc(%ebp)
 a2f:	89 c3                	mov    %eax,%ebx
 a31:	50                   	push   %eax
 a32:	e8 f3 00 00 00       	call   b2a <fstat>
  close(fd);
 a37:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 a3a:	89 c6                	mov    %eax,%esi
  close(fd);
 a3c:	e8 b9 00 00 00       	call   afa <close>
  return r;
 a41:	83 c4 10             	add    $0x10,%esp
}
 a44:	8d 65 f8             	lea    -0x8(%ebp),%esp
 a47:	89 f0                	mov    %esi,%eax
 a49:	5b                   	pop    %ebx
 a4a:	5e                   	pop    %esi
 a4b:	5d                   	pop    %ebp
 a4c:	c3                   	ret    
 a4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 a50:	be ff ff ff ff       	mov    $0xffffffff,%esi
 a55:	eb ed                	jmp    a44 <stat+0x34>
 a57:	89 f6                	mov    %esi,%esi
 a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a60 <atoi>:

int
atoi(const char *s)
{
 a60:	55                   	push   %ebp
 a61:	89 e5                	mov    %esp,%ebp
 a63:	53                   	push   %ebx
 a64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 a67:	0f be 11             	movsbl (%ecx),%edx
 a6a:	8d 42 d0             	lea    -0x30(%edx),%eax
 a6d:	3c 09                	cmp    $0x9,%al
  n = 0;
 a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 a74:	77 1f                	ja     a95 <atoi+0x35>
 a76:	8d 76 00             	lea    0x0(%esi),%esi
 a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 a80:	8d 04 80             	lea    (%eax,%eax,4),%eax
 a83:	83 c1 01             	add    $0x1,%ecx
 a86:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 a8a:	0f be 11             	movsbl (%ecx),%edx
 a8d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 a90:	80 fb 09             	cmp    $0x9,%bl
 a93:	76 eb                	jbe    a80 <atoi+0x20>
  return n;
}
 a95:	5b                   	pop    %ebx
 a96:	5d                   	pop    %ebp
 a97:	c3                   	ret    
 a98:	90                   	nop
 a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000aa0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
 aa3:	56                   	push   %esi
 aa4:	53                   	push   %ebx
 aa5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 aa8:	8b 45 08             	mov    0x8(%ebp),%eax
 aab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 aae:	85 db                	test   %ebx,%ebx
 ab0:	7e 14                	jle    ac6 <memmove+0x26>
 ab2:	31 d2                	xor    %edx,%edx
 ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 ab8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 abc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 abf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 ac2:	39 d3                	cmp    %edx,%ebx
 ac4:	75 f2                	jne    ab8 <memmove+0x18>
  return vdst;
}
 ac6:	5b                   	pop    %ebx
 ac7:	5e                   	pop    %esi
 ac8:	5d                   	pop    %ebp
 ac9:	c3                   	ret    

00000aca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 aca:	b8 01 00 00 00       	mov    $0x1,%eax
 acf:	cd 40                	int    $0x40
 ad1:	c3                   	ret    

00000ad2 <exit>:
SYSCALL(exit)
 ad2:	b8 02 00 00 00       	mov    $0x2,%eax
 ad7:	cd 40                	int    $0x40
 ad9:	c3                   	ret    

00000ada <wait>:
SYSCALL(wait)
 ada:	b8 03 00 00 00       	mov    $0x3,%eax
 adf:	cd 40                	int    $0x40
 ae1:	c3                   	ret    

00000ae2 <pipe>:
SYSCALL(pipe)
 ae2:	b8 04 00 00 00       	mov    $0x4,%eax
 ae7:	cd 40                	int    $0x40
 ae9:	c3                   	ret    

00000aea <read>:
SYSCALL(read)
 aea:	b8 05 00 00 00       	mov    $0x5,%eax
 aef:	cd 40                	int    $0x40
 af1:	c3                   	ret    

00000af2 <write>:
SYSCALL(write)
 af2:	b8 10 00 00 00       	mov    $0x10,%eax
 af7:	cd 40                	int    $0x40
 af9:	c3                   	ret    

00000afa <close>:
SYSCALL(close)
 afa:	b8 15 00 00 00       	mov    $0x15,%eax
 aff:	cd 40                	int    $0x40
 b01:	c3                   	ret    

00000b02 <kill>:
SYSCALL(kill)
 b02:	b8 06 00 00 00       	mov    $0x6,%eax
 b07:	cd 40                	int    $0x40
 b09:	c3                   	ret    

00000b0a <exec>:
SYSCALL(exec)
 b0a:	b8 07 00 00 00       	mov    $0x7,%eax
 b0f:	cd 40                	int    $0x40
 b11:	c3                   	ret    

00000b12 <open>:
SYSCALL(open)
 b12:	b8 0f 00 00 00       	mov    $0xf,%eax
 b17:	cd 40                	int    $0x40
 b19:	c3                   	ret    

00000b1a <mknod>:
SYSCALL(mknod)
 b1a:	b8 11 00 00 00       	mov    $0x11,%eax
 b1f:	cd 40                	int    $0x40
 b21:	c3                   	ret    

00000b22 <unlink>:
SYSCALL(unlink)
 b22:	b8 12 00 00 00       	mov    $0x12,%eax
 b27:	cd 40                	int    $0x40
 b29:	c3                   	ret    

00000b2a <fstat>:
SYSCALL(fstat)
 b2a:	b8 08 00 00 00       	mov    $0x8,%eax
 b2f:	cd 40                	int    $0x40
 b31:	c3                   	ret    

00000b32 <link>:
SYSCALL(link)
 b32:	b8 13 00 00 00       	mov    $0x13,%eax
 b37:	cd 40                	int    $0x40
 b39:	c3                   	ret    

00000b3a <mkdir>:
SYSCALL(mkdir)
 b3a:	b8 14 00 00 00       	mov    $0x14,%eax
 b3f:	cd 40                	int    $0x40
 b41:	c3                   	ret    

00000b42 <chdir>:
SYSCALL(chdir)
 b42:	b8 09 00 00 00       	mov    $0x9,%eax
 b47:	cd 40                	int    $0x40
 b49:	c3                   	ret    

00000b4a <dup>:
SYSCALL(dup)
 b4a:	b8 0a 00 00 00       	mov    $0xa,%eax
 b4f:	cd 40                	int    $0x40
 b51:	c3                   	ret    

00000b52 <getpid>:
SYSCALL(getpid)
 b52:	b8 0b 00 00 00       	mov    $0xb,%eax
 b57:	cd 40                	int    $0x40
 b59:	c3                   	ret    

00000b5a <sbrk>:
SYSCALL(sbrk)
 b5a:	b8 0c 00 00 00       	mov    $0xc,%eax
 b5f:	cd 40                	int    $0x40
 b61:	c3                   	ret    

00000b62 <sleep>:
SYSCALL(sleep)
 b62:	b8 0d 00 00 00       	mov    $0xd,%eax
 b67:	cd 40                	int    $0x40
 b69:	c3                   	ret    

00000b6a <uptime>:
SYSCALL(uptime)
 b6a:	b8 0e 00 00 00       	mov    $0xe,%eax
 b6f:	cd 40                	int    $0x40
 b71:	c3                   	ret    

00000b72 <arp>:
SYSCALL(arp)
 b72:	b8 16 00 00 00       	mov    $0x16,%eax
 b77:	cd 40                	int    $0x40
 b79:	c3                   	ret    

00000b7a <connect>:
SYSCALL(connect)
 b7a:	b8 17 00 00 00       	mov    $0x17,%eax
 b7f:	cd 40                	int    $0x40
 b81:	c3                   	ret    
 b82:	66 90                	xchg   %ax,%ax
 b84:	66 90                	xchg   %ax,%ax
 b86:	66 90                	xchg   %ax,%ax
 b88:	66 90                	xchg   %ax,%ax
 b8a:	66 90                	xchg   %ax,%ax
 b8c:	66 90                	xchg   %ax,%ax
 b8e:	66 90                	xchg   %ax,%ax

00000b90 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 b90:	55                   	push   %ebp
 b91:	89 e5                	mov    %esp,%ebp
 b93:	57                   	push   %edi
 b94:	56                   	push   %esi
 b95:	53                   	push   %ebx
 b96:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 b99:	85 d2                	test   %edx,%edx
{
 b9b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 b9e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 ba0:	79 76                	jns    c18 <printint+0x88>
 ba2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 ba6:	74 70                	je     c18 <printint+0x88>
    x = -xx;
 ba8:	f7 d8                	neg    %eax
    neg = 1;
 baa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 bb1:	31 f6                	xor    %esi,%esi
 bb3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 bb6:	eb 0a                	jmp    bc2 <printint+0x32>
 bb8:	90                   	nop
 bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 bc0:	89 fe                	mov    %edi,%esi
 bc2:	31 d2                	xor    %edx,%edx
 bc4:	8d 7e 01             	lea    0x1(%esi),%edi
 bc7:	f7 f1                	div    %ecx
 bc9:	0f b6 92 08 12 00 00 	movzbl 0x1208(%edx),%edx
  }while((x /= base) != 0);
 bd0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 bd2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 bd5:	75 e9                	jne    bc0 <printint+0x30>
  if(neg)
 bd7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 bda:	85 c0                	test   %eax,%eax
 bdc:	74 08                	je     be6 <printint+0x56>
    buf[i++] = '-';
 bde:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 be3:	8d 7e 02             	lea    0x2(%esi),%edi
 be6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 bea:	8b 7d c0             	mov    -0x40(%ebp),%edi
 bed:	8d 76 00             	lea    0x0(%esi),%esi
 bf0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 bf3:	83 ec 04             	sub    $0x4,%esp
 bf6:	83 ee 01             	sub    $0x1,%esi
 bf9:	6a 01                	push   $0x1
 bfb:	53                   	push   %ebx
 bfc:	57                   	push   %edi
 bfd:	88 45 d7             	mov    %al,-0x29(%ebp)
 c00:	e8 ed fe ff ff       	call   af2 <write>

  while(--i >= 0)
 c05:	83 c4 10             	add    $0x10,%esp
 c08:	39 de                	cmp    %ebx,%esi
 c0a:	75 e4                	jne    bf0 <printint+0x60>
    putc(fd, buf[i]);
}
 c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 c0f:	5b                   	pop    %ebx
 c10:	5e                   	pop    %esi
 c11:	5f                   	pop    %edi
 c12:	5d                   	pop    %ebp
 c13:	c3                   	ret    
 c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 c18:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 c1f:	eb 90                	jmp    bb1 <printint+0x21>
 c21:	eb 0d                	jmp    c30 <printf>
 c23:	90                   	nop
 c24:	90                   	nop
 c25:	90                   	nop
 c26:	90                   	nop
 c27:	90                   	nop
 c28:	90                   	nop
 c29:	90                   	nop
 c2a:	90                   	nop
 c2b:	90                   	nop
 c2c:	90                   	nop
 c2d:	90                   	nop
 c2e:	90                   	nop
 c2f:	90                   	nop

00000c30 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c30:	55                   	push   %ebp
 c31:	89 e5                	mov    %esp,%ebp
 c33:	57                   	push   %edi
 c34:	56                   	push   %esi
 c35:	53                   	push   %ebx
 c36:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c39:	8b 75 0c             	mov    0xc(%ebp),%esi
 c3c:	0f b6 1e             	movzbl (%esi),%ebx
 c3f:	84 db                	test   %bl,%bl
 c41:	0f 84 b3 00 00 00    	je     cfa <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 c47:	8d 45 10             	lea    0x10(%ebp),%eax
 c4a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 c4d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 c4f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 c52:	eb 2f                	jmp    c83 <printf+0x53>
 c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 c58:	83 f8 25             	cmp    $0x25,%eax
 c5b:	0f 84 a7 00 00 00    	je     d08 <printf+0xd8>
  write(fd, &c, 1);
 c61:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 c64:	83 ec 04             	sub    $0x4,%esp
 c67:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 c6a:	6a 01                	push   $0x1
 c6c:	50                   	push   %eax
 c6d:	ff 75 08             	pushl  0x8(%ebp)
 c70:	e8 7d fe ff ff       	call   af2 <write>
 c75:	83 c4 10             	add    $0x10,%esp
 c78:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 c7b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 c7f:	84 db                	test   %bl,%bl
 c81:	74 77                	je     cfa <printf+0xca>
    if(state == 0){
 c83:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 c85:	0f be cb             	movsbl %bl,%ecx
 c88:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 c8b:	74 cb                	je     c58 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 c8d:	83 ff 25             	cmp    $0x25,%edi
 c90:	75 e6                	jne    c78 <printf+0x48>
      if(c == 'd'){
 c92:	83 f8 64             	cmp    $0x64,%eax
 c95:	0f 84 05 01 00 00    	je     da0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 c9b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 ca1:	83 f9 70             	cmp    $0x70,%ecx
 ca4:	74 72                	je     d18 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 ca6:	83 f8 73             	cmp    $0x73,%eax
 ca9:	0f 84 99 00 00 00    	je     d48 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 caf:	83 f8 63             	cmp    $0x63,%eax
 cb2:	0f 84 08 01 00 00    	je     dc0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 cb8:	83 f8 25             	cmp    $0x25,%eax
 cbb:	0f 84 ef 00 00 00    	je     db0 <printf+0x180>
  write(fd, &c, 1);
 cc1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 cc4:	83 ec 04             	sub    $0x4,%esp
 cc7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 ccb:	6a 01                	push   $0x1
 ccd:	50                   	push   %eax
 cce:	ff 75 08             	pushl  0x8(%ebp)
 cd1:	e8 1c fe ff ff       	call   af2 <write>
 cd6:	83 c4 0c             	add    $0xc,%esp
 cd9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 cdc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 cdf:	6a 01                	push   $0x1
 ce1:	50                   	push   %eax
 ce2:	ff 75 08             	pushl  0x8(%ebp)
 ce5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 ce8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 cea:	e8 03 fe ff ff       	call   af2 <write>
  for(i = 0; fmt[i]; i++){
 cef:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 cf3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 cf6:	84 db                	test   %bl,%bl
 cf8:	75 89                	jne    c83 <printf+0x53>
    }
  }
}
 cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 cfd:	5b                   	pop    %ebx
 cfe:	5e                   	pop    %esi
 cff:	5f                   	pop    %edi
 d00:	5d                   	pop    %ebp
 d01:	c3                   	ret    
 d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 d08:	bf 25 00 00 00       	mov    $0x25,%edi
 d0d:	e9 66 ff ff ff       	jmp    c78 <printf+0x48>
 d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 d18:	83 ec 0c             	sub    $0xc,%esp
 d1b:	b9 10 00 00 00       	mov    $0x10,%ecx
 d20:	6a 00                	push   $0x0
 d22:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 d25:	8b 45 08             	mov    0x8(%ebp),%eax
 d28:	8b 17                	mov    (%edi),%edx
 d2a:	e8 61 fe ff ff       	call   b90 <printint>
        ap++;
 d2f:	89 f8                	mov    %edi,%eax
 d31:	83 c4 10             	add    $0x10,%esp
      state = 0;
 d34:	31 ff                	xor    %edi,%edi
        ap++;
 d36:	83 c0 04             	add    $0x4,%eax
 d39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 d3c:	e9 37 ff ff ff       	jmp    c78 <printf+0x48>
 d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 d48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 d4b:	8b 08                	mov    (%eax),%ecx
        ap++;
 d4d:	83 c0 04             	add    $0x4,%eax
 d50:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 d53:	85 c9                	test   %ecx,%ecx
 d55:	0f 84 8e 00 00 00    	je     de9 <printf+0x1b9>
        while(*s != 0){
 d5b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 d5e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 d60:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 d62:	84 c0                	test   %al,%al
 d64:	0f 84 0e ff ff ff    	je     c78 <printf+0x48>
 d6a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 d6d:	89 de                	mov    %ebx,%esi
 d6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 d72:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 d75:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 d78:	83 ec 04             	sub    $0x4,%esp
          s++;
 d7b:	83 c6 01             	add    $0x1,%esi
 d7e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 d81:	6a 01                	push   $0x1
 d83:	57                   	push   %edi
 d84:	53                   	push   %ebx
 d85:	e8 68 fd ff ff       	call   af2 <write>
        while(*s != 0){
 d8a:	0f b6 06             	movzbl (%esi),%eax
 d8d:	83 c4 10             	add    $0x10,%esp
 d90:	84 c0                	test   %al,%al
 d92:	75 e4                	jne    d78 <printf+0x148>
 d94:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 d97:	31 ff                	xor    %edi,%edi
 d99:	e9 da fe ff ff       	jmp    c78 <printf+0x48>
 d9e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 da0:	83 ec 0c             	sub    $0xc,%esp
 da3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 da8:	6a 01                	push   $0x1
 daa:	e9 73 ff ff ff       	jmp    d22 <printf+0xf2>
 daf:	90                   	nop
  write(fd, &c, 1);
 db0:	83 ec 04             	sub    $0x4,%esp
 db3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 db6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 db9:	6a 01                	push   $0x1
 dbb:	e9 21 ff ff ff       	jmp    ce1 <printf+0xb1>
        putc(fd, *ap);
 dc0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 dc3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 dc6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 dc8:	6a 01                	push   $0x1
        ap++;
 dca:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 dcd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 dd0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 dd3:	50                   	push   %eax
 dd4:	ff 75 08             	pushl  0x8(%ebp)
 dd7:	e8 16 fd ff ff       	call   af2 <write>
        ap++;
 ddc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 ddf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 de2:	31 ff                	xor    %edi,%edi
 de4:	e9 8f fe ff ff       	jmp    c78 <printf+0x48>
          s = "(null)";
 de9:	bb 00 12 00 00       	mov    $0x1200,%ebx
        while(*s != 0){
 dee:	b8 28 00 00 00       	mov    $0x28,%eax
 df3:	e9 72 ff ff ff       	jmp    d6a <printf+0x13a>
 df8:	66 90                	xchg   %ax,%ax
 dfa:	66 90                	xchg   %ax,%ax
 dfc:	66 90                	xchg   %ax,%ax
 dfe:	66 90                	xchg   %ax,%ax

00000e00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e00:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e01:	a1 0c 15 00 00       	mov    0x150c,%eax
{
 e06:	89 e5                	mov    %esp,%ebp
 e08:	57                   	push   %edi
 e09:	56                   	push   %esi
 e0a:	53                   	push   %ebx
 e0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 e0e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e18:	39 c8                	cmp    %ecx,%eax
 e1a:	8b 10                	mov    (%eax),%edx
 e1c:	73 32                	jae    e50 <free+0x50>
 e1e:	39 d1                	cmp    %edx,%ecx
 e20:	72 04                	jb     e26 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e22:	39 d0                	cmp    %edx,%eax
 e24:	72 32                	jb     e58 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 e26:	8b 73 fc             	mov    -0x4(%ebx),%esi
 e29:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 e2c:	39 fa                	cmp    %edi,%edx
 e2e:	74 30                	je     e60 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 e30:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 e33:	8b 50 04             	mov    0x4(%eax),%edx
 e36:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 e39:	39 f1                	cmp    %esi,%ecx
 e3b:	74 3a                	je     e77 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 e3d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 e3f:	a3 0c 15 00 00       	mov    %eax,0x150c
}
 e44:	5b                   	pop    %ebx
 e45:	5e                   	pop    %esi
 e46:	5f                   	pop    %edi
 e47:	5d                   	pop    %ebp
 e48:	c3                   	ret    
 e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e50:	39 d0                	cmp    %edx,%eax
 e52:	72 04                	jb     e58 <free+0x58>
 e54:	39 d1                	cmp    %edx,%ecx
 e56:	72 ce                	jb     e26 <free+0x26>
{
 e58:	89 d0                	mov    %edx,%eax
 e5a:	eb bc                	jmp    e18 <free+0x18>
 e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 e60:	03 72 04             	add    0x4(%edx),%esi
 e63:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 e66:	8b 10                	mov    (%eax),%edx
 e68:	8b 12                	mov    (%edx),%edx
 e6a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 e6d:	8b 50 04             	mov    0x4(%eax),%edx
 e70:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 e73:	39 f1                	cmp    %esi,%ecx
 e75:	75 c6                	jne    e3d <free+0x3d>
    p->s.size += bp->s.size;
 e77:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 e7a:	a3 0c 15 00 00       	mov    %eax,0x150c
    p->s.size += bp->s.size;
 e7f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 e82:	8b 53 f8             	mov    -0x8(%ebx),%edx
 e85:	89 10                	mov    %edx,(%eax)
}
 e87:	5b                   	pop    %ebx
 e88:	5e                   	pop    %esi
 e89:	5f                   	pop    %edi
 e8a:	5d                   	pop    %ebp
 e8b:	c3                   	ret    
 e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000e90 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 e90:	55                   	push   %ebp
 e91:	89 e5                	mov    %esp,%ebp
 e93:	57                   	push   %edi
 e94:	56                   	push   %esi
 e95:	53                   	push   %ebx
 e96:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e99:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 e9c:	8b 15 0c 15 00 00    	mov    0x150c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ea2:	8d 78 07             	lea    0x7(%eax),%edi
 ea5:	c1 ef 03             	shr    $0x3,%edi
 ea8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 eab:	85 d2                	test   %edx,%edx
 ead:	0f 84 9d 00 00 00    	je     f50 <malloc+0xc0>
 eb3:	8b 02                	mov    (%edx),%eax
 eb5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 eb8:	39 cf                	cmp    %ecx,%edi
 eba:	76 6c                	jbe    f28 <malloc+0x98>
 ebc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 ec2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 ec7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 eca:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 ed1:	eb 0e                	jmp    ee1 <malloc+0x51>
 ed3:	90                   	nop
 ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ed8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 eda:	8b 48 04             	mov    0x4(%eax),%ecx
 edd:	39 f9                	cmp    %edi,%ecx
 edf:	73 47                	jae    f28 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ee1:	39 05 0c 15 00 00    	cmp    %eax,0x150c
 ee7:	89 c2                	mov    %eax,%edx
 ee9:	75 ed                	jne    ed8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 eeb:	83 ec 0c             	sub    $0xc,%esp
 eee:	56                   	push   %esi
 eef:	e8 66 fc ff ff       	call   b5a <sbrk>
  if(p == (char*)-1)
 ef4:	83 c4 10             	add    $0x10,%esp
 ef7:	83 f8 ff             	cmp    $0xffffffff,%eax
 efa:	74 1c                	je     f18 <malloc+0x88>
  hp->s.size = nu;
 efc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 eff:	83 ec 0c             	sub    $0xc,%esp
 f02:	83 c0 08             	add    $0x8,%eax
 f05:	50                   	push   %eax
 f06:	e8 f5 fe ff ff       	call   e00 <free>
  return freep;
 f0b:	8b 15 0c 15 00 00    	mov    0x150c,%edx
      if((p = morecore(nunits)) == 0)
 f11:	83 c4 10             	add    $0x10,%esp
 f14:	85 d2                	test   %edx,%edx
 f16:	75 c0                	jne    ed8 <malloc+0x48>
        return 0;
  }
}
 f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 f1b:	31 c0                	xor    %eax,%eax
}
 f1d:	5b                   	pop    %ebx
 f1e:	5e                   	pop    %esi
 f1f:	5f                   	pop    %edi
 f20:	5d                   	pop    %ebp
 f21:	c3                   	ret    
 f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 f28:	39 cf                	cmp    %ecx,%edi
 f2a:	74 54                	je     f80 <malloc+0xf0>
        p->s.size -= nunits;
 f2c:	29 f9                	sub    %edi,%ecx
 f2e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 f31:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 f34:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 f37:	89 15 0c 15 00 00    	mov    %edx,0x150c
}
 f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 f40:	83 c0 08             	add    $0x8,%eax
}
 f43:	5b                   	pop    %ebx
 f44:	5e                   	pop    %esi
 f45:	5f                   	pop    %edi
 f46:	5d                   	pop    %ebp
 f47:	c3                   	ret    
 f48:	90                   	nop
 f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 f50:	c7 05 0c 15 00 00 10 	movl   $0x1510,0x150c
 f57:	15 00 00 
 f5a:	c7 05 10 15 00 00 10 	movl   $0x1510,0x1510
 f61:	15 00 00 
    base.s.size = 0;
 f64:	b8 10 15 00 00       	mov    $0x1510,%eax
 f69:	c7 05 14 15 00 00 00 	movl   $0x0,0x1514
 f70:	00 00 00 
 f73:	e9 44 ff ff ff       	jmp    ebc <malloc+0x2c>
 f78:	90                   	nop
 f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 f80:	8b 08                	mov    (%eax),%ecx
 f82:	89 0a                	mov    %ecx,(%edx)
 f84:	eb b1                	jmp    f37 <malloc+0xa7>
