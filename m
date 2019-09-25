Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27698BDCA6
	for <lists+kvm-ppc@lfdr.de>; Wed, 25 Sep 2019 13:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbfIYLFX (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 25 Sep 2019 07:05:23 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54697 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404108AbfIYLFW (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Wed, 25 Sep 2019 07:05:22 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46dZwJ4fsTz9sPc; Wed, 25 Sep 2019 21:05:20 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 3a83f677a6eeff65751b29e3648d7c69c3be83f3
In-Reply-To: <20190911223155.16045-1-mdroth@linux.vnet.ibm.com>
To:     Michael Roth <mdroth@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: use smp_mb() when setting/clearing host_ipi flag
Message-Id: <46dZwJ4fsTz9sPc@ozlabs.org>
Date:   Wed, 25 Sep 2019 21:05:20 +1000 (AEST)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 2019-09-11 at 22:31:55 UTC, Michael Roth wrote:
> On a 2-socket Power9 system with 32 cores/128 threads (SMT4) and 1TB
> of memory running the following guest configs:
...
> To handle both cases, this patch splits kvmppc_set_host_ipi() into
> separate set/clear functions, where we execute smp_mb() prior to
> setting host_ipi flag, and after clearing host_ipi flag. These
> functions pair with each other to synchronize the sender and receiver
> sides.
> 
> With that change in place the above workload ran for 20 hours without
> triggering any lock-ups.
> 
> Fixes: 755563bc79c7 ("powerpc/powernv: Fixes for hypervisor doorbell handling") # v4.0
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: kvm-ppc@vger.kernel.org
> Signed-off-by: Michael Roth <mdroth@linux.vnet.ibm.com>

Applied to powerpc fixes, thanks.

https://git.kernel.org/powerpc/c/3a83f677a6eeff65751b29e3648d7c69c3be83f3

cheers
