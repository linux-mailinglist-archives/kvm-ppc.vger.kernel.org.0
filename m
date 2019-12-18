Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91CD2123F2E
	for <lists+kvm-ppc@lfdr.de>; Wed, 18 Dec 2019 06:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfLRFgh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 18 Dec 2019 00:36:37 -0500
Received: from ozlabs.org ([203.11.71.1]:36423 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbfLRFgh (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 18 Dec 2019 00:36:37 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47d3fC3JrGz9sRs; Wed, 18 Dec 2019 16:36:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1576647395; bh=vkkInNqS+SwPpU3kaJCTXghI/oELZZ27t+qKvtMxzA8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P8P7Oc3Cp7HwjsBZTwpp+jcJ43wH03dnhYSwWHzKeY0UGpZvcz6RniJv3T23jYaCT
         zHQwSA1cLT/7NmuQBXAcmB29XKf8vZKlISVS0y1qCdwyGB5B8lzNFWCN3vLsxlYHYN
         AuaroncnYHWL+mqcNnlw+Dtf6dnQZsBiO8jxcXv6XPWVpxfnG4XWc8yJm4OuYk6l5w
         QmLPGj7IQ45+2Cn1tyCgBEQlY7FQWScOfIoiKDrWc0P9gIBLg2pVBew3gVQLGgpLaH
         c5x9SyHb1ah+r/S2fA3X6QQRZimPzu7Z0n9etxJ3dOhYReq34a6I/Sl4S2s51rwuJK
         7pyOvfzgPWmTQ==
Date:   Wed, 18 Dec 2019 16:36:32 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, linuxram@us.ibm.com,
        Bharata B Rao <bharata@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V3 2/2] KVM: PPC: Implement H_SVM_INIT_ABORT hcall
Message-ID: <20191218053632.GC29890@oak.ozlabs.ibm.com>
References: <20191215021104.GA27378@us.ibm.com>
 <20191215021208.GB27378@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215021208.GB27378@us.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Dec 14, 2019 at 06:12:08PM -0800, Sukadev Bhattiprolu wrote:
> 
> Implement the H_SVM_INIT_ABORT hcall which the Ultravisor can use to
> abort an SVM after it has issued the H_SVM_INIT_START and before the
> H_SVM_INIT_DONE hcalls. This hcall could be used when Ultravisor
> encounters security violations or other errors when starting an SVM.
> 
> Note that this hcall is different from UV_SVM_TERMINATE ucall which
> is used by HV to terminate/cleanup an VM that has becore secure.
> 
> The H_SVM_INIT_ABORT should basically undo operations that were done
> since the H_SVM_INIT_START hcall - i.e page-out all the VM pages back
> to normal memory, and terminate the SVM.
> 
> (If we do not bring the pages back to normal memory, the text/data
> of the VM would be stuck in secure memory and since the SVM did not
> go secure, its MSR_S bit will be clear and the VM wont be able to
> access its pages even to do a clean exit).
> 
> Based on patches and discussion with Paul Mackerras, Ram Pai and
> Bharata Rao.
> 
> Signed-off-by: Ram Pai <linuxram@linux.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Signed-off-by: Bharata B Rao <bharata@linux.ibm.com>

Minor comment below, but not a showstopper.  Also, as Bharata noted
you need to hold the srcu lock for reading.

> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		struct kvm_memory_slot *memslot;
> +		struct kvm_memslots *slots = __kvm_memslots(kvm, i);
> +
> +		if (!slots)
> +			continue;
> +
> +		kvm_for_each_memslot(memslot, slots)
> +			kvmppc_uvmem_drop_pages(memslot, kvm, false);
> +	}

Since we use the default KVM_ADDRESS_SPACE_NUM, which is 1, this code
isn't wrong but it is more verbose than it needs to be.  It could be

	kvm_for_each_memslot(kvm_memslots(kvm), slots)
		kvmppc_uvmem_drop_pages(memslot, kvm, false);

Paul.
