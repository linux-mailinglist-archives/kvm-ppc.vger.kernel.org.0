Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AF8CEF90
	for <lists+kvm-ppc@lfdr.de>; Tue,  8 Oct 2019 01:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbfJGXZm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 7 Oct 2019 19:25:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729252AbfJGXZl (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 7 Oct 2019 19:25:41 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x97NLxWr191809
        for <kvm-ppc@vger.kernel.org>; Mon, 7 Oct 2019 19:25:40 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vgc9sn2d4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Mon, 07 Oct 2019 19:25:39 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <alistair@popple.id.au>;
        Tue, 8 Oct 2019 00:25:38 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 8 Oct 2019 00:25:34 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x97NPXHS12189904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Oct 2019 23:25:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ED73A405B;
        Mon,  7 Oct 2019 23:25:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0EC2A405C;
        Mon,  7 Oct 2019 23:25:32 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Oct 2019 23:25:32 +0000 (GMT)
Received: from townsend.localnet (unknown [9.102.60.224])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id EF62DA01E3;
        Tue,  8 Oct 2019 10:25:30 +1100 (AEDT)
From:   Alistair Popple <alistair@popple.id.au>
To:     Jordan Niethe <jniethe5@gmail.com>
Cc:     linuxppc-dev@lists.ozlabs.org, patch-notifications@ellerman.id.au,
        paulus@ozlabs.org, kvm-ppc@vger.kernel.org, aik@ozlabs.ru
Subject: Re: [PATCH] powerpc/kvm: Fix kvmppc_vcore->in_guest value in kvmhv_switch_to_host
Date:   Tue, 08 Oct 2019 10:25:30 +1100
In-Reply-To: <20191004025317.19340-1-jniethe5@gmail.com>
References: <20191004025317.19340-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 19100723-0016-0000-0000-000002B4F962
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100723-0017-0000-0000-0000331612F8
Message-Id: <3982154.yavEZ9r0OR@townsend>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-07_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=44 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910070209
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Friday, 4 October 2019 12:53:17 PM AEDT Jordan Niethe wrote:
> kvmhv_switch_to_host() in arch/powerpc/kvm/book3s_hv_rmhandlers.S needs
> to set kvmppc_vcore->in_guest to 0 to signal secondary CPUs to continue.
> This happens after resetting the PCR. Before commit 13c7bb3c57dc
> ("powerpc/64s: Set reserved PCR bits"), r0 would always be 0 before it
> was stored to kvmppc_vcore->in_guest. However because of this change in
> the commit:
> 
>         /* Reset PCR */
>         ld      r0, VCORE_PCR(r5)
> -       cmpdi   r0, 0
> +       LOAD_REG_IMMEDIATE(r6, PCR_MASK)
> +       cmpld   r0, r6
>         beq     18f
> -       li      r0, 0
> -       mtspr   SPRN_PCR, r0
> +       mtspr   SPRN_PCR, r6
>  18:
>         /* Signal secondary CPUs to continue */
>         stb     r0,VCORE_IN_GUEST(r5)

Easy to understand how that was missed :-)

Reviewed-by: Alistair Popple <alistair@popple.id.au>

> We are no longer comparing r0 against 0 and loading it with 0 if it
> contains something else. Hence when we store r0 to
> kvmppc_vcore->in_guest, it might not be 0.  This means that secondary
> CPUs will not be signalled to continue. Those CPUs get stuck and errors
> like the following are logged:
> 
>     KVM: CPU 1 seems to be stuck
>     KVM: CPU 2 seems to be stuck
>     KVM: CPU 3 seems to be stuck
>     KVM: CPU 4 seems to be stuck
>     KVM: CPU 5 seems to be stuck
>     KVM: CPU 6 seems to be stuck
>     KVM: CPU 7 seems to be stuck
> 
> This can be reproduced with:
>     $ for i in `seq 1 7` ; do chcpu -d $i ; done ;
>     $ taskset -c 0 qemu-system-ppc64 -smp 8,threads=8 \
>        -M pseries,accel=kvm,kvm-type=HV -m 1G -nographic -vga none \
>        -kernel vmlinux -initrd initrd.cpio.xz
> 
> Fix by making sure r0 is 0 before storing it to kvmppc_vcore->in_guest.
> 
> Fixes: 13c7bb3c57dc ("powerpc/64s: Set reserved PCR bits")
> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index 74a9cfe84aee..faebcbb8c4db 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -1921,6 +1921,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
>  	mtspr	SPRN_PCR, r6
>  18:
>  	/* Signal secondary CPUs to continue */
> +	li	r0, 0
>  	stb	r0,VCORE_IN_GUEST(r5)
>  19:	lis	r8,0x7fff		/* MAX_INT@h */
>  	mtspr	SPRN_HDEC,r8
> 




