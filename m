Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCB512802
	for <lists+kvm-ppc@lfdr.de>; Fri,  3 May 2019 08:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfECGuH (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 3 May 2019 02:50:07 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43061 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbfECGuF (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 3 May 2019 02:50:05 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 44wN6g3cqXz9sBr; Fri,  3 May 2019 16:50:03 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 10d91611f426d4bafd2a83d966c36da811b2f7ad
X-Patchwork-Hint: ignore
In-Reply-To: <20190412143053.18567-1-npiggin@gmail.com>
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     "Gautham R . Shenoy" <ego@linux.vnet.ibm.com>,
        kvm-ppc@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v9 1/2] powerpc/64s: reimplement book3s idle code in C
Message-Id: <44wN6g3cqXz9sBr@ozlabs.org>
Date:   Fri,  3 May 2019 16:50:03 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 2019-04-12 at 14:30:52 UTC, Nicholas Piggin wrote:
> Reimplement Book3S idle code in C, moving POWER7/8/9 implementation
> speific HV idle code to the powernv platform code.
> 
> Book3S assembly stubs are kept in common code and used only to save
> the stack frame and non-volatile GPRs before executing architected
> idle instructions, and restoring the stack and reloading GPRs then
> returning to C after waking from idle.
> 
> The complex logic dealing with threads and subcores, locking, SPRs,
> HMIs, timebase resync, etc., is all done in C which makes it more
> maintainable.
> 
> This is not a strict translation to C code, there are some
> significant differences:
> 
> - Idle wakeup no longer uses the ->cpu_restore call to reinit SPRs,
>   but saves and restores them itself.
> 
> - The optimisation where EC=ESL=0 idle modes did not have to save GPRs
>   or change MSR is restored, because it's now simple to do. ESL=1
>   sleeps that do not lose GPRs can use this optimization too.
> 
> - KVM secondary entry and cede is now more of a call/return style
>   rather than branchy. nap_state_lost is not required because KVM
>   always returns via NVGPR restoring path.
> 
> - KVM secondary wakeup from offline sequence is moved entirely into
>   the offline wakeup, which avoids a hwsync in the normal idle wakeup
>   path.
> 
> Performance measured with context switch ping-pong on different
> threads or cores, is possibly improved a small amount, 1-3% depending
> on stop state and core vs thread test for shallow states. Deep states
> it's in the noise compared with other latencies.
> 
> Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Applied to powerpc topic/ppc-kvm, thanks.

https://git.kernel.org/powerpc/c/10d91611f426d4bafd2a83d966c36da8

cheers
