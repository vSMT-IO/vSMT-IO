
./nop_unroll:     file format elf64-x86-64


Disassembly of section .init:

0000000000400390 <_init>:
  400390:	48 83 ec 08          	sub    $0x8,%rsp
  400394:	48 8b 05 5d 0c 20 00 	mov    0x200c5d(%rip),%rax        # 600ff8 <_DYNAMIC+0x1d0>
  40039b:	48 85 c0             	test   %rax,%rax
  40039e:	74 05                	je     4003a5 <_init+0x15>
  4003a0:	e8 2b 00 00 00       	callq  4003d0 <__libc_start_main@plt+0x10>
  4003a5:	48 83 c4 08          	add    $0x8,%rsp
  4003a9:	c3                   	retq   

Disassembly of section .plt:

00000000004003b0 <__libc_start_main@plt-0x10>:
  4003b0:	ff 35 52 0c 20 00    	pushq  0x200c52(%rip)        # 601008 <_GLOBAL_OFFSET_TABLE_+0x8>
  4003b6:	ff 25 54 0c 20 00    	jmpq   *0x200c54(%rip)        # 601010 <_GLOBAL_OFFSET_TABLE_+0x10>
  4003bc:	0f 1f 40 00          	nopl   0x0(%rax)

00000000004003c0 <__libc_start_main@plt>:
  4003c0:	ff 25 52 0c 20 00    	jmpq   *0x200c52(%rip)        # 601018 <_GLOBAL_OFFSET_TABLE_+0x18>
  4003c6:	68 00 00 00 00       	pushq  $0x0
  4003cb:	e9 e0 ff ff ff       	jmpq   4003b0 <_init+0x20>

Disassembly of section .plt.got:

00000000004003d0 <.plt.got>:
  4003d0:	ff 25 22 0c 20 00    	jmpq   *0x200c22(%rip)        # 600ff8 <_DYNAMIC+0x1d0>
  4003d6:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

00000000004003e0 <_start>:
  4003e0:	31 ed                	xor    %ebp,%ebp
  4003e2:	49 89 d1             	mov    %rdx,%r9
  4003e5:	5e                   	pop    %rsi
  4003e6:	48 89 e2             	mov    %rsp,%rdx
  4003e9:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  4003ed:	50                   	push   %rax
  4003ee:	54                   	push   %rsp
  4003ef:	49 c7 c0 d0 08 40 00 	mov    $0x4008d0,%r8
  4003f6:	48 c7 c1 60 08 40 00 	mov    $0x400860,%rcx
  4003fd:	48 c7 c7 d6 04 40 00 	mov    $0x4004d6,%rdi
  400404:	e8 b7 ff ff ff       	callq  4003c0 <__libc_start_main@plt>
  400409:	f4                   	hlt    
  40040a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400410 <deregister_tm_clones>:
  400410:	b8 37 10 60 00       	mov    $0x601037,%eax
  400415:	55                   	push   %rbp
  400416:	48 2d 30 10 60 00    	sub    $0x601030,%rax
  40041c:	48 83 f8 0e          	cmp    $0xe,%rax
  400420:	48 89 e5             	mov    %rsp,%rbp
  400423:	76 1b                	jbe    400440 <deregister_tm_clones+0x30>
  400425:	b8 00 00 00 00       	mov    $0x0,%eax
  40042a:	48 85 c0             	test   %rax,%rax
  40042d:	74 11                	je     400440 <deregister_tm_clones+0x30>
  40042f:	5d                   	pop    %rbp
  400430:	bf 30 10 60 00       	mov    $0x601030,%edi
  400435:	ff e0                	jmpq   *%rax
  400437:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  40043e:	00 00 
  400440:	5d                   	pop    %rbp
  400441:	c3                   	retq   
  400442:	0f 1f 40 00          	nopl   0x0(%rax)
  400446:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  40044d:	00 00 00 

