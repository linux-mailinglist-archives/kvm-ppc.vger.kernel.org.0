Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E88677E7
	for <lists+kvm-ppc@lfdr.de>; Sat, 13 Jul 2019 05:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfGMDr4 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 12 Jul 2019 23:47:56 -0400
Received: from ozlabs.org ([203.11.71.1]:35353 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727466AbfGMDr4 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 12 Jul 2019 23:47:56 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45lwjj75Vwz9sNf;
        Sat, 13 Jul 2019 13:47:53 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, paulus@ozlabs.org,
        sjitindarsingh@gmail.com
Subject: Re: [PATCH 1/3] KVM: PPC: Book3S HV: Always save guest pmu for guest capable of nesting
In-Reply-To: <20190703012022.15644-1-sjitindarsingh@gmail.com>
References: <20190703012022.15644-1-sjitindarsingh@gmail.com>
Date:   Sat, 13 Jul 2019 13:47:51 +1000
Message-ID: <87lfx2egt4.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
> The performance monitoring unit (PMU) registers are saved on guest exit
> when the guest has set the pmcregs_in_use flag in its lppaca, if it
> exists, or unconditionally if it doesn't. If a nested guest is being
> run then the hypervisor doesn't, and in most cases can't, know if the
> pmu registers are in use since it doesn't know the location of the lppaca
> for the nested guest, although it may have one for its immediate guest.
> This results in the values of these registers being lost across nested
> guest entry and exit in the case where the nested guest was making use
> of the performance monitoring facility while it's nested guest hypervisor
> wasn't.
>
> Further more the hypervisor could interrupt a guest hypervisor between
> when it has loaded up the pmu registers and it calling H_ENTER_NESTED or
> between returning from the nested guest to the guest hypervisor and the
> guest hypervisor reading the pmu registers, in kvmhv_p9_guest_entry().
> This means that it isn't sufficient to just save the pmu registers when
> entering or exiting a nested guest, but that it is necessary to always
> save the pmu registers whenever a guest is capable of running nested guests
> to ensure the register values aren't lost in the context switch.
>
> Ensure the pmu register values are preserved by always saving their
> value into the vcpu struct when a guest is capable of running nested
> guests.
>
> This should have minimal performance impact however any impact can be
> avoided by booting a guest with "-machine pseries,cap-nested-hv=false"
> on the qemu commandline.
>
> Fixes: 95a6432ce903 "KVM: PPC: Book3S HV: Streamlined guest entry/exit path on P9 for radix guests"

I'm not clear why this and the next commit are marked as fixing the
above commit. Wasn't it broken prior to that commit as well?

cheers

> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index ec1804f822af..b682a429f3ef 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3654,6 +3654,8 @@ int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>  		vcpu->arch.vpa.dirty = 1;
>  		save_pmu = lp->pmcregs_in_use;
>  	}
> +	/* Must save pmu if this guest is capable of running nested guests */
> +	save_pmu |= nesting_enabled(vcpu->kvm);
>  
>  	kvmhv_save_guest_pmu(vcpu, save_pmu);
>  
> -- 
> 2.13.6
