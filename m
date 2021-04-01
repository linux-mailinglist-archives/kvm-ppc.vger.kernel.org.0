Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFCA350E81
	for <lists+kvm-ppc@lfdr.de>; Thu,  1 Apr 2021 07:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhDAFmL (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 1 Apr 2021 01:42:11 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:48743 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhDAFlt (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 1 Apr 2021 01:41:49 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9sWH5jg5z9s1l; Thu,  1 Apr 2021 16:41:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617255707; bh=wr1Uv5X9gRQte7XjxSM4uvrWDpXTMCsWYTlSf8nDGoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LqPTHOsqdcb+aYuWf9n3Wvj7rxIeQ8ArR5mhCAc+Y/V28vIwftXnZpbDCn+PZgWI4
         nHihrJrM2Se6CuVO8E8m7l5IKoMnc5Sez7FPHWUIYoDZ6+A9DtDf/jt4saEIjj1/xN
         dHi2Nvi6AmrOVTS7Xchv39621M5jQs8sZyBKQQ3cgt8Zaft7KmN20YZJ9WUoW0Q58X
         VMzvk/VRKcSRdzhXlupCP/5LNTkvni8MVlI7qNPT25ezOq8J/89AZ7KYh/aBohV7f3
         IHra0jyxd1IvM9E7rmbRI/4P2+xiQJ7sX0rXFLgeYp4BWNCx9ya9qoDhy3YQta5GVn
         wky5W8n9Red6A==
Date:   Thu, 1 Apr 2021 16:41:42 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 15/46] KVM: PPC: Book3S 64: Move hcall early register
 setup to KVM
Message-ID: <YGVdFrsEtD88oB90@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-16-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-16-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:34AM +1000, Nicholas Piggin wrote:
> System calls / hcalls have a different calling convention than
> other interrupts, so there is code in the KVMTEST to massage these
> into the same form as other interrupt handlers.
> 
> Move this work into the KVM hcall handler. This means teaching KVM
> a little more about the low level interrupt handler setup, PACA save
> areas, etc., although that's not obviously worse than the current
> approach of coming up with an entirely different interrupt register
> / save convention.

[snip]

> @@ -1964,29 +1948,8 @@ EXC_VIRT_END(system_call, 0x4c00, 0x100)
>  
>  #ifdef CONFIG_KVM_BOOK3S_64_HANDLER
>  TRAMP_REAL_BEGIN(system_call_kvm)
> -	/*
> -	 * This is a hcall, so register convention is as above, with these
> -	 * differences:

I haven't checked all the code changes in detail yet, but this comment
at least is slightly misleading, since under PR KVM, system calls (to
the guest kernel) and hypercalls both come through this path.

Paul.