0000000000400450 <register_tm_clones>:
  400450:	be 30 10 60 00       	mov    $0x601030,%esi
  400455:	55                   	push   %rbp
  400456:	48 81 ee 30 10 60 00 	sub    $0x601030,%rsi
  40045d:	48 c1 fe 03          	sar    $0x3,%rsi
  400461:	48 89 e5             	mov    %rsp,%rbp
  400464:	48 89 f0             	mov    %rsi,%rax
  400467:	48 c1 e8 3f          	shr    $0x3f,%rax
  40046b:	48 01 c6             	add    %rax,%rsi
  40046e:	48 d1 fe             	sar    %rsi
  400471:	74 15                	je     400488 <register_tm_clones+0x38>
  400473:	b8 00 00 00 00       	mov    $0x0,%eax
  400478:	48 85 c0             	test   %rax,%rax
  40047b:	74 0b                	je     400488 <register_tm_clones+0x38>
  40047d:	5d                   	pop    %rbp
  40047e:	bf 30 10 60 00       	mov    $0x601030,%edi
  400483:	ff e0                	jmpq   *%rax
  400485:	0f 1f 00             	nopl   (%rax)
  400488:	5d                   	pop    %rbp
  400489:	c3                   	retq   
  40048a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400490 <__do_global_dtors_aux>:
  400490:	80 3d 99 0b 20 00 00 	cmpb   $0x0,0x200b99(%rip)        # 601030 <__TMC_END__>
  400497:	75 11                	jne    4004aa <__do_global_dtors_aux+0x1a>
  400499:	55                   	push   %rbp
  40049a:	48 89 e5             	mov    %rsp,%rbp
  40049d:	e8 6e ff ff ff       	callq  400410 <deregister_tm_clones>
  4004a2:	5d                   	pop    %rbp
  4004a3:	c6 05 86 0b 20 00 01 	movb   $0x1,0x200b86(%rip)        # 601030 <__TMC_END__>
  4004aa:	f3 c3                	repz retq 
  4004ac:	0f 1f 40 00          	nopl   0x0(%rax)

00000000004004b0 <frame_dummy>:
  4004b0:	bf 20 0e 60 00       	mov    $0x600e20,%edi
  4004b5:	48 83 3f 00          	cmpq   $0x0,(%rdi)
  4004b9:	75 05                	jne    4004c0 <frame_dummy+0x10>
  4004bb:	eb 93                	jmp    400450 <register_tm_clones>
  4004bd:	0f 1f 00             	nopl   (%rax)
  4004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  4004c5:	48 85 c0             	test   %rax,%rax
  4004c8:	74 f1                	je     4004bb <frame_dummy+0xb>
  4004ca:	55                   	push   %rbp
  4004cb:	48 89 e5             	mov    %rsp,%rbp
  4004ce:	ff d0                	callq  *%rax
  4004d0:	5d                   	pop    %rbp
  4004d1:	e9 7a ff ff ff       	jmpq   400450 <register_tm_clones>

