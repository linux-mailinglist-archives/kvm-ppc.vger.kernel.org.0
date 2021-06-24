Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA7C3B309C
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 15:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhFXOCP (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 10:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbhFXOCP (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 24 Jun 2021 10:02:15 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD0CC061756
        for <kvm-ppc@vger.kernel.org>; Thu, 24 Jun 2021 06:59:56 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4G9hbF25YMz9sX1; Thu, 24 Jun 2021 23:59:53 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20210602040441.3984352-1-npiggin@gmail.com>
References: <20210602040441.3984352-1-npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix TLB management on SMT8 POWER9 and POWER10 processors
Message-Id: <162454315598.2927609.4257910816986735296.b4-ty@ellerman.id.au>
Date:   Thu, 24 Jun 2021 23:59:15 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 2 Jun 2021 14:04:41 +1000, Nicholas Piggin wrote:
> The POWER9 vCPU TLB management code assumes all threads in a core share
> a TLB, and that TLBIEL execued by one thread will invalidate TLBs for
> all threads. This is not the case for SMT8 capable POWER9 and POWER10
> (big core) processors, where the TLB is split between groups of threads.
> This results in TLB multi-hits, random data corruption, etc.
> 
> Fix this by introducing cpu_first_tlb_thread_sibling etc., to determine
> which siblings share TLBs, and use that in the guest TLB flushing code.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3S HV: Fix TLB management on SMT8 POWER9 and POWER10 processors
      https://git.kernel.org/powerpc/c/77bbbc0cf84834ed130838f7ac1988567f4d0288

cheers
