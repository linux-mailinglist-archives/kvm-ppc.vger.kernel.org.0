Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5AF3627CC
	for <lists+kvm-ppc@lfdr.de>; Fri, 16 Apr 2021 20:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhDPSf0 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 16 Apr 2021 14:35:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241863AbhDPSf0 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 16 Apr 2021 14:35:26 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GIXcki193532;
        Fri, 16 Apr 2021 14:34:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=RiTtakBkXEIhsvOIl1Nt97IU4z5aOd7Xe8QsV0GofDA=;
 b=OuGOhb7leqBvNLa0Qxil1zbq2uC8ccGI915D6pljl6Vd1+5jxfggsrl3enTq35UVk2Nl
 ZS7183JXMl2BTM7QbyI2fN5/79kpSKXrJ9RAig8IxhyE/wnCx5m1cMLYAwkCJjJMQ+rz
 ZIDtL6BC+PsirAtzSQQjBVWhmwK9+FI7tNLaJWMamEG1ODljwxSjxzRHiV/ebaAE1hdZ
 OqC0ATXK+8qp/+oSb4PklDdzqBJhYY1jSEAyMqfDJgR/PTDz6/R0TN3bSRU6jZt9cnnh
 iOZGd9Wp/mxJZ7uB/7lYj9fnoTIoJrLrmit/Rgu8Fz3Nqn7ZB9DpvVcnhmtXZ7751tbI rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xrhpe2dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 14:34:54 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13GIYspe003814;
        Fri, 16 Apr 2021 14:34:54 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37xrhpe2dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 14:34:53 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13GIXiHr020769;
        Fri, 16 Apr 2021 18:34:53 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 37u3narcq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Apr 2021 18:34:53 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13GIYqON26345772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 18:34:52 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91D09AE063;
        Fri, 16 Apr 2021 18:34:52 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5127AE05F;
        Fri, 16 Apr 2021 18:34:51 +0000 (GMT)
Received: from localhost (unknown [9.211.116.137])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Fri, 16 Apr 2021 18:34:51 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH v1 12/12] KVM: PPC: Book3S HV: Ensure MSR[HV] is always
 clear in guest MSR
In-Reply-To: <20210412014845.1517916-13-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
 <20210412014845.1517916-13-npiggin@gmail.com>
Date:   Fri, 16 Apr 2021 15:34:49 -0300
Message-ID: <877dl2m62e.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4gUmXwsEd9XeAssgMTC25zdhociVGTeu
X-Proofpoint-ORIG-GUID: iJgKTH7kbaCCQPrhQsgo3Lbxyo9lzLqW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_09:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104160131
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Nicholas Piggin <npiggin@gmail.com> writes:

> Rather than clear the HV bit from the MSR at guest entry, make it clear
> that the hypervisor does not allow the guest to set the bit.
>
> The HV clear is kept in guest entry for now, but a future patch will
> warn if it is set.
>
> Acked-by: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kvm/book3s_hv_builtin.c | 4 ++--
>  arch/powerpc/kvm/book3s_hv_nested.c  | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
> index 41cb03d0bde4..7a0e33a9c980 100644
> --- a/arch/powerpc/kvm/book3s_hv_builtin.c
> +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
> @@ -662,8 +662,8 @@ static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
>
>  void kvmppc_set_msr_hv(struct kvm_vcpu *vcpu, u64 msr)
>  {
> -	/* Guest must always run with ME enabled. */
> -	msr = msr | MSR_ME;
> +	/* Guest must always run with ME enabled, HV disabled. */
> +	msr = (msr | MSR_ME) & ~MSR_HV;
>
>  	/*
>  	 * Check for illegal transactional state bit combination
> diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
> index fb03085c902b..60724f674421 100644
> --- a/arch/powerpc/kvm/book3s_hv_nested.c
> +++ b/arch/powerpc/kvm/book3s_hv_nested.c
> @@ -344,8 +344,8 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
>  	vcpu->arch.nested_vcpu_id = l2_hv.vcpu_token;
>  	vcpu->arch.regs = l2_regs;
>
> -	/* Guest must always run with ME enabled. */
> -	vcpu->arch.shregs.msr = vcpu->arch.regs.msr | MSR_ME;
> +	/* Guest must always run with ME enabled, HV disabled. */
> +	vcpu->arch.shregs.msr = (vcpu->arch.regs.msr | MSR_ME) & ~MSR_HV;
>
>  	sanitise_hv_regs(vcpu, &l2_hv);
>  	restore_hv_regs(vcpu, &l2_hv);
