Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E529E34F7CE
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhCaEVL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:21:11 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34057 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhCaEU4 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 31 Mar 2021 00:20:56 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9CmR4SpFz9sCD; Wed, 31 Mar 2021 15:20:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617164455; bh=R5yeQfItJMYJlpFnCudzTg5QYDa/YjngEkHJnRuWw24=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lU/T7acfin8IYqJfb+++vclSDcW2I1lHSIk9+QvAaBa9rNeVKr1ABIYu7rxRp4pQC
         fG8R74l2lH3y3WozkdFqc/OUGAAdThLrsAm7wEc3oEoHkjOb4UKmGYEMUNQZdXTVWC
         Q+qiRMCZinlFkrjI9ZBdPiFJeGeUKLnhOGsGNzHgxZ25ps+YKWSPV1YsBzhX/EStjh
         jqwOQ/5R+dCp+Hgf1atBhkF7UXvfQOLxnrM19bZC5ur0WxLTIPOmskRVZYNeji03p7
         Kpc+vU4eckCAaRJL5fXDKdhtNcBEKFF2si0+vfA5fYWeeWUnPMAnntL8oL3F+Ls9IH
         Sft1LhM8EqtmQ==
Date:   Wed, 31 Mar 2021 15:08:25 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 02/46] KVM: PPC: Book3S HV: Add a function to filter
 guest LPCR bits
Message-ID: <YGP1uXH5q72auwP7@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-3-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-3-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:21AM +1000, Nicholas Piggin wrote:
> Guest LPCR depends on hardware type, and future changes will add
> restrictions based on errata and guest MMU mode. Move this logic
> to a common function and use it for the cases where the guest
> wants to update its LPCR (or the LPCR of a nested guest).

[snip]

> @@ -4641,8 +4662,9 @@ void kvmppc_update_lpcr(struct kvm *kvm, unsigned long lpcr, unsigned long mask)
>  		struct kvmppc_vcore *vc = kvm->arch.vcores[i];
>  		if (!vc)
>  			continue;
> +
>  		spin_lock(&vc->lock);
> -		vc->lpcr = (vc->lpcr & ~mask) | lpcr;
> +		vc->lpcr = kvmppc_filter_lpcr_hv(vc, (vc->lpcr & ~mask) | lpcr);

This change seems unnecessary, since kvmppc_update_lpcr is called only
to update MMU configuration bits, not as a result of any action by
userspace or a nested hypervisor.  It's also beyond the scope of what
was mentioned in the commit message.

Paul.
