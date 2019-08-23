Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5409A66C
	for <lists+kvm-ppc@lfdr.de>; Fri, 23 Aug 2019 06:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbfHWEAI (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 23 Aug 2019 00:00:08 -0400
Received: from ozlabs.org ([203.11.71.1]:42699 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbfHWEAH (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 23 Aug 2019 00:00:07 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46F72s37ZNz9sBp; Fri, 23 Aug 2019 14:00:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1566532805; bh=mNtdsViEFCyavtDiwsHTDK9xXch9sH1Vg8FJtRYNWO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TiSuWrKvb8jY5ggylKlgo6MZ25p+tSAZtqIluxy8K+FsmhgL/OEBUqDzdVUnHfEAk
         YyMUpt1SNIyDCfVOon2irmWAbPfmMEfRRxw3VrmZDfyqMM7EZ9I4gJn7lK8LbTnh/A
         Q2srBonqZZYrUEHlsFv768NVLLI54CiaISYERWt+G4i2BJHYiulEO3/ztD2yz9eEAe
         ABTQGZp7QKhTXSaOrTX7PEnwrbvu9wt2SLBFpeORB77isa9x+yQuoIBjrvnnr3ZSYF
         hraIZKTnsRvoZqiGMBLReMsGnHuZZXKRYW12rcYgoDJ7nq+Cg3yAwWgvVf3q2O6hh3
         rItA7KzAHpyBA==
Date:   Fri, 23 Aug 2019 13:59:58 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     linuxppc-dev@ozlabs.org, kvm-ppc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Michael Anderson <andmike@linux.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Thiago Bauermann <bauerman@linux.ibm.com>,
        Ryan Grimm <grimm@linux.ibm.com>,
        Guerney Hunt <gdhh@linux.ibm.com>
Subject: Re: [PATCH v6 7/7] powerpc/kvm: Use UV_RETURN ucall to return to
 ultravisor
Message-ID: <20190823035958.tqpdtck2pl3foq5i@oak.ozlabs.ibm.com>
References: <20190822034838.27876-1-cclaudio@linux.ibm.com>
 <20190822034838.27876-8-cclaudio@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822034838.27876-8-cclaudio@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, Aug 22, 2019 at 12:48:38AM -0300, Claudio Carvalho wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> 
> When an SVM makes an hypercall or incurs some other exception, the
> Ultravisor usually forwards (a.k.a. reflects) the exceptions to the
> Hypervisor. After processing the exception, Hypervisor uses the
> UV_RETURN ultracall to return control back to the SVM.
> 
> The expected register state on entry to this ultracall is:
> 
> * Non-volatile registers are restored to their original values.
> * If returning from an hypercall, register R0 contains the return value
>   (unlike other ultracalls) and, registers R4 through R12 contain any
>   output values of the hypercall.
> * R3 contains the ultracall number, i.e UV_RETURN.
> * If returning with a synthesized interrupt, R2 contains the
>   synthesized interrupt number.

This isn't accurate: R2 contains the value that should end up in SRR1
when we are back in the secure guest.  HSRR0 and HSRR1 contain the
instruction pointer and MSR that the guest should run with.  They may
be different from the instruction pointer and MSR that the guest vCPU
last had, if the hypervisor has synthesized an interrupt for the
guest.  The ultravisor needs to detect this case and respond
appropriately.

> Thanks to input from Paul Mackerras, Ram Pai and Mike Anderson.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Signed-off-by: Claudio Carvalho <cclaudio@linux.ibm.com>

Apart from that comment on the patch description -

Acked-by: Paul Mackerras <paulus@ozlabs.org>
