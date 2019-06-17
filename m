Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA05479CD
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 07:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbfFQF7A (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 17 Jun 2019 01:59:00 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37349 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbfFQF7A (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 17 Jun 2019 01:59:00 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45S0ry5xr9z9s7h; Mon, 17 Jun 2019 15:58:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560751138; bh=AtJPc/0VVu0H7tqiVN+mbcZUFjZD/6+l3t+jKYXhEdk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KfyFTV+K2P0IRnQjMacy99zQ2QMxWJgx15PYkFAlB2Lexxrybwm0AoTlfjfSYWSdB
         dom8i3XJrSjcJTo/SvAb90TrABAstD1FBbZr9vI2OBMfOq3qEvkj8j4K0Stw+NfG17
         lzLuKpkty2EryUl7PqyWtyUOY/u5CP4PQpDtgOzMSFzGtKAjzA+kuWRqcPLgEGUWZA
         ZzX3zMShiECtbaR4lAMG6GIgoK1O5pQXGXwLWD6N3sK2ZFyMgtqr3s/7ZIEkrxeGOO
         FweYEwg3e6RKAAo6G4GPCAZNiv2QpJSLh23qoBAW8n6IQIgeAaPbb8pWAnVe3VvGtg
         4Dtnsg0J+X0LA==
Date:   Mon, 17 Jun 2019 15:58:24 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: PPC: Book3S HV: Reject mflags=2 (LPCR[AIL]=2)
 ADDR_TRANS_MODE mode
Message-ID: <20190617055824.h6hkzbgp3h2cn3xg@oak.ozlabs.ibm.com>
References: <20190520005659.18628-1-npiggin@gmail.com>
 <20190520005659.18628-5-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520005659.18628-5-npiggin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, May 20, 2019 at 10:56:59AM +1000, Nicholas Piggin wrote:
> AIL=2 mode has no known users, so is not well tested or supported.
> Disallow guests from selecting this mode because it may become
> deprecated in future versions of the architecture.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Given that H_SET_MODE_RESOURCE_ADDR_TRANS_MODE gets punted to
userspace (QEMU), why are we enforcing this here rather than in QEMU?

If there is a reason to do this here rather than in QEMU, then the
patch description should really comment on why we're rejecting AIL=1
as well as AIL=2.

> ---
>  arch/powerpc/kvm/book3s_hv.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 36d16740748a..4295ccdbee26 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -784,6 +784,11 @@ static int kvmppc_h_set_mode(struct kvm_vcpu *vcpu, unsigned long mflags,
>  		vcpu->arch.dawr  = value1;
>  		vcpu->arch.dawrx = value2;
>  		return H_SUCCESS;
> +	case H_SET_MODE_RESOURCE_ADDR_TRANS_MODE:
> +		/* KVM does not support mflags=2 (AIL=2) */
> +		if (mflags != 0 && mflags != 3)
> +			return H_UNSUPPORTED_FLAG_START;
> +		return H_TOO_HARD;
>  	default:
>  		return H_TOO_HARD;
>  	}
> -- 
> 2.20.1

Paul.
