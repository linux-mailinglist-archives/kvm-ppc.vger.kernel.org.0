Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA08232221F
	for <lists+kvm-ppc@lfdr.de>; Mon, 22 Feb 2021 23:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhBVWYI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 22 Feb 2021 17:24:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25088 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229518AbhBVWYI (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 22 Feb 2021 17:24:08 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11MMK8Oo110640;
        Mon, 22 Feb 2021 17:23:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=UmvtzvfxROJDiscc8m5MKltOL6plKqCJi88n/9n74og=;
 b=iYab1XVVL7eOKV+4CI/Kk+T9SHbQ1l4S7c1pIOMvvsEodWyagqrPi/PhzTuGyNDvvAh6
 pDStjMaPzqyvHjpIyyVjWZHbgcLglMQqQ94XWNKERf0qLZqMkNK19hxljWlVcr+AQ3pS
 oJyD7rTwtUOwt4h/0EwjgEY4Fy3pJ9Q7dy5yrocyji6W787K8T2mulEneKjkwDwdn4aZ
 qB5/mirv/jMcFS2oq5VQyFELRdMcvBNJ8xvRcNTMjZKHRyr3t8/G+WP26+SgE2q+4GMT
 7kvyU9vFd32m35W3/PHm20a0R78sSb1uoOUuAyhUEgZRk8o2sTQgEoSA+utHjif22d0V jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkg03wj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 17:23:24 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11MMN4sQ125434;
        Mon, 22 Feb 2021 17:23:23 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkg03whu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 17:23:23 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11MMLmW7023049;
        Mon, 22 Feb 2021 22:23:23 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 36tt28t83v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 22:23:23 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11MMNM0e34668976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 22:23:23 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8E2AAE063;
        Mon, 22 Feb 2021 22:23:22 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B1EDAE05C;
        Mon, 22 Feb 2021 22:23:22 +0000 (GMT)
Received: from localhost (unknown [9.160.141.72])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 22 Feb 2021 22:23:21 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 03/13] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set
 in guest MSR
In-Reply-To: <20210219063542.1425130-4-npiggin@gmail.com>
References: <20210219063542.1425130-1-npiggin@gmail.com>
 <20210219063542.1425130-4-npiggin@gmail.com>
Date:   Mon, 22 Feb 2021 19:23:20 -0300
Message-ID: <87h7m3yc6f.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_07:2021-02-22,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 mlxlogscore=985 spamscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220190
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Rather than add the ME bit to the MSR when the guest is entered, make
> it clear that the hypervisor does not allow the guest to clear the bit.
>
> The ME addition is kept in the code for now, but a future patch will
> warn if it's not present.
>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kvm/book3s_hv_builtin.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
> index dad118760a4e..ae8f291c5c48 100644
> --- a/arch/powerpc/kvm/book3s_hv_builtin.c
> +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
> @@ -661,6 +661,13 @@ static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
>
>  void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
>  {
> +	/*
> +	 * Guest must always run with machine check interrupt
> +	 * enabled.
> +	 */
> +	if (!(msr & MSR_ME))
> +		msr |= MSR_ME;
> +
>  	/*
>  	 * Check for illegal transactional state bit combination
>  	 * and if we find it, force the TS field to a safe state.
