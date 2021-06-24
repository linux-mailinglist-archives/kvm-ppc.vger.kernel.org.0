Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49A63B30D4
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Jun 2021 16:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhFXOEk (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Jun 2021 10:04:40 -0400
Received: from ozlabs.org ([203.11.71.1]:57157 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232055AbhFXOEZ (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Thu, 24 Jun 2021 10:04:25 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4G9hdn486hz9sXJ; Fri, 25 Jun 2021 00:02:05 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Fabiano Rosas <farosas@linux.ibm.com>
In-Reply-To: <20210526125851.3436735-1-npiggin@gmail.com>
References: <20210526125851.3436735-1-npiggin@gmail.com>
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path
Message-Id: <162454330041.2930301.11877612798226022181.b4-ty@ellerman.id.au>
Date:   Fri, 25 Jun 2021 00:01:40 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Wed, 26 May 2021 22:58:51 +1000, Nicholas Piggin wrote:
> Similar to commit 25edcc50d76c ("KVM: PPC: Book3S HV: Save and restore
> FSCR in the P9 path"), ensure the P7/8 path saves and restores the host
> FSCR. The logic explained in that patch actually applies there to the
> old path well: a context switch can be made before kvmppc_vcpu_run_hv
> restores the host FSCR and returns.
> 
> Now both the p9 and the p7/8 paths now save and restore their FSCR, it
> no longer needs to be restored at the end of kvmppc_vcpu_run_hv

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path
      https://git.kernel.org/powerpc/c/6ba53317d497dec029bfb040b1daf38328fa00ab

cheers
