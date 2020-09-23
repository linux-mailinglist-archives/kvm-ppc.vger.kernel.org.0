Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774D2274DAA
	for <lists+kvm-ppc@lfdr.de>; Wed, 23 Sep 2020 02:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgIWAL1 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Sep 2020 20:11:27 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54199 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgIWAL1 (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 22 Sep 2020 20:11:27 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Bwz9m4kHZz9sTh; Wed, 23 Sep 2020 10:11:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1600819884; bh=qxuvilfoTnyNq+tBA0iFeUPCv77I+0VTd8cXq4bIGDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NWfNdS/JTWDcyBku0m3+xPTR5aINhEBrBGiXkZYxihUsfRyEAx8YYXQfSIbuYukYJ
         oUAvy5xWbDlrXOR7+jkKHKKUAPMXVxjmahCCpSd7nrM8GeMCBldurDO67GdaJeAhof
         Q8U2KQAgohzYIPGQ9tDpKD10mineXmYVJ7cfwYIhE0rgruCv3GBZaaiYJdQ+IASBYy
         1BXRkbz/08ecQaEC2NfTKnEVtX80f+wWddpwSF4AV6VNMhlokatZ1obdr/LQfzOuLa
         WfpmD5ZzB2NrdZgCzmiK0R7dH5XcqJInPe7JTaft7Xo42VRE5tB+UjR8rKWgqDSdwK
         ym2fRbUP7tUTw==
Date:   Wed, 23 Sep 2020 10:08:00 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Wang Wensheng <wangwensheng4@huawei.com>
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] powerpc/kvm/books: Fix symbol undeclared warnings
Message-ID: <20200923000800.GB531519@thinks.paulus.ozlabs.org>
References: <20200921112211.82830-1-wangwensheng4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921112211.82830-1-wangwensheng4@huawei.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Sep 21, 2020 at 11:22:11AM +0000, Wang Wensheng wrote:
> Build the kernel with `C=2`:
> arch/powerpc/kvm/book3s_hv_nested.c:572:25: warning: symbol
> 'kvmhv_alloc_nested' was not declared. Should it be static?
> arch/powerpc/kvm/book3s_64_mmu_radix.c:350:6: warning: symbol
> 'kvmppc_radix_set_pte_at' was not declared. Should it be static?
> arch/powerpc/kvm/book3s_hv.c:3568:5: warning: symbol
> 'kvmhv_p9_guest_entry' was not declared. Should it be static?
> arch/powerpc/kvm/book3s_hv_rm_xics.c:767:15: warning: symbol 'eoi_rc'
> was not declared. Should it be static?
> arch/powerpc/kvm/book3s_64_vio_hv.c:240:13: warning: symbol
> 'iommu_tce_kill_rm' was not declared. Should it be static?
> arch/powerpc/kvm/book3s_64_vio.c:492:6: warning: symbol
> 'kvmppc_tce_iommu_do_map' was not declared. Should it be static?
> arch/powerpc/kvm/book3s_pr.c:572:6: warning: symbol 'kvmppc_set_pvr_pr'
> was not declared. Should it be static?
> 
> Those symbols are used only in the files that define them so make them
> static to fix the warnings.
> 
> Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>

Thanks, applied.

Paul.
