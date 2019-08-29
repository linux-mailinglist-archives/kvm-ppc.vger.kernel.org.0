Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87DEA1316
	for <lists+kvm-ppc@lfdr.de>; Thu, 29 Aug 2019 09:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfH2H6B (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 29 Aug 2019 03:58:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6556 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbfH2H6B (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 29 Aug 2019 03:58:01 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7T7veOo133055
        for <kvm-ppc@vger.kernel.org>; Thu, 29 Aug 2019 03:58:00 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2up9t8htpc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm-ppc@vger.kernel.org>; Thu, 29 Aug 2019 03:57:59 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm-ppc@vger.kernel.org> from <bharata@linux.ibm.com>;
        Thu, 29 Aug 2019 08:57:57 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 29 Aug 2019 08:57:55 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7T7vr9045416700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 07:57:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95EF842042;
        Thu, 29 Aug 2019 07:57:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA5324204C;
        Thu, 29 Aug 2019 07:57:51 +0000 (GMT)
Received: from in.ibm.com (unknown [9.124.35.109])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 29 Aug 2019 07:57:51 +0000 (GMT)
Date:   Thu, 29 Aug 2019 13:27:49 +0530
From:   Bharata B Rao <bharata@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        linuxram@us.ibm.com, cclaudio@linux.ibm.com, hch@lst.de
Subject: Re: [PATCH v7 5/7] kvmppc: Radix changes for secure guest
Reply-To: bharata@linux.ibm.com
References: <20190822102620.21897-1-bharata@linux.ibm.com>
 <20190822102620.21897-6-bharata@linux.ibm.com>
 <20190829030552.GA17673@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829030552.GA17673@us.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-TM-AS-GCONF: 00
x-cbid: 19082907-0008-0000-0000-0000030E8B2E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082907-0009-0000-0000-00004A2CCDFA
Message-Id: <20190829075749.GC31913@in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908290087
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, Aug 28, 2019 at 08:05:52PM -0700, Sukadev Bhattiprolu wrote:
> > - After the guest becomes secure, when we handle a page fault of a page
> >   belonging to SVM in HV, send that page to UV via UV_PAGE_IN.
> > - Whenever a page is unmapped on the HV side, inform UV via UV_PAGE_INVAL.
> > - Ensure all those routines that walk the secondary page tables of
> >   the guest don't do so in case of secure VM. For secure guest, the
> >   active secondary page tables are in secure memory and the secondary
> >   page tables in HV are freed when guest becomes secure.
> > 
> > Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>
> > ---
> >  arch/powerpc/include/asm/kvm_host.h       | 12 ++++++++++++
> >  arch/powerpc/include/asm/ultravisor-api.h |  1 +
> >  arch/powerpc/include/asm/ultravisor.h     |  5 +++++
> >  arch/powerpc/kvm/book3s_64_mmu_radix.c    | 22 ++++++++++++++++++++++
> >  arch/powerpc/kvm/book3s_hv_devm.c         | 20 ++++++++++++++++++++
> >  5 files changed, 60 insertions(+)
> > 
> > diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> > index 66e5cc8c9759..29333e8de1c4 100644
> > --- a/arch/powerpc/include/asm/kvm_host.h
> > +++ b/arch/powerpc/include/asm/kvm_host.h
> > @@ -867,6 +867,8 @@ static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> >  #ifdef CONFIG_PPC_UV
> >  extern int kvmppc_devm_init(void);
> >  extern void kvmppc_devm_free(void);
> > +extern bool kvmppc_is_guest_secure(struct kvm *kvm);
> > +extern int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gpa);
> >  #else
> >  static inline int kvmppc_devm_init(void)
> >  {
> > @@ -874,6 +876,16 @@ static inline int kvmppc_devm_init(void)
> >  }
> > 
> >  static inline void kvmppc_devm_free(void) {}
> > +
> > +static inline bool kvmppc_is_guest_secure(struct kvm *kvm)
> > +{
> > +	return false;
> > +}
> > +
> > +static inline int kvmppc_send_page_to_uv(struct kvm *kvm, unsigned long gpa)
> > +{
> > +	return -EFAULT;
> > +}
> >  #endif /* CONFIG_PPC_UV */
> > 
> >  #endif /* __POWERPC_KVM_HOST_H__ */
> > diff --git a/arch/powerpc/include/asm/ultravisor-api.h b/arch/powerpc/include/asm/ultravisor-api.h
> > index 46b1ee381695..cf200d4ce703 100644
> > --- a/arch/powerpc/include/asm/ultravisor-api.h
> > +++ b/arch/powerpc/include/asm/ultravisor-api.h
> > @@ -29,5 +29,6 @@
> >  #define UV_UNREGISTER_MEM_SLOT		0xF124
> >  #define UV_PAGE_IN			0xF128
> >  #define UV_PAGE_OUT			0xF12C
> > +#define UV_PAGE_INVAL			0xF138
> > 
> >  #endif /* _ASM_POWERPC_ULTRAVISOR_API_H */
> > diff --git a/arch/powerpc/include/asm/ultravisor.h b/arch/powerpc/include/asm/ultravisor.h
> > index 719c0c3930b9..b333241bbe4c 100644
> > --- a/arch/powerpc/include/asm/ultravisor.h
> > +++ b/arch/powerpc/include/asm/ultravisor.h
> > @@ -57,4 +57,9 @@ static inline int uv_unregister_mem_slot(u64 lpid, u64 slotid)
> >  	return ucall_norets(UV_UNREGISTER_MEM_SLOT, lpid, slotid);
> >  }
> > 
> > +static inline int uv_page_inval(u64 lpid, u64 gpa, u64 page_shift)
> > +{
> > +	return ucall_norets(UV_PAGE_INVAL, lpid, gpa, page_shift);
> > +}
> > +
> >  #endif	/* _ASM_POWERPC_ULTRAVISOR_H */
> > diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > index 2d415c36a61d..93ad34e63045 100644
> > --- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > +++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
> > @@ -19,6 +19,8 @@
> >  #include <asm/pgtable.h>
> >  #include <asm/pgalloc.h>
> >  #include <asm/pte-walk.h>
> > +#include <asm/ultravisor.h>
> > +#include <asm/kvm_host.h>
> > 
> >  /*
> >   * Supported radix tree geometry.
> > @@ -915,6 +917,9 @@ int kvmppc_book3s_radix_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
> >  	if (!(dsisr & DSISR_PRTABLE_FAULT))
> >  		gpa |= ea & 0xfff;
> > 
> > +	if (kvmppc_is_guest_secure(kvm))
> > +		return kvmppc_send_page_to_uv(kvm, gpa & PAGE_MASK);
> > +
> >  	/* Get the corresponding memslot */
> >  	memslot = gfn_to_memslot(kvm, gfn);
> > 
> > @@ -972,6 +977,11 @@ int kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
> >  	unsigned long gpa = gfn << PAGE_SHIFT;
> >  	unsigned int shift;
> > 
> > +	if (kvmppc_is_guest_secure(kvm)) {
> > +		uv_page_inval(kvm->arch.lpid, gpa, PAGE_SIZE);
> > +		return 0;
> > +	}
> 
> If it is a page we share with UV, won't we need to drop the HV mapping
> for the page?

I believe we come here via MMU notifies only after dropping HV mapping.

Regards,
Bharata.

