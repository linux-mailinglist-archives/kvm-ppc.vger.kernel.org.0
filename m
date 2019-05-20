Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C8C22C32
	for <lists+kvm-ppc@lfdr.de>; Mon, 20 May 2019 08:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbfETGhu (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 20 May 2019 02:37:50 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49419 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbfETGht (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 20 May 2019 02:37:49 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 456q2g3Df9z9s6w; Mon, 20 May 2019 16:37:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1558334267; bh=PNedFHkkuQzcJ3wxJ8NC9BpfSFJPvCUXblZ49yZlqsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KlUgt4MgHd3B8BHlYvJ2B1gzSvJM5w7HGDLClWT9F190UJn1IloBUPOZdMcPw9+1i
         zduKxRZi2RjwJM5k936+UYMn7/H+DusJij3vatSXygoObqaymBjdmfqet6hUoVGRni
         7spLAe9pxOhQj8ZCrAFBHEhlcKXgQ6vNiyOdQ5WvU+PZgketpJNY7Bl36mHEarVHQz
         0ph0ZY8SU5KVxWkNzq3kncx1aJ7PS4TIrq4HHi5MDl974BZpb4cUdphDLRRrA4OTgK
         C3038eCuD+OaBnDfRpgoamTfRdVbPfpd62pS9MSobzdz/Tdzw10THIWNKXoROlcAuy
         fFhBGDEaNpFZw==
Date:   Mon, 20 May 2019 16:17:00 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Ram Pai <linuxram@us.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: Re: [RFC PATCH v2 08/10] KVM: PPC: Ultravisor: Return to UV for
 hcalls from SVM
Message-ID: <20190520061700.GC21382@blackberry>
References: <20190518142524.28528-1-cclaudio@linux.ibm.com>
 <20190518142524.28528-9-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190518142524.28528-9-cclaudio@linux.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, May 18, 2019 at 11:25:22AM -0300, Claudio Carvalho wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> 
> All hcalls from a secure VM go to the ultravisor from where they are
> reflected into the HV. When we (HV) complete processing such hcalls,
> we should return to the UV rather than to the guest kernel.

This paragraph in the patch description, and the comment in
book3s_hv_rmhandlers.S, are confusing and possibly misleading in
focussing on returns from hcalls, when the change is needed for any
sort of entry to the guest from the hypervisor, whether it is a return
from an hcall, a return from a hypervisor interrupt, or the first time
that a guest vCPU is run.

This paragraph needs to explain that to enter a secure guest, we have
to go through the ultravisor, therefore we do a ucall when we are
entering a secure guest.

[snip]

> +/*
> + * The hcall we just completed was from Ultravisor. Use UV_RETURN
> + * ultra call to return to the Ultravisor. Results from the hcall
> + * are already in the appropriate registers (r3:12), except for
> + * R6,7 which we used as temporary registers above. Restore them,
> + * and set R0 to the ucall number (UV_RETURN).
> + */

This needs to say something like "We are entering a secure guest, so
we have to invoke the ultravisor to do that.  If we are returning from
a hcall, the results are already ...".

> +ret_to_ultra:
> +	lwz	r6, VCPU_CR(r4)
> +	mtcr	r6
> +	LOAD_REG_IMMEDIATE(r0, UV_RETURN)
> +	ld	r7, VCPU_GPR(R7)(r4)
> +	ld	r6, VCPU_GPR(R6)(r4)
> +	ld	r4, VCPU_GPR(R4)(r4)
> +	sc	2
>  
>  /*
>   * Enter the guest on a P9 or later system where we have exactly
> -- 
> 2.20.1

Paul.
