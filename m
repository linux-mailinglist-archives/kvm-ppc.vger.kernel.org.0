Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2461E48106
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 13:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbfFQLkc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Jun 2019 07:40:32 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45357 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbfFQLkc (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 17 Jun 2019 07:40:32 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45S8R20PQhz9sN4; Mon, 17 Jun 2019 21:40:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560771630; bh=pe40tL5T//Cdv5V4JOy8kcLgPfD9Purq8iaqBesMDHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rKeCugmmWeEJbRtz9mLpNlMi3sE/LI0l748XJalN2FRBr1I7VWNPs5QxKq9uM0ceX
         A0NdBTeSIBR+qmExiKilbnGCXD6yCvb76eSWEHF+D0NoCJgrJSeWJFazJIX5MmJHks
         Qdw/HXTRCCQoR5hQlvaPCrFngw0ikPmMxhEEEX6VOtrd1BU/3lm7Vrv0NFRXsVRttx
         pWYZMBtLkwtcgXsKsa3NlOs4ucM5vsGtmpfnB04XjymzJ0K45i2xzGwXDjB+ighfIZ
         VaSvQO+SzqKjmlLqczF2eC/TMqq5AVo70IsD5em2hU85MWwJZ7Q49VqeBawcrf1Neb
         l4efZafy2IXgg==
Date:   Mon, 17 Jun 2019 16:33:25 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Fabiano Rosas <farosas@linux.ibm.com>
Cc:     kvm-ppc@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] KVM: PPC: Remove leftover comment from
 emulate_loadstore.c
Message-ID: <20190617063325.4jq36sij2nnmwifj@oak.ozlabs.ibm.com>
References: <20190530171014.1733-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530171014.1733-1-farosas@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, May 30, 2019 at 02:10:14PM -0300, Fabiano Rosas wrote:
> The mmio_vsx_tx_sx_enabled field was removed but its documentation was
> left behind.
> 
> 4eeb85568e56 KVM: PPC: Remove mmio_vsx_tx_sx_enabled in KVM MMIO
> emulation
> 
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  arch/powerpc/kvm/emulate_loadstore.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
> index f91b1309a0a8..806dbc439131 100644
> --- a/arch/powerpc/kvm/emulate_loadstore.c
> +++ b/arch/powerpc/kvm/emulate_loadstore.c
> @@ -100,12 +100,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
>  	rs = get_rs(inst);
>  	rt = get_rt(inst);
>  
> -	/*
> -	 * if mmio_vsx_tx_sx_enabled == 0, copy data between
> -	 * VSR[0..31] and memory
> -	 * if mmio_vsx_tx_sx_enabled == 1, copy data between
> -	 * VSR[32..63] and memory
> -	 */
>  	vcpu->arch.mmio_vsx_copy_nums = 0;
>  	vcpu->arch.mmio_vsx_offset = 0;
>  	vcpu->arch.mmio_copy_type = KVMPPC_VSX_COPY_NONE;

Thanks, applied to my kvm-ppc-next branch.

Paul.
