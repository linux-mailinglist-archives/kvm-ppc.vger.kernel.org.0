Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35744A4D62
	for <lists+kvm-ppc@lfdr.de>; Mon,  2 Sep 2019 05:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbfIBDGR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 1 Sep 2019 23:06:17 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57649 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbfIBDGR (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 1 Sep 2019 23:06:17 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46MFN66pq4z9sNf; Mon,  2 Sep 2019 13:06:14 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 4f916593be9da38c5cf0d3a5c386b57beb70f422
In-Reply-To: <20190826045520.92153-1-aik@ozlabs.ru>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Jose Ricardo Ziviani <joserz@linux.ibm.com>,
        kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH kernel] KVM: PPC: Fix incorrect guest-to-user-translation error handling
Message-Id: <46MFN66pq4z9sNf@ozlabs.org>
Date:   Mon,  2 Sep 2019 13:06:14 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 2019-08-26 at 04:55:20 UTC, Alexey Kardashevskiy wrote:
> H_PUT_TCE_INDIRECT handlers receive a page with up to 512 TCEs from
> a guest. Although we verify correctness of TCEs before we do anything
> with the existing tables, there is a small window when a check in
> kvmppc_tce_validate might pass and right after that the guest alters
> the page with TCEs which can cause early exit from the handler and
> leave srcu_read_lock(&vcpu->kvm->srcu) (virtual mode) or lock_rmap(rmap)
> (real mode) locked.
> 
> This fixes the bug by jumping to the common exit code with an appropriate
> unlock.
> 
> Fixes: 121f80ba68f1 ("KVM: PPC: VFIO: Add in-kernel acceleration for VFIO")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>

Applied to powerpc topic/ppc-kvm, thanks.

https://git.kernel.org/powerpc/c/4f916593be9da38c5cf0d3a5c386b57beb70f422

cheers
