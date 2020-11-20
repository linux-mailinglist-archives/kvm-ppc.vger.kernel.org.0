Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1C52BA2C7
	for <lists+kvm-ppc@lfdr.de>; Fri, 20 Nov 2020 08:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKTHAk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 20 Nov 2020 02:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgKTHAk (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 20 Nov 2020 02:00:40 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA79C0613CF
        for <kvm-ppc@vger.kernel.org>; Thu, 19 Nov 2020 23:00:39 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4CcnW9513Qz9sTL; Fri, 20 Nov 2020 18:00:37 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm-ppc@vger.kernel.org
In-Reply-To: <20201117135617.3521127-1-npiggin@gmail.com>
References: <20201117135617.3521127-1-npiggin@gmail.com>
Subject: Re: [PATCH] powerpc/64s/exception: KVM Fix for host DSI being taken in HPT guest MMU context
Message-Id: <160585562627.1117366.9794270499881106934.b4-ty@ellerman.id.au>
Date:   Fri, 20 Nov 2020 18:00:37 +1100 (AEDT)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 17 Nov 2020 23:56:17 +1000, Nicholas Piggin wrote:
> Commit 2284ffea8f0c ("powerpc/64s/exception: Only test KVM in SRR
> interrupts when PR KVM is supported") removed KVM guest tests from
> interrupts that do not set HV=1, when PR-KVM is not configured.
> 
> This is wrong for HV-KVM HPT guest MMIO emulation case which attempts
> to load the faulting instruction word with MSR[DR]=1 and MSR[HV]=1 with
> the guest MMU context loaded. This can cause host DSI, DSLB interrupts
> which must test for KVM guest. Restore this and add a comment.

Applied to powerpc/fixes.

[1/1] powerpc/64s/exception: KVM Fix for host DSI being taken in HPT guest MMU context
      https://git.kernel.org/powerpc/c/cd81acc600a9684ea4b4d25a47900d38a3890eab

cheers
