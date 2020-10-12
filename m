Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D9A28BD57
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Oct 2020 18:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390598AbgJLQNj (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 12 Oct 2020 12:13:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52744 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390043AbgJLQNj (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 12 Oct 2020 12:13:39 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09CG3EgK044308;
        Mon, 12 Oct 2020 12:13:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : reply-to : references : mime-version : content-type
 : in-reply-to; s=pp1; bh=DQb2p4EkD85ey8a9ActePp3d6MvtDJTED59FIyyUx9o=;
 b=pv2XS3lqZIkbdly7Tgw8K1KrzVTcxsR5VkPajlBxpccYvaJ9gC6FZO6MjjyflnhQrhZP
 rvVrVmK8fJN07wsfWDwC49IlCvtCU70B/iYQT1r5YH5QDakMx3DC56j+hLl4iLUL8+t6
 h8SZo+NUQ62SGehidgFuS11Y8KK1AkuIr/pgMMQgEZkpdngw2nFptct0H5XxrZJ+WVid
 gPItIjTsetmzJzHrvQDfSkIEnh5ENmZaWXT7AwCmnYg8t2zanInqc/X8VMF74j1juPUo
 Wv0LOHJ39WAjgUqaX4TLkOyd5WRDLyW6big+iTRj1CXli9FMNCgSu/kvufd+onoCLh1C Qw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 344seetpbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 12:13:30 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09CG86tI017013;
        Mon, 12 Oct 2020 16:13:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3434k7t6df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 16:13:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09CGDOn035717480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Oct 2020 16:13:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 499375204E;
        Mon, 12 Oct 2020 16:13:24 +0000 (GMT)
Received: from ram-ibm-com.ibm.com (unknown [9.85.204.94])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 822675204F;
        Mon, 12 Oct 2020 16:13:22 +0000 (GMT)
Date:   Mon, 12 Oct 2020 09:13:19 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulus@ozlabs.org, farosas@linux.ibm.com
Subject: Re: [RFC v1 2/2] KVM: PPC: Book3S HV: abstract secure VM related
 calls.
Message-ID: <20201012161319.GB4773@ram-ibm-com.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1602487663-7321-1-git-send-email-linuxram@us.ibm.com>
 <1602487663-7321-2-git-send-email-linuxram@us.ibm.com>
 <1602487663-7321-3-git-send-email-linuxram@us.ibm.com>
 <20201012152836.GK185637@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012152836.GK185637@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_12:2020-10-12,2020-10-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=2 mlxscore=0 spamscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010120125
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Oct 12, 2020 at 08:58:36PM +0530, Bharata B Rao wrote:
> On Mon, Oct 12, 2020 at 12:27:43AM -0700, Ram Pai wrote:
> > Abstract the secure VM related calls into generic calls.
> > 
> > These generic calls will call the corresponding method of the
> > backend that prvoides the implementation to support secure VM.
> > 
> > Currently there is only the ultravisor based implementation.
> > Modify that implementation to act as a backed to the generic calls.
> > 
> > This plumbing will provide the flexibility to add more backends
> > in the future.
> > 
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > ---
> >  arch/powerpc/include/asm/kvm_book3s_uvmem.h   | 100 -----------
> >  arch/powerpc/include/asm/kvmppc_svm_backend.h | 250 ++++++++++++++++++++++++++
> >  arch/powerpc/kvm/book3s_64_mmu_radix.c        |   6 +-
> >  arch/powerpc/kvm/book3s_hv.c                  |  28 +--
> >  arch/powerpc/kvm/book3s_hv_uvmem.c            |  78 ++++++--
> >  5 files changed, 327 insertions(+), 135 deletions(-)
> >  delete mode 100644 arch/powerpc/include/asm/kvm_book3s_uvmem.h
> >  create mode 100644 arch/powerpc/include/asm/kvmppc_svm_backend.h
> > 
> > diff --git a/arch/powerpc/include/asm/kvmppc_svm_backend.h b/arch/powerpc/include/asm/kvmppc_svm_backend.h
> > new file mode 100644
> > index 0000000..be60d80
> > --- /dev/null
> > +++ b/arch/powerpc/include/asm/kvmppc_svm_backend.h
> > @@ -0,0 +1,250 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + *
> > + * Copyright IBM Corp. 2020
> > + *
> > + * Authors: Ram Pai <linuxram@us.ibm.com>
> > + */
> > +
> > +#ifndef __POWERPC_KVMPPC_SVM_BACKEND_H__
> > +#define __POWERPC_KVMPPC_SVM_BACKEND_H__
> > +
> > +#include <linux/mutex.h>
> > +#include <linux/timer.h>
> > +#include <linux/types.h>
> > +#include <linux/kvm_types.h>
> > +#include <linux/kvm_host.h>
> > +#include <linux/bug.h>
> > +#ifdef CONFIG_PPC_BOOK3S
> > +#include <asm/kvm_book3s.h>
> > +#else
> > +#include <asm/kvm_booke.h>
> > +#endif
> > +#ifdef CONFIG_KVM_BOOK3S_64_HANDLER
> > +#include <asm/paca.h>
> > +#include <asm/xive.h>
> > +#include <asm/cpu_has_feature.h>
> > +#endif
> > +
> > +struct kvmppc_hmm_backend {
> 
> Though we started with HMM initially, what we ended up with eventually
> has nothing to do with HMM. Please don't introduce hmm again :-)

Hmm.. its still a extension to HMM to help manage device memory.
right?  What am i missing?


> 
> > +	/* initialize */
> > +	int (*kvmppc_secmem_init)(void);
> > +
> > +	/* cleanup */
> > +	void (*kvmppc_secmem_free)(void);
> > +
> > +	/* is memory available */
> > +	bool (*kvmppc_secmem_available)(void);
> > +
> > +	/* allocate a protected/secure page for the secure VM */
> > +	unsigned long (*kvmppc_svm_page_in)(struct kvm *kvm,
> > +			unsigned long gra,
> > +			unsigned long flags,
> > +			unsigned long page_shift);
> > +
> > +	/* recover the protected/secure page from the secure VM */
> > +	unsigned long (*kvmppc_svm_page_out)(struct kvm *kvm,
> > +			unsigned long gra,
> > +			unsigned long flags,
> > +			unsigned long page_shift);
> > +
> > +	/* initiate the transition of a VM to secure VM */
> > +	unsigned long (*kvmppc_svm_init_start)(struct kvm *kvm);
> > +
> > +	/* finalize the transition of a secure VM */
> > +	unsigned long (*kvmppc_svm_init_done)(struct kvm *kvm);
> > +
> > +	/* share the page on page fault */
> > +	int (*kvmppc_svm_page_share)(struct kvm *kvm, unsigned long gfn);
> > +
> > +	/* abort the transition to a secure VM */
> > +	unsigned long (*kvmppc_svm_init_abort)(struct kvm *kvm);
> > +
> > +	/* add a memory slot */
> > +	int (*kvmppc_svm_memslot_create)(struct kvm *kvm,
> > +		const struct kvm_memory_slot *new);
> > +
> > +	/* free a memory slot */
> > +	void (*kvmppc_svm_memslot_delete)(struct kvm *kvm,
> > +		const struct kvm_memory_slot *old);
> > +
> > +	/* drop pages allocated to the secure VM */
> > +	void (*kvmppc_svm_drop_pages)(const struct kvm_memory_slot *free,
> > +			     struct kvm *kvm, bool skip_page_out);
> > +};
> 
> Since the structure has kvmppc_ prefix, may be you can drop
> the same from its members to make the fields smaller?

ok.


> 
> > +
> > +extern const struct kvmppc_hmm_backend *kvmppc_svm_backend;
> > +
> > +static inline int kvmppc_svm_page_share(struct kvm *kvm, unsigned long gfn)
> > +{
> > +	if (!kvmppc_svm_backend)
> > +		return -ENODEV;
> > +
> > +	return kvmppc_svm_backend->kvmppc_svm_page_share(kvm,
> > +				gfn);
> > +}
> > +
> > +static inline void kvmppc_svm_drop_pages(const struct kvm_memory_slot *memslot,
> > +			struct kvm *kvm, bool skip_page_out)
> > +{
> > +	if (!kvmppc_svm_backend)
> > +		return;
> > +
> > +	kvmppc_svm_backend->kvmppc_svm_drop_pages(memslot,
> > +			kvm, skip_page_out);
> > +}
> > +
> > +static inline int kvmppc_svm_page_in(struct kvm *kvm,
> > +			unsigned long gpa,
> > +			unsigned long flags,
> > +			unsigned long page_shift)
> > +{
> > +	if (!kvmppc_svm_backend)
> > +		return -ENODEV;
> > +
> > +	return kvmppc_svm_backend->kvmppc_svm_page_in(kvm,
> > +			gpa, flags, page_shift);
> > +}
> > +
> > +static inline int kvmppc_svm_page_out(struct kvm *kvm,
> > +			unsigned long gpa,
> > +			unsigned long flags,
> > +			unsigned long page_shift)
> > +{
> > +	if (!kvmppc_svm_backend)
> > +		return -ENODEV;
> > +
> > +	return kvmppc_svm_backend->kvmppc_svm_page_out(kvm,
> > +			gpa, flags, page_shift);
> > +}
> > +
> > +static inline int kvmppc_svm_init_start(struct kvm *kvm)
> > +{
> > +	if (!kvmppc_svm_backend)
> > +		return -ENODEV;
> > +
> > +	return kvmppc_svm_backend->kvmppc_svm_init_start(kvm);
> > +}
> > +
> > +static inline int kvmppc_svm_init_done(struct kvm *kvm)
> > +{
> > +	if (!kvmppc_svm_backend)
> > +		return -ENODEV;
> > +
> > +	return kvmppc_svm_backend->kvmppc_svm_init_done(kvm);
> > +}
> > +
> > +static inline int kvmppc_svm_init_abort(struct kvm *kvm)
> > +{
> > +	if (!kvmppc_svm_backend)
> > +		return -ENODEV;
> > +
> > +	return kvmppc_svm_backend->kvmppc_svm_init_abort(kvm);
> > +}
> > +
> > +static inline void kvmppc_svm_memslot_create(struct kvm *kvm,
> > +		const struct kvm_memory_slot *memslot)
> > +{
> > +	if (!kvmppc_svm_backend)
> > +		return;
> > +
> > +	kvmppc_svm_backend->kvmppc_svm_memslot_create(kvm,
> > +			memslot);
> > +}
> > +
> > +static inline void kvmppc_svm_memslot_delete(struct kvm *kvm,
> > +		const struct kvm_memory_slot *memslot)
> > +{
> > +	if (!kvmppc_svm_backend)
> > +		return;
> > +
> > +	kvmppc_svm_backend->kvmppc_svm_memslot_delete(kvm,
> > +			memslot);
> > +}
> > +
> > +static inline int kvmppc_secmem_init(void)
> > +{
> > +#ifdef CONFIG_PPC_UV
> > +	extern const struct kvmppc_hmm_backend kvmppc_uvmem_backend;
> > +
> > +	kvmppc_svm_backend = NULL;
> > +	if (kvmhv_on_pseries()) {
> > +		/* @TODO add the protected memory backend */
> > +		return 0;
> > +	}
> > +
> > +	kvmppc_svm_backend = &kvmppc_uvmem_backend;
> > +
> > +	if (!kvmppc_svm_backend->kvmppc_secmem_init) {
> 
> You have a function named kvmppc_secmem_init() and the field
> named the same, can be confusing.

ok. anyway the 'kvmppc' of the field will go away as per your comment
above. So the confusion will also go away :)

> 
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no %s\n", __func__);
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_secmem_free) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_secmem_free()\n");
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_secmem_available) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_secmem_available()\n");
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_svm_page_in) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_svm_page_in()\n");
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_svm_page_out) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_svm_page_out()\n");
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_svm_init_start) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_svm_init_start()\n");
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_svm_init_done) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_svm_init_done()\n");
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_svm_page_share) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_svm_page_share()\n");
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_svm_init_abort) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_svm_init_abort()\n");
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_svm_memslot_create) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_svm_memslot_create()\n");
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_svm_memslot_delete) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_svm_memslot_delete()\n");
> > +		goto err;
> > +	}
> > +	if (!kvmppc_svm_backend->kvmppc_svm_drop_pages) {
> > +		pr_err("KVM-HV: kvmppc_svm_backend has no kvmppc_svm_drop_pages()\n");
> > +		goto err;
> > +	}
> 
> Do you really need to check each and every callback like above?
> If so, may be the check can be optimized?

It gets checked only the first time, when the backend is introduced.
If we dont check it during initialization, then we will have to check
everytime the method is called. So it is optimized in that sense.

Do you see a better way to optimize it?

Thanks for your comments,
RP
