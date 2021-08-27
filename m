Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9C83F99EB
	for <lists+kvm-ppc@lfdr.de>; Fri, 27 Aug 2021 15:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245304AbhH0NXx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 27 Aug 2021 09:23:53 -0400
Received: from ozlabs.org ([203.11.71.1]:43997 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245305AbhH0NXj (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Fri, 27 Aug 2021 09:23:39 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gx0kx4Wypz9t0T;
        Fri, 27 Aug 2021 23:22:49 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20210811160134.904987-1-npiggin@gmail.com>
References: <20210811160134.904987-1-npiggin@gmail.com>
Subject: Re: (subset) [PATCH v2 00/60] KVM: PPC: Book3S HV P9: entry/exit optimisations
Message-Id: <163007018125.52768.7502212191984719774.b4-ty@ellerman.id.au>
Date:   Fri, 27 Aug 2021 23:16:21 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 12 Aug 2021 02:00:34 +1000, Nicholas Piggin wrote:
> This reduces radix guest full entry/exit latency on POWER9 and POWER10
> by 2x.
> 
> Nested HV guests should see smaller improvements in their L1 entry/exit,
> but this is also combined with most L0 speedups also applying to nested
> entry. nginx localhost throughput test in a SMP nested guest is improved
> about 10% (in a direct guest it doesn't change much because it uses XIVE
> for IPIs) when L0 and L1 are patched.
> 
> [...]

Applied to powerpc/next.

[01/60] KVM: PPC: Book3S HV: Initialise vcpu MSR with MSR_ME
        https://git.kernel.org/powerpc/c/fd42b7b09c602c904452c0c3e5955ca21d8e387a
[02/60] KVM: PPC: Book3S HV: Remove TM emulation from POWER7/8 path
        https://git.kernel.org/powerpc/c/daac40e8d7a63ab8608132a7cfce411986feac32
[03/60] KVM: PPC: Book3S HV P9: Fixes for TM softpatch interrupt NIP
        https://git.kernel.org/powerpc/c/4782e0cd0d184d727ad3b0cfe20d1d44d9f98239
[04/60] KVM: PPC: Book3S HV Nested: Fix TM softpatch HFAC interrupt emulation
        https://git.kernel.org/powerpc/c/d82b392d9b3556b63e3f9916cf057ea847e173a9
[05/60] KVM: PPC: Book3S HV Nested: Sanitise vcpu registers
        https://git.kernel.org/powerpc/c/7487cabc7ed2f7716bf304e4e97c57fd995cf70e
[06/60] KVM: PPC: Book3S HV Nested: Make nested HFSCR state accessible
        https://git.kernel.org/powerpc/c/8b210a880b35ba75eb42b79dfd65e369c1feb119
[07/60] KVM: PPC: Book3S HV Nested: Stop forwarding all HFUs to L1
        https://git.kernel.org/powerpc/c/7c3ded5735141ff4d049747c9f76672a8b737c49
[08/60] KVM: PPC: Book3S HV Nested: save_hv_return_state does not require trap argument
        https://git.kernel.org/powerpc/c/f2e29db156523bf08a0524e0f4306a641912c6d9
[09/60] KVM: PPC: Book3S HV Nested: Reflect guest PMU in-use to L0 when guest SPRs are live
        https://git.kernel.org/powerpc/c/1782663897945a5cf28e564ba5eed730098e9aa4
[10/60] powerpc/64s: Remove WORT SPR from POWER9/10
        https://git.kernel.org/powerpc/c/0c8fb653d487d2873f5eefdcaf4cecff4e103828

cheers
