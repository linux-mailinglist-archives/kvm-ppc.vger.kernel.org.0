Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B1A22E491
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 Jul 2020 05:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgG0Dzs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 26 Jul 2020 23:55:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbgG0Dzs (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 26 Jul 2020 23:55:48 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06R3X7jh111156;
        Sun, 26 Jul 2020 23:55:40 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32gf29h1p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 26 Jul 2020 23:55:40 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06R3qbZH014797;
        Mon, 27 Jul 2020 03:55:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 32gcqghrv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 03:55:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06R3tZIs28180856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 03:55:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DF7D4203F;
        Mon, 27 Jul 2020 03:55:35 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44AF242041;
        Mon, 27 Jul 2020 03:55:32 +0000 (GMT)
Received: from in.ibm.com (unknown [9.85.81.241])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 27 Jul 2020 03:55:32 +0000 (GMT)
Date:   Mon, 27 Jul 2020 09:25:29 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Ram Pai <linuxram@us.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        aneesh.kumar@linux.ibm.com, sukadev@linux.vnet.ibm.com,
        ldufour@linux.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, cclaudio@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com
Subject: Re: [PATCH v5 5/7] KVM: PPC: Book3S HV: migrate hot plugged memory
Message-ID: <20200727035529.GH1082478@in.ibm.com>
Reply-To: bharata@linux.ibm.com
References: <1595534844-16188-1-git-send-email-linuxram@us.ibm.com>
 <1595534844-16188-6-git-send-email-linuxram@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595534844-16188-6-git-send-email-linuxram@us.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_02:2020-07-24,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 suspectscore=5 mlxscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270023
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Jul 23, 2020 at 01:07:22PM -0700, Ram Pai wrote:
> From: Laurent Dufour <ldufour@linux.ibm.com>
> 
> When a memory slot is hot plugged to a SVM, PFNs associated with the
> GFNs in that slot must be migrated to the secure-PFNs, aka device-PFNs.
> 
> Call kvmppc_uv_migrate_mem_slot() to accomplish this.
> Disable page-merge for all pages in the memory slot.
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> [rearranged the code, and modified the commit log]
> Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/kvm_book3s_uvmem.h | 14 ++++++++++++++
>  arch/powerpc/kvm/book3s_hv.c                | 10 ++--------
>  arch/powerpc/kvm/book3s_hv_uvmem.c          | 23 +++++++++++++++++++----
>  3 files changed, 35 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/kvm_book3s_uvmem.h b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
> index f229ab5..59c17ca 100644
> --- a/arch/powerpc/include/asm/kvm_book3s_uvmem.h
> +++ b/arch/powerpc/include/asm/kvm_book3s_uvmem.h
> @@ -25,6 +25,10 @@ void kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
>  			     struct kvm *kvm, bool skip_page_out);
>  int kvmppc_uv_migrate_mem_slot(struct kvm *kvm,
>  			const struct kvm_memory_slot *memslot);
> +int kvmppc_uvmem_memslot_create(struct kvm *kvm,
> +		const struct kvm_memory_slot *new);
> +void kvmppc_uvmem_memslot_delete(struct kvm *kvm,
> +		const struct kvm_memory_slot *old);
>  #else
>  static inline int kvmppc_uvmem_init(void)
>  {
> @@ -84,5 +88,15 @@ static inline int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gfn)
>  static inline void
>  kvmppc_uvmem_drop_pages(const struct kvm_memory_slot *free,
>  			struct kvm *kvm, bool skip_page_out) { }
> +
> +static inline int  kvmppc_uvmem_memslot_create(struct kvm *kvm,
> +		const struct kvm_memory_slot *new)
> +{
> +	return H_UNSUPPORTED;
> +}
> +
> +static inline void  kvmppc_uvmem_memslot_delete(struct kvm *kvm,
> +		const struct kvm_memory_slot *old) { }
> +
>  #endif /* CONFIG_PPC_UV */
>  #endif /* __ASM_KVM_BOOK3S_UVMEM_H__ */
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index d331b46..b1485ca 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4515,16 +4515,10 @@ static void kvmppc_core_commit_memory_region_hv(struct kvm *kvm,
>  
>  	switch (change) {
>  	case KVM_MR_CREATE:
> -		if (kvmppc_uvmem_slot_init(kvm, new))
> -			return;
> -		uv_register_mem_slot(kvm->arch.lpid,
> -				     new->base_gfn << PAGE_SHIFT,
> -				     new->npages * PAGE_SIZE,
> -				     0, new->id);
> +		kvmppc_uvmem_memslot_create(kvm, new);

Only concern is that kvmppc_uvmem_memslot_create() can fail due
to multiple reasons but we ignore them and go ahead with memory
hotplug.

May be this hasn't been observed in reality but if we can note this
as a TODO in the comments to dig further and explore the possibility
of recovering from here, then

Reviewed-by: Bharata B Rao <bharata@linux.ibm.com>

Regards,
Bharata.
