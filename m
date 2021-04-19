Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC82D3639FE
	for <lists+kvm-ppc@lfdr.de>; Mon, 19 Apr 2021 06:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237426AbhDSEFX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 19 Apr 2021 00:05:23 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:52459 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237453AbhDSEFC (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 19 Apr 2021 00:05:02 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FNtVj1sHCz9vHY; Mon, 19 Apr 2021 14:04:28 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
Subject: Re: [PATCH v1 00/12] minor KVM fixes and cleanups
Message-Id: <161880479451.1398509.3440383363531390198.b4-ty@ellerman.id.au>
Date:   Mon, 19 Apr 2021 13:59:54 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 12 Apr 2021 11:48:33 +1000, Nicholas Piggin wrote:
> Here is the first batch of patches are extracted from the patches of the
> KVM C conversion series, plus one new fix (host CTRL not restored) since
> v6 was posted.
> 
> Please consider for merging.
> 
> Thanks,
> Nick
> 
> [...]

Applied to powerpc/next.

[01/12] KVM: PPC: Book3S HV P9: Restore host CTRL SPR after guest exit
        https://git.kernel.org/powerpc/c/5088eb4092df12d701af8e0e92860b7186365279
[02/12] KVM: PPC: Book3S HV: Nested move LPCR sanitising to sanitise_hv_regs
        https://git.kernel.org/powerpc/c/a19b70abc69aea8ea5974c57e1c3457d9df6aff2
[03/12] KVM: PPC: Book3S HV: Add a function to filter guest LPCR bits
        https://git.kernel.org/powerpc/c/67145ef4960f55923b9e404c0b184944bfeded4d
[04/12] KVM: PPC: Book3S HV: Disallow LPCR[AIL] to be set to 1 or 2
        https://git.kernel.org/powerpc/c/bcc92a0d6d6eae1e7b34a88f58ae69c081d85f97
[05/12] KVM: PPC: Book3S HV: Prevent radix guests setting LPCR[TC]
        https://git.kernel.org/powerpc/c/72c15287210f7433f5fcb55452b05e4b6ccc6c15
[06/12] KVM: PPC: Book3S HV: Remove redundant mtspr PSPB
        https://git.kernel.org/powerpc/c/4b5f0a0d49e663adf1c7c6f2dd05cb18dd53db8c
[07/12] KVM: PPC: Book3S HV: remove unused kvmppc_h_protect argument
        https://git.kernel.org/powerpc/c/6c12c4376bbbc89fc84480096ba838e07ab7c405
[08/12] KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=n default hcalls
        https://git.kernel.org/powerpc/c/0fd85cb83fbd7048d8a024ba1338924349e26fd5
[09/12] powerpc/64s: Remove KVM handler support from CBE_RAS interrupts
        https://git.kernel.org/powerpc/c/5eee8371828a92a2620453907d6b2b6dc819ab3a
[10/12] powerpc/64s: remove KVM SKIP test from instruction breakpoint handler
        https://git.kernel.org/powerpc/c/da487a5d1bee6a30798a8db15986d3d028c8ac92
[11/12] KVM: PPC: Book3S HV: Ensure MSR[ME] is always set in guest MSR
        https://git.kernel.org/powerpc/c/946cf44ac6ce61378ea02386d39394a06d502f28
[12/12] KVM: PPC: Book3S HV: Ensure MSR[HV] is always clear in guest MSR
        https://git.kernel.org/powerpc/c/732f21a3053cf279eb6b85d19b7818a8f1dd2071

cheers
