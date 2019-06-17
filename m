Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C90477C7
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 03:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfFQBsS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 16 Jun 2019 21:48:18 -0400
Received: from ozlabs.org ([203.11.71.1]:47671 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbfFQBsS (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 16 Jun 2019 21:48:18 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45RvHg660sz9s3l; Mon, 17 Jun 2019 11:48:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560736095; bh=UM3NuONXhbeKpfzH5/zyknABvRupBX6dfLItyTzs8CI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=APAy26VdmGVwaJqa1w2GMxBSw91pBbxy0M7YcZERn/YTUVzTGreAMFkwjDRxqVdhb
         ohjJmg2lzBr5IdVb5xea46dCYE3Ee8/HcJIjWghnzD2Fkw/HeEmIpnD19l9ETRra38
         ydjHpgIGBc9FaSyOv3WSGenUHqIv4P4D7f4S2g0jMrGfM4P4aIc6DqgJGM5DgyYkly
         xFs+XynFcWffIryjtN2fbQpRiyx0qCpG24FqYwRIcp4bp1oOo5VqGKcObC4TDUVMZE
         cnbWjReq/RNXXs60Oy2oP81a3w1S3KKh+eibSdW0Xkr3fyW2eE2Hj5lBwUoRgnakWA
         e3u2rWFGaAG+A==
Date:   Mon, 17 Jun 2019 11:45:27 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 3/5] KVM: PPC: Book3S HV: Reuse kvmppc_inject_interrupt
 for async guest delivery
Message-ID: <20190617014527.dlbhru4tads7tdhc@oak.ozlabs.ibm.com>
References: <20190520005659.18628-1-npiggin@gmail.com>
 <20190520005659.18628-3-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520005659.18628-3-npiggin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, May 20, 2019 at 10:56:57AM +1000, Nicholas Piggin wrote:
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Comment below...

> diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
> index 6035d24f1d1d..5ae7f8359368 100644
> --- a/arch/powerpc/kvm/book3s_hv_builtin.c
> +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
> @@ -758,6 +758,53 @@ void kvmhv_p9_restore_lpcr(struct kvm_split_mode *sip)
>  	local_paca->kvm_hstate.kvm_split_mode = NULL;
>  }
>  
> +static void kvmppc_end_cede(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.ceded = 0;
> +	if (vcpu->arch.timer_running) {
> +		hrtimer_try_to_cancel(&vcpu->arch.dec_timer);

So now we're potentially calling hrtimer_try_to_cancel in real mode.
Are you absolutely sure that nothing in the hrtimer code accesses
anything that is vmalloc'd?  I'm not.  Maybe you can prove that when
called in real mode, vcpu->arch.timer_running will always be false,
but it seems fragile to me.

Paul.