00000000004004d6 <main>:
  4004d6:	55                   	push   %rbp
  4004d7:	48 89 e5             	mov    %rsp,%rbp
  4004da:	90                   	nop
  4004db:	90                   	nop
  4004dc:	90                   	nop
  4004dd:	90                   	nop
  4004de:	90                   	nop
  4004df:	90                   	nop
  4004e0:	90                   	nop
  4004e1:	90                   	nop
  4004e2:	90                   	nop
  4004e3:	90                   	nop
  4004e4:	90                   	nop
  4004e5:	90                   	nop
  4004e6:	90                   	nop
  4004e7:	90                   	nop
  4004e8:	90                   	nop
  4004e9:	90                   	nop
  4004ea:	90                   	nop
  4004eb:	90                   	nop
  4004ec:	90                   	nop
  4004ed:	90                   	nop
  4004ee:	90                   	nop
  4004ef:	90                   	nop
  4004f0:	90                   	nop
  4004f1:	90                   	nop
  4004f2:	90                   	nop
  4004f3:	90                   	nop
  4004f4:	90                   	nop
  4004f5:	90                   	nop
  4004f6:	90                   	nop
  4004f7:	90                   	nop
  4004f8:	90                   	nop
  4004f9:	90                   	nop
  4004fa:	90                   	nop
  4004fb:	90                   	nop
  4004fc:	90                   	nop
  4004fd:	90                   	nop
  4004fe:	90                   	nop
  4004ff:	90                   	nop
  400500:	90                   	nop
  400501:	90                   	nop
  400502:	90                   	nop
  400503:	90                   	nop
  400504:	90                   	nop
  400505:	90                   	nop
  400506:	90                   	nop
  400507:	90                   	nop
  400508:	90                   	nop
  400509:	90                   	nop
  40050a:	90                   	nop
  40050b:	90                   	nop
  40050c:	90                   	nop
  40050d:	90                   	nop
  40050e:	90                   	nop
  40050f:	90                   	nop
  400510:	90                   	nop
  400511:	90                   	nop
  400512:	90                   	nop
  400513:	90                   	nop
  400514:	90                   	nop
  400515:	90                   	nop
  400516:	90                   	nop
  400517:	90                   	nop
  400518:	90                   	nop
  400519:	90                   	nop
  40051a:	90                   	nop
  40051b:	90                   	nop
  40051c:	90                   	nop
  40051d:	90                   	nop
  40051e:	90                   	nop
  40051f:	90                   	nop
  400520:	90                   	nop
  400521:	90                   	nop
  400522:	90                   	nop
  400523:	90                   	nop
  400524:	90                   	nop
  400525:	90                   	nop
  400526:	90                   	nop
  400527:	90                   	nop
  400528:	90                   	nop
  400529:	90                   	nop
  40052a:	90                   	nop
  40052b:	90                   	nop
  40052c:	90                   	nop
  40052d:	90                   	nop
  40052e:	90                   	nop
  40052f:	90                   	nop
  400530:	90                   	nop
  400531:	90                   	nop
  400532:	90                   	nop
  400533:	90                   	nop
  400534:	90                   	nop
  400535:	90                   	nop
  400536:	90                   	nop
  400537:	90                   	nop
  400538:	90                   	nop
  400539:	90                   	nop
  40053a:	90                   	nop
  40053b:	90                   	nop
  40053c:	90                   	nop
  40053d:	90                   	nop
  40053e:	90                   	nop
  40053f:	90                   	nop
  400540:	90                   	nop
  400541:	90                   	nop
  400542:	90                   	nop
  400543:	90                   	nop
  400544:	90                   	nop
  400545:	90                   	nop
  400546:	90                   	nop
  400547:	90                   	nop
  400548:	90                   	nop
  400549:	90                   	nop
  40054a:	90                   	nop
  40054b:	90                   	nop
  40054c:	90                   	nop
  40054d:	90                   	nop
  40054e:	90                   	nop
  40054f:	90                   	nop
  400550:	90                   	nop
  400551:	90                   	nop
  400552:	90                   	nop
  400553:	90                   	nop
  400554:	90                   	nop
  400555:	90                   	nop
  400556:	90                   	nop
  400557:	90                   	nop
  400558:	90                   	nop
  400559:	90                   	nop
  40055a:	90                   	nop
  40055b:	90                   	nop
  40055c:	90                   	nop
  40055d:	90                   	nop
  40055e:	90                   	nop
  40055f:	90                   	nop
  400560:	90                   	nop
  400561:	90                   	nop
  400562:	90                   	nop
  400563:	90                   	nop
  400564:	90                   	nop
  400565:	90                   	nop
  400566:	90                   	nop
  400567:	90                   	nop
  400568:	90                   	nop
  400569:	90                   	nop
  40056a:	90                   	nop
  40056b:	90                   	nop
  40056c:	90                   	nop
  40056d:	90                   	nop
  40056e:	90                   	nop
  40056f:	90                   	nop
  400570:	90                   	nop
  400571:	90                   	nop
  400572:	90                   	nop
  400573:	90                   	nop
  400574:	90                   	nop
  400575:	90                   	nop
  400576:	90                   	nop
  400577:	90                   	nop
  400578:	90                   	nop
  400579:	90                   	nop
  40057a:	90                   	nop
  40057b:	90                   	nop
  40057c:	90                   	nop
  40057d:	90                   	nop
  40057e:	90                   	nop
  40057f:	90                   	nop
  400580:	90                   	nop
  400581:	90                   	nop
  400582:	90                   	nop
  400583:	90                   	nop
  400584:	90                   	nop
  400585:	90                   	nop
  400586:	90                   	nop
  400587:	90                   	nop
  400588:	90                   	nop
  400589:	90                   	nop
  40058a:	90                   	nop
  40058b:	90                   	nop
  40058c:	90                   	nop
  40058d:	90                   	nop
  40058e:	90                   	nop
  40058f:	90                   	nop
  400590:	90                   	nop
  400591:	90                   	nop
  400592:	90                   	nop
  400593:	90                   	nop
  400594:	90                   	nop
  400595:	90                   	nop
  400596:	90                   	nop
  400597:	90                   	nop
  400598:	90                   	nop
  400599:	90                   	nop
  40059a:	90                   	nop
  40059b:	90                   	nop
  40059c:	90                   	nop
  40059d:	90                   	nop
  40059e:	90                   	nop
  40059f:	90                   	nop
  4005a0:	90                   	nop
  4005a1:	90                   	nop
  4005a2:	90                   	nop
  4005a3:	90                   	nop
  4005a4:	90                   	nop
  4005a5:	90                   	nop
  4005a6:	90                   	nop
  4005a7:	90                   	nop
  4005a8:	90                   	nop
  4005a9:	90                   	nop
  4005aa:	90                   	nop
  4005ab:	90                   	nop
  4005ac:	90                   	nop
  4005ad:	90                   	nop
  4005ae:	90                   	nop
  4005af:	90                   	nop
  4005b0:	90                   	nop
  4005b1:	90                   	nop
  4005b2:	90                   	nop
  4005b3:	90                   	nop
  4005b4:	90                   	nop
  4005b5:	90                   	nop
  4005b6:	90                   	nop
  4005b7:	90                   	nop
  4005b8:	90                   	nop
  4005b9:	90                   	nop
  4005ba:	90                   	nop
  4005bb:	90                   	nop
  4005bc:	90                   	nop
  4005bd:	90                   	nop
  4005be:	90                   	nop
  4005bf:	90                   	nop
  4005c0:	90                   	nop
  4005c1:	90                   	nop
  4005c2:	90                   	nop
  4005c3:	90                   	nop
  4005c4:	90                   	nop
  4005c5:	90                   	nop
  4005c6:	90                   	nop
  4005c7:	90                   	nop
  4005c8:	90                   	nop
  4005c9:	90                   	nop
  4005ca:	90                   	nop
  4005cb:	90                   	nop
  4005cc:	90                   	nop
  4005cd:	90                   	nop
  4005ce:	90                   	nop
  4005cf:	90                   	nop
  4005d0:	90                   	nop
  4005d1:	90                   	nop
  4005d2:	90                   	nop
  4005d3:	90                   	nop
  4005d4:	90                   	nop
  4005d5:	90                   	nop
  4005d6:	90                   	nop
  4005d7:	90                   	nop
  4005d8:	90                   	nop
  4005d9:	90                   	nop
  4005da:	90                   	nop
  4005db:	90                   	nop
  4005dc:	90                   	nop
  4005dd:	90                   	nop
  4005de:	90                   	nop
  4005df:	90                   	nop
  4005e0:	90                   	nop
  4005e1:	90                   	nop
  4005e2:	90                   	nop
  4005e3:	90                   	nop
  4005e4:	90                   	nop
  4005e5:	90                   	nop
  4005e6:	90                   	nop
  4005e7:	90                   	nop
  4005e8:	90                   	nop
  4005e9:	90                   	nop
  4005ea:	90                   	nop
  4005eb:	90                   	nop
  4005ec:	90                   	nop
  4005ed:	90                   	nop
  4005ee:	90                   	nop
  4005ef:	90                   	nop
  4005f0:	90                   	nop
  4005f1:	90                   	nop
  4005f2:	90                   	nop
  4005f3:	90                   	nop
  4005f4:	90                   	nop
  4005f5:	90                   	nop
  4005f6:	90                   	nop
  4005f7:	90                   	nop
  4005f8:	90                   	nop
  4005f9:	90                   	nop
  4005fa:	90                   	nop
  4005fb:	90                   	nop
  4005fc:	90                   	nop
  4005fd:	90                   	nop
  4005fe:	90                   	nop
  4005ff:	90                   	nop
  400600:	90                   	nop
  400601:	90                   	nop
  400602:	90                   	nop
  400603:	90                   	nop
  400604:	90                   	nop
  400605:	90                   	nop
  400606:	90                   	nop
  400607:	90                   	nop
  400608:	90                   	nop
  400609:	90                   	nop
  40060a:	90                   	nop
  40060b:	90                   	nop
  40060c:	90                   	nop
  40060d:	90                   	nop
  40060e:	90                   	nop
  40060f:	90                   	nop
  400610:	90                   	nop
  400611:	90                   	nop
  400612:	90                   	nop
  400613:	90                   	nop
  400614:	90                   	nop
  400615:	90                   	nop
  400616:	90                   	nop
  400617:	90                   	nop
  400618:	90                   	nop
  400619:	90                   	nop
  40061a:	90                   	nop
  40061b:	90                   	nop
  40061c:	90                   	nop
  40061d:	90                   	nop
  40061e:	90                   	nop
  40061f:	90                   	nop
  400620:	90                   	nop
  400621:	90                   	nop
  400622:	90                   	nop
  400623:	90                   	nop
  400624:	90                   	nop
  400625:	90                   	nop
  400626:	90                   	nop
  400627:	90                   	nop
  400628:	90                   	nop
  400629:	90                   	nop
  40062a:	90                   	nop
  40062b:	90                   	nop
  40062c:	90                   	nop
  40062d:	90                   	nop
  40062e:	90                   	nop
  40062f:	90                   	nop
  400630:	90                   	nop
  400631:	90                   	nop
  400632:	90                   	nop
  400633:	90                   	nop
  400634:	90                   	nop
  400635:	90                   	nop
  400636:	90                   	nop
  400637:	90                   	nop
  400638:	90                   	nop
  400639:	90                   	nop
  40063a:	90                   	nop
  40063b:	90                   	nop
  40063c:	90                   	nop
  40063d:	90                   	nop
  40063e:	90                   	nop
  40063f:	90                   	nop
  400640:	90                   	nop
  400641:	90                   	nop
  400642:	90                   	nop
  400643:	90                   	nop
  400644:	90                   	nop
  400645:	90                   	nop
  400646:	90                   	nop
  400647:	90                   	nop
  400648:	90                   	nop
  400649:	90                   	nop
  40064a:	90                   	nop
  40064b:	90                   	nop
  40064c:	90                   	nop
  40064d:	90                   	nop
  40064e:	90                   	nop
  40064f:	90                   	nop
  400650:	90                   	nop
  400651:	90                   	nop
  400652:	90                   	nop
  400653:	90                   	nop
  400654:	90                   	nop
  400655:	90                   	nop
  400656:	90                   	nop
  400657:	90                   	nop
  400658:	90                   	nop
  400659:	90                   	nop
  40065a:	90                   	nop
  40065b:	90                   	nop
  40065c:	90                   	nop
  40065d:	90                   	nop
  40065e:	90                   	nop
  40065f:	90                   	nop
  400660:	90                   	nop
  400661:	90                   	nop
  400662:	90                   	nop
  400663:	90                   	nop
  400664:	90                   	nop
  400665:	90                   	nop
  400666:	90                   	nop
  400667:	90                   	nop
  400668:	90                   	nop
  400669:	90                   	nop
  40066a:	90                   	nop
  40066b:	90                   	nop
  40066c:	90                   	nop
  40066d:	90                   	nop
  40066e:	90                   	nop
  40066f:	90                   	nop
  400670:	90                   	nop
  400671:	90                   	nop
  400672:	90                   	nop
  400673:	90                   	nop
  400674:	90                   	nop
  400675:	90                   	nop
  400676:	90                   	nop
  400677:	90                   	nop
  400678:	90                   	nop
  400679:	90                   	nop
  40067a:	90                   	nop
  40067b:	90                   	nop
  40067c:	90                   	nop
  40067d:	90                   	nop
  40067e:	90                   	nop
  40067f:	90                   	nop
  400680:	90                   	nop
  400681:	90                   	nop
  400682:	90                   	nop
  400683:	90                   	nop
  400684:	90                   	nop
  400685:	90                   	nop
  400686:	90                   	nop
  400687:	90                   	nop
  400688:	90                   	nop
  400689:	90                   	nop
  40068a:	90                   	nop
  40068b:	90                   	nop
  40068c:	90                   	nop
  40068d:	90                   	nop
  40068e:	90                   	nop
  40068f:	90                   	nop
  400690:	90                   	nop
  400691:	90                   	nop
  400692:	90                   	nop
  400693:	90                   	nop
  400694:	90                   	nop
  400695:	90                   	nop
  400696:	90                   	nop
  400697:	90                   	nop
  400698:	90                   	nop
  400699:	90                   	nop
  40069a:	90                   	nop
  40069b:	90                   	nop
  40069c:	90                   	nop
  40069d:	90                   	nop
  40069e:	90                   	nop
  40069f:	90                   	nop
  4006a0:	90                   	nop
  4006a1:	90                   	nop
  4006a2:	90                   	nop
  4006a3:	90                   	nop
  4006a4:	90                   	nop
  4006a5:	90                   	nop
  4006a6:	90                   	nop
  4006a7:	90                   	nop
  4006a8:	90                   	nop
  4006a9:	90                   	nop
  4006aa:	90                   	nop
  4006ab:	90                   	nop
  4006ac:	90                   	nop
  4006ad:	90                   	nop
  4006ae:	90                   	nop
  4006af:	90                   	nop
  4006b0:	90                   	nop
  4006b1:	90                   	nop
  4006b2:	90                   	nop
  4006b3:	90                   	nop
  4006b4:	90                   	nop
  4006b5:	90                   	nop
  4006b6:	90                   	nop
  4006b7:	90                   	nop
  4006b8:	90                   	nop
  4006b9:	90                   	nop
  4006ba:	90                   	nop
  4006bb:	90                   	nop
  4006bc:	90                   	nop
  4006bd:	90                   	nop
  4006be:	90                   	nop
  4006bf:	90                   	nop
  4006c0:	90                   	nop
  4006c1:	90                   	nop
  4006c2:	90                   	nop
  4006c3:	90                   	nop
  4006c4:	90                   	nop
  4006c5:	90                   	nop
  4006c6:	90                   	nop
  4006c7:	90                   	nop
  4006c8:	90                   	nop
  4006c9:	90                   	nop
  4006ca:	90                   	nop
  4006cb:	90                   	nop
  4006cc:	90                   	nop
  4006cd:	90                   	nop
  4006ce:	90                   	nop
  4006cf:	90                   	nop
  4006d0:	90                   	nop
  4006d1:	90                   	nop
  4006d2:	90                   	nop
  4006d3:	90                   	nop
  4006d4:	90                   	nop
  4006d5:	90                   	nop
  4006d6:	90                   	nop
  4006d7:	90                   	nop
  4006d8:	90                   	nop
  4006d9:	90                   	nop
  4006da:	90                   	nop
  4006db:	90                   	nop
  4006dc:	90                   	nop
  4006dd:	90                   	nop
  4006de:	90                   	nop
  4006df:	90                   	nop
  4006e0:	90                   	nop
  4006e1:	90                   	nop
  4006e2:	90                   	nop
  4006e3:	90                   	nop
  4006e4:	90                   	nop
  4006e5:	90                   	nop
  4006e6:	90                   	nop
  4006e7:	90                   	nop
  4006e8:	90                   	nop
  4006e9:	90                   	nop
  4006ea:	90                   	nop
  4006eb:	90                   	nop
  4006ec:	90                   	nop
  4006ed:	90                   	nop
  4006ee:	90                   	nop
  4006ef:	90                   	nop
  4006f0:	90                   	nop
  4006f1:	90                   	nop
  4006f2:	90                   	nop
  4006f3:	90                   	nop
  4006f4:	90                   	nop
  4006f5:	90                   	nop
  4006f6:	90                   	nop
  4006f7:	90                   	nop
  4006f8:	90                   	nop
  4006f9:	90                   	nop
  4006fa:	90                   	nop
  4006fb:	90                   	nop
  4006fc:	90                   	nop
  4006fd:	90                   	nop
  4006fe:	90                   	nop
  4006ff:	90                   	nop
  400700:	90                   	nop
  400701:	90                   	nop
  400702:	90                   	nop
  400703:	90                   	nop
  400704:	90                   	nop
  400705:	90                   	nop
  400706:	90                   	nop
  400707:	90                   	nop
  400708:	90                   	nop
  400709:	90                   	nop
  40070a:	90                   	nop
  40070b:	90                   	nop
  40070c:	90                   	nop
  40070d:	90                   	nop
  40070e:	90                   	nop
  40070f:	90                   	nop
  400710:	90                   	nop
  400711:	90                   	nop
  400712:	90                   	nop
  400713:	90                   	nop
  400714:	90                   	nop
  400715:	90                   	nop
  400716:	90                   	nop
  400717:	90                   	nop
  400718:	90                   	nop
  400719:	90                   	nop
  40071a:	90                   	nop
  40071b:	90                   	nop
  40071c:	90                   	nop
  40071d:	90                   	nop
  40071e:	90                   	nop
  40071f:	90                   	nop
  400720:	90                   	nop
  400721:	90                   	nop
  400722:	90                   	nop
  400723:	90                   	nop
  400724:	90                   	nop
  400725:	90                   	nop
  400726:	90                   	nop
  400727:	90                   	nop
  400728:	90                   	nop
  400729:	90                   	nop
  40072a:	90                   	nop
  40072b:	90                   	nop
  40072c:	90                   	nop
  40072d:	90                   	nop
  40072e:	90                   	nop
  40072f:	90                   	nop
  400730:	90                   	nop
  400731:	90                   	nop
  400732:	90                   	nop
  400733:	90                   	nop
  400734:	90                   	nop
  400735:	90                   	nop
  400736:	90                   	nop
  400737:	90                   	nop
  400738:	90                   	nop
  400739:	90                   	nop
  40073a:	90                   	nop
  40073b:	90                   	nop
  40073c:	90                   	nop
  40073d:	90                   	nop
  40073e:	90                   	nop
  40073f:	90                   	nop
  400740:	90                   	nop
  400741:	90                   	nop
  400742:	90                   	nop
  400743:	90                   	nop
  400744:	90                   	nop
  400745:	90                   	nop
  400746:	90                   	nop
  400747:	90                   	nop
  400748:	90                   	nop
  400749:	90                   	nop
  40074a:	90                   	nop
  40074b:	90                   	nop
  40074c:	90                   	nop
  40074d:	90                   	nop
  40074e:	90                   	nop
  40074f:	90                   	nop
  400750:	90                   	nop
  400751:	90                   	nop
  400752:	90                   	nop
  400753:	90                   	nop
  400754:	90                   	nop
  400755:	90                   	nop
  400756:	90                   	nop
  400757:	90                   	nop
  400758:	90                   	nop
  400759:	90                   	nop
  40075a:	90                   	nop
  40075b:	90                   	nop
  40075c:	90                   	nop
  40075d:	90                   	nop
  40075e:	90                   	nop
  40075f:	90                   	nop
  400760:	90                   	nop
  400761:	90                   	nop
  400762:	90                   	nop
  400763:	90                   	nop
  400764:	90                   	nop
  400765:	90                   	nop
  400766:	90                   	nop
  400767:	90                   	nop
  400768:	90                   	nop
  400769:	90                   	nop
  40076a:	90                   	nop
  40076b:	90                   	nop
  40076c:	90                   	nop
  40076d:	90                   	nop
  40076e:	90                   	nop
  40076f:	90                   	nop
  400770:	90                   	nop
  400771:	90                   	nop
  400772:	90                   	nop
  400773:	90                   	nop
  400774:	90                   	nop
  400775:	90                   	nop
  400776:	90                   	nop
  400777:	90                   	nop
  400778:	90                   	nop
  400779:	90                   	nop
  40077a:	90                   	nop
  40077b:	90                   	nop
  40077c:	90                   	nop
  40077d:	90                   	nop
  40077e:	90                   	nop
  40077f:	90                   	nop
  400780:	90                   	nop
  400781:	90                   	nop
  400782:	90                   	nop
  400783:	90                   	nop
  400784:	90                   	nop
  400785:	90                   	nop
  400786:	90                   	nop
  400787:	90                   	nop
  400788:	90                   	nop
  400789:	90                   	nop
  40078a:	90                   	nop
  40078b:	90                   	nop
  40078c:	90                   	nop
  40078d:	90                   	nop
  40078e:	90                   	nop
  40078f:	90                   	nop
  400790:	90                   	nop
  400791:	90                   	nop
  400792:	90                   	nop
  400793:	90                   	nop
  400794:	90                   	nop
  400795:	90                   	nop
  400796:	90                   	nop
  400797:	90                   	nop
  400798:	90                   	nop
  400799:	90                   	nop
  40079a:	90                   	nop
  40079b:	90                   	nop
  40079c:	90                   	nop
  40079d:	90                   	nop
  40079e:	90                   	nop
  40079f:	90                   	nop
  4007a0:	90                   	nop
  4007a1:	90                   	nop
  4007a2:	90                   	nop
  4007a3:	90                   	nop
  4007a4:	90                   	nop
  4007a5:	90                   	nop
  4007a6:	90                   	nop
  4007a7:	90                   	nop
  4007a8:	90                   	nop
  4007a9:	90                   	nop
  4007aa:	90                   	nop
  4007ab:	90                   	nop
  4007ac:	90                   	nop
  4007ad:	90                   	nop
  4007ae:	90                   	nop
  4007af:	90                   	nop
  4007b0:	90                   	nop
  4007b1:	90                   	nop
  4007b2:	90                   	nop
  4007b3:	90                   	nop
  4007b4:	90                   	nop
  4007b5:	90                   	nop
  4007b6:	90                   	nop
  4007b7:	90                   	nop
  4007b8:	90                   	nop
  4007b9:	90                   	nop
  4007ba:	90                   	nop
  4007bb:	90                   	nop
  4007bc:	90                   	nop
  4007bd:	90                   	nop
  4007be:	90                   	nop
  4007bf:	90                   	nop
  4007c0:	90                   	nop
  4007c1:	90                   	nop
  4007c2:	90                   	nop
  4007c3:	90                   	nop
  4007c4:	90                   	nop
  4007c5:	90                   	nop
  4007c6:	90                   	nop
  4007c7:	90                   	nop
  4007c8:	90                   	nop
  4007c9:	90                   	nop
  4007ca:	90                   	nop
  4007cb:	90                   	nop
  4007cc:	90                   	nop
  4007cd:	90                   	nop
  4007ce:	90                   	nop
  4007cf:	90                   	nop
  4007d0:	90                   	nop
  4007d1:	90                   	nop
  4007d2:	90                   	nop
  4007d3:	90                   	nop
  4007d4:	90                   	nop
  4007d5:	90                   	nop
  4007d6:	90                   	nop
  4007d7:	90                   	nop
  4007d8:	90                   	nop
  4007d9:	90                   	nop
  4007da:	90                   	nop
  4007db:	90                   	nop
  4007dc:	90                   	nop
  4007dd:	90                   	nop
  4007de:	90                   	nop
  4007df:	90                   	nop
  4007e0:	90                   	nop
  4007e1:	90                   	nop
  4007e2:	90                   	nop
  4007e3:	90                   	nop
  4007e4:	90                   	nop
  4007e5:	90                   	nop
  4007e6:	90                   	nop
  4007e7:	90                   	nop
  4007e8:	90                   	nop
  4007e9:	90                   	nop
  4007ea:	90                   	nop
  4007eb:	90                   	nop
  4007ec:	90                   	nop
  4007ed:	90                   	nop
  4007ee:	90                   	nop
  4007ef:	90                   	nop
  4007f0:	90                   	nop
  4007f1:	90                   	nop
  4007f2:	90                   	nop
  4007f3:	90                   	nop
  4007f4:	90                   	nop
  4007f5:	90                   	nop
  4007f6:	90                   	nop
  4007f7:	90                   	nop
  4007f8:	90                   	nop
  4007f9:	90                   	nop
  4007fa:	90                   	nop
  4007fb:	90                   	nop
  4007fc:	90                   	nop
  4007fd:	90                   	nop
  4007fe:	90                   	nop
  4007ff:	90                   	nop
  400800:	90                   	nop
  400801:	90                   	nop
  400802:	90                   	nop
  400803:	90                   	nop
  400804:	90                   	nop
  400805:	90                   	nop
  400806:	90                   	nop
  400807:	90                   	nop
  400808:	90                   	nop
  400809:	90                   	nop
  40080a:	90                   	nop
  40080b:	90                   	nop
  40080c:	90                   	nop
  40080d:	90                   	nop
  40080e:	90                   	nop
  40080f:	90                   	nop
  400810:	90                   	nop
  400811:	90                   	nop
  400812:	90                   	nop
  400813:	90                   	nop
  400814:	90                   	nop
  400815:	90                   	nop
  400816:	90                   	nop
  400817:	90                   	nop
  400818:	90                   	nop
  400819:	90                   	nop
  40081a:	90                   	nop
  40081b:	90                   	nop
  40081c:	90                   	nop
  40081d:	90                   	nop
  40081e:	90                   	nop
  40081f:	90                   	nop
  400820:	90                   	nop
  400821:	90                   	nop
  400822:	90                   	nop
  400823:	90                   	nop
  400824:	90                   	nop
  400825:	90                   	nop
  400826:	90                   	nop
  400827:	90                   	nop
  400828:	90                   	nop
  400829:	90                   	nop
  40082a:	90                   	nop
  40082b:	90                   	nop
  40082c:	90                   	nop
  40082d:	90                   	nop
  40082e:	90                   	nop
  40082f:	90                   	nop
  400830:	90                   	nop
  400831:	90                   	nop
  400832:	90                   	nop
  400833:	90                   	nop
  400834:	90                   	nop
  400835:	90                   	nop
  400836:	90                   	nop
  400837:	90                   	nop
  400838:	90                   	nop
  400839:	90                   	nop
  40083a:	90                   	nop
  40083b:	90                   	nop
  40083c:	90                   	nop
  40083d:	90                   	nop
  40083e:	90                   	nop
  40083f:	90                   	nop
  400840:	90                   	nop
  400841:	90                   	nop
  400842:	90                   	nop
  400843:	90                   	nop
  400844:	90                   	nop
  400845:	90                   	nop
  400846:	90                   	nop
  400847:	90                   	nop
  400848:	90                   	nop
  400849:	90                   	nop
  40084a:	90                   	nop
  40084b:	90                   	nop
  40084c:	90                   	nop
  40084d:	90                   	nop
  40084e:	90                   	nop
  40084f:	90                   	nop
  400850:	90                   	nop
  400851:	90                   	nop
  400852:	e9 83 fc ff ff       	jmpq   4004da <main+0x4>
  400857:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  40085e:	00 00 

