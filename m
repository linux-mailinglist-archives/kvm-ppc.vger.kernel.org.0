Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C302D5948
	for <lists+kvm-ppc@lfdr.de>; Thu, 10 Dec 2020 12:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389534AbgLJLbs (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 10 Dec 2020 06:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389531AbgLJLbJ (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 10 Dec 2020 06:31:09 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD485C061282
        for <kvm-ppc@vger.kernel.org>; Thu, 10 Dec 2020 03:30:22 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4CsBY81BFDz9shl; Thu, 10 Dec 2020 22:30:19 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     Mahesh Salgaonkar <mahesh@linux.ibm.com>, kvm-ppc@vger.kernel.org
In-Reply-To: <20201128070728.825934-1-npiggin@gmail.com>
References: <20201128070728.825934-1-npiggin@gmail.com>
Subject: Re: [PATCH 0/8] powerpc/64s: fix and improve machine check handling
Message-Id: <160756607429.1313423.15187936842862654777.b4-ty@ellerman.id.au>
Date:   Thu, 10 Dec 2020 22:30:19 +1100 (AEDT)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, 28 Nov 2020 17:07:20 +1000, Nicholas Piggin wrote:
> First patch is a nasty memory scribble introduced by me :( That
> should go into fixes.
> 
> The next ones could wait for next merge window. They get things to the
> point where misbehaving or buggy guest isn't so painful for the host,
> and also get the guest SLB dumping code working (because the host no
> longer clears them before delivering the MCE to the guest).
> 
> [...]

Patches 2-8 applied to powerpc/next.

[2/8] powerpc/64s/powernv: Allow KVM to handle guest machine check details
      https://git.kernel.org/powerpc/c/0ce2382657f39ced2adbb927355360c3aaeb05f8
[3/8] KVM: PPC: Book3S HV: Don't attempt to recover machine checks for FWNMI enabled guests
      https://git.kernel.org/powerpc/c/067c9f9c98c8804b07751994c51d8557e440821e
[4/8] KVM: PPC: Book3S HV: Ratelimit machine check messages coming from guests
      https://git.kernel.org/powerpc/c/1d15ffdfc94127d75e04a88344ee1ce8c79f05fd
[5/8] powerpc/64s/powernv: Ratelimit harmless HMI error printing
      https://git.kernel.org/powerpc/c/f4b239e4c6bddf63d00cd460eabb933232dbc326
[6/8] powerpc/64s/pseries: Add ERAT specific machine check handler
      https://git.kernel.org/powerpc/c/82f70a05108c98aea4f140067c44a606262d2af7
[7/8] powerpc/64s: Remove "Host" from MCE logging
      https://git.kernel.org/powerpc/c/4a869531ddbf5939c45eab6ff389e4e58c8ed19c
[8/8] powerpc/64s: Tidy machine check SLB logging
      https://git.kernel.org/powerpc/c/865ae6f27789dcc3f92341d935f4439e8730a9fe

cheers
