Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7671442927F
	for <lists+kvm-ppc@lfdr.de>; Mon, 11 Oct 2021 16:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbhJKOuA (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 11 Oct 2021 10:50:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237241AbhJKOt7 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 11 Oct 2021 10:49:59 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BEgqa3020455;
        Mon, 11 Oct 2021 10:47:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=v0EqP+xBLbJ4ic9PfV8gluyoQ5BMUB+9BNf7dkKUwx8=;
 b=khkkjSPc34MRxchI+neUm+Q20mZFy3ETtbxSn5C0gcJPxsp6yJvO+Ms/NawD0HAPJ8y0
 o5aX5MAzhqaG52/ZuY2ORJUavQKD9hFmKWIAV/tPAODmgyYdvLXX4RMIqfIF/7pIGYNM
 0XVQ/4ITdO45qlOmQE9DinaZYF8zHBKBAr4P/CnNmPWP0NAZVwZgZsIZfHxhcneR1h7Y
 SV5dbywBNSHeTjZ+Z5J5Gtf4lvWXCvXgDEip8GKnpG3izxdJONOfxYMrgbJJBiSIiXcW
 VNrXoFsTN/0khZzQ2Huz9ahM5YgpCBvcYoCz4UK/qe8DAXXVmLEZHFMzQLfB9CabBJkK Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bmj9s7dk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 10:47:51 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19BEhijJ022997;
        Mon, 11 Oct 2021 10:47:51 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bmj9s7dk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 10:47:51 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19BEadCe028681;
        Mon, 11 Oct 2021 14:47:50 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3bk2qaxbpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 14:47:50 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19BElnTW40108382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 14:47:49 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51D44AE060;
        Mon, 11 Oct 2021 14:47:49 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76973AE063;
        Mon, 11 Oct 2021 14:47:48 +0000 (GMT)
Received: from localhost (unknown [9.211.66.33])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 11 Oct 2021 14:47:48 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: H_ENTER filter out reserved
 HPTE[B] value
In-Reply-To: <20211004145749.1331331-1-npiggin@gmail.com>
References: <20211004145749.1331331-1-npiggin@gmail.com>
Date:   Mon, 11 Oct 2021 11:47:45 -0300
Message-ID: <87y26z62jy.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V-Gd8qqZZQdC9RejtOYSCc4AvhYwyerZ
X-Proofpoint-ORIG-GUID: A0yAopPCMXp9vxOaLuEhRoTpVeItMLeU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-11_05,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 clxscore=1011 mlxscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110085
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> The HPTE B field is a 2-bit field with values 0b10 and 0b11 reserved.
> This field is also taken from the HPTE and used when KVM executes
> TLBIEs to set the B field of those instructions.
>
> Disallow the guest setting B to a reserved value with H_ENTER by
> rejecting it. This is the same approach already taken for rejecting
> reserved (unsupported) LLP values. This prevents the guest from being
> able to induce the host to execute TLBIE with reserved values, which
> is not known to be a problem with current processors but in theory it
> could prevent the TLBIE from working correctly in a future processor.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

The ISA says:

B Segment Size Selector
0b00 - 256 MB (s=28)
0b01 - 1 TB (s=40)
0b10 - reserved
0b11 - reserved

So that looks good. I couldn't find any other guest initiated PTE
modifications, so I think we're covered.

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/include/asm/kvm_book3s_64.h | 4 ++++
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c      | 9 +++++++++
>  2 files changed, 13 insertions(+)
>
> diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
> index 19b6942c6969..fff391b9b97b 100644
> --- a/arch/powerpc/include/asm/kvm_book3s_64.h
> +++ b/arch/powerpc/include/asm/kvm_book3s_64.h
> @@ -378,6 +378,10 @@ static inline unsigned long compute_tlbie_rb(unsigned long v, unsigned long r,
>  		rb |= 1;		/* L field */
>  		rb |= r & 0xff000 & ((1ul << a_pgshift) - 1); /* LP field */
>  	}
> +	/*
> +	 * This sets both bits of the B field in the PTE. 0b1x values are
> +	 * reserved, but those will have been filtered by kvmppc_do_h_enter.
> +	 */
>  	rb |= (v >> HPTE_V_SSIZE_SHIFT) << 8;	/* B field */
>  	return rb;
>  }
> diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> index 632b2545072b..2c1f3c6e72d1 100644
> --- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> +++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
> @@ -207,6 +207,15 @@ long kvmppc_do_h_enter(struct kvm *kvm, unsigned long flags,
>
>  	if (kvm_is_radix(kvm))
>  		return H_FUNCTION;
> +	/*
> +	 * The HPTE gets used by compute_tlbie_rb() to set TLBIE bits, so
> +	 * these functions should work together -- must ensure a guest can not
> +	 * cause problems with the TLBIE that KVM executes.
> +	 */
> +	if ((pteh >> HPTE_V_SSIZE_SHIFT) & 0x2) {
> +		/* B=0b1x is a reserved value, disallow it. */
> +		return H_PARAMETER;
> +	}
>  	psize = kvmppc_actual_pgsz(pteh, ptel);
>  	if (!psize)
>  		return H_PARAMETER;
