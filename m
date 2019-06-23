Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914744FB1B
	for <lists+kvm-ppc@lfdr.de>; Sun, 23 Jun 2019 12:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfFWKe1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 23 Jun 2019 06:34:27 -0400
Received: from ozlabs.org ([203.11.71.1]:52113 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbfFWKe1 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 23 Jun 2019 06:34:27 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 45Wph05wlrz9sBp; Sun, 23 Jun 2019 20:34:24 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 50087112592016a3fc10b394a55f1f1a1bde6908
X-Patchwork-Hint: ignore
In-Reply-To: <20190620014651.7645-1-sjitindarsingh@gmail.com>
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     clg@kaod.org, kvm-ppc@vger.kernel.org, sjitindarsingh@gmail.com
Subject: Re: [PATCH 1/3] KVM: PPC: Book3S HV: Invalidate ERAT when flushing guest TLB entries
Message-Id: <45Wph05wlrz9sBp@ozlabs.org>
Date:   Sun, 23 Jun 2019 20:34:24 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 2019-06-20 at 01:46:49 UTC, Suraj Jitindar Singh wrote:
> When a guest vcpu moves from one physical thread to another it is
> necessary for the host to perform a tlb flush on the previous core if
> another vcpu from the same guest is going to run there. This is because the
> guest may use the local form of the tlb invalidation instruction meaning
> stale tlb entries would persist where it previously ran. This is handled
> on guest entry in kvmppc_check_need_tlb_flush() which calls
> flush_guest_tlb() to perform the tlb flush.
> 
> Previously the generic radix__local_flush_tlb_lpid_guest() function was
> used, however the functionality was reimplemented in flush_guest_tlb()
> to avoid the trace_tlbie() call as the flushing may be done in real
> mode. The reimplementation in flush_guest_tlb() was missing an erat
> invalidation after flushing the tlb.
> 
> This lead to observable memory corruption in the guest due to the
> caching of stale translations. Fix this by adding the erat invalidation.
> 
> Fixes: 70ea13f6e609 "KVM: PPC: Book3S HV: Flush TLB on secondary radix threads"
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

Applied to powerpc fixes, thanks.

https://git.kernel.org/powerpc/c/50087112592016a3fc10b394a55f1f1a1bde6908

cheers