0000000000400860 <__libc_csu_init>:
  400860:	41 57                	push   %r15
  400862:	41 56                	push   %r14
  400864:	41 89 ff             	mov    %edi,%r15d
  400867:	41 55                	push   %r13
  400869:	41 54                	push   %r12
  40086b:	4c 8d 25 9e 05 20 00 	lea    0x20059e(%rip),%r12        # 600e10 <__frame_dummy_init_array_entry>
  400872:	55                   	push   %rbp
  400873:	48 8d 2d 9e 05 20 00 	lea    0x20059e(%rip),%rbp        # 600e18 <__init_array_end>
  40087a:	53                   	push   %rbx
  40087b:	49 89 f6             	mov    %rsi,%r14
  40087e:	49 89 d5             	mov    %rdx,%r13
  400881:	4c 29 e5             	sub    %r12,%rbp
  400884:	48 83 ec 08          	sub    $0x8,%rsp
  400888:	48 c1 fd 03          	sar    $0x3,%rbp
  40088c:	e8 ff fa ff ff       	callq  400390 <_init>
  400891:	48 85 ed             	test   %rbp,%rbp
  400894:	74 20                	je     4008b6 <__libc_csu_init+0x56>
  400896:	31 db                	xor    %ebx,%ebx
  400898:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  40089f:	00 
  4008a0:	4c 89 ea             	mov    %r13,%rdx
  4008a3:	4c 89 f6             	mov    %r14,%rsi
  4008a6:	44 89 ff             	mov    %r15d,%edi
  4008a9:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
  4008ad:	48 83 c3 01          	add    $0x1,%rbx
  4008b1:	48 39 eb             	cmp    %rbp,%rbx
  4008b4:	75 ea                	jne    4008a0 <__libc_csu_init+0x40>
  4008b6:	48 83 c4 08          	add    $0x8,%rsp
  4008ba:	5b                   	pop    %rbx
  4008bb:	5d                   	pop    %rbp
  4008bc:	41 5c                	pop    %r12
  4008be:	41 5d                	pop    %r13
  4008c0:	41 5e                	pop    %r14
  4008c2:	41 5f                	pop    %r15
  4008c4:	c3                   	retq   
  4008c5:	90                   	nop
  4008c6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  4008cd:	00 00 00 

00000000004008d0 <__libc_csu_fini>:
  4008d0:	f3 c3                	repz retq 

Disassembly of section .fini:

00000000004008d4 <_fini>:
  4008d4:	48 83 ec 08          	sub    $0x8,%rsp
  4008d8:	48 83 c4 08          	add    $0x8,%rsp
  4008dc:	c3                   	retq   
