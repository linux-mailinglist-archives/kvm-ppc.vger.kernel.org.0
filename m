Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1E6F87A1
	for <lists+kvm-ppc@lfdr.de>; Tue, 12 Nov 2019 05:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKLE5o (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 11 Nov 2019 23:57:44 -0500
Received: from ozlabs.org ([203.11.71.1]:33123 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfKLE5n (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 11 Nov 2019 23:57:43 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47BwTx1MgVz9s7T;
        Tue, 12 Nov 2019 15:57:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1573534661;
        bh=uYip1D+O0qxvSAZmVsjreqWMMiJScHjb7OaWupdHy1g=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=qJqHaXsZbg6PKABCFV05/MmyEqiQsPpDwWDt6up2flx2qovaz+CWAnu/S0WsuT98t
         lNAsVa1BF5LiO9kCc26G9W3LXhkf7YVVdWEnnlrIumVzMUa9kgF0Pc/OwC/UTTKt6W
         EqWtowu61h10IHW+e4O1Fgozs/OKNJrMLOic+msejkuQJIXrnwrZhbcZnHIQaL1G/w
         bPmT8x1b3SkfF9/roKwbpCUCPjz02Dsymkwta7pTL3L5xj/XbG4io5fPyq3MFLSpIQ
         tLs5EHbAJv5ZXWZVowZpnHLNh+nrVyHVLS1g6OPoWA3NJj505bSJp8spFardUmlA1q
         Q2h++C5kh7ylg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Leonardo Bras <leonardo@linux.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc:     Leonardo Bras <leonardo@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 1/4] powerpc/kvm/book3s: Fixes possible 'use after release' of kvm
In-Reply-To: <20191107170258.36379-2-leonardo@linux.ibm.com>
References: <20191107170258.36379-1-leonardo@linux.ibm.com> <20191107170258.36379-2-leonardo@linux.ibm.com>
Date:   Tue, 12 Nov 2019 15:57:40 +1100
Message-ID: <87mud13d4r.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Hi Leonardo,

Leonardo Bras <leonardo@linux.ibm.com> writes:
> Fixes a possible 'use after free' of kvm variable in
> kvm_vm_ioctl_create_spapr_tce, where it does a mutex_unlock(&kvm->lock)
> after a kvm_put_kvm(kvm).

There is no potential for an actual use after free here AFAICS.

> diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
> index 5834db0a54c6..a402ead833b6 100644
> --- a/arch/powerpc/kvm/book3s_64_vio.c
> +++ b/arch/powerpc/kvm/book3s_64_vio.c

The preceeding context is:

	mutex_lock(&kvm->lock);

	/* Check this LIOBN hasn't been previously allocated */
	ret = 0;
	list_for_each_entry(siter, &kvm->arch.spapr_tce_tables, list) {
		if (siter->liobn == args->liobn) {
			ret = -EBUSY;
			break;
		}
	}

	kvm_get_kvm(kvm);
	if (!ret)
		ret = anon_inode_getfd("kvm-spapr-tce", &kvm_spapr_tce_fops,
				       stt, O_RDWR | O_CLOEXEC);

> @@ -316,14 +316,13 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
>  
>  	if (ret >= 0)
>  		list_add_rcu(&stt->list, &kvm->arch.spapr_tce_tables);
> -	else
> -		kvm_put_kvm(kvm);
>  
>  	mutex_unlock(&kvm->lock);
>  
>  	if (ret >= 0)
>  		return ret;
>  
> +	kvm_put_kvm(kvm);
>  	kfree(stt);
>   fail_acct:
>  	account_locked_vm(current->mm, kvmppc_stt_pages(npages), false);


If the kvm_put_kvm() you've moved actually caused the last reference to
be dropped that would mean that our caller had passed us a kvm struct
without holding a reference to it, and that would be a bug in our
caller.

Or put another way, it would mean the mutex_lock() above could already
be operating on a freed kvm struct.

The kvm_get_kvm() prior to the anon_inode_getfd() is to account for the
reference that's held by the `stt` struct, and dropped in
kvm_spapr_tce_release().

So although this patch isn't wrong, the explanation is not accurate.

cheers
