Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8387EB5893
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Sep 2019 01:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfIQXdm (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 17 Sep 2019 19:33:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726234AbfIQXdm (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 17 Sep 2019 19:33:42 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8HNWPNI007150;
        Tue, 17 Sep 2019 19:33:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v37u22h02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 19:33:33 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8HNWupm008382;
        Tue, 17 Sep 2019 19:33:33 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v37u22gxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 19:33:32 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8HNU40Z023603;
        Tue, 17 Sep 2019 23:33:31 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 2v37jvgskb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Sep 2019 23:33:31 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8HNXUDo47776080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Sep 2019 23:33:30 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E561112066;
        Tue, 17 Sep 2019 23:33:30 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32931112062;
        Tue, 17 Sep 2019 23:33:30 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.70.94.45])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 17 Sep 2019 23:33:30 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 9BADE2E10EA; Tue, 17 Sep 2019 16:33:28 -0700 (PDT)
Date:   Tue, 17 Sep 2019 16:33:28 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v8 3/8] kvmppc: Shared pages support for secure guests
Message-ID: <20190917233328.GC27932@us.ibm.com>
References: <20190910082946.7849-1-bharata@linux.ibm.com>
 <20190910082946.7849-4-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910082946.7849-4-bharata@linux.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.10.1 (2018-07-13)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-17_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909170219
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org


> A secure guest will share some of its pages with hypervisor (Eg. virtio
> bounce buffers etc). Support sharing of pages between hypervisor and
> ultravisor.

A brief note about what a shared page is would help (a page belonging
to the SVM but in normal memory and with decrypted contents)? Either
here or in the function header of kvmppc_h_svm_page_in() where we
handle shared pages.

> 
> Once a secure page is converted to shared page, the device page is

Maybe useful to add "the device page (representing the secure page") is ...

> unmapped from the HV side page tables.
> 
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/hvcall.h  |  3 ++
>  arch/powerpc/kvm/book3s_hv_uvmem.c | 65 ++++++++++++++++++++++++++++--
>  2 files changed, 65 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
> index 2595d0144958..4e98dd992bd1 100644
> --- a/arch/powerpc/include/asm/hvcall.h
> +++ b/arch/powerpc/include/asm/hvcall.h
> @@ -342,6 +342,9 @@
>  #define H_TLB_INVALIDATE	0xF808
>  #define H_COPY_TOFROM_GUEST	0xF80C
> 
> +/* Flags for H_SVM_PAGE_IN */
> +#define H_PAGE_IN_SHARED        0x1
> +
>  /* Platform-specific hcalls used by the Ultravisor */
>  #define H_SVM_PAGE_IN		0xEF00
>  #define H_SVM_PAGE_OUT		0xEF04
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index a1eccb065ba9..bcecb643a730 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -46,6 +46,7 @@ struct kvmppc_uvmem_page_pvt {
>  	unsigned long *rmap;
>  	unsigned int lpid;
>  	unsigned long gpa;
> +	bool skip_page_out;
>  };
> 
>  /*
> @@ -159,6 +160,53 @@ kvmppc_svm_page_in(struct vm_area_struct *vma, unsigned long start,
>  	return ret;
>  }
> 
> +/*
> + * Shares the page with HV, thus making it a normal page.
> + *
> + * - If the page is already secure, then provision a new page and share
> + * - If the page is a normal page, share the existing page
> + *
> + * In the former case, uses the dev_pagemap_ops migrate_to_ram handler
> + * to unmap the device page from QEMU's page tables.
> + */
> +static unsigned long
> +kvmppc_share_page(struct kvm *kvm, unsigned long gpa, unsigned long page_shift)
> +{
> +
> +	int ret = H_PARAMETER;
> +	struct page *uvmem_page;
> +	struct kvmppc_uvmem_page_pvt *pvt;
> +	unsigned long pfn;
> +	unsigned long *rmap;
> +	struct kvm_memory_slot *slot;
> +	unsigned long gfn = gpa >> page_shift;
> +	int srcu_idx;
> +
> +	srcu_idx = srcu_read_lock(&kvm->srcu);
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot)
> +		goto out;
> +
> +	rmap = &slot->arch.rmap[gfn - slot->base_gfn];
> +	if (kvmppc_rmap_type(rmap) == KVMPPC_RMAP_UVMEM_PFN) {
> +		uvmem_page = pfn_to_page(*rmap & ~KVMPPC_RMAP_UVMEM_PFN);
> +		pvt = (struct kvmppc_uvmem_page_pvt *)
> +			uvmem_page->zone_device_data;
> +		pvt->skip_page_out = true;
> +	}
> +
> +	pfn = gfn_to_pfn(kvm, gfn);
> +	if (is_error_noslot_pfn(pfn))
> +		goto out;
> +
> +	if (!uv_page_in(kvm->arch.lpid, pfn << page_shift, gpa, 0, page_shift))
> +		ret = H_SUCCESS;
> +	kvm_release_pfn_clean(pfn);
> +out:
> +	srcu_read_unlock(&kvm->srcu, srcu_idx);
> +	return ret;
> +}
> +
>  /*
>   * H_SVM_PAGE_IN: Move page from normal memory to secure memory.

Would help to mention/remind here what a shared page is.

>   */
> @@ -177,9 +225,12 @@ kvmppc_h_svm_page_in(struct kvm *kvm, unsigned long gpa,
>  	if (page_shift != PAGE_SHIFT)
>  		return H_P3;
> 
> -	if (flags)
> +	if (flags & ~H_PAGE_IN_SHARED)
>  		return H_P2;
> 
> +	if (flags & H_PAGE_IN_SHARED)
> +		return kvmppc_share_page(kvm, gpa, page_shift);
> +
>  	ret = H_PARAMETER;
>  	srcu_idx = srcu_read_lock(&kvm->srcu);
>  	down_read(&kvm->mm->mmap_sem);
> @@ -252,8 +303,16 @@ kvmppc_svm_page_out(struct vm_area_struct *vma, unsigned long start,
>  	pvt = spage->zone_device_data;
>  	pfn = page_to_pfn(dpage);
> 
> -	ret = uv_page_out(pvt->lpid, pfn << page_shift, pvt->gpa, 0,
> -			  page_shift);
> +	/*
> +	 * This function is used in two cases:
> +	 * - When HV touches a secure page, for which we do UV_PAGE_OUT
> +	 * - When a secure page is converted to shared page, we touch
> +	 *   the page to essentially unmap the device page. In this
> +	 *   case we skip page-out.
> +	 */
> +	if (!pvt->skip_page_out)
> +		ret = uv_page_out(pvt->lpid, pfn << page_shift, pvt->gpa, 0,
> +				  page_shift);
> 
>  	if (ret == U_SUCCESS)
>  		*mig.dst = migrate_pfn(pfn) | MIGRATE_PFN_LOCKED;
> -- 
> 2.21.0
