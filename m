Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27F321D331
	for <lists+kvm-ppc@lfdr.de>; Mon, 13 Jul 2020 11:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgGMJvF (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 13 Jul 2020 05:51:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22814 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726523AbgGMJvE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 13 Jul 2020 05:51:04 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06D9WAvN142833;
        Mon, 13 Jul 2020 05:50:53 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32771wrcwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 05:50:53 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06D9nZKV021830;
        Mon, 13 Jul 2020 09:50:51 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 327528223f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 09:50:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06D9om0B66388098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 09:50:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D3534203F;
        Mon, 13 Jul 2020 09:50:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 366924204B;
        Mon, 13 Jul 2020 09:50:46 +0000 (GMT)
Received: from in.ibm.com (unknown [9.199.58.151])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 13 Jul 2020 09:50:46 +0000 (GMT)
Date:   Mon, 13 Jul 2020 15:20:43 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, cclaudio@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [v3 4/5] KVM: PPC: Book3S HV: retry page migration before
 erroring-out H_SVM_PAGE_IN
Message-ID: <20200713095043.GH7902@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <1594458827-31866-1-git-send-email-linuxram@us.ibm.com>
 <1594458827-31866-5-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594458827-31866-5-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_04:2020-07-10,2020-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 suspectscore=1 adultscore=0
 clxscore=1015 bulkscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130071
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Jul 11, 2020 at 02:13:46AM -0700, Ram Pai wrote:
> The page requested for page-in; sometimes, can have transient
> references, and hence cannot migrate immediately. Retry a few times
> before returning error.

As I noted in the previous patch, we need to understand what are these
transient errors and they occur on what type of pages?

The previous patch also introduced a bit of retry logic in the
page-in path. Can you consolidate the retry logic into a separate
patch?

> 
> H_SVM_PAGE_IN interface is enhanced to return H_BUSY if the page is
> not in a migratable state.
> 
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Bharata B Rao <bharata@linux.ibm.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Claudio Carvalho <cclaudio@linux.ibm.com>
> Cc: kvm-ppc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> ---
>  Documentation/powerpc/ultravisor.rst |  1 +
>  arch/powerpc/kvm/book3s_hv_uvmem.c   | 54 +++++++++++++++++++++---------------
>  2 files changed, 33 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/powerpc/ultravisor.rst b/Documentation/powerpc/ultravisor.rst
> index d98fc85..638d1a7 100644
> --- a/Documentation/powerpc/ultravisor.rst
> +++ b/Documentation/powerpc/ultravisor.rst
> @@ -1034,6 +1034,7 @@ Return values
>  	* H_PARAMETER	if ``guest_pa`` is invalid.
>  	* H_P2		if ``flags`` is invalid.
>  	* H_P3		if ``order`` of page is invalid.
> +	* H_BUSY	if ``page`` is not in a state to pagein
>  
>  Description
>  ~~~~~~~~~~~
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index 12ed52a..c9bdef6 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -843,7 +843,7 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
>  	struct vm_area_struct *vma;
>  	int srcu_idx;
>  	unsigned long gfn = gpa >> page_shift;
> -	int ret;
> +	int ret, repeat_count = REPEAT_COUNT;
>  
>  	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
>  		return H_UNSUPPORTED;
> @@ -857,34 +857,44 @@ unsigned long kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
>  	if (flags & H_PAGE_IN_SHARED)
>  		return kvmppc_share_page(kvm, gpa, page_shift);
>  
> -	ret = H_PARAMETER;
>  	srcu_idx = srcu_read_lock(&kvm->srcu);
> -	down_write(&kvm->mm->mmap_sem);
>  
> -	start = gfn_to_hva(kvm, gfn);
> -	if (kvm_is_error_hva(start))
> -		goto out;
> -
> -	mutex_lock(&kvm->arch.uvmem_lock);
>  	/* Fail the page-in request of an already paged-in page */
> -	if (kvmppc_gfn_is_uvmem_pfn(gfn, kvm, NULL))
> -		goto out_unlock;
> +	mutex_lock(&kvm->arch.uvmem_lock);
> +	ret = kvmppc_gfn_is_uvmem_pfn(gfn, kvm, NULL);
> +	mutex_unlock(&kvm->arch.uvmem_lock);
> +	if (ret) {
> +		srcu_read_unlock(&kvm->srcu, srcu_idx);
> +		return H_PARAMETER;
> +	}
>  
> -	end = start + (1UL << page_shift);
> -	vma = find_vma_intersection(kvm->mm, start, end);
> -	if (!vma || vma->vm_start > start || vma->vm_end < end)
> -		goto out_unlock;
> +	do {
> +		ret = H_PARAMETER;
> +		down_write(&kvm->mm->mmap_sem);

Again with ksm_madvise() moved to init time, check if you still need
write mmap_sem here.

Regards,
Bharata.
