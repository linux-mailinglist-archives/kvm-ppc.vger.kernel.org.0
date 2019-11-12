Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1080DF881B
	for <lists+kvm-ppc@lfdr.de>; Tue, 12 Nov 2019 06:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbfKLFin (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 12 Nov 2019 00:38:43 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:55077 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfKLFin (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 12 Nov 2019 00:38:43 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47BxPD2KHWz9sPF; Tue, 12 Nov 2019 16:38:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1573537120; bh=YxgI2NrQO1fN9SK0O7nd/Xw8TdmEeaUYksXgOTKsyYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t7gFTQAhnZMZsDrZIfOpcYRXjyHw0N39ty70Py9TKQwrwhiPKuLkF72wWSqxYnWgg
         Ji9Cq02gQTiLqCvS0BTgheJ8q7C4NmhXeWIMz1vqh7MaddsWkhPr7PF91alVTS+8vr
         FMicWxglSyuv+rxWpqcMSjdP8U2t0DawgA+E55FFOIIbj3jO85UQbkmHmky+Vb4UFv
         Bb8maDKhDMBBkNPSW+42a/YvkPlYVxo2jEOgdOY85yCu2VcJE3Fyi5lPAggkb/KbnG
         2Yn0u/4uzBaCDsms/2eIpvgeM7ZP4RK+AbF43z1o9mRhYk67N5+Ek4sQBdZ+rcUYtB
         wtly9nROU6n1Q==
Date:   Tue, 12 Nov 2019 16:34:34 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org, paulus@au1.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, jglisse@redhat.com,
        cclaudio@linux.ibm.com, linuxram@us.ibm.com,
        sukadev@linux.vnet.ibm.com, hch@lst.de
Subject: Re: [PATCH v10 6/8] KVM: PPC: Support reset of secure guest
Message-ID: <20191112053434.GA10885@oak.ozlabs.ibm.com>
References: <20191104041800.24527-1-bharata@linux.ibm.com>
 <20191104041800.24527-7-bharata@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104041800.24527-7-bharata@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Nov 04, 2019 at 09:47:58AM +0530, Bharata B Rao wrote:
[snip]
> @@ -5442,6 +5471,64 @@ static int kvmhv_store_to_eaddr(struct kvm_vcpu *vcpu, ulong *eaddr, void *ptr,
>  	return rc;
>  }
>  
> +/*
> + *  IOCTL handler to turn off secure mode of guest
> + *
> + * - Issue ucall to terminate the guest on the UV side
> + * - Unpin the VPA pages (Enables these pages to be migrated back
> + *   when VM becomes secure again)
> + * - Recreate partition table as the guest is transitioning back to
> + *   normal mode
> + * - Release all device pages
> + */
> +static int kvmhv_svm_off(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int srcu_idx;
> +	int ret = 0;
> +	int i;
> +
> +	if (!(kvm->arch.secure_guest & KVMPPC_SECURE_INIT_START))
> +		return ret;
> +

A further comment on this code: it should check that no vcpus are
running and fail if any are running, and it should prevent any vcpus
from running until the function is finished, using code like that in
kvmhv_configure_mmu().  That is, it should do something like this:

	mutex_lock(&kvm->arch.mmu_setup_lock);
	mmu_was_ready = kvm->arch.mmu_ready;
	if (kvm->arch.mmu_ready) {
		kvm->arch.mmu_ready = 0;
		/* order mmu_ready vs. vcpus_running */
		smp_mb();
		if (atomic_read(&kvm->arch.vcpus_running)) {
			kvm->arch.mmu_ready = 1;
			ret = -EBUSY;
			goto out_unlock;
		}
	}

and then after clearing kvm->arch.secure_guest below:

> +	srcu_idx = srcu_read_lock(&kvm->srcu);
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		struct kvm_memory_slot *memslot;
> +		struct kvm_memslots *slots = __kvm_memslots(kvm, i);
> +
> +		if (!slots)
> +			continue;
> +
> +		kvm_for_each_memslot(memslot, slots) {
> +			kvmppc_uvmem_drop_pages(memslot, kvm, true);
> +			uv_unregister_mem_slot(kvm->arch.lpid, memslot->id);
> +		}
> +	}
> +	srcu_read_unlock(&kvm->srcu, srcu_idx);
> +
> +	ret = uv_svm_terminate(kvm->arch.lpid);
> +	if (ret != U_SUCCESS) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		spin_lock(&vcpu->arch.vpa_update_lock);
> +		unpin_vpa_reset(kvm, &vcpu->arch.dtl);
> +		unpin_vpa_reset(kvm, &vcpu->arch.slb_shadow);
> +		unpin_vpa_reset(kvm, &vcpu->arch.vpa);
> +		spin_unlock(&vcpu->arch.vpa_update_lock);
> +	}
> +
> +	ret = kvmppc_reinit_partition_table(kvm);
> +	if (ret)
> +		goto out;
> +
> +	kvm->arch.secure_guest = 0;

you need to do:

	kvm->arch.mmu_ready = mmu_was_ready;
 out_unlock:
	mutex_unlock(&kvm->arch.mmu_setup_lock);

> +out:
> +	return ret;
> +}
> +

With that extra check in place, it should be safe to unpin the vpas if
there is a good reason to do so.  ("Userspace has some bug that we
haven't found" isn't a good reason to do so.)

Paul.

