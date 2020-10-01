
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 60 3e 15 80       	mov    $0x80153e60,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 38 10 80       	mov    $0x801038f0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <block_until_arp_reply.isra.0>:
#include "arp_frame.h"
int 
e1000_receive(void *buff, size_t size);
void parse(char *packet);

static int block_until_arp_reply(struct ethr_hdr *arpReply) {
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	56                   	push   %esi
80100044:	53                   	push   %ebx
80100045:	8d 9d 10 fc ff ff    	lea    -0x3f0(%ebp),%ebx
8010004b:	be 0a 00 00 00       	mov    $0xa,%esi
80100050:	81 ec f0 03 00 00    	sub    $0x3f0,%esp
80100056:	8d 76 00             	lea    0x0(%esi),%esi
80100059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
   *      If received, unblock. else, sleep again.
   */
  char buff[1000]; 
int cnt =0;
do{
while (e1000_receive((void *)buff, 1000)<0);
80100060:	83 ec 08             	sub    $0x8,%esp
80100063:	68 e8 03 00 00       	push   $0x3e8
80100068:	53                   	push   %ebx
80100069:	e8 92 15 00 00       	call   80101600 <e1000_receive>
8010006e:	83 c4 10             	add    $0x10,%esp
80100071:	85 c0                	test   %eax,%eax
80100073:	78 eb                	js     80100060 <block_until_arp_reply.isra.0+0x20>
cprintf("got packet\n");
80100075:	83 ec 0c             	sub    $0xc,%esp
80100078:	68 e0 8c 10 80       	push   $0x80108ce0
8010007d:	e8 be 0b 00 00       	call   80100c40 <cprintf>

cprintf("after parse\n");
80100082:	c7 04 24 ec 8c 10 80 	movl   $0x80108cec,(%esp)
80100089:	e8 b2 0b 00 00       	call   80100c40 <cprintf>
cnt++;
}while (cnt <10);
8010008e:	83 c4 10             	add    $0x10,%esp
80100091:	83 ee 01             	sub    $0x1,%esi
80100094:	75 ca                	jne    80100060 <block_until_arp_reply.isra.0+0x20>

  return 0;
}
80100096:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100099:	31 c0                	xor    %eax,%eax
8010009b:	5b                   	pop    %ebx
8010009c:	5e                   	pop    %esi
8010009d:	5d                   	pop    %ebp
8010009e:	c3                   	ret    
8010009f:	90                   	nop

801000a0 <send_arpRequest>:


int 
e1000_transmit(const void *data, size_t len);
extern uint8_t mac_addr[6];
int send_arpRequest(char* interface, char* ipAddr, char* arpResp) {
801000a0:	55                   	push   %ebp
801000a1:	89 e5                	mov    %esp,%ebp
801000a3:	57                   	push   %edi
801000a4:	56                   	push   %esi
801000a5:	53                   	push   %ebx

  
  struct ethr_hdr eth;
  
  	
  create_eth_arp_frame(mac_addr, ipAddr, &eth);
801000a6:	8d 5d 90             	lea    -0x70(%ebp),%ebx
int send_arpRequest(char* interface, char* ipAddr, char* arpResp) {
801000a9:	83 ec 70             	sub    $0x70,%esp
801000ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  cprintf("Create arp request for ip:%s over Interface:%s\n", ipAddr, interface);
801000af:	ff 75 08             	pushl  0x8(%ebp)
int send_arpRequest(char* interface, char* ipAddr, char* arpResp) {
801000b2:	8b 7d 10             	mov    0x10(%ebp),%edi
  cprintf("Create arp request for ip:%s over Interface:%s\n", ipAddr, interface);
801000b5:	56                   	push   %esi
801000b6:	68 fc 8c 10 80       	push   $0x80108cfc
801000bb:	e8 80 0b 00 00       	call   80100c40 <cprintf>
  create_eth_arp_frame(mac_addr, ipAddr, &eth);
801000c0:	83 c4 0c             	add    $0xc,%esp
801000c3:	53                   	push   %ebx
801000c4:	56                   	push   %esi
801000c5:	68 4c 88 15 80       	push   $0x8015884c
801000ca:	e8 41 02 00 00       	call   80100310 <create_eth_arp_frame>
  e1000_transmit( (uint8_t*)&eth, sizeof(eth)-2); //sizeof(eth)-2 to remove padding. padding was necessary for alignment.
801000cf:	58                   	pop    %eax
801000d0:	5a                   	pop    %edx
801000d1:	6a 2a                	push   $0x2a
801000d3:	53                   	push   %ebx
801000d4:	e8 27 14 00 00       	call   80101500 <e1000_transmit>

  struct ethr_hdr arpResponse;
  if(block_until_arp_reply(&arpResponse) < 0) {
801000d9:	e8 62 ff ff ff       	call   80100040 <block_until_arp_reply.isra.0>
801000de:	83 c4 10             	add    $0x10,%esp
801000e1:	85 c0                	test   %eax,%eax
801000e3:	78 23                	js     80100108 <send_arpRequest+0x68>
    cprintf("ERROR:send_arpRequest:Failed to recv ARP response over the NIC\n");
    return -3;
  }

  unpack_mac(arpResponse.arp_dmac, arpResp);
801000e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
801000e8:	83 ec 08             	sub    $0x8,%esp
801000eb:	57                   	push   %edi
801000ec:	50                   	push   %eax
801000ed:	e8 fe 02 00 00       	call   801003f0 <unpack_mac>
  arpResp[17] = '\0';
801000f2:	c6 47 11 00          	movb   $0x0,0x11(%edi)

  return 0;
801000f6:	83 c4 10             	add    $0x10,%esp
801000f9:	31 c0                	xor    %eax,%eax
}
801000fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000fe:	5b                   	pop    %ebx
801000ff:	5e                   	pop    %esi
80100100:	5f                   	pop    %edi
80100101:	5d                   	pop    %ebp
80100102:	c3                   	ret    
80100103:	90                   	nop
80100104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("ERROR:send_arpRequest:Failed to recv ARP response over the NIC\n");
80100108:	83 ec 0c             	sub    $0xc,%esp
8010010b:	68 2c 8d 10 80       	push   $0x80108d2c
80100110:	e8 2b 0b 00 00       	call   80100c40 <cprintf>
    return -3;
80100115:	83 c4 10             	add    $0x10,%esp
80100118:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
8010011d:	eb dc                	jmp    801000fb <send_arpRequest+0x5b>
8010011f:	90                   	nop

80100120 <hex_to_int>:
#include "defs.h"
#include "arp_frame.h"

#define BROADCAST_MAC "00:00:00:00:00:00";//"FF:FF:FF:FF:FF:FF"

int hex_to_int (char ch) {
80100120:	55                   	push   %ebp
80100121:	89 e5                	mov    %esp,%ebp
80100123:	8b 45 08             	mov    0x8(%ebp),%eax

	uint i = 0;

	if (ch >= '0' && ch <= '9') {
80100126:	8d 50 d0             	lea    -0x30(%eax),%edx
80100129:	80 fa 09             	cmp    $0x9,%dl
8010012c:	76 32                	jbe    80100160 <hex_to_int+0x40>
		i = ch - '0';
	}
	else if (ch >= 'A' && ch <= 'F') {
8010012e:	8d 50 bf             	lea    -0x41(%eax),%edx
80100131:	80 fa 05             	cmp    $0x5,%dl
80100134:	76 1a                	jbe    80100150 <hex_to_int+0x30>
		i = 10 + (ch - 'A');
	}
	else if (ch >= 'a' && ch <= 'f') {
80100136:	8d 50 9f             	lea    -0x61(%eax),%edx
		i = 10 + (ch - 'a');
80100139:	0f be c0             	movsbl %al,%eax
8010013c:	83 e8 57             	sub    $0x57,%eax
8010013f:	80 fa 06             	cmp    $0x6,%dl
80100142:	ba 00 00 00 00       	mov    $0x0,%edx
80100147:	0f 43 c2             	cmovae %edx,%eax
	}

	return i;
}
8010014a:	5d                   	pop    %ebp
8010014b:	c3                   	ret    
8010014c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		i = 10 + (ch - 'A');
80100150:	0f be c0             	movsbl %al,%eax
80100153:	83 e8 37             	sub    $0x37,%eax
}
80100156:	5d                   	pop    %ebp
80100157:	c3                   	ret    
80100158:	90                   	nop
80100159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		i = ch - '0';
80100160:	0f be c0             	movsbl %al,%eax
80100163:	83 e8 30             	sub    $0x30,%eax
}
80100166:	5d                   	pop    %ebp
80100167:	c3                   	ret    
80100168:	90                   	nop
80100169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100170 <pack_mac>:

/**
 * Pack the XX:Xx:XX:XX:XX:XX representation of MAC address
 * into I:I:I:I:I:I
 */
void pack_mac(uchar* dest, char* src) {
80100170:	55                   	push   %ebp
80100171:	89 e5                	mov    %esp,%ebp
80100173:	57                   	push   %edi
80100174:	56                   	push   %esi
80100175:	53                   	push   %ebx
80100176:	83 ec 08             	sub    $0x8,%esp
80100179:	8b 55 0c             	mov    0xc(%ebp),%edx
8010017c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010017f:	8d 42 12             	lea    0x12(%edx),%eax
80100182:	89 5d f0             	mov    %ebx,-0x10(%ebp)
80100185:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100188:	eb 1f                	jmp    801001a9 <pack_mac+0x39>
8010018a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100190:	8d 44 30 d0          	lea    -0x30(%eax,%esi,1),%eax
	for (int i = 0, j = 0; i < 17; i += 3) {
		uint i1 = hex_to_int(src[i]);
		uint i2 = hex_to_int(src[i+1]);
		dest[j++] = (i1<<4) + i2;
80100194:	8b 7d f0             	mov    -0x10(%ebp),%edi
80100197:	83 c2 03             	add    $0x3,%edx
8010019a:	88 07                	mov    %al,(%edi)
8010019c:	89 f8                	mov    %edi,%eax
8010019e:	83 c0 01             	add    $0x1,%eax
	for (int i = 0, j = 0; i < 17; i += 3) {
801001a1:	39 55 ec             	cmp    %edx,-0x14(%ebp)
801001a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801001a7:	74 7f                	je     80100228 <pack_mac+0xb8>
		uint i1 = hex_to_int(src[i]);
801001a9:	0f be 02             	movsbl (%edx),%eax
	if (ch >= '0' && ch <= '9') {
801001ac:	8d 70 d0             	lea    -0x30(%eax),%esi
		uint i1 = hex_to_int(src[i]);
801001af:	89 c1                	mov    %eax,%ecx
	if (ch >= '0' && ch <= '9') {
801001b1:	89 f3                	mov    %esi,%ebx
801001b3:	80 fb 09             	cmp    $0x9,%bl
801001b6:	76 0d                	jbe    801001c5 <pack_mac+0x55>
	else if (ch >= 'A' && ch <= 'F') {
801001b8:	8d 70 bf             	lea    -0x41(%eax),%esi
801001bb:	89 f3                	mov    %esi,%ebx
801001bd:	80 fb 05             	cmp    $0x5,%bl
801001c0:	77 2e                	ja     801001f0 <pack_mac+0x80>
		i = 10 + (ch - 'A');
801001c2:	83 e8 37             	sub    $0x37,%eax
801001c5:	c1 e0 04             	shl    $0x4,%eax
		uint i2 = hex_to_int(src[i+1]);
801001c8:	0f be 72 01          	movsbl 0x1(%edx),%esi
	if (ch >= '0' && ch <= '9') {
801001cc:	8d 7e d0             	lea    -0x30(%esi),%edi
		uint i2 = hex_to_int(src[i+1]);
801001cf:	89 f1                	mov    %esi,%ecx
	if (ch >= '0' && ch <= '9') {
801001d1:	89 fb                	mov    %edi,%ebx
801001d3:	80 fb 09             	cmp    $0x9,%bl
801001d6:	76 b8                	jbe    80100190 <pack_mac+0x20>
	else if (ch >= 'A' && ch <= 'F') {
801001d8:	8d 7e bf             	lea    -0x41(%esi),%edi
801001db:	89 fb                	mov    %edi,%ebx
801001dd:	80 fb 05             	cmp    $0x5,%bl
801001e0:	77 2e                	ja     80100210 <pack_mac+0xa0>
801001e2:	8d 44 30 c9          	lea    -0x37(%eax,%esi,1),%eax
801001e6:	eb ac                	jmp    80100194 <pack_mac+0x24>
801001e8:	90                   	nop
801001e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001f0:	83 e8 57             	sub    $0x57,%eax
	else if (ch >= 'a' && ch <= 'f') {
801001f3:	83 e9 61             	sub    $0x61,%ecx
801001f6:	bb 00 00 00 00       	mov    $0x0,%ebx
801001fb:	c1 e0 04             	shl    $0x4,%eax
801001fe:	80 f9 06             	cmp    $0x6,%cl
80100201:	0f 43 c3             	cmovae %ebx,%eax
80100204:	eb c2                	jmp    801001c8 <pack_mac+0x58>
80100206:	8d 76 00             	lea    0x0(%esi),%esi
80100209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80100210:	83 e9 61             	sub    $0x61,%ecx
80100213:	8d 74 30 a9          	lea    -0x57(%eax,%esi,1),%esi
80100217:	80 f9 06             	cmp    $0x6,%cl
8010021a:	0f 42 c6             	cmovb  %esi,%eax
8010021d:	e9 72 ff ff ff       	jmp    80100194 <pack_mac+0x24>
80100222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	}
}
80100228:	83 c4 08             	add    $0x8,%esp
8010022b:	5b                   	pop    %ebx
8010022c:	5e                   	pop    %esi
8010022d:	5f                   	pop    %edi
8010022e:	5d                   	pop    %ebp
8010022f:	c3                   	ret    

80100230 <get_ip>:

uint32_t get_ip (char* ip, uint len) {
80100230:	55                   	push   %ebp
80100231:	89 e5                	mov    %esp,%ebp
80100233:	57                   	push   %edi
80100234:	56                   	push   %esi
80100235:	53                   	push   %ebx
80100236:	83 ec 3c             	sub    $0x3c,%esp
80100239:	8b 75 0c             	mov    0xc(%ebp),%esi
    int n1 = 0;

     uint ip_vals[4];
     int n2 = 0;

     for (int i =0; i<len; i++) {
8010023c:	85 f6                	test   %esi,%esi
8010023e:	0f 84 8c 00 00 00    	je     801002d0 <get_ip+0xa0>
80100244:	8b 5d 08             	mov    0x8(%ebp),%ebx
     int n2 = 0;
80100247:	31 ff                	xor    %edi,%edi
    int n1 = 0;
80100249:	31 c0                	xor    %eax,%eax
8010024b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
8010024e:	01 de                	add    %ebx,%esi
80100250:	eb 14                	jmp    80100266 <get_ip+0x36>
80100252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100258:	83 c3 01             	add    $0x1,%ebx
            n1 = 0;
            ip_vals[n2++] = atoi(arr);
       	    //cprintf("Check ipval:%d , arr:%s",ip_vals[n2],arr);
	} else {

		arr[n1++] = ch;
8010025b:	88 4c 05 d4          	mov    %cl,-0x2c(%ebp,%eax,1)
8010025f:	83 c0 01             	add    $0x1,%eax
     for (int i =0; i<len; i++) {
80100262:	39 de                	cmp    %ebx,%esi
80100264:	74 2f                	je     80100295 <get_ip+0x65>
        char ch = ip[i];
80100266:	0f b6 0b             	movzbl (%ebx),%ecx
        if (ch == '.') {
80100269:	80 f9 2e             	cmp    $0x2e,%cl
8010026c:	75 ea                	jne    80100258 <get_ip+0x28>
            ip_vals[n2++] = atoi(arr);
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	83 c3 01             	add    $0x1,%ebx
80100274:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80100277:	52                   	push   %edx
            arr[n1++] = '\0';
80100278:	c6 44 05 d4 00       	movb   $0x0,-0x2c(%ebp,%eax,1)
            ip_vals[n2++] = atoi(arr);
8010027d:	e8 2e 76 00 00       	call   801078b0 <atoi>
80100282:	83 c4 10             	add    $0x10,%esp
80100285:	89 44 bd d8          	mov    %eax,-0x28(%ebp,%edi,4)
80100289:	83 c7 01             	add    $0x1,%edi
            n1 = 0;
8010028c:	31 c0                	xor    %eax,%eax
     for (int i =0; i<len; i++) {
8010028e:	39 de                	cmp    %ebx,%esi
80100290:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80100293:	75 d1                	jne    80100266 <get_ip+0x36>
	}
    }

        arr[n1++] = '\0';
        n1 = 0;
        ip_vals[n2++] = atoi(arr);
80100295:	83 ec 0c             	sub    $0xc,%esp
        arr[n1++] = '\0';
80100298:	c6 44 05 d4 00       	movb   $0x0,-0x2c(%ebp,%eax,1)
        ip_vals[n2++] = atoi(arr);
8010029d:	52                   	push   %edx
8010029e:	e8 0d 76 00 00       	call   801078b0 <atoi>
801002a3:	89 44 bd d8          	mov    %eax,-0x28(%ebp,%edi,4)
        //cprintf("Final Check ipval:%d , arr:%s",ip_vals[n2],arr);

//	ipv4 = (ip_vals[0]<<24) + (ip_vals[1]<<16) + (ip_vals[2]<<8) + ip_vals[3];
	ipv4 = (ip_vals[3]<<24) + (ip_vals[2]<<16) + (ip_vals[1]<<8) + ip_vals[0];
801002a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801002aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
801002ad:	c1 e0 18             	shl    $0x18,%eax
801002b0:	c1 e2 10             	shl    $0x10,%edx
801002b3:	01 d0                	add    %edx,%eax
801002b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801002b8:	03 45 d8             	add    -0x28(%ebp),%eax
    return ipv4;
}
801002bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
	ipv4 = (ip_vals[3]<<24) + (ip_vals[2]<<16) + (ip_vals[1]<<8) + ip_vals[0];
801002be:	c1 e2 08             	shl    $0x8,%edx
}
801002c1:	5b                   	pop    %ebx
	ipv4 = (ip_vals[3]<<24) + (ip_vals[2]<<16) + (ip_vals[1]<<8) + ip_vals[0];
801002c2:	01 d0                	add    %edx,%eax
}
801002c4:	5e                   	pop    %esi
801002c5:	5f                   	pop    %edi
801002c6:	5d                   	pop    %ebp
801002c7:	c3                   	ret    
801002c8:	90                   	nop
801002c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     int n2 = 0;
801002d0:	31 ff                	xor    %edi,%edi
    int n1 = 0;
801002d2:	31 c0                	xor    %eax,%eax
801002d4:	8d 55 d4             	lea    -0x2c(%ebp),%edx
801002d7:	eb bc                	jmp    80100295 <get_ip+0x65>
801002d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801002e0 <htons>:
uint16_t htons(uint16_t v) {
801002e0:	55                   	push   %ebp
801002e1:	89 e5                	mov    %esp,%ebp
  return (v >> 8) | (v << 8);
801002e3:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
}
801002e7:	5d                   	pop    %ebp
  return (v >> 8) | (v << 8);
801002e8:	66 c1 c0 08          	rol    $0x8,%ax
}
801002ec:	c3                   	ret    
801002ed:	8d 76 00             	lea    0x0(%esi),%esi

801002f0 <htonl>:
uint32_t htonl(uint32_t v) {
801002f0:	55                   	push   %ebp
801002f1:	89 e5                	mov    %esp,%ebp
801002f3:	8b 55 08             	mov    0x8(%ebp),%edx
  return htons(v >> 16) | (htons((uint16_t) v) << 16);
}
801002f6:	5d                   	pop    %ebp
  return (v >> 8) | (v << 8);
801002f7:	89 d0                	mov    %edx,%eax
  return htons(v >> 16) | (htons((uint16_t) v) << 16);
801002f9:	c1 ea 10             	shr    $0x10,%edx
  return (v >> 8) | (v << 8);
801002fc:	66 c1 c0 08          	rol    $0x8,%ax
  return htons(v >> 16) | (htons((uint16_t) v) << 16);
80100300:	66 c1 c2 08          	rol    $0x8,%dx
80100304:	89 c1                	mov    %eax,%ecx
80100306:	0f b7 c2             	movzwl %dx,%eax
80100309:	c1 e1 10             	shl    $0x10,%ecx
8010030c:	09 c8                	or     %ecx,%eax
}
8010030e:	c3                   	ret    
8010030f:	90                   	nop

80100310 <create_eth_arp_frame>:

int create_eth_arp_frame(uint8_t* smac, char* ipAddr, struct ethr_hdr *eth) {
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
80100313:	57                   	push   %edi
80100314:	56                   	push   %esi
80100315:	53                   	push   %ebx
80100316:	83 ec 18             	sub    $0x18,%esp
80100319:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010031c:	8b 7d 08             	mov    0x8(%ebp),%edi
	cprintf("Create ARP frame\n");
8010031f:	68 6c 8d 10 80       	push   $0x80108d6c
int create_eth_arp_frame(uint8_t* smac, char* ipAddr, struct ethr_hdr *eth) {
80100324:	8b 75 0c             	mov    0xc(%ebp),%esi
	cprintf("Create ARP frame\n");
80100327:	e8 14 09 00 00       	call   80100c40 <cprintf>
	char* dmac = BROADCAST_MAC;
   char * sipAddr = "10.0.2.15";

	pack_mac(eth->dmac, dmac);
8010032c:	58                   	pop    %eax
8010032d:	5a                   	pop    %edx
8010032e:	68 7e 8d 10 80       	push   $0x80108d7e
80100333:	53                   	push   %ebx
80100334:	e8 37 fe ff ff       	call   80100170 <pack_mac>
	memmove(eth->smac, smac, 6);
80100339:	8d 43 06             	lea    0x6(%ebx),%eax
8010033c:	83 c4 0c             	add    $0xc,%esp
8010033f:	6a 06                	push   $0x6
80100341:	57                   	push   %edi
80100342:	50                   	push   %eax
80100343:	e8 c8 58 00 00       	call   80105c10 <memmove>

	//arp request
	eth->opcode = htons(1);

	/** ARP packet internal data filling **/
	memmove(eth->arp_smac, smac, 6);
80100348:	8d 43 16             	lea    0x16(%ebx),%eax
8010034b:	83 c4 0c             	add    $0xc,%esp
	eth->prosize = 0x04;
8010034e:	b9 00 01 00 00       	mov    $0x100,%ecx
80100353:	66 89 4b 14          	mov    %cx,0x14(%ebx)
	eth->ethr_type = htons(0x0806);
80100357:	c7 43 0c 08 06 00 01 	movl   $0x1000608,0xc(%ebx)
	eth->hwtype = htons(1);
8010035e:	c7 43 10 08 00 06 04 	movl   $0x4060008,0x10(%ebx)
	memmove(eth->arp_smac, smac, 6);
80100365:	6a 06                	push   $0x6
80100367:	57                   	push   %edi
80100368:	50                   	push   %eax
80100369:	e8 a2 58 00 00       	call   80105c10 <memmove>
	pack_mac(eth->arp_dmac, dmac); //this can potentially be igored for the request
8010036e:	5f                   	pop    %edi
8010036f:	58                   	pop    %eax
80100370:	8d 43 20             	lea    0x20(%ebx),%eax
80100373:	68 7e 8d 10 80       	push   $0x80108d7e
80100378:	50                   	push   %eax
80100379:	e8 f2 fd ff ff       	call   80100170 <pack_mac>

	eth->sip = get_ip(sipAddr, strlen(sipAddr));
8010037e:	c7 04 24 90 8d 10 80 	movl   $0x80108d90,(%esp)
80100385:	e8 f6 59 00 00       	call   80105d80 <strlen>
8010038a:	5a                   	pop    %edx
8010038b:	59                   	pop    %ecx
8010038c:	50                   	push   %eax
8010038d:	68 90 8d 10 80       	push   $0x80108d90
80100392:	e8 99 fe ff ff       	call   80100230 <get_ip>
80100397:	89 43 1c             	mov    %eax,0x1c(%ebx)

	*(uint32_t*)(&eth->dip) = get_ip(ipAddr, strlen(ipAddr));
8010039a:	89 34 24             	mov    %esi,(%esp)
8010039d:	e8 de 59 00 00       	call   80105d80 <strlen>
801003a2:	5f                   	pop    %edi
801003a3:	5a                   	pop    %edx
801003a4:	50                   	push   %eax
801003a5:	56                   	push   %esi
801003a6:	e8 85 fe ff ff       	call   80100230 <get_ip>
801003ab:	89 43 26             	mov    %eax,0x26(%ebx)

	return 0;
}
801003ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801003b1:	31 c0                	xor    %eax,%eax
801003b3:	5b                   	pop    %ebx
801003b4:	5e                   	pop    %esi
801003b5:	5f                   	pop    %edi
801003b6:	5d                   	pop    %ebp
801003b7:	c3                   	ret    
801003b8:	90                   	nop
801003b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801003c0 <int_to_hex>:


char int_to_hex (uint n) {
801003c0:	55                   	push   %ebp
801003c1:	89 e5                	mov    %esp,%ebp
801003c3:	8b 45 08             	mov    0x8(%ebp),%eax

    char ch = '0';

    if (n >= 0 && n <= 9) {
801003c6:	83 f8 09             	cmp    $0x9,%eax
801003c9:	76 15                	jbe    801003e0 <int_to_hex+0x20>
        ch = '0' + n;
    }
    else if (n >= 10 && n <= 15) {
801003cb:	8d 50 f6             	lea    -0xa(%eax),%edx
        ch = 'A' + (n - 10);
801003ce:	83 c0 37             	add    $0x37,%eax
    }

    return ch;

}
801003d1:	5d                   	pop    %ebp
        ch = 'A' + (n - 10);
801003d2:	83 fa 06             	cmp    $0x6,%edx
801003d5:	ba 30 00 00 00       	mov    $0x30,%edx
801003da:	0f 43 c2             	cmovae %edx,%eax
}
801003dd:	c3                   	ret    
801003de:	66 90                	xchg   %ax,%ax
        ch = '0' + n;
801003e0:	83 c0 30             	add    $0x30,%eax
}
801003e3:	5d                   	pop    %ebp
801003e4:	c3                   	ret    
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <unpack_mac>:
// parse the mac address
void unpack_mac(uint8_t* mac, char* mac_str) {
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	83 ec 04             	sub    $0x4,%esp
801003f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801003fc:	8b 75 08             	mov    0x8(%ebp),%esi
801003ff:	89 d0                	mov    %edx,%eax
80100401:	83 c0 12             	add    $0x12,%eax
80100404:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100407:	89 f6                	mov    %esi,%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    int c = 0;

    for (int i = 0; i < 6; i++) {
        uint m = mac[i];
80100410:	0f b6 06             	movzbl (%esi),%eax
        uint i1 = (m & 0xf0)>>4;

        mac_str[c++] = int_to_hex(i1);
        mac_str[c++] = int_to_hex(i2);

        mac_str[c++] = ':';
80100413:	c6 42 02 3a          	movb   $0x3a,0x2(%edx)
80100417:	89 c1                	mov    %eax,%ecx
        uint i1 = (m & 0xf0)>>4;
80100419:	c1 e8 04             	shr    $0x4,%eax
        ch = '0' + n;
8010041c:	8d 78 30             	lea    0x30(%eax),%edi
8010041f:	8d 58 37             	lea    0x37(%eax),%ebx
80100422:	83 e1 0f             	and    $0xf,%ecx
80100425:	83 f8 09             	cmp    $0x9,%eax
        ch = 'A' + (n - 10);
80100428:	8d 41 30             	lea    0x30(%ecx),%eax
        ch = '0' + n;
8010042b:	0f 46 df             	cmovbe %edi,%ebx
        ch = 'A' + (n - 10);
8010042e:	80 f9 0a             	cmp    $0xa,%cl
        mac_str[c++] = int_to_hex(i1);
80100431:	88 1a                	mov    %bl,(%edx)
        ch = 'A' + (n - 10);
80100433:	8d 59 37             	lea    0x37(%ecx),%ebx
80100436:	0f 43 c3             	cmovae %ebx,%eax
80100439:	83 c6 01             	add    $0x1,%esi
8010043c:	83 c2 03             	add    $0x3,%edx
        mac_str[c++] = int_to_hex(i2);
8010043f:	88 42 fe             	mov    %al,-0x2(%edx)
    for (int i = 0; i < 6; i++) {
80100442:	39 55 f0             	cmp    %edx,-0x10(%ebp)
80100445:	75 c9                	jne    80100410 <unpack_mac+0x20>
    }

    mac_str[c-1] = '\0';
80100447:	8b 45 0c             	mov    0xc(%ebp),%eax
8010044a:	c6 40 11 00          	movb   $0x0,0x11(%eax)

}
8010044e:	83 c4 04             	add    $0x4,%esp
80100451:	5b                   	pop    %ebx
80100452:	5e                   	pop    %esi
80100453:	5f                   	pop    %edi
80100454:	5d                   	pop    %ebp
80100455:	c3                   	ret    
80100456:	8d 76 00             	lea    0x0(%esi),%esi
80100459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100460 <parse_ip>:

// parse the ip value
void parse_ip (uint ip, char* ip_str) {
80100460:	55                   	push   %ebp

    uint v = 255;
    uint ip_vals[4];

    for (int i = 0; i >= 0; i--) {
        ip_vals[i] = ip && v;
80100461:	31 c9                	xor    %ecx,%ecx
void parse_ip (uint ip, char* ip_str) {
80100463:	89 e5                	mov    %esp,%ebp
80100465:	57                   	push   %edi
80100466:	56                   	push   %esi
80100467:	53                   	push   %ebx
80100468:	8d 75 e4             	lea    -0x1c(%ebp),%esi
8010046b:	83 ec 24             	sub    $0x24,%esp
        ip_vals[i] = ip && v;
8010046e:	8b 45 08             	mov    0x8(%ebp),%eax
80100471:	85 c0                	test   %eax,%eax
80100473:	0f 95 c1             	setne  %cl
        v  = v<<8;
    }

    int c = 0;
80100476:	31 ff                	xor    %edi,%edi
    for (int i = 0; i < 4; i++) {
        uint ip1 = ip_vals[i];

        if (ip1 == 0) {
80100478:	85 c9                	test   %ecx,%ecx
        ip_vals[i] = ip && v;
8010047a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
        if (ip1 == 0) {
8010047d:	75 21                	jne    801004a0 <parse_ip+0x40>
            ip_str[c++] = '0';
8010047f:	8b 45 0c             	mov    0xc(%ebp),%eax
    for (int i = 0; i < 4; i++) {
80100482:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80100485:	83 c6 04             	add    $0x4,%esi
            ip_str[c++] = '0';
80100488:	c6 04 38 30          	movb   $0x30,(%eax,%edi,1)
            ip_str[c++] = ':';
8010048c:	c6 44 38 01 3a       	movb   $0x3a,0x1(%eax,%edi,1)
80100491:	83 c7 02             	add    $0x2,%edi
    for (int i = 0; i < 4; i++) {
80100494:	39 de                	cmp    %ebx,%esi
            ip_str[c++] = ':';
80100496:	89 f8                	mov    %edi,%eax
    for (int i = 0; i < 4; i++) {
80100498:	74 7a                	je     80100514 <parse_ip+0xb4>
8010049a:	8b 0e                	mov    (%esi),%ecx
        if (ip1 == 0) {
8010049c:	85 c9                	test   %ecx,%ecx
8010049e:	74 df                	je     8010047f <parse_ip+0x1f>
        }
        else {
            //unsigned int n_digits = 0;
            char arr[3];
            int j = 0;
801004a0:	31 db                	xor    %ebx,%ebx
801004a2:	89 7d d0             	mov    %edi,-0x30(%ebp)

            while (ip1 > 0) {
                arr[j++] = (ip1 % 10) + '0';
801004a5:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
801004aa:	8d 7b 01             	lea    0x1(%ebx),%edi
801004ad:	f7 e1                	mul    %ecx
801004af:	c1 ea 03             	shr    $0x3,%edx
801004b2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004b5:	01 c0                	add    %eax,%eax
801004b7:	29 c1                	sub    %eax,%ecx
            while (ip1 > 0) {
801004b9:	85 d2                	test   %edx,%edx
                arr[j++] = (ip1 % 10) + '0';
801004bb:	8d 41 30             	lea    0x30(%ecx),%eax
                ip1 /= 10;
801004be:	89 d1                	mov    %edx,%ecx
                arr[j++] = (ip1 % 10) + '0';
801004c0:	88 44 3d e0          	mov    %al,-0x20(%ebp,%edi,1)
            while (ip1 > 0) {
801004c4:	74 0a                	je     801004d0 <parse_ip+0x70>
                arr[j++] = (ip1 % 10) + '0';
801004c6:	89 fb                	mov    %edi,%ebx
801004c8:	eb db                	jmp    801004a5 <parse_ip+0x45>
801004ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801004d0:	8b 7d d0             	mov    -0x30(%ebp),%edi
801004d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
            while (ip1 > 0) {
801004d6:	89 da                	mov    %ebx,%edx
            }

            for (j = j-1; j >= 0; j--) {
801004d8:	83 ea 01             	sub    $0x1,%edx
801004db:	01 f9                	add    %edi,%ecx
                ip_str[c++] = arr[j];
801004dd:	88 01                	mov    %al,(%ecx)
801004df:	83 c1 01             	add    $0x1,%ecx
            for (j = j-1; j >= 0; j--) {
801004e2:	83 fa ff             	cmp    $0xffffffff,%edx
801004e5:	74 13                	je     801004fa <parse_ip+0x9a>
801004e7:	0f b6 44 15 e1       	movzbl -0x1f(%ebp,%edx,1),%eax
801004ec:	83 ea 01             	sub    $0x1,%edx
801004ef:	83 c1 01             	add    $0x1,%ecx
                ip_str[c++] = arr[j];
801004f2:	88 41 ff             	mov    %al,-0x1(%ecx)
            for (j = j-1; j >= 0; j--) {
801004f5:	83 fa ff             	cmp    $0xffffffff,%edx
801004f8:	75 ed                	jne    801004e7 <parse_ip+0x87>
801004fa:	8d 54 1f 01          	lea    0x1(%edi,%ebx,1),%edx
            }

            ip_str[c++] = ':';
801004fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100501:	83 c6 04             	add    $0x4,%esi
80100504:	8d 7a 01             	lea    0x1(%edx),%edi
80100507:	c6 04 13 3a          	movb   $0x3a,(%ebx,%edx,1)
    for (int i = 0; i < 4; i++) {
8010050b:	8d 5d f4             	lea    -0xc(%ebp),%ebx
8010050e:	89 f8                	mov    %edi,%eax
80100510:	39 de                	cmp    %ebx,%esi
80100512:	75 86                	jne    8010049a <parse_ip+0x3a>
        }
    }

    ip_str[c-1] = '\0';
80100514:	8b 75 0c             	mov    0xc(%ebp),%esi
80100517:	c6 44 06 ff 00       	movb   $0x0,-0x1(%esi,%eax,1)

}
8010051c:	83 c4 24             	add    $0x24,%esp
8010051f:	5b                   	pop    %ebx
80100520:	5e                   	pop    %esi
80100521:	5f                   	pop    %edi
80100522:	5d                   	pop    %ebp
80100523:	c3                   	ret    
80100524:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010052a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100530 <parse_arp_reply>:

// ethernet packet arrived; parse and get the MAC address
void parse_arp_reply(struct ethr_hdr eth) {
80100530:	55                   	push   %ebp
80100531:	89 e5                	mov    %esp,%ebp
80100533:	53                   	push   %ebx
80100534:	83 ec 44             	sub    $0x44,%esp
	if (eth.ethr_type != 0x0806) {
80100537:	66 81 7d 14 06 08    	cmpw   $0x806,0x14(%ebp)
8010053d:	75 41                	jne    80100580 <parse_arp_reply+0x50>
		cprintf("Not an ARP packet");
		return;
	}

	if (eth.protype != 0x0800) {
8010053f:	66 81 7d 18 00 08    	cmpw   $0x800,0x18(%ebp)
80100545:	75 21                	jne    80100568 <parse_arp_reply+0x38>
		cprintf("Not IPV4 protocol\n");
		return;
	}

	if (eth.opcode != 2) {
80100547:	66 83 7d 1c 02       	cmpw   $0x2,0x1c(%ebp)
8010054c:	74 4a                	je     80100598 <parse_arp_reply+0x68>
		cprintf("Not an ARP reply\n");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 bf 8d 10 80       	push   $0x80108dbf
80100556:	e8 e5 06 00 00       	call   80100c40 <cprintf>
		return;
8010055b:	83 c4 10             	add    $0x10,%esp

	char mac[18];
	unpack_mac(eth.arp_smac, mac);

	cprintf((char*)mac);
}
8010055e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100561:	c9                   	leave  
80100562:	c3                   	ret    
80100563:	90                   	nop
80100564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("Not IPV4 protocol\n");
80100568:	83 ec 0c             	sub    $0xc,%esp
8010056b:	68 ac 8d 10 80       	push   $0x80108dac
80100570:	e8 cb 06 00 00       	call   80100c40 <cprintf>
		return;
80100575:	83 c4 10             	add    $0x10,%esp
}
80100578:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010057b:	c9                   	leave  
8010057c:	c3                   	ret    
8010057d:	8d 76 00             	lea    0x0(%esi),%esi
		cprintf("Not an ARP packet");
80100580:	83 ec 0c             	sub    $0xc,%esp
80100583:	68 9a 8d 10 80       	push   $0x80108d9a
80100588:	e8 b3 06 00 00       	call   80100c40 <cprintf>
		return;
8010058d:	83 c4 10             	add    $0x10,%esp
}
80100590:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100593:	c9                   	leave  
80100594:	c3                   	ret    
80100595:	8d 76 00             	lea    0x0(%esi),%esi
	unpack_mac(eth.arp_dmac, dst_mac);
80100598:	8d 45 28             	lea    0x28(%ebp),%eax
8010059b:	8d 5d d4             	lea    -0x2c(%ebp),%ebx
8010059e:	83 ec 08             	sub    $0x8,%esp
801005a1:	53                   	push   %ebx
801005a2:	50                   	push   %eax
801005a3:	e8 48 fe ff ff       	call   801003f0 <unpack_mac>
	if (strcmp((const char*)my_mac, (const char*)dst_mac)) {
801005a8:	59                   	pop    %ecx
801005a9:	58                   	pop    %eax
801005aa:	53                   	push   %ebx
801005ab:	68 d1 8d 10 80       	push   $0x80108dd1
801005b0:	e8 3b 73 00 00       	call   801078f0 <strcmp>
801005b5:	83 c4 10             	add    $0x10,%esp
801005b8:	85 c0                	test   %eax,%eax
801005ba:	75 4c                	jne    80100608 <parse_arp_reply+0xd8>
	parse_ip(eth.dip, dst_ip);
801005bc:	0f b7 45 2e          	movzwl 0x2e(%ebp),%eax
801005c0:	8d 5d c4             	lea    -0x3c(%ebp),%ebx
801005c3:	83 ec 08             	sub    $0x8,%esp
801005c6:	53                   	push   %ebx
801005c7:	50                   	push   %eax
801005c8:	e8 93 fe ff ff       	call   80100460 <parse_ip>
	if (strcmp((const char*)my_ip, (const char*)dst_ip)) {
801005cd:	58                   	pop    %eax
801005ce:	5a                   	pop    %edx
801005cf:	53                   	push   %ebx
801005d0:	68 ff 8d 10 80       	push   $0x80108dff
801005d5:	e8 16 73 00 00       	call   801078f0 <strcmp>
801005da:	83 c4 10             	add    $0x10,%esp
801005dd:	85 c0                	test   %eax,%eax
801005df:	75 27                	jne    80100608 <parse_arp_reply+0xd8>
	unpack_mac(eth.arp_smac, mac);
801005e1:	8d 45 1e             	lea    0x1e(%ebp),%eax
801005e4:	8d 5d e6             	lea    -0x1a(%ebp),%ebx
801005e7:	83 ec 08             	sub    $0x8,%esp
801005ea:	53                   	push   %ebx
801005eb:	50                   	push   %eax
801005ec:	e8 ff fd ff ff       	call   801003f0 <unpack_mac>
	cprintf((char*)mac);
801005f1:	89 1c 24             	mov    %ebx,(%esp)
801005f4:	e8 47 06 00 00       	call   80100c40 <cprintf>
801005f9:	83 c4 10             	add    $0x10,%esp
801005fc:	e9 77 ff ff ff       	jmp    80100578 <parse_arp_reply+0x48>
80100601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		cprintf("Not the intended recipient\n");
80100608:	83 ec 0c             	sub    $0xc,%esp
8010060b:	68 e3 8d 10 80       	push   $0x80108de3
80100610:	e8 2b 06 00 00       	call   80100c40 <cprintf>
		return;
80100615:	83 c4 10             	add    $0x10,%esp
80100618:	e9 5b ff ff ff       	jmp    80100578 <parse_arp_reply+0x48>
8010061d:	66 90                	xchg   %ax,%ax
8010061f:	90                   	nop

80100620 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100624:	bb 94 3e 15 80       	mov    $0x80153e94,%ebx
{
80100629:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010062c:	68 0f 8e 10 80       	push   $0x80108e0f
80100631:	68 60 3e 15 80       	push   $0x80153e60
80100636:	e8 b5 52 00 00       	call   801058f0 <initlock>
  bcache.head.prev = &bcache.head;
8010063b:	c7 05 ac 85 15 80 5c 	movl   $0x8015855c,0x801585ac
80100642:	85 15 80 
  bcache.head.next = &bcache.head;
80100645:	c7 05 b0 85 15 80 5c 	movl   $0x8015855c,0x801585b0
8010064c:	85 15 80 
8010064f:	83 c4 10             	add    $0x10,%esp
80100652:	ba 5c 85 15 80       	mov    $0x8015855c,%edx
80100657:	eb 09                	jmp    80100662 <binit+0x42>
80100659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100660:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100662:	8d 43 0c             	lea    0xc(%ebx),%eax
80100665:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100668:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010066b:	c7 43 50 5c 85 15 80 	movl   $0x8015855c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100672:	68 16 8e 10 80       	push   $0x80108e16
80100677:	50                   	push   %eax
80100678:	e8 63 51 00 00       	call   801057e0 <initsleeplock>
    bcache.head.next->prev = b;
8010067d:	a1 b0 85 15 80       	mov    0x801585b0,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100682:	83 c4 10             	add    $0x10,%esp
80100685:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
80100687:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010068a:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
80100690:	89 1d b0 85 15 80    	mov    %ebx,0x801585b0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100696:	3d 5c 85 15 80       	cmp    $0x8015855c,%eax
8010069b:	72 c3                	jb     80100660 <binit+0x40>
  }
}
8010069d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801006a0:	c9                   	leave  
801006a1:	c3                   	ret    
801006a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801006b0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 18             	sub    $0x18,%esp
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801006bf:	68 60 3e 15 80       	push   $0x80153e60
801006c4:	e8 17 53 00 00       	call   801059e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801006c9:	8b 1d b0 85 15 80    	mov    0x801585b0,%ebx
801006cf:	83 c4 10             	add    $0x10,%esp
801006d2:	81 fb 5c 85 15 80    	cmp    $0x8015855c,%ebx
801006d8:	75 11                	jne    801006eb <bread+0x3b>
801006da:	eb 24                	jmp    80100700 <bread+0x50>
801006dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006e0:	8b 5b 54             	mov    0x54(%ebx),%ebx
801006e3:	81 fb 5c 85 15 80    	cmp    $0x8015855c,%ebx
801006e9:	74 15                	je     80100700 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
801006eb:	3b 73 04             	cmp    0x4(%ebx),%esi
801006ee:	75 f0                	jne    801006e0 <bread+0x30>
801006f0:	3b 7b 08             	cmp    0x8(%ebx),%edi
801006f3:	75 eb                	jne    801006e0 <bread+0x30>
      b->refcnt++;
801006f5:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
801006f9:	eb 3f                	jmp    8010073a <bread+0x8a>
801006fb:	90                   	nop
801006fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100700:	8b 1d ac 85 15 80    	mov    0x801585ac,%ebx
80100706:	81 fb 5c 85 15 80    	cmp    $0x8015855c,%ebx
8010070c:	75 0d                	jne    8010071b <bread+0x6b>
8010070e:	eb 60                	jmp    80100770 <bread+0xc0>
80100710:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100713:	81 fb 5c 85 15 80    	cmp    $0x8015855c,%ebx
80100719:	74 55                	je     80100770 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010071b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010071e:	85 c0                	test   %eax,%eax
80100720:	75 ee                	jne    80100710 <bread+0x60>
80100722:	f6 03 04             	testb  $0x4,(%ebx)
80100725:	75 e9                	jne    80100710 <bread+0x60>
      b->dev = dev;
80100727:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010072a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010072d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100733:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010073a:	83 ec 0c             	sub    $0xc,%esp
8010073d:	68 60 3e 15 80       	push   $0x80153e60
80100742:	e8 b9 53 00 00       	call   80105b00 <release>
      acquiresleep(&b->lock);
80100747:	8d 43 0c             	lea    0xc(%ebx),%eax
8010074a:	89 04 24             	mov    %eax,(%esp)
8010074d:	e8 ce 50 00 00       	call   80105820 <acquiresleep>
80100752:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100755:	f6 03 02             	testb  $0x2,(%ebx)
80100758:	75 0c                	jne    80100766 <bread+0xb6>
    iderw(b);
8010075a:	83 ec 0c             	sub    $0xc,%esp
8010075d:	53                   	push   %ebx
8010075e:	e8 0d 24 00 00       	call   80102b70 <iderw>
80100763:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100766:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100769:	89 d8                	mov    %ebx,%eax
8010076b:	5b                   	pop    %ebx
8010076c:	5e                   	pop    %esi
8010076d:	5f                   	pop    %edi
8010076e:	5d                   	pop    %ebp
8010076f:	c3                   	ret    
  panic("bget: no buffers");
80100770:	83 ec 0c             	sub    $0xc,%esp
80100773:	68 1d 8e 10 80       	push   $0x80108e1d
80100778:	e8 f3 01 00 00       	call   80100970 <panic>
8010077d:	8d 76 00             	lea    0x0(%esi),%esi

80100780 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100780:	55                   	push   %ebp
80100781:	89 e5                	mov    %esp,%ebp
80100783:	53                   	push   %ebx
80100784:	83 ec 10             	sub    $0x10,%esp
80100787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
8010078a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010078d:	50                   	push   %eax
8010078e:	e8 2d 51 00 00       	call   801058c0 <holdingsleep>
80100793:	83 c4 10             	add    $0x10,%esp
80100796:	85 c0                	test   %eax,%eax
80100798:	74 0f                	je     801007a9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
8010079a:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
8010079d:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801007a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801007a3:	c9                   	leave  
  iderw(b);
801007a4:	e9 c7 23 00 00       	jmp    80102b70 <iderw>
    panic("bwrite");
801007a9:	83 ec 0c             	sub    $0xc,%esp
801007ac:	68 2e 8e 10 80       	push   $0x80108e2e
801007b1:	e8 ba 01 00 00       	call   80100970 <panic>
801007b6:	8d 76 00             	lea    0x0(%esi),%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007c0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801007c0:	55                   	push   %ebp
801007c1:	89 e5                	mov    %esp,%ebp
801007c3:	56                   	push   %esi
801007c4:	53                   	push   %ebx
801007c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801007c8:	83 ec 0c             	sub    $0xc,%esp
801007cb:	8d 73 0c             	lea    0xc(%ebx),%esi
801007ce:	56                   	push   %esi
801007cf:	e8 ec 50 00 00       	call   801058c0 <holdingsleep>
801007d4:	83 c4 10             	add    $0x10,%esp
801007d7:	85 c0                	test   %eax,%eax
801007d9:	74 66                	je     80100841 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801007db:	83 ec 0c             	sub    $0xc,%esp
801007de:	56                   	push   %esi
801007df:	e8 9c 50 00 00       	call   80105880 <releasesleep>

  acquire(&bcache.lock);
801007e4:	c7 04 24 60 3e 15 80 	movl   $0x80153e60,(%esp)
801007eb:	e8 f0 51 00 00       	call   801059e0 <acquire>
  b->refcnt--;
801007f0:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
801007f3:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
801007f6:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
801007f9:	85 c0                	test   %eax,%eax
  b->refcnt--;
801007fb:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
801007fe:	75 2f                	jne    8010082f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100800:	8b 43 54             	mov    0x54(%ebx),%eax
80100803:	8b 53 50             	mov    0x50(%ebx),%edx
80100806:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100809:	8b 43 50             	mov    0x50(%ebx),%eax
8010080c:	8b 53 54             	mov    0x54(%ebx),%edx
8010080f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100812:	a1 b0 85 15 80       	mov    0x801585b0,%eax
    b->prev = &bcache.head;
80100817:	c7 43 50 5c 85 15 80 	movl   $0x8015855c,0x50(%ebx)
    b->next = bcache.head.next;
8010081e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100821:	a1 b0 85 15 80       	mov    0x801585b0,%eax
80100826:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100829:	89 1d b0 85 15 80    	mov    %ebx,0x801585b0
  }
  
  release(&bcache.lock);
8010082f:	c7 45 08 60 3e 15 80 	movl   $0x80153e60,0x8(%ebp)
}
80100836:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100839:	5b                   	pop    %ebx
8010083a:	5e                   	pop    %esi
8010083b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010083c:	e9 bf 52 00 00       	jmp    80105b00 <release>
    panic("brelse");
80100841:	83 ec 0c             	sub    $0xc,%esp
80100844:	68 35 8e 10 80       	push   $0x80108e35
80100849:	e8 22 01 00 00       	call   80100970 <panic>
8010084e:	66 90                	xchg   %ax,%ax

80100850 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100850:	55                   	push   %ebp
80100851:	89 e5                	mov    %esp,%ebp
80100853:	57                   	push   %edi
80100854:	56                   	push   %esi
80100855:	53                   	push   %ebx
80100856:	83 ec 28             	sub    $0x28,%esp
80100859:	8b 7d 08             	mov    0x8(%ebp),%edi
8010085c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010085f:	57                   	push   %edi
80100860:	e8 4b 19 00 00       	call   801021b0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100865:	c7 04 24 60 c5 10 80 	movl   $0x8010c560,(%esp)
8010086c:	e8 6f 51 00 00       	call   801059e0 <acquire>
  while(n > 0){
80100871:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100874:	83 c4 10             	add    $0x10,%esp
80100877:	31 c0                	xor    %eax,%eax
80100879:	85 db                	test   %ebx,%ebx
8010087b:	0f 8e a1 00 00 00    	jle    80100922 <consoleread+0xd2>
    while(input.r == input.w){
80100881:	8b 15 40 88 15 80    	mov    0x80158840,%edx
80100887:	39 15 44 88 15 80    	cmp    %edx,0x80158844
8010088d:	74 2c                	je     801008bb <consoleread+0x6b>
8010088f:	eb 5f                	jmp    801008f0 <consoleread+0xa0>
80100891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100898:	83 ec 08             	sub    $0x8,%esp
8010089b:	68 60 c5 10 80       	push   $0x8010c560
801008a0:	68 40 88 15 80       	push   $0x80158840
801008a5:	e8 e6 4b 00 00       	call   80105490 <sleep>
    while(input.r == input.w){
801008aa:	8b 15 40 88 15 80    	mov    0x80158840,%edx
801008b0:	83 c4 10             	add    $0x10,%esp
801008b3:	3b 15 44 88 15 80    	cmp    0x80158844,%edx
801008b9:	75 35                	jne    801008f0 <consoleread+0xa0>
      if(myproc()->killed){
801008bb:	e8 30 46 00 00       	call   80104ef0 <myproc>
801008c0:	8b 40 24             	mov    0x24(%eax),%eax
801008c3:	85 c0                	test   %eax,%eax
801008c5:	74 d1                	je     80100898 <consoleread+0x48>
        release(&cons.lock);
801008c7:	83 ec 0c             	sub    $0xc,%esp
801008ca:	68 60 c5 10 80       	push   $0x8010c560
801008cf:	e8 2c 52 00 00       	call   80105b00 <release>
        ilock(ip);
801008d4:	89 3c 24             	mov    %edi,(%esp)
801008d7:	e8 f4 17 00 00       	call   801020d0 <ilock>
        return -1;
801008dc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801008df:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
801008e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801008e7:	5b                   	pop    %ebx
801008e8:	5e                   	pop    %esi
801008e9:	5f                   	pop    %edi
801008ea:	5d                   	pop    %ebp
801008eb:	c3                   	ret    
801008ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
801008f0:	8d 42 01             	lea    0x1(%edx),%eax
801008f3:	a3 40 88 15 80       	mov    %eax,0x80158840
801008f8:	89 d0                	mov    %edx,%eax
801008fa:	83 e0 7f             	and    $0x7f,%eax
801008fd:	0f be 80 c0 87 15 80 	movsbl -0x7fea7840(%eax),%eax
    if(c == C('D')){  // EOF
80100904:	83 f8 04             	cmp    $0x4,%eax
80100907:	74 3f                	je     80100948 <consoleread+0xf8>
    *dst++ = c;
80100909:	83 c6 01             	add    $0x1,%esi
    --n;
8010090c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010090f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100912:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100915:	74 43                	je     8010095a <consoleread+0x10a>
  while(n > 0){
80100917:	85 db                	test   %ebx,%ebx
80100919:	0f 85 62 ff ff ff    	jne    80100881 <consoleread+0x31>
8010091f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100922:	83 ec 0c             	sub    $0xc,%esp
80100925:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100928:	68 60 c5 10 80       	push   $0x8010c560
8010092d:	e8 ce 51 00 00       	call   80105b00 <release>
  ilock(ip);
80100932:	89 3c 24             	mov    %edi,(%esp)
80100935:	e8 96 17 00 00       	call   801020d0 <ilock>
  return target - n;
8010093a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010093d:	83 c4 10             	add    $0x10,%esp
}
80100940:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100943:	5b                   	pop    %ebx
80100944:	5e                   	pop    %esi
80100945:	5f                   	pop    %edi
80100946:	5d                   	pop    %ebp
80100947:	c3                   	ret    
80100948:	8b 45 10             	mov    0x10(%ebp),%eax
8010094b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010094d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100950:	73 d0                	jae    80100922 <consoleread+0xd2>
        input.r--;
80100952:	89 15 40 88 15 80    	mov    %edx,0x80158840
80100958:	eb c8                	jmp    80100922 <consoleread+0xd2>
8010095a:	8b 45 10             	mov    0x10(%ebp),%eax
8010095d:	29 d8                	sub    %ebx,%eax
8010095f:	eb c1                	jmp    80100922 <consoleread+0xd2>
80100961:	eb 0d                	jmp    80100970 <panic>
80100963:	90                   	nop
80100964:	90                   	nop
80100965:	90                   	nop
80100966:	90                   	nop
80100967:	90                   	nop
80100968:	90                   	nop
80100969:	90                   	nop
8010096a:	90                   	nop
8010096b:	90                   	nop
8010096c:	90                   	nop
8010096d:	90                   	nop
8010096e:	90                   	nop
8010096f:	90                   	nop

80100970 <panic>:
{
80100970:	55                   	push   %ebp
80100971:	89 e5                	mov    %esp,%ebp
80100973:	56                   	push   %esi
80100974:	53                   	push   %ebx
80100975:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100978:	fa                   	cli    
  cons.locking = 0;
80100979:	c7 05 94 c5 10 80 00 	movl   $0x0,0x8010c594
80100980:	00 00 00 
  getcallerpcs(&s, pcs);
80100983:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100986:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100989:	e8 f2 27 00 00       	call   80103180 <lapicid>
8010098e:	83 ec 08             	sub    $0x8,%esp
80100991:	50                   	push   %eax
80100992:	68 3c 8e 10 80       	push   $0x80108e3c
80100997:	e8 a4 02 00 00       	call   80100c40 <cprintf>
  cprintf(s);
8010099c:	58                   	pop    %eax
8010099d:	ff 75 08             	pushl  0x8(%ebp)
801009a0:	e8 9b 02 00 00       	call   80100c40 <cprintf>
  cprintf("\n");
801009a5:	c7 04 24 57 9c 10 80 	movl   $0x80109c57,(%esp)
801009ac:	e8 8f 02 00 00       	call   80100c40 <cprintf>
  getcallerpcs(&s, pcs);
801009b1:	5a                   	pop    %edx
801009b2:	8d 45 08             	lea    0x8(%ebp),%eax
801009b5:	59                   	pop    %ecx
801009b6:	53                   	push   %ebx
801009b7:	50                   	push   %eax
801009b8:	e8 53 4f 00 00       	call   80105910 <getcallerpcs>
801009bd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801009c0:	83 ec 08             	sub    $0x8,%esp
801009c3:	ff 33                	pushl  (%ebx)
801009c5:	83 c3 04             	add    $0x4,%ebx
801009c8:	68 bc 8e 10 80       	push   $0x80108ebc
801009cd:	e8 6e 02 00 00       	call   80100c40 <cprintf>
  for(i=0; i<10; i++)
801009d2:	83 c4 10             	add    $0x10,%esp
801009d5:	39 f3                	cmp    %esi,%ebx
801009d7:	75 e7                	jne    801009c0 <panic+0x50>
  panicked = 1; // freeze other CPU
801009d9:	c7 05 98 c5 10 80 01 	movl   $0x1,0x8010c598
801009e0:	00 00 00 
801009e3:	eb fe                	jmp    801009e3 <panic+0x73>
801009e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009f0 <consputc>:
  if(panicked){
801009f0:	8b 0d 98 c5 10 80    	mov    0x8010c598,%ecx
801009f6:	85 c9                	test   %ecx,%ecx
801009f8:	74 06                	je     80100a00 <consputc+0x10>
801009fa:	fa                   	cli    
801009fb:	eb fe                	jmp    801009fb <consputc+0xb>
801009fd:	8d 76 00             	lea    0x0(%esi),%esi
{
80100a00:	55                   	push   %ebp
80100a01:	89 e5                	mov    %esp,%ebp
80100a03:	57                   	push   %edi
80100a04:	56                   	push   %esi
80100a05:	53                   	push   %ebx
80100a06:	89 c6                	mov    %eax,%esi
80100a08:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
80100a0b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100a10:	0f 84 b1 00 00 00    	je     80100ac7 <consputc+0xd7>
    uartputc(c);
80100a16:	83 ec 0c             	sub    $0xc,%esp
80100a19:	50                   	push   %eax
80100a1a:	e8 41 6e 00 00       	call   80107860 <uartputc>
80100a1f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a22:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100a27:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a2c:	89 da                	mov    %ebx,%edx
80100a2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a2f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100a34:	89 ca                	mov    %ecx,%edx
80100a36:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100a37:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a3a:	89 da                	mov    %ebx,%edx
80100a3c:	c1 e0 08             	shl    $0x8,%eax
80100a3f:	89 c7                	mov    %eax,%edi
80100a41:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a47:	89 ca                	mov    %ecx,%edx
80100a49:	ec                   	in     (%dx),%al
80100a4a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
80100a4d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
80100a4f:	83 fe 0a             	cmp    $0xa,%esi
80100a52:	0f 84 f3 00 00 00    	je     80100b4b <consputc+0x15b>
  else if(c == BACKSPACE){
80100a58:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100a5e:	0f 84 d7 00 00 00    	je     80100b3b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100a64:	89 f0                	mov    %esi,%eax
80100a66:	0f b6 c0             	movzbl %al,%eax
80100a69:	80 cc 07             	or     $0x7,%ah
80100a6c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100a73:	80 
80100a74:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100a77:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100a7d:	0f 8f ab 00 00 00    	jg     80100b2e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
80100a83:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100a89:	7f 66                	jg     80100af1 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a8b:	be d4 03 00 00       	mov    $0x3d4,%esi
80100a90:	b8 0e 00 00 00       	mov    $0xe,%eax
80100a95:	89 f2                	mov    %esi,%edx
80100a97:	ee                   	out    %al,(%dx)
80100a98:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
80100a9d:	89 d8                	mov    %ebx,%eax
80100a9f:	c1 f8 08             	sar    $0x8,%eax
80100aa2:	89 ca                	mov    %ecx,%edx
80100aa4:	ee                   	out    %al,(%dx)
80100aa5:	b8 0f 00 00 00       	mov    $0xf,%eax
80100aaa:	89 f2                	mov    %esi,%edx
80100aac:	ee                   	out    %al,(%dx)
80100aad:	89 d8                	mov    %ebx,%eax
80100aaf:	89 ca                	mov    %ecx,%edx
80100ab1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100ab2:	b8 20 07 00 00       	mov    $0x720,%eax
80100ab7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100abe:	80 
}
80100abf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ac2:	5b                   	pop    %ebx
80100ac3:	5e                   	pop    %esi
80100ac4:	5f                   	pop    %edi
80100ac5:	5d                   	pop    %ebp
80100ac6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100ac7:	83 ec 0c             	sub    $0xc,%esp
80100aca:	6a 08                	push   $0x8
80100acc:	e8 8f 6d 00 00       	call   80107860 <uartputc>
80100ad1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100ad8:	e8 83 6d 00 00       	call   80107860 <uartputc>
80100add:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100ae4:	e8 77 6d 00 00       	call   80107860 <uartputc>
80100ae9:	83 c4 10             	add    $0x10,%esp
80100aec:	e9 31 ff ff ff       	jmp    80100a22 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100af1:	52                   	push   %edx
80100af2:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100af7:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100afa:	68 a0 80 0b 80       	push   $0x800b80a0
80100aff:	68 00 80 0b 80       	push   $0x800b8000
80100b04:	e8 07 51 00 00       	call   80105c10 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100b09:	b8 80 07 00 00       	mov    $0x780,%eax
80100b0e:	83 c4 0c             	add    $0xc,%esp
80100b11:	29 d8                	sub    %ebx,%eax
80100b13:	01 c0                	add    %eax,%eax
80100b15:	50                   	push   %eax
80100b16:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100b19:	6a 00                	push   $0x0
80100b1b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100b20:	50                   	push   %eax
80100b21:	e8 3a 50 00 00       	call   80105b60 <memset>
80100b26:	83 c4 10             	add    $0x10,%esp
80100b29:	e9 5d ff ff ff       	jmp    80100a8b <consputc+0x9b>
    panic("pos under/overflow");
80100b2e:	83 ec 0c             	sub    $0xc,%esp
80100b31:	68 50 8e 10 80       	push   $0x80108e50
80100b36:	e8 35 fe ff ff       	call   80100970 <panic>
    if(pos > 0) --pos;
80100b3b:	85 db                	test   %ebx,%ebx
80100b3d:	0f 84 48 ff ff ff    	je     80100a8b <consputc+0x9b>
80100b43:	83 eb 01             	sub    $0x1,%ebx
80100b46:	e9 2c ff ff ff       	jmp    80100a77 <consputc+0x87>
    pos += 80 - pos%80;
80100b4b:	89 d8                	mov    %ebx,%eax
80100b4d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100b52:	99                   	cltd   
80100b53:	f7 f9                	idiv   %ecx
80100b55:	29 d1                	sub    %edx,%ecx
80100b57:	01 cb                	add    %ecx,%ebx
80100b59:	e9 19 ff ff ff       	jmp    80100a77 <consputc+0x87>
80100b5e:	66 90                	xchg   %ax,%ax

80100b60 <printint>:
{
80100b60:	55                   	push   %ebp
80100b61:	89 e5                	mov    %esp,%ebp
80100b63:	57                   	push   %edi
80100b64:	56                   	push   %esi
80100b65:	53                   	push   %ebx
80100b66:	89 d3                	mov    %edx,%ebx
80100b68:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
80100b6b:	85 c9                	test   %ecx,%ecx
{
80100b6d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100b70:	74 04                	je     80100b76 <printint+0x16>
80100b72:	85 c0                	test   %eax,%eax
80100b74:	78 5a                	js     80100bd0 <printint+0x70>
    x = xx;
80100b76:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
80100b7d:	31 c9                	xor    %ecx,%ecx
80100b7f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100b82:	eb 06                	jmp    80100b8a <printint+0x2a>
80100b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
80100b88:	89 f9                	mov    %edi,%ecx
80100b8a:	31 d2                	xor    %edx,%edx
80100b8c:	8d 79 01             	lea    0x1(%ecx),%edi
80100b8f:	f7 f3                	div    %ebx
80100b91:	0f b6 92 7c 8e 10 80 	movzbl -0x7fef7184(%edx),%edx
  }while((x /= base) != 0);
80100b98:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
80100b9a:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
80100b9d:	75 e9                	jne    80100b88 <printint+0x28>
  if(sign)
80100b9f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ba2:	85 c0                	test   %eax,%eax
80100ba4:	74 08                	je     80100bae <printint+0x4e>
    buf[i++] = '-';
80100ba6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
80100bab:	8d 79 02             	lea    0x2(%ecx),%edi
80100bae:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
80100bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
80100bb8:	0f be 03             	movsbl (%ebx),%eax
80100bbb:	83 eb 01             	sub    $0x1,%ebx
80100bbe:	e8 2d fe ff ff       	call   801009f0 <consputc>
  while(--i >= 0)
80100bc3:	39 f3                	cmp    %esi,%ebx
80100bc5:	75 f1                	jne    80100bb8 <printint+0x58>
}
80100bc7:	83 c4 2c             	add    $0x2c,%esp
80100bca:	5b                   	pop    %ebx
80100bcb:	5e                   	pop    %esi
80100bcc:	5f                   	pop    %edi
80100bcd:	5d                   	pop    %ebp
80100bce:	c3                   	ret    
80100bcf:	90                   	nop
    x = -xx;
80100bd0:	f7 d8                	neg    %eax
80100bd2:	eb a9                	jmp    80100b7d <printint+0x1d>
80100bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100be0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100be0:	55                   	push   %ebp
80100be1:	89 e5                	mov    %esp,%ebp
80100be3:	57                   	push   %edi
80100be4:	56                   	push   %esi
80100be5:	53                   	push   %ebx
80100be6:	83 ec 18             	sub    $0x18,%esp
80100be9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
80100bec:	ff 75 08             	pushl  0x8(%ebp)
80100bef:	e8 bc 15 00 00       	call   801021b0 <iunlock>
  acquire(&cons.lock);
80100bf4:	c7 04 24 60 c5 10 80 	movl   $0x8010c560,(%esp)
80100bfb:	e8 e0 4d 00 00       	call   801059e0 <acquire>
  for(i = 0; i < n; i++)
80100c00:	83 c4 10             	add    $0x10,%esp
80100c03:	85 f6                	test   %esi,%esi
80100c05:	7e 18                	jle    80100c1f <consolewrite+0x3f>
80100c07:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100c0a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
80100c0d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100c10:	0f b6 07             	movzbl (%edi),%eax
80100c13:	83 c7 01             	add    $0x1,%edi
80100c16:	e8 d5 fd ff ff       	call   801009f0 <consputc>
  for(i = 0; i < n; i++)
80100c1b:	39 fb                	cmp    %edi,%ebx
80100c1d:	75 f1                	jne    80100c10 <consolewrite+0x30>
  release(&cons.lock);
80100c1f:	83 ec 0c             	sub    $0xc,%esp
80100c22:	68 60 c5 10 80       	push   $0x8010c560
80100c27:	e8 d4 4e 00 00       	call   80105b00 <release>
  ilock(ip);
80100c2c:	58                   	pop    %eax
80100c2d:	ff 75 08             	pushl  0x8(%ebp)
80100c30:	e8 9b 14 00 00       	call   801020d0 <ilock>

  return n;
}
80100c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c38:	89 f0                	mov    %esi,%eax
80100c3a:	5b                   	pop    %ebx
80100c3b:	5e                   	pop    %esi
80100c3c:	5f                   	pop    %edi
80100c3d:	5d                   	pop    %ebp
80100c3e:	c3                   	ret    
80100c3f:	90                   	nop

80100c40 <cprintf>:
{
80100c40:	55                   	push   %ebp
80100c41:	89 e5                	mov    %esp,%ebp
80100c43:	57                   	push   %edi
80100c44:	56                   	push   %esi
80100c45:	53                   	push   %ebx
80100c46:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100c49:	a1 94 c5 10 80       	mov    0x8010c594,%eax
  if(locking)
80100c4e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100c50:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100c53:	0f 85 6f 01 00 00    	jne    80100dc8 <cprintf+0x188>
  if (fmt == 0)
80100c59:	8b 45 08             	mov    0x8(%ebp),%eax
80100c5c:	85 c0                	test   %eax,%eax
80100c5e:	89 c7                	mov    %eax,%edi
80100c60:	0f 84 77 01 00 00    	je     80100ddd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100c66:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100c69:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100c6c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
80100c6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100c71:	85 c0                	test   %eax,%eax
80100c73:	75 56                	jne    80100ccb <cprintf+0x8b>
80100c75:	eb 79                	jmp    80100cf0 <cprintf+0xb0>
80100c77:	89 f6                	mov    %esi,%esi
80100c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
80100c80:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
80100c83:	85 d2                	test   %edx,%edx
80100c85:	74 69                	je     80100cf0 <cprintf+0xb0>
80100c87:	83 c3 02             	add    $0x2,%ebx
    switch(c){
80100c8a:	83 fa 70             	cmp    $0x70,%edx
80100c8d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
80100c90:	0f 84 84 00 00 00    	je     80100d1a <cprintf+0xda>
80100c96:	7f 78                	jg     80100d10 <cprintf+0xd0>
80100c98:	83 fa 25             	cmp    $0x25,%edx
80100c9b:	0f 84 ff 00 00 00    	je     80100da0 <cprintf+0x160>
80100ca1:	83 fa 64             	cmp    $0x64,%edx
80100ca4:	0f 85 8e 00 00 00    	jne    80100d38 <cprintf+0xf8>
      printint(*argp++, 10, 1);
80100caa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cad:	ba 0a 00 00 00       	mov    $0xa,%edx
80100cb2:	8d 48 04             	lea    0x4(%eax),%ecx
80100cb5:	8b 00                	mov    (%eax),%eax
80100cb7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100cba:	b9 01 00 00 00       	mov    $0x1,%ecx
80100cbf:	e8 9c fe ff ff       	call   80100b60 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100cc4:	0f b6 06             	movzbl (%esi),%eax
80100cc7:	85 c0                	test   %eax,%eax
80100cc9:	74 25                	je     80100cf0 <cprintf+0xb0>
80100ccb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
80100cce:	83 f8 25             	cmp    $0x25,%eax
80100cd1:	8d 34 17             	lea    (%edi,%edx,1),%esi
80100cd4:	74 aa                	je     80100c80 <cprintf+0x40>
80100cd6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
80100cd9:	e8 12 fd ff ff       	call   801009f0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100cde:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100ce1:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ce4:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100ce6:	85 c0                	test   %eax,%eax
80100ce8:	75 e1                	jne    80100ccb <cprintf+0x8b>
80100cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100cf0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100cf3:	85 c0                	test   %eax,%eax
80100cf5:	74 10                	je     80100d07 <cprintf+0xc7>
    release(&cons.lock);
80100cf7:	83 ec 0c             	sub    $0xc,%esp
80100cfa:	68 60 c5 10 80       	push   $0x8010c560
80100cff:	e8 fc 4d 00 00       	call   80105b00 <release>
80100d04:	83 c4 10             	add    $0x10,%esp
}
80100d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d0a:	5b                   	pop    %ebx
80100d0b:	5e                   	pop    %esi
80100d0c:	5f                   	pop    %edi
80100d0d:	5d                   	pop    %ebp
80100d0e:	c3                   	ret    
80100d0f:	90                   	nop
    switch(c){
80100d10:	83 fa 73             	cmp    $0x73,%edx
80100d13:	74 43                	je     80100d58 <cprintf+0x118>
80100d15:	83 fa 78             	cmp    $0x78,%edx
80100d18:	75 1e                	jne    80100d38 <cprintf+0xf8>
      printint(*argp++, 16, 0);
80100d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d1d:	ba 10 00 00 00       	mov    $0x10,%edx
80100d22:	8d 48 04             	lea    0x4(%eax),%ecx
80100d25:	8b 00                	mov    (%eax),%eax
80100d27:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100d2a:	31 c9                	xor    %ecx,%ecx
80100d2c:	e8 2f fe ff ff       	call   80100b60 <printint>
      break;
80100d31:	eb 91                	jmp    80100cc4 <cprintf+0x84>
80100d33:	90                   	nop
80100d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100d38:	b8 25 00 00 00       	mov    $0x25,%eax
80100d3d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100d40:	e8 ab fc ff ff       	call   801009f0 <consputc>
      consputc(c);
80100d45:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100d48:	89 d0                	mov    %edx,%eax
80100d4a:	e8 a1 fc ff ff       	call   801009f0 <consputc>
      break;
80100d4f:	e9 70 ff ff ff       	jmp    80100cc4 <cprintf+0x84>
80100d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d5b:	8b 10                	mov    (%eax),%edx
80100d5d:	8d 48 04             	lea    0x4(%eax),%ecx
80100d60:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100d63:	85 d2                	test   %edx,%edx
80100d65:	74 49                	je     80100db0 <cprintf+0x170>
      for(; *s; s++)
80100d67:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
80100d6a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
80100d6d:	84 c0                	test   %al,%al
80100d6f:	0f 84 4f ff ff ff    	je     80100cc4 <cprintf+0x84>
80100d75:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100d78:	89 d3                	mov    %edx,%ebx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d80:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
80100d83:	e8 68 fc ff ff       	call   801009f0 <consputc>
      for(; *s; s++)
80100d88:	0f be 03             	movsbl (%ebx),%eax
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
80100d8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d92:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100d98:	e9 27 ff ff ff       	jmp    80100cc4 <cprintf+0x84>
80100d9d:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
80100da0:	b8 25 00 00 00       	mov    $0x25,%eax
80100da5:	e8 46 fc ff ff       	call   801009f0 <consputc>
      break;
80100daa:	e9 15 ff ff ff       	jmp    80100cc4 <cprintf+0x84>
80100daf:	90                   	nop
        s = "(null)";
80100db0:	ba 63 8e 10 80       	mov    $0x80108e63,%edx
      for(; *s; s++)
80100db5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100db8:	b8 28 00 00 00       	mov    $0x28,%eax
80100dbd:	89 d3                	mov    %edx,%ebx
80100dbf:	eb bf                	jmp    80100d80 <cprintf+0x140>
80100dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
80100dc8:	83 ec 0c             	sub    $0xc,%esp
80100dcb:	68 60 c5 10 80       	push   $0x8010c560
80100dd0:	e8 0b 4c 00 00       	call   801059e0 <acquire>
80100dd5:	83 c4 10             	add    $0x10,%esp
80100dd8:	e9 7c fe ff ff       	jmp    80100c59 <cprintf+0x19>
    panic("null fmt");
80100ddd:	83 ec 0c             	sub    $0xc,%esp
80100de0:	68 6a 8e 10 80       	push   $0x80108e6a
80100de5:	e8 86 fb ff ff       	call   80100970 <panic>
80100dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100df0 <consoleintr>:
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	57                   	push   %edi
80100df4:	56                   	push   %esi
80100df5:	53                   	push   %ebx
  int c, doprocdump = 0;
80100df6:	31 f6                	xor    %esi,%esi
{
80100df8:	83 ec 18             	sub    $0x18,%esp
80100dfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100dfe:	68 60 c5 10 80       	push   $0x8010c560
80100e03:	e8 d8 4b 00 00       	call   801059e0 <acquire>
  while((c = getc()) >= 0){
80100e08:	83 c4 10             	add    $0x10,%esp
80100e0b:	90                   	nop
80100e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e10:	ff d3                	call   *%ebx
80100e12:	85 c0                	test   %eax,%eax
80100e14:	89 c7                	mov    %eax,%edi
80100e16:	78 48                	js     80100e60 <consoleintr+0x70>
    switch(c){
80100e18:	83 ff 10             	cmp    $0x10,%edi
80100e1b:	0f 84 e7 00 00 00    	je     80100f08 <consoleintr+0x118>
80100e21:	7e 5d                	jle    80100e80 <consoleintr+0x90>
80100e23:	83 ff 15             	cmp    $0x15,%edi
80100e26:	0f 84 ec 00 00 00    	je     80100f18 <consoleintr+0x128>
80100e2c:	83 ff 7f             	cmp    $0x7f,%edi
80100e2f:	75 54                	jne    80100e85 <consoleintr+0x95>
      if(input.e != input.w){
80100e31:	a1 48 88 15 80       	mov    0x80158848,%eax
80100e36:	3b 05 44 88 15 80    	cmp    0x80158844,%eax
80100e3c:	74 d2                	je     80100e10 <consoleintr+0x20>
        input.e--;
80100e3e:	83 e8 01             	sub    $0x1,%eax
80100e41:	a3 48 88 15 80       	mov    %eax,0x80158848
        consputc(BACKSPACE);
80100e46:	b8 00 01 00 00       	mov    $0x100,%eax
80100e4b:	e8 a0 fb ff ff       	call   801009f0 <consputc>
  while((c = getc()) >= 0){
80100e50:	ff d3                	call   *%ebx
80100e52:	85 c0                	test   %eax,%eax
80100e54:	89 c7                	mov    %eax,%edi
80100e56:	79 c0                	jns    80100e18 <consoleintr+0x28>
80100e58:	90                   	nop
80100e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
80100e63:	68 60 c5 10 80       	push   $0x8010c560
80100e68:	e8 93 4c 00 00       	call   80105b00 <release>
  if(doprocdump) {
80100e6d:	83 c4 10             	add    $0x10,%esp
80100e70:	85 f6                	test   %esi,%esi
80100e72:	0f 85 f8 00 00 00    	jne    80100f70 <consoleintr+0x180>
}
80100e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e7b:	5b                   	pop    %ebx
80100e7c:	5e                   	pop    %esi
80100e7d:	5f                   	pop    %edi
80100e7e:	5d                   	pop    %ebp
80100e7f:	c3                   	ret    
    switch(c){
80100e80:	83 ff 08             	cmp    $0x8,%edi
80100e83:	74 ac                	je     80100e31 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100e85:	85 ff                	test   %edi,%edi
80100e87:	74 87                	je     80100e10 <consoleintr+0x20>
80100e89:	a1 48 88 15 80       	mov    0x80158848,%eax
80100e8e:	89 c2                	mov    %eax,%edx
80100e90:	2b 15 40 88 15 80    	sub    0x80158840,%edx
80100e96:	83 fa 7f             	cmp    $0x7f,%edx
80100e99:	0f 87 71 ff ff ff    	ja     80100e10 <consoleintr+0x20>
80100e9f:	8d 50 01             	lea    0x1(%eax),%edx
80100ea2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100ea5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100ea8:	89 15 48 88 15 80    	mov    %edx,0x80158848
        c = (c == '\r') ? '\n' : c;
80100eae:	0f 84 cc 00 00 00    	je     80100f80 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
80100eb4:	89 f9                	mov    %edi,%ecx
80100eb6:	88 88 c0 87 15 80    	mov    %cl,-0x7fea7840(%eax)
        consputc(c);
80100ebc:	89 f8                	mov    %edi,%eax
80100ebe:	e8 2d fb ff ff       	call   801009f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100ec3:	83 ff 0a             	cmp    $0xa,%edi
80100ec6:	0f 84 c5 00 00 00    	je     80100f91 <consoleintr+0x1a1>
80100ecc:	83 ff 04             	cmp    $0x4,%edi
80100ecf:	0f 84 bc 00 00 00    	je     80100f91 <consoleintr+0x1a1>
80100ed5:	a1 40 88 15 80       	mov    0x80158840,%eax
80100eda:	83 e8 80             	sub    $0xffffff80,%eax
80100edd:	39 05 48 88 15 80    	cmp    %eax,0x80158848
80100ee3:	0f 85 27 ff ff ff    	jne    80100e10 <consoleintr+0x20>
          wakeup(&input.r);
80100ee9:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100eec:	a3 44 88 15 80       	mov    %eax,0x80158844
          wakeup(&input.r);
80100ef1:	68 40 88 15 80       	push   $0x80158840
80100ef6:	e8 45 47 00 00       	call   80105640 <wakeup>
80100efb:	83 c4 10             	add    $0x10,%esp
80100efe:	e9 0d ff ff ff       	jmp    80100e10 <consoleintr+0x20>
80100f03:	90                   	nop
80100f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100f08:	be 01 00 00 00       	mov    $0x1,%esi
80100f0d:	e9 fe fe ff ff       	jmp    80100e10 <consoleintr+0x20>
80100f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100f18:	a1 48 88 15 80       	mov    0x80158848,%eax
80100f1d:	39 05 44 88 15 80    	cmp    %eax,0x80158844
80100f23:	75 2b                	jne    80100f50 <consoleintr+0x160>
80100f25:	e9 e6 fe ff ff       	jmp    80100e10 <consoleintr+0x20>
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100f30:	a3 48 88 15 80       	mov    %eax,0x80158848
        consputc(BACKSPACE);
80100f35:	b8 00 01 00 00       	mov    $0x100,%eax
80100f3a:	e8 b1 fa ff ff       	call   801009f0 <consputc>
      while(input.e != input.w &&
80100f3f:	a1 48 88 15 80       	mov    0x80158848,%eax
80100f44:	3b 05 44 88 15 80    	cmp    0x80158844,%eax
80100f4a:	0f 84 c0 fe ff ff    	je     80100e10 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100f50:	83 e8 01             	sub    $0x1,%eax
80100f53:	89 c2                	mov    %eax,%edx
80100f55:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100f58:	80 ba c0 87 15 80 0a 	cmpb   $0xa,-0x7fea7840(%edx)
80100f5f:	75 cf                	jne    80100f30 <consoleintr+0x140>
80100f61:	e9 aa fe ff ff       	jmp    80100e10 <consoleintr+0x20>
80100f66:	8d 76 00             	lea    0x0(%esi),%esi
80100f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f73:	5b                   	pop    %ebx
80100f74:	5e                   	pop    %esi
80100f75:	5f                   	pop    %edi
80100f76:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100f77:	e9 a4 47 00 00       	jmp    80105720 <procdump>
80100f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100f80:	c6 80 c0 87 15 80 0a 	movb   $0xa,-0x7fea7840(%eax)
        consputc(c);
80100f87:	b8 0a 00 00 00       	mov    $0xa,%eax
80100f8c:	e8 5f fa ff ff       	call   801009f0 <consputc>
80100f91:	a1 48 88 15 80       	mov    0x80158848,%eax
80100f96:	e9 4e ff ff ff       	jmp    80100ee9 <consoleintr+0xf9>
80100f9b:	90                   	nop
80100f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fa0 <consoleinit>:

void
consoleinit(void)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100fa6:	68 73 8e 10 80       	push   $0x80108e73
80100fab:	68 60 c5 10 80       	push   $0x8010c560
80100fb0:	e8 3b 49 00 00       	call   801058f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100fb5:	58                   	pop    %eax
80100fb6:	5a                   	pop    %edx
80100fb7:	6a 00                	push   $0x0
80100fb9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100fbb:	c7 05 2c 95 15 80 e0 	movl   $0x80100be0,0x8015952c
80100fc2:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100fc5:	c7 05 28 95 15 80 50 	movl   $0x80100850,0x80159528
80100fcc:	08 10 80 
  cons.locking = 1;
80100fcf:	c7 05 94 c5 10 80 01 	movl   $0x1,0x8010c594
80100fd6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100fd9:	e8 42 1d 00 00       	call   80102d20 <ioapicenable>
}
80100fde:	83 c4 10             	add    $0x10,%esp
80100fe1:	c9                   	leave  
80100fe2:	c3                   	ret    
80100fe3:	66 90                	xchg   %ax,%ax
80100fe5:	66 90                	xchg   %ax,%ax
80100fe7:	66 90                	xchg   %ax,%ax
80100fe9:	66 90                	xchg   %ax,%ax
80100feb:	66 90                	xchg   %ax,%ax
80100fed:	66 90                	xchg   %ax,%ax
80100fef:	90                   	nop

80100ff0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100ffc:	e8 ef 3e 00 00       	call   80104ef0 <myproc>
80101001:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80101007:	e8 e4 25 00 00       	call   801035f0 <begin_op>

  if((ip = namei(path)) == 0){
8010100c:	83 ec 0c             	sub    $0xc,%esp
8010100f:	ff 75 08             	pushl  0x8(%ebp)
80101012:	e8 19 19 00 00       	call   80102930 <namei>
80101017:	83 c4 10             	add    $0x10,%esp
8010101a:	85 c0                	test   %eax,%eax
8010101c:	0f 84 91 01 00 00    	je     801011b3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101022:	83 ec 0c             	sub    $0xc,%esp
80101025:	89 c3                	mov    %eax,%ebx
80101027:	50                   	push   %eax
80101028:	e8 a3 10 00 00       	call   801020d0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010102d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101033:	6a 34                	push   $0x34
80101035:	6a 00                	push   $0x0
80101037:	50                   	push   %eax
80101038:	53                   	push   %ebx
80101039:	e8 72 13 00 00       	call   801023b0 <readi>
8010103e:	83 c4 20             	add    $0x20,%esp
80101041:	83 f8 34             	cmp    $0x34,%eax
80101044:	74 22                	je     80101068 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	53                   	push   %ebx
8010104a:	e8 11 13 00 00       	call   80102360 <iunlockput>
    end_op();
8010104f:	e8 0c 26 00 00       	call   80103660 <end_op>
80101054:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80101057:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010105c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105f:	5b                   	pop    %ebx
80101060:	5e                   	pop    %esi
80101061:	5f                   	pop    %edi
80101062:	5d                   	pop    %ebp
80101063:	c3                   	ret    
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80101068:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010106f:	45 4c 46 
80101072:	75 d2                	jne    80101046 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80101074:	e8 c7 79 00 00       	call   80108a40 <setupkvm>
80101079:	85 c0                	test   %eax,%eax
8010107b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101081:	74 c3                	je     80101046 <exec+0x56>
  sz = 0;
80101083:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101085:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
8010108c:	00 
8010108d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80101093:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80101099:	0f 84 8c 02 00 00    	je     8010132b <exec+0x33b>
8010109f:	31 f6                	xor    %esi,%esi
801010a1:	eb 7f                	jmp    80101122 <exec+0x132>
801010a3:	90                   	nop
801010a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
801010a8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801010af:	75 63                	jne    80101114 <exec+0x124>
    if(ph.memsz < ph.filesz)
801010b1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801010b7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801010bd:	0f 82 86 00 00 00    	jb     80101149 <exec+0x159>
801010c3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801010c9:	72 7e                	jb     80101149 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801010cb:	83 ec 04             	sub    $0x4,%esp
801010ce:	50                   	push   %eax
801010cf:	57                   	push   %edi
801010d0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801010d6:	e8 85 77 00 00       	call   80108860 <allocuvm>
801010db:	83 c4 10             	add    $0x10,%esp
801010de:	85 c0                	test   %eax,%eax
801010e0:	89 c7                	mov    %eax,%edi
801010e2:	74 65                	je     80101149 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
801010e4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801010ea:	a9 ff 0f 00 00       	test   $0xfff,%eax
801010ef:	75 58                	jne    80101149 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801010f1:	83 ec 0c             	sub    $0xc,%esp
801010f4:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
801010fa:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101100:	53                   	push   %ebx
80101101:	50                   	push   %eax
80101102:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80101108:	e8 93 76 00 00       	call   801087a0 <loaduvm>
8010110d:	83 c4 20             	add    $0x20,%esp
80101110:	85 c0                	test   %eax,%eax
80101112:	78 35                	js     80101149 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101114:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010111b:	83 c6 01             	add    $0x1,%esi
8010111e:	39 f0                	cmp    %esi,%eax
80101120:	7e 3d                	jle    8010115f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101122:	89 f0                	mov    %esi,%eax
80101124:	6a 20                	push   $0x20
80101126:	c1 e0 05             	shl    $0x5,%eax
80101129:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
8010112f:	50                   	push   %eax
80101130:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80101136:	50                   	push   %eax
80101137:	53                   	push   %ebx
80101138:	e8 73 12 00 00       	call   801023b0 <readi>
8010113d:	83 c4 10             	add    $0x10,%esp
80101140:	83 f8 20             	cmp    $0x20,%eax
80101143:	0f 84 5f ff ff ff    	je     801010a8 <exec+0xb8>
    freevm(pgdir);
80101149:	83 ec 0c             	sub    $0xc,%esp
8010114c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80101152:	e8 69 78 00 00       	call   801089c0 <freevm>
80101157:	83 c4 10             	add    $0x10,%esp
8010115a:	e9 e7 fe ff ff       	jmp    80101046 <exec+0x56>
8010115f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80101165:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
8010116b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101171:	83 ec 0c             	sub    $0xc,%esp
80101174:	53                   	push   %ebx
80101175:	e8 e6 11 00 00       	call   80102360 <iunlockput>
  end_op();
8010117a:	e8 e1 24 00 00       	call   80103660 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
8010117f:	83 c4 0c             	add    $0xc,%esp
80101182:	56                   	push   %esi
80101183:	57                   	push   %edi
80101184:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8010118a:	e8 d1 76 00 00       	call   80108860 <allocuvm>
8010118f:	83 c4 10             	add    $0x10,%esp
80101192:	85 c0                	test   %eax,%eax
80101194:	89 c6                	mov    %eax,%esi
80101196:	75 3a                	jne    801011d2 <exec+0x1e2>
    freevm(pgdir);
80101198:	83 ec 0c             	sub    $0xc,%esp
8010119b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801011a1:	e8 1a 78 00 00       	call   801089c0 <freevm>
801011a6:	83 c4 10             	add    $0x10,%esp
  return -1;
801011a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011ae:	e9 a9 fe ff ff       	jmp    8010105c <exec+0x6c>
    end_op();
801011b3:	e8 a8 24 00 00       	call   80103660 <end_op>
    cprintf("exec: fail\n");
801011b8:	83 ec 0c             	sub    $0xc,%esp
801011bb:	68 8d 8e 10 80       	push   $0x80108e8d
801011c0:	e8 7b fa ff ff       	call   80100c40 <cprintf>
    return -1;
801011c5:	83 c4 10             	add    $0x10,%esp
801011c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011cd:	e9 8a fe ff ff       	jmp    8010105c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801011d2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
801011d8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
801011db:	31 ff                	xor    %edi,%edi
801011dd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801011df:	50                   	push   %eax
801011e0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801011e6:	e8 f5 78 00 00       	call   80108ae0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801011eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801011ee:	83 c4 10             	add    $0x10,%esp
801011f1:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801011f7:	8b 00                	mov    (%eax),%eax
801011f9:	85 c0                	test   %eax,%eax
801011fb:	74 70                	je     8010126d <exec+0x27d>
801011fd:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80101203:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80101209:	eb 0a                	jmp    80101215 <exec+0x225>
8010120b:	90                   	nop
8010120c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80101210:	83 ff 20             	cmp    $0x20,%edi
80101213:	74 83                	je     80101198 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101215:	83 ec 0c             	sub    $0xc,%esp
80101218:	50                   	push   %eax
80101219:	e8 62 4b 00 00       	call   80105d80 <strlen>
8010121e:	f7 d0                	not    %eax
80101220:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101222:	8b 45 0c             	mov    0xc(%ebp),%eax
80101225:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101226:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101229:	ff 34 b8             	pushl  (%eax,%edi,4)
8010122c:	e8 4f 4b 00 00       	call   80105d80 <strlen>
80101231:	83 c0 01             	add    $0x1,%eax
80101234:	50                   	push   %eax
80101235:	8b 45 0c             	mov    0xc(%ebp),%eax
80101238:	ff 34 b8             	pushl  (%eax,%edi,4)
8010123b:	53                   	push   %ebx
8010123c:	56                   	push   %esi
8010123d:	e8 ee 79 00 00       	call   80108c30 <copyout>
80101242:	83 c4 20             	add    $0x20,%esp
80101245:	85 c0                	test   %eax,%eax
80101247:	0f 88 4b ff ff ff    	js     80101198 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
8010124d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101250:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80101257:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010125a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101260:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101263:	85 c0                	test   %eax,%eax
80101265:	75 a9                	jne    80101210 <exec+0x220>
80101267:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010126d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101274:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101276:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
8010127d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80101281:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80101288:	ff ff ff 
  ustack[1] = argc;
8010128b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101291:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80101293:	83 c0 0c             	add    $0xc,%eax
80101296:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101298:	50                   	push   %eax
80101299:	52                   	push   %edx
8010129a:	53                   	push   %ebx
8010129b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801012a1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801012a7:	e8 84 79 00 00       	call   80108c30 <copyout>
801012ac:	83 c4 10             	add    $0x10,%esp
801012af:	85 c0                	test   %eax,%eax
801012b1:	0f 88 e1 fe ff ff    	js     80101198 <exec+0x1a8>
  for(last=s=path; *s; s++)
801012b7:	8b 45 08             	mov    0x8(%ebp),%eax
801012ba:	0f b6 00             	movzbl (%eax),%eax
801012bd:	84 c0                	test   %al,%al
801012bf:	74 17                	je     801012d8 <exec+0x2e8>
801012c1:	8b 55 08             	mov    0x8(%ebp),%edx
801012c4:	89 d1                	mov    %edx,%ecx
801012c6:	83 c1 01             	add    $0x1,%ecx
801012c9:	3c 2f                	cmp    $0x2f,%al
801012cb:	0f b6 01             	movzbl (%ecx),%eax
801012ce:	0f 44 d1             	cmove  %ecx,%edx
801012d1:	84 c0                	test   %al,%al
801012d3:	75 f1                	jne    801012c6 <exec+0x2d6>
801012d5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801012d8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801012de:	50                   	push   %eax
801012df:	6a 10                	push   $0x10
801012e1:	ff 75 08             	pushl  0x8(%ebp)
801012e4:	89 f8                	mov    %edi,%eax
801012e6:	83 c0 6c             	add    $0x6c,%eax
801012e9:	50                   	push   %eax
801012ea:	e8 51 4a 00 00       	call   80105d40 <safestrcpy>
  curproc->pgdir = pgdir;
801012ef:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
801012f5:	89 f9                	mov    %edi,%ecx
801012f7:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
801012fa:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
801012fd:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
801012ff:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80101302:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80101308:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
8010130b:	8b 41 18             	mov    0x18(%ecx),%eax
8010130e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80101311:	89 0c 24             	mov    %ecx,(%esp)
80101314:	e8 f7 72 00 00       	call   80108610 <switchuvm>
  freevm(oldpgdir);
80101319:	89 3c 24             	mov    %edi,(%esp)
8010131c:	e8 9f 76 00 00       	call   801089c0 <freevm>
  return 0;
80101321:	83 c4 10             	add    $0x10,%esp
80101324:	31 c0                	xor    %eax,%eax
80101326:	e9 31 fd ff ff       	jmp    8010105c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010132b:	be 00 20 00 00       	mov    $0x2000,%esi
80101330:	e9 3c fe ff ff       	jmp    80101171 <exec+0x181>
80101335:	66 90                	xchg   %ax,%ax
80101337:	66 90                	xchg   %ax,%ax
80101339:	66 90                	xchg   %ax,%ax
8010133b:	66 90                	xchg   %ax,%ax
8010133d:	66 90                	xchg   %ax,%ax
8010133f:	90                   	nop

80101340 <e1000_tx_init>:

uint8_t mac_addr[6];

int
e1000_tx_init(void) 
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	83 ec 0c             	sub    $0xc,%esp
    assert(sizeof(struct e1000_tx_desc) == 16);
    assert(((uint32_t)(&tx_queue[0]) & 0xf) == 0);
    assert(sizeof(tx_queue) % 128 == 0);
	
    // Initialize packet buffers
    memset(tx_queue, 0, sizeof(tx_queue));
80101346:	68 00 01 00 00       	push   $0x100
8010134b:	6a 00                	push   $0x0
8010134d:	68 80 2c 15 80       	push   $0x80152c80
80101352:	e8 09 48 00 00       	call   80105b60 <memset>
80101357:	b8 a0 cd 14 00       	mov    $0x14cda0,%eax
8010135c:	83 c4 10             	add    $0x10,%esp
8010135f:	ba 80 2c 15 80       	mov    $0x80152c80,%edx
80101364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < NTXDESC; i++) 
        tx_queue[i].buff_addr = V2P(tx_buffs[i]);
80101368:	89 02                	mov    %eax,(%edx)
8010136a:	05 ee 05 00 00       	add    $0x5ee,%eax
8010136f:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
80101376:	83 c2 10             	add    $0x10,%edx
    for (i = 0; i < NTXDESC; i++) 
80101379:	3d 80 2c 15 00       	cmp    $0x152c80,%eax
8010137e:	75 e8                	jne    80101368 <e1000_tx_init+0x28>
    
    // Initialize regs of transmit descriptor ring (a.k.a. transmit queue)
    E1000_REG(E1000_TDBAL) = V2P(tx_queue); 
80101380:	a1 54 88 15 80       	mov    0x80158854,%eax
80101385:	c7 80 00 38 00 00 80 	movl   $0x152c80,0x3800(%eax)
8010138c:	2c 15 00 
    E1000_REG(E1000_TDBAH) = 0;
8010138f:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
80101396:	00 00 00 
    E1000_REG(E1000_TDLEN) = sizeof(tx_queue);
80101399:	c7 80 08 38 00 00 00 	movl   $0x100,0x3808(%eax)
801013a0:	01 00 00 
    E1000_REG(E1000_TDH)   = 0;
801013a3:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
801013aa:	00 00 00 
    E1000_REG(E1000_TDT)   = 0;
801013ad:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
801013b4:	00 00 00 
    // Program TCTL & TIPG
//#define E1000_TCTL           0x00400    /* Transmit Control - R/W */
//#define E1000_TCTL_EN     0x00000002    /* enable */
//#define E1000_TCTL_PSP    0x00000008    /* pad short packets */
//#define E1000_TCTL_COLD   0x003ff000    /* collision distance */
    E1000_REG(E1000_TCTL) |= E1000_TCTL_EN;
801013b7:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
801013bd:	83 ca 02             	or     $0x2,%edx
801013c0:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
    E1000_REG(E1000_TCTL) |= E1000_TCTL_PSP;
801013c6:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
801013cc:	83 ca 08             	or     $0x8,%edx
801013cf:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

    E1000_REG(E1000_TCTL) &= ~E1000_TCTL_COLD;
801013d5:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
801013db:	81 e2 ff 0f c0 ff    	and    $0xffc00fff,%edx
801013e1:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
    E1000_REG(E1000_TCTL) |= 0x00040000; // TCTL.COLD: 40h
801013e7:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
801013ed:	81 ca 00 00 04 00    	or     $0x40000,%edx
801013f3:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)

    E1000_REG(E1000_TIPG)  = 10;
801013f9:	c7 80 10 04 00 00 0a 	movl   $0xa,0x410(%eax)
80101400:	00 00 00 
    
    return 0;
}
80101403:	31 c0                	xor    %eax,%eax
80101405:	c9                   	leave  
80101406:	c3                   	ret    
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <e1000_rx_init>:

int
e1000_rx_init(void)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	83 ec 0c             	sub    $0xc,%esp
    int i;
    memset(rx_queue, 0, sizeof(rx_queue));
80101416:	68 00 08 00 00       	push   $0x800
8010141b:	6a 00                	push   $0x0
8010141d:	68 a0 c5 14 80       	push   $0x8014c5a0
80101422:	e8 39 47 00 00       	call   80105b60 <memset>
80101427:	b8 a0 c5 10 00       	mov    $0x10c5a0,%eax
8010142c:	83 c4 10             	add    $0x10,%esp
8010142f:	ba a0 c5 14 80       	mov    $0x8014c5a0,%edx
80101434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < NRXDESC; i++)
        rx_queue[i].buff_addr = V2P(rx_buffs[i]);
80101438:	89 02                	mov    %eax,(%edx)
8010143a:	05 00 08 00 00       	add    $0x800,%eax
8010143f:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
80101446:	83 c2 10             	add    $0x10,%edx
    for (i = 0; i < NRXDESC; i++)
80101449:	3d a0 c5 14 00       	cmp    $0x14c5a0,%eax
8010144e:	75 e8                	jne    80101438 <e1000_rx_init+0x28>
    
    // configure the Receive Adress Registers with the card's 
    // own MAC address ( 52:54:00:12:34:56 ) in order to accept
    // packets addressed to the card
    E1000_REG(E1000_RAL0)  = 0x12005452;
80101450:	a1 54 88 15 80       	mov    0x80158854,%eax
80101455:	c7 80 00 54 00 00 52 	movl   $0x12005452,0x5400(%eax)
8010145c:	54 00 12 
    E1000_REG(E1000_RAH0)  = 0x80005634;   
8010145f:	c7 80 04 54 00 00 34 	movl   $0x80005634,0x5404(%eax)
80101466:	56 00 80 
   uint32_t macaddr_l = E1000_REG(E1000_RAL0);
80101469:	8b 88 00 54 00 00    	mov    0x5400(%eax),%ecx
  uint32_t macaddr_h = E1000_REG(E1000_RAH0);
8010146f:	8b 90 04 54 00 00    	mov    0x5404(%eax),%edx
  *(uint32_t*)mac_addr = macaddr_l;
  *(uint16_t*)(&mac_addr[4]) = (uint16_t)macaddr_h;
  *(uint32_t*)mac_addr = macaddr_l;
  *(uint32_t*)(&mac_addr[4]) = (uint16_t)macaddr_h; 
80101475:	81 e2 ff ff 00 00    	and    $0xffff,%edx
  *(uint32_t*)mac_addr = macaddr_l;
8010147b:	89 0d 4c 88 15 80    	mov    %ecx,0x8015884c
  *(uint32_t*)(&mac_addr[4]) = (uint16_t)macaddr_h; 
80101481:	89 15 50 88 15 80    	mov    %edx,0x80158850

    // initialize regs of receive descriptor ring
    E1000_REG(E1000_RDBAL) = V2P(rx_queue); 
80101487:	c7 80 00 28 00 00 a0 	movl   $0x14c5a0,0x2800(%eax)
8010148e:	c5 14 00 
    E1000_REG(E1000_RDBAH) = 0;
80101491:	c7 80 04 28 00 00 00 	movl   $0x0,0x2804(%eax)
80101498:	00 00 00 
    E1000_REG(E1000_RDLEN) = sizeof(rx_queue);
8010149b:	c7 80 08 28 00 00 00 	movl   $0x800,0x2808(%eax)
801014a2:	08 00 00 
    E1000_REG(E1000_RDH)   = 0;
801014a5:	c7 80 10 28 00 00 00 	movl   $0x0,0x2810(%eax)
801014ac:	00 00 00 
    E1000_REG(E1000_RDT)   = NRXDESC - 1;
801014af:	c7 80 18 28 00 00 7f 	movl   $0x7f,0x2818(%eax)
801014b6:	00 00 00 
    
    // enable receive
    E1000_REG(E1000_RCTL) |= E1000_RCTL_EN;
801014b9:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
801014bf:	83 ca 02             	or     $0x2,%edx
801014c2:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
    
    // configure e1000 to strip the Ethernet CRC
    E1000_REG(E1000_RCTL) |= E1000_RCTL_SECRC;
801014c8:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
801014ce:	81 ca 00 00 00 04    	or     $0x4000000,%edx
801014d4:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)

    E1000_REG(E1000_RCTL) |=        E1000_RCTL_UPE;    /* unicast promiscuous enable */
801014da:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
801014e0:	83 ca 08             	or     $0x8,%edx
801014e3:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
    E1000_REG(E1000_RCTL) |=       E1000_RCTL_MPE;
801014e9:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
801014ef:	83 ca 10             	or     $0x10,%edx
801014f2:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
     
    return 0;
}
801014f8:	31 c0                	xor    %eax,%eax
801014fa:	c9                   	leave  
801014fb:	c3                   	ret    
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <e1000_transmit>:

int 
e1000_transmit(const void *data, size_t len) 
{
80101500:	55                   	push   %ebp
    uint32_t tail = E1000_REG(E1000_TDT);
80101501:	a1 54 88 15 80       	mov    0x80158854,%eax
{
80101506:	89 e5                	mov    %esp,%ebp
80101508:	56                   	push   %esi
80101509:	53                   	push   %ebx
8010150a:	8b 75 0c             	mov    0xc(%ebp),%esi
    uint32_t tail = E1000_REG(E1000_TDT);
8010150d:	8b 98 18 38 00 00    	mov    0x3818(%eax),%ebx

    if (len > TX_PKT_BUFF_SIZE)
80101513:	81 fe ee 05 00 00    	cmp    $0x5ee,%esi
80101519:	77 65                	ja     80101580 <e1000_transmit+0x80>
        return -E_PKT_TOO_LONG;	

    if ((tx_queue[tail].cmd & E1000_TXD_CMD_RS) 
8010151b:	89 d8                	mov    %ebx,%eax
8010151d:	c1 e0 04             	shl    $0x4,%eax
80101520:	05 80 2c 15 80       	add    $0x80152c80,%eax
80101525:	f6 40 0b 08          	testb  $0x8,0xb(%eax)
80101529:	74 06                	je     80101531 <e1000_transmit+0x31>
        && !(tx_queue[tail].sta & E1000_TXD_STA_DD))
8010152b:	f6 40 0c 01          	testb  $0x1,0xc(%eax)
8010152f:	74 5f                	je     80101590 <e1000_transmit+0x90>
        return -E_TX_FULL;

    memcpy(tx_buffs[tail], data, len);
80101531:	69 c3 ee 05 00 00    	imul   $0x5ee,%ebx,%eax
80101537:	83 ec 04             	sub    $0x4,%esp
8010153a:	56                   	push   %esi
8010153b:	ff 75 08             	pushl  0x8(%ebp)
8010153e:	05 a0 cd 14 80       	add    $0x8014cda0,%eax
80101543:	50                   	push   %eax
80101544:	e8 27 47 00 00       	call   80105c70 <memcpy>
    tx_queue[tail].length = len;
80101549:	89 d8                	mov    %ebx,%eax
    tx_queue[tail].cmd |= E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;
    tx_queue[tail].sta &= ~E1000_TXD_STA_DD;

    E1000_REG(E1000_TDT) = (tail + 1) % NTXDESC;
8010154b:	83 c3 01             	add    $0x1,%ebx
   
    return 0;
8010154e:	83 c4 10             	add    $0x10,%esp
    tx_queue[tail].length = len;
80101551:	c1 e0 04             	shl    $0x4,%eax
    E1000_REG(E1000_TDT) = (tail + 1) % NTXDESC;
80101554:	83 e3 0f             	and    $0xf,%ebx
    tx_queue[tail].length = len;
80101557:	66 89 b0 88 2c 15 80 	mov    %si,-0x7fead378(%eax)
8010155e:	05 80 2c 15 80       	add    $0x80152c80,%eax
    tx_queue[tail].cmd |= E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;
80101563:	80 48 0b 09          	orb    $0x9,0xb(%eax)
    tx_queue[tail].sta &= ~E1000_TXD_STA_DD;
80101567:	80 60 0c fe          	andb   $0xfe,0xc(%eax)
    E1000_REG(E1000_TDT) = (tail + 1) % NTXDESC;
8010156b:	a1 54 88 15 80       	mov    0x80158854,%eax
80101570:	89 98 18 38 00 00    	mov    %ebx,0x3818(%eax)
    return 0;
80101576:	31 c0                	xor    %eax,%eax
}
80101578:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010157b:	5b                   	pop    %ebx
8010157c:	5e                   	pop    %esi
8010157d:	5d                   	pop    %ebp
8010157e:	c3                   	ret    
8010157f:	90                   	nop
        return -E_PKT_TOO_LONG;	
80101580:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101585:	eb f1                	jmp    80101578 <e1000_transmit+0x78>
80101587:	89 f6                	mov    %esi,%esi
80101589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -E_TX_FULL;
80101590:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
80101595:	eb e1                	jmp    80101578 <e1000_transmit+0x78>
80101597:	89 f6                	mov    %esi,%esi
80101599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801015a0 <parse1>:
	unsigned char version[2];
	unsigned char length[2];
};


void parse1(char *packet, int len){
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	56                   	push   %esi
801015a4:	53                   	push   %ebx
801015a5:	8b 75 08             	mov    0x8(%ebp),%esi


           int  j;
    printf("len =%d\n",len);
801015a8:	83 ec 08             	sub    $0x8,%esp
801015ab:	ff 75 0c             	pushl  0xc(%ebp)
801015ae:	68 99 8e 10 80       	push   $0x80108e99
801015b3:	8d 5e 06             	lea    0x6(%esi),%ebx
801015b6:	83 c6 0c             	add    $0xc,%esi
801015b9:	e8 82 f6 ff ff       	call   80100c40 <cprintf>
    struct ethernet_h * ethernet;
   // struct ip_h * ip;
   // struct tcp_h * tcp;
        /*ethernet header memory map*/
        ethernet = (struct ethernet_h *)(packet);
        printf("\nMAC src:\t");
801015be:	c7 04 24 a2 8e 10 80 	movl   $0x80108ea2,(%esp)
801015c5:	e8 76 f6 ff ff       	call   80100c40 <cprintf>
801015ca:	83 c4 10             	add    $0x10,%esp
801015cd:	8d 76 00             	lea    0x0(%esi),%esi
        for(j=0;j<6;j++)
        {
            printf("%x:", ethernet->srcAddress[j]);
801015d0:	0f b6 03             	movzbl (%ebx),%eax
801015d3:	83 ec 08             	sub    $0x8,%esp
801015d6:	83 c3 01             	add    $0x1,%ebx
801015d9:	50                   	push   %eax
801015da:	68 ad 8e 10 80       	push   $0x80108ead
801015df:	e8 5c f6 ff ff       	call   80100c40 <cprintf>
        for(j=0;j<6;j++)
801015e4:	83 c4 10             	add    $0x10,%esp
801015e7:	39 f3                	cmp    %esi,%ebx
801015e9:	75 e5                	jne    801015d0 <parse1+0x30>
        }
 printf("\n");
801015eb:	c7 45 08 57 9c 10 80 	movl   $0x80109c57,0x8(%ebp)

       
}
801015f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015f5:	5b                   	pop    %ebx
801015f6:	5e                   	pop    %esi
801015f7:	5d                   	pop    %ebp
 printf("\n");
801015f8:	e9 43 f6 ff ff       	jmp    80100c40 <cprintf>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <e1000_receive>:

void net_rx(struct mbuf *m);
void
e1000_receive()
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	57                   	push   %edi
80101604:	56                   	push   %esi
80101605:	53                   	push   %ebx
80101606:	83 ec 1c             	sub    $0x1c,%esp
    uint32_t tail;
    uint32_t next;
    int len;
    struct mbuf *m;
while (1){
tail = E1000_REG(E1000_RDT);
80101609:	a1 54 88 15 80       	mov    0x80158854,%eax
8010160e:	8b 98 18 28 00 00    	mov    0x2818(%eax),%ebx
    next = (tail + 1) % NRXDESC;
80101614:	83 c3 01             	add    $0x1,%ebx
80101617:	83 e3 7f             	and    $0x7f,%ebx
    if (!(rx_queue[next].sta & E1000_RXD_STA_DD))
8010161a:	89 d8                	mov    %ebx,%eax
8010161c:	c1 e0 04             	shl    $0x4,%eax
8010161f:	f6 80 ac c5 14 80 01 	testb  $0x1,-0x7feb3a54(%eax)
80101626:	0f 84 9b 00 00 00    	je     801016c7 <e1000_receive+0xc7>
8010162c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return;
 
    len = rx_queue[next].length;
80101630:	89 da                	mov    %ebx,%edx
      //  return -E_PKT_TOO_LONG;

 
	    
	    
    m = mbufalloc(0);
80101632:	83 ec 0c             	sub    $0xc,%esp
    len = rx_queue[next].length;
80101635:	c1 e2 04             	shl    $0x4,%edx
    m = mbufalloc(0);
80101638:	6a 00                	push   $0x0
    len = rx_queue[next].length;
8010163a:	0f b7 b2 a8 c5 14 80 	movzwl -0x7feb3a58(%edx),%esi
80101641:	81 c2 a0 c5 14 80    	add    $0x8014c5a0,%edx
80101647:	89 55 e0             	mov    %edx,-0x20(%ebp)
    m = mbufalloc(0);
8010164a:	e8 c1 27 00 00       	call   80103e10 <mbufalloc>
8010164f:	89 c7                	mov    %eax,%edi
    m->len = len;
80101651:	89 70 08             	mov    %esi,0x8(%eax)
	    
 parse1((char *)rx_buffs[next],len);
80101654:	89 d8                	mov    %ebx,%eax
80101656:	5a                   	pop    %edx
80101657:	c1 e0 0b             	shl    $0xb,%eax
8010165a:	59                   	pop    %ecx
8010165b:	05 a0 c5 10 80       	add    $0x8010c5a0,%eax
80101660:	56                   	push   %esi
80101661:	50                   	push   %eax
80101662:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101665:	e8 36 ff ff ff       	call   801015a0 <parse1>

    memcpy(m->head, rx_buffs[next], len);
8010166a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010166d:	83 c4 0c             	add    $0xc,%esp
80101670:	56                   	push   %esi
80101671:	50                   	push   %eax
80101672:	ff 77 04             	pushl  0x4(%edi)
80101675:	e8 f6 45 00 00       	call   80105c70 <memcpy>
    rx_queue[next].sta &= ~E1000_RXD_STA_DD;
8010167a:	8b 55 e0             	mov    -0x20(%ebp),%edx

    E1000_REG(E1000_RDT) = next;
8010167d:	a1 54 88 15 80       	mov    0x80158854,%eax
    rx_queue[next].sta &= ~E1000_RXD_STA_DD;
80101682:	80 62 0c fe          	andb   $0xfe,0xc(%edx)
    E1000_REG(E1000_RDT) = next;
80101686:	89 98 18 28 00 00    	mov    %ebx,0x2818(%eax)
cprintf("call net_rx %p",m);
8010168c:	5b                   	pop    %ebx
8010168d:	5e                   	pop    %esi
8010168e:	57                   	push   %edi
8010168f:	68 b1 8e 10 80       	push   $0x80108eb1
80101694:	e8 a7 f5 ff ff       	call   80100c40 <cprintf>
    net_rx(m);
80101699:	89 3c 24             	mov    %edi,(%esp)
8010169c:	e8 4f 29 00 00       	call   80103ff0 <net_rx>
tail = E1000_REG(E1000_RDT);
801016a1:	a1 54 88 15 80       	mov    0x80158854,%eax
    if (!(rx_queue[next].sta & E1000_RXD_STA_DD))
801016a6:	83 c4 10             	add    $0x10,%esp
tail = E1000_REG(E1000_RDT);
801016a9:	8b 98 18 28 00 00    	mov    0x2818(%eax),%ebx
    next = (tail + 1) % NRXDESC;
801016af:	83 c3 01             	add    $0x1,%ebx
801016b2:	83 e3 7f             	and    $0x7f,%ebx
    if (!(rx_queue[next].sta & E1000_RXD_STA_DD))
801016b5:	89 d8                	mov    %ebx,%eax
801016b7:	c1 e0 04             	shl    $0x4,%eax
801016ba:	f6 80 ac c5 14 80 01 	testb  $0x1,-0x7feb3a54(%eax)
801016c1:	0f 85 69 ff ff ff    	jne    80101630 <e1000_receive+0x30>
    }
}
801016c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ca:	5b                   	pop    %ebx
801016cb:	5e                   	pop    %esi
801016cc:	5f                   	pop    %edi
801016cd:	5d                   	pop    %ebp
801016ce:	c3                   	ret    
801016cf:	90                   	nop

801016d0 <e1000_init>:

int e1000_init(){
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	83 ec 10             	sub    $0x10,%esp
	E1000_REG(E1000_IMS) = E1000_IMS_RXT0;
801016d6:	a1 54 88 15 80       	mov    0x80158854,%eax
801016db:	c7 80 d0 00 00 00 80 	movl   $0x80,0xd0(%eax)
801016e2:	00 00 00 
	ioapicenable(IRQ_ETH, 0);
801016e5:	6a 00                	push   $0x0
801016e7:	6a 0b                	push   $0xb
801016e9:	e8 32 16 00 00       	call   80102d20 <ioapicenable>
	return 1;
}
801016ee:	b8 01 00 00 00       	mov    $0x1,%eax
801016f3:	c9                   	leave  
801016f4:	c3                   	ret    
801016f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101700 <ethintr>:
void ethintr(){
	
       
E1000_REG(E1000_ICR);
80101700:	a1 54 88 15 80       	mov    0x80158854,%eax
void ethintr(){
80101705:	55                   	push   %ebp
80101706:	89 e5                	mov    %esp,%ebp
E1000_REG(E1000_ICR);
80101708:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
	E1000_REG(E1000_IMS) = E1000_IMS_RXT0;
8010170e:	c7 80 d0 00 00 00 80 	movl   $0x80,0xd0(%eax)
80101715:	00 00 00 
 e1000_receive();
}
80101718:	5d                   	pop    %ebp
 e1000_receive();
80101719:	e9 e2 fe ff ff       	jmp    80101600 <e1000_receive>
8010171e:	66 90                	xchg   %ax,%ax

80101720 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101726:	68 c0 8e 10 80       	push   $0x80108ec0
8010172b:	68 60 88 15 80       	push   $0x80158860
80101730:	e8 bb 41 00 00       	call   801058f0 <initlock>
}
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	c9                   	leave  
80101739:	c3                   	ret    
8010173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101740 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101744:	bb 94 88 15 80       	mov    $0x80158894,%ebx
{
80101749:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010174c:	68 60 88 15 80       	push   $0x80158860
80101751:	e8 8a 42 00 00       	call   801059e0 <acquire>
80101756:	83 c4 10             	add    $0x10,%esp
80101759:	eb 10                	jmp    8010176b <filealloc+0x2b>
8010175b:	90                   	nop
8010175c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101760:	83 c3 20             	add    $0x20,%ebx
80101763:	81 fb 14 95 15 80    	cmp    $0x80159514,%ebx
80101769:	73 25                	jae    80101790 <filealloc+0x50>
    if(f->ref == 0){
8010176b:	8b 43 04             	mov    0x4(%ebx),%eax
8010176e:	85 c0                	test   %eax,%eax
80101770:	75 ee                	jne    80101760 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101772:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101775:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010177c:	68 60 88 15 80       	push   $0x80158860
80101781:	e8 7a 43 00 00       	call   80105b00 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101786:	89 d8                	mov    %ebx,%eax
      return f;
80101788:	83 c4 10             	add    $0x10,%esp
}
8010178b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010178e:	c9                   	leave  
8010178f:	c3                   	ret    
  release(&ftable.lock);
80101790:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101793:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101795:	68 60 88 15 80       	push   $0x80158860
8010179a:	e8 61 43 00 00       	call   80105b00 <release>
}
8010179f:	89 d8                	mov    %ebx,%eax
  return 0;
801017a1:	83 c4 10             	add    $0x10,%esp
}
801017a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017a7:	c9                   	leave  
801017a8:	c3                   	ret    
801017a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801017b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	53                   	push   %ebx
801017b4:	83 ec 10             	sub    $0x10,%esp
801017b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801017ba:	68 60 88 15 80       	push   $0x80158860
801017bf:	e8 1c 42 00 00       	call   801059e0 <acquire>
  if(f->ref < 1)
801017c4:	8b 43 04             	mov    0x4(%ebx),%eax
801017c7:	83 c4 10             	add    $0x10,%esp
801017ca:	85 c0                	test   %eax,%eax
801017cc:	7e 1a                	jle    801017e8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801017ce:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801017d1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801017d4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801017d7:	68 60 88 15 80       	push   $0x80158860
801017dc:	e8 1f 43 00 00       	call   80105b00 <release>
  return f;
}
801017e1:	89 d8                	mov    %ebx,%eax
801017e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e6:	c9                   	leave  
801017e7:	c3                   	ret    
    panic("filedup");
801017e8:	83 ec 0c             	sub    $0xc,%esp
801017eb:	68 c7 8e 10 80       	push   $0x80108ec7
801017f0:	e8 7b f1 ff ff       	call   80100970 <panic>
801017f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101800 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	57                   	push   %edi
80101804:	56                   	push   %esi
80101805:	53                   	push   %ebx
80101806:	83 ec 28             	sub    $0x28,%esp
80101809:	8b 75 08             	mov    0x8(%ebp),%esi
  struct file ff;

  acquire(&ftable.lock);
8010180c:	68 60 88 15 80       	push   $0x80158860
80101811:	e8 ca 41 00 00       	call   801059e0 <acquire>
  if(f->ref < 1)
80101816:	8b 46 04             	mov    0x4(%esi),%eax
80101819:	83 c4 10             	add    $0x10,%esp
8010181c:	85 c0                	test   %eax,%eax
8010181e:	0f 8e bb 00 00 00    	jle    801018df <fileclose+0xdf>
    panic("fileclose");
  if(--f->ref > 0){
80101824:	83 e8 01             	sub    $0x1,%eax
80101827:	85 c0                	test   %eax,%eax
80101829:	89 46 04             	mov    %eax,0x4(%esi)
8010182c:	74 1a                	je     80101848 <fileclose+0x48>
    release(&ftable.lock);
8010182e:	c7 45 08 60 88 15 80 	movl   $0x80158860,0x8(%ebp)
    else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101835:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101838:	5b                   	pop    %ebx
80101839:	5e                   	pop    %esi
8010183a:	5f                   	pop    %edi
8010183b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010183c:	e9 bf 42 00 00       	jmp    80105b00 <release>
80101841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101848:	0f b6 46 09          	movzbl 0x9(%esi),%eax
8010184c:	8b 3e                	mov    (%esi),%edi
  release(&ftable.lock);
8010184e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101851:	8b 5e 10             	mov    0x10(%esi),%ebx
  f->type = FD_NONE;
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  ff = *f;
8010185a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010185d:	8b 46 14             	mov    0x14(%esi),%eax
80101860:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101863:	8b 46 18             	mov    0x18(%esi),%eax
  release(&ftable.lock);
80101866:	68 60 88 15 80       	push   $0x80158860
  ff = *f;
8010186b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010186e:	e8 8d 42 00 00       	call   80105b00 <release>
  if(ff.type == FD_PIPE)
80101873:	83 c4 10             	add    $0x10,%esp
80101876:	83 ff 01             	cmp    $0x1,%edi
80101879:	74 15                	je     80101890 <fileclose+0x90>
    if(ff.type == FD_SOCK){
8010187b:	83 ff 04             	cmp    $0x4,%edi
8010187e:	74 28                	je     801018a8 <fileclose+0xa8>
    else if(ff.type == FD_INODE){
80101880:	83 ff 02             	cmp    $0x2,%edi
80101883:	74 3b                	je     801018c0 <fileclose+0xc0>
}
80101885:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101888:	5b                   	pop    %ebx
80101889:	5e                   	pop    %esi
8010188a:	5f                   	pop    %edi
8010188b:	5d                   	pop    %ebp
8010188c:	c3                   	ret    
8010188d:	8d 76 00             	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101890:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80101894:	83 ec 08             	sub    $0x8,%esp
80101897:	50                   	push   %eax
80101898:	53                   	push   %ebx
80101899:	e8 c2 31 00 00       	call   80104a60 <pipeclose>
8010189e:	83 c4 10             	add    $0x10,%esp
801018a1:	eb e2                	jmp    80101885 <fileclose+0x85>
801018a3:	90                   	nop
801018a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	    sockclose(ff.sock);
801018a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801018ab:	89 45 08             	mov    %eax,0x8(%ebp)
}
801018ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b1:	5b                   	pop    %ebx
801018b2:	5e                   	pop    %esi
801018b3:	5f                   	pop    %edi
801018b4:	5d                   	pop    %ebp
	    sockclose(ff.sock);
801018b5:	e9 d6 55 00 00       	jmp    80106e90 <sockclose>
801018ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
801018c0:	e8 2b 1d 00 00       	call   801035f0 <begin_op>
    iput(ff.ip);
801018c5:	83 ec 0c             	sub    $0xc,%esp
801018c8:	ff 75 dc             	pushl  -0x24(%ebp)
801018cb:	e8 30 09 00 00       	call   80102200 <iput>
    end_op();
801018d0:	83 c4 10             	add    $0x10,%esp
}
801018d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018d6:	5b                   	pop    %ebx
801018d7:	5e                   	pop    %esi
801018d8:	5f                   	pop    %edi
801018d9:	5d                   	pop    %ebp
    end_op();
801018da:	e9 81 1d 00 00       	jmp    80103660 <end_op>
    panic("fileclose");
801018df:	83 ec 0c             	sub    $0xc,%esp
801018e2:	68 cf 8e 10 80       	push   $0x80108ecf
801018e7:	e8 84 f0 ff ff       	call   80100970 <panic>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 04             	sub    $0x4,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801018fa:	83 3b 02             	cmpl   $0x2,(%ebx)
801018fd:	75 31                	jne    80101930 <filestat+0x40>
    ilock(f->ip);
801018ff:	83 ec 0c             	sub    $0xc,%esp
80101902:	ff 73 14             	pushl  0x14(%ebx)
80101905:	e8 c6 07 00 00       	call   801020d0 <ilock>
    stati(f->ip, st);
8010190a:	58                   	pop    %eax
8010190b:	5a                   	pop    %edx
8010190c:	ff 75 0c             	pushl  0xc(%ebp)
8010190f:	ff 73 14             	pushl  0x14(%ebx)
80101912:	e8 69 0a 00 00       	call   80102380 <stati>
    iunlock(f->ip);
80101917:	59                   	pop    %ecx
80101918:	ff 73 14             	pushl  0x14(%ebx)
8010191b:	e8 90 08 00 00       	call   801021b0 <iunlock>
    return 0;
80101920:	83 c4 10             	add    $0x10,%esp
80101923:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101925:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101928:	c9                   	leave  
80101929:	c3                   	ret    
8010192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101935:	eb ee                	jmp    80101925 <filestat+0x35>
80101937:	89 f6                	mov    %esi,%esi
80101939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101940 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 0c             	sub    $0xc,%esp
80101949:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010194c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010194f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101952:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101956:	0f 84 84 00 00 00    	je     801019e0 <fileread+0xa0>
    return -1;
  if(f->type == FD_PIPE)
8010195c:	8b 03                	mov    (%ebx),%eax
8010195e:	83 f8 01             	cmp    $0x1,%eax
80101961:	74 4d                	je     801019b0 <fileread+0x70>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_SOCK){
80101963:	83 f8 04             	cmp    $0x4,%eax
80101966:	74 60                	je     801019c8 <fileread+0x88>
      return sockread(f->sock, addr, n);
  }
  if(f->type == FD_INODE){
80101968:	83 f8 02             	cmp    $0x2,%eax
8010196b:	75 7a                	jne    801019e7 <fileread+0xa7>
    ilock(f->ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
80101970:	ff 73 14             	pushl  0x14(%ebx)
80101973:	e8 58 07 00 00       	call   801020d0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101978:	57                   	push   %edi
80101979:	ff 73 1c             	pushl  0x1c(%ebx)
8010197c:	56                   	push   %esi
8010197d:	ff 73 14             	pushl  0x14(%ebx)
80101980:	e8 2b 0a 00 00       	call   801023b0 <readi>
80101985:	83 c4 20             	add    $0x20,%esp
80101988:	85 c0                	test   %eax,%eax
8010198a:	89 c6                	mov    %eax,%esi
8010198c:	7e 03                	jle    80101991 <fileread+0x51>
      f->off += r;
8010198e:	01 43 1c             	add    %eax,0x1c(%ebx)
    iunlock(f->ip);
80101991:	83 ec 0c             	sub    $0xc,%esp
80101994:	ff 73 14             	pushl  0x14(%ebx)
80101997:	e8 14 08 00 00       	call   801021b0 <iunlock>
    return r;
8010199c:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010199f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019a2:	89 f0                	mov    %esi,%eax
801019a4:	5b                   	pop    %ebx
801019a5:	5e                   	pop    %esi
801019a6:	5f                   	pop    %edi
801019a7:	5d                   	pop    %ebp
801019a8:	c3                   	ret    
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801019b0:	8b 43 10             	mov    0x10(%ebx),%eax
801019b3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801019b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019b9:	5b                   	pop    %ebx
801019ba:	5e                   	pop    %esi
801019bb:	5f                   	pop    %edi
801019bc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801019bd:	e9 4e 32 00 00       	jmp    80104c10 <piperead>
801019c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return sockread(f->sock, addr, n);
801019c8:	8b 43 18             	mov    0x18(%ebx),%eax
801019cb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801019ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019d1:	5b                   	pop    %ebx
801019d2:	5e                   	pop    %esi
801019d3:	5f                   	pop    %edi
801019d4:	5d                   	pop    %ebp
      return sockread(f->sock, addr, n);
801019d5:	e9 26 56 00 00       	jmp    80107000 <sockread>
801019da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801019e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801019e5:	eb b8                	jmp    8010199f <fileread+0x5f>
  panic("fileread");
801019e7:	83 ec 0c             	sub    $0xc,%esp
801019ea:	68 d9 8e 10 80       	push   $0x80108ed9
801019ef:	e8 7c ef ff ff       	call   80100970 <panic>
801019f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801019fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101a00 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	57                   	push   %edi
80101a04:	56                   	push   %esi
80101a05:	53                   	push   %ebx
80101a06:	83 ec 1c             	sub    $0x1c,%esp
80101a09:	8b 75 08             	mov    0x8(%ebp),%esi
80101a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80101a0f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101a13:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101a16:	8b 45 10             	mov    0x10(%ebp),%eax
80101a19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101a1c:	0f 84 b2 00 00 00    	je     80101ad4 <filewrite+0xd4>
    return -1;
  if(f->type == FD_PIPE)
80101a22:	8b 06                	mov    (%esi),%eax
80101a24:	83 f8 01             	cmp    $0x1,%eax
80101a27:	0f 84 d3 00 00 00    	je     80101b00 <filewrite+0x100>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_SOCK){
80101a2d:	83 f8 04             	cmp    $0x4,%eax
80101a30:	0f 84 e2 00 00 00    	je     80101b18 <filewrite+0x118>
	return sockwrite(f->sock, addr, n);
  } 
  if(f->type == FD_INODE){
80101a36:	83 f8 02             	cmp    $0x2,%eax
80101a39:	0f 85 f8 00 00 00    	jne    80101b37 <filewrite+0x137>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101a3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101a42:	31 ff                	xor    %edi,%edi
    while(i < n){
80101a44:	85 c0                	test   %eax,%eax
80101a46:	7f 33                	jg     80101a7b <filewrite+0x7b>
80101a48:	e9 9b 00 00 00       	jmp    80101ae8 <filewrite+0xe8>
80101a4d:	8d 76 00             	lea    0x0(%esi),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101a50:	01 46 1c             	add    %eax,0x1c(%esi)
      iunlock(f->ip);
80101a53:	83 ec 0c             	sub    $0xc,%esp
80101a56:	ff 76 14             	pushl  0x14(%esi)
        f->off += r;
80101a59:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101a5c:	e8 4f 07 00 00       	call   801021b0 <iunlock>
      end_op();
80101a61:	e8 fa 1b 00 00       	call   80103660 <end_op>
80101a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a69:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101a6c:	39 c3                	cmp    %eax,%ebx
80101a6e:	0f 85 b6 00 00 00    	jne    80101b2a <filewrite+0x12a>
        panic("short filewrite");
      i += r;
80101a74:	01 df                	add    %ebx,%edi
    while(i < n){
80101a76:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a79:	7e 6d                	jle    80101ae8 <filewrite+0xe8>
      int n1 = n - i;
80101a7b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a7e:	b8 00 06 00 00       	mov    $0x600,%eax
80101a83:	29 fb                	sub    %edi,%ebx
80101a85:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101a8b:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101a8e:	e8 5d 1b 00 00       	call   801035f0 <begin_op>
      ilock(f->ip);
80101a93:	83 ec 0c             	sub    $0xc,%esp
80101a96:	ff 76 14             	pushl  0x14(%esi)
80101a99:	e8 32 06 00 00       	call   801020d0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101a9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101aa1:	53                   	push   %ebx
80101aa2:	ff 76 1c             	pushl  0x1c(%esi)
80101aa5:	01 f8                	add    %edi,%eax
80101aa7:	50                   	push   %eax
80101aa8:	ff 76 14             	pushl  0x14(%esi)
80101aab:	e8 00 0a 00 00       	call   801024b0 <writei>
80101ab0:	83 c4 20             	add    $0x20,%esp
80101ab3:	85 c0                	test   %eax,%eax
80101ab5:	7f 99                	jg     80101a50 <filewrite+0x50>
      iunlock(f->ip);
80101ab7:	83 ec 0c             	sub    $0xc,%esp
80101aba:	ff 76 14             	pushl  0x14(%esi)
80101abd:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101ac0:	e8 eb 06 00 00       	call   801021b0 <iunlock>
      end_op();
80101ac5:	e8 96 1b 00 00       	call   80103660 <end_op>
      if(r < 0)
80101aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101acd:	83 c4 10             	add    $0x10,%esp
80101ad0:	85 c0                	test   %eax,%eax
80101ad2:	74 98                	je     80101a6c <filewrite+0x6c>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101ad4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80101ad7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101adc:	89 f8                	mov    %edi,%eax
80101ade:	5b                   	pop    %ebx
80101adf:	5e                   	pop    %esi
80101ae0:	5f                   	pop    %edi
80101ae1:	5d                   	pop    %ebp
80101ae2:	c3                   	ret    
80101ae3:	90                   	nop
80101ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101ae8:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101aeb:	75 e7                	jne    80101ad4 <filewrite+0xd4>
}
80101aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101af0:	89 f8                	mov    %edi,%eax
80101af2:	5b                   	pop    %ebx
80101af3:	5e                   	pop    %esi
80101af4:	5f                   	pop    %edi
80101af5:	5d                   	pop    %ebp
80101af6:	c3                   	ret    
80101af7:	89 f6                	mov    %esi,%esi
80101af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return pipewrite(f->pipe, addr, n);
80101b00:	8b 46 10             	mov    0x10(%esi),%eax
80101b03:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101b06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b09:	5b                   	pop    %ebx
80101b0a:	5e                   	pop    %esi
80101b0b:	5f                   	pop    %edi
80101b0c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101b0d:	e9 ee 2f 00 00       	jmp    80104b00 <pipewrite>
80101b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	return sockwrite(f->sock, addr, n);
80101b18:	8b 46 18             	mov    0x18(%esi),%eax
80101b1b:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101b1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b21:	5b                   	pop    %ebx
80101b22:	5e                   	pop    %esi
80101b23:	5f                   	pop    %edi
80101b24:	5d                   	pop    %ebp
	return sockwrite(f->sock, addr, n);
80101b25:	e9 36 54 00 00       	jmp    80106f60 <sockwrite>
        panic("short filewrite");
80101b2a:	83 ec 0c             	sub    $0xc,%esp
80101b2d:	68 e2 8e 10 80       	push   $0x80108ee2
80101b32:	e8 39 ee ff ff       	call   80100970 <panic>
  panic("filewrite");
80101b37:	83 ec 0c             	sub    $0xc,%esp
80101b3a:	68 e8 8e 10 80       	push   $0x80108ee8
80101b3f:	e8 2c ee ff ff       	call   80100970 <panic>
80101b44:	66 90                	xchg   %ax,%ax
80101b46:	66 90                	xchg   %ax,%ax
80101b48:	66 90                	xchg   %ax,%ax
80101b4a:	66 90                	xchg   %ax,%ax
80101b4c:	66 90                	xchg   %ax,%ax
80101b4e:	66 90                	xchg   %ax,%ax

80101b50 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	57                   	push   %edi
80101b54:	56                   	push   %esi
80101b55:	53                   	push   %ebx
80101b56:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101b59:	8b 0d 80 95 15 80    	mov    0x80159580,%ecx
{
80101b5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101b62:	85 c9                	test   %ecx,%ecx
80101b64:	0f 84 87 00 00 00    	je     80101bf1 <balloc+0xa1>
80101b6a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101b71:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101b74:	83 ec 08             	sub    $0x8,%esp
80101b77:	89 f0                	mov    %esi,%eax
80101b79:	c1 f8 0c             	sar    $0xc,%eax
80101b7c:	03 05 98 95 15 80    	add    0x80159598,%eax
80101b82:	50                   	push   %eax
80101b83:	ff 75 d8             	pushl  -0x28(%ebp)
80101b86:	e8 25 eb ff ff       	call   801006b0 <bread>
80101b8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101b8e:	a1 80 95 15 80       	mov    0x80159580,%eax
80101b93:	83 c4 10             	add    $0x10,%esp
80101b96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b99:	31 c0                	xor    %eax,%eax
80101b9b:	eb 2f                	jmp    80101bcc <balloc+0x7c>
80101b9d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101ba0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101ba2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101ba5:	bb 01 00 00 00       	mov    $0x1,%ebx
80101baa:	83 e1 07             	and    $0x7,%ecx
80101bad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101baf:	89 c1                	mov    %eax,%ecx
80101bb1:	c1 f9 03             	sar    $0x3,%ecx
80101bb4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101bb9:	85 df                	test   %ebx,%edi
80101bbb:	89 fa                	mov    %edi,%edx
80101bbd:	74 41                	je     80101c00 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101bbf:	83 c0 01             	add    $0x1,%eax
80101bc2:	83 c6 01             	add    $0x1,%esi
80101bc5:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101bca:	74 05                	je     80101bd1 <balloc+0x81>
80101bcc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101bcf:	77 cf                	ja     80101ba0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101bd1:	83 ec 0c             	sub    $0xc,%esp
80101bd4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bd7:	e8 e4 eb ff ff       	call   801007c0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101bdc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101be3:	83 c4 10             	add    $0x10,%esp
80101be6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101be9:	39 05 80 95 15 80    	cmp    %eax,0x80159580
80101bef:	77 80                	ja     80101b71 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101bf1:	83 ec 0c             	sub    $0xc,%esp
80101bf4:	68 f2 8e 10 80       	push   $0x80108ef2
80101bf9:	e8 72 ed ff ff       	call   80100970 <panic>
80101bfe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101c00:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101c03:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101c06:	09 da                	or     %ebx,%edx
80101c08:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101c0c:	57                   	push   %edi
80101c0d:	e8 ae 1b 00 00       	call   801037c0 <log_write>
        brelse(bp);
80101c12:	89 3c 24             	mov    %edi,(%esp)
80101c15:	e8 a6 eb ff ff       	call   801007c0 <brelse>
  bp = bread(dev, bno);
80101c1a:	58                   	pop    %eax
80101c1b:	5a                   	pop    %edx
80101c1c:	56                   	push   %esi
80101c1d:	ff 75 d8             	pushl  -0x28(%ebp)
80101c20:	e8 8b ea ff ff       	call   801006b0 <bread>
80101c25:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101c27:	8d 40 5c             	lea    0x5c(%eax),%eax
80101c2a:	83 c4 0c             	add    $0xc,%esp
80101c2d:	68 00 02 00 00       	push   $0x200
80101c32:	6a 00                	push   $0x0
80101c34:	50                   	push   %eax
80101c35:	e8 26 3f 00 00       	call   80105b60 <memset>
  log_write(bp);
80101c3a:	89 1c 24             	mov    %ebx,(%esp)
80101c3d:	e8 7e 1b 00 00       	call   801037c0 <log_write>
  brelse(bp);
80101c42:	89 1c 24             	mov    %ebx,(%esp)
80101c45:	e8 76 eb ff ff       	call   801007c0 <brelse>
}
80101c4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4d:	89 f0                	mov    %esi,%eax
80101c4f:	5b                   	pop    %ebx
80101c50:	5e                   	pop    %esi
80101c51:	5f                   	pop    %edi
80101c52:	5d                   	pop    %ebp
80101c53:	c3                   	ret    
80101c54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c60 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101c68:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c6a:	bb d4 95 15 80       	mov    $0x801595d4,%ebx
{
80101c6f:	83 ec 28             	sub    $0x28,%esp
80101c72:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101c75:	68 a0 95 15 80       	push   $0x801595a0
80101c7a:	e8 61 3d 00 00       	call   801059e0 <acquire>
80101c7f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c85:	eb 17                	jmp    80101c9e <iget+0x3e>
80101c87:	89 f6                	mov    %esi,%esi
80101c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101c90:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101c96:	81 fb f4 b1 15 80    	cmp    $0x8015b1f4,%ebx
80101c9c:	73 22                	jae    80101cc0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c9e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101ca1:	85 c9                	test   %ecx,%ecx
80101ca3:	7e 04                	jle    80101ca9 <iget+0x49>
80101ca5:	39 3b                	cmp    %edi,(%ebx)
80101ca7:	74 4f                	je     80101cf8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101ca9:	85 f6                	test   %esi,%esi
80101cab:	75 e3                	jne    80101c90 <iget+0x30>
80101cad:	85 c9                	test   %ecx,%ecx
80101caf:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101cb2:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101cb8:	81 fb f4 b1 15 80    	cmp    $0x8015b1f4,%ebx
80101cbe:	72 de                	jb     80101c9e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101cc0:	85 f6                	test   %esi,%esi
80101cc2:	74 5b                	je     80101d1f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101cc4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101cc7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101cc9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101ccc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101cd3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101cda:	68 a0 95 15 80       	push   $0x801595a0
80101cdf:	e8 1c 3e 00 00       	call   80105b00 <release>

  return ip;
80101ce4:	83 c4 10             	add    $0x10,%esp
}
80101ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cea:	89 f0                	mov    %esi,%eax
80101cec:	5b                   	pop    %ebx
80101ced:	5e                   	pop    %esi
80101cee:	5f                   	pop    %edi
80101cef:	5d                   	pop    %ebp
80101cf0:	c3                   	ret    
80101cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101cf8:	39 53 04             	cmp    %edx,0x4(%ebx)
80101cfb:	75 ac                	jne    80101ca9 <iget+0x49>
      release(&icache.lock);
80101cfd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101d00:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101d03:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101d05:	68 a0 95 15 80       	push   $0x801595a0
      ip->ref++;
80101d0a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101d0d:	e8 ee 3d 00 00       	call   80105b00 <release>
      return ip;
80101d12:	83 c4 10             	add    $0x10,%esp
}
80101d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d18:	89 f0                	mov    %esi,%eax
80101d1a:	5b                   	pop    %ebx
80101d1b:	5e                   	pop    %esi
80101d1c:	5f                   	pop    %edi
80101d1d:	5d                   	pop    %ebp
80101d1e:	c3                   	ret    
    panic("iget: no inodes");
80101d1f:	83 ec 0c             	sub    $0xc,%esp
80101d22:	68 08 8f 10 80       	push   $0x80108f08
80101d27:	e8 44 ec ff ff       	call   80100970 <panic>
80101d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d30 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	89 c6                	mov    %eax,%esi
80101d38:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d3b:	83 fa 0b             	cmp    $0xb,%edx
80101d3e:	77 18                	ja     80101d58 <bmap+0x28>
80101d40:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101d43:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101d46:	85 db                	test   %ebx,%ebx
80101d48:	74 76                	je     80101dc0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
80101d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d4d:	89 d8                	mov    %ebx,%eax
80101d4f:	5b                   	pop    %ebx
80101d50:	5e                   	pop    %esi
80101d51:	5f                   	pop    %edi
80101d52:	5d                   	pop    %ebp
80101d53:	c3                   	ret    
80101d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101d58:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
80101d5b:	83 fb 7f             	cmp    $0x7f,%ebx
80101d5e:	0f 87 90 00 00 00    	ja     80101df4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d64:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101d6a:	8b 00                	mov    (%eax),%eax
80101d6c:	85 d2                	test   %edx,%edx
80101d6e:	74 70                	je     80101de0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101d70:	83 ec 08             	sub    $0x8,%esp
80101d73:	52                   	push   %edx
80101d74:	50                   	push   %eax
80101d75:	e8 36 e9 ff ff       	call   801006b0 <bread>
    if((addr = a[bn]) == 0){
80101d7a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
80101d7e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101d81:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101d83:	8b 1a                	mov    (%edx),%ebx
80101d85:	85 db                	test   %ebx,%ebx
80101d87:	75 1d                	jne    80101da6 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101d89:	8b 06                	mov    (%esi),%eax
80101d8b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d8e:	e8 bd fd ff ff       	call   80101b50 <balloc>
80101d93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101d96:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101d99:	89 c3                	mov    %eax,%ebx
80101d9b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d9d:	57                   	push   %edi
80101d9e:	e8 1d 1a 00 00       	call   801037c0 <log_write>
80101da3:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101da6:	83 ec 0c             	sub    $0xc,%esp
80101da9:	57                   	push   %edi
80101daa:	e8 11 ea ff ff       	call   801007c0 <brelse>
80101daf:	83 c4 10             	add    $0x10,%esp
}
80101db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db5:	89 d8                	mov    %ebx,%eax
80101db7:	5b                   	pop    %ebx
80101db8:	5e                   	pop    %esi
80101db9:	5f                   	pop    %edi
80101dba:	5d                   	pop    %ebp
80101dbb:	c3                   	ret    
80101dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101dc0:	8b 00                	mov    (%eax),%eax
80101dc2:	e8 89 fd ff ff       	call   80101b50 <balloc>
80101dc7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
80101dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
80101dcd:	89 c3                	mov    %eax,%ebx
}
80101dcf:	89 d8                	mov    %ebx,%eax
80101dd1:	5b                   	pop    %ebx
80101dd2:	5e                   	pop    %esi
80101dd3:	5f                   	pop    %edi
80101dd4:	5d                   	pop    %ebp
80101dd5:	c3                   	ret    
80101dd6:	8d 76 00             	lea    0x0(%esi),%esi
80101dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101de0:	e8 6b fd ff ff       	call   80101b50 <balloc>
80101de5:	89 c2                	mov    %eax,%edx
80101de7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101ded:	8b 06                	mov    (%esi),%eax
80101def:	e9 7c ff ff ff       	jmp    80101d70 <bmap+0x40>
  panic("bmap: out of range");
80101df4:	83 ec 0c             	sub    $0xc,%esp
80101df7:	68 18 8f 10 80       	push   $0x80108f18
80101dfc:	e8 6f eb ff ff       	call   80100970 <panic>
80101e01:	eb 0d                	jmp    80101e10 <readsb>
80101e03:	90                   	nop
80101e04:	90                   	nop
80101e05:	90                   	nop
80101e06:	90                   	nop
80101e07:	90                   	nop
80101e08:	90                   	nop
80101e09:	90                   	nop
80101e0a:	90                   	nop
80101e0b:	90                   	nop
80101e0c:	90                   	nop
80101e0d:	90                   	nop
80101e0e:	90                   	nop
80101e0f:	90                   	nop

80101e10 <readsb>:
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	56                   	push   %esi
80101e14:	53                   	push   %ebx
80101e15:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101e18:	83 ec 08             	sub    $0x8,%esp
80101e1b:	6a 01                	push   $0x1
80101e1d:	ff 75 08             	pushl  0x8(%ebp)
80101e20:	e8 8b e8 ff ff       	call   801006b0 <bread>
80101e25:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101e27:	8d 40 5c             	lea    0x5c(%eax),%eax
80101e2a:	83 c4 0c             	add    $0xc,%esp
80101e2d:	6a 1c                	push   $0x1c
80101e2f:	50                   	push   %eax
80101e30:	56                   	push   %esi
80101e31:	e8 da 3d 00 00       	call   80105c10 <memmove>
  brelse(bp);
80101e36:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101e39:	83 c4 10             	add    $0x10,%esp
}
80101e3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e3f:	5b                   	pop    %ebx
80101e40:	5e                   	pop    %esi
80101e41:	5d                   	pop    %ebp
  brelse(bp);
80101e42:	e9 79 e9 ff ff       	jmp    801007c0 <brelse>
80101e47:	89 f6                	mov    %esi,%esi
80101e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e50 <bfree>:
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	56                   	push   %esi
80101e54:	53                   	push   %ebx
80101e55:	89 d3                	mov    %edx,%ebx
80101e57:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101e59:	83 ec 08             	sub    $0x8,%esp
80101e5c:	68 80 95 15 80       	push   $0x80159580
80101e61:	50                   	push   %eax
80101e62:	e8 a9 ff ff ff       	call   80101e10 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101e67:	58                   	pop    %eax
80101e68:	5a                   	pop    %edx
80101e69:	89 da                	mov    %ebx,%edx
80101e6b:	c1 ea 0c             	shr    $0xc,%edx
80101e6e:	03 15 98 95 15 80    	add    0x80159598,%edx
80101e74:	52                   	push   %edx
80101e75:	56                   	push   %esi
80101e76:	e8 35 e8 ff ff       	call   801006b0 <bread>
  m = 1 << (bi % 8);
80101e7b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101e7d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101e80:	ba 01 00 00 00       	mov    $0x1,%edx
80101e85:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101e88:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101e8e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101e91:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101e93:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101e98:	85 d1                	test   %edx,%ecx
80101e9a:	74 25                	je     80101ec1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
80101e9c:	f7 d2                	not    %edx
80101e9e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101ea0:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101ea3:	21 ca                	and    %ecx,%edx
80101ea5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101ea9:	56                   	push   %esi
80101eaa:	e8 11 19 00 00       	call   801037c0 <log_write>
  brelse(bp);
80101eaf:	89 34 24             	mov    %esi,(%esp)
80101eb2:	e8 09 e9 ff ff       	call   801007c0 <brelse>
}
80101eb7:	83 c4 10             	add    $0x10,%esp
80101eba:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ebd:	5b                   	pop    %ebx
80101ebe:	5e                   	pop    %esi
80101ebf:	5d                   	pop    %ebp
80101ec0:	c3                   	ret    
    panic("freeing free block");
80101ec1:	83 ec 0c             	sub    $0xc,%esp
80101ec4:	68 2b 8f 10 80       	push   $0x80108f2b
80101ec9:	e8 a2 ea ff ff       	call   80100970 <panic>
80101ece:	66 90                	xchg   %ax,%ax

80101ed0 <iinit>:
{
80101ed0:	55                   	push   %ebp
80101ed1:	89 e5                	mov    %esp,%ebp
80101ed3:	53                   	push   %ebx
80101ed4:	bb e0 95 15 80       	mov    $0x801595e0,%ebx
80101ed9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101edc:	68 3e 8f 10 80       	push   $0x80108f3e
80101ee1:	68 a0 95 15 80       	push   $0x801595a0
80101ee6:	e8 05 3a 00 00       	call   801058f0 <initlock>
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101ef0:	83 ec 08             	sub    $0x8,%esp
80101ef3:	68 45 8f 10 80       	push   $0x80108f45
80101ef8:	53                   	push   %ebx
80101ef9:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101eff:	e8 dc 38 00 00       	call   801057e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101f04:	83 c4 10             	add    $0x10,%esp
80101f07:	81 fb 00 b2 15 80    	cmp    $0x8015b200,%ebx
80101f0d:	75 e1                	jne    80101ef0 <iinit+0x20>
  readsb(dev, &sb);
80101f0f:	83 ec 08             	sub    $0x8,%esp
80101f12:	68 80 95 15 80       	push   $0x80159580
80101f17:	ff 75 08             	pushl  0x8(%ebp)
80101f1a:	e8 f1 fe ff ff       	call   80101e10 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101f1f:	ff 35 98 95 15 80    	pushl  0x80159598
80101f25:	ff 35 94 95 15 80    	pushl  0x80159594
80101f2b:	ff 35 90 95 15 80    	pushl  0x80159590
80101f31:	ff 35 8c 95 15 80    	pushl  0x8015958c
80101f37:	ff 35 88 95 15 80    	pushl  0x80159588
80101f3d:	ff 35 84 95 15 80    	pushl  0x80159584
80101f43:	ff 35 80 95 15 80    	pushl  0x80159580
80101f49:	68 a8 8f 10 80       	push   $0x80108fa8
80101f4e:	e8 ed ec ff ff       	call   80100c40 <cprintf>
}
80101f53:	83 c4 30             	add    $0x30,%esp
80101f56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f59:	c9                   	leave  
80101f5a:	c3                   	ret    
80101f5b:	90                   	nop
80101f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101f60 <ialloc>:
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	57                   	push   %edi
80101f64:	56                   	push   %esi
80101f65:	53                   	push   %ebx
80101f66:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101f69:	83 3d 88 95 15 80 01 	cmpl   $0x1,0x80159588
{
80101f70:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f73:	8b 75 08             	mov    0x8(%ebp),%esi
80101f76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101f79:	0f 86 91 00 00 00    	jbe    80102010 <ialloc+0xb0>
80101f7f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101f84:	eb 21                	jmp    80101fa7 <ialloc+0x47>
80101f86:	8d 76 00             	lea    0x0(%esi),%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101f90:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101f93:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101f96:	57                   	push   %edi
80101f97:	e8 24 e8 ff ff       	call   801007c0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101f9c:	83 c4 10             	add    $0x10,%esp
80101f9f:	39 1d 88 95 15 80    	cmp    %ebx,0x80159588
80101fa5:	76 69                	jbe    80102010 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101fa7:	89 d8                	mov    %ebx,%eax
80101fa9:	83 ec 08             	sub    $0x8,%esp
80101fac:	c1 e8 03             	shr    $0x3,%eax
80101faf:	03 05 94 95 15 80    	add    0x80159594,%eax
80101fb5:	50                   	push   %eax
80101fb6:	56                   	push   %esi
80101fb7:	e8 f4 e6 ff ff       	call   801006b0 <bread>
80101fbc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101fbe:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101fc0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101fc3:	83 e0 07             	and    $0x7,%eax
80101fc6:	c1 e0 06             	shl    $0x6,%eax
80101fc9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101fcd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101fd1:	75 bd                	jne    80101f90 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101fd3:	83 ec 04             	sub    $0x4,%esp
80101fd6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101fd9:	6a 40                	push   $0x40
80101fdb:	6a 00                	push   $0x0
80101fdd:	51                   	push   %ecx
80101fde:	e8 7d 3b 00 00       	call   80105b60 <memset>
      dip->type = type;
80101fe3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101fe7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101fea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101fed:	89 3c 24             	mov    %edi,(%esp)
80101ff0:	e8 cb 17 00 00       	call   801037c0 <log_write>
      brelse(bp);
80101ff5:	89 3c 24             	mov    %edi,(%esp)
80101ff8:	e8 c3 e7 ff ff       	call   801007c0 <brelse>
      return iget(dev, inum);
80101ffd:	83 c4 10             	add    $0x10,%esp
}
80102000:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80102003:	89 da                	mov    %ebx,%edx
80102005:	89 f0                	mov    %esi,%eax
}
80102007:	5b                   	pop    %ebx
80102008:	5e                   	pop    %esi
80102009:	5f                   	pop    %edi
8010200a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010200b:	e9 50 fc ff ff       	jmp    80101c60 <iget>
  panic("ialloc: no inodes");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 4b 8f 10 80       	push   $0x80108f4b
80102018:	e8 53 e9 ff ff       	call   80100970 <panic>
8010201d:	8d 76 00             	lea    0x0(%esi),%esi

80102020 <iupdate>:
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	56                   	push   %esi
80102024:	53                   	push   %ebx
80102025:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102028:	83 ec 08             	sub    $0x8,%esp
8010202b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010202e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102031:	c1 e8 03             	shr    $0x3,%eax
80102034:	03 05 94 95 15 80    	add    0x80159594,%eax
8010203a:	50                   	push   %eax
8010203b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010203e:	e8 6d e6 ff ff       	call   801006b0 <bread>
80102043:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80102045:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80102048:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010204c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010204f:	83 e0 07             	and    $0x7,%eax
80102052:	c1 e0 06             	shl    $0x6,%eax
80102055:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80102059:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010205c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80102060:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80102063:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80102067:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010206b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010206f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80102073:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80102077:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010207a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010207d:	6a 34                	push   $0x34
8010207f:	53                   	push   %ebx
80102080:	50                   	push   %eax
80102081:	e8 8a 3b 00 00       	call   80105c10 <memmove>
  log_write(bp);
80102086:	89 34 24             	mov    %esi,(%esp)
80102089:	e8 32 17 00 00       	call   801037c0 <log_write>
  brelse(bp);
8010208e:	89 75 08             	mov    %esi,0x8(%ebp)
80102091:	83 c4 10             	add    $0x10,%esp
}
80102094:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102097:	5b                   	pop    %ebx
80102098:	5e                   	pop    %esi
80102099:	5d                   	pop    %ebp
  brelse(bp);
8010209a:	e9 21 e7 ff ff       	jmp    801007c0 <brelse>
8010209f:	90                   	nop

801020a0 <idup>:
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	53                   	push   %ebx
801020a4:	83 ec 10             	sub    $0x10,%esp
801020a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801020aa:	68 a0 95 15 80       	push   $0x801595a0
801020af:	e8 2c 39 00 00       	call   801059e0 <acquire>
  ip->ref++;
801020b4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801020b8:	c7 04 24 a0 95 15 80 	movl   $0x801595a0,(%esp)
801020bf:	e8 3c 3a 00 00       	call   80105b00 <release>
}
801020c4:	89 d8                	mov    %ebx,%eax
801020c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020c9:	c9                   	leave  
801020ca:	c3                   	ret    
801020cb:	90                   	nop
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020d0 <ilock>:
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	56                   	push   %esi
801020d4:	53                   	push   %ebx
801020d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801020d8:	85 db                	test   %ebx,%ebx
801020da:	0f 84 b7 00 00 00    	je     80102197 <ilock+0xc7>
801020e0:	8b 53 08             	mov    0x8(%ebx),%edx
801020e3:	85 d2                	test   %edx,%edx
801020e5:	0f 8e ac 00 00 00    	jle    80102197 <ilock+0xc7>
  acquiresleep(&ip->lock);
801020eb:	8d 43 0c             	lea    0xc(%ebx),%eax
801020ee:	83 ec 0c             	sub    $0xc,%esp
801020f1:	50                   	push   %eax
801020f2:	e8 29 37 00 00       	call   80105820 <acquiresleep>
  if(ip->valid == 0){
801020f7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801020fa:	83 c4 10             	add    $0x10,%esp
801020fd:	85 c0                	test   %eax,%eax
801020ff:	74 0f                	je     80102110 <ilock+0x40>
}
80102101:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102104:	5b                   	pop    %ebx
80102105:	5e                   	pop    %esi
80102106:	5d                   	pop    %ebp
80102107:	c3                   	ret    
80102108:	90                   	nop
80102109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102110:	8b 43 04             	mov    0x4(%ebx),%eax
80102113:	83 ec 08             	sub    $0x8,%esp
80102116:	c1 e8 03             	shr    $0x3,%eax
80102119:	03 05 94 95 15 80    	add    0x80159594,%eax
8010211f:	50                   	push   %eax
80102120:	ff 33                	pushl  (%ebx)
80102122:	e8 89 e5 ff ff       	call   801006b0 <bread>
80102127:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80102129:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010212c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010212f:	83 e0 07             	and    $0x7,%eax
80102132:	c1 e0 06             	shl    $0x6,%eax
80102135:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102139:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010213c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010213f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102143:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102147:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010214b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010214f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102153:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102157:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010215b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010215e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102161:	6a 34                	push   $0x34
80102163:	50                   	push   %eax
80102164:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102167:	50                   	push   %eax
80102168:	e8 a3 3a 00 00       	call   80105c10 <memmove>
    brelse(bp);
8010216d:	89 34 24             	mov    %esi,(%esp)
80102170:	e8 4b e6 ff ff       	call   801007c0 <brelse>
    if(ip->type == 0)
80102175:	83 c4 10             	add    $0x10,%esp
80102178:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010217d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102184:	0f 85 77 ff ff ff    	jne    80102101 <ilock+0x31>
      panic("ilock: no type");
8010218a:	83 ec 0c             	sub    $0xc,%esp
8010218d:	68 63 8f 10 80       	push   $0x80108f63
80102192:	e8 d9 e7 ff ff       	call   80100970 <panic>
    panic("ilock");
80102197:	83 ec 0c             	sub    $0xc,%esp
8010219a:	68 5d 8f 10 80       	push   $0x80108f5d
8010219f:	e8 cc e7 ff ff       	call   80100970 <panic>
801021a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801021b0 <iunlock>:
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	56                   	push   %esi
801021b4:	53                   	push   %ebx
801021b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801021b8:	85 db                	test   %ebx,%ebx
801021ba:	74 28                	je     801021e4 <iunlock+0x34>
801021bc:	8d 73 0c             	lea    0xc(%ebx),%esi
801021bf:	83 ec 0c             	sub    $0xc,%esp
801021c2:	56                   	push   %esi
801021c3:	e8 f8 36 00 00       	call   801058c0 <holdingsleep>
801021c8:	83 c4 10             	add    $0x10,%esp
801021cb:	85 c0                	test   %eax,%eax
801021cd:	74 15                	je     801021e4 <iunlock+0x34>
801021cf:	8b 43 08             	mov    0x8(%ebx),%eax
801021d2:	85 c0                	test   %eax,%eax
801021d4:	7e 0e                	jle    801021e4 <iunlock+0x34>
  releasesleep(&ip->lock);
801021d6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801021d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021dc:	5b                   	pop    %ebx
801021dd:	5e                   	pop    %esi
801021de:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801021df:	e9 9c 36 00 00       	jmp    80105880 <releasesleep>
    panic("iunlock");
801021e4:	83 ec 0c             	sub    $0xc,%esp
801021e7:	68 72 8f 10 80       	push   $0x80108f72
801021ec:	e8 7f e7 ff ff       	call   80100970 <panic>
801021f1:	eb 0d                	jmp    80102200 <iput>
801021f3:	90                   	nop
801021f4:	90                   	nop
801021f5:	90                   	nop
801021f6:	90                   	nop
801021f7:	90                   	nop
801021f8:	90                   	nop
801021f9:	90                   	nop
801021fa:	90                   	nop
801021fb:	90                   	nop
801021fc:	90                   	nop
801021fd:	90                   	nop
801021fe:	90                   	nop
801021ff:	90                   	nop

80102200 <iput>:
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	57                   	push   %edi
80102204:	56                   	push   %esi
80102205:	53                   	push   %ebx
80102206:	83 ec 28             	sub    $0x28,%esp
80102209:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010220c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010220f:	57                   	push   %edi
80102210:	e8 0b 36 00 00       	call   80105820 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102215:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102218:	83 c4 10             	add    $0x10,%esp
8010221b:	85 d2                	test   %edx,%edx
8010221d:	74 07                	je     80102226 <iput+0x26>
8010221f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102224:	74 32                	je     80102258 <iput+0x58>
  releasesleep(&ip->lock);
80102226:	83 ec 0c             	sub    $0xc,%esp
80102229:	57                   	push   %edi
8010222a:	e8 51 36 00 00       	call   80105880 <releasesleep>
  acquire(&icache.lock);
8010222f:	c7 04 24 a0 95 15 80 	movl   $0x801595a0,(%esp)
80102236:	e8 a5 37 00 00       	call   801059e0 <acquire>
  ip->ref--;
8010223b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010223f:	83 c4 10             	add    $0x10,%esp
80102242:	c7 45 08 a0 95 15 80 	movl   $0x801595a0,0x8(%ebp)
}
80102249:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010224c:	5b                   	pop    %ebx
8010224d:	5e                   	pop    %esi
8010224e:	5f                   	pop    %edi
8010224f:	5d                   	pop    %ebp
  release(&icache.lock);
80102250:	e9 ab 38 00 00       	jmp    80105b00 <release>
80102255:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80102258:	83 ec 0c             	sub    $0xc,%esp
8010225b:	68 a0 95 15 80       	push   $0x801595a0
80102260:	e8 7b 37 00 00       	call   801059e0 <acquire>
    int r = ip->ref;
80102265:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102268:	c7 04 24 a0 95 15 80 	movl   $0x801595a0,(%esp)
8010226f:	e8 8c 38 00 00       	call   80105b00 <release>
    if(r == 1){
80102274:	83 c4 10             	add    $0x10,%esp
80102277:	83 fe 01             	cmp    $0x1,%esi
8010227a:	75 aa                	jne    80102226 <iput+0x26>
8010227c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102282:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102285:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102288:	89 cf                	mov    %ecx,%edi
8010228a:	eb 0b                	jmp    80102297 <iput+0x97>
8010228c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102290:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102293:	39 fe                	cmp    %edi,%esi
80102295:	74 19                	je     801022b0 <iput+0xb0>
    if(ip->addrs[i]){
80102297:	8b 16                	mov    (%esi),%edx
80102299:	85 d2                	test   %edx,%edx
8010229b:	74 f3                	je     80102290 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010229d:	8b 03                	mov    (%ebx),%eax
8010229f:	e8 ac fb ff ff       	call   80101e50 <bfree>
      ip->addrs[i] = 0;
801022a4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801022aa:	eb e4                	jmp    80102290 <iput+0x90>
801022ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801022b0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801022b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801022b9:	85 c0                	test   %eax,%eax
801022bb:	75 33                	jne    801022f0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801022bd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801022c0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801022c7:	53                   	push   %ebx
801022c8:	e8 53 fd ff ff       	call   80102020 <iupdate>
      ip->type = 0;
801022cd:	31 c0                	xor    %eax,%eax
801022cf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801022d3:	89 1c 24             	mov    %ebx,(%esp)
801022d6:	e8 45 fd ff ff       	call   80102020 <iupdate>
      ip->valid = 0;
801022db:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801022e2:	83 c4 10             	add    $0x10,%esp
801022e5:	e9 3c ff ff ff       	jmp    80102226 <iput+0x26>
801022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801022f0:	83 ec 08             	sub    $0x8,%esp
801022f3:	50                   	push   %eax
801022f4:	ff 33                	pushl  (%ebx)
801022f6:	e8 b5 e3 ff ff       	call   801006b0 <bread>
801022fb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102301:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102304:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80102307:	8d 70 5c             	lea    0x5c(%eax),%esi
8010230a:	83 c4 10             	add    $0x10,%esp
8010230d:	89 cf                	mov    %ecx,%edi
8010230f:	eb 0e                	jmp    8010231f <iput+0x11f>
80102311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102318:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010231b:	39 fe                	cmp    %edi,%esi
8010231d:	74 0f                	je     8010232e <iput+0x12e>
      if(a[j])
8010231f:	8b 16                	mov    (%esi),%edx
80102321:	85 d2                	test   %edx,%edx
80102323:	74 f3                	je     80102318 <iput+0x118>
        bfree(ip->dev, a[j]);
80102325:	8b 03                	mov    (%ebx),%eax
80102327:	e8 24 fb ff ff       	call   80101e50 <bfree>
8010232c:	eb ea                	jmp    80102318 <iput+0x118>
    brelse(bp);
8010232e:	83 ec 0c             	sub    $0xc,%esp
80102331:	ff 75 e4             	pushl  -0x1c(%ebp)
80102334:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102337:	e8 84 e4 ff ff       	call   801007c0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010233c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102342:	8b 03                	mov    (%ebx),%eax
80102344:	e8 07 fb ff ff       	call   80101e50 <bfree>
    ip->addrs[NDIRECT] = 0;
80102349:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102350:	00 00 00 
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	e9 62 ff ff ff       	jmp    801022bd <iput+0xbd>
8010235b:	90                   	nop
8010235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102360 <iunlockput>:
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	53                   	push   %ebx
80102364:	83 ec 10             	sub    $0x10,%esp
80102367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010236a:	53                   	push   %ebx
8010236b:	e8 40 fe ff ff       	call   801021b0 <iunlock>
  iput(ip);
80102370:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102373:	83 c4 10             	add    $0x10,%esp
}
80102376:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102379:	c9                   	leave  
  iput(ip);
8010237a:	e9 81 fe ff ff       	jmp    80102200 <iput>
8010237f:	90                   	nop

80102380 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	8b 55 08             	mov    0x8(%ebp),%edx
80102386:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80102389:	8b 0a                	mov    (%edx),%ecx
8010238b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010238e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102391:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102394:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102398:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010239b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010239f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801023a3:	8b 52 58             	mov    0x58(%edx),%edx
801023a6:	89 50 10             	mov    %edx,0x10(%eax)
}
801023a9:	5d                   	pop    %ebp
801023aa:	c3                   	ret    
801023ab:	90                   	nop
801023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023b0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	57                   	push   %edi
801023b4:	56                   	push   %esi
801023b5:	53                   	push   %ebx
801023b6:	83 ec 1c             	sub    $0x1c,%esp
801023b9:	8b 45 08             	mov    0x8(%ebp),%eax
801023bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801023bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801023c2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801023c7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801023ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
801023cd:	8b 75 10             	mov    0x10(%ebp),%esi
801023d0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801023d3:	0f 84 a7 00 00 00    	je     80102480 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801023d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801023dc:	8b 40 58             	mov    0x58(%eax),%eax
801023df:	39 c6                	cmp    %eax,%esi
801023e1:	0f 87 ba 00 00 00    	ja     801024a1 <readi+0xf1>
801023e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801023ea:	89 f9                	mov    %edi,%ecx
801023ec:	01 f1                	add    %esi,%ecx
801023ee:	0f 82 ad 00 00 00    	jb     801024a1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801023f4:	89 c2                	mov    %eax,%edx
801023f6:	29 f2                	sub    %esi,%edx
801023f8:	39 c8                	cmp    %ecx,%eax
801023fa:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801023fd:	31 ff                	xor    %edi,%edi
801023ff:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80102401:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102404:	74 6c                	je     80102472 <readi+0xc2>
80102406:	8d 76 00             	lea    0x0(%esi),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102410:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102413:	89 f2                	mov    %esi,%edx
80102415:	c1 ea 09             	shr    $0x9,%edx
80102418:	89 d8                	mov    %ebx,%eax
8010241a:	e8 11 f9 ff ff       	call   80101d30 <bmap>
8010241f:	83 ec 08             	sub    $0x8,%esp
80102422:	50                   	push   %eax
80102423:	ff 33                	pushl  (%ebx)
80102425:	e8 86 e2 ff ff       	call   801006b0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010242a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010242d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
8010242f:	89 f0                	mov    %esi,%eax
80102431:	25 ff 01 00 00       	and    $0x1ff,%eax
80102436:	b9 00 02 00 00       	mov    $0x200,%ecx
8010243b:	83 c4 0c             	add    $0xc,%esp
8010243e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102440:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80102444:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102447:	29 fb                	sub    %edi,%ebx
80102449:	39 d9                	cmp    %ebx,%ecx
8010244b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010244e:	53                   	push   %ebx
8010244f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102450:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80102452:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102455:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102457:	e8 b4 37 00 00       	call   80105c10 <memmove>
    brelse(bp);
8010245c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010245f:	89 14 24             	mov    %edx,(%esp)
80102462:	e8 59 e3 ff ff       	call   801007c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102467:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010246a:	83 c4 10             	add    $0x10,%esp
8010246d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102470:	77 9e                	ja     80102410 <readi+0x60>
  }
  return n;
80102472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102475:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102478:	5b                   	pop    %ebx
80102479:	5e                   	pop    %esi
8010247a:	5f                   	pop    %edi
8010247b:	5d                   	pop    %ebp
8010247c:	c3                   	ret    
8010247d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102480:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102484:	66 83 f8 09          	cmp    $0x9,%ax
80102488:	77 17                	ja     801024a1 <readi+0xf1>
8010248a:	8b 04 c5 20 95 15 80 	mov    -0x7fea6ae0(,%eax,8),%eax
80102491:	85 c0                	test   %eax,%eax
80102493:	74 0c                	je     801024a1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102495:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102498:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010249b:	5b                   	pop    %ebx
8010249c:	5e                   	pop    %esi
8010249d:	5f                   	pop    %edi
8010249e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010249f:	ff e0                	jmp    *%eax
      return -1;
801024a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024a6:	eb cd                	jmp    80102475 <readi+0xc5>
801024a8:	90                   	nop
801024a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801024b0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	57                   	push   %edi
801024b4:	56                   	push   %esi
801024b5:	53                   	push   %ebx
801024b6:	83 ec 1c             	sub    $0x1c,%esp
801024b9:	8b 45 08             	mov    0x8(%ebp),%eax
801024bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801024bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801024c2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801024c7:	89 75 dc             	mov    %esi,-0x24(%ebp)
801024ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
801024cd:	8b 75 10             	mov    0x10(%ebp),%esi
801024d0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
801024d3:	0f 84 b7 00 00 00    	je     80102590 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801024d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801024dc:	39 70 58             	cmp    %esi,0x58(%eax)
801024df:	0f 82 eb 00 00 00    	jb     801025d0 <writei+0x120>
801024e5:	8b 7d e0             	mov    -0x20(%ebp),%edi
801024e8:	31 d2                	xor    %edx,%edx
801024ea:	89 f8                	mov    %edi,%eax
801024ec:	01 f0                	add    %esi,%eax
801024ee:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
801024f1:	3d 00 18 01 00       	cmp    $0x11800,%eax
801024f6:	0f 87 d4 00 00 00    	ja     801025d0 <writei+0x120>
801024fc:	85 d2                	test   %edx,%edx
801024fe:	0f 85 cc 00 00 00    	jne    801025d0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102504:	85 ff                	test   %edi,%edi
80102506:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010250d:	74 72                	je     80102581 <writei+0xd1>
8010250f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102510:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102513:	89 f2                	mov    %esi,%edx
80102515:	c1 ea 09             	shr    $0x9,%edx
80102518:	89 f8                	mov    %edi,%eax
8010251a:	e8 11 f8 ff ff       	call   80101d30 <bmap>
8010251f:	83 ec 08             	sub    $0x8,%esp
80102522:	50                   	push   %eax
80102523:	ff 37                	pushl  (%edi)
80102525:	e8 86 e1 ff ff       	call   801006b0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010252a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010252d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102530:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102532:	89 f0                	mov    %esi,%eax
80102534:	b9 00 02 00 00       	mov    $0x200,%ecx
80102539:	83 c4 0c             	add    $0xc,%esp
8010253c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102541:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102543:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102547:	39 d9                	cmp    %ebx,%ecx
80102549:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010254c:	53                   	push   %ebx
8010254d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102550:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80102552:	50                   	push   %eax
80102553:	e8 b8 36 00 00       	call   80105c10 <memmove>
    log_write(bp);
80102558:	89 3c 24             	mov    %edi,(%esp)
8010255b:	e8 60 12 00 00       	call   801037c0 <log_write>
    brelse(bp);
80102560:	89 3c 24             	mov    %edi,(%esp)
80102563:	e8 58 e2 ff ff       	call   801007c0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102568:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010256b:	01 5d dc             	add    %ebx,-0x24(%ebp)
8010256e:	83 c4 10             	add    $0x10,%esp
80102571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102574:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102577:	77 97                	ja     80102510 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102579:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010257c:	3b 70 58             	cmp    0x58(%eax),%esi
8010257f:	77 37                	ja     801025b8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102581:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102584:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102587:	5b                   	pop    %ebx
80102588:	5e                   	pop    %esi
80102589:	5f                   	pop    %edi
8010258a:	5d                   	pop    %ebp
8010258b:	c3                   	ret    
8010258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102590:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102594:	66 83 f8 09          	cmp    $0x9,%ax
80102598:	77 36                	ja     801025d0 <writei+0x120>
8010259a:	8b 04 c5 24 95 15 80 	mov    -0x7fea6adc(,%eax,8),%eax
801025a1:	85 c0                	test   %eax,%eax
801025a3:	74 2b                	je     801025d0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
801025a5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801025a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025ab:	5b                   	pop    %ebx
801025ac:	5e                   	pop    %esi
801025ad:	5f                   	pop    %edi
801025ae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801025af:	ff e0                	jmp    *%eax
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801025b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801025bb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801025be:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801025c1:	50                   	push   %eax
801025c2:	e8 59 fa ff ff       	call   80102020 <iupdate>
801025c7:	83 c4 10             	add    $0x10,%esp
801025ca:	eb b5                	jmp    80102581 <writei+0xd1>
801025cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
801025d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025d5:	eb ad                	jmp    80102584 <writei+0xd4>
801025d7:	89 f6                	mov    %esi,%esi
801025d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025e0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801025e6:	6a 0e                	push   $0xe
801025e8:	ff 75 0c             	pushl  0xc(%ebp)
801025eb:	ff 75 08             	pushl  0x8(%ebp)
801025ee:	e8 8d 36 00 00       	call   80105c80 <strncmp>
}
801025f3:	c9                   	leave  
801025f4:	c3                   	ret    
801025f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102600 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	57                   	push   %edi
80102604:	56                   	push   %esi
80102605:	53                   	push   %ebx
80102606:	83 ec 1c             	sub    $0x1c,%esp
80102609:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010260c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102611:	0f 85 85 00 00 00    	jne    8010269c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102617:	8b 53 58             	mov    0x58(%ebx),%edx
8010261a:	31 ff                	xor    %edi,%edi
8010261c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010261f:	85 d2                	test   %edx,%edx
80102621:	74 3e                	je     80102661 <dirlookup+0x61>
80102623:	90                   	nop
80102624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102628:	6a 10                	push   $0x10
8010262a:	57                   	push   %edi
8010262b:	56                   	push   %esi
8010262c:	53                   	push   %ebx
8010262d:	e8 7e fd ff ff       	call   801023b0 <readi>
80102632:	83 c4 10             	add    $0x10,%esp
80102635:	83 f8 10             	cmp    $0x10,%eax
80102638:	75 55                	jne    8010268f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
8010263a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010263f:	74 18                	je     80102659 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80102641:	8d 45 da             	lea    -0x26(%ebp),%eax
80102644:	83 ec 04             	sub    $0x4,%esp
80102647:	6a 0e                	push   $0xe
80102649:	50                   	push   %eax
8010264a:	ff 75 0c             	pushl  0xc(%ebp)
8010264d:	e8 2e 36 00 00       	call   80105c80 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80102652:	83 c4 10             	add    $0x10,%esp
80102655:	85 c0                	test   %eax,%eax
80102657:	74 17                	je     80102670 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102659:	83 c7 10             	add    $0x10,%edi
8010265c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010265f:	72 c7                	jb     80102628 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102661:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80102664:	31 c0                	xor    %eax,%eax
}
80102666:	5b                   	pop    %ebx
80102667:	5e                   	pop    %esi
80102668:	5f                   	pop    %edi
80102669:	5d                   	pop    %ebp
8010266a:	c3                   	ret    
8010266b:	90                   	nop
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80102670:	8b 45 10             	mov    0x10(%ebp),%eax
80102673:	85 c0                	test   %eax,%eax
80102675:	74 05                	je     8010267c <dirlookup+0x7c>
        *poff = off;
80102677:	8b 45 10             	mov    0x10(%ebp),%eax
8010267a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
8010267c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102680:	8b 03                	mov    (%ebx),%eax
80102682:	e8 d9 f5 ff ff       	call   80101c60 <iget>
}
80102687:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010268a:	5b                   	pop    %ebx
8010268b:	5e                   	pop    %esi
8010268c:	5f                   	pop    %edi
8010268d:	5d                   	pop    %ebp
8010268e:	c3                   	ret    
      panic("dirlookup read");
8010268f:	83 ec 0c             	sub    $0xc,%esp
80102692:	68 8c 8f 10 80       	push   $0x80108f8c
80102697:	e8 d4 e2 ff ff       	call   80100970 <panic>
    panic("dirlookup not DIR");
8010269c:	83 ec 0c             	sub    $0xc,%esp
8010269f:	68 7a 8f 10 80       	push   $0x80108f7a
801026a4:	e8 c7 e2 ff ff       	call   80100970 <panic>
801026a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801026b0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	57                   	push   %edi
801026b4:	56                   	push   %esi
801026b5:	53                   	push   %ebx
801026b6:	89 cf                	mov    %ecx,%edi
801026b8:	89 c3                	mov    %eax,%ebx
801026ba:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801026bd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801026c0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
801026c3:	0f 84 67 01 00 00    	je     80102830 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801026c9:	e8 22 28 00 00       	call   80104ef0 <myproc>
  acquire(&icache.lock);
801026ce:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
801026d1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801026d4:	68 a0 95 15 80       	push   $0x801595a0
801026d9:	e8 02 33 00 00       	call   801059e0 <acquire>
  ip->ref++;
801026de:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801026e2:	c7 04 24 a0 95 15 80 	movl   $0x801595a0,(%esp)
801026e9:	e8 12 34 00 00       	call   80105b00 <release>
801026ee:	83 c4 10             	add    $0x10,%esp
801026f1:	eb 08                	jmp    801026fb <namex+0x4b>
801026f3:	90                   	nop
801026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801026f8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801026fb:	0f b6 03             	movzbl (%ebx),%eax
801026fe:	3c 2f                	cmp    $0x2f,%al
80102700:	74 f6                	je     801026f8 <namex+0x48>
  if(*path == 0)
80102702:	84 c0                	test   %al,%al
80102704:	0f 84 ee 00 00 00    	je     801027f8 <namex+0x148>
  while(*path != '/' && *path != 0)
8010270a:	0f b6 03             	movzbl (%ebx),%eax
8010270d:	3c 2f                	cmp    $0x2f,%al
8010270f:	0f 84 b3 00 00 00    	je     801027c8 <namex+0x118>
80102715:	84 c0                	test   %al,%al
80102717:	89 da                	mov    %ebx,%edx
80102719:	75 09                	jne    80102724 <namex+0x74>
8010271b:	e9 a8 00 00 00       	jmp    801027c8 <namex+0x118>
80102720:	84 c0                	test   %al,%al
80102722:	74 0a                	je     8010272e <namex+0x7e>
    path++;
80102724:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102727:	0f b6 02             	movzbl (%edx),%eax
8010272a:	3c 2f                	cmp    $0x2f,%al
8010272c:	75 f2                	jne    80102720 <namex+0x70>
8010272e:	89 d1                	mov    %edx,%ecx
80102730:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102732:	83 f9 0d             	cmp    $0xd,%ecx
80102735:	0f 8e 91 00 00 00    	jle    801027cc <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010273b:	83 ec 04             	sub    $0x4,%esp
8010273e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102741:	6a 0e                	push   $0xe
80102743:	53                   	push   %ebx
80102744:	57                   	push   %edi
80102745:	e8 c6 34 00 00       	call   80105c10 <memmove>
    path++;
8010274a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010274d:	83 c4 10             	add    $0x10,%esp
    path++;
80102750:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80102752:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102755:	75 11                	jne    80102768 <namex+0xb8>
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102760:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102763:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102766:	74 f8                	je     80102760 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102768:	83 ec 0c             	sub    $0xc,%esp
8010276b:	56                   	push   %esi
8010276c:	e8 5f f9 ff ff       	call   801020d0 <ilock>
    if(ip->type != T_DIR){
80102771:	83 c4 10             	add    $0x10,%esp
80102774:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102779:	0f 85 91 00 00 00    	jne    80102810 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010277f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102782:	85 d2                	test   %edx,%edx
80102784:	74 09                	je     8010278f <namex+0xdf>
80102786:	80 3b 00             	cmpb   $0x0,(%ebx)
80102789:	0f 84 b7 00 00 00    	je     80102846 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010278f:	83 ec 04             	sub    $0x4,%esp
80102792:	6a 00                	push   $0x0
80102794:	57                   	push   %edi
80102795:	56                   	push   %esi
80102796:	e8 65 fe ff ff       	call   80102600 <dirlookup>
8010279b:	83 c4 10             	add    $0x10,%esp
8010279e:	85 c0                	test   %eax,%eax
801027a0:	74 6e                	je     80102810 <namex+0x160>
  iunlock(ip);
801027a2:	83 ec 0c             	sub    $0xc,%esp
801027a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801027a8:	56                   	push   %esi
801027a9:	e8 02 fa ff ff       	call   801021b0 <iunlock>
  iput(ip);
801027ae:	89 34 24             	mov    %esi,(%esp)
801027b1:	e8 4a fa ff ff       	call   80102200 <iput>
801027b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801027b9:	83 c4 10             	add    $0x10,%esp
801027bc:	89 c6                	mov    %eax,%esi
801027be:	e9 38 ff ff ff       	jmp    801026fb <namex+0x4b>
801027c3:	90                   	nop
801027c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
801027c8:	89 da                	mov    %ebx,%edx
801027ca:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
801027cc:	83 ec 04             	sub    $0x4,%esp
801027cf:	89 55 dc             	mov    %edx,-0x24(%ebp)
801027d2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801027d5:	51                   	push   %ecx
801027d6:	53                   	push   %ebx
801027d7:	57                   	push   %edi
801027d8:	e8 33 34 00 00       	call   80105c10 <memmove>
    name[len] = 0;
801027dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801027e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801027e3:	83 c4 10             	add    $0x10,%esp
801027e6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
801027ea:	89 d3                	mov    %edx,%ebx
801027ec:	e9 61 ff ff ff       	jmp    80102752 <namex+0xa2>
801027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801027f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801027fb:	85 c0                	test   %eax,%eax
801027fd:	75 5d                	jne    8010285c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
801027ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102802:	89 f0                	mov    %esi,%eax
80102804:	5b                   	pop    %ebx
80102805:	5e                   	pop    %esi
80102806:	5f                   	pop    %edi
80102807:	5d                   	pop    %ebp
80102808:	c3                   	ret    
80102809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102810:	83 ec 0c             	sub    $0xc,%esp
80102813:	56                   	push   %esi
80102814:	e8 97 f9 ff ff       	call   801021b0 <iunlock>
  iput(ip);
80102819:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010281c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010281e:	e8 dd f9 ff ff       	call   80102200 <iput>
      return 0;
80102823:	83 c4 10             	add    $0x10,%esp
}
80102826:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102829:	89 f0                	mov    %esi,%eax
8010282b:	5b                   	pop    %ebx
8010282c:	5e                   	pop    %esi
8010282d:	5f                   	pop    %edi
8010282e:	5d                   	pop    %ebp
8010282f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102830:	ba 01 00 00 00       	mov    $0x1,%edx
80102835:	b8 01 00 00 00       	mov    $0x1,%eax
8010283a:	e8 21 f4 ff ff       	call   80101c60 <iget>
8010283f:	89 c6                	mov    %eax,%esi
80102841:	e9 b5 fe ff ff       	jmp    801026fb <namex+0x4b>
      iunlock(ip);
80102846:	83 ec 0c             	sub    $0xc,%esp
80102849:	56                   	push   %esi
8010284a:	e8 61 f9 ff ff       	call   801021b0 <iunlock>
      return ip;
8010284f:	83 c4 10             	add    $0x10,%esp
}
80102852:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102855:	89 f0                	mov    %esi,%eax
80102857:	5b                   	pop    %ebx
80102858:	5e                   	pop    %esi
80102859:	5f                   	pop    %edi
8010285a:	5d                   	pop    %ebp
8010285b:	c3                   	ret    
    iput(ip);
8010285c:	83 ec 0c             	sub    $0xc,%esp
8010285f:	56                   	push   %esi
    return 0;
80102860:	31 f6                	xor    %esi,%esi
    iput(ip);
80102862:	e8 99 f9 ff ff       	call   80102200 <iput>
    return 0;
80102867:	83 c4 10             	add    $0x10,%esp
8010286a:	eb 93                	jmp    801027ff <namex+0x14f>
8010286c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102870 <dirlink>:
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	57                   	push   %edi
80102874:	56                   	push   %esi
80102875:	53                   	push   %ebx
80102876:	83 ec 20             	sub    $0x20,%esp
80102879:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010287c:	6a 00                	push   $0x0
8010287e:	ff 75 0c             	pushl  0xc(%ebp)
80102881:	53                   	push   %ebx
80102882:	e8 79 fd ff ff       	call   80102600 <dirlookup>
80102887:	83 c4 10             	add    $0x10,%esp
8010288a:	85 c0                	test   %eax,%eax
8010288c:	75 67                	jne    801028f5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010288e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102891:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102894:	85 ff                	test   %edi,%edi
80102896:	74 29                	je     801028c1 <dirlink+0x51>
80102898:	31 ff                	xor    %edi,%edi
8010289a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010289d:	eb 09                	jmp    801028a8 <dirlink+0x38>
8010289f:	90                   	nop
801028a0:	83 c7 10             	add    $0x10,%edi
801028a3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801028a6:	73 19                	jae    801028c1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801028a8:	6a 10                	push   $0x10
801028aa:	57                   	push   %edi
801028ab:	56                   	push   %esi
801028ac:	53                   	push   %ebx
801028ad:	e8 fe fa ff ff       	call   801023b0 <readi>
801028b2:	83 c4 10             	add    $0x10,%esp
801028b5:	83 f8 10             	cmp    $0x10,%eax
801028b8:	75 4e                	jne    80102908 <dirlink+0x98>
    if(de.inum == 0)
801028ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801028bf:	75 df                	jne    801028a0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801028c1:	8d 45 da             	lea    -0x26(%ebp),%eax
801028c4:	83 ec 04             	sub    $0x4,%esp
801028c7:	6a 0e                	push   $0xe
801028c9:	ff 75 0c             	pushl  0xc(%ebp)
801028cc:	50                   	push   %eax
801028cd:	e8 0e 34 00 00       	call   80105ce0 <strncpy>
  de.inum = inum;
801028d2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801028d5:	6a 10                	push   $0x10
801028d7:	57                   	push   %edi
801028d8:	56                   	push   %esi
801028d9:	53                   	push   %ebx
  de.inum = inum;
801028da:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801028de:	e8 cd fb ff ff       	call   801024b0 <writei>
801028e3:	83 c4 20             	add    $0x20,%esp
801028e6:	83 f8 10             	cmp    $0x10,%eax
801028e9:	75 2a                	jne    80102915 <dirlink+0xa5>
  return 0;
801028eb:	31 c0                	xor    %eax,%eax
}
801028ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028f0:	5b                   	pop    %ebx
801028f1:	5e                   	pop    %esi
801028f2:	5f                   	pop    %edi
801028f3:	5d                   	pop    %ebp
801028f4:	c3                   	ret    
    iput(ip);
801028f5:	83 ec 0c             	sub    $0xc,%esp
801028f8:	50                   	push   %eax
801028f9:	e8 02 f9 ff ff       	call   80102200 <iput>
    return -1;
801028fe:	83 c4 10             	add    $0x10,%esp
80102901:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102906:	eb e5                	jmp    801028ed <dirlink+0x7d>
      panic("dirlink read");
80102908:	83 ec 0c             	sub    $0xc,%esp
8010290b:	68 9b 8f 10 80       	push   $0x80108f9b
80102910:	e8 5b e0 ff ff       	call   80100970 <panic>
    panic("dirlink");
80102915:	83 ec 0c             	sub    $0xc,%esp
80102918:	68 06 99 10 80       	push   $0x80109906
8010291d:	e8 4e e0 ff ff       	call   80100970 <panic>
80102922:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102930 <namei>:

struct inode*
namei(char *path)
{
80102930:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102931:	31 d2                	xor    %edx,%edx
{
80102933:	89 e5                	mov    %esp,%ebp
80102935:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102938:	8b 45 08             	mov    0x8(%ebp),%eax
8010293b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010293e:	e8 6d fd ff ff       	call   801026b0 <namex>
}
80102943:	c9                   	leave  
80102944:	c3                   	ret    
80102945:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102950 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102950:	55                   	push   %ebp
  return namex(path, 1, name);
80102951:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102956:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102958:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010295b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010295e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010295f:	e9 4c fd ff ff       	jmp    801026b0 <namex>
80102964:	66 90                	xchg   %ax,%ax
80102966:	66 90                	xchg   %ax,%ax
80102968:	66 90                	xchg   %ax,%ax
8010296a:	66 90                	xchg   %ax,%ax
8010296c:	66 90                	xchg   %ax,%ax
8010296e:	66 90                	xchg   %ax,%ax

80102970 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	57                   	push   %edi
80102974:	56                   	push   %esi
80102975:	53                   	push   %ebx
80102976:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102979:	85 c0                	test   %eax,%eax
8010297b:	0f 84 b4 00 00 00    	je     80102a35 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102981:	8b 58 08             	mov    0x8(%eax),%ebx
80102984:	89 c6                	mov    %eax,%esi
80102986:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010298c:	0f 87 96 00 00 00    	ja     80102a28 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102992:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102997:	89 f6                	mov    %esi,%esi
80102999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801029a0:	89 ca                	mov    %ecx,%edx
801029a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801029a3:	83 e0 c0             	and    $0xffffffc0,%eax
801029a6:	3c 40                	cmp    $0x40,%al
801029a8:	75 f6                	jne    801029a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029aa:	31 ff                	xor    %edi,%edi
801029ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801029b1:	89 f8                	mov    %edi,%eax
801029b3:	ee                   	out    %al,(%dx)
801029b4:	b8 01 00 00 00       	mov    $0x1,%eax
801029b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801029be:	ee                   	out    %al,(%dx)
801029bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801029c4:	89 d8                	mov    %ebx,%eax
801029c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801029c7:	89 d8                	mov    %ebx,%eax
801029c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801029ce:	c1 f8 08             	sar    $0x8,%eax
801029d1:	ee                   	out    %al,(%dx)
801029d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801029d7:	89 f8                	mov    %edi,%eax
801029d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801029da:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801029de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801029e3:	c1 e0 04             	shl    $0x4,%eax
801029e6:	83 e0 10             	and    $0x10,%eax
801029e9:	83 c8 e0             	or     $0xffffffe0,%eax
801029ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801029ed:	f6 06 04             	testb  $0x4,(%esi)
801029f0:	75 16                	jne    80102a08 <idestart+0x98>
801029f2:	b8 20 00 00 00       	mov    $0x20,%eax
801029f7:	89 ca                	mov    %ecx,%edx
801029f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801029fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029fd:	5b                   	pop    %ebx
801029fe:	5e                   	pop    %esi
801029ff:	5f                   	pop    %edi
80102a00:	5d                   	pop    %ebp
80102a01:	c3                   	ret    
80102a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a08:	b8 30 00 00 00       	mov    $0x30,%eax
80102a0d:	89 ca                	mov    %ecx,%edx
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102a10:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102a15:	83 c6 5c             	add    $0x5c,%esi
80102a18:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102a1d:	fc                   	cld    
80102a1e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a23:	5b                   	pop    %ebx
80102a24:	5e                   	pop    %esi
80102a25:	5f                   	pop    %edi
80102a26:	5d                   	pop    %ebp
80102a27:	c3                   	ret    
    panic("incorrect blockno");
80102a28:	83 ec 0c             	sub    $0xc,%esp
80102a2b:	68 04 90 10 80       	push   $0x80109004
80102a30:	e8 3b df ff ff       	call   80100970 <panic>
    panic("idestart");
80102a35:	83 ec 0c             	sub    $0xc,%esp
80102a38:	68 fb 8f 10 80       	push   $0x80108ffb
80102a3d:	e8 2e df ff ff       	call   80100970 <panic>
80102a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a50 <ideinit>:
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102a56:	68 16 90 10 80       	push   $0x80109016
80102a5b:	68 a0 2d 15 80       	push   $0x80152da0
80102a60:	e8 8b 2e 00 00       	call   801058f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102a65:	58                   	pop    %eax
80102a66:	a1 c0 b8 15 80       	mov    0x8015b8c0,%eax
80102a6b:	5a                   	pop    %edx
80102a6c:	83 e8 01             	sub    $0x1,%eax
80102a6f:	50                   	push   %eax
80102a70:	6a 0e                	push   $0xe
80102a72:	e8 a9 02 00 00       	call   80102d20 <ioapicenable>
80102a77:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a7f:	90                   	nop
80102a80:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102a81:	83 e0 c0             	and    $0xffffffc0,%eax
80102a84:	3c 40                	cmp    $0x40,%al
80102a86:	75 f8                	jne    80102a80 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a88:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102a8d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a92:	ee                   	out    %al,(%dx)
80102a93:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a9d:	eb 06                	jmp    80102aa5 <ideinit+0x55>
80102a9f:	90                   	nop
  for(i=0; i<1000; i++){
80102aa0:	83 e9 01             	sub    $0x1,%ecx
80102aa3:	74 0f                	je     80102ab4 <ideinit+0x64>
80102aa5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102aa6:	84 c0                	test   %al,%al
80102aa8:	74 f6                	je     80102aa0 <ideinit+0x50>
      havedisk1 = 1;
80102aaa:	c7 05 80 2d 15 80 01 	movl   $0x1,0x80152d80
80102ab1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102ab9:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102abe:	ee                   	out    %al,(%dx)
}
80102abf:	c9                   	leave  
80102ac0:	c3                   	ret    
80102ac1:	eb 0d                	jmp    80102ad0 <ideintr>
80102ac3:	90                   	nop
80102ac4:	90                   	nop
80102ac5:	90                   	nop
80102ac6:	90                   	nop
80102ac7:	90                   	nop
80102ac8:	90                   	nop
80102ac9:	90                   	nop
80102aca:	90                   	nop
80102acb:	90                   	nop
80102acc:	90                   	nop
80102acd:	90                   	nop
80102ace:	90                   	nop
80102acf:	90                   	nop

80102ad0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	57                   	push   %edi
80102ad4:	56                   	push   %esi
80102ad5:	53                   	push   %ebx
80102ad6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102ad9:	68 a0 2d 15 80       	push   $0x80152da0
80102ade:	e8 fd 2e 00 00       	call   801059e0 <acquire>

  if((b = idequeue) == 0){
80102ae3:	8b 1d 84 2d 15 80    	mov    0x80152d84,%ebx
80102ae9:	83 c4 10             	add    $0x10,%esp
80102aec:	85 db                	test   %ebx,%ebx
80102aee:	74 67                	je     80102b57 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102af0:	8b 43 58             	mov    0x58(%ebx),%eax
80102af3:	a3 84 2d 15 80       	mov    %eax,0x80152d84

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102af8:	8b 3b                	mov    (%ebx),%edi
80102afa:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102b00:	75 31                	jne    80102b33 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b02:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102b07:	89 f6                	mov    %esi,%esi
80102b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102b10:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102b11:	89 c6                	mov    %eax,%esi
80102b13:	83 e6 c0             	and    $0xffffffc0,%esi
80102b16:	89 f1                	mov    %esi,%ecx
80102b18:	80 f9 40             	cmp    $0x40,%cl
80102b1b:	75 f3                	jne    80102b10 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102b1d:	a8 21                	test   $0x21,%al
80102b1f:	75 12                	jne    80102b33 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102b21:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102b24:	b9 80 00 00 00       	mov    $0x80,%ecx
80102b29:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102b2e:	fc                   	cld    
80102b2f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102b31:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102b33:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102b36:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102b39:	89 f9                	mov    %edi,%ecx
80102b3b:	83 c9 02             	or     $0x2,%ecx
80102b3e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102b40:	53                   	push   %ebx
80102b41:	e8 fa 2a 00 00       	call   80105640 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102b46:	a1 84 2d 15 80       	mov    0x80152d84,%eax
80102b4b:	83 c4 10             	add    $0x10,%esp
80102b4e:	85 c0                	test   %eax,%eax
80102b50:	74 05                	je     80102b57 <ideintr+0x87>
    idestart(idequeue);
80102b52:	e8 19 fe ff ff       	call   80102970 <idestart>
    release(&idelock);
80102b57:	83 ec 0c             	sub    $0xc,%esp
80102b5a:	68 a0 2d 15 80       	push   $0x80152da0
80102b5f:	e8 9c 2f 00 00       	call   80105b00 <release>

  release(&idelock);
}
80102b64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b67:	5b                   	pop    %ebx
80102b68:	5e                   	pop    %esi
80102b69:	5f                   	pop    %edi
80102b6a:	5d                   	pop    %ebp
80102b6b:	c3                   	ret    
80102b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b70 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	53                   	push   %ebx
80102b74:	83 ec 10             	sub    $0x10,%esp
80102b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102b7a:	8d 43 0c             	lea    0xc(%ebx),%eax
80102b7d:	50                   	push   %eax
80102b7e:	e8 3d 2d 00 00       	call   801058c0 <holdingsleep>
80102b83:	83 c4 10             	add    $0x10,%esp
80102b86:	85 c0                	test   %eax,%eax
80102b88:	0f 84 c6 00 00 00    	je     80102c54 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102b8e:	8b 03                	mov    (%ebx),%eax
80102b90:	83 e0 06             	and    $0x6,%eax
80102b93:	83 f8 02             	cmp    $0x2,%eax
80102b96:	0f 84 ab 00 00 00    	je     80102c47 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102b9c:	8b 53 04             	mov    0x4(%ebx),%edx
80102b9f:	85 d2                	test   %edx,%edx
80102ba1:	74 0d                	je     80102bb0 <iderw+0x40>
80102ba3:	a1 80 2d 15 80       	mov    0x80152d80,%eax
80102ba8:	85 c0                	test   %eax,%eax
80102baa:	0f 84 b1 00 00 00    	je     80102c61 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102bb0:	83 ec 0c             	sub    $0xc,%esp
80102bb3:	68 a0 2d 15 80       	push   $0x80152da0
80102bb8:	e8 23 2e 00 00       	call   801059e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102bbd:	8b 15 84 2d 15 80    	mov    0x80152d84,%edx
80102bc3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102bc6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102bcd:	85 d2                	test   %edx,%edx
80102bcf:	75 09                	jne    80102bda <iderw+0x6a>
80102bd1:	eb 6d                	jmp    80102c40 <iderw+0xd0>
80102bd3:	90                   	nop
80102bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bd8:	89 c2                	mov    %eax,%edx
80102bda:	8b 42 58             	mov    0x58(%edx),%eax
80102bdd:	85 c0                	test   %eax,%eax
80102bdf:	75 f7                	jne    80102bd8 <iderw+0x68>
80102be1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102be4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102be6:	39 1d 84 2d 15 80    	cmp    %ebx,0x80152d84
80102bec:	74 42                	je     80102c30 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102bee:	8b 03                	mov    (%ebx),%eax
80102bf0:	83 e0 06             	and    $0x6,%eax
80102bf3:	83 f8 02             	cmp    $0x2,%eax
80102bf6:	74 23                	je     80102c1b <iderw+0xab>
80102bf8:	90                   	nop
80102bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102c00:	83 ec 08             	sub    $0x8,%esp
80102c03:	68 a0 2d 15 80       	push   $0x80152da0
80102c08:	53                   	push   %ebx
80102c09:	e8 82 28 00 00       	call   80105490 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102c0e:	8b 03                	mov    (%ebx),%eax
80102c10:	83 c4 10             	add    $0x10,%esp
80102c13:	83 e0 06             	and    $0x6,%eax
80102c16:	83 f8 02             	cmp    $0x2,%eax
80102c19:	75 e5                	jne    80102c00 <iderw+0x90>
  }


  release(&idelock);
80102c1b:	c7 45 08 a0 2d 15 80 	movl   $0x80152da0,0x8(%ebp)
}
80102c22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c25:	c9                   	leave  
  release(&idelock);
80102c26:	e9 d5 2e 00 00       	jmp    80105b00 <release>
80102c2b:	90                   	nop
80102c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102c30:	89 d8                	mov    %ebx,%eax
80102c32:	e8 39 fd ff ff       	call   80102970 <idestart>
80102c37:	eb b5                	jmp    80102bee <iderw+0x7e>
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c40:	ba 84 2d 15 80       	mov    $0x80152d84,%edx
80102c45:	eb 9d                	jmp    80102be4 <iderw+0x74>
    panic("iderw: nothing to do");
80102c47:	83 ec 0c             	sub    $0xc,%esp
80102c4a:	68 30 90 10 80       	push   $0x80109030
80102c4f:	e8 1c dd ff ff       	call   80100970 <panic>
    panic("iderw: buf not locked");
80102c54:	83 ec 0c             	sub    $0xc,%esp
80102c57:	68 1a 90 10 80       	push   $0x8010901a
80102c5c:	e8 0f dd ff ff       	call   80100970 <panic>
    panic("iderw: ide disk 1 not present");
80102c61:	83 ec 0c             	sub    $0xc,%esp
80102c64:	68 45 90 10 80       	push   $0x80109045
80102c69:	e8 02 dd ff ff       	call   80100970 <panic>
80102c6e:	66 90                	xchg   %ax,%ax

80102c70 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102c70:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102c71:	c7 05 f4 b1 15 80 00 	movl   $0xfec00000,0x8015b1f4
80102c78:	00 c0 fe 
{
80102c7b:	89 e5                	mov    %esp,%ebp
80102c7d:	56                   	push   %esi
80102c7e:	53                   	push   %ebx
  ioapic->reg = reg;
80102c7f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102c86:	00 00 00 
  return ioapic->data;
80102c89:	a1 f4 b1 15 80       	mov    0x8015b1f4,%eax
80102c8e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102c91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102c97:	8b 0d f4 b1 15 80    	mov    0x8015b1f4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102c9d:	0f b6 15 20 b3 15 80 	movzbl 0x8015b320,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102ca4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102ca7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102caa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
80102cad:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102cb0:	39 c2                	cmp    %eax,%edx
80102cb2:	74 16                	je     80102cca <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102cb4:	83 ec 0c             	sub    $0xc,%esp
80102cb7:	68 64 90 10 80       	push   $0x80109064
80102cbc:	e8 7f df ff ff       	call   80100c40 <cprintf>
80102cc1:	8b 0d f4 b1 15 80    	mov    0x8015b1f4,%ecx
80102cc7:	83 c4 10             	add    $0x10,%esp
80102cca:	83 c3 21             	add    $0x21,%ebx
{
80102ccd:	ba 10 00 00 00       	mov    $0x10,%edx
80102cd2:	b8 20 00 00 00       	mov    $0x20,%eax
80102cd7:	89 f6                	mov    %esi,%esi
80102cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102ce0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102ce2:	8b 0d f4 b1 15 80    	mov    0x8015b1f4,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102ce8:	89 c6                	mov    %eax,%esi
80102cea:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102cf0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102cf3:	89 71 10             	mov    %esi,0x10(%ecx)
80102cf6:	8d 72 01             	lea    0x1(%edx),%esi
80102cf9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
80102cfc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
80102cfe:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102d00:	8b 0d f4 b1 15 80    	mov    0x8015b1f4,%ecx
80102d06:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102d0d:	75 d1                	jne    80102ce0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102d0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d12:	5b                   	pop    %ebx
80102d13:	5e                   	pop    %esi
80102d14:	5d                   	pop    %ebp
80102d15:	c3                   	ret    
80102d16:	8d 76 00             	lea    0x0(%esi),%esi
80102d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d20 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102d20:	55                   	push   %ebp
  ioapic->reg = reg;
80102d21:	8b 0d f4 b1 15 80    	mov    0x8015b1f4,%ecx
{
80102d27:	89 e5                	mov    %esp,%ebp
80102d29:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102d2c:	8d 50 20             	lea    0x20(%eax),%edx
80102d2f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102d33:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102d35:	8b 0d f4 b1 15 80    	mov    0x8015b1f4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d3b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102d3e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d41:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102d44:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102d46:	a1 f4 b1 15 80       	mov    0x8015b1f4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d4b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102d4e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102d51:	5d                   	pop    %ebp
80102d52:	c3                   	ret    
80102d53:	66 90                	xchg   %ax,%ax
80102d55:	66 90                	xchg   %ax,%ax
80102d57:	66 90                	xchg   %ax,%ax
80102d59:	66 90                	xchg   %ax,%ax
80102d5b:	66 90                	xchg   %ax,%ax
80102d5d:	66 90                	xchg   %ax,%ax
80102d5f:	90                   	nop

80102d60 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	53                   	push   %ebx
80102d64:	83 ec 04             	sub    $0x4,%esp
80102d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102d6a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102d70:	75 70                	jne    80102de2 <kfree+0x82>
80102d72:	81 fb 68 e0 15 80    	cmp    $0x8015e068,%ebx
80102d78:	72 68                	jb     80102de2 <kfree+0x82>
80102d7a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102d80:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d85:	77 5b                	ja     80102de2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d87:	83 ec 04             	sub    $0x4,%esp
80102d8a:	68 00 10 00 00       	push   $0x1000
80102d8f:	6a 01                	push   $0x1
80102d91:	53                   	push   %ebx
80102d92:	e8 c9 2d 00 00       	call   80105b60 <memset>

  if(kmem.use_lock)
80102d97:	8b 15 34 b2 15 80    	mov    0x8015b234,%edx
80102d9d:	83 c4 10             	add    $0x10,%esp
80102da0:	85 d2                	test   %edx,%edx
80102da2:	75 2c                	jne    80102dd0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102da4:	a1 38 b2 15 80       	mov    0x8015b238,%eax
80102da9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102dab:	a1 34 b2 15 80       	mov    0x8015b234,%eax
  kmem.freelist = r;
80102db0:	89 1d 38 b2 15 80    	mov    %ebx,0x8015b238
  if(kmem.use_lock)
80102db6:	85 c0                	test   %eax,%eax
80102db8:	75 06                	jne    80102dc0 <kfree+0x60>
    release(&kmem.lock);
}
80102dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dbd:	c9                   	leave  
80102dbe:	c3                   	ret    
80102dbf:	90                   	nop
    release(&kmem.lock);
80102dc0:	c7 45 08 00 b2 15 80 	movl   $0x8015b200,0x8(%ebp)
}
80102dc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dca:	c9                   	leave  
    release(&kmem.lock);
80102dcb:	e9 30 2d 00 00       	jmp    80105b00 <release>
    acquire(&kmem.lock);
80102dd0:	83 ec 0c             	sub    $0xc,%esp
80102dd3:	68 00 b2 15 80       	push   $0x8015b200
80102dd8:	e8 03 2c 00 00       	call   801059e0 <acquire>
80102ddd:	83 c4 10             	add    $0x10,%esp
80102de0:	eb c2                	jmp    80102da4 <kfree+0x44>
    panic("kfree");
80102de2:	83 ec 0c             	sub    $0xc,%esp
80102de5:	68 96 90 10 80       	push   $0x80109096
80102dea:	e8 81 db ff ff       	call   80100970 <panic>
80102def:	90                   	nop

80102df0 <freerange>:
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	56                   	push   %esi
80102df4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102df5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102df8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102dfb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e01:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e07:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e0d:	39 de                	cmp    %ebx,%esi
80102e0f:	72 23                	jb     80102e34 <freerange+0x44>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102e18:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102e1e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e27:	50                   	push   %eax
80102e28:	e8 33 ff ff ff       	call   80102d60 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e2d:	83 c4 10             	add    $0x10,%esp
80102e30:	39 f3                	cmp    %esi,%ebx
80102e32:	76 e4                	jbe    80102e18 <freerange+0x28>
}
80102e34:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e37:	5b                   	pop    %ebx
80102e38:	5e                   	pop    %esi
80102e39:	5d                   	pop    %ebp
80102e3a:	c3                   	ret    
80102e3b:	90                   	nop
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e40 <kinit1>:
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	56                   	push   %esi
80102e44:	53                   	push   %ebx
80102e45:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102e48:	83 ec 08             	sub    $0x8,%esp
80102e4b:	68 9c 90 10 80       	push   $0x8010909c
80102e50:	68 00 b2 15 80       	push   $0x8015b200
80102e55:	e8 96 2a 00 00       	call   801058f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e5d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102e60:	c7 05 34 b2 15 80 00 	movl   $0x0,0x8015b234
80102e67:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102e6a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e70:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e76:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e7c:	39 de                	cmp    %ebx,%esi
80102e7e:	72 1c                	jb     80102e9c <kinit1+0x5c>
    kfree(p);
80102e80:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102e86:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e89:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e8f:	50                   	push   %eax
80102e90:	e8 cb fe ff ff       	call   80102d60 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e95:	83 c4 10             	add    $0x10,%esp
80102e98:	39 de                	cmp    %ebx,%esi
80102e9a:	73 e4                	jae    80102e80 <kinit1+0x40>
}
80102e9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e9f:	5b                   	pop    %ebx
80102ea0:	5e                   	pop    %esi
80102ea1:	5d                   	pop    %ebp
80102ea2:	c3                   	ret    
80102ea3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102eb0 <kinit2>:
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	56                   	push   %esi
80102eb4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102eb5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102eb8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102ebb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ec1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ec7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ecd:	39 de                	cmp    %ebx,%esi
80102ecf:	72 23                	jb     80102ef4 <kinit2+0x44>
80102ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102ed8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102ede:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ee1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ee7:	50                   	push   %eax
80102ee8:	e8 73 fe ff ff       	call   80102d60 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102eed:	83 c4 10             	add    $0x10,%esp
80102ef0:	39 de                	cmp    %ebx,%esi
80102ef2:	73 e4                	jae    80102ed8 <kinit2+0x28>
  kmem.use_lock = 1;
80102ef4:	c7 05 34 b2 15 80 01 	movl   $0x1,0x8015b234
80102efb:	00 00 00 
}
80102efe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f01:	5b                   	pop    %ebx
80102f02:	5e                   	pop    %esi
80102f03:	5d                   	pop    %ebp
80102f04:	c3                   	ret    
80102f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f10 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102f10:	a1 34 b2 15 80       	mov    0x8015b234,%eax
80102f15:	85 c0                	test   %eax,%eax
80102f17:	75 1f                	jne    80102f38 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102f19:	a1 38 b2 15 80       	mov    0x8015b238,%eax
  if(r)
80102f1e:	85 c0                	test   %eax,%eax
80102f20:	74 0e                	je     80102f30 <kalloc+0x20>
    kmem.freelist = r->next;
80102f22:	8b 10                	mov    (%eax),%edx
80102f24:	89 15 38 b2 15 80    	mov    %edx,0x8015b238
80102f2a:	c3                   	ret    
80102f2b:	90                   	nop
80102f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102f30:	f3 c3                	repz ret 
80102f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102f38:	55                   	push   %ebp
80102f39:	89 e5                	mov    %esp,%ebp
80102f3b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102f3e:	68 00 b2 15 80       	push   $0x8015b200
80102f43:	e8 98 2a 00 00       	call   801059e0 <acquire>
  r = kmem.freelist;
80102f48:	a1 38 b2 15 80       	mov    0x8015b238,%eax
  if(r)
80102f4d:	83 c4 10             	add    $0x10,%esp
80102f50:	8b 15 34 b2 15 80    	mov    0x8015b234,%edx
80102f56:	85 c0                	test   %eax,%eax
80102f58:	74 08                	je     80102f62 <kalloc+0x52>
    kmem.freelist = r->next;
80102f5a:	8b 08                	mov    (%eax),%ecx
80102f5c:	89 0d 38 b2 15 80    	mov    %ecx,0x8015b238
  if(kmem.use_lock)
80102f62:	85 d2                	test   %edx,%edx
80102f64:	74 16                	je     80102f7c <kalloc+0x6c>
    release(&kmem.lock);
80102f66:	83 ec 0c             	sub    $0xc,%esp
80102f69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102f6c:	68 00 b2 15 80       	push   $0x8015b200
80102f71:	e8 8a 2b 00 00       	call   80105b00 <release>
  return (char*)r;
80102f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102f79:	83 c4 10             	add    $0x10,%esp
}
80102f7c:	c9                   	leave  
80102f7d:	c3                   	ret    
80102f7e:	66 90                	xchg   %ax,%ax

80102f80 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f80:	ba 64 00 00 00       	mov    $0x64,%edx
80102f85:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102f86:	a8 01                	test   $0x1,%al
80102f88:	0f 84 c2 00 00 00    	je     80103050 <kbdgetc+0xd0>
80102f8e:	ba 60 00 00 00       	mov    $0x60,%edx
80102f93:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102f94:	0f b6 d0             	movzbl %al,%edx
80102f97:	8b 0d d4 2d 15 80    	mov    0x80152dd4,%ecx

  if(data == 0xE0){
80102f9d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102fa3:	0f 84 7f 00 00 00    	je     80103028 <kbdgetc+0xa8>
{
80102fa9:	55                   	push   %ebp
80102faa:	89 e5                	mov    %esp,%ebp
80102fac:	53                   	push   %ebx
80102fad:	89 cb                	mov    %ecx,%ebx
80102faf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102fb2:	84 c0                	test   %al,%al
80102fb4:	78 4a                	js     80103000 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102fb6:	85 db                	test   %ebx,%ebx
80102fb8:	74 09                	je     80102fc3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102fba:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102fbd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102fc0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102fc3:	0f b6 82 e0 91 10 80 	movzbl -0x7fef6e20(%edx),%eax
80102fca:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102fcc:	0f b6 82 e0 90 10 80 	movzbl -0x7fef6f20(%edx),%eax
80102fd3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102fd5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102fd7:	89 0d d4 2d 15 80    	mov    %ecx,0x80152dd4
  c = charcode[shift & (CTL | SHIFT)][data];
80102fdd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102fe0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102fe3:	8b 04 85 c0 90 10 80 	mov    -0x7fef6f40(,%eax,4),%eax
80102fea:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102fee:	74 31                	je     80103021 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102ff0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102ff3:	83 fa 19             	cmp    $0x19,%edx
80102ff6:	77 40                	ja     80103038 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102ff8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102ffb:	5b                   	pop    %ebx
80102ffc:	5d                   	pop    %ebp
80102ffd:	c3                   	ret    
80102ffe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80103000:	83 e0 7f             	and    $0x7f,%eax
80103003:	85 db                	test   %ebx,%ebx
80103005:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80103008:	0f b6 82 e0 91 10 80 	movzbl -0x7fef6e20(%edx),%eax
8010300f:	83 c8 40             	or     $0x40,%eax
80103012:	0f b6 c0             	movzbl %al,%eax
80103015:	f7 d0                	not    %eax
80103017:	21 c1                	and    %eax,%ecx
    return 0;
80103019:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010301b:	89 0d d4 2d 15 80    	mov    %ecx,0x80152dd4
}
80103021:	5b                   	pop    %ebx
80103022:	5d                   	pop    %ebp
80103023:	c3                   	ret    
80103024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80103028:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010302b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010302d:	89 0d d4 2d 15 80    	mov    %ecx,0x80152dd4
    return 0;
80103033:	c3                   	ret    
80103034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80103038:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010303b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010303e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010303f:	83 f9 1a             	cmp    $0x1a,%ecx
80103042:	0f 42 c2             	cmovb  %edx,%eax
}
80103045:	5d                   	pop    %ebp
80103046:	c3                   	ret    
80103047:	89 f6                	mov    %esi,%esi
80103049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80103050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103055:	c3                   	ret    
80103056:	8d 76 00             	lea    0x0(%esi),%esi
80103059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103060 <kbdintr>:

void
kbdintr(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80103066:	68 80 2f 10 80       	push   $0x80102f80
8010306b:	e8 80 dd ff ff       	call   80100df0 <consoleintr>
}
80103070:	83 c4 10             	add    $0x10,%esp
80103073:	c9                   	leave  
80103074:	c3                   	ret    
80103075:	66 90                	xchg   %ax,%ax
80103077:	66 90                	xchg   %ax,%ax
80103079:	66 90                	xchg   %ax,%ax
8010307b:	66 90                	xchg   %ax,%ax
8010307d:	66 90                	xchg   %ax,%ax
8010307f:	90                   	nop

80103080 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103080:	a1 3c b2 15 80       	mov    0x8015b23c,%eax
{
80103085:	55                   	push   %ebp
80103086:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80103088:	85 c0                	test   %eax,%eax
8010308a:	0f 84 c8 00 00 00    	je     80103158 <lapicinit+0xd8>
  lapic[index] = value;
80103090:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103097:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010309a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010309d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801030a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801030b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801030b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801030be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801030c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801030cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801030d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030db:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801030de:	8b 50 30             	mov    0x30(%eax),%edx
801030e1:	c1 ea 10             	shr    $0x10,%edx
801030e4:	80 fa 03             	cmp    $0x3,%dl
801030e7:	77 77                	ja     80103160 <lapicinit+0xe0>
  lapic[index] = value;
801030e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801030f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030f3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103100:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103103:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010310a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010310d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103110:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103117:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010311a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010311d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103124:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103127:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010312a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103131:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103134:	8b 50 20             	mov    0x20(%eax),%edx
80103137:	89 f6                	mov    %esi,%esi
80103139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103140:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103146:	80 e6 10             	and    $0x10,%dh
80103149:	75 f5                	jne    80103140 <lapicinit+0xc0>
  lapic[index] = value;
8010314b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103152:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103155:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103158:	5d                   	pop    %ebp
80103159:	c3                   	ret    
8010315a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80103160:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103167:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010316a:	8b 50 20             	mov    0x20(%eax),%edx
8010316d:	e9 77 ff ff ff       	jmp    801030e9 <lapicinit+0x69>
80103172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103180 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103180:	8b 15 3c b2 15 80    	mov    0x8015b23c,%edx
{
80103186:	55                   	push   %ebp
80103187:	31 c0                	xor    %eax,%eax
80103189:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010318b:	85 d2                	test   %edx,%edx
8010318d:	74 06                	je     80103195 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010318f:	8b 42 20             	mov    0x20(%edx),%eax
80103192:	c1 e8 18             	shr    $0x18,%eax
}
80103195:	5d                   	pop    %ebp
80103196:	c3                   	ret    
80103197:	89 f6                	mov    %esi,%esi
80103199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801031a0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801031a0:	a1 3c b2 15 80       	mov    0x8015b23c,%eax
{
801031a5:	55                   	push   %ebp
801031a6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801031a8:	85 c0                	test   %eax,%eax
801031aa:	74 0d                	je     801031b9 <lapiceoi+0x19>
  lapic[index] = value;
801031ac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801031b3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031b6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801031b9:	5d                   	pop    %ebp
801031ba:	c3                   	ret    
801031bb:	90                   	nop
801031bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031c0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
}
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
801031c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801031d0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801031d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031d1:	b8 0f 00 00 00       	mov    $0xf,%eax
801031d6:	ba 70 00 00 00       	mov    $0x70,%edx
801031db:	89 e5                	mov    %esp,%ebp
801031dd:	53                   	push   %ebx
801031de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801031e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801031e4:	ee                   	out    %al,(%dx)
801031e5:	b8 0a 00 00 00       	mov    $0xa,%eax
801031ea:	ba 71 00 00 00       	mov    $0x71,%edx
801031ef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801031f0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801031f2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801031f5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801031fb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801031fd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80103200:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80103203:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80103205:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103208:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010320e:	a1 3c b2 15 80       	mov    0x8015b23c,%eax
80103213:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103219:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010321c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103223:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103226:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103229:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103230:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103233:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103236:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010323c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010323f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103245:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103248:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010324e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103251:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103257:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010325a:	5b                   	pop    %ebx
8010325b:	5d                   	pop    %ebp
8010325c:	c3                   	ret    
8010325d:	8d 76 00             	lea    0x0(%esi),%esi

80103260 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103260:	55                   	push   %ebp
80103261:	b8 0b 00 00 00       	mov    $0xb,%eax
80103266:	ba 70 00 00 00       	mov    $0x70,%edx
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	57                   	push   %edi
8010326e:	56                   	push   %esi
8010326f:	53                   	push   %ebx
80103270:	83 ec 4c             	sub    $0x4c,%esp
80103273:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103274:	ba 71 00 00 00       	mov    $0x71,%edx
80103279:	ec                   	in     (%dx),%al
8010327a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010327d:	bb 70 00 00 00       	mov    $0x70,%ebx
80103282:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103285:	8d 76 00             	lea    0x0(%esi),%esi
80103288:	31 c0                	xor    %eax,%eax
8010328a:	89 da                	mov    %ebx,%edx
8010328c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010328d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103292:	89 ca                	mov    %ecx,%edx
80103294:	ec                   	in     (%dx),%al
80103295:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103298:	89 da                	mov    %ebx,%edx
8010329a:	b8 02 00 00 00       	mov    $0x2,%eax
8010329f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032a0:	89 ca                	mov    %ecx,%edx
801032a2:	ec                   	in     (%dx),%al
801032a3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032a6:	89 da                	mov    %ebx,%edx
801032a8:	b8 04 00 00 00       	mov    $0x4,%eax
801032ad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ae:	89 ca                	mov    %ecx,%edx
801032b0:	ec                   	in     (%dx),%al
801032b1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b4:	89 da                	mov    %ebx,%edx
801032b6:	b8 07 00 00 00       	mov    $0x7,%eax
801032bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032bc:	89 ca                	mov    %ecx,%edx
801032be:	ec                   	in     (%dx),%al
801032bf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c2:	89 da                	mov    %ebx,%edx
801032c4:	b8 08 00 00 00       	mov    $0x8,%eax
801032c9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ca:	89 ca                	mov    %ecx,%edx
801032cc:	ec                   	in     (%dx),%al
801032cd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032cf:	89 da                	mov    %ebx,%edx
801032d1:	b8 09 00 00 00       	mov    $0x9,%eax
801032d6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d7:	89 ca                	mov    %ecx,%edx
801032d9:	ec                   	in     (%dx),%al
801032da:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032dc:	89 da                	mov    %ebx,%edx
801032de:	b8 0a 00 00 00       	mov    $0xa,%eax
801032e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032e4:	89 ca                	mov    %ecx,%edx
801032e6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801032e7:	84 c0                	test   %al,%al
801032e9:	78 9d                	js     80103288 <cmostime+0x28>
  return inb(CMOS_RETURN);
801032eb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801032ef:	89 fa                	mov    %edi,%edx
801032f1:	0f b6 fa             	movzbl %dl,%edi
801032f4:	89 f2                	mov    %esi,%edx
801032f6:	0f b6 f2             	movzbl %dl,%esi
801032f9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032fc:	89 da                	mov    %ebx,%edx
801032fe:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103301:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103304:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103308:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010330b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010330f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103312:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103316:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103319:	31 c0                	xor    %eax,%eax
8010331b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010331c:	89 ca                	mov    %ecx,%edx
8010331e:	ec                   	in     (%dx),%al
8010331f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	89 da                	mov    %ebx,%edx
80103324:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103327:	b8 02 00 00 00       	mov    $0x2,%eax
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	89 ca                	mov    %ecx,%edx
8010332f:	ec                   	in     (%dx),%al
80103330:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103333:	89 da                	mov    %ebx,%edx
80103335:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103338:	b8 04 00 00 00       	mov    $0x4,%eax
8010333d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010333e:	89 ca                	mov    %ecx,%edx
80103340:	ec                   	in     (%dx),%al
80103341:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103344:	89 da                	mov    %ebx,%edx
80103346:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103349:	b8 07 00 00 00       	mov    $0x7,%eax
8010334e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010334f:	89 ca                	mov    %ecx,%edx
80103351:	ec                   	in     (%dx),%al
80103352:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103355:	89 da                	mov    %ebx,%edx
80103357:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010335a:	b8 08 00 00 00       	mov    $0x8,%eax
8010335f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103360:	89 ca                	mov    %ecx,%edx
80103362:	ec                   	in     (%dx),%al
80103363:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103366:	89 da                	mov    %ebx,%edx
80103368:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010336b:	b8 09 00 00 00       	mov    $0x9,%eax
80103370:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103371:	89 ca                	mov    %ecx,%edx
80103373:	ec                   	in     (%dx),%al
80103374:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103377:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010337a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010337d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103380:	6a 18                	push   $0x18
80103382:	50                   	push   %eax
80103383:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103386:	50                   	push   %eax
80103387:	e8 24 28 00 00       	call   80105bb0 <memcmp>
8010338c:	83 c4 10             	add    $0x10,%esp
8010338f:	85 c0                	test   %eax,%eax
80103391:	0f 85 f1 fe ff ff    	jne    80103288 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103397:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010339b:	75 78                	jne    80103415 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010339d:	8b 45 b8             	mov    -0x48(%ebp),%eax
801033a0:	89 c2                	mov    %eax,%edx
801033a2:	83 e0 0f             	and    $0xf,%eax
801033a5:	c1 ea 04             	shr    $0x4,%edx
801033a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801033b1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801033b4:	89 c2                	mov    %eax,%edx
801033b6:	83 e0 0f             	and    $0xf,%eax
801033b9:	c1 ea 04             	shr    $0x4,%edx
801033bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801033c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801033c8:	89 c2                	mov    %eax,%edx
801033ca:	83 e0 0f             	and    $0xf,%eax
801033cd:	c1 ea 04             	shr    $0x4,%edx
801033d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033d3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033d6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801033d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801033dc:	89 c2                	mov    %eax,%edx
801033de:	83 e0 0f             	and    $0xf,%eax
801033e1:	c1 ea 04             	shr    $0x4,%edx
801033e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033e7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801033ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033f0:	89 c2                	mov    %eax,%edx
801033f2:	83 e0 0f             	and    $0xf,%eax
801033f5:	c1 ea 04             	shr    $0x4,%edx
801033f8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033fb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033fe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103401:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103404:	89 c2                	mov    %eax,%edx
80103406:	83 e0 0f             	and    $0xf,%eax
80103409:	c1 ea 04             	shr    $0x4,%edx
8010340c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010340f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103412:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103415:	8b 75 08             	mov    0x8(%ebp),%esi
80103418:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010341b:	89 06                	mov    %eax,(%esi)
8010341d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103420:	89 46 04             	mov    %eax,0x4(%esi)
80103423:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103426:	89 46 08             	mov    %eax,0x8(%esi)
80103429:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010342c:	89 46 0c             	mov    %eax,0xc(%esi)
8010342f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103432:	89 46 10             	mov    %eax,0x10(%esi)
80103435:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103438:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010343b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103442:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103445:	5b                   	pop    %ebx
80103446:	5e                   	pop    %esi
80103447:	5f                   	pop    %edi
80103448:	5d                   	pop    %ebp
80103449:	c3                   	ret    
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103450:	8b 0d 88 b2 15 80    	mov    0x8015b288,%ecx
80103456:	85 c9                	test   %ecx,%ecx
80103458:	0f 8e 8a 00 00 00    	jle    801034e8 <install_trans+0x98>
{
8010345e:	55                   	push   %ebp
8010345f:	89 e5                	mov    %esp,%ebp
80103461:	57                   	push   %edi
80103462:	56                   	push   %esi
80103463:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103464:	31 db                	xor    %ebx,%ebx
{
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103470:	a1 74 b2 15 80       	mov    0x8015b274,%eax
80103475:	83 ec 08             	sub    $0x8,%esp
80103478:	01 d8                	add    %ebx,%eax
8010347a:	83 c0 01             	add    $0x1,%eax
8010347d:	50                   	push   %eax
8010347e:	ff 35 84 b2 15 80    	pushl  0x8015b284
80103484:	e8 27 d2 ff ff       	call   801006b0 <bread>
80103489:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010348b:	58                   	pop    %eax
8010348c:	5a                   	pop    %edx
8010348d:	ff 34 9d 8c b2 15 80 	pushl  -0x7fea4d74(,%ebx,4)
80103494:	ff 35 84 b2 15 80    	pushl  0x8015b284
  for (tail = 0; tail < log.lh.n; tail++) {
8010349a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010349d:	e8 0e d2 ff ff       	call   801006b0 <bread>
801034a2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034a4:	8d 47 5c             	lea    0x5c(%edi),%eax
801034a7:	83 c4 0c             	add    $0xc,%esp
801034aa:	68 00 02 00 00       	push   $0x200
801034af:	50                   	push   %eax
801034b0:	8d 46 5c             	lea    0x5c(%esi),%eax
801034b3:	50                   	push   %eax
801034b4:	e8 57 27 00 00       	call   80105c10 <memmove>
    bwrite(dbuf);  // write dst to disk
801034b9:	89 34 24             	mov    %esi,(%esp)
801034bc:	e8 bf d2 ff ff       	call   80100780 <bwrite>
    brelse(lbuf);
801034c1:	89 3c 24             	mov    %edi,(%esp)
801034c4:	e8 f7 d2 ff ff       	call   801007c0 <brelse>
    brelse(dbuf);
801034c9:	89 34 24             	mov    %esi,(%esp)
801034cc:	e8 ef d2 ff ff       	call   801007c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801034d1:	83 c4 10             	add    $0x10,%esp
801034d4:	39 1d 88 b2 15 80    	cmp    %ebx,0x8015b288
801034da:	7f 94                	jg     80103470 <install_trans+0x20>
  }
}
801034dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034df:	5b                   	pop    %ebx
801034e0:	5e                   	pop    %esi
801034e1:	5f                   	pop    %edi
801034e2:	5d                   	pop    %ebp
801034e3:	c3                   	ret    
801034e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e8:	f3 c3                	repz ret 
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801034f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	56                   	push   %esi
801034f4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
801034f5:	83 ec 08             	sub    $0x8,%esp
801034f8:	ff 35 74 b2 15 80    	pushl  0x8015b274
801034fe:	ff 35 84 b2 15 80    	pushl  0x8015b284
80103504:	e8 a7 d1 ff ff       	call   801006b0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103509:	8b 1d 88 b2 15 80    	mov    0x8015b288,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010350f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103512:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103514:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103516:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103519:	7e 16                	jle    80103531 <write_head+0x41>
8010351b:	c1 e3 02             	shl    $0x2,%ebx
8010351e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103520:	8b 8a 8c b2 15 80    	mov    -0x7fea4d74(%edx),%ecx
80103526:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010352a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010352d:	39 da                	cmp    %ebx,%edx
8010352f:	75 ef                	jne    80103520 <write_head+0x30>
  }
  bwrite(buf);
80103531:	83 ec 0c             	sub    $0xc,%esp
80103534:	56                   	push   %esi
80103535:	e8 46 d2 ff ff       	call   80100780 <bwrite>
  brelse(buf);
8010353a:	89 34 24             	mov    %esi,(%esp)
8010353d:	e8 7e d2 ff ff       	call   801007c0 <brelse>
}
80103542:	83 c4 10             	add    $0x10,%esp
80103545:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103548:	5b                   	pop    %ebx
80103549:	5e                   	pop    %esi
8010354a:	5d                   	pop    %ebp
8010354b:	c3                   	ret    
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103550 <initlog>:
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	53                   	push   %ebx
80103554:	83 ec 2c             	sub    $0x2c,%esp
80103557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010355a:	68 e0 92 10 80       	push   $0x801092e0
8010355f:	68 40 b2 15 80       	push   $0x8015b240
80103564:	e8 87 23 00 00       	call   801058f0 <initlock>
  readsb(dev, &sb);
80103569:	58                   	pop    %eax
8010356a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010356d:	5a                   	pop    %edx
8010356e:	50                   	push   %eax
8010356f:	53                   	push   %ebx
80103570:	e8 9b e8 ff ff       	call   80101e10 <readsb>
  log.size = sb.nlog;
80103575:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103578:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010357b:	59                   	pop    %ecx
  log.dev = dev;
8010357c:	89 1d 84 b2 15 80    	mov    %ebx,0x8015b284
  log.size = sb.nlog;
80103582:	89 15 78 b2 15 80    	mov    %edx,0x8015b278
  log.start = sb.logstart;
80103588:	a3 74 b2 15 80       	mov    %eax,0x8015b274
  struct buf *buf = bread(log.dev, log.start);
8010358d:	5a                   	pop    %edx
8010358e:	50                   	push   %eax
8010358f:	53                   	push   %ebx
80103590:	e8 1b d1 ff ff       	call   801006b0 <bread>
  log.lh.n = lh->n;
80103595:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103598:	83 c4 10             	add    $0x10,%esp
8010359b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010359d:	89 1d 88 b2 15 80    	mov    %ebx,0x8015b288
  for (i = 0; i < log.lh.n; i++) {
801035a3:	7e 1c                	jle    801035c1 <initlog+0x71>
801035a5:	c1 e3 02             	shl    $0x2,%ebx
801035a8:	31 d2                	xor    %edx,%edx
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
801035b0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801035b4:	83 c2 04             	add    $0x4,%edx
801035b7:	89 8a 88 b2 15 80    	mov    %ecx,-0x7fea4d78(%edx)
  for (i = 0; i < log.lh.n; i++) {
801035bd:	39 d3                	cmp    %edx,%ebx
801035bf:	75 ef                	jne    801035b0 <initlog+0x60>
  brelse(buf);
801035c1:	83 ec 0c             	sub    $0xc,%esp
801035c4:	50                   	push   %eax
801035c5:	e8 f6 d1 ff ff       	call   801007c0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801035ca:	e8 81 fe ff ff       	call   80103450 <install_trans>
  log.lh.n = 0;
801035cf:	c7 05 88 b2 15 80 00 	movl   $0x0,0x8015b288
801035d6:	00 00 00 
  write_head(); // clear the log
801035d9:	e8 12 ff ff ff       	call   801034f0 <write_head>
}
801035de:	83 c4 10             	add    $0x10,%esp
801035e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035e4:	c9                   	leave  
801035e5:	c3                   	ret    
801035e6:	8d 76 00             	lea    0x0(%esi),%esi
801035e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801035f6:	68 40 b2 15 80       	push   $0x8015b240
801035fb:	e8 e0 23 00 00       	call   801059e0 <acquire>
80103600:	83 c4 10             	add    $0x10,%esp
80103603:	eb 18                	jmp    8010361d <begin_op+0x2d>
80103605:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103608:	83 ec 08             	sub    $0x8,%esp
8010360b:	68 40 b2 15 80       	push   $0x8015b240
80103610:	68 40 b2 15 80       	push   $0x8015b240
80103615:	e8 76 1e 00 00       	call   80105490 <sleep>
8010361a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010361d:	a1 80 b2 15 80       	mov    0x8015b280,%eax
80103622:	85 c0                	test   %eax,%eax
80103624:	75 e2                	jne    80103608 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103626:	a1 7c b2 15 80       	mov    0x8015b27c,%eax
8010362b:	8b 15 88 b2 15 80    	mov    0x8015b288,%edx
80103631:	83 c0 01             	add    $0x1,%eax
80103634:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103637:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010363a:	83 fa 1e             	cmp    $0x1e,%edx
8010363d:	7f c9                	jg     80103608 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010363f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103642:	a3 7c b2 15 80       	mov    %eax,0x8015b27c
      release(&log.lock);
80103647:	68 40 b2 15 80       	push   $0x8015b240
8010364c:	e8 af 24 00 00       	call   80105b00 <release>
      break;
    }
  }
}
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	c9                   	leave  
80103655:	c3                   	ret    
80103656:	8d 76 00             	lea    0x0(%esi),%esi
80103659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103660 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	57                   	push   %edi
80103664:	56                   	push   %esi
80103665:	53                   	push   %ebx
80103666:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103669:	68 40 b2 15 80       	push   $0x8015b240
8010366e:	e8 6d 23 00 00       	call   801059e0 <acquire>
  log.outstanding -= 1;
80103673:	a1 7c b2 15 80       	mov    0x8015b27c,%eax
  if(log.committing)
80103678:	8b 35 80 b2 15 80    	mov    0x8015b280,%esi
8010367e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103681:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103684:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103686:	89 1d 7c b2 15 80    	mov    %ebx,0x8015b27c
  if(log.committing)
8010368c:	0f 85 1a 01 00 00    	jne    801037ac <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103692:	85 db                	test   %ebx,%ebx
80103694:	0f 85 ee 00 00 00    	jne    80103788 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010369a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010369d:	c7 05 80 b2 15 80 01 	movl   $0x1,0x8015b280
801036a4:	00 00 00 
  release(&log.lock);
801036a7:	68 40 b2 15 80       	push   $0x8015b240
801036ac:	e8 4f 24 00 00       	call   80105b00 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801036b1:	8b 0d 88 b2 15 80    	mov    0x8015b288,%ecx
801036b7:	83 c4 10             	add    $0x10,%esp
801036ba:	85 c9                	test   %ecx,%ecx
801036bc:	0f 8e 85 00 00 00    	jle    80103747 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036c2:	a1 74 b2 15 80       	mov    0x8015b274,%eax
801036c7:	83 ec 08             	sub    $0x8,%esp
801036ca:	01 d8                	add    %ebx,%eax
801036cc:	83 c0 01             	add    $0x1,%eax
801036cf:	50                   	push   %eax
801036d0:	ff 35 84 b2 15 80    	pushl  0x8015b284
801036d6:	e8 d5 cf ff ff       	call   801006b0 <bread>
801036db:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036dd:	58                   	pop    %eax
801036de:	5a                   	pop    %edx
801036df:	ff 34 9d 8c b2 15 80 	pushl  -0x7fea4d74(,%ebx,4)
801036e6:	ff 35 84 b2 15 80    	pushl  0x8015b284
  for (tail = 0; tail < log.lh.n; tail++) {
801036ec:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036ef:	e8 bc cf ff ff       	call   801006b0 <bread>
801036f4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801036f6:	8d 40 5c             	lea    0x5c(%eax),%eax
801036f9:	83 c4 0c             	add    $0xc,%esp
801036fc:	68 00 02 00 00       	push   $0x200
80103701:	50                   	push   %eax
80103702:	8d 46 5c             	lea    0x5c(%esi),%eax
80103705:	50                   	push   %eax
80103706:	e8 05 25 00 00       	call   80105c10 <memmove>
    bwrite(to);  // write the log
8010370b:	89 34 24             	mov    %esi,(%esp)
8010370e:	e8 6d d0 ff ff       	call   80100780 <bwrite>
    brelse(from);
80103713:	89 3c 24             	mov    %edi,(%esp)
80103716:	e8 a5 d0 ff ff       	call   801007c0 <brelse>
    brelse(to);
8010371b:	89 34 24             	mov    %esi,(%esp)
8010371e:	e8 9d d0 ff ff       	call   801007c0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103723:	83 c4 10             	add    $0x10,%esp
80103726:	3b 1d 88 b2 15 80    	cmp    0x8015b288,%ebx
8010372c:	7c 94                	jl     801036c2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010372e:	e8 bd fd ff ff       	call   801034f0 <write_head>
    install_trans(); // Now install writes to home locations
80103733:	e8 18 fd ff ff       	call   80103450 <install_trans>
    log.lh.n = 0;
80103738:	c7 05 88 b2 15 80 00 	movl   $0x0,0x8015b288
8010373f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103742:	e8 a9 fd ff ff       	call   801034f0 <write_head>
    acquire(&log.lock);
80103747:	83 ec 0c             	sub    $0xc,%esp
8010374a:	68 40 b2 15 80       	push   $0x8015b240
8010374f:	e8 8c 22 00 00       	call   801059e0 <acquire>
    wakeup(&log);
80103754:	c7 04 24 40 b2 15 80 	movl   $0x8015b240,(%esp)
    log.committing = 0;
8010375b:	c7 05 80 b2 15 80 00 	movl   $0x0,0x8015b280
80103762:	00 00 00 
    wakeup(&log);
80103765:	e8 d6 1e 00 00       	call   80105640 <wakeup>
    release(&log.lock);
8010376a:	c7 04 24 40 b2 15 80 	movl   $0x8015b240,(%esp)
80103771:	e8 8a 23 00 00       	call   80105b00 <release>
80103776:	83 c4 10             	add    $0x10,%esp
}
80103779:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010377c:	5b                   	pop    %ebx
8010377d:	5e                   	pop    %esi
8010377e:	5f                   	pop    %edi
8010377f:	5d                   	pop    %ebp
80103780:	c3                   	ret    
80103781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103788:	83 ec 0c             	sub    $0xc,%esp
8010378b:	68 40 b2 15 80       	push   $0x8015b240
80103790:	e8 ab 1e 00 00       	call   80105640 <wakeup>
  release(&log.lock);
80103795:	c7 04 24 40 b2 15 80 	movl   $0x8015b240,(%esp)
8010379c:	e8 5f 23 00 00       	call   80105b00 <release>
801037a1:	83 c4 10             	add    $0x10,%esp
}
801037a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a7:	5b                   	pop    %ebx
801037a8:	5e                   	pop    %esi
801037a9:	5f                   	pop    %edi
801037aa:	5d                   	pop    %ebp
801037ab:	c3                   	ret    
    panic("log.committing");
801037ac:	83 ec 0c             	sub    $0xc,%esp
801037af:	68 e4 92 10 80       	push   $0x801092e4
801037b4:	e8 b7 d1 ff ff       	call   80100970 <panic>
801037b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	53                   	push   %ebx
801037c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037c7:	8b 15 88 b2 15 80    	mov    0x8015b288,%edx
{
801037cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037d0:	83 fa 1d             	cmp    $0x1d,%edx
801037d3:	0f 8f 9d 00 00 00    	jg     80103876 <log_write+0xb6>
801037d9:	a1 78 b2 15 80       	mov    0x8015b278,%eax
801037de:	83 e8 01             	sub    $0x1,%eax
801037e1:	39 c2                	cmp    %eax,%edx
801037e3:	0f 8d 8d 00 00 00    	jge    80103876 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801037e9:	a1 7c b2 15 80       	mov    0x8015b27c,%eax
801037ee:	85 c0                	test   %eax,%eax
801037f0:	0f 8e 8d 00 00 00    	jle    80103883 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801037f6:	83 ec 0c             	sub    $0xc,%esp
801037f9:	68 40 b2 15 80       	push   $0x8015b240
801037fe:	e8 dd 21 00 00       	call   801059e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103803:	8b 0d 88 b2 15 80    	mov    0x8015b288,%ecx
80103809:	83 c4 10             	add    $0x10,%esp
8010380c:	83 f9 00             	cmp    $0x0,%ecx
8010380f:	7e 57                	jle    80103868 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103811:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103814:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103816:	3b 15 8c b2 15 80    	cmp    0x8015b28c,%edx
8010381c:	75 0b                	jne    80103829 <log_write+0x69>
8010381e:	eb 38                	jmp    80103858 <log_write+0x98>
80103820:	39 14 85 8c b2 15 80 	cmp    %edx,-0x7fea4d74(,%eax,4)
80103827:	74 2f                	je     80103858 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103829:	83 c0 01             	add    $0x1,%eax
8010382c:	39 c1                	cmp    %eax,%ecx
8010382e:	75 f0                	jne    80103820 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103830:	89 14 85 8c b2 15 80 	mov    %edx,-0x7fea4d74(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103837:	83 c0 01             	add    $0x1,%eax
8010383a:	a3 88 b2 15 80       	mov    %eax,0x8015b288
  b->flags |= B_DIRTY; // prevent eviction
8010383f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103842:	c7 45 08 40 b2 15 80 	movl   $0x8015b240,0x8(%ebp)
}
80103849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010384c:	c9                   	leave  
  release(&log.lock);
8010384d:	e9 ae 22 00 00       	jmp    80105b00 <release>
80103852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103858:	89 14 85 8c b2 15 80 	mov    %edx,-0x7fea4d74(,%eax,4)
8010385f:	eb de                	jmp    8010383f <log_write+0x7f>
80103861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103868:	8b 43 08             	mov    0x8(%ebx),%eax
8010386b:	a3 8c b2 15 80       	mov    %eax,0x8015b28c
  if (i == log.lh.n)
80103870:	75 cd                	jne    8010383f <log_write+0x7f>
80103872:	31 c0                	xor    %eax,%eax
80103874:	eb c1                	jmp    80103837 <log_write+0x77>
    panic("too big a transaction");
80103876:	83 ec 0c             	sub    $0xc,%esp
80103879:	68 f3 92 10 80       	push   $0x801092f3
8010387e:	e8 ed d0 ff ff       	call   80100970 <panic>
    panic("log_write outside of trans");
80103883:	83 ec 0c             	sub    $0xc,%esp
80103886:	68 09 93 10 80       	push   $0x80109309
8010388b:	e8 e0 d0 ff ff       	call   80100970 <panic>

80103890 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
80103894:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103897:	e8 34 16 00 00       	call   80104ed0 <cpuid>
8010389c:	89 c3                	mov    %eax,%ebx
8010389e:	e8 2d 16 00 00       	call   80104ed0 <cpuid>
801038a3:	83 ec 04             	sub    $0x4,%esp
801038a6:	53                   	push   %ebx
801038a7:	50                   	push   %eax
801038a8:	68 24 93 10 80       	push   $0x80109324
801038ad:	e8 8e d3 ff ff       	call   80100c40 <cprintf>
  idtinit();       // load idt register
801038b2:	e8 a9 3b 00 00       	call   80107460 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801038b7:	e8 94 15 00 00       	call   80104e50 <mycpu>
801038bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038be:	b8 01 00 00 00       	mov    $0x1,%eax
801038c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801038ca:	e8 e1 18 00 00       	call   801051b0 <scheduler>
801038cf:	90                   	nop

801038d0 <mpenter>:
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801038d6:	e8 15 4d 00 00       	call   801085f0 <switchkvm>
  seginit();
801038db:	e8 80 4c 00 00       	call   80108560 <seginit>
  lapicinit();
801038e0:	e8 9b f7 ff ff       	call   80103080 <lapicinit>
  mpmain();
801038e5:	e8 a6 ff ff ff       	call   80103890 <mpmain>
801038ea:	66 90                	xchg   %ax,%ax
801038ec:	66 90                	xchg   %ax,%ax
801038ee:	66 90                	xchg   %ax,%ax

801038f0 <main>:
{
801038f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038f4:	83 e4 f0             	and    $0xfffffff0,%esp
801038f7:	ff 71 fc             	pushl  -0x4(%ecx)
801038fa:	55                   	push   %ebp
801038fb:	89 e5                	mov    %esp,%ebp
801038fd:	53                   	push   %ebx
801038fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038ff:	83 ec 08             	sub    $0x8,%esp
80103902:	68 00 00 40 80       	push   $0x80400000
80103907:	68 68 e0 15 80       	push   $0x8015e068
8010390c:	e8 2f f5 ff ff       	call   80102e40 <kinit1>
  kvmalloc();      // kernel page table
80103911:	e8 aa 51 00 00       	call   80108ac0 <kvmalloc>
  mpinit();        // detect other processors
80103916:	e8 85 01 00 00       	call   80103aa0 <mpinit>
  lapicinit();     // interrupt controller
8010391b:	e8 60 f7 ff ff       	call   80103080 <lapicinit>
  seginit();       // segment descriptors
80103920:	e8 3b 4c 00 00       	call   80108560 <seginit>
  picinit();       // disable pic
80103925:	e8 06 10 00 00       	call   80104930 <picinit>
  ioapicinit();    // another interrupt controller
8010392a:	e8 41 f3 ff ff       	call   80102c70 <ioapicinit>
  consoleinit();   // console hardware
8010392f:	e8 6c d6 ff ff       	call   80100fa0 <consoleinit>
  uartinit();      // serial port
80103934:	e8 67 3e 00 00       	call   801077a0 <uartinit>
  pinit();         // process table
80103939:	e8 f2 14 00 00       	call   80104e30 <pinit>
  tvinit();        // trap vectors
8010393e:	e8 9d 3a 00 00       	call   801073e0 <tvinit>
  binit();         // buffer cache
80103943:	e8 d8 cc ff ff       	call   80100620 <binit>
  fileinit();      // file table
80103948:	e8 d3 dd ff ff       	call   80101720 <fileinit>
  ideinit();       // disk 
8010394d:	e8 fe f0 ff ff       	call   80102a50 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103952:	83 c4 0c             	add    $0xc,%esp
80103955:	68 8a 00 00 00       	push   $0x8a
8010395a:	68 cc c4 10 80       	push   $0x8010c4cc
8010395f:	68 00 70 00 80       	push   $0x80007000
80103964:	e8 a7 22 00 00       	call   80105c10 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103969:	69 05 c0 b8 15 80 b0 	imul   $0xb0,0x8015b8c0,%eax
80103970:	00 00 00 
80103973:	83 c4 10             	add    $0x10,%esp
80103976:	05 40 b3 15 80       	add    $0x8015b340,%eax
8010397b:	3d 40 b3 15 80       	cmp    $0x8015b340,%eax
80103980:	76 71                	jbe    801039f3 <main+0x103>
80103982:	bb 40 b3 15 80       	mov    $0x8015b340,%ebx
80103987:	89 f6                	mov    %esi,%esi
80103989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103990:	e8 bb 14 00 00       	call   80104e50 <mycpu>
80103995:	39 d8                	cmp    %ebx,%eax
80103997:	74 41                	je     801039da <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103999:	e8 72 f5 ff ff       	call   80102f10 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010399e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801039a3:	c7 05 f8 6f 00 80 d0 	movl   $0x801038d0,0x80006ff8
801039aa:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801039ad:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801039b4:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801039b7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801039bc:	0f b6 03             	movzbl (%ebx),%eax
801039bf:	83 ec 08             	sub    $0x8,%esp
801039c2:	68 00 70 00 00       	push   $0x7000
801039c7:	50                   	push   %eax
801039c8:	e8 03 f8 ff ff       	call   801031d0 <lapicstartap>
801039cd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801039d6:	85 c0                	test   %eax,%eax
801039d8:	74 f6                	je     801039d0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801039da:	69 05 c0 b8 15 80 b0 	imul   $0xb0,0x8015b8c0,%eax
801039e1:	00 00 00 
801039e4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801039ea:	05 40 b3 15 80       	add    $0x8015b340,%eax
801039ef:	39 c3                	cmp    %eax,%ebx
801039f1:	72 9d                	jb     80103990 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039f3:	83 ec 08             	sub    $0x8,%esp
801039f6:	68 00 00 00 8e       	push   $0x8e000000
801039fb:	68 00 00 40 80       	push   $0x80400000
80103a00:	e8 ab f4 ff ff       	call   80102eb0 <kinit2>
pci_init();
80103a05:	e8 f6 0e 00 00       	call   80104900 <pci_init>
 sockinit();
80103a0a:	e8 f1 32 00 00       	call   80106d00 <sockinit>
  userinit();      // first user process
80103a0f:	e8 0c 15 00 00       	call   80104f20 <userinit>
  mpmain();        // finish this processor's setup
80103a14:	e8 77 fe ff ff       	call   80103890 <mpmain>
80103a19:	66 90                	xchg   %ax,%ax
80103a1b:	66 90                	xchg   %ax,%ax
80103a1d:	66 90                	xchg   %ax,%ax
80103a1f:	90                   	nop

80103a20 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	57                   	push   %edi
80103a24:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a25:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103a2b:	53                   	push   %ebx
  e = addr+len;
80103a2c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103a2f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103a32:	39 de                	cmp    %ebx,%esi
80103a34:	72 10                	jb     80103a46 <mpsearch1+0x26>
80103a36:	eb 50                	jmp    80103a88 <mpsearch1+0x68>
80103a38:	90                   	nop
80103a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a40:	39 fb                	cmp    %edi,%ebx
80103a42:	89 fe                	mov    %edi,%esi
80103a44:	76 42                	jbe    80103a88 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a46:	83 ec 04             	sub    $0x4,%esp
80103a49:	8d 7e 10             	lea    0x10(%esi),%edi
80103a4c:	6a 04                	push   $0x4
80103a4e:	68 38 93 10 80       	push   $0x80109338
80103a53:	56                   	push   %esi
80103a54:	e8 57 21 00 00       	call   80105bb0 <memcmp>
80103a59:	83 c4 10             	add    $0x10,%esp
80103a5c:	85 c0                	test   %eax,%eax
80103a5e:	75 e0                	jne    80103a40 <mpsearch1+0x20>
80103a60:	89 f1                	mov    %esi,%ecx
80103a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103a68:	0f b6 11             	movzbl (%ecx),%edx
80103a6b:	83 c1 01             	add    $0x1,%ecx
80103a6e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103a70:	39 f9                	cmp    %edi,%ecx
80103a72:	75 f4                	jne    80103a68 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a74:	84 c0                	test   %al,%al
80103a76:	75 c8                	jne    80103a40 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a7b:	89 f0                	mov    %esi,%eax
80103a7d:	5b                   	pop    %ebx
80103a7e:	5e                   	pop    %esi
80103a7f:	5f                   	pop    %edi
80103a80:	5d                   	pop    %ebp
80103a81:	c3                   	ret    
80103a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103a8b:	31 f6                	xor    %esi,%esi
}
80103a8d:	89 f0                	mov    %esi,%eax
80103a8f:	5b                   	pop    %ebx
80103a90:	5e                   	pop    %esi
80103a91:	5f                   	pop    %edi
80103a92:	5d                   	pop    %ebp
80103a93:	c3                   	ret    
80103a94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103aa0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	57                   	push   %edi
80103aa4:	56                   	push   %esi
80103aa5:	53                   	push   %ebx
80103aa6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103aa9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103ab0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103ab7:	c1 e0 08             	shl    $0x8,%eax
80103aba:	09 d0                	or     %edx,%eax
80103abc:	c1 e0 04             	shl    $0x4,%eax
80103abf:	85 c0                	test   %eax,%eax
80103ac1:	75 1b                	jne    80103ade <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ac3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103aca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103ad1:	c1 e0 08             	shl    $0x8,%eax
80103ad4:	09 d0                	or     %edx,%eax
80103ad6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103ad9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103ade:	ba 00 04 00 00       	mov    $0x400,%edx
80103ae3:	e8 38 ff ff ff       	call   80103a20 <mpsearch1>
80103ae8:	85 c0                	test   %eax,%eax
80103aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aed:	0f 84 3d 01 00 00    	je     80103c30 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103af6:	8b 58 04             	mov    0x4(%eax),%ebx
80103af9:	85 db                	test   %ebx,%ebx
80103afb:	0f 84 4f 01 00 00    	je     80103c50 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b01:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103b07:	83 ec 04             	sub    $0x4,%esp
80103b0a:	6a 04                	push   $0x4
80103b0c:	68 55 93 10 80       	push   $0x80109355
80103b11:	56                   	push   %esi
80103b12:	e8 99 20 00 00       	call   80105bb0 <memcmp>
80103b17:	83 c4 10             	add    $0x10,%esp
80103b1a:	85 c0                	test   %eax,%eax
80103b1c:	0f 85 2e 01 00 00    	jne    80103c50 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103b22:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103b29:	3c 01                	cmp    $0x1,%al
80103b2b:	0f 95 c2             	setne  %dl
80103b2e:	3c 04                	cmp    $0x4,%al
80103b30:	0f 95 c0             	setne  %al
80103b33:	20 c2                	and    %al,%dl
80103b35:	0f 85 15 01 00 00    	jne    80103c50 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b3b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103b42:	66 85 ff             	test   %di,%di
80103b45:	74 1a                	je     80103b61 <mpinit+0xc1>
80103b47:	89 f0                	mov    %esi,%eax
80103b49:	01 f7                	add    %esi,%edi
  sum = 0;
80103b4b:	31 d2                	xor    %edx,%edx
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103b50:	0f b6 08             	movzbl (%eax),%ecx
80103b53:	83 c0 01             	add    $0x1,%eax
80103b56:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103b58:	39 c7                	cmp    %eax,%edi
80103b5a:	75 f4                	jne    80103b50 <mpinit+0xb0>
80103b5c:	84 d2                	test   %dl,%dl
80103b5e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103b61:	85 f6                	test   %esi,%esi
80103b63:	0f 84 e7 00 00 00    	je     80103c50 <mpinit+0x1b0>
80103b69:	84 d2                	test   %dl,%dl
80103b6b:	0f 85 df 00 00 00    	jne    80103c50 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103b71:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103b77:	a3 3c b2 15 80       	mov    %eax,0x8015b23c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b7c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103b83:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103b89:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b8e:	01 d6                	add    %edx,%esi
80103b90:	39 c6                	cmp    %eax,%esi
80103b92:	76 23                	jbe    80103bb7 <mpinit+0x117>
    switch(*p){
80103b94:	0f b6 10             	movzbl (%eax),%edx
80103b97:	80 fa 04             	cmp    $0x4,%dl
80103b9a:	0f 87 ca 00 00 00    	ja     80103c6a <mpinit+0x1ca>
80103ba0:	ff 24 95 7c 93 10 80 	jmp    *-0x7fef6c84(,%edx,4)
80103ba7:	89 f6                	mov    %esi,%esi
80103ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103bb0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bb3:	39 c6                	cmp    %eax,%esi
80103bb5:	77 dd                	ja     80103b94 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103bb7:	85 db                	test   %ebx,%ebx
80103bb9:	0f 84 9e 00 00 00    	je     80103c5d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103bc2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103bc6:	74 15                	je     80103bdd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bc8:	b8 70 00 00 00       	mov    $0x70,%eax
80103bcd:	ba 22 00 00 00       	mov    $0x22,%edx
80103bd2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103bd3:	ba 23 00 00 00       	mov    $0x23,%edx
80103bd8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103bd9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bdc:	ee                   	out    %al,(%dx)
  }
}
80103bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103be0:	5b                   	pop    %ebx
80103be1:	5e                   	pop    %esi
80103be2:	5f                   	pop    %edi
80103be3:	5d                   	pop    %ebp
80103be4:	c3                   	ret    
80103be5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103be8:	8b 0d c0 b8 15 80    	mov    0x8015b8c0,%ecx
80103bee:	83 f9 07             	cmp    $0x7,%ecx
80103bf1:	7f 19                	jg     80103c0c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103bf3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103bf7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
80103bfd:	83 c1 01             	add    $0x1,%ecx
80103c00:	89 0d c0 b8 15 80    	mov    %ecx,0x8015b8c0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c06:	88 97 40 b3 15 80    	mov    %dl,-0x7fea4cc0(%edi)
      p += sizeof(struct mpproc);
80103c0c:	83 c0 14             	add    $0x14,%eax
      continue;
80103c0f:	e9 7c ff ff ff       	jmp    80103b90 <mpinit+0xf0>
80103c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103c18:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103c1c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103c1f:	88 15 20 b3 15 80    	mov    %dl,0x8015b320
      continue;
80103c25:	e9 66 ff ff ff       	jmp    80103b90 <mpinit+0xf0>
80103c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103c30:	ba 00 00 01 00       	mov    $0x10000,%edx
80103c35:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103c3a:	e8 e1 fd ff ff       	call   80103a20 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c3f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103c41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c44:	0f 85 a9 fe ff ff    	jne    80103af3 <mpinit+0x53>
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103c50:	83 ec 0c             	sub    $0xc,%esp
80103c53:	68 3d 93 10 80       	push   $0x8010933d
80103c58:	e8 13 cd ff ff       	call   80100970 <panic>
    panic("Didn't find a suitable machine");
80103c5d:	83 ec 0c             	sub    $0xc,%esp
80103c60:	68 5c 93 10 80       	push   $0x8010935c
80103c65:	e8 06 cd ff ff       	call   80100970 <panic>
      ismp = 0;
80103c6a:	31 db                	xor    %ebx,%ebx
80103c6c:	e9 26 ff ff ff       	jmp    80103b97 <mpinit+0xf7>
80103c71:	66 90                	xchg   %ax,%ax
80103c73:	66 90                	xchg   %ax,%ax
80103c75:	66 90                	xchg   %ax,%ax
80103c77:	66 90                	xchg   %ax,%ax
80103c79:	66 90                	xchg   %ax,%ax
80103c7b:	66 90                	xchg   %ax,%ax
80103c7d:	66 90                	xchg   %ax,%ax
80103c7f:	90                   	nop

80103c80 <net_tx_eth>:
int 
e1000_transmit(const void *data, size_t len);
// sends an ethernet packet
static void
net_tx_eth(struct mbuf *m, uint16 ethtype)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	89 c3                	mov    %eax,%ebx
  if (m->head < m->buf)
80103c88:	83 c0 0c             	add    $0xc,%eax
{
80103c8b:	83 ec 1c             	sub    $0x1c,%esp
  m->head -= len;
80103c8e:	8b 78 f8             	mov    -0x8(%eax),%edi
80103c91:	8d 77 f2             	lea    -0xe(%edi),%esi
80103c94:	89 70 f8             	mov    %esi,-0x8(%eax)
  if (m->head < m->buf)
80103c97:	39 c6                	cmp    %eax,%esi
80103c99:	72 55                	jb     80103cf0 <net_tx_eth+0x70>
  struct eth *ethhdr;

  ethhdr = mbufpushhdr(m, *ethhdr);
  memmove(ethhdr->shost, local_mac, ETHADDR_LEN);
80103c9b:	8d 47 f8             	lea    -0x8(%edi),%eax
  m->len += len;
80103c9e:	83 43 08 0e          	addl   $0xe,0x8(%ebx)
  memmove(ethhdr->shost, local_mac, ETHADDR_LEN);
80103ca2:	83 ec 04             	sub    $0x4,%esp
80103ca5:	6a 06                	push   $0x6
80103ca7:	68 08 c0 10 80       	push   $0x8010c008
80103cac:	50                   	push   %eax
80103cad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103cb0:	e8 5b 1f 00 00       	call   80105c10 <memmove>
  // In a real networking stack, dhost would be set to the address discovered
  // through ARP. Because we don't support enough of the ARP protocol, set it
  // to broadcast instead.
  memmove(ethhdr->dhost, broadcast_mac, ETHADDR_LEN);
80103cb5:	83 c4 0c             	add    $0xc,%esp
80103cb8:	6a 06                	push   $0x6
80103cba:	68 00 c0 10 80       	push   $0x8010c000
80103cbf:	56                   	push   %esi
80103cc0:	e8 4b 1f 00 00       	call   80105c10 <memmove>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
80103cc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cc8:	66 c1 c2 08          	rol    $0x8,%dx
80103ccc:	66 89 57 fe          	mov    %dx,-0x2(%edi)
  ethhdr->type = htons(ethtype);
  e1000_transmit(m->head,m->len);
80103cd0:	58                   	pop    %eax
80103cd1:	5a                   	pop    %edx
80103cd2:	ff 73 08             	pushl  0x8(%ebx)
80103cd5:	ff 73 04             	pushl  0x4(%ebx)
80103cd8:	e8 23 d8 ff ff       	call   80101500 <e1000_transmit>
  kfree((char *)m);
80103cdd:	89 1c 24             	mov    %ebx,(%esp)
80103ce0:	e8 7b f0 ff ff       	call   80102d60 <kfree>
  mbuffree(m);
  
}
80103ce5:	83 c4 10             	add    $0x10,%esp
80103ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ceb:	5b                   	pop    %ebx
80103cec:	5e                   	pop    %esi
80103ced:	5f                   	pop    %edi
80103cee:	5d                   	pop    %ebp
80103cef:	c3                   	ret    
    panic("mbufpush");
80103cf0:	83 ec 0c             	sub    $0xc,%esp
80103cf3:	68 90 93 10 80       	push   $0x80109390
80103cf8:	e8 73 cc ff ff       	call   80100970 <panic>
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi

80103d00 <in_cksum.constprop.2>:
in_cksum(const unsigned char *addr, int len)
80103d00:	55                   	push   %ebp
  unsigned int sum = 0;
80103d01:	31 d2                	xor    %edx,%edx
in_cksum(const unsigned char *addr, int len)
80103d03:	89 e5                	mov    %esp,%ebp
80103d05:	53                   	push   %ebx
80103d06:	8d 58 14             	lea    0x14(%eax),%ebx
80103d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += *w++;
80103d10:	83 c0 02             	add    $0x2,%eax
80103d13:	0f b7 48 fe          	movzwl -0x2(%eax),%ecx
80103d17:	01 ca                	add    %ecx,%edx
  while (nleft > 1)  {
80103d19:	39 d8                	cmp    %ebx,%eax
80103d1b:	75 f3                	jne    80103d10 <in_cksum.constprop.2+0x10>
  sum = (sum & 0xffff) + (sum >> 16);
80103d1d:	0f b7 c2             	movzwl %dx,%eax
80103d20:	c1 ea 10             	shr    $0x10,%edx
80103d23:	01 c2                	add    %eax,%edx
  sum += (sum >> 16);
80103d25:	89 d0                	mov    %edx,%eax
80103d27:	c1 e8 10             	shr    $0x10,%eax
80103d2a:	01 d0                	add    %edx,%eax
  answer = ~sum; /* truncate to 16 bits */
80103d2c:	f7 d0                	not    %eax
}
80103d2e:	5b                   	pop    %ebx
80103d2f:	5d                   	pop    %ebp
80103d30:	c3                   	ret    
80103d31:	eb 0d                	jmp    80103d40 <mbufpull>
80103d33:	90                   	nop
80103d34:	90                   	nop
80103d35:	90                   	nop
80103d36:	90                   	nop
80103d37:	90                   	nop
80103d38:	90                   	nop
80103d39:	90                   	nop
80103d3a:	90                   	nop
80103d3b:	90                   	nop
80103d3c:	90                   	nop
80103d3d:	90                   	nop
80103d3e:	90                   	nop
80103d3f:	90                   	nop

80103d40 <mbufpull>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	53                   	push   %ebx
80103d44:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  if (m->len < len)
80103d4a:	8b 59 08             	mov    0x8(%ecx),%ebx
  char *tmp = m->head;
80103d4d:	8b 41 04             	mov    0x4(%ecx),%eax
  if (m->len < len)
80103d50:	39 d3                	cmp    %edx,%ebx
80103d52:	72 14                	jb     80103d68 <mbufpull+0x28>
  m->len -= len;
80103d54:	29 d3                	sub    %edx,%ebx
  m->head += len;
80103d56:	01 c2                	add    %eax,%edx
  m->len -= len;
80103d58:	89 59 08             	mov    %ebx,0x8(%ecx)
  m->head += len;
80103d5b:	89 51 04             	mov    %edx,0x4(%ecx)
}
80103d5e:	5b                   	pop    %ebx
80103d5f:	5d                   	pop    %ebp
80103d60:	c3                   	ret    
80103d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103d68:	31 c0                	xor    %eax,%eax
80103d6a:	eb f2                	jmp    80103d5e <mbufpull+0x1e>
80103d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d70 <mbufpush>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	53                   	push   %ebx
80103d74:	83 ec 04             	sub    $0x4,%esp
80103d77:	8b 55 08             	mov    0x8(%ebp),%edx
80103d7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  m->head -= len;
80103d7d:	8b 42 04             	mov    0x4(%edx),%eax
  if (m->head < m->buf)
80103d80:	8d 5a 0c             	lea    0xc(%edx),%ebx
  m->head -= len;
80103d83:	29 c8                	sub    %ecx,%eax
  if (m->head < m->buf)
80103d85:	39 d8                	cmp    %ebx,%eax
  m->head -= len;
80103d87:	89 42 04             	mov    %eax,0x4(%edx)
  if (m->head < m->buf)
80103d8a:	72 08                	jb     80103d94 <mbufpush+0x24>
  m->len += len;
80103d8c:	01 4a 08             	add    %ecx,0x8(%edx)
}
80103d8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d92:	c9                   	leave  
80103d93:	c3                   	ret    
    panic("mbufpush");
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	68 90 93 10 80       	push   $0x80109390
80103d9c:	e8 cf cb ff ff       	call   80100970 <panic>
80103da1:	eb 0d                	jmp    80103db0 <mbufput>
80103da3:	90                   	nop
80103da4:	90                   	nop
80103da5:	90                   	nop
80103da6:	90                   	nop
80103da7:	90                   	nop
80103da8:	90                   	nop
80103da9:	90                   	nop
80103daa:	90                   	nop
80103dab:	90                   	nop
80103dac:	90                   	nop
80103dad:	90                   	nop
80103dae:	90                   	nop
80103daf:	90                   	nop

80103db0 <mbufput>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	83 ec 08             	sub    $0x8,%esp
80103db6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *tmp = m->head + m->len;
80103db9:	8b 51 08             	mov    0x8(%ecx),%edx
80103dbc:	8b 41 04             	mov    0x4(%ecx),%eax
80103dbf:	01 d0                	add    %edx,%eax
  m->len += len;
80103dc1:	03 55 0c             	add    0xc(%ebp),%edx
  if (m->len > MBUF_SIZE)
80103dc4:	81 fa 00 08 00 00    	cmp    $0x800,%edx
  m->len += len;
80103dca:	89 51 08             	mov    %edx,0x8(%ecx)
  if (m->len > MBUF_SIZE)
80103dcd:	77 02                	ja     80103dd1 <mbufput+0x21>
}
80103dcf:	c9                   	leave  
80103dd0:	c3                   	ret    
    panic("mbufput");
80103dd1:	83 ec 0c             	sub    $0xc,%esp
80103dd4:	68 99 93 10 80       	push   $0x80109399
80103dd9:	e8 92 cb ff ff       	call   80100970 <panic>
80103dde:	66 90                	xchg   %ax,%ax

80103de0 <mbuftrim>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	8b 55 08             	mov    0x8(%ebp),%edx
80103de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if (len > m->len)
80103de9:	8b 42 08             	mov    0x8(%edx),%eax
80103dec:	39 c8                	cmp    %ecx,%eax
80103dee:	72 10                	jb     80103e00 <mbuftrim+0x20>
  m->len -= len;
80103df0:	29 c8                	sub    %ecx,%eax
80103df2:	89 42 08             	mov    %eax,0x8(%edx)
  return m->head + m->len;
80103df5:	03 42 04             	add    0x4(%edx),%eax
}
80103df8:	5d                   	pop    %ebp
80103df9:	c3                   	ret    
80103dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return 0;
80103e00:	31 c0                	xor    %eax,%eax
}
80103e02:	5d                   	pop    %ebp
80103e03:	c3                   	ret    
80103e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e10 <mbufalloc>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	56                   	push   %esi
80103e14:	53                   	push   %ebx
80103e15:	8b 75 08             	mov    0x8(%ebp),%esi
  if (headroom > MBUF_SIZE)
80103e18:	81 fe 00 08 00 00    	cmp    $0x800,%esi
80103e1e:	77 40                	ja     80103e60 <mbufalloc+0x50>
  m = (struct mbuf *)kalloc();
80103e20:	e8 eb f0 ff ff       	call   80102f10 <kalloc>
  if (m == 0)
80103e25:	85 c0                	test   %eax,%eax
  m = (struct mbuf *)kalloc();
80103e27:	89 c3                	mov    %eax,%ebx
  if (m == 0)
80103e29:	74 28                	je     80103e53 <mbufalloc+0x43>
  m->next = 0;
80103e2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  m->head = (char *)m->buf + headroom;
80103e31:	8d 40 0c             	lea    0xc(%eax),%eax
  memset(m->buf, 0, sizeof(m->buf));
80103e34:	83 ec 04             	sub    $0x4,%esp
  m->len = 0;
80103e37:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  m->head = (char *)m->buf + headroom;
80103e3e:	01 c6                	add    %eax,%esi
80103e40:	89 73 04             	mov    %esi,0x4(%ebx)
  memset(m->buf, 0, sizeof(m->buf));
80103e43:	68 00 08 00 00       	push   $0x800
80103e48:	6a 00                	push   $0x0
80103e4a:	50                   	push   %eax
80103e4b:	e8 10 1d 00 00       	call   80105b60 <memset>
  return m;
80103e50:	83 c4 10             	add    $0x10,%esp
}
80103e53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e56:	89 d8                	mov    %ebx,%eax
80103e58:	5b                   	pop    %ebx
80103e59:	5e                   	pop    %esi
80103e5a:	5d                   	pop    %ebp
80103e5b:	c3                   	ret    
80103e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e60:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80103e63:	31 db                	xor    %ebx,%ebx
}
80103e65:	89 d8                	mov    %ebx,%eax
80103e67:	5b                   	pop    %ebx
80103e68:	5e                   	pop    %esi
80103e69:	5d                   	pop    %ebp
80103e6a:	c3                   	ret    
80103e6b:	90                   	nop
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e70 <mbuffree>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
}
80103e73:	5d                   	pop    %ebp
  kfree((char *)m);
80103e74:	e9 e7 ee ff ff       	jmp    80102d60 <kfree>
80103e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e80 <mbufq_pushtail>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	8b 45 08             	mov    0x8(%ebp),%eax
80103e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  m->next = 0;
80103e89:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  if (!q->head){
80103e8f:	8b 08                	mov    (%eax),%ecx
80103e91:	85 c9                	test   %ecx,%ecx
80103e93:	74 0b                	je     80103ea0 <mbufq_pushtail+0x20>
  q->tail->next = m;
80103e95:	8b 48 04             	mov    0x4(%eax),%ecx
80103e98:	89 11                	mov    %edx,(%ecx)
  q->tail = m;
80103e9a:	89 50 04             	mov    %edx,0x4(%eax)
}
80103e9d:	5d                   	pop    %ebp
80103e9e:	c3                   	ret    
80103e9f:	90                   	nop
    q->head = q->tail = m;
80103ea0:	89 50 04             	mov    %edx,0x4(%eax)
80103ea3:	89 10                	mov    %edx,(%eax)
}
80103ea5:	5d                   	pop    %ebp
80103ea6:	c3                   	ret    
80103ea7:	89 f6                	mov    %esi,%esi
80103ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103eb0 <mbufq_pushhead>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  struct mbuf *head = q->head;
80103eb9:	8b 08                	mov    (%eax),%ecx
    q->tail = q->head = m;
80103ebb:	89 10                	mov    %edx,(%eax)
  if (!head)
80103ebd:	85 c9                	test   %ecx,%ecx
80103ebf:	74 07                	je     80103ec8 <mbufq_pushhead+0x18>
     m->next = head;
80103ec1:	89 0a                	mov    %ecx,(%edx)
}
80103ec3:	5d                   	pop    %ebp
80103ec4:	c3                   	ret    
80103ec5:	8d 76 00             	lea    0x0(%esi),%esi
    q->tail = q->head = m;
80103ec8:	89 50 04             	mov    %edx,0x4(%eax)
}
80103ecb:	5d                   	pop    %ebp
80103ecc:	c3                   	ret    
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi

80103ed0 <mbufq_pophead>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  struct mbuf *head = q->head;
80103ed6:	8b 02                	mov    (%edx),%eax
  if (!head)
80103ed8:	85 c0                	test   %eax,%eax
80103eda:	74 04                	je     80103ee0 <mbufq_pophead+0x10>
  q->head = head->next;
80103edc:	8b 08                	mov    (%eax),%ecx
80103ede:	89 0a                	mov    %ecx,(%edx)
}
80103ee0:	5d                   	pop    %ebp
80103ee1:	c3                   	ret    
80103ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <mbufq_empty>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
  return q->head == 0;
80103ef3:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103ef6:	5d                   	pop    %ebp
  return q->head == 0;
80103ef7:	8b 00                	mov    (%eax),%eax
80103ef9:	85 c0                	test   %eax,%eax
80103efb:	0f 94 c0             	sete   %al
80103efe:	0f b6 c0             	movzbl %al,%eax
}
80103f01:	c3                   	ret    
80103f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f10 <mbufq_init>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
  q->head = 0;
80103f13:	8b 45 08             	mov    0x8(%ebp),%eax
80103f16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
80103f1c:	5d                   	pop    %ebp
80103f1d:	c3                   	ret    
80103f1e:	66 90                	xchg   %ax,%ax

80103f20 <net_tx_udp>:

// sends a UDP packet
void
net_tx_udp(struct mbuf *m, uint32 dip,
           uint16 sport, uint16 dport)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 1c             	sub    $0x1c,%esp
80103f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f2f:	8b 55 10             	mov    0x10(%ebp),%edx
80103f32:	8b 7d 14             	mov    0x14(%ebp),%edi
80103f35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  m->head -= len;
80103f38:	8b 43 04             	mov    0x4(%ebx),%eax
  if (m->head < m->buf)
80103f3b:	8d 73 0c             	lea    0xc(%ebx),%esi
  m->head -= len;
80103f3e:	8d 48 f8             	lea    -0x8(%eax),%ecx
  if (m->head < m->buf)
80103f41:	39 f1                	cmp    %esi,%ecx
  m->head -= len;
80103f43:	89 4b 04             	mov    %ecx,0x4(%ebx)
  if (m->head < m->buf)
80103f46:	0f 82 94 00 00 00    	jb     80103fe0 <net_tx_udp+0xc0>
80103f4c:	66 c1 c2 08          	rol    $0x8,%dx
  m->len += len;
80103f50:	83 43 08 08          	addl   $0x8,0x8(%ebx)
80103f54:	66 89 50 f8          	mov    %dx,-0x8(%eax)
80103f58:	89 fa                	mov    %edi,%edx
80103f5a:	66 c1 c2 08          	rol    $0x8,%dx
80103f5e:	66 89 50 fa          	mov    %dx,-0x6(%eax)
80103f62:	0f b7 53 08          	movzwl 0x8(%ebx),%edx
80103f66:	66 c1 c2 08          	rol    $0x8,%dx
80103f6a:	66 89 50 fc          	mov    %dx,-0x4(%eax)
  // put the UDP header
  udphdr = mbufpushhdr(m, *udphdr);
  udphdr->sport = htons(sport);
  udphdr->dport = htons(dport);
  udphdr->ulen = htons(m->len);
  udphdr->sum = 0; // zero means no checksum is provided
80103f6e:	31 d2                	xor    %edx,%edx
80103f70:	66 89 50 fe          	mov    %dx,-0x2(%eax)
  m->head -= len;
80103f74:	8b 7b 04             	mov    0x4(%ebx),%edi
80103f77:	8d 4f ec             	lea    -0x14(%edi),%ecx
  if (m->head < m->buf)
80103f7a:	39 ce                	cmp    %ecx,%esi
  m->head -= len;
80103f7c:	89 4b 04             	mov    %ecx,0x4(%ebx)
  if (m->head < m->buf)
80103f7f:	77 5f                	ja     80103fe0 <net_tx_udp+0xc0>
  m->len += len;
80103f81:	83 43 08 14          	addl   $0x14,0x8(%ebx)
  memset(iphdr, 0, sizeof(*iphdr));
80103f85:	83 ec 04             	sub    $0x4,%esp
80103f88:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103f8b:	6a 14                	push   $0x14
80103f8d:	6a 00                	push   $0x0
80103f8f:	51                   	push   %ecx
80103f90:	e8 cb 1b 00 00       	call   80105b60 <memset>
80103f95:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  iphdr->ip_vhl = (4 << 4) | (20 >> 2);
80103f98:	c6 47 ec 45          	movb   $0x45,-0x14(%edi)
  iphdr->ip_p = proto;
80103f9c:	c6 47 f5 11          	movb   $0x11,-0xb(%edi)
  iphdr->ip_src = htonl(local_ip);
80103fa0:	c7 47 f8 0a 00 02 0f 	movl   $0xf02000a,-0x8(%edi)
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
80103fa7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103faa:	0f ce                	bswap  %esi
  iphdr->ip_dst = htonl(dip);
80103fac:	89 77 fc             	mov    %esi,-0x4(%edi)
80103faf:	0f b7 43 08          	movzwl 0x8(%ebx),%eax
  iphdr->ip_ttl = 100;
80103fb3:	c6 47 f4 64          	movb   $0x64,-0xc(%edi)
80103fb7:	66 c1 c0 08          	rol    $0x8,%ax
80103fbb:	66 89 47 ee          	mov    %ax,-0x12(%edi)
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
80103fbf:	89 c8                	mov    %ecx,%eax
80103fc1:	e8 3a fd ff ff       	call   80103d00 <in_cksum.constprop.2>
  net_tx_eth(m, ETHTYPE_IP);
80103fc6:	83 c4 10             	add    $0x10,%esp
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
80103fc9:	66 89 47 f6          	mov    %ax,-0xa(%edi)

  // now on to the IP layer
  net_tx_ip(m, IPPROTO_UDP, dip);
}
80103fcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  net_tx_eth(m, ETHTYPE_IP);
80103fd0:	89 d8                	mov    %ebx,%eax
80103fd2:	ba 00 08 00 00       	mov    $0x800,%edx
}
80103fd7:	5b                   	pop    %ebx
80103fd8:	5e                   	pop    %esi
80103fd9:	5f                   	pop    %edi
80103fda:	5d                   	pop    %ebp
  net_tx_eth(m, ETHTYPE_IP);
80103fdb:	e9 a0 fc ff ff       	jmp    80103c80 <net_tx_eth>
    panic("mbufpush");
80103fe0:	83 ec 0c             	sub    $0xc,%esp
80103fe3:	68 90 93 10 80       	push   $0x80109390
80103fe8:	e8 83 c9 ff ff       	call   80100970 <panic>
80103fed:	8d 76 00             	lea    0x0(%esi),%esi

80103ff0 <net_rx>:
}

// called by e1000 driver's interrupt handler to deliver a packet to the
// networking stack
void net_rx(struct mbuf *m)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
80103ff4:	56                   	push   %esi
80103ff5:	53                   	push   %ebx
80103ff6:	83 ec 2c             	sub    $0x2c,%esp
80103ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (m->len < len)
80103ffc:	8b 43 08             	mov    0x8(%ebx),%eax
80103fff:	83 f8 0d             	cmp    $0xd,%eax
80104002:	76 5c                	jbe    80104060 <net_rx+0x70>
  char *tmp = m->head;
80104004:	8b 53 04             	mov    0x4(%ebx),%edx
  m->len -= len;
80104007:	83 e8 0e             	sub    $0xe,%eax
8010400a:	89 43 08             	mov    %eax,0x8(%ebx)
  m->head += len;
8010400d:	8d 42 0e             	lea    0xe(%edx),%eax
  struct eth *ethhdr;
  uint16 type;

  ethhdr = mbufpullhdr(m, *ethhdr);
  if (!ethhdr) {
80104010:	85 d2                	test   %edx,%edx
  m->head += len;
80104012:	89 43 04             	mov    %eax,0x4(%ebx)
  if (!ethhdr) {
80104015:	74 49                	je     80104060 <net_rx+0x70>
80104017:	0f b7 72 0c          	movzwl 0xc(%edx),%esi
    mbuffree(m);
    return;
  }

  type = ntohs(ethhdr->type);
  cprintf("type = %x\n",type);
8010401b:	83 ec 08             	sub    $0x8,%esp
8010401e:	66 c1 c6 08          	rol    $0x8,%si
80104022:	0f b7 c6             	movzwl %si,%eax
80104025:	50                   	push   %eax
80104026:	68 b1 93 10 80       	push   $0x801093b1
8010402b:	e8 10 cc ff ff       	call   80100c40 <cprintf>
  if (type == ETHTYPE_IP)
80104030:	83 c4 10             	add    $0x10,%esp
80104033:	66 81 fe 00 08       	cmp    $0x800,%si
80104038:	0f 84 72 01 00 00    	je     801041b0 <net_rx+0x1c0>
    net_rx_ip(m);
  else if (type == ETHTYPE_ARP)
8010403e:	66 81 fe 06 08       	cmp    $0x806,%si
80104043:	74 3b                	je     80104080 <net_rx+0x90>
  kfree((char *)m);
80104045:	83 ec 0c             	sub    $0xc,%esp
80104048:	53                   	push   %ebx
80104049:	e8 12 ed ff ff       	call   80102d60 <kfree>
8010404e:	83 c4 10             	add    $0x10,%esp
    net_rx_arp(m);
  else
    mbuffree(m);
}
80104051:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104054:	5b                   	pop    %ebx
80104055:	5e                   	pop    %esi
80104056:	5f                   	pop    %edi
80104057:	5d                   	pop    %ebp
80104058:	c3                   	ret    
80104059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	  cprintf("ethhdr is null\n");
80104060:	83 ec 0c             	sub    $0xc,%esp
80104063:	68 a1 93 10 80       	push   $0x801093a1
80104068:	e8 d3 cb ff ff       	call   80100c40 <cprintf>
  kfree((char *)m);
8010406d:	89 1c 24             	mov    %ebx,(%esp)
80104070:	e8 eb ec ff ff       	call   80102d60 <kfree>
80104075:	83 c4 10             	add    $0x10,%esp
}
80104078:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010407b:	5b                   	pop    %ebx
8010407c:	5e                   	pop    %esi
8010407d:	5f                   	pop    %edi
8010407e:	5d                   	pop    %ebp
8010407f:	c3                   	ret    
  if (m->len < len)
80104080:	8b 43 08             	mov    0x8(%ebx),%eax
80104083:	83 f8 1b             	cmp    $0x1b,%eax
80104086:	76 bd                	jbe    80104045 <net_rx+0x55>
  char *tmp = m->head;
80104088:	8b 73 04             	mov    0x4(%ebx),%esi
  m->len -= len;
8010408b:	83 e8 1c             	sub    $0x1c,%eax
8010408e:	89 43 08             	mov    %eax,0x8(%ebx)
  m->head += len;
80104091:	8d 46 1c             	lea    0x1c(%esi),%eax
  if (!arphdr)
80104094:	85 f6                	test   %esi,%esi
  m->head += len;
80104096:	89 43 04             	mov    %eax,0x4(%ebx)
  if (!arphdr)
80104099:	74 aa                	je     80104045 <net_rx+0x55>
cprintf("arp1\n");
8010409b:	83 ec 0c             	sub    $0xc,%esp
8010409e:	68 09 94 10 80       	push   $0x80109409
801040a3:	e8 98 cb ff ff       	call   80100c40 <cprintf>
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
801040a8:	83 c4 10             	add    $0x10,%esp
801040ab:	66 81 3e 00 01       	cmpw   $0x100,(%esi)
801040b0:	75 93                	jne    80104045 <net_rx+0x55>
801040b2:	66 83 7e 02 08       	cmpw   $0x8,0x2(%esi)
801040b7:	75 8c                	jne    80104045 <net_rx+0x55>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
801040b9:	80 7e 04 06          	cmpb   $0x6,0x4(%esi)
801040bd:	75 86                	jne    80104045 <net_rx+0x55>
      arphdr->hln != ETHADDR_LEN ||
801040bf:	80 7e 05 04          	cmpb   $0x4,0x5(%esi)
801040c3:	75 80                	jne    80104045 <net_rx+0x55>
  cprintf("arp2\n");
801040c5:	83 ec 0c             	sub    $0xc,%esp
801040c8:	68 0f 94 10 80       	push   $0x8010940f
801040cd:	e8 6e cb ff ff       	call   80100c40 <cprintf>
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
801040d2:	83 c4 10             	add    $0x10,%esp
801040d5:	66 81 7e 06 00 01    	cmpw   $0x100,0x6(%esi)
801040db:	8b 46 18             	mov    0x18(%esi),%eax
801040de:	0f c8                	bswap  %eax
801040e0:	0f 85 5f ff ff ff    	jne    80104045 <net_rx+0x55>
801040e6:	3d 0f 02 00 0a       	cmp    $0xa00020f,%eax
801040eb:	0f 85 54 ff ff ff    	jne    80104045 <net_rx+0x55>
  cprintf("rx_arp2 - send reply\n");
801040f1:	83 ec 0c             	sub    $0xc,%esp
  memmove(smac, arphdr->sha, ETHADDR_LEN); // sender's ethernet address
801040f4:	8d 7d e2             	lea    -0x1e(%ebp),%edi
  cprintf("rx_arp2 - send reply\n");
801040f7:	68 15 94 10 80       	push   $0x80109415
801040fc:	e8 3f cb ff ff       	call   80100c40 <cprintf>
  memmove(smac, arphdr->sha, ETHADDR_LEN); // sender's ethernet address
80104101:	8d 46 08             	lea    0x8(%esi),%eax
80104104:	83 c4 0c             	add    $0xc,%esp
80104107:	6a 06                	push   $0x6
80104109:	50                   	push   %eax
8010410a:	57                   	push   %edi
8010410b:	e8 00 1b 00 00       	call   80105c10 <memmove>
80104110:	8b 46 0e             	mov    0xe(%esi),%eax
  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
80104113:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
8010411a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010411d:	e8 ee fc ff ff       	call   80103e10 <mbufalloc>
  if (!m)
80104122:	83 c4 10             	add    $0x10,%esp
80104125:	85 c0                	test   %eax,%eax
  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
80104127:	89 c1                	mov    %eax,%ecx
  if (!m)
80104129:	74 68                	je     80104193 <net_rx+0x1a3>
  char *tmp = m->head + m->len;
8010412b:	8b 40 08             	mov    0x8(%eax),%eax
8010412e:	8b 71 04             	mov    0x4(%ecx),%esi
80104131:	01 c6                	add    %eax,%esi
  m->len += len;
80104133:	83 c0 1c             	add    $0x1c,%eax
  if (m->len > MBUF_SIZE)
80104136:	3d 00 08 00 00       	cmp    $0x800,%eax
  m->len += len;
8010413b:	89 41 08             	mov    %eax,0x8(%ecx)
  if (m->len > MBUF_SIZE)
8010413e:	0f 87 95 01 00 00    	ja     801042d9 <net_rx+0x2e9>
  memmove(arphdr->sha, local_mac, ETHADDR_LEN);
80104144:	8d 46 08             	lea    0x8(%esi),%eax
  arphdr->hrd = htons(ARP_HRD_ETHER);
80104147:	c7 06 00 01 08 00    	movl   $0x80100,(%esi)
  arphdr->pro = htons(ETHTYPE_IP);
8010414d:	c7 46 04 06 04 00 02 	movl   $0x2000406,0x4(%esi)
  memmove(arphdr->sha, local_mac, ETHADDR_LEN);
80104154:	52                   	push   %edx
80104155:	6a 06                	push   $0x6
80104157:	68 08 c0 10 80       	push   $0x8010c008
8010415c:	50                   	push   %eax
8010415d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104160:	e8 ab 1a 00 00       	call   80105c10 <memmove>
  memmove(arphdr->tha, dmac, ETHADDR_LEN);
80104165:	8d 46 12             	lea    0x12(%esi),%eax
80104168:	83 c4 0c             	add    $0xc,%esp
  arphdr->sip = htonl(local_ip);
8010416b:	c7 46 0e 0a 00 02 0f 	movl   $0xf02000a,0xe(%esi)
  memmove(arphdr->tha, dmac, ETHADDR_LEN);
80104172:	6a 06                	push   $0x6
80104174:	57                   	push   %edi
80104175:	50                   	push   %eax
80104176:	e8 95 1a 00 00       	call   80105c10 <memmove>
  arphdr->tip = htonl(dip);
8010417b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  net_tx_eth(m, ETHTYPE_ARP);
8010417e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80104181:	ba 06 08 00 00       	mov    $0x806,%edx
  arphdr->tip = htonl(dip);
80104186:	89 46 18             	mov    %eax,0x18(%esi)
  net_tx_eth(m, ETHTYPE_ARP);
80104189:	89 c8                	mov    %ecx,%eax
8010418b:	e8 f0 fa ff ff       	call   80103c80 <net_tx_eth>
80104190:	83 c4 10             	add    $0x10,%esp
  cprintf("rx_arp2 free mbuf %p\n",m);
80104193:	50                   	push   %eax
80104194:	50                   	push   %eax
80104195:	53                   	push   %ebx
80104196:	68 2b 94 10 80       	push   $0x8010942b
8010419b:	e8 a0 ca ff ff       	call   80100c40 <cprintf>
801041a0:	83 c4 10             	add    $0x10,%esp
801041a3:	e9 9d fe ff ff       	jmp    80104045 <net_rx+0x55>
801041a8:	90                   	nop
801041a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cprintf("call net_rx_ip\n");
801041b0:	83 ec 0c             	sub    $0xc,%esp
801041b3:	68 bc 93 10 80       	push   $0x801093bc
801041b8:	e8 83 ca ff ff       	call   80100c40 <cprintf>
  if (m->len < len)
801041bd:	8b 43 08             	mov    0x8(%ebx),%eax
801041c0:	83 c4 10             	add    $0x10,%esp
801041c3:	83 f8 13             	cmp    $0x13,%eax
801041c6:	0f 86 79 fe ff ff    	jbe    80104045 <net_rx+0x55>
  char *tmp = m->head;
801041cc:	8b 73 04             	mov    0x4(%ebx),%esi
  m->len -= len;
801041cf:	83 e8 14             	sub    $0x14,%eax
801041d2:	89 43 08             	mov    %eax,0x8(%ebx)
  m->head += len;
801041d5:	8d 46 14             	lea    0x14(%esi),%eax
  if (!iphdr)
801041d8:	85 f6                	test   %esi,%esi
  m->head += len;
801041da:	89 43 04             	mov    %eax,0x4(%ebx)
  if (!iphdr)
801041dd:	0f 84 62 fe ff ff    	je     80104045 <net_rx+0x55>
  cprintf("call net_rx_ip %d\n",iphdr->ip_len);
801041e3:	0f b7 46 02          	movzwl 0x2(%esi),%eax
801041e7:	83 ec 08             	sub    $0x8,%esp
801041ea:	50                   	push   %eax
801041eb:	68 cc 93 10 80       	push   $0x801093cc
801041f0:	e8 4b ca ff ff       	call   80100c40 <cprintf>
  if (iphdr->ip_vhl != ((4 << 4) | (20 >> 2)))
801041f5:	83 c4 10             	add    $0x10,%esp
801041f8:	80 3e 45             	cmpb   $0x45,(%esi)
801041fb:	0f 85 44 fe ff ff    	jne    80104045 <net_rx+0x55>
  if (in_cksum((unsigned char *)iphdr, sizeof(*iphdr)))
80104201:	89 f0                	mov    %esi,%eax
80104203:	e8 f8 fa ff ff       	call   80103d00 <in_cksum.constprop.2>
80104208:	66 85 c0             	test   %ax,%ax
8010420b:	0f 85 34 fe ff ff    	jne    80104045 <net_rx+0x55>
  if (htons(iphdr->ip_off) != 0)
80104211:	66 83 7e 06 00       	cmpw   $0x0,0x6(%esi)
80104216:	0f 85 29 fe ff ff    	jne    80104045 <net_rx+0x55>
  if (htonl(iphdr->ip_dst) != local_ip)
8010421c:	81 7e 10 0a 00 02 0f 	cmpl   $0xf02000a,0x10(%esi)
80104223:	0f 85 1c fe ff ff    	jne    80104045 <net_rx+0x55>
  if (iphdr->ip_p != IPPROTO_UDP)
80104229:	80 7e 09 11          	cmpb   $0x11,0x9(%esi)
8010422d:	0f 85 12 fe ff ff    	jne    80104045 <net_rx+0x55>
80104233:	0f b7 7e 02          	movzwl 0x2(%esi),%edi
  cprintf("call net_rx_udp len %d\n",len);
80104237:	51                   	push   %ecx
80104238:	51                   	push   %ecx
80104239:	66 c1 c7 08          	rol    $0x8,%di
  len = ntohs(iphdr->ip_len) - sizeof(*iphdr);
8010423d:	8d 47 ec             	lea    -0x14(%edi),%eax
  cprintf("call net_rx_udp len %d\n",len);
80104240:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
80104244:	0f b7 c0             	movzwl %ax,%eax
80104247:	50                   	push   %eax
80104248:	68 df 93 10 80       	push   $0x801093df
8010424d:	e8 ee c9 ff ff       	call   80100c40 <cprintf>
  if (m->len < len)
80104252:	8b 53 08             	mov    0x8(%ebx),%edx
80104255:	83 c4 10             	add    $0x10,%esp
  char *tmp = m->head;
80104258:	8b 43 04             	mov    0x4(%ebx),%eax
  if (m->len < len)
8010425b:	83 fa 07             	cmp    $0x7,%edx
8010425e:	0f 86 e1 fd ff ff    	jbe    80104045 <net_rx+0x55>
  m->head += len;
80104264:	8d 48 08             	lea    0x8(%eax),%ecx
  m->len -= len;
80104267:	83 ea 08             	sub    $0x8,%edx
  if (!udphdr)
8010426a:	85 c0                	test   %eax,%eax
  m->len -= len;
8010426c:	89 53 08             	mov    %edx,0x8(%ebx)
  m->head += len;
8010426f:	89 4b 04             	mov    %ecx,0x4(%ebx)
  if (!udphdr)
80104272:	0f 84 cd fd ff ff    	je     80104045 <net_rx+0x55>
80104278:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
8010427c:	66 c1 c1 08          	rol    $0x8,%cx
  if (ntohs(udphdr->ulen) != len)
80104280:	66 39 4d d4          	cmp    %cx,-0x2c(%ebp)
80104284:	0f 85 bb fd ff ff    	jne    80104045 <net_rx+0x55>
  len -= sizeof(*udphdr);
8010428a:	8d 4f e4             	lea    -0x1c(%edi),%ecx
  if (len > m->len)
8010428d:	0f b7 c9             	movzwl %cx,%ecx
80104290:	39 ca                	cmp    %ecx,%edx
80104292:	0f 82 ad fd ff ff    	jb     80104045 <net_rx+0x55>
  m->len -= len;
80104298:	89 4b 08             	mov    %ecx,0x8(%ebx)
8010429b:	8b 56 0c             	mov    0xc(%esi),%edx
  cprintf("call sockrecvudp\n");
8010429e:	83 ec 0c             	sub    $0xc,%esp
801042a1:	0f b7 30             	movzwl (%eax),%esi
801042a4:	0f b7 78 02          	movzwl 0x2(%eax),%edi
801042a8:	68 f7 93 10 80       	push   $0x801093f7
801042ad:	0f ca                	bswap  %edx
801042af:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801042b2:	e8 89 c9 ff ff       	call   80100c40 <cprintf>
  sockrecvudp(m, sip, dport, sport);
801042b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801042ba:	66 c1 c6 08          	rol    $0x8,%si
801042be:	66 c1 c7 08          	rol    $0x8,%di
801042c2:	0f b7 f6             	movzwl %si,%esi
801042c5:	0f b7 ff             	movzwl %di,%edi
801042c8:	56                   	push   %esi
801042c9:	57                   	push   %edi
801042ca:	52                   	push   %edx
801042cb:	53                   	push   %ebx
801042cc:	e8 4f 2e 00 00       	call   80107120 <sockrecvudp>
801042d1:	83 c4 20             	add    $0x20,%esp
801042d4:	e9 9f fd ff ff       	jmp    80104078 <net_rx+0x88>
    panic("mbufput");
801042d9:	83 ec 0c             	sub    $0xc,%esp
801042dc:	68 99 93 10 80       	push   $0x80109399
801042e1:	e8 8a c6 ff ff       	call   80100970 <panic>
801042e6:	66 90                	xchg   %ax,%ax
801042e8:	66 90                	xchg   %ax,%ax
801042ea:	66 90                	xchg   %ax,%ax
801042ec:	66 90                	xchg   %ax,%ax
801042ee:	66 90                	xchg   %ax,%ax

801042f0 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
801042f6:	83 ec 0c             	sub    $0xc,%esp
801042f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801042fc:	8b 7d 08             	mov    0x8(%ebp),%edi
801042ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
80104302:	8b 43 08             	mov    0x8(%ebx),%eax
80104305:	85 c0                	test   %eax,%eax
80104307:	75 11                	jne    8010431a <pci_attach_match+0x2a>
80104309:	eb 4d                	jmp    80104358 <pci_attach_match+0x68>
8010430b:	90                   	nop
8010430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104310:	83 c3 0c             	add    $0xc,%ebx
80104313:	8b 43 08             	mov    0x8(%ebx),%eax
80104316:	85 c0                	test   %eax,%eax
80104318:	74 3e                	je     80104358 <pci_attach_match+0x68>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
8010431a:	39 3b                	cmp    %edi,(%ebx)
8010431c:	75 f2                	jne    80104310 <pci_attach_match+0x20>
8010431e:	39 73 04             	cmp    %esi,0x4(%ebx)
80104321:	75 ed                	jne    80104310 <pci_attach_match+0x20>
			int r = list[i].attachfn(pcif);
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	ff 75 14             	pushl  0x14(%ebp)
80104329:	ff d0                	call   *%eax
            if (r > 0)
8010432b:	83 c4 10             	add    $0x10,%esp
8010432e:	83 f8 00             	cmp    $0x0,%eax
80104331:	7f 27                	jg     8010435a <pci_attach_match+0x6a>
				return r;
			if (r < 0)
80104333:	74 db                	je     80104310 <pci_attach_match+0x20>
				cprintf("pci_attach_match: attaching "
80104335:	83 ec 0c             	sub    $0xc,%esp
80104338:	83 c3 0c             	add    $0xc,%ebx
8010433b:	50                   	push   %eax
8010433c:	ff 73 fc             	pushl  -0x4(%ebx)
8010433f:	56                   	push   %esi
80104340:	57                   	push   %edi
80104341:	68 44 94 10 80       	push   $0x80109444
80104346:	e8 f5 c8 ff ff       	call   80100c40 <cprintf>
	for (i = 0; list[i].attachfn; i++) {
8010434b:	8b 43 08             	mov    0x8(%ebx),%eax
				cprintf("pci_attach_match: attaching "
8010434e:	83 c4 20             	add    $0x20,%esp
	for (i = 0; list[i].attachfn; i++) {
80104351:	85 c0                	test   %eax,%eax
80104353:	75 c5                	jne    8010431a <pci_attach_match+0x2a>
80104355:	8d 76 00             	lea    0x0(%esi),%esi
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
80104358:	31 c0                	xor    %eax,%eax
}
8010435a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010435d:	5b                   	pop    %ebx
8010435e:	5e                   	pop    %esi
8010435f:	5f                   	pop    %edi
80104360:	5d                   	pop    %ebp
80104361:	c3                   	ret    
80104362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104370 <pci_conf1_set_addr>:
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	53                   	push   %ebx
80104374:	83 ec 04             	sub    $0x4,%esp
	assert(bus < 256);
80104377:	3d ff 00 00 00       	cmp    $0xff,%eax
{
8010437c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
8010437f:	77 32                	ja     801043b3 <pci_conf1_set_addr+0x43>
	assert(dev < 32);
80104381:	83 fa 1f             	cmp    $0x1f,%edx
80104384:	77 2d                	ja     801043b3 <pci_conf1_set_addr+0x43>
	assert(func < 8);
80104386:	83 f9 07             	cmp    $0x7,%ecx
80104389:	77 28                	ja     801043b3 <pci_conf1_set_addr+0x43>
	assert(offset < 256);
8010438b:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
80104391:	77 20                	ja     801043b3 <pci_conf1_set_addr+0x43>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
80104393:	c1 e1 08             	shl    $0x8,%ecx
	uint32_t v = (1 << 31) |		// config-space
80104396:	81 cb 00 00 00 80    	or     $0x80000000,%ebx
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
8010439c:	c1 e2 0b             	shl    $0xb,%edx
	uint32_t v = (1 << 31) |		// config-space
8010439f:	09 d9                	or     %ebx,%ecx
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
801043a1:	c1 e0 10             	shl    $0x10,%eax
	uint32_t v = (1 << 31) |		// config-space
801043a4:	09 d1                	or     %edx,%ecx
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
801043a6:	ba f8 0c 00 00       	mov    $0xcf8,%edx
801043ab:	09 c8                	or     %ecx,%eax
801043ad:	ef                   	out    %eax,(%dx)
}
801043ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b1:	c9                   	leave  
801043b2:	c3                   	ret    
	assert(bus < 256);
801043b3:	83 ec 0c             	sub    $0xc,%esp
801043b6:	68 a9 95 10 80       	push   $0x801095a9
801043bb:	e8 b0 c5 ff ff       	call   80100970 <panic>

801043c0 <pci_attach>:

//static 
int
pci_attach(struct pci_func *f)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 04             	sub    $0x4,%esp
801043c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
801043ca:	8b 43 10             	mov    0x10(%ebx),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
801043cd:	53                   	push   %ebx
801043ce:	68 28 c0 10 80       	push   $0x8010c028
				 PCI_SUBCLASS(f->dev_class),
801043d3:	89 c2                	mov    %eax,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
801043d5:	c1 e8 18             	shr    $0x18,%eax
				 PCI_SUBCLASS(f->dev_class),
801043d8:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
801043db:	0f b6 d2             	movzbl %dl,%edx
801043de:	52                   	push   %edx
801043df:	50                   	push   %eax
801043e0:	e8 0b ff ff ff       	call   801042f0 <pci_attach_match>
				 &pci_attach_class[0], f) ||
801043e5:	83 c4 10             	add    $0x10,%esp
801043e8:	85 c0                	test   %eax,%eax
801043ea:	ba 01 00 00 00       	mov    $0x1,%edx
801043ef:	75 22                	jne    80104413 <pci_attach+0x53>
		pci_attach_match(PCI_VENDOR(f->dev_id),
				 PCI_PRODUCT(f->dev_id),
801043f1:	8b 43 0c             	mov    0xc(%ebx),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
801043f4:	53                   	push   %ebx
801043f5:	68 10 c0 10 80       	push   $0x8010c010
801043fa:	89 c2                	mov    %eax,%edx
801043fc:	0f b7 c0             	movzwl %ax,%eax
801043ff:	c1 ea 10             	shr    $0x10,%edx
80104402:	52                   	push   %edx
80104403:	50                   	push   %eax
80104404:	e8 e7 fe ff ff       	call   801042f0 <pci_attach_match>
				 &pci_attach_class[0], f) ||
80104409:	31 d2                	xor    %edx,%edx
8010440b:	83 c4 10             	add    $0x10,%esp
8010440e:	85 c0                	test   %eax,%eax
80104410:	0f 95 c2             	setne  %dl
				 &pci_attach_vendor[0], f);
}
80104413:	89 d0                	mov    %edx,%eax
80104415:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104418:	c9                   	leave  
80104419:	c3                   	ret    
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	57                   	push   %edi
80104424:	56                   	push   %esi
80104425:	53                   	push   %ebx
80104426:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
80104428:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
{
8010442e:	81 ec 00 01 00 00    	sub    $0x100,%esp
	memset(&df, 0, sizeof(df));
80104434:	6a 48                	push   $0x48
80104436:	6a 00                	push   $0x0
80104438:	50                   	push   %eax
80104439:	e8 22 17 00 00       	call   80105b60 <memset>
	df.bus = bus;
8010443e:	89 9d 10 ff ff ff    	mov    %ebx,-0xf0(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
80104444:	c7 85 14 ff ff ff 00 	movl   $0x0,-0xec(%ebp)
8010444b:	00 00 00 
8010444e:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
80104451:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%ebp)
80104458:	00 00 00 
	for (df.dev = 0; df.dev < 32; df.dev++) {
8010445b:	31 d2                	xor    %edx,%edx
8010445d:	eb 1f                	jmp    8010447e <pci_scan_bus+0x5e>
8010445f:	90                   	nop
80104460:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
80104466:	8d 50 01             	lea    0x1(%eax),%edx
80104469:	83 fa 1f             	cmp    $0x1f,%edx
8010446c:	89 95 14 ff ff ff    	mov    %edx,-0xec(%ebp)
80104472:	0f 87 98 01 00 00    	ja     80104610 <pci_scan_bus+0x1f0>
80104478:	8b 9d 10 ff ff ff    	mov    -0xf0(%ebp),%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
8010447e:	8b 43 04             	mov    0x4(%ebx),%eax
80104481:	83 ec 0c             	sub    $0xc,%esp
80104484:	8b 8d 18 ff ff ff    	mov    -0xe8(%ebp),%ecx
8010448a:	6a 0c                	push   $0xc
8010448c:	e8 df fe ff ff       	call   80104370 <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
80104491:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80104496:	ed                   	in     (%dx),%eax
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
80104497:	89 c2                	mov    %eax,%edx
80104499:	83 c4 10             	add    $0x10,%esp
8010449c:	c1 ea 10             	shr    $0x10,%edx
8010449f:	83 e2 7f             	and    $0x7f,%edx
801044a2:	83 fa 01             	cmp    $0x1,%edx
801044a5:	77 b9                	ja     80104460 <pci_scan_bus+0x40>
			continue;

		totaldev++;

		struct pci_func f = df;
801044a7:	b9 12 00 00 00       	mov    $0x12,%ecx
801044ac:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
801044b2:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
801044b8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
801044ba:	8b b5 10 ff ff ff    	mov    -0xf0(%ebp),%esi
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
801044c0:	25 00 00 80 00       	and    $0x800000,%eax
		totaldev++;
801044c5:	83 85 f8 fe ff ff 01 	addl   $0x1,-0x108(%ebp)
801044cc:	83 f8 01             	cmp    $0x1,%eax
801044cf:	19 c0                	sbb    %eax,%eax
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
801044d1:	31 db                	xor    %ebx,%ebx
		struct pci_func f = df;
801044d3:	89 b5 fc fe ff ff    	mov    %esi,-0x104(%ebp)
801044d9:	83 e0 f9             	and    $0xfffffff9,%eax
801044dc:	8b b5 14 ff ff ff    	mov    -0xec(%ebp),%esi
801044e2:	83 c0 08             	add    $0x8,%eax
801044e5:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
801044eb:	89 b5 00 ff ff ff    	mov    %esi,-0x100(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
801044f1:	e9 00 01 00 00       	jmp    801045f6 <pci_scan_bus+0x1d6>
801044f6:	8d 76 00             	lea    0x0(%esi),%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		     f.func++) {
			struct pci_func af = f;
80104500:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80104506:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
8010450c:	8d 7d a0             	lea    -0x60(%ebp),%edi
8010450f:	89 9d 60 ff ff ff    	mov    %ebx,-0xa0(%ebp)
80104515:	8d b5 58 ff ff ff    	lea    -0xa8(%ebp),%esi
8010451b:	b9 12 00 00 00       	mov    $0x12,%ecx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
80104520:	83 ec 0c             	sub    $0xc,%esp
			struct pci_func af = f;
80104523:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
80104529:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
8010452f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
80104531:	89 d9                	mov    %ebx,%ecx
80104533:	8b 40 04             	mov    0x4(%eax),%eax
80104536:	6a 00                	push   $0x0
80104538:	e8 33 fe ff ff       	call   80104370 <pci_conf1_set_addr>
8010453d:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80104542:	ed                   	in     (%dx),%eax

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
80104543:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
80104546:	0f b7 c0             	movzwl %ax,%eax
80104549:	83 c4 10             	add    $0x10,%esp
8010454c:	3d ff ff 00 00       	cmp    $0xffff,%eax
80104551:	0f 84 9c 00 00 00    	je     801045f3 <pci_scan_bus+0x1d3>
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
80104557:	8b 45 a0             	mov    -0x60(%ebp),%eax
8010455a:	83 ec 0c             	sub    $0xc,%esp
8010455d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
80104560:	8b 4d a8             	mov    -0x58(%ebp),%ecx
80104563:	8b 40 04             	mov    0x4(%eax),%eax
80104566:	6a 3c                	push   $0x3c
80104568:	e8 03 fe ff ff       	call   80104370 <pci_conf1_set_addr>
8010456d:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80104572:	ed                   	in     (%dx),%eax
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
			af.irq_line = PCI_INTERRUPT_LINE(intr);
80104573:	88 45 e4             	mov    %al,-0x1c(%ebp)
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
80104576:	8b 45 a0             	mov    -0x60(%ebp),%eax
80104579:	8b 55 a4             	mov    -0x5c(%ebp),%edx
8010457c:	8b 4d a8             	mov    -0x58(%ebp),%ecx
8010457f:	8b 40 04             	mov    0x4(%eax),%eax
80104582:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80104589:	e8 e2 fd ff ff       	call   80104370 <pci_conf1_set_addr>
8010458e:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80104593:	ed                   	in     (%dx),%eax
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
80104594:	89 c1                	mov    %eax,%ecx
80104596:	83 c4 10             	add    $0x10,%esp

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
80104599:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
8010459c:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
8010459f:	be be 95 10 80       	mov    $0x801095be,%esi
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
801045a4:	83 f9 06             	cmp    $0x6,%ecx
801045a7:	77 07                	ja     801045b0 <pci_scan_bus+0x190>
		class = pci_class[PCI_CLASS(f->dev_class)];
801045a9:	8b 34 8d 68 96 10 80 	mov    -0x7fef6998(,%ecx,4),%esi
	cprintf("PCI3: %x:%x.%d: %x:%x: class: %x.%x (%s) irq: %d\n",
801045b0:	0f b6 7d e4          	movzbl -0x1c(%ebp),%edi
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
801045b4:	8b 55 ac             	mov    -0x54(%ebp),%edx
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
801045b7:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI3: %x:%x.%d: %x:%x: class: %x.%x (%s) irq: %d\n",
801045ba:	83 ec 08             	sub    $0x8,%esp
801045bd:	0f b6 c0             	movzbl %al,%eax
801045c0:	57                   	push   %edi
801045c1:	56                   	push   %esi
801045c2:	50                   	push   %eax
801045c3:	89 d0                	mov    %edx,%eax
801045c5:	51                   	push   %ecx
801045c6:	c1 e8 10             	shr    $0x10,%eax
801045c9:	0f b7 d2             	movzwl %dx,%edx
801045cc:	50                   	push   %eax
801045cd:	8b 45 a0             	mov    -0x60(%ebp),%eax
801045d0:	52                   	push   %edx
801045d1:	ff 75 a8             	pushl  -0x58(%ebp)
801045d4:	ff 75 a4             	pushl  -0x5c(%ebp)
801045d7:	ff 70 04             	pushl  0x4(%eax)
801045da:	68 70 94 10 80       	push   $0x80109470
801045df:	e8 5c c6 ff ff       	call   80100c40 <cprintf>
			if (pci_show_devs)
				pci_print_func(&af);
			pci_attach(&af);
801045e4:	8d 45 a0             	lea    -0x60(%ebp),%eax
801045e7:	83 c4 24             	add    $0x24,%esp
801045ea:	50                   	push   %eax
801045eb:	e8 d0 fd ff ff       	call   801043c0 <pci_attach>
801045f0:	83 c4 10             	add    $0x10,%esp
801045f3:	83 c3 01             	add    $0x1,%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
801045f6:	3b 9d 04 ff ff ff    	cmp    -0xfc(%ebp),%ebx
801045fc:	0f 85 fe fe ff ff    	jne    80104500 <pci_scan_bus+0xe0>
80104602:	e9 59 fe ff ff       	jmp    80104460 <pci_scan_bus+0x40>
80104607:	89 f6                	mov    %esi,%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		}
	}

	return totaldev;
}
80104610:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80104616:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104619:	5b                   	pop    %ebx
8010461a:	5e                   	pop    %esi
8010461b:	5f                   	pop    %edi
8010461c:	5d                   	pop    %ebp
8010461d:	c3                   	ret    
8010461e:	66 90                	xchg   %ax,%ax

80104620 <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	56                   	push   %esi
80104625:	53                   	push   %ebx
80104626:	be fc 0c 00 00       	mov    $0xcfc,%esi
8010462b:	83 ec 28             	sub    $0x28,%esp
8010462e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
80104631:	8b 03                	mov    (%ebx),%eax
80104633:	8b 53 04             	mov    0x4(%ebx),%edx
80104636:	8b 4b 08             	mov    0x8(%ebx),%ecx
80104639:	8b 40 04             	mov    0x4(%eax),%eax
8010463c:	6a 1c                	push   $0x1c
8010463e:	e8 2d fd ff ff       	call   80104370 <pci_conf1_set_addr>
80104643:	89 f2                	mov    %esi,%edx
80104645:	ed                   	in     (%dx),%eax
80104646:	89 c7                	mov    %eax,%edi
80104648:	8b 03                	mov    (%ebx),%eax
8010464a:	8b 53 04             	mov    0x4(%ebx),%edx
8010464d:	8b 4b 08             	mov    0x8(%ebx),%ecx
80104650:	8b 40 04             	mov    0x4(%eax),%eax
80104653:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
8010465a:	e8 11 fd ff ff       	call   80104370 <pci_conf1_set_addr>
8010465f:	89 f2                	mov    %esi,%edx
80104661:	ed                   	in     (%dx),%eax
80104662:	89 c6                	mov    %eax,%esi
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
80104664:	89 f8                	mov    %edi,%eax
80104666:	83 c4 10             	add    $0x10,%esp
80104669:	83 e0 0f             	and    $0xf,%eax
8010466c:	83 f8 01             	cmp    $0x1,%eax
8010466f:	74 57                	je     801046c8 <pci_bridge_attach+0xa8>
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
80104671:	8d 7d e0             	lea    -0x20(%ebp),%edi
80104674:	83 ec 04             	sub    $0x4,%esp
80104677:	6a 08                	push   $0x8
80104679:	6a 00                	push   $0x0
8010467b:	57                   	push   %edi
8010467c:	e8 df 14 00 00       	call   80105b60 <memset>
	nbus.parent_bridge = pcif;
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
80104681:	89 f0                	mov    %esi,%eax
	nbus.parent_bridge = pcif;
80104683:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
80104686:	0f b6 d4             	movzbl %ah,%edx

	if (pci_show_devs)
		cprintf("PCI2: %x:%x.%d: bridge to PCI bus %d--%d\n",
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
80104689:	c1 e8 10             	shr    $0x10,%eax
		cprintf("PCI2: %x:%x.%d: bridge to PCI bus %d--%d\n",
8010468c:	0f b6 c0             	movzbl %al,%eax
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
8010468f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		cprintf("PCI2: %x:%x.%d: bridge to PCI bus %d--%d\n",
80104692:	59                   	pop    %ecx
80104693:	5e                   	pop    %esi
80104694:	50                   	push   %eax
80104695:	52                   	push   %edx
80104696:	ff 73 08             	pushl  0x8(%ebx)
80104699:	ff 73 04             	pushl  0x4(%ebx)
8010469c:	8b 03                	mov    (%ebx),%eax
8010469e:	ff 70 04             	pushl  0x4(%eax)
801046a1:	68 d8 94 10 80       	push   $0x801094d8
801046a6:	e8 95 c5 ff ff       	call   80100c40 <cprintf>

	pci_scan_bus(&nbus);
801046ab:	83 c4 20             	add    $0x20,%esp
801046ae:	89 f8                	mov    %edi,%eax
801046b0:	e8 6b fd ff ff       	call   80104420 <pci_scan_bus>
	return 1;
}
801046b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 1;
801046b8:	b8 01 00 00 00       	mov    $0x1,%eax
}
801046bd:	5b                   	pop    %ebx
801046be:	5e                   	pop    %esi
801046bf:	5f                   	pop    %edi
801046c0:	5d                   	pop    %ebp
801046c1:	c3                   	ret    
801046c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cprintf("PCI1: %x:%x.%d: 32-bit bridge IO not supported.\n",
801046c8:	ff 73 08             	pushl  0x8(%ebx)
801046cb:	ff 73 04             	pushl  0x4(%ebx)
801046ce:	8b 03                	mov    (%ebx),%eax
801046d0:	ff 70 04             	pushl  0x4(%eax)
801046d3:	68 a4 94 10 80       	push   $0x801094a4
801046d8:	e8 63 c5 ff ff       	call   80100c40 <cprintf>
		return 0;
801046dd:	83 c4 10             	add    $0x10,%esp
}
801046e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return 0;
801046e3:	31 c0                	xor    %eax,%eax
}
801046e5:	5b                   	pop    %ebx
801046e6:	5e                   	pop    %esi
801046e7:	5f                   	pop    %edi
801046e8:	5d                   	pop    %ebp
801046e9:	c3                   	ret    
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046f0 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	56                   	push   %esi
801046f5:	53                   	push   %ebx
801046f6:	83 ec 28             	sub    $0x28,%esp
801046f9:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
801046fc:	8b 07                	mov    (%edi),%eax
801046fe:	8b 57 04             	mov    0x4(%edi),%edx
80104701:	8b 4f 08             	mov    0x8(%edi),%ecx
80104704:	8b 40 04             	mov    0x4(%eax),%eax
80104707:	6a 04                	push   $0x4
80104709:	e8 62 fc ff ff       	call   80104370 <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
8010470e:	b8 07 00 00 00       	mov    $0x7,%eax
80104713:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80104718:	ef                   	out    %eax,(%dx)
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
80104719:	be 10 00 00 00       	mov    $0x10,%esi
8010471e:	83 c4 10             	add    $0x10,%esp
80104721:	e9 a4 00 00 00       	jmp    801047ca <pci_func_enable+0xda>
80104726:	8d 76 00             	lea    0x0(%esi),%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
			continue;

		int regnum = PCI_MAPREG_NUM(bar);
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
80104730:	83 e2 06             	and    $0x6,%edx
		bar_width = 4;
80104733:	31 db                	xor    %ebx,%ebx
80104735:	83 fa 04             	cmp    $0x4,%edx
				bar_width = 8;

			size = PCI_MAPREG_MEM_SIZE(rv);
80104738:	89 c2                	mov    %eax,%edx
		bar_width = 4;
8010473a:	0f 94 c3             	sete   %bl
			size = PCI_MAPREG_MEM_SIZE(rv);
8010473d:	83 e2 f0             	and    $0xfffffff0,%edx
80104740:	f7 da                	neg    %edx
		bar_width = 4;
80104742:	8d 1c 9d 04 00 00 00 	lea    0x4(,%ebx,4),%ebx
			size = PCI_MAPREG_MEM_SIZE(rv);
80104749:	21 c2                	and    %eax,%edx
			base = PCI_MAPREG_MEM_ADDR(oldv);
8010474b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
			size = PCI_MAPREG_MEM_SIZE(rv);
8010474e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			base = PCI_MAPREG_MEM_ADDR(oldv);
80104751:	83 e0 f0             	and    $0xfffffff0,%eax
80104754:	89 45 d8             	mov    %eax,-0x28(%ebp)
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
80104757:	8b 07                	mov    (%edi),%eax
80104759:	8b 57 04             	mov    0x4(%edi),%edx
8010475c:	83 ec 0c             	sub    $0xc,%esp
8010475f:	8b 4f 08             	mov    0x8(%edi),%ecx
80104762:	8b 40 04             	mov    0x4(%eax),%eax
80104765:	56                   	push   %esi
80104766:	e8 05 fc ff ff       	call   80104370 <pci_conf1_set_addr>
8010476b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010476e:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80104773:	ef                   	out    %eax,(%dx)
80104774:	8b 45 e0             	mov    -0x20(%ebp),%eax
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
		f->reg_base[regnum] = base;
		f->reg_size[regnum] = size;
80104777:	8b 4d dc             	mov    -0x24(%ebp),%ecx

		if (size && !base)
8010477a:	83 c4 10             	add    $0x10,%esp
		f->reg_base[regnum] = base;
8010477d:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104780:	8d 04 87             	lea    (%edi,%eax,4),%eax
		if (size && !base)
80104783:	85 c9                	test   %ecx,%ecx
		f->reg_base[regnum] = base;
80104785:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
80104788:	89 48 2c             	mov    %ecx,0x2c(%eax)
		if (size && !base)
8010478b:	74 32                	je     801047bf <pci_func_enable+0xcf>
8010478d:	85 d2                	test   %edx,%edx
8010478f:	75 2e                	jne    801047bf <pci_func_enable+0xcf>
			cprintf("PCI device %x:%x.%d (%x:%x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
80104791:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %x:%x.%d (%x:%x) "
80104794:	83 ec 0c             	sub    $0xc,%esp
80104797:	51                   	push   %ecx
80104798:	6a 00                	push   $0x0
8010479a:	ff 75 e0             	pushl  -0x20(%ebp)
8010479d:	89 c2                	mov    %eax,%edx
8010479f:	0f b7 c0             	movzwl %ax,%eax
801047a2:	c1 ea 10             	shr    $0x10,%edx
801047a5:	52                   	push   %edx
801047a6:	50                   	push   %eax
801047a7:	ff 77 08             	pushl  0x8(%edi)
801047aa:	ff 77 04             	pushl  0x4(%edi)
801047ad:	8b 07                	mov    (%edi),%eax
801047af:	ff 70 04             	pushl  0x4(%eax)
801047b2:	68 04 95 10 80       	push   $0x80109504
801047b7:	e8 84 c4 ff ff       	call   80100c40 <cprintf>
801047bc:	83 c4 30             	add    $0x30,%esp
	     bar += bar_width)
801047bf:	01 de                	add    %ebx,%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
801047c1:	83 fe 27             	cmp    $0x27,%esi
801047c4:	0f 87 8e 00 00 00    	ja     80104858 <pci_func_enable+0x168>
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
801047ca:	8b 07                	mov    (%edi),%eax
801047cc:	8b 57 04             	mov    0x4(%edi),%edx
801047cf:	83 ec 0c             	sub    $0xc,%esp
801047d2:	8b 4f 08             	mov    0x8(%edi),%ecx
801047d5:	8b 40 04             	mov    0x4(%eax),%eax
801047d8:	56                   	push   %esi
801047d9:	e8 92 fb ff ff       	call   80104370 <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
801047de:	ba fc 0c 00 00       	mov    $0xcfc,%edx
801047e3:	ed                   	in     (%dx),%eax
801047e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
801047e7:	8b 07                	mov    (%edi),%eax
801047e9:	8b 57 04             	mov    0x4(%edi),%edx
801047ec:	8b 4f 08             	mov    0x8(%edi),%ecx
801047ef:	8b 40 04             	mov    0x4(%eax),%eax
801047f2:	89 34 24             	mov    %esi,(%esp)
801047f5:	e8 76 fb ff ff       	call   80104370 <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
801047fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047ff:	ba fc 0c 00 00       	mov    $0xcfc,%edx
80104804:	ef                   	out    %eax,(%dx)
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
80104805:	8b 07                	mov    (%edi),%eax
80104807:	8b 57 04             	mov    0x4(%edi),%edx
8010480a:	8b 4f 08             	mov    0x8(%edi),%ecx
8010480d:	8b 40 04             	mov    0x4(%eax),%eax
80104810:	89 34 24             	mov    %esi,(%esp)
80104813:	e8 58 fb ff ff       	call   80104370 <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
80104818:	ba fc 0c 00 00       	mov    $0xcfc,%edx
8010481d:	ed                   	in     (%dx),%eax
		if (rv == 0)
8010481e:	83 c4 10             	add    $0x10,%esp
80104821:	85 c0                	test   %eax,%eax
		bar_width = 4;
80104823:	bb 04 00 00 00       	mov    $0x4,%ebx
		if (rv == 0)
80104828:	74 95                	je     801047bf <pci_func_enable+0xcf>
		int regnum = PCI_MAPREG_NUM(bar);
8010482a:	8d 56 f0             	lea    -0x10(%esi),%edx
8010482d:	c1 ea 02             	shr    $0x2,%edx
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
80104830:	a8 01                	test   $0x1,%al
		int regnum = PCI_MAPREG_NUM(bar);
80104832:	89 55 e0             	mov    %edx,-0x20(%ebp)
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
80104835:	89 c2                	mov    %eax,%edx
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
80104837:	0f 84 f3 fe ff ff    	je     80104730 <pci_func_enable+0x40>
			size = PCI_MAPREG_IO_SIZE(rv);
8010483d:	83 e2 fc             	and    $0xfffffffc,%edx
80104840:	f7 da                	neg    %edx
80104842:	21 c2                	and    %eax,%edx
			base = PCI_MAPREG_IO_ADDR(oldv);
80104844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
			size = PCI_MAPREG_IO_SIZE(rv);
80104847:	89 55 dc             	mov    %edx,-0x24(%ebp)
			base = PCI_MAPREG_IO_ADDR(oldv);
8010484a:	83 e0 fc             	and    $0xfffffffc,%eax
8010484d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104850:	e9 02 ff ff ff       	jmp    80104757 <pci_func_enable+0x67>
80104855:	8d 76 00             	lea    0x0(%esi),%esi
				regnum, base, size);
	}

	cprintf("PCI function %x:%x.%d (%x:%x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
80104858:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %x:%x.%d (%x:%x) enabled\n",
8010485b:	83 ec 08             	sub    $0x8,%esp
8010485e:	89 c2                	mov    %eax,%edx
80104860:	0f b7 c0             	movzwl %ax,%eax
80104863:	c1 ea 10             	shr    $0x10,%edx
80104866:	52                   	push   %edx
80104867:	50                   	push   %eax
80104868:	ff 77 08             	pushl  0x8(%edi)
8010486b:	ff 77 04             	pushl  0x4(%edi)
8010486e:	8b 07                	mov    (%edi),%eax
80104870:	ff 70 04             	pushl  0x4(%eax)
80104873:	68 58 95 10 80       	push   $0x80109558
80104878:	e8 c3 c3 ff ff       	call   80100c40 <cprintf>
}
8010487d:	83 c4 20             	add    $0x20,%esp
80104880:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104883:	5b                   	pop    %ebx
80104884:	5e                   	pop    %esi
80104885:	5f                   	pop    %edi
80104886:	5d                   	pop    %ebp
80104887:	c3                   	ret    
80104888:	90                   	nop
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104890 <pci_e1000_attach>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 10             	sub    $0x10,%esp
80104897:	8b 5d 08             	mov    0x8(%ebp),%ebx
    pci_func_enable(pcif);
8010489a:	53                   	push   %ebx
8010489b:	e8 50 fe ff ff       	call   801046f0 <pci_func_enable>
    e1000_memreg_vaddr = (uint32_t*)pcif->reg_base[0]; //P2V(pcif->reg_base[0]);//, pcif->reg_size[0]);
801048a0:	8b 43 14             	mov    0x14(%ebx),%eax
    cprintf("here e1000_memreg_vaddr: %x\n", e1000_memreg_vaddr);
801048a3:	5a                   	pop    %edx
801048a4:	59                   	pop    %ecx
801048a5:	50                   	push   %eax
801048a6:	68 c6 95 10 80       	push   $0x801095c6
    e1000_memreg_vaddr = (uint32_t*)pcif->reg_base[0]; //P2V(pcif->reg_base[0]);//, pcif->reg_size[0]);
801048ab:	a3 54 88 15 80       	mov    %eax,0x80158854
    cprintf("here e1000_memreg_vaddr: %x\n", e1000_memreg_vaddr);
801048b0:	e8 8b c3 ff ff       	call   80100c40 <cprintf>
cprintf("pcif->reg_base[0]: %x\n", pcif->reg_base[0]);
801048b5:	58                   	pop    %eax
801048b6:	5a                   	pop    %edx
801048b7:	ff 73 14             	pushl  0x14(%ebx)
801048ba:	68 e3 95 10 80       	push   $0x801095e3
801048bf:	e8 7c c3 ff ff       	call   80100c40 <cprintf>
    cprintf("after assert E1000 Status:0x80080783 %x\n", E1000_REG(E1000_STATUS));
801048c4:	a1 54 88 15 80       	mov    0x80158854,%eax
801048c9:	59                   	pop    %ecx
801048ca:	5b                   	pop    %ebx
801048cb:	8b 40 08             	mov    0x8(%eax),%eax
801048ce:	50                   	push   %eax
801048cf:	68 80 95 10 80       	push   $0x80109580
801048d4:	e8 67 c3 ff ff       	call   80100c40 <cprintf>
    e1000_tx_init();
801048d9:	e8 62 ca ff ff       	call   80101340 <e1000_tx_init>
   e1000_rx_init();
801048de:	e8 2d cb ff ff       	call   80101410 <e1000_rx_init>
   e1000_init();
801048e3:	e8 e8 cd ff ff       	call   801016d0 <e1000_init>
}
801048e8:	b8 01 00 00 00       	mov    $0x1,%eax
801048ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f0:	c9                   	leave  
801048f1:	c3                   	ret    
801048f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <pci_init>:

int
pci_init(void)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
80104906:	6a 08                	push   $0x8
80104908:	6a 00                	push   $0x0
8010490a:	68 d8 2d 15 80       	push   $0x80152dd8
8010490f:	e8 4c 12 00 00       	call   80105b60 <memset>

	return pci_scan_bus(&root_bus);
80104914:	83 c4 10             	add    $0x10,%esp
}
80104917:	c9                   	leave  
	return pci_scan_bus(&root_bus);
80104918:	b8 d8 2d 15 80       	mov    $0x80152dd8,%eax
8010491d:	e9 fe fa ff ff       	jmp    80104420 <pci_scan_bus>
80104922:	66 90                	xchg   %ax,%ax
80104924:	66 90                	xchg   %ax,%ax
80104926:	66 90                	xchg   %ax,%ax
80104928:	66 90                	xchg   %ax,%ax
8010492a:	66 90                	xchg   %ax,%ax
8010492c:	66 90                	xchg   %ax,%ax
8010492e:	66 90                	xchg   %ax,%ax

80104930 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80104930:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104931:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104936:	ba 21 00 00 00       	mov    $0x21,%edx
8010493b:	89 e5                	mov    %esp,%ebp
8010493d:	ee                   	out    %al,(%dx)
8010493e:	ba a1 00 00 00       	mov    $0xa1,%edx
80104943:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80104944:	5d                   	pop    %ebp
80104945:	c3                   	ret    
80104946:	66 90                	xchg   %ax,%ax
80104948:	66 90                	xchg   %ax,%ax
8010494a:	66 90                	xchg   %ax,%ax
8010494c:	66 90                	xchg   %ax,%ax
8010494e:	66 90                	xchg   %ax,%ax

80104950 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	57                   	push   %edi
80104954:	56                   	push   %esi
80104955:	53                   	push   %ebx
80104956:	83 ec 0c             	sub    $0xc,%esp
80104959:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010495c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010495f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104965:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010496b:	e8 d0 cd ff ff       	call   80101740 <filealloc>
80104970:	85 c0                	test   %eax,%eax
80104972:	89 03                	mov    %eax,(%ebx)
80104974:	74 22                	je     80104998 <pipealloc+0x48>
80104976:	e8 c5 cd ff ff       	call   80101740 <filealloc>
8010497b:	85 c0                	test   %eax,%eax
8010497d:	89 06                	mov    %eax,(%esi)
8010497f:	74 3f                	je     801049c0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104981:	e8 8a e5 ff ff       	call   80102f10 <kalloc>
80104986:	85 c0                	test   %eax,%eax
80104988:	89 c7                	mov    %eax,%edi
8010498a:	75 54                	jne    801049e0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010498c:	8b 03                	mov    (%ebx),%eax
8010498e:	85 c0                	test   %eax,%eax
80104990:	75 34                	jne    801049c6 <pipealloc+0x76>
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80104998:	8b 06                	mov    (%esi),%eax
8010499a:	85 c0                	test   %eax,%eax
8010499c:	74 0c                	je     801049aa <pipealloc+0x5a>
    fileclose(*f1);
8010499e:	83 ec 0c             	sub    $0xc,%esp
801049a1:	50                   	push   %eax
801049a2:	e8 59 ce ff ff       	call   80101800 <fileclose>
801049a7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801049aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801049ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049b2:	5b                   	pop    %ebx
801049b3:	5e                   	pop    %esi
801049b4:	5f                   	pop    %edi
801049b5:	5d                   	pop    %ebp
801049b6:	c3                   	ret    
801049b7:	89 f6                	mov    %esi,%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801049c0:	8b 03                	mov    (%ebx),%eax
801049c2:	85 c0                	test   %eax,%eax
801049c4:	74 e4                	je     801049aa <pipealloc+0x5a>
    fileclose(*f0);
801049c6:	83 ec 0c             	sub    $0xc,%esp
801049c9:	50                   	push   %eax
801049ca:	e8 31 ce ff ff       	call   80101800 <fileclose>
  if(*f1)
801049cf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801049d1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801049d4:	85 c0                	test   %eax,%eax
801049d6:	75 c6                	jne    8010499e <pipealloc+0x4e>
801049d8:	eb d0                	jmp    801049aa <pipealloc+0x5a>
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801049e0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801049e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801049ea:	00 00 00 
  p->writeopen = 1;
801049ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801049f4:	00 00 00 
  p->nwrite = 0;
801049f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801049fe:	00 00 00 
  p->nread = 0;
80104a01:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104a08:	00 00 00 
  initlock(&p->lock, "pipe");
80104a0b:	68 84 96 10 80       	push   $0x80109684
80104a10:	50                   	push   %eax
80104a11:	e8 da 0e 00 00       	call   801058f0 <initlock>
  (*f0)->type = FD_PIPE;
80104a16:	8b 03                	mov    (%ebx),%eax
  return 0;
80104a18:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104a1b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104a21:	8b 03                	mov    (%ebx),%eax
80104a23:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104a27:	8b 03                	mov    (%ebx),%eax
80104a29:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104a2d:	8b 03                	mov    (%ebx),%eax
80104a2f:	89 78 10             	mov    %edi,0x10(%eax)
  (*f1)->type = FD_PIPE;
80104a32:	8b 06                	mov    (%esi),%eax
80104a34:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104a3a:	8b 06                	mov    (%esi),%eax
80104a3c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104a40:	8b 06                	mov    (%esi),%eax
80104a42:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104a46:	8b 06                	mov    (%esi),%eax
80104a48:	89 78 10             	mov    %edi,0x10(%eax)
}
80104a4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80104a4e:	31 c0                	xor    %eax,%eax
}
80104a50:	5b                   	pop    %ebx
80104a51:	5e                   	pop    %esi
80104a52:	5f                   	pop    %edi
80104a53:	5d                   	pop    %ebp
80104a54:	c3                   	ret    
80104a55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a60 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
80104a65:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a68:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80104a6b:	83 ec 0c             	sub    $0xc,%esp
80104a6e:	53                   	push   %ebx
80104a6f:	e8 6c 0f 00 00       	call   801059e0 <acquire>
  if(writable){
80104a74:	83 c4 10             	add    $0x10,%esp
80104a77:	85 f6                	test   %esi,%esi
80104a79:	74 45                	je     80104ac0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80104a7b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104a81:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80104a84:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80104a8b:	00 00 00 
    wakeup(&p->nread);
80104a8e:	50                   	push   %eax
80104a8f:	e8 ac 0b 00 00       	call   80105640 <wakeup>
80104a94:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104a97:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80104a9d:	85 d2                	test   %edx,%edx
80104a9f:	75 0a                	jne    80104aab <pipeclose+0x4b>
80104aa1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80104aa7:	85 c0                	test   %eax,%eax
80104aa9:	74 35                	je     80104ae0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80104aab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80104aae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab1:	5b                   	pop    %ebx
80104ab2:	5e                   	pop    %esi
80104ab3:	5d                   	pop    %ebp
    release(&p->lock);
80104ab4:	e9 47 10 00 00       	jmp    80105b00 <release>
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80104ac0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80104ac6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80104ac9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80104ad0:	00 00 00 
    wakeup(&p->nwrite);
80104ad3:	50                   	push   %eax
80104ad4:	e8 67 0b 00 00       	call   80105640 <wakeup>
80104ad9:	83 c4 10             	add    $0x10,%esp
80104adc:	eb b9                	jmp    80104a97 <pipeclose+0x37>
80104ade:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80104ae0:	83 ec 0c             	sub    $0xc,%esp
80104ae3:	53                   	push   %ebx
80104ae4:	e8 17 10 00 00       	call   80105b00 <release>
    kfree((char*)p);
80104ae9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104aec:	83 c4 10             	add    $0x10,%esp
}
80104aef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104af2:	5b                   	pop    %ebx
80104af3:	5e                   	pop    %esi
80104af4:	5d                   	pop    %ebp
    kfree((char*)p);
80104af5:	e9 66 e2 ff ff       	jmp    80102d60 <kfree>
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b00 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
80104b06:	83 ec 28             	sub    $0x28,%esp
80104b09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80104b0c:	53                   	push   %ebx
80104b0d:	e8 ce 0e 00 00       	call   801059e0 <acquire>
  for(i = 0; i < n; i++){
80104b12:	8b 45 10             	mov    0x10(%ebp),%eax
80104b15:	83 c4 10             	add    $0x10,%esp
80104b18:	85 c0                	test   %eax,%eax
80104b1a:	0f 8e c9 00 00 00    	jle    80104be9 <pipewrite+0xe9>
80104b20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104b23:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80104b29:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80104b2f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80104b32:	03 4d 10             	add    0x10(%ebp),%ecx
80104b35:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104b38:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80104b3e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80104b44:	39 d0                	cmp    %edx,%eax
80104b46:	75 71                	jne    80104bb9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80104b48:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80104b4e:	85 c0                	test   %eax,%eax
80104b50:	74 4e                	je     80104ba0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104b52:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80104b58:	eb 3a                	jmp    80104b94 <pipewrite+0x94>
80104b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80104b60:	83 ec 0c             	sub    $0xc,%esp
80104b63:	57                   	push   %edi
80104b64:	e8 d7 0a 00 00       	call   80105640 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104b69:	5a                   	pop    %edx
80104b6a:	59                   	pop    %ecx
80104b6b:	53                   	push   %ebx
80104b6c:	56                   	push   %esi
80104b6d:	e8 1e 09 00 00       	call   80105490 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104b72:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80104b78:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80104b7e:	83 c4 10             	add    $0x10,%esp
80104b81:	05 00 02 00 00       	add    $0x200,%eax
80104b86:	39 c2                	cmp    %eax,%edx
80104b88:	75 36                	jne    80104bc0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80104b8a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80104b90:	85 c0                	test   %eax,%eax
80104b92:	74 0c                	je     80104ba0 <pipewrite+0xa0>
80104b94:	e8 57 03 00 00       	call   80104ef0 <myproc>
80104b99:	8b 40 24             	mov    0x24(%eax),%eax
80104b9c:	85 c0                	test   %eax,%eax
80104b9e:	74 c0                	je     80104b60 <pipewrite+0x60>
        release(&p->lock);
80104ba0:	83 ec 0c             	sub    $0xc,%esp
80104ba3:	53                   	push   %ebx
80104ba4:	e8 57 0f 00 00       	call   80105b00 <release>
        return -1;
80104ba9:	83 c4 10             	add    $0x10,%esp
80104bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80104bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bb4:	5b                   	pop    %ebx
80104bb5:	5e                   	pop    %esi
80104bb6:	5f                   	pop    %edi
80104bb7:	5d                   	pop    %ebp
80104bb8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104bb9:	89 c2                	mov    %eax,%edx
80104bbb:	90                   	nop
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104bc0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104bc3:	8d 42 01             	lea    0x1(%edx),%eax
80104bc6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80104bcc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80104bd2:	83 c6 01             	add    $0x1,%esi
80104bd5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80104bd9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80104bdc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104bdf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104be3:	0f 85 4f ff ff ff    	jne    80104b38 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104be9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104bef:	83 ec 0c             	sub    $0xc,%esp
80104bf2:	50                   	push   %eax
80104bf3:	e8 48 0a 00 00       	call   80105640 <wakeup>
  release(&p->lock);
80104bf8:	89 1c 24             	mov    %ebx,(%esp)
80104bfb:	e8 00 0f 00 00       	call   80105b00 <release>
  return n;
80104c00:	83 c4 10             	add    $0x10,%esp
80104c03:	8b 45 10             	mov    0x10(%ebp),%eax
80104c06:	eb a9                	jmp    80104bb1 <pipewrite+0xb1>
80104c08:	90                   	nop
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c10 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	57                   	push   %edi
80104c14:	56                   	push   %esi
80104c15:	53                   	push   %ebx
80104c16:	83 ec 18             	sub    $0x18,%esp
80104c19:	8b 75 08             	mov    0x8(%ebp),%esi
80104c1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80104c1f:	56                   	push   %esi
80104c20:	e8 bb 0d 00 00       	call   801059e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104c25:	83 c4 10             	add    $0x10,%esp
80104c28:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80104c2e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80104c34:	75 6a                	jne    80104ca0 <piperead+0x90>
80104c36:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80104c3c:	85 db                	test   %ebx,%ebx
80104c3e:	0f 84 c4 00 00 00    	je     80104d08 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104c44:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80104c4a:	eb 2d                	jmp    80104c79 <piperead+0x69>
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c50:	83 ec 08             	sub    $0x8,%esp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
80104c55:	e8 36 08 00 00       	call   80105490 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104c5a:	83 c4 10             	add    $0x10,%esp
80104c5d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80104c63:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80104c69:	75 35                	jne    80104ca0 <piperead+0x90>
80104c6b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80104c71:	85 d2                	test   %edx,%edx
80104c73:	0f 84 8f 00 00 00    	je     80104d08 <piperead+0xf8>
    if(myproc()->killed){
80104c79:	e8 72 02 00 00       	call   80104ef0 <myproc>
80104c7e:	8b 48 24             	mov    0x24(%eax),%ecx
80104c81:	85 c9                	test   %ecx,%ecx
80104c83:	74 cb                	je     80104c50 <piperead+0x40>
      release(&p->lock);
80104c85:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104c88:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104c8d:	56                   	push   %esi
80104c8e:	e8 6d 0e 00 00       	call   80105b00 <release>
      return -1;
80104c93:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80104c96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c99:	89 d8                	mov    %ebx,%eax
80104c9b:	5b                   	pop    %ebx
80104c9c:	5e                   	pop    %esi
80104c9d:	5f                   	pop    %edi
80104c9e:	5d                   	pop    %ebp
80104c9f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104ca0:	8b 45 10             	mov    0x10(%ebp),%eax
80104ca3:	85 c0                	test   %eax,%eax
80104ca5:	7e 61                	jle    80104d08 <piperead+0xf8>
    if(p->nread == p->nwrite)
80104ca7:	31 db                	xor    %ebx,%ebx
80104ca9:	eb 13                	jmp    80104cbe <piperead+0xae>
80104cab:	90                   	nop
80104cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cb0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80104cb6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80104cbc:	74 1f                	je     80104cdd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104cbe:	8d 41 01             	lea    0x1(%ecx),%eax
80104cc1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80104cc7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80104ccd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80104cd2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104cd5:	83 c3 01             	add    $0x1,%ebx
80104cd8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80104cdb:	75 d3                	jne    80104cb0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104cdd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104ce3:	83 ec 0c             	sub    $0xc,%esp
80104ce6:	50                   	push   %eax
80104ce7:	e8 54 09 00 00       	call   80105640 <wakeup>
  release(&p->lock);
80104cec:	89 34 24             	mov    %esi,(%esp)
80104cef:	e8 0c 0e 00 00       	call   80105b00 <release>
  return i;
80104cf4:	83 c4 10             	add    $0x10,%esp
}
80104cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cfa:	89 d8                	mov    %ebx,%eax
80104cfc:	5b                   	pop    %ebx
80104cfd:	5e                   	pop    %esi
80104cfe:	5f                   	pop    %edi
80104cff:	5d                   	pop    %ebp
80104d00:	c3                   	ret    
80104d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d08:	31 db                	xor    %ebx,%ebx
80104d0a:	eb d1                	jmp    80104cdd <piperead+0xcd>
80104d0c:	66 90                	xchg   %ax,%ax
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d14:	bb 14 b9 15 80       	mov    $0x8015b914,%ebx
{
80104d19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104d1c:	68 e0 b8 15 80       	push   $0x8015b8e0
80104d21:	e8 ba 0c 00 00       	call   801059e0 <acquire>
80104d26:	83 c4 10             	add    $0x10,%esp
80104d29:	eb 10                	jmp    80104d3b <allocproc+0x2b>
80104d2b:	90                   	nop
80104d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d30:	83 c3 7c             	add    $0x7c,%ebx
80104d33:	81 fb 14 d8 15 80    	cmp    $0x8015d814,%ebx
80104d39:	73 75                	jae    80104db0 <allocproc+0xa0>
    if(p->state == UNUSED)
80104d3b:	8b 43 0c             	mov    0xc(%ebx),%eax
80104d3e:	85 c0                	test   %eax,%eax
80104d40:	75 ee                	jne    80104d30 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104d42:	a1 44 c0 10 80       	mov    0x8010c044,%eax

  release(&ptable.lock);
80104d47:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104d4a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104d51:	8d 50 01             	lea    0x1(%eax),%edx
80104d54:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80104d57:	68 e0 b8 15 80       	push   $0x8015b8e0
  p->pid = nextpid++;
80104d5c:	89 15 44 c0 10 80    	mov    %edx,0x8010c044
  release(&ptable.lock);
80104d62:	e8 99 0d 00 00       	call   80105b00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104d67:	e8 a4 e1 ff ff       	call   80102f10 <kalloc>
80104d6c:	83 c4 10             	add    $0x10,%esp
80104d6f:	85 c0                	test   %eax,%eax
80104d71:	89 43 08             	mov    %eax,0x8(%ebx)
80104d74:	74 53                	je     80104dc9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104d76:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104d7c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80104d7f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104d84:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104d87:	c7 40 14 d2 73 10 80 	movl   $0x801073d2,0x14(%eax)
  p->context = (struct context*)sp;
80104d8e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104d91:	6a 14                	push   $0x14
80104d93:	6a 00                	push   $0x0
80104d95:	50                   	push   %eax
80104d96:	e8 c5 0d 00 00       	call   80105b60 <memset>
  p->context->eip = (uint)forkret;
80104d9b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80104d9e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104da1:	c7 40 10 e0 4d 10 80 	movl   $0x80104de0,0x10(%eax)
}
80104da8:	89 d8                	mov    %ebx,%eax
80104daa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dad:	c9                   	leave  
80104dae:	c3                   	ret    
80104daf:	90                   	nop
  release(&ptable.lock);
80104db0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104db3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104db5:	68 e0 b8 15 80       	push   $0x8015b8e0
80104dba:	e8 41 0d 00 00       	call   80105b00 <release>
}
80104dbf:	89 d8                	mov    %ebx,%eax
  return 0;
80104dc1:	83 c4 10             	add    $0x10,%esp
}
80104dc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc7:	c9                   	leave  
80104dc8:	c3                   	ret    
    p->state = UNUSED;
80104dc9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104dd0:	31 db                	xor    %ebx,%ebx
80104dd2:	eb d4                	jmp    80104da8 <allocproc+0x98>
80104dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104de0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104de6:	68 e0 b8 15 80       	push   $0x8015b8e0
80104deb:	e8 10 0d 00 00       	call   80105b00 <release>

  if (first) {
80104df0:	a1 40 c0 10 80       	mov    0x8010c040,%eax
80104df5:	83 c4 10             	add    $0x10,%esp
80104df8:	85 c0                	test   %eax,%eax
80104dfa:	75 04                	jne    80104e00 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104dfc:	c9                   	leave  
80104dfd:	c3                   	ret    
80104dfe:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80104e00:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80104e03:	c7 05 40 c0 10 80 00 	movl   $0x0,0x8010c040
80104e0a:	00 00 00 
    iinit(ROOTDEV);
80104e0d:	6a 01                	push   $0x1
80104e0f:	e8 bc d0 ff ff       	call   80101ed0 <iinit>
    initlog(ROOTDEV);
80104e14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e1b:	e8 30 e7 ff ff       	call   80103550 <initlog>
80104e20:	83 c4 10             	add    $0x10,%esp
}
80104e23:	c9                   	leave  
80104e24:	c3                   	ret    
80104e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <pinit>:
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104e36:	68 89 96 10 80       	push   $0x80109689
80104e3b:	68 e0 b8 15 80       	push   $0x8015b8e0
80104e40:	e8 ab 0a 00 00       	call   801058f0 <initlock>
}
80104e45:	83 c4 10             	add    $0x10,%esp
80104e48:	c9                   	leave  
80104e49:	c3                   	ret    
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e50 <mycpu>:
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e55:	9c                   	pushf  
80104e56:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e57:	f6 c4 02             	test   $0x2,%ah
80104e5a:	75 5e                	jne    80104eba <mycpu+0x6a>
  apicid = lapicid();
80104e5c:	e8 1f e3 ff ff       	call   80103180 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104e61:	8b 35 c0 b8 15 80    	mov    0x8015b8c0,%esi
80104e67:	85 f6                	test   %esi,%esi
80104e69:	7e 42                	jle    80104ead <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80104e6b:	0f b6 15 40 b3 15 80 	movzbl 0x8015b340,%edx
80104e72:	39 d0                	cmp    %edx,%eax
80104e74:	74 30                	je     80104ea6 <mycpu+0x56>
80104e76:	b9 f0 b3 15 80       	mov    $0x8015b3f0,%ecx
  for (i = 0; i < ncpu; ++i) {
80104e7b:	31 d2                	xor    %edx,%edx
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi
80104e80:	83 c2 01             	add    $0x1,%edx
80104e83:	39 f2                	cmp    %esi,%edx
80104e85:	74 26                	je     80104ead <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80104e87:	0f b6 19             	movzbl (%ecx),%ebx
80104e8a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104e90:	39 c3                	cmp    %eax,%ebx
80104e92:	75 ec                	jne    80104e80 <mycpu+0x30>
80104e94:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80104e9a:	05 40 b3 15 80       	add    $0x8015b340,%eax
}
80104e9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ea2:	5b                   	pop    %ebx
80104ea3:	5e                   	pop    %esi
80104ea4:	5d                   	pop    %ebp
80104ea5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80104ea6:	b8 40 b3 15 80       	mov    $0x8015b340,%eax
      return &cpus[i];
80104eab:	eb f2                	jmp    80104e9f <mycpu+0x4f>
  panic("unknown apicid\n");
80104ead:	83 ec 0c             	sub    $0xc,%esp
80104eb0:	68 90 96 10 80       	push   $0x80109690
80104eb5:	e8 b6 ba ff ff       	call   80100970 <panic>
    panic("mycpu called with interrupts enabled\n");
80104eba:	83 ec 0c             	sub    $0xc,%esp
80104ebd:	68 6c 97 10 80       	push   $0x8010976c
80104ec2:	e8 a9 ba ff ff       	call   80100970 <panic>
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ed0 <cpuid>:
cpuid() {
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104ed6:	e8 75 ff ff ff       	call   80104e50 <mycpu>
80104edb:	2d 40 b3 15 80       	sub    $0x8015b340,%eax
}
80104ee0:	c9                   	leave  
  return mycpu()-cpus;
80104ee1:	c1 f8 04             	sar    $0x4,%eax
80104ee4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80104eea:	c3                   	ret    
80104eeb:	90                   	nop
80104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <myproc>:
myproc(void) {
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	53                   	push   %ebx
80104ef4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104ef7:	e8 a4 0a 00 00       	call   801059a0 <pushcli>
  c = mycpu();
80104efc:	e8 4f ff ff ff       	call   80104e50 <mycpu>
  p = c->proc;
80104f01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104f07:	e8 94 0b 00 00       	call   80105aa0 <popcli>
}
80104f0c:	83 c4 04             	add    $0x4,%esp
80104f0f:	89 d8                	mov    %ebx,%eax
80104f11:	5b                   	pop    %ebx
80104f12:	5d                   	pop    %ebp
80104f13:	c3                   	ret    
80104f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f20 <userinit>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104f27:	e8 e4 fd ff ff       	call   80104d10 <allocproc>
80104f2c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104f2e:	a3 e0 2d 15 80       	mov    %eax,0x80152de0
  if((p->pgdir = setupkvm()) == 0)
80104f33:	e8 08 3b 00 00       	call   80108a40 <setupkvm>
80104f38:	85 c0                	test   %eax,%eax
80104f3a:	89 43 04             	mov    %eax,0x4(%ebx)
80104f3d:	0f 84 bd 00 00 00    	je     80105000 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104f43:	83 ec 04             	sub    $0x4,%esp
80104f46:	68 2c 00 00 00       	push   $0x2c
80104f4b:	68 a0 c4 10 80       	push   $0x8010c4a0
80104f50:	50                   	push   %eax
80104f51:	e8 ca 37 00 00       	call   80108720 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104f56:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104f59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104f5f:	6a 4c                	push   $0x4c
80104f61:	6a 00                	push   $0x0
80104f63:	ff 73 18             	pushl  0x18(%ebx)
80104f66:	e8 f5 0b 00 00       	call   80105b60 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104f6b:	8b 43 18             	mov    0x18(%ebx),%eax
80104f6e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104f73:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104f78:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104f7b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104f7f:	8b 43 18             	mov    0x18(%ebx),%eax
80104f82:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104f86:	8b 43 18             	mov    0x18(%ebx),%eax
80104f89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104f8d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104f91:	8b 43 18             	mov    0x18(%ebx),%eax
80104f94:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104f98:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104f9c:	8b 43 18             	mov    0x18(%ebx),%eax
80104f9f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104fa6:	8b 43 18             	mov    0x18(%ebx),%eax
80104fa9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104fb0:	8b 43 18             	mov    0x18(%ebx),%eax
80104fb3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104fba:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104fbd:	6a 10                	push   $0x10
80104fbf:	68 b9 96 10 80       	push   $0x801096b9
80104fc4:	50                   	push   %eax
80104fc5:	e8 76 0d 00 00       	call   80105d40 <safestrcpy>
  p->cwd = namei("/");
80104fca:	c7 04 24 c2 96 10 80 	movl   $0x801096c2,(%esp)
80104fd1:	e8 5a d9 ff ff       	call   80102930 <namei>
80104fd6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104fd9:	c7 04 24 e0 b8 15 80 	movl   $0x8015b8e0,(%esp)
80104fe0:	e8 fb 09 00 00       	call   801059e0 <acquire>
  p->state = RUNNABLE;
80104fe5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104fec:	c7 04 24 e0 b8 15 80 	movl   $0x8015b8e0,(%esp)
80104ff3:	e8 08 0b 00 00       	call   80105b00 <release>
}
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ffe:	c9                   	leave  
80104fff:	c3                   	ret    
    panic("userinit: out of memory?");
80105000:	83 ec 0c             	sub    $0xc,%esp
80105003:	68 a0 96 10 80       	push   $0x801096a0
80105008:	e8 63 b9 ff ff       	call   80100970 <panic>
8010500d:	8d 76 00             	lea    0x0(%esi),%esi

80105010 <growproc>:
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80105018:	e8 83 09 00 00       	call   801059a0 <pushcli>
  c = mycpu();
8010501d:	e8 2e fe ff ff       	call   80104e50 <mycpu>
  p = c->proc;
80105022:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105028:	e8 73 0a 00 00       	call   80105aa0 <popcli>
  if(n > 0){
8010502d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80105030:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80105032:	7f 1c                	jg     80105050 <growproc+0x40>
  } else if(n < 0){
80105034:	75 3a                	jne    80105070 <growproc+0x60>
  switchuvm(curproc);
80105036:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80105039:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010503b:	53                   	push   %ebx
8010503c:	e8 cf 35 00 00       	call   80108610 <switchuvm>
  return 0;
80105041:	83 c4 10             	add    $0x10,%esp
80105044:	31 c0                	xor    %eax,%eax
}
80105046:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105049:	5b                   	pop    %ebx
8010504a:	5e                   	pop    %esi
8010504b:	5d                   	pop    %ebp
8010504c:	c3                   	ret    
8010504d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80105050:	83 ec 04             	sub    $0x4,%esp
80105053:	01 c6                	add    %eax,%esi
80105055:	56                   	push   %esi
80105056:	50                   	push   %eax
80105057:	ff 73 04             	pushl  0x4(%ebx)
8010505a:	e8 01 38 00 00       	call   80108860 <allocuvm>
8010505f:	83 c4 10             	add    $0x10,%esp
80105062:	85 c0                	test   %eax,%eax
80105064:	75 d0                	jne    80105036 <growproc+0x26>
      return -1;
80105066:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506b:	eb d9                	jmp    80105046 <growproc+0x36>
8010506d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80105070:	83 ec 04             	sub    $0x4,%esp
80105073:	01 c6                	add    %eax,%esi
80105075:	56                   	push   %esi
80105076:	50                   	push   %eax
80105077:	ff 73 04             	pushl  0x4(%ebx)
8010507a:	e8 11 39 00 00       	call   80108990 <deallocuvm>
8010507f:	83 c4 10             	add    $0x10,%esp
80105082:	85 c0                	test   %eax,%eax
80105084:	75 b0                	jne    80105036 <growproc+0x26>
80105086:	eb de                	jmp    80105066 <growproc+0x56>
80105088:	90                   	nop
80105089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105090 <fork>:
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
80105095:	53                   	push   %ebx
80105096:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80105099:	e8 02 09 00 00       	call   801059a0 <pushcli>
  c = mycpu();
8010509e:	e8 ad fd ff ff       	call   80104e50 <mycpu>
  p = c->proc;
801050a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801050a9:	e8 f2 09 00 00       	call   80105aa0 <popcli>
  if((np = allocproc()) == 0){
801050ae:	e8 5d fc ff ff       	call   80104d10 <allocproc>
801050b3:	85 c0                	test   %eax,%eax
801050b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801050b8:	0f 84 b7 00 00 00    	je     80105175 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801050be:	83 ec 08             	sub    $0x8,%esp
801050c1:	ff 33                	pushl  (%ebx)
801050c3:	ff 73 04             	pushl  0x4(%ebx)
801050c6:	89 c7                	mov    %eax,%edi
801050c8:	e8 43 3a 00 00       	call   80108b10 <copyuvm>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	89 47 04             	mov    %eax,0x4(%edi)
801050d5:	0f 84 a1 00 00 00    	je     8010517c <fork+0xec>
  np->sz = curproc->sz;
801050db:	8b 03                	mov    (%ebx),%eax
801050dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801050e0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801050e2:	89 59 14             	mov    %ebx,0x14(%ecx)
801050e5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
801050e7:	8b 79 18             	mov    0x18(%ecx),%edi
801050ea:	8b 73 18             	mov    0x18(%ebx),%esi
801050ed:	b9 13 00 00 00       	mov    $0x13,%ecx
801050f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801050f4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801050f6:	8b 40 18             	mov    0x18(%eax),%eax
801050f9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80105100:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80105104:	85 c0                	test   %eax,%eax
80105106:	74 13                	je     8010511b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80105108:	83 ec 0c             	sub    $0xc,%esp
8010510b:	50                   	push   %eax
8010510c:	e8 9f c6 ff ff       	call   801017b0 <filedup>
80105111:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105114:	83 c4 10             	add    $0x10,%esp
80105117:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010511b:	83 c6 01             	add    $0x1,%esi
8010511e:	83 fe 10             	cmp    $0x10,%esi
80105121:	75 dd                	jne    80105100 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80105123:	83 ec 0c             	sub    $0xc,%esp
80105126:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105129:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010512c:	e8 6f cf ff ff       	call   801020a0 <idup>
80105131:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80105134:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80105137:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010513a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010513d:	6a 10                	push   $0x10
8010513f:	53                   	push   %ebx
80105140:	50                   	push   %eax
80105141:	e8 fa 0b 00 00       	call   80105d40 <safestrcpy>
  pid = np->pid;
80105146:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80105149:	c7 04 24 e0 b8 15 80 	movl   $0x8015b8e0,(%esp)
80105150:	e8 8b 08 00 00       	call   801059e0 <acquire>
  np->state = RUNNABLE;
80105155:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010515c:	c7 04 24 e0 b8 15 80 	movl   $0x8015b8e0,(%esp)
80105163:	e8 98 09 00 00       	call   80105b00 <release>
  return pid;
80105168:	83 c4 10             	add    $0x10,%esp
}
8010516b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010516e:	89 d8                	mov    %ebx,%eax
80105170:	5b                   	pop    %ebx
80105171:	5e                   	pop    %esi
80105172:	5f                   	pop    %edi
80105173:	5d                   	pop    %ebp
80105174:	c3                   	ret    
    return -1;
80105175:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010517a:	eb ef                	jmp    8010516b <fork+0xdb>
    kfree(np->kstack);
8010517c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010517f:	83 ec 0c             	sub    $0xc,%esp
80105182:	ff 73 08             	pushl  0x8(%ebx)
80105185:	e8 d6 db ff ff       	call   80102d60 <kfree>
    np->kstack = 0;
8010518a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80105191:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80105198:	83 c4 10             	add    $0x10,%esp
8010519b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051a0:	eb c9                	jmp    8010516b <fork+0xdb>
801051a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <scheduler>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
801051b6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801051b9:	e8 92 fc ff ff       	call   80104e50 <mycpu>
801051be:	8d 78 04             	lea    0x4(%eax),%edi
801051c1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801051c3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801051ca:	00 00 00 
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801051d0:	fb                   	sti    
    acquire(&ptable.lock);
801051d1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051d4:	bb 14 b9 15 80       	mov    $0x8015b914,%ebx
    acquire(&ptable.lock);
801051d9:	68 e0 b8 15 80       	push   $0x8015b8e0
801051de:	e8 fd 07 00 00       	call   801059e0 <acquire>
801051e3:	83 c4 10             	add    $0x10,%esp
801051e6:	8d 76 00             	lea    0x0(%esi),%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801051f0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801051f4:	75 33                	jne    80105229 <scheduler+0x79>
      switchuvm(p);
801051f6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801051f9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801051ff:	53                   	push   %ebx
80105200:	e8 0b 34 00 00       	call   80108610 <switchuvm>
      swtch(&(c->scheduler), p->context);
80105205:	58                   	pop    %eax
80105206:	5a                   	pop    %edx
80105207:	ff 73 1c             	pushl  0x1c(%ebx)
8010520a:	57                   	push   %edi
      p->state = RUNNING;
8010520b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80105212:	e8 84 0b 00 00       	call   80105d9b <swtch>
      switchkvm();
80105217:	e8 d4 33 00 00       	call   801085f0 <switchkvm>
      c->proc = 0;
8010521c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80105223:	00 00 00 
80105226:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105229:	83 c3 7c             	add    $0x7c,%ebx
8010522c:	81 fb 14 d8 15 80    	cmp    $0x8015d814,%ebx
80105232:	72 bc                	jb     801051f0 <scheduler+0x40>
    release(&ptable.lock);
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	68 e0 b8 15 80       	push   $0x8015b8e0
8010523c:	e8 bf 08 00 00       	call   80105b00 <release>
    sti();
80105241:	83 c4 10             	add    $0x10,%esp
80105244:	eb 8a                	jmp    801051d0 <scheduler+0x20>
80105246:	8d 76 00             	lea    0x0(%esi),%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sched>:
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	56                   	push   %esi
80105254:	53                   	push   %ebx
  pushcli();
80105255:	e8 46 07 00 00       	call   801059a0 <pushcli>
  c = mycpu();
8010525a:	e8 f1 fb ff ff       	call   80104e50 <mycpu>
  p = c->proc;
8010525f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105265:	e8 36 08 00 00       	call   80105aa0 <popcli>
  if(!holding(&ptable.lock))
8010526a:	83 ec 0c             	sub    $0xc,%esp
8010526d:	68 e0 b8 15 80       	push   $0x8015b8e0
80105272:	e8 e9 06 00 00       	call   80105960 <holding>
80105277:	83 c4 10             	add    $0x10,%esp
8010527a:	85 c0                	test   %eax,%eax
8010527c:	74 4f                	je     801052cd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010527e:	e8 cd fb ff ff       	call   80104e50 <mycpu>
80105283:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010528a:	75 68                	jne    801052f4 <sched+0xa4>
  if(p->state == RUNNING)
8010528c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80105290:	74 55                	je     801052e7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105292:	9c                   	pushf  
80105293:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105294:	f6 c4 02             	test   $0x2,%ah
80105297:	75 41                	jne    801052da <sched+0x8a>
  intena = mycpu()->intena;
80105299:	e8 b2 fb ff ff       	call   80104e50 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010529e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801052a1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801052a7:	e8 a4 fb ff ff       	call   80104e50 <mycpu>
801052ac:	83 ec 08             	sub    $0x8,%esp
801052af:	ff 70 04             	pushl  0x4(%eax)
801052b2:	53                   	push   %ebx
801052b3:	e8 e3 0a 00 00       	call   80105d9b <swtch>
  mycpu()->intena = intena;
801052b8:	e8 93 fb ff ff       	call   80104e50 <mycpu>
}
801052bd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801052c0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801052c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052c9:	5b                   	pop    %ebx
801052ca:	5e                   	pop    %esi
801052cb:	5d                   	pop    %ebp
801052cc:	c3                   	ret    
    panic("sched ptable.lock");
801052cd:	83 ec 0c             	sub    $0xc,%esp
801052d0:	68 c4 96 10 80       	push   $0x801096c4
801052d5:	e8 96 b6 ff ff       	call   80100970 <panic>
    panic("sched interruptible");
801052da:	83 ec 0c             	sub    $0xc,%esp
801052dd:	68 f0 96 10 80       	push   $0x801096f0
801052e2:	e8 89 b6 ff ff       	call   80100970 <panic>
    panic("sched running");
801052e7:	83 ec 0c             	sub    $0xc,%esp
801052ea:	68 e2 96 10 80       	push   $0x801096e2
801052ef:	e8 7c b6 ff ff       	call   80100970 <panic>
    panic("sched locks");
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	68 d6 96 10 80       	push   $0x801096d6
801052fc:	e8 6f b6 ff ff       	call   80100970 <panic>
80105301:	eb 0d                	jmp    80105310 <exit>
80105303:	90                   	nop
80105304:	90                   	nop
80105305:	90                   	nop
80105306:	90                   	nop
80105307:	90                   	nop
80105308:	90                   	nop
80105309:	90                   	nop
8010530a:	90                   	nop
8010530b:	90                   	nop
8010530c:	90                   	nop
8010530d:	90                   	nop
8010530e:	90                   	nop
8010530f:	90                   	nop

80105310 <exit>:
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
80105315:	53                   	push   %ebx
80105316:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80105319:	e8 82 06 00 00       	call   801059a0 <pushcli>
  c = mycpu();
8010531e:	e8 2d fb ff ff       	call   80104e50 <mycpu>
  p = c->proc;
80105323:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105329:	e8 72 07 00 00       	call   80105aa0 <popcli>
  if(curproc == initproc)
8010532e:	39 35 e0 2d 15 80    	cmp    %esi,0x80152de0
80105334:	8d 5e 28             	lea    0x28(%esi),%ebx
80105337:	8d 7e 68             	lea    0x68(%esi),%edi
8010533a:	0f 84 e7 00 00 00    	je     80105427 <exit+0x117>
    if(curproc->ofile[fd]){
80105340:	8b 03                	mov    (%ebx),%eax
80105342:	85 c0                	test   %eax,%eax
80105344:	74 12                	je     80105358 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80105346:	83 ec 0c             	sub    $0xc,%esp
80105349:	50                   	push   %eax
8010534a:	e8 b1 c4 ff ff       	call   80101800 <fileclose>
      curproc->ofile[fd] = 0;
8010534f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80105355:	83 c4 10             	add    $0x10,%esp
80105358:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010535b:	39 fb                	cmp    %edi,%ebx
8010535d:	75 e1                	jne    80105340 <exit+0x30>
  begin_op();
8010535f:	e8 8c e2 ff ff       	call   801035f0 <begin_op>
  iput(curproc->cwd);
80105364:	83 ec 0c             	sub    $0xc,%esp
80105367:	ff 76 68             	pushl  0x68(%esi)
8010536a:	e8 91 ce ff ff       	call   80102200 <iput>
  end_op();
8010536f:	e8 ec e2 ff ff       	call   80103660 <end_op>
  curproc->cwd = 0;
80105374:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010537b:	c7 04 24 e0 b8 15 80 	movl   $0x8015b8e0,(%esp)
80105382:	e8 59 06 00 00       	call   801059e0 <acquire>
  wakeup1(curproc->parent);
80105387:	8b 56 14             	mov    0x14(%esi),%edx
8010538a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010538d:	b8 14 b9 15 80       	mov    $0x8015b914,%eax
80105392:	eb 0e                	jmp    801053a2 <exit+0x92>
80105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105398:	83 c0 7c             	add    $0x7c,%eax
8010539b:	3d 14 d8 15 80       	cmp    $0x8015d814,%eax
801053a0:	73 1c                	jae    801053be <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
801053a2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801053a6:	75 f0                	jne    80105398 <exit+0x88>
801053a8:	3b 50 20             	cmp    0x20(%eax),%edx
801053ab:	75 eb                	jne    80105398 <exit+0x88>
      p->state = RUNNABLE;
801053ad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053b4:	83 c0 7c             	add    $0x7c,%eax
801053b7:	3d 14 d8 15 80       	cmp    $0x8015d814,%eax
801053bc:	72 e4                	jb     801053a2 <exit+0x92>
      p->parent = initproc;
801053be:	8b 0d e0 2d 15 80    	mov    0x80152de0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053c4:	ba 14 b9 15 80       	mov    $0x8015b914,%edx
801053c9:	eb 10                	jmp    801053db <exit+0xcb>
801053cb:	90                   	nop
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053d0:	83 c2 7c             	add    $0x7c,%edx
801053d3:	81 fa 14 d8 15 80    	cmp    $0x8015d814,%edx
801053d9:	73 33                	jae    8010540e <exit+0xfe>
    if(p->parent == curproc){
801053db:	39 72 14             	cmp    %esi,0x14(%edx)
801053de:	75 f0                	jne    801053d0 <exit+0xc0>
      if(p->state == ZOMBIE)
801053e0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801053e4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801053e7:	75 e7                	jne    801053d0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801053e9:	b8 14 b9 15 80       	mov    $0x8015b914,%eax
801053ee:	eb 0a                	jmp    801053fa <exit+0xea>
801053f0:	83 c0 7c             	add    $0x7c,%eax
801053f3:	3d 14 d8 15 80       	cmp    $0x8015d814,%eax
801053f8:	73 d6                	jae    801053d0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801053fa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801053fe:	75 f0                	jne    801053f0 <exit+0xe0>
80105400:	3b 48 20             	cmp    0x20(%eax),%ecx
80105403:	75 eb                	jne    801053f0 <exit+0xe0>
      p->state = RUNNABLE;
80105405:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010540c:	eb e2                	jmp    801053f0 <exit+0xe0>
  curproc->state = ZOMBIE;
8010540e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80105415:	e8 36 fe ff ff       	call   80105250 <sched>
  panic("zombie exit");
8010541a:	83 ec 0c             	sub    $0xc,%esp
8010541d:	68 11 97 10 80       	push   $0x80109711
80105422:	e8 49 b5 ff ff       	call   80100970 <panic>
    panic("init exiting");
80105427:	83 ec 0c             	sub    $0xc,%esp
8010542a:	68 04 97 10 80       	push   $0x80109704
8010542f:	e8 3c b5 ff ff       	call   80100970 <panic>
80105434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010543a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105440 <yield>:
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	53                   	push   %ebx
80105444:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105447:	68 e0 b8 15 80       	push   $0x8015b8e0
8010544c:	e8 8f 05 00 00       	call   801059e0 <acquire>
  pushcli();
80105451:	e8 4a 05 00 00       	call   801059a0 <pushcli>
  c = mycpu();
80105456:	e8 f5 f9 ff ff       	call   80104e50 <mycpu>
  p = c->proc;
8010545b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105461:	e8 3a 06 00 00       	call   80105aa0 <popcli>
  myproc()->state = RUNNABLE;
80105466:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010546d:	e8 de fd ff ff       	call   80105250 <sched>
  release(&ptable.lock);
80105472:	c7 04 24 e0 b8 15 80 	movl   $0x8015b8e0,(%esp)
80105479:	e8 82 06 00 00       	call   80105b00 <release>
}
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105484:	c9                   	leave  
80105485:	c3                   	ret    
80105486:	8d 76 00             	lea    0x0(%esi),%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sleep>:
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
80105495:	53                   	push   %ebx
80105496:	83 ec 0c             	sub    $0xc,%esp
80105499:	8b 7d 08             	mov    0x8(%ebp),%edi
8010549c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010549f:	e8 fc 04 00 00       	call   801059a0 <pushcli>
  c = mycpu();
801054a4:	e8 a7 f9 ff ff       	call   80104e50 <mycpu>
  p = c->proc;
801054a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801054af:	e8 ec 05 00 00       	call   80105aa0 <popcli>
  if(p == 0)
801054b4:	85 db                	test   %ebx,%ebx
801054b6:	0f 84 87 00 00 00    	je     80105543 <sleep+0xb3>
  if(lk == 0)
801054bc:	85 f6                	test   %esi,%esi
801054be:	74 76                	je     80105536 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801054c0:	81 fe e0 b8 15 80    	cmp    $0x8015b8e0,%esi
801054c6:	74 50                	je     80105518 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801054c8:	83 ec 0c             	sub    $0xc,%esp
801054cb:	68 e0 b8 15 80       	push   $0x8015b8e0
801054d0:	e8 0b 05 00 00       	call   801059e0 <acquire>
    release(lk);
801054d5:	89 34 24             	mov    %esi,(%esp)
801054d8:	e8 23 06 00 00       	call   80105b00 <release>
  p->chan = chan;
801054dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801054e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801054e7:	e8 64 fd ff ff       	call   80105250 <sched>
  p->chan = 0;
801054ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801054f3:	c7 04 24 e0 b8 15 80 	movl   $0x8015b8e0,(%esp)
801054fa:	e8 01 06 00 00       	call   80105b00 <release>
    acquire(lk);
801054ff:	89 75 08             	mov    %esi,0x8(%ebp)
80105502:	83 c4 10             	add    $0x10,%esp
}
80105505:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105508:	5b                   	pop    %ebx
80105509:	5e                   	pop    %esi
8010550a:	5f                   	pop    %edi
8010550b:	5d                   	pop    %ebp
    acquire(lk);
8010550c:	e9 cf 04 00 00       	jmp    801059e0 <acquire>
80105511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80105518:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010551b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80105522:	e8 29 fd ff ff       	call   80105250 <sched>
  p->chan = 0;
80105527:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010552e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105531:	5b                   	pop    %ebx
80105532:	5e                   	pop    %esi
80105533:	5f                   	pop    %edi
80105534:	5d                   	pop    %ebp
80105535:	c3                   	ret    
    panic("sleep without lk");
80105536:	83 ec 0c             	sub    $0xc,%esp
80105539:	68 23 97 10 80       	push   $0x80109723
8010553e:	e8 2d b4 ff ff       	call   80100970 <panic>
    panic("sleep");
80105543:	83 ec 0c             	sub    $0xc,%esp
80105546:	68 1d 97 10 80       	push   $0x8010971d
8010554b:	e8 20 b4 ff ff       	call   80100970 <panic>

80105550 <wait>:
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	56                   	push   %esi
80105554:	53                   	push   %ebx
  pushcli();
80105555:	e8 46 04 00 00       	call   801059a0 <pushcli>
  c = mycpu();
8010555a:	e8 f1 f8 ff ff       	call   80104e50 <mycpu>
  p = c->proc;
8010555f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105565:	e8 36 05 00 00       	call   80105aa0 <popcli>
  acquire(&ptable.lock);
8010556a:	83 ec 0c             	sub    $0xc,%esp
8010556d:	68 e0 b8 15 80       	push   $0x8015b8e0
80105572:	e8 69 04 00 00       	call   801059e0 <acquire>
80105577:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010557a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010557c:	bb 14 b9 15 80       	mov    $0x8015b914,%ebx
80105581:	eb 10                	jmp    80105593 <wait+0x43>
80105583:	90                   	nop
80105584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105588:	83 c3 7c             	add    $0x7c,%ebx
8010558b:	81 fb 14 d8 15 80    	cmp    $0x8015d814,%ebx
80105591:	73 1b                	jae    801055ae <wait+0x5e>
      if(p->parent != curproc)
80105593:	39 73 14             	cmp    %esi,0x14(%ebx)
80105596:	75 f0                	jne    80105588 <wait+0x38>
      if(p->state == ZOMBIE){
80105598:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010559c:	74 32                	je     801055d0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010559e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801055a1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801055a6:	81 fb 14 d8 15 80    	cmp    $0x8015d814,%ebx
801055ac:	72 e5                	jb     80105593 <wait+0x43>
    if(!havekids || curproc->killed){
801055ae:	85 c0                	test   %eax,%eax
801055b0:	74 74                	je     80105626 <wait+0xd6>
801055b2:	8b 46 24             	mov    0x24(%esi),%eax
801055b5:	85 c0                	test   %eax,%eax
801055b7:	75 6d                	jne    80105626 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801055b9:	83 ec 08             	sub    $0x8,%esp
801055bc:	68 e0 b8 15 80       	push   $0x8015b8e0
801055c1:	56                   	push   %esi
801055c2:	e8 c9 fe ff ff       	call   80105490 <sleep>
    havekids = 0;
801055c7:	83 c4 10             	add    $0x10,%esp
801055ca:	eb ae                	jmp    8010557a <wait+0x2a>
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801055d6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801055d9:	e8 82 d7 ff ff       	call   80102d60 <kfree>
        freevm(p->pgdir);
801055de:	5a                   	pop    %edx
801055df:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801055e2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801055e9:	e8 d2 33 00 00       	call   801089c0 <freevm>
        release(&ptable.lock);
801055ee:	c7 04 24 e0 b8 15 80 	movl   $0x8015b8e0,(%esp)
        p->pid = 0;
801055f5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801055fc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80105603:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80105607:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010560e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80105615:	e8 e6 04 00 00       	call   80105b00 <release>
        return pid;
8010561a:	83 c4 10             	add    $0x10,%esp
}
8010561d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105620:	89 f0                	mov    %esi,%eax
80105622:	5b                   	pop    %ebx
80105623:	5e                   	pop    %esi
80105624:	5d                   	pop    %ebp
80105625:	c3                   	ret    
      release(&ptable.lock);
80105626:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80105629:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010562e:	68 e0 b8 15 80       	push   $0x8015b8e0
80105633:	e8 c8 04 00 00       	call   80105b00 <release>
      return -1;
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	eb e0                	jmp    8010561d <wait+0xcd>
8010563d:	8d 76 00             	lea    0x0(%esi),%esi

80105640 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	53                   	push   %ebx
80105644:	83 ec 10             	sub    $0x10,%esp
80105647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010564a:	68 e0 b8 15 80       	push   $0x8015b8e0
8010564f:	e8 8c 03 00 00       	call   801059e0 <acquire>
80105654:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105657:	b8 14 b9 15 80       	mov    $0x8015b914,%eax
8010565c:	eb 0c                	jmp    8010566a <wakeup+0x2a>
8010565e:	66 90                	xchg   %ax,%ax
80105660:	83 c0 7c             	add    $0x7c,%eax
80105663:	3d 14 d8 15 80       	cmp    $0x8015d814,%eax
80105668:	73 1c                	jae    80105686 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010566a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010566e:	75 f0                	jne    80105660 <wakeup+0x20>
80105670:	3b 58 20             	cmp    0x20(%eax),%ebx
80105673:	75 eb                	jne    80105660 <wakeup+0x20>
      p->state = RUNNABLE;
80105675:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010567c:	83 c0 7c             	add    $0x7c,%eax
8010567f:	3d 14 d8 15 80       	cmp    $0x8015d814,%eax
80105684:	72 e4                	jb     8010566a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80105686:	c7 45 08 e0 b8 15 80 	movl   $0x8015b8e0,0x8(%ebp)
}
8010568d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105690:	c9                   	leave  
  release(&ptable.lock);
80105691:	e9 6a 04 00 00       	jmp    80105b00 <release>
80105696:	8d 76 00             	lea    0x0(%esi),%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	53                   	push   %ebx
801056a4:	83 ec 10             	sub    $0x10,%esp
801056a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801056aa:	68 e0 b8 15 80       	push   $0x8015b8e0
801056af:	e8 2c 03 00 00       	call   801059e0 <acquire>
801056b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801056b7:	b8 14 b9 15 80       	mov    $0x8015b914,%eax
801056bc:	eb 0c                	jmp    801056ca <kill+0x2a>
801056be:	66 90                	xchg   %ax,%ax
801056c0:	83 c0 7c             	add    $0x7c,%eax
801056c3:	3d 14 d8 15 80       	cmp    $0x8015d814,%eax
801056c8:	73 36                	jae    80105700 <kill+0x60>
    if(p->pid == pid){
801056ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801056cd:	75 f1                	jne    801056c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801056cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801056d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801056da:	75 07                	jne    801056e3 <kill+0x43>
        p->state = RUNNABLE;
801056dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801056e3:	83 ec 0c             	sub    $0xc,%esp
801056e6:	68 e0 b8 15 80       	push   $0x8015b8e0
801056eb:	e8 10 04 00 00       	call   80105b00 <release>
      return 0;
801056f0:	83 c4 10             	add    $0x10,%esp
801056f3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801056f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056f8:	c9                   	leave  
801056f9:	c3                   	ret    
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	68 e0 b8 15 80       	push   $0x8015b8e0
80105708:	e8 f3 03 00 00       	call   80105b00 <release>
  return -1;
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105718:	c9                   	leave  
80105719:	c3                   	ret    
8010571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105720 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	57                   	push   %edi
80105724:	56                   	push   %esi
80105725:	53                   	push   %ebx
80105726:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105729:	bb 14 b9 15 80       	mov    $0x8015b914,%ebx
{
8010572e:	83 ec 3c             	sub    $0x3c,%esp
80105731:	eb 24                	jmp    80105757 <procdump+0x37>
80105733:	90                   	nop
80105734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105738:	83 ec 0c             	sub    $0xc,%esp
8010573b:	68 57 9c 10 80       	push   $0x80109c57
80105740:	e8 fb b4 ff ff       	call   80100c40 <cprintf>
80105745:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105748:	83 c3 7c             	add    $0x7c,%ebx
8010574b:	81 fb 14 d8 15 80    	cmp    $0x8015d814,%ebx
80105751:	0f 83 81 00 00 00    	jae    801057d8 <procdump+0xb8>
    if(p->state == UNUSED)
80105757:	8b 43 0c             	mov    0xc(%ebx),%eax
8010575a:	85 c0                	test   %eax,%eax
8010575c:	74 ea                	je     80105748 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010575e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80105761:	ba 34 97 10 80       	mov    $0x80109734,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105766:	77 11                	ja     80105779 <procdump+0x59>
80105768:	8b 14 85 94 97 10 80 	mov    -0x7fef686c(,%eax,4),%edx
      state = "???";
8010576f:	b8 34 97 10 80       	mov    $0x80109734,%eax
80105774:	85 d2                	test   %edx,%edx
80105776:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80105779:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010577c:	50                   	push   %eax
8010577d:	52                   	push   %edx
8010577e:	ff 73 10             	pushl  0x10(%ebx)
80105781:	68 38 97 10 80       	push   $0x80109738
80105786:	e8 b5 b4 ff ff       	call   80100c40 <cprintf>
    if(p->state == SLEEPING){
8010578b:	83 c4 10             	add    $0x10,%esp
8010578e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80105792:	75 a4                	jne    80105738 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105794:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105797:	83 ec 08             	sub    $0x8,%esp
8010579a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010579d:	50                   	push   %eax
8010579e:	8b 43 1c             	mov    0x1c(%ebx),%eax
801057a1:	8b 40 0c             	mov    0xc(%eax),%eax
801057a4:	83 c0 08             	add    $0x8,%eax
801057a7:	50                   	push   %eax
801057a8:	e8 63 01 00 00       	call   80105910 <getcallerpcs>
801057ad:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801057b0:	8b 17                	mov    (%edi),%edx
801057b2:	85 d2                	test   %edx,%edx
801057b4:	74 82                	je     80105738 <procdump+0x18>
        cprintf(" %p", pc[i]);
801057b6:	83 ec 08             	sub    $0x8,%esp
801057b9:	83 c7 04             	add    $0x4,%edi
801057bc:	52                   	push   %edx
801057bd:	68 bc 8e 10 80       	push   $0x80108ebc
801057c2:	e8 79 b4 ff ff       	call   80100c40 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801057c7:	83 c4 10             	add    $0x10,%esp
801057ca:	39 fe                	cmp    %edi,%esi
801057cc:	75 e2                	jne    801057b0 <procdump+0x90>
801057ce:	e9 65 ff ff ff       	jmp    80105738 <procdump+0x18>
801057d3:	90                   	nop
801057d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801057d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057db:	5b                   	pop    %ebx
801057dc:	5e                   	pop    %esi
801057dd:	5f                   	pop    %edi
801057de:	5d                   	pop    %ebp
801057df:	c3                   	ret    

801057e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	53                   	push   %ebx
801057e4:	83 ec 0c             	sub    $0xc,%esp
801057e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801057ea:	68 ac 97 10 80       	push   $0x801097ac
801057ef:	8d 43 04             	lea    0x4(%ebx),%eax
801057f2:	50                   	push   %eax
801057f3:	e8 f8 00 00 00       	call   801058f0 <initlock>
  lk->name = name;
801057f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801057fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105801:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105804:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010580b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010580e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105811:	c9                   	leave  
80105812:	c3                   	ret    
80105813:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105820 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	56                   	push   %esi
80105824:	53                   	push   %ebx
80105825:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	8d 73 04             	lea    0x4(%ebx),%esi
8010582e:	56                   	push   %esi
8010582f:	e8 ac 01 00 00       	call   801059e0 <acquire>
  while (lk->locked) {
80105834:	8b 13                	mov    (%ebx),%edx
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	85 d2                	test   %edx,%edx
8010583b:	74 16                	je     80105853 <acquiresleep+0x33>
8010583d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105840:	83 ec 08             	sub    $0x8,%esp
80105843:	56                   	push   %esi
80105844:	53                   	push   %ebx
80105845:	e8 46 fc ff ff       	call   80105490 <sleep>
  while (lk->locked) {
8010584a:	8b 03                	mov    (%ebx),%eax
8010584c:	83 c4 10             	add    $0x10,%esp
8010584f:	85 c0                	test   %eax,%eax
80105851:	75 ed                	jne    80105840 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105853:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105859:	e8 92 f6 ff ff       	call   80104ef0 <myproc>
8010585e:	8b 40 10             	mov    0x10(%eax),%eax
80105861:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105864:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105867:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010586a:	5b                   	pop    %ebx
8010586b:	5e                   	pop    %esi
8010586c:	5d                   	pop    %ebp
  release(&lk->lk);
8010586d:	e9 8e 02 00 00       	jmp    80105b00 <release>
80105872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105880 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	56                   	push   %esi
80105884:	53                   	push   %ebx
80105885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105888:	83 ec 0c             	sub    $0xc,%esp
8010588b:	8d 73 04             	lea    0x4(%ebx),%esi
8010588e:	56                   	push   %esi
8010588f:	e8 4c 01 00 00       	call   801059e0 <acquire>
  lk->locked = 0;
80105894:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010589a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801058a1:	89 1c 24             	mov    %ebx,(%esp)
801058a4:	e8 97 fd ff ff       	call   80105640 <wakeup>
  release(&lk->lk);
801058a9:	89 75 08             	mov    %esi,0x8(%ebp)
801058ac:	83 c4 10             	add    $0x10,%esp
}
801058af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058b2:	5b                   	pop    %ebx
801058b3:	5e                   	pop    %esi
801058b4:	5d                   	pop    %ebp
  release(&lk->lk);
801058b5:	e9 46 02 00 00       	jmp    80105b00 <release>
801058ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	56                   	push   %esi
801058c4:	53                   	push   %ebx
801058c5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	8d 5e 04             	lea    0x4(%esi),%ebx
801058ce:	53                   	push   %ebx
801058cf:	e8 0c 01 00 00       	call   801059e0 <acquire>
  r = lk->locked;
801058d4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801058d6:	89 1c 24             	mov    %ebx,(%esp)
801058d9:	e8 22 02 00 00       	call   80105b00 <release>
  return r;
}
801058de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058e1:	89 f0                	mov    %esi,%eax
801058e3:	5b                   	pop    %ebx
801058e4:	5e                   	pop    %esi
801058e5:	5d                   	pop    %ebp
801058e6:	c3                   	ret    
801058e7:	66 90                	xchg   %ax,%ax
801058e9:	66 90                	xchg   %ax,%ax
801058eb:	66 90                	xchg   %ax,%ax
801058ed:	66 90                	xchg   %ax,%ax
801058ef:	90                   	nop

801058f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801058f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801058f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801058ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105902:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105909:	5d                   	pop    %ebp
8010590a:	c3                   	ret    
8010590b:	90                   	nop
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105910:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105911:	31 d2                	xor    %edx,%edx
{
80105913:	89 e5                	mov    %esp,%ebp
80105915:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105916:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105919:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010591c:	83 e8 08             	sub    $0x8,%eax
8010591f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105920:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105926:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010592c:	77 1a                	ja     80105948 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010592e:	8b 58 04             	mov    0x4(%eax),%ebx
80105931:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105934:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105937:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105939:	83 fa 0a             	cmp    $0xa,%edx
8010593c:	75 e2                	jne    80105920 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010593e:	5b                   	pop    %ebx
8010593f:	5d                   	pop    %ebp
80105940:	c3                   	ret    
80105941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105948:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010594b:	83 c1 28             	add    $0x28,%ecx
8010594e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105950:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105956:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105959:	39 c1                	cmp    %eax,%ecx
8010595b:	75 f3                	jne    80105950 <getcallerpcs+0x40>
}
8010595d:	5b                   	pop    %ebx
8010595e:	5d                   	pop    %ebp
8010595f:	c3                   	ret    

80105960 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	53                   	push   %ebx
80105964:	83 ec 04             	sub    $0x4,%esp
80105967:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010596a:	8b 02                	mov    (%edx),%eax
8010596c:	85 c0                	test   %eax,%eax
8010596e:	75 10                	jne    80105980 <holding+0x20>
}
80105970:	83 c4 04             	add    $0x4,%esp
80105973:	31 c0                	xor    %eax,%eax
80105975:	5b                   	pop    %ebx
80105976:	5d                   	pop    %ebp
80105977:	c3                   	ret    
80105978:	90                   	nop
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80105980:	8b 5a 08             	mov    0x8(%edx),%ebx
80105983:	e8 c8 f4 ff ff       	call   80104e50 <mycpu>
80105988:	39 c3                	cmp    %eax,%ebx
8010598a:	0f 94 c0             	sete   %al
}
8010598d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80105990:	0f b6 c0             	movzbl %al,%eax
}
80105993:	5b                   	pop    %ebx
80105994:	5d                   	pop    %ebp
80105995:	c3                   	ret    
80105996:	8d 76 00             	lea    0x0(%esi),%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	53                   	push   %ebx
801059a4:	83 ec 04             	sub    $0x4,%esp
801059a7:	9c                   	pushf  
801059a8:	5b                   	pop    %ebx
  asm volatile("cli");
801059a9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801059aa:	e8 a1 f4 ff ff       	call   80104e50 <mycpu>
801059af:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801059b5:	85 c0                	test   %eax,%eax
801059b7:	75 11                	jne    801059ca <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801059b9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801059bf:	e8 8c f4 ff ff       	call   80104e50 <mycpu>
801059c4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801059ca:	e8 81 f4 ff ff       	call   80104e50 <mycpu>
801059cf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801059d6:	83 c4 04             	add    $0x4,%esp
801059d9:	5b                   	pop    %ebx
801059da:	5d                   	pop    %ebp
801059db:	c3                   	ret    
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059e0 <acquire>:
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	56                   	push   %esi
801059e4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801059e5:	e8 b6 ff ff ff       	call   801059a0 <pushcli>
  if(holding(lk))
801059ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801059ed:	8b 03                	mov    (%ebx),%eax
801059ef:	85 c0                	test   %eax,%eax
801059f1:	0f 85 81 00 00 00    	jne    80105a78 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801059f7:	ba 01 00 00 00       	mov    $0x1,%edx
801059fc:	eb 05                	jmp    80105a03 <acquire+0x23>
801059fe:	66 90                	xchg   %ax,%ax
80105a00:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105a03:	89 d0                	mov    %edx,%eax
80105a05:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105a08:	85 c0                	test   %eax,%eax
80105a0a:	75 f4                	jne    80105a00 <acquire+0x20>
  __sync_synchronize();
80105a0c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105a11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105a14:	e8 37 f4 ff ff       	call   80104e50 <mycpu>
  for(i = 0; i < 10; i++){
80105a19:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
80105a1b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
80105a1e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80105a21:	89 e8                	mov    %ebp,%eax
80105a23:	90                   	nop
80105a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105a28:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105a2e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105a34:	77 1a                	ja     80105a50 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80105a36:	8b 58 04             	mov    0x4(%eax),%ebx
80105a39:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105a3c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105a3f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105a41:	83 fa 0a             	cmp    $0xa,%edx
80105a44:	75 e2                	jne    80105a28 <acquire+0x48>
}
80105a46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a49:	5b                   	pop    %ebx
80105a4a:	5e                   	pop    %esi
80105a4b:	5d                   	pop    %ebp
80105a4c:	c3                   	ret    
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi
80105a50:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105a53:	83 c1 28             	add    $0x28,%ecx
80105a56:	8d 76 00             	lea    0x0(%esi),%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105a66:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105a69:	39 c8                	cmp    %ecx,%eax
80105a6b:	75 f3                	jne    80105a60 <acquire+0x80>
}
80105a6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a70:	5b                   	pop    %ebx
80105a71:	5e                   	pop    %esi
80105a72:	5d                   	pop    %ebp
80105a73:	c3                   	ret    
80105a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80105a78:	8b 73 08             	mov    0x8(%ebx),%esi
80105a7b:	e8 d0 f3 ff ff       	call   80104e50 <mycpu>
80105a80:	39 c6                	cmp    %eax,%esi
80105a82:	0f 85 6f ff ff ff    	jne    801059f7 <acquire+0x17>
    panic("acquire");
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	68 b7 97 10 80       	push   $0x801097b7
80105a90:	e8 db ae ff ff       	call   80100970 <panic>
80105a95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105aa0 <popcli>:

void
popcli(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105aa6:	9c                   	pushf  
80105aa7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105aa8:	f6 c4 02             	test   $0x2,%ah
80105aab:	75 35                	jne    80105ae2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105aad:	e8 9e f3 ff ff       	call   80104e50 <mycpu>
80105ab2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105ab9:	78 34                	js     80105aef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105abb:	e8 90 f3 ff ff       	call   80104e50 <mycpu>
80105ac0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105ac6:	85 d2                	test   %edx,%edx
80105ac8:	74 06                	je     80105ad0 <popcli+0x30>
    sti();
}
80105aca:	c9                   	leave  
80105acb:	c3                   	ret    
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105ad0:	e8 7b f3 ff ff       	call   80104e50 <mycpu>
80105ad5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105adb:	85 c0                	test   %eax,%eax
80105add:	74 eb                	je     80105aca <popcli+0x2a>
  asm volatile("sti");
80105adf:	fb                   	sti    
}
80105ae0:	c9                   	leave  
80105ae1:	c3                   	ret    
    panic("popcli - interruptible");
80105ae2:	83 ec 0c             	sub    $0xc,%esp
80105ae5:	68 bf 97 10 80       	push   $0x801097bf
80105aea:	e8 81 ae ff ff       	call   80100970 <panic>
    panic("popcli");
80105aef:	83 ec 0c             	sub    $0xc,%esp
80105af2:	68 d6 97 10 80       	push   $0x801097d6
80105af7:	e8 74 ae ff ff       	call   80100970 <panic>
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b00 <release>:
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	56                   	push   %esi
80105b04:	53                   	push   %ebx
80105b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80105b08:	8b 03                	mov    (%ebx),%eax
80105b0a:	85 c0                	test   %eax,%eax
80105b0c:	74 0c                	je     80105b1a <release+0x1a>
80105b0e:	8b 73 08             	mov    0x8(%ebx),%esi
80105b11:	e8 3a f3 ff ff       	call   80104e50 <mycpu>
80105b16:	39 c6                	cmp    %eax,%esi
80105b18:	74 16                	je     80105b30 <release+0x30>
    panic("release");
80105b1a:	83 ec 0c             	sub    $0xc,%esp
80105b1d:	68 dd 97 10 80       	push   $0x801097dd
80105b22:	e8 49 ae ff ff       	call   80100970 <panic>
80105b27:	89 f6                	mov    %esi,%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80105b30:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105b37:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105b3e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105b43:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105b49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b4c:	5b                   	pop    %ebx
80105b4d:	5e                   	pop    %esi
80105b4e:	5d                   	pop    %ebp
  popcli();
80105b4f:	e9 4c ff ff ff       	jmp    80105aa0 <popcli>
80105b54:	66 90                	xchg   %ax,%ax
80105b56:	66 90                	xchg   %ax,%ax
80105b58:	66 90                	xchg   %ax,%ax
80105b5a:	66 90                	xchg   %ax,%ax
80105b5c:	66 90                	xchg   %ax,%ax
80105b5e:	66 90                	xchg   %ax,%ax

80105b60 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	53                   	push   %ebx
80105b65:	8b 55 08             	mov    0x8(%ebp),%edx
80105b68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80105b6b:	f6 c2 03             	test   $0x3,%dl
80105b6e:	75 05                	jne    80105b75 <memset+0x15>
80105b70:	f6 c1 03             	test   $0x3,%cl
80105b73:	74 13                	je     80105b88 <memset+0x28>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
}
static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80105b75:	89 d7                	mov    %edx,%edi
80105b77:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b7a:	fc                   	cld    
80105b7b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80105b7d:	5b                   	pop    %ebx
80105b7e:	89 d0                	mov    %edx,%eax
80105b80:	5f                   	pop    %edi
80105b81:	5d                   	pop    %ebp
80105b82:	c3                   	ret    
80105b83:	90                   	nop
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105b88:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105b8c:	c1 e9 02             	shr    $0x2,%ecx
80105b8f:	89 f8                	mov    %edi,%eax
80105b91:	89 fb                	mov    %edi,%ebx
80105b93:	c1 e0 18             	shl    $0x18,%eax
80105b96:	c1 e3 10             	shl    $0x10,%ebx
80105b99:	09 d8                	or     %ebx,%eax
80105b9b:	09 f8                	or     %edi,%eax
80105b9d:	c1 e7 08             	shl    $0x8,%edi
80105ba0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80105ba2:	89 d7                	mov    %edx,%edi
80105ba4:	fc                   	cld    
80105ba5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105ba7:	5b                   	pop    %ebx
80105ba8:	89 d0                	mov    %edx,%eax
80105baa:	5f                   	pop    %edi
80105bab:	5d                   	pop    %ebp
80105bac:	c3                   	ret    
80105bad:	8d 76 00             	lea    0x0(%esi),%esi

80105bb0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	57                   	push   %edi
80105bb4:	56                   	push   %esi
80105bb5:	53                   	push   %ebx
80105bb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105bb9:	8b 75 08             	mov    0x8(%ebp),%esi
80105bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105bbf:	85 db                	test   %ebx,%ebx
80105bc1:	74 29                	je     80105bec <memcmp+0x3c>
    if(*s1 != *s2)
80105bc3:	0f b6 16             	movzbl (%esi),%edx
80105bc6:	0f b6 0f             	movzbl (%edi),%ecx
80105bc9:	38 d1                	cmp    %dl,%cl
80105bcb:	75 2b                	jne    80105bf8 <memcmp+0x48>
80105bcd:	b8 01 00 00 00       	mov    $0x1,%eax
80105bd2:	eb 14                	jmp    80105be8 <memcmp+0x38>
80105bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bd8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80105bdc:	83 c0 01             	add    $0x1,%eax
80105bdf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105be4:	38 ca                	cmp    %cl,%dl
80105be6:	75 10                	jne    80105bf8 <memcmp+0x48>
  while(n-- > 0){
80105be8:	39 d8                	cmp    %ebx,%eax
80105bea:	75 ec                	jne    80105bd8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80105bec:	5b                   	pop    %ebx
  return 0;
80105bed:	31 c0                	xor    %eax,%eax
}
80105bef:	5e                   	pop    %esi
80105bf0:	5f                   	pop    %edi
80105bf1:	5d                   	pop    %ebp
80105bf2:	c3                   	ret    
80105bf3:	90                   	nop
80105bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105bf8:	0f b6 c2             	movzbl %dl,%eax
}
80105bfb:	5b                   	pop    %ebx
      return *s1 - *s2;
80105bfc:	29 c8                	sub    %ecx,%eax
}
80105bfe:	5e                   	pop    %esi
80105bff:	5f                   	pop    %edi
80105c00:	5d                   	pop    %ebp
80105c01:	c3                   	ret    
80105c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c10 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	56                   	push   %esi
80105c14:	53                   	push   %ebx
80105c15:	8b 45 08             	mov    0x8(%ebp),%eax
80105c18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105c1b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105c1e:	39 c3                	cmp    %eax,%ebx
80105c20:	73 26                	jae    80105c48 <memmove+0x38>
80105c22:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105c25:	39 c8                	cmp    %ecx,%eax
80105c27:	73 1f                	jae    80105c48 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105c29:	85 f6                	test   %esi,%esi
80105c2b:	8d 56 ff             	lea    -0x1(%esi),%edx
80105c2e:	74 0f                	je     80105c3f <memmove+0x2f>
      *--d = *--s;
80105c30:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105c34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105c37:	83 ea 01             	sub    $0x1,%edx
80105c3a:	83 fa ff             	cmp    $0xffffffff,%edx
80105c3d:	75 f1                	jne    80105c30 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105c3f:	5b                   	pop    %ebx
80105c40:	5e                   	pop    %esi
80105c41:	5d                   	pop    %ebp
80105c42:	c3                   	ret    
80105c43:	90                   	nop
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105c48:	31 d2                	xor    %edx,%edx
80105c4a:	85 f6                	test   %esi,%esi
80105c4c:	74 f1                	je     80105c3f <memmove+0x2f>
80105c4e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105c50:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105c54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105c57:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80105c5a:	39 d6                	cmp    %edx,%esi
80105c5c:	75 f2                	jne    80105c50 <memmove+0x40>
}
80105c5e:	5b                   	pop    %ebx
80105c5f:	5e                   	pop    %esi
80105c60:	5d                   	pop    %ebp
80105c61:	c3                   	ret    
80105c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105c73:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105c74:	eb 9a                	jmp    80105c10 <memmove>
80105c76:	8d 76 00             	lea    0x0(%esi),%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c80 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	57                   	push   %edi
80105c84:	56                   	push   %esi
80105c85:	8b 7d 10             	mov    0x10(%ebp),%edi
80105c88:	53                   	push   %ebx
80105c89:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80105c8f:	85 ff                	test   %edi,%edi
80105c91:	74 2f                	je     80105cc2 <strncmp+0x42>
80105c93:	0f b6 01             	movzbl (%ecx),%eax
80105c96:	0f b6 1e             	movzbl (%esi),%ebx
80105c99:	84 c0                	test   %al,%al
80105c9b:	74 37                	je     80105cd4 <strncmp+0x54>
80105c9d:	38 c3                	cmp    %al,%bl
80105c9f:	75 33                	jne    80105cd4 <strncmp+0x54>
80105ca1:	01 f7                	add    %esi,%edi
80105ca3:	eb 13                	jmp    80105cb8 <strncmp+0x38>
80105ca5:	8d 76 00             	lea    0x0(%esi),%esi
80105ca8:	0f b6 01             	movzbl (%ecx),%eax
80105cab:	84 c0                	test   %al,%al
80105cad:	74 21                	je     80105cd0 <strncmp+0x50>
80105caf:	0f b6 1a             	movzbl (%edx),%ebx
80105cb2:	89 d6                	mov    %edx,%esi
80105cb4:	38 d8                	cmp    %bl,%al
80105cb6:	75 1c                	jne    80105cd4 <strncmp+0x54>
    n--, p++, q++;
80105cb8:	8d 56 01             	lea    0x1(%esi),%edx
80105cbb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105cbe:	39 fa                	cmp    %edi,%edx
80105cc0:	75 e6                	jne    80105ca8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105cc2:	5b                   	pop    %ebx
    return 0;
80105cc3:	31 c0                	xor    %eax,%eax
}
80105cc5:	5e                   	pop    %esi
80105cc6:	5f                   	pop    %edi
80105cc7:	5d                   	pop    %ebp
80105cc8:	c3                   	ret    
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cd0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105cd4:	29 d8                	sub    %ebx,%eax
}
80105cd6:	5b                   	pop    %ebx
80105cd7:	5e                   	pop    %esi
80105cd8:	5f                   	pop    %edi
80105cd9:	5d                   	pop    %ebp
80105cda:	c3                   	ret    
80105cdb:	90                   	nop
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	56                   	push   %esi
80105ce4:	53                   	push   %ebx
80105ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80105ce8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105ceb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105cee:	89 c2                	mov    %eax,%edx
80105cf0:	eb 19                	jmp    80105d0b <strncpy+0x2b>
80105cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cf8:	83 c3 01             	add    $0x1,%ebx
80105cfb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80105cff:	83 c2 01             	add    $0x1,%edx
80105d02:	84 c9                	test   %cl,%cl
80105d04:	88 4a ff             	mov    %cl,-0x1(%edx)
80105d07:	74 09                	je     80105d12 <strncpy+0x32>
80105d09:	89 f1                	mov    %esi,%ecx
80105d0b:	85 c9                	test   %ecx,%ecx
80105d0d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105d10:	7f e6                	jg     80105cf8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105d12:	31 c9                	xor    %ecx,%ecx
80105d14:	85 f6                	test   %esi,%esi
80105d16:	7e 17                	jle    80105d2f <strncpy+0x4f>
80105d18:	90                   	nop
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105d20:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105d24:	89 f3                	mov    %esi,%ebx
80105d26:	83 c1 01             	add    $0x1,%ecx
80105d29:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80105d2b:	85 db                	test   %ebx,%ebx
80105d2d:	7f f1                	jg     80105d20 <strncpy+0x40>
  return os;
}
80105d2f:	5b                   	pop    %ebx
80105d30:	5e                   	pop    %esi
80105d31:	5d                   	pop    %ebp
80105d32:	c3                   	ret    
80105d33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	56                   	push   %esi
80105d44:	53                   	push   %ebx
80105d45:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105d48:	8b 45 08             	mov    0x8(%ebp),%eax
80105d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80105d4e:	85 c9                	test   %ecx,%ecx
80105d50:	7e 26                	jle    80105d78 <safestrcpy+0x38>
80105d52:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105d56:	89 c1                	mov    %eax,%ecx
80105d58:	eb 17                	jmp    80105d71 <safestrcpy+0x31>
80105d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105d60:	83 c2 01             	add    $0x1,%edx
80105d63:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105d67:	83 c1 01             	add    $0x1,%ecx
80105d6a:	84 db                	test   %bl,%bl
80105d6c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80105d6f:	74 04                	je     80105d75 <safestrcpy+0x35>
80105d71:	39 f2                	cmp    %esi,%edx
80105d73:	75 eb                	jne    80105d60 <safestrcpy+0x20>
    ;
  *s = 0;
80105d75:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105d78:	5b                   	pop    %ebx
80105d79:	5e                   	pop    %esi
80105d7a:	5d                   	pop    %ebp
80105d7b:	c3                   	ret    
80105d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d80 <strlen>:

int
strlen(const char *s)
{
80105d80:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105d81:	31 c0                	xor    %eax,%eax
{
80105d83:	89 e5                	mov    %esp,%ebp
80105d85:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105d88:	80 3a 00             	cmpb   $0x0,(%edx)
80105d8b:	74 0c                	je     80105d99 <strlen+0x19>
80105d8d:	8d 76 00             	lea    0x0(%esi),%esi
80105d90:	83 c0 01             	add    $0x1,%eax
80105d93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105d97:	75 f7                	jne    80105d90 <strlen+0x10>
    ;
  return n;
}
80105d99:	5d                   	pop    %ebp
80105d9a:	c3                   	ret    

80105d9b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105d9b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105d9f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105da3:	55                   	push   %ebp
  pushl %ebx
80105da4:	53                   	push   %ebx
  pushl %esi
80105da5:	56                   	push   %esi
  pushl %edi
80105da6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105da7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105da9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105dab:	5f                   	pop    %edi
  popl %esi
80105dac:	5e                   	pop    %esi
  popl %ebx
80105dad:	5b                   	pop    %ebx
  popl %ebp
80105dae:	5d                   	pop    %ebp
  ret
80105daf:	c3                   	ret    

80105db0 <sys_arp>:

#include "types.h"
#include "defs.h"

int send_arpRequest(char* interface, char* ipAddr, char* arpResp);
int sys_arp(void) {
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 20             	sub    $0x20,%esp
  char *ipAddr, *interface, *arpResp;
  int size;

  if(argstr(0, &interface) < 0 || argstr(1, &ipAddr) < 0 || argint(3, &size) < 0 || argptr(2, &arpResp, size) < 0) {
80105db6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105db9:	50                   	push   %eax
80105dba:	6a 00                	push   $0x0
80105dbc:	e8 0f 02 00 00       	call   80105fd0 <argstr>
80105dc1:	83 c4 10             	add    $0x10,%esp
80105dc4:	85 c0                	test   %eax,%eax
80105dc6:	78 68                	js     80105e30 <sys_arp+0x80>
80105dc8:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105dcb:	83 ec 08             	sub    $0x8,%esp
80105dce:	50                   	push   %eax
80105dcf:	6a 01                	push   $0x1
80105dd1:	e8 fa 01 00 00       	call   80105fd0 <argstr>
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	78 53                	js     80105e30 <sys_arp+0x80>
80105ddd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de0:	83 ec 08             	sub    $0x8,%esp
80105de3:	50                   	push   %eax
80105de4:	6a 03                	push   $0x3
80105de6:	e8 35 01 00 00       	call   80105f20 <argint>
80105deb:	83 c4 10             	add    $0x10,%esp
80105dee:	85 c0                	test   %eax,%eax
80105df0:	78 3e                	js     80105e30 <sys_arp+0x80>
80105df2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105df5:	83 ec 04             	sub    $0x4,%esp
80105df8:	ff 75 f4             	pushl  -0xc(%ebp)
80105dfb:	50                   	push   %eax
80105dfc:	6a 02                	push   $0x2
80105dfe:	e8 6d 01 00 00       	call   80105f70 <argptr>
80105e03:	83 c4 10             	add    $0x10,%esp
80105e06:	85 c0                	test   %eax,%eax
80105e08:	78 26                	js     80105e30 <sys_arp+0x80>
    cprintf("ERROR:sys_createARP:Failed to fetch arguments");
    return -1;
  }

  if(send_arpRequest(interface, ipAddr, arpResp) < 0) {
80105e0a:	83 ec 04             	sub    $0x4,%esp
80105e0d:	ff 75 f0             	pushl  -0x10(%ebp)
80105e10:	ff 75 e8             	pushl  -0x18(%ebp)
80105e13:	ff 75 ec             	pushl  -0x14(%ebp)
80105e16:	e8 85 a2 ff ff       	call   801000a0 <send_arpRequest>
80105e1b:	83 c4 10             	add    $0x10,%esp
80105e1e:	85 c0                	test   %eax,%eax
80105e20:	78 25                	js     80105e47 <sys_arp+0x97>
    cprintf("ERROR:sys_createARP:Failed to send ARP Request for IP:%s", ipAddr);
    return -1;
  }

  return 0;
80105e22:	31 c0                	xor    %eax,%eax
}
80105e24:	c9                   	leave  
80105e25:	c3                   	ret    
80105e26:	8d 76 00             	lea    0x0(%esi),%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("ERROR:sys_createARP:Failed to fetch arguments");
80105e30:	83 ec 0c             	sub    $0xc,%esp
80105e33:	68 e8 97 10 80       	push   $0x801097e8
80105e38:	e8 03 ae ff ff       	call   80100c40 <cprintf>
    return -1;
80105e3d:	83 c4 10             	add    $0x10,%esp
80105e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e45:	c9                   	leave  
80105e46:	c3                   	ret    
    cprintf("ERROR:sys_createARP:Failed to send ARP Request for IP:%s", ipAddr);
80105e47:	83 ec 08             	sub    $0x8,%esp
80105e4a:	ff 75 e8             	pushl  -0x18(%ebp)
80105e4d:	68 18 98 10 80       	push   $0x80109818
80105e52:	e8 e9 ad ff ff       	call   80100c40 <cprintf>
    return -1;
80105e57:	83 c4 10             	add    $0x10,%esp
80105e5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e5f:	c9                   	leave  
80105e60:	c3                   	ret    
80105e61:	66 90                	xchg   %ax,%ax
80105e63:	66 90                	xchg   %ax,%ax
80105e65:	66 90                	xchg   %ax,%ax
80105e67:	66 90                	xchg   %ax,%ax
80105e69:	66 90                	xchg   %ax,%ax
80105e6b:	66 90                	xchg   %ax,%ax
80105e6d:	66 90                	xchg   %ax,%ax
80105e6f:	90                   	nop

80105e70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	53                   	push   %ebx
80105e74:	83 ec 04             	sub    $0x4,%esp
80105e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105e7a:	e8 71 f0 ff ff       	call   80104ef0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105e7f:	8b 00                	mov    (%eax),%eax
80105e81:	39 d8                	cmp    %ebx,%eax
80105e83:	76 1b                	jbe    80105ea0 <fetchint+0x30>
80105e85:	8d 53 04             	lea    0x4(%ebx),%edx
80105e88:	39 d0                	cmp    %edx,%eax
80105e8a:	72 14                	jb     80105ea0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e8f:	8b 13                	mov    (%ebx),%edx
80105e91:	89 10                	mov    %edx,(%eax)
  return 0;
80105e93:	31 c0                	xor    %eax,%eax
}
80105e95:	83 c4 04             	add    $0x4,%esp
80105e98:	5b                   	pop    %ebx
80105e99:	5d                   	pop    %ebp
80105e9a:	c3                   	ret    
80105e9b:	90                   	nop
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea5:	eb ee                	jmp    80105e95 <fetchint+0x25>
80105ea7:	89 f6                	mov    %esi,%esi
80105ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105eb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	53                   	push   %ebx
80105eb4:	83 ec 04             	sub    $0x4,%esp
80105eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105eba:	e8 31 f0 ff ff       	call   80104ef0 <myproc>

  if(addr >= curproc->sz)
80105ebf:	39 18                	cmp    %ebx,(%eax)
80105ec1:	76 29                	jbe    80105eec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105ec6:	89 da                	mov    %ebx,%edx
80105ec8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80105eca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80105ecc:	39 c3                	cmp    %eax,%ebx
80105ece:	73 1c                	jae    80105eec <fetchstr+0x3c>
    if(*s == 0)
80105ed0:	80 3b 00             	cmpb   $0x0,(%ebx)
80105ed3:	75 10                	jne    80105ee5 <fetchstr+0x35>
80105ed5:	eb 39                	jmp    80105f10 <fetchstr+0x60>
80105ed7:	89 f6                	mov    %esi,%esi
80105ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ee0:	80 3a 00             	cmpb   $0x0,(%edx)
80105ee3:	74 1b                	je     80105f00 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105ee5:	83 c2 01             	add    $0x1,%edx
80105ee8:	39 d0                	cmp    %edx,%eax
80105eea:	77 f4                	ja     80105ee0 <fetchstr+0x30>
    return -1;
80105eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105ef1:	83 c4 04             	add    $0x4,%esp
80105ef4:	5b                   	pop    %ebx
80105ef5:	5d                   	pop    %ebp
80105ef6:	c3                   	ret    
80105ef7:	89 f6                	mov    %esi,%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105f00:	83 c4 04             	add    $0x4,%esp
80105f03:	89 d0                	mov    %edx,%eax
80105f05:	29 d8                	sub    %ebx,%eax
80105f07:	5b                   	pop    %ebx
80105f08:	5d                   	pop    %ebp
80105f09:	c3                   	ret    
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105f10:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105f12:	eb dd                	jmp    80105ef1 <fetchstr+0x41>
80105f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	56                   	push   %esi
80105f24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f25:	e8 c6 ef ff ff       	call   80104ef0 <myproc>
80105f2a:	8b 40 18             	mov    0x18(%eax),%eax
80105f2d:	8b 55 08             	mov    0x8(%ebp),%edx
80105f30:	8b 40 44             	mov    0x44(%eax),%eax
80105f33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105f36:	e8 b5 ef ff ff       	call   80104ef0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105f3b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f3d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105f40:	39 c6                	cmp    %eax,%esi
80105f42:	73 1c                	jae    80105f60 <argint+0x40>
80105f44:	8d 53 08             	lea    0x8(%ebx),%edx
80105f47:	39 d0                	cmp    %edx,%eax
80105f49:	72 15                	jb     80105f60 <argint+0x40>
  *ip = *(int*)(addr);
80105f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f4e:	8b 53 04             	mov    0x4(%ebx),%edx
80105f51:	89 10                	mov    %edx,(%eax)
  return 0;
80105f53:	31 c0                	xor    %eax,%eax
}
80105f55:	5b                   	pop    %ebx
80105f56:	5e                   	pop    %esi
80105f57:	5d                   	pop    %ebp
80105f58:	c3                   	ret    
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f65:	eb ee                	jmp    80105f55 <argint+0x35>
80105f67:	89 f6                	mov    %esi,%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	56                   	push   %esi
80105f74:	53                   	push   %ebx
80105f75:	83 ec 10             	sub    $0x10,%esp
80105f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80105f7b:	e8 70 ef ff ff       	call   80104ef0 <myproc>
80105f80:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105f82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f85:	83 ec 08             	sub    $0x8,%esp
80105f88:	50                   	push   %eax
80105f89:	ff 75 08             	pushl  0x8(%ebp)
80105f8c:	e8 8f ff ff ff       	call   80105f20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105f91:	83 c4 10             	add    $0x10,%esp
80105f94:	85 c0                	test   %eax,%eax
80105f96:	78 28                	js     80105fc0 <argptr+0x50>
80105f98:	85 db                	test   %ebx,%ebx
80105f9a:	78 24                	js     80105fc0 <argptr+0x50>
80105f9c:	8b 16                	mov    (%esi),%edx
80105f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa1:	39 c2                	cmp    %eax,%edx
80105fa3:	76 1b                	jbe    80105fc0 <argptr+0x50>
80105fa5:	01 c3                	add    %eax,%ebx
80105fa7:	39 da                	cmp    %ebx,%edx
80105fa9:	72 15                	jb     80105fc0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80105fab:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fae:	89 02                	mov    %eax,(%edx)
  return 0;
80105fb0:	31 c0                	xor    %eax,%eax
}
80105fb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fb5:	5b                   	pop    %ebx
80105fb6:	5e                   	pop    %esi
80105fb7:	5d                   	pop    %ebp
80105fb8:	c3                   	ret    
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc5:	eb eb                	jmp    80105fb2 <argptr+0x42>
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fd9:	50                   	push   %eax
80105fda:	ff 75 08             	pushl  0x8(%ebp)
80105fdd:	e8 3e ff ff ff       	call   80105f20 <argint>
80105fe2:	83 c4 10             	add    $0x10,%esp
80105fe5:	85 c0                	test   %eax,%eax
80105fe7:	78 17                	js     80106000 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105fe9:	83 ec 08             	sub    $0x8,%esp
80105fec:	ff 75 0c             	pushl  0xc(%ebp)
80105fef:	ff 75 f4             	pushl  -0xc(%ebp)
80105ff2:	e8 b9 fe ff ff       	call   80105eb0 <fetchstr>
80105ff7:	83 c4 10             	add    $0x10,%esp
}
80105ffa:	c9                   	leave  
80105ffb:	c3                   	ret    
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106005:	c9                   	leave  
80106006:	c3                   	ret    
80106007:	89 f6                	mov    %esi,%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106010 <syscall>:
[SYS_connect] sys_connect,
};

void
syscall(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	53                   	push   %ebx
80106014:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80106017:	e8 d4 ee ff ff       	call   80104ef0 <myproc>
8010601c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010601e:	8b 40 18             	mov    0x18(%eax),%eax
80106021:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106024:	8d 50 ff             	lea    -0x1(%eax),%edx
80106027:	83 fa 16             	cmp    $0x16,%edx
8010602a:	77 1c                	ja     80106048 <syscall+0x38>
8010602c:	8b 14 85 80 98 10 80 	mov    -0x7fef6780(,%eax,4),%edx
80106033:	85 d2                	test   %edx,%edx
80106035:	74 11                	je     80106048 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80106037:	ff d2                	call   *%edx
80106039:	8b 53 18             	mov    0x18(%ebx),%edx
8010603c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010603f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106042:	c9                   	leave  
80106043:	c3                   	ret    
80106044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80106048:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80106049:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010604c:	50                   	push   %eax
8010604d:	ff 73 10             	pushl  0x10(%ebx)
80106050:	68 51 98 10 80       	push   $0x80109851
80106055:	e8 e6 ab ff ff       	call   80100c40 <cprintf>
    curproc->tf->eax = -1;
8010605a:	8b 43 18             	mov    0x18(%ebx),%eax
8010605d:	83 c4 10             	add    $0x10,%esp
80106060:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80106067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010606a:	c9                   	leave  
8010606b:	c3                   	ret    
8010606c:	66 90                	xchg   %ax,%ax
8010606e:	66 90                	xchg   %ax,%ax

80106070 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	57                   	push   %edi
80106074:	56                   	push   %esi
80106075:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106076:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80106079:	83 ec 44             	sub    $0x44,%esp
8010607c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010607f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80106082:	56                   	push   %esi
80106083:	50                   	push   %eax
{
80106084:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80106087:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010608a:	e8 c1 c8 ff ff       	call   80102950 <nameiparent>
8010608f:	83 c4 10             	add    $0x10,%esp
80106092:	85 c0                	test   %eax,%eax
80106094:	0f 84 46 01 00 00    	je     801061e0 <create+0x170>
    return 0;
  ilock(dp);
8010609a:	83 ec 0c             	sub    $0xc,%esp
8010609d:	89 c3                	mov    %eax,%ebx
8010609f:	50                   	push   %eax
801060a0:	e8 2b c0 ff ff       	call   801020d0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801060a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801060a8:	83 c4 0c             	add    $0xc,%esp
801060ab:	50                   	push   %eax
801060ac:	56                   	push   %esi
801060ad:	53                   	push   %ebx
801060ae:	e8 4d c5 ff ff       	call   80102600 <dirlookup>
801060b3:	83 c4 10             	add    $0x10,%esp
801060b6:	85 c0                	test   %eax,%eax
801060b8:	89 c7                	mov    %eax,%edi
801060ba:	74 34                	je     801060f0 <create+0x80>
    iunlockput(dp);
801060bc:	83 ec 0c             	sub    $0xc,%esp
801060bf:	53                   	push   %ebx
801060c0:	e8 9b c2 ff ff       	call   80102360 <iunlockput>
    ilock(ip);
801060c5:	89 3c 24             	mov    %edi,(%esp)
801060c8:	e8 03 c0 ff ff       	call   801020d0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801060cd:	83 c4 10             	add    $0x10,%esp
801060d0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801060d5:	0f 85 95 00 00 00    	jne    80106170 <create+0x100>
801060db:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801060e0:	0f 85 8a 00 00 00    	jne    80106170 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801060e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060e9:	89 f8                	mov    %edi,%eax
801060eb:	5b                   	pop    %ebx
801060ec:	5e                   	pop    %esi
801060ed:	5f                   	pop    %edi
801060ee:	5d                   	pop    %ebp
801060ef:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801060f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801060f4:	83 ec 08             	sub    $0x8,%esp
801060f7:	50                   	push   %eax
801060f8:	ff 33                	pushl  (%ebx)
801060fa:	e8 61 be ff ff       	call   80101f60 <ialloc>
801060ff:	83 c4 10             	add    $0x10,%esp
80106102:	85 c0                	test   %eax,%eax
80106104:	89 c7                	mov    %eax,%edi
80106106:	0f 84 e8 00 00 00    	je     801061f4 <create+0x184>
  ilock(ip);
8010610c:	83 ec 0c             	sub    $0xc,%esp
8010610f:	50                   	push   %eax
80106110:	e8 bb bf ff ff       	call   801020d0 <ilock>
  ip->major = major;
80106115:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80106119:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010611d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80106121:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80106125:	b8 01 00 00 00       	mov    $0x1,%eax
8010612a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010612e:	89 3c 24             	mov    %edi,(%esp)
80106131:	e8 ea be ff ff       	call   80102020 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106136:	83 c4 10             	add    $0x10,%esp
80106139:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010613e:	74 50                	je     80106190 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80106140:	83 ec 04             	sub    $0x4,%esp
80106143:	ff 77 04             	pushl  0x4(%edi)
80106146:	56                   	push   %esi
80106147:	53                   	push   %ebx
80106148:	e8 23 c7 ff ff       	call   80102870 <dirlink>
8010614d:	83 c4 10             	add    $0x10,%esp
80106150:	85 c0                	test   %eax,%eax
80106152:	0f 88 8f 00 00 00    	js     801061e7 <create+0x177>
  iunlockput(dp);
80106158:	83 ec 0c             	sub    $0xc,%esp
8010615b:	53                   	push   %ebx
8010615c:	e8 ff c1 ff ff       	call   80102360 <iunlockput>
  return ip;
80106161:	83 c4 10             	add    $0x10,%esp
}
80106164:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106167:	89 f8                	mov    %edi,%eax
80106169:	5b                   	pop    %ebx
8010616a:	5e                   	pop    %esi
8010616b:	5f                   	pop    %edi
8010616c:	5d                   	pop    %ebp
8010616d:	c3                   	ret    
8010616e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	57                   	push   %edi
    return 0;
80106174:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80106176:	e8 e5 c1 ff ff       	call   80102360 <iunlockput>
    return 0;
8010617b:	83 c4 10             	add    $0x10,%esp
}
8010617e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106181:	89 f8                	mov    %edi,%eax
80106183:	5b                   	pop    %ebx
80106184:	5e                   	pop    %esi
80106185:	5f                   	pop    %edi
80106186:	5d                   	pop    %ebp
80106187:	c3                   	ret    
80106188:	90                   	nop
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80106190:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80106195:	83 ec 0c             	sub    $0xc,%esp
80106198:	53                   	push   %ebx
80106199:	e8 82 be ff ff       	call   80102020 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010619e:	83 c4 0c             	add    $0xc,%esp
801061a1:	ff 77 04             	pushl  0x4(%edi)
801061a4:	68 fc 98 10 80       	push   $0x801098fc
801061a9:	57                   	push   %edi
801061aa:	e8 c1 c6 ff ff       	call   80102870 <dirlink>
801061af:	83 c4 10             	add    $0x10,%esp
801061b2:	85 c0                	test   %eax,%eax
801061b4:	78 1c                	js     801061d2 <create+0x162>
801061b6:	83 ec 04             	sub    $0x4,%esp
801061b9:	ff 73 04             	pushl  0x4(%ebx)
801061bc:	68 fb 98 10 80       	push   $0x801098fb
801061c1:	57                   	push   %edi
801061c2:	e8 a9 c6 ff ff       	call   80102870 <dirlink>
801061c7:	83 c4 10             	add    $0x10,%esp
801061ca:	85 c0                	test   %eax,%eax
801061cc:	0f 89 6e ff ff ff    	jns    80106140 <create+0xd0>
      panic("create dots");
801061d2:	83 ec 0c             	sub    $0xc,%esp
801061d5:	68 ef 98 10 80       	push   $0x801098ef
801061da:	e8 91 a7 ff ff       	call   80100970 <panic>
801061df:	90                   	nop
    return 0;
801061e0:	31 ff                	xor    %edi,%edi
801061e2:	e9 ff fe ff ff       	jmp    801060e6 <create+0x76>
    panic("create: dirlink");
801061e7:	83 ec 0c             	sub    $0xc,%esp
801061ea:	68 fe 98 10 80       	push   $0x801098fe
801061ef:	e8 7c a7 ff ff       	call   80100970 <panic>
    panic("create: ialloc");
801061f4:	83 ec 0c             	sub    $0xc,%esp
801061f7:	68 e0 98 10 80       	push   $0x801098e0
801061fc:	e8 6f a7 ff ff       	call   80100970 <panic>
80106201:	eb 0d                	jmp    80106210 <argfd.constprop.0>
80106203:	90                   	nop
80106204:	90                   	nop
80106205:	90                   	nop
80106206:	90                   	nop
80106207:	90                   	nop
80106208:	90                   	nop
80106209:	90                   	nop
8010620a:	90                   	nop
8010620b:	90                   	nop
8010620c:	90                   	nop
8010620d:	90                   	nop
8010620e:	90                   	nop
8010620f:	90                   	nop

80106210 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	56                   	push   %esi
80106214:	53                   	push   %ebx
80106215:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80106217:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010621a:	89 d6                	mov    %edx,%esi
8010621c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010621f:	50                   	push   %eax
80106220:	6a 00                	push   $0x0
80106222:	e8 f9 fc ff ff       	call   80105f20 <argint>
80106227:	83 c4 10             	add    $0x10,%esp
8010622a:	85 c0                	test   %eax,%eax
8010622c:	78 2a                	js     80106258 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010622e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106232:	77 24                	ja     80106258 <argfd.constprop.0+0x48>
80106234:	e8 b7 ec ff ff       	call   80104ef0 <myproc>
80106239:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010623c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80106240:	85 c0                	test   %eax,%eax
80106242:	74 14                	je     80106258 <argfd.constprop.0+0x48>
  if(pfd)
80106244:	85 db                	test   %ebx,%ebx
80106246:	74 02                	je     8010624a <argfd.constprop.0+0x3a>
    *pfd = fd;
80106248:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010624a:	89 06                	mov    %eax,(%esi)
  return 0;
8010624c:	31 c0                	xor    %eax,%eax
}
8010624e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106251:	5b                   	pop    %ebx
80106252:	5e                   	pop    %esi
80106253:	5d                   	pop    %ebp
80106254:	c3                   	ret    
80106255:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010625d:	eb ef                	jmp    8010624e <argfd.constprop.0+0x3e>
8010625f:	90                   	nop

80106260 <sys_dup>:
{
80106260:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80106261:	31 c0                	xor    %eax,%eax
{
80106263:	89 e5                	mov    %esp,%ebp
80106265:	56                   	push   %esi
80106266:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80106267:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010626a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010626d:	e8 9e ff ff ff       	call   80106210 <argfd.constprop.0>
80106272:	85 c0                	test   %eax,%eax
80106274:	78 42                	js     801062b8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80106276:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106279:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010627b:	e8 70 ec ff ff       	call   80104ef0 <myproc>
80106280:	eb 0e                	jmp    80106290 <sys_dup+0x30>
80106282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106288:	83 c3 01             	add    $0x1,%ebx
8010628b:	83 fb 10             	cmp    $0x10,%ebx
8010628e:	74 28                	je     801062b8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80106290:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106294:	85 d2                	test   %edx,%edx
80106296:	75 f0                	jne    80106288 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80106298:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010629c:	83 ec 0c             	sub    $0xc,%esp
8010629f:	ff 75 f4             	pushl  -0xc(%ebp)
801062a2:	e8 09 b5 ff ff       	call   801017b0 <filedup>
  return fd;
801062a7:	83 c4 10             	add    $0x10,%esp
}
801062aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062ad:	89 d8                	mov    %ebx,%eax
801062af:	5b                   	pop    %ebx
801062b0:	5e                   	pop    %esi
801062b1:	5d                   	pop    %ebp
801062b2:	c3                   	ret    
801062b3:	90                   	nop
801062b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801062bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801062c0:	89 d8                	mov    %ebx,%eax
801062c2:	5b                   	pop    %ebx
801062c3:	5e                   	pop    %esi
801062c4:	5d                   	pop    %ebp
801062c5:	c3                   	ret    
801062c6:	8d 76 00             	lea    0x0(%esi),%esi
801062c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062d0 <sys_read>:
{
801062d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801062d1:	31 c0                	xor    %eax,%eax
{
801062d3:	89 e5                	mov    %esp,%ebp
801062d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801062d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801062db:	e8 30 ff ff ff       	call   80106210 <argfd.constprop.0>
801062e0:	85 c0                	test   %eax,%eax
801062e2:	78 4c                	js     80106330 <sys_read+0x60>
801062e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801062e7:	83 ec 08             	sub    $0x8,%esp
801062ea:	50                   	push   %eax
801062eb:	6a 02                	push   $0x2
801062ed:	e8 2e fc ff ff       	call   80105f20 <argint>
801062f2:	83 c4 10             	add    $0x10,%esp
801062f5:	85 c0                	test   %eax,%eax
801062f7:	78 37                	js     80106330 <sys_read+0x60>
801062f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062fc:	83 ec 04             	sub    $0x4,%esp
801062ff:	ff 75 f0             	pushl  -0x10(%ebp)
80106302:	50                   	push   %eax
80106303:	6a 01                	push   $0x1
80106305:	e8 66 fc ff ff       	call   80105f70 <argptr>
8010630a:	83 c4 10             	add    $0x10,%esp
8010630d:	85 c0                	test   %eax,%eax
8010630f:	78 1f                	js     80106330 <sys_read+0x60>
  return fileread(f, p, n);
80106311:	83 ec 04             	sub    $0x4,%esp
80106314:	ff 75 f0             	pushl  -0x10(%ebp)
80106317:	ff 75 f4             	pushl  -0xc(%ebp)
8010631a:	ff 75 ec             	pushl  -0x14(%ebp)
8010631d:	e8 1e b6 ff ff       	call   80101940 <fileread>
80106322:	83 c4 10             	add    $0x10,%esp
}
80106325:	c9                   	leave  
80106326:	c3                   	ret    
80106327:	89 f6                	mov    %esi,%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80106330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106335:	c9                   	leave  
80106336:	c3                   	ret    
80106337:	89 f6                	mov    %esi,%esi
80106339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106340 <sys_write>:
{
80106340:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106341:	31 c0                	xor    %eax,%eax
{
80106343:	89 e5                	mov    %esp,%ebp
80106345:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106348:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010634b:	e8 c0 fe ff ff       	call   80106210 <argfd.constprop.0>
80106350:	85 c0                	test   %eax,%eax
80106352:	78 4c                	js     801063a0 <sys_write+0x60>
80106354:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106357:	83 ec 08             	sub    $0x8,%esp
8010635a:	50                   	push   %eax
8010635b:	6a 02                	push   $0x2
8010635d:	e8 be fb ff ff       	call   80105f20 <argint>
80106362:	83 c4 10             	add    $0x10,%esp
80106365:	85 c0                	test   %eax,%eax
80106367:	78 37                	js     801063a0 <sys_write+0x60>
80106369:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010636c:	83 ec 04             	sub    $0x4,%esp
8010636f:	ff 75 f0             	pushl  -0x10(%ebp)
80106372:	50                   	push   %eax
80106373:	6a 01                	push   $0x1
80106375:	e8 f6 fb ff ff       	call   80105f70 <argptr>
8010637a:	83 c4 10             	add    $0x10,%esp
8010637d:	85 c0                	test   %eax,%eax
8010637f:	78 1f                	js     801063a0 <sys_write+0x60>
  return filewrite(f, p, n);
80106381:	83 ec 04             	sub    $0x4,%esp
80106384:	ff 75 f0             	pushl  -0x10(%ebp)
80106387:	ff 75 f4             	pushl  -0xc(%ebp)
8010638a:	ff 75 ec             	pushl  -0x14(%ebp)
8010638d:	e8 6e b6 ff ff       	call   80101a00 <filewrite>
80106392:	83 c4 10             	add    $0x10,%esp
}
80106395:	c9                   	leave  
80106396:	c3                   	ret    
80106397:	89 f6                	mov    %esi,%esi
80106399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801063a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063a5:	c9                   	leave  
801063a6:	c3                   	ret    
801063a7:	89 f6                	mov    %esi,%esi
801063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063b0 <sys_close>:
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801063b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801063b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063bc:	e8 4f fe ff ff       	call   80106210 <argfd.constprop.0>
801063c1:	85 c0                	test   %eax,%eax
801063c3:	78 2b                	js     801063f0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801063c5:	e8 26 eb ff ff       	call   80104ef0 <myproc>
801063ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801063cd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801063d0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801063d7:	00 
  fileclose(f);
801063d8:	ff 75 f4             	pushl  -0xc(%ebp)
801063db:	e8 20 b4 ff ff       	call   80101800 <fileclose>
  return 0;
801063e0:	83 c4 10             	add    $0x10,%esp
801063e3:	31 c0                	xor    %eax,%eax
}
801063e5:	c9                   	leave  
801063e6:	c3                   	ret    
801063e7:	89 f6                	mov    %esi,%esi
801063e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801063f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063f5:	c9                   	leave  
801063f6:	c3                   	ret    
801063f7:	89 f6                	mov    %esi,%esi
801063f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106400 <sys_fstat>:
{
80106400:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106401:	31 c0                	xor    %eax,%eax
{
80106403:	89 e5                	mov    %esp,%ebp
80106405:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106408:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010640b:	e8 00 fe ff ff       	call   80106210 <argfd.constprop.0>
80106410:	85 c0                	test   %eax,%eax
80106412:	78 2c                	js     80106440 <sys_fstat+0x40>
80106414:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106417:	83 ec 04             	sub    $0x4,%esp
8010641a:	6a 14                	push   $0x14
8010641c:	50                   	push   %eax
8010641d:	6a 01                	push   $0x1
8010641f:	e8 4c fb ff ff       	call   80105f70 <argptr>
80106424:	83 c4 10             	add    $0x10,%esp
80106427:	85 c0                	test   %eax,%eax
80106429:	78 15                	js     80106440 <sys_fstat+0x40>
  return filestat(f, st);
8010642b:	83 ec 08             	sub    $0x8,%esp
8010642e:	ff 75 f4             	pushl  -0xc(%ebp)
80106431:	ff 75 f0             	pushl  -0x10(%ebp)
80106434:	e8 b7 b4 ff ff       	call   801018f0 <filestat>
80106439:	83 c4 10             	add    $0x10,%esp
}
8010643c:	c9                   	leave  
8010643d:	c3                   	ret    
8010643e:	66 90                	xchg   %ax,%ax
    return -1;
80106440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106445:	c9                   	leave  
80106446:	c3                   	ret    
80106447:	89 f6                	mov    %esi,%esi
80106449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106450 <sys_link>:
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	57                   	push   %edi
80106454:	56                   	push   %esi
80106455:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106456:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106459:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010645c:	50                   	push   %eax
8010645d:	6a 00                	push   $0x0
8010645f:	e8 6c fb ff ff       	call   80105fd0 <argstr>
80106464:	83 c4 10             	add    $0x10,%esp
80106467:	85 c0                	test   %eax,%eax
80106469:	0f 88 fb 00 00 00    	js     8010656a <sys_link+0x11a>
8010646f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106472:	83 ec 08             	sub    $0x8,%esp
80106475:	50                   	push   %eax
80106476:	6a 01                	push   $0x1
80106478:	e8 53 fb ff ff       	call   80105fd0 <argstr>
8010647d:	83 c4 10             	add    $0x10,%esp
80106480:	85 c0                	test   %eax,%eax
80106482:	0f 88 e2 00 00 00    	js     8010656a <sys_link+0x11a>
  begin_op();
80106488:	e8 63 d1 ff ff       	call   801035f0 <begin_op>
  if((ip = namei(old)) == 0){
8010648d:	83 ec 0c             	sub    $0xc,%esp
80106490:	ff 75 d4             	pushl  -0x2c(%ebp)
80106493:	e8 98 c4 ff ff       	call   80102930 <namei>
80106498:	83 c4 10             	add    $0x10,%esp
8010649b:	85 c0                	test   %eax,%eax
8010649d:	89 c3                	mov    %eax,%ebx
8010649f:	0f 84 ea 00 00 00    	je     8010658f <sys_link+0x13f>
  ilock(ip);
801064a5:	83 ec 0c             	sub    $0xc,%esp
801064a8:	50                   	push   %eax
801064a9:	e8 22 bc ff ff       	call   801020d0 <ilock>
  if(ip->type == T_DIR){
801064ae:	83 c4 10             	add    $0x10,%esp
801064b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801064b6:	0f 84 bb 00 00 00    	je     80106577 <sys_link+0x127>
  ip->nlink++;
801064bc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801064c1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801064c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801064c7:	53                   	push   %ebx
801064c8:	e8 53 bb ff ff       	call   80102020 <iupdate>
  iunlock(ip);
801064cd:	89 1c 24             	mov    %ebx,(%esp)
801064d0:	e8 db bc ff ff       	call   801021b0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801064d5:	58                   	pop    %eax
801064d6:	5a                   	pop    %edx
801064d7:	57                   	push   %edi
801064d8:	ff 75 d0             	pushl  -0x30(%ebp)
801064db:	e8 70 c4 ff ff       	call   80102950 <nameiparent>
801064e0:	83 c4 10             	add    $0x10,%esp
801064e3:	85 c0                	test   %eax,%eax
801064e5:	89 c6                	mov    %eax,%esi
801064e7:	74 5b                	je     80106544 <sys_link+0xf4>
  ilock(dp);
801064e9:	83 ec 0c             	sub    $0xc,%esp
801064ec:	50                   	push   %eax
801064ed:	e8 de bb ff ff       	call   801020d0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801064f2:	83 c4 10             	add    $0x10,%esp
801064f5:	8b 03                	mov    (%ebx),%eax
801064f7:	39 06                	cmp    %eax,(%esi)
801064f9:	75 3d                	jne    80106538 <sys_link+0xe8>
801064fb:	83 ec 04             	sub    $0x4,%esp
801064fe:	ff 73 04             	pushl  0x4(%ebx)
80106501:	57                   	push   %edi
80106502:	56                   	push   %esi
80106503:	e8 68 c3 ff ff       	call   80102870 <dirlink>
80106508:	83 c4 10             	add    $0x10,%esp
8010650b:	85 c0                	test   %eax,%eax
8010650d:	78 29                	js     80106538 <sys_link+0xe8>
  iunlockput(dp);
8010650f:	83 ec 0c             	sub    $0xc,%esp
80106512:	56                   	push   %esi
80106513:	e8 48 be ff ff       	call   80102360 <iunlockput>
  iput(ip);
80106518:	89 1c 24             	mov    %ebx,(%esp)
8010651b:	e8 e0 bc ff ff       	call   80102200 <iput>
  end_op();
80106520:	e8 3b d1 ff ff       	call   80103660 <end_op>
  return 0;
80106525:	83 c4 10             	add    $0x10,%esp
80106528:	31 c0                	xor    %eax,%eax
}
8010652a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010652d:	5b                   	pop    %ebx
8010652e:	5e                   	pop    %esi
8010652f:	5f                   	pop    %edi
80106530:	5d                   	pop    %ebp
80106531:	c3                   	ret    
80106532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106538:	83 ec 0c             	sub    $0xc,%esp
8010653b:	56                   	push   %esi
8010653c:	e8 1f be ff ff       	call   80102360 <iunlockput>
    goto bad;
80106541:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106544:	83 ec 0c             	sub    $0xc,%esp
80106547:	53                   	push   %ebx
80106548:	e8 83 bb ff ff       	call   801020d0 <ilock>
  ip->nlink--;
8010654d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106552:	89 1c 24             	mov    %ebx,(%esp)
80106555:	e8 c6 ba ff ff       	call   80102020 <iupdate>
  iunlockput(ip);
8010655a:	89 1c 24             	mov    %ebx,(%esp)
8010655d:	e8 fe bd ff ff       	call   80102360 <iunlockput>
  end_op();
80106562:	e8 f9 d0 ff ff       	call   80103660 <end_op>
  return -1;
80106567:	83 c4 10             	add    $0x10,%esp
}
8010656a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010656d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106572:	5b                   	pop    %ebx
80106573:	5e                   	pop    %esi
80106574:	5f                   	pop    %edi
80106575:	5d                   	pop    %ebp
80106576:	c3                   	ret    
    iunlockput(ip);
80106577:	83 ec 0c             	sub    $0xc,%esp
8010657a:	53                   	push   %ebx
8010657b:	e8 e0 bd ff ff       	call   80102360 <iunlockput>
    end_op();
80106580:	e8 db d0 ff ff       	call   80103660 <end_op>
    return -1;
80106585:	83 c4 10             	add    $0x10,%esp
80106588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010658d:	eb 9b                	jmp    8010652a <sys_link+0xda>
    end_op();
8010658f:	e8 cc d0 ff ff       	call   80103660 <end_op>
    return -1;
80106594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106599:	eb 8f                	jmp    8010652a <sys_link+0xda>
8010659b:	90                   	nop
8010659c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065a0 <sys_unlink>:
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	57                   	push   %edi
801065a4:	56                   	push   %esi
801065a5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801065a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801065a9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801065ac:	50                   	push   %eax
801065ad:	6a 00                	push   $0x0
801065af:	e8 1c fa ff ff       	call   80105fd0 <argstr>
801065b4:	83 c4 10             	add    $0x10,%esp
801065b7:	85 c0                	test   %eax,%eax
801065b9:	0f 88 77 01 00 00    	js     80106736 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801065bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801065c2:	e8 29 d0 ff ff       	call   801035f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801065c7:	83 ec 08             	sub    $0x8,%esp
801065ca:	53                   	push   %ebx
801065cb:	ff 75 c0             	pushl  -0x40(%ebp)
801065ce:	e8 7d c3 ff ff       	call   80102950 <nameiparent>
801065d3:	83 c4 10             	add    $0x10,%esp
801065d6:	85 c0                	test   %eax,%eax
801065d8:	89 c6                	mov    %eax,%esi
801065da:	0f 84 60 01 00 00    	je     80106740 <sys_unlink+0x1a0>
  ilock(dp);
801065e0:	83 ec 0c             	sub    $0xc,%esp
801065e3:	50                   	push   %eax
801065e4:	e8 e7 ba ff ff       	call   801020d0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801065e9:	58                   	pop    %eax
801065ea:	5a                   	pop    %edx
801065eb:	68 fc 98 10 80       	push   $0x801098fc
801065f0:	53                   	push   %ebx
801065f1:	e8 ea bf ff ff       	call   801025e0 <namecmp>
801065f6:	83 c4 10             	add    $0x10,%esp
801065f9:	85 c0                	test   %eax,%eax
801065fb:	0f 84 03 01 00 00    	je     80106704 <sys_unlink+0x164>
80106601:	83 ec 08             	sub    $0x8,%esp
80106604:	68 fb 98 10 80       	push   $0x801098fb
80106609:	53                   	push   %ebx
8010660a:	e8 d1 bf ff ff       	call   801025e0 <namecmp>
8010660f:	83 c4 10             	add    $0x10,%esp
80106612:	85 c0                	test   %eax,%eax
80106614:	0f 84 ea 00 00 00    	je     80106704 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010661a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010661d:	83 ec 04             	sub    $0x4,%esp
80106620:	50                   	push   %eax
80106621:	53                   	push   %ebx
80106622:	56                   	push   %esi
80106623:	e8 d8 bf ff ff       	call   80102600 <dirlookup>
80106628:	83 c4 10             	add    $0x10,%esp
8010662b:	85 c0                	test   %eax,%eax
8010662d:	89 c3                	mov    %eax,%ebx
8010662f:	0f 84 cf 00 00 00    	je     80106704 <sys_unlink+0x164>
  ilock(ip);
80106635:	83 ec 0c             	sub    $0xc,%esp
80106638:	50                   	push   %eax
80106639:	e8 92 ba ff ff       	call   801020d0 <ilock>
  if(ip->nlink < 1)
8010663e:	83 c4 10             	add    $0x10,%esp
80106641:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80106646:	0f 8e 10 01 00 00    	jle    8010675c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010664c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106651:	74 6d                	je     801066c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80106653:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106656:	83 ec 04             	sub    $0x4,%esp
80106659:	6a 10                	push   $0x10
8010665b:	6a 00                	push   $0x0
8010665d:	50                   	push   %eax
8010665e:	e8 fd f4 ff ff       	call   80105b60 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106663:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106666:	6a 10                	push   $0x10
80106668:	ff 75 c4             	pushl  -0x3c(%ebp)
8010666b:	50                   	push   %eax
8010666c:	56                   	push   %esi
8010666d:	e8 3e be ff ff       	call   801024b0 <writei>
80106672:	83 c4 20             	add    $0x20,%esp
80106675:	83 f8 10             	cmp    $0x10,%eax
80106678:	0f 85 eb 00 00 00    	jne    80106769 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010667e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106683:	0f 84 97 00 00 00    	je     80106720 <sys_unlink+0x180>
  iunlockput(dp);
80106689:	83 ec 0c             	sub    $0xc,%esp
8010668c:	56                   	push   %esi
8010668d:	e8 ce bc ff ff       	call   80102360 <iunlockput>
  ip->nlink--;
80106692:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106697:	89 1c 24             	mov    %ebx,(%esp)
8010669a:	e8 81 b9 ff ff       	call   80102020 <iupdate>
  iunlockput(ip);
8010669f:	89 1c 24             	mov    %ebx,(%esp)
801066a2:	e8 b9 bc ff ff       	call   80102360 <iunlockput>
  end_op();
801066a7:	e8 b4 cf ff ff       	call   80103660 <end_op>
  return 0;
801066ac:	83 c4 10             	add    $0x10,%esp
801066af:	31 c0                	xor    %eax,%eax
}
801066b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066b4:	5b                   	pop    %ebx
801066b5:	5e                   	pop    %esi
801066b6:	5f                   	pop    %edi
801066b7:	5d                   	pop    %ebp
801066b8:	c3                   	ret    
801066b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801066c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801066c4:	76 8d                	jbe    80106653 <sys_unlink+0xb3>
801066c6:	bf 20 00 00 00       	mov    $0x20,%edi
801066cb:	eb 0f                	jmp    801066dc <sys_unlink+0x13c>
801066cd:	8d 76 00             	lea    0x0(%esi),%esi
801066d0:	83 c7 10             	add    $0x10,%edi
801066d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801066d6:	0f 83 77 ff ff ff    	jae    80106653 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801066dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801066df:	6a 10                	push   $0x10
801066e1:	57                   	push   %edi
801066e2:	50                   	push   %eax
801066e3:	53                   	push   %ebx
801066e4:	e8 c7 bc ff ff       	call   801023b0 <readi>
801066e9:	83 c4 10             	add    $0x10,%esp
801066ec:	83 f8 10             	cmp    $0x10,%eax
801066ef:	75 5e                	jne    8010674f <sys_unlink+0x1af>
    if(de.inum != 0)
801066f1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801066f6:	74 d8                	je     801066d0 <sys_unlink+0x130>
    iunlockput(ip);
801066f8:	83 ec 0c             	sub    $0xc,%esp
801066fb:	53                   	push   %ebx
801066fc:	e8 5f bc ff ff       	call   80102360 <iunlockput>
    goto bad;
80106701:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80106704:	83 ec 0c             	sub    $0xc,%esp
80106707:	56                   	push   %esi
80106708:	e8 53 bc ff ff       	call   80102360 <iunlockput>
  end_op();
8010670d:	e8 4e cf ff ff       	call   80103660 <end_op>
  return -1;
80106712:	83 c4 10             	add    $0x10,%esp
80106715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671a:	eb 95                	jmp    801066b1 <sys_unlink+0x111>
8010671c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80106720:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80106725:	83 ec 0c             	sub    $0xc,%esp
80106728:	56                   	push   %esi
80106729:	e8 f2 b8 ff ff       	call   80102020 <iupdate>
8010672e:	83 c4 10             	add    $0x10,%esp
80106731:	e9 53 ff ff ff       	jmp    80106689 <sys_unlink+0xe9>
    return -1;
80106736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010673b:	e9 71 ff ff ff       	jmp    801066b1 <sys_unlink+0x111>
    end_op();
80106740:	e8 1b cf ff ff       	call   80103660 <end_op>
    return -1;
80106745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010674a:	e9 62 ff ff ff       	jmp    801066b1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010674f:	83 ec 0c             	sub    $0xc,%esp
80106752:	68 20 99 10 80       	push   $0x80109920
80106757:	e8 14 a2 ff ff       	call   80100970 <panic>
    panic("unlink: nlink < 1");
8010675c:	83 ec 0c             	sub    $0xc,%esp
8010675f:	68 0e 99 10 80       	push   $0x8010990e
80106764:	e8 07 a2 ff ff       	call   80100970 <panic>
    panic("unlink: writei");
80106769:	83 ec 0c             	sub    $0xc,%esp
8010676c:	68 32 99 10 80       	push   $0x80109932
80106771:	e8 fa a1 ff ff       	call   80100970 <panic>
80106776:	8d 76 00             	lea    0x0(%esi),%esi
80106779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106780 <sys_open>:

int
sys_open(void)
{
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	57                   	push   %edi
80106784:	56                   	push   %esi
80106785:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106786:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106789:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010678c:	50                   	push   %eax
8010678d:	6a 00                	push   $0x0
8010678f:	e8 3c f8 ff ff       	call   80105fd0 <argstr>
80106794:	83 c4 10             	add    $0x10,%esp
80106797:	85 c0                	test   %eax,%eax
80106799:	0f 88 1d 01 00 00    	js     801068bc <sys_open+0x13c>
8010679f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801067a2:	83 ec 08             	sub    $0x8,%esp
801067a5:	50                   	push   %eax
801067a6:	6a 01                	push   $0x1
801067a8:	e8 73 f7 ff ff       	call   80105f20 <argint>
801067ad:	83 c4 10             	add    $0x10,%esp
801067b0:	85 c0                	test   %eax,%eax
801067b2:	0f 88 04 01 00 00    	js     801068bc <sys_open+0x13c>
    return -1;

  begin_op();
801067b8:	e8 33 ce ff ff       	call   801035f0 <begin_op>

  if(omode & O_CREATE){
801067bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801067c1:	0f 85 a9 00 00 00    	jne    80106870 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801067c7:	83 ec 0c             	sub    $0xc,%esp
801067ca:	ff 75 e0             	pushl  -0x20(%ebp)
801067cd:	e8 5e c1 ff ff       	call   80102930 <namei>
801067d2:	83 c4 10             	add    $0x10,%esp
801067d5:	85 c0                	test   %eax,%eax
801067d7:	89 c6                	mov    %eax,%esi
801067d9:	0f 84 b2 00 00 00    	je     80106891 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801067df:	83 ec 0c             	sub    $0xc,%esp
801067e2:	50                   	push   %eax
801067e3:	e8 e8 b8 ff ff       	call   801020d0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801067e8:	83 c4 10             	add    $0x10,%esp
801067eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801067f0:	0f 84 aa 00 00 00    	je     801068a0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801067f6:	e8 45 af ff ff       	call   80101740 <filealloc>
801067fb:	85 c0                	test   %eax,%eax
801067fd:	89 c7                	mov    %eax,%edi
801067ff:	0f 84 a6 00 00 00    	je     801068ab <sys_open+0x12b>
  struct proc *curproc = myproc();
80106805:	e8 e6 e6 ff ff       	call   80104ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010680a:	31 db                	xor    %ebx,%ebx
8010680c:	eb 0e                	jmp    8010681c <sys_open+0x9c>
8010680e:	66 90                	xchg   %ax,%ax
80106810:	83 c3 01             	add    $0x1,%ebx
80106813:	83 fb 10             	cmp    $0x10,%ebx
80106816:	0f 84 ac 00 00 00    	je     801068c8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010681c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106820:	85 d2                	test   %edx,%edx
80106822:	75 ec                	jne    80106810 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106824:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106827:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010682b:	56                   	push   %esi
8010682c:	e8 7f b9 ff ff       	call   801021b0 <iunlock>
  end_op();
80106831:	e8 2a ce ff ff       	call   80103660 <end_op>

  f->type = FD_INODE;
80106836:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010683c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010683f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106842:	89 77 14             	mov    %esi,0x14(%edi)
  f->off = 0;
80106845:	c7 47 1c 00 00 00 00 	movl   $0x0,0x1c(%edi)
  f->readable = !(omode & O_WRONLY);
8010684c:	89 d0                	mov    %edx,%eax
8010684e:	f7 d0                	not    %eax
80106850:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106853:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106856:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106859:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010685d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106860:	89 d8                	mov    %ebx,%eax
80106862:	5b                   	pop    %ebx
80106863:	5e                   	pop    %esi
80106864:	5f                   	pop    %edi
80106865:	5d                   	pop    %ebp
80106866:	c3                   	ret    
80106867:	89 f6                	mov    %esi,%esi
80106869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80106870:	83 ec 0c             	sub    $0xc,%esp
80106873:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106876:	31 c9                	xor    %ecx,%ecx
80106878:	6a 00                	push   $0x0
8010687a:	ba 02 00 00 00       	mov    $0x2,%edx
8010687f:	e8 ec f7 ff ff       	call   80106070 <create>
    if(ip == 0){
80106884:	83 c4 10             	add    $0x10,%esp
80106887:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106889:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010688b:	0f 85 65 ff ff ff    	jne    801067f6 <sys_open+0x76>
      end_op();
80106891:	e8 ca cd ff ff       	call   80103660 <end_op>
      return -1;
80106896:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010689b:	eb c0                	jmp    8010685d <sys_open+0xdd>
8010689d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801068a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801068a3:	85 c9                	test   %ecx,%ecx
801068a5:	0f 84 4b ff ff ff    	je     801067f6 <sys_open+0x76>
    iunlockput(ip);
801068ab:	83 ec 0c             	sub    $0xc,%esp
801068ae:	56                   	push   %esi
801068af:	e8 ac ba ff ff       	call   80102360 <iunlockput>
    end_op();
801068b4:	e8 a7 cd ff ff       	call   80103660 <end_op>
    return -1;
801068b9:	83 c4 10             	add    $0x10,%esp
801068bc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801068c1:	eb 9a                	jmp    8010685d <sys_open+0xdd>
801068c3:	90                   	nop
801068c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801068c8:	83 ec 0c             	sub    $0xc,%esp
801068cb:	57                   	push   %edi
801068cc:	e8 2f af ff ff       	call   80101800 <fileclose>
801068d1:	83 c4 10             	add    $0x10,%esp
801068d4:	eb d5                	jmp    801068ab <sys_open+0x12b>
801068d6:	8d 76 00             	lea    0x0(%esi),%esi
801068d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801068e6:	e8 05 cd ff ff       	call   801035f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801068eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068ee:	83 ec 08             	sub    $0x8,%esp
801068f1:	50                   	push   %eax
801068f2:	6a 00                	push   $0x0
801068f4:	e8 d7 f6 ff ff       	call   80105fd0 <argstr>
801068f9:	83 c4 10             	add    $0x10,%esp
801068fc:	85 c0                	test   %eax,%eax
801068fe:	78 30                	js     80106930 <sys_mkdir+0x50>
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106906:	31 c9                	xor    %ecx,%ecx
80106908:	6a 00                	push   $0x0
8010690a:	ba 01 00 00 00       	mov    $0x1,%edx
8010690f:	e8 5c f7 ff ff       	call   80106070 <create>
80106914:	83 c4 10             	add    $0x10,%esp
80106917:	85 c0                	test   %eax,%eax
80106919:	74 15                	je     80106930 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010691b:	83 ec 0c             	sub    $0xc,%esp
8010691e:	50                   	push   %eax
8010691f:	e8 3c ba ff ff       	call   80102360 <iunlockput>
  end_op();
80106924:	e8 37 cd ff ff       	call   80103660 <end_op>
  return 0;
80106929:	83 c4 10             	add    $0x10,%esp
8010692c:	31 c0                	xor    %eax,%eax
}
8010692e:	c9                   	leave  
8010692f:	c3                   	ret    
    end_op();
80106930:	e8 2b cd ff ff       	call   80103660 <end_op>
    return -1;
80106935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010693a:	c9                   	leave  
8010693b:	c3                   	ret    
8010693c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106940 <sys_mknod>:

int
sys_mknod(void)
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106946:	e8 a5 cc ff ff       	call   801035f0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010694b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010694e:	83 ec 08             	sub    $0x8,%esp
80106951:	50                   	push   %eax
80106952:	6a 00                	push   $0x0
80106954:	e8 77 f6 ff ff       	call   80105fd0 <argstr>
80106959:	83 c4 10             	add    $0x10,%esp
8010695c:	85 c0                	test   %eax,%eax
8010695e:	78 60                	js     801069c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106960:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106963:	83 ec 08             	sub    $0x8,%esp
80106966:	50                   	push   %eax
80106967:	6a 01                	push   $0x1
80106969:	e8 b2 f5 ff ff       	call   80105f20 <argint>
  if((argstr(0, &path)) < 0 ||
8010696e:	83 c4 10             	add    $0x10,%esp
80106971:	85 c0                	test   %eax,%eax
80106973:	78 4b                	js     801069c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106975:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106978:	83 ec 08             	sub    $0x8,%esp
8010697b:	50                   	push   %eax
8010697c:	6a 02                	push   $0x2
8010697e:	e8 9d f5 ff ff       	call   80105f20 <argint>
     argint(1, &major) < 0 ||
80106983:	83 c4 10             	add    $0x10,%esp
80106986:	85 c0                	test   %eax,%eax
80106988:	78 36                	js     801069c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010698a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010698e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80106991:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80106995:	ba 03 00 00 00       	mov    $0x3,%edx
8010699a:	50                   	push   %eax
8010699b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010699e:	e8 cd f6 ff ff       	call   80106070 <create>
801069a3:	83 c4 10             	add    $0x10,%esp
801069a6:	85 c0                	test   %eax,%eax
801069a8:	74 16                	je     801069c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801069aa:	83 ec 0c             	sub    $0xc,%esp
801069ad:	50                   	push   %eax
801069ae:	e8 ad b9 ff ff       	call   80102360 <iunlockput>
  end_op();
801069b3:	e8 a8 cc ff ff       	call   80103660 <end_op>
  return 0;
801069b8:	83 c4 10             	add    $0x10,%esp
801069bb:	31 c0                	xor    %eax,%eax
}
801069bd:	c9                   	leave  
801069be:	c3                   	ret    
801069bf:	90                   	nop
    end_op();
801069c0:	e8 9b cc ff ff       	call   80103660 <end_op>
    return -1;
801069c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069ca:	c9                   	leave  
801069cb:	c3                   	ret    
801069cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069d0 <sys_chdir>:

int
sys_chdir(void)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	56                   	push   %esi
801069d4:	53                   	push   %ebx
801069d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801069d8:	e8 13 e5 ff ff       	call   80104ef0 <myproc>
801069dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801069df:	e8 0c cc ff ff       	call   801035f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801069e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069e7:	83 ec 08             	sub    $0x8,%esp
801069ea:	50                   	push   %eax
801069eb:	6a 00                	push   $0x0
801069ed:	e8 de f5 ff ff       	call   80105fd0 <argstr>
801069f2:	83 c4 10             	add    $0x10,%esp
801069f5:	85 c0                	test   %eax,%eax
801069f7:	78 77                	js     80106a70 <sys_chdir+0xa0>
801069f9:	83 ec 0c             	sub    $0xc,%esp
801069fc:	ff 75 f4             	pushl  -0xc(%ebp)
801069ff:	e8 2c bf ff ff       	call   80102930 <namei>
80106a04:	83 c4 10             	add    $0x10,%esp
80106a07:	85 c0                	test   %eax,%eax
80106a09:	89 c3                	mov    %eax,%ebx
80106a0b:	74 63                	je     80106a70 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106a0d:	83 ec 0c             	sub    $0xc,%esp
80106a10:	50                   	push   %eax
80106a11:	e8 ba b6 ff ff       	call   801020d0 <ilock>
  if(ip->type != T_DIR){
80106a16:	83 c4 10             	add    $0x10,%esp
80106a19:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106a1e:	75 30                	jne    80106a50 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106a20:	83 ec 0c             	sub    $0xc,%esp
80106a23:	53                   	push   %ebx
80106a24:	e8 87 b7 ff ff       	call   801021b0 <iunlock>
  iput(curproc->cwd);
80106a29:	58                   	pop    %eax
80106a2a:	ff 76 68             	pushl  0x68(%esi)
80106a2d:	e8 ce b7 ff ff       	call   80102200 <iput>
  end_op();
80106a32:	e8 29 cc ff ff       	call   80103660 <end_op>
  curproc->cwd = ip;
80106a37:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80106a3a:	83 c4 10             	add    $0x10,%esp
80106a3d:	31 c0                	xor    %eax,%eax
}
80106a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106a42:	5b                   	pop    %ebx
80106a43:	5e                   	pop    %esi
80106a44:	5d                   	pop    %ebp
80106a45:	c3                   	ret    
80106a46:	8d 76 00             	lea    0x0(%esi),%esi
80106a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106a50:	83 ec 0c             	sub    $0xc,%esp
80106a53:	53                   	push   %ebx
80106a54:	e8 07 b9 ff ff       	call   80102360 <iunlockput>
    end_op();
80106a59:	e8 02 cc ff ff       	call   80103660 <end_op>
    return -1;
80106a5e:	83 c4 10             	add    $0x10,%esp
80106a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a66:	eb d7                	jmp    80106a3f <sys_chdir+0x6f>
80106a68:	90                   	nop
80106a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106a70:	e8 eb cb ff ff       	call   80103660 <end_op>
    return -1;
80106a75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a7a:	eb c3                	jmp    80106a3f <sys_chdir+0x6f>
80106a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a80 <sys_exec>:

int
sys_exec(void)
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	57                   	push   %edi
80106a84:	56                   	push   %esi
80106a85:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106a86:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80106a8c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106a92:	50                   	push   %eax
80106a93:	6a 00                	push   $0x0
80106a95:	e8 36 f5 ff ff       	call   80105fd0 <argstr>
80106a9a:	83 c4 10             	add    $0x10,%esp
80106a9d:	85 c0                	test   %eax,%eax
80106a9f:	0f 88 87 00 00 00    	js     80106b2c <sys_exec+0xac>
80106aa5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106aab:	83 ec 08             	sub    $0x8,%esp
80106aae:	50                   	push   %eax
80106aaf:	6a 01                	push   $0x1
80106ab1:	e8 6a f4 ff ff       	call   80105f20 <argint>
80106ab6:	83 c4 10             	add    $0x10,%esp
80106ab9:	85 c0                	test   %eax,%eax
80106abb:	78 6f                	js     80106b2c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106abd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106ac3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106ac6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106ac8:	68 80 00 00 00       	push   $0x80
80106acd:	6a 00                	push   $0x0
80106acf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106ad5:	50                   	push   %eax
80106ad6:	e8 85 f0 ff ff       	call   80105b60 <memset>
80106adb:	83 c4 10             	add    $0x10,%esp
80106ade:	eb 2c                	jmp    80106b0c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106ae0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106ae6:	85 c0                	test   %eax,%eax
80106ae8:	74 56                	je     80106b40 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106aea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106af0:	83 ec 08             	sub    $0x8,%esp
80106af3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106af6:	52                   	push   %edx
80106af7:	50                   	push   %eax
80106af8:	e8 b3 f3 ff ff       	call   80105eb0 <fetchstr>
80106afd:	83 c4 10             	add    $0x10,%esp
80106b00:	85 c0                	test   %eax,%eax
80106b02:	78 28                	js     80106b2c <sys_exec+0xac>
  for(i=0;; i++){
80106b04:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106b07:	83 fb 20             	cmp    $0x20,%ebx
80106b0a:	74 20                	je     80106b2c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106b0c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106b12:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106b19:	83 ec 08             	sub    $0x8,%esp
80106b1c:	57                   	push   %edi
80106b1d:	01 f0                	add    %esi,%eax
80106b1f:	50                   	push   %eax
80106b20:	e8 4b f3 ff ff       	call   80105e70 <fetchint>
80106b25:	83 c4 10             	add    $0x10,%esp
80106b28:	85 c0                	test   %eax,%eax
80106b2a:	79 b4                	jns    80106ae0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80106b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106b2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b34:	5b                   	pop    %ebx
80106b35:	5e                   	pop    %esi
80106b36:	5f                   	pop    %edi
80106b37:	5d                   	pop    %ebp
80106b38:	c3                   	ret    
80106b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106b40:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106b46:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106b49:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106b50:	00 00 00 00 
  return exec(path, argv);
80106b54:	50                   	push   %eax
80106b55:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106b5b:	e8 90 a4 ff ff       	call   80100ff0 <exec>
80106b60:	83 c4 10             	add    $0x10,%esp
}
80106b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b66:	5b                   	pop    %ebx
80106b67:	5e                   	pop    %esi
80106b68:	5f                   	pop    %edi
80106b69:	5d                   	pop    %ebp
80106b6a:	c3                   	ret    
80106b6b:	90                   	nop
80106b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b70 <sys_pipe>:

int
sys_pipe(void)
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106b76:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106b79:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106b7c:	6a 08                	push   $0x8
80106b7e:	50                   	push   %eax
80106b7f:	6a 00                	push   $0x0
80106b81:	e8 ea f3 ff ff       	call   80105f70 <argptr>
80106b86:	83 c4 10             	add    $0x10,%esp
80106b89:	85 c0                	test   %eax,%eax
80106b8b:	0f 88 ae 00 00 00    	js     80106c3f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106b91:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106b94:	83 ec 08             	sub    $0x8,%esp
80106b97:	50                   	push   %eax
80106b98:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106b9b:	50                   	push   %eax
80106b9c:	e8 af dd ff ff       	call   80104950 <pipealloc>
80106ba1:	83 c4 10             	add    $0x10,%esp
80106ba4:	85 c0                	test   %eax,%eax
80106ba6:	0f 88 93 00 00 00    	js     80106c3f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106bac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106baf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106bb1:	e8 3a e3 ff ff       	call   80104ef0 <myproc>
80106bb6:	eb 10                	jmp    80106bc8 <sys_pipe+0x58>
80106bb8:	90                   	nop
80106bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106bc0:	83 c3 01             	add    $0x1,%ebx
80106bc3:	83 fb 10             	cmp    $0x10,%ebx
80106bc6:	74 60                	je     80106c28 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106bc8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106bcc:	85 f6                	test   %esi,%esi
80106bce:	75 f0                	jne    80106bc0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106bd0:	8d 73 08             	lea    0x8(%ebx),%esi
80106bd3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106bd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106bda:	e8 11 e3 ff ff       	call   80104ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106bdf:	31 d2                	xor    %edx,%edx
80106be1:	eb 0d                	jmp    80106bf0 <sys_pipe+0x80>
80106be3:	90                   	nop
80106be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106be8:	83 c2 01             	add    $0x1,%edx
80106beb:	83 fa 10             	cmp    $0x10,%edx
80106bee:	74 28                	je     80106c18 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106bf0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106bf4:	85 c9                	test   %ecx,%ecx
80106bf6:	75 f0                	jne    80106be8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106bf8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80106bfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106bff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106c01:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106c04:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106c07:	31 c0                	xor    %eax,%eax
}
80106c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c0c:	5b                   	pop    %ebx
80106c0d:	5e                   	pop    %esi
80106c0e:	5f                   	pop    %edi
80106c0f:	5d                   	pop    %ebp
80106c10:	c3                   	ret    
80106c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106c18:	e8 d3 e2 ff ff       	call   80104ef0 <myproc>
80106c1d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106c24:	00 
80106c25:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106c28:	83 ec 0c             	sub    $0xc,%esp
80106c2b:	ff 75 e0             	pushl  -0x20(%ebp)
80106c2e:	e8 cd ab ff ff       	call   80101800 <fileclose>
    fileclose(wf);
80106c33:	58                   	pop    %eax
80106c34:	ff 75 e4             	pushl  -0x1c(%ebp)
80106c37:	e8 c4 ab ff ff       	call   80101800 <fileclose>
    return -1;
80106c3c:	83 c4 10             	add    $0x10,%esp
80106c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c44:	eb c3                	jmp    80106c09 <sys_pipe+0x99>
80106c46:	8d 76 00             	lea    0x0(%esi),%esi
80106c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c50 <sys_connect>:

int
sys_connect(void)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	53                   	push   %ebx
  int fd;
  uint32 raddr;
  uint32 rport;
  uint32 lport;

  if (argint(0, (int*)&raddr) < 0 ||
80106c54:	8d 45 ec             	lea    -0x14(%ebp),%eax
{
80106c57:	83 ec 1c             	sub    $0x1c,%esp
  if (argint(0, (int*)&raddr) < 0 ||
80106c5a:	50                   	push   %eax
80106c5b:	6a 00                	push   $0x0
80106c5d:	e8 be f2 ff ff       	call   80105f20 <argint>
80106c62:	83 c4 10             	add    $0x10,%esp
80106c65:	85 c0                	test   %eax,%eax
80106c67:	0f 88 81 00 00 00    	js     80106cee <sys_connect+0x9e>
      argint(1, (int*)&lport) < 0 ||
80106c6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c70:	83 ec 08             	sub    $0x8,%esp
80106c73:	50                   	push   %eax
80106c74:	6a 01                	push   $0x1
80106c76:	e8 a5 f2 ff ff       	call   80105f20 <argint>
  if (argint(0, (int*)&raddr) < 0 ||
80106c7b:	83 c4 10             	add    $0x10,%esp
80106c7e:	85 c0                	test   %eax,%eax
80106c80:	78 6c                	js     80106cee <sys_connect+0x9e>
      argint(2, (int*)&rport) < 0) {
80106c82:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c85:	83 ec 08             	sub    $0x8,%esp
80106c88:	50                   	push   %eax
80106c89:	6a 02                	push   $0x2
80106c8b:	e8 90 f2 ff ff       	call   80105f20 <argint>
      argint(1, (int*)&lport) < 0 ||
80106c90:	83 c4 10             	add    $0x10,%esp
80106c93:	85 c0                	test   %eax,%eax
80106c95:	78 57                	js     80106cee <sys_connect+0x9e>
    return -1;
  }

  if(sockalloc(&f, raddr, lport, rport) < 0)
80106c97:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
80106c9b:	50                   	push   %eax
80106c9c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
80106ca0:	50                   	push   %eax
80106ca1:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106ca4:	ff 75 ec             	pushl  -0x14(%ebp)
80106ca7:	50                   	push   %eax
80106ca8:	e8 73 00 00 00       	call   80106d20 <sockalloc>
80106cad:	83 c4 10             	add    $0x10,%esp
80106cb0:	85 c0                	test   %eax,%eax
80106cb2:	78 3a                	js     80106cee <sys_connect+0x9e>
    return -1;
  if((fd=fdalloc(f)) < 0){
80106cb4:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  struct proc *curproc = myproc();
80106cb7:	e8 34 e2 ff ff       	call   80104ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106cbc:	31 d2                	xor    %edx,%edx
80106cbe:	eb 08                	jmp    80106cc8 <sys_connect+0x78>
80106cc0:	83 c2 01             	add    $0x1,%edx
80106cc3:	83 fa 10             	cmp    $0x10,%edx
80106cc6:	74 18                	je     80106ce0 <sys_connect+0x90>
    if(curproc->ofile[fd] == 0){
80106cc8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106ccc:	85 c9                	test   %ecx,%ecx
80106cce:	75 f0                	jne    80106cc0 <sys_connect+0x70>
      curproc->ofile[fd] = f;
80106cd0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
    fileclose(f);
    return -1;
  }

  return fd;
}
80106cd4:	89 d0                	mov    %edx,%eax
80106cd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106cd9:	c9                   	leave  
80106cda:	c3                   	ret    
80106cdb:	90                   	nop
80106cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fileclose(f);
80106ce0:	83 ec 0c             	sub    $0xc,%esp
80106ce3:	ff 75 e8             	pushl  -0x18(%ebp)
80106ce6:	e8 15 ab ff ff       	call   80101800 <fileclose>
    return -1;
80106ceb:	83 c4 10             	add    $0x10,%esp
80106cee:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
80106cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106cf6:	89 d0                	mov    %edx,%eax
80106cf8:	c9                   	leave  
80106cf9:	c3                   	ret    
80106cfa:	66 90                	xchg   %ax,%ax
80106cfc:	66 90                	xchg   %ax,%ax
80106cfe:	66 90                	xchg   %ax,%ax

80106d00 <sockinit>:
static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	83 ec 10             	sub    $0x10,%esp
  initlock(&lock, "socktbl");
80106d06:	68 41 99 10 80       	push   $0x80109941
80106d0b:	68 20 2e 15 80       	push   $0x80152e20
80106d10:	e8 db eb ff ff       	call   801058f0 <initlock>
}
80106d15:	83 c4 10             	add    $0x10,%esp
80106d18:	c9                   	leave  
80106d19:	c3                   	ret    
80106d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d20 <sockalloc>:

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 1c             	sub    $0x1c,%esp
80106d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106d2c:	8b 45 14             	mov    0x14(%ebp),%eax
80106d2f:	8b 7d 10             	mov    0x10(%ebp),%edi
80106d32:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct sock *si, *pos;

  si = 0;
  *f = 0;
80106d35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
{
80106d3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d3e:	66 89 7d e0          	mov    %di,-0x20(%ebp)
80106d42:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
  if ((*f = filealloc()) == 0)
80106d46:	e8 f5 a9 ff ff       	call   80101740 <filealloc>
80106d4b:	85 c0                	test   %eax,%eax
80106d4d:	89 03                	mov    %eax,(%ebx)
80106d4f:	0f 84 e9 00 00 00    	je     80106e3e <sockalloc+0x11e>
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
80106d55:	e8 b6 c1 ff ff       	call   80102f10 <kalloc>
80106d5a:	85 c0                	test   %eax,%eax
80106d5c:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d5f:	0f 84 c7 00 00 00    	je     80106e2c <sockalloc+0x10c>
    goto bad;

  cprintf("sock allocated add %x lp %d rp %d\n",raddr,lport,rport);
80106d65:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80106d69:	52                   	push   %edx
80106d6a:	0f b7 d7             	movzwl %di,%edx
80106d6d:	52                   	push   %edx
80106d6e:	56                   	push   %esi
80106d6f:	68 f4 99 10 80       	push   $0x801099f4
80106d74:	e8 c7 9e ff ff       	call   80100c40 <cprintf>
  // initialize objects
  si->raddr = raddr;
  si->lport = lport;
  si->rport = rport;
80106d79:	0f b7 4d e4          	movzwl -0x1c(%ebp),%ecx
  si->raddr = raddr;
80106d7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106d80:	89 70 04             	mov    %esi,0x4(%eax)
  si->lport = lport;
80106d83:	66 89 78 08          	mov    %di,0x8(%eax)
  si->rport = rport;
80106d87:	66 89 48 0a          	mov    %cx,0xa(%eax)
  initlock(&si->lock, "sock");
80106d8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d8e:	5a                   	pop    %edx
80106d8f:	8d 50 0c             	lea    0xc(%eax),%edx
80106d92:	59                   	pop    %ecx
80106d93:	68 49 99 10 80       	push   $0x80109949
80106d98:	52                   	push   %edx
80106d99:	e8 52 eb ff ff       	call   801058f0 <initlock>
  mbufq_init(&si->rxq);
80106d9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106da1:	8d 50 40             	lea    0x40(%eax),%edx
80106da4:	89 14 24             	mov    %edx,(%esp)
80106da7:	e8 64 d1 ff ff       	call   80103f10 <mbufq_init>
  (*f)->type = FD_SOCK;
80106dac:	8b 13                	mov    (%ebx),%edx
  (*f)->readable = 1;
  (*f)->writable = 1;
  (*f)->sock = si;
80106dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  (*f)->type = FD_SOCK;
80106db1:	c7 02 04 00 00 00    	movl   $0x4,(%edx)
  (*f)->readable = 1;
80106db7:	8b 13                	mov    (%ebx),%edx
80106db9:	c6 42 08 01          	movb   $0x1,0x8(%edx)
  (*f)->writable = 1;
80106dbd:	8b 13                	mov    (%ebx),%edx
80106dbf:	c6 42 09 01          	movb   $0x1,0x9(%edx)
  (*f)->sock = si;
80106dc3:	8b 13                	mov    (%ebx),%edx
80106dc5:	89 42 18             	mov    %eax,0x18(%edx)

  // add to list of sockets
  acquire(&lock);
80106dc8:	c7 04 24 20 2e 15 80 	movl   $0x80152e20,(%esp)
80106dcf:	e8 0c ec ff ff       	call   801059e0 <acquire>
  pos = sockets;
80106dd4:	8b 0d 00 2e 15 80    	mov    0x80152e00,%ecx
  while (pos) {
80106dda:	83 c4 10             	add    $0x10,%esp
80106ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106de0:	85 c9                	test   %ecx,%ecx
80106de2:	74 6c                	je     80106e50 <sockalloc+0x130>
80106de4:	89 ca                	mov    %ecx,%edx
80106de6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106de9:	0f b7 7d e0          	movzwl -0x20(%ebp),%edi
80106ded:	eb 07                	jmp    80106df6 <sockalloc+0xd6>
80106def:	90                   	nop
        pos->lport == lport &&
	pos->rport == rport) {
      release(&lock);
      goto bad;
    }
    pos = pos->next;
80106df0:	8b 12                	mov    (%edx),%edx
  while (pos) {
80106df2:	85 d2                	test   %edx,%edx
80106df4:	74 5a                	je     80106e50 <sockalloc+0x130>
    if (pos->raddr == raddr &&
80106df6:	39 72 04             	cmp    %esi,0x4(%edx)
80106df9:	75 f5                	jne    80106df0 <sockalloc+0xd0>
80106dfb:	66 39 7a 08          	cmp    %di,0x8(%edx)
80106dff:	75 ef                	jne    80106df0 <sockalloc+0xd0>
        pos->lport == lport &&
80106e01:	0f b7 5d e2          	movzwl -0x1e(%ebp),%ebx
80106e05:	66 39 5a 0a          	cmp    %bx,0xa(%edx)
80106e09:	75 e5                	jne    80106df0 <sockalloc+0xd0>
      release(&lock);
80106e0b:	83 ec 0c             	sub    $0xc,%esp
80106e0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106e14:	68 20 2e 15 80       	push   $0x80152e20
80106e19:	e8 e2 ec ff ff       	call   80105b00 <release>
  release(&lock);
  return 0;

bad:
  if (si)
    kfree((char*)si);
80106e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e21:	89 04 24             	mov    %eax,(%esp)
80106e24:	e8 37 bf ff ff       	call   80102d60 <kfree>
80106e29:	83 c4 10             	add    $0x10,%esp
  if (*f)
80106e2c:	8b 03                	mov    (%ebx),%eax
80106e2e:	85 c0                	test   %eax,%eax
80106e30:	74 0c                	je     80106e3e <sockalloc+0x11e>
    fileclose(*f);
80106e32:	83 ec 0c             	sub    $0xc,%esp
80106e35:	50                   	push   %eax
80106e36:	e8 c5 a9 ff ff       	call   80101800 <fileclose>
80106e3b:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80106e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80106e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e46:	5b                   	pop    %ebx
80106e47:	5e                   	pop    %esi
80106e48:	5f                   	pop    %edi
80106e49:	5d                   	pop    %ebp
80106e4a:	c3                   	ret    
80106e4b:	90                   	nop
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  cprintf("added to sockets %x lp %d rp %d\n",si->raddr,si->lport,si->rport);
80106e50:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
  si->next = sockets;
80106e54:	89 08                	mov    %ecx,(%eax)
  sockets = si;
80106e56:	a3 00 2e 15 80       	mov    %eax,0x80152e00
  cprintf("added to sockets %x lp %d rp %d\n",si->raddr,si->lport,si->rport);
80106e5b:	52                   	push   %edx
80106e5c:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80106e60:	52                   	push   %edx
80106e61:	ff 70 04             	pushl  0x4(%eax)
80106e64:	68 18 9a 10 80       	push   $0x80109a18
80106e69:	e8 d2 9d ff ff       	call   80100c40 <cprintf>
  release(&lock);
80106e6e:	c7 04 24 20 2e 15 80 	movl   $0x80152e20,(%esp)
80106e75:	e8 86 ec ff ff       	call   80105b00 <release>
  return 0;
80106e7a:	83 c4 10             	add    $0x10,%esp
}
80106e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e80:	31 c0                	xor    %eax,%eax
}
80106e82:	5b                   	pop    %ebx
80106e83:	5e                   	pop    %esi
80106e84:	5f                   	pop    %edi
80106e85:	5d                   	pop    %ebp
80106e86:	c3                   	ret    
80106e87:	89 f6                	mov    %esi,%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e90 <sockclose>:
// Add and wire in methods to handle closing, reading,
// and writing for network sockets.
//
void
sockclose(struct sock *si)
{struct sock  *pos,*prev;
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
80106e99:	8b 7d 08             	mov    0x8(%ebp),%edi
if (!si) return;
80106e9c:	85 ff                	test   %edi,%edi
80106e9e:	0f 84 ac 00 00 00    	je     80106f50 <sockclose+0xc0>
acquire(&lock);
80106ea4:	83 ec 0c             	sub    $0xc,%esp
80106ea7:	68 20 2e 15 80       	push   $0x80152e20
80106eac:	e8 2f eb ff ff       	call   801059e0 <acquire>
	  prev = pos = sockets;
80106eb1:	8b 35 00 2e 15 80    	mov    0x80152e00,%esi
	  while (pos) {
80106eb7:	83 c4 10             	add    $0x10,%esp
80106eba:	85 f6                	test   %esi,%esi
80106ebc:	74 7e                	je     80106f3c <sockclose+0xac>
	    if (pos->raddr == si->raddr &&
80106ebe:	8b 4f 04             	mov    0x4(%edi),%ecx
80106ec1:	89 f3                	mov    %esi,%ebx
80106ec3:	eb 0d                	jmp    80106ed2 <sockclose+0x42>
80106ec5:	8d 76 00             	lea    0x0(%esi),%esi
	      kfree((char*)si);
	      release(&lock);
	      return;
	    }
	    prev=pos;
	    pos = pos->next;
80106ec8:	8b 03                	mov    (%ebx),%eax
80106eca:	89 de                	mov    %ebx,%esi
	  while (pos) {
80106ecc:	85 c0                	test   %eax,%eax
80106ece:	74 6c                	je     80106f3c <sockclose+0xac>
80106ed0:	89 c3                	mov    %eax,%ebx
	    if (pos->raddr == si->raddr &&
80106ed2:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80106ed5:	75 f1                	jne    80106ec8 <sockclose+0x38>
	        pos->lport == si->lport &&
80106ed7:	8b 47 08             	mov    0x8(%edi),%eax
80106eda:	39 43 08             	cmp    %eax,0x8(%ebx)
80106edd:	75 e9                	jne    80106ec8 <sockclose+0x38>
80106edf:	8d 47 40             	lea    0x40(%edi),%eax
80106ee2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ee5:	eb 15                	jmp    80106efc <sockclose+0x6c>
80106ee7:	89 f6                	mov    %esi,%esi
80106ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	    	  mbuffree(m);
80106ef0:	83 ec 0c             	sub    $0xc,%esp
80106ef3:	50                   	push   %eax
80106ef4:	e8 77 cf ff ff       	call   80103e70 <mbuffree>
80106ef9:	83 c4 10             	add    $0x10,%esp
	      while ((m=mbufq_pophead(&si->rxq)))
80106efc:	83 ec 0c             	sub    $0xc,%esp
80106eff:	ff 75 e4             	pushl  -0x1c(%ebp)
80106f02:	e8 c9 cf ff ff       	call   80103ed0 <mbufq_pophead>
80106f07:	83 c4 10             	add    $0x10,%esp
80106f0a:	85 c0                	test   %eax,%eax
80106f0c:	75 e2                	jne    80106ef0 <sockclose+0x60>
	      if (pos == sockets)
80106f0e:	39 1d 00 2e 15 80    	cmp    %ebx,0x80152e00
80106f14:	8b 03                	mov    (%ebx),%eax
80106f16:	74 40                	je     80106f58 <sockclose+0xc8>
	    	  prev->next = pos->next;
80106f18:	89 06                	mov    %eax,(%esi)
	      cprintf("sockclose ra %x lp %d rp %d\n",si->raddr,si->lport,si->rport);
80106f1a:	0f b7 47 0a          	movzwl 0xa(%edi),%eax
80106f1e:	50                   	push   %eax
80106f1f:	0f b7 47 08          	movzwl 0x8(%edi),%eax
80106f23:	50                   	push   %eax
80106f24:	ff 77 04             	pushl  0x4(%edi)
80106f27:	68 4e 99 10 80       	push   $0x8010994e
80106f2c:	e8 0f 9d ff ff       	call   80100c40 <cprintf>
	      kfree((char*)si);
80106f31:	89 3c 24             	mov    %edi,(%esp)
80106f34:	e8 27 be ff ff       	call   80102d60 <kfree>
	      release(&lock);
80106f39:	83 c4 10             	add    $0x10,%esp
	  }
	  release(&lock);
80106f3c:	c7 45 08 20 2e 15 80 	movl   $0x80152e20,0x8(%ebp)
}
80106f43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f46:	5b                   	pop    %ebx
80106f47:	5e                   	pop    %esi
80106f48:	5f                   	pop    %edi
80106f49:	5d                   	pop    %ebp
	  release(&lock);
80106f4a:	e9 b1 eb ff ff       	jmp    80105b00 <release>
80106f4f:	90                   	nop
}
80106f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f53:	5b                   	pop    %ebx
80106f54:	5e                   	pop    %esi
80106f55:	5f                   	pop    %edi
80106f56:	5d                   	pop    %ebp
80106f57:	c3                   	ret    
	    	  sockets = pos->next;
80106f58:	a3 00 2e 15 80       	mov    %eax,0x80152e00
80106f5d:	eb bb                	jmp    80106f1a <sockclose+0x8a>
80106f5f:	90                   	nop

80106f60 <sockwrite>:
void
net_tx_udp(struct mbuf *m, uint32 dip,
           uint16 sport, uint16 dport);
int
sockwrite(struct sock *si, char* addr, int n)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 18             	sub    $0x18,%esp
80106f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct mbuf *m;
  //struct proc *pr = myproc();

  acquire(&si->lock);
80106f6c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80106f6f:	57                   	push   %edi
80106f70:	e8 6b ea ff ff       	call   801059e0 <acquire>




     m = mbufalloc(MBUF_DEFAULT_HEADROOM);
80106f75:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
80106f7c:	e8 8f ce ff ff       	call   80103e10 <mbufalloc>
     if (!m){
80106f81:	83 c4 10             	add    $0x10,%esp
80106f84:	85 c0                	test   %eax,%eax
80106f86:	74 5c                	je     80106fe4 <sockwrite+0x84>
    	 release(&si->lock);
       return -1;
     }
    memmove(m->head,addr,n);
80106f88:	83 ec 04             	sub    $0x4,%esp
80106f8b:	ff 75 10             	pushl  0x10(%ebp)
80106f8e:	ff 75 0c             	pushl  0xc(%ebp)
80106f91:	ff 70 04             	pushl  0x4(%eax)
80106f94:	89 c6                	mov    %eax,%esi
80106f96:	e8 75 ec ff ff       	call   80105c10 <memmove>
    //if(copyin(pr->pagetable, m->head, addr, n) == -1)
    //  return -1;
    m->len = n;
80106f9b:	8b 45 10             	mov    0x10(%ebp),%eax
80106f9e:	89 46 08             	mov    %eax,0x8(%esi)
    cprintf("net_tx_udp ra %x lp %d rp %d\n",si->raddr,si->lport,si->rport);
80106fa1:	0f b7 43 0a          	movzwl 0xa(%ebx),%eax
80106fa5:	50                   	push   %eax
80106fa6:	0f b7 43 08          	movzwl 0x8(%ebx),%eax
80106faa:	50                   	push   %eax
80106fab:	ff 73 04             	pushl  0x4(%ebx)
80106fae:	68 6b 99 10 80       	push   $0x8010996b
80106fb3:	e8 88 9c ff ff       	call   80100c40 <cprintf>
    net_tx_udp(m,si->raddr,si->lport,si->rport);
80106fb8:	0f b7 43 0a          	movzwl 0xa(%ebx),%eax
80106fbc:	83 c4 20             	add    $0x20,%esp
80106fbf:	50                   	push   %eax
80106fc0:	0f b7 43 08          	movzwl 0x8(%ebx),%eax
80106fc4:	50                   	push   %eax
80106fc5:	ff 73 04             	pushl  0x4(%ebx)
80106fc8:	56                   	push   %esi
80106fc9:	e8 52 cf ff ff       	call   80103f20 <net_tx_udp>
 // }
  release(&si->lock);
80106fce:	89 3c 24             	mov    %edi,(%esp)
80106fd1:	e8 2a eb ff ff       	call   80105b00 <release>
  return n;
80106fd6:	8b 45 10             	mov    0x10(%ebp),%eax
80106fd9:	83 c4 10             	add    $0x10,%esp
}
80106fdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fdf:	5b                   	pop    %ebx
80106fe0:	5e                   	pop    %esi
80106fe1:	5f                   	pop    %edi
80106fe2:	5d                   	pop    %ebp
80106fe3:	c3                   	ret    
    	 release(&si->lock);
80106fe4:	83 ec 0c             	sub    $0xc,%esp
80106fe7:	57                   	push   %edi
80106fe8:	e8 13 eb ff ff       	call   80105b00 <release>
       return -1;
80106fed:	83 c4 10             	add    $0x10,%esp
80106ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ff5:	eb e5                	jmp    80106fdc <sockwrite+0x7c>
80106ff7:	89 f6                	mov    %esi,%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107000 <sockread>:

int
sockread(struct sock *si, char *addr, int n)
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
80107006:	83 ec 28             	sub    $0x28,%esp
80107009:	8b 5d 08             	mov    0x8(%ebp),%ebx

  //struct proc *pr = myproc();

  acquire(&si->lock);
8010700c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010700f:	83 c3 40             	add    $0x40,%ebx
80107012:	57                   	push   %edi
80107013:	e8 c8 e9 ff ff       	call   801059e0 <acquire>
  while(mbufq_empty(&si->rxq)){  //DOC: pipe-empty
80107018:	83 c4 10             	add    $0x10,%esp
8010701b:	eb 20                	jmp    8010703d <sockread+0x3d>
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
80107020:	e8 cb de ff ff       	call   80104ef0 <myproc>
80107025:	8b 40 24             	mov    0x24(%eax),%eax
80107028:	85 c0                	test   %eax,%eax
8010702a:	0f 85 a0 00 00 00    	jne    801070d0 <sockread+0xd0>
      release(&si->lock);
      return -1;
    }
    sleep(&si->rxq, &si->lock); //DOC: piperead-sleep
80107030:	83 ec 08             	sub    $0x8,%esp
80107033:	57                   	push   %edi
80107034:	53                   	push   %ebx
80107035:	e8 56 e4 ff ff       	call   80105490 <sleep>
8010703a:	83 c4 10             	add    $0x10,%esp
  while(mbufq_empty(&si->rxq)){  //DOC: pipe-empty
8010703d:	83 ec 0c             	sub    $0xc,%esp
80107040:	53                   	push   %ebx
80107041:	e8 aa ce ff ff       	call   80103ef0 <mbufq_empty>
80107046:	83 c4 10             	add    $0x10,%esp
80107049:	85 c0                	test   %eax,%eax
8010704b:	89 c6                	mov    %eax,%esi
8010704d:	75 d1                	jne    80107020 <sockread+0x20>
  }

  struct mbuf * mp = mbufq_pophead(&si->rxq);
8010704f:	83 ec 0c             	sub    $0xc,%esp
80107052:	53                   	push   %ebx
80107053:	e8 78 ce ff ff       	call   80103ed0 <mbufq_pophead>
  if (!mp){
80107058:	83 c4 10             	add    $0x10,%esp
8010705b:	85 c0                	test   %eax,%eax
8010705d:	74 52                	je     801070b1 <sockread+0xb1>
	  release(&si->lock);
	  return 0;
  }
  cprintf("sock read got some data %d\n",mp->len);
8010705f:	83 ec 08             	sub    $0x8,%esp
80107062:	ff 70 08             	pushl  0x8(%eax)
80107065:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107068:	68 89 99 10 80       	push   $0x80109989
8010706d:	e8 ce 9b ff ff       	call   80100c40 <cprintf>
  int retval = n;
  if (n<mp->len){
80107072:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107075:	83 c4 10             	add    $0x10,%esp
80107078:	8b 42 08             	mov    0x8(%edx),%eax
8010707b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010707e:	76 70                	jbe    801070f0 <sockread+0xf0>
	  memmove(addr, mp->head,n); // copyout(pr->pagetable, addr, mp->head, n);
80107080:	83 ec 04             	sub    $0x4,%esp
80107083:	ff 75 10             	pushl  0x10(%ebp)
80107086:	ff 72 04             	pushl  0x4(%edx)
80107089:	ff 75 0c             	pushl  0xc(%ebp)
8010708c:	e8 7f eb ff ff       	call   80105c10 <memmove>
	  mbufpull(mp, n);
80107091:	58                   	pop    %eax
80107092:	5a                   	pop    %edx
80107093:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107096:	ff 75 10             	pushl  0x10(%ebp)
80107099:	52                   	push   %edx
8010709a:	e8 a1 cc ff ff       	call   80103d40 <mbufpull>
	  mbufq_pushhead(&si->rxq, mp);
8010709f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070a2:	59                   	pop    %ecx
801070a3:	5e                   	pop    %esi
801070a4:	52                   	push   %edx
801070a5:	53                   	push   %ebx
801070a6:	e8 05 ce ff ff       	call   80103eb0 <mbufq_pushhead>
  int retval = n;
801070ab:	8b 75 10             	mov    0x10(%ebp),%esi
801070ae:	83 c4 10             	add    $0x10,%esp
  else{
	  memmove(addr, mp->head,mp->len); //copyout(pr->pagetable, addr, mp->head, mp->len);
	  retval = mp->len;
	  mbuffree(mp);
  }
  release(&si->lock);
801070b1:	83 ec 0c             	sub    $0xc,%esp
801070b4:	57                   	push   %edi
801070b5:	e8 46 ea ff ff       	call   80105b00 <release>
  return retval;
801070ba:	83 c4 10             	add    $0x10,%esp
}
801070bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c0:	89 f0                	mov    %esi,%eax
801070c2:	5b                   	pop    %ebx
801070c3:	5e                   	pop    %esi
801070c4:	5f                   	pop    %edi
801070c5:	5d                   	pop    %ebp
801070c6:	c3                   	ret    
801070c7:	89 f6                	mov    %esi,%esi
801070c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&si->lock);
801070d0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801070d3:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&si->lock);
801070d8:	57                   	push   %edi
801070d9:	e8 22 ea ff ff       	call   80105b00 <release>
      return -1;
801070de:	83 c4 10             	add    $0x10,%esp
}
801070e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e4:	89 f0                	mov    %esi,%eax
801070e6:	5b                   	pop    %ebx
801070e7:	5e                   	pop    %esi
801070e8:	5f                   	pop    %edi
801070e9:	5d                   	pop    %ebp
801070ea:	c3                   	ret    
801070eb:	90                   	nop
801070ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	  memmove(addr, mp->head,mp->len); //copyout(pr->pagetable, addr, mp->head, mp->len);
801070f0:	83 ec 04             	sub    $0x4,%esp
801070f3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801070f6:	50                   	push   %eax
801070f7:	ff 72 04             	pushl  0x4(%edx)
801070fa:	ff 75 0c             	pushl  0xc(%ebp)
801070fd:	e8 0e eb ff ff       	call   80105c10 <memmove>
	  retval = mp->len;
80107102:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107105:	8b 72 08             	mov    0x8(%edx),%esi
	  mbuffree(mp);
80107108:	89 14 24             	mov    %edx,(%esp)
8010710b:	e8 60 cd ff ff       	call   80103e70 <mbuffree>
80107110:	83 c4 10             	add    $0x10,%esp
80107113:	eb 9c                	jmp    801070b1 <sockread+0xb1>
80107115:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107120 <sockrecvudp>:
// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 28             	sub    $0x28,%esp
80107129:	8b 55 10             	mov    0x10(%ebp),%edx
8010712c:	8b 45 08             	mov    0x8(%ebp),%eax
8010712f:	8b 75 14             	mov    0x14(%ebp),%esi
  //
  // Find the socket that handles this mbuf and deliver it, waking
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
	 acquire(&lock);
80107132:	68 20 2e 15 80       	push   $0x80152e20
{
80107137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010713a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010713d:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
80107141:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107144:	66 89 75 e6          	mov    %si,-0x1a(%ebp)
	 struct sock *pos;
	 pos = sockets;
	 cprintf("check ra %x lp %d rp %d\n",raddr,lport,rport);
80107148:	0f b7 f6             	movzwl %si,%esi
	 acquire(&lock);
8010714b:	e8 90 e8 ff ff       	call   801059e0 <acquire>
	 cprintf("check ra %x lp %d rp %d\n",raddr,lport,rport);
80107150:	8b 55 e0             	mov    -0x20(%ebp),%edx
	 pos = sockets;
80107153:	8b 3d 00 2e 15 80    	mov    0x80152e00,%edi
	 cprintf("check ra %x lp %d rp %d\n",raddr,lport,rport);
80107159:	56                   	push   %esi
8010715a:	0f b7 c2             	movzwl %dx,%eax
8010715d:	50                   	push   %eax
8010715e:	53                   	push   %ebx
8010715f:	68 a5 99 10 80       	push   $0x801099a5
80107164:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107167:	e8 d4 9a ff ff       	call   80100c40 <cprintf>
	  while (pos) {
8010716c:	83 c4 20             	add    $0x20,%esp
8010716f:	85 ff                	test   %edi,%edi
80107171:	74 78                	je     801071eb <sockrecvudp+0xcb>
80107173:	89 75 dc             	mov    %esi,-0x24(%ebp)
80107176:	89 fe                	mov    %edi,%esi
80107178:	0f b7 7d e4          	movzwl -0x1c(%ebp),%edi
8010717c:	eb 08                	jmp    80107186 <sockrecvudp+0x66>
8010717e:	66 90                	xchg   %ax,%ax
	      mbufq_pushtail(&pos->rxq,m);
	      wakeup(&pos->rxq);
		  release(&lock);
          return;
	    }
	    pos = pos->next;
80107180:	8b 36                	mov    (%esi),%esi
	  while (pos) {
80107182:	85 f6                	test   %esi,%esi
80107184:	74 62                	je     801071e8 <sockrecvudp+0xc8>
		  cprintf("loop ra %x lp %d rp %d\n",pos->raddr,pos->lport,pos->rport);
80107186:	0f b7 56 0a          	movzwl 0xa(%esi),%edx
8010718a:	52                   	push   %edx
8010718b:	0f b7 56 08          	movzwl 0x8(%esi),%edx
8010718f:	52                   	push   %edx
80107190:	ff 76 04             	pushl  0x4(%esi)
80107193:	68 be 99 10 80       	push   $0x801099be
80107198:	e8 a3 9a ff ff       	call   80100c40 <cprintf>
	    if (pos->raddr == raddr &&
8010719d:	83 c4 10             	add    $0x10,%esp
801071a0:	39 5e 04             	cmp    %ebx,0x4(%esi)
801071a3:	75 db                	jne    80107180 <sockrecvudp+0x60>
801071a5:	66 39 7e 08          	cmp    %di,0x8(%esi)
801071a9:	75 d5                	jne    80107180 <sockrecvudp+0x60>
	        pos->lport == lport &&
801071ab:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801071af:	66 39 46 0a          	cmp    %ax,0xa(%esi)
801071b3:	75 cb                	jne    80107180 <sockrecvudp+0x60>
801071b5:	89 f7                	mov    %esi,%edi
801071b7:	8b 75 dc             	mov    -0x24(%ebp),%esi
cprintf("calling mbufq_pushtail ra %x lp %x rp %x\n",pos->raddr,lport,rport);
801071ba:	56                   	push   %esi
801071bb:	ff 75 e0             	pushl  -0x20(%ebp)
801071be:	53                   	push   %ebx
801071bf:	68 3c 9a 10 80       	push   $0x80109a3c
	      mbufq_pushtail(&pos->rxq,m);
801071c4:	8d 5f 40             	lea    0x40(%edi),%ebx
cprintf("calling mbufq_pushtail ra %x lp %x rp %x\n",pos->raddr,lport,rport);
801071c7:	e8 74 9a ff ff       	call   80100c40 <cprintf>
	      mbufq_pushtail(&pos->rxq,m);
801071cc:	58                   	pop    %eax
801071cd:	5a                   	pop    %edx
801071ce:	ff 75 d8             	pushl  -0x28(%ebp)
801071d1:	53                   	push   %ebx
801071d2:	e8 a9 cc ff ff       	call   80103e80 <mbufq_pushtail>
	      wakeup(&pos->rxq);
801071d7:	89 1c 24             	mov    %ebx,(%esp)
801071da:	e8 61 e4 ff ff       	call   80105640 <wakeup>
801071df:	eb 19                	jmp    801071fa <sockrecvudp+0xda>
801071e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071e8:	8b 75 dc             	mov    -0x24(%ebp),%esi
	  }
cprintf("no match ra %x lp %d rp %d\n",raddr,lport,rport);
801071eb:	56                   	push   %esi
801071ec:	ff 75 e0             	pushl  -0x20(%ebp)
801071ef:	53                   	push   %ebx
801071f0:	68 d6 99 10 80       	push   $0x801099d6
801071f5:	e8 46 9a ff ff       	call   80100c40 <cprintf>
  release(&lock);
801071fa:	c7 45 08 20 2e 15 80 	movl   $0x80152e20,0x8(%ebp)
80107201:	83 c4 10             	add    $0x10,%esp
  //mbuffree(m);
}
80107204:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107207:	5b                   	pop    %ebx
80107208:	5e                   	pop    %esi
80107209:	5f                   	pop    %edi
8010720a:	5d                   	pop    %ebp
  release(&lock);
8010720b:	e9 f0 e8 ff ff       	jmp    80105b00 <release>

80107210 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
  return fork();
}
80107213:	5d                   	pop    %ebp
  return fork();
80107214:	e9 77 de ff ff       	jmp    80105090 <fork>
80107219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107220 <sys_exit>:

int
sys_exit(void)
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	83 ec 08             	sub    $0x8,%esp
  exit();
80107226:	e8 e5 e0 ff ff       	call   80105310 <exit>
  return 0;  // not reached
}
8010722b:	31 c0                	xor    %eax,%eax
8010722d:	c9                   	leave  
8010722e:	c3                   	ret    
8010722f:	90                   	nop

80107230 <sys_wait>:

int
sys_wait(void)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
  return wait();
}
80107233:	5d                   	pop    %ebp
  return wait();
80107234:	e9 17 e3 ff ff       	jmp    80105550 <wait>
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107240 <sys_kill>:

int
sys_kill(void)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107246:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107249:	50                   	push   %eax
8010724a:	6a 00                	push   $0x0
8010724c:	e8 cf ec ff ff       	call   80105f20 <argint>
80107251:	83 c4 10             	add    $0x10,%esp
80107254:	85 c0                	test   %eax,%eax
80107256:	78 18                	js     80107270 <sys_kill+0x30>
    return -1;
  return kill(pid);
80107258:	83 ec 0c             	sub    $0xc,%esp
8010725b:	ff 75 f4             	pushl  -0xc(%ebp)
8010725e:	e8 3d e4 ff ff       	call   801056a0 <kill>
80107263:	83 c4 10             	add    $0x10,%esp
}
80107266:	c9                   	leave  
80107267:	c3                   	ret    
80107268:	90                   	nop
80107269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107275:	c9                   	leave  
80107276:	c3                   	ret    
80107277:	89 f6                	mov    %esi,%esi
80107279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107280 <sys_getpid>:

int
sys_getpid(void)
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80107286:	e8 65 dc ff ff       	call   80104ef0 <myproc>
8010728b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010728e:	c9                   	leave  
8010728f:	c3                   	ret    

80107290 <sys_sbrk>:

int
sys_sbrk(void)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107294:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80107297:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010729a:	50                   	push   %eax
8010729b:	6a 00                	push   $0x0
8010729d:	e8 7e ec ff ff       	call   80105f20 <argint>
801072a2:	83 c4 10             	add    $0x10,%esp
801072a5:	85 c0                	test   %eax,%eax
801072a7:	78 27                	js     801072d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801072a9:	e8 42 dc ff ff       	call   80104ef0 <myproc>
  if(growproc(n) < 0)
801072ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801072b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801072b3:	ff 75 f4             	pushl  -0xc(%ebp)
801072b6:	e8 55 dd ff ff       	call   80105010 <growproc>
801072bb:	83 c4 10             	add    $0x10,%esp
801072be:	85 c0                	test   %eax,%eax
801072c0:	78 0e                	js     801072d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801072c2:	89 d8                	mov    %ebx,%eax
801072c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801072c7:	c9                   	leave  
801072c8:	c3                   	ret    
801072c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801072d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801072d5:	eb eb                	jmp    801072c2 <sys_sbrk+0x32>
801072d7:	89 f6                	mov    %esi,%esi
801072d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072e0 <sys_sleep>:

int
sys_sleep(void)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801072e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801072e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801072ea:	50                   	push   %eax
801072eb:	6a 00                	push   $0x0
801072ed:	e8 2e ec ff ff       	call   80105f20 <argint>
801072f2:	83 c4 10             	add    $0x10,%esp
801072f5:	85 c0                	test   %eax,%eax
801072f7:	0f 88 8a 00 00 00    	js     80107387 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801072fd:	83 ec 0c             	sub    $0xc,%esp
80107300:	68 20 d8 15 80       	push   $0x8015d820
80107305:	e8 d6 e6 ff ff       	call   801059e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010730a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010730d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80107310:	8b 1d 60 e0 15 80    	mov    0x8015e060,%ebx
  while(ticks - ticks0 < n){
80107316:	85 d2                	test   %edx,%edx
80107318:	75 27                	jne    80107341 <sys_sleep+0x61>
8010731a:	eb 54                	jmp    80107370 <sys_sleep+0x90>
8010731c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80107320:	83 ec 08             	sub    $0x8,%esp
80107323:	68 20 d8 15 80       	push   $0x8015d820
80107328:	68 60 e0 15 80       	push   $0x8015e060
8010732d:	e8 5e e1 ff ff       	call   80105490 <sleep>
  while(ticks - ticks0 < n){
80107332:	a1 60 e0 15 80       	mov    0x8015e060,%eax
80107337:	83 c4 10             	add    $0x10,%esp
8010733a:	29 d8                	sub    %ebx,%eax
8010733c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010733f:	73 2f                	jae    80107370 <sys_sleep+0x90>
    if(myproc()->killed){
80107341:	e8 aa db ff ff       	call   80104ef0 <myproc>
80107346:	8b 40 24             	mov    0x24(%eax),%eax
80107349:	85 c0                	test   %eax,%eax
8010734b:	74 d3                	je     80107320 <sys_sleep+0x40>
      release(&tickslock);
8010734d:	83 ec 0c             	sub    $0xc,%esp
80107350:	68 20 d8 15 80       	push   $0x8015d820
80107355:	e8 a6 e7 ff ff       	call   80105b00 <release>
      return -1;
8010735a:	83 c4 10             	add    $0x10,%esp
8010735d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80107362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107365:	c9                   	leave  
80107366:	c3                   	ret    
80107367:	89 f6                	mov    %esi,%esi
80107369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80107370:	83 ec 0c             	sub    $0xc,%esp
80107373:	68 20 d8 15 80       	push   $0x8015d820
80107378:	e8 83 e7 ff ff       	call   80105b00 <release>
  return 0;
8010737d:	83 c4 10             	add    $0x10,%esp
80107380:	31 c0                	xor    %eax,%eax
}
80107382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107385:	c9                   	leave  
80107386:	c3                   	ret    
    return -1;
80107387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010738c:	eb f4                	jmp    80107382 <sys_sleep+0xa2>
8010738e:	66 90                	xchg   %ax,%ax

80107390 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	53                   	push   %ebx
80107394:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80107397:	68 20 d8 15 80       	push   $0x8015d820
8010739c:	e8 3f e6 ff ff       	call   801059e0 <acquire>
  xticks = ticks;
801073a1:	8b 1d 60 e0 15 80    	mov    0x8015e060,%ebx
  release(&tickslock);
801073a7:	c7 04 24 20 d8 15 80 	movl   $0x8015d820,(%esp)
801073ae:	e8 4d e7 ff ff       	call   80105b00 <release>
  return xticks;
}
801073b3:	89 d8                	mov    %ebx,%eax
801073b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801073b8:	c9                   	leave  
801073b9:	c3                   	ret    

801073ba <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801073ba:	1e                   	push   %ds
  pushl %es
801073bb:	06                   	push   %es
  pushl %fs
801073bc:	0f a0                	push   %fs
  pushl %gs
801073be:	0f a8                	push   %gs
  pushal
801073c0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801073c1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801073c5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801073c7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801073c9:	54                   	push   %esp
  call trap
801073ca:	e8 c1 00 00 00       	call   80107490 <trap>
  addl $4, %esp
801073cf:	83 c4 04             	add    $0x4,%esp

801073d2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801073d2:	61                   	popa   
  popl %gs
801073d3:	0f a9                	pop    %gs
  popl %fs
801073d5:	0f a1                	pop    %fs
  popl %es
801073d7:	07                   	pop    %es
  popl %ds
801073d8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801073d9:	83 c4 08             	add    $0x8,%esp
  iret
801073dc:	cf                   	iret   
801073dd:	66 90                	xchg   %ax,%ax
801073df:	90                   	nop

801073e0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801073e0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801073e1:	31 c0                	xor    %eax,%eax
{
801073e3:	89 e5                	mov    %esp,%ebp
801073e5:	83 ec 08             	sub    $0x8,%esp
801073e8:	90                   	nop
801073e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801073f0:	8b 14 85 48 c0 10 80 	mov    -0x7fef3fb8(,%eax,4),%edx
801073f7:	c7 04 c5 62 d8 15 80 	movl   $0x8e000008,-0x7fea279e(,%eax,8)
801073fe:	08 00 00 8e 
80107402:	66 89 14 c5 60 d8 15 	mov    %dx,-0x7fea27a0(,%eax,8)
80107409:	80 
8010740a:	c1 ea 10             	shr    $0x10,%edx
8010740d:	66 89 14 c5 66 d8 15 	mov    %dx,-0x7fea279a(,%eax,8)
80107414:	80 
  for(i = 0; i < 256; i++)
80107415:	83 c0 01             	add    $0x1,%eax
80107418:	3d 00 01 00 00       	cmp    $0x100,%eax
8010741d:	75 d1                	jne    801073f0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010741f:	a1 48 c1 10 80       	mov    0x8010c148,%eax

  initlock(&tickslock, "time");
80107424:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107427:	c7 05 62 da 15 80 08 	movl   $0xef000008,0x8015da62
8010742e:	00 00 ef 
  initlock(&tickslock, "time");
80107431:	68 66 9a 10 80       	push   $0x80109a66
80107436:	68 20 d8 15 80       	push   $0x8015d820
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010743b:	66 a3 60 da 15 80    	mov    %ax,0x8015da60
80107441:	c1 e8 10             	shr    $0x10,%eax
80107444:	66 a3 66 da 15 80    	mov    %ax,0x8015da66
  initlock(&tickslock, "time");
8010744a:	e8 a1 e4 ff ff       	call   801058f0 <initlock>
}
8010744f:	83 c4 10             	add    $0x10,%esp
80107452:	c9                   	leave  
80107453:	c3                   	ret    
80107454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010745a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107460 <idtinit>:

void
idtinit(void)
{
80107460:	55                   	push   %ebp
  pd[0] = size-1;
80107461:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80107466:	89 e5                	mov    %esp,%ebp
80107468:	83 ec 10             	sub    $0x10,%esp
8010746b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010746f:	b8 60 d8 15 80       	mov    $0x8015d860,%eax
80107474:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107478:	c1 e8 10             	shr    $0x10,%eax
8010747b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010747f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107482:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80107485:	c9                   	leave  
80107486:	c3                   	ret    
80107487:	89 f6                	mov    %esi,%esi
80107489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107490 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 1c             	sub    $0x1c,%esp
80107499:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010749c:	8b 47 30             	mov    0x30(%edi),%eax
8010749f:	83 f8 40             	cmp    $0x40,%eax
801074a2:	0f 84 f0 00 00 00    	je     80107598 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801074a8:	83 e8 20             	sub    $0x20,%eax
801074ab:	83 f8 1f             	cmp    $0x1f,%eax
801074ae:	77 10                	ja     801074c0 <trap+0x30>
801074b0:	ff 24 85 20 9b 10 80 	jmp    *-0x7fef64e0(,%eax,4)
801074b7:	89 f6                	mov    %esi,%esi
801074b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801074c0:	e8 2b da ff ff       	call   80104ef0 <myproc>
801074c5:	85 c0                	test   %eax,%eax
801074c7:	8b 5f 38             	mov    0x38(%edi),%ebx
801074ca:	0f 84 24 02 00 00    	je     801076f4 <trap+0x264>
801074d0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801074d4:	0f 84 1a 02 00 00    	je     801076f4 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801074da:	0f 20 d1             	mov    %cr2,%ecx
801074dd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801074e0:	e8 eb d9 ff ff       	call   80104ed0 <cpuid>
801074e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801074e8:	8b 47 34             	mov    0x34(%edi),%eax
801074eb:	8b 77 30             	mov    0x30(%edi),%esi
801074ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801074f1:	e8 fa d9 ff ff       	call   80104ef0 <myproc>
801074f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074f9:	e8 f2 d9 ff ff       	call   80104ef0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801074fe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80107501:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107504:	51                   	push   %ecx
80107505:	53                   	push   %ebx
80107506:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80107507:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010750a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010750d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010750e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107511:	52                   	push   %edx
80107512:	ff 70 10             	pushl  0x10(%eax)
80107515:	68 dc 9a 10 80       	push   $0x80109adc
8010751a:	e8 21 97 ff ff       	call   80100c40 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010751f:	83 c4 20             	add    $0x20,%esp
80107522:	e8 c9 d9 ff ff       	call   80104ef0 <myproc>
80107527:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010752e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107530:	e8 bb d9 ff ff       	call   80104ef0 <myproc>
80107535:	85 c0                	test   %eax,%eax
80107537:	74 1d                	je     80107556 <trap+0xc6>
80107539:	e8 b2 d9 ff ff       	call   80104ef0 <myproc>
8010753e:	8b 50 24             	mov    0x24(%eax),%edx
80107541:	85 d2                	test   %edx,%edx
80107543:	74 11                	je     80107556 <trap+0xc6>
80107545:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80107549:	83 e0 03             	and    $0x3,%eax
8010754c:	66 83 f8 03          	cmp    $0x3,%ax
80107550:	0f 84 5a 01 00 00    	je     801076b0 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107556:	e8 95 d9 ff ff       	call   80104ef0 <myproc>
8010755b:	85 c0                	test   %eax,%eax
8010755d:	74 0b                	je     8010756a <trap+0xda>
8010755f:	e8 8c d9 ff ff       	call   80104ef0 <myproc>
80107564:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80107568:	74 66                	je     801075d0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010756a:	e8 81 d9 ff ff       	call   80104ef0 <myproc>
8010756f:	85 c0                	test   %eax,%eax
80107571:	74 19                	je     8010758c <trap+0xfc>
80107573:	e8 78 d9 ff ff       	call   80104ef0 <myproc>
80107578:	8b 40 24             	mov    0x24(%eax),%eax
8010757b:	85 c0                	test   %eax,%eax
8010757d:	74 0d                	je     8010758c <trap+0xfc>
8010757f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80107583:	83 e0 03             	and    $0x3,%eax
80107586:	66 83 f8 03          	cmp    $0x3,%ax
8010758a:	74 35                	je     801075c1 <trap+0x131>
    exit();
}
8010758c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010758f:	5b                   	pop    %ebx
80107590:	5e                   	pop    %esi
80107591:	5f                   	pop    %edi
80107592:	5d                   	pop    %ebp
80107593:	c3                   	ret    
80107594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80107598:	e8 53 d9 ff ff       	call   80104ef0 <myproc>
8010759d:	8b 40 24             	mov    0x24(%eax),%eax
801075a0:	85 c0                	test   %eax,%eax
801075a2:	0f 85 f8 00 00 00    	jne    801076a0 <trap+0x210>
    myproc()->tf = tf;
801075a8:	e8 43 d9 ff ff       	call   80104ef0 <myproc>
801075ad:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801075b0:	e8 5b ea ff ff       	call   80106010 <syscall>
    if(myproc()->killed)
801075b5:	e8 36 d9 ff ff       	call   80104ef0 <myproc>
801075ba:	8b 70 24             	mov    0x24(%eax),%esi
801075bd:	85 f6                	test   %esi,%esi
801075bf:	74 cb                	je     8010758c <trap+0xfc>
}
801075c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075c4:	5b                   	pop    %ebx
801075c5:	5e                   	pop    %esi
801075c6:	5f                   	pop    %edi
801075c7:	5d                   	pop    %ebp
      exit();
801075c8:	e9 43 dd ff ff       	jmp    80105310 <exit>
801075cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801075d0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801075d4:	75 94                	jne    8010756a <trap+0xda>
    yield();
801075d6:	e8 65 de ff ff       	call   80105440 <yield>
801075db:	eb 8d                	jmp    8010756a <trap+0xda>
801075dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
801075e0:	e8 eb d8 ff ff       	call   80104ed0 <cpuid>
801075e5:	85 c0                	test   %eax,%eax
801075e7:	0f 84 d3 00 00 00    	je     801076c0 <trap+0x230>
    lapiceoi();
801075ed:	e8 ae bb ff ff       	call   801031a0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801075f2:	e8 f9 d8 ff ff       	call   80104ef0 <myproc>
801075f7:	85 c0                	test   %eax,%eax
801075f9:	0f 85 3a ff ff ff    	jne    80107539 <trap+0xa9>
801075ff:	e9 52 ff ff ff       	jmp    80107556 <trap+0xc6>
80107604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80107608:	e8 53 ba ff ff       	call   80103060 <kbdintr>
    lapiceoi();
8010760d:	e8 8e bb ff ff       	call   801031a0 <lapiceoi>
    break;
80107612:	e9 19 ff ff ff       	jmp    80107530 <trap+0xa0>
80107617:	89 f6                	mov    %esi,%esi
80107619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80107620:	e8 6b 02 00 00       	call   80107890 <uartintr>
    lapiceoi();
80107625:	e8 76 bb ff ff       	call   801031a0 <lapiceoi>
    break;
8010762a:	e9 01 ff ff ff       	jmp    80107530 <trap+0xa0>
8010762f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107630:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80107634:	8b 77 38             	mov    0x38(%edi),%esi
80107637:	e8 94 d8 ff ff       	call   80104ed0 <cpuid>
8010763c:	56                   	push   %esi
8010763d:	53                   	push   %ebx
8010763e:	50                   	push   %eax
8010763f:	68 84 9a 10 80       	push   $0x80109a84
80107644:	e8 f7 95 ff ff       	call   80100c40 <cprintf>
    lapiceoi();
80107649:	e8 52 bb ff ff       	call   801031a0 <lapiceoi>
    break;
8010764e:	83 c4 10             	add    $0x10,%esp
80107651:	e9 da fe ff ff       	jmp    80107530 <trap+0xa0>
80107656:	8d 76 00             	lea    0x0(%esi),%esi
80107659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  cprintf("ethernet interrupt\n");
80107660:	83 ec 0c             	sub    $0xc,%esp
80107663:	68 6b 9a 10 80       	push   $0x80109a6b
80107668:	e8 d3 95 ff ff       	call   80100c40 <cprintf>
     ethintr();
8010766d:	e8 8e a0 ff ff       	call   80101700 <ethintr>
     lapiceoi();
80107672:	e8 29 bb ff ff       	call   801031a0 <lapiceoi>
     ioapicenable(IRQ_ETH, 0);
80107677:	59                   	pop    %ecx
80107678:	5b                   	pop    %ebx
80107679:	6a 00                	push   $0x0
8010767b:	6a 0b                	push   $0xb
8010767d:	e8 9e b6 ff ff       	call   80102d20 <ioapicenable>
     break;
80107682:	83 c4 10             	add    $0x10,%esp
80107685:	e9 a6 fe ff ff       	jmp    80107530 <trap+0xa0>
8010768a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ideintr();
80107690:	e8 3b b4 ff ff       	call   80102ad0 <ideintr>
80107695:	e9 53 ff ff ff       	jmp    801075ed <trap+0x15d>
8010769a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801076a0:	e8 6b dc ff ff       	call   80105310 <exit>
801076a5:	e9 fe fe ff ff       	jmp    801075a8 <trap+0x118>
801076aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801076b0:	e8 5b dc ff ff       	call   80105310 <exit>
801076b5:	e9 9c fe ff ff       	jmp    80107556 <trap+0xc6>
801076ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801076c0:	83 ec 0c             	sub    $0xc,%esp
801076c3:	68 20 d8 15 80       	push   $0x8015d820
801076c8:	e8 13 e3 ff ff       	call   801059e0 <acquire>
      wakeup(&ticks);
801076cd:	c7 04 24 60 e0 15 80 	movl   $0x8015e060,(%esp)
      ticks++;
801076d4:	83 05 60 e0 15 80 01 	addl   $0x1,0x8015e060
      wakeup(&ticks);
801076db:	e8 60 df ff ff       	call   80105640 <wakeup>
      release(&tickslock);
801076e0:	c7 04 24 20 d8 15 80 	movl   $0x8015d820,(%esp)
801076e7:	e8 14 e4 ff ff       	call   80105b00 <release>
801076ec:	83 c4 10             	add    $0x10,%esp
801076ef:	e9 f9 fe ff ff       	jmp    801075ed <trap+0x15d>
801076f4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801076f7:	e8 d4 d7 ff ff       	call   80104ed0 <cpuid>
801076fc:	83 ec 0c             	sub    $0xc,%esp
801076ff:	56                   	push   %esi
80107700:	53                   	push   %ebx
80107701:	50                   	push   %eax
80107702:	ff 77 30             	pushl  0x30(%edi)
80107705:	68 a8 9a 10 80       	push   $0x80109aa8
8010770a:	e8 31 95 ff ff       	call   80100c40 <cprintf>
      panic("trap");
8010770f:	83 c4 14             	add    $0x14,%esp
80107712:	68 7f 9a 10 80       	push   $0x80109a7f
80107717:	e8 54 92 ff ff       	call   80100970 <panic>
8010771c:	66 90                	xchg   %ax,%ax
8010771e:	66 90                	xchg   %ax,%ax

80107720 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107720:	a1 54 2e 15 80       	mov    0x80152e54,%eax
{
80107725:	55                   	push   %ebp
80107726:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107728:	85 c0                	test   %eax,%eax
8010772a:	74 1c                	je     80107748 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010772c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107731:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80107732:	a8 01                	test   $0x1,%al
80107734:	74 12                	je     80107748 <uartgetc+0x28>
80107736:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010773b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010773c:	0f b6 c0             	movzbl %al,%eax
}
8010773f:	5d                   	pop    %ebp
80107740:	c3                   	ret    
80107741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010774d:	5d                   	pop    %ebp
8010774e:	c3                   	ret    
8010774f:	90                   	nop

80107750 <uartputc.part.0>:
uartputc(int c)
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	57                   	push   %edi
80107754:	56                   	push   %esi
80107755:	53                   	push   %ebx
80107756:	89 c7                	mov    %eax,%edi
80107758:	bb 80 00 00 00       	mov    $0x80,%ebx
8010775d:	be fd 03 00 00       	mov    $0x3fd,%esi
80107762:	83 ec 0c             	sub    $0xc,%esp
80107765:	eb 1b                	jmp    80107782 <uartputc.part.0+0x32>
80107767:	89 f6                	mov    %esi,%esi
80107769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80107770:	83 ec 0c             	sub    $0xc,%esp
80107773:	6a 0a                	push   $0xa
80107775:	e8 46 ba ff ff       	call   801031c0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010777a:	83 c4 10             	add    $0x10,%esp
8010777d:	83 eb 01             	sub    $0x1,%ebx
80107780:	74 07                	je     80107789 <uartputc.part.0+0x39>
80107782:	89 f2                	mov    %esi,%edx
80107784:	ec                   	in     (%dx),%al
80107785:	a8 20                	test   $0x20,%al
80107787:	74 e7                	je     80107770 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107789:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010778e:	89 f8                	mov    %edi,%eax
80107790:	ee                   	out    %al,(%dx)
}
80107791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107794:	5b                   	pop    %ebx
80107795:	5e                   	pop    %esi
80107796:	5f                   	pop    %edi
80107797:	5d                   	pop    %ebp
80107798:	c3                   	ret    
80107799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077a0 <uartinit>:
{
801077a0:	55                   	push   %ebp
801077a1:	31 c9                	xor    %ecx,%ecx
801077a3:	89 c8                	mov    %ecx,%eax
801077a5:	89 e5                	mov    %esp,%ebp
801077a7:	57                   	push   %edi
801077a8:	56                   	push   %esi
801077a9:	53                   	push   %ebx
801077aa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801077af:	89 da                	mov    %ebx,%edx
801077b1:	83 ec 0c             	sub    $0xc,%esp
801077b4:	ee                   	out    %al,(%dx)
801077b5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801077ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801077bf:	89 fa                	mov    %edi,%edx
801077c1:	ee                   	out    %al,(%dx)
801077c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801077c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801077cc:	ee                   	out    %al,(%dx)
801077cd:	be f9 03 00 00       	mov    $0x3f9,%esi
801077d2:	89 c8                	mov    %ecx,%eax
801077d4:	89 f2                	mov    %esi,%edx
801077d6:	ee                   	out    %al,(%dx)
801077d7:	b8 03 00 00 00       	mov    $0x3,%eax
801077dc:	89 fa                	mov    %edi,%edx
801077de:	ee                   	out    %al,(%dx)
801077df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801077e4:	89 c8                	mov    %ecx,%eax
801077e6:	ee                   	out    %al,(%dx)
801077e7:	b8 01 00 00 00       	mov    $0x1,%eax
801077ec:	89 f2                	mov    %esi,%edx
801077ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801077ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801077f4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801077f5:	3c ff                	cmp    $0xff,%al
801077f7:	74 5a                	je     80107853 <uartinit+0xb3>
  uart = 1;
801077f9:	c7 05 54 2e 15 80 01 	movl   $0x1,0x80152e54
80107800:	00 00 00 
80107803:	89 da                	mov    %ebx,%edx
80107805:	ec                   	in     (%dx),%al
80107806:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010780b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010780c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010780f:	bb a0 9b 10 80       	mov    $0x80109ba0,%ebx
  ioapicenable(IRQ_COM1, 0);
80107814:	6a 00                	push   $0x0
80107816:	6a 04                	push   $0x4
80107818:	e8 03 b5 ff ff       	call   80102d20 <ioapicenable>
8010781d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107820:	b8 78 00 00 00       	mov    $0x78,%eax
80107825:	eb 13                	jmp    8010783a <uartinit+0x9a>
80107827:	89 f6                	mov    %esi,%esi
80107829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107830:	83 c3 01             	add    $0x1,%ebx
80107833:	0f be 03             	movsbl (%ebx),%eax
80107836:	84 c0                	test   %al,%al
80107838:	74 19                	je     80107853 <uartinit+0xb3>
  if(!uart)
8010783a:	8b 15 54 2e 15 80    	mov    0x80152e54,%edx
80107840:	85 d2                	test   %edx,%edx
80107842:	74 ec                	je     80107830 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80107844:	83 c3 01             	add    $0x1,%ebx
80107847:	e8 04 ff ff ff       	call   80107750 <uartputc.part.0>
8010784c:	0f be 03             	movsbl (%ebx),%eax
8010784f:	84 c0                	test   %al,%al
80107851:	75 e7                	jne    8010783a <uartinit+0x9a>
}
80107853:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107856:	5b                   	pop    %ebx
80107857:	5e                   	pop    %esi
80107858:	5f                   	pop    %edi
80107859:	5d                   	pop    %ebp
8010785a:	c3                   	ret    
8010785b:	90                   	nop
8010785c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107860 <uartputc>:
  if(!uart)
80107860:	8b 15 54 2e 15 80    	mov    0x80152e54,%edx
{
80107866:	55                   	push   %ebp
80107867:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107869:	85 d2                	test   %edx,%edx
{
8010786b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010786e:	74 10                	je     80107880 <uartputc+0x20>
}
80107870:	5d                   	pop    %ebp
80107871:	e9 da fe ff ff       	jmp    80107750 <uartputc.part.0>
80107876:	8d 76 00             	lea    0x0(%esi),%esi
80107879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107880:	5d                   	pop    %ebp
80107881:	c3                   	ret    
80107882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107890 <uartintr>:

void
uartintr(void)
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107896:	68 20 77 10 80       	push   $0x80107720
8010789b:	e8 50 95 ff ff       	call   80100df0 <consoleintr>
}
801078a0:	83 c4 10             	add    $0x10,%esp
801078a3:	c9                   	leave  
801078a4:	c3                   	ret    
801078a5:	66 90                	xchg   %ax,%ax
801078a7:	66 90                	xchg   %ax,%ax
801078a9:	66 90                	xchg   %ax,%ax
801078ab:	66 90                	xchg   %ax,%ax
801078ad:	66 90                	xchg   %ax,%ax
801078af:	90                   	nop

801078b0 <atoi>:
#include "types.h"
#include "util.h"

int
atoi(const char *s)
{
801078b0:	55                   	push   %ebp
801078b1:	89 e5                	mov    %esp,%ebp
801078b3:	53                   	push   %ebx
801078b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
801078b7:	0f be 11             	movsbl (%ecx),%edx
801078ba:	8d 42 d0             	lea    -0x30(%edx),%eax
801078bd:	3c 09                	cmp    $0x9,%al
  n = 0;
801078bf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
801078c4:	77 1f                	ja     801078e5 <atoi+0x35>
801078c6:	8d 76 00             	lea    0x0(%esi),%esi
801078c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
801078d0:	8d 04 80             	lea    (%eax,%eax,4),%eax
801078d3:	83 c1 01             	add    $0x1,%ecx
801078d6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
801078da:	0f be 11             	movsbl (%ecx),%edx
801078dd:	8d 5a d0             	lea    -0x30(%edx),%ebx
801078e0:	80 fb 09             	cmp    $0x9,%bl
801078e3:	76 eb                	jbe    801078d0 <atoi+0x20>
  return n;
}
801078e5:	5b                   	pop    %ebx
801078e6:	5d                   	pop    %ebp
801078e7:	c3                   	ret    
801078e8:	90                   	nop
801078e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801078f0 <strcmp>:


int
strcmp(const char *p, const char *q)
{
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	53                   	push   %ebx
801078f4:	8b 55 08             	mov    0x8(%ebp),%edx
801078f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
801078fa:	0f b6 02             	movzbl (%edx),%eax
801078fd:	0f b6 19             	movzbl (%ecx),%ebx
80107900:	84 c0                	test   %al,%al
80107902:	75 1c                	jne    80107920 <strcmp+0x30>
80107904:	eb 2a                	jmp    80107930 <strcmp+0x40>
80107906:	8d 76 00             	lea    0x0(%esi),%esi
80107909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
80107910:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
80107913:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
80107916:	83 c1 01             	add    $0x1,%ecx
80107919:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
8010791c:	84 c0                	test   %al,%al
8010791e:	74 10                	je     80107930 <strcmp+0x40>
80107920:	38 d8                	cmp    %bl,%al
80107922:	74 ec                	je     80107910 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
80107924:	29 d8                	sub    %ebx,%eax
}
80107926:	5b                   	pop    %ebx
80107927:	5d                   	pop    %ebp
80107928:	c3                   	ret    
80107929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107930:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
80107932:	29 d8                	sub    %ebx,%eax
}
80107934:	5b                   	pop    %ebx
80107935:	5d                   	pop    %ebp
80107936:	c3                   	ret    

80107937 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107937:	6a 00                	push   $0x0
  pushl $0
80107939:	6a 00                	push   $0x0
  jmp alltraps
8010793b:	e9 7a fa ff ff       	jmp    801073ba <alltraps>

80107940 <vector1>:
.globl vector1
vector1:
  pushl $0
80107940:	6a 00                	push   $0x0
  pushl $1
80107942:	6a 01                	push   $0x1
  jmp alltraps
80107944:	e9 71 fa ff ff       	jmp    801073ba <alltraps>

80107949 <vector2>:
.globl vector2
vector2:
  pushl $0
80107949:	6a 00                	push   $0x0
  pushl $2
8010794b:	6a 02                	push   $0x2
  jmp alltraps
8010794d:	e9 68 fa ff ff       	jmp    801073ba <alltraps>

80107952 <vector3>:
.globl vector3
vector3:
  pushl $0
80107952:	6a 00                	push   $0x0
  pushl $3
80107954:	6a 03                	push   $0x3
  jmp alltraps
80107956:	e9 5f fa ff ff       	jmp    801073ba <alltraps>

8010795b <vector4>:
.globl vector4
vector4:
  pushl $0
8010795b:	6a 00                	push   $0x0
  pushl $4
8010795d:	6a 04                	push   $0x4
  jmp alltraps
8010795f:	e9 56 fa ff ff       	jmp    801073ba <alltraps>

80107964 <vector5>:
.globl vector5
vector5:
  pushl $0
80107964:	6a 00                	push   $0x0
  pushl $5
80107966:	6a 05                	push   $0x5
  jmp alltraps
80107968:	e9 4d fa ff ff       	jmp    801073ba <alltraps>

8010796d <vector6>:
.globl vector6
vector6:
  pushl $0
8010796d:	6a 00                	push   $0x0
  pushl $6
8010796f:	6a 06                	push   $0x6
  jmp alltraps
80107971:	e9 44 fa ff ff       	jmp    801073ba <alltraps>

80107976 <vector7>:
.globl vector7
vector7:
  pushl $0
80107976:	6a 00                	push   $0x0
  pushl $7
80107978:	6a 07                	push   $0x7
  jmp alltraps
8010797a:	e9 3b fa ff ff       	jmp    801073ba <alltraps>

8010797f <vector8>:
.globl vector8
vector8:
  pushl $8
8010797f:	6a 08                	push   $0x8
  jmp alltraps
80107981:	e9 34 fa ff ff       	jmp    801073ba <alltraps>

80107986 <vector9>:
.globl vector9
vector9:
  pushl $0
80107986:	6a 00                	push   $0x0
  pushl $9
80107988:	6a 09                	push   $0x9
  jmp alltraps
8010798a:	e9 2b fa ff ff       	jmp    801073ba <alltraps>

8010798f <vector10>:
.globl vector10
vector10:
  pushl $10
8010798f:	6a 0a                	push   $0xa
  jmp alltraps
80107991:	e9 24 fa ff ff       	jmp    801073ba <alltraps>

80107996 <vector11>:
.globl vector11
vector11:
  pushl $11
80107996:	6a 0b                	push   $0xb
  jmp alltraps
80107998:	e9 1d fa ff ff       	jmp    801073ba <alltraps>

8010799d <vector12>:
.globl vector12
vector12:
  pushl $12
8010799d:	6a 0c                	push   $0xc
  jmp alltraps
8010799f:	e9 16 fa ff ff       	jmp    801073ba <alltraps>

801079a4 <vector13>:
.globl vector13
vector13:
  pushl $13
801079a4:	6a 0d                	push   $0xd
  jmp alltraps
801079a6:	e9 0f fa ff ff       	jmp    801073ba <alltraps>

801079ab <vector14>:
.globl vector14
vector14:
  pushl $14
801079ab:	6a 0e                	push   $0xe
  jmp alltraps
801079ad:	e9 08 fa ff ff       	jmp    801073ba <alltraps>

801079b2 <vector15>:
.globl vector15
vector15:
  pushl $0
801079b2:	6a 00                	push   $0x0
  pushl $15
801079b4:	6a 0f                	push   $0xf
  jmp alltraps
801079b6:	e9 ff f9 ff ff       	jmp    801073ba <alltraps>

801079bb <vector16>:
.globl vector16
vector16:
  pushl $0
801079bb:	6a 00                	push   $0x0
  pushl $16
801079bd:	6a 10                	push   $0x10
  jmp alltraps
801079bf:	e9 f6 f9 ff ff       	jmp    801073ba <alltraps>

801079c4 <vector17>:
.globl vector17
vector17:
  pushl $17
801079c4:	6a 11                	push   $0x11
  jmp alltraps
801079c6:	e9 ef f9 ff ff       	jmp    801073ba <alltraps>

801079cb <vector18>:
.globl vector18
vector18:
  pushl $0
801079cb:	6a 00                	push   $0x0
  pushl $18
801079cd:	6a 12                	push   $0x12
  jmp alltraps
801079cf:	e9 e6 f9 ff ff       	jmp    801073ba <alltraps>

801079d4 <vector19>:
.globl vector19
vector19:
  pushl $0
801079d4:	6a 00                	push   $0x0
  pushl $19
801079d6:	6a 13                	push   $0x13
  jmp alltraps
801079d8:	e9 dd f9 ff ff       	jmp    801073ba <alltraps>

801079dd <vector20>:
.globl vector20
vector20:
  pushl $0
801079dd:	6a 00                	push   $0x0
  pushl $20
801079df:	6a 14                	push   $0x14
  jmp alltraps
801079e1:	e9 d4 f9 ff ff       	jmp    801073ba <alltraps>

801079e6 <vector21>:
.globl vector21
vector21:
  pushl $0
801079e6:	6a 00                	push   $0x0
  pushl $21
801079e8:	6a 15                	push   $0x15
  jmp alltraps
801079ea:	e9 cb f9 ff ff       	jmp    801073ba <alltraps>

801079ef <vector22>:
.globl vector22
vector22:
  pushl $0
801079ef:	6a 00                	push   $0x0
  pushl $22
801079f1:	6a 16                	push   $0x16
  jmp alltraps
801079f3:	e9 c2 f9 ff ff       	jmp    801073ba <alltraps>

801079f8 <vector23>:
.globl vector23
vector23:
  pushl $0
801079f8:	6a 00                	push   $0x0
  pushl $23
801079fa:	6a 17                	push   $0x17
  jmp alltraps
801079fc:	e9 b9 f9 ff ff       	jmp    801073ba <alltraps>

80107a01 <vector24>:
.globl vector24
vector24:
  pushl $0
80107a01:	6a 00                	push   $0x0
  pushl $24
80107a03:	6a 18                	push   $0x18
  jmp alltraps
80107a05:	e9 b0 f9 ff ff       	jmp    801073ba <alltraps>

80107a0a <vector25>:
.globl vector25
vector25:
  pushl $0
80107a0a:	6a 00                	push   $0x0
  pushl $25
80107a0c:	6a 19                	push   $0x19
  jmp alltraps
80107a0e:	e9 a7 f9 ff ff       	jmp    801073ba <alltraps>

80107a13 <vector26>:
.globl vector26
vector26:
  pushl $0
80107a13:	6a 00                	push   $0x0
  pushl $26
80107a15:	6a 1a                	push   $0x1a
  jmp alltraps
80107a17:	e9 9e f9 ff ff       	jmp    801073ba <alltraps>

80107a1c <vector27>:
.globl vector27
vector27:
  pushl $0
80107a1c:	6a 00                	push   $0x0
  pushl $27
80107a1e:	6a 1b                	push   $0x1b
  jmp alltraps
80107a20:	e9 95 f9 ff ff       	jmp    801073ba <alltraps>

80107a25 <vector28>:
.globl vector28
vector28:
  pushl $0
80107a25:	6a 00                	push   $0x0
  pushl $28
80107a27:	6a 1c                	push   $0x1c
  jmp alltraps
80107a29:	e9 8c f9 ff ff       	jmp    801073ba <alltraps>

80107a2e <vector29>:
.globl vector29
vector29:
  pushl $0
80107a2e:	6a 00                	push   $0x0
  pushl $29
80107a30:	6a 1d                	push   $0x1d
  jmp alltraps
80107a32:	e9 83 f9 ff ff       	jmp    801073ba <alltraps>

80107a37 <vector30>:
.globl vector30
vector30:
  pushl $0
80107a37:	6a 00                	push   $0x0
  pushl $30
80107a39:	6a 1e                	push   $0x1e
  jmp alltraps
80107a3b:	e9 7a f9 ff ff       	jmp    801073ba <alltraps>

80107a40 <vector31>:
.globl vector31
vector31:
  pushl $0
80107a40:	6a 00                	push   $0x0
  pushl $31
80107a42:	6a 1f                	push   $0x1f
  jmp alltraps
80107a44:	e9 71 f9 ff ff       	jmp    801073ba <alltraps>

80107a49 <vector32>:
.globl vector32
vector32:
  pushl $0
80107a49:	6a 00                	push   $0x0
  pushl $32
80107a4b:	6a 20                	push   $0x20
  jmp alltraps
80107a4d:	e9 68 f9 ff ff       	jmp    801073ba <alltraps>

80107a52 <vector33>:
.globl vector33
vector33:
  pushl $0
80107a52:	6a 00                	push   $0x0
  pushl $33
80107a54:	6a 21                	push   $0x21
  jmp alltraps
80107a56:	e9 5f f9 ff ff       	jmp    801073ba <alltraps>

80107a5b <vector34>:
.globl vector34
vector34:
  pushl $0
80107a5b:	6a 00                	push   $0x0
  pushl $34
80107a5d:	6a 22                	push   $0x22
  jmp alltraps
80107a5f:	e9 56 f9 ff ff       	jmp    801073ba <alltraps>

80107a64 <vector35>:
.globl vector35
vector35:
  pushl $0
80107a64:	6a 00                	push   $0x0
  pushl $35
80107a66:	6a 23                	push   $0x23
  jmp alltraps
80107a68:	e9 4d f9 ff ff       	jmp    801073ba <alltraps>

80107a6d <vector36>:
.globl vector36
vector36:
  pushl $0
80107a6d:	6a 00                	push   $0x0
  pushl $36
80107a6f:	6a 24                	push   $0x24
  jmp alltraps
80107a71:	e9 44 f9 ff ff       	jmp    801073ba <alltraps>

80107a76 <vector37>:
.globl vector37
vector37:
  pushl $0
80107a76:	6a 00                	push   $0x0
  pushl $37
80107a78:	6a 25                	push   $0x25
  jmp alltraps
80107a7a:	e9 3b f9 ff ff       	jmp    801073ba <alltraps>

80107a7f <vector38>:
.globl vector38
vector38:
  pushl $0
80107a7f:	6a 00                	push   $0x0
  pushl $38
80107a81:	6a 26                	push   $0x26
  jmp alltraps
80107a83:	e9 32 f9 ff ff       	jmp    801073ba <alltraps>

80107a88 <vector39>:
.globl vector39
vector39:
  pushl $0
80107a88:	6a 00                	push   $0x0
  pushl $39
80107a8a:	6a 27                	push   $0x27
  jmp alltraps
80107a8c:	e9 29 f9 ff ff       	jmp    801073ba <alltraps>

80107a91 <vector40>:
.globl vector40
vector40:
  pushl $0
80107a91:	6a 00                	push   $0x0
  pushl $40
80107a93:	6a 28                	push   $0x28
  jmp alltraps
80107a95:	e9 20 f9 ff ff       	jmp    801073ba <alltraps>

80107a9a <vector41>:
.globl vector41
vector41:
  pushl $0
80107a9a:	6a 00                	push   $0x0
  pushl $41
80107a9c:	6a 29                	push   $0x29
  jmp alltraps
80107a9e:	e9 17 f9 ff ff       	jmp    801073ba <alltraps>

80107aa3 <vector42>:
.globl vector42
vector42:
  pushl $0
80107aa3:	6a 00                	push   $0x0
  pushl $42
80107aa5:	6a 2a                	push   $0x2a
  jmp alltraps
80107aa7:	e9 0e f9 ff ff       	jmp    801073ba <alltraps>

80107aac <vector43>:
.globl vector43
vector43:
  pushl $0
80107aac:	6a 00                	push   $0x0
  pushl $43
80107aae:	6a 2b                	push   $0x2b
  jmp alltraps
80107ab0:	e9 05 f9 ff ff       	jmp    801073ba <alltraps>

80107ab5 <vector44>:
.globl vector44
vector44:
  pushl $0
80107ab5:	6a 00                	push   $0x0
  pushl $44
80107ab7:	6a 2c                	push   $0x2c
  jmp alltraps
80107ab9:	e9 fc f8 ff ff       	jmp    801073ba <alltraps>

80107abe <vector45>:
.globl vector45
vector45:
  pushl $0
80107abe:	6a 00                	push   $0x0
  pushl $45
80107ac0:	6a 2d                	push   $0x2d
  jmp alltraps
80107ac2:	e9 f3 f8 ff ff       	jmp    801073ba <alltraps>

80107ac7 <vector46>:
.globl vector46
vector46:
  pushl $0
80107ac7:	6a 00                	push   $0x0
  pushl $46
80107ac9:	6a 2e                	push   $0x2e
  jmp alltraps
80107acb:	e9 ea f8 ff ff       	jmp    801073ba <alltraps>

80107ad0 <vector47>:
.globl vector47
vector47:
  pushl $0
80107ad0:	6a 00                	push   $0x0
  pushl $47
80107ad2:	6a 2f                	push   $0x2f
  jmp alltraps
80107ad4:	e9 e1 f8 ff ff       	jmp    801073ba <alltraps>

80107ad9 <vector48>:
.globl vector48
vector48:
  pushl $0
80107ad9:	6a 00                	push   $0x0
  pushl $48
80107adb:	6a 30                	push   $0x30
  jmp alltraps
80107add:	e9 d8 f8 ff ff       	jmp    801073ba <alltraps>

80107ae2 <vector49>:
.globl vector49
vector49:
  pushl $0
80107ae2:	6a 00                	push   $0x0
  pushl $49
80107ae4:	6a 31                	push   $0x31
  jmp alltraps
80107ae6:	e9 cf f8 ff ff       	jmp    801073ba <alltraps>

80107aeb <vector50>:
.globl vector50
vector50:
  pushl $0
80107aeb:	6a 00                	push   $0x0
  pushl $50
80107aed:	6a 32                	push   $0x32
  jmp alltraps
80107aef:	e9 c6 f8 ff ff       	jmp    801073ba <alltraps>

80107af4 <vector51>:
.globl vector51
vector51:
  pushl $0
80107af4:	6a 00                	push   $0x0
  pushl $51
80107af6:	6a 33                	push   $0x33
  jmp alltraps
80107af8:	e9 bd f8 ff ff       	jmp    801073ba <alltraps>

80107afd <vector52>:
.globl vector52
vector52:
  pushl $0
80107afd:	6a 00                	push   $0x0
  pushl $52
80107aff:	6a 34                	push   $0x34
  jmp alltraps
80107b01:	e9 b4 f8 ff ff       	jmp    801073ba <alltraps>

80107b06 <vector53>:
.globl vector53
vector53:
  pushl $0
80107b06:	6a 00                	push   $0x0
  pushl $53
80107b08:	6a 35                	push   $0x35
  jmp alltraps
80107b0a:	e9 ab f8 ff ff       	jmp    801073ba <alltraps>

80107b0f <vector54>:
.globl vector54
vector54:
  pushl $0
80107b0f:	6a 00                	push   $0x0
  pushl $54
80107b11:	6a 36                	push   $0x36
  jmp alltraps
80107b13:	e9 a2 f8 ff ff       	jmp    801073ba <alltraps>

80107b18 <vector55>:
.globl vector55
vector55:
  pushl $0
80107b18:	6a 00                	push   $0x0
  pushl $55
80107b1a:	6a 37                	push   $0x37
  jmp alltraps
80107b1c:	e9 99 f8 ff ff       	jmp    801073ba <alltraps>

80107b21 <vector56>:
.globl vector56
vector56:
  pushl $0
80107b21:	6a 00                	push   $0x0
  pushl $56
80107b23:	6a 38                	push   $0x38
  jmp alltraps
80107b25:	e9 90 f8 ff ff       	jmp    801073ba <alltraps>

80107b2a <vector57>:
.globl vector57
vector57:
  pushl $0
80107b2a:	6a 00                	push   $0x0
  pushl $57
80107b2c:	6a 39                	push   $0x39
  jmp alltraps
80107b2e:	e9 87 f8 ff ff       	jmp    801073ba <alltraps>

80107b33 <vector58>:
.globl vector58
vector58:
  pushl $0
80107b33:	6a 00                	push   $0x0
  pushl $58
80107b35:	6a 3a                	push   $0x3a
  jmp alltraps
80107b37:	e9 7e f8 ff ff       	jmp    801073ba <alltraps>

80107b3c <vector59>:
.globl vector59
vector59:
  pushl $0
80107b3c:	6a 00                	push   $0x0
  pushl $59
80107b3e:	6a 3b                	push   $0x3b
  jmp alltraps
80107b40:	e9 75 f8 ff ff       	jmp    801073ba <alltraps>

80107b45 <vector60>:
.globl vector60
vector60:
  pushl $0
80107b45:	6a 00                	push   $0x0
  pushl $60
80107b47:	6a 3c                	push   $0x3c
  jmp alltraps
80107b49:	e9 6c f8 ff ff       	jmp    801073ba <alltraps>

80107b4e <vector61>:
.globl vector61
vector61:
  pushl $0
80107b4e:	6a 00                	push   $0x0
  pushl $61
80107b50:	6a 3d                	push   $0x3d
  jmp alltraps
80107b52:	e9 63 f8 ff ff       	jmp    801073ba <alltraps>

80107b57 <vector62>:
.globl vector62
vector62:
  pushl $0
80107b57:	6a 00                	push   $0x0
  pushl $62
80107b59:	6a 3e                	push   $0x3e
  jmp alltraps
80107b5b:	e9 5a f8 ff ff       	jmp    801073ba <alltraps>

80107b60 <vector63>:
.globl vector63
vector63:
  pushl $0
80107b60:	6a 00                	push   $0x0
  pushl $63
80107b62:	6a 3f                	push   $0x3f
  jmp alltraps
80107b64:	e9 51 f8 ff ff       	jmp    801073ba <alltraps>

80107b69 <vector64>:
.globl vector64
vector64:
  pushl $0
80107b69:	6a 00                	push   $0x0
  pushl $64
80107b6b:	6a 40                	push   $0x40
  jmp alltraps
80107b6d:	e9 48 f8 ff ff       	jmp    801073ba <alltraps>

80107b72 <vector65>:
.globl vector65
vector65:
  pushl $0
80107b72:	6a 00                	push   $0x0
  pushl $65
80107b74:	6a 41                	push   $0x41
  jmp alltraps
80107b76:	e9 3f f8 ff ff       	jmp    801073ba <alltraps>

80107b7b <vector66>:
.globl vector66
vector66:
  pushl $0
80107b7b:	6a 00                	push   $0x0
  pushl $66
80107b7d:	6a 42                	push   $0x42
  jmp alltraps
80107b7f:	e9 36 f8 ff ff       	jmp    801073ba <alltraps>

80107b84 <vector67>:
.globl vector67
vector67:
  pushl $0
80107b84:	6a 00                	push   $0x0
  pushl $67
80107b86:	6a 43                	push   $0x43
  jmp alltraps
80107b88:	e9 2d f8 ff ff       	jmp    801073ba <alltraps>

80107b8d <vector68>:
.globl vector68
vector68:
  pushl $0
80107b8d:	6a 00                	push   $0x0
  pushl $68
80107b8f:	6a 44                	push   $0x44
  jmp alltraps
80107b91:	e9 24 f8 ff ff       	jmp    801073ba <alltraps>

80107b96 <vector69>:
.globl vector69
vector69:
  pushl $0
80107b96:	6a 00                	push   $0x0
  pushl $69
80107b98:	6a 45                	push   $0x45
  jmp alltraps
80107b9a:	e9 1b f8 ff ff       	jmp    801073ba <alltraps>

80107b9f <vector70>:
.globl vector70
vector70:
  pushl $0
80107b9f:	6a 00                	push   $0x0
  pushl $70
80107ba1:	6a 46                	push   $0x46
  jmp alltraps
80107ba3:	e9 12 f8 ff ff       	jmp    801073ba <alltraps>

80107ba8 <vector71>:
.globl vector71
vector71:
  pushl $0
80107ba8:	6a 00                	push   $0x0
  pushl $71
80107baa:	6a 47                	push   $0x47
  jmp alltraps
80107bac:	e9 09 f8 ff ff       	jmp    801073ba <alltraps>

80107bb1 <vector72>:
.globl vector72
vector72:
  pushl $0
80107bb1:	6a 00                	push   $0x0
  pushl $72
80107bb3:	6a 48                	push   $0x48
  jmp alltraps
80107bb5:	e9 00 f8 ff ff       	jmp    801073ba <alltraps>

80107bba <vector73>:
.globl vector73
vector73:
  pushl $0
80107bba:	6a 00                	push   $0x0
  pushl $73
80107bbc:	6a 49                	push   $0x49
  jmp alltraps
80107bbe:	e9 f7 f7 ff ff       	jmp    801073ba <alltraps>

80107bc3 <vector74>:
.globl vector74
vector74:
  pushl $0
80107bc3:	6a 00                	push   $0x0
  pushl $74
80107bc5:	6a 4a                	push   $0x4a
  jmp alltraps
80107bc7:	e9 ee f7 ff ff       	jmp    801073ba <alltraps>

80107bcc <vector75>:
.globl vector75
vector75:
  pushl $0
80107bcc:	6a 00                	push   $0x0
  pushl $75
80107bce:	6a 4b                	push   $0x4b
  jmp alltraps
80107bd0:	e9 e5 f7 ff ff       	jmp    801073ba <alltraps>

80107bd5 <vector76>:
.globl vector76
vector76:
  pushl $0
80107bd5:	6a 00                	push   $0x0
  pushl $76
80107bd7:	6a 4c                	push   $0x4c
  jmp alltraps
80107bd9:	e9 dc f7 ff ff       	jmp    801073ba <alltraps>

80107bde <vector77>:
.globl vector77
vector77:
  pushl $0
80107bde:	6a 00                	push   $0x0
  pushl $77
80107be0:	6a 4d                	push   $0x4d
  jmp alltraps
80107be2:	e9 d3 f7 ff ff       	jmp    801073ba <alltraps>

80107be7 <vector78>:
.globl vector78
vector78:
  pushl $0
80107be7:	6a 00                	push   $0x0
  pushl $78
80107be9:	6a 4e                	push   $0x4e
  jmp alltraps
80107beb:	e9 ca f7 ff ff       	jmp    801073ba <alltraps>

80107bf0 <vector79>:
.globl vector79
vector79:
  pushl $0
80107bf0:	6a 00                	push   $0x0
  pushl $79
80107bf2:	6a 4f                	push   $0x4f
  jmp alltraps
80107bf4:	e9 c1 f7 ff ff       	jmp    801073ba <alltraps>

80107bf9 <vector80>:
.globl vector80
vector80:
  pushl $0
80107bf9:	6a 00                	push   $0x0
  pushl $80
80107bfb:	6a 50                	push   $0x50
  jmp alltraps
80107bfd:	e9 b8 f7 ff ff       	jmp    801073ba <alltraps>

80107c02 <vector81>:
.globl vector81
vector81:
  pushl $0
80107c02:	6a 00                	push   $0x0
  pushl $81
80107c04:	6a 51                	push   $0x51
  jmp alltraps
80107c06:	e9 af f7 ff ff       	jmp    801073ba <alltraps>

80107c0b <vector82>:
.globl vector82
vector82:
  pushl $0
80107c0b:	6a 00                	push   $0x0
  pushl $82
80107c0d:	6a 52                	push   $0x52
  jmp alltraps
80107c0f:	e9 a6 f7 ff ff       	jmp    801073ba <alltraps>

80107c14 <vector83>:
.globl vector83
vector83:
  pushl $0
80107c14:	6a 00                	push   $0x0
  pushl $83
80107c16:	6a 53                	push   $0x53
  jmp alltraps
80107c18:	e9 9d f7 ff ff       	jmp    801073ba <alltraps>

80107c1d <vector84>:
.globl vector84
vector84:
  pushl $0
80107c1d:	6a 00                	push   $0x0
  pushl $84
80107c1f:	6a 54                	push   $0x54
  jmp alltraps
80107c21:	e9 94 f7 ff ff       	jmp    801073ba <alltraps>

80107c26 <vector85>:
.globl vector85
vector85:
  pushl $0
80107c26:	6a 00                	push   $0x0
  pushl $85
80107c28:	6a 55                	push   $0x55
  jmp alltraps
80107c2a:	e9 8b f7 ff ff       	jmp    801073ba <alltraps>

80107c2f <vector86>:
.globl vector86
vector86:
  pushl $0
80107c2f:	6a 00                	push   $0x0
  pushl $86
80107c31:	6a 56                	push   $0x56
  jmp alltraps
80107c33:	e9 82 f7 ff ff       	jmp    801073ba <alltraps>

80107c38 <vector87>:
.globl vector87
vector87:
  pushl $0
80107c38:	6a 00                	push   $0x0
  pushl $87
80107c3a:	6a 57                	push   $0x57
  jmp alltraps
80107c3c:	e9 79 f7 ff ff       	jmp    801073ba <alltraps>

80107c41 <vector88>:
.globl vector88
vector88:
  pushl $0
80107c41:	6a 00                	push   $0x0
  pushl $88
80107c43:	6a 58                	push   $0x58
  jmp alltraps
80107c45:	e9 70 f7 ff ff       	jmp    801073ba <alltraps>

80107c4a <vector89>:
.globl vector89
vector89:
  pushl $0
80107c4a:	6a 00                	push   $0x0
  pushl $89
80107c4c:	6a 59                	push   $0x59
  jmp alltraps
80107c4e:	e9 67 f7 ff ff       	jmp    801073ba <alltraps>

80107c53 <vector90>:
.globl vector90
vector90:
  pushl $0
80107c53:	6a 00                	push   $0x0
  pushl $90
80107c55:	6a 5a                	push   $0x5a
  jmp alltraps
80107c57:	e9 5e f7 ff ff       	jmp    801073ba <alltraps>

80107c5c <vector91>:
.globl vector91
vector91:
  pushl $0
80107c5c:	6a 00                	push   $0x0
  pushl $91
80107c5e:	6a 5b                	push   $0x5b
  jmp alltraps
80107c60:	e9 55 f7 ff ff       	jmp    801073ba <alltraps>

80107c65 <vector92>:
.globl vector92
vector92:
  pushl $0
80107c65:	6a 00                	push   $0x0
  pushl $92
80107c67:	6a 5c                	push   $0x5c
  jmp alltraps
80107c69:	e9 4c f7 ff ff       	jmp    801073ba <alltraps>

80107c6e <vector93>:
.globl vector93
vector93:
  pushl $0
80107c6e:	6a 00                	push   $0x0
  pushl $93
80107c70:	6a 5d                	push   $0x5d
  jmp alltraps
80107c72:	e9 43 f7 ff ff       	jmp    801073ba <alltraps>

80107c77 <vector94>:
.globl vector94
vector94:
  pushl $0
80107c77:	6a 00                	push   $0x0
  pushl $94
80107c79:	6a 5e                	push   $0x5e
  jmp alltraps
80107c7b:	e9 3a f7 ff ff       	jmp    801073ba <alltraps>

80107c80 <vector95>:
.globl vector95
vector95:
  pushl $0
80107c80:	6a 00                	push   $0x0
  pushl $95
80107c82:	6a 5f                	push   $0x5f
  jmp alltraps
80107c84:	e9 31 f7 ff ff       	jmp    801073ba <alltraps>

80107c89 <vector96>:
.globl vector96
vector96:
  pushl $0
80107c89:	6a 00                	push   $0x0
  pushl $96
80107c8b:	6a 60                	push   $0x60
  jmp alltraps
80107c8d:	e9 28 f7 ff ff       	jmp    801073ba <alltraps>

80107c92 <vector97>:
.globl vector97
vector97:
  pushl $0
80107c92:	6a 00                	push   $0x0
  pushl $97
80107c94:	6a 61                	push   $0x61
  jmp alltraps
80107c96:	e9 1f f7 ff ff       	jmp    801073ba <alltraps>

80107c9b <vector98>:
.globl vector98
vector98:
  pushl $0
80107c9b:	6a 00                	push   $0x0
  pushl $98
80107c9d:	6a 62                	push   $0x62
  jmp alltraps
80107c9f:	e9 16 f7 ff ff       	jmp    801073ba <alltraps>

80107ca4 <vector99>:
.globl vector99
vector99:
  pushl $0
80107ca4:	6a 00                	push   $0x0
  pushl $99
80107ca6:	6a 63                	push   $0x63
  jmp alltraps
80107ca8:	e9 0d f7 ff ff       	jmp    801073ba <alltraps>

80107cad <vector100>:
.globl vector100
vector100:
  pushl $0
80107cad:	6a 00                	push   $0x0
  pushl $100
80107caf:	6a 64                	push   $0x64
  jmp alltraps
80107cb1:	e9 04 f7 ff ff       	jmp    801073ba <alltraps>

80107cb6 <vector101>:
.globl vector101
vector101:
  pushl $0
80107cb6:	6a 00                	push   $0x0
  pushl $101
80107cb8:	6a 65                	push   $0x65
  jmp alltraps
80107cba:	e9 fb f6 ff ff       	jmp    801073ba <alltraps>

80107cbf <vector102>:
.globl vector102
vector102:
  pushl $0
80107cbf:	6a 00                	push   $0x0
  pushl $102
80107cc1:	6a 66                	push   $0x66
  jmp alltraps
80107cc3:	e9 f2 f6 ff ff       	jmp    801073ba <alltraps>

80107cc8 <vector103>:
.globl vector103
vector103:
  pushl $0
80107cc8:	6a 00                	push   $0x0
  pushl $103
80107cca:	6a 67                	push   $0x67
  jmp alltraps
80107ccc:	e9 e9 f6 ff ff       	jmp    801073ba <alltraps>

80107cd1 <vector104>:
.globl vector104
vector104:
  pushl $0
80107cd1:	6a 00                	push   $0x0
  pushl $104
80107cd3:	6a 68                	push   $0x68
  jmp alltraps
80107cd5:	e9 e0 f6 ff ff       	jmp    801073ba <alltraps>

80107cda <vector105>:
.globl vector105
vector105:
  pushl $0
80107cda:	6a 00                	push   $0x0
  pushl $105
80107cdc:	6a 69                	push   $0x69
  jmp alltraps
80107cde:	e9 d7 f6 ff ff       	jmp    801073ba <alltraps>

80107ce3 <vector106>:
.globl vector106
vector106:
  pushl $0
80107ce3:	6a 00                	push   $0x0
  pushl $106
80107ce5:	6a 6a                	push   $0x6a
  jmp alltraps
80107ce7:	e9 ce f6 ff ff       	jmp    801073ba <alltraps>

80107cec <vector107>:
.globl vector107
vector107:
  pushl $0
80107cec:	6a 00                	push   $0x0
  pushl $107
80107cee:	6a 6b                	push   $0x6b
  jmp alltraps
80107cf0:	e9 c5 f6 ff ff       	jmp    801073ba <alltraps>

80107cf5 <vector108>:
.globl vector108
vector108:
  pushl $0
80107cf5:	6a 00                	push   $0x0
  pushl $108
80107cf7:	6a 6c                	push   $0x6c
  jmp alltraps
80107cf9:	e9 bc f6 ff ff       	jmp    801073ba <alltraps>

80107cfe <vector109>:
.globl vector109
vector109:
  pushl $0
80107cfe:	6a 00                	push   $0x0
  pushl $109
80107d00:	6a 6d                	push   $0x6d
  jmp alltraps
80107d02:	e9 b3 f6 ff ff       	jmp    801073ba <alltraps>

80107d07 <vector110>:
.globl vector110
vector110:
  pushl $0
80107d07:	6a 00                	push   $0x0
  pushl $110
80107d09:	6a 6e                	push   $0x6e
  jmp alltraps
80107d0b:	e9 aa f6 ff ff       	jmp    801073ba <alltraps>

80107d10 <vector111>:
.globl vector111
vector111:
  pushl $0
80107d10:	6a 00                	push   $0x0
  pushl $111
80107d12:	6a 6f                	push   $0x6f
  jmp alltraps
80107d14:	e9 a1 f6 ff ff       	jmp    801073ba <alltraps>

80107d19 <vector112>:
.globl vector112
vector112:
  pushl $0
80107d19:	6a 00                	push   $0x0
  pushl $112
80107d1b:	6a 70                	push   $0x70
  jmp alltraps
80107d1d:	e9 98 f6 ff ff       	jmp    801073ba <alltraps>

80107d22 <vector113>:
.globl vector113
vector113:
  pushl $0
80107d22:	6a 00                	push   $0x0
  pushl $113
80107d24:	6a 71                	push   $0x71
  jmp alltraps
80107d26:	e9 8f f6 ff ff       	jmp    801073ba <alltraps>

80107d2b <vector114>:
.globl vector114
vector114:
  pushl $0
80107d2b:	6a 00                	push   $0x0
  pushl $114
80107d2d:	6a 72                	push   $0x72
  jmp alltraps
80107d2f:	e9 86 f6 ff ff       	jmp    801073ba <alltraps>

80107d34 <vector115>:
.globl vector115
vector115:
  pushl $0
80107d34:	6a 00                	push   $0x0
  pushl $115
80107d36:	6a 73                	push   $0x73
  jmp alltraps
80107d38:	e9 7d f6 ff ff       	jmp    801073ba <alltraps>

80107d3d <vector116>:
.globl vector116
vector116:
  pushl $0
80107d3d:	6a 00                	push   $0x0
  pushl $116
80107d3f:	6a 74                	push   $0x74
  jmp alltraps
80107d41:	e9 74 f6 ff ff       	jmp    801073ba <alltraps>

80107d46 <vector117>:
.globl vector117
vector117:
  pushl $0
80107d46:	6a 00                	push   $0x0
  pushl $117
80107d48:	6a 75                	push   $0x75
  jmp alltraps
80107d4a:	e9 6b f6 ff ff       	jmp    801073ba <alltraps>

80107d4f <vector118>:
.globl vector118
vector118:
  pushl $0
80107d4f:	6a 00                	push   $0x0
  pushl $118
80107d51:	6a 76                	push   $0x76
  jmp alltraps
80107d53:	e9 62 f6 ff ff       	jmp    801073ba <alltraps>

80107d58 <vector119>:
.globl vector119
vector119:
  pushl $0
80107d58:	6a 00                	push   $0x0
  pushl $119
80107d5a:	6a 77                	push   $0x77
  jmp alltraps
80107d5c:	e9 59 f6 ff ff       	jmp    801073ba <alltraps>

80107d61 <vector120>:
.globl vector120
vector120:
  pushl $0
80107d61:	6a 00                	push   $0x0
  pushl $120
80107d63:	6a 78                	push   $0x78
  jmp alltraps
80107d65:	e9 50 f6 ff ff       	jmp    801073ba <alltraps>

80107d6a <vector121>:
.globl vector121
vector121:
  pushl $0
80107d6a:	6a 00                	push   $0x0
  pushl $121
80107d6c:	6a 79                	push   $0x79
  jmp alltraps
80107d6e:	e9 47 f6 ff ff       	jmp    801073ba <alltraps>

80107d73 <vector122>:
.globl vector122
vector122:
  pushl $0
80107d73:	6a 00                	push   $0x0
  pushl $122
80107d75:	6a 7a                	push   $0x7a
  jmp alltraps
80107d77:	e9 3e f6 ff ff       	jmp    801073ba <alltraps>

80107d7c <vector123>:
.globl vector123
vector123:
  pushl $0
80107d7c:	6a 00                	push   $0x0
  pushl $123
80107d7e:	6a 7b                	push   $0x7b
  jmp alltraps
80107d80:	e9 35 f6 ff ff       	jmp    801073ba <alltraps>

80107d85 <vector124>:
.globl vector124
vector124:
  pushl $0
80107d85:	6a 00                	push   $0x0
  pushl $124
80107d87:	6a 7c                	push   $0x7c
  jmp alltraps
80107d89:	e9 2c f6 ff ff       	jmp    801073ba <alltraps>

80107d8e <vector125>:
.globl vector125
vector125:
  pushl $0
80107d8e:	6a 00                	push   $0x0
  pushl $125
80107d90:	6a 7d                	push   $0x7d
  jmp alltraps
80107d92:	e9 23 f6 ff ff       	jmp    801073ba <alltraps>

80107d97 <vector126>:
.globl vector126
vector126:
  pushl $0
80107d97:	6a 00                	push   $0x0
  pushl $126
80107d99:	6a 7e                	push   $0x7e
  jmp alltraps
80107d9b:	e9 1a f6 ff ff       	jmp    801073ba <alltraps>

80107da0 <vector127>:
.globl vector127
vector127:
  pushl $0
80107da0:	6a 00                	push   $0x0
  pushl $127
80107da2:	6a 7f                	push   $0x7f
  jmp alltraps
80107da4:	e9 11 f6 ff ff       	jmp    801073ba <alltraps>

80107da9 <vector128>:
.globl vector128
vector128:
  pushl $0
80107da9:	6a 00                	push   $0x0
  pushl $128
80107dab:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107db0:	e9 05 f6 ff ff       	jmp    801073ba <alltraps>

80107db5 <vector129>:
.globl vector129
vector129:
  pushl $0
80107db5:	6a 00                	push   $0x0
  pushl $129
80107db7:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107dbc:	e9 f9 f5 ff ff       	jmp    801073ba <alltraps>

80107dc1 <vector130>:
.globl vector130
vector130:
  pushl $0
80107dc1:	6a 00                	push   $0x0
  pushl $130
80107dc3:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107dc8:	e9 ed f5 ff ff       	jmp    801073ba <alltraps>

80107dcd <vector131>:
.globl vector131
vector131:
  pushl $0
80107dcd:	6a 00                	push   $0x0
  pushl $131
80107dcf:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107dd4:	e9 e1 f5 ff ff       	jmp    801073ba <alltraps>

80107dd9 <vector132>:
.globl vector132
vector132:
  pushl $0
80107dd9:	6a 00                	push   $0x0
  pushl $132
80107ddb:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107de0:	e9 d5 f5 ff ff       	jmp    801073ba <alltraps>

80107de5 <vector133>:
.globl vector133
vector133:
  pushl $0
80107de5:	6a 00                	push   $0x0
  pushl $133
80107de7:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107dec:	e9 c9 f5 ff ff       	jmp    801073ba <alltraps>

80107df1 <vector134>:
.globl vector134
vector134:
  pushl $0
80107df1:	6a 00                	push   $0x0
  pushl $134
80107df3:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107df8:	e9 bd f5 ff ff       	jmp    801073ba <alltraps>

80107dfd <vector135>:
.globl vector135
vector135:
  pushl $0
80107dfd:	6a 00                	push   $0x0
  pushl $135
80107dff:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107e04:	e9 b1 f5 ff ff       	jmp    801073ba <alltraps>

80107e09 <vector136>:
.globl vector136
vector136:
  pushl $0
80107e09:	6a 00                	push   $0x0
  pushl $136
80107e0b:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107e10:	e9 a5 f5 ff ff       	jmp    801073ba <alltraps>

80107e15 <vector137>:
.globl vector137
vector137:
  pushl $0
80107e15:	6a 00                	push   $0x0
  pushl $137
80107e17:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107e1c:	e9 99 f5 ff ff       	jmp    801073ba <alltraps>

80107e21 <vector138>:
.globl vector138
vector138:
  pushl $0
80107e21:	6a 00                	push   $0x0
  pushl $138
80107e23:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107e28:	e9 8d f5 ff ff       	jmp    801073ba <alltraps>

80107e2d <vector139>:
.globl vector139
vector139:
  pushl $0
80107e2d:	6a 00                	push   $0x0
  pushl $139
80107e2f:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107e34:	e9 81 f5 ff ff       	jmp    801073ba <alltraps>

80107e39 <vector140>:
.globl vector140
vector140:
  pushl $0
80107e39:	6a 00                	push   $0x0
  pushl $140
80107e3b:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107e40:	e9 75 f5 ff ff       	jmp    801073ba <alltraps>

80107e45 <vector141>:
.globl vector141
vector141:
  pushl $0
80107e45:	6a 00                	push   $0x0
  pushl $141
80107e47:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107e4c:	e9 69 f5 ff ff       	jmp    801073ba <alltraps>

80107e51 <vector142>:
.globl vector142
vector142:
  pushl $0
80107e51:	6a 00                	push   $0x0
  pushl $142
80107e53:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107e58:	e9 5d f5 ff ff       	jmp    801073ba <alltraps>

80107e5d <vector143>:
.globl vector143
vector143:
  pushl $0
80107e5d:	6a 00                	push   $0x0
  pushl $143
80107e5f:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107e64:	e9 51 f5 ff ff       	jmp    801073ba <alltraps>

80107e69 <vector144>:
.globl vector144
vector144:
  pushl $0
80107e69:	6a 00                	push   $0x0
  pushl $144
80107e6b:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107e70:	e9 45 f5 ff ff       	jmp    801073ba <alltraps>

80107e75 <vector145>:
.globl vector145
vector145:
  pushl $0
80107e75:	6a 00                	push   $0x0
  pushl $145
80107e77:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107e7c:	e9 39 f5 ff ff       	jmp    801073ba <alltraps>

80107e81 <vector146>:
.globl vector146
vector146:
  pushl $0
80107e81:	6a 00                	push   $0x0
  pushl $146
80107e83:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107e88:	e9 2d f5 ff ff       	jmp    801073ba <alltraps>

80107e8d <vector147>:
.globl vector147
vector147:
  pushl $0
80107e8d:	6a 00                	push   $0x0
  pushl $147
80107e8f:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107e94:	e9 21 f5 ff ff       	jmp    801073ba <alltraps>

80107e99 <vector148>:
.globl vector148
vector148:
  pushl $0
80107e99:	6a 00                	push   $0x0
  pushl $148
80107e9b:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107ea0:	e9 15 f5 ff ff       	jmp    801073ba <alltraps>

80107ea5 <vector149>:
.globl vector149
vector149:
  pushl $0
80107ea5:	6a 00                	push   $0x0
  pushl $149
80107ea7:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107eac:	e9 09 f5 ff ff       	jmp    801073ba <alltraps>

80107eb1 <vector150>:
.globl vector150
vector150:
  pushl $0
80107eb1:	6a 00                	push   $0x0
  pushl $150
80107eb3:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107eb8:	e9 fd f4 ff ff       	jmp    801073ba <alltraps>

80107ebd <vector151>:
.globl vector151
vector151:
  pushl $0
80107ebd:	6a 00                	push   $0x0
  pushl $151
80107ebf:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107ec4:	e9 f1 f4 ff ff       	jmp    801073ba <alltraps>

80107ec9 <vector152>:
.globl vector152
vector152:
  pushl $0
80107ec9:	6a 00                	push   $0x0
  pushl $152
80107ecb:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107ed0:	e9 e5 f4 ff ff       	jmp    801073ba <alltraps>

80107ed5 <vector153>:
.globl vector153
vector153:
  pushl $0
80107ed5:	6a 00                	push   $0x0
  pushl $153
80107ed7:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107edc:	e9 d9 f4 ff ff       	jmp    801073ba <alltraps>

80107ee1 <vector154>:
.globl vector154
vector154:
  pushl $0
80107ee1:	6a 00                	push   $0x0
  pushl $154
80107ee3:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107ee8:	e9 cd f4 ff ff       	jmp    801073ba <alltraps>

80107eed <vector155>:
.globl vector155
vector155:
  pushl $0
80107eed:	6a 00                	push   $0x0
  pushl $155
80107eef:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107ef4:	e9 c1 f4 ff ff       	jmp    801073ba <alltraps>

80107ef9 <vector156>:
.globl vector156
vector156:
  pushl $0
80107ef9:	6a 00                	push   $0x0
  pushl $156
80107efb:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107f00:	e9 b5 f4 ff ff       	jmp    801073ba <alltraps>

80107f05 <vector157>:
.globl vector157
vector157:
  pushl $0
80107f05:	6a 00                	push   $0x0
  pushl $157
80107f07:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107f0c:	e9 a9 f4 ff ff       	jmp    801073ba <alltraps>

80107f11 <vector158>:
.globl vector158
vector158:
  pushl $0
80107f11:	6a 00                	push   $0x0
  pushl $158
80107f13:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107f18:	e9 9d f4 ff ff       	jmp    801073ba <alltraps>

80107f1d <vector159>:
.globl vector159
vector159:
  pushl $0
80107f1d:	6a 00                	push   $0x0
  pushl $159
80107f1f:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107f24:	e9 91 f4 ff ff       	jmp    801073ba <alltraps>

80107f29 <vector160>:
.globl vector160
vector160:
  pushl $0
80107f29:	6a 00                	push   $0x0
  pushl $160
80107f2b:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107f30:	e9 85 f4 ff ff       	jmp    801073ba <alltraps>

80107f35 <vector161>:
.globl vector161
vector161:
  pushl $0
80107f35:	6a 00                	push   $0x0
  pushl $161
80107f37:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107f3c:	e9 79 f4 ff ff       	jmp    801073ba <alltraps>

80107f41 <vector162>:
.globl vector162
vector162:
  pushl $0
80107f41:	6a 00                	push   $0x0
  pushl $162
80107f43:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107f48:	e9 6d f4 ff ff       	jmp    801073ba <alltraps>

80107f4d <vector163>:
.globl vector163
vector163:
  pushl $0
80107f4d:	6a 00                	push   $0x0
  pushl $163
80107f4f:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107f54:	e9 61 f4 ff ff       	jmp    801073ba <alltraps>

80107f59 <vector164>:
.globl vector164
vector164:
  pushl $0
80107f59:	6a 00                	push   $0x0
  pushl $164
80107f5b:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107f60:	e9 55 f4 ff ff       	jmp    801073ba <alltraps>

80107f65 <vector165>:
.globl vector165
vector165:
  pushl $0
80107f65:	6a 00                	push   $0x0
  pushl $165
80107f67:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107f6c:	e9 49 f4 ff ff       	jmp    801073ba <alltraps>

80107f71 <vector166>:
.globl vector166
vector166:
  pushl $0
80107f71:	6a 00                	push   $0x0
  pushl $166
80107f73:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107f78:	e9 3d f4 ff ff       	jmp    801073ba <alltraps>

80107f7d <vector167>:
.globl vector167
vector167:
  pushl $0
80107f7d:	6a 00                	push   $0x0
  pushl $167
80107f7f:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107f84:	e9 31 f4 ff ff       	jmp    801073ba <alltraps>

80107f89 <vector168>:
.globl vector168
vector168:
  pushl $0
80107f89:	6a 00                	push   $0x0
  pushl $168
80107f8b:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107f90:	e9 25 f4 ff ff       	jmp    801073ba <alltraps>

80107f95 <vector169>:
.globl vector169
vector169:
  pushl $0
80107f95:	6a 00                	push   $0x0
  pushl $169
80107f97:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107f9c:	e9 19 f4 ff ff       	jmp    801073ba <alltraps>

80107fa1 <vector170>:
.globl vector170
vector170:
  pushl $0
80107fa1:	6a 00                	push   $0x0
  pushl $170
80107fa3:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107fa8:	e9 0d f4 ff ff       	jmp    801073ba <alltraps>

80107fad <vector171>:
.globl vector171
vector171:
  pushl $0
80107fad:	6a 00                	push   $0x0
  pushl $171
80107faf:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107fb4:	e9 01 f4 ff ff       	jmp    801073ba <alltraps>

80107fb9 <vector172>:
.globl vector172
vector172:
  pushl $0
80107fb9:	6a 00                	push   $0x0
  pushl $172
80107fbb:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107fc0:	e9 f5 f3 ff ff       	jmp    801073ba <alltraps>

80107fc5 <vector173>:
.globl vector173
vector173:
  pushl $0
80107fc5:	6a 00                	push   $0x0
  pushl $173
80107fc7:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107fcc:	e9 e9 f3 ff ff       	jmp    801073ba <alltraps>

80107fd1 <vector174>:
.globl vector174
vector174:
  pushl $0
80107fd1:	6a 00                	push   $0x0
  pushl $174
80107fd3:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107fd8:	e9 dd f3 ff ff       	jmp    801073ba <alltraps>

80107fdd <vector175>:
.globl vector175
vector175:
  pushl $0
80107fdd:	6a 00                	push   $0x0
  pushl $175
80107fdf:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107fe4:	e9 d1 f3 ff ff       	jmp    801073ba <alltraps>

80107fe9 <vector176>:
.globl vector176
vector176:
  pushl $0
80107fe9:	6a 00                	push   $0x0
  pushl $176
80107feb:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107ff0:	e9 c5 f3 ff ff       	jmp    801073ba <alltraps>

80107ff5 <vector177>:
.globl vector177
vector177:
  pushl $0
80107ff5:	6a 00                	push   $0x0
  pushl $177
80107ff7:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107ffc:	e9 b9 f3 ff ff       	jmp    801073ba <alltraps>

80108001 <vector178>:
.globl vector178
vector178:
  pushl $0
80108001:	6a 00                	push   $0x0
  pushl $178
80108003:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108008:	e9 ad f3 ff ff       	jmp    801073ba <alltraps>

8010800d <vector179>:
.globl vector179
vector179:
  pushl $0
8010800d:	6a 00                	push   $0x0
  pushl $179
8010800f:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108014:	e9 a1 f3 ff ff       	jmp    801073ba <alltraps>

80108019 <vector180>:
.globl vector180
vector180:
  pushl $0
80108019:	6a 00                	push   $0x0
  pushl $180
8010801b:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108020:	e9 95 f3 ff ff       	jmp    801073ba <alltraps>

80108025 <vector181>:
.globl vector181
vector181:
  pushl $0
80108025:	6a 00                	push   $0x0
  pushl $181
80108027:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010802c:	e9 89 f3 ff ff       	jmp    801073ba <alltraps>

80108031 <vector182>:
.globl vector182
vector182:
  pushl $0
80108031:	6a 00                	push   $0x0
  pushl $182
80108033:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108038:	e9 7d f3 ff ff       	jmp    801073ba <alltraps>

8010803d <vector183>:
.globl vector183
vector183:
  pushl $0
8010803d:	6a 00                	push   $0x0
  pushl $183
8010803f:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108044:	e9 71 f3 ff ff       	jmp    801073ba <alltraps>

80108049 <vector184>:
.globl vector184
vector184:
  pushl $0
80108049:	6a 00                	push   $0x0
  pushl $184
8010804b:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108050:	e9 65 f3 ff ff       	jmp    801073ba <alltraps>

80108055 <vector185>:
.globl vector185
vector185:
  pushl $0
80108055:	6a 00                	push   $0x0
  pushl $185
80108057:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010805c:	e9 59 f3 ff ff       	jmp    801073ba <alltraps>

80108061 <vector186>:
.globl vector186
vector186:
  pushl $0
80108061:	6a 00                	push   $0x0
  pushl $186
80108063:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108068:	e9 4d f3 ff ff       	jmp    801073ba <alltraps>

8010806d <vector187>:
.globl vector187
vector187:
  pushl $0
8010806d:	6a 00                	push   $0x0
  pushl $187
8010806f:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108074:	e9 41 f3 ff ff       	jmp    801073ba <alltraps>

80108079 <vector188>:
.globl vector188
vector188:
  pushl $0
80108079:	6a 00                	push   $0x0
  pushl $188
8010807b:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108080:	e9 35 f3 ff ff       	jmp    801073ba <alltraps>

80108085 <vector189>:
.globl vector189
vector189:
  pushl $0
80108085:	6a 00                	push   $0x0
  pushl $189
80108087:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010808c:	e9 29 f3 ff ff       	jmp    801073ba <alltraps>

80108091 <vector190>:
.globl vector190
vector190:
  pushl $0
80108091:	6a 00                	push   $0x0
  pushl $190
80108093:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108098:	e9 1d f3 ff ff       	jmp    801073ba <alltraps>

8010809d <vector191>:
.globl vector191
vector191:
  pushl $0
8010809d:	6a 00                	push   $0x0
  pushl $191
8010809f:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801080a4:	e9 11 f3 ff ff       	jmp    801073ba <alltraps>

801080a9 <vector192>:
.globl vector192
vector192:
  pushl $0
801080a9:	6a 00                	push   $0x0
  pushl $192
801080ab:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801080b0:	e9 05 f3 ff ff       	jmp    801073ba <alltraps>

801080b5 <vector193>:
.globl vector193
vector193:
  pushl $0
801080b5:	6a 00                	push   $0x0
  pushl $193
801080b7:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801080bc:	e9 f9 f2 ff ff       	jmp    801073ba <alltraps>

801080c1 <vector194>:
.globl vector194
vector194:
  pushl $0
801080c1:	6a 00                	push   $0x0
  pushl $194
801080c3:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801080c8:	e9 ed f2 ff ff       	jmp    801073ba <alltraps>

801080cd <vector195>:
.globl vector195
vector195:
  pushl $0
801080cd:	6a 00                	push   $0x0
  pushl $195
801080cf:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801080d4:	e9 e1 f2 ff ff       	jmp    801073ba <alltraps>

801080d9 <vector196>:
.globl vector196
vector196:
  pushl $0
801080d9:	6a 00                	push   $0x0
  pushl $196
801080db:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801080e0:	e9 d5 f2 ff ff       	jmp    801073ba <alltraps>

801080e5 <vector197>:
.globl vector197
vector197:
  pushl $0
801080e5:	6a 00                	push   $0x0
  pushl $197
801080e7:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801080ec:	e9 c9 f2 ff ff       	jmp    801073ba <alltraps>

801080f1 <vector198>:
.globl vector198
vector198:
  pushl $0
801080f1:	6a 00                	push   $0x0
  pushl $198
801080f3:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801080f8:	e9 bd f2 ff ff       	jmp    801073ba <alltraps>

801080fd <vector199>:
.globl vector199
vector199:
  pushl $0
801080fd:	6a 00                	push   $0x0
  pushl $199
801080ff:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108104:	e9 b1 f2 ff ff       	jmp    801073ba <alltraps>

80108109 <vector200>:
.globl vector200
vector200:
  pushl $0
80108109:	6a 00                	push   $0x0
  pushl $200
8010810b:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108110:	e9 a5 f2 ff ff       	jmp    801073ba <alltraps>

80108115 <vector201>:
.globl vector201
vector201:
  pushl $0
80108115:	6a 00                	push   $0x0
  pushl $201
80108117:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010811c:	e9 99 f2 ff ff       	jmp    801073ba <alltraps>

80108121 <vector202>:
.globl vector202
vector202:
  pushl $0
80108121:	6a 00                	push   $0x0
  pushl $202
80108123:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108128:	e9 8d f2 ff ff       	jmp    801073ba <alltraps>

8010812d <vector203>:
.globl vector203
vector203:
  pushl $0
8010812d:	6a 00                	push   $0x0
  pushl $203
8010812f:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108134:	e9 81 f2 ff ff       	jmp    801073ba <alltraps>

80108139 <vector204>:
.globl vector204
vector204:
  pushl $0
80108139:	6a 00                	push   $0x0
  pushl $204
8010813b:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108140:	e9 75 f2 ff ff       	jmp    801073ba <alltraps>

80108145 <vector205>:
.globl vector205
vector205:
  pushl $0
80108145:	6a 00                	push   $0x0
  pushl $205
80108147:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010814c:	e9 69 f2 ff ff       	jmp    801073ba <alltraps>

80108151 <vector206>:
.globl vector206
vector206:
  pushl $0
80108151:	6a 00                	push   $0x0
  pushl $206
80108153:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108158:	e9 5d f2 ff ff       	jmp    801073ba <alltraps>

8010815d <vector207>:
.globl vector207
vector207:
  pushl $0
8010815d:	6a 00                	push   $0x0
  pushl $207
8010815f:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108164:	e9 51 f2 ff ff       	jmp    801073ba <alltraps>

80108169 <vector208>:
.globl vector208
vector208:
  pushl $0
80108169:	6a 00                	push   $0x0
  pushl $208
8010816b:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108170:	e9 45 f2 ff ff       	jmp    801073ba <alltraps>

80108175 <vector209>:
.globl vector209
vector209:
  pushl $0
80108175:	6a 00                	push   $0x0
  pushl $209
80108177:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010817c:	e9 39 f2 ff ff       	jmp    801073ba <alltraps>

80108181 <vector210>:
.globl vector210
vector210:
  pushl $0
80108181:	6a 00                	push   $0x0
  pushl $210
80108183:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108188:	e9 2d f2 ff ff       	jmp    801073ba <alltraps>

8010818d <vector211>:
.globl vector211
vector211:
  pushl $0
8010818d:	6a 00                	push   $0x0
  pushl $211
8010818f:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108194:	e9 21 f2 ff ff       	jmp    801073ba <alltraps>

80108199 <vector212>:
.globl vector212
vector212:
  pushl $0
80108199:	6a 00                	push   $0x0
  pushl $212
8010819b:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801081a0:	e9 15 f2 ff ff       	jmp    801073ba <alltraps>

801081a5 <vector213>:
.globl vector213
vector213:
  pushl $0
801081a5:	6a 00                	push   $0x0
  pushl $213
801081a7:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801081ac:	e9 09 f2 ff ff       	jmp    801073ba <alltraps>

801081b1 <vector214>:
.globl vector214
vector214:
  pushl $0
801081b1:	6a 00                	push   $0x0
  pushl $214
801081b3:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801081b8:	e9 fd f1 ff ff       	jmp    801073ba <alltraps>

801081bd <vector215>:
.globl vector215
vector215:
  pushl $0
801081bd:	6a 00                	push   $0x0
  pushl $215
801081bf:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801081c4:	e9 f1 f1 ff ff       	jmp    801073ba <alltraps>

801081c9 <vector216>:
.globl vector216
vector216:
  pushl $0
801081c9:	6a 00                	push   $0x0
  pushl $216
801081cb:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801081d0:	e9 e5 f1 ff ff       	jmp    801073ba <alltraps>

801081d5 <vector217>:
.globl vector217
vector217:
  pushl $0
801081d5:	6a 00                	push   $0x0
  pushl $217
801081d7:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801081dc:	e9 d9 f1 ff ff       	jmp    801073ba <alltraps>

801081e1 <vector218>:
.globl vector218
vector218:
  pushl $0
801081e1:	6a 00                	push   $0x0
  pushl $218
801081e3:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801081e8:	e9 cd f1 ff ff       	jmp    801073ba <alltraps>

801081ed <vector219>:
.globl vector219
vector219:
  pushl $0
801081ed:	6a 00                	push   $0x0
  pushl $219
801081ef:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801081f4:	e9 c1 f1 ff ff       	jmp    801073ba <alltraps>

801081f9 <vector220>:
.globl vector220
vector220:
  pushl $0
801081f9:	6a 00                	push   $0x0
  pushl $220
801081fb:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108200:	e9 b5 f1 ff ff       	jmp    801073ba <alltraps>

80108205 <vector221>:
.globl vector221
vector221:
  pushl $0
80108205:	6a 00                	push   $0x0
  pushl $221
80108207:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010820c:	e9 a9 f1 ff ff       	jmp    801073ba <alltraps>

80108211 <vector222>:
.globl vector222
vector222:
  pushl $0
80108211:	6a 00                	push   $0x0
  pushl $222
80108213:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108218:	e9 9d f1 ff ff       	jmp    801073ba <alltraps>

8010821d <vector223>:
.globl vector223
vector223:
  pushl $0
8010821d:	6a 00                	push   $0x0
  pushl $223
8010821f:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108224:	e9 91 f1 ff ff       	jmp    801073ba <alltraps>

80108229 <vector224>:
.globl vector224
vector224:
  pushl $0
80108229:	6a 00                	push   $0x0
  pushl $224
8010822b:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108230:	e9 85 f1 ff ff       	jmp    801073ba <alltraps>

80108235 <vector225>:
.globl vector225
vector225:
  pushl $0
80108235:	6a 00                	push   $0x0
  pushl $225
80108237:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010823c:	e9 79 f1 ff ff       	jmp    801073ba <alltraps>

80108241 <vector226>:
.globl vector226
vector226:
  pushl $0
80108241:	6a 00                	push   $0x0
  pushl $226
80108243:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108248:	e9 6d f1 ff ff       	jmp    801073ba <alltraps>

8010824d <vector227>:
.globl vector227
vector227:
  pushl $0
8010824d:	6a 00                	push   $0x0
  pushl $227
8010824f:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108254:	e9 61 f1 ff ff       	jmp    801073ba <alltraps>

80108259 <vector228>:
.globl vector228
vector228:
  pushl $0
80108259:	6a 00                	push   $0x0
  pushl $228
8010825b:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108260:	e9 55 f1 ff ff       	jmp    801073ba <alltraps>

80108265 <vector229>:
.globl vector229
vector229:
  pushl $0
80108265:	6a 00                	push   $0x0
  pushl $229
80108267:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010826c:	e9 49 f1 ff ff       	jmp    801073ba <alltraps>

80108271 <vector230>:
.globl vector230
vector230:
  pushl $0
80108271:	6a 00                	push   $0x0
  pushl $230
80108273:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108278:	e9 3d f1 ff ff       	jmp    801073ba <alltraps>

8010827d <vector231>:
.globl vector231
vector231:
  pushl $0
8010827d:	6a 00                	push   $0x0
  pushl $231
8010827f:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108284:	e9 31 f1 ff ff       	jmp    801073ba <alltraps>

80108289 <vector232>:
.globl vector232
vector232:
  pushl $0
80108289:	6a 00                	push   $0x0
  pushl $232
8010828b:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108290:	e9 25 f1 ff ff       	jmp    801073ba <alltraps>

80108295 <vector233>:
.globl vector233
vector233:
  pushl $0
80108295:	6a 00                	push   $0x0
  pushl $233
80108297:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010829c:	e9 19 f1 ff ff       	jmp    801073ba <alltraps>

801082a1 <vector234>:
.globl vector234
vector234:
  pushl $0
801082a1:	6a 00                	push   $0x0
  pushl $234
801082a3:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801082a8:	e9 0d f1 ff ff       	jmp    801073ba <alltraps>

801082ad <vector235>:
.globl vector235
vector235:
  pushl $0
801082ad:	6a 00                	push   $0x0
  pushl $235
801082af:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801082b4:	e9 01 f1 ff ff       	jmp    801073ba <alltraps>

801082b9 <vector236>:
.globl vector236
vector236:
  pushl $0
801082b9:	6a 00                	push   $0x0
  pushl $236
801082bb:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801082c0:	e9 f5 f0 ff ff       	jmp    801073ba <alltraps>

801082c5 <vector237>:
.globl vector237
vector237:
  pushl $0
801082c5:	6a 00                	push   $0x0
  pushl $237
801082c7:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801082cc:	e9 e9 f0 ff ff       	jmp    801073ba <alltraps>

801082d1 <vector238>:
.globl vector238
vector238:
  pushl $0
801082d1:	6a 00                	push   $0x0
  pushl $238
801082d3:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801082d8:	e9 dd f0 ff ff       	jmp    801073ba <alltraps>

801082dd <vector239>:
.globl vector239
vector239:
  pushl $0
801082dd:	6a 00                	push   $0x0
  pushl $239
801082df:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801082e4:	e9 d1 f0 ff ff       	jmp    801073ba <alltraps>

801082e9 <vector240>:
.globl vector240
vector240:
  pushl $0
801082e9:	6a 00                	push   $0x0
  pushl $240
801082eb:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801082f0:	e9 c5 f0 ff ff       	jmp    801073ba <alltraps>

801082f5 <vector241>:
.globl vector241
vector241:
  pushl $0
801082f5:	6a 00                	push   $0x0
  pushl $241
801082f7:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801082fc:	e9 b9 f0 ff ff       	jmp    801073ba <alltraps>

80108301 <vector242>:
.globl vector242
vector242:
  pushl $0
80108301:	6a 00                	push   $0x0
  pushl $242
80108303:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108308:	e9 ad f0 ff ff       	jmp    801073ba <alltraps>

8010830d <vector243>:
.globl vector243
vector243:
  pushl $0
8010830d:	6a 00                	push   $0x0
  pushl $243
8010830f:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108314:	e9 a1 f0 ff ff       	jmp    801073ba <alltraps>

80108319 <vector244>:
.globl vector244
vector244:
  pushl $0
80108319:	6a 00                	push   $0x0
  pushl $244
8010831b:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108320:	e9 95 f0 ff ff       	jmp    801073ba <alltraps>

80108325 <vector245>:
.globl vector245
vector245:
  pushl $0
80108325:	6a 00                	push   $0x0
  pushl $245
80108327:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010832c:	e9 89 f0 ff ff       	jmp    801073ba <alltraps>

80108331 <vector246>:
.globl vector246
vector246:
  pushl $0
80108331:	6a 00                	push   $0x0
  pushl $246
80108333:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108338:	e9 7d f0 ff ff       	jmp    801073ba <alltraps>

8010833d <vector247>:
.globl vector247
vector247:
  pushl $0
8010833d:	6a 00                	push   $0x0
  pushl $247
8010833f:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108344:	e9 71 f0 ff ff       	jmp    801073ba <alltraps>

80108349 <vector248>:
.globl vector248
vector248:
  pushl $0
80108349:	6a 00                	push   $0x0
  pushl $248
8010834b:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108350:	e9 65 f0 ff ff       	jmp    801073ba <alltraps>

80108355 <vector249>:
.globl vector249
vector249:
  pushl $0
80108355:	6a 00                	push   $0x0
  pushl $249
80108357:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010835c:	e9 59 f0 ff ff       	jmp    801073ba <alltraps>

80108361 <vector250>:
.globl vector250
vector250:
  pushl $0
80108361:	6a 00                	push   $0x0
  pushl $250
80108363:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108368:	e9 4d f0 ff ff       	jmp    801073ba <alltraps>

8010836d <vector251>:
.globl vector251
vector251:
  pushl $0
8010836d:	6a 00                	push   $0x0
  pushl $251
8010836f:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108374:	e9 41 f0 ff ff       	jmp    801073ba <alltraps>

80108379 <vector252>:
.globl vector252
vector252:
  pushl $0
80108379:	6a 00                	push   $0x0
  pushl $252
8010837b:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108380:	e9 35 f0 ff ff       	jmp    801073ba <alltraps>

80108385 <vector253>:
.globl vector253
vector253:
  pushl $0
80108385:	6a 00                	push   $0x0
  pushl $253
80108387:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010838c:	e9 29 f0 ff ff       	jmp    801073ba <alltraps>

80108391 <vector254>:
.globl vector254
vector254:
  pushl $0
80108391:	6a 00                	push   $0x0
  pushl $254
80108393:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108398:	e9 1d f0 ff ff       	jmp    801073ba <alltraps>

8010839d <vector255>:
.globl vector255
vector255:
  pushl $0
8010839d:	6a 00                	push   $0x0
  pushl $255
8010839f:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801083a4:	e9 11 f0 ff ff       	jmp    801073ba <alltraps>
801083a9:	66 90                	xchg   %ax,%ax
801083ab:	66 90                	xchg   %ax,%ax
801083ad:	66 90                	xchg   %ax,%ax
801083af:	90                   	nop

801083b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801083b0:	55                   	push   %ebp
801083b1:	89 e5                	mov    %esp,%ebp
801083b3:	57                   	push   %edi
801083b4:	56                   	push   %esi
801083b5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801083b6:	89 d3                	mov    %edx,%ebx
{
801083b8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801083ba:	c1 eb 16             	shr    $0x16,%ebx
801083bd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801083c0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801083c3:	8b 06                	mov    (%esi),%eax
801083c5:	a8 01                	test   $0x1,%al
801083c7:	74 27                	je     801083f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801083c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083ce:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801083d4:	c1 ef 0a             	shr    $0xa,%edi
}
801083d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801083da:	89 fa                	mov    %edi,%edx
801083dc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801083e2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801083e5:	5b                   	pop    %ebx
801083e6:	5e                   	pop    %esi
801083e7:	5f                   	pop    %edi
801083e8:	5d                   	pop    %ebp
801083e9:	c3                   	ret    
801083ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801083f0:	85 c9                	test   %ecx,%ecx
801083f2:	74 2c                	je     80108420 <walkpgdir+0x70>
801083f4:	e8 17 ab ff ff       	call   80102f10 <kalloc>
801083f9:	85 c0                	test   %eax,%eax
801083fb:	89 c3                	mov    %eax,%ebx
801083fd:	74 21                	je     80108420 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801083ff:	83 ec 04             	sub    $0x4,%esp
80108402:	68 00 10 00 00       	push   $0x1000
80108407:	6a 00                	push   $0x0
80108409:	50                   	push   %eax
8010840a:	e8 51 d7 ff ff       	call   80105b60 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010840f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108415:	83 c4 10             	add    $0x10,%esp
80108418:	83 c8 07             	or     $0x7,%eax
8010841b:	89 06                	mov    %eax,(%esi)
8010841d:	eb b5                	jmp    801083d4 <walkpgdir+0x24>
8010841f:	90                   	nop
}
80108420:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80108423:	31 c0                	xor    %eax,%eax
}
80108425:	5b                   	pop    %ebx
80108426:	5e                   	pop    %esi
80108427:	5f                   	pop    %edi
80108428:	5d                   	pop    %ebp
80108429:	c3                   	ret    
8010842a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108430 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108430:	55                   	push   %ebp
80108431:	89 e5                	mov    %esp,%ebp
80108433:	57                   	push   %edi
80108434:	56                   	push   %esi
80108435:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80108436:	89 d3                	mov    %edx,%ebx
80108438:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010843e:	83 ec 1c             	sub    $0x1c,%esp
80108441:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108444:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80108448:	8b 7d 08             	mov    0x8(%ebp),%edi
8010844b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108450:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80108453:	8b 45 0c             	mov    0xc(%ebp),%eax
80108456:	29 df                	sub    %ebx,%edi
80108458:	83 c8 01             	or     $0x1,%eax
8010845b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010845e:	eb 15                	jmp    80108475 <mappages+0x45>
    if(*pte & PTE_P)
80108460:	f6 00 01             	testb  $0x1,(%eax)
80108463:	75 45                	jne    801084aa <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80108465:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80108468:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010846b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010846d:	74 31                	je     801084a0 <mappages+0x70>
      break;
    a += PGSIZE;
8010846f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108478:	b9 01 00 00 00       	mov    $0x1,%ecx
8010847d:	89 da                	mov    %ebx,%edx
8010847f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80108482:	e8 29 ff ff ff       	call   801083b0 <walkpgdir>
80108487:	85 c0                	test   %eax,%eax
80108489:	75 d5                	jne    80108460 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010848b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010848e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108493:	5b                   	pop    %ebx
80108494:	5e                   	pop    %esi
80108495:	5f                   	pop    %edi
80108496:	5d                   	pop    %ebp
80108497:	c3                   	ret    
80108498:	90                   	nop
80108499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801084a3:	31 c0                	xor    %eax,%eax
}
801084a5:	5b                   	pop    %ebx
801084a6:	5e                   	pop    %esi
801084a7:	5f                   	pop    %edi
801084a8:	5d                   	pop    %ebp
801084a9:	c3                   	ret    
      panic("remap");
801084aa:	83 ec 0c             	sub    $0xc,%esp
801084ad:	68 a8 9b 10 80       	push   $0x80109ba8
801084b2:	e8 b9 84 ff ff       	call   80100970 <panic>
801084b7:	89 f6                	mov    %esi,%esi
801084b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801084c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801084c0:	55                   	push   %ebp
801084c1:	89 e5                	mov    %esp,%ebp
801084c3:	57                   	push   %edi
801084c4:	56                   	push   %esi
801084c5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801084c6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801084cc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
801084ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801084d4:	83 ec 1c             	sub    $0x1c,%esp
801084d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801084da:	39 d3                	cmp    %edx,%ebx
801084dc:	73 66                	jae    80108544 <deallocuvm.part.0+0x84>
801084de:	89 d6                	mov    %edx,%esi
801084e0:	eb 3d                	jmp    8010851f <deallocuvm.part.0+0x5f>
801084e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801084e8:	8b 10                	mov    (%eax),%edx
801084ea:	f6 c2 01             	test   $0x1,%dl
801084ed:	74 26                	je     80108515 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801084ef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801084f5:	74 58                	je     8010854f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801084f7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801084fa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108500:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80108503:	52                   	push   %edx
80108504:	e8 57 a8 ff ff       	call   80102d60 <kfree>
      *pte = 0;
80108509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010850c:	83 c4 10             	add    $0x10,%esp
8010850f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108515:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010851b:	39 f3                	cmp    %esi,%ebx
8010851d:	73 25                	jae    80108544 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010851f:	31 c9                	xor    %ecx,%ecx
80108521:	89 da                	mov    %ebx,%edx
80108523:	89 f8                	mov    %edi,%eax
80108525:	e8 86 fe ff ff       	call   801083b0 <walkpgdir>
    if(!pte)
8010852a:	85 c0                	test   %eax,%eax
8010852c:	75 ba                	jne    801084e8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010852e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80108534:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010853a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108540:	39 f3                	cmp    %esi,%ebx
80108542:	72 db                	jb     8010851f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80108544:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108547:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010854a:	5b                   	pop    %ebx
8010854b:	5e                   	pop    %esi
8010854c:	5f                   	pop    %edi
8010854d:	5d                   	pop    %ebp
8010854e:	c3                   	ret    
        panic("kfree");
8010854f:	83 ec 0c             	sub    $0xc,%esp
80108552:	68 96 90 10 80       	push   $0x80109096
80108557:	e8 14 84 ff ff       	call   80100970 <panic>
8010855c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108560 <seginit>:
{
80108560:	55                   	push   %ebp
80108561:	89 e5                	mov    %esp,%ebp
80108563:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80108566:	e8 65 c9 ff ff       	call   80104ed0 <cpuid>
8010856b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80108571:	ba 2f 00 00 00       	mov    $0x2f,%edx
80108576:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010857a:	c7 80 b8 b3 15 80 ff 	movl   $0xffff,-0x7fea4c48(%eax)
80108581:	ff 00 00 
80108584:	c7 80 bc b3 15 80 00 	movl   $0xcf9a00,-0x7fea4c44(%eax)
8010858b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010858e:	c7 80 c0 b3 15 80 ff 	movl   $0xffff,-0x7fea4c40(%eax)
80108595:	ff 00 00 
80108598:	c7 80 c4 b3 15 80 00 	movl   $0xcf9200,-0x7fea4c3c(%eax)
8010859f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801085a2:	c7 80 c8 b3 15 80 ff 	movl   $0xffff,-0x7fea4c38(%eax)
801085a9:	ff 00 00 
801085ac:	c7 80 cc b3 15 80 00 	movl   $0xcffa00,-0x7fea4c34(%eax)
801085b3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801085b6:	c7 80 d0 b3 15 80 ff 	movl   $0xffff,-0x7fea4c30(%eax)
801085bd:	ff 00 00 
801085c0:	c7 80 d4 b3 15 80 00 	movl   $0xcff200,-0x7fea4c2c(%eax)
801085c7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801085ca:	05 b0 b3 15 80       	add    $0x8015b3b0,%eax
  pd[1] = (uint)p;
801085cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801085d3:	c1 e8 10             	shr    $0x10,%eax
801085d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801085da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801085dd:	0f 01 10             	lgdtl  (%eax)
}
801085e0:	c9                   	leave  
801085e1:	c3                   	ret    
801085e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801085f0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801085f0:	a1 64 e0 15 80       	mov    0x8015e064,%eax
{
801085f5:	55                   	push   %ebp
801085f6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801085f8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801085fd:	0f 22 d8             	mov    %eax,%cr3
}
80108600:	5d                   	pop    %ebp
80108601:	c3                   	ret    
80108602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108610 <switchuvm>:
{
80108610:	55                   	push   %ebp
80108611:	89 e5                	mov    %esp,%ebp
80108613:	57                   	push   %edi
80108614:	56                   	push   %esi
80108615:	53                   	push   %ebx
80108616:	83 ec 1c             	sub    $0x1c,%esp
80108619:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010861c:	85 db                	test   %ebx,%ebx
8010861e:	0f 84 cb 00 00 00    	je     801086ef <switchuvm+0xdf>
  if(p->kstack == 0)
80108624:	8b 43 08             	mov    0x8(%ebx),%eax
80108627:	85 c0                	test   %eax,%eax
80108629:	0f 84 da 00 00 00    	je     80108709 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010862f:	8b 43 04             	mov    0x4(%ebx),%eax
80108632:	85 c0                	test   %eax,%eax
80108634:	0f 84 c2 00 00 00    	je     801086fc <switchuvm+0xec>
  pushcli();
8010863a:	e8 61 d3 ff ff       	call   801059a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010863f:	e8 0c c8 ff ff       	call   80104e50 <mycpu>
80108644:	89 c6                	mov    %eax,%esi
80108646:	e8 05 c8 ff ff       	call   80104e50 <mycpu>
8010864b:	89 c7                	mov    %eax,%edi
8010864d:	e8 fe c7 ff ff       	call   80104e50 <mycpu>
80108652:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108655:	83 c7 08             	add    $0x8,%edi
80108658:	e8 f3 c7 ff ff       	call   80104e50 <mycpu>
8010865d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108660:	83 c0 08             	add    $0x8,%eax
80108663:	ba 67 00 00 00       	mov    $0x67,%edx
80108668:	c1 e8 18             	shr    $0x18,%eax
8010866b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80108672:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80108679:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010867f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108684:	83 c1 08             	add    $0x8,%ecx
80108687:	c1 e9 10             	shr    $0x10,%ecx
8010868a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80108690:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108695:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010869c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801086a1:	e8 aa c7 ff ff       	call   80104e50 <mycpu>
801086a6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801086ad:	e8 9e c7 ff ff       	call   80104e50 <mycpu>
801086b2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801086b6:	8b 73 08             	mov    0x8(%ebx),%esi
801086b9:	e8 92 c7 ff ff       	call   80104e50 <mycpu>
801086be:	81 c6 00 10 00 00    	add    $0x1000,%esi
801086c4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801086c7:	e8 84 c7 ff ff       	call   80104e50 <mycpu>
801086cc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801086d0:	b8 28 00 00 00       	mov    $0x28,%eax
801086d5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801086d8:	8b 43 04             	mov    0x4(%ebx),%eax
801086db:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801086e0:	0f 22 d8             	mov    %eax,%cr3
}
801086e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801086e6:	5b                   	pop    %ebx
801086e7:	5e                   	pop    %esi
801086e8:	5f                   	pop    %edi
801086e9:	5d                   	pop    %ebp
  popcli();
801086ea:	e9 b1 d3 ff ff       	jmp    80105aa0 <popcli>
    panic("switchuvm: no process");
801086ef:	83 ec 0c             	sub    $0xc,%esp
801086f2:	68 ae 9b 10 80       	push   $0x80109bae
801086f7:	e8 74 82 ff ff       	call   80100970 <panic>
    panic("switchuvm: no pgdir");
801086fc:	83 ec 0c             	sub    $0xc,%esp
801086ff:	68 d9 9b 10 80       	push   $0x80109bd9
80108704:	e8 67 82 ff ff       	call   80100970 <panic>
    panic("switchuvm: no kstack");
80108709:	83 ec 0c             	sub    $0xc,%esp
8010870c:	68 c4 9b 10 80       	push   $0x80109bc4
80108711:	e8 5a 82 ff ff       	call   80100970 <panic>
80108716:	8d 76 00             	lea    0x0(%esi),%esi
80108719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108720 <inituvm>:
{
80108720:	55                   	push   %ebp
80108721:	89 e5                	mov    %esp,%ebp
80108723:	57                   	push   %edi
80108724:	56                   	push   %esi
80108725:	53                   	push   %ebx
80108726:	83 ec 1c             	sub    $0x1c,%esp
80108729:	8b 75 10             	mov    0x10(%ebp),%esi
8010872c:	8b 45 08             	mov    0x8(%ebp),%eax
8010872f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80108732:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80108738:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010873b:	77 49                	ja     80108786 <inituvm+0x66>
  mem = kalloc();
8010873d:	e8 ce a7 ff ff       	call   80102f10 <kalloc>
  memset(mem, 0, PGSIZE);
80108742:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80108745:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80108747:	68 00 10 00 00       	push   $0x1000
8010874c:	6a 00                	push   $0x0
8010874e:	50                   	push   %eax
8010874f:	e8 0c d4 ff ff       	call   80105b60 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108754:	58                   	pop    %eax
80108755:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010875b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108760:	5a                   	pop    %edx
80108761:	6a 06                	push   $0x6
80108763:	50                   	push   %eax
80108764:	31 d2                	xor    %edx,%edx
80108766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108769:	e8 c2 fc ff ff       	call   80108430 <mappages>
  memmove(mem, init, sz);
8010876e:	89 75 10             	mov    %esi,0x10(%ebp)
80108771:	89 7d 0c             	mov    %edi,0xc(%ebp)
80108774:	83 c4 10             	add    $0x10,%esp
80108777:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010877a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010877d:	5b                   	pop    %ebx
8010877e:	5e                   	pop    %esi
8010877f:	5f                   	pop    %edi
80108780:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108781:	e9 8a d4 ff ff       	jmp    80105c10 <memmove>
    panic("inituvm: more than a page");
80108786:	83 ec 0c             	sub    $0xc,%esp
80108789:	68 ed 9b 10 80       	push   $0x80109bed
8010878e:	e8 dd 81 ff ff       	call   80100970 <panic>
80108793:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801087a0 <loaduvm>:
{
801087a0:	55                   	push   %ebp
801087a1:	89 e5                	mov    %esp,%ebp
801087a3:	57                   	push   %edi
801087a4:	56                   	push   %esi
801087a5:	53                   	push   %ebx
801087a6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801087a9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801087b0:	0f 85 91 00 00 00    	jne    80108847 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801087b6:	8b 75 18             	mov    0x18(%ebp),%esi
801087b9:	31 db                	xor    %ebx,%ebx
801087bb:	85 f6                	test   %esi,%esi
801087bd:	75 1a                	jne    801087d9 <loaduvm+0x39>
801087bf:	eb 6f                	jmp    80108830 <loaduvm+0x90>
801087c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801087c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801087ce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801087d4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801087d7:	76 57                	jbe    80108830 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801087d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801087dc:	8b 45 08             	mov    0x8(%ebp),%eax
801087df:	31 c9                	xor    %ecx,%ecx
801087e1:	01 da                	add    %ebx,%edx
801087e3:	e8 c8 fb ff ff       	call   801083b0 <walkpgdir>
801087e8:	85 c0                	test   %eax,%eax
801087ea:	74 4e                	je     8010883a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801087ec:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801087ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801087f1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801087f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801087fb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80108801:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108804:	01 d9                	add    %ebx,%ecx
80108806:	05 00 00 00 80       	add    $0x80000000,%eax
8010880b:	57                   	push   %edi
8010880c:	51                   	push   %ecx
8010880d:	50                   	push   %eax
8010880e:	ff 75 10             	pushl  0x10(%ebp)
80108811:	e8 9a 9b ff ff       	call   801023b0 <readi>
80108816:	83 c4 10             	add    $0x10,%esp
80108819:	39 f8                	cmp    %edi,%eax
8010881b:	74 ab                	je     801087c8 <loaduvm+0x28>
}
8010881d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108825:	5b                   	pop    %ebx
80108826:	5e                   	pop    %esi
80108827:	5f                   	pop    %edi
80108828:	5d                   	pop    %ebp
80108829:	c3                   	ret    
8010882a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108830:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108833:	31 c0                	xor    %eax,%eax
}
80108835:	5b                   	pop    %ebx
80108836:	5e                   	pop    %esi
80108837:	5f                   	pop    %edi
80108838:	5d                   	pop    %ebp
80108839:	c3                   	ret    
      panic("loaduvm: address should exist");
8010883a:	83 ec 0c             	sub    $0xc,%esp
8010883d:	68 07 9c 10 80       	push   $0x80109c07
80108842:	e8 29 81 ff ff       	call   80100970 <panic>
    panic("loaduvm: addr must be page aligned");
80108847:	83 ec 0c             	sub    $0xc,%esp
8010884a:	68 a8 9c 10 80       	push   $0x80109ca8
8010884f:	e8 1c 81 ff ff       	call   80100970 <panic>
80108854:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010885a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108860 <allocuvm>:
{
80108860:	55                   	push   %ebp
80108861:	89 e5                	mov    %esp,%ebp
80108863:	57                   	push   %edi
80108864:	56                   	push   %esi
80108865:	53                   	push   %ebx
80108866:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80108869:	8b 7d 10             	mov    0x10(%ebp),%edi
8010886c:	85 ff                	test   %edi,%edi
8010886e:	0f 88 8e 00 00 00    	js     80108902 <allocuvm+0xa2>
  if(newsz < oldsz)
80108874:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80108877:	0f 82 93 00 00 00    	jb     80108910 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010887d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108880:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80108886:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010888c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010888f:	0f 86 7e 00 00 00    	jbe    80108913 <allocuvm+0xb3>
80108895:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80108898:	8b 7d 08             	mov    0x8(%ebp),%edi
8010889b:	eb 42                	jmp    801088df <allocuvm+0x7f>
8010889d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801088a0:	83 ec 04             	sub    $0x4,%esp
801088a3:	68 00 10 00 00       	push   $0x1000
801088a8:	6a 00                	push   $0x0
801088aa:	50                   	push   %eax
801088ab:	e8 b0 d2 ff ff       	call   80105b60 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801088b0:	58                   	pop    %eax
801088b1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801088b7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801088bc:	5a                   	pop    %edx
801088bd:	6a 06                	push   $0x6
801088bf:	50                   	push   %eax
801088c0:	89 da                	mov    %ebx,%edx
801088c2:	89 f8                	mov    %edi,%eax
801088c4:	e8 67 fb ff ff       	call   80108430 <mappages>
801088c9:	83 c4 10             	add    $0x10,%esp
801088cc:	85 c0                	test   %eax,%eax
801088ce:	78 50                	js     80108920 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801088d0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801088d6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801088d9:	0f 86 81 00 00 00    	jbe    80108960 <allocuvm+0x100>
    mem = kalloc();
801088df:	e8 2c a6 ff ff       	call   80102f10 <kalloc>
    if(mem == 0){
801088e4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801088e6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801088e8:	75 b6                	jne    801088a0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801088ea:	83 ec 0c             	sub    $0xc,%esp
801088ed:	68 25 9c 10 80       	push   $0x80109c25
801088f2:	e8 49 83 ff ff       	call   80100c40 <cprintf>
  if(newsz >= oldsz)
801088f7:	83 c4 10             	add    $0x10,%esp
801088fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801088fd:	39 45 10             	cmp    %eax,0x10(%ebp)
80108900:	77 6e                	ja     80108970 <allocuvm+0x110>
}
80108902:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80108905:	31 ff                	xor    %edi,%edi
}
80108907:	89 f8                	mov    %edi,%eax
80108909:	5b                   	pop    %ebx
8010890a:	5e                   	pop    %esi
8010890b:	5f                   	pop    %edi
8010890c:	5d                   	pop    %ebp
8010890d:	c3                   	ret    
8010890e:	66 90                	xchg   %ax,%ax
    return oldsz;
80108910:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80108913:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108916:	89 f8                	mov    %edi,%eax
80108918:	5b                   	pop    %ebx
80108919:	5e                   	pop    %esi
8010891a:	5f                   	pop    %edi
8010891b:	5d                   	pop    %ebp
8010891c:	c3                   	ret    
8010891d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108920:	83 ec 0c             	sub    $0xc,%esp
80108923:	68 3d 9c 10 80       	push   $0x80109c3d
80108928:	e8 13 83 ff ff       	call   80100c40 <cprintf>
  if(newsz >= oldsz)
8010892d:	83 c4 10             	add    $0x10,%esp
80108930:	8b 45 0c             	mov    0xc(%ebp),%eax
80108933:	39 45 10             	cmp    %eax,0x10(%ebp)
80108936:	76 0d                	jbe    80108945 <allocuvm+0xe5>
80108938:	89 c1                	mov    %eax,%ecx
8010893a:	8b 55 10             	mov    0x10(%ebp),%edx
8010893d:	8b 45 08             	mov    0x8(%ebp),%eax
80108940:	e8 7b fb ff ff       	call   801084c0 <deallocuvm.part.0>
      kfree(mem);
80108945:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80108948:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010894a:	56                   	push   %esi
8010894b:	e8 10 a4 ff ff       	call   80102d60 <kfree>
      return 0;
80108950:	83 c4 10             	add    $0x10,%esp
}
80108953:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108956:	89 f8                	mov    %edi,%eax
80108958:	5b                   	pop    %ebx
80108959:	5e                   	pop    %esi
8010895a:	5f                   	pop    %edi
8010895b:	5d                   	pop    %ebp
8010895c:	c3                   	ret    
8010895d:	8d 76 00             	lea    0x0(%esi),%esi
80108960:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80108963:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108966:	5b                   	pop    %ebx
80108967:	89 f8                	mov    %edi,%eax
80108969:	5e                   	pop    %esi
8010896a:	5f                   	pop    %edi
8010896b:	5d                   	pop    %ebp
8010896c:	c3                   	ret    
8010896d:	8d 76 00             	lea    0x0(%esi),%esi
80108970:	89 c1                	mov    %eax,%ecx
80108972:	8b 55 10             	mov    0x10(%ebp),%edx
80108975:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80108978:	31 ff                	xor    %edi,%edi
8010897a:	e8 41 fb ff ff       	call   801084c0 <deallocuvm.part.0>
8010897f:	eb 92                	jmp    80108913 <allocuvm+0xb3>
80108981:	eb 0d                	jmp    80108990 <deallocuvm>
80108983:	90                   	nop
80108984:	90                   	nop
80108985:	90                   	nop
80108986:	90                   	nop
80108987:	90                   	nop
80108988:	90                   	nop
80108989:	90                   	nop
8010898a:	90                   	nop
8010898b:	90                   	nop
8010898c:	90                   	nop
8010898d:	90                   	nop
8010898e:	90                   	nop
8010898f:	90                   	nop

80108990 <deallocuvm>:
{
80108990:	55                   	push   %ebp
80108991:	89 e5                	mov    %esp,%ebp
80108993:	8b 55 0c             	mov    0xc(%ebp),%edx
80108996:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108999:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010899c:	39 d1                	cmp    %edx,%ecx
8010899e:	73 10                	jae    801089b0 <deallocuvm+0x20>
}
801089a0:	5d                   	pop    %ebp
801089a1:	e9 1a fb ff ff       	jmp    801084c0 <deallocuvm.part.0>
801089a6:	8d 76 00             	lea    0x0(%esi),%esi
801089a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801089b0:	89 d0                	mov    %edx,%eax
801089b2:	5d                   	pop    %ebp
801089b3:	c3                   	ret    
801089b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801089ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801089c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801089c0:	55                   	push   %ebp
801089c1:	89 e5                	mov    %esp,%ebp
801089c3:	57                   	push   %edi
801089c4:	56                   	push   %esi
801089c5:	53                   	push   %ebx
801089c6:	83 ec 0c             	sub    $0xc,%esp
801089c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801089cc:	85 f6                	test   %esi,%esi
801089ce:	74 59                	je     80108a29 <freevm+0x69>
801089d0:	31 c9                	xor    %ecx,%ecx
801089d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801089d7:	89 f0                	mov    %esi,%eax
801089d9:	e8 e2 fa ff ff       	call   801084c0 <deallocuvm.part.0>
801089de:	89 f3                	mov    %esi,%ebx
801089e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801089e6:	eb 0f                	jmp    801089f7 <freevm+0x37>
801089e8:	90                   	nop
801089e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801089f0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801089f3:	39 fb                	cmp    %edi,%ebx
801089f5:	74 23                	je     80108a1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801089f7:	8b 03                	mov    (%ebx),%eax
801089f9:	a8 01                	test   $0x1,%al
801089fb:	74 f3                	je     801089f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801089fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108a02:	83 ec 0c             	sub    $0xc,%esp
80108a05:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108a08:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80108a0d:	50                   	push   %eax
80108a0e:	e8 4d a3 ff ff       	call   80102d60 <kfree>
80108a13:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108a16:	39 fb                	cmp    %edi,%ebx
80108a18:	75 dd                	jne    801089f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108a1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80108a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108a20:	5b                   	pop    %ebx
80108a21:	5e                   	pop    %esi
80108a22:	5f                   	pop    %edi
80108a23:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108a24:	e9 37 a3 ff ff       	jmp    80102d60 <kfree>
    panic("freevm: no pgdir");
80108a29:	83 ec 0c             	sub    $0xc,%esp
80108a2c:	68 59 9c 10 80       	push   $0x80109c59
80108a31:	e8 3a 7f ff ff       	call   80100970 <panic>
80108a36:	8d 76 00             	lea    0x0(%esi),%esi
80108a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108a40 <setupkvm>:
{
80108a40:	55                   	push   %ebp
80108a41:	89 e5                	mov    %esp,%ebp
80108a43:	56                   	push   %esi
80108a44:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108a45:	e8 c6 a4 ff ff       	call   80102f10 <kalloc>
80108a4a:	85 c0                	test   %eax,%eax
80108a4c:	89 c6                	mov    %eax,%esi
80108a4e:	74 42                	je     80108a92 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108a50:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108a53:	bb 60 c4 10 80       	mov    $0x8010c460,%ebx
  memset(pgdir, 0, PGSIZE);
80108a58:	68 00 10 00 00       	push   $0x1000
80108a5d:	6a 00                	push   $0x0
80108a5f:	50                   	push   %eax
80108a60:	e8 fb d0 ff ff       	call   80105b60 <memset>
80108a65:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108a68:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108a6b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108a6e:	83 ec 08             	sub    $0x8,%esp
80108a71:	8b 13                	mov    (%ebx),%edx
80108a73:	ff 73 0c             	pushl  0xc(%ebx)
80108a76:	50                   	push   %eax
80108a77:	29 c1                	sub    %eax,%ecx
80108a79:	89 f0                	mov    %esi,%eax
80108a7b:	e8 b0 f9 ff ff       	call   80108430 <mappages>
80108a80:	83 c4 10             	add    $0x10,%esp
80108a83:	85 c0                	test   %eax,%eax
80108a85:	78 19                	js     80108aa0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108a87:	83 c3 10             	add    $0x10,%ebx
80108a8a:	81 fb a0 c4 10 80    	cmp    $0x8010c4a0,%ebx
80108a90:	75 d6                	jne    80108a68 <setupkvm+0x28>
}
80108a92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108a95:	89 f0                	mov    %esi,%eax
80108a97:	5b                   	pop    %ebx
80108a98:	5e                   	pop    %esi
80108a99:	5d                   	pop    %ebp
80108a9a:	c3                   	ret    
80108a9b:	90                   	nop
80108a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80108aa0:	83 ec 0c             	sub    $0xc,%esp
80108aa3:	56                   	push   %esi
      return 0;
80108aa4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108aa6:	e8 15 ff ff ff       	call   801089c0 <freevm>
      return 0;
80108aab:	83 c4 10             	add    $0x10,%esp
}
80108aae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108ab1:	89 f0                	mov    %esi,%eax
80108ab3:	5b                   	pop    %ebx
80108ab4:	5e                   	pop    %esi
80108ab5:	5d                   	pop    %ebp
80108ab6:	c3                   	ret    
80108ab7:	89 f6                	mov    %esi,%esi
80108ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108ac0 <kvmalloc>:
{
80108ac0:	55                   	push   %ebp
80108ac1:	89 e5                	mov    %esp,%ebp
80108ac3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108ac6:	e8 75 ff ff ff       	call   80108a40 <setupkvm>
80108acb:	a3 64 e0 15 80       	mov    %eax,0x8015e064
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108ad0:	05 00 00 00 80       	add    $0x80000000,%eax
80108ad5:	0f 22 d8             	mov    %eax,%cr3
}
80108ad8:	c9                   	leave  
80108ad9:	c3                   	ret    
80108ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108ae0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108ae0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108ae1:	31 c9                	xor    %ecx,%ecx
{
80108ae3:	89 e5                	mov    %esp,%ebp
80108ae5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
80108aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80108aee:	e8 bd f8 ff ff       	call   801083b0 <walkpgdir>
  if(pte == 0)
80108af3:	85 c0                	test   %eax,%eax
80108af5:	74 05                	je     80108afc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108af7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80108afa:	c9                   	leave  
80108afb:	c3                   	ret    
    panic("clearpteu");
80108afc:	83 ec 0c             	sub    $0xc,%esp
80108aff:	68 6a 9c 10 80       	push   $0x80109c6a
80108b04:	e8 67 7e ff ff       	call   80100970 <panic>
80108b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108b10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108b10:	55                   	push   %ebp
80108b11:	89 e5                	mov    %esp,%ebp
80108b13:	57                   	push   %edi
80108b14:	56                   	push   %esi
80108b15:	53                   	push   %ebx
80108b16:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108b19:	e8 22 ff ff ff       	call   80108a40 <setupkvm>
80108b1e:	85 c0                	test   %eax,%eax
80108b20:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108b23:	0f 84 a0 00 00 00    	je     80108bc9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108b29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108b2c:	85 c9                	test   %ecx,%ecx
80108b2e:	0f 84 95 00 00 00    	je     80108bc9 <copyuvm+0xb9>
80108b34:	31 f6                	xor    %esi,%esi
80108b36:	eb 4e                	jmp    80108b86 <copyuvm+0x76>
80108b38:	90                   	nop
80108b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108b40:	83 ec 04             	sub    $0x4,%esp
80108b43:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108b49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108b4c:	68 00 10 00 00       	push   $0x1000
80108b51:	57                   	push   %edi
80108b52:	50                   	push   %eax
80108b53:	e8 b8 d0 ff ff       	call   80105c10 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80108b58:	58                   	pop    %eax
80108b59:	5a                   	pop    %edx
80108b5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108b5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108b60:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108b65:	53                   	push   %ebx
80108b66:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108b6c:	52                   	push   %edx
80108b6d:	89 f2                	mov    %esi,%edx
80108b6f:	e8 bc f8 ff ff       	call   80108430 <mappages>
80108b74:	83 c4 10             	add    $0x10,%esp
80108b77:	85 c0                	test   %eax,%eax
80108b79:	78 39                	js     80108bb4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80108b7b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108b81:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108b84:	76 43                	jbe    80108bc9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108b86:	8b 45 08             	mov    0x8(%ebp),%eax
80108b89:	31 c9                	xor    %ecx,%ecx
80108b8b:	89 f2                	mov    %esi,%edx
80108b8d:	e8 1e f8 ff ff       	call   801083b0 <walkpgdir>
80108b92:	85 c0                	test   %eax,%eax
80108b94:	74 3e                	je     80108bd4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80108b96:	8b 18                	mov    (%eax),%ebx
80108b98:	f6 c3 01             	test   $0x1,%bl
80108b9b:	74 44                	je     80108be1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80108b9d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80108b9f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80108ba5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108bab:	e8 60 a3 ff ff       	call   80102f10 <kalloc>
80108bb0:	85 c0                	test   %eax,%eax
80108bb2:	75 8c                	jne    80108b40 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80108bb4:	83 ec 0c             	sub    $0xc,%esp
80108bb7:	ff 75 e0             	pushl  -0x20(%ebp)
80108bba:	e8 01 fe ff ff       	call   801089c0 <freevm>
  return 0;
80108bbf:	83 c4 10             	add    $0x10,%esp
80108bc2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80108bc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108bcf:	5b                   	pop    %ebx
80108bd0:	5e                   	pop    %esi
80108bd1:	5f                   	pop    %edi
80108bd2:	5d                   	pop    %ebp
80108bd3:	c3                   	ret    
      panic("copyuvm: pte should exist");
80108bd4:	83 ec 0c             	sub    $0xc,%esp
80108bd7:	68 74 9c 10 80       	push   $0x80109c74
80108bdc:	e8 8f 7d ff ff       	call   80100970 <panic>
      panic("copyuvm: page not present");
80108be1:	83 ec 0c             	sub    $0xc,%esp
80108be4:	68 8e 9c 10 80       	push   $0x80109c8e
80108be9:	e8 82 7d ff ff       	call   80100970 <panic>
80108bee:	66 90                	xchg   %ax,%ax

80108bf0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108bf0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108bf1:	31 c9                	xor    %ecx,%ecx
{
80108bf3:	89 e5                	mov    %esp,%ebp
80108bf5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
80108bfb:	8b 45 08             	mov    0x8(%ebp),%eax
80108bfe:	e8 ad f7 ff ff       	call   801083b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108c03:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108c05:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108c06:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108c08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108c0d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108c10:	05 00 00 00 80       	add    $0x80000000,%eax
80108c15:	83 fa 05             	cmp    $0x5,%edx
80108c18:	ba 00 00 00 00       	mov    $0x0,%edx
80108c1d:	0f 45 c2             	cmovne %edx,%eax
}
80108c20:	c3                   	ret    
80108c21:	eb 0d                	jmp    80108c30 <copyout>
80108c23:	90                   	nop
80108c24:	90                   	nop
80108c25:	90                   	nop
80108c26:	90                   	nop
80108c27:	90                   	nop
80108c28:	90                   	nop
80108c29:	90                   	nop
80108c2a:	90                   	nop
80108c2b:	90                   	nop
80108c2c:	90                   	nop
80108c2d:	90                   	nop
80108c2e:	90                   	nop
80108c2f:	90                   	nop

80108c30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108c30:	55                   	push   %ebp
80108c31:	89 e5                	mov    %esp,%ebp
80108c33:	57                   	push   %edi
80108c34:	56                   	push   %esi
80108c35:	53                   	push   %ebx
80108c36:	83 ec 1c             	sub    $0x1c,%esp
80108c39:	8b 5d 14             	mov    0x14(%ebp),%ebx
80108c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80108c3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108c42:	85 db                	test   %ebx,%ebx
80108c44:	75 40                	jne    80108c86 <copyout+0x56>
80108c46:	eb 70                	jmp    80108cb8 <copyout+0x88>
80108c48:	90                   	nop
80108c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108c50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108c53:	89 f1                	mov    %esi,%ecx
80108c55:	29 d1                	sub    %edx,%ecx
80108c57:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80108c5d:	39 d9                	cmp    %ebx,%ecx
80108c5f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108c62:	29 f2                	sub    %esi,%edx
80108c64:	83 ec 04             	sub    $0x4,%esp
80108c67:	01 d0                	add    %edx,%eax
80108c69:	51                   	push   %ecx
80108c6a:	57                   	push   %edi
80108c6b:	50                   	push   %eax
80108c6c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108c6f:	e8 9c cf ff ff       	call   80105c10 <memmove>
    len -= n;
    buf += n;
80108c74:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108c77:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80108c7a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108c80:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108c82:	29 cb                	sub    %ecx,%ebx
80108c84:	74 32                	je     80108cb8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108c86:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108c88:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108c8b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108c8e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108c94:	56                   	push   %esi
80108c95:	ff 75 08             	pushl  0x8(%ebp)
80108c98:	e8 53 ff ff ff       	call   80108bf0 <uva2ka>
    if(pa0 == 0)
80108c9d:	83 c4 10             	add    $0x10,%esp
80108ca0:	85 c0                	test   %eax,%eax
80108ca2:	75 ac                	jne    80108c50 <copyout+0x20>
  }
  return 0;
}
80108ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108ca7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108cac:	5b                   	pop    %ebx
80108cad:	5e                   	pop    %esi
80108cae:	5f                   	pop    %edi
80108caf:	5d                   	pop    %ebp
80108cb0:	c3                   	ret    
80108cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108cbb:	31 c0                	xor    %eax,%eax
}
80108cbd:	5b                   	pop    %ebx
80108cbe:	5e                   	pop    %esi
80108cbf:	5f                   	pop    %edi
80108cc0:	5d                   	pop    %ebp
80108cc1:	c3                   	ret    
